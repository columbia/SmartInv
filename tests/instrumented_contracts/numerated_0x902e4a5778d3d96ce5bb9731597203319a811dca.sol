1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The tree and the proofs can be generated using our
12  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
13  * You will find a quickstart guide in the readme.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  * OpenZeppelin's JavaScript library generates merkle trees that are safe
20  * against this attack out of the box.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Calldata version of {verify}
35      *
36      * _Available since v4.7._
37      */
38     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
39         return processProofCalldata(proof, leaf) == root;
40     }
41 
42     /**
43      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
44      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
45      * hash matches the root of the tree. When processing the proof, the pairs
46      * of leafs & pre-images are assumed to be sorted.
47      *
48      * _Available since v4.4._
49      */
50     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
51         bytes32 computedHash = leaf;
52         for (uint256 i = 0; i < proof.length; i++) {
53             computedHash = _hashPair(computedHash, proof[i]);
54         }
55         return computedHash;
56     }
57 
58     /**
59      * @dev Calldata version of {processProof}
60      *
61      * _Available since v4.7._
62      */
63     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             computedHash = _hashPair(computedHash, proof[i]);
67         }
68         return computedHash;
69     }
70 
71     /**
72      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
73      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
74      *
75      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
76      *
77      * _Available since v4.7._
78      */
79     function multiProofVerify(
80         bytes32[] memory proof,
81         bool[] memory proofFlags,
82         bytes32 root,
83         bytes32[] memory leaves
84     ) internal pure returns (bool) {
85         return processMultiProof(proof, proofFlags, leaves) == root;
86     }
87 
88     /**
89      * @dev Calldata version of {multiProofVerify}
90      *
91      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
92      *
93      * _Available since v4.7._
94      */
95     function multiProofVerifyCalldata(
96         bytes32[] calldata proof,
97         bool[] calldata proofFlags,
98         bytes32 root,
99         bytes32[] memory leaves
100     ) internal pure returns (bool) {
101         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
102     }
103 
104     /**
105      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
106      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
107      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
108      * respectively.
109      *
110      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
111      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
112      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
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
140         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i]
145                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
146                 : proof[proofPos++];
147             hashes[i] = _hashPair(a, b);
148         }
149 
150         if (totalHashes > 0) {
151             unchecked {
152                 return hashes[totalHashes - 1];
153             }
154         } else if (leavesLen > 0) {
155             return leaves[0];
156         } else {
157             return proof[0];
158         }
159     }
160 
161     /**
162      * @dev Calldata version of {processMultiProof}.
163      *
164      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
165      *
166      * _Available since v4.7._
167      */
168     function processMultiProofCalldata(
169         bytes32[] calldata proof,
170         bool[] calldata proofFlags,
171         bytes32[] memory leaves
172     ) internal pure returns (bytes32 merkleRoot) {
173         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
174         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
175         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
176         // the merkle tree.
177         uint256 leavesLen = leaves.length;
178         uint256 totalHashes = proofFlags.length;
179 
180         // Check proof validity.
181         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
182 
183         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
184         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
185         bytes32[] memory hashes = new bytes32[](totalHashes);
186         uint256 leafPos = 0;
187         uint256 hashPos = 0;
188         uint256 proofPos = 0;
189         // At each step, we compute the next hash using two values:
190         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
191         //   get the next hash.
192         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
193         //   `proof` array.
194         for (uint256 i = 0; i < totalHashes; i++) {
195             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
196             bytes32 b = proofFlags[i]
197                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
198                 : proof[proofPos++];
199             hashes[i] = _hashPair(a, b);
200         }
201 
202         if (totalHashes > 0) {
203             unchecked {
204                 return hashes[totalHashes - 1];
205             }
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
214         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
215     }
216 
217     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
218         /// @solidity memory-safe-assembly
219         assembly {
220             mstore(0x00, a)
221             mstore(0x20, b)
222             value := keccak256(0x00, 0x40)
223         }
224     }
225 }
226 
227 // File: contracts/IERC721A.sol
228 
229 
230 // ERC721A Contracts v4.1.0
231 // Creator: Chiru Labs
232 
233 pragma solidity ^0.8.4;
234 
235 /**
236  * @dev Interface of an ERC721A compliant contract.
237  */
238 
239 
240 interface IERC721A {
241     /**
242      * The caller must own the token or be an approved operator.
243      */
244     error ApprovalCallerNotOwnerNorApproved();
245 
246     /**
247      * The token does not exist.
248      */
249     error ApprovalQueryForNonexistentToken();
250 
251     /**
252      * The caller cannot approve to their own address.
253      */
254     error ApproveToCaller();
255 
256     /**
257      * Cannot query the balance for the zero address.
258      */
259     error BalanceQueryForZeroAddress();
260 
261     /**
262      * Cannot mint to the zero address.
263      */
264     error MintToZeroAddress();
265 
266     /**
267      * The quantity of tokens minted must be more than zero.
268      */
269     error MintZeroQuantity();
270 
271     /**
272      * The token does not exist.
273      */
274     error OwnerQueryForNonexistentToken();
275 
276     /**
277      * The caller must own the token or be an approved operator.
278      */
279     error TransferCallerNotOwnerNorApproved();
280 
281     /**
282      * The token must be owned by `from`.
283      */
284     error TransferFromIncorrectOwner();
285 
286     /**
287      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
288      */
289     error TransferToNonERC721ReceiverImplementer();
290 
291     /**
292      * Cannot transfer to the zero address.
293      */
294     error TransferToZeroAddress();
295 
296     /**
297      * The token does not exist.
298      */
299     error URIQueryForNonexistentToken();
300 
301     /**
302      * The `quantity` minted with ERC2309 exceeds the safety limit.
303      */
304     error MintERC2309QuantityExceedsLimit();
305 
306     /**
307      * The `extraData` cannot be set on an unintialized ownership slot.
308      */
309     error OwnershipNotInitializedForExtraData();
310 
311     struct TokenOwnership {
312         // The address of the owner.
313         address addr;
314         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
315         uint64 startTimestamp;
316         // Whether the token has been burned.
317         bool burned;
318         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
319         uint24 extraData;
320     }
321 
322     /**
323      * @dev Returns the total amount of tokens stored by the contract.
324      *
325      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
326      */
327     function totalSupply() external view returns (uint256);
328 
329     // ==============================
330     //            IERC165
331     // ==============================
332 
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 
343     // ==============================
344     //            IERC721
345     // ==============================
346 
347     /**
348      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
354      */
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
359      */
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     /**
363      * @dev Returns the number of tokens in ``owner``'s account.
364      */
365     function balanceOf(address owner) external view returns (uint256 balance);
366 
367     /**
368      * @dev Returns the owner of the `tokenId` token.
369      *
370      * Requirements:
371      *
372      * - `tokenId` must exist.
373      */
374     function ownerOf(uint256 tokenId) external view returns (address owner);
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`.
378      *
379      * Requirements:
380      *
381      * - `from` cannot be the zero address.
382      * - `to` cannot be the zero address.
383      * - `tokenId` token must exist and be owned by `from`.
384      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
385      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
386      *
387      * Emits a {Transfer} event.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId,
393         bytes calldata data
394     ) external;
395 
396     /**
397      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
398      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `tokenId` token must exist and be owned by `from`.
405      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
407      *
408      * Emits a {Transfer} event.
409      */
410     function safeTransferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Transfers `tokenId` token from `from` to `to`.
418      *
419      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must be owned by `from`.
426      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
427      *
428      * Emits a {Transfer} event.
429      */
430     function transferFrom(
431         address from,
432         address to,
433         uint256 tokenId
434     ) external;
435 
436     /**
437      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
438      * The approval is cleared when the token is transferred.
439      *
440      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
441      *
442      * Requirements:
443      *
444      * - The caller must own the token or be an approved operator.
445      * - `tokenId` must exist.
446      *
447      * Emits an {Approval} event.
448      */
449     function approve(address to, uint256 tokenId) external;
450 
451     /**
452      * @dev Approve or remove `operator` as an operator for the caller.
453      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
454      *
455      * Requirements:
456      *
457      * - The `operator` cannot be the caller.
458      *
459      * Emits an {ApprovalForAll} event.
460      */
461     function setApprovalForAll(address operator, bool _approved) external;
462 
463     /**
464      * @dev Returns the account approved for `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function getApproved(uint256 tokenId) external view returns (address operator);
471 
472     /**
473      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
474      *
475      * See {setApprovalForAll}
476      */
477     function isApprovedForAll(address owner, address operator) external view returns (bool);
478 
479     // ==============================
480     //        IERC721Metadata
481     // ==============================
482 
483     /**
484      * @dev Returns the token collection name.
485      */
486     function name() external view returns (string memory);
487 
488     /**
489      * @dev Returns the token collection symbol.
490      */
491     function symbol() external view returns (string memory);
492 
493     /**
494      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
495      */
496     function tokenURI(uint256 tokenId) external view returns (string memory);
497 
498     // ==============================
499     //            IERC2309
500     // ==============================
501 
502     /**
503      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
504      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
505      */
506     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
507 }
508 // File: contracts/ERC721A_royalty.sol
509 
510 
511 // ERC721A Contracts v4.1.0
512 // Creator: Chiru Labs
513 
514 pragma solidity ^0.8.4;
515 
516 
517 /**
518  * @dev ERC721 token receiver interface.
519  */
520 interface ERC721A__IERC721Receiver {
521     function onERC721Received(
522         address operator,
523         address from,
524         uint256 tokenId,
525         bytes calldata data
526     ) external returns (bytes4);
527 }
528 
529 /**
530  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
531  * including the Metadata extension. Built to optimize for lower gas during batch mints.
532  *
533  * Assumes serials are sequentially minted starting at `_startTokenId()`
534  * (defaults to 0, e.g. 0, 1, 2, 3..).
535  *
536  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
537  *
538  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
539  */
540 contract ERC721A is IERC721A {
541     // Mask of an entry in packed address data.
542     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
543 
544     // The bit position of `numberMinted` in packed address data.
545     uint256 private constant BITPOS_NUMBER_MINTED = 64;
546 
547     // The bit position of `numberBurned` in packed address data.
548     uint256 private constant BITPOS_NUMBER_BURNED = 128;
549 
550     // The bit position of `aux` in packed address data.
551     uint256 private constant BITPOS_AUX = 192;
552 
553     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
554     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
555 
556     // The bit position of `startTimestamp` in packed ownership.
557     uint256 private constant BITPOS_START_TIMESTAMP = 160;
558 
559     // The bit mask of the `burned` bit in packed ownership.
560     uint256 private constant BITMASK_BURNED = 1 << 224;
561 
562     // The bit position of the `nextInitialized` bit in packed ownership.
563     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
564 
565     // The bit mask of the `nextInitialized` bit in packed ownership.
566     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
567 
568     // The bit position of `extraData` in packed ownership.
569     uint256 private constant BITPOS_EXTRA_DATA = 232;
570 
571     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
572     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
573 
574     // The mask of the lower 160 bits for addresses.
575     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
576 
577     // The maximum `quantity` that can be minted with `_mintERC2309`.
578     // This limit is to prevent overflows on the address data entries.
579     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
580     // is required to cause an overflow, which is unrealistic.
581     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
582 
583     // The tokenId of the next token to be minted.
584     uint256 private _currentIndex;
585 
586     // The number of tokens burned.
587     uint256 private _burnCounter;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to ownership details
596     // An empty struct value does not necessarily mean the token is unowned.
597     // See `_packedOwnershipOf` implementation for details.
598     //
599     // Bits Layout:
600     // - [0..159]   `addr`
601     // - [160..223] `startTimestamp`
602     // - [224]      `burned`
603     // - [225]      `nextInitialized`
604     // - [232..255] `extraData`
605     mapping(uint256 => uint256) private _packedOwnerships;
606 
607     // Mapping owner address to address data.
608     //
609     // Bits Layout:
610     // - [0..63]    `balance`
611     // - [64..127]  `numberMinted`
612     // - [128..191] `numberBurned`
613     // - [192..255] `aux`
614     mapping(address => uint256) private _packedAddressData;
615 
616     // Mapping from token ID to approved address.
617     mapping(uint256 => address) private _tokenApprovals;
618 
619     // Mapping from owner to operator approvals
620     mapping(address => mapping(address => bool)) private _operatorApprovals;
621 
622     constructor(string memory name_, string memory symbol_) {
623         _name = name_;
624         _symbol = symbol_;
625         _currentIndex = _startTokenId();
626     }
627 
628     /**
629      * @dev Returns the starting token ID.
630      * To change the starting token ID, please override this function.
631      */
632     function _startTokenId() internal view virtual returns (uint256) {
633         return 1;
634     }
635 
636     /**
637      * @dev Returns the next token ID to be minted.
638      */
639     function _nextTokenId() internal view returns (uint256) {
640         return _currentIndex;
641     }
642 
643     /**
644      * @dev Returns the total number of tokens in existence.
645      * Burned tokens will reduce the count.
646      * To get the total number of tokens minted, please see `_totalMinted`.
647      */
648     function totalSupply() public view override returns (uint256) {
649         // Counter underflow is impossible as _burnCounter cannot be incremented
650         // more than `_currentIndex - _startTokenId()` times.
651         unchecked {
652             return _currentIndex - _burnCounter - _startTokenId();
653         }
654     }
655 
656     /**
657      * @dev Returns the total amount of tokens minted in the contract.
658      */
659     function _totalMinted() internal view returns (uint256) {
660         // Counter underflow is impossible as _currentIndex does not decrement,
661         // and it is initialized to `_startTokenId()`
662         unchecked {
663             return _currentIndex - _startTokenId();
664         }
665     }
666 
667     /**
668      * @dev Returns the total number of tokens burned.
669      */
670     function _totalBurned() internal view returns (uint256) {
671         return _burnCounter;
672     }
673 
674     /**
675      * @dev See {IERC165-supportsInterface}.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678         // The interface IDs are constants representing the first 4 bytes of the XOR of
679         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
680         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
681         return
682             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
683             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
684             interfaceId == 0x2a55205a || // ERC 2981 rotyalty
685             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view override returns (uint256) {
692         if (owner == address(0)) revert BalanceQueryForZeroAddress();
693         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
694     }
695 
696     /**
697      * Returns the number of tokens minted by `owner`.
698      */
699     function _numberMinted(address owner) internal view returns (uint256) {
700         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
701     }
702 
703     /**
704      * Returns the number of tokens burned by or on behalf of `owner`.
705      */
706     function _numberBurned(address owner) internal view returns (uint256) {
707         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
708     }
709 
710     /**
711      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
712      */
713     function _getAux(address owner) internal view returns (uint64) {
714         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
715     }
716 
717     /**
718      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
719      * If there are multiple variables, please pack them into a uint64.
720      */
721     function _setAux(address owner, uint64 aux) internal {
722         uint256 packed = _packedAddressData[owner];
723         uint256 auxCasted;
724         // Cast `aux` with assembly to avoid redundant masking.
725         assembly {
726             auxCasted := aux
727         }
728         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
729         _packedAddressData[owner] = packed;
730     }
731 
732     /**
733      * Returns the packed ownership data of `tokenId`.
734      */
735     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
736         uint256 curr = tokenId;
737 
738         unchecked {
739             if (_startTokenId() <= curr)
740                 if (curr < _currentIndex) {
741                     uint256 packed = _packedOwnerships[curr];
742                     // If not burned.
743                     if (packed & BITMASK_BURNED == 0) {
744                         // Invariant:
745                         // There will always be an ownership that has an address and is not burned
746                         // before an ownership that does not have an address and is not burned.
747                         // Hence, curr will not underflow.
748                         //
749                         // We can directly compare the packed value.
750                         // If the address is zero, packed is zero.
751                         while (packed == 0) {
752                             packed = _packedOwnerships[--curr];
753                         }
754                         return packed;
755                     }
756                 }
757         }
758         revert OwnerQueryForNonexistentToken();
759     }
760 
761     /**
762      * Returns the unpacked `TokenOwnership` struct from `packed`.
763      */
764     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
765         ownership.addr = address(uint160(packed));
766         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
767         ownership.burned = packed & BITMASK_BURNED != 0;
768         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
769     }
770 
771     /**
772      * Returns the unpacked `TokenOwnership` struct at `index`.
773      */
774     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
775         return _unpackedOwnership(_packedOwnerships[index]);
776     }
777 
778     /**
779      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
780      */
781     function _initializeOwnershipAt(uint256 index) internal {
782         if (_packedOwnerships[index] == 0) {
783             _packedOwnerships[index] = _packedOwnershipOf(index);
784         }
785     }
786 
787     /**
788      * Gas spent here starts off proportional to the maximum mint batch size.
789      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
790      */
791     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
792         return _unpackedOwnership(_packedOwnershipOf(tokenId));
793     }
794 
795     /**
796      * @dev Packs ownership data into a single uint256.
797      */
798     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, BITMASK_ADDRESS)
802             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
803             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
804         }
805     }
806 
807     /**
808      * @dev See {IERC721-ownerOf}.
809      */
810     function ownerOf(uint256 tokenId) public view override returns (address) {
811         return address(uint160(_packedOwnershipOf(tokenId)));
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-name}.
816      */
817     function name() public view virtual override returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-symbol}.
823      */
824     function symbol() public view virtual override returns (string memory) {
825         return _symbol;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-tokenURI}.
830      */
831     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
832         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
833 
834         string memory baseURI = _baseURI();
835         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, it can be overridden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return '';
845     }
846 
847     /**
848      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
849      */
850     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
851         // For branchless setting of the `nextInitialized` flag.
852         assembly {
853             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
854             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
855         }
856     }
857 
858     /**
859      * @dev See {IERC721-approve}.
860      */
861     function approve(address to, uint256 tokenId) public virtual override {
862         address owner = ownerOf(tokenId);
863         if (_msgSenderERC721A() != owner)
864             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
865                 revert ApprovalCallerNotOwnerNorApproved();
866             }
867 
868         _tokenApprovals[tokenId] = to;
869         emit Approval(owner, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-getApproved}.
874      */
875     function getApproved(uint256 tokenId) public view override returns (address) {
876         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
877 
878         return _tokenApprovals[tokenId];
879     }
880 
881     /**
882      * @dev See {IERC721-setApprovalForAll}.
883      */
884     function setApprovalForAll(address operator, bool approved) public virtual override {
885         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
886         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
887         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
888     }
889     
890 
891     /**
892      * @dev See {IERC721-isApprovedForAll}.
893      */
894     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
895         return _operatorApprovals[owner][operator];
896     }
897 
898     /**
899      * @dev See {IERC721-safeTransferFrom}.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev See {IERC721-safeTransferFrom}.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) public virtual override {
918         transferFrom(from, to, tokenId);
919         if (to.code.length != 0)
920             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
921                 revert TransferToNonERC721ReceiverImplementer();
922             }
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      */
932     function _exists(uint256 tokenId) internal view returns (bool) {
933         return
934             _startTokenId() <= tokenId &&
935             tokenId < _currentIndex && // If within bounds,
936             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
937     }
938 
939     /**
940      * @dev Equivalent to `_safeMint(to, quantity, '')`.
941      */
942     function _safeMint(address to, uint256 quantity) internal {
943         _safeMint(to, quantity, '');
944     }
945 
946     /**
947      * @dev Safely mints `quantity` tokens and transfers them to `to`.
948      *
949      * Requirements:
950      *
951      * - If `to` refers to a smart contract, it must implement
952      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
953      * - `quantity` must be greater than 0.
954      *
955      * See {_mint}.
956      *
957      * Emits a {Transfer} event for each mint.
958      */
959     function _safeMint(
960         address to,
961         uint256 quantity,
962         bytes memory _data
963     ) internal {
964         _mint(to, quantity);
965 
966         unchecked {
967             if (to.code.length != 0) {
968                 uint256 end = _currentIndex;
969                 uint256 index = end - quantity;
970                 do {
971                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
972                         revert TransferToNonERC721ReceiverImplementer();
973                     }
974                 } while (index < end);
975                 // Reentrancy protection.
976                 if (_currentIndex != end) revert();
977             }
978         }
979     }
980 
981     /**
982      * @dev Mints `quantity` tokens and transfers them to `to`.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - `quantity` must be greater than 0.
988      *
989      * Emits a {Transfer} event for each mint.
990      */
991     function _mint(address to, uint256 quantity) internal {
992         uint256 startTokenId = _currentIndex;
993         if (to == address(0)) revert MintToZeroAddress();
994         if (quantity == 0) revert MintZeroQuantity();
995 
996         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
997 
998         // Overflows are incredibly unrealistic.
999         // `balance` and `numberMinted` have a maximum limit of 2**64.
1000         // `tokenId` has a maximum limit of 2**256.
1001         unchecked {
1002             // Updates:
1003             // - `balance += quantity`.
1004             // - `numberMinted += quantity`.
1005             //
1006             // We can directly add to the `balance` and `numberMinted`.
1007             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1008 
1009             // Updates:
1010             // - `address` to the owner.
1011             // - `startTimestamp` to the timestamp of minting.
1012             // - `burned` to `false`.
1013             // - `nextInitialized` to `quantity == 1`.
1014             _packedOwnerships[startTokenId] = _packOwnershipData(
1015                 to,
1016                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1017             );
1018 
1019             uint256 tokenId = startTokenId;
1020             uint256 end = startTokenId + quantity;
1021             do {
1022                 emit Transfer(address(0), to, tokenId++);
1023             } while (tokenId < end);
1024 
1025             _currentIndex = end;
1026         }
1027         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1028     }
1029 
1030     /**
1031      * @dev Mints `quantity` tokens and transfers them to `to`.
1032      *
1033      * This function is intended for efficient minting only during contract creation.
1034      *
1035      * It emits only one {ConsecutiveTransfer} as defined in
1036      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1037      * instead of a sequence of {Transfer} event(s).
1038      *
1039      * Calling this function outside of contract creation WILL make your contract
1040      * non-compliant with the ERC721 standard.
1041      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1042      * {ConsecutiveTransfer} event is only permissible during contract creation.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `quantity` must be greater than 0.
1048      *
1049      * Emits a {ConsecutiveTransfer} event.
1050      */
1051     function _mintERC2309(address to, uint256 quantity) internal {
1052         uint256 startTokenId = _currentIndex;
1053         if (to == address(0)) revert MintToZeroAddress();
1054         if (quantity == 0) revert MintZeroQuantity();
1055         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1056 
1057         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1058 
1059         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1060         unchecked {
1061             // Updates:
1062             // - `balance += quantity`.
1063             // - `numberMinted += quantity`.
1064             //
1065             // We can directly add to the `balance` and `numberMinted`.
1066             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1067 
1068             // Updates:
1069             // - `address` to the owner.
1070             // - `startTimestamp` to the timestamp of minting.
1071             // - `burned` to `false`.
1072             // - `nextInitialized` to `quantity == 1`.
1073             _packedOwnerships[startTokenId] = _packOwnershipData(
1074                 to,
1075                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1076             );
1077 
1078             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1079 
1080             _currentIndex = startTokenId + quantity;
1081         }
1082         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1083     }
1084 
1085     /**
1086      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1087      */
1088     function _getApprovedAddress(uint256 tokenId)
1089         private
1090         view
1091         returns (uint256 approvedAddressSlot, address approvedAddress)
1092     {
1093         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1094         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1095         assembly {
1096             // Compute the slot.
1097             mstore(0x00, tokenId)
1098             mstore(0x20, tokenApprovalsPtr.slot)
1099             approvedAddressSlot := keccak256(0x00, 0x40)
1100             // Load the slot's value from storage.
1101             approvedAddress := sload(approvedAddressSlot)
1102         }
1103     }
1104 
1105     /**
1106      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1107      */
1108     function _isOwnerOrApproved(
1109         address approvedAddress,
1110         address from,
1111         address msgSender
1112     ) private pure returns (bool result) {
1113         assembly {
1114             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1115             from := and(from, BITMASK_ADDRESS)
1116             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1117             msgSender := and(msgSender, BITMASK_ADDRESS)
1118             // `msgSender == from || msgSender == approvedAddress`.
1119             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1120         }
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function transferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) public virtual override {
1138         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1139 
1140         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1141 
1142         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1143 
1144         // The nested ifs save around 20+ gas over a compound boolean condition.
1145         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1146             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1147 
1148         if (to == address(0)) revert TransferToZeroAddress();
1149 
1150         _beforeTokenTransfers(from, to, tokenId, 1);
1151 
1152         // Clear approvals from the previous owner.
1153         assembly {
1154             if approvedAddress {
1155                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1156                 sstore(approvedAddressSlot, 0)
1157             }
1158         }
1159 
1160         // Underflow of the sender's balance is impossible because we check for
1161         // ownership above and the recipient's balance can't realistically overflow.
1162         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1163         unchecked {
1164             // We can directly increment and decrement the balances.
1165             --_packedAddressData[from]; // Updates: `balance -= 1`.
1166             ++_packedAddressData[to]; // Updates: `balance += 1`.
1167 
1168             // Updates:
1169             // - `address` to the next owner.
1170             // - `startTimestamp` to the timestamp of transfering.
1171             // - `burned` to `false`.
1172             // - `nextInitialized` to `true`.
1173             _packedOwnerships[tokenId] = _packOwnershipData(
1174                 to,
1175                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1176             );
1177 
1178             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1179             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1180                 uint256 nextTokenId = tokenId + 1;
1181                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1182                 if (_packedOwnerships[nextTokenId] == 0) {
1183                     // If the next slot is within bounds.
1184                     if (nextTokenId != _currentIndex) {
1185                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1186                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1187                     }
1188                 }
1189             }
1190         }
1191 
1192         emit Transfer(from, to, tokenId);
1193         _afterTokenTransfers(from, to, tokenId, 1);
1194     }
1195 
1196     /**
1197      * @dev Equivalent to `_burn(tokenId, false)`.
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1215 
1216         address from = address(uint160(prevOwnershipPacked));
1217 
1218         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1219 
1220         if (approvalCheck) {
1221             // The nested ifs save around 20+ gas over a compound boolean condition.
1222             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1223                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner.
1229         assembly {
1230             if approvedAddress {
1231                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1232                 sstore(approvedAddressSlot, 0)
1233             }
1234         }
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1239         unchecked {
1240             // Updates:
1241             // - `balance -= 1`.
1242             // - `numberBurned += 1`.
1243             //
1244             // We can directly decrement the balance, and increment the number burned.
1245             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1246             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1247 
1248             // Updates:
1249             // - `address` to the last owner.
1250             // - `startTimestamp` to the timestamp of burning.
1251             // - `burned` to `true`.
1252             // - `nextInitialized` to `true`.
1253             _packedOwnerships[tokenId] = _packOwnershipData(
1254                 from,
1255                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1256             );
1257 
1258             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1259             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1260                 uint256 nextTokenId = tokenId + 1;
1261                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1262                 if (_packedOwnerships[nextTokenId] == 0) {
1263                     // If the next slot is within bounds.
1264                     if (nextTokenId != _currentIndex) {
1265                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1266                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1267                     }
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, address(0), tokenId);
1273         _afterTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1276         unchecked {
1277             _burnCounter++;
1278         }
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1283      *
1284      * @param from address representing the previous owner of the given token ID
1285      * @param to target address that will receive the tokens
1286      * @param tokenId uint256 ID of the token to be transferred
1287      * @param _data bytes optional data to send along with the call
1288      * @return bool whether the call correctly returned the expected magic value
1289      */
1290     function _checkContractOnERC721Received(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) private returns (bool) {
1296         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1297             bytes4 retval
1298         ) {
1299             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1300         } catch (bytes memory reason) {
1301             if (reason.length == 0) {
1302                 revert TransferToNonERC721ReceiverImplementer();
1303             } else {
1304                 assembly {
1305                     revert(add(32, reason), mload(reason))
1306                 }
1307             }
1308         }
1309     }
1310 
1311     /**
1312      * @dev Directly sets the extra data for the ownership data `index`.
1313      */
1314     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1315         uint256 packed = _packedOwnerships[index];
1316         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1317         uint256 extraDataCasted;
1318         // Cast `extraData` with assembly to avoid redundant masking.
1319         assembly {
1320             extraDataCasted := extraData
1321         }
1322         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1323         _packedOwnerships[index] = packed;
1324     }
1325 
1326     /**
1327      * @dev Returns the next extra data for the packed ownership data.
1328      * The returned result is shifted into position.
1329      */
1330     function _nextExtraData(
1331         address from,
1332         address to,
1333         uint256 prevOwnershipPacked
1334     ) private view returns (uint256) {
1335         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1336         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1337     }
1338 
1339     /**
1340      * @dev Called during each token transfer to set the 24bit `extraData` field.
1341      * Intended to be overridden by the cosumer contract.
1342      *
1343      * `previousExtraData` - the value of `extraData` before transfer.
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _extraData(
1354         address from,
1355         address to,
1356         uint24 previousExtraData
1357     ) internal view virtual returns (uint24) {}
1358 
1359     /**
1360      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1361      * This includes minting.
1362      * And also called before burning one token.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` will be minted for `to`.
1372      * - When `to` is zero, `tokenId` will be burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _beforeTokenTransfers(
1376         address from,
1377         address to,
1378         uint256 startTokenId,
1379         uint256 quantity
1380     ) internal virtual {}
1381 
1382     /**
1383      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1384      * This includes minting.
1385      * And also called after one token has been burned.
1386      *
1387      * startTokenId - the first token id to be transferred
1388      * quantity - the amount to be transferred
1389      *
1390      * Calling conditions:
1391      *
1392      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1393      * transferred to `to`.
1394      * - When `from` is zero, `tokenId` has been minted for `to`.
1395      * - When `to` is zero, `tokenId` has been burned by `from`.
1396      * - `from` and `to` are never both zero.
1397      */
1398     function _afterTokenTransfers(
1399         address from,
1400         address to,
1401         uint256 startTokenId,
1402         uint256 quantity
1403     ) internal virtual {}
1404 
1405     /**
1406      * @dev Returns the message sender (defaults to `msg.sender`).
1407      *
1408      * If you are writing GSN compatible contracts, you need to override this function.
1409      */
1410     function _msgSenderERC721A() internal view virtual returns (address) {
1411         return msg.sender;
1412     }
1413 
1414     /**
1415      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1416      */
1417     function _toString(uint256 value) internal pure returns (string memory ptr) {
1418         assembly {
1419             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1420             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1421             // We will need 1 32-byte word to store the length,
1422             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1423             ptr := add(mload(0x40), 128)
1424             // Update the free memory pointer to allocate.
1425             mstore(0x40, ptr)
1426 
1427             // Cache the end of the memory to calculate the length later.
1428             let end := ptr
1429 
1430             // We write the string from the rightmost digit to the leftmost digit.
1431             // The following is essentially a do-while loop that also handles the zero case.
1432             // Costs a bit more than early returning for the zero case,
1433             // but cheaper in terms of deployment and overall runtime costs.
1434             for {
1435                 // Initialize and perform the first pass without check.
1436                 let temp := value
1437                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1438                 ptr := sub(ptr, 1)
1439                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1440                 mstore8(ptr, add(48, mod(temp, 10)))
1441                 temp := div(temp, 10)
1442             } temp {
1443                 // Keep dividing `temp` until zero.
1444                 temp := div(temp, 10)
1445             } {
1446                 // Body of the for loop.
1447                 ptr := sub(ptr, 1)
1448                 mstore8(ptr, add(48, mod(temp, 10)))
1449             }
1450 
1451             let length := sub(end, ptr)
1452             // Move the pointer 32 bytes leftwards to make room for the length.
1453             ptr := sub(ptr, 32)
1454             // Store the length.
1455             mstore(ptr, length)
1456         }
1457     }
1458 }
1459 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
1460 
1461 
1462 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
1463 
1464 pragma solidity ^0.8.0;
1465 
1466 /**
1467  * @dev Standard signed math utilities missing in the Solidity language.
1468  */
1469 library SignedMath {
1470     /**
1471      * @dev Returns the largest of two signed numbers.
1472      */
1473     function max(int256 a, int256 b) internal pure returns (int256) {
1474         return a > b ? a : b;
1475     }
1476 
1477     /**
1478      * @dev Returns the smallest of two signed numbers.
1479      */
1480     function min(int256 a, int256 b) internal pure returns (int256) {
1481         return a < b ? a : b;
1482     }
1483 
1484     /**
1485      * @dev Returns the average of two signed numbers without overflow.
1486      * The result is rounded towards zero.
1487      */
1488     function average(int256 a, int256 b) internal pure returns (int256) {
1489         // Formula from the book "Hacker's Delight"
1490         int256 x = (a & b) + ((a ^ b) >> 1);
1491         return x + (int256(uint256(x) >> 255) & (a ^ b));
1492     }
1493 
1494     /**
1495      * @dev Returns the absolute unsigned value of a signed value.
1496      */
1497     function abs(int256 n) internal pure returns (uint256) {
1498         unchecked {
1499             // must be unchecked in order to support `n = type(int256).min`
1500             return uint256(n >= 0 ? n : -n);
1501         }
1502     }
1503 }
1504 
1505 // File: @openzeppelin/contracts/utils/math/Math.sol
1506 
1507 
1508 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
1509 
1510 pragma solidity ^0.8.0;
1511 
1512 /**
1513  * @dev Standard math utilities missing in the Solidity language.
1514  */
1515 library Math {
1516     enum Rounding {
1517         Down, // Toward negative infinity
1518         Up, // Toward infinity
1519         Zero // Toward zero
1520     }
1521 
1522     /**
1523      * @dev Returns the largest of two numbers.
1524      */
1525     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1526         return a > b ? a : b;
1527     }
1528 
1529     /**
1530      * @dev Returns the smallest of two numbers.
1531      */
1532     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1533         return a < b ? a : b;
1534     }
1535 
1536     /**
1537      * @dev Returns the average of two numbers. The result is rounded towards
1538      * zero.
1539      */
1540     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1541         // (a + b) / 2 can overflow.
1542         return (a & b) + (a ^ b) / 2;
1543     }
1544 
1545     /**
1546      * @dev Returns the ceiling of the division of two numbers.
1547      *
1548      * This differs from standard division with `/` in that it rounds up instead
1549      * of rounding down.
1550      */
1551     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1552         // (a + b - 1) / b can overflow on addition, so we distribute.
1553         return a == 0 ? 0 : (a - 1) / b + 1;
1554     }
1555 
1556     /**
1557      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1558      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1559      * with further edits by Uniswap Labs also under MIT license.
1560      */
1561     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
1562         unchecked {
1563             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1564             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1565             // variables such that product = prod1 * 2^256 + prod0.
1566             uint256 prod0; // Least significant 256 bits of the product
1567             uint256 prod1; // Most significant 256 bits of the product
1568             assembly {
1569                 let mm := mulmod(x, y, not(0))
1570                 prod0 := mul(x, y)
1571                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1572             }
1573 
1574             // Handle non-overflow cases, 256 by 256 division.
1575             if (prod1 == 0) {
1576                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
1577                 // The surrounding unchecked block does not change this fact.
1578                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
1579                 return prod0 / denominator;
1580             }
1581 
1582             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1583             require(denominator > prod1, "Math: mulDiv overflow");
1584 
1585             ///////////////////////////////////////////////
1586             // 512 by 256 division.
1587             ///////////////////////////////////////////////
1588 
1589             // Make division exact by subtracting the remainder from [prod1 prod0].
1590             uint256 remainder;
1591             assembly {
1592                 // Compute remainder using mulmod.
1593                 remainder := mulmod(x, y, denominator)
1594 
1595                 // Subtract 256 bit number from 512 bit number.
1596                 prod1 := sub(prod1, gt(remainder, prod0))
1597                 prod0 := sub(prod0, remainder)
1598             }
1599 
1600             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1601             // See https://cs.stackexchange.com/q/138556/92363.
1602 
1603             // Does not overflow because the denominator cannot be zero at this stage in the function.
1604             uint256 twos = denominator & (~denominator + 1);
1605             assembly {
1606                 // Divide denominator by twos.
1607                 denominator := div(denominator, twos)
1608 
1609                 // Divide [prod1 prod0] by twos.
1610                 prod0 := div(prod0, twos)
1611 
1612                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1613                 twos := add(div(sub(0, twos), twos), 1)
1614             }
1615 
1616             // Shift in bits from prod1 into prod0.
1617             prod0 |= prod1 * twos;
1618 
1619             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1620             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1621             // four bits. That is, denominator * inv = 1 mod 2^4.
1622             uint256 inverse = (3 * denominator) ^ 2;
1623 
1624             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1625             // in modular arithmetic, doubling the correct bits in each step.
1626             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1627             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1628             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1629             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1630             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1631             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1632 
1633             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1634             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1635             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1636             // is no longer required.
1637             result = prod0 * inverse;
1638             return result;
1639         }
1640     }
1641 
1642     /**
1643      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1644      */
1645     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
1646         uint256 result = mulDiv(x, y, denominator);
1647         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1648             result += 1;
1649         }
1650         return result;
1651     }
1652 
1653     /**
1654      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1655      *
1656      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1657      */
1658     function sqrt(uint256 a) internal pure returns (uint256) {
1659         if (a == 0) {
1660             return 0;
1661         }
1662 
1663         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1664         //
1665         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1666         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1667         //
1668         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1669         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1670         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1671         //
1672         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1673         uint256 result = 1 << (log2(a) >> 1);
1674 
1675         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1676         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1677         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1678         // into the expected uint128 result.
1679         unchecked {
1680             result = (result + a / result) >> 1;
1681             result = (result + a / result) >> 1;
1682             result = (result + a / result) >> 1;
1683             result = (result + a / result) >> 1;
1684             result = (result + a / result) >> 1;
1685             result = (result + a / result) >> 1;
1686             result = (result + a / result) >> 1;
1687             return min(result, a / result);
1688         }
1689     }
1690 
1691     /**
1692      * @notice Calculates sqrt(a), following the selected rounding direction.
1693      */
1694     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1695         unchecked {
1696             uint256 result = sqrt(a);
1697             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1698         }
1699     }
1700 
1701     /**
1702      * @dev Return the log in base 2, rounded down, of a positive value.
1703      * Returns 0 if given 0.
1704      */
1705     function log2(uint256 value) internal pure returns (uint256) {
1706         uint256 result = 0;
1707         unchecked {
1708             if (value >> 128 > 0) {
1709                 value >>= 128;
1710                 result += 128;
1711             }
1712             if (value >> 64 > 0) {
1713                 value >>= 64;
1714                 result += 64;
1715             }
1716             if (value >> 32 > 0) {
1717                 value >>= 32;
1718                 result += 32;
1719             }
1720             if (value >> 16 > 0) {
1721                 value >>= 16;
1722                 result += 16;
1723             }
1724             if (value >> 8 > 0) {
1725                 value >>= 8;
1726                 result += 8;
1727             }
1728             if (value >> 4 > 0) {
1729                 value >>= 4;
1730                 result += 4;
1731             }
1732             if (value >> 2 > 0) {
1733                 value >>= 2;
1734                 result += 2;
1735             }
1736             if (value >> 1 > 0) {
1737                 result += 1;
1738             }
1739         }
1740         return result;
1741     }
1742 
1743     /**
1744      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1745      * Returns 0 if given 0.
1746      */
1747     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1748         unchecked {
1749             uint256 result = log2(value);
1750             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1751         }
1752     }
1753 
1754     /**
1755      * @dev Return the log in base 10, rounded down, of a positive value.
1756      * Returns 0 if given 0.
1757      */
1758     function log10(uint256 value) internal pure returns (uint256) {
1759         uint256 result = 0;
1760         unchecked {
1761             if (value >= 10 ** 64) {
1762                 value /= 10 ** 64;
1763                 result += 64;
1764             }
1765             if (value >= 10 ** 32) {
1766                 value /= 10 ** 32;
1767                 result += 32;
1768             }
1769             if (value >= 10 ** 16) {
1770                 value /= 10 ** 16;
1771                 result += 16;
1772             }
1773             if (value >= 10 ** 8) {
1774                 value /= 10 ** 8;
1775                 result += 8;
1776             }
1777             if (value >= 10 ** 4) {
1778                 value /= 10 ** 4;
1779                 result += 4;
1780             }
1781             if (value >= 10 ** 2) {
1782                 value /= 10 ** 2;
1783                 result += 2;
1784             }
1785             if (value >= 10 ** 1) {
1786                 result += 1;
1787             }
1788         }
1789         return result;
1790     }
1791 
1792     /**
1793      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1794      * Returns 0 if given 0.
1795      */
1796     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1797         unchecked {
1798             uint256 result = log10(value);
1799             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
1800         }
1801     }
1802 
1803     /**
1804      * @dev Return the log in base 256, rounded down, of a positive value.
1805      * Returns 0 if given 0.
1806      *
1807      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1808      */
1809     function log256(uint256 value) internal pure returns (uint256) {
1810         uint256 result = 0;
1811         unchecked {
1812             if (value >> 128 > 0) {
1813                 value >>= 128;
1814                 result += 16;
1815             }
1816             if (value >> 64 > 0) {
1817                 value >>= 64;
1818                 result += 8;
1819             }
1820             if (value >> 32 > 0) {
1821                 value >>= 32;
1822                 result += 4;
1823             }
1824             if (value >> 16 > 0) {
1825                 value >>= 16;
1826                 result += 2;
1827             }
1828             if (value >> 8 > 0) {
1829                 result += 1;
1830             }
1831         }
1832         return result;
1833     }
1834 
1835     /**
1836      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1837      * Returns 0 if given 0.
1838      */
1839     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1840         unchecked {
1841             uint256 result = log256(value);
1842             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1843         }
1844     }
1845 }
1846 
1847 // File: @openzeppelin/contracts/utils/Strings.sol
1848 
1849 
1850 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1851 
1852 pragma solidity ^0.8.0;
1853 
1854 
1855 
1856 /**
1857  * @dev String operations.
1858  */
1859 library Strings {
1860     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1861     uint8 private constant _ADDRESS_LENGTH = 20;
1862 
1863     /**
1864      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1865      */
1866     function toString(uint256 value) internal pure returns (string memory) {
1867         unchecked {
1868             uint256 length = Math.log10(value) + 1;
1869             string memory buffer = new string(length);
1870             uint256 ptr;
1871             /// @solidity memory-safe-assembly
1872             assembly {
1873                 ptr := add(buffer, add(32, length))
1874             }
1875             while (true) {
1876                 ptr--;
1877                 /// @solidity memory-safe-assembly
1878                 assembly {
1879                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1880                 }
1881                 value /= 10;
1882                 if (value == 0) break;
1883             }
1884             return buffer;
1885         }
1886     }
1887 
1888     /**
1889      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1890      */
1891     function toString(int256 value) internal pure returns (string memory) {
1892         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
1893     }
1894 
1895     /**
1896      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1897      */
1898     function toHexString(uint256 value) internal pure returns (string memory) {
1899         unchecked {
1900             return toHexString(value, Math.log256(value) + 1);
1901         }
1902     }
1903 
1904     /**
1905      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1906      */
1907     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1908         bytes memory buffer = new bytes(2 * length + 2);
1909         buffer[0] = "0";
1910         buffer[1] = "x";
1911         for (uint256 i = 2 * length + 1; i > 1; --i) {
1912             buffer[i] = _SYMBOLS[value & 0xf];
1913             value >>= 4;
1914         }
1915         require(value == 0, "Strings: hex length insufficient");
1916         return string(buffer);
1917     }
1918 
1919     /**
1920      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1921      */
1922     function toHexString(address addr) internal pure returns (string memory) {
1923         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1924     }
1925 
1926     /**
1927      * @dev Returns true if the two strings are equal.
1928      */
1929     function equal(string memory a, string memory b) internal pure returns (bool) {
1930         return keccak256(bytes(a)) == keccak256(bytes(b));
1931     }
1932 }
1933 
1934 // File: @openzeppelin/contracts/utils/Address.sol
1935 
1936 
1937 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
1938 
1939 pragma solidity ^0.8.1;
1940 
1941 /**
1942  * @dev Collection of functions related to the address type
1943  */
1944 library Address {
1945     /**
1946      * @dev Returns true if `account` is a contract.
1947      *
1948      * [IMPORTANT]
1949      * ====
1950      * It is unsafe to assume that an address for which this function returns
1951      * false is an externally-owned account (EOA) and not a contract.
1952      *
1953      * Among others, `isContract` will return false for the following
1954      * types of addresses:
1955      *
1956      *  - an externally-owned account
1957      *  - a contract in construction
1958      *  - an address where a contract will be created
1959      *  - an address where a contract lived, but was destroyed
1960      *
1961      * Furthermore, `isContract` will also return true if the target contract within
1962      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1963      * which only has an effect at the end of a transaction.
1964      * ====
1965      *
1966      * [IMPORTANT]
1967      * ====
1968      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1969      *
1970      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1971      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1972      * constructor.
1973      * ====
1974      */
1975     function isContract(address account) internal view returns (bool) {
1976         // This method relies on extcodesize/address.code.length, which returns 0
1977         // for contracts in construction, since the code is only stored at the end
1978         // of the constructor execution.
1979 
1980         return account.code.length > 0;
1981     }
1982 
1983     /**
1984      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1985      * `recipient`, forwarding all available gas and reverting on errors.
1986      *
1987      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1988      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1989      * imposed by `transfer`, making them unable to receive funds via
1990      * `transfer`. {sendValue} removes this limitation.
1991      *
1992      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1993      *
1994      * IMPORTANT: because control is transferred to `recipient`, care must be
1995      * taken to not create reentrancy vulnerabilities. Consider using
1996      * {ReentrancyGuard} or the
1997      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1998      */
1999     function sendValue(address payable recipient, uint256 amount) internal {
2000         require(address(this).balance >= amount, "Address: insufficient balance");
2001 
2002         (bool success, ) = recipient.call{value: amount}("");
2003         require(success, "Address: unable to send value, recipient may have reverted");
2004     }
2005 
2006     /**
2007      * @dev Performs a Solidity function call using a low level `call`. A
2008      * plain `call` is an unsafe replacement for a function call: use this
2009      * function instead.
2010      *
2011      * If `target` reverts with a revert reason, it is bubbled up by this
2012      * function (like regular Solidity function calls).
2013      *
2014      * Returns the raw returned data. To convert to the expected return value,
2015      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2016      *
2017      * Requirements:
2018      *
2019      * - `target` must be a contract.
2020      * - calling `target` with `data` must not revert.
2021      *
2022      * _Available since v3.1._
2023      */
2024     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2025         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2026     }
2027 
2028     /**
2029      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2030      * `errorMessage` as a fallback revert reason when `target` reverts.
2031      *
2032      * _Available since v3.1._
2033      */
2034     function functionCall(
2035         address target,
2036         bytes memory data,
2037         string memory errorMessage
2038     ) internal returns (bytes memory) {
2039         return functionCallWithValue(target, data, 0, errorMessage);
2040     }
2041 
2042     /**
2043      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2044      * but also transferring `value` wei to `target`.
2045      *
2046      * Requirements:
2047      *
2048      * - the calling contract must have an ETH balance of at least `value`.
2049      * - the called Solidity function must be `payable`.
2050      *
2051      * _Available since v3.1._
2052      */
2053     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
2054         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2055     }
2056 
2057     /**
2058      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2059      * with `errorMessage` as a fallback revert reason when `target` reverts.
2060      *
2061      * _Available since v3.1._
2062      */
2063     function functionCallWithValue(
2064         address target,
2065         bytes memory data,
2066         uint256 value,
2067         string memory errorMessage
2068     ) internal returns (bytes memory) {
2069         require(address(this).balance >= value, "Address: insufficient balance for call");
2070         (bool success, bytes memory returndata) = target.call{value: value}(data);
2071         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2072     }
2073 
2074     /**
2075      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2076      * but performing a static call.
2077      *
2078      * _Available since v3.3._
2079      */
2080     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2081         return functionStaticCall(target, data, "Address: low-level static call failed");
2082     }
2083 
2084     /**
2085      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2086      * but performing a static call.
2087      *
2088      * _Available since v3.3._
2089      */
2090     function functionStaticCall(
2091         address target,
2092         bytes memory data,
2093         string memory errorMessage
2094     ) internal view returns (bytes memory) {
2095         (bool success, bytes memory returndata) = target.staticcall(data);
2096         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2097     }
2098 
2099     /**
2100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2101      * but performing a delegate call.
2102      *
2103      * _Available since v3.4._
2104      */
2105     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2106         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2107     }
2108 
2109     /**
2110      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2111      * but performing a delegate call.
2112      *
2113      * _Available since v3.4._
2114      */
2115     function functionDelegateCall(
2116         address target,
2117         bytes memory data,
2118         string memory errorMessage
2119     ) internal returns (bytes memory) {
2120         (bool success, bytes memory returndata) = target.delegatecall(data);
2121         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2122     }
2123 
2124     /**
2125      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2126      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2127      *
2128      * _Available since v4.8._
2129      */
2130     function verifyCallResultFromTarget(
2131         address target,
2132         bool success,
2133         bytes memory returndata,
2134         string memory errorMessage
2135     ) internal view returns (bytes memory) {
2136         if (success) {
2137             if (returndata.length == 0) {
2138                 // only check isContract if the call was successful and the return data is empty
2139                 // otherwise we already know that it was a contract
2140                 require(isContract(target), "Address: call to non-contract");
2141             }
2142             return returndata;
2143         } else {
2144             _revert(returndata, errorMessage);
2145         }
2146     }
2147 
2148     /**
2149      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2150      * revert reason or using the provided one.
2151      *
2152      * _Available since v4.3._
2153      */
2154     function verifyCallResult(
2155         bool success,
2156         bytes memory returndata,
2157         string memory errorMessage
2158     ) internal pure returns (bytes memory) {
2159         if (success) {
2160             return returndata;
2161         } else {
2162             _revert(returndata, errorMessage);
2163         }
2164     }
2165 
2166     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2167         // Look for revert reason and bubble it up if present
2168         if (returndata.length > 0) {
2169             // The easiest way to bubble the revert reason is using memory via assembly
2170             /// @solidity memory-safe-assembly
2171             assembly {
2172                 let returndata_size := mload(returndata)
2173                 revert(add(32, returndata), returndata_size)
2174             }
2175         } else {
2176             revert(errorMessage);
2177         }
2178     }
2179 }
2180 
2181 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol
2182 
2183 
2184 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
2185 
2186 pragma solidity ^0.8.0;
2187 
2188 /**
2189  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2190  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2191  *
2192  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2193  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2194  * need to send a transaction, and thus is not required to hold Ether at all.
2195  */
2196 interface IERC20Permit {
2197     /**
2198      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2199      * given ``owner``'s signed approval.
2200      *
2201      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2202      * ordering also apply here.
2203      *
2204      * Emits an {Approval} event.
2205      *
2206      * Requirements:
2207      *
2208      * - `spender` cannot be the zero address.
2209      * - `deadline` must be a timestamp in the future.
2210      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2211      * over the EIP712-formatted function arguments.
2212      * - the signature must use ``owner``'s current nonce (see {nonces}).
2213      *
2214      * For more information on the signature format, see the
2215      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2216      * section].
2217      */
2218     function permit(
2219         address owner,
2220         address spender,
2221         uint256 value,
2222         uint256 deadline,
2223         uint8 v,
2224         bytes32 r,
2225         bytes32 s
2226     ) external;
2227 
2228     /**
2229      * @dev Returns the current nonce for `owner`. This value must be
2230      * included whenever a signature is generated for {permit}.
2231      *
2232      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2233      * prevents a signature from being used multiple times.
2234      */
2235     function nonces(address owner) external view returns (uint256);
2236 
2237     /**
2238      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2239      */
2240     // solhint-disable-next-line func-name-mixedcase
2241     function DOMAIN_SEPARATOR() external view returns (bytes32);
2242 }
2243 
2244 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2245 
2246 
2247 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
2248 
2249 pragma solidity ^0.8.0;
2250 
2251 /**
2252  * @dev Interface of the ERC20 standard as defined in the EIP.
2253  */
2254 interface IERC20 {
2255     /**
2256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2257      * another (`to`).
2258      *
2259      * Note that `value` may be zero.
2260      */
2261     event Transfer(address indexed from, address indexed to, uint256 value);
2262 
2263     /**
2264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2265      * a call to {approve}. `value` is the new allowance.
2266      */
2267     event Approval(address indexed owner, address indexed spender, uint256 value);
2268 
2269     /**
2270      * @dev Returns the amount of tokens in existence.
2271      */
2272     function totalSupply() external view returns (uint256);
2273 
2274     /**
2275      * @dev Returns the amount of tokens owned by `account`.
2276      */
2277     function balanceOf(address account) external view returns (uint256);
2278 
2279     /**
2280      * @dev Moves `amount` tokens from the caller's account to `to`.
2281      *
2282      * Returns a boolean value indicating whether the operation succeeded.
2283      *
2284      * Emits a {Transfer} event.
2285      */
2286     function transfer(address to, uint256 amount) external returns (bool);
2287 
2288     /**
2289      * @dev Returns the remaining number of tokens that `spender` will be
2290      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2291      * zero by default.
2292      *
2293      * This value changes when {approve} or {transferFrom} are called.
2294      */
2295     function allowance(address owner, address spender) external view returns (uint256);
2296 
2297     /**
2298      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2299      *
2300      * Returns a boolean value indicating whether the operation succeeded.
2301      *
2302      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2303      * that someone may use both the old and the new allowance by unfortunate
2304      * transaction ordering. One possible solution to mitigate this race
2305      * condition is to first reduce the spender's allowance to 0 and set the
2306      * desired value afterwards:
2307      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2308      *
2309      * Emits an {Approval} event.
2310      */
2311     function approve(address spender, uint256 amount) external returns (bool);
2312 
2313     /**
2314      * @dev Moves `amount` tokens from `from` to `to` using the
2315      * allowance mechanism. `amount` is then deducted from the caller's
2316      * allowance.
2317      *
2318      * Returns a boolean value indicating whether the operation succeeded.
2319      *
2320      * Emits a {Transfer} event.
2321      */
2322     function transferFrom(address from, address to, uint256 amount) external returns (bool);
2323 }
2324 
2325 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2326 
2327 
2328 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)
2329 
2330 pragma solidity ^0.8.0;
2331 
2332 
2333 
2334 
2335 /**
2336  * @title SafeERC20
2337  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2338  * contract returns false). Tokens that return no value (and instead revert or
2339  * throw on failure) are also supported, non-reverting calls are assumed to be
2340  * successful.
2341  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2342  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2343  */
2344 library SafeERC20 {
2345     using Address for address;
2346 
2347     /**
2348      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
2349      * non-reverting calls are assumed to be successful.
2350      */
2351     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2352         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2353     }
2354 
2355     /**
2356      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
2357      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
2358      */
2359     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2360         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2361     }
2362 
2363     /**
2364      * @dev Deprecated. This function has issues similar to the ones found in
2365      * {IERC20-approve}, and its usage is discouraged.
2366      *
2367      * Whenever possible, use {safeIncreaseAllowance} and
2368      * {safeDecreaseAllowance} instead.
2369      */
2370     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2371         // safeApprove should only be called when setting an initial allowance,
2372         // or when resetting it to zero. To increase and decrease it, use
2373         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2374         require(
2375             (value == 0) || (token.allowance(address(this), spender) == 0),
2376             "SafeERC20: approve from non-zero to non-zero allowance"
2377         );
2378         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2379     }
2380 
2381     /**
2382      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
2383      * non-reverting calls are assumed to be successful.
2384      */
2385     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2386         uint256 oldAllowance = token.allowance(address(this), spender);
2387         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
2388     }
2389 
2390     /**
2391      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
2392      * non-reverting calls are assumed to be successful.
2393      */
2394     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2395         unchecked {
2396             uint256 oldAllowance = token.allowance(address(this), spender);
2397             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2398             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
2399         }
2400     }
2401 
2402     /**
2403      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
2404      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
2405      * 0 before setting it to a non-zero value.
2406      */
2407     function forceApprove(IERC20 token, address spender, uint256 value) internal {
2408         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
2409 
2410         if (!_callOptionalReturnBool(token, approvalCall)) {
2411             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
2412             _callOptionalReturn(token, approvalCall);
2413         }
2414     }
2415 
2416     /**
2417      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
2418      * Revert on invalid signature.
2419      */
2420     function safePermit(
2421         IERC20Permit token,
2422         address owner,
2423         address spender,
2424         uint256 value,
2425         uint256 deadline,
2426         uint8 v,
2427         bytes32 r,
2428         bytes32 s
2429     ) internal {
2430         uint256 nonceBefore = token.nonces(owner);
2431         token.permit(owner, spender, value, deadline, v, r, s);
2432         uint256 nonceAfter = token.nonces(owner);
2433         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2434     }
2435 
2436     /**
2437      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2438      * on the return value: the return value is optional (but if data is returned, it must not be false).
2439      * @param token The token targeted by the call.
2440      * @param data The call data (encoded using abi.encode or one of its variants).
2441      */
2442     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2443         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2444         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2445         // the target address contains contract code and also asserts for success in the low-level call.
2446 
2447         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2448         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2449     }
2450 
2451     /**
2452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2453      * on the return value: the return value is optional (but if data is returned, it must not be false).
2454      * @param token The token targeted by the call.
2455      * @param data The call data (encoded using abi.encode or one of its variants).
2456      *
2457      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
2458      */
2459     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
2460         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2461         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
2462         // and not revert is the subcall reverts.
2463 
2464         (bool success, bytes memory returndata) = address(token).call(data);
2465         return
2466             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
2467     }
2468 }
2469 
2470 // File: @openzeppelin/contracts/utils/Context.sol
2471 
2472 
2473 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2474 
2475 pragma solidity ^0.8.0;
2476 
2477 /**
2478  * @dev Provides information about the current execution context, including the
2479  * sender of the transaction and its data. While these are generally available
2480  * via msg.sender and msg.data, they should not be accessed in such a direct
2481  * manner, since when dealing with meta-transactions the account sending and
2482  * paying for execution may not be the actual sender (as far as an application
2483  * is concerned).
2484  *
2485  * This contract is only required for intermediate, library-like contracts.
2486  */
2487 abstract contract Context {
2488     function _msgSender() internal view virtual returns (address) {
2489         return msg.sender;
2490     }
2491 
2492     function _msgData() internal view virtual returns (bytes calldata) {
2493         return msg.data;
2494     }
2495 }
2496 
2497 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2498 
2499 
2500 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2501 
2502 pragma solidity ^0.8.0;
2503 
2504 
2505 
2506 
2507 /**
2508  * @title PaymentSplitter
2509  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2510  * that the Ether will be split in this way, since it is handled transparently by the contract.
2511  *
2512  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2513  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2514  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2515  * time of contract deployment and can't be updated thereafter.
2516  *
2517  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2518  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2519  * function.
2520  *
2521  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2522  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2523  * to run tests before sending real value to this contract.
2524  */
2525 contract PaymentSplitter is Context {
2526     event PayeeAdded(address account, uint256 shares);
2527     event PaymentReleased(address to, uint256 amount);
2528     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2529     event PaymentReceived(address from, uint256 amount);
2530 
2531     uint256 private _totalShares;
2532     uint256 private _totalReleased;
2533 
2534     mapping(address => uint256) private _shares;
2535     mapping(address => uint256) private _released;
2536     address[] private _payees;
2537 
2538     mapping(IERC20 => uint256) private _erc20TotalReleased;
2539     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2540 
2541     /**
2542      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2543      * the matching position in the `shares` array.
2544      *
2545      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2546      * duplicates in `payees`.
2547      */
2548     constructor(address[] memory payees, uint256[] memory shares_) payable {
2549         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2550         require(payees.length > 0, "PaymentSplitter: no payees");
2551 
2552         for (uint256 i = 0; i < payees.length; i++) {
2553             _addPayee(payees[i], shares_[i]);
2554         }
2555     }
2556 
2557     /**
2558      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2559      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2560      * reliability of the events, and not the actual splitting of Ether.
2561      *
2562      * To learn more about this see the Solidity documentation for
2563      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2564      * functions].
2565      */
2566     receive() external payable virtual {
2567         emit PaymentReceived(_msgSender(), msg.value);
2568     }
2569 
2570     /**
2571      * @dev Getter for the total shares held by payees.
2572      */
2573     function totalShares() public view returns (uint256) {
2574         return _totalShares;
2575     }
2576 
2577     /**
2578      * @dev Getter for the total amount of Ether already released.
2579      */
2580     function totalReleased() public view returns (uint256) {
2581         return _totalReleased;
2582     }
2583 
2584     /**
2585      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2586      * contract.
2587      */
2588     function totalReleased(IERC20 token) public view returns (uint256) {
2589         return _erc20TotalReleased[token];
2590     }
2591 
2592     /**
2593      * @dev Getter for the amount of shares held by an account.
2594      */
2595     function shares(address account) public view returns (uint256) {
2596         return _shares[account];
2597     }
2598 
2599     /**
2600      * @dev Getter for the amount of Ether already released to a payee.
2601      */
2602     function released(address account) public view returns (uint256) {
2603         return _released[account];
2604     }
2605 
2606     /**
2607      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2608      * IERC20 contract.
2609      */
2610     function released(IERC20 token, address account) public view returns (uint256) {
2611         return _erc20Released[token][account];
2612     }
2613 
2614     /**
2615      * @dev Getter for the address of the payee number `index`.
2616      */
2617     function payee(uint256 index) public view returns (address) {
2618         return _payees[index];
2619     }
2620 
2621     /**
2622      * @dev Getter for the amount of payee's releasable Ether.
2623      */
2624     function releasable(address account) public view returns (uint256) {
2625         uint256 totalReceived = address(this).balance + totalReleased();
2626         return _pendingPayment(account, totalReceived, released(account));
2627     }
2628 
2629     /**
2630      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2631      * IERC20 contract.
2632      */
2633     function releasable(IERC20 token, address account) public view returns (uint256) {
2634         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2635         return _pendingPayment(account, totalReceived, released(token, account));
2636     }
2637 
2638     /**
2639      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2640      * total shares and their previous withdrawals.
2641      */
2642     function release(address payable account) public virtual {
2643         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2644 
2645         uint256 payment = releasable(account);
2646 
2647         require(payment != 0, "PaymentSplitter: account is not due payment");
2648 
2649         // _totalReleased is the sum of all values in _released.
2650         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2651         _totalReleased += payment;
2652         unchecked {
2653             _released[account] += payment;
2654         }
2655 
2656         Address.sendValue(account, payment);
2657         emit PaymentReleased(account, payment);
2658     }
2659 
2660     /**
2661      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2662      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2663      * contract.
2664      */
2665     function release(IERC20 token, address account) public virtual {
2666         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2667 
2668         uint256 payment = releasable(token, account);
2669 
2670         require(payment != 0, "PaymentSplitter: account is not due payment");
2671 
2672         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2673         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2674         // cannot overflow.
2675         _erc20TotalReleased[token] += payment;
2676         unchecked {
2677             _erc20Released[token][account] += payment;
2678         }
2679 
2680         SafeERC20.safeTransfer(token, account, payment);
2681         emit ERC20PaymentReleased(token, account, payment);
2682     }
2683 
2684     /**
2685      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2686      * already released amounts.
2687      */
2688     function _pendingPayment(
2689         address account,
2690         uint256 totalReceived,
2691         uint256 alreadyReleased
2692     ) private view returns (uint256) {
2693         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2694     }
2695 
2696     /**
2697      * @dev Add a new payee to the contract.
2698      * @param account The address of the payee to add.
2699      * @param shares_ The number of shares owned by the payee.
2700      */
2701     function _addPayee(address account, uint256 shares_) private {
2702         require(account != address(0), "PaymentSplitter: account is the zero address");
2703         require(shares_ > 0, "PaymentSplitter: shares are 0");
2704         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2705 
2706         _payees.push(account);
2707         _shares[account] = shares_;
2708         _totalShares = _totalShares + shares_;
2709         emit PayeeAdded(account, shares_);
2710     }
2711 }
2712 
2713 // File: @openzeppelin/contracts/access/Ownable.sol
2714 
2715 
2716 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
2717 
2718 pragma solidity ^0.8.0;
2719 
2720 
2721 /**
2722  * @dev Contract module which provides a basic access control mechanism, where
2723  * there is an account (an owner) that can be granted exclusive access to
2724  * specific functions.
2725  *
2726  * By default, the owner account will be the one that deploys the contract. This
2727  * can later be changed with {transferOwnership}.
2728  *
2729  * This module is used through inheritance. It will make available the modifier
2730  * `onlyOwner`, which can be applied to your functions to restrict their use to
2731  * the owner.
2732  */
2733 abstract contract Ownable is Context {
2734     address private _owner;
2735 
2736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2737 
2738     /**
2739      * @dev Initializes the contract setting the deployer as the initial owner.
2740      */
2741     constructor() {
2742         _transferOwnership(_msgSender());
2743     }
2744 
2745     /**
2746      * @dev Throws if called by any account other than the owner.
2747      */
2748     modifier onlyOwner() {
2749         _checkOwner();
2750         _;
2751     }
2752 
2753     /**
2754      * @dev Returns the address of the current owner.
2755      */
2756     function owner() public view virtual returns (address) {
2757         return _owner;
2758     }
2759 
2760     /**
2761      * @dev Throws if the sender is not the owner.
2762      */
2763     function _checkOwner() internal view virtual {
2764         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2765     }
2766 
2767     /**
2768      * @dev Leaves the contract without owner. It will not be possible to call
2769      * `onlyOwner` functions. Can only be called by the current owner.
2770      *
2771      * NOTE: Renouncing ownership will leave the contract without an owner,
2772      * thereby disabling any functionality that is only available to the owner.
2773      */
2774     function renounceOwnership() public virtual onlyOwner {
2775         _transferOwnership(address(0));
2776     }
2777 
2778     /**
2779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2780      * Can only be called by the current owner.
2781      */
2782     function transferOwnership(address newOwner) public virtual onlyOwner {
2783         require(newOwner != address(0), "Ownable: new owner is the zero address");
2784         _transferOwnership(newOwner);
2785     }
2786 
2787     /**
2788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2789      * Internal function without access restriction.
2790      */
2791     function _transferOwnership(address newOwner) internal virtual {
2792         address oldOwner = _owner;
2793         _owner = newOwner;
2794         emit OwnershipTransferred(oldOwner, newOwner);
2795     }
2796 }
2797 
2798 // File: contracts/PonziBucks.sol
2799 
2800 
2801 pragma solidity ^0.8.18;
2802 
2803 
2804 
2805 
2806 
2807 
2808 contract PonziBucks is Ownable, ERC721A, PaymentSplitter {
2809 
2810     using Strings for uint256;
2811 
2812     string public baseURI;
2813 
2814     bool public saleOn = false;
2815     bool public whitelistSaleOn = false;
2816 
2817     uint256 public MAX_SUPPLY = 1000;
2818     uint256 public MAX_PER_WALLET_PUBLIC = 5;
2819     uint256 public PUBLIC_TOTAL = 500;
2820 
2821     uint256 public SalePrice = 0.00053233 ether;
2822 
2823     uint256 private teamLength;
2824 
2825     uint96 royaltyFeesInBips;
2826     address royaltyReceiver;
2827 
2828     bytes32 public merkleRoot1px;
2829     bytes32 public merkleRootWL;
2830 
2831     mapping (address => bool) private _burners;
2832     address[] public burnerList;
2833 
2834     mapping(address => uint256) public amountNFTsperWalletPUBLIC;
2835     mapping(address => uint256) public amountNFTsperWallet1px;
2836     mapping(address => uint256) public amountNFTsperWalletWL;
2837 
2838     constructor(uint96 _royaltyFeesInBips, address[] memory _team, uint256[] memory _teamShares, string memory _baseURI) ERC721A("PonziBucks", "PonziBucks")
2839     PaymentSplitter(_team, _teamShares) {
2840         baseURI = _baseURI;
2841         teamLength = _team.length;
2842         royaltyFeesInBips = _royaltyFeesInBips;
2843         royaltyReceiver = msg.sender;
2844     }
2845 
2846     modifier callerIsUser() {
2847         require(tx.origin == msg.sender, "The caller is another contract");
2848         _;
2849     }
2850 
2851     function currentTime() internal view returns(uint256) {
2852         return block.timestamp;
2853     }
2854     //MINTING
2855     function publicSaleMint(uint256 _quantity) external payable callerIsUser {
2856         require(saleOn == true, "Public sale is not activated");
2857         require(amountNFTsperWalletPUBLIC[msg.sender] + _quantity <= MAX_PER_WALLET_PUBLIC, "Max per wallet limit reached");
2858         require(totalSupply() + _quantity <= PUBLIC_TOTAL, "Max allocated amount exceeded");
2859         require(totalSupply() + _quantity <= MAX_SUPPLY,"Max supply exceeded");
2860         require(msg.value >= SalePrice * _quantity, "Not enought funds");
2861         amountNFTsperWalletPUBLIC[msg.sender] += _quantity;
2862         _safeMint(msg.sender, _quantity);
2863     }
2864     function holders1pxMint(bytes32[] calldata _proof) external payable callerIsUser{
2865         require(whitelistSaleOn == true, "Whitelist sale is not activated");
2866         require(isWhiteListed1px(msg.sender, _proof), "Not whitelisted");
2867         require(amountNFTsperWallet1px[msg.sender] + 3 <= 3, "Max per wallet limit reached");
2868         require(totalSupply() + 3 <= MAX_SUPPLY,"Max supply exceeded");
2869         require(msg.value >= SalePrice * 3, "Not enought funds");
2870         amountNFTsperWallet1px[msg.sender] += 3;
2871         _safeMint(msg.sender, 3);
2872     }
2873     function whitelistMint(bytes32[] calldata _proof) external payable callerIsUser{
2874         require(whitelistSaleOn == true, "Whitelist sale is not activated");
2875         require(isWhiteListedWL(msg.sender, _proof), "Not whitelisted");
2876         require(amountNFTsperWalletWL[msg.sender] + 1 <= 1, "Max per wallet limit reached");
2877         require(totalSupply() + 1 <= MAX_SUPPLY,"Max supply exceeded");
2878         require(msg.value >= SalePrice, "Not enought funds");
2879         amountNFTsperWalletWL[msg.sender] += 1;
2880         _safeMint(msg.sender, 1);
2881     }
2882 
2883     function gift(address _to, uint _quantity) external onlyOwner {
2884         _safeMint(_to, _quantity);
2885     }
2886     function burn(uint256 tokenId) public {
2887         require(msg.sender == ownerOf(tokenId), "You don't own it");
2888         require(!_burners[msg.sender], "You have already burnt an NFT");
2889 
2890         _burn(tokenId);
2891 
2892         _burners[msg.sender] = true;
2893         burnerList.push(msg.sender);
2894     }
2895     function getBurnerList() public view returns (address[] memory) {
2896         return burnerList;
2897     }
2898     //ADMIN
2899     function setSalePrice(uint _SalePrice) external onlyOwner {
2900         SalePrice = _SalePrice;
2901     }
2902     function setBaseUri(string memory _baseURI) external onlyOwner {
2903         baseURI = _baseURI;
2904     }
2905     function setSale(bool _saleOn, bool _whitelistSaleOn) external onlyOwner {
2906         saleOn = _saleOn;
2907         whitelistSaleOn = _whitelistSaleOn;
2908     }
2909     function lowerSupply(uint256 _MAX_SUPPLY) external onlyOwner {
2910         require(_MAX_SUPPLY < MAX_SUPPLY, "Cannot increase supply!");
2911         MAX_SUPPLY = _MAX_SUPPLY;
2912     }
2913     function setMaxPublic(uint256 _PUBLIC_TOTAL) external onlyOwner {
2914         PUBLIC_TOTAL = _PUBLIC_TOTAL;
2915     }
2916     function setMaxPerWalletPUBLIC(uint256 _MAX_PER_WALLET_PUBLIC)
2917         external
2918         onlyOwner
2919     {
2920         MAX_PER_WALLET_PUBLIC = _MAX_PER_WALLET_PUBLIC;
2921     }
2922     function setMerkleRootWL(bytes32 _merkleRootWL) external onlyOwner {
2923         merkleRootWL = _merkleRootWL;
2924     }
2925     function setMerkleRoot1px(bytes32 _merkleRoot1px) external onlyOwner {
2926         merkleRoot1px = _merkleRoot1px;
2927     }
2928     function isWhiteListedWL(address _account, bytes32[] calldata _proof)
2929         internal
2930         view
2931         returns (bool)
2932     {
2933         return _verifyWL(leaf(_account), _proof);
2934     }
2935      function isWhiteListed1px(address _account, bytes32[] calldata _proof)
2936         internal
2937         view
2938         returns (bool)
2939     {
2940         return _verify1px(leaf(_account), _proof);
2941     }
2942 
2943     function leaf(address _account) internal pure returns (bytes32) {
2944         return keccak256(abi.encodePacked(_account));
2945     }
2946 
2947     function _verifyWL(bytes32 _leaf, bytes32[] memory _proof)
2948         internal
2949         view
2950         returns (bool)
2951     {
2952         return MerkleProof.verify(_proof, merkleRootWL, _leaf);
2953     }
2954     function _verify1px(bytes32 _leaf, bytes32[] memory _proof)
2955         internal
2956         view
2957         returns (bool)
2958     {
2959         return MerkleProof.verify(_proof, merkleRoot1px, _leaf);
2960     }
2961     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2962         require(_exists(_tokenId), "URI query for nonexistent token");
2963         if(_tokenId % 2 == 0){
2964         return string(abi.encodePacked(baseURI, "front.json"));
2965         }
2966         else
2967             return string(abi.encodePacked(baseURI, "back.json"));
2968     }
2969 
2970     // ROYALTY
2971     function royaltyInfo (
2972     uint256 _tokenId,
2973     uint256 _salePrice
2974      ) external view returns (
2975         address receiver,
2976         uint256 royaltyAmount
2977      ){
2978          return (royaltyReceiver, calculateRoyalty(_salePrice));
2979      }
2980 
2981     function calculateRoyalty(uint256 _salePrice) view public returns (uint256){
2982         return(_salePrice / 10000) * royaltyFeesInBips;
2983     }
2984 
2985     function setRoyaltyInfo (address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
2986         royaltyReceiver = _receiver;
2987         royaltyFeesInBips = _royaltyFeesInBips;
2988     }
2989 
2990     //WITHDRAW
2991     function releaseAll() external onlyOwner {
2992         for(uint i = 0 ; i < teamLength ; i++) {
2993             release(payable(payee(i)));
2994         }
2995     }
2996 
2997     receive() override external payable {
2998         revert('Only if you mint');
2999     }
3000 
3001 }