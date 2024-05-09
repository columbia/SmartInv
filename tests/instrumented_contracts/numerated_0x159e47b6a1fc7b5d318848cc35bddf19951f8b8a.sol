1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The tree and the proofs can be generated using our
13  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
14  * You will find a quickstart guide in the readme.
15  *
16  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
17  * hashing, or use a hash function other than keccak256 for hashing leaves.
18  * This is because the concatenation of a sorted pair of internal nodes in
19  * the merkle tree could be reinterpreted as a leaf value.
20  * OpenZeppelin's JavaScript library generates merkle trees that are safe
21  * against this attack out of the box.
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
81      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
85      *
86      * _Available since v4.7._
87      */
88     function multiProofVerify(
89         bytes32[] memory proof,
90         bool[] memory proofFlags,
91         bytes32 root,
92         bytes32[] memory leaves
93     ) internal pure returns (bool) {
94         return processMultiProof(proof, proofFlags, leaves) == root;
95     }
96 
97     /**
98      * @dev Calldata version of {multiProofVerify}
99      *
100      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
101      *
102      * _Available since v4.7._
103      */
104     function multiProofVerifyCalldata(
105         bytes32[] calldata proof,
106         bool[] calldata proofFlags,
107         bytes32 root,
108         bytes32[] memory leaves
109     ) internal pure returns (bool) {
110         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
111     }
112 
113     /**
114      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
115      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
116      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
117      * respectively.
118      *
119      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
120      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
121      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
122      *
123      * _Available since v4.7._
124      */
125     function processMultiProof(
126         bytes32[] memory proof,
127         bool[] memory proofFlags,
128         bytes32[] memory leaves
129     ) internal pure returns (bytes32 merkleRoot) {
130         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
131         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
132         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
133         // the merkle tree.
134         uint256 leavesLen = leaves.length;
135         uint256 totalHashes = proofFlags.length;
136 
137         // Check proof validity.
138         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
139 
140         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
141         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
142         bytes32[] memory hashes = new bytes32[](totalHashes);
143         uint256 leafPos = 0;
144         uint256 hashPos = 0;
145         uint256 proofPos = 0;
146         // At each step, we compute the next hash using two values:
147         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
148         //   get the next hash.
149         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
150         //   `proof` array.
151         for (uint256 i = 0; i < totalHashes; i++) {
152             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
153             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
154             hashes[i] = _hashPair(a, b);
155         }
156 
157         if (totalHashes > 0) {
158             return hashes[totalHashes - 1];
159         } else if (leavesLen > 0) {
160             return leaves[0];
161         } else {
162             return proof[0];
163         }
164     }
165 
166     /**
167      * @dev Calldata version of {processMultiProof}.
168      *
169      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
170      *
171      * _Available since v4.7._
172      */
173     function processMultiProofCalldata(
174         bytes32[] calldata proof,
175         bool[] calldata proofFlags,
176         bytes32[] memory leaves
177     ) internal pure returns (bytes32 merkleRoot) {
178         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
179         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
180         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
181         // the merkle tree.
182         uint256 leavesLen = leaves.length;
183         uint256 totalHashes = proofFlags.length;
184 
185         // Check proof validity.
186         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
187 
188         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
189         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
190         bytes32[] memory hashes = new bytes32[](totalHashes);
191         uint256 leafPos = 0;
192         uint256 hashPos = 0;
193         uint256 proofPos = 0;
194         // At each step, we compute the next hash using two values:
195         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
196         //   get the next hash.
197         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
198         //   `proof` array.
199         for (uint256 i = 0; i < totalHashes; i++) {
200             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
201             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
202             hashes[i] = _hashPair(a, b);
203         }
204 
205         if (totalHashes > 0) {
206             return hashes[totalHashes - 1];
207         } else if (leavesLen > 0) {
208             return leaves[0];
209         } else {
210             return proof[0];
211         }
212     }
213 
214     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
215         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
216     }
217 
218     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
219         /// @solidity memory-safe-assembly
220         assembly {
221             mstore(0x00, a)
222             mstore(0x20, b)
223             value := keccak256(0x00, 0x40)
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Context.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 
258 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _transferOwnership(_msgSender());
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         _checkOwner();
292         _;
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if the sender is not the owner.
304      */
305     function _checkOwner() internal view virtual {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public virtual onlyOwner {
317         _transferOwnership(address(0));
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Can only be called by the current owner.
323      */
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325         require(newOwner != address(0), "Ownable: new owner is the zero address");
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Internal function without access restriction.
332      */
333     function _transferOwnership(address newOwner) internal virtual {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 // File: erc721a/contracts/IERC721A.sol
341 
342 
343 // ERC721A Contracts v4.2.3
344 // Creator: Chiru Labs
345 
346 pragma solidity ^0.8.4;
347 
348 /**
349  * @dev Interface of ERC721A.
350  */
351 interface IERC721A {
352     /**
353      * The caller must own the token or be an approved operator.
354      */
355     error ApprovalCallerNotOwnerNorApproved();
356 
357     /**
358      * The token does not exist.
359      */
360     error ApprovalQueryForNonexistentToken();
361 
362     /**
363      * Cannot query the balance for the zero address.
364      */
365     error BalanceQueryForZeroAddress();
366 
367     /**
368      * Cannot mint to the zero address.
369      */
370     error MintToZeroAddress();
371 
372     /**
373      * The quantity of tokens minted must be more than zero.
374      */
375     error MintZeroQuantity();
376 
377     /**
378      * The token does not exist.
379      */
380     error OwnerQueryForNonexistentToken();
381 
382     /**
383      * The caller must own the token or be an approved operator.
384      */
385     error TransferCallerNotOwnerNorApproved();
386 
387     /**
388      * The token must be owned by `from`.
389      */
390     error TransferFromIncorrectOwner();
391 
392     /**
393      * Cannot safely transfer to a contract that does not implement the
394      * ERC721Receiver interface.
395      */
396     error TransferToNonERC721ReceiverImplementer();
397 
398     /**
399      * Cannot transfer to the zero address.
400      */
401     error TransferToZeroAddress();
402 
403     /**
404      * The token does not exist.
405      */
406     error URIQueryForNonexistentToken();
407 
408     /**
409      * The `quantity` minted with ERC2309 exceeds the safety limit.
410      */
411     error MintERC2309QuantityExceedsLimit();
412 
413     /**
414      * The `extraData` cannot be set on an unintialized ownership slot.
415      */
416     error OwnershipNotInitializedForExtraData();
417 
418     // =============================================================
419     //                            STRUCTS
420     // =============================================================
421 
422     struct TokenOwnership {
423         // The address of the owner.
424         address addr;
425         // Stores the start time of ownership with minimal overhead for tokenomics.
426         uint64 startTimestamp;
427         // Whether the token has been burned.
428         bool burned;
429         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
430         uint24 extraData;
431     }
432 
433     // =============================================================
434     //                         TOKEN COUNTERS
435     // =============================================================
436 
437     /**
438      * @dev Returns the total number of tokens in existence.
439      * Burned tokens will reduce the count.
440      * To get the total number of tokens minted, please see {_totalMinted}.
441      */
442     function totalSupply() external view returns (uint256);
443 
444     // =============================================================
445     //                            IERC165
446     // =============================================================
447 
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 
458     // =============================================================
459     //                            IERC721
460     // =============================================================
461 
462     /**
463      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
464      */
465     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
466 
467     /**
468      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
469      */
470     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
471 
472     /**
473      * @dev Emitted when `owner` enables or disables
474      * (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
477 
478     /**
479      * @dev Returns the number of tokens in `owner`'s account.
480      */
481     function balanceOf(address owner) external view returns (uint256 balance);
482 
483     /**
484      * @dev Returns the owner of the `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function ownerOf(uint256 tokenId) external view returns (address owner);
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`,
494      * checking first that contract recipients are aware of the ERC721 protocol
495      * to prevent tokens from being forever locked.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If the caller is not `from`, it must be have been allowed to move
503      * this token by either {approve} or {setApprovalForAll}.
504      * - If `to` refers to a smart contract, it must implement
505      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes calldata data
514     ) external payable;
515 
516     /**
517      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external payable;
524 
525     /**
526      * @dev Transfers `tokenId` from `from` to `to`.
527      *
528      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
529      * whenever possible.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token
537      * by either {approve} or {setApprovalForAll}.
538      *
539      * Emits a {Transfer} event.
540      */
541     function transferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external payable;
546 
547     /**
548      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
549      * The approval is cleared when the token is transferred.
550      *
551      * Only a single account can be approved at a time, so approving the
552      * zero address clears previous approvals.
553      *
554      * Requirements:
555      *
556      * - The caller must own the token or be an approved operator.
557      * - `tokenId` must exist.
558      *
559      * Emits an {Approval} event.
560      */
561     function approve(address to, uint256 tokenId) external payable;
562 
563     /**
564      * @dev Approve or remove `operator` as an operator for the caller.
565      * Operators can call {transferFrom} or {safeTransferFrom}
566      * for any token owned by the caller.
567      *
568      * Requirements:
569      *
570      * - The `operator` cannot be the caller.
571      *
572      * Emits an {ApprovalForAll} event.
573      */
574     function setApprovalForAll(address operator, bool _approved) external;
575 
576     /**
577      * @dev Returns the account approved for `tokenId` token.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function getApproved(uint256 tokenId) external view returns (address operator);
584 
585     /**
586      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
587      *
588      * See {setApprovalForAll}.
589      */
590     function isApprovedForAll(address owner, address operator) external view returns (bool);
591 
592     // =============================================================
593     //                        IERC721Metadata
594     // =============================================================
595 
596     /**
597      * @dev Returns the token collection name.
598      */
599     function name() external view returns (string memory);
600 
601     /**
602      * @dev Returns the token collection symbol.
603      */
604     function symbol() external view returns (string memory);
605 
606     /**
607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
608      */
609     function tokenURI(uint256 tokenId) external view returns (string memory);
610 
611     // =============================================================
612     //                           IERC2309
613     // =============================================================
614 
615     /**
616      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
617      * (inclusive) is transferred from `from` to `to`, as defined in the
618      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
619      *
620      * See {_mintERC2309} for more details.
621      */
622     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
623 }
624 
625 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
626 
627 
628 // ERC721A Contracts v4.2.3
629 // Creator: Chiru Labs
630 
631 pragma solidity ^0.8.4;
632 
633 
634 /**
635  * @dev Interface of ERC721AQueryable.
636  */
637 interface IERC721AQueryable is IERC721A {
638     /**
639      * Invalid query range (`start` >= `stop`).
640      */
641     error InvalidQueryRange();
642 
643     /**
644      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
645      *
646      * If the `tokenId` is out of bounds:
647      *
648      * - `addr = address(0)`
649      * - `startTimestamp = 0`
650      * - `burned = false`
651      * - `extraData = 0`
652      *
653      * If the `tokenId` is burned:
654      *
655      * - `addr = <Address of owner before token was burned>`
656      * - `startTimestamp = <Timestamp when token was burned>`
657      * - `burned = true`
658      * - `extraData = <Extra data when token was burned>`
659      *
660      * Otherwise:
661      *
662      * - `addr = <Address of owner>`
663      * - `startTimestamp = <Timestamp of start of ownership>`
664      * - `burned = false`
665      * - `extraData = <Extra data at start of ownership>`
666      */
667     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
668 
669     /**
670      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
671      * See {ERC721AQueryable-explicitOwnershipOf}
672      */
673     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
674 
675     /**
676      * @dev Returns an array of token IDs owned by `owner`,
677      * in the range [`start`, `stop`)
678      * (i.e. `start <= tokenId < stop`).
679      *
680      * This function allows for tokens to be queried if the collection
681      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
682      *
683      * Requirements:
684      *
685      * - `start < stop`
686      */
687     function tokensOfOwnerIn(
688         address owner,
689         uint256 start,
690         uint256 stop
691     ) external view returns (uint256[] memory);
692 
693     /**
694      * @dev Returns an array of token IDs owned by `owner`.
695      *
696      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
697      * It is meant to be called off-chain.
698      *
699      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
700      * multiple smaller scans if the collection is large enough to cause
701      * an out-of-gas error (10K collections should be fine).
702      */
703     function tokensOfOwner(address owner) external view returns (uint256[] memory);
704 }
705 
706 // File: erc721a/contracts/ERC721A.sol
707 
708 
709 // ERC721A Contracts v4.2.3
710 // Creator: Chiru Labs
711 
712 pragma solidity ^0.8.4;
713 
714 
715 /**
716  * @dev Interface of ERC721 token receiver.
717  */
718 interface ERC721A__IERC721Receiver {
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 /**
728  * @title ERC721A
729  *
730  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
731  * Non-Fungible Token Standard, including the Metadata extension.
732  * Optimized for lower gas during batch mints.
733  *
734  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
735  * starting from `_startTokenId()`.
736  *
737  * Assumptions:
738  *
739  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
740  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
741  */
742 contract ERC721A is IERC721A {
743     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
744     struct TokenApprovalRef {
745         address value;
746     }
747 
748     // =============================================================
749     //                           CONSTANTS
750     // =============================================================
751 
752     // Mask of an entry in packed address data.
753     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
754 
755     // The bit position of `numberMinted` in packed address data.
756     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
757 
758     // The bit position of `numberBurned` in packed address data.
759     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
760 
761     // The bit position of `aux` in packed address data.
762     uint256 private constant _BITPOS_AUX = 192;
763 
764     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
765     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
766 
767     // The bit position of `startTimestamp` in packed ownership.
768     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
769 
770     // The bit mask of the `burned` bit in packed ownership.
771     uint256 private constant _BITMASK_BURNED = 1 << 224;
772 
773     // The bit position of the `nextInitialized` bit in packed ownership.
774     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
775 
776     // The bit mask of the `nextInitialized` bit in packed ownership.
777     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
778 
779     // The bit position of `extraData` in packed ownership.
780     uint256 private constant _BITPOS_EXTRA_DATA = 232;
781 
782     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
783     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
784 
785     // The mask of the lower 160 bits for addresses.
786     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
787 
788     // The maximum `quantity` that can be minted with {_mintERC2309}.
789     // This limit is to prevent overflows on the address data entries.
790     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
791     // is required to cause an overflow, which is unrealistic.
792     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
793 
794     // The `Transfer` event signature is given by:
795     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
796     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
797         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
798 
799     // =============================================================
800     //                            STORAGE
801     // =============================================================
802 
803     // The next token ID to be minted.
804     uint256 private _currentIndex;
805 
806     // The number of tokens burned.
807     uint256 private _burnCounter;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned.
817     // See {_packedOwnershipOf} implementation for details.
818     //
819     // Bits Layout:
820     // - [0..159]   `addr`
821     // - [160..223] `startTimestamp`
822     // - [224]      `burned`
823     // - [225]      `nextInitialized`
824     // - [232..255] `extraData`
825     mapping(uint256 => uint256) private _packedOwnerships;
826 
827     // Mapping owner address to address data.
828     //
829     // Bits Layout:
830     // - [0..63]    `balance`
831     // - [64..127]  `numberMinted`
832     // - [128..191] `numberBurned`
833     // - [192..255] `aux`
834     mapping(address => uint256) private _packedAddressData;
835 
836     // Mapping from token ID to approved address.
837     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
838 
839     // Mapping from owner to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     // =============================================================
843     //                          CONSTRUCTOR
844     // =============================================================
845 
846     constructor(string memory name_, string memory symbol_) {
847         _name = name_;
848         _symbol = symbol_;
849         _currentIndex = _startTokenId();
850     }
851 
852     // =============================================================
853     //                   TOKEN COUNTING OPERATIONS
854     // =============================================================
855 
856     /**
857      * @dev Returns the starting token ID.
858      * To change the starting token ID, please override this function.
859      */
860     function _startTokenId() internal view virtual returns (uint256) {
861         return 0;
862     }
863 
864     /**
865      * @dev Returns the next token ID to be minted.
866      */
867     function _nextTokenId() internal view virtual returns (uint256) {
868         return _currentIndex;
869     }
870 
871     /**
872      * @dev Returns the total number of tokens in existence.
873      * Burned tokens will reduce the count.
874      * To get the total number of tokens minted, please see {_totalMinted}.
875      */
876     function totalSupply() public view virtual override returns (uint256) {
877         // Counter underflow is impossible as _burnCounter cannot be incremented
878         // more than `_currentIndex - _startTokenId()` times.
879         unchecked {
880             return _currentIndex - _burnCounter - _startTokenId();
881         }
882     }
883 
884     /**
885      * @dev Returns the total amount of tokens minted in the contract.
886      */
887     function _totalMinted() internal view virtual returns (uint256) {
888         // Counter underflow is impossible as `_currentIndex` does not decrement,
889         // and it is initialized to `_startTokenId()`.
890         unchecked {
891             return _currentIndex - _startTokenId();
892         }
893     }
894 
895     /**
896      * @dev Returns the total number of tokens burned.
897      */
898     function _totalBurned() internal view virtual returns (uint256) {
899         return _burnCounter;
900     }
901 
902     // =============================================================
903     //                    ADDRESS DATA OPERATIONS
904     // =============================================================
905 
906     /**
907      * @dev Returns the number of tokens in `owner`'s account.
908      */
909     function balanceOf(address owner) public view virtual override returns (uint256) {
910         if (owner == address(0)) revert BalanceQueryForZeroAddress();
911         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
912     }
913 
914     /**
915      * Returns the number of tokens minted by `owner`.
916      */
917     function _numberMinted(address owner) internal view returns (uint256) {
918         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
919     }
920 
921     /**
922      * Returns the number of tokens burned by or on behalf of `owner`.
923      */
924     function _numberBurned(address owner) internal view returns (uint256) {
925         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
926     }
927 
928     /**
929      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
930      */
931     function _getAux(address owner) internal view returns (uint64) {
932         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
933     }
934 
935     /**
936      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
937      * If there are multiple variables, please pack them into a uint64.
938      */
939     function _setAux(address owner, uint64 aux) internal virtual {
940         uint256 packed = _packedAddressData[owner];
941         uint256 auxCasted;
942         // Cast `aux` with assembly to avoid redundant masking.
943         assembly {
944             auxCasted := aux
945         }
946         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
947         _packedAddressData[owner] = packed;
948     }
949 
950     // =============================================================
951     //                            IERC165
952     // =============================================================
953 
954     /**
955      * @dev Returns true if this contract implements the interface defined by
956      * `interfaceId`. See the corresponding
957      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
958      * to learn more about how these ids are created.
959      *
960      * This function call must use less than 30000 gas.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963         // The interface IDs are constants representing the first 4 bytes
964         // of the XOR of all function selectors in the interface.
965         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
966         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
967         return
968             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
969             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
970             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
971     }
972 
973     // =============================================================
974     //                        IERC721Metadata
975     // =============================================================
976 
977     /**
978      * @dev Returns the token collection name.
979      */
980     function name() public view virtual override returns (string memory) {
981         return _name;
982     }
983 
984     /**
985      * @dev Returns the token collection symbol.
986      */
987     function symbol() public view virtual override returns (string memory) {
988         return _symbol;
989     }
990 
991     /**
992      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
993      */
994     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
995         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
996 
997         string memory baseURI = _baseURI();
998         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
999     }
1000 
1001     /**
1002      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1003      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1004      * by default, it can be overridden in child contracts.
1005      */
1006     function _baseURI() internal view virtual returns (string memory) {
1007         return '';
1008     }
1009 
1010     // =============================================================
1011     //                     OWNERSHIPS OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Returns the owner of the `tokenId` token.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      */
1021     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1022         return address(uint160(_packedOwnershipOf(tokenId)));
1023     }
1024 
1025     /**
1026      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1027      * It gradually moves to O(1) as tokens get transferred around over time.
1028      */
1029     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1030         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1031     }
1032 
1033     /**
1034      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1035      */
1036     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1037         return _unpackedOwnership(_packedOwnerships[index]);
1038     }
1039 
1040     /**
1041      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1042      */
1043     function _initializeOwnershipAt(uint256 index) internal virtual {
1044         if (_packedOwnerships[index] == 0) {
1045             _packedOwnerships[index] = _packedOwnershipOf(index);
1046         }
1047     }
1048 
1049     /**
1050      * Returns the packed ownership data of `tokenId`.
1051      */
1052     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1053         uint256 curr = tokenId;
1054 
1055         unchecked {
1056             if (_startTokenId() <= curr)
1057                 if (curr < _currentIndex) {
1058                     uint256 packed = _packedOwnerships[curr];
1059                     // If not burned.
1060                     if (packed & _BITMASK_BURNED == 0) {
1061                         // Invariant:
1062                         // There will always be an initialized ownership slot
1063                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1064                         // before an unintialized ownership slot
1065                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1066                         // Hence, `curr` will not underflow.
1067                         //
1068                         // We can directly compare the packed value.
1069                         // If the address is zero, packed will be zero.
1070                         while (packed == 0) {
1071                             packed = _packedOwnerships[--curr];
1072                         }
1073                         return packed;
1074                     }
1075                 }
1076         }
1077         revert OwnerQueryForNonexistentToken();
1078     }
1079 
1080     /**
1081      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1082      */
1083     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1084         ownership.addr = address(uint160(packed));
1085         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1086         ownership.burned = packed & _BITMASK_BURNED != 0;
1087         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1088     }
1089 
1090     /**
1091      * @dev Packs ownership data into a single uint256.
1092      */
1093     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1094         assembly {
1095             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1096             owner := and(owner, _BITMASK_ADDRESS)
1097             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1098             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1099         }
1100     }
1101 
1102     /**
1103      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1104      */
1105     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1106         // For branchless setting of the `nextInitialized` flag.
1107         assembly {
1108             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1109             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1110         }
1111     }
1112 
1113     // =============================================================
1114     //                      APPROVAL OPERATIONS
1115     // =============================================================
1116 
1117     /**
1118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1119      * The approval is cleared when the token is transferred.
1120      *
1121      * Only a single account can be approved at a time, so approving the
1122      * zero address clears previous approvals.
1123      *
1124      * Requirements:
1125      *
1126      * - The caller must own the token or be an approved operator.
1127      * - `tokenId` must exist.
1128      *
1129      * Emits an {Approval} event.
1130      */
1131     function approve(address to, uint256 tokenId) public payable virtual override {
1132         address owner = ownerOf(tokenId);
1133 
1134         if (_msgSenderERC721A() != owner)
1135             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1136                 revert ApprovalCallerNotOwnerNorApproved();
1137             }
1138 
1139         _tokenApprovals[tokenId].value = to;
1140         emit Approval(owner, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Returns the account approved for `tokenId` token.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      */
1150     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1151         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1152 
1153         return _tokenApprovals[tokenId].value;
1154     }
1155 
1156     /**
1157      * @dev Approve or remove `operator` as an operator for the caller.
1158      * Operators can call {transferFrom} or {safeTransferFrom}
1159      * for any token owned by the caller.
1160      *
1161      * Requirements:
1162      *
1163      * - The `operator` cannot be the caller.
1164      *
1165      * Emits an {ApprovalForAll} event.
1166      */
1167     function setApprovalForAll(address operator, bool approved) public virtual override {
1168         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1169         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1170     }
1171 
1172     /**
1173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1174      *
1175      * See {setApprovalForAll}.
1176      */
1177     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1178         return _operatorApprovals[owner][operator];
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted. See {_mint}.
1187      */
1188     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1189         return
1190             _startTokenId() <= tokenId &&
1191             tokenId < _currentIndex && // If within bounds,
1192             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1193     }
1194 
1195     /**
1196      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1197      */
1198     function _isSenderApprovedOrOwner(
1199         address approvedAddress,
1200         address owner,
1201         address msgSender
1202     ) private pure returns (bool result) {
1203         assembly {
1204             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1205             owner := and(owner, _BITMASK_ADDRESS)
1206             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1207             msgSender := and(msgSender, _BITMASK_ADDRESS)
1208             // `msgSender == owner || msgSender == approvedAddress`.
1209             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1210         }
1211     }
1212 
1213     /**
1214      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1215      */
1216     function _getApprovedSlotAndAddress(uint256 tokenId)
1217         private
1218         view
1219         returns (uint256 approvedAddressSlot, address approvedAddress)
1220     {
1221         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1222         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1223         assembly {
1224             approvedAddressSlot := tokenApproval.slot
1225             approvedAddress := sload(approvedAddressSlot)
1226         }
1227     }
1228 
1229     // =============================================================
1230     //                      TRANSFER OPERATIONS
1231     // =============================================================
1232 
1233     /**
1234      * @dev Transfers `tokenId` from `from` to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token
1242      * by either {approve} or {setApprovalForAll}.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function transferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) public payable virtual override {
1251         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1252 
1253         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1254 
1255         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1256 
1257         // The nested ifs save around 20+ gas over a compound boolean condition.
1258         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1259             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1260 
1261         if (to == address(0)) revert TransferToZeroAddress();
1262 
1263         _beforeTokenTransfers(from, to, tokenId, 1);
1264 
1265         // Clear approvals from the previous owner.
1266         assembly {
1267             if approvedAddress {
1268                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1269                 sstore(approvedAddressSlot, 0)
1270             }
1271         }
1272 
1273         // Underflow of the sender's balance is impossible because we check for
1274         // ownership above and the recipient's balance can't realistically overflow.
1275         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1276         unchecked {
1277             // We can directly increment and decrement the balances.
1278             --_packedAddressData[from]; // Updates: `balance -= 1`.
1279             ++_packedAddressData[to]; // Updates: `balance += 1`.
1280 
1281             // Updates:
1282             // - `address` to the next owner.
1283             // - `startTimestamp` to the timestamp of transfering.
1284             // - `burned` to `false`.
1285             // - `nextInitialized` to `true`.
1286             _packedOwnerships[tokenId] = _packOwnershipData(
1287                 to,
1288                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1289             );
1290 
1291             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1292             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1293                 uint256 nextTokenId = tokenId + 1;
1294                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1295                 if (_packedOwnerships[nextTokenId] == 0) {
1296                     // If the next slot is within bounds.
1297                     if (nextTokenId != _currentIndex) {
1298                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1299                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1300                     }
1301                 }
1302             }
1303         }
1304 
1305         emit Transfer(from, to, tokenId);
1306         _afterTokenTransfers(from, to, tokenId, 1);
1307     }
1308 
1309     /**
1310      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1311      */
1312     function safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public payable virtual override {
1317         safeTransferFrom(from, to, tokenId, '');
1318     }
1319 
1320     /**
1321      * @dev Safely transfers `tokenId` token from `from` to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `from` cannot be the zero address.
1326      * - `to` cannot be the zero address.
1327      * - `tokenId` token must exist and be owned by `from`.
1328      * - If the caller is not `from`, it must be approved to move this token
1329      * by either {approve} or {setApprovalForAll}.
1330      * - If `to` refers to a smart contract, it must implement
1331      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function safeTransferFrom(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) public payable virtual override {
1341         transferFrom(from, to, tokenId);
1342         if (to.code.length != 0)
1343             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1344                 revert TransferToNonERC721ReceiverImplementer();
1345             }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before a set of serially-ordered token IDs
1350      * are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * `startTokenId` - the first token ID to be transferred.
1354      * `quantity` - the amount to be transferred.
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token IDs
1373      * have been transferred. This includes minting.
1374      * And also called after one token has been burned.
1375      *
1376      * `startTokenId` - the first token ID to be transferred.
1377      * `quantity` - the amount to be transferred.
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 
1394     /**
1395      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1396      *
1397      * `from` - Previous owner of the given token ID.
1398      * `to` - Target address that will receive the token.
1399      * `tokenId` - Token ID to be transferred.
1400      * `_data` - Optional data to send along with the call.
1401      *
1402      * Returns whether the call correctly returned the expected magic value.
1403      */
1404     function _checkContractOnERC721Received(
1405         address from,
1406         address to,
1407         uint256 tokenId,
1408         bytes memory _data
1409     ) private returns (bool) {
1410         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1411             bytes4 retval
1412         ) {
1413             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1414         } catch (bytes memory reason) {
1415             if (reason.length == 0) {
1416                 revert TransferToNonERC721ReceiverImplementer();
1417             } else {
1418                 assembly {
1419                     revert(add(32, reason), mload(reason))
1420                 }
1421             }
1422         }
1423     }
1424 
1425     // =============================================================
1426     //                        MINT OPERATIONS
1427     // =============================================================
1428 
1429     /**
1430      * @dev Mints `quantity` tokens and transfers them to `to`.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - `quantity` must be greater than 0.
1436      *
1437      * Emits a {Transfer} event for each mint.
1438      */
1439     function _mint(address to, uint256 quantity) internal virtual {
1440         uint256 startTokenId = _currentIndex;
1441         if (quantity == 0) revert MintZeroQuantity();
1442 
1443         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1444 
1445         // Overflows are incredibly unrealistic.
1446         // `balance` and `numberMinted` have a maximum limit of 2**64.
1447         // `tokenId` has a maximum limit of 2**256.
1448         unchecked {
1449             // Updates:
1450             // - `balance += quantity`.
1451             // - `numberMinted += quantity`.
1452             //
1453             // We can directly add to the `balance` and `numberMinted`.
1454             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1455 
1456             // Updates:
1457             // - `address` to the owner.
1458             // - `startTimestamp` to the timestamp of minting.
1459             // - `burned` to `false`.
1460             // - `nextInitialized` to `quantity == 1`.
1461             _packedOwnerships[startTokenId] = _packOwnershipData(
1462                 to,
1463                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1464             );
1465 
1466             uint256 toMasked;
1467             uint256 end = startTokenId + quantity;
1468 
1469             // Use assembly to loop and emit the `Transfer` event for gas savings.
1470             // The duplicated `log4` removes an extra check and reduces stack juggling.
1471             // The assembly, together with the surrounding Solidity code, have been
1472             // delicately arranged to nudge the compiler into producing optimized opcodes.
1473             assembly {
1474                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1475                 toMasked := and(to, _BITMASK_ADDRESS)
1476                 // Emit the `Transfer` event.
1477                 log4(
1478                     0, // Start of data (0, since no data).
1479                     0, // End of data (0, since no data).
1480                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1481                     0, // `address(0)`.
1482                     toMasked, // `to`.
1483                     startTokenId // `tokenId`.
1484                 )
1485 
1486                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1487                 // that overflows uint256 will make the loop run out of gas.
1488                 // The compiler will optimize the `iszero` away for performance.
1489                 for {
1490                     let tokenId := add(startTokenId, 1)
1491                 } iszero(eq(tokenId, end)) {
1492                     tokenId := add(tokenId, 1)
1493                 } {
1494                     // Emit the `Transfer` event. Similar to above.
1495                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1496                 }
1497             }
1498             if (toMasked == 0) revert MintToZeroAddress();
1499 
1500             _currentIndex = end;
1501         }
1502         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1503     }
1504 
1505     /**
1506      * @dev Mints `quantity` tokens and transfers them to `to`.
1507      *
1508      * This function is intended for efficient minting only during contract creation.
1509      *
1510      * It emits only one {ConsecutiveTransfer} as defined in
1511      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1512      * instead of a sequence of {Transfer} event(s).
1513      *
1514      * Calling this function outside of contract creation WILL make your contract
1515      * non-compliant with the ERC721 standard.
1516      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1517      * {ConsecutiveTransfer} event is only permissible during contract creation.
1518      *
1519      * Requirements:
1520      *
1521      * - `to` cannot be the zero address.
1522      * - `quantity` must be greater than 0.
1523      *
1524      * Emits a {ConsecutiveTransfer} event.
1525      */
1526     function _mintERC2309(address to, uint256 quantity) internal virtual {
1527         uint256 startTokenId = _currentIndex;
1528         if (to == address(0)) revert MintToZeroAddress();
1529         if (quantity == 0) revert MintZeroQuantity();
1530         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1531 
1532         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1535         unchecked {
1536             // Updates:
1537             // - `balance += quantity`.
1538             // - `numberMinted += quantity`.
1539             //
1540             // We can directly add to the `balance` and `numberMinted`.
1541             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1542 
1543             // Updates:
1544             // - `address` to the owner.
1545             // - `startTimestamp` to the timestamp of minting.
1546             // - `burned` to `false`.
1547             // - `nextInitialized` to `quantity == 1`.
1548             _packedOwnerships[startTokenId] = _packOwnershipData(
1549                 to,
1550                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1551             );
1552 
1553             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1554 
1555             _currentIndex = startTokenId + quantity;
1556         }
1557         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1558     }
1559 
1560     /**
1561      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1562      *
1563      * Requirements:
1564      *
1565      * - If `to` refers to a smart contract, it must implement
1566      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1567      * - `quantity` must be greater than 0.
1568      *
1569      * See {_mint}.
1570      *
1571      * Emits a {Transfer} event for each mint.
1572      */
1573     function _safeMint(
1574         address to,
1575         uint256 quantity,
1576         bytes memory _data
1577     ) internal virtual {
1578         _mint(to, quantity);
1579 
1580         unchecked {
1581             if (to.code.length != 0) {
1582                 uint256 end = _currentIndex;
1583                 uint256 index = end - quantity;
1584                 do {
1585                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1586                         revert TransferToNonERC721ReceiverImplementer();
1587                     }
1588                 } while (index < end);
1589                 // Reentrancy protection.
1590                 if (_currentIndex != end) revert();
1591             }
1592         }
1593     }
1594 
1595     /**
1596      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1597      */
1598     function _safeMint(address to, uint256 quantity) internal virtual {
1599         _safeMint(to, quantity, '');
1600     }
1601 
1602     // =============================================================
1603     //                        BURN OPERATIONS
1604     // =============================================================
1605 
1606     /**
1607      * @dev Equivalent to `_burn(tokenId, false)`.
1608      */
1609     function _burn(uint256 tokenId) internal virtual {
1610         _burn(tokenId, false);
1611     }
1612 
1613     /**
1614      * @dev Destroys `tokenId`.
1615      * The approval is cleared when the token is burned.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1624         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1625 
1626         address from = address(uint160(prevOwnershipPacked));
1627 
1628         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1629 
1630         if (approvalCheck) {
1631             // The nested ifs save around 20+ gas over a compound boolean condition.
1632             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1633                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1634         }
1635 
1636         _beforeTokenTransfers(from, address(0), tokenId, 1);
1637 
1638         // Clear approvals from the previous owner.
1639         assembly {
1640             if approvedAddress {
1641                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1642                 sstore(approvedAddressSlot, 0)
1643             }
1644         }
1645 
1646         // Underflow of the sender's balance is impossible because we check for
1647         // ownership above and the recipient's balance can't realistically overflow.
1648         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1649         unchecked {
1650             // Updates:
1651             // - `balance -= 1`.
1652             // - `numberBurned += 1`.
1653             //
1654             // We can directly decrement the balance, and increment the number burned.
1655             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1656             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1657 
1658             // Updates:
1659             // - `address` to the last owner.
1660             // - `startTimestamp` to the timestamp of burning.
1661             // - `burned` to `true`.
1662             // - `nextInitialized` to `true`.
1663             _packedOwnerships[tokenId] = _packOwnershipData(
1664                 from,
1665                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1666             );
1667 
1668             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1669             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1670                 uint256 nextTokenId = tokenId + 1;
1671                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1672                 if (_packedOwnerships[nextTokenId] == 0) {
1673                     // If the next slot is within bounds.
1674                     if (nextTokenId != _currentIndex) {
1675                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1676                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1677                     }
1678                 }
1679             }
1680         }
1681 
1682         emit Transfer(from, address(0), tokenId);
1683         _afterTokenTransfers(from, address(0), tokenId, 1);
1684 
1685         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1686         unchecked {
1687             _burnCounter++;
1688         }
1689     }
1690 
1691     // =============================================================
1692     //                     EXTRA DATA OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Directly sets the extra data for the ownership data `index`.
1697      */
1698     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1699         uint256 packed = _packedOwnerships[index];
1700         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1701         uint256 extraDataCasted;
1702         // Cast `extraData` with assembly to avoid redundant masking.
1703         assembly {
1704             extraDataCasted := extraData
1705         }
1706         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1707         _packedOwnerships[index] = packed;
1708     }
1709 
1710     /**
1711      * @dev Called during each token transfer to set the 24bit `extraData` field.
1712      * Intended to be overridden by the cosumer contract.
1713      *
1714      * `previousExtraData` - the value of `extraData` before transfer.
1715      *
1716      * Calling conditions:
1717      *
1718      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1719      * transferred to `to`.
1720      * - When `from` is zero, `tokenId` will be minted for `to`.
1721      * - When `to` is zero, `tokenId` will be burned by `from`.
1722      * - `from` and `to` are never both zero.
1723      */
1724     function _extraData(
1725         address from,
1726         address to,
1727         uint24 previousExtraData
1728     ) internal view virtual returns (uint24) {}
1729 
1730     /**
1731      * @dev Returns the next extra data for the packed ownership data.
1732      * The returned result is shifted into position.
1733      */
1734     function _nextExtraData(
1735         address from,
1736         address to,
1737         uint256 prevOwnershipPacked
1738     ) private view returns (uint256) {
1739         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1740         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1741     }
1742 
1743     // =============================================================
1744     //                       OTHER OPERATIONS
1745     // =============================================================
1746 
1747     /**
1748      * @dev Returns the message sender (defaults to `msg.sender`).
1749      *
1750      * If you are writing GSN compatible contracts, you need to override this function.
1751      */
1752     function _msgSenderERC721A() internal view virtual returns (address) {
1753         return msg.sender;
1754     }
1755 
1756     /**
1757      * @dev Converts a uint256 to its ASCII string decimal representation.
1758      */
1759     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1760         assembly {
1761             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1762             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1763             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1764             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1765             let m := add(mload(0x40), 0xa0)
1766             // Update the free memory pointer to allocate.
1767             mstore(0x40, m)
1768             // Assign the `str` to the end.
1769             str := sub(m, 0x20)
1770             // Zeroize the slot after the string.
1771             mstore(str, 0)
1772 
1773             // Cache the end of the memory to calculate the length later.
1774             let end := str
1775 
1776             // We write the string from rightmost digit to leftmost digit.
1777             // The following is essentially a do-while loop that also handles the zero case.
1778             // prettier-ignore
1779             for { let temp := value } 1 {} {
1780                 str := sub(str, 1)
1781                 // Write the character to the pointer.
1782                 // The ASCII index of the '0' character is 48.
1783                 mstore8(str, add(48, mod(temp, 10)))
1784                 // Keep dividing `temp` until zero.
1785                 temp := div(temp, 10)
1786                 // prettier-ignore
1787                 if iszero(temp) { break }
1788             }
1789 
1790             let length := sub(end, str)
1791             // Move the pointer 32 bytes leftwards to make room for the length.
1792             str := sub(str, 0x20)
1793             // Store the length.
1794             mstore(str, length)
1795         }
1796     }
1797 }
1798 
1799 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1800 
1801 
1802 // ERC721A Contracts v4.2.3
1803 // Creator: Chiru Labs
1804 
1805 pragma solidity ^0.8.4;
1806 
1807 
1808 
1809 /**
1810  * @title ERC721AQueryable.
1811  *
1812  * @dev ERC721A subclass with convenience query functions.
1813  */
1814 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1815     /**
1816      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1817      *
1818      * If the `tokenId` is out of bounds:
1819      *
1820      * - `addr = address(0)`
1821      * - `startTimestamp = 0`
1822      * - `burned = false`
1823      * - `extraData = 0`
1824      *
1825      * If the `tokenId` is burned:
1826      *
1827      * - `addr = <Address of owner before token was burned>`
1828      * - `startTimestamp = <Timestamp when token was burned>`
1829      * - `burned = true`
1830      * - `extraData = <Extra data when token was burned>`
1831      *
1832      * Otherwise:
1833      *
1834      * - `addr = <Address of owner>`
1835      * - `startTimestamp = <Timestamp of start of ownership>`
1836      * - `burned = false`
1837      * - `extraData = <Extra data at start of ownership>`
1838      */
1839     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1840         TokenOwnership memory ownership;
1841         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1842             return ownership;
1843         }
1844         ownership = _ownershipAt(tokenId);
1845         if (ownership.burned) {
1846             return ownership;
1847         }
1848         return _ownershipOf(tokenId);
1849     }
1850 
1851     /**
1852      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1853      * See {ERC721AQueryable-explicitOwnershipOf}
1854      */
1855     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1856         external
1857         view
1858         virtual
1859         override
1860         returns (TokenOwnership[] memory)
1861     {
1862         unchecked {
1863             uint256 tokenIdsLength = tokenIds.length;
1864             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1865             for (uint256 i; i != tokenIdsLength; ++i) {
1866                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1867             }
1868             return ownerships;
1869         }
1870     }
1871 
1872     /**
1873      * @dev Returns an array of token IDs owned by `owner`,
1874      * in the range [`start`, `stop`)
1875      * (i.e. `start <= tokenId < stop`).
1876      *
1877      * This function allows for tokens to be queried if the collection
1878      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1879      *
1880      * Requirements:
1881      *
1882      * - `start < stop`
1883      */
1884     function tokensOfOwnerIn(
1885         address owner,
1886         uint256 start,
1887         uint256 stop
1888     ) external view virtual override returns (uint256[] memory) {
1889         unchecked {
1890             if (start >= stop) revert InvalidQueryRange();
1891             uint256 tokenIdsIdx;
1892             uint256 stopLimit = _nextTokenId();
1893             // Set `start = max(start, _startTokenId())`.
1894             if (start < _startTokenId()) {
1895                 start = _startTokenId();
1896             }
1897             // Set `stop = min(stop, stopLimit)`.
1898             if (stop > stopLimit) {
1899                 stop = stopLimit;
1900             }
1901             uint256 tokenIdsMaxLength = balanceOf(owner);
1902             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1903             // to cater for cases where `balanceOf(owner)` is too big.
1904             if (start < stop) {
1905                 uint256 rangeLength = stop - start;
1906                 if (rangeLength < tokenIdsMaxLength) {
1907                     tokenIdsMaxLength = rangeLength;
1908                 }
1909             } else {
1910                 tokenIdsMaxLength = 0;
1911             }
1912             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1913             if (tokenIdsMaxLength == 0) {
1914                 return tokenIds;
1915             }
1916             // We need to call `explicitOwnershipOf(start)`,
1917             // because the slot at `start` may not be initialized.
1918             TokenOwnership memory ownership = explicitOwnershipOf(start);
1919             address currOwnershipAddr;
1920             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1921             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1922             if (!ownership.burned) {
1923                 currOwnershipAddr = ownership.addr;
1924             }
1925             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1926                 ownership = _ownershipAt(i);
1927                 if (ownership.burned) {
1928                     continue;
1929                 }
1930                 if (ownership.addr != address(0)) {
1931                     currOwnershipAddr = ownership.addr;
1932                 }
1933                 if (currOwnershipAddr == owner) {
1934                     tokenIds[tokenIdsIdx++] = i;
1935                 }
1936             }
1937             // Downsize the array to fit.
1938             assembly {
1939                 mstore(tokenIds, tokenIdsIdx)
1940             }
1941             return tokenIds;
1942         }
1943     }
1944 
1945     /**
1946      * @dev Returns an array of token IDs owned by `owner`.
1947      *
1948      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1949      * It is meant to be called off-chain.
1950      *
1951      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1952      * multiple smaller scans if the collection is large enough to cause
1953      * an out-of-gas error (10K collections should be fine).
1954      */
1955     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1956         unchecked {
1957             uint256 tokenIdsIdx;
1958             address currOwnershipAddr;
1959             uint256 tokenIdsLength = balanceOf(owner);
1960             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1961             TokenOwnership memory ownership;
1962             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1963                 ownership = _ownershipAt(i);
1964                 if (ownership.burned) {
1965                     continue;
1966                 }
1967                 if (ownership.addr != address(0)) {
1968                     currOwnershipAddr = ownership.addr;
1969                 }
1970                 if (currOwnershipAddr == owner) {
1971                     tokenIds[tokenIdsIdx++] = i;
1972                 }
1973             }
1974             return tokenIds;
1975         }
1976     }
1977 }
1978 
1979 // File: anarchist.sol
1980 
1981 
1982 
1983 pragma solidity ^0.8.4 .0;
1984 
1985 
1986 
1987 
1988 
1989 //  ▄▄▄       ███▄    █  ▄▄▄       ██▀███   ▄████▄   ██░ ██  ██▓  ██████ ▄▄▄█████▓
1990 // ▒████▄     ██ ▀█   █ ▒████▄    ▓██ ▒ ██▒▒██▀ ▀█  ▓██░ ██▒▓██▒▒██    ▒ ▓  ██▒ ▓▒
1991 // ▒██  ▀█▄  ▓██  ▀█ ██▒▒██  ▀█▄  ▓██ ░▄█ ▒▒▓█    ▄ ▒██▀▀██░▒██▒░ ▓██▄   ▒ ▓██░ ▒░
1992 // ░██▄▄▄▄██ ▓██▒  ▐▌██▒░██▄▄▄▄██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒░▓█ ░██ ░██░  ▒   ██▒░ ▓██▓ ░
1993 //  ▓█   ▓██▒▒██░   ▓██░ ▓█   ▓██▒░██▓ ▒██▒▒ ▓███▀ ░░▓█▒░██▓░██░▒██████▒▒  ▒██▒ ░
1994 //  ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ░▒ ▒  ░ ▒ ░░▒░▒░▓  ▒ ▒▓▒ ▒ ░  ▒ ░░
1995 //   ▒   ▒▒ ░░ ░░   ░ ▒░  ▒   ▒▒ ░  ░▒ ░ ▒░  ░  ▒    ▒ ░▒░ ░ ▒ ░░ ░▒  ░ ░    ░
1996 //   ░   ▒      ░   ░ ░   ░   ▒     ░░   ░ ░         ░  ░░ ░ ▒ ░░  ░  ░    ░
1997 //       ░  ░         ░       ░  ░   ░     ░ ░       ░  ░  ░ ░        ░
1998 //                                         ░
1999 
2000 /// @title ERC721A contract for the Anarchist NFT collection
2001 /// @author Syahmi Rafsan
2002 contract Anarchist is ERC721A, ERC721AQueryable, Ownable {
2003     uint256 public constant MAX_SUPPLY = 3333;
2004     uint256 public price = 0.0069 ether;
2005     string private _startTokenURI;
2006     string private _endTokenURI;
2007     bool public mintPaused = false;
2008     bool public whitelistMinting = true;
2009     bytes32 public merkleRoot;
2010     uint public maxFreeMint;
2011     mapping(address => uint) public userHasMinted;
2012 
2013     constructor(
2014         string memory startTokenURI,
2015         string memory endTokenURI,
2016         bytes32 _merkleRoot,
2017         uint _maxFreeMint
2018     ) ERC721A("Anarchist", "ANARC") {
2019         _startTokenURI = startTokenURI;
2020         _endTokenURI = endTokenURI;
2021         merkleRoot = _merkleRoot;
2022         maxFreeMint = _maxFreeMint;
2023     }
2024 
2025     /// @notice The NFT minting function for public
2026     /// @param quantity The number of NFT to be minted
2027     function mintPublic(uint256 quantity) external payable {
2028         require(msg.sender == tx.origin, "Minter is a contract");
2029         require(!mintPaused, "Mint is paused");
2030         require(!whitelistMinting, "Mint is only for whitelist");
2031         require(
2032             _totalMinted() + quantity <= MAX_SUPPLY,
2033             "Maximum supply exceeded"
2034         );
2035 
2036         uint cost;
2037         uint free;
2038         int balance = int(maxFreeMint) - int(userHasMinted[msg.sender]);
2039         if (balance < 0) {
2040             free = 0;
2041         } else {
2042             int freeCalc = int(maxFreeMint) - int(userHasMinted[msg.sender]);
2043             free = uint(freeCalc);
2044         }
2045 
2046         if (quantity >= free) {
2047             cost = (price) * (quantity - free);
2048             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
2049         } else {
2050             cost = 0;
2051             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
2052         }
2053 
2054         require(msg.value >= cost, "Must send enough eth");
2055         if (msg.value > cost) {
2056             payable(msg.sender).transfer(msg.value - cost);
2057         }
2058 
2059         _mint(msg.sender, quantity);
2060     }
2061 
2062     /// @notice The NFT minting function for whitelisted addresses
2063     /// @param quantity The number of NFT to be minted
2064     /// @param proof The Merkle proof to validate with the Merkle root
2065     function mintWhitelist(
2066         uint quantity,
2067         bytes32[] memory proof
2068     ) external payable {
2069         require(
2070             isValid(proof, keccak256(abi.encodePacked(msg.sender))),
2071             "Sorry but you are not eligible to mint"
2072         );
2073         require(msg.sender == tx.origin, "Minter is a contract");
2074         require(!mintPaused, "Mint is paused");
2075         require(whitelistMinting, "Mint is open to public");
2076         require(
2077             _totalMinted() + quantity <= MAX_SUPPLY,
2078             "Maximum supply exceeded"
2079         );
2080 
2081         uint cost;
2082         uint free;
2083         int balance = int(maxFreeMint) - int(userHasMinted[msg.sender]);
2084         if (balance < 0) {
2085             free = 0;
2086         } else {
2087             int freeCalc = int(maxFreeMint) - int(userHasMinted[msg.sender]);
2088             free = uint(freeCalc);
2089         }
2090 
2091         if (quantity >= free) {
2092             cost = (price) * (quantity - free);
2093             userHasMinted[msg.sender] = userHasMinted[msg.sender] + free;
2094         } else {
2095             cost = 0;
2096             userHasMinted[msg.sender] = userHasMinted[msg.sender] + quantity;
2097         }
2098 
2099         require(msg.value >= cost, "Must send enough eth");
2100         if (msg.value > cost) {
2101             payable(msg.sender).transfer(msg.value - cost);
2102         }
2103 
2104         _mint(msg.sender, quantity);
2105     }
2106 
2107     /// @notice The NFT minting function for owner. Callable only by the contract owner.
2108     /// @param receiver The address receiving the minted NFT
2109     /// @param quantity The number of NFT to be minted
2110     function mintOwner(
2111         address receiver,
2112         uint256 quantity
2113     ) external onlyOwner {
2114         require(
2115             _totalMinted() + quantity <= MAX_SUPPLY,
2116             "Maximum supply exceeded"
2117         );
2118 
2119         _mint(receiver, quantity);
2120     }
2121 
2122     /// @notice The function to change mint configuration. Callable only by the contract owner.
2123     /// @param _merkleRoot The Merkle root of the whitelisted addresses
2124     /// @param _maxFreeMint The maximum number of free mints per wallet
2125     function setMintConfig(
2126         bytes32 _merkleRoot,
2127         uint _maxFreeMint
2128     ) external onlyOwner {
2129         merkleRoot = _merkleRoot;
2130         maxFreeMint = _maxFreeMint;
2131     }
2132 
2133     /// @notice The function to validate the Merkle proof with the Merkle root via leaf
2134     /// @param proof The Merkle proof to be validated
2135     /// @param leaf The mint price in wei
2136     function isValid(
2137         bytes32[] memory proof,
2138         bytes32 leaf
2139     ) public view returns (bool) {
2140         return MerkleProof.verify(proof, merkleRoot, leaf);
2141     }
2142 
2143     /// @notice The function to check the free mint balance of the sender
2144     /// @param sender The address of sender
2145     function freeMintBalance(address sender) public view returns (int) {
2146         int balance = int(maxFreeMint) - int(userHasMinted[sender]);
2147         if (balance < 0) {
2148             return 0;
2149         } else {
2150             int free = int(maxFreeMint) - int(userHasMinted[sender]);
2151             return free;
2152         }
2153     }
2154 
2155     /// @notice The function to check the cost of minting by sender
2156     /// @param quantity The mint quantity
2157     /// @param sender The address of sender
2158     function senderCost(
2159         uint256 quantity,
2160         address sender
2161     ) public view returns (uint256) {
2162         uint256 cost;
2163         uint free;
2164         int balance = int(maxFreeMint) - int(userHasMinted[sender]);
2165         if (balance < 0) {
2166             free = 0;
2167         } else {
2168             int freeCalc = int(maxFreeMint) - int(userHasMinted[sender]);
2169             free = uint(freeCalc);
2170         }
2171 
2172         if (quantity >= free) {
2173             cost = (price) * (quantity - free);
2174         } else {
2175             cost = 0;
2176         }
2177 
2178         return cost;
2179     }
2180 
2181     /// @notice The function to withdraw the contract balance to the contract owner. Callable only by the contract owner.
2182     function withdraw() external onlyOwner {
2183         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2184         require(success, "Transfer failed");
2185     }
2186 
2187     /// @notice The function to pause the mint. Callable only by the contract owner.
2188     function pauseMint(bool _paused) external onlyOwner {
2189         mintPaused = _paused;
2190     }
2191 
2192     /// @notice The function to change the mint price. Callable only by the contract owner.
2193     /// @param _price The mint price in wei
2194     function setPrice(uint256 _price) external onlyOwner {
2195         price = _price;
2196     }
2197 
2198     /// @notice The function to change the max free mint per wallet. Callable only by the contract owner.
2199     /// @param _maxFreeMint The maximum number of free mints per wallet
2200     function setMaxFreeMint(uint _maxFreeMint) external onlyOwner {
2201         maxFreeMint = _maxFreeMint;
2202     }
2203 
2204     /// @notice The function to set the whitelist minting variable. Callable only by the contract owner.
2205     function setWhitelistMinting(bool _state) external onlyOwner {
2206         whitelistMinting = _state;
2207     }
2208 
2209     /// @notice The function to change the prefix and suffix of the tokenURI. Callable only by the contract owner.
2210     function setURI(
2211         string calldata startTokenURI,
2212         string calldata endTokenURI
2213     ) external onlyOwner {
2214         _startTokenURI = startTokenURI;
2215         _endTokenURI = endTokenURI;
2216     }
2217 
2218     /// @notice Overiddes the ERC721A function to show the tokenURI.
2219     function tokenURI(
2220         uint256 tokenId
2221     ) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2222         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2223         return
2224             bytes(_startTokenURI).length != 0
2225                 ? string(
2226                     abi.encodePacked(
2227                         _startTokenURI,
2228                         _toString(tokenId),
2229                         _endTokenURI
2230                     )
2231                 )
2232                 : "";
2233     }
2234 
2235     /// @notice Overiddes the ERC721A function to start tokenId at 1.
2236     function _startTokenId() internal view virtual override returns (uint256) {
2237         return 1;
2238     }
2239 }