1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
8 
9 
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Contract module that helps prevent reentrant calls to a function.
15  *
16  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
17  * available, which can be applied to functions to make sure there are no nested
18  * (reentrant) calls to them.
19  *
20  * Note that because there is a single `nonReentrant` guard, functions marked as
21  * `nonReentrant` may not call one another. This can be worked around by making
22  * those functions `private`, and then adding `external` `nonReentrant` entry
23  * points to them.
24  *
25  * TIP: If you would like to learn more about reentrancy and alternative ways
26  * to protect against it, check out our blog post
27  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
28  */
29 abstract contract ReentrancyGuard {
30     // Booleans are more expensive than uint256 or any type that takes up a full
31     // word because each write operation emits an extra SLOAD to first read the
32     // slot's contents, replace the bits taken up by the boolean, and then write
33     // back. This is the compiler's defense against contract upgrades and
34     // pointer aliasing, and it cannot be disabled.
35 
36     // The values being non-zero value makes deployment a bit more expensive,
37     // but in exchange the refund on every call to nonReentrant will be lower in
38     // amount. Since refunds are capped to a percentage of the total
39     // transaction's gas, it is best to keep them low in cases like this one, to
40     // increase the likelihood of the full refund coming into effect.
41     uint256 private constant _NOT_ENTERED = 1;
42     uint256 private constant _ENTERED = 2;
43 
44     uint256 private _status;
45 
46     constructor() {
47         _status = _NOT_ENTERED;
48     }
49 
50     /**
51      * @dev Prevents a contract from calling itself, directly or indirectly.
52      * Calling a `nonReentrant` function from another `nonReentrant`
53      * function is not supported. It is possible to prevent this from happening
54      * by making the `nonReentrant` function external, and making it call a
55      * `private` function that does the actual work.
56      */
57     modifier nonReentrant() {
58         // On the first call to nonReentrant, _notEntered will be true
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63 
64         _;
65 
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 }
71 
72 // File: contracts/witch.sol
73 
74 
75 
76 
77 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev These functions deal with verification of Merkle Tree proofs.
86  *
87  * The proofs can be generated using the JavaScript library
88  * https://github.com/miguelmota/merkletreejs[merkletreejs].
89  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
90  *
91  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
92  *
93  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
94  * hashing, or use a hash function other than keccak256 for hashing leaves.
95  * This is because the concatenation of a sorted pair of internal nodes in
96  * the merkle tree could be reinterpreted as a leaf value.
97  */
98 library MerkleProof {
99     /**
100      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
101      * defined by `root`. For this, a `proof` must be provided, containing
102      * sibling hashes on the branch from the leaf to the root of the tree. Each
103      * pair of leaves and each pair of pre-images are assumed to be sorted.
104      */
105     function verify(
106         bytes32[] memory proof,
107         bytes32 root,
108         bytes32 leaf
109     ) internal pure returns (bool) {
110         return processProof(proof, leaf) == root;
111     }
112 
113     /**
114      * @dev Calldata version of {verify}
115      *
116      * _Available since v4.7._
117      */
118     function verifyCalldata(
119         bytes32[] calldata proof,
120         bytes32 root,
121         bytes32 leaf
122     ) internal pure returns (bool) {
123         return processProofCalldata(proof, leaf) == root;
124     }
125 
126     /**
127      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
128      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
129      * hash matches the root of the tree. When processing the proof, the pairs
130      * of leafs & pre-images are assumed to be sorted.
131      *
132      * _Available since v4.4._
133      */
134     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
135         bytes32 computedHash = leaf;
136         for (uint256 i = 0; i < proof.length; i++) {
137             computedHash = _hashPair(computedHash, proof[i]);
138         }
139         return computedHash;
140     }
141 
142     /**
143      * @dev Calldata version of {processProof}
144      *
145      * _Available since v4.7._
146      */
147     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
148         bytes32 computedHash = leaf;
149         for (uint256 i = 0; i < proof.length; i++) {
150             computedHash = _hashPair(computedHash, proof[i]);
151         }
152         return computedHash;
153     }
154 
155     /**
156      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
157      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
158      *
159      * _Available since v4.7._
160      */
161     function multiProofVerify(
162         bytes32[] memory proof,
163         bool[] memory proofFlags,
164         bytes32 root,
165         bytes32[] memory leaves
166     ) internal pure returns (bool) {
167         return processMultiProof(proof, proofFlags, leaves) == root;
168     }
169 
170     /**
171      * @dev Calldata version of {multiProofVerify}
172      *
173      * _Available since v4.7._
174      */
175     function multiProofVerifyCalldata(
176         bytes32[] calldata proof,
177         bool[] calldata proofFlags,
178         bytes32 root,
179         bytes32[] memory leaves
180     ) internal pure returns (bool) {
181         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
182     }
183 
184     /**
185      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
186      * consuming from one or the other at each step according to the instructions given by
187      * `proofFlags`.
188      *
189      * _Available since v4.7._
190      */
191     function processMultiProof(
192         bytes32[] memory proof,
193         bool[] memory proofFlags,
194         bytes32[] memory leaves
195     ) internal pure returns (bytes32 merkleRoot) {
196         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
197         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
198         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
199         // the merkle tree.
200         uint256 leavesLen = leaves.length;
201         uint256 totalHashes = proofFlags.length;
202 
203         // Check proof validity.
204         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
205 
206         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
207         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
208         bytes32[] memory hashes = new bytes32[](totalHashes);
209         uint256 leafPos = 0;
210         uint256 hashPos = 0;
211         uint256 proofPos = 0;
212         // At each step, we compute the next hash using two values:
213         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
214         //   get the next hash.
215         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
216         //   `proof` array.
217         for (uint256 i = 0; i < totalHashes; i++) {
218             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
219             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
220             hashes[i] = _hashPair(a, b);
221         }
222 
223         if (totalHashes > 0) {
224             return hashes[totalHashes - 1];
225         } else if (leavesLen > 0) {
226             return leaves[0];
227         } else {
228             return proof[0];
229         }
230     }
231 
232     /**
233      * @dev Calldata version of {processMultiProof}
234      *
235      * _Available since v4.7._
236      */
237     function processMultiProofCalldata(
238         bytes32[] calldata proof,
239         bool[] calldata proofFlags,
240         bytes32[] memory leaves
241     ) internal pure returns (bytes32 merkleRoot) {
242         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
243         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
244         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
245         // the merkle tree.
246         uint256 leavesLen = leaves.length;
247         uint256 totalHashes = proofFlags.length;
248 
249         // Check proof validity.
250         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
251 
252         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
253         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
254         bytes32[] memory hashes = new bytes32[](totalHashes);
255         uint256 leafPos = 0;
256         uint256 hashPos = 0;
257         uint256 proofPos = 0;
258         // At each step, we compute the next hash using two values:
259         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
260         //   get the next hash.
261         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
262         //   `proof` array.
263         for (uint256 i = 0; i < totalHashes; i++) {
264             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
265             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
266             hashes[i] = _hashPair(a, b);
267         }
268 
269         if (totalHashes > 0) {
270             return hashes[totalHashes - 1];
271         } else if (leavesLen > 0) {
272             return leaves[0];
273         } else {
274             return proof[0];
275         }
276     }
277 
278     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
279         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
280     }
281 
282     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
283         /// @solidity memory-safe-assembly
284         assembly {
285             mstore(0x00, a)
286             mstore(0x20, b)
287             value := keccak256(0x00, 0x40)
288         }
289     }
290 }
291 
292 // File: contracts/witch.sol
293 
294 
295 
296 
297 pragma solidity ^0.8.4;
298 
299 /**
300  * @dev Interface of an ERC721A compliant contract.
301  */
302 interface IERC721A {
303     /**
304      * The caller must own the token or be an approved operator.
305      */
306     error ApprovalCallerNotOwnerNorApproved();
307 
308     /**
309      * The token does not exist.
310      */
311     error ApprovalQueryForNonexistentToken();
312 
313     /**
314      * The caller cannot approve to their own address.
315      */
316     error ApproveToCaller();
317 
318     /**
319      * The caller cannot approve to the current owner.
320      */
321     error ApprovalToCurrentOwner();
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
354      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
355      */
356     error TransferToNonERC721ReceiverImplementer();
357 
358     /**
359      * Cannot transfer to the zero address.
360      */
361     error TransferToZeroAddress();
362 
363     /**
364      * The token does not exist.
365      */
366     error URIQueryForNonexistentToken();
367 
368     struct TokenOwnership {
369         // The address of the owner.
370         address addr;
371         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
372         uint64 startTimestamp;
373         // Whether the token has been burned.
374         bool burned;
375     }
376 
377     /**
378      * @dev Returns the total amount of tokens stored by the contract.
379      *
380      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
381      */
382     function totalSupply() external view returns (uint256);
383 
384     // ==============================
385     //            IERC165
386     // ==============================
387 
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30 000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 
398     // ==============================
399     //            IERC721
400     // ==============================
401 
402     /**
403      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
409      */
410     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
414      */
415     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
416 
417     /**
418      * @dev Returns the number of tokens in ``owner``'s account.
419      */
420     function balanceOf(address owner) external view returns (uint256 balance);
421 
422     /**
423      * @dev Returns the owner of the `tokenId` token.
424      *
425      * Requirements:
426      *
427      * - `tokenId` must exist.
428      */
429     function ownerOf(uint256 tokenId) external view returns (address owner);
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId,
448         bytes calldata data
449     ) external;
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
453      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Transfers `tokenId` token from `from` to `to`.
473      *
474      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must be owned by `from`.
481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
493      * The approval is cleared when the token is transferred.
494      *
495      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
496      *
497      * Requirements:
498      *
499      * - The caller must own the token or be an approved operator.
500      * - `tokenId` must exist.
501      *
502      * Emits an {Approval} event.
503      */
504     function approve(address to, uint256 tokenId) external;
505 
506     /**
507      * @dev Approve or remove `operator` as an operator for the caller.
508      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
509      *
510      * Requirements:
511      *
512      * - The `operator` cannot be the caller.
513      *
514      * Emits an {ApprovalForAll} event.
515      */
516     function setApprovalForAll(address operator, bool _approved) external;
517 
518     /**
519      * @dev Returns the account approved for `tokenId` token.
520      *
521      * Requirements:
522      *
523      * - `tokenId` must exist.
524      */
525     function getApproved(uint256 tokenId) external view returns (address operator);
526 
527     /**
528      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
529      *
530      * See {setApprovalForAll}
531      */
532     function isApprovedForAll(address owner, address operator) external view returns (bool);
533 
534     // ==============================
535     //        IERC721Metadata
536     // ==============================
537 
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
555 
556 
557 // ERC721A Contracts v3.3.0
558 // Creator: Chiru Labs
559 
560 pragma solidity ^0.8.4;
561 
562 
563 /**
564  * @dev ERC721 token receiver interface.
565  */
566 interface ERC721A__IERC721Receiver {
567     function onERC721Received(
568         address operator,
569         address from,
570         uint256 tokenId,
571         bytes calldata data
572     ) external returns (bytes4);
573 }
574 
575 /**
576  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
577  * the Metadata extension. Built to optimize for lower gas during batch mints.
578  *
579  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
580  *
581  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
582  *
583  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
584  */
585 contract ERC721A is IERC721A {
586     // Mask of an entry in packed address data.
587     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
588 
589     // The bit position of `numberMinted` in packed address data.
590     uint256 private constant BITPOS_NUMBER_MINTED = 64;
591 
592     // The bit position of `numberBurned` in packed address data.
593     uint256 private constant BITPOS_NUMBER_BURNED = 128;
594 
595     // The bit position of `aux` in packed address data.
596     uint256 private constant BITPOS_AUX = 192;
597 
598     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
599     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
600 
601     // The bit position of `startTimestamp` in packed ownership.
602     uint256 private constant BITPOS_START_TIMESTAMP = 160;
603 
604     // The bit mask of the `burned` bit in packed ownership.
605     uint256 private constant BITMASK_BURNED = 1 << 224;
606     
607     // The bit position of the `nextInitialized` bit in packed ownership.
608     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
609 
610     // The bit mask of the `nextInitialized` bit in packed ownership.
611     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
612 
613     // The tokenId of the next token to be minted.
614     uint256 private _currentIndex;
615 
616     // The number of tokens burned.
617     uint256 private _burnCounter;
618 
619     // Token name
620     string private _name;
621 
622     // Token symbol
623     string private _symbol;
624 
625     // Mapping from token ID to ownership details
626     // An empty struct value does not necessarily mean the token is unowned.
627     // See `_packedOwnershipOf` implementation for details.
628     //
629     // Bits Layout:
630     // - [0..159]   `addr`
631     // - [160..223] `startTimestamp`
632     // - [224]      `burned`
633     // - [225]      `nextInitialized`
634     mapping(uint256 => uint256) private _packedOwnerships;
635 
636     // Mapping owner address to address data.
637     //
638     // Bits Layout:
639     // - [0..63]    `balance`
640     // - [64..127]  `numberMinted`
641     // - [128..191] `numberBurned`
642     // - [192..255] `aux`
643     mapping(address => uint256) private _packedAddressData;
644 
645     // Mapping from token ID to approved address.
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     constructor(string memory name_, string memory symbol_) {
652         _name = name_;
653         _symbol = symbol_;
654         _currentIndex = _startTokenId();
655     }
656 
657     /**
658      * @dev Returns the starting token ID. 
659      * To change the starting token ID, please override this function.
660      */
661     function _startTokenId() internal view virtual returns (uint256) {
662         return 0;
663     }
664 
665     /**
666      * @dev Returns the next token ID to be minted.
667      */
668     function _nextTokenId() internal view returns (uint256) {
669         return _currentIndex;
670     }
671 
672     /**
673      * @dev Returns the total number of tokens in existence.
674      * Burned tokens will reduce the count. 
675      * To get the total number of tokens minted, please see `_totalMinted`.
676      */
677     function totalSupply() public view override returns (uint256) {
678         // Counter underflow is impossible as _burnCounter cannot be incremented
679         // more than `_currentIndex - _startTokenId()` times.
680         unchecked {
681             return _currentIndex - _burnCounter - _startTokenId();
682         }
683     }
684 
685     /**
686      * @dev Returns the total amount of tokens minted in the contract.
687      */
688     function _totalMinted() internal view returns (uint256) {
689         // Counter underflow is impossible as _currentIndex does not decrement,
690         // and it is initialized to `_startTokenId()`
691         unchecked {
692             return _currentIndex - _startTokenId();
693         }
694     }
695 
696     /**
697      * @dev Returns the total number of tokens burned.
698      */
699     function _totalBurned() internal view returns (uint256) {
700         return _burnCounter;
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         // The interface IDs are constants representing the first 4 bytes of the XOR of
708         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
709         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
710         return
711             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
712             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
713             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
714     }
715 
716     /**
717      * @dev See {IERC721-balanceOf}.
718      */
719     function balanceOf(address owner) public view override returns (uint256) {
720         if (owner == address(0)) revert BalanceQueryForZeroAddress();
721         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
722     }
723 
724     /**
725      * Returns the number of tokens minted by `owner`.
726      */
727     function _numberMinted(address owner) internal view returns (uint256) {
728         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
729     }
730 
731     /**
732      * Returns the number of tokens burned by or on behalf of `owner`.
733      */
734     function _numberBurned(address owner) internal view returns (uint256) {
735         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
736     }
737 
738     /**
739      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
740      */
741     function _getAux(address owner) internal view returns (uint64) {
742         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
743     }
744 
745     /**
746      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
747      * If there are multiple variables, please pack them into a uint64.
748      */
749     function _setAux(address owner, uint64 aux) internal {
750         uint256 packed = _packedAddressData[owner];
751         uint256 auxCasted;
752         assembly { // Cast aux without masking.
753             auxCasted := aux
754         }
755         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
756         _packedAddressData[owner] = packed;
757     }
758 
759     /**
760      * Returns the packed ownership data of `tokenId`.
761      */
762     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
763         uint256 curr = tokenId;
764 
765         unchecked {
766             if (_startTokenId() <= curr)
767                 if (curr < _currentIndex) {
768                     uint256 packed = _packedOwnerships[curr];
769                     // If not burned.
770                     if (packed & BITMASK_BURNED == 0) {
771                         // Invariant:
772                         // There will always be an ownership that has an address and is not burned
773                         // before an ownership that does not have an address and is not burned.
774                         // Hence, curr will not underflow.
775                         //
776                         // We can directly compare the packed value.
777                         // If the address is zero, packed is zero.
778                         while (packed == 0) {
779                             packed = _packedOwnerships[--curr];
780                         }
781                         return packed;
782                     }
783                 }
784         }
785         revert OwnerQueryForNonexistentToken();
786     }
787 
788     /**
789      * Returns the unpacked `TokenOwnership` struct from `packed`.
790      */
791     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
792         ownership.addr = address(uint160(packed));
793         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
794         ownership.burned = packed & BITMASK_BURNED != 0;
795     }
796 
797     /**
798      * Returns the unpacked `TokenOwnership` struct at `index`.
799      */
800     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
801         return _unpackedOwnership(_packedOwnerships[index]);
802     }
803 
804     /**
805      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
806      */
807     function _initializeOwnershipAt(uint256 index) internal {
808         if (_packedOwnerships[index] == 0) {
809             _packedOwnerships[index] = _packedOwnershipOf(index);
810         }
811     }
812 
813     /**
814      * Gas spent here starts off proportional to the maximum mint batch size.
815      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
816      */
817     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
818         return _unpackedOwnership(_packedOwnershipOf(tokenId));
819     }
820 
821     /**
822      * @dev See {IERC721-ownerOf}.
823      */
824     function ownerOf(uint256 tokenId) public view override returns (address) {
825         return address(uint160(_packedOwnershipOf(tokenId)));
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     /**
862      * @dev Casts the address to uint256 without masking.
863      */
864     function _addressToUint256(address value) private pure returns (uint256 result) {
865         assembly {
866             result := value
867         }
868     }
869 
870     /**
871      * @dev Casts the boolean to uint256 without branching.
872      */
873     function _boolToUint256(bool value) private pure returns (uint256 result) {
874         assembly {
875             result := value
876         }
877     }
878 
879     /**
880      * @dev See {IERC721-approve}.
881      */
882     function approve(address to, uint256 tokenId) public override {
883         address owner = address(uint160(_packedOwnershipOf(tokenId)));
884         if (to == owner) revert ApprovalToCurrentOwner();
885 
886         if (_msgSenderERC721A() != owner)
887             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
888                 revert ApprovalCallerNotOwnerNorApproved();
889             }
890 
891         _tokenApprovals[tokenId] = to;
892         emit Approval(owner, to, tokenId);
893     }
894 
895     /**
896      * @dev See {IERC721-getApproved}.
897      */
898     function getApproved(uint256 tokenId) public view override returns (address) {
899         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
900 
901         return _tokenApprovals[tokenId];
902     }
903 
904     /**
905      * @dev See {IERC721-setApprovalForAll}.
906      */
907     function setApprovalForAll(address operator, bool approved) public virtual override {
908         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
909 
910         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
911         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
912     }
913 
914     /**
915      * @dev See {IERC721-isApprovedForAll}.
916      */
917     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         _transfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         safeTransferFrom(from, to, tokenId, '');
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) public virtual override {
952         _transfer(from, to, tokenId);
953         if (to.code.length != 0)
954             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
955                 revert TransferToNonERC721ReceiverImplementer();
956             }
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return
968             _startTokenId() <= tokenId &&
969             tokenId < _currentIndex && // If within bounds,
970             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
971     }
972 
973     /**
974      * @dev Equivalent to `_safeMint(to, quantity, '')`.
975      */
976     function _safeMint(address to, uint256 quantity) internal {
977         _safeMint(to, quantity, '');
978     }
979 
980     /**
981      * @dev Safely mints `quantity` tokens and transfers them to `to`.
982      *
983      * Requirements:
984      *
985      * - If `to` refers to a smart contract, it must implement
986      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
987      * - `quantity` must be greater than 0.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(
992         address to,
993         uint256 quantity,
994         bytes memory _data
995     ) internal {
996         uint256 startTokenId = _currentIndex;
997         if (to == address(0)) revert MintToZeroAddress();
998         if (quantity == 0) revert MintZeroQuantity();
999 
1000         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1001 
1002         // Overflows are incredibly unrealistic.
1003         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1004         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1005         unchecked {
1006             // Updates:
1007             // - `balance += quantity`.
1008             // - `numberMinted += quantity`.
1009             //
1010             // We can directly add to the balance and number minted.
1011             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1012 
1013             // Updates:
1014             // - `address` to the owner.
1015             // - `startTimestamp` to the timestamp of minting.
1016             // - `burned` to `false`.
1017             // - `nextInitialized` to `quantity == 1`.
1018             _packedOwnerships[startTokenId] =
1019                 _addressToUint256(to) |
1020                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1021                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1022 
1023             uint256 updatedIndex = startTokenId;
1024             uint256 end = updatedIndex + quantity;
1025 
1026             if (to.code.length != 0) {
1027                 do {
1028                     emit Transfer(address(0), to, updatedIndex);
1029                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1030                         revert TransferToNonERC721ReceiverImplementer();
1031                     }
1032                 } while (updatedIndex < end);
1033                 // Reentrancy protection
1034                 if (_currentIndex != startTokenId) revert();
1035             } else {
1036                 do {
1037                     emit Transfer(address(0), to, updatedIndex++);
1038                 } while (updatedIndex < end);
1039             }
1040             _currentIndex = updatedIndex;
1041         }
1042         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1043     }
1044 
1045     
1046 
1047     /**
1048      * @dev Mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 quantity) internal {
1058         uint256 startTokenId = _currentIndex;
1059         if (to == address(0)) revert MintToZeroAddress();
1060         if (quantity == 0) revert MintZeroQuantity();
1061 
1062         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1063 
1064         // Overflows are incredibly unrealistic.
1065         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1066         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1067         unchecked {
1068             // Updates:
1069             // - `balance += quantity`.
1070             // - `numberMinted += quantity`.
1071             //
1072             // We can directly add to the balance and number minted.
1073             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1074 
1075             // Updates:
1076             // - `address` to the owner.
1077             // - `startTimestamp` to the timestamp of minting.
1078             // - `burned` to `false`.
1079             // - `nextInitialized` to `quantity == 1`.
1080             _packedOwnerships[startTokenId] =
1081                 _addressToUint256(to) |
1082                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1083                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1084 
1085             uint256 updatedIndex = startTokenId;
1086             uint256 end = updatedIndex + quantity;
1087 
1088             do {
1089                 emit Transfer(address(0), to, updatedIndex++);
1090             } while (updatedIndex < end);
1091 
1092             _currentIndex = updatedIndex;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1113 
1114         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1115 
1116         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1117             isApprovedForAll(from, _msgSenderERC721A()) ||
1118             getApproved(tokenId) == _msgSenderERC721A());
1119 
1120         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1121         if (to == address(0)) revert TransferToZeroAddress();
1122 
1123         _beforeTokenTransfers(from, to, tokenId, 1);
1124 
1125         // Clear approvals from the previous owner.
1126         delete _tokenApprovals[tokenId];
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1131         unchecked {
1132             // We can directly increment and decrement the balances.
1133             --_packedAddressData[from]; // Updates: `balance -= 1`.
1134             ++_packedAddressData[to]; // Updates: `balance += 1`.
1135 
1136             // Updates:
1137             // - `address` to the next owner.
1138             // - `startTimestamp` to the timestamp of transfering.
1139             // - `burned` to `false`.
1140             // - `nextInitialized` to `true`.
1141             _packedOwnerships[tokenId] =
1142                 _addressToUint256(to) |
1143                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1144                 BITMASK_NEXT_INITIALIZED;
1145 
1146             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1147             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1148                 uint256 nextTokenId = tokenId + 1;
1149                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1150                 if (_packedOwnerships[nextTokenId] == 0) {
1151                     // If the next slot is within bounds.
1152                     if (nextTokenId != _currentIndex) {
1153                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1154                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1155                     }
1156                 }
1157             }
1158         }
1159 
1160         emit Transfer(from, to, tokenId);
1161         _afterTokenTransfers(from, to, tokenId, 1);
1162     }
1163 
1164     /**
1165      * @dev Equivalent to `_burn(tokenId, false)`.
1166      */
1167     function _burn(uint256 tokenId) internal virtual {
1168         _burn(tokenId, false);
1169     }
1170 
1171     /**
1172      * @dev Destroys `tokenId`.
1173      * The approval is cleared when the token is burned.
1174      *
1175      * Requirements:
1176      *
1177      * - `tokenId` must exist.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1182         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1183 
1184         address from = address(uint160(prevOwnershipPacked));
1185 
1186         if (approvalCheck) {
1187             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1188                 isApprovedForAll(from, _msgSenderERC721A()) ||
1189                 getApproved(tokenId) == _msgSenderERC721A());
1190 
1191             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1192         }
1193 
1194         _beforeTokenTransfers(from, address(0), tokenId, 1);
1195 
1196         // Clear approvals from the previous owner.
1197         delete _tokenApprovals[tokenId];
1198 
1199         // Underflow of the sender's balance is impossible because we check for
1200         // ownership above and the recipient's balance can't realistically overflow.
1201         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1202         unchecked {
1203             // Updates:
1204             // - `balance -= 1`.
1205             // - `numberBurned += 1`.
1206             //
1207             // We can directly decrement the balance, and increment the number burned.
1208             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1209             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1210 
1211             // Updates:
1212             // - `address` to the last owner.
1213             // - `startTimestamp` to the timestamp of burning.
1214             // - `burned` to `true`.
1215             // - `nextInitialized` to `true`.
1216             _packedOwnerships[tokenId] =
1217                 _addressToUint256(from) |
1218                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1219                 BITMASK_BURNED | 
1220                 BITMASK_NEXT_INITIALIZED;
1221 
1222             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1223             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1224                 uint256 nextTokenId = tokenId + 1;
1225                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1226                 if (_packedOwnerships[nextTokenId] == 0) {
1227                     // If the next slot is within bounds.
1228                     if (nextTokenId != _currentIndex) {
1229                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1230                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1231                     }
1232                 }
1233             }
1234         }
1235 
1236         emit Transfer(from, address(0), tokenId);
1237         _afterTokenTransfers(from, address(0), tokenId, 1);
1238 
1239         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1240         unchecked {
1241             _burnCounter++;
1242         }
1243     }
1244 
1245     /**
1246      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1247      *
1248      * @param from address representing the previous owner of the given token ID
1249      * @param to target address that will receive the tokens
1250      * @param tokenId uint256 ID of the token to be transferred
1251      * @param _data bytes optional data to send along with the call
1252      * @return bool whether the call correctly returned the expected magic value
1253      */
1254     function _checkContractOnERC721Received(
1255         address from,
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) private returns (bool) {
1260         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1261             bytes4 retval
1262         ) {
1263             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1264         } catch (bytes memory reason) {
1265             if (reason.length == 0) {
1266                 revert TransferToNonERC721ReceiverImplementer();
1267             } else {
1268                 assembly {
1269                     revert(add(32, reason), mload(reason))
1270                 }
1271             }
1272         }
1273     }
1274 
1275     /**
1276      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1277      * And also called before burning one token.
1278      *
1279      * startTokenId - the first token id to be transferred
1280      * quantity - the amount to be transferred
1281      *
1282      * Calling conditions:
1283      *
1284      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1285      * transferred to `to`.
1286      * - When `from` is zero, `tokenId` will be minted for `to`.
1287      * - When `to` is zero, `tokenId` will be burned by `from`.
1288      * - `from` and `to` are never both zero.
1289      */
1290     function _beforeTokenTransfers(
1291         address from,
1292         address to,
1293         uint256 startTokenId,
1294         uint256 quantity
1295     ) internal virtual {}
1296 
1297     /**
1298      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1299      * minting.
1300      * And also called after one token has been burned.
1301      *
1302      * startTokenId - the first token id to be transferred
1303      * quantity - the amount to be transferred
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` has been minted for `to`.
1310      * - When `to` is zero, `tokenId` has been burned by `from`.
1311      * - `from` and `to` are never both zero.
1312      */
1313     function _afterTokenTransfers(
1314         address from,
1315         address to,
1316         uint256 startTokenId,
1317         uint256 quantity
1318     ) internal virtual {}
1319 
1320     /**
1321      * @dev Returns the message sender (defaults to `msg.sender`).
1322      *
1323      * If you are writing GSN compatible contracts, you need to override this function.
1324      */
1325     function _msgSenderERC721A() internal view virtual returns (address) {
1326         return msg.sender;
1327     }
1328 
1329     /**
1330      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1331      */
1332     function _toString(uint256 value) internal pure returns (string memory ptr) {
1333         assembly {
1334             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1335             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1336             // We will need 1 32-byte word to store the length, 
1337             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1338             ptr := add(mload(0x40), 128)
1339             // Update the free memory pointer to allocate.
1340             mstore(0x40, ptr)
1341 
1342             // Cache the end of the memory to calculate the length later.
1343             let end := ptr
1344 
1345             // We write the string from the rightmost digit to the leftmost digit.
1346             // The following is essentially a do-while loop that also handles the zero case.
1347             // Costs a bit more than early returning for the zero case,
1348             // but cheaper in terms of deployment and overall runtime costs.
1349             for { 
1350                 // Initialize and perform the first pass without check.
1351                 let temp := value
1352                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1353                 ptr := sub(ptr, 1)
1354                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1355                 mstore8(ptr, add(48, mod(temp, 10)))
1356                 temp := div(temp, 10)
1357             } temp { 
1358                 // Keep dividing `temp` until zero.
1359                 temp := div(temp, 10)
1360             } { // Body of the for loop.
1361                 ptr := sub(ptr, 1)
1362                 mstore8(ptr, add(48, mod(temp, 10)))
1363             }
1364             
1365             let length := sub(end, ptr)
1366             // Move the pointer 32 bytes leftwards to make room for the length.
1367             ptr := sub(ptr, 32)
1368             // Store the length.
1369             mstore(ptr, length)
1370         }
1371     }
1372 }
1373 
1374 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1375 
1376 
1377 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 /**
1382  * @dev String operations.
1383  */
1384 library Strings {
1385     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1386     uint8 private constant _ADDRESS_LENGTH = 20;
1387 
1388     /**
1389      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1390      */
1391     function toString(uint256 value) internal pure returns (string memory) {
1392         // Inspired by OraclizeAPI's implementation - MIT licence
1393         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1394 
1395         if (value == 0) {
1396             return "0";
1397         }
1398         uint256 temp = value;
1399         uint256 digits;
1400         while (temp != 0) {
1401             digits++;
1402             temp /= 10;
1403         }
1404         bytes memory buffer = new bytes(digits);
1405         while (value != 0) {
1406             digits -= 1;
1407             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1408             value /= 10;
1409         }
1410         return string(buffer);
1411     }
1412 
1413     /**
1414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1415      */
1416     function toHexString(uint256 value) internal pure returns (string memory) {
1417         if (value == 0) {
1418             return "0x00";
1419         }
1420         uint256 temp = value;
1421         uint256 length = 0;
1422         while (temp != 0) {
1423             length++;
1424             temp >>= 8;
1425         }
1426         return toHexString(value, length);
1427     }
1428 
1429     /**
1430      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1431      */
1432     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1433         bytes memory buffer = new bytes(2 * length + 2);
1434         buffer[0] = "0";
1435         buffer[1] = "x";
1436         for (uint256 i = 2 * length + 1; i > 1; --i) {
1437             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1438             value >>= 4;
1439         }
1440         require(value == 0, "Strings: hex length insufficient");
1441         return string(buffer);
1442     }
1443 
1444     /**
1445      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1446      */
1447     function toHexString(address addr) internal pure returns (string memory) {
1448         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1449     }
1450 }
1451 
1452 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1453 
1454 
1455 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1456 
1457 pragma solidity ^0.8.0;
1458 
1459 /**
1460  * @dev Provides information about the current execution context, including the
1461  * sender of the transaction and its data. While these are generally available
1462  * via msg.sender and msg.data, they should not be accessed in such a direct
1463  * manner, since when dealing with meta-transactions the account sending and
1464  * paying for execution may not be the actual sender (as far as an application
1465  * is concerned).
1466  *
1467  * This contract is only required for intermediate, library-like contracts.
1468  */
1469 abstract contract Context {
1470     function _msgSender() internal view virtual returns (address) {
1471         return msg.sender;
1472     }
1473 
1474     function _msgData() internal view virtual returns (bytes calldata) {
1475         return msg.data;
1476     }
1477 }
1478 
1479 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1480 
1481 
1482 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1483 
1484 pragma solidity ^0.8.0;
1485 
1486 
1487 /**
1488  * @dev Contract module which provides a basic access control mechanism, where
1489  * there is an account (an owner) that can be granted exclusive access to
1490  * specific functions.
1491  *
1492  * By default, the owner account will be the one that deploys the contract. This
1493  * can later be changed with {transferOwnership}.
1494  *
1495  * This module is used through inheritance. It will make available the modifier
1496  * `onlyOwner`, which can be applied to your functions to restrict their use to
1497  * the owner.
1498  */
1499 abstract contract Ownable is Context {
1500     address private _owner;
1501 
1502     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1503 
1504     /**
1505      * @dev Initializes the contract setting the deployer as the initial owner.
1506      */
1507     constructor() {
1508         _transferOwnership(_msgSender());
1509     }
1510 
1511     /**
1512      * @dev Returns the address of the current owner.
1513      */
1514     function owner() public view virtual returns (address) {
1515         return _owner;
1516     }
1517 
1518     /**
1519      * @dev Throws if called by any account other than the owner.
1520      */
1521     modifier onlyOwner() {
1522         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1523         _;
1524     }
1525 
1526     /**
1527      * @dev Leaves the contract without owner. It will not be possible to call
1528      * `onlyOwner` functions anymore. Can only be called by the current owner.
1529      *
1530      * NOTE: Renouncing ownership will leave the contract without an owner,
1531      * thereby removing any functionality that is only available to the owner.
1532      */
1533     function renounceOwnership() public virtual onlyOwner {
1534         _transferOwnership(address(0));
1535     }
1536 
1537     /**
1538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1539      * Can only be called by the current owner.
1540      */
1541     function transferOwnership(address newOwner) public virtual onlyOwner {
1542         require(newOwner != address(0), "Ownable: new owner is the zero address");
1543         _transferOwnership(newOwner);
1544     }
1545 
1546     /**
1547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1548      * Internal function without access restriction.
1549      */
1550     function _transferOwnership(address newOwner) internal virtual {
1551         address oldOwner = _owner;
1552         _owner = newOwner;
1553         emit OwnershipTransferred(oldOwner, newOwner);
1554     }
1555 }
1556 
1557 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1558 
1559 
1560 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1561 
1562 pragma solidity ^0.8.1;
1563 
1564 /**
1565  * @dev Collection of functions related to the address type
1566  */
1567 library Address {
1568     /**
1569      * @dev Returns true if `account` is a contract.
1570      *
1571      * [IMPORTANT]
1572      * ====
1573      * It is unsafe to assume that an address for which this function returns
1574      * false is an externally-owned account (EOA) and not a contract.
1575      *
1576      * Among others, `isContract` will return false for the following
1577      * types of addresses:
1578      *
1579      *  - an externally-owned account
1580      *  - a contract in construction
1581      *  - an address where a contract will be created
1582      *  - an address where a contract lived, but was destroyed
1583      * ====
1584      *
1585      * [IMPORTANT]
1586      * ====
1587      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1588      *
1589      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1590      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1591      * constructor.
1592      * ====
1593      */
1594     function isContract(address account) internal view returns (bool) {
1595         // This method relies on extcodesize/address.code.length, which returns 0
1596         // for contracts in construction, since the code is only stored at the end
1597         // of the constructor execution.
1598 
1599         return account.code.length > 0;
1600     }
1601 
1602     /**
1603      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1604      * `recipient`, forwarding all available gas and reverting on errors.
1605      *
1606      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1607      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1608      * imposed by `transfer`, making them unable to receive funds via
1609      * `transfer`. {sendValue} removes this limitation.
1610      *
1611      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1612      *
1613      * IMPORTANT: because control is transferred to `recipient`, care must be
1614      * taken to not create reentrancy vulnerabilities. Consider using
1615      * {ReentrancyGuard} or the
1616      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1617      */
1618     function sendValue(address payable recipient, uint256 amount) internal {
1619         require(address(this).balance >= amount, "Address: insufficient balance");
1620 
1621         (bool success, ) = recipient.call{value: amount}("");
1622         require(success, "Address: unable to send value, recipient may have reverted");
1623     }
1624 
1625     /**
1626      * @dev Performs a Solidity function call using a low level `call`. A
1627      * plain `call` is an unsafe replacement for a function call: use this
1628      * function instead.
1629      *
1630      * If `target` reverts with a revert reason, it is bubbled up by this
1631      * function (like regular Solidity function calls).
1632      *
1633      * Returns the raw returned data. To convert to the expected return value,
1634      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1635      *
1636      * Requirements:
1637      *
1638      * - `target` must be a contract.
1639      * - calling `target` with `data` must not revert.
1640      *
1641      * _Available since v3.1._
1642      */
1643     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1644         return functionCall(target, data, "Address: low-level call failed");
1645     }
1646 
1647     /**
1648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1649      * `errorMessage` as a fallback revert reason when `target` reverts.
1650      *
1651      * _Available since v3.1._
1652      */
1653     function functionCall(
1654         address target,
1655         bytes memory data,
1656         string memory errorMessage
1657     ) internal returns (bytes memory) {
1658         return functionCallWithValue(target, data, 0, errorMessage);
1659     }
1660 
1661     /**
1662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1663      * but also transferring `value` wei to `target`.
1664      *
1665      * Requirements:
1666      *
1667      * - the calling contract must have an ETH balance of at least `value`.
1668      * - the called Solidity function must be `payable`.
1669      *
1670      * _Available since v3.1._
1671      */
1672     function functionCallWithValue(
1673         address target,
1674         bytes memory data,
1675         uint256 value
1676     ) internal returns (bytes memory) {
1677         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1678     }
1679 
1680     /**
1681      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1682      * with `errorMessage` as a fallback revert reason when `target` reverts.
1683      *
1684      * _Available since v3.1._
1685      */
1686     function functionCallWithValue(
1687         address target,
1688         bytes memory data,
1689         uint256 value,
1690         string memory errorMessage
1691     ) internal returns (bytes memory) {
1692         require(address(this).balance >= value, "Address: insufficient balance for call");
1693         require(isContract(target), "Address: call to non-contract");
1694 
1695         (bool success, bytes memory returndata) = target.call{value: value}(data);
1696         return verifyCallResult(success, returndata, errorMessage);
1697     }
1698 
1699     /**
1700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1701      * but performing a static call.
1702      *
1703      * _Available since v3.3._
1704      */
1705     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1706         return functionStaticCall(target, data, "Address: low-level static call failed");
1707     }
1708 
1709     /**
1710      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1711      * but performing a static call.
1712      *
1713      * _Available since v3.3._
1714      */
1715     function functionStaticCall(
1716         address target,
1717         bytes memory data,
1718         string memory errorMessage
1719     ) internal view returns (bytes memory) {
1720         require(isContract(target), "Address: static call to non-contract");
1721 
1722         (bool success, bytes memory returndata) = target.staticcall(data);
1723         return verifyCallResult(success, returndata, errorMessage);
1724     }
1725 
1726     /**
1727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1728      * but performing a delegate call.
1729      *
1730      * _Available since v3.4._
1731      */
1732     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1733         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1734     }
1735 //1b0014041a0a15
1736     /**
1737      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1738      * but performing a delegate call.
1739      *
1740      * _Available since v3.4._
1741      */
1742     function functionDelegateCall(
1743         address target,
1744         bytes memory data,
1745         string memory errorMessage
1746     ) internal returns (bytes memory) {
1747         require(isContract(target), "Address: delegate call to non-contract");
1748 
1749         (bool success, bytes memory returndata) = target.delegatecall(data);
1750         return verifyCallResult(success, returndata, errorMessage);
1751     }
1752 
1753     /**
1754      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1755      * revert reason using the provided one.
1756      *
1757      * _Available since v4.3._
1758      */
1759     function verifyCallResult(
1760         bool success,
1761         bytes memory returndata,
1762         string memory errorMessage
1763     ) internal pure returns (bytes memory) {
1764         if (success) {
1765             return returndata;
1766         } else {
1767             // Look for revert reason and bubble it up if present
1768             if (returndata.length > 0) {
1769                 // The easiest way to bubble the revert reason is using memory via assembly
1770 
1771                 assembly {
1772                     let returndata_size := mload(returndata)
1773                     revert(add(32, returndata), returndata_size)
1774                 }
1775             } else {
1776                 revert(errorMessage);
1777             }
1778         }
1779     }
1780 }
1781 
1782 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1783 
1784 
1785 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 /**
1790  * @title ERC721 token receiver interface
1791  * @dev Interface for any contract that wants to support safeTransfers
1792  * from ERC721 asset contracts.
1793  */
1794 interface IERC721Receiver {
1795     /**
1796      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1797      * by `operator` from `from`, this function is called.
1798      *
1799      * It must return its Solidity selector to confirm the token transfer.
1800      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1801      *
1802      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1803      */
1804     function onERC721Received(
1805         address operator,
1806         address from,
1807         uint256 tokenId,
1808         bytes calldata data
1809     ) external returns (bytes4);
1810 }
1811 
1812 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1813 
1814 
1815 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1816 
1817 pragma solidity ^0.8.0;
1818 
1819 /**
1820  * @dev Interface of the ERC165 standard, as defined in the
1821  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1822  *
1823  * Implementers can declare support of contract interfaces, which can then be
1824  * queried by others ({ERC165Checker}).
1825  *
1826  * For an implementation, see {ERC165}.
1827  */
1828 interface IERC165 {
1829     /**
1830      * @dev Returns true if this contract implements the interface defined by
1831      * `interfaceId`. See the corresponding
1832      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1833      * to learn more about how these ids are created.
1834      *
1835      * This function call must use less than 30 000 gas.
1836      */
1837     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1838 }
1839 
1840 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1841 
1842 
1843 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1844 
1845 pragma solidity ^0.8.0;
1846 
1847 
1848 /**
1849  * @dev Implementation of the {IERC165} interface.
1850  *
1851  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1852  * for the additional interface id that will be supported. For example:
1853  *
1854  * ```solidity
1855  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1856  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1857  * }
1858  * ```
1859  *
1860  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1861  */
1862 abstract contract ERC165 is IERC165 {
1863     /**
1864      * @dev See {IERC165-supportsInterface}.
1865      */
1866     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1867         return interfaceId == type(IERC165).interfaceId;
1868     }
1869 }
1870 
1871 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1872 
1873 
1874 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1875 
1876 pragma solidity ^0.8.0;
1877 
1878 
1879 /**
1880  * @dev Required interface of an ERC721 compliant contract.
1881  */
1882 interface IERC721 is IERC165 {
1883     /**
1884      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1885      */
1886     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1887 
1888     /**
1889      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1890      */
1891     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1892 
1893     /**
1894      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1895      */
1896     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1897 
1898     /**
1899      * @dev Returns the number of tokens in ``owner``'s account.
1900      */
1901     function balanceOf(address owner) external view returns (uint256 balance);
1902 
1903     /**
1904      * @dev Returns the owner of the `tokenId` token.
1905      *
1906      * Requirements:
1907      *
1908      * - `tokenId` must exist.
1909      */
1910     function ownerOf(uint256 tokenId) external view returns (address owner);
1911 
1912     /**
1913      * @dev Safely transfers `tokenId` token from `from` to `to`.
1914      *
1915      * Requirements:
1916      *
1917      * - `from` cannot be the zero address.
1918      * - `to` cannot be the zero address.
1919      * - `tokenId` token must exist and be owned by `from`.
1920      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1921      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1922      *
1923      * Emits a {Transfer} event.
1924      */
1925     function safeTransferFrom(
1926         address from,
1927         address to,
1928         uint256 tokenId,
1929         bytes calldata data
1930     ) external;
1931 
1932     /**
1933      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1934      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1935      *
1936      * Requirements:
1937      *
1938      * - `from` cannot be the zero address.
1939      * - `to` cannot be the zero address.
1940      * - `tokenId` token must exist and be owned by `from`.
1941      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1943      *
1944      * Emits a {Transfer} event.
1945      */
1946     function safeTransferFrom(
1947         address from,
1948         address to,
1949         uint256 tokenId
1950     ) external;
1951 
1952     /**
1953      * @dev Transfers `tokenId` token from `from` to `to`.
1954      *
1955      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1956      *
1957      * Requirements:
1958      *
1959      * - `from` cannot be the zero address.
1960      * - `to` cannot be the zero address.
1961      * - `tokenId` token must be owned by `from`.
1962      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1963      *
1964      * Emits a {Transfer} event.
1965      */
1966     function transferFrom(
1967         address from,
1968         address to,
1969         uint256 tokenId
1970     ) external;
1971 
1972     /**
1973      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1974      * The approval is cleared when the token is transferred.
1975      *
1976      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1977      *
1978      * Requirements:
1979      *
1980      * - The caller must own the token or be an approved operator.
1981      * - `tokenId` must exist.
1982      *
1983      * Emits an {Approval} event.
1984      */
1985     function approve(address to, uint256 tokenId) external;
1986 
1987     /**
1988      * @dev Approve or remove `operator` as an operator for the caller.
1989      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1990      *
1991      * Requirements:
1992      *
1993      * - The `operator` cannot be the caller.
1994      *
1995      * Emits an {ApprovalForAll} event.
1996      */
1997     function setApprovalForAll(address operator, bool _approved) external;
1998 
1999     /**
2000      * @dev Returns the account approved for `tokenId` token.
2001      *
2002      * Requirements:
2003      *
2004      * - `tokenId` must exist.
2005      */
2006     function getApproved(uint256 tokenId) external view returns (address operator);
2007 
2008     /**
2009      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2010      *
2011      * See {setApprovalForAll}
2012      */
2013     function isApprovedForAll(address owner, address operator) external view returns (bool);
2014 }
2015 
2016 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2017 
2018 
2019 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2020 
2021 pragma solidity ^0.8.0;
2022 
2023 
2024 /**
2025  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2026  * @dev See https://eips.ethereum.org/EIPS/eip-721
2027  */
2028 interface IERC721Metadata is IERC721 {
2029     /**
2030      * @dev Returns the token collection name.
2031      */
2032     function name() external view returns (string memory);
2033 
2034     /**
2035      * @dev Returns the token collection symbol.
2036      */
2037     function symbol() external view returns (string memory);
2038 
2039     /**
2040      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2041      */
2042     function tokenURI(uint256 tokenId) external view returns (string memory);
2043 }
2044 
2045 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2046 
2047 
2048 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2049 
2050 pragma solidity ^0.8.0;
2051 
2052 
2053 
2054 
2055 
2056 
2057 
2058 
2059 /**
2060  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2061  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2062  * {ERC721Enumerable}.
2063  */
2064 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2065     using Address for address;
2066     using Strings for uint256;
2067 
2068     // Token name
2069     string private _name;
2070 
2071     // Token symbol
2072     string private _symbol;
2073 
2074     // Mapping from token ID to owner address
2075     mapping(uint256 => address) private _owners;
2076 
2077     // Mapping owner address to token count
2078     mapping(address => uint256) private _balances;
2079 
2080     // Mapping from token ID to approved address
2081     mapping(uint256 => address) private _tokenApprovals;
2082 
2083     // Mapping from owner to operator approvals
2084     mapping(address => mapping(address => bool)) private _operatorApprovals;
2085 
2086     /**
2087      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2088      */
2089     constructor(string memory name_, string memory symbol_) {
2090         _name = name_;
2091         _symbol = symbol_;
2092     }
2093 
2094     /**
2095      * @dev See {IERC165-supportsInterface}.
2096      */
2097     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2098         return
2099             interfaceId == type(IERC721).interfaceId ||
2100             interfaceId == type(IERC721Metadata).interfaceId ||
2101             super.supportsInterface(interfaceId);
2102     }
2103 
2104     /**
2105      * @dev See {IERC721-balanceOf}.
2106      */
2107     function balanceOf(address owner) public view virtual override returns (uint256) {
2108         require(owner != address(0), "ERC721: address zero is not a valid owner");
2109         return _balances[owner];
2110     }
2111 
2112     /**
2113      * @dev See {IERC721-ownerOf}.
2114      */
2115     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2116         address owner = _owners[tokenId];
2117         require(owner != address(0), "ERC721: owner query for nonexistent token");
2118         return owner;
2119     }
2120 
2121     /**
2122      * @dev See {IERC721Metadata-name}.
2123      */
2124     function name() public view virtual override returns (string memory) {
2125         return _name;
2126     }
2127 
2128     /**
2129      * @dev See {IERC721Metadata-symbol}.
2130      */
2131     function symbol() public view virtual override returns (string memory) {
2132         return _symbol;
2133     }
2134 
2135     /**
2136      * @dev See {IERC721Metadata-tokenURI}.
2137      */
2138     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2139         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2140 
2141         string memory baseURI = _baseURI();
2142         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2143     }
2144 
2145     /**
2146      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2147      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2148      * by default, can be overridden in child contracts.
2149      */
2150     function _baseURI() internal view virtual returns (string memory) {
2151         return "";
2152     }
2153 
2154     /**
2155      * @dev See {IERC721-approve}.
2156      */
2157     function approve(address to, uint256 tokenId) public virtual override {
2158         address owner = ERC721.ownerOf(tokenId);
2159         require(to != owner, "ERC721: approval to current owner");
2160 
2161         require(
2162             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2163             "ERC721: approve caller is not owner nor approved for all"
2164         );
2165 
2166         _approve(to, tokenId);
2167     }
2168 
2169     /**
2170      * @dev See {IERC721-getApproved}.
2171      */
2172     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2173         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2174 
2175         return _tokenApprovals[tokenId];
2176     }
2177 
2178     /**
2179      * @dev See {IERC721-setApprovalForAll}.
2180      */
2181     function setApprovalForAll(address operator, bool approved) public virtual override {
2182         _setApprovalForAll(_msgSender(), operator, approved);
2183     }
2184 
2185     /**
2186      * @dev See {IERC721-isApprovedForAll}.
2187      */
2188     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2189         return _operatorApprovals[owner][operator];
2190     }
2191 
2192     /**
2193      * @dev See {IERC721-transferFrom}.
2194      */
2195     function transferFrom(
2196         address from,
2197         address to,
2198         uint256 tokenId
2199     ) public virtual override {
2200         //solhint-disable-next-line max-line-length
2201         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2202 
2203         _transfer(from, to, tokenId);
2204     }
2205 
2206     /**
2207      * @dev See {IERC721-safeTransferFrom}.
2208      */
2209     function safeTransferFrom(
2210         address from,
2211         address to,
2212         uint256 tokenId
2213     ) public virtual override {
2214         safeTransferFrom(from, to, tokenId, "");
2215     }
2216 
2217     /**
2218      * @dev See {IERC721-safeTransferFrom}.
2219      */
2220     function safeTransferFrom(
2221         address from,
2222         address to,
2223         uint256 tokenId,
2224         bytes memory data
2225     ) public virtual override {
2226         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2227         _safeTransfer(from, to, tokenId, data);
2228     }
2229 
2230     /**
2231      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2232      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2233      *
2234      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2235      *
2236      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2237      * implement alternative mechanisms to perform token transfer, such as signature-based.
2238      *
2239      * Requirements:
2240      *
2241      * - `from` cannot be the zero address.
2242      * - `to` cannot be the zero address.
2243      * - `tokenId` token must exist and be owned by `from`.
2244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2245      *
2246      * Emits a {Transfer} event.
2247      */
2248     function _safeTransfer(
2249         address from,
2250         address to,
2251         uint256 tokenId,
2252         bytes memory data
2253     ) internal virtual {
2254         _transfer(from, to, tokenId);
2255         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2256     }
2257 
2258     /**
2259      * @dev Returns whether `tokenId` exists.
2260      *
2261      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2262      *
2263      * Tokens start existing when they are minted (`_mint`),
2264      * and stop existing when they are burned (`_burn`).
2265      */
2266     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2267         return _owners[tokenId] != address(0);
2268     }
2269 
2270     /**
2271      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2272      *
2273      * Requirements:
2274      *
2275      * - `tokenId` must exist.
2276      */
2277     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2278         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2279         address owner = ERC721.ownerOf(tokenId);
2280         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2281     }
2282 
2283     /**
2284      * @dev Safely mints `tokenId` and transfers it to `to`.
2285      *
2286      * Requirements:
2287      *
2288      * - `tokenId` must not exist.
2289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2290      *
2291      * Emits a {Transfer} event.
2292      */
2293     function _safeMint(address to, uint256 tokenId) internal virtual {
2294         _safeMint(to, tokenId, "");
2295     }
2296 
2297     /**
2298      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2299      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2300      */
2301     function _safeMint(
2302         address to,
2303         uint256 tokenId,
2304         bytes memory data
2305     ) internal virtual {
2306         _mint(to, tokenId);
2307         require(
2308             _checkOnERC721Received(address(0), to, tokenId, data),
2309             "ERC721: transfer to non ERC721Receiver implementer"
2310         );
2311     }
2312 
2313     /**
2314      * @dev Mints `tokenId` and transfers it to `to`.
2315      *
2316      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2317      *
2318      * Requirements:
2319      *
2320      * - `tokenId` must not exist.
2321      * - `to` cannot be the zero address.
2322      *
2323      * Emits a {Transfer} event.
2324      */
2325     function _mint(address to, uint256 tokenId) internal virtual {
2326         require(to != address(0), "ERC721: mint to the zero address");
2327         require(!_exists(tokenId), "ERC721: token already minted");
2328 
2329         _beforeTokenTransfer(address(0), to, tokenId);
2330 
2331         _balances[to] += 1;
2332         _owners[tokenId] = to;
2333 
2334         emit Transfer(address(0), to, tokenId);
2335 
2336         _afterTokenTransfer(address(0), to, tokenId);
2337     }
2338 
2339     /**
2340      * @dev Destroys `tokenId`.
2341      * The approval is cleared when the token is burned.
2342      *
2343      * Requirements:
2344      *
2345      * - `tokenId` must exist.
2346      *
2347      * Emits a {Transfer} event.
2348      */
2349     function _burn(uint256 tokenId) internal virtual {
2350         address owner = ERC721.ownerOf(tokenId);
2351 
2352         _beforeTokenTransfer(owner, address(0), tokenId);
2353 
2354         // Clear approvals
2355         _approve(address(0), tokenId);
2356 
2357         _balances[owner] -= 1;
2358         delete _owners[tokenId];
2359 
2360         emit Transfer(owner, address(0), tokenId);
2361 
2362         _afterTokenTransfer(owner, address(0), tokenId);
2363     }
2364 
2365     /**
2366      * @dev Transfers `tokenId` from `from` to `to`.
2367      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2368      *
2369      * Requirements:
2370      *
2371      * - `to` cannot be the zero address.
2372      * - `tokenId` token must be owned by `from`.
2373      *
2374      * Emits a {Transfer} event.
2375      */
2376     function _transfer(
2377         address from,
2378         address to,
2379         uint256 tokenId
2380     ) internal virtual {
2381         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2382         require(to != address(0), "ERC721: transfer to the zero address");
2383 
2384         _beforeTokenTransfer(from, to, tokenId);
2385 
2386         // Clear approvals from the previous owner
2387         _approve(address(0), tokenId);
2388 
2389         _balances[from] -= 1;
2390         _balances[to] += 1;
2391         _owners[tokenId] = to;
2392 
2393         emit Transfer(from, to, tokenId);
2394 
2395         _afterTokenTransfer(from, to, tokenId);
2396     }
2397 
2398     /**
2399      * @dev Approve `to` to operate on `tokenId`
2400      *
2401      * Emits an {Approval} event.
2402      */
2403     function _approve(address to, uint256 tokenId) internal virtual {
2404         _tokenApprovals[tokenId] = to;
2405         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2406     }
2407 
2408     /**
2409      * @dev Approve `operator` to operate on all of `owner` tokens
2410      *
2411      * Emits an {ApprovalForAll} event.
2412      */
2413     function _setApprovalForAll(
2414         address owner,
2415         address operator,
2416         bool approved
2417     ) internal virtual {
2418         require(owner != operator, "ERC721: approve to caller");
2419         _operatorApprovals[owner][operator] = approved;
2420         emit ApprovalForAll(owner, operator, approved);
2421     }
2422 
2423     /**
2424      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2425      * The call is not executed if the target address is not a contract.
2426      *
2427      * @param from address representing the previous owner of the given token ID
2428      * @param to target address that will receive the tokens
2429      * @param tokenId uint256 ID of the token to be transferred
2430      * @param data bytes optional data to send along with the call
2431      * @return bool whether the call correctly returned the expected magic value
2432      */
2433     function _checkOnERC721Received(
2434         address from,
2435         address to,
2436         uint256 tokenId,
2437         bytes memory data
2438     ) private returns (bool) {
2439         if (to.isContract()) {
2440             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2441                 return retval == IERC721Receiver.onERC721Received.selector;
2442             } catch (bytes memory reason) {
2443                 if (reason.length == 0) {
2444                     revert("ERC721: transfer to non ERC721Receiver implementer");
2445                 } else {
2446                     assembly {
2447                         revert(add(32, reason), mload(reason))
2448                     }
2449                 }
2450             }
2451         } else {
2452             return true;
2453         }
2454     }
2455 
2456     /**
2457      * @dev Hook that is called before any token transfer. This includes minting
2458      * and burning.
2459      *
2460      * Calling conditions:
2461      *
2462      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2463      * transferred to `to`.
2464      * - When `from` is zero, `tokenId` will be minted for `to`.
2465      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2466      * - `from` and `to` are never both zero.
2467      *
2468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2469      */
2470     function _beforeTokenTransfer(
2471         address from,
2472         address to,
2473         uint256 tokenId
2474     ) internal virtual {}
2475 
2476     /**
2477      * @dev Hook that is called after any transfer of tokens. This includes
2478      * minting and burning.
2479      *
2480      * Calling conditions:
2481      *
2482      * - when `from` and `to` are both non-zero.
2483      * - `from` and `to` are never both zero.
2484      *
2485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2486      */
2487     function _afterTokenTransfer(
2488         address from,
2489         address to,
2490         uint256 tokenId
2491     ) internal virtual {}
2492 }
2493 
2494 
2495 
2496 pragma solidity ^0.8.0;
2497 
2498 
2499 
2500 
2501 contract ChubbyPenguins is ERC721A, Ownable, ReentrancyGuard {
2502     using Strings for uint256;
2503 
2504     string private baseURI;
2505 
2506     uint256 public price = 0.0069 ether;
2507 
2508     uint256 public maxPerWallet = 5;
2509 
2510     uint256 public maxFreePerWallet = 1;
2511 
2512     uint256 public maxSupply = 3200;  //Team + Community Supply
2513 
2514 
2515     bool public mintEnabled = false;
2516     bool public publicEnabled = false;
2517 
2518     bytes32 freelistRoot;
2519     bytes32 allowlistRoot;
2520 
2521     string public hiddenURI="ipfs://bafybeiazodctovkc7qjblt6oltqcbe2uob52t2p65qfgk7prlcy5mrdzdm/hidden.json";
2522 
2523     bool public revealed = false;
2524 
2525     
2526     mapping(address => bool ) private _mintedFree;
2527 
2528     constructor() ERC721A("ChubbyPenguins", "Chubby") {
2529         
2530      
2531     }
2532 
2533 
2534 
2535 
2536 function freelistMint(bytes32[] calldata _merkleProof,uint256 count) external payable  nonReentrant {
2537 
2538         bool isFreeLeft = !(_mintedFree[msg.sender]) ;
2539         bool isEqual= count==maxFreePerWallet;
2540 
2541         uint256 cost = price;
2542        
2543 
2544         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2545         
2546         if(  isFreeLeft  && isEqual){
2547             cost=0;
2548         }
2549 
2550 
2551         if( isFreeLeft && !isEqual ){
2552         require(msg.value >= (count-maxFreePerWallet) * cost, "Please send the exact amount.");
2553         }
2554         else{
2555          require(msg.value >= count * cost, "Please send the exact amount.");
2556 
2557         }
2558         require(MerkleProof.verify(_merkleProof, freelistRoot, leaf),"Incorrect Whitelist Proof");
2559         require(totalSupply() + count <= maxSupply , "No more");
2560         require(count>0,"Please enter a number");
2561         require(mintEnabled, "Minting is not live yet");
2562         require(_numberMinted(msg.sender)+count <= maxPerWallet , "Can not mint more than 5");
2563        
2564 
2565        _mintedFree[msg.sender]=true;
2566 
2567         
2568 
2569         _safeMint(msg.sender, count);
2570     }
2571 
2572     function allowListMint(bytes32[] calldata _merkleProof,uint256 count) external payable {
2573         
2574         
2575        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2576 
2577       
2578         require(MerkleProof.verify(_merkleProof, allowlistRoot, leaf),"Incorrect Whitelist Proof");
2579         require(msg.value >=  price * count, "Please send the exact amount.");
2580         require(_numberMinted(msg.sender)+count <=maxPerWallet,"You cant mint anymore");
2581         require(totalSupply()+count<= maxSupply , "No more");
2582         require(mintEnabled, "Minting is not live yet");
2583        
2584 
2585         _safeMint(msg.sender, count);
2586     }
2587 
2588     function publicMint(uint256 count) external payable   {
2589         
2590 
2591         require(msg.value >= count * price, "Please send the exact amount.");
2592         require(totalSupply() + count <= maxSupply , "No more NFT left");
2593         require(_numberMinted(msg.sender)+count <= maxPerWallet , "Can not mint more than 5");
2594         require(count>0,"Please enter a number");
2595         require(publicEnabled, "Minting is not live yet");
2596         
2597         _safeMint(msg.sender, count);
2598     }
2599 
2600     function _baseURI() internal view virtual override returns (string memory) {
2601         return baseURI;
2602     }
2603     function _isMintedFree(address minter) external view  returns (bool) {
2604         return _mintedFree[minter];
2605     }
2606 
2607     function _mintedAmount(address minter) external view  returns (uint256) {
2608         return _numberMinted(minter);
2609     }
2610 
2611     function tokenURI(uint256 tokenId)
2612     public
2613     view
2614     virtual
2615     override
2616     returns (string memory)
2617   {
2618     require(
2619       _exists(tokenId),
2620       "ERC721AMetadata: URI query for nonexistent token"
2621     );
2622      if (revealed == false) {
2623       return hiddenURI;
2624     }
2625 
2626     string memory currentBaseURI = _baseURI();
2627     return bytes(currentBaseURI).length > 0
2628         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2629         : "";
2630   }
2631 
2632     function setBaseURI(string memory uri) public onlyOwner {
2633         baseURI = uri;
2634     }
2635 
2636     function setPreSaleRoot(bytes32 _presaleRoot_1, bytes32 _presaleRoot_2)
2637         external
2638         onlyOwner
2639     {  
2640         freelistRoot = _presaleRoot_1;
2641         allowlistRoot = _presaleRoot_2;
2642     }
2643 
2644   
2645 
2646     function setMaxPerWallet(uint256 amount) external onlyOwner {
2647         maxPerWallet = amount;
2648     }
2649 
2650     function setPrice(uint256 _newPrice) external onlyOwner {
2651         price = _newPrice;
2652     }
2653 
2654    function setMaxSupply(uint256 _newSupply) external onlyOwner {
2655         maxSupply = _newSupply;
2656     }
2657 
2658     function flipWhitelist(bool status) external onlyOwner {
2659         mintEnabled = status;
2660     }
2661 
2662     function flipPublic(bool status) external onlyOwner {
2663         publicEnabled = status;
2664     }
2665 
2666     function reveal() external onlyOwner {
2667     revealed = !revealed;
2668    
2669   }
2670 
2671  function airdrop(uint256 _mintAmount, address destination) public onlyOwner {
2672     require(_mintAmount > 0, "need to mint at least 1 NFT");
2673     uint256 supply = totalSupply();
2674     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2675 
2676       _safeMint(destination, _mintAmount);
2677     
2678   }
2679 
2680       function withdraw() external onlyOwner {
2681         (bool success, ) = payable(msg.sender).call{
2682             value: address(this).balance
2683         }("");
2684         require(success, "Transfer failed.");
2685     }
2686 
2687 
2688 }