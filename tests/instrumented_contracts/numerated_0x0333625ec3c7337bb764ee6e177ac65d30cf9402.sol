1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: contracts/witch.sol
69 
70 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
71 
72 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev These functions deal with verification of Merkle Tree proofs.
78  *
79  * The proofs can be generated using the JavaScript library
80  * https://github.com/miguelmota/merkletreejs[merkletreejs].
81  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
82  *
83  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
84  *
85  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
86  * hashing, or use a hash function other than keccak256 for hashing leaves.
87  * This is because the concatenation of a sorted pair of internal nodes in
88  * the merkle tree could be reinterpreted as a leaf value.
89  */
90 library MerkleProof {
91     /**
92      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
93      * defined by `root`. For this, a `proof` must be provided, containing
94      * sibling hashes on the branch from the leaf to the root of the tree. Each
95      * pair of leaves and each pair of pre-images are assumed to be sorted.
96      */
97     function verify(
98         bytes32[] memory proof,
99         bytes32 root,
100         bytes32 leaf
101     ) internal pure returns (bool) {
102         return processProof(proof, leaf) == root;
103     }
104 
105     /**
106      * @dev Calldata version of {verify}
107      *
108      * _Available since v4.7._
109      */
110     function verifyCalldata(
111         bytes32[] calldata proof,
112         bytes32 root,
113         bytes32 leaf
114     ) internal pure returns (bool) {
115         return processProofCalldata(proof, leaf) == root;
116     }
117 
118     /**
119      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
120      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
121      * hash matches the root of the tree. When processing the proof, the pairs
122      * of leafs & pre-images are assumed to be sorted.
123      *
124      * _Available since v4.4._
125      */
126     function processProof(bytes32[] memory proof, bytes32 leaf)
127         internal
128         pure
129         returns (bytes32)
130     {
131         bytes32 computedHash = leaf;
132         for (uint256 i = 0; i < proof.length; i++) {
133             computedHash = _hashPair(computedHash, proof[i]);
134         }
135         return computedHash;
136     }
137 
138     /**
139      * @dev Calldata version of {processProof}
140      *
141      * _Available since v4.7._
142      */
143     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
144         internal
145         pure
146         returns (bytes32)
147     {
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
204         require(
205             leavesLen + proof.length - 1 == totalHashes,
206             "MerkleProof: invalid multiproof"
207         );
208 
209         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
210         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
211         bytes32[] memory hashes = new bytes32[](totalHashes);
212         uint256 leafPos = 0;
213         uint256 hashPos = 0;
214         uint256 proofPos = 0;
215         // At each step, we compute the next hash using two values:
216         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
217         //   get the next hash.
218         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
219         //   `proof` array.
220         for (uint256 i = 0; i < totalHashes; i++) {
221             bytes32 a = leafPos < leavesLen
222                 ? leaves[leafPos++]
223                 : hashes[hashPos++];
224             bytes32 b = proofFlags[i]
225                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
226                 : proof[proofPos++];
227             hashes[i] = _hashPair(a, b);
228         }
229 
230         if (totalHashes > 0) {
231             return hashes[totalHashes - 1];
232         } else if (leavesLen > 0) {
233             return leaves[0];
234         } else {
235             return proof[0];
236         }
237     }
238 
239     /**
240      * @dev Calldata version of {processMultiProof}
241      *
242      * _Available since v4.7._
243      */
244     function processMultiProofCalldata(
245         bytes32[] calldata proof,
246         bool[] calldata proofFlags,
247         bytes32[] memory leaves
248     ) internal pure returns (bytes32 merkleRoot) {
249         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
250         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
251         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
252         // the merkle tree.
253         uint256 leavesLen = leaves.length;
254         uint256 totalHashes = proofFlags.length;
255 
256         // Check proof validity.
257         require(
258             leavesLen + proof.length - 1 == totalHashes,
259             "MerkleProof: invalid multiproof"
260         );
261 
262         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
263         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
264         bytes32[] memory hashes = new bytes32[](totalHashes);
265         uint256 leafPos = 0;
266         uint256 hashPos = 0;
267         uint256 proofPos = 0;
268         // At each step, we compute the next hash using two values:
269         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
270         //   get the next hash.
271         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
272         //   `proof` array.
273         for (uint256 i = 0; i < totalHashes; i++) {
274             bytes32 a = leafPos < leavesLen
275                 ? leaves[leafPos++]
276                 : hashes[hashPos++];
277             bytes32 b = proofFlags[i]
278                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
279                 : proof[proofPos++];
280             hashes[i] = _hashPair(a, b);
281         }
282 
283         if (totalHashes > 0) {
284             return hashes[totalHashes - 1];
285         } else if (leavesLen > 0) {
286             return leaves[0];
287         } else {
288             return proof[0];
289         }
290     }
291 
292     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
293         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
294     }
295 
296     function _efficientHash(bytes32 a, bytes32 b)
297         private
298         pure
299         returns (bytes32 value)
300     {
301         /// @solidity memory-safe-assembly
302         assembly {
303             mstore(0x00, a)
304             mstore(0x20, b)
305             value := keccak256(0x00, 0x40)
306         }
307     }
308 }
309 
310 // File: contracts/witch.sol
311 
312 pragma solidity ^0.8.4;
313 
314 /**
315  * @dev Interface of an ERC721A compliant contract.
316  */
317 interface IERC721A {
318     /**
319      * The caller must own the token or be an approved operator.
320      */
321     error ApprovalCallerNotOwnerNorApproved();
322 
323     /**
324      * The token does not exist.
325      */
326     error ApprovalQueryForNonexistentToken();
327 
328     /**
329      * The caller cannot approve to their own address.
330      */
331     error ApproveToCaller();
332 
333     /**
334      * The caller cannot approve to the current owner.
335      */
336     error ApprovalToCurrentOwner();
337 
338     /**
339      * Cannot query the balance for the zero address.
340      */
341     error BalanceQueryForZeroAddress();
342 
343     /**
344      * Cannot mint to the zero address.
345      */
346     error MintToZeroAddress();
347 
348     /**
349      * The quantity of tokens minted must be more than zero.
350      */
351     error MintZeroQuantity();
352 
353     /**
354      * The token does not exist.
355      */
356     error OwnerQueryForNonexistentToken();
357 
358     /**
359      * The caller must own the token or be an approved operator.
360      */
361     error TransferCallerNotOwnerNorApproved();
362 
363     /**
364      * The token must be owned by `from`.
365      */
366     error TransferFromIncorrectOwner();
367 
368     /**
369      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
370      */
371     error TransferToNonERC721ReceiverImplementer();
372 
373     /**
374      * Cannot transfer to the zero address.
375      */
376     error TransferToZeroAddress();
377 
378     /**
379      * The token does not exist.
380      */
381     error URIQueryForNonexistentToken();
382 
383     struct TokenOwnership {
384         // The address of the owner.
385         address addr;
386         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
387         uint64 startTimestamp;
388         // Whether the token has been burned.
389         bool burned;
390     }
391 
392     /**
393      * @dev Returns the total amount of tokens stored by the contract.
394      *
395      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
396      */
397     function totalSupply() external view returns (uint256);
398 
399     // ==============================
400     //            IERC165
401     // ==============================
402 
403     /**
404      * @dev Returns true if this contract implements the interface defined by
405      * `interfaceId`. See the corresponding
406      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
407      * to learn more about how these ids are created.
408      *
409      * This function call must use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) external view returns (bool);
412 
413     // ==============================
414     //            IERC721
415     // ==============================
416 
417     /**
418      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
419      */
420     event Transfer(
421         address indexed from,
422         address indexed to,
423         uint256 indexed tokenId
424     );
425 
426     /**
427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
428      */
429     event Approval(
430         address indexed owner,
431         address indexed approved,
432         uint256 indexed tokenId
433     );
434 
435     /**
436      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(
439         address indexed owner,
440         address indexed operator,
441         bool approved
442     );
443 
444     /**
445      * @dev Returns the number of tokens in ``owner``'s account.
446      */
447     function balanceOf(address owner) external view returns (uint256 balance);
448 
449     /**
450      * @dev Returns the owner of the `tokenId` token.
451      *
452      * Requirements:
453      *
454      * - `tokenId` must exist.
455      */
456     function ownerOf(uint256 tokenId) external view returns (address owner);
457 
458     /**
459      * @dev Safely transfers `tokenId` token from `from` to `to`.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must exist and be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external;
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId
496     ) external;
497 
498     /**
499      * @dev Transfers `tokenId` token from `from` to `to`.
500      *
501      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
520      * The approval is cleared when the token is transferred.
521      *
522      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
523      *
524      * Requirements:
525      *
526      * - The caller must own the token or be an approved operator.
527      * - `tokenId` must exist.
528      *
529      * Emits an {Approval} event.
530      */
531     function approve(address to, uint256 tokenId) external;
532 
533     /**
534      * @dev Approve or remove `operator` as an operator for the caller.
535      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
536      *
537      * Requirements:
538      *
539      * - The `operator` cannot be the caller.
540      *
541      * Emits an {ApprovalForAll} event.
542      */
543     function setApprovalForAll(address operator, bool _approved) external;
544 
545     /**
546      * @dev Returns the account approved for `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function getApproved(uint256 tokenId)
553         external
554         view
555         returns (address operator);
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}
561      */
562     function isApprovedForAll(address owner, address operator)
563         external
564         view
565         returns (bool);
566 
567     // ==============================
568     //        IERC721Metadata
569     // ==============================
570 
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() external view returns (string memory);
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) external view returns (string memory);
585 }
586 
587 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
588 
589 // ERC721A Contracts v3.3.0
590 // Creator: Chiru Labs
591 
592 pragma solidity ^0.8.4;
593 
594 /**
595  * @dev ERC721 token receiver interface.
596  */
597 interface ERC721A__IERC721Receiver {
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
611  *
612  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
613  *
614  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
615  */
616 contract ERC721A is IERC721A {
617     // Mask of an entry in packed address data.
618     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
619 
620     // The bit position of `numberMinted` in packed address data.
621     uint256 private constant BITPOS_NUMBER_MINTED = 64;
622 
623     // The bit position of `numberBurned` in packed address data.
624     uint256 private constant BITPOS_NUMBER_BURNED = 128;
625 
626     // The bit position of `aux` in packed address data.
627     uint256 private constant BITPOS_AUX = 192;
628 
629     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
630     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
631 
632     // The bit position of `startTimestamp` in packed ownership.
633     uint256 private constant BITPOS_START_TIMESTAMP = 160;
634 
635     // The bit mask of the `burned` bit in packed ownership.
636     uint256 private constant BITMASK_BURNED = 1 << 224;
637 
638     // The bit position of the `nextInitialized` bit in packed ownership.
639     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
640 
641     // The bit mask of the `nextInitialized` bit in packed ownership.
642     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
643 
644     // The tokenId of the next token to be minted.
645     uint256 private _currentIndex;
646 
647     // The number of tokens burned.
648     uint256 private _burnCounter;
649 
650     // Token name
651     string private _name;
652 
653     // Token symbol
654     string private _symbol;
655 
656     // Mapping from token ID to ownership details
657     // An empty struct value does not necessarily mean the token is unowned.
658     // See `_packedOwnershipOf` implementation for details.
659     //
660     // Bits Layout:
661     // - [0..159]   `addr`
662     // - [160..223] `startTimestamp`
663     // - [224]      `burned`
664     // - [225]      `nextInitialized`
665     mapping(uint256 => uint256) private _packedOwnerships;
666 
667     // Mapping owner address to address data.
668     //
669     // Bits Layout:
670     // - [0..63]    `balance`
671     // - [64..127]  `numberMinted`
672     // - [128..191] `numberBurned`
673     // - [192..255] `aux`
674     mapping(address => uint256) private _packedAddressData;
675 
676     // Mapping from token ID to approved address.
677     mapping(uint256 => address) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685         _currentIndex = _startTokenId();
686     }
687 
688     /**
689      * @dev Returns the starting token ID.
690      * To change the starting token ID, please override this function.
691      */
692     function _startTokenId() internal view virtual returns (uint256) {
693         return 0;
694     }
695 
696     /**
697      * @dev Returns the next token ID to be minted.
698      */
699     function _nextTokenId() internal view returns (uint256) {
700         return _currentIndex;
701     }
702 
703     /**
704      * @dev Returns the total number of tokens in existence.
705      * Burned tokens will reduce the count.
706      * To get the total number of tokens minted, please see `_totalMinted`.
707      */
708     function totalSupply() public view override returns (uint256) {
709         // Counter underflow is impossible as _burnCounter cannot be incremented
710         // more than `_currentIndex - _startTokenId()` times.
711         unchecked {
712             return _currentIndex - _burnCounter - _startTokenId();
713         }
714     }
715 
716     /**
717      * @dev Returns the total amount of tokens minted in the contract.
718      */
719     function _totalMinted() internal view returns (uint256) {
720         // Counter underflow is impossible as _currentIndex does not decrement,
721         // and it is initialized to `_startTokenId()`
722         unchecked {
723             return _currentIndex - _startTokenId();
724         }
725     }
726 
727     /**
728      * @dev Returns the total number of tokens burned.
729      */
730     function _totalBurned() internal view returns (uint256) {
731         return _burnCounter;
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId)
738         public
739         view
740         virtual
741         override
742         returns (bool)
743     {
744         // The interface IDs are constants representing the first 4 bytes of the XOR of
745         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
746         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
747         return
748             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
749             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
750             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
759     }
760 
761     /**
762      * Returns the number of tokens minted by `owner`.
763      */
764     function _numberMinted(address owner) internal view returns (uint256) {
765         return
766             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
767             BITMASK_ADDRESS_DATA_ENTRY;
768     }
769 
770     /**
771      * Returns the number of tokens burned by or on behalf of `owner`.
772      */
773     function _numberBurned(address owner) internal view returns (uint256) {
774         return
775             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
776             BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
781      */
782     function _getAux(address owner) internal view returns (uint64) {
783         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
784     }
785 
786     /**
787      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
788      * If there are multiple variables, please pack them into a uint64.
789      */
790     function _setAux(address owner, uint64 aux) internal {
791         uint256 packed = _packedAddressData[owner];
792         uint256 auxCasted;
793         assembly {
794             // Cast aux without masking.
795             auxCasted := aux
796         }
797         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
798         _packedAddressData[owner] = packed;
799     }
800 
801     /**
802      * Returns the packed ownership data of `tokenId`.
803      */
804     function _packedOwnershipOf(uint256 tokenId)
805         private
806         view
807         returns (uint256)
808     {
809         uint256 curr = tokenId;
810 
811         unchecked {
812             if (_startTokenId() <= curr)
813                 if (curr < _currentIndex) {
814                     uint256 packed = _packedOwnerships[curr];
815                     // If not burned.
816                     if (packed & BITMASK_BURNED == 0) {
817                         // Invariant:
818                         // There will always be an ownership that has an address and is not burned
819                         // before an ownership that does not have an address and is not burned.
820                         // Hence, curr will not underflow.
821                         //
822                         // We can directly compare the packed value.
823                         // If the address is zero, packed is zero.
824                         while (packed == 0) {
825                             packed = _packedOwnerships[--curr];
826                         }
827                         return packed;
828                     }
829                 }
830         }
831         revert OwnerQueryForNonexistentToken();
832     }
833 
834     /**
835      * Returns the unpacked `TokenOwnership` struct from `packed`.
836      */
837     function _unpackedOwnership(uint256 packed)
838         private
839         pure
840         returns (TokenOwnership memory ownership)
841     {
842         ownership.addr = address(uint160(packed));
843         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
844         ownership.burned = packed & BITMASK_BURNED != 0;
845     }
846 
847     /**
848      * Returns the unpacked `TokenOwnership` struct at `index`.
849      */
850     function _ownershipAt(uint256 index)
851         internal
852         view
853         returns (TokenOwnership memory)
854     {
855         return _unpackedOwnership(_packedOwnerships[index]);
856     }
857 
858     /**
859      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
860      */
861     function _initializeOwnershipAt(uint256 index) internal {
862         if (_packedOwnerships[index] == 0) {
863             _packedOwnerships[index] = _packedOwnershipOf(index);
864         }
865     }
866 
867     /**
868      * Gas spent here starts off proportional to the maximum mint batch size.
869      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
870      */
871     function _ownershipOf(uint256 tokenId)
872         internal
873         view
874         returns (TokenOwnership memory)
875     {
876         return _unpackedOwnership(_packedOwnershipOf(tokenId));
877     }
878 
879     /**
880      * @dev See {IERC721-ownerOf}.
881      */
882     function ownerOf(uint256 tokenId) public view override returns (address) {
883         return address(uint160(_packedOwnershipOf(tokenId)));
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-name}.
888      */
889     function name() public view virtual override returns (string memory) {
890         return _name;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-symbol}.
895      */
896     function symbol() public view virtual override returns (string memory) {
897         return _symbol;
898     }
899 
900     /**
901      * @dev See {IERC721Metadata-tokenURI}.
902      */
903     function tokenURI(uint256 tokenId)
904         public
905         view
906         virtual
907         override
908         returns (string memory)
909     {
910         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
911 
912         string memory baseURI = _baseURI();
913         return
914             bytes(baseURI).length != 0
915                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
916                 : "";
917     }
918 
919     /**
920      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
921      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
922      * by default, can be overriden in child contracts.
923      */
924     function _baseURI() internal view virtual returns (string memory) {
925         return "";
926     }
927 
928     /**
929      * @dev Casts the address to uint256 without masking.
930      */
931     function _addressToUint256(address value)
932         private
933         pure
934         returns (uint256 result)
935     {
936         assembly {
937             result := value
938         }
939     }
940 
941     /**
942      * @dev Casts the boolean to uint256 without branching.
943      */
944     function _boolToUint256(bool value) private pure returns (uint256 result) {
945         assembly {
946             result := value
947         }
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public override {
954         address owner = address(uint160(_packedOwnershipOf(tokenId)));
955         if (to == owner) revert ApprovalToCurrentOwner();
956 
957         if (_msgSenderERC721A() != owner)
958             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
959                 revert ApprovalCallerNotOwnerNorApproved();
960             }
961 
962         _tokenApprovals[tokenId] = to;
963         emit Approval(owner, to, tokenId);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId)
970         public
971         view
972         override
973         returns (address)
974     {
975         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
976 
977         return _tokenApprovals[tokenId];
978     }
979 
980     /**
981      * @dev See {IERC721-setApprovalForAll}.
982      */
983     function setApprovalForAll(address operator, bool approved)
984         public
985         virtual
986         override
987     {
988         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
989 
990         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
991         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
992     }
993 
994     /**
995      * @dev See {IERC721-isApprovedForAll}.
996      */
997     function isApprovedForAll(address owner, address operator)
998         public
999         view
1000         virtual
1001         override
1002         returns (bool)
1003     {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         _transfer(from, to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-safeTransferFrom}.
1020      */
1021     function safeTransferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         safeTransferFrom(from, to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) public virtual override {
1038         _transfer(from, to, tokenId);
1039         if (to.code.length != 0)
1040             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1041                 revert TransferToNonERC721ReceiverImplementer();
1042             }
1043     }
1044 
1045     /**
1046      * @dev Returns whether `tokenId` exists.
1047      *
1048      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1049      *
1050      * Tokens start existing when they are minted (`_mint`),
1051      */
1052     function _exists(uint256 tokenId) internal view returns (bool) {
1053         return
1054             _startTokenId() <= tokenId &&
1055             tokenId < _currentIndex && // If within bounds,
1056             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1057     }
1058 
1059     /**
1060      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1061      */
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, "");
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement
1072      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             // Updates:
1093             // - `balance += quantity`.
1094             // - `numberMinted += quantity`.
1095             //
1096             // We can directly add to the balance and number minted.
1097             _packedAddressData[to] +=
1098                 quantity *
1099                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1100 
1101             // Updates:
1102             // - `address` to the owner.
1103             // - `startTimestamp` to the timestamp of minting.
1104             // - `burned` to `false`.
1105             // - `nextInitialized` to `quantity == 1`.
1106             _packedOwnerships[startTokenId] =
1107                 _addressToUint256(to) |
1108                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1109                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1110 
1111             uint256 updatedIndex = startTokenId;
1112             uint256 end = updatedIndex + quantity;
1113 
1114             if (to.code.length != 0) {
1115                 do {
1116                     emit Transfer(address(0), to, updatedIndex);
1117                     if (
1118                         !_checkContractOnERC721Received(
1119                             address(0),
1120                             to,
1121                             updatedIndex++,
1122                             _data
1123                         )
1124                     ) {
1125                         revert TransferToNonERC721ReceiverImplementer();
1126                     }
1127                 } while (updatedIndex < end);
1128                 // Reentrancy protection
1129                 if (_currentIndex != startTokenId) revert();
1130             } else {
1131                 do {
1132                     emit Transfer(address(0), to, updatedIndex++);
1133                 } while (updatedIndex < end);
1134             }
1135             _currentIndex = updatedIndex;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _mint(address to, uint256 quantity) internal {
1151         uint256 startTokenId = _currentIndex;
1152         if (to == address(0)) revert MintToZeroAddress();
1153         if (quantity == 0) revert MintZeroQuantity();
1154 
1155         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1156 
1157         // Overflows are incredibly unrealistic.
1158         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1159         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1160         unchecked {
1161             // Updates:
1162             // - `balance += quantity`.
1163             // - `numberMinted += quantity`.
1164             //
1165             // We can directly add to the balance and number minted.
1166             _packedAddressData[to] +=
1167                 quantity *
1168                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1169 
1170             // Updates:
1171             // - `address` to the owner.
1172             // - `startTimestamp` to the timestamp of minting.
1173             // - `burned` to `false`.
1174             // - `nextInitialized` to `quantity == 1`.
1175             _packedOwnerships[startTokenId] =
1176                 _addressToUint256(to) |
1177                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1178                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1179 
1180             uint256 updatedIndex = startTokenId;
1181             uint256 end = updatedIndex + quantity;
1182 
1183             do {
1184                 emit Transfer(address(0), to, updatedIndex++);
1185             } while (updatedIndex < end);
1186 
1187             _currentIndex = updatedIndex;
1188         }
1189         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1190     }
1191 
1192     /**
1193      * @dev Transfers `tokenId` from `from` to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `to` cannot be the zero address.
1198      * - `tokenId` token must be owned by `from`.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _transfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) private {
1207         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1208 
1209         if (address(uint160(prevOwnershipPacked)) != from)
1210             revert TransferFromIncorrectOwner();
1211 
1212         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1213             isApprovedForAll(from, _msgSenderERC721A()) ||
1214             getApproved(tokenId) == _msgSenderERC721A());
1215 
1216         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1217         if (to == address(0)) revert TransferToZeroAddress();
1218 
1219         _beforeTokenTransfers(from, to, tokenId, 1);
1220 
1221         // Clear approvals from the previous owner.
1222         delete _tokenApprovals[tokenId];
1223 
1224         // Underflow of the sender's balance is impossible because we check for
1225         // ownership above and the recipient's balance can't realistically overflow.
1226         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1227         unchecked {
1228             // We can directly increment and decrement the balances.
1229             --_packedAddressData[from]; // Updates: `balance -= 1`.
1230             ++_packedAddressData[to]; // Updates: `balance += 1`.
1231 
1232             // Updates:
1233             // - `address` to the next owner.
1234             // - `startTimestamp` to the timestamp of transfering.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `true`.
1237             _packedOwnerships[tokenId] =
1238                 _addressToUint256(to) |
1239                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1240                 BITMASK_NEXT_INITIALIZED;
1241 
1242             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1243             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1244                 uint256 nextTokenId = tokenId + 1;
1245                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1246                 if (_packedOwnerships[nextTokenId] == 0) {
1247                     // If the next slot is within bounds.
1248                     if (nextTokenId != _currentIndex) {
1249                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1250                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1251                     }
1252                 }
1253             }
1254         }
1255 
1256         emit Transfer(from, to, tokenId);
1257         _afterTokenTransfers(from, to, tokenId, 1);
1258     }
1259 
1260     /**
1261      * @dev Equivalent to `_burn(tokenId, false)`.
1262      */
1263     function _burn(uint256 tokenId) internal virtual {
1264         _burn(tokenId, false);
1265     }
1266 
1267     /**
1268      * @dev Destroys `tokenId`.
1269      * The approval is cleared when the token is burned.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must exist.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1278         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1279 
1280         address from = address(uint160(prevOwnershipPacked));
1281 
1282         if (approvalCheck) {
1283             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1284                 isApprovedForAll(from, _msgSenderERC721A()) ||
1285                 getApproved(tokenId) == _msgSenderERC721A());
1286 
1287             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1288         }
1289 
1290         _beforeTokenTransfers(from, address(0), tokenId, 1);
1291 
1292         // Clear approvals from the previous owner.
1293         delete _tokenApprovals[tokenId];
1294 
1295         // Underflow of the sender's balance is impossible because we check for
1296         // ownership above and the recipient's balance can't realistically overflow.
1297         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1298         unchecked {
1299             // Updates:
1300             // - `balance -= 1`.
1301             // - `numberBurned += 1`.
1302             //
1303             // We can directly decrement the balance, and increment the number burned.
1304             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1305             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1306 
1307             // Updates:
1308             // - `address` to the last owner.
1309             // - `startTimestamp` to the timestamp of burning.
1310             // - `burned` to `true`.
1311             // - `nextInitialized` to `true`.
1312             _packedOwnerships[tokenId] =
1313                 _addressToUint256(from) |
1314                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1315                 BITMASK_BURNED |
1316                 BITMASK_NEXT_INITIALIZED;
1317 
1318             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1319             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1320                 uint256 nextTokenId = tokenId + 1;
1321                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1322                 if (_packedOwnerships[nextTokenId] == 0) {
1323                     // If the next slot is within bounds.
1324                     if (nextTokenId != _currentIndex) {
1325                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1326                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1327                     }
1328                 }
1329             }
1330         }
1331 
1332         emit Transfer(from, address(0), tokenId);
1333         _afterTokenTransfers(from, address(0), tokenId, 1);
1334 
1335         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1336         unchecked {
1337             _burnCounter++;
1338         }
1339     }
1340 
1341     /**
1342      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1343      *
1344      * @param from address representing the previous owner of the given token ID
1345      * @param to target address that will receive the tokens
1346      * @param tokenId uint256 ID of the token to be transferred
1347      * @param _data bytes optional data to send along with the call
1348      * @return bool whether the call correctly returned the expected magic value
1349      */
1350     function _checkContractOnERC721Received(
1351         address from,
1352         address to,
1353         uint256 tokenId,
1354         bytes memory _data
1355     ) private returns (bool) {
1356         try
1357             ERC721A__IERC721Receiver(to).onERC721Received(
1358                 _msgSenderERC721A(),
1359                 from,
1360                 tokenId,
1361                 _data
1362             )
1363         returns (bytes4 retval) {
1364             return
1365                 retval ==
1366                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1367         } catch (bytes memory reason) {
1368             if (reason.length == 0) {
1369                 revert TransferToNonERC721ReceiverImplementer();
1370             } else {
1371                 assembly {
1372                     revert(add(32, reason), mload(reason))
1373                 }
1374             }
1375         }
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1380      * And also called before burning one token.
1381      *
1382      * startTokenId - the first token id to be transferred
1383      * quantity - the amount to be transferred
1384      *
1385      * Calling conditions:
1386      *
1387      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1388      * transferred to `to`.
1389      * - When `from` is zero, `tokenId` will be minted for `to`.
1390      * - When `to` is zero, `tokenId` will be burned by `from`.
1391      * - `from` and `to` are never both zero.
1392      */
1393     function _beforeTokenTransfers(
1394         address from,
1395         address to,
1396         uint256 startTokenId,
1397         uint256 quantity
1398     ) internal virtual {}
1399 
1400     /**
1401      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1402      * minting.
1403      * And also called after one token has been burned.
1404      *
1405      * startTokenId - the first token id to be transferred
1406      * quantity - the amount to be transferred
1407      *
1408      * Calling conditions:
1409      *
1410      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1411      * transferred to `to`.
1412      * - When `from` is zero, `tokenId` has been minted for `to`.
1413      * - When `to` is zero, `tokenId` has been burned by `from`.
1414      * - `from` and `to` are never both zero.
1415      */
1416     function _afterTokenTransfers(
1417         address from,
1418         address to,
1419         uint256 startTokenId,
1420         uint256 quantity
1421     ) internal virtual {}
1422 
1423     /**
1424      * @dev Returns the message sender (defaults to `msg.sender`).
1425      *
1426      * If you are writing GSN compatible contracts, you need to override this function.
1427      */
1428     function _msgSenderERC721A() internal view virtual returns (address) {
1429         return msg.sender;
1430     }
1431 
1432     /**
1433      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1434      */
1435     function _toString(uint256 value)
1436         internal
1437         pure
1438         returns (string memory ptr)
1439     {
1440         assembly {
1441             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1442             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1443             // We will need 1 32-byte word to store the length,
1444             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1445             ptr := add(mload(0x40), 128)
1446             // Update the free memory pointer to allocate.
1447             mstore(0x40, ptr)
1448 
1449             // Cache the end of the memory to calculate the length later.
1450             let end := ptr
1451 
1452             // We write the string from the rightmost digit to the leftmost digit.
1453             // The following is essentially a do-while loop that also handles the zero case.
1454             // Costs a bit more than early returning for the zero case,
1455             // but cheaper in terms of deployment and overall runtime costs.
1456             for {
1457                 // Initialize and perform the first pass without check.
1458                 let temp := value
1459                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1460                 ptr := sub(ptr, 1)
1461                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1462                 mstore8(ptr, add(48, mod(temp, 10)))
1463                 temp := div(temp, 10)
1464             } temp {
1465                 // Keep dividing `temp` until zero.
1466                 temp := div(temp, 10)
1467             } {
1468                 // Body of the for loop.
1469                 ptr := sub(ptr, 1)
1470                 mstore8(ptr, add(48, mod(temp, 10)))
1471             }
1472 
1473             let length := sub(end, ptr)
1474             // Move the pointer 32 bytes leftwards to make room for the length.
1475             ptr := sub(ptr, 32)
1476             // Store the length.
1477             mstore(ptr, length)
1478         }
1479     }
1480 }
1481 
1482 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1483 
1484 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1485 
1486 pragma solidity ^0.8.0;
1487 
1488 /**
1489  * @dev String operations.
1490  */
1491 library Strings {
1492     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1493     uint8 private constant _ADDRESS_LENGTH = 20;
1494 
1495     /**
1496      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1497      */
1498     function toString(uint256 value) internal pure returns (string memory) {
1499         // Inspired by OraclizeAPI's implementation - MIT licence
1500         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1501 
1502         if (value == 0) {
1503             return "0";
1504         }
1505         uint256 temp = value;
1506         uint256 digits;
1507         while (temp != 0) {
1508             digits++;
1509             temp /= 10;
1510         }
1511         bytes memory buffer = new bytes(digits);
1512         while (value != 0) {
1513             digits -= 1;
1514             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1515             value /= 10;
1516         }
1517         return string(buffer);
1518     }
1519 
1520     /**
1521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1522      */
1523     function toHexString(uint256 value) internal pure returns (string memory) {
1524         if (value == 0) {
1525             return "0x00";
1526         }
1527         uint256 temp = value;
1528         uint256 length = 0;
1529         while (temp != 0) {
1530             length++;
1531             temp >>= 8;
1532         }
1533         return toHexString(value, length);
1534     }
1535 
1536     /**
1537      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1538      */
1539     function toHexString(uint256 value, uint256 length)
1540         internal
1541         pure
1542         returns (string memory)
1543     {
1544         bytes memory buffer = new bytes(2 * length + 2);
1545         buffer[0] = "0";
1546         buffer[1] = "x";
1547         for (uint256 i = 2 * length + 1; i > 1; --i) {
1548             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1549             value >>= 4;
1550         }
1551         require(value == 0, "Strings: hex length insufficient");
1552         return string(buffer);
1553     }
1554 
1555     /**
1556      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1557      */
1558     function toHexString(address addr) internal pure returns (string memory) {
1559         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1560     }
1561 }
1562 
1563 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1564 
1565 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 /**
1570  * @dev Provides information about the current execution context, including the
1571  * sender of the transaction and its data. While these are generally available
1572  * via msg.sender and msg.data, they should not be accessed in such a direct
1573  * manner, since when dealing with meta-transactions the account sending and
1574  * paying for execution may not be the actual sender (as far as an application
1575  * is concerned).
1576  *
1577  * This contract is only required for intermediate, library-like contracts.
1578  */
1579 abstract contract Context {
1580     function _msgSender() internal view virtual returns (address) {
1581         return msg.sender;
1582     }
1583 
1584     function _msgData() internal view virtual returns (bytes calldata) {
1585         return msg.data;
1586     }
1587 }
1588 
1589 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1590 
1591 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 /**
1596  * @dev Contract module which provides a basic access control mechanism, where
1597  * there is an account (an owner) that can be granted exclusive access to
1598  * specific functions.
1599  *
1600  * By default, the owner account will be the one that deploys the contract. This
1601  * can later be changed with {transferOwnership}.
1602  *
1603  * This module is used through inheritance. It will make available the modifier
1604  * `onlyOwner`, which can be applied to your functions to restrict their use to
1605  * the owner.
1606  */
1607 abstract contract Ownable is Context {
1608     address private _owner;
1609 
1610     event OwnershipTransferred(
1611         address indexed previousOwner,
1612         address indexed newOwner
1613     );
1614 
1615     /**
1616      * @dev Initializes the contract setting the deployer as the initial owner.
1617      */
1618     constructor() {
1619         _transferOwnership(_msgSender());
1620     }
1621 
1622     /**
1623      * @dev Returns the address of the current owner.
1624      */
1625     function owner() public view virtual returns (address) {
1626         return _owner;
1627     }
1628 
1629     /**
1630      * @dev Throws if called by any account other than the owner.
1631      */
1632     modifier onlyOwner() {
1633         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1634         _;
1635     }
1636 
1637     /**
1638      * @dev Leaves the contract without owner. It will not be possible to call
1639      * `onlyOwner` functions anymore. Can only be called by the current owner.
1640      *
1641      * NOTE: Renouncing ownership will leave the contract without an owner,
1642      * thereby removing any functionality that is only available to the owner.
1643      */
1644     function renounceOwnership() public virtual onlyOwner {
1645         _transferOwnership(address(0));
1646     }
1647 
1648     /**
1649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1650      * Can only be called by the current owner.
1651      */
1652     function transferOwnership(address newOwner) public virtual onlyOwner {
1653         require(
1654             newOwner != address(0),
1655             "Ownable: new owner is the zero address"
1656         );
1657         _transferOwnership(newOwner);
1658     }
1659 
1660     /**
1661      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1662      * Internal function without access restriction.
1663      */
1664     function _transferOwnership(address newOwner) internal virtual {
1665         address oldOwner = _owner;
1666         _owner = newOwner;
1667         emit OwnershipTransferred(oldOwner, newOwner);
1668     }
1669 }
1670 
1671 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1672 
1673 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1674 
1675 pragma solidity ^0.8.1;
1676 
1677 /**
1678  * @dev Collection of functions related to the address type
1679  */
1680 library Address {
1681     /**
1682      * @dev Returns true if `account` is a contract.
1683      *
1684      * [IMPORTANT]
1685      * ====
1686      * It is unsafe to assume that an address for which this function returns
1687      * false is an externally-owned account (EOA) and not a contract.
1688      *
1689      * Among others, `isContract` will return false for the following
1690      * types of addresses:
1691      *
1692      *  - an externally-owned account
1693      *  - a contract in construction
1694      *  - an address where a contract will be created
1695      *  - an address where a contract lived, but was destroyed
1696      * ====
1697      *
1698      * [IMPORTANT]
1699      * ====
1700      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1701      *
1702      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1703      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1704      * constructor.
1705      * ====
1706      */
1707     function isContract(address account) internal view returns (bool) {
1708         // This method relies on extcodesize/address.code.length, which returns 0
1709         // for contracts in construction, since the code is only stored at the end
1710         // of the constructor execution.
1711 
1712         return account.code.length > 0;
1713     }
1714 
1715     /**
1716      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1717      * `recipient`, forwarding all available gas and reverting on errors.
1718      *
1719      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1720      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1721      * imposed by `transfer`, making them unable to receive funds via
1722      * `transfer`. {sendValue} removes this limitation.
1723      *
1724      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1725      *
1726      * IMPORTANT: because control is transferred to `recipient`, care must be
1727      * taken to not create reentrancy vulnerabilities. Consider using
1728      * {ReentrancyGuard} or the
1729      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1730      */
1731     function sendValue(address payable recipient, uint256 amount) internal {
1732         require(
1733             address(this).balance >= amount,
1734             "Address: insufficient balance"
1735         );
1736 
1737         (bool success, ) = recipient.call{value: amount}("");
1738         require(
1739             success,
1740             "Address: unable to send value, recipient may have reverted"
1741         );
1742     }
1743 
1744     /**
1745      * @dev Performs a Solidity function call using a low level `call`. A
1746      * plain `call` is an unsafe replacement for a function call: use this
1747      * function instead.
1748      *
1749      * If `target` reverts with a revert reason, it is bubbled up by this
1750      * function (like regular Solidity function calls).
1751      *
1752      * Returns the raw returned data. To convert to the expected return value,
1753      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1754      *
1755      * Requirements:
1756      *
1757      * - `target` must be a contract.
1758      * - calling `target` with `data` must not revert.
1759      *
1760      * _Available since v3.1._
1761      */
1762     function functionCall(address target, bytes memory data)
1763         internal
1764         returns (bytes memory)
1765     {
1766         return functionCall(target, data, "Address: low-level call failed");
1767     }
1768 
1769     /**
1770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1771      * `errorMessage` as a fallback revert reason when `target` reverts.
1772      *
1773      * _Available since v3.1._
1774      */
1775     function functionCall(
1776         address target,
1777         bytes memory data,
1778         string memory errorMessage
1779     ) internal returns (bytes memory) {
1780         return functionCallWithValue(target, data, 0, errorMessage);
1781     }
1782 
1783     /**
1784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1785      * but also transferring `value` wei to `target`.
1786      *
1787      * Requirements:
1788      *
1789      * - the calling contract must have an ETH balance of at least `value`.
1790      * - the called Solidity function must be `payable`.
1791      *
1792      * _Available since v3.1._
1793      */
1794     function functionCallWithValue(
1795         address target,
1796         bytes memory data,
1797         uint256 value
1798     ) internal returns (bytes memory) {
1799         return
1800             functionCallWithValue(
1801                 target,
1802                 data,
1803                 value,
1804                 "Address: low-level call with value failed"
1805             );
1806     }
1807 
1808     /**
1809      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1810      * with `errorMessage` as a fallback revert reason when `target` reverts.
1811      *
1812      * _Available since v3.1._
1813      */
1814     function functionCallWithValue(
1815         address target,
1816         bytes memory data,
1817         uint256 value,
1818         string memory errorMessage
1819     ) internal returns (bytes memory) {
1820         require(
1821             address(this).balance >= value,
1822             "Address: insufficient balance for call"
1823         );
1824         require(isContract(target), "Address: call to non-contract");
1825 
1826         (bool success, bytes memory returndata) = target.call{value: value}(
1827             data
1828         );
1829         return verifyCallResult(success, returndata, errorMessage);
1830     }
1831 
1832     /**
1833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1834      * but performing a static call.
1835      *
1836      * _Available since v3.3._
1837      */
1838     function functionStaticCall(address target, bytes memory data)
1839         internal
1840         view
1841         returns (bytes memory)
1842     {
1843         return
1844             functionStaticCall(
1845                 target,
1846                 data,
1847                 "Address: low-level static call failed"
1848             );
1849     }
1850 
1851     /**
1852      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1853      * but performing a static call.
1854      *
1855      * _Available since v3.3._
1856      */
1857     function functionStaticCall(
1858         address target,
1859         bytes memory data,
1860         string memory errorMessage
1861     ) internal view returns (bytes memory) {
1862         require(isContract(target), "Address: static call to non-contract");
1863 
1864         (bool success, bytes memory returndata) = target.staticcall(data);
1865         return verifyCallResult(success, returndata, errorMessage);
1866     }
1867 
1868     /**
1869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1870      * but performing a delegate call.
1871      *
1872      * _Available since v3.4._
1873      */
1874     function functionDelegateCall(address target, bytes memory data)
1875         internal
1876         returns (bytes memory)
1877     {
1878         return
1879             functionDelegateCall(
1880                 target,
1881                 data,
1882                 "Address: low-level delegate call failed"
1883             );
1884     }
1885 
1886     //1b0014041a0a15
1887     /**
1888      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1889      * but performing a delegate call.
1890      *
1891      * _Available since v3.4._
1892      */
1893     function functionDelegateCall(
1894         address target,
1895         bytes memory data,
1896         string memory errorMessage
1897     ) internal returns (bytes memory) {
1898         require(isContract(target), "Address: delegate call to non-contract");
1899 
1900         (bool success, bytes memory returndata) = target.delegatecall(data);
1901         return verifyCallResult(success, returndata, errorMessage);
1902     }
1903 
1904     /**
1905      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1906      * revert reason using the provided one.
1907      *
1908      * _Available since v4.3._
1909      */
1910     function verifyCallResult(
1911         bool success,
1912         bytes memory returndata,
1913         string memory errorMessage
1914     ) internal pure returns (bytes memory) {
1915         if (success) {
1916             return returndata;
1917         } else {
1918             // Look for revert reason and bubble it up if present
1919             if (returndata.length > 0) {
1920                 // The easiest way to bubble the revert reason is using memory via assembly
1921 
1922                 assembly {
1923                     let returndata_size := mload(returndata)
1924                     revert(add(32, returndata), returndata_size)
1925                 }
1926             } else {
1927                 revert(errorMessage);
1928             }
1929         }
1930     }
1931 }
1932 
1933 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1934 
1935 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1936 
1937 pragma solidity ^0.8.0;
1938 
1939 /**
1940  * @title ERC721 token receiver interface
1941  * @dev Interface for any contract that wants to support safeTransfers
1942  * from ERC721 asset contracts.
1943  */
1944 interface IERC721Receiver {
1945     /**
1946      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1947      * by `operator` from `from`, this function is called.
1948      *
1949      * It must return its Solidity selector to confirm the token transfer.
1950      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1951      *
1952      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1953      */
1954     function onERC721Received(
1955         address operator,
1956         address from,
1957         uint256 tokenId,
1958         bytes calldata data
1959     ) external returns (bytes4);
1960 }
1961 
1962 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1963 
1964 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1965 
1966 pragma solidity ^0.8.0;
1967 
1968 /**
1969  * @dev Interface of the ERC165 standard, as defined in the
1970  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1971  *
1972  * Implementers can declare support of contract interfaces, which can then be
1973  * queried by others ({ERC165Checker}).
1974  *
1975  * For an implementation, see {ERC165}.
1976  */
1977 interface IERC165 {
1978     /**
1979      * @dev Returns true if this contract implements the interface defined by
1980      * `interfaceId`. See the corresponding
1981      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1982      * to learn more about how these ids are created.
1983      *
1984      * This function call must use less than 30 000 gas.
1985      */
1986     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1987 }
1988 
1989 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1990 //hera
1991 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 /**
1996  * @dev Implementation of the {IERC165} interface.
1997  *
1998  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1999  * for the additional interface id that will be supported. For example:
2000  *
2001  * ```solidity
2002  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2003  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2004  * }
2005  * ```
2006  *
2007  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2008  */
2009 abstract contract ERC165 is IERC165 {
2010     /**
2011      * @dev See {IERC165-supportsInterface}.
2012      */
2013     function supportsInterface(bytes4 interfaceId)
2014         public
2015         view
2016         virtual
2017         override
2018         returns (bool)
2019     {
2020         return interfaceId == type(IERC165).interfaceId;
2021     }
2022 }
2023 
2024 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
2025 
2026 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
2027 
2028 pragma solidity ^0.8.0;
2029 
2030 /**
2031  * @dev Required interface of an ERC721 compliant contract.
2032  */
2033 interface IERC721 is IERC165 {
2034     /**
2035      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2036      */
2037     event Transfer(
2038         address indexed from,
2039         address indexed to,
2040         uint256 indexed tokenId
2041     );
2042 
2043     /**
2044      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2045      */
2046     event Approval(
2047         address indexed owner,
2048         address indexed approved,
2049         uint256 indexed tokenId
2050     );
2051 
2052     /**
2053      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2054      */
2055     event ApprovalForAll(
2056         address indexed owner,
2057         address indexed operator,
2058         bool approved
2059     );
2060 
2061     /**
2062      * @dev Returns the number of tokens in ``owner``'s account.
2063      */
2064     function balanceOf(address owner) external view returns (uint256 balance);
2065 
2066     /**
2067      * @dev Returns the owner of the `tokenId` token.
2068      *
2069      * Requirements:
2070      *
2071      * - `tokenId` must exist.
2072      */
2073     function ownerOf(uint256 tokenId) external view returns (address owner);
2074 
2075     /**
2076      * @dev Safely transfers `tokenId` token from `from` to `to`.
2077      *
2078      * Requirements:
2079      *
2080      * - `from` cannot be the zero address.
2081      * - `to` cannot be the zero address.
2082      * - `tokenId` token must exist and be owned by `from`.
2083      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2085      *
2086      * Emits a {Transfer} event.
2087      */
2088     function safeTransferFrom(
2089         address from,
2090         address to,
2091         uint256 tokenId,
2092         bytes calldata data
2093     ) external;
2094 
2095     /**
2096      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2097      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2098      *
2099      * Requirements:
2100      *
2101      * - `from` cannot be the zero address.
2102      * - `to` cannot be the zero address.
2103      * - `tokenId` token must exist and be owned by `from`.
2104      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2106      *
2107      * Emits a {Transfer} event.
2108      */
2109     function safeTransferFrom(
2110         address from,
2111         address to,
2112         uint256 tokenId
2113     ) external;
2114 
2115     /**
2116      * @dev Transfers `tokenId` token from `from` to `to`.
2117      *
2118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2119      *
2120      * Requirements:
2121      *
2122      * - `from` cannot be the zero address.
2123      * - `to` cannot be the zero address.
2124      * - `tokenId` token must be owned by `from`.
2125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2126      *
2127      * Emits a {Transfer} event.
2128      */
2129     function transferFrom(
2130         address from,
2131         address to,
2132         uint256 tokenId
2133     ) external;
2134 
2135     /**
2136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2137      * The approval is cleared when the token is transferred.
2138      *
2139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2140      *
2141      * Requirements:
2142      *
2143      * - The caller must own the token or be an approved operator.
2144      * - `tokenId` must exist.
2145      *
2146      * Emits an {Approval} event.
2147      */
2148     function approve(address to, uint256 tokenId) external;
2149 
2150     /**
2151      * @dev Approve or remove `operator` as an operator for the caller.
2152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2153      *
2154      * Requirements:
2155      *
2156      * - The `operator` cannot be the caller.
2157      *
2158      * Emits an {ApprovalForAll} event.
2159      */
2160     function setApprovalForAll(address operator, bool _approved) external;
2161 
2162     /**
2163      * @dev Returns the account approved for `tokenId` token.
2164      *
2165      * Requirements:
2166      *
2167      * - `tokenId` must exist.
2168      */
2169     function getApproved(uint256 tokenId)
2170         external
2171         view
2172         returns (address operator);
2173 
2174     /**
2175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2176      *
2177      * See {setApprovalForAll}
2178      */
2179     function isApprovedForAll(address owner, address operator)
2180         external
2181         view
2182         returns (bool);
2183 }
2184 
2185 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2186 
2187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2188 
2189 pragma solidity ^0.8.0;
2190 
2191 /**
2192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2193  * @dev See https://eips.ethereum.org/EIPS/eip-721
2194  */
2195 interface IERC721Metadata is IERC721 {
2196     /**
2197      * @dev Returns the token collection name.
2198      */
2199     function name() external view returns (string memory);
2200 
2201     /**
2202      * @dev Returns the token collection symbol.
2203      */
2204     function symbol() external view returns (string memory);
2205 
2206     /**
2207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2208      */
2209     function tokenURI(uint256 tokenId) external view returns (string memory);
2210 }
2211 
2212 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2213 
2214 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2215 
2216 pragma solidity ^0.8.0;
2217 
2218 /**
2219  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2220  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2221  * {ERC721Enumerable}.
2222  */
2223 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2224     using Address for address;
2225     using Strings for uint256;
2226 
2227     // Token name
2228     string private _name;
2229 
2230     // Token symbol
2231     string private _symbol;
2232 
2233     // Mapping from token ID to owner address
2234     mapping(uint256 => address) private _owners;
2235 
2236     // Mapping owner address to token count
2237     mapping(address => uint256) private _balances;
2238 
2239     // Mapping from token ID to approved address
2240     mapping(uint256 => address) private _tokenApprovals;
2241 
2242     // Mapping from owner to operator approvals
2243     mapping(address => mapping(address => bool)) private _operatorApprovals;
2244 
2245     /**
2246      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2247      */
2248     constructor(string memory name_, string memory symbol_) {
2249         _name = name_;
2250         _symbol = symbol_;
2251     }
2252 
2253     /**
2254      * @dev See {IERC165-supportsInterface}.
2255      */
2256     function supportsInterface(bytes4 interfaceId)
2257         public
2258         view
2259         virtual
2260         override(ERC165, IERC165)
2261         returns (bool)
2262     {
2263         return
2264             interfaceId == type(IERC721).interfaceId ||
2265             interfaceId == type(IERC721Metadata).interfaceId ||
2266             super.supportsInterface(interfaceId);
2267     }
2268 
2269     /**
2270      * @dev See {IERC721-balanceOf}.
2271      */
2272     function balanceOf(address owner)
2273         public
2274         view
2275         virtual
2276         override
2277         returns (uint256)
2278     {
2279         require(
2280             owner != address(0),
2281             "ERC721: address zero is not a valid owner"
2282         );
2283         return _balances[owner];
2284     }
2285 
2286     /**
2287      * @dev See {IERC721-ownerOf}.
2288      */
2289     function ownerOf(uint256 tokenId)
2290         public
2291         view
2292         virtual
2293         override
2294         returns (address)
2295     {
2296         address owner = _owners[tokenId];
2297         require(
2298             owner != address(0),
2299             "ERC721: owner query for nonexistent token"
2300         );
2301         return owner;
2302     }
2303 
2304     /**
2305      * @dev See {IERC721Metadata-name}.
2306      */
2307     function name() public view virtual override returns (string memory) {
2308         return _name;
2309     }
2310 
2311     /**
2312      * @dev See {IERC721Metadata-symbol}.
2313      */
2314     function symbol() public view virtual override returns (string memory) {
2315         return _symbol;
2316     }
2317 
2318     /**
2319      * @dev See {IERC721Metadata-tokenURI}.
2320      */
2321     function tokenURI(uint256 tokenId)
2322         public
2323         view
2324         virtual
2325         override
2326         returns (string memory)
2327     {
2328         require(
2329             _exists(tokenId),
2330             "ERC721Metadata: URI query for nonexistent token"
2331         );
2332 
2333         string memory baseURI = _baseURI();
2334         return
2335             bytes(baseURI).length > 0
2336                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2337                 : "";
2338     }
2339 
2340     /**
2341      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2342      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2343      * by default, can be overridden in child contracts.
2344      */
2345     function _baseURI() internal view virtual returns (string memory) {
2346         return "";
2347     }
2348 
2349     /**
2350      * @dev See {IERC721-approve}.
2351      */
2352     function approve(address to, uint256 tokenId) public virtual override {
2353         address owner = ERC721.ownerOf(tokenId);
2354         require(to != owner, "ERC721: approval to current owner");
2355 
2356         require(
2357             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2358             "ERC721: approve caller is not owner nor approved for all"
2359         );
2360 
2361         _approve(to, tokenId);
2362     }
2363 
2364     /**
2365      * @dev See {IERC721-getApproved}.
2366      */
2367     function getApproved(uint256 tokenId)
2368         public
2369         view
2370         virtual
2371         override
2372         returns (address)
2373     {
2374         require(
2375             _exists(tokenId),
2376             "ERC721: approved query for nonexistent token"
2377         );
2378 
2379         return _tokenApprovals[tokenId];
2380     }
2381 
2382     /**
2383      * @dev See {IERC721-setApprovalForAll}.
2384      */
2385     function setApprovalForAll(address operator, bool approved)
2386         public
2387         virtual
2388         override
2389     {
2390         _setApprovalForAll(_msgSender(), operator, approved);
2391     }
2392 
2393     /**
2394      * @dev See {IERC721-isApprovedForAll}.
2395      */
2396     function isApprovedForAll(address owner, address operator)
2397         public
2398         view
2399         virtual
2400         override
2401         returns (bool)
2402     {
2403         return _operatorApprovals[owner][operator];
2404     }
2405 
2406     /**
2407      * @dev See {IERC721-transferFrom}.
2408      */
2409     function transferFrom(
2410         address from,
2411         address to,
2412         uint256 tokenId
2413     ) public virtual override {
2414         //solhint-disable-next-line max-line-length
2415         require(
2416             _isApprovedOrOwner(_msgSender(), tokenId),
2417             "ERC721: transfer caller is not owner nor approved"
2418         );
2419 
2420         _transfer(from, to, tokenId);
2421     }
2422 
2423     /**
2424      * @dev See {IERC721-safeTransferFrom}.
2425      */
2426     function safeTransferFrom(
2427         address from,
2428         address to,
2429         uint256 tokenId
2430     ) public virtual override {
2431         safeTransferFrom(from, to, tokenId, "");
2432     }
2433 
2434     /**
2435      * @dev See {IERC721-safeTransferFrom}.
2436      */
2437     function safeTransferFrom(
2438         address from,
2439         address to,
2440         uint256 tokenId,
2441         bytes memory data
2442     ) public virtual override {
2443         require(
2444             _isApprovedOrOwner(_msgSender(), tokenId),
2445             "ERC721: transfer caller is not owner nor approved"
2446         );
2447         _safeTransfer(from, to, tokenId, data);
2448     }
2449 
2450     /**
2451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2453      *
2454      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2455      *
2456      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2457      * implement alternative mechanisms to perform token transfer, such as signature-based.
2458      *
2459      * Requirements:
2460      *
2461      * - `from` cannot be the zero address.
2462      * - `to` cannot be the zero address.
2463      * - `tokenId` token must exist and be owned by `from`.
2464      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2465      *
2466      * Emits a {Transfer} event.
2467      */
2468     function _safeTransfer(
2469         address from,
2470         address to,
2471         uint256 tokenId,
2472         bytes memory data
2473     ) internal virtual {
2474         _transfer(from, to, tokenId);
2475         require(
2476             _checkOnERC721Received(from, to, tokenId, data),
2477             "ERC721: transfer to non ERC721Receiver implementer"
2478         );
2479     }
2480 
2481     /**
2482      * @dev Returns whether `tokenId` exists.
2483      *
2484      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2485      *
2486      * Tokens start existing when they are minted (`_mint`),
2487      * and stop existing when they are burned (`_burn`).
2488      */
2489     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2490         return _owners[tokenId] != address(0);
2491     }
2492 
2493     /**
2494      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2495      *
2496      * Requirements:
2497      *
2498      * - `tokenId` must exist.
2499      */
2500     function _isApprovedOrOwner(address spender, uint256 tokenId)
2501         internal
2502         view
2503         virtual
2504         returns (bool)
2505     {
2506         require(
2507             _exists(tokenId),
2508             "ERC721: operator query for nonexistent token"
2509         );
2510         address owner = ERC721.ownerOf(tokenId);
2511         return (spender == owner ||
2512             isApprovedForAll(owner, spender) ||
2513             getApproved(tokenId) == spender);
2514     }
2515 
2516     /**
2517      * @dev Safely mints `tokenId` and transfers it to `to`.
2518      *
2519      * Requirements:
2520      *
2521      * - `tokenId` must not exist.
2522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2523      *
2524      * Emits a {Transfer} event.
2525      */
2526     function _safeMint(address to, uint256 tokenId) internal virtual {
2527         _safeMint(to, tokenId, "");
2528     }
2529 
2530     /**
2531      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2532      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2533      */
2534     function _safeMint(
2535         address to,
2536         uint256 tokenId,
2537         bytes memory data
2538     ) internal virtual {
2539         _mint(to, tokenId);
2540         require(
2541             _checkOnERC721Received(address(0), to, tokenId, data),
2542             "ERC721: transfer to non ERC721Receiver implementer"
2543         );
2544     }
2545 
2546     /**
2547      * @dev Mints `tokenId` and transfers it to `to`.
2548      *
2549      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2550      *
2551      * Requirements:
2552      *
2553      * - `tokenId` must not exist.
2554      * - `to` cannot be the zero address.
2555      *
2556      * Emits a {Transfer} event.
2557      */
2558     function _mint(address to, uint256 tokenId) internal virtual {
2559         require(to != address(0), "ERC721: mint to the zero address");
2560         require(!_exists(tokenId), "ERC721: token already minted");
2561 
2562         _beforeTokenTransfer(address(0), to, tokenId);
2563 
2564         _balances[to] += 1;
2565         _owners[tokenId] = to;
2566 
2567         emit Transfer(address(0), to, tokenId);
2568 
2569         _afterTokenTransfer(address(0), to, tokenId);
2570     }
2571 
2572     /**
2573      * @dev Destroys `tokenId`.
2574      * The approval is cleared when the token is burned.
2575      *
2576      * Requirements:
2577      *
2578      * - `tokenId` must exist.
2579      *
2580      * Emits a {Transfer} event.
2581      */
2582     function _burn(uint256 tokenId) internal virtual {
2583         address owner = ERC721.ownerOf(tokenId);
2584 
2585         _beforeTokenTransfer(owner, address(0), tokenId);
2586 
2587         // Clear approvals
2588         _approve(address(0), tokenId);
2589 
2590         _balances[owner] -= 1;
2591         delete _owners[tokenId];
2592 
2593         emit Transfer(owner, address(0), tokenId);
2594 
2595         _afterTokenTransfer(owner, address(0), tokenId);
2596     }
2597 
2598     /**
2599      * @dev Transfers `tokenId` from `from` to `to`.
2600      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2601      *
2602      * Requirements:
2603      *
2604      * - `to` cannot be the zero address.
2605      * - `tokenId` token must be owned by `from`.
2606      *
2607      * Emits a {Transfer} event.
2608      */
2609     function _transfer(
2610         address from,
2611         address to,
2612         uint256 tokenId
2613     ) internal virtual {
2614         require(
2615             ERC721.ownerOf(tokenId) == from,
2616             "ERC721: transfer from incorrect owner"
2617         );
2618         require(to != address(0), "ERC721: transfer to the zero address");
2619 
2620         _beforeTokenTransfer(from, to, tokenId);
2621 
2622         // Clear approvals from the previous owner
2623         _approve(address(0), tokenId);
2624 
2625         _balances[from] -= 1;
2626         _balances[to] += 1;
2627         _owners[tokenId] = to;
2628 
2629         emit Transfer(from, to, tokenId);
2630 
2631         _afterTokenTransfer(from, to, tokenId);
2632     }
2633 
2634     /**
2635      * @dev Approve `to` to operate on `tokenId`
2636      *
2637      * Emits an {Approval} event.
2638      */
2639     function _approve(address to, uint256 tokenId) internal virtual {
2640         _tokenApprovals[tokenId] = to;
2641         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2642     }
2643 
2644     /**
2645      * @dev Approve `operator` to operate on all of `owner` tokens
2646      *
2647      * Emits an {ApprovalForAll} event.
2648      */
2649     function _setApprovalForAll(
2650         address owner,
2651         address operator,
2652         bool approved
2653     ) internal virtual {
2654         require(owner != operator, "ERC721: approve to caller");
2655         _operatorApprovals[owner][operator] = approved;
2656         emit ApprovalForAll(owner, operator, approved);
2657     }
2658 
2659     /**
2660      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2661      * The call is not executed if the target address is not a contract.
2662      *
2663      * @param from address representing the previous owner of the given token ID
2664      * @param to target address that will receive the tokens
2665      * @param tokenId uint256 ID of the token to be transferred
2666      * @param data bytes optional data to send along with the call
2667      * @return bool whether the call correctly returned the expected magic value
2668      */
2669     function _checkOnERC721Received(
2670         address from,
2671         address to,
2672         uint256 tokenId,
2673         bytes memory data
2674     ) private returns (bool) {
2675         if (to.isContract()) {
2676             try
2677                 IERC721Receiver(to).onERC721Received(
2678                     _msgSender(),
2679                     from,
2680                     tokenId,
2681                     data
2682                 )
2683             returns (bytes4 retval) {
2684                 return retval == IERC721Receiver.onERC721Received.selector;
2685             } catch (bytes memory reason) {
2686                 if (reason.length == 0) {
2687                     revert(
2688                         "ERC721: transfer to non ERC721Receiver implementer"
2689                     );
2690                 } else {
2691                     assembly {
2692                         revert(add(32, reason), mload(reason))
2693                     }
2694                 }
2695             }
2696         } else {
2697             return true;
2698         }
2699     }
2700 
2701     /**
2702      * @dev Hook that is called before any token transfer. This includes minting
2703      * and burning.
2704      *
2705      * Calling conditions:
2706      *
2707      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2708      * transferred to `to`.
2709      * - When `from` is zero, `tokenId` will be minted for `to`.
2710      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2711      * - `from` and `to` are never both zero.
2712      *
2713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2714      */
2715     function _beforeTokenTransfer(
2716         address from,
2717         address to,
2718         uint256 tokenId
2719     ) internal virtual {}
2720 
2721     /**
2722      * @dev Hook that is called after any transfer of tokens. This includes
2723      * minting and burning.
2724      *
2725      * Calling conditions:
2726      *
2727      * - when `from` and `to` are both non-zero.
2728      * - `from` and `to` are never both zero.
2729      *
2730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2731      */
2732     function _afterTokenTransfer(
2733         address from,
2734         address to,
2735         uint256 tokenId
2736     ) internal virtual {}
2737 }
2738 
2739 pragma solidity ^0.8.0;
2740 
2741 contract RandomFoxes is ERC721A, Ownable, ReentrancyGuard {
2742     using Strings for uint256;
2743 
2744     string private baseURI;
2745 
2746     uint256 public maxPerWallet = 4;
2747     uint256 public price = 0.0066 ether;
2748 
2749     uint256 public maxFreePerWallet = 1;
2750 
2751     uint256 public maxSupply = 3400; // 67 reserved for team
2752     bool public mintEnabled = false;
2753     bool public publicEnabled = false;
2754 
2755     bytes32 vipRoot;
2756     bytes32 whitelistRoot;
2757 
2758     string public hiddenURI = "ipfs://bafybeibut3ro7tth33vn2hkdqdlcwsqzuukcml6x3q7yytgkaljpy25rou/hidden.json";
2759 
2760     bool public revealed = false;
2761 
2762     mapping(address => bool) private _mintedFree;
2763 
2764     constructor() ERC721A("RFoxSquad", "RFS") {}
2765 
2766     function vipMint(bytes32[] calldata _merkleProof, uint256 count)
2767         external
2768         payable
2769         nonReentrant
2770     {
2771         bool isFreeLeft = !(_mintedFree[msg.sender]);
2772         bool isEqual = count == maxFreePerWallet;
2773 
2774         uint256 cost = price;
2775 
2776         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2777 
2778         if (isFreeLeft && isEqual) {
2779             cost = 0;
2780         }
2781 
2782         if (isFreeLeft && !isEqual) {
2783             require(
2784                 msg.value >= (count - maxFreePerWallet) * cost,
2785                 "Please send the exact amount."
2786             );
2787         } else {
2788             require(msg.value >= count * cost, "Please send the exact amount.");
2789         }
2790         require(
2791             MerkleProof.verify(_merkleProof, vipRoot, leaf),
2792             "Incorrect Whitelist Proof"
2793         );
2794         require(totalSupply() + count <= maxSupply, "No more");
2795         require(count > 0, "Please enter a number");
2796         require(mintEnabled, "Minting is not live yet");
2797         require(
2798             _numberMinted(msg.sender) + count <= maxPerWallet,
2799             "Can not mint more than 4"
2800         );
2801 
2802         _mintedFree[msg.sender] = true;
2803 
2804         _safeMint(msg.sender, count);
2805     }
2806 
2807     function whitelistMint(bytes32[] calldata _merkleProof, uint256 count)
2808         external
2809         payable
2810     {
2811         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2812 
2813         require(
2814             MerkleProof.verify(_merkleProof, whitelistRoot, leaf),
2815             "Incorrect Whitelist Proof"
2816         );
2817         require(msg.value >= price * count, "Please send the exact amount.");
2818         require(
2819             _numberMinted(msg.sender) + count <= maxPerWallet,
2820             "You cant mint anymore"
2821         );
2822         require(totalSupply() + count <= maxSupply, "No more");
2823         require(mintEnabled, "Minting is not live yet");
2824 
2825         _safeMint(msg.sender, count);
2826     }
2827 
2828     function publicMint(uint256 count) external payable {
2829         require(msg.value >= count * price, "Please send the exact amount.");
2830         require(totalSupply() + count <= maxSupply, "No more NFT left");
2831         require(
2832             _numberMinted(msg.sender) + count <= maxPerWallet,
2833             "Can not mint more than 4"
2834         );
2835         require(count > 0, "Please enter a number");
2836         require(publicEnabled, "Minting is not live yet");
2837 
2838         _safeMint(msg.sender, count);
2839     }
2840 
2841     function _baseURI() internal view virtual override returns (string memory) {
2842         return baseURI;
2843     }
2844 
2845     function _isMintedFree(address minter) external view returns (bool) {
2846         return _mintedFree[minter];
2847     }
2848 
2849     function _mintedAmount(address account) external view returns (uint256) {
2850         return _numberMinted(account);
2851     }
2852 
2853     function tokenURI(uint256 tokenId)
2854         public
2855         view
2856         virtual
2857         override
2858         returns (string memory)
2859     {
2860         require(
2861             _exists(tokenId),
2862             "ERC721AMetadata: URI query for nonexistent token"
2863         );
2864         if (revealed == false) {
2865             return hiddenURI;
2866         }
2867 
2868         string memory currentBaseURI = _baseURI();
2869         return
2870             bytes(currentBaseURI).length > 0
2871                 ? string(
2872                     abi.encodePacked(
2873                         currentBaseURI,
2874                         tokenId.toString(),
2875                         ".json"
2876                     )
2877                 )
2878                 : "";
2879     }
2880 
2881     function setPreSaleRoot(bytes32 _presaleRoot_1, bytes32 _presaleRoot_2)
2882         external
2883         onlyOwner
2884     {
2885         vipRoot = _presaleRoot_1;
2886         whitelistRoot = _presaleRoot_2;
2887     }
2888 
2889     // Only Owner Functions-----------
2890     function setBaseURI(string memory uri) public onlyOwner {
2891         baseURI = uri;
2892     }
2893 
2894     function setMaxPerWallet(uint256 amount) external onlyOwner {
2895         maxPerWallet = amount;
2896     }
2897 
2898     function setPrice(uint256 _newPrice) external onlyOwner {
2899         price = _newPrice;
2900     }
2901 
2902     function setMaxSupply(uint256 _newSupply) external onlyOwner {
2903         maxSupply = _newSupply;
2904     }
2905 
2906     function flipWhitelist(bool status) external onlyOwner {
2907         mintEnabled = status;
2908     }
2909 
2910     function flipPublic(bool status) external onlyOwner {
2911         publicEnabled = status;
2912     }
2913 
2914     function reveal() external onlyOwner {
2915         revealed = !revealed;
2916     }
2917 
2918     function batchMint(uint256 _mintAmount, address destination)
2919         public
2920         onlyOwner
2921     {
2922         require(_mintAmount > 0, "need to mint at least 1 NFT");
2923         uint256 supply = totalSupply();
2924         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2925 
2926         _safeMint(destination, _mintAmount);
2927     }
2928 
2929     function withdraw() external onlyOwner {
2930         (bool success, ) = payable(msg.sender).call{
2931             value: address(this).balance
2932         }("");
2933         require(success, "Transfer failed.");
2934     }
2935 }