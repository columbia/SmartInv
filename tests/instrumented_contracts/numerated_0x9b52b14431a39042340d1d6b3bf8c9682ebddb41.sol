1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         _checkOwner();
64         _;
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if the sender is not the owner.
76      */
77     function _checkOwner() internal view virtual {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.0
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev These functions deal with verification of Merkle Tree proofs.
120  *
121  * The tree and the proofs can be generated using our
122  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
123  * You will find a quickstart guide in the readme.
124  *
125  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
126  * hashing, or use a hash function other than keccak256 for hashing leaves.
127  * This is because the concatenation of a sorted pair of internal nodes in
128  * the merkle tree could be reinterpreted as a leaf value.
129  * OpenZeppelin's JavaScript library generates merkle trees that are safe
130  * against this attack out of the box.
131  */
132 library MerkleProof {
133     /**
134      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
135      * defined by `root`. For this, a `proof` must be provided, containing
136      * sibling hashes on the branch from the leaf to the root of the tree. Each
137      * pair of leaves and each pair of pre-images are assumed to be sorted.
138      */
139     function verify(
140         bytes32[] memory proof,
141         bytes32 root,
142         bytes32 leaf
143     ) internal pure returns (bool) {
144         return processProof(proof, leaf) == root;
145     }
146 
147     /**
148      * @dev Calldata version of {verify}
149      *
150      * _Available since v4.7._
151      */
152     function verifyCalldata(
153         bytes32[] calldata proof,
154         bytes32 root,
155         bytes32 leaf
156     ) internal pure returns (bool) {
157         return processProofCalldata(proof, leaf) == root;
158     }
159 
160     /**
161      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
162      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
163      * hash matches the root of the tree. When processing the proof, the pairs
164      * of leafs & pre-images are assumed to be sorted.
165      *
166      * _Available since v4.4._
167      */
168     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
169         bytes32 computedHash = leaf;
170         for (uint256 i = 0; i < proof.length; i++) {
171             computedHash = _hashPair(computedHash, proof[i]);
172         }
173         return computedHash;
174     }
175 
176     /**
177      * @dev Calldata version of {processProof}
178      *
179      * _Available since v4.7._
180      */
181     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
182         bytes32 computedHash = leaf;
183         for (uint256 i = 0; i < proof.length; i++) {
184             computedHash = _hashPair(computedHash, proof[i]);
185         }
186         return computedHash;
187     }
188 
189     /**
190      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
191      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
192      *
193      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
194      *
195      * _Available since v4.7._
196      */
197     function multiProofVerify(
198         bytes32[] memory proof,
199         bool[] memory proofFlags,
200         bytes32 root,
201         bytes32[] memory leaves
202     ) internal pure returns (bool) {
203         return processMultiProof(proof, proofFlags, leaves) == root;
204     }
205 
206     /**
207      * @dev Calldata version of {multiProofVerify}
208      *
209      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
210      *
211      * _Available since v4.7._
212      */
213     function multiProofVerifyCalldata(
214         bytes32[] calldata proof,
215         bool[] calldata proofFlags,
216         bytes32 root,
217         bytes32[] memory leaves
218     ) internal pure returns (bool) {
219         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
220     }
221 
222     /**
223      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
224      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
225      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
226      * respectively.
227      *
228      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
229      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
230      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
231      *
232      * _Available since v4.7._
233      */
234     function processMultiProof(
235         bytes32[] memory proof,
236         bool[] memory proofFlags,
237         bytes32[] memory leaves
238     ) internal pure returns (bytes32 merkleRoot) {
239         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
240         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
241         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
242         // the merkle tree.
243         uint256 leavesLen = leaves.length;
244         uint256 totalHashes = proofFlags.length;
245 
246         // Check proof validity.
247         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
248 
249         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
250         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
251         bytes32[] memory hashes = new bytes32[](totalHashes);
252         uint256 leafPos = 0;
253         uint256 hashPos = 0;
254         uint256 proofPos = 0;
255         // At each step, we compute the next hash using two values:
256         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
257         //   get the next hash.
258         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
259         //   `proof` array.
260         for (uint256 i = 0; i < totalHashes; i++) {
261             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
262             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
263             hashes[i] = _hashPair(a, b);
264         }
265 
266         if (totalHashes > 0) {
267             return hashes[totalHashes - 1];
268         } else if (leavesLen > 0) {
269             return leaves[0];
270         } else {
271             return proof[0];
272         }
273     }
274 
275     /**
276      * @dev Calldata version of {processMultiProof}.
277      *
278      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
279      *
280      * _Available since v4.7._
281      */
282     function processMultiProofCalldata(
283         bytes32[] calldata proof,
284         bool[] calldata proofFlags,
285         bytes32[] memory leaves
286     ) internal pure returns (bytes32 merkleRoot) {
287         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
288         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
289         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
290         // the merkle tree.
291         uint256 leavesLen = leaves.length;
292         uint256 totalHashes = proofFlags.length;
293 
294         // Check proof validity.
295         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
296 
297         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
298         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
299         bytes32[] memory hashes = new bytes32[](totalHashes);
300         uint256 leafPos = 0;
301         uint256 hashPos = 0;
302         uint256 proofPos = 0;
303         // At each step, we compute the next hash using two values:
304         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
305         //   get the next hash.
306         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
307         //   `proof` array.
308         for (uint256 i = 0; i < totalHashes; i++) {
309             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
310             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
311             hashes[i] = _hashPair(a, b);
312         }
313 
314         if (totalHashes > 0) {
315             return hashes[totalHashes - 1];
316         } else if (leavesLen > 0) {
317             return leaves[0];
318         } else {
319             return proof[0];
320         }
321     }
322 
323     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
324         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
325     }
326 
327     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
328         /// @solidity memory-safe-assembly
329         assembly {
330             mstore(0x00, a)
331             mstore(0x20, b)
332             value := keccak256(0x00, 0x40)
333         }
334     }
335 }
336 
337 
338 // File erc721a/contracts/IERC721A.sol@v4.2.3
339 // ERC721A Contracts v4.2.3
340 // Creator: Chiru Labs
341 
342 pragma solidity ^0.8.4;
343 
344 /**
345  * @dev Interface of ERC721A.
346  */
347 interface IERC721A {
348     /**
349      * The caller must own the token or be an approved operator.
350      */
351     error ApprovalCallerNotOwnerNorApproved();
352 
353     /**
354      * The token does not exist.
355      */
356     error ApprovalQueryForNonexistentToken();
357 
358     /**
359      * Cannot query the balance for the zero address.
360      */
361     error BalanceQueryForZeroAddress();
362 
363     /**
364      * Cannot mint to the zero address.
365      */
366     error MintToZeroAddress();
367 
368     /**
369      * The quantity of tokens minted must be more than zero.
370      */
371     error MintZeroQuantity();
372 
373     /**
374      * The token does not exist.
375      */
376     error OwnerQueryForNonexistentToken();
377 
378     /**
379      * The caller must own the token or be an approved operator.
380      */
381     error TransferCallerNotOwnerNorApproved();
382 
383     /**
384      * The token must be owned by `from`.
385      */
386     error TransferFromIncorrectOwner();
387 
388     /**
389      * Cannot safely transfer to a contract that does not implement the
390      * ERC721Receiver interface.
391      */
392     error TransferToNonERC721ReceiverImplementer();
393 
394     /**
395      * Cannot transfer to the zero address.
396      */
397     error TransferToZeroAddress();
398 
399     /**
400      * The token does not exist.
401      */
402     error URIQueryForNonexistentToken();
403 
404     /**
405      * The `quantity` minted with ERC2309 exceeds the safety limit.
406      */
407     error MintERC2309QuantityExceedsLimit();
408 
409     /**
410      * The `extraData` cannot be set on an unintialized ownership slot.
411      */
412     error OwnershipNotInitializedForExtraData();
413 
414     // =============================================================
415     //                            STRUCTS
416     // =============================================================
417 
418     struct TokenOwnership {
419         // The address of the owner.
420         address addr;
421         // Stores the start time of ownership with minimal overhead for tokenomics.
422         uint64 startTimestamp;
423         // Whether the token has been burned.
424         bool burned;
425         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
426         uint24 extraData;
427     }
428 
429     // =============================================================
430     //                         TOKEN COUNTERS
431     // =============================================================
432 
433     /**
434      * @dev Returns the total number of tokens in existence.
435      * Burned tokens will reduce the count.
436      * To get the total number of tokens minted, please see {_totalMinted}.
437      */
438     function totalSupply() external view returns (uint256);
439 
440     // =============================================================
441     //                            IERC165
442     // =============================================================
443 
444     /**
445      * @dev Returns true if this contract implements the interface defined by
446      * `interfaceId`. See the corresponding
447      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
448      * to learn more about how these ids are created.
449      *
450      * This function call must use less than 30000 gas.
451      */
452     function supportsInterface(bytes4 interfaceId) external view returns (bool);
453 
454     // =============================================================
455     //                            IERC721
456     // =============================================================
457 
458     /**
459      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
460      */
461     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
465      */
466     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables or disables
470      * (`approved`) `operator` to manage all of its assets.
471      */
472     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
473 
474     /**
475      * @dev Returns the number of tokens in `owner`'s account.
476      */
477     function balanceOf(address owner) external view returns (uint256 balance);
478 
479     /**
480      * @dev Returns the owner of the `tokenId` token.
481      *
482      * Requirements:
483      *
484      * - `tokenId` must exist.
485      */
486     function ownerOf(uint256 tokenId) external view returns (address owner);
487 
488     /**
489      * @dev Safely transfers `tokenId` token from `from` to `to`,
490      * checking first that contract recipients are aware of the ERC721 protocol
491      * to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move
499      * this token by either {approve} or {setApprovalForAll}.
500      * - If `to` refers to a smart contract, it must implement
501      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
502      *
503      * Emits a {Transfer} event.
504      */
505     function safeTransferFrom(
506         address from,
507         address to,
508         uint256 tokenId,
509         bytes calldata data
510     ) external payable;
511 
512     /**
513      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external payable;
520 
521     /**
522      * @dev Transfers `tokenId` from `from` to `to`.
523      *
524      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
525      * whenever possible.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must be owned by `from`.
532      * - If the caller is not `from`, it must be approved to move this token
533      * by either {approve} or {setApprovalForAll}.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external payable;
542 
543     /**
544      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
545      * The approval is cleared when the token is transferred.
546      *
547      * Only a single account can be approved at a time, so approving the
548      * zero address clears previous approvals.
549      *
550      * Requirements:
551      *
552      * - The caller must own the token or be an approved operator.
553      * - `tokenId` must exist.
554      *
555      * Emits an {Approval} event.
556      */
557     function approve(address to, uint256 tokenId) external payable;
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom}
562      * for any token owned by the caller.
563      *
564      * Requirements:
565      *
566      * - The `operator` cannot be the caller.
567      *
568      * Emits an {ApprovalForAll} event.
569      */
570     function setApprovalForAll(address operator, bool _approved) external;
571 
572     /**
573      * @dev Returns the account approved for `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function getApproved(uint256 tokenId) external view returns (address operator);
580 
581     /**
582      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
583      *
584      * See {setApprovalForAll}.
585      */
586     function isApprovedForAll(address owner, address operator) external view returns (bool);
587 
588     // =============================================================
589     //                        IERC721Metadata
590     // =============================================================
591 
592     /**
593      * @dev Returns the token collection name.
594      */
595     function name() external view returns (string memory);
596 
597     /**
598      * @dev Returns the token collection symbol.
599      */
600     function symbol() external view returns (string memory);
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) external view returns (string memory);
606 
607     // =============================================================
608     //                           IERC2309
609     // =============================================================
610 
611     /**
612      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
613      * (inclusive) is transferred from `from` to `to`, as defined in the
614      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
615      *
616      * See {_mintERC2309} for more details.
617      */
618     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
619 }
620 
621 
622 // File erc721a/contracts/ERC721A.sol@v4.2.3
623 // ERC721A Contracts v4.2.3
624 // Creator: Chiru Labs
625 
626 pragma solidity ^0.8.4;
627 
628 /**
629  * @dev Interface of ERC721 token receiver.
630  */
631 interface ERC721A__IERC721Receiver {
632     function onERC721Received(
633         address operator,
634         address from,
635         uint256 tokenId,
636         bytes calldata data
637     ) external returns (bytes4);
638 }
639 
640 /**
641  * @title ERC721A
642  *
643  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
644  * Non-Fungible Token Standard, including the Metadata extension.
645  * Optimized for lower gas during batch mints.
646  *
647  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
648  * starting from `_startTokenId()`.
649  *
650  * Assumptions:
651  *
652  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
653  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
654  */
655 contract ERC721A is IERC721A {
656     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
657     struct TokenApprovalRef {
658         address value;
659     }
660 
661     // =============================================================
662     //                           CONSTANTS
663     // =============================================================
664 
665     // Mask of an entry in packed address data.
666     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
667 
668     // The bit position of `numberMinted` in packed address data.
669     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
670 
671     // The bit position of `numberBurned` in packed address data.
672     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
673 
674     // The bit position of `aux` in packed address data.
675     uint256 private constant _BITPOS_AUX = 192;
676 
677     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
678     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
679 
680     // The bit position of `startTimestamp` in packed ownership.
681     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
682 
683     // The bit mask of the `burned` bit in packed ownership.
684     uint256 private constant _BITMASK_BURNED = 1 << 224;
685 
686     // The bit position of the `nextInitialized` bit in packed ownership.
687     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
688 
689     // The bit mask of the `nextInitialized` bit in packed ownership.
690     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
691 
692     // The bit position of `extraData` in packed ownership.
693     uint256 private constant _BITPOS_EXTRA_DATA = 232;
694 
695     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
696     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
697 
698     // The mask of the lower 160 bits for addresses.
699     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
700 
701     // The maximum `quantity` that can be minted with {_mintERC2309}.
702     // This limit is to prevent overflows on the address data entries.
703     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
704     // is required to cause an overflow, which is unrealistic.
705     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
706 
707     // The `Transfer` event signature is given by:
708     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
709     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
710         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
711 
712     // =============================================================
713     //                            STORAGE
714     // =============================================================
715 
716     // The next token ID to be minted.
717     uint256 private _currentIndex;
718 
719     // The number of tokens burned.
720     uint256 private _burnCounter;
721 
722     // Token name
723     string private _name;
724 
725     // Token symbol
726     string private _symbol;
727 
728     // Mapping from token ID to ownership details
729     // An empty struct value does not necessarily mean the token is unowned.
730     // See {_packedOwnershipOf} implementation for details.
731     //
732     // Bits Layout:
733     // - [0..159]   `addr`
734     // - [160..223] `startTimestamp`
735     // - [224]      `burned`
736     // - [225]      `nextInitialized`
737     // - [232..255] `extraData`
738     mapping(uint256 => uint256) private _packedOwnerships;
739 
740     // Mapping owner address to address data.
741     //
742     // Bits Layout:
743     // - [0..63]    `balance`
744     // - [64..127]  `numberMinted`
745     // - [128..191] `numberBurned`
746     // - [192..255] `aux`
747     mapping(address => uint256) private _packedAddressData;
748 
749     // Mapping from token ID to approved address.
750     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     // =============================================================
756     //                          CONSTRUCTOR
757     // =============================================================
758 
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762         _currentIndex = _startTokenId();
763     }
764 
765     // =============================================================
766     //                   TOKEN COUNTING OPERATIONS
767     // =============================================================
768 
769     /**
770      * @dev Returns the starting token ID.
771      * To change the starting token ID, please override this function.
772      */
773     function _startTokenId() internal view virtual returns (uint256) {
774         return 0;
775     }
776 
777     /**
778      * @dev Returns the next token ID to be minted.
779      */
780     function _nextTokenId() internal view virtual returns (uint256) {
781         return _currentIndex;
782     }
783 
784     /**
785      * @dev Returns the total number of tokens in existence.
786      * Burned tokens will reduce the count.
787      * To get the total number of tokens minted, please see {_totalMinted}.
788      */
789     function totalSupply() public view virtual override returns (uint256) {
790         // Counter underflow is impossible as _burnCounter cannot be incremented
791         // more than `_currentIndex - _startTokenId()` times.
792         unchecked {
793             return _currentIndex - _burnCounter - _startTokenId();
794         }
795     }
796 
797     /**
798      * @dev Returns the total amount of tokens minted in the contract.
799      */
800     function _totalMinted() internal view virtual returns (uint256) {
801         // Counter underflow is impossible as `_currentIndex` does not decrement,
802         // and it is initialized to `_startTokenId()`.
803         unchecked {
804             return _currentIndex - _startTokenId();
805         }
806     }
807 
808     /**
809      * @dev Returns the total number of tokens burned.
810      */
811     function _totalBurned() internal view virtual returns (uint256) {
812         return _burnCounter;
813     }
814 
815     // =============================================================
816     //                    ADDRESS DATA OPERATIONS
817     // =============================================================
818 
819     /**
820      * @dev Returns the number of tokens in `owner`'s account.
821      */
822     function balanceOf(address owner) public view virtual override returns (uint256) {
823         if (owner == address(0)) revert BalanceQueryForZeroAddress();
824         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
825     }
826 
827     /**
828      * Returns the number of tokens minted by `owner`.
829      */
830     function _numberMinted(address owner) internal view returns (uint256) {
831         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
832     }
833 
834     /**
835      * Returns the number of tokens burned by or on behalf of `owner`.
836      */
837     function _numberBurned(address owner) internal view returns (uint256) {
838         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
839     }
840 
841     /**
842      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
843      */
844     function _getAux(address owner) internal view returns (uint64) {
845         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
846     }
847 
848     /**
849      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
850      * If there are multiple variables, please pack them into a uint64.
851      */
852     function _setAux(address owner, uint64 aux) internal virtual {
853         uint256 packed = _packedAddressData[owner];
854         uint256 auxCasted;
855         // Cast `aux` with assembly to avoid redundant masking.
856         assembly {
857             auxCasted := aux
858         }
859         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
860         _packedAddressData[owner] = packed;
861     }
862 
863     // =============================================================
864     //                            IERC165
865     // =============================================================
866 
867     /**
868      * @dev Returns true if this contract implements the interface defined by
869      * `interfaceId`. See the corresponding
870      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
871      * to learn more about how these ids are created.
872      *
873      * This function call must use less than 30000 gas.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
876         // The interface IDs are constants representing the first 4 bytes
877         // of the XOR of all function selectors in the interface.
878         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
879         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
880         return
881             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
882             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
883             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
884     }
885 
886     // =============================================================
887     //                        IERC721Metadata
888     // =============================================================
889 
890     /**
891      * @dev Returns the token collection name.
892      */
893     function name() public view virtual override returns (string memory) {
894         return _name;
895     }
896 
897     /**
898      * @dev Returns the token collection symbol.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
906      */
907     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
909 
910         string memory baseURI = _baseURI();
911         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
912     }
913 
914     /**
915      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917      * by default, it can be overridden in child contracts.
918      */
919     function _baseURI() internal view virtual returns (string memory) {
920         return '';
921     }
922 
923     // =============================================================
924     //                     OWNERSHIPS OPERATIONS
925     // =============================================================
926 
927     /**
928      * @dev Returns the owner of the `tokenId` token.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      */
934     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
935         return address(uint160(_packedOwnershipOf(tokenId)));
936     }
937 
938     /**
939      * @dev Gas spent here starts off proportional to the maximum mint batch size.
940      * It gradually moves to O(1) as tokens get transferred around over time.
941      */
942     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
943         return _unpackedOwnership(_packedOwnershipOf(tokenId));
944     }
945 
946     /**
947      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
948      */
949     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
950         return _unpackedOwnership(_packedOwnerships[index]);
951     }
952 
953     /**
954      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
955      */
956     function _initializeOwnershipAt(uint256 index) internal virtual {
957         if (_packedOwnerships[index] == 0) {
958             _packedOwnerships[index] = _packedOwnershipOf(index);
959         }
960     }
961 
962     /**
963      * Returns the packed ownership data of `tokenId`.
964      */
965     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
966         uint256 curr = tokenId;
967 
968         unchecked {
969             if (_startTokenId() <= curr)
970                 if (curr < _currentIndex) {
971                     uint256 packed = _packedOwnerships[curr];
972                     // If not burned.
973                     if (packed & _BITMASK_BURNED == 0) {
974                         // Invariant:
975                         // There will always be an initialized ownership slot
976                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
977                         // before an unintialized ownership slot
978                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
979                         // Hence, `curr` will not underflow.
980                         //
981                         // We can directly compare the packed value.
982                         // If the address is zero, packed will be zero.
983                         while (packed == 0) {
984                             packed = _packedOwnerships[--curr];
985                         }
986                         return packed;
987                     }
988                 }
989         }
990         revert OwnerQueryForNonexistentToken();
991     }
992 
993     /**
994      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
995      */
996     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
997         ownership.addr = address(uint160(packed));
998         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
999         ownership.burned = packed & _BITMASK_BURNED != 0;
1000         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1001     }
1002 
1003     /**
1004      * @dev Packs ownership data into a single uint256.
1005      */
1006     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1007         assembly {
1008             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1009             owner := and(owner, _BITMASK_ADDRESS)
1010             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1011             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1012         }
1013     }
1014 
1015     /**
1016      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1017      */
1018     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1019         // For branchless setting of the `nextInitialized` flag.
1020         assembly {
1021             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1022             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1023         }
1024     }
1025 
1026     // =============================================================
1027     //                      APPROVAL OPERATIONS
1028     // =============================================================
1029 
1030     /**
1031      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1032      * The approval is cleared when the token is transferred.
1033      *
1034      * Only a single account can be approved at a time, so approving the
1035      * zero address clears previous approvals.
1036      *
1037      * Requirements:
1038      *
1039      * - The caller must own the token or be an approved operator.
1040      * - `tokenId` must exist.
1041      *
1042      * Emits an {Approval} event.
1043      */
1044     function approve(address to, uint256 tokenId) public payable virtual override {
1045         address owner = ownerOf(tokenId);
1046 
1047         if (_msgSenderERC721A() != owner)
1048             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1049                 revert ApprovalCallerNotOwnerNorApproved();
1050             }
1051 
1052         _tokenApprovals[tokenId].value = to;
1053         emit Approval(owner, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Returns the account approved for `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1064         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1065 
1066         return _tokenApprovals[tokenId].value;
1067     }
1068 
1069     /**
1070      * @dev Approve or remove `operator` as an operator for the caller.
1071      * Operators can call {transferFrom} or {safeTransferFrom}
1072      * for any token owned by the caller.
1073      *
1074      * Requirements:
1075      *
1076      * - The `operator` cannot be the caller.
1077      *
1078      * Emits an {ApprovalForAll} event.
1079      */
1080     function setApprovalForAll(address operator, bool approved) public virtual override {
1081         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1082         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1087      *
1088      * See {setApprovalForAll}.
1089      */
1090     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1091         return _operatorApprovals[owner][operator];
1092     }
1093 
1094     /**
1095      * @dev Returns whether `tokenId` exists.
1096      *
1097      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1098      *
1099      * Tokens start existing when they are minted. See {_mint}.
1100      */
1101     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1102         return
1103             _startTokenId() <= tokenId &&
1104             tokenId < _currentIndex && // If within bounds,
1105             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1106     }
1107 
1108     /**
1109      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1110      */
1111     function _isSenderApprovedOrOwner(
1112         address approvedAddress,
1113         address owner,
1114         address msgSender
1115     ) private pure returns (bool result) {
1116         assembly {
1117             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1118             owner := and(owner, _BITMASK_ADDRESS)
1119             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1120             msgSender := and(msgSender, _BITMASK_ADDRESS)
1121             // `msgSender == owner || msgSender == approvedAddress`.
1122             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1128      */
1129     function _getApprovedSlotAndAddress(uint256 tokenId)
1130         private
1131         view
1132         returns (uint256 approvedAddressSlot, address approvedAddress)
1133     {
1134         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1135         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1136         assembly {
1137             approvedAddressSlot := tokenApproval.slot
1138             approvedAddress := sload(approvedAddressSlot)
1139         }
1140     }
1141 
1142     // =============================================================
1143     //                      TRANSFER OPERATIONS
1144     // =============================================================
1145 
1146     /**
1147      * @dev Transfers `tokenId` from `from` to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      * - `tokenId` token must be owned by `from`.
1154      * - If the caller is not `from`, it must be approved to move this token
1155      * by either {approve} or {setApprovalForAll}.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function transferFrom(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) public payable virtual override {
1164         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1165 
1166         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1167 
1168         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1169 
1170         // The nested ifs save around 20+ gas over a compound boolean condition.
1171         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1172             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1173 
1174         if (to == address(0)) revert TransferToZeroAddress();
1175 
1176         _beforeTokenTransfers(from, to, tokenId, 1);
1177 
1178         // Clear approvals from the previous owner.
1179         assembly {
1180             if approvedAddress {
1181                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1182                 sstore(approvedAddressSlot, 0)
1183             }
1184         }
1185 
1186         // Underflow of the sender's balance is impossible because we check for
1187         // ownership above and the recipient's balance can't realistically overflow.
1188         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1189         unchecked {
1190             // We can directly increment and decrement the balances.
1191             --_packedAddressData[from]; // Updates: `balance -= 1`.
1192             ++_packedAddressData[to]; // Updates: `balance += 1`.
1193 
1194             // Updates:
1195             // - `address` to the next owner.
1196             // - `startTimestamp` to the timestamp of transfering.
1197             // - `burned` to `false`.
1198             // - `nextInitialized` to `true`.
1199             _packedOwnerships[tokenId] = _packOwnershipData(
1200                 to,
1201                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1202             );
1203 
1204             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1205             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1206                 uint256 nextTokenId = tokenId + 1;
1207                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1208                 if (_packedOwnerships[nextTokenId] == 0) {
1209                     // If the next slot is within bounds.
1210                     if (nextTokenId != _currentIndex) {
1211                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1212                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1213                     }
1214                 }
1215             }
1216         }
1217 
1218         emit Transfer(from, to, tokenId);
1219         _afterTokenTransfers(from, to, tokenId, 1);
1220     }
1221 
1222     /**
1223      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public payable virtual override {
1230         safeTransferFrom(from, to, tokenId, '');
1231     }
1232 
1233     /**
1234      * @dev Safely transfers `tokenId` token from `from` to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must exist and be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token
1242      * by either {approve} or {setApprovalForAll}.
1243      * - If `to` refers to a smart contract, it must implement
1244      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function safeTransferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) public payable virtual override {
1254         transferFrom(from, to, tokenId);
1255         if (to.code.length != 0)
1256             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1257                 revert TransferToNonERC721ReceiverImplementer();
1258             }
1259     }
1260 
1261     /**
1262      * @dev Hook that is called before a set of serially-ordered token IDs
1263      * are about to be transferred. This includes minting.
1264      * And also called before burning one token.
1265      *
1266      * `startTokenId` - the first token ID to be transferred.
1267      * `quantity` - the amount to be transferred.
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, `tokenId` will be burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _beforeTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 
1284     /**
1285      * @dev Hook that is called after a set of serially-ordered token IDs
1286      * have been transferred. This includes minting.
1287      * And also called after one token has been burned.
1288      *
1289      * `startTokenId` - the first token ID to be transferred.
1290      * `quantity` - the amount to be transferred.
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` has been minted for `to`.
1297      * - When `to` is zero, `tokenId` has been burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _afterTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 
1307     /**
1308      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1309      *
1310      * `from` - Previous owner of the given token ID.
1311      * `to` - Target address that will receive the token.
1312      * `tokenId` - Token ID to be transferred.
1313      * `_data` - Optional data to send along with the call.
1314      *
1315      * Returns whether the call correctly returned the expected magic value.
1316      */
1317     function _checkContractOnERC721Received(
1318         address from,
1319         address to,
1320         uint256 tokenId,
1321         bytes memory _data
1322     ) private returns (bool) {
1323         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1324             bytes4 retval
1325         ) {
1326             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1327         } catch (bytes memory reason) {
1328             if (reason.length == 0) {
1329                 revert TransferToNonERC721ReceiverImplementer();
1330             } else {
1331                 assembly {
1332                     revert(add(32, reason), mload(reason))
1333                 }
1334             }
1335         }
1336     }
1337 
1338     // =============================================================
1339     //                        MINT OPERATIONS
1340     // =============================================================
1341 
1342     /**
1343      * @dev Mints `quantity` tokens and transfers them to `to`.
1344      *
1345      * Requirements:
1346      *
1347      * - `to` cannot be the zero address.
1348      * - `quantity` must be greater than 0.
1349      *
1350      * Emits a {Transfer} event for each mint.
1351      */
1352     function _mint(address to, uint256 quantity) internal virtual {
1353         uint256 startTokenId = _currentIndex;
1354         if (quantity == 0) revert MintZeroQuantity();
1355 
1356         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1357 
1358         // Overflows are incredibly unrealistic.
1359         // `balance` and `numberMinted` have a maximum limit of 2**64.
1360         // `tokenId` has a maximum limit of 2**256.
1361         unchecked {
1362             // Updates:
1363             // - `balance += quantity`.
1364             // - `numberMinted += quantity`.
1365             //
1366             // We can directly add to the `balance` and `numberMinted`.
1367             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1368 
1369             // Updates:
1370             // - `address` to the owner.
1371             // - `startTimestamp` to the timestamp of minting.
1372             // - `burned` to `false`.
1373             // - `nextInitialized` to `quantity == 1`.
1374             _packedOwnerships[startTokenId] = _packOwnershipData(
1375                 to,
1376                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1377             );
1378 
1379             uint256 toMasked;
1380             uint256 end = startTokenId + quantity;
1381 
1382             // Use assembly to loop and emit the `Transfer` event for gas savings.
1383             // The duplicated `log4` removes an extra check and reduces stack juggling.
1384             // The assembly, together with the surrounding Solidity code, have been
1385             // delicately arranged to nudge the compiler into producing optimized opcodes.
1386             assembly {
1387                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1388                 toMasked := and(to, _BITMASK_ADDRESS)
1389                 // Emit the `Transfer` event.
1390                 log4(
1391                     0, // Start of data (0, since no data).
1392                     0, // End of data (0, since no data).
1393                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1394                     0, // `address(0)`.
1395                     toMasked, // `to`.
1396                     startTokenId // `tokenId`.
1397                 )
1398 
1399                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1400                 // that overflows uint256 will make the loop run out of gas.
1401                 // The compiler will optimize the `iszero` away for performance.
1402                 for {
1403                     let tokenId := add(startTokenId, 1)
1404                 } iszero(eq(tokenId, end)) {
1405                     tokenId := add(tokenId, 1)
1406                 } {
1407                     // Emit the `Transfer` event. Similar to above.
1408                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1409                 }
1410             }
1411             if (toMasked == 0) revert MintToZeroAddress();
1412 
1413             _currentIndex = end;
1414         }
1415         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1416     }
1417 
1418     /**
1419      * @dev Mints `quantity` tokens and transfers them to `to`.
1420      *
1421      * This function is intended for efficient minting only during contract creation.
1422      *
1423      * It emits only one {ConsecutiveTransfer} as defined in
1424      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1425      * instead of a sequence of {Transfer} event(s).
1426      *
1427      * Calling this function outside of contract creation WILL make your contract
1428      * non-compliant with the ERC721 standard.
1429      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1430      * {ConsecutiveTransfer} event is only permissible during contract creation.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - `quantity` must be greater than 0.
1436      *
1437      * Emits a {ConsecutiveTransfer} event.
1438      */
1439     function _mintERC2309(address to, uint256 quantity) internal virtual {
1440         uint256 startTokenId = _currentIndex;
1441         if (to == address(0)) revert MintToZeroAddress();
1442         if (quantity == 0) revert MintZeroQuantity();
1443         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1444 
1445         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1446 
1447         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
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
1466             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1467 
1468             _currentIndex = startTokenId + quantity;
1469         }
1470         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1471     }
1472 
1473     /**
1474      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1475      *
1476      * Requirements:
1477      *
1478      * - If `to` refers to a smart contract, it must implement
1479      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1480      * - `quantity` must be greater than 0.
1481      *
1482      * See {_mint}.
1483      *
1484      * Emits a {Transfer} event for each mint.
1485      */
1486     function _safeMint(
1487         address to,
1488         uint256 quantity,
1489         bytes memory _data
1490     ) internal virtual {
1491         _mint(to, quantity);
1492 
1493         unchecked {
1494             if (to.code.length != 0) {
1495                 uint256 end = _currentIndex;
1496                 uint256 index = end - quantity;
1497                 do {
1498                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1499                         revert TransferToNonERC721ReceiverImplementer();
1500                     }
1501                 } while (index < end);
1502                 // Reentrancy protection.
1503                 if (_currentIndex != end) revert();
1504             }
1505         }
1506     }
1507 
1508     /**
1509      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1510      */
1511     function _safeMint(address to, uint256 quantity) internal virtual {
1512         _safeMint(to, quantity, '');
1513     }
1514 
1515     // =============================================================
1516     //                        BURN OPERATIONS
1517     // =============================================================
1518 
1519     /**
1520      * @dev Equivalent to `_burn(tokenId, false)`.
1521      */
1522     function _burn(uint256 tokenId) internal virtual {
1523         _burn(tokenId, false);
1524     }
1525 
1526     /**
1527      * @dev Destroys `tokenId`.
1528      * The approval is cleared when the token is burned.
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must exist.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1537         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1538 
1539         address from = address(uint160(prevOwnershipPacked));
1540 
1541         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1542 
1543         if (approvalCheck) {
1544             // The nested ifs save around 20+ gas over a compound boolean condition.
1545             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1546                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1547         }
1548 
1549         _beforeTokenTransfers(from, address(0), tokenId, 1);
1550 
1551         // Clear approvals from the previous owner.
1552         assembly {
1553             if approvedAddress {
1554                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1555                 sstore(approvedAddressSlot, 0)
1556             }
1557         }
1558 
1559         // Underflow of the sender's balance is impossible because we check for
1560         // ownership above and the recipient's balance can't realistically overflow.
1561         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1562         unchecked {
1563             // Updates:
1564             // - `balance -= 1`.
1565             // - `numberBurned += 1`.
1566             //
1567             // We can directly decrement the balance, and increment the number burned.
1568             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1569             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1570 
1571             // Updates:
1572             // - `address` to the last owner.
1573             // - `startTimestamp` to the timestamp of burning.
1574             // - `burned` to `true`.
1575             // - `nextInitialized` to `true`.
1576             _packedOwnerships[tokenId] = _packOwnershipData(
1577                 from,
1578                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1579             );
1580 
1581             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1582             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1583                 uint256 nextTokenId = tokenId + 1;
1584                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1585                 if (_packedOwnerships[nextTokenId] == 0) {
1586                     // If the next slot is within bounds.
1587                     if (nextTokenId != _currentIndex) {
1588                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1589                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1590                     }
1591                 }
1592             }
1593         }
1594 
1595         emit Transfer(from, address(0), tokenId);
1596         _afterTokenTransfers(from, address(0), tokenId, 1);
1597 
1598         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1599         unchecked {
1600             _burnCounter++;
1601         }
1602     }
1603 
1604     // =============================================================
1605     //                     EXTRA DATA OPERATIONS
1606     // =============================================================
1607 
1608     /**
1609      * @dev Directly sets the extra data for the ownership data `index`.
1610      */
1611     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1612         uint256 packed = _packedOwnerships[index];
1613         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1614         uint256 extraDataCasted;
1615         // Cast `extraData` with assembly to avoid redundant masking.
1616         assembly {
1617             extraDataCasted := extraData
1618         }
1619         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1620         _packedOwnerships[index] = packed;
1621     }
1622 
1623     /**
1624      * @dev Called during each token transfer to set the 24bit `extraData` field.
1625      * Intended to be overridden by the cosumer contract.
1626      *
1627      * `previousExtraData` - the value of `extraData` before transfer.
1628      *
1629      * Calling conditions:
1630      *
1631      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1632      * transferred to `to`.
1633      * - When `from` is zero, `tokenId` will be minted for `to`.
1634      * - When `to` is zero, `tokenId` will be burned by `from`.
1635      * - `from` and `to` are never both zero.
1636      */
1637     function _extraData(
1638         address from,
1639         address to,
1640         uint24 previousExtraData
1641     ) internal view virtual returns (uint24) {}
1642 
1643     /**
1644      * @dev Returns the next extra data for the packed ownership data.
1645      * The returned result is shifted into position.
1646      */
1647     function _nextExtraData(
1648         address from,
1649         address to,
1650         uint256 prevOwnershipPacked
1651     ) private view returns (uint256) {
1652         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1653         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1654     }
1655 
1656     // =============================================================
1657     //                       OTHER OPERATIONS
1658     // =============================================================
1659 
1660     /**
1661      * @dev Returns the message sender (defaults to `msg.sender`).
1662      *
1663      * If you are writing GSN compatible contracts, you need to override this function.
1664      */
1665     function _msgSenderERC721A() internal view virtual returns (address) {
1666         return msg.sender;
1667     }
1668 
1669     /**
1670      * @dev Converts a uint256 to its ASCII string decimal representation.
1671      */
1672     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1673         assembly {
1674             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1675             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1676             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1677             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1678             let m := add(mload(0x40), 0xa0)
1679             // Update the free memory pointer to allocate.
1680             mstore(0x40, m)
1681             // Assign the `str` to the end.
1682             str := sub(m, 0x20)
1683             // Zeroize the slot after the string.
1684             mstore(str, 0)
1685 
1686             // Cache the end of the memory to calculate the length later.
1687             let end := str
1688 
1689             // We write the string from rightmost digit to leftmost digit.
1690             // The following is essentially a do-while loop that also handles the zero case.
1691             // prettier-ignore
1692             for { let temp := value } 1 {} {
1693                 str := sub(str, 1)
1694                 // Write the character to the pointer.
1695                 // The ASCII index of the '0' character is 48.
1696                 mstore8(str, add(48, mod(temp, 10)))
1697                 // Keep dividing `temp` until zero.
1698                 temp := div(temp, 10)
1699                 // prettier-ignore
1700                 if iszero(temp) { break }
1701             }
1702 
1703             let length := sub(end, str)
1704             // Move the pointer 32 bytes leftwards to make room for the length.
1705             str := sub(str, 0x20)
1706             // Store the length.
1707             mstore(str, length)
1708         }
1709     }
1710 }
1711 
1712 
1713 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
1714 // ERC721A Contracts v4.2.3
1715 // Creator: Chiru Labs
1716 
1717 pragma solidity ^0.8.4;
1718 
1719 /**
1720  * @dev Interface of ERC721AQueryable.
1721  */
1722 interface IERC721AQueryable is IERC721A {
1723     /**
1724      * Invalid query range (`start` >= `stop`).
1725      */
1726     error InvalidQueryRange();
1727 
1728     /**
1729      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1730      *
1731      * If the `tokenId` is out of bounds:
1732      *
1733      * - `addr = address(0)`
1734      * - `startTimestamp = 0`
1735      * - `burned = false`
1736      * - `extraData = 0`
1737      *
1738      * If the `tokenId` is burned:
1739      *
1740      * - `addr = <Address of owner before token was burned>`
1741      * - `startTimestamp = <Timestamp when token was burned>`
1742      * - `burned = true`
1743      * - `extraData = <Extra data when token was burned>`
1744      *
1745      * Otherwise:
1746      *
1747      * - `addr = <Address of owner>`
1748      * - `startTimestamp = <Timestamp of start of ownership>`
1749      * - `burned = false`
1750      * - `extraData = <Extra data at start of ownership>`
1751      */
1752     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1753 
1754     /**
1755      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1756      * See {ERC721AQueryable-explicitOwnershipOf}
1757      */
1758     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1759 
1760     /**
1761      * @dev Returns an array of token IDs owned by `owner`,
1762      * in the range [`start`, `stop`)
1763      * (i.e. `start <= tokenId < stop`).
1764      *
1765      * This function allows for tokens to be queried if the collection
1766      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1767      *
1768      * Requirements:
1769      *
1770      * - `start < stop`
1771      */
1772     function tokensOfOwnerIn(
1773         address owner,
1774         uint256 start,
1775         uint256 stop
1776     ) external view returns (uint256[] memory);
1777 
1778     /**
1779      * @dev Returns an array of token IDs owned by `owner`.
1780      *
1781      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1782      * It is meant to be called off-chain.
1783      *
1784      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1785      * multiple smaller scans if the collection is large enough to cause
1786      * an out-of-gas error (10K collections should be fine).
1787      */
1788     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1789 }
1790 
1791 
1792 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
1793 // ERC721A Contracts v4.2.3
1794 // Creator: Chiru Labs
1795 
1796 pragma solidity ^0.8.4;
1797 
1798 
1799 /**
1800  * @title ERC721AQueryable.
1801  *
1802  * @dev ERC721A subclass with convenience query functions.
1803  */
1804 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1805     /**
1806      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1807      *
1808      * If the `tokenId` is out of bounds:
1809      *
1810      * - `addr = address(0)`
1811      * - `startTimestamp = 0`
1812      * - `burned = false`
1813      * - `extraData = 0`
1814      *
1815      * If the `tokenId` is burned:
1816      *
1817      * - `addr = <Address of owner before token was burned>`
1818      * - `startTimestamp = <Timestamp when token was burned>`
1819      * - `burned = true`
1820      * - `extraData = <Extra data when token was burned>`
1821      *
1822      * Otherwise:
1823      *
1824      * - `addr = <Address of owner>`
1825      * - `startTimestamp = <Timestamp of start of ownership>`
1826      * - `burned = false`
1827      * - `extraData = <Extra data at start of ownership>`
1828      */
1829     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1830         TokenOwnership memory ownership;
1831         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1832             return ownership;
1833         }
1834         ownership = _ownershipAt(tokenId);
1835         if (ownership.burned) {
1836             return ownership;
1837         }
1838         return _ownershipOf(tokenId);
1839     }
1840 
1841     /**
1842      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1843      * See {ERC721AQueryable-explicitOwnershipOf}
1844      */
1845     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1846         external
1847         view
1848         virtual
1849         override
1850         returns (TokenOwnership[] memory)
1851     {
1852         unchecked {
1853             uint256 tokenIdsLength = tokenIds.length;
1854             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1855             for (uint256 i; i != tokenIdsLength; ++i) {
1856                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1857             }
1858             return ownerships;
1859         }
1860     }
1861 
1862     /**
1863      * @dev Returns an array of token IDs owned by `owner`,
1864      * in the range [`start`, `stop`)
1865      * (i.e. `start <= tokenId < stop`).
1866      *
1867      * This function allows for tokens to be queried if the collection
1868      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1869      *
1870      * Requirements:
1871      *
1872      * - `start < stop`
1873      */
1874     function tokensOfOwnerIn(
1875         address owner,
1876         uint256 start,
1877         uint256 stop
1878     ) external view virtual override returns (uint256[] memory) {
1879         unchecked {
1880             if (start >= stop) revert InvalidQueryRange();
1881             uint256 tokenIdsIdx;
1882             uint256 stopLimit = _nextTokenId();
1883             // Set `start = max(start, _startTokenId())`.
1884             if (start < _startTokenId()) {
1885                 start = _startTokenId();
1886             }
1887             // Set `stop = min(stop, stopLimit)`.
1888             if (stop > stopLimit) {
1889                 stop = stopLimit;
1890             }
1891             uint256 tokenIdsMaxLength = balanceOf(owner);
1892             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1893             // to cater for cases where `balanceOf(owner)` is too big.
1894             if (start < stop) {
1895                 uint256 rangeLength = stop - start;
1896                 if (rangeLength < tokenIdsMaxLength) {
1897                     tokenIdsMaxLength = rangeLength;
1898                 }
1899             } else {
1900                 tokenIdsMaxLength = 0;
1901             }
1902             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1903             if (tokenIdsMaxLength == 0) {
1904                 return tokenIds;
1905             }
1906             // We need to call `explicitOwnershipOf(start)`,
1907             // because the slot at `start` may not be initialized.
1908             TokenOwnership memory ownership = explicitOwnershipOf(start);
1909             address currOwnershipAddr;
1910             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1911             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1912             if (!ownership.burned) {
1913                 currOwnershipAddr = ownership.addr;
1914             }
1915             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1916                 ownership = _ownershipAt(i);
1917                 if (ownership.burned) {
1918                     continue;
1919                 }
1920                 if (ownership.addr != address(0)) {
1921                     currOwnershipAddr = ownership.addr;
1922                 }
1923                 if (currOwnershipAddr == owner) {
1924                     tokenIds[tokenIdsIdx++] = i;
1925                 }
1926             }
1927             // Downsize the array to fit.
1928             assembly {
1929                 mstore(tokenIds, tokenIdsIdx)
1930             }
1931             return tokenIds;
1932         }
1933     }
1934 
1935     /**
1936      * @dev Returns an array of token IDs owned by `owner`.
1937      *
1938      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1939      * It is meant to be called off-chain.
1940      *
1941      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1942      * multiple smaller scans if the collection is large enough to cause
1943      * an out-of-gas error (10K collections should be fine).
1944      */
1945     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1946         unchecked {
1947             uint256 tokenIdsIdx;
1948             address currOwnershipAddr;
1949             uint256 tokenIdsLength = balanceOf(owner);
1950             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1951             TokenOwnership memory ownership;
1952             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1953                 ownership = _ownershipAt(i);
1954                 if (ownership.burned) {
1955                     continue;
1956                 }
1957                 if (ownership.addr != address(0)) {
1958                     currOwnershipAddr = ownership.addr;
1959                 }
1960                 if (currOwnershipAddr == owner) {
1961                     tokenIds[tokenIdsIdx++] = i;
1962                 }
1963             }
1964             return tokenIds;
1965         }
1966     }
1967 }
1968 
1969 
1970 // File contracts/Mars4Masks.sol
1971 pragma solidity ^0.8.17;
1972 
1973 
1974 
1975 contract Mars4Masks is ERC721AQueryable, Ownable {
1976     
1977     enum Stage {
1978         Closed,
1979         Whitelist,
1980         Public
1981     }
1982 
1983     uint256 public constant MAX_SUPPLY = 999;
1984     uint256 public price = 0;
1985     Stage public stage = Stage.Closed;
1986     string public baseTokenURI = 'https://mars4-masks.fra1.cdn.digitaloceanspaces.com/metadata/';
1987     string public contractURI = 'https://mars4-masks.fra1.cdn.digitaloceanspaces.com/metadata.json';
1988     bytes32 private merkleRoot;
1989 
1990     constructor() ERC721A("Mars4 Masks", "MarsMask") {}
1991 
1992     function setStage(Stage newStage, uint256 newPrice) external onlyOwner {
1993         stage = newStage;
1994         price = newPrice;
1995     }
1996 
1997     function getStage() public view returns (string memory) {
1998         if (stage == Stage.Closed) {
1999             return "Closed";
2000         } else if (stage == Stage.Whitelist) {
2001             return "Whitelist";
2002         } else {
2003             return "Public";
2004         }
2005     }
2006 
2007     function buy(uint256 amount) external payable {
2008         require(stage == Stage.Public, "Public sale is closed");
2009         require(totalSupply() + amount <= MAX_SUPPLY, "Insufficient token supply");
2010         require(msg.value >= amount * price, "Amount invalid");
2011         _mint(msg.sender, amount);
2012     }
2013 
2014     function buy(uint256 amount, bytes32[] memory proof) external payable {
2015         require(stage == Stage.Whitelist, "Whitelist sale is closed");
2016         require(totalSupply() + amount <= MAX_SUPPLY, "Insufficient token supply");
2017         require(merkleRoot != "", "Whitelist is empty");
2018         require(
2019             MerkleProof.verify(
2020                 proof,
2021                 merkleRoot,
2022                 keccak256(abi.encodePacked(msg.sender))
2023             ),
2024             "Invalid proof"
2025         );
2026         require(msg.value >= amount * price, "Amount invalid");
2027         _mint(msg.sender, amount);
2028     }    
2029 
2030     function mint(uint256 amount, address to) external onlyOwner {
2031         require(totalSupply() + amount <= MAX_SUPPLY, "Insufficient token supply");
2032         _safeMint(to, amount);
2033     }
2034 
2035     function withdraw() external onlyOwner {
2036         (bool success, ) = owner().call{ value: address(this).balance }("");
2037         require(success, "Failed to withdraw");
2038     }
2039 
2040     function _startTokenId() internal pure override returns (uint256) {
2041         return 1;
2042     }
2043 
2044     function _baseURI() internal view override returns (string memory) {
2045         return baseTokenURI;
2046     }
2047 
2048     function setMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
2049         merkleRoot = newMerkleRoot;
2050     }
2051 
2052     function setContractURI(string memory newUri) external onlyOwner {
2053         contractURI = newUri;
2054     }
2055 
2056     function setTokenURI(string memory newUri) external onlyOwner {
2057         baseTokenURI = newUri;
2058     }
2059 }