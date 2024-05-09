1 // SPDX-License-Identifier: MIT
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
217 // File: contracts/Nakeds.sol
218 
219 
220 // HI OS 01.06.2022
221 
222 pragma solidity ^0.8.4;
223 
224 /**
225  * @dev Interface of an ERC721A compliant contract.
226  */
227 interface IERC721A {
228     /**
229      * The caller must own the token or be an approved operator.
230      */
231     error ApprovalCallerNotOwnerNorApproved();
232 
233     /**
234      * The token does not exist.
235      */
236     error ApprovalQueryForNonexistentToken();
237 
238     /**
239      * The caller cannot approve to their own address.
240      */
241     error ApproveToCaller();
242 
243     /**
244      * The caller cannot approve to the current owner.
245      */
246     error ApprovalToCurrentOwner();
247 
248     /**
249      * Cannot query the balance for the zero address.
250      */
251     error BalanceQueryForZeroAddress();
252 
253     /**
254      * Cannot mint to the zero address.
255      */
256     error MintToZeroAddress();
257 
258     /**
259      * The quantity of tokens minted must be more than zero.
260      */
261     error MintZeroQuantity();
262 
263     /**
264      * The token does not exist.
265      */
266     error OwnerQueryForNonexistentToken();
267 
268     /**
269      * The caller must own the token or be an approved operator.
270      */
271     error TransferCallerNotOwnerNorApproved();
272 
273     /**
274      * The token must be owned by `from`.
275      */
276     error TransferFromIncorrectOwner();
277 
278     /**
279      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
280      */
281     error TransferToNonERC721ReceiverImplementer();
282 
283     /**
284      * Cannot transfer to the zero address.
285      */
286     error TransferToZeroAddress();
287 
288     /**
289      * The token does not exist.
290      */
291     error URIQueryForNonexistentToken();
292 
293     struct TokenOwnership {
294         // The address of the owner.
295         address addr;
296         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
297         uint64 startTimestamp;
298         // Whether the token has been burned.
299         bool burned;
300     }
301 
302     /**
303      * @dev Returns the total amount of tokens stored by the contract.
304      *
305      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     // ==============================
310     //            IERC165
311     // ==============================
312 
313     /**
314      * @dev Returns true if this contract implements the interface defined by
315      * `interfaceId`. See the corresponding
316      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
317      * to learn more about how these ids are created.
318      *
319      * This function call must use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool);
322 
323     // ==============================
324     //            IERC721
325     // ==============================
326 
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     // ==============================
460     //        IERC721Metadata
461     // ==============================
462 
463     /**
464      * @dev Returns the token collection name.
465      */
466     function name() external view returns (string memory);
467 
468     /**
469      * @dev Returns the token collection symbol.
470      */
471     function symbol() external view returns (string memory);
472 
473     /**
474      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
475      */
476     function tokenURI(uint256 tokenId) external view returns (string memory);
477 }
478 
479 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
480 
481 
482 // ERC721A Contracts v3.3.0
483 // Creator: Chiru Labs
484 
485 pragma solidity ^0.8.4;
486 
487 
488 /**
489  * @dev ERC721 token receiver interface.
490  */
491 interface ERC721A__IERC721Receiver {
492     function onERC721Received(
493         address operator,
494         address from,
495         uint256 tokenId,
496         bytes calldata data
497     ) external returns (bytes4);
498 }
499 
500 /**
501  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
502  * the Metadata extension. Built to optimize for lower gas during batch mints.
503  *
504  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
505  *
506  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
507  *
508  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
509  */
510 contract ERC721A is IERC721A {
511     // Mask of an entry in packed address data.
512     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
513 
514     // The bit position of `numberMinted` in packed address data.
515     uint256 private constant BITPOS_NUMBER_MINTED = 64;
516 
517     // The bit position of `numberBurned` in packed address data.
518     uint256 private constant BITPOS_NUMBER_BURNED = 128;
519 
520     // The bit position of `aux` in packed address data.
521     uint256 private constant BITPOS_AUX = 192;
522 
523     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
524     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
525 
526     // The bit position of `startTimestamp` in packed ownership.
527     uint256 private constant BITPOS_START_TIMESTAMP = 160;
528 
529     // The bit mask of the `burned` bit in packed ownership.
530     uint256 private constant BITMASK_BURNED = 1 << 224;
531     
532     // The bit position of the `nextInitialized` bit in packed ownership.
533     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
534 
535     // The bit mask of the `nextInitialized` bit in packed ownership.
536     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
537 
538     // The tokenId of the next token to be minted.
539     uint256 private _currentIndex;
540 
541     // The number of tokens burned.
542     uint256 private _burnCounter;
543 
544     // Token name
545     string private _name;
546 
547     // Token symbol
548     string private _symbol;
549 
550     // Mapping from token ID to ownership details
551     // An empty struct value does not necessarily mean the token is unowned.
552     // See `_packedOwnershipOf` implementation for details.
553     //
554     // Bits Layout:
555     // - [0..159]   `addr`
556     // - [160..223] `startTimestamp`
557     // - [224]      `burned`
558     // - [225]      `nextInitialized`
559     mapping(uint256 => uint256) private _packedOwnerships;
560 
561     // Mapping owner address to address data.
562     //
563     // Bits Layout:
564     // - [0..63]    `balance`
565     // - [64..127]  `numberMinted`
566     // - [128..191] `numberBurned`
567     // - [192..255] `aux`
568     mapping(address => uint256) private _packedAddressData;
569 
570     // Mapping from token ID to approved address.
571     mapping(uint256 => address) private _tokenApprovals;
572 
573     // Mapping from owner to operator approvals
574     mapping(address => mapping(address => bool)) private _operatorApprovals;
575 
576     constructor(string memory name_, string memory symbol_) {
577         _name = name_;
578         _symbol = symbol_;
579         _currentIndex = _startTokenId();
580     }
581 
582     /**
583      * @dev Returns the starting token ID. 
584      * To change the starting token ID, please override this function.
585      */
586     function _startTokenId() internal view virtual returns (uint256) {
587         return 0;
588     }
589 
590     /**
591      * @dev Returns the next token ID to be minted.
592      */
593     function _nextTokenId() internal view returns (uint256) {
594         return _currentIndex;
595     }
596 
597     /**
598      * @dev Returns the total number of tokens in existence.
599      * Burned tokens will reduce the count. 
600      * To get the total number of tokens minted, please see `_totalMinted`.
601      */
602     function totalSupply() public view override returns (uint256) {
603         // Counter underflow is impossible as _burnCounter cannot be incremented
604         // more than `_currentIndex - _startTokenId()` times.
605         unchecked {
606             return _currentIndex - _burnCounter - _startTokenId();
607         }
608     }
609 
610     /**
611      * @dev Returns the total amount of tokens minted in the contract.
612      */
613     function _totalMinted() internal view returns (uint256) {
614         // Counter underflow is impossible as _currentIndex does not decrement,
615         // and it is initialized to `_startTokenId()`
616         unchecked {
617             return _currentIndex - _startTokenId();
618         }
619     }
620 
621     /**
622      * @dev Returns the total number of tokens burned.
623      */
624     function _totalBurned() internal view returns (uint256) {
625         return _burnCounter;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
632         // The interface IDs are constants representing the first 4 bytes of the XOR of
633         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
634         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
635         return
636             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
637             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
638             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
639     }
640 
641     /**
642      * @dev See {IERC721-balanceOf}.
643      */
644     function balanceOf(address owner) public view override returns (uint256) {
645         if (owner == address(0)) revert BalanceQueryForZeroAddress();
646         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
647     }
648 
649     /**
650      * Returns the number of tokens minted by `owner`.
651      */
652     function _numberMinted(address owner) internal view returns (uint256) {
653         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
654     }
655 
656     /**
657      * Returns the number of tokens burned by or on behalf of `owner`.
658      */
659     function _numberBurned(address owner) internal view returns (uint256) {
660         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
661     }
662 
663     /**
664      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
665      */
666     function _getAux(address owner) internal view returns (uint64) {
667         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
668     }
669 
670     /**
671      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
672      * If there are multiple variables, please pack them into a uint64.
673      */
674     function _setAux(address owner, uint64 aux) internal {
675         uint256 packed = _packedAddressData[owner];
676         uint256 auxCasted;
677         assembly { // Cast aux without masking.
678             auxCasted := aux
679         }
680         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
681         _packedAddressData[owner] = packed;
682     }
683 
684     /**
685      * Returns the packed ownership data of `tokenId`.
686      */
687     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
688         uint256 curr = tokenId;
689 
690         unchecked {
691             if (_startTokenId() <= curr)
692                 if (curr < _currentIndex) {
693                     uint256 packed = _packedOwnerships[curr];
694                     // If not burned.
695                     if (packed & BITMASK_BURNED == 0) {
696                         // Invariant:
697                         // There will always be an ownership that has an address and is not burned
698                         // before an ownership that does not have an address and is not burned.
699                         // Hence, curr will not underflow.
700                         //
701                         // We can directly compare the packed value.
702                         // If the address is zero, packed is zero.
703                         while (packed == 0) {
704                             packed = _packedOwnerships[--curr];
705                         }
706                         return packed;
707                     }
708                 }
709         }
710         revert OwnerQueryForNonexistentToken();
711     }
712 
713     /**
714      * Returns the unpacked `TokenOwnership` struct from `packed`.
715      */
716     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
717         ownership.addr = address(uint160(packed));
718         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
719         ownership.burned = packed & BITMASK_BURNED != 0;
720     }
721 
722     /**
723      * Returns the unpacked `TokenOwnership` struct at `index`.
724      */
725     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
726         return _unpackedOwnership(_packedOwnerships[index]);
727     }
728 
729     /**
730      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
731      */
732     function _initializeOwnershipAt(uint256 index) internal {
733         if (_packedOwnerships[index] == 0) {
734             _packedOwnerships[index] = _packedOwnershipOf(index);
735         }
736     }
737 
738     /**
739      * Gas spent here starts off proportional to the maximum mint batch size.
740      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
741      */
742     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
743         return _unpackedOwnership(_packedOwnershipOf(tokenId));
744     }
745 
746     /**
747      * @dev See {IERC721-ownerOf}.
748      */
749     function ownerOf(uint256 tokenId) public view override returns (address) {
750         return address(uint160(_packedOwnershipOf(tokenId)));
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-name}.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev See {IERC721Metadata-symbol}.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-tokenURI}.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, can be overriden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return '';
784     }
785 
786     /**
787      * @dev Casts the address to uint256 without masking.
788      */
789     function _addressToUint256(address value) private pure returns (uint256 result) {
790         assembly {
791             result := value
792         }
793     }
794 
795     /**
796      * @dev Casts the boolean to uint256 without branching.
797      */
798     function _boolToUint256(bool value) private pure returns (uint256 result) {
799         assembly {
800             result := value
801         }
802     }
803 
804     /**
805      * @dev See {IERC721-approve}.
806      */
807     function approve(address to, uint256 tokenId) public override {
808         address owner = address(uint160(_packedOwnershipOf(tokenId)));
809         if (to == owner) revert ApprovalToCurrentOwner();
810 
811         if (_msgSenderERC721A() != owner)
812             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
813                 revert ApprovalCallerNotOwnerNorApproved();
814             }
815 
816         _tokenApprovals[tokenId] = to;
817         emit Approval(owner, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view override returns (address) {
824         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public virtual override {
833         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
834 
835         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
836         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-transferFrom}.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public virtual override {
865         safeTransferFrom(from, to, tokenId, '');
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public virtual override {
877         _transfer(from, to, tokenId);
878         if (to.code.length != 0)
879             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
880                 revert TransferToNonERC721ReceiverImplementer();
881             }
882     }
883 
884     /**
885      * @dev Returns whether `tokenId` exists.
886      *
887      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
888      *
889      * Tokens start existing when they are minted (`_mint`),
890      */
891     function _exists(uint256 tokenId) internal view returns (bool) {
892         return
893             _startTokenId() <= tokenId &&
894             tokenId < _currentIndex && // If within bounds,
895             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
896     }
897 
898     /**
899      * @dev Equivalent to `_safeMint(to, quantity, '')`.
900      */
901     function _safeMint(address to, uint256 quantity) internal {
902         _safeMint(to, quantity, '');
903     }
904 
905     /**
906      * @dev Safely mints `quantity` tokens and transfers them to `to`.
907      *
908      * Requirements:
909      *
910      * - If `to` refers to a smart contract, it must implement
911      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
912      * - `quantity` must be greater than 0.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _safeMint(
917         address to,
918         uint256 quantity,
919         bytes memory _data
920     ) internal {
921         uint256 startTokenId = _currentIndex;
922         if (to == address(0)) revert MintToZeroAddress();
923         if (quantity == 0) revert MintZeroQuantity();
924 
925         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
926 
927         // Overflows are incredibly unrealistic.
928         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
929         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
930         unchecked {
931             // Updates:
932             // - `balance += quantity`.
933             // - `numberMinted += quantity`.
934             //
935             // We can directly add to the balance and number minted.
936             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
937 
938             // Updates:
939             // - `address` to the owner.
940             // - `startTimestamp` to the timestamp of minting.
941             // - `burned` to `false`.
942             // - `nextInitialized` to `quantity == 1`.
943             _packedOwnerships[startTokenId] =
944                 _addressToUint256(to) |
945                 (block.timestamp << BITPOS_START_TIMESTAMP) |
946                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
947 
948             uint256 updatedIndex = startTokenId;
949             uint256 end = updatedIndex + quantity;
950 
951             if (to.code.length != 0) {
952                 do {
953                     emit Transfer(address(0), to, updatedIndex);
954                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
955                         revert TransferToNonERC721ReceiverImplementer();
956                     }
957                 } while (updatedIndex < end);
958                 // Reentrancy protection
959                 if (_currentIndex != startTokenId) revert();
960             } else {
961                 do {
962                     emit Transfer(address(0), to, updatedIndex++);
963                 } while (updatedIndex < end);
964             }
965             _currentIndex = updatedIndex;
966         }
967         _afterTokenTransfers(address(0), to, startTokenId, quantity);
968     }
969 
970     /**
971      * @dev Mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `quantity` must be greater than 0.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 quantity) internal {
981         uint256 startTokenId = _currentIndex;
982         if (to == address(0)) revert MintToZeroAddress();
983         if (quantity == 0) revert MintZeroQuantity();
984 
985         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
986 
987         // Overflows are incredibly unrealistic.
988         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
989         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
990         unchecked {
991             // Updates:
992             // - `balance += quantity`.
993             // - `numberMinted += quantity`.
994             //
995             // We can directly add to the balance and number minted.
996             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
997 
998             // Updates:
999             // - `address` to the owner.
1000             // - `startTimestamp` to the timestamp of minting.
1001             // - `burned` to `false`.
1002             // - `nextInitialized` to `quantity == 1`.
1003             _packedOwnerships[startTokenId] =
1004                 _addressToUint256(to) |
1005                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1006                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1007 
1008             uint256 updatedIndex = startTokenId;
1009             uint256 end = updatedIndex + quantity;
1010 
1011             do {
1012                 emit Transfer(address(0), to, updatedIndex++);
1013             } while (updatedIndex < end);
1014 
1015             _currentIndex = updatedIndex;
1016         }
1017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) private {
1035         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1036 
1037         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1038 
1039         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1040             isApprovedForAll(from, _msgSenderERC721A()) ||
1041             getApproved(tokenId) == _msgSenderERC721A());
1042 
1043         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1044         if (to == address(0)) revert TransferToZeroAddress();
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner.
1049         delete _tokenApprovals[tokenId];
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1054         unchecked {
1055             // We can directly increment and decrement the balances.
1056             --_packedAddressData[from]; // Updates: `balance -= 1`.
1057             ++_packedAddressData[to]; // Updates: `balance += 1`.
1058 
1059             // Updates:
1060             // - `address` to the next owner.
1061             // - `startTimestamp` to the timestamp of transfering.
1062             // - `burned` to `false`.
1063             // - `nextInitialized` to `true`.
1064             _packedOwnerships[tokenId] =
1065                 _addressToUint256(to) |
1066                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1067                 BITMASK_NEXT_INITIALIZED;
1068 
1069             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1070             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1071                 uint256 nextTokenId = tokenId + 1;
1072                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1073                 if (_packedOwnerships[nextTokenId] == 0) {
1074                     // If the next slot is within bounds.
1075                     if (nextTokenId != _currentIndex) {
1076                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1077                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1078                     }
1079                 }
1080             }
1081         }
1082 
1083         emit Transfer(from, to, tokenId);
1084         _afterTokenTransfers(from, to, tokenId, 1);
1085     }
1086 
1087     /**
1088      * @dev Equivalent to `_burn(tokenId, false)`.
1089      */
1090     function _burn(uint256 tokenId) internal virtual {
1091         _burn(tokenId, false);
1092     }
1093 
1094     /**
1095      * @dev Destroys `tokenId`.
1096      * The approval is cleared when the token is burned.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1105         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1106 
1107         address from = address(uint160(prevOwnershipPacked));
1108 
1109         if (approvalCheck) {
1110             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1111                 isApprovedForAll(from, _msgSenderERC721A()) ||
1112                 getApproved(tokenId) == _msgSenderERC721A());
1113 
1114             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1115         }
1116 
1117         _beforeTokenTransfers(from, address(0), tokenId, 1);
1118 
1119         // Clear approvals from the previous owner.
1120         delete _tokenApprovals[tokenId];
1121 
1122         // Underflow of the sender's balance is impossible because we check for
1123         // ownership above and the recipient's balance can't realistically overflow.
1124         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1125         unchecked {
1126             // Updates:
1127             // - `balance -= 1`.
1128             // - `numberBurned += 1`.
1129             //
1130             // We can directly decrement the balance, and increment the number burned.
1131             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1132             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1133 
1134             // Updates:
1135             // - `address` to the last owner.
1136             // - `startTimestamp` to the timestamp of burning.
1137             // - `burned` to `true`.
1138             // - `nextInitialized` to `true`.
1139             _packedOwnerships[tokenId] =
1140                 _addressToUint256(from) |
1141                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1142                 BITMASK_BURNED | 
1143                 BITMASK_NEXT_INITIALIZED;
1144 
1145             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1146             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1147                 uint256 nextTokenId = tokenId + 1;
1148                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1149                 if (_packedOwnerships[nextTokenId] == 0) {
1150                     // If the next slot is within bounds.
1151                     if (nextTokenId != _currentIndex) {
1152                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1153                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1154                     }
1155                 }
1156             }
1157         }
1158 
1159         emit Transfer(from, address(0), tokenId);
1160         _afterTokenTransfers(from, address(0), tokenId, 1);
1161 
1162         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1163         unchecked {
1164             _burnCounter++;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1170      *
1171      * @param from address representing the previous owner of the given token ID
1172      * @param to target address that will receive the tokens
1173      * @param tokenId uint256 ID of the token to be transferred
1174      * @param _data bytes optional data to send along with the call
1175      * @return bool whether the call correctly returned the expected magic value
1176      */
1177     function _checkContractOnERC721Received(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) private returns (bool) {
1183         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1184             bytes4 retval
1185         ) {
1186             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1187         } catch (bytes memory reason) {
1188             if (reason.length == 0) {
1189                 revert TransferToNonERC721ReceiverImplementer();
1190             } else {
1191                 assembly {
1192                     revert(add(32, reason), mload(reason))
1193                 }
1194             }
1195         }
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1200      * And also called before burning one token.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` will be minted for `to`.
1210      * - When `to` is zero, `tokenId` will be burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _beforeTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 
1220     /**
1221      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1222      * minting.
1223      * And also called after one token has been burned.
1224      *
1225      * startTokenId - the first token id to be transferred
1226      * quantity - the amount to be transferred
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` has been minted for `to`.
1233      * - When `to` is zero, `tokenId` has been burned by `from`.
1234      * - `from` and `to` are never both zero.
1235      */
1236     function _afterTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Returns the message sender (defaults to `msg.sender`).
1245      *
1246      * If you are writing GSN compatible contracts, you need to override this function.
1247      */
1248     function _msgSenderERC721A() internal view virtual returns (address) {
1249         return msg.sender;
1250     }
1251 
1252     /**
1253      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1254      */
1255     function _toString(uint256 value) internal pure returns (string memory ptr) {
1256         assembly {
1257             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1258             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1259             // We will need 1 32-byte word to store the length, 
1260             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1261             ptr := add(mload(0x40), 128)
1262             // Update the free memory pointer to allocate.
1263             mstore(0x40, ptr)
1264 
1265             // Cache the end of the memory to calculate the length later.
1266             let end := ptr
1267 
1268             // We write the string from the rightmost digit to the leftmost digit.
1269             // The following is essentially a do-while loop that also handles the zero case.
1270             // Costs a bit more than early returning for the zero case,
1271             // but cheaper in terms of deployment and overall runtime costs.
1272             for { 
1273                 // Initialize and perform the first pass without check.
1274                 let temp := value
1275                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1276                 ptr := sub(ptr, 1)
1277                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1278                 mstore8(ptr, add(48, mod(temp, 10)))
1279                 temp := div(temp, 10)
1280             } temp { 
1281                 // Keep dividing `temp` until zero.
1282                 temp := div(temp, 10)
1283             } { // Body of the for loop.
1284                 ptr := sub(ptr, 1)
1285                 mstore8(ptr, add(48, mod(temp, 10)))
1286             }
1287             
1288             let length := sub(end, ptr)
1289             // Move the pointer 32 bytes leftwards to make room for the length.
1290             ptr := sub(ptr, 32)
1291             // Store the length.
1292             mstore(ptr, length)
1293         }
1294     }
1295 }
1296 
1297 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1298 
1299 
1300 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 /**
1305  * @dev String operations.
1306  */
1307 library Strings {
1308     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1309     uint8 private constant _ADDRESS_LENGTH = 20;
1310 
1311     /**
1312      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1313      */
1314     function toString(uint256 value) internal pure returns (string memory) {
1315         // Inspired by OraclizeAPI's implementation - MIT licence
1316         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1317 
1318         if (value == 0) {
1319             return "0";
1320         }
1321         uint256 temp = value;
1322         uint256 digits;
1323         while (temp != 0) {
1324             digits++;
1325             temp /= 10;
1326         }
1327         bytes memory buffer = new bytes(digits);
1328         while (value != 0) {
1329             digits -= 1;
1330             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1331             value /= 10;
1332         }
1333         return string(buffer);
1334     }
1335 
1336     /**
1337      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1338      */
1339     function toHexString(uint256 value) internal pure returns (string memory) {
1340         if (value == 0) {
1341             return "0x00";
1342         }
1343         uint256 temp = value;
1344         uint256 length = 0;
1345         while (temp != 0) {
1346             length++;
1347             temp >>= 8;
1348         }
1349         return toHexString(value, length);
1350     }
1351 
1352     /**
1353      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1354      */
1355     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1356         bytes memory buffer = new bytes(2 * length + 2);
1357         buffer[0] = "0";
1358         buffer[1] = "x";
1359         for (uint256 i = 2 * length + 1; i > 1; --i) {
1360             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1361             value >>= 4;
1362         }
1363         require(value == 0, "Strings: hex length insufficient");
1364         return string(buffer);
1365     }
1366 
1367     /**
1368      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1369      */
1370     function toHexString(address addr) internal pure returns (string memory) {
1371         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1372     }
1373 }
1374 
1375 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1376 
1377 
1378 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 /**
1383  * @dev Provides information about the current execution context, including the
1384  * sender of the transaction and its data. While these are generally available
1385  * via msg.sender and msg.data, they should not be accessed in such a direct
1386  * manner, since when dealing with meta-transactions the account sending and
1387  * paying for execution may not be the actual sender (as far as an application
1388  * is concerned).
1389  *
1390  * This contract is only required for intermediate, library-like contracts.
1391  */
1392 abstract contract Context {
1393     function _msgSender() internal view virtual returns (address) {
1394         return msg.sender;
1395     }
1396 
1397     function _msgData() internal view virtual returns (bytes calldata) {
1398         return msg.data;
1399     }
1400 }
1401 
1402 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1403 
1404 
1405 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 
1410 /**
1411  * @dev Contract module which provides a basic access control mechanism, where
1412  * there is an account (an owner) that can be granted exclusive access to
1413  * specific functions.
1414  *
1415  * By default, the owner account will be the one that deploys the contract. This
1416  * can later be changed with {transferOwnership}.
1417  *
1418  * This module is used through inheritance. It will make available the modifier
1419  * `onlyOwner`, which can be applied to your functions to restrict their use to
1420  * the owner.
1421  */
1422 abstract contract Ownable is Context {
1423     address private _owner;
1424 
1425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1426 
1427     /**
1428      * @dev Initializes the contract setting the deployer as the initial owner.
1429      */
1430     constructor() {
1431         _transferOwnership(_msgSender());
1432     }
1433 
1434     /**
1435      * @dev Returns the address of the current owner.
1436      */
1437     function owner() public view virtual returns (address) {
1438         return _owner;
1439     }
1440 
1441     /**
1442      * @dev Throws if called by any account other than the owner.
1443      */
1444     modifier onlyOwner() {
1445         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1446         _;
1447     }
1448 
1449     /**
1450      * @dev Leaves the contract without owner. It will not be possible to call
1451      * `onlyOwner` functions anymore. Can only be called by the current owner.
1452      *
1453      * NOTE: Renouncing ownership will leave the contract without an owner,
1454      * thereby removing any functionality that is only available to the owner.
1455      */
1456     function renounceOwnership() public virtual onlyOwner {
1457         _transferOwnership(address(0));
1458     }
1459 
1460     /**
1461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1462      * Can only be called by the current owner.
1463      */
1464     function transferOwnership(address newOwner) public virtual onlyOwner {
1465         require(newOwner != address(0), "Ownable: new owner is the zero address");
1466         _transferOwnership(newOwner);
1467     }
1468 
1469     /**
1470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1471      * Internal function without access restriction.
1472      */
1473     function _transferOwnership(address newOwner) internal virtual {
1474         address oldOwner = _owner;
1475         _owner = newOwner;
1476         emit OwnershipTransferred(oldOwner, newOwner);
1477     }
1478 }
1479 
1480 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1481 
1482 
1483 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1484 
1485 pragma solidity ^0.8.1;
1486 
1487 /**
1488  * @dev Collection of functions related to the address type
1489  */
1490 library Address {
1491     /**
1492      * @dev Returns true if `account` is a contract.
1493      *
1494      * [IMPORTANT]
1495      * ====
1496      * It is unsafe to assume that an address for which this function returns
1497      * false is an externally-owned account (EOA) and not a contract.
1498      *
1499      * Among others, `isContract` will return false for the following
1500      * types of addresses:
1501      *
1502      *  - an externally-owned account
1503      *  - a contract in construction
1504      *  - an address where a contract will be created
1505      *  - an address where a contract lived, but was destroyed
1506      * ====
1507      *
1508      * [IMPORTANT]
1509      * ====
1510      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1511      *
1512      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1513      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1514      * constructor.
1515      * ====
1516      */
1517     function isContract(address account) internal view returns (bool) {
1518         // This method relies on extcodesize/address.code.length, which returns 0
1519         // for contracts in construction, since the code is only stored at the end
1520         // of the constructor execution.
1521 
1522         return account.code.length > 0;
1523     }
1524 
1525     /**
1526      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1527      * `recipient`, forwarding all available gas and reverting on errors.
1528      *
1529      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1530      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1531      * imposed by `transfer`, making them unable to receive funds via
1532      * `transfer`. {sendValue} removes this limitation.
1533      *
1534      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1535      *
1536      * IMPORTANT: because control is transferred to `recipient`, care must be
1537      * taken to not create reentrancy vulnerabilities. Consider using
1538      * {ReentrancyGuard} or the
1539      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1540      */
1541     function sendValue(address payable recipient, uint256 amount) internal {
1542         require(address(this).balance >= amount, "Address: insufficient balance");
1543 
1544         (bool success, ) = recipient.call{value: amount}("");
1545         require(success, "Address: unable to send value, recipient may have reverted");
1546     }
1547 
1548     /**
1549      * @dev Performs a Solidity function call using a low level `call`. A
1550      * plain `call` is an unsafe replacement for a function call: use this
1551      * function instead.
1552      *
1553      * If `target` reverts with a revert reason, it is bubbled up by this
1554      * function (like regular Solidity function calls).
1555      *
1556      * Returns the raw returned data. To convert to the expected return value,
1557      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1558      *
1559      * Requirements:
1560      *
1561      * - `target` must be a contract.
1562      * - calling `target` with `data` must not revert.
1563      *
1564      * _Available since v3.1._
1565      */
1566     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1567         return functionCall(target, data, "Address: low-level call failed");
1568     }
1569 
1570     /**
1571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1572      * `errorMessage` as a fallback revert reason when `target` reverts.
1573      *
1574      * _Available since v3.1._
1575      */
1576     function functionCall(
1577         address target,
1578         bytes memory data,
1579         string memory errorMessage
1580     ) internal returns (bytes memory) {
1581         return functionCallWithValue(target, data, 0, errorMessage);
1582     }
1583 
1584     /**
1585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1586      * but also transferring `value` wei to `target`.
1587      *
1588      * Requirements:
1589      *
1590      * - the calling contract must have an ETH balance of at least `value`.
1591      * - the called Solidity function must be `payable`.
1592      *
1593      * _Available since v3.1._
1594      */
1595     function functionCallWithValue(
1596         address target,
1597         bytes memory data,
1598         uint256 value
1599     ) internal returns (bytes memory) {
1600         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1601     }
1602 
1603     /**
1604      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1605      * with `errorMessage` as a fallback revert reason when `target` reverts.
1606      *
1607      * _Available since v3.1._
1608      */
1609     function functionCallWithValue(
1610         address target,
1611         bytes memory data,
1612         uint256 value,
1613         string memory errorMessage
1614     ) internal returns (bytes memory) {
1615         require(address(this).balance >= value, "Address: insufficient balance for call");
1616         require(isContract(target), "Address: call to non-contract");
1617 
1618         (bool success, bytes memory returndata) = target.call{value: value}(data);
1619         return verifyCallResult(success, returndata, errorMessage);
1620     }
1621 
1622     /**
1623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1624      * but performing a static call.
1625      *
1626      * _Available since v3.3._
1627      */
1628     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1629         return functionStaticCall(target, data, "Address: low-level static call failed");
1630     }
1631 
1632 //1b0014041a0a15
1633     /**
1634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1635      * but performing a static call.
1636      *
1637      * _Available since v3.3._
1638      */
1639     function functionStaticCall(
1640         address target,
1641         bytes memory data,
1642         string memory errorMessage
1643     ) internal view returns (bytes memory) {
1644         require(isContract(target), "Address: static call to non-contract");
1645 
1646         (bool success, bytes memory returndata) = target.staticcall(data);
1647         return verifyCallResult(success, returndata, errorMessage);
1648     }
1649 
1650     /**
1651      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1652      * but performing a delegate call.
1653      *
1654      * _Available since v3.4._
1655      */
1656     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1657         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1658     }
1659 
1660     /**
1661      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1662      * but performing a delegate call.
1663      *
1664      * _Available since v3.4._
1665      */
1666     function functionDelegateCall(
1667         address target,
1668         bytes memory data,
1669         string memory errorMessage
1670     ) internal returns (bytes memory) {
1671         require(isContract(target), "Address: delegate call to non-contract");
1672 
1673         (bool success, bytes memory returndata) = target.delegatecall(data);
1674         return verifyCallResult(success, returndata, errorMessage);
1675     }
1676 
1677     /**
1678      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1679      * revert reason using the provided one.
1680      *
1681      * _Available since v4.3._
1682      */
1683     function verifyCallResult(
1684         bool success,
1685         bytes memory returndata,
1686         string memory errorMessage
1687     ) internal pure returns (bytes memory) {
1688         if (success) {
1689             return returndata;
1690         } else {
1691             // Look for revert reason and bubble it up if present
1692             if (returndata.length > 0) {
1693                 // The easiest way to bubble the revert reason is using memory via assembly
1694 
1695                 assembly {
1696                     let returndata_size := mload(returndata)
1697                     revert(add(32, returndata), returndata_size)
1698                 }
1699             } else {
1700                 revert(errorMessage);
1701             }
1702         }
1703     }
1704 }
1705 
1706 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1707 
1708 
1709 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1710 
1711 pragma solidity ^0.8.0;
1712 
1713 /**
1714  * @title ERC721 token receiver interface
1715  * @dev Interface for any contract that wants to support safeTransfers
1716  * from ERC721 asset contracts.
1717  */
1718 interface IERC721Receiver {
1719     /**
1720      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1721      * by `operator` from `from`, this function is called.
1722      *
1723      * It must return its Solidity selector to confirm the token transfer.
1724      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1725      *
1726      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1727      */
1728     function onERC721Received(
1729         address operator,
1730         address from,
1731         uint256 tokenId,
1732         bytes calldata data
1733     ) external returns (bytes4);
1734 }
1735 
1736 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1737 
1738 
1739 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1740 
1741 pragma solidity ^0.8.0;
1742 
1743 /**
1744  * @dev Interface of the ERC165 standard, as defined in the
1745  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1746  *
1747  * Implementers can declare support of contract interfaces, which can then be
1748  * queried by others ({ERC165Checker}).
1749  *
1750  * For an implementation, see {ERC165}.
1751  */
1752 interface IERC165 {
1753     /**
1754      * @dev Returns true if this contract implements the interface defined by
1755      * `interfaceId`. See the corresponding
1756      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1757      * to learn more about how these ids are created.
1758      *
1759      * This function call must use less than 30 000 gas.
1760      */
1761     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1762 }
1763 
1764 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1765 
1766 
1767 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1768 
1769 pragma solidity ^0.8.0;
1770 
1771 
1772 /**
1773  * @dev Implementation of the {IERC165} interface.
1774  *
1775  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1776  * for the additional interface id that will be supported. For example:
1777  *
1778  * ```solidity
1779  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1780  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1781  * }
1782  * ```
1783  *
1784  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1785  */
1786 abstract contract ERC165 is IERC165 {
1787     /**
1788      * @dev See {IERC165-supportsInterface}.
1789      */
1790     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1791         return interfaceId == type(IERC165).interfaceId;
1792     }
1793 }
1794 
1795 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1796 
1797 
1798 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1799 
1800 pragma solidity ^0.8.0;
1801 
1802 
1803 /**
1804  * @dev Required interface of an ERC721 compliant contract.
1805  */
1806 interface IERC721 is IERC165 {
1807     /**
1808      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1809      */
1810     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1811 
1812     /**
1813      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1814      */
1815     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1816 
1817     /**
1818      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1819      */
1820     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1821 
1822     /**
1823      * @dev Returns the number of tokens in ``owner``'s account.
1824      */
1825     function balanceOf(address owner) external view returns (uint256 balance);
1826 
1827     /**
1828      * @dev Returns the owner of the `tokenId` token.
1829      *
1830      * Requirements:
1831      *
1832      * - `tokenId` must exist.
1833      */
1834     function ownerOf(uint256 tokenId) external view returns (address owner);
1835 
1836     /**
1837      * @dev Safely transfers `tokenId` token from `from` to `to`.
1838      *
1839      * Requirements:
1840      *
1841      * - `from` cannot be the zero address.
1842      * - `to` cannot be the zero address.
1843      * - `tokenId` token must exist and be owned by `from`.
1844      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1846      *
1847      * Emits a {Transfer} event.
1848      */
1849     function safeTransferFrom(
1850         address from,
1851         address to,
1852         uint256 tokenId,
1853         bytes calldata data
1854     ) external;
1855 
1856     /**
1857      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1858      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1859      *
1860      * Requirements:
1861      *
1862      * - `from` cannot be the zero address.
1863      * - `to` cannot be the zero address.
1864      * - `tokenId` token must exist and be owned by `from`.
1865      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1867      *
1868      * Emits a {Transfer} event.
1869      */
1870     function safeTransferFrom(
1871         address from,
1872         address to,
1873         uint256 tokenId
1874     ) external;
1875 
1876     /**
1877      * @dev Transfers `tokenId` token from `from` to `to`.
1878      *
1879      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1880      *
1881      * Requirements:
1882      *
1883      * - `from` cannot be the zero address.
1884      * - `to` cannot be the zero address.
1885      * - `tokenId` token must be owned by `from`.
1886      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1887      *
1888      * Emits a {Transfer} event.
1889      */
1890     function transferFrom(
1891         address from,
1892         address to,
1893         uint256 tokenId
1894     ) external;
1895 
1896     /**
1897      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1898      * The approval is cleared when the token is transferred.
1899      *
1900      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1901      *
1902      * Requirements:
1903      *
1904      * - The caller must own the token or be an approved operator.
1905      * - `tokenId` must exist.
1906      *
1907      * Emits an {Approval} event.
1908      */
1909     function approve(address to, uint256 tokenId) external;
1910 
1911     /**
1912      * @dev Approve or remove `operator` as an operator for the caller.
1913      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1914      *
1915      * Requirements:
1916      *
1917      * - The `operator` cannot be the caller.
1918      *
1919      * Emits an {ApprovalForAll} event.
1920      */
1921     function setApprovalForAll(address operator, bool _approved) external;
1922 
1923     /**
1924      * @dev Returns the account approved for `tokenId` token.
1925      *
1926      * Requirements:
1927      *
1928      * - `tokenId` must exist.
1929      */
1930     function getApproved(uint256 tokenId) external view returns (address operator);
1931 
1932     /**
1933      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1934      *
1935      * See {setApprovalForAll}
1936      */
1937     function isApprovedForAll(address owner, address operator) external view returns (bool);
1938 }
1939 
1940 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1941 
1942 
1943 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1944 
1945 pragma solidity ^0.8.0;
1946 
1947 
1948 /**
1949  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1950  * @dev See https://eips.ethereum.org/EIPS/eip-721
1951  */
1952 interface IERC721Metadata is IERC721 {
1953     /**
1954      * @dev Returns the token collection name.
1955      */
1956     function name() external view returns (string memory);
1957 
1958     /**
1959      * @dev Returns the token collection symbol.
1960      */
1961     function symbol() external view returns (string memory);
1962 
1963     /**
1964      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1965      */
1966     function tokenURI(uint256 tokenId) external view returns (string memory);
1967 }
1968 
1969 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1970 
1971 
1972 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1973 
1974 pragma solidity ^0.8.0;
1975 
1976 
1977 
1978 
1979 
1980 
1981 
1982 
1983 /**
1984  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1985  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1986  * {ERC721Enumerable}.
1987  */
1988 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1989     using Address for address;
1990     using Strings for uint256;
1991 
1992     // Token name
1993     string private _name;
1994 
1995     // Token symbol
1996     string private _symbol;
1997 
1998     // Mapping from token ID to owner address
1999     mapping(uint256 => address) private _owners;
2000 
2001     // Mapping owner address to token count
2002     mapping(address => uint256) private _balances;
2003 
2004     // Mapping from token ID to approved address
2005     mapping(uint256 => address) private _tokenApprovals;
2006 
2007     // Mapping from owner to operator approvals
2008     mapping(address => mapping(address => bool)) private _operatorApprovals;
2009 
2010     /**
2011      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2012      */
2013     constructor(string memory name_, string memory symbol_) {
2014         _name = name_;
2015         _symbol = symbol_;
2016     }
2017 
2018     /**
2019      * @dev See {IERC165-supportsInterface}.
2020      */
2021     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2022         return
2023             interfaceId == type(IERC721).interfaceId ||
2024             interfaceId == type(IERC721Metadata).interfaceId ||
2025             super.supportsInterface(interfaceId);
2026     }
2027 
2028     /**
2029      * @dev See {IERC721-balanceOf}.
2030      */
2031     function balanceOf(address owner) public view virtual override returns (uint256) {
2032         require(owner != address(0), "ERC721: address zero is not a valid owner");
2033         return _balances[owner];
2034     }
2035 
2036     /**
2037      * @dev See {IERC721-ownerOf}.
2038      */
2039     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2040         address owner = _owners[tokenId];
2041         require(owner != address(0), "ERC721: owner query for nonexistent token");
2042         return owner;
2043     }
2044 
2045     /**
2046      * @dev See {IERC721Metadata-name}.
2047      */
2048     function name() public view virtual override returns (string memory) {
2049         return _name;
2050     }
2051 
2052     /**
2053      * @dev See {IERC721Metadata-symbol}.
2054      */
2055     function symbol() public view virtual override returns (string memory) {
2056         return _symbol;
2057     }
2058 
2059     /**
2060      * @dev See {IERC721Metadata-tokenURI}.
2061      */
2062     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2063         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2064 
2065         string memory baseURI = _baseURI();
2066         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2067     }
2068 
2069     /**
2070      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2071      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2072      * by default, can be overridden in child contracts.
2073      */
2074     function _baseURI() internal view virtual returns (string memory) {
2075         return "";
2076     }
2077 
2078     /**
2079      * @dev See {IERC721-approve}.
2080      */
2081     function approve(address to, uint256 tokenId) public virtual override {
2082         address owner = ERC721.ownerOf(tokenId);
2083         require(to != owner, "ERC721: approval to current owner");
2084 
2085         require(
2086             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2087             "ERC721: approve caller is not owner nor approved for all"
2088         );
2089 
2090         _approve(to, tokenId);
2091     }
2092 
2093     /**
2094      * @dev See {IERC721-getApproved}.
2095      */
2096     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2097         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2098 
2099         return _tokenApprovals[tokenId];
2100     }
2101 
2102     /**
2103      * @dev See {IERC721-setApprovalForAll}.
2104      */
2105     function setApprovalForAll(address operator, bool approved) public virtual override {
2106         _setApprovalForAll(_msgSender(), operator, approved);
2107     }
2108 
2109     /**
2110      * @dev See {IERC721-isApprovedForAll}.
2111      */
2112     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2113         return _operatorApprovals[owner][operator];
2114     }
2115 
2116     /**
2117      * @dev See {IERC721-transferFrom}.
2118      */
2119     function transferFrom(
2120         address from,
2121         address to,
2122         uint256 tokenId
2123     ) public virtual override {
2124         //solhint-disable-next-line max-line-length
2125         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2126 
2127         _transfer(from, to, tokenId);
2128     }
2129 
2130     /**
2131      * @dev See {IERC721-safeTransferFrom}.
2132      */
2133     function safeTransferFrom(
2134         address from,
2135         address to,
2136         uint256 tokenId
2137     ) public virtual override {
2138         safeTransferFrom(from, to, tokenId, "");
2139     }
2140 
2141     /**
2142      * @dev See {IERC721-safeTransferFrom}.
2143      */
2144     function safeTransferFrom(
2145         address from,
2146         address to,
2147         uint256 tokenId,
2148         bytes memory data
2149     ) public virtual override {
2150         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2151         _safeTransfer(from, to, tokenId, data);
2152     }
2153 
2154     /**
2155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2157      *
2158      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2159      *
2160      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2161      * implement alternative mechanisms to perform token transfer, such as signature-based.
2162      *
2163      * Requirements:
2164      *
2165      * - `from` cannot be the zero address.
2166      * - `to` cannot be the zero address.
2167      * - `tokenId` token must exist and be owned by `from`.
2168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2169      *
2170      * Emits a {Transfer} event.
2171      */
2172     function _safeTransfer(
2173         address from,
2174         address to,
2175         uint256 tokenId,
2176         bytes memory data
2177     ) internal virtual {
2178         _transfer(from, to, tokenId);
2179         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2180     }
2181 
2182     /**
2183      * @dev Returns whether `tokenId` exists.
2184      *
2185      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2186      *
2187      * Tokens start existing when they are minted (`_mint`),
2188      * and stop existing when they are burned (`_burn`).
2189      */
2190     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2191         return _owners[tokenId] != address(0);
2192     }
2193 
2194     /**
2195      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2196      *
2197      * Requirements:
2198      *
2199      * - `tokenId` must exist.
2200      */
2201     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2202         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2203         address owner = ERC721.ownerOf(tokenId);
2204         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2205     }
2206 
2207     /**
2208      * @dev Safely mints `tokenId` and transfers it to `to`.
2209      *
2210      * Requirements:
2211      *
2212      * - `tokenId` must not exist.
2213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2214      *
2215      * Emits a {Transfer} event.
2216      */
2217     function _safeMint(address to, uint256 tokenId) internal virtual {
2218         _safeMint(to, tokenId, "");
2219     }
2220 
2221     /**
2222      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2223      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2224      */
2225     function _safeMint(
2226         address to,
2227         uint256 tokenId,
2228         bytes memory data
2229     ) internal virtual {
2230         _mint(to, tokenId);
2231         require(
2232             _checkOnERC721Received(address(0), to, tokenId, data),
2233             "ERC721: transfer to non ERC721Receiver implementer"
2234         );
2235     }
2236 
2237     /**
2238      * @dev Mints `tokenId` and transfers it to `to`.
2239      *
2240      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2241      *
2242      * Requirements:
2243      *
2244      * - `tokenId` must not exist.
2245      * - `to` cannot be the zero address.
2246      *
2247      * Emits a {Transfer} event.
2248      */
2249     function _mint(address to, uint256 tokenId) internal virtual {
2250         require(to != address(0), "ERC721: mint to the zero address");
2251         require(!_exists(tokenId), "ERC721: token already minted");
2252 
2253         _beforeTokenTransfer(address(0), to, tokenId);
2254 
2255         _balances[to] += 1;
2256         _owners[tokenId] = to;
2257 
2258         emit Transfer(address(0), to, tokenId);
2259 
2260         _afterTokenTransfer(address(0), to, tokenId);
2261     }
2262 
2263     /**
2264      * @dev Destroys `tokenId`.
2265      * The approval is cleared when the token is burned.
2266      *
2267      * Requirements:
2268      *
2269      * - `tokenId` must exist.
2270      *
2271      * Emits a {Transfer} event.
2272      */
2273     function _burn(uint256 tokenId) internal virtual {
2274         address owner = ERC721.ownerOf(tokenId);
2275 
2276         _beforeTokenTransfer(owner, address(0), tokenId);
2277 
2278         // Clear approvals
2279         _approve(address(0), tokenId);
2280 
2281         _balances[owner] -= 1;
2282         delete _owners[tokenId];
2283 
2284         emit Transfer(owner, address(0), tokenId);
2285 
2286         _afterTokenTransfer(owner, address(0), tokenId);
2287     }
2288 
2289     /**
2290      * @dev Transfers `tokenId` from `from` to `to`.
2291      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2292      *
2293      * Requirements:
2294      *
2295      * - `to` cannot be the zero address.
2296      * - `tokenId` token must be owned by `from`.
2297      *
2298      * Emits a {Transfer} event.
2299      */
2300     function _transfer(
2301         address from,
2302         address to,
2303         uint256 tokenId
2304     ) internal virtual {
2305         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2306         require(to != address(0), "ERC721: transfer to the zero address");
2307 
2308         _beforeTokenTransfer(from, to, tokenId);
2309 
2310         // Clear approvals from the previous owner
2311         _approve(address(0), tokenId);
2312 
2313         _balances[from] -= 1;
2314         _balances[to] += 1;
2315         _owners[tokenId] = to;
2316 
2317         emit Transfer(from, to, tokenId);
2318 
2319         _afterTokenTransfer(from, to, tokenId);
2320     }
2321 
2322     /**
2323      * @dev Approve `to` to operate on `tokenId`
2324      *
2325      * Emits an {Approval} event.
2326      */
2327     function _approve(address to, uint256 tokenId) internal virtual {
2328         _tokenApprovals[tokenId] = to;
2329         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2330     }
2331 
2332     /**
2333      * @dev Approve `operator` to operate on all of `owner` tokens
2334      *
2335      * Emits an {ApprovalForAll} event.
2336      */
2337     function _setApprovalForAll(
2338         address owner,
2339         address operator,
2340         bool approved
2341     ) internal virtual {
2342         require(owner != operator, "ERC721: approve to caller");
2343         _operatorApprovals[owner][operator] = approved;
2344         emit ApprovalForAll(owner, operator, approved);
2345     }
2346 
2347     /**
2348      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2349      * The call is not executed if the target address is not a contract.
2350      *
2351      * @param from address representing the previous owner of the given token ID
2352      * @param to target address that will receive the tokens
2353      * @param tokenId uint256 ID of the token to be transferred
2354      * @param data bytes optional data to send along with the call
2355      * @return bool whether the call correctly returned the expected magic value
2356      */
2357     function _checkOnERC721Received(
2358         address from,
2359         address to,
2360         uint256 tokenId,
2361         bytes memory data
2362     ) private returns (bool) {
2363         if (to.isContract()) {
2364             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2365                 return retval == IERC721Receiver.onERC721Received.selector;
2366             } catch (bytes memory reason) {
2367                 if (reason.length == 0) {
2368                     revert("ERC721: transfer to non ERC721Receiver implementer");
2369                 } else {
2370                     assembly {
2371                         revert(add(32, reason), mload(reason))
2372                     }
2373                 }
2374             }
2375         } else {
2376             return true;
2377         }
2378     }
2379     //sf852022
2380     /**
2381      * @dev Hook that is called before any token transfer. This includes minting
2382      * and burning.
2383      *
2384      * Calling conditions:
2385      *
2386      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2387      * transferred to `to`.
2388      * - When `from` is zero, `tokenId` will be minted for `to`.
2389      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2390      * - `from` and `to` are never both zero.
2391      *
2392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2393      */
2394     function _beforeTokenTransfer(
2395         address from,
2396         address to,
2397         uint256 tokenId
2398     ) internal virtual {}
2399 
2400     /**
2401      * @dev Hook that is called after any transfer of tokens. This includes
2402      * minting and burning.
2403      *
2404      * Calling conditions:
2405      *
2406      * - when `from` and `to` are both non-zero.
2407      * - `from` and `to` are never both zero.
2408      *
2409      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2410      */
2411     function _afterTokenTransfer(
2412         address from,
2413         address to,
2414         uint256 tokenId
2415     ) internal virtual {}
2416 }
2417 
2418 
2419 
2420 
2421 pragma solidity ^0.8.0;
2422 
2423 
2424 
2425 
2426 contract PenguinTown is ERC721A, Ownable {
2427     using Strings for uint256;
2428 
2429     string private baseURI;
2430 
2431     uint256 public price = 0.0077 ether;
2432 
2433    
2434 
2435     uint256 public maxPerWallet = 2;
2436     string public hiddenURI="ipfs://QmdEkaBfRZVJ11BiJ4VZhuZnXxiFZ4n8t1AijWT9tgVpvJ";
2437     bool public revealed = false;
2438    
2439     
2440 
2441     uint256 public maxSupply = 999;
2442 
2443     bool public whitelistSale = false;
2444     
2445     bool public publicEnabled = false;
2446     
2447     bytes32 whitelistRoot;
2448   
2449 
2450   
2451     
2452     constructor() ERC721A("Penguin Town", "PT") {
2453         
2454         
2455     }
2456 
2457 function whitelistMint(bytes32[] calldata _merkleProof,uint256 count) external payable {
2458         
2459        
2460        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2461 
2462      
2463         
2464         require(MerkleProof.verify(_merkleProof, whitelistRoot, leaf),"Incorrect Whitelist Proof");
2465         require(msg.value >= price * count, "Please send the exact amount.");
2466         require(numberMinted(msg.sender)+ count <=maxPerWallet,"You cant mint anymore");
2467         require(totalSupply() + count <= maxSupply , "No more");
2468         require(count>0,"Please enter a number");
2469         require(whitelistSale, "Minting is not live yet");
2470       
2471 
2472 
2473         
2474 
2475         _safeMint(msg.sender, count);
2476     }
2477 
2478 function publicMint(uint256 count) external payable {
2479        
2480 
2481         require(msg.value >= count * price, "Please send the exact amount.");
2482         require(numberMinted(msg.sender)+ count <=maxPerWallet,"You cant mint anymore");
2483         require(totalSupply() + count <= maxSupply , "No more");
2484         require(count>0,"Please enter a number");
2485         require(publicEnabled, "Minting is not live yet");
2486         
2487        
2488 
2489         
2490 
2491         _safeMint(msg.sender, count);
2492     }
2493 
2494     function _baseURI() internal view virtual override returns (string memory) {
2495         return baseURI;
2496     }
2497    
2498      function tokenURI(uint256 tokenId)
2499     public
2500     view
2501     virtual
2502     override
2503     returns (string memory)
2504   {
2505     require(
2506       _exists(tokenId),
2507       "ERC721AMetadata: URI query for nonexistent token"
2508     );
2509      if (revealed == false) {
2510       return hiddenURI;
2511     }
2512 
2513     string memory currentBaseURI = _baseURI();
2514     return bytes(currentBaseURI).length > 0
2515         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2516         : "";
2517   }
2518   
2519 
2520     function setBaseURI(string memory uri) public onlyOwner {
2521         baseURI = uri;
2522     }
2523     function setHiddenURI(string memory uri) public onlyOwner {
2524         hiddenURI = uri;
2525     }
2526 
2527 
2528     function setMaxPerWallet(uint256 amount) external onlyOwner {
2529         maxPerWallet = amount;
2530     }
2531     function setPrice(uint256 _newPrice) external onlyOwner {
2532         price = _newPrice;
2533     }
2534 
2535     function setMaxSupply(uint256 _newSupply) external onlyOwner {
2536         maxSupply = _newSupply;
2537     }
2538    
2539     function flipWhitelist(bool status) external onlyOwner {
2540         whitelistSale = status;
2541     }
2542    
2543     function flipPublic(bool status) external onlyOwner {
2544         
2545         publicEnabled = status;
2546     }
2547     function reveal() external onlyOwner {
2548     revealed = !revealed;
2549    
2550   }
2551      function setWhitelistRoot(bytes32 _presaleRoot_1)
2552         external
2553         onlyOwner
2554     {  
2555         whitelistRoot = _presaleRoot_1;
2556        
2557     }
2558      function numberMinted(address owner) public view returns (uint256) {
2559         return _numberMinted(owner);
2560     }
2561  function batchmint(uint256 _mintAmount, address destination) public onlyOwner {
2562     require(_mintAmount > 0, "need to mint at least 1 NFT");
2563     uint256 supply = totalSupply();
2564     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2565 
2566       _safeMint(destination, _mintAmount);
2567     
2568   }
2569     function withdraw() external onlyOwner {
2570         (bool success, ) = payable(msg.sender).call{
2571             value: address(this).balance
2572         }("");
2573         require(success, "Transfer failed.");
2574     }
2575 }