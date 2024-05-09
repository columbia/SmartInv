1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
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
68 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev These functions deal with verification of Merkle Tree proofs.
77  *
78  * The proofs can be generated using the JavaScript library
79  * https://github.com/miguelmota/merkletreejs[merkletreejs].
80  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
81  *
82  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
83  *
84  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
85  * hashing, or use a hash function other than keccak256 for hashing leaves.
86  * This is because the concatenation of a sorted pair of internal nodes in
87  * the merkle tree could be reinterpreted as a leaf value.
88  */
89 library MerkleProof {
90     /**
91      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
92      * defined by `root`. For this, a `proof` must be provided, containing
93      * sibling hashes on the branch from the leaf to the root of the tree. Each
94      * pair of leaves and each pair of pre-images are assumed to be sorted.
95      */
96     function verify(
97         bytes32[] memory proof,
98         bytes32 root,
99         bytes32 leaf
100     ) internal pure returns (bool) {
101         return processProof(proof, leaf) == root;
102     }
103 
104     /**
105      * @dev Calldata version of {verify}
106      *
107      * _Available since v4.7._
108      */
109     function verifyCalldata(
110         bytes32[] calldata proof,
111         bytes32 root,
112         bytes32 leaf
113     ) internal pure returns (bool) {
114         return processProofCalldata(proof, leaf) == root;
115     }
116 
117     /**
118      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
119      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
120      * hash matches the root of the tree. When processing the proof, the pairs
121      * of leafs & pre-images are assumed to be sorted.
122      *
123      * _Available since v4.4._
124      */
125     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
126         bytes32 computedHash = leaf;
127         for (uint256 i = 0; i < proof.length; i++) {
128             computedHash = _hashPair(computedHash, proof[i]);
129         }
130         return computedHash;
131     }
132 
133     /**
134      * @dev Calldata version of {processProof}
135      *
136      * _Available since v4.7._
137      */
138     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
139         bytes32 computedHash = leaf;
140         for (uint256 i = 0; i < proof.length; i++) {
141             computedHash = _hashPair(computedHash, proof[i]);
142         }
143         return computedHash;
144     }
145 
146     /**
147      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
148      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
149      *
150      * _Available since v4.7._
151      */
152     function multiProofVerify(
153         bytes32[] memory proof,
154         bool[] memory proofFlags,
155         bytes32 root,
156         bytes32[] memory leaves
157     ) internal pure returns (bool) {
158         return processMultiProof(proof, proofFlags, leaves) == root;
159     }
160 
161     /**
162      * @dev Calldata version of {multiProofVerify}
163      *
164      * _Available since v4.7._
165      */
166     function multiProofVerifyCalldata(
167         bytes32[] calldata proof,
168         bool[] calldata proofFlags,
169         bytes32 root,
170         bytes32[] memory leaves
171     ) internal pure returns (bool) {
172         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
173     }
174 
175     /**
176      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
177      * consuming from one or the other at each step according to the instructions given by
178      * `proofFlags`.
179      *
180      * _Available since v4.7._
181      */
182     function processMultiProof(
183         bytes32[] memory proof,
184         bool[] memory proofFlags,
185         bytes32[] memory leaves
186     ) internal pure returns (bytes32 merkleRoot) {
187         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
188         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
189         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
190         // the merkle tree.
191         uint256 leavesLen = leaves.length;
192         uint256 totalHashes = proofFlags.length;
193 
194         // Check proof validity.
195         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
196 
197         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
198         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
199         bytes32[] memory hashes = new bytes32[](totalHashes);
200         uint256 leafPos = 0;
201         uint256 hashPos = 0;
202         uint256 proofPos = 0;
203         // At each step, we compute the next hash using two values:
204         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
205         //   get the next hash.
206         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
207         //   `proof` array.
208         for (uint256 i = 0; i < totalHashes; i++) {
209             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
210             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
211             hashes[i] = _hashPair(a, b);
212         }
213 
214         if (totalHashes > 0) {
215             return hashes[totalHashes - 1];
216         } else if (leavesLen > 0) {
217             return leaves[0];
218         } else {
219             return proof[0];
220         }
221     }
222 
223     /**
224      * @dev Calldata version of {processMultiProof}
225      *
226      * _Available since v4.7._
227      */
228     function processMultiProofCalldata(
229         bytes32[] calldata proof,
230         bool[] calldata proofFlags,
231         bytes32[] memory leaves
232     ) internal pure returns (bytes32 merkleRoot) {
233         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
234         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
235         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
236         // the merkle tree.
237         uint256 leavesLen = leaves.length;
238         uint256 totalHashes = proofFlags.length;
239 
240         // Check proof validity.
241         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
242 
243         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
244         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
245         bytes32[] memory hashes = new bytes32[](totalHashes);
246         uint256 leafPos = 0;
247         uint256 hashPos = 0;
248         uint256 proofPos = 0;
249         // At each step, we compute the next hash using two values:
250         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
251         //   get the next hash.
252         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
253         //   `proof` array.
254         for (uint256 i = 0; i < totalHashes; i++) {
255             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
256             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
257             hashes[i] = _hashPair(a, b);
258         }
259 
260         if (totalHashes > 0) {
261             return hashes[totalHashes - 1];
262         } else if (leavesLen > 0) {
263             return leaves[0];
264         } else {
265             return proof[0];
266         }
267     }
268 
269     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
270         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
271     }
272 
273     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
274         /// @solidity memory-safe-assembly
275         assembly {
276             mstore(0x00, a)
277             mstore(0x20, b)
278             value := keccak256(0x00, 0x40)
279         }
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Context.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Provides information about the current execution context, including the
292  * sender of the transaction and its data. While these are generally available
293  * via msg.sender and msg.data, they should not be accessed in such a direct
294  * manner, since when dealing with meta-transactions the account sending and
295  * paying for execution may not be the actual sender (as far as an application
296  * is concerned).
297  *
298  * This contract is only required for intermediate, library-like contracts.
299  */
300 abstract contract Context {
301     function _msgSender() internal view virtual returns (address) {
302         return msg.sender;
303     }
304 
305     function _msgData() internal view virtual returns (bytes calldata) {
306         return msg.data;
307     }
308 }
309 
310 // File: @openzeppelin/contracts/access/Ownable.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Contract module which provides a basic access control mechanism, where
320  * there is an account (an owner) that can be granted exclusive access to
321  * specific functions.
322  *
323  * By default, the owner account will be the one that deploys the contract. This
324  * can later be changed with {transferOwnership}.
325  *
326  * This module is used through inheritance. It will make available the modifier
327  * `onlyOwner`, which can be applied to your functions to restrict their use to
328  * the owner.
329  */
330 abstract contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor() {
339         _transferOwnership(_msgSender());
340     }
341 
342     /**
343      * @dev Returns the address of the current owner.
344      */
345     function owner() public view virtual returns (address) {
346         return _owner;
347     }
348 
349     /**
350      * @dev Throws if called by any account other than the owner.
351      */
352     modifier onlyOwner() {
353         require(owner() == _msgSender(), "Ownable: caller is not the owner");
354         _;
355     }
356 
357     /**
358      * @dev Leaves the contract without owner. It will not be possible to call
359      * `onlyOwner` functions anymore. Can only be called by the current owner.
360      *
361      * NOTE: Renouncing ownership will leave the contract without an owner,
362      * thereby removing any functionality that is only available to the owner.
363      */
364     function renounceOwnership() public virtual onlyOwner {
365         _transferOwnership(address(0));
366     }
367 
368     /**
369      * @dev Transfers ownership of the contract to a new account (`newOwner`).
370      * Can only be called by the current owner.
371      */
372     function transferOwnership(address newOwner) public virtual onlyOwner {
373         require(newOwner != address(0), "Ownable: new owner is the zero address");
374         _transferOwnership(newOwner);
375     }
376 
377     /**
378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
379      * Internal function without access restriction.
380      */
381     function _transferOwnership(address newOwner) internal virtual {
382         address oldOwner = _owner;
383         _owner = newOwner;
384         emit OwnershipTransferred(oldOwner, newOwner);
385     }
386 }
387 
388 // File: erc721a/contracts/IERC721A.sol
389 
390 
391 // ERC721A Contracts v4.0.0
392 // Creator: Chiru Labs
393 
394 pragma solidity ^0.8.4;
395 
396 /**
397  * @dev Interface of an ERC721A compliant contract.
398  */
399 interface IERC721A {
400     /**
401      * The caller must own the token or be an approved operator.
402      */
403     error ApprovalCallerNotOwnerNorApproved();
404 
405     /**
406      * The token does not exist.
407      */
408     error ApprovalQueryForNonexistentToken();
409 
410     /**
411      * The caller cannot approve to their own address.
412      */
413     error ApproveToCaller();
414 
415     /**
416      * The caller cannot approve to the current owner.
417      */
418     error ApprovalToCurrentOwner();
419 
420     /**
421      * Cannot query the balance for the zero address.
422      */
423     error BalanceQueryForZeroAddress();
424 
425     /**
426      * Cannot mint to the zero address.
427      */
428     error MintToZeroAddress();
429 
430     /**
431      * The quantity of tokens minted must be more than zero.
432      */
433     error MintZeroQuantity();
434 
435     /**
436      * The token does not exist.
437      */
438     error OwnerQueryForNonexistentToken();
439 
440     /**
441      * The caller must own the token or be an approved operator.
442      */
443     error TransferCallerNotOwnerNorApproved();
444 
445     /**
446      * The token must be owned by `from`.
447      */
448     error TransferFromIncorrectOwner();
449 
450     /**
451      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
452      */
453     error TransferToNonERC721ReceiverImplementer();
454 
455     /**
456      * Cannot transfer to the zero address.
457      */
458     error TransferToZeroAddress();
459 
460     /**
461      * The token does not exist.
462      */
463     error URIQueryForNonexistentToken();
464 
465     struct TokenOwnership {
466         // The address of the owner.
467         address addr;
468         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
469         uint64 startTimestamp;
470         // Whether the token has been burned.
471         bool burned;
472     }
473 
474     /**
475      * @dev Returns the total amount of tokens stored by the contract.
476      *
477      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
478      */
479     function totalSupply() external view returns (uint256);
480 
481     // ==============================
482     //            IERC165
483     // ==============================
484 
485     /**
486      * @dev Returns true if this contract implements the interface defined by
487      * `interfaceId`. See the corresponding
488      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
489      * to learn more about how these ids are created.
490      *
491      * This function call must use less than 30 000 gas.
492      */
493     function supportsInterface(bytes4 interfaceId) external view returns (bool);
494 
495     // ==============================
496     //            IERC721
497     // ==============================
498 
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must exist and be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
537      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
538      *
539      * Emits a {Transfer} event.
540      */
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId,
545         bytes calldata data
546     ) external;
547 
548     /**
549      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
550      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Transfers `tokenId` token from `from` to `to`.
570      *
571      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      *
580      * Emits a {Transfer} event.
581      */
582     function transferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
590      * The approval is cleared when the token is transferred.
591      *
592      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
593      *
594      * Requirements:
595      *
596      * - The caller must own the token or be an approved operator.
597      * - `tokenId` must exist.
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address to, uint256 tokenId) external;
602 
603     /**
604      * @dev Approve or remove `operator` as an operator for the caller.
605      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
606      *
607      * Requirements:
608      *
609      * - The `operator` cannot be the caller.
610      *
611      * Emits an {ApprovalForAll} event.
612      */
613     function setApprovalForAll(address operator, bool _approved) external;
614 
615     /**
616      * @dev Returns the account approved for `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function getApproved(uint256 tokenId) external view returns (address operator);
623 
624     /**
625      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
626      *
627      * See {setApprovalForAll}
628      */
629     function isApprovedForAll(address owner, address operator) external view returns (bool);
630 
631     // ==============================
632     //        IERC721Metadata
633     // ==============================
634 
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the token collection symbol.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
647      */
648     function tokenURI(uint256 tokenId) external view returns (string memory);
649 }
650 
651 // File: erc721a/contracts/ERC721A.sol
652 
653 
654 // ERC721A Contracts v4.0.0
655 // Creator: Chiru Labs
656 
657 pragma solidity ^0.8.4;
658 
659 
660 /**
661  * @dev ERC721 token receiver interface.
662  */
663 interface ERC721A__IERC721Receiver {
664     function onERC721Received(
665         address operator,
666         address from,
667         uint256 tokenId,
668         bytes calldata data
669     ) external returns (bytes4);
670 }
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata extension. Built to optimize for lower gas during batch mints.
675  *
676  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
677  *
678  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
679  *
680  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
681  */
682 contract ERC721A is IERC721A {
683     // Mask of an entry in packed address data.
684     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
685 
686     // The bit position of `numberMinted` in packed address data.
687     uint256 private constant BITPOS_NUMBER_MINTED = 64;
688 
689     // The bit position of `numberBurned` in packed address data.
690     uint256 private constant BITPOS_NUMBER_BURNED = 128;
691 
692     // The bit position of `aux` in packed address data.
693     uint256 private constant BITPOS_AUX = 192;
694 
695     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
696     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
697 
698     // The bit position of `startTimestamp` in packed ownership.
699     uint256 private constant BITPOS_START_TIMESTAMP = 160;
700 
701     // The bit mask of the `burned` bit in packed ownership.
702     uint256 private constant BITMASK_BURNED = 1 << 224;
703     
704     // The bit position of the `nextInitialized` bit in packed ownership.
705     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
706 
707     // The bit mask of the `nextInitialized` bit in packed ownership.
708     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
709 
710     // The tokenId of the next token to be minted.
711     uint256 private _currentIndex;
712 
713     // The number of tokens burned.
714     uint256 private _burnCounter;
715 
716     // Token name
717     string private _name;
718 
719     // Token symbol
720     string private _symbol;
721 
722     // Mapping from token ID to ownership details
723     // An empty struct value does not necessarily mean the token is unowned.
724     // See `_packedOwnershipOf` implementation for details.
725     //
726     // Bits Layout:
727     // - [0..159]   `addr`
728     // - [160..223] `startTimestamp`
729     // - [224]      `burned`
730     // - [225]      `nextInitialized`
731     mapping(uint256 => uint256) private _packedOwnerships;
732 
733     // Mapping owner address to address data.
734     //
735     // Bits Layout:
736     // - [0..63]    `balance`
737     // - [64..127]  `numberMinted`
738     // - [128..191] `numberBurned`
739     // - [192..255] `aux`
740     mapping(address => uint256) private _packedAddressData;
741 
742     // Mapping from token ID to approved address.
743     mapping(uint256 => address) private _tokenApprovals;
744 
745     // Mapping from owner to operator approvals
746     mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748     constructor(string memory name_, string memory symbol_) {
749         _name = name_;
750         _symbol = symbol_;
751         _currentIndex = _startTokenId();
752     }
753 
754     /**
755      * @dev Returns the starting token ID. 
756      * To change the starting token ID, please override this function.
757      */
758     function _startTokenId() internal view virtual returns (uint256) {
759         return 0;
760     }
761 
762     /**
763      * @dev Returns the next token ID to be minted.
764      */
765     function _nextTokenId() internal view returns (uint256) {
766         return _currentIndex;
767     }
768 
769     /**
770      * @dev Returns the total number of tokens in existence.
771      * Burned tokens will reduce the count. 
772      * To get the total number of tokens minted, please see `_totalMinted`.
773      */
774     function totalSupply() public view override returns (uint256) {
775         // Counter underflow is impossible as _burnCounter cannot be incremented
776         // more than `_currentIndex - _startTokenId()` times.
777         unchecked {
778             return _currentIndex - _burnCounter - _startTokenId();
779         }
780     }
781 
782     /**
783      * @dev Returns the total amount of tokens minted in the contract.
784      */
785     function _totalMinted() internal view returns (uint256) {
786         // Counter underflow is impossible as _currentIndex does not decrement,
787         // and it is initialized to `_startTokenId()`
788         unchecked {
789             return _currentIndex - _startTokenId();
790         }
791     }
792 
793     /**
794      * @dev Returns the total number of tokens burned.
795      */
796     function _totalBurned() internal view returns (uint256) {
797         return _burnCounter;
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
804         // The interface IDs are constants representing the first 4 bytes of the XOR of
805         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
806         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
807         return
808             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
809             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
810             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
811     }
812 
813     /**
814      * @dev See {IERC721-balanceOf}.
815      */
816     function balanceOf(address owner) public view override returns (uint256) {
817         if (owner == address(0)) revert BalanceQueryForZeroAddress();
818         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
819     }
820 
821     /**
822      * Returns the number of tokens minted by `owner`.
823      */
824     function _numberMinted(address owner) internal view returns (uint256) {
825         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
826     }
827 
828     /**
829      * Returns the number of tokens burned by or on behalf of `owner`.
830      */
831     function _numberBurned(address owner) internal view returns (uint256) {
832         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
833     }
834 
835     /**
836      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
837      */
838     function _getAux(address owner) internal view returns (uint64) {
839         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
840     }
841 
842     /**
843      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
844      * If there are multiple variables, please pack them into a uint64.
845      */
846     function _setAux(address owner, uint64 aux) internal {
847         uint256 packed = _packedAddressData[owner];
848         uint256 auxCasted;
849         assembly { // Cast aux without masking.
850             auxCasted := aux
851         }
852         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
853         _packedAddressData[owner] = packed;
854     }
855 
856     /**
857      * Returns the packed ownership data of `tokenId`.
858      */
859     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
860         uint256 curr = tokenId;
861 
862         unchecked {
863             if (_startTokenId() <= curr)
864                 if (curr < _currentIndex) {
865                     uint256 packed = _packedOwnerships[curr];
866                     // If not burned.
867                     if (packed & BITMASK_BURNED == 0) {
868                         // Invariant:
869                         // There will always be an ownership that has an address and is not burned
870                         // before an ownership that does not have an address and is not burned.
871                         // Hence, curr will not underflow.
872                         //
873                         // We can directly compare the packed value.
874                         // If the address is zero, packed is zero.
875                         while (packed == 0) {
876                             packed = _packedOwnerships[--curr];
877                         }
878                         return packed;
879                     }
880                 }
881         }
882         revert OwnerQueryForNonexistentToken();
883     }
884 
885     /**
886      * Returns the unpacked `TokenOwnership` struct from `packed`.
887      */
888     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
889         ownership.addr = address(uint160(packed));
890         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
891         ownership.burned = packed & BITMASK_BURNED != 0;
892     }
893 
894     /**
895      * Returns the unpacked `TokenOwnership` struct at `index`.
896      */
897     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
898         return _unpackedOwnership(_packedOwnerships[index]);
899     }
900 
901     /**
902      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
903      */
904     function _initializeOwnershipAt(uint256 index) internal {
905         if (_packedOwnerships[index] == 0) {
906             _packedOwnerships[index] = _packedOwnershipOf(index);
907         }
908     }
909 
910     /**
911      * Gas spent here starts off proportional to the maximum mint batch size.
912      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
913      */
914     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
915         return _unpackedOwnership(_packedOwnershipOf(tokenId));
916     }
917 
918     /**
919      * @dev See {IERC721-ownerOf}.
920      */
921     function ownerOf(uint256 tokenId) public view override returns (address) {
922         return address(uint160(_packedOwnershipOf(tokenId)));
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
947     }
948 
949     /**
950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
952      * by default, can be overriden in child contracts.
953      */
954     function _baseURI() internal view virtual returns (string memory) {
955         return '';
956     }
957 
958     /**
959      * @dev Casts the address to uint256 without masking.
960      */
961     function _addressToUint256(address value) private pure returns (uint256 result) {
962         assembly {
963             result := value
964         }
965     }
966 
967     /**
968      * @dev Casts the boolean to uint256 without branching.
969      */
970     function _boolToUint256(bool value) private pure returns (uint256 result) {
971         assembly {
972             result := value
973         }
974     }
975 
976     /**
977      * @dev See {IERC721-approve}.
978      */
979     function approve(address to, uint256 tokenId) public override {
980         address owner = address(uint160(_packedOwnershipOf(tokenId)));
981         if (to == owner) revert ApprovalToCurrentOwner();
982 
983         if (_msgSenderERC721A() != owner)
984             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
985                 revert ApprovalCallerNotOwnerNorApproved();
986             }
987 
988         _tokenApprovals[tokenId] = to;
989         emit Approval(owner, to, tokenId);
990     }
991 
992     /**
993      * @dev See {IERC721-getApproved}.
994      */
995     function getApproved(uint256 tokenId) public view override returns (address) {
996         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
997 
998         return _tokenApprovals[tokenId];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-setApprovalForAll}.
1003      */
1004     function setApprovalForAll(address operator, bool approved) public virtual override {
1005         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1006 
1007         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1008         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         _transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         safeTransferFrom(from, to, tokenId, '');
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050         if (to.code.length != 0)
1051             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1052                 revert TransferToNonERC721ReceiverImplementer();
1053             }
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      */
1063     function _exists(uint256 tokenId) internal view returns (bool) {
1064         return
1065             _startTokenId() <= tokenId &&
1066             tokenId < _currentIndex && // If within bounds,
1067             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1068     }
1069 
1070     /**
1071      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1072      */
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, '');
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement
1083      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 quantity,
1091         bytes memory _data
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             // Updates:
1104             // - `balance += quantity`.
1105             // - `numberMinted += quantity`.
1106             //
1107             // We can directly add to the balance and number minted.
1108             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1109 
1110             // Updates:
1111             // - `address` to the owner.
1112             // - `startTimestamp` to the timestamp of minting.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `quantity == 1`.
1115             _packedOwnerships[startTokenId] =
1116                 _addressToUint256(to) |
1117                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1118                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (to.code.length != 0) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (updatedIndex < end);
1130                 // Reentrancy protection
1131                 if (_currentIndex != startTokenId) revert();
1132             } else {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex++);
1135                 } while (updatedIndex < end);
1136             }
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _mint(address to, uint256 quantity) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1161         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1162         unchecked {
1163             // Updates:
1164             // - `balance += quantity`.
1165             // - `numberMinted += quantity`.
1166             //
1167             // We can directly add to the balance and number minted.
1168             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
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
1209         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1210 
1211         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1212             isApprovedForAll(from, _msgSenderERC721A()) ||
1213             getApproved(tokenId) == _msgSenderERC721A());
1214 
1215         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1216         if (to == address(0)) revert TransferToZeroAddress();
1217 
1218         _beforeTokenTransfers(from, to, tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         delete _tokenApprovals[tokenId];
1222 
1223         // Underflow of the sender's balance is impossible because we check for
1224         // ownership above and the recipient's balance can't realistically overflow.
1225         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1226         unchecked {
1227             // We can directly increment and decrement the balances.
1228             --_packedAddressData[from]; // Updates: `balance -= 1`.
1229             ++_packedAddressData[to]; // Updates: `balance += 1`.
1230 
1231             // Updates:
1232             // - `address` to the next owner.
1233             // - `startTimestamp` to the timestamp of transfering.
1234             // - `burned` to `false`.
1235             // - `nextInitialized` to `true`.
1236             _packedOwnerships[tokenId] =
1237                 _addressToUint256(to) |
1238                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1239                 BITMASK_NEXT_INITIALIZED;
1240 
1241             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1242             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1243                 uint256 nextTokenId = tokenId + 1;
1244                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1245                 if (_packedOwnerships[nextTokenId] == 0) {
1246                     // If the next slot is within bounds.
1247                     if (nextTokenId != _currentIndex) {
1248                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1249                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1250                     }
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(from, to, tokenId);
1256         _afterTokenTransfers(from, to, tokenId, 1);
1257     }
1258 
1259     /**
1260      * @dev Equivalent to `_burn(tokenId, false)`.
1261      */
1262     function _burn(uint256 tokenId) internal virtual {
1263         _burn(tokenId, false);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1277         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1278 
1279         address from = address(uint160(prevOwnershipPacked));
1280 
1281         if (approvalCheck) {
1282             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1283                 isApprovedForAll(from, _msgSenderERC721A()) ||
1284                 getApproved(tokenId) == _msgSenderERC721A());
1285 
1286             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1287         }
1288 
1289         _beforeTokenTransfers(from, address(0), tokenId, 1);
1290 
1291         // Clear approvals from the previous owner.
1292         delete _tokenApprovals[tokenId];
1293 
1294         // Underflow of the sender's balance is impossible because we check for
1295         // ownership above and the recipient's balance can't realistically overflow.
1296         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1297         unchecked {
1298             // Updates:
1299             // - `balance -= 1`.
1300             // - `numberBurned += 1`.
1301             //
1302             // We can directly decrement the balance, and increment the number burned.
1303             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1304             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1305 
1306             // Updates:
1307             // - `address` to the last owner.
1308             // - `startTimestamp` to the timestamp of burning.
1309             // - `burned` to `true`.
1310             // - `nextInitialized` to `true`.
1311             _packedOwnerships[tokenId] =
1312                 _addressToUint256(from) |
1313                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1314                 BITMASK_BURNED | 
1315                 BITMASK_NEXT_INITIALIZED;
1316 
1317             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1318             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1319                 uint256 nextTokenId = tokenId + 1;
1320                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1321                 if (_packedOwnerships[nextTokenId] == 0) {
1322                     // If the next slot is within bounds.
1323                     if (nextTokenId != _currentIndex) {
1324                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1325                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1326                     }
1327                 }
1328             }
1329         }
1330 
1331         emit Transfer(from, address(0), tokenId);
1332         _afterTokenTransfers(from, address(0), tokenId, 1);
1333 
1334         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1335         unchecked {
1336             _burnCounter++;
1337         }
1338     }
1339 
1340     /**
1341      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1342      *
1343      * @param from address representing the previous owner of the given token ID
1344      * @param to target address that will receive the tokens
1345      * @param tokenId uint256 ID of the token to be transferred
1346      * @param _data bytes optional data to send along with the call
1347      * @return bool whether the call correctly returned the expected magic value
1348      */
1349     function _checkContractOnERC721Received(
1350         address from,
1351         address to,
1352         uint256 tokenId,
1353         bytes memory _data
1354     ) private returns (bool) {
1355         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1356             bytes4 retval
1357         ) {
1358             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1359         } catch (bytes memory reason) {
1360             if (reason.length == 0) {
1361                 revert TransferToNonERC721ReceiverImplementer();
1362             } else {
1363                 assembly {
1364                     revert(add(32, reason), mload(reason))
1365                 }
1366             }
1367         }
1368     }
1369 
1370     /**
1371      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1372      * And also called before burning one token.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _beforeTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 
1392     /**
1393      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1394      * minting.
1395      * And also called after one token has been burned.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` has been minted for `to`.
1405      * - When `to` is zero, `tokenId` has been burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _afterTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Returns the message sender (defaults to `msg.sender`).
1417      *
1418      * If you are writing GSN compatible contracts, you need to override this function.
1419      */
1420     function _msgSenderERC721A() internal view virtual returns (address) {
1421         return msg.sender;
1422     }
1423 
1424     /**
1425      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1426      */
1427     function _toString(uint256 value) internal pure returns (string memory ptr) {
1428         assembly {
1429             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1430             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1431             // We will need 1 32-byte word to store the length, 
1432             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1433             ptr := add(mload(0x40), 128)
1434             // Update the free memory pointer to allocate.
1435             mstore(0x40, ptr)
1436 
1437             // Cache the end of the memory to calculate the length later.
1438             let end := ptr
1439 
1440             // We write the string from the rightmost digit to the leftmost digit.
1441             // The following is essentially a do-while loop that also handles the zero case.
1442             // Costs a bit more than early returning for the zero case,
1443             // but cheaper in terms of deployment and overall runtime costs.
1444             for { 
1445                 // Initialize and perform the first pass without check.
1446                 let temp := value
1447                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1448                 ptr := sub(ptr, 1)
1449                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1450                 mstore8(ptr, add(48, mod(temp, 10)))
1451                 temp := div(temp, 10)
1452             } temp { 
1453                 // Keep dividing `temp` until zero.
1454                 temp := div(temp, 10)
1455             } { // Body of the for loop.
1456                 ptr := sub(ptr, 1)
1457                 mstore8(ptr, add(48, mod(temp, 10)))
1458             }
1459             
1460             let length := sub(end, ptr)
1461             // Move the pointer 32 bytes leftwards to make room for the length.
1462             ptr := sub(ptr, 32)
1463             // Store the length.
1464             mstore(ptr, length)
1465         }
1466     }
1467 }
1468 
1469 // File: contracts/MythologicalMadness.sol
1470 
1471 
1472 pragma solidity ^0.8.4;
1473 
1474 
1475 
1476 
1477 
1478 contract MythologicalMadness is ERC721A, Ownable, ReentrancyGuard {
1479     uint256 public maxPerWallet = 2;
1480     uint256 public maxPerWalletWL = 2;
1481     uint256 public maxSupply = 5555;
1482     uint256 public freeSupply = 3300;
1483     uint256 public wlSupply = 3300;
1484     uint256 public price = 0.0069 ether;
1485     uint256 public wlPrice = 0 ether;
1486     
1487     bool public isPaused = true;
1488     bool public isPublicSale = false;
1489 
1490     mapping(address => uint256) private whiteListMinted;
1491 
1492     string public baseURI = "ipfs://QmaW4m2BcQpKSuh4AXTENYd8oGbapsSB5g9QmzWbA2w1eU/";
1493 
1494     bytes32 public merkleRoot = 0xd393e9572ddf835406f08de333c015f863dfb6d64b37007b72cfcbbbf561bbcd;
1495 
1496     constructor() ERC721A("Mythological Madness", "MMAD") {}
1497 
1498     function mintWhitelist(uint256 quantity, bytes32[] calldata merkleProof) public payable nonReentrant {
1499         require(!isPaused, "Sales are off");
1500         require(!isPublicSale, "It's Public Sale now - you had your chance.");
1501         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not Whitelisted");
1502         require(quantity + numberMinted(msg.sender) <= maxPerWalletWL, "Exceeded the WL wallet limit");
1503         
1504         require(totalSupply() + quantity <= wlSupply, "Not enough tokens left");
1505 
1506         whiteListMinted[msg.sender] += quantity;
1507 
1508         internalMint(quantity, wlPrice);
1509     }
1510 
1511     function mint(uint256 quantity) external payable nonReentrant {
1512         
1513         require(!isPaused, "Sales are off");
1514         require(isPublicSale, "Public Sale is not open yet");
1515         
1516         //this way WL can mint again
1517         require(quantity + numberMinted(msg.sender) - whiteListMinted[msg.sender] <= maxPerWallet, "Exceeded the wallet limit");
1518        
1519         internalMint(quantity, price);
1520     }
1521 
1522     function internalMint(uint256 quantity, uint256 mintPrice) internal {
1523         
1524         require(quantity > 0, "Wrong quantity");
1525         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
1526         require(tx.origin == msg.sender,"Contracts forbidden from minting!");
1527 
1528         //first 'freeSupply' is free, then paid
1529         require(
1530             msg.value >= getPrice(quantity, mintPrice),
1531             "Insufficient Fund."
1532         );
1533         
1534         _safeMint(msg.sender, quantity);
1535     }
1536 
1537 
1538     function getPrice(uint256 _count, uint256 mintPrice) internal view returns (uint256) {
1539         
1540         if(_totalMinted() > freeSupply){
1541             return mintPrice * _count;
1542         }
1543 
1544         uint256 endingTokenId = _totalMinted() + _count;
1545         // If qty to mint results in a final token ID less than or equal to the cap then
1546         // the entire qty is within free mint.
1547         if(endingTokenId  <= freeSupply) {
1548             return 0;
1549         }
1550         
1551         uint256 outsideIncentiveCount = endingTokenId - freeSupply;
1552 
1553         return 0 + mintPrice * outsideIncentiveCount;
1554     }
1555 
1556     function numberMinted(address owner) public view returns (uint256) {
1557         return _numberMinted(owner);
1558     }
1559 
1560     function whitelistMintedNumber(address owner) public view returns (uint256) {
1561         return whiteListMinted[owner];
1562     }
1563 
1564     function setPause(bool value) external onlyOwner {
1565 		  isPaused = value;
1566 	  }
1567 
1568     function setPublic(bool value) external onlyOwner {
1569 		  isPublicSale = value;
1570 	  }
1571 
1572     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1573         merkleRoot = _merkleRoot;
1574     }
1575 
1576     // ERC721A overrides
1577     // ERC721A starts counting tokenIds from 0, this contract starts from 1
1578     function _startTokenId() internal pure override returns (uint256) {
1579         return 1;
1580     }
1581 
1582     function withdraw() external onlyOwner {
1583 		uint balance = address(this).balance;
1584 		require(balance > 0, "Nothing to Withdraw");
1585         payable(owner()).transfer(balance);
1586     }
1587 
1588     function withdrawTo(address to) external onlyOwner {
1589 		uint balance = address(this).balance;
1590 		require(balance > 0, "Nothing to Withdraw");
1591         payable(to).transfer(balance);
1592     }
1593 
1594     function setBaseURI(string memory newuri) external onlyOwner {
1595         baseURI = newuri;
1596     }
1597 
1598     function _baseURI() internal view override returns (string memory) {
1599         return baseURI;
1600     }
1601 
1602     function setPrice(uint256 _price) public onlyOwner {
1603         price = _price;
1604     }
1605 
1606     function setMaxPerWalleet(uint256 _maxPerWallet) public onlyOwner {
1607         maxPerWallet = _maxPerWallet;
1608     }
1609 
1610     function setMaxPerWalletWL(uint256 _maxPerWalletWL) public onlyOwner {
1611         maxPerWalletWL = _maxPerWalletWL;
1612     }
1613 
1614     function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1615         freeSupply = _freeSupply;
1616     }
1617 
1618     function setWlSupply(uint256 _wlSupply) public onlyOwner {
1619         wlSupply = _wlSupply;
1620     }
1621 
1622     function devMint(uint256 quantity) external onlyOwner {
1623         require(totalSupply() + quantity <= maxSupply, "Max supply exceeded!");
1624         _safeMint(msg.sender, quantity);
1625     }
1626 
1627     function cutSupply(uint256 _maxSupply) external onlyOwner {
1628 		require(_maxSupply < maxSupply , "no jokes here");
1629         maxSupply = _maxSupply;
1630 	}
1631 }