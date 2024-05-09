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
217 // File: @openzeppelin/contracts/utils/Context.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes calldata) {
240         return msg.data;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/access/Ownable.sol
245 
246 
247 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 
252 /**
253  * @dev Contract module which provides a basic access control mechanism, where
254  * there is an account (an owner) that can be granted exclusive access to
255  * specific functions.
256  *
257  * By default, the owner account will be the one that deploys the contract. This
258  * can later be changed with {transferOwnership}.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor() {
273         _transferOwnership(_msgSender());
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         _checkOwner();
281         _;
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view virtual returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if the sender is not the owner.
293      */
294     function _checkOwner() internal view virtual {
295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: erc721a/contracts/IERC721A.sol
330 
331 
332 // ERC721A Contracts v4.2.3
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 /**
338  * @dev Interface of ERC721A.
339  */
340 interface IERC721A {
341     /**
342      * The caller must own the token or be an approved operator.
343      */
344     error ApprovalCallerNotOwnerNorApproved();
345 
346     /**
347      * The token does not exist.
348      */
349     error ApprovalQueryForNonexistentToken();
350 
351     /**
352      * Cannot query the balance for the zero address.
353      */
354     error BalanceQueryForZeroAddress();
355 
356     /**
357      * Cannot mint to the zero address.
358      */
359     error MintToZeroAddress();
360 
361     /**
362      * The quantity of tokens minted must be more than zero.
363      */
364     error MintZeroQuantity();
365 
366     /**
367      * The token does not exist.
368      */
369     error OwnerQueryForNonexistentToken();
370 
371     /**
372      * The caller must own the token or be an approved operator.
373      */
374     error TransferCallerNotOwnerNorApproved();
375 
376     /**
377      * The token must be owned by `from`.
378      */
379     error TransferFromIncorrectOwner();
380 
381     /**
382      * Cannot safely transfer to a contract that does not implement the
383      * ERC721Receiver interface.
384      */
385     error TransferToNonERC721ReceiverImplementer();
386 
387     /**
388      * Cannot transfer to the zero address.
389      */
390     error TransferToZeroAddress();
391 
392     /**
393      * The token does not exist.
394      */
395     error URIQueryForNonexistentToken();
396 
397     /**
398      * The `quantity` minted with ERC2309 exceeds the safety limit.
399      */
400     error MintERC2309QuantityExceedsLimit();
401 
402     /**
403      * The `extraData` cannot be set on an unintialized ownership slot.
404      */
405     error OwnershipNotInitializedForExtraData();
406 
407     // =============================================================
408     //                            STRUCTS
409     // =============================================================
410 
411     struct TokenOwnership {
412         // The address of the owner.
413         address addr;
414         // Stores the start time of ownership with minimal overhead for tokenomics.
415         uint64 startTimestamp;
416         // Whether the token has been burned.
417         bool burned;
418         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
419         uint24 extraData;
420     }
421 
422     // =============================================================
423     //                         TOKEN COUNTERS
424     // =============================================================
425 
426     /**
427      * @dev Returns the total number of tokens in existence.
428      * Burned tokens will reduce the count.
429      * To get the total number of tokens minted, please see {_totalMinted}.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     // =============================================================
434     //                            IERC165
435     // =============================================================
436 
437     /**
438      * @dev Returns true if this contract implements the interface defined by
439      * `interfaceId`. See the corresponding
440      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
441      * to learn more about how these ids are created.
442      *
443      * This function call must use less than 30000 gas.
444      */
445     function supportsInterface(bytes4 interfaceId) external view returns (bool);
446 
447     // =============================================================
448     //                            IERC721
449     // =============================================================
450 
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables
463      * (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in `owner`'s account.
469      */
470     function balanceOf(address owner) external view returns (uint256 balance);
471 
472     /**
473      * @dev Returns the owner of the `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function ownerOf(uint256 tokenId) external view returns (address owner);
480 
481     /**
482      * @dev Safely transfers `tokenId` token from `from` to `to`,
483      * checking first that contract recipients are aware of the ERC721 protocol
484      * to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move
492      * this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement
494      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes calldata data
503     ) external payable;
504 
505     /**
506      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
507      */
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external payable;
513 
514     /**
515      * @dev Transfers `tokenId` from `from` to `to`.
516      *
517      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
518      * whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token
526      * by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external payable;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the
541      * zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external payable;
551 
552     /**
553      * @dev Approve or remove `operator` as an operator for the caller.
554      * Operators can call {transferFrom} or {safeTransferFrom}
555      * for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns the account approved for `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function getApproved(uint256 tokenId) external view returns (address operator);
573 
574     /**
575      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
576      *
577      * See {setApprovalForAll}.
578      */
579     function isApprovedForAll(address owner, address operator) external view returns (bool);
580 
581     // =============================================================
582     //                        IERC721Metadata
583     // =============================================================
584 
585     /**
586      * @dev Returns the token collection name.
587      */
588     function name() external view returns (string memory);
589 
590     /**
591      * @dev Returns the token collection symbol.
592      */
593     function symbol() external view returns (string memory);
594 
595     /**
596      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
597      */
598     function tokenURI(uint256 tokenId) external view returns (string memory);
599 
600     // =============================================================
601     //                           IERC2309
602     // =============================================================
603 
604     /**
605      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
606      * (inclusive) is transferred from `from` to `to`, as defined in the
607      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
608      *
609      * See {_mintERC2309} for more details.
610      */
611     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
612 }
613 
614 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
615 
616 
617 // ERC721A Contracts v4.2.3
618 // Creator: Chiru Labs
619 
620 pragma solidity ^0.8.4;
621 
622 
623 /**
624  * @dev Interface of ERC721AQueryable.
625  */
626 interface IERC721AQueryable is IERC721A {
627     /**
628      * Invalid query range (`start` >= `stop`).
629      */
630     error InvalidQueryRange();
631 
632     /**
633      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
634      *
635      * If the `tokenId` is out of bounds:
636      *
637      * - `addr = address(0)`
638      * - `startTimestamp = 0`
639      * - `burned = false`
640      * - `extraData = 0`
641      *
642      * If the `tokenId` is burned:
643      *
644      * - `addr = <Address of owner before token was burned>`
645      * - `startTimestamp = <Timestamp when token was burned>`
646      * - `burned = true`
647      * - `extraData = <Extra data when token was burned>`
648      *
649      * Otherwise:
650      *
651      * - `addr = <Address of owner>`
652      * - `startTimestamp = <Timestamp of start of ownership>`
653      * - `burned = false`
654      * - `extraData = <Extra data at start of ownership>`
655      */
656     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
657 
658     /**
659      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
660      * See {ERC721AQueryable-explicitOwnershipOf}
661      */
662     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
663 
664     /**
665      * @dev Returns an array of token IDs owned by `owner`,
666      * in the range [`start`, `stop`)
667      * (i.e. `start <= tokenId < stop`).
668      *
669      * This function allows for tokens to be queried if the collection
670      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
671      *
672      * Requirements:
673      *
674      * - `start < stop`
675      */
676     function tokensOfOwnerIn(
677         address owner,
678         uint256 start,
679         uint256 stop
680     ) external view returns (uint256[] memory);
681 
682     /**
683      * @dev Returns an array of token IDs owned by `owner`.
684      *
685      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
686      * It is meant to be called off-chain.
687      *
688      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
689      * multiple smaller scans if the collection is large enough to cause
690      * an out-of-gas error (10K collections should be fine).
691      */
692     function tokensOfOwner(address owner) external view returns (uint256[] memory);
693 }
694 
695 // File: erc721a/contracts/ERC721A.sol
696 
697 
698 // ERC721A Contracts v4.2.3
699 // Creator: Chiru Labs
700 
701 pragma solidity ^0.8.4;
702 
703 
704 /**
705  * @dev Interface of ERC721 token receiver.
706  */
707 interface ERC721A__IERC721Receiver {
708     function onERC721Received(
709         address operator,
710         address from,
711         uint256 tokenId,
712         bytes calldata data
713     ) external returns (bytes4);
714 }
715 
716 /**
717  * @title ERC721A
718  *
719  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
720  * Non-Fungible Token Standard, including the Metadata extension.
721  * Optimized for lower gas during batch mints.
722  *
723  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
724  * starting from `_startTokenId()`.
725  *
726  * Assumptions:
727  *
728  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
729  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
730  */
731 contract ERC721A is IERC721A {
732     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
733     struct TokenApprovalRef {
734         address value;
735     }
736 
737     // =============================================================
738     //                           CONSTANTS
739     // =============================================================
740 
741     // Mask of an entry in packed address data.
742     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
743 
744     // The bit position of `numberMinted` in packed address data.
745     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
746 
747     // The bit position of `numberBurned` in packed address data.
748     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
749 
750     // The bit position of `aux` in packed address data.
751     uint256 private constant _BITPOS_AUX = 192;
752 
753     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
754     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
755 
756     // The bit position of `startTimestamp` in packed ownership.
757     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
758 
759     // The bit mask of the `burned` bit in packed ownership.
760     uint256 private constant _BITMASK_BURNED = 1 << 224;
761 
762     // The bit position of the `nextInitialized` bit in packed ownership.
763     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
764 
765     // The bit mask of the `nextInitialized` bit in packed ownership.
766     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
767 
768     // The bit position of `extraData` in packed ownership.
769     uint256 private constant _BITPOS_EXTRA_DATA = 232;
770 
771     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
772     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
773 
774     // The mask of the lower 160 bits for addresses.
775     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
776 
777     // The maximum `quantity` that can be minted with {_mintERC2309}.
778     // This limit is to prevent overflows on the address data entries.
779     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
780     // is required to cause an overflow, which is unrealistic.
781     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
782 
783     // The `Transfer` event signature is given by:
784     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
785     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
786         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
787 
788     // =============================================================
789     //                            STORAGE
790     // =============================================================
791 
792     // The next token ID to be minted.
793     uint256 private _currentIndex;
794 
795     // The number of tokens burned.
796     uint256 private _burnCounter;
797 
798     // Token name
799     string private _name;
800 
801     // Token symbol
802     string private _symbol;
803 
804     // Mapping from token ID to ownership details
805     // An empty struct value does not necessarily mean the token is unowned.
806     // See {_packedOwnershipOf} implementation for details.
807     //
808     // Bits Layout:
809     // - [0..159]   `addr`
810     // - [160..223] `startTimestamp`
811     // - [224]      `burned`
812     // - [225]      `nextInitialized`
813     // - [232..255] `extraData`
814     mapping(uint256 => uint256) private _packedOwnerships;
815 
816     // Mapping owner address to address data.
817     //
818     // Bits Layout:
819     // - [0..63]    `balance`
820     // - [64..127]  `numberMinted`
821     // - [128..191] `numberBurned`
822     // - [192..255] `aux`
823     mapping(address => uint256) private _packedAddressData;
824 
825     // Mapping from token ID to approved address.
826     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     // =============================================================
832     //                          CONSTRUCTOR
833     // =============================================================
834 
835     constructor(string memory name_, string memory symbol_) {
836         _name = name_;
837         _symbol = symbol_;
838         _currentIndex = _startTokenId();
839     }
840 
841     // =============================================================
842     //                   TOKEN COUNTING OPERATIONS
843     // =============================================================
844 
845     /**
846      * @dev Returns the starting token ID.
847      * To change the starting token ID, please override this function.
848      */
849     function _startTokenId() internal view virtual returns (uint256) {
850         return 0;
851     }
852 
853     /**
854      * @dev Returns the next token ID to be minted.
855      */
856     function _nextTokenId() internal view virtual returns (uint256) {
857         return _currentIndex;
858     }
859 
860     /**
861      * @dev Returns the total number of tokens in existence.
862      * Burned tokens will reduce the count.
863      * To get the total number of tokens minted, please see {_totalMinted}.
864      */
865     function totalSupply() public view virtual override returns (uint256) {
866         // Counter underflow is impossible as _burnCounter cannot be incremented
867         // more than `_currentIndex - _startTokenId()` times.
868         unchecked {
869             return _currentIndex - _burnCounter - _startTokenId();
870         }
871     }
872 
873     /**
874      * @dev Returns the total amount of tokens minted in the contract.
875      */
876     function _totalMinted() internal view virtual returns (uint256) {
877         // Counter underflow is impossible as `_currentIndex` does not decrement,
878         // and it is initialized to `_startTokenId()`.
879         unchecked {
880             return _currentIndex - _startTokenId();
881         }
882     }
883 
884     /**
885      * @dev Returns the total number of tokens burned.
886      */
887     function _totalBurned() internal view virtual returns (uint256) {
888         return _burnCounter;
889     }
890 
891     // =============================================================
892     //                    ADDRESS DATA OPERATIONS
893     // =============================================================
894 
895     /**
896      * @dev Returns the number of tokens in `owner`'s account.
897      */
898     function balanceOf(address owner) public view virtual override returns (uint256) {
899         if (owner == address(0)) revert BalanceQueryForZeroAddress();
900         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
901     }
902 
903     /**
904      * Returns the number of tokens minted by `owner`.
905      */
906     function _numberMinted(address owner) internal view returns (uint256) {
907         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
908     }
909 
910     /**
911      * Returns the number of tokens burned by or on behalf of `owner`.
912      */
913     function _numberBurned(address owner) internal view returns (uint256) {
914         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
915     }
916 
917     /**
918      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
919      */
920     function _getAux(address owner) internal view returns (uint64) {
921         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
922     }
923 
924     /**
925      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
926      * If there are multiple variables, please pack them into a uint64.
927      */
928     function _setAux(address owner, uint64 aux) internal virtual {
929         uint256 packed = _packedAddressData[owner];
930         uint256 auxCasted;
931         // Cast `aux` with assembly to avoid redundant masking.
932         assembly {
933             auxCasted := aux
934         }
935         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
936         _packedAddressData[owner] = packed;
937     }
938 
939     // =============================================================
940     //                            IERC165
941     // =============================================================
942 
943     /**
944      * @dev Returns true if this contract implements the interface defined by
945      * `interfaceId`. See the corresponding
946      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
947      * to learn more about how these ids are created.
948      *
949      * This function call must use less than 30000 gas.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952         // The interface IDs are constants representing the first 4 bytes
953         // of the XOR of all function selectors in the interface.
954         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
955         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
956         return
957             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
958             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
959             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
960     }
961 
962     // =============================================================
963     //                        IERC721Metadata
964     // =============================================================
965 
966     /**
967      * @dev Returns the token collection name.
968      */
969     function name() public view virtual override returns (string memory) {
970         return _name;
971     }
972 
973     /**
974      * @dev Returns the token collection symbol.
975      */
976     function symbol() public view virtual override returns (string memory) {
977         return _symbol;
978     }
979 
980     /**
981      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
982      */
983     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
984         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
985 
986         string memory baseURI = _baseURI();
987         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
988     }
989 
990     /**
991      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
992      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
993      * by default, it can be overridden in child contracts.
994      */
995     function _baseURI() internal view virtual returns (string memory) {
996         return '';
997     }
998 
999     // =============================================================
1000     //                     OWNERSHIPS OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Returns the owner of the `tokenId` token.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      */
1010     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1011         return address(uint160(_packedOwnershipOf(tokenId)));
1012     }
1013 
1014     /**
1015      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1016      * It gradually moves to O(1) as tokens get transferred around over time.
1017      */
1018     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1019         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1020     }
1021 
1022     /**
1023      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1024      */
1025     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1026         return _unpackedOwnership(_packedOwnerships[index]);
1027     }
1028 
1029     /**
1030      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1031      */
1032     function _initializeOwnershipAt(uint256 index) internal virtual {
1033         if (_packedOwnerships[index] == 0) {
1034             _packedOwnerships[index] = _packedOwnershipOf(index);
1035         }
1036     }
1037 
1038     /**
1039      * Returns the packed ownership data of `tokenId`.
1040      */
1041     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1042         uint256 curr = tokenId;
1043 
1044         unchecked {
1045             if (_startTokenId() <= curr)
1046                 if (curr < _currentIndex) {
1047                     uint256 packed = _packedOwnerships[curr];
1048                     // If not burned.
1049                     if (packed & _BITMASK_BURNED == 0) {
1050                         // Invariant:
1051                         // There will always be an initialized ownership slot
1052                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1053                         // before an unintialized ownership slot
1054                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1055                         // Hence, `curr` will not underflow.
1056                         //
1057                         // We can directly compare the packed value.
1058                         // If the address is zero, packed will be zero.
1059                         while (packed == 0) {
1060                             packed = _packedOwnerships[--curr];
1061                         }
1062                         return packed;
1063                     }
1064                 }
1065         }
1066         revert OwnerQueryForNonexistentToken();
1067     }
1068 
1069     /**
1070      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1071      */
1072     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1073         ownership.addr = address(uint160(packed));
1074         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1075         ownership.burned = packed & _BITMASK_BURNED != 0;
1076         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1077     }
1078 
1079     /**
1080      * @dev Packs ownership data into a single uint256.
1081      */
1082     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1083         assembly {
1084             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1085             owner := and(owner, _BITMASK_ADDRESS)
1086             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1087             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1088         }
1089     }
1090 
1091     /**
1092      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1093      */
1094     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1095         // For branchless setting of the `nextInitialized` flag.
1096         assembly {
1097             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1098             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1099         }
1100     }
1101 
1102     // =============================================================
1103     //                      APPROVAL OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1108      * The approval is cleared when the token is transferred.
1109      *
1110      * Only a single account can be approved at a time, so approving the
1111      * zero address clears previous approvals.
1112      *
1113      * Requirements:
1114      *
1115      * - The caller must own the token or be an approved operator.
1116      * - `tokenId` must exist.
1117      *
1118      * Emits an {Approval} event.
1119      */
1120     function approve(address to, uint256 tokenId) public payable virtual override {
1121         address owner = ownerOf(tokenId);
1122 
1123         if (_msgSenderERC721A() != owner)
1124             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1125                 revert ApprovalCallerNotOwnerNorApproved();
1126             }
1127 
1128         _tokenApprovals[tokenId].value = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Returns the account approved for `tokenId` token.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      */
1139     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1140         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1141 
1142         return _tokenApprovals[tokenId].value;
1143     }
1144 
1145     /**
1146      * @dev Approve or remove `operator` as an operator for the caller.
1147      * Operators can call {transferFrom} or {safeTransferFrom}
1148      * for any token owned by the caller.
1149      *
1150      * Requirements:
1151      *
1152      * - The `operator` cannot be the caller.
1153      *
1154      * Emits an {ApprovalForAll} event.
1155      */
1156     function setApprovalForAll(address operator, bool approved) public virtual override {
1157         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1158         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1159     }
1160 
1161     /**
1162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1163      *
1164      * See {setApprovalForAll}.
1165      */
1166     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1167         return _operatorApprovals[owner][operator];
1168     }
1169 
1170     /**
1171      * @dev Returns whether `tokenId` exists.
1172      *
1173      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1174      *
1175      * Tokens start existing when they are minted. See {_mint}.
1176      */
1177     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1178         return
1179             _startTokenId() <= tokenId &&
1180             tokenId < _currentIndex && // If within bounds,
1181             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1182     }
1183 
1184     /**
1185      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1186      */
1187     function _isSenderApprovedOrOwner(
1188         address approvedAddress,
1189         address owner,
1190         address msgSender
1191     ) private pure returns (bool result) {
1192         assembly {
1193             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1194             owner := and(owner, _BITMASK_ADDRESS)
1195             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1196             msgSender := and(msgSender, _BITMASK_ADDRESS)
1197             // `msgSender == owner || msgSender == approvedAddress`.
1198             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1204      */
1205     function _getApprovedSlotAndAddress(uint256 tokenId)
1206         private
1207         view
1208         returns (uint256 approvedAddressSlot, address approvedAddress)
1209     {
1210         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1211         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1212         assembly {
1213             approvedAddressSlot := tokenApproval.slot
1214             approvedAddress := sload(approvedAddressSlot)
1215         }
1216     }
1217 
1218     // =============================================================
1219     //                      TRANSFER OPERATIONS
1220     // =============================================================
1221 
1222     /**
1223      * @dev Transfers `tokenId` from `from` to `to`.
1224      *
1225      * Requirements:
1226      *
1227      * - `from` cannot be the zero address.
1228      * - `to` cannot be the zero address.
1229      * - `tokenId` token must be owned by `from`.
1230      * - If the caller is not `from`, it must be approved to move this token
1231      * by either {approve} or {setApprovalForAll}.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function transferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public payable virtual override {
1240         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1241 
1242         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1243 
1244         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1245 
1246         // The nested ifs save around 20+ gas over a compound boolean condition.
1247         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1248             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1249 
1250         if (to == address(0)) revert TransferToZeroAddress();
1251 
1252         _beforeTokenTransfers(from, to, tokenId, 1);
1253 
1254         // Clear approvals from the previous owner.
1255         assembly {
1256             if approvedAddress {
1257                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1258                 sstore(approvedAddressSlot, 0)
1259             }
1260         }
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1265         unchecked {
1266             // We can directly increment and decrement the balances.
1267             --_packedAddressData[from]; // Updates: `balance -= 1`.
1268             ++_packedAddressData[to]; // Updates: `balance += 1`.
1269 
1270             // Updates:
1271             // - `address` to the next owner.
1272             // - `startTimestamp` to the timestamp of transfering.
1273             // - `burned` to `false`.
1274             // - `nextInitialized` to `true`.
1275             _packedOwnerships[tokenId] = _packOwnershipData(
1276                 to,
1277                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1278             );
1279 
1280             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1281             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1282                 uint256 nextTokenId = tokenId + 1;
1283                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1284                 if (_packedOwnerships[nextTokenId] == 0) {
1285                     // If the next slot is within bounds.
1286                     if (nextTokenId != _currentIndex) {
1287                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1288                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1289                     }
1290                 }
1291             }
1292         }
1293 
1294         emit Transfer(from, to, tokenId);
1295         _afterTokenTransfers(from, to, tokenId, 1);
1296     }
1297 
1298     /**
1299      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1300      */
1301     function safeTransferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) public payable virtual override {
1306         safeTransferFrom(from, to, tokenId, '');
1307     }
1308 
1309     /**
1310      * @dev Safely transfers `tokenId` token from `from` to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `from` cannot be the zero address.
1315      * - `to` cannot be the zero address.
1316      * - `tokenId` token must exist and be owned by `from`.
1317      * - If the caller is not `from`, it must be approved to move this token
1318      * by either {approve} or {setApprovalForAll}.
1319      * - If `to` refers to a smart contract, it must implement
1320      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 tokenId,
1328         bytes memory _data
1329     ) public payable virtual override {
1330         transferFrom(from, to, tokenId);
1331         if (to.code.length != 0)
1332             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1333                 revert TransferToNonERC721ReceiverImplementer();
1334             }
1335     }
1336 
1337     /**
1338      * @dev Hook that is called before a set of serially-ordered token IDs
1339      * are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * `startTokenId` - the first token ID to be transferred.
1343      * `quantity` - the amount to be transferred.
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token IDs
1362      * have been transferred. This includes minting.
1363      * And also called after one token has been burned.
1364      *
1365      * `startTokenId` - the first token ID to be transferred.
1366      * `quantity` - the amount to be transferred.
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 
1383     /**
1384      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * `from` - Previous owner of the given token ID.
1387      * `to` - Target address that will receive the token.
1388      * `tokenId` - Token ID to be transferred.
1389      * `_data` - Optional data to send along with the call.
1390      *
1391      * Returns whether the call correctly returned the expected magic value.
1392      */
1393     function _checkContractOnERC721Received(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) private returns (bool) {
1399         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1400             bytes4 retval
1401         ) {
1402             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1403         } catch (bytes memory reason) {
1404             if (reason.length == 0) {
1405                 revert TransferToNonERC721ReceiverImplementer();
1406             } else {
1407                 assembly {
1408                     revert(add(32, reason), mload(reason))
1409                 }
1410             }
1411         }
1412     }
1413 
1414     // =============================================================
1415     //                        MINT OPERATIONS
1416     // =============================================================
1417 
1418     /**
1419      * @dev Mints `quantity` tokens and transfers them to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `to` cannot be the zero address.
1424      * - `quantity` must be greater than 0.
1425      *
1426      * Emits a {Transfer} event for each mint.
1427      */
1428     function _mint(address to, uint256 quantity) internal virtual {
1429         uint256 startTokenId = _currentIndex;
1430         if (quantity == 0) revert MintZeroQuantity();
1431 
1432         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1433 
1434         // Overflows are incredibly unrealistic.
1435         // `balance` and `numberMinted` have a maximum limit of 2**64.
1436         // `tokenId` has a maximum limit of 2**256.
1437         unchecked {
1438             // Updates:
1439             // - `balance += quantity`.
1440             // - `numberMinted += quantity`.
1441             //
1442             // We can directly add to the `balance` and `numberMinted`.
1443             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1444 
1445             // Updates:
1446             // - `address` to the owner.
1447             // - `startTimestamp` to the timestamp of minting.
1448             // - `burned` to `false`.
1449             // - `nextInitialized` to `quantity == 1`.
1450             _packedOwnerships[startTokenId] = _packOwnershipData(
1451                 to,
1452                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1453             );
1454 
1455             uint256 toMasked;
1456             uint256 end = startTokenId + quantity;
1457 
1458             // Use assembly to loop and emit the `Transfer` event for gas savings.
1459             // The duplicated `log4` removes an extra check and reduces stack juggling.
1460             // The assembly, together with the surrounding Solidity code, have been
1461             // delicately arranged to nudge the compiler into producing optimized opcodes.
1462             assembly {
1463                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1464                 toMasked := and(to, _BITMASK_ADDRESS)
1465                 // Emit the `Transfer` event.
1466                 log4(
1467                     0, // Start of data (0, since no data).
1468                     0, // End of data (0, since no data).
1469                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1470                     0, // `address(0)`.
1471                     toMasked, // `to`.
1472                     startTokenId // `tokenId`.
1473                 )
1474 
1475                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1476                 // that overflows uint256 will make the loop run out of gas.
1477                 // The compiler will optimize the `iszero` away for performance.
1478                 for {
1479                     let tokenId := add(startTokenId, 1)
1480                 } iszero(eq(tokenId, end)) {
1481                     tokenId := add(tokenId, 1)
1482                 } {
1483                     // Emit the `Transfer` event. Similar to above.
1484                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1485                 }
1486             }
1487             if (toMasked == 0) revert MintToZeroAddress();
1488 
1489             _currentIndex = end;
1490         }
1491         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1492     }
1493 
1494     /**
1495      * @dev Mints `quantity` tokens and transfers them to `to`.
1496      *
1497      * This function is intended for efficient minting only during contract creation.
1498      *
1499      * It emits only one {ConsecutiveTransfer} as defined in
1500      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1501      * instead of a sequence of {Transfer} event(s).
1502      *
1503      * Calling this function outside of contract creation WILL make your contract
1504      * non-compliant with the ERC721 standard.
1505      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1506      * {ConsecutiveTransfer} event is only permissible during contract creation.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `quantity` must be greater than 0.
1512      *
1513      * Emits a {ConsecutiveTransfer} event.
1514      */
1515     function _mintERC2309(address to, uint256 quantity) internal virtual {
1516         uint256 startTokenId = _currentIndex;
1517         if (to == address(0)) revert MintToZeroAddress();
1518         if (quantity == 0) revert MintZeroQuantity();
1519         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1520 
1521         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1522 
1523         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1524         unchecked {
1525             // Updates:
1526             // - `balance += quantity`.
1527             // - `numberMinted += quantity`.
1528             //
1529             // We can directly add to the `balance` and `numberMinted`.
1530             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1531 
1532             // Updates:
1533             // - `address` to the owner.
1534             // - `startTimestamp` to the timestamp of minting.
1535             // - `burned` to `false`.
1536             // - `nextInitialized` to `quantity == 1`.
1537             _packedOwnerships[startTokenId] = _packOwnershipData(
1538                 to,
1539                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1540             );
1541 
1542             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1543 
1544             _currentIndex = startTokenId + quantity;
1545         }
1546         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1547     }
1548 
1549     /**
1550      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1551      *
1552      * Requirements:
1553      *
1554      * - If `to` refers to a smart contract, it must implement
1555      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1556      * - `quantity` must be greater than 0.
1557      *
1558      * See {_mint}.
1559      *
1560      * Emits a {Transfer} event for each mint.
1561      */
1562     function _safeMint(
1563         address to,
1564         uint256 quantity,
1565         bytes memory _data
1566     ) internal virtual {
1567         _mint(to, quantity);
1568 
1569         unchecked {
1570             if (to.code.length != 0) {
1571                 uint256 end = _currentIndex;
1572                 uint256 index = end - quantity;
1573                 do {
1574                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1575                         revert TransferToNonERC721ReceiverImplementer();
1576                     }
1577                 } while (index < end);
1578                 // Reentrancy protection.
1579                 if (_currentIndex != end) revert();
1580             }
1581         }
1582     }
1583 
1584     /**
1585      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1586      */
1587     function _safeMint(address to, uint256 quantity) internal virtual {
1588         _safeMint(to, quantity, '');
1589     }
1590 
1591     // =============================================================
1592     //                        BURN OPERATIONS
1593     // =============================================================
1594 
1595     /**
1596      * @dev Equivalent to `_burn(tokenId, false)`.
1597      */
1598     function _burn(uint256 tokenId) internal virtual {
1599         _burn(tokenId, false);
1600     }
1601 
1602     /**
1603      * @dev Destroys `tokenId`.
1604      * The approval is cleared when the token is burned.
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must exist.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1613         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1614 
1615         address from = address(uint160(prevOwnershipPacked));
1616 
1617         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1618 
1619         if (approvalCheck) {
1620             // The nested ifs save around 20+ gas over a compound boolean condition.
1621             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1622                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1623         }
1624 
1625         _beforeTokenTransfers(from, address(0), tokenId, 1);
1626 
1627         // Clear approvals from the previous owner.
1628         assembly {
1629             if approvedAddress {
1630                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1631                 sstore(approvedAddressSlot, 0)
1632             }
1633         }
1634 
1635         // Underflow of the sender's balance is impossible because we check for
1636         // ownership above and the recipient's balance can't realistically overflow.
1637         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1638         unchecked {
1639             // Updates:
1640             // - `balance -= 1`.
1641             // - `numberBurned += 1`.
1642             //
1643             // We can directly decrement the balance, and increment the number burned.
1644             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1645             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1646 
1647             // Updates:
1648             // - `address` to the last owner.
1649             // - `startTimestamp` to the timestamp of burning.
1650             // - `burned` to `true`.
1651             // - `nextInitialized` to `true`.
1652             _packedOwnerships[tokenId] = _packOwnershipData(
1653                 from,
1654                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1655             );
1656 
1657             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1658             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1659                 uint256 nextTokenId = tokenId + 1;
1660                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1661                 if (_packedOwnerships[nextTokenId] == 0) {
1662                     // If the next slot is within bounds.
1663                     if (nextTokenId != _currentIndex) {
1664                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1665                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1666                     }
1667                 }
1668             }
1669         }
1670 
1671         emit Transfer(from, address(0), tokenId);
1672         _afterTokenTransfers(from, address(0), tokenId, 1);
1673 
1674         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1675         unchecked {
1676             _burnCounter++;
1677         }
1678     }
1679 
1680     // =============================================================
1681     //                     EXTRA DATA OPERATIONS
1682     // =============================================================
1683 
1684     /**
1685      * @dev Directly sets the extra data for the ownership data `index`.
1686      */
1687     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1688         uint256 packed = _packedOwnerships[index];
1689         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1690         uint256 extraDataCasted;
1691         // Cast `extraData` with assembly to avoid redundant masking.
1692         assembly {
1693             extraDataCasted := extraData
1694         }
1695         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1696         _packedOwnerships[index] = packed;
1697     }
1698 
1699     /**
1700      * @dev Called during each token transfer to set the 24bit `extraData` field.
1701      * Intended to be overridden by the cosumer contract.
1702      *
1703      * `previousExtraData` - the value of `extraData` before transfer.
1704      *
1705      * Calling conditions:
1706      *
1707      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1708      * transferred to `to`.
1709      * - When `from` is zero, `tokenId` will be minted for `to`.
1710      * - When `to` is zero, `tokenId` will be burned by `from`.
1711      * - `from` and `to` are never both zero.
1712      */
1713     function _extraData(
1714         address from,
1715         address to,
1716         uint24 previousExtraData
1717     ) internal view virtual returns (uint24) {}
1718 
1719     /**
1720      * @dev Returns the next extra data for the packed ownership data.
1721      * The returned result is shifted into position.
1722      */
1723     function _nextExtraData(
1724         address from,
1725         address to,
1726         uint256 prevOwnershipPacked
1727     ) private view returns (uint256) {
1728         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1729         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1730     }
1731 
1732     // =============================================================
1733     //                       OTHER OPERATIONS
1734     // =============================================================
1735 
1736     /**
1737      * @dev Returns the message sender (defaults to `msg.sender`).
1738      *
1739      * If you are writing GSN compatible contracts, you need to override this function.
1740      */
1741     function _msgSenderERC721A() internal view virtual returns (address) {
1742         return msg.sender;
1743     }
1744 
1745     /**
1746      * @dev Converts a uint256 to its ASCII string decimal representation.
1747      */
1748     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1749         assembly {
1750             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1751             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1752             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1753             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1754             let m := add(mload(0x40), 0xa0)
1755             // Update the free memory pointer to allocate.
1756             mstore(0x40, m)
1757             // Assign the `str` to the end.
1758             str := sub(m, 0x20)
1759             // Zeroize the slot after the string.
1760             mstore(str, 0)
1761 
1762             // Cache the end of the memory to calculate the length later.
1763             let end := str
1764 
1765             // We write the string from rightmost digit to leftmost digit.
1766             // The following is essentially a do-while loop that also handles the zero case.
1767             // prettier-ignore
1768             for { let temp := value } 1 {} {
1769                 str := sub(str, 1)
1770                 // Write the character to the pointer.
1771                 // The ASCII index of the '0' character is 48.
1772                 mstore8(str, add(48, mod(temp, 10)))
1773                 // Keep dividing `temp` until zero.
1774                 temp := div(temp, 10)
1775                 // prettier-ignore
1776                 if iszero(temp) { break }
1777             }
1778 
1779             let length := sub(end, str)
1780             // Move the pointer 32 bytes leftwards to make room for the length.
1781             str := sub(str, 0x20)
1782             // Store the length.
1783             mstore(str, length)
1784         }
1785     }
1786 }
1787 
1788 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1789 
1790 
1791 // ERC721A Contracts v4.2.3
1792 // Creator: Chiru Labs
1793 
1794 pragma solidity ^0.8.4;
1795 
1796 
1797 
1798 /**
1799  * @title ERC721AQueryable.
1800  *
1801  * @dev ERC721A subclass with convenience query functions.
1802  */
1803 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1804     /**
1805      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1806      *
1807      * If the `tokenId` is out of bounds:
1808      *
1809      * - `addr = address(0)`
1810      * - `startTimestamp = 0`
1811      * - `burned = false`
1812      * - `extraData = 0`
1813      *
1814      * If the `tokenId` is burned:
1815      *
1816      * - `addr = <Address of owner before token was burned>`
1817      * - `startTimestamp = <Timestamp when token was burned>`
1818      * - `burned = true`
1819      * - `extraData = <Extra data when token was burned>`
1820      *
1821      * Otherwise:
1822      *
1823      * - `addr = <Address of owner>`
1824      * - `startTimestamp = <Timestamp of start of ownership>`
1825      * - `burned = false`
1826      * - `extraData = <Extra data at start of ownership>`
1827      */
1828     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1829         TokenOwnership memory ownership;
1830         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1831             return ownership;
1832         }
1833         ownership = _ownershipAt(tokenId);
1834         if (ownership.burned) {
1835             return ownership;
1836         }
1837         return _ownershipOf(tokenId);
1838     }
1839 
1840     /**
1841      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1842      * See {ERC721AQueryable-explicitOwnershipOf}
1843      */
1844     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1845         external
1846         view
1847         virtual
1848         override
1849         returns (TokenOwnership[] memory)
1850     {
1851         unchecked {
1852             uint256 tokenIdsLength = tokenIds.length;
1853             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1854             for (uint256 i; i != tokenIdsLength; ++i) {
1855                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1856             }
1857             return ownerships;
1858         }
1859     }
1860 
1861     /**
1862      * @dev Returns an array of token IDs owned by `owner`,
1863      * in the range [`start`, `stop`)
1864      * (i.e. `start <= tokenId < stop`).
1865      *
1866      * This function allows for tokens to be queried if the collection
1867      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1868      *
1869      * Requirements:
1870      *
1871      * - `start < stop`
1872      */
1873     function tokensOfOwnerIn(
1874         address owner,
1875         uint256 start,
1876         uint256 stop
1877     ) external view virtual override returns (uint256[] memory) {
1878         unchecked {
1879             if (start >= stop) revert InvalidQueryRange();
1880             uint256 tokenIdsIdx;
1881             uint256 stopLimit = _nextTokenId();
1882             // Set `start = max(start, _startTokenId())`.
1883             if (start < _startTokenId()) {
1884                 start = _startTokenId();
1885             }
1886             // Set `stop = min(stop, stopLimit)`.
1887             if (stop > stopLimit) {
1888                 stop = stopLimit;
1889             }
1890             uint256 tokenIdsMaxLength = balanceOf(owner);
1891             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1892             // to cater for cases where `balanceOf(owner)` is too big.
1893             if (start < stop) {
1894                 uint256 rangeLength = stop - start;
1895                 if (rangeLength < tokenIdsMaxLength) {
1896                     tokenIdsMaxLength = rangeLength;
1897                 }
1898             } else {
1899                 tokenIdsMaxLength = 0;
1900             }
1901             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1902             if (tokenIdsMaxLength == 0) {
1903                 return tokenIds;
1904             }
1905             // We need to call `explicitOwnershipOf(start)`,
1906             // because the slot at `start` may not be initialized.
1907             TokenOwnership memory ownership = explicitOwnershipOf(start);
1908             address currOwnershipAddr;
1909             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1910             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1911             if (!ownership.burned) {
1912                 currOwnershipAddr = ownership.addr;
1913             }
1914             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1915                 ownership = _ownershipAt(i);
1916                 if (ownership.burned) {
1917                     continue;
1918                 }
1919                 if (ownership.addr != address(0)) {
1920                     currOwnershipAddr = ownership.addr;
1921                 }
1922                 if (currOwnershipAddr == owner) {
1923                     tokenIds[tokenIdsIdx++] = i;
1924                 }
1925             }
1926             // Downsize the array to fit.
1927             assembly {
1928                 mstore(tokenIds, tokenIdsIdx)
1929             }
1930             return tokenIds;
1931         }
1932     }
1933 
1934     /**
1935      * @dev Returns an array of token IDs owned by `owner`.
1936      *
1937      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1938      * It is meant to be called off-chain.
1939      *
1940      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1941      * multiple smaller scans if the collection is large enough to cause
1942      * an out-of-gas error (10K collections should be fine).
1943      */
1944     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1945         unchecked {
1946             uint256 tokenIdsIdx;
1947             address currOwnershipAddr;
1948             uint256 tokenIdsLength = balanceOf(owner);
1949             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1950             TokenOwnership memory ownership;
1951             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1952                 ownership = _ownershipAt(i);
1953                 if (ownership.burned) {
1954                     continue;
1955                 }
1956                 if (ownership.addr != address(0)) {
1957                     currOwnershipAddr = ownership.addr;
1958                 }
1959                 if (currOwnershipAddr == owner) {
1960                     tokenIds[tokenIdsIdx++] = i;
1961                 }
1962             }
1963             return tokenIds;
1964         }
1965     }
1966 }
1967 
1968 // File: nakama.sol
1969 
1970 
1971 
1972 pragma solidity ^0.8.4 .0;
1973 
1974 
1975 
1976 
1977 
1978 // ███╗   ██╗ █████╗ ██╗  ██╗ █████╗ ███╗   ███╗ █████╗
1979 // ████╗  ██║██╔══██╗██║ ██╔╝██╔══██╗████╗ ████║██╔══██╗
1980 // ██╔██╗ ██║███████║█████╔╝ ███████║██╔████╔██║███████║
1981 // ██║╚██╗██║██╔══██║██╔═██╗ ██╔══██║██║╚██╔╝██║██╔══██║
1982 // ██║ ╚████║██║  ██║██║  ██╗██║  ██║██║ ╚═╝ ██║██║  ██║
1983 // ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝
1984 // Embrace The Mischief - Small Creatures With A Big Attitude. Will You Survive The Journey Ahead?
1985 
1986 /// @title ERC721A contract for the Nakama MC NFT collection
1987 /// @author Syahmi Rafsan
1988 contract NakamaMC is ERC721A, ERC721AQueryable, Ownable {
1989     uint256 public constant MAX_SUPPLY = 4888;
1990     uint256 public price;
1991     uint256 public maxPerWallet;
1992     string private _startTokenURI;
1993     string private _endTokenURI;
1994     bool public whitelistMinting = true;
1995     bytes32 public merkleRoot;
1996 
1997     constructor(
1998         string memory startTokenURI,
1999         string memory endTokenURI,
2000         bytes32 _merkleRoot,
2001         uint256 _maxPerWallet
2002     ) ERC721A("Nakama", "NAKAMA") {
2003         _startTokenURI = startTokenURI;
2004         _endTokenURI = endTokenURI;
2005         merkleRoot = _merkleRoot;
2006         maxPerWallet = _maxPerWallet;
2007     }
2008 
2009     /// @notice The NFT minting function for public
2010     /// @param quantity The number of NFT to be minted
2011     function mintPublic(uint256 quantity) external payable {
2012         require(msg.sender == tx.origin, "Minter is a contract");
2013         require(!whitelistMinting, "Mint is only for whitelist");
2014         require(
2015             _totalMinted() + quantity <= MAX_SUPPLY,
2016             "Maximum supply exceeded"
2017         );
2018         require(
2019             msg.value == quantity * price,
2020             "Funds are not the right amount"
2021         );
2022         _mint(msg.sender, quantity);
2023     }
2024 
2025     /// @notice The NFT minting function for whitelisted addresses
2026     /// @param quantity The number of NFT to be minted
2027     /// @param proof The Merkle proof to validate with the Merkle root
2028     function mintWhitelist(
2029         uint256 quantity,
2030         bytes32[] memory proof
2031     ) external payable {
2032         require(msg.sender == tx.origin, "Minter is a contract");
2033         require(whitelistMinting, "Mint is now open to public");
2034         require(
2035             _totalMinted() + quantity <= MAX_SUPPLY,
2036             "Maximum supply exceeded"
2037         );
2038         require(
2039             _numberMinted(msg.sender) + quantity <= maxPerWallet,
2040             "Maximum mint per wallet exceeded"
2041         );
2042         require(
2043             msg.value == quantity * price,
2044             "Funds are not the right amount"
2045         );
2046         require(
2047             isValid(proof, keccak256(abi.encodePacked(msg.sender))),
2048             "Sorry but you are not eligible to mint"
2049         );
2050         _mint(msg.sender, quantity);
2051     }
2052 
2053     /// @notice The function to validate the Merkle proof with the Merkle root via leaf
2054     /// @param proof The Merkle proof to be validated
2055     /// @param leaf The mint price in wei
2056     function isValid(
2057         bytes32[] memory proof,
2058         bytes32 leaf
2059     ) public view returns (bool) {
2060         return MerkleProof.verify(proof, merkleRoot, leaf);
2061     }
2062 
2063     /// @notice The function to change mint configuration. Callable only by the contract owner.
2064     /// @param _merkleRoot The Merkle root of the whitelisted addresses
2065     /// @param _maxPerWallet The maximum number of mints per wallet
2066     function setMintConfig(
2067         bytes32 _merkleRoot,
2068         uint256 _maxPerWallet
2069     ) external onlyOwner {
2070         merkleRoot = _merkleRoot;
2071         maxPerWallet = _maxPerWallet;
2072     }
2073 
2074     /// @notice The function to change the mint price. Callable only by the contract owner.
2075     /// @param _price The mint price in wei
2076     function setPrice(uint256 _price) external onlyOwner {
2077         price = _price;
2078     }
2079 
2080     /// @notice The function to withdraw the contract balance to the developer and project wallets. Callable only by the contract owner.
2081     function withdraw() external onlyOwner {
2082         address devWallet = 0x94c970c7c352AA8f9C1cca09396E07873f3FC5Be;
2083         address projectWallet = 0xb6e7E59121E5aF3465D9deEC32f9E59290B9458D;
2084 
2085         (bool success, ) = payable(devWallet).call{
2086             value: ((address(this).balance * 10) / 100)
2087         }("");
2088         require(success, "Transfer failed");
2089 
2090         (bool success2, ) = payable(projectWallet).call{
2091             value: (address(this).balance)
2092         }("");
2093         require(success2, "Transfer failed");
2094     }
2095 
2096     /// @notice The function to set the whitelist minting variable. Callable only by the contract owner.
2097     function setWhitelistMinting(bool _state) external onlyOwner {
2098         whitelistMinting = _state;
2099     }
2100 
2101     /// @notice The function to change the prefix and suffix of the tokenURI. Callable only by the contract owner.
2102     function setURI(
2103         string calldata startTokenURI,
2104         string calldata endTokenURI
2105     ) external onlyOwner {
2106         _startTokenURI = startTokenURI;
2107         _endTokenURI = endTokenURI;
2108     }
2109 
2110     /// @notice Overiddes the ERC721A function to show the tokenURI.
2111     function tokenURI(
2112         uint256 tokenId
2113     ) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2114         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2115         return
2116             bytes(_startTokenURI).length != 0
2117                 ? string(
2118                     abi.encodePacked(
2119                         _startTokenURI,
2120                         _toString(tokenId),
2121                         _endTokenURI
2122                     )
2123                 )
2124                 : "";
2125     }
2126 
2127     /// @notice Overiddes the ERC721A function to start tokenId at 1.
2128     function _startTokenId() internal view virtual override returns (uint256) {
2129         return 1;
2130     }
2131 }