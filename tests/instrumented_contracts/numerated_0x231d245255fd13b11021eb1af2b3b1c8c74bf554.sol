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
332 // ERC721A Contracts v4.1.0
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 /**
338  * @dev Interface of an ERC721A compliant contract.
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
352      * The caller cannot approve to their own address.
353      */
354     error ApproveToCaller();
355 
356     /**
357      * Cannot query the balance for the zero address.
358      */
359     error BalanceQueryForZeroAddress();
360 
361     /**
362      * Cannot mint to the zero address.
363      */
364     error MintToZeroAddress();
365 
366     /**
367      * The quantity of tokens minted must be more than zero.
368      */
369     error MintZeroQuantity();
370 
371     /**
372      * The token does not exist.
373      */
374     error OwnerQueryForNonexistentToken();
375 
376     /**
377      * The caller must own the token or be an approved operator.
378      */
379     error TransferCallerNotOwnerNorApproved();
380 
381     /**
382      * The token must be owned by `from`.
383      */
384     error TransferFromIncorrectOwner();
385 
386     /**
387      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
388      */
389     error TransferToNonERC721ReceiverImplementer();
390 
391     /**
392      * Cannot transfer to the zero address.
393      */
394     error TransferToZeroAddress();
395 
396     /**
397      * The token does not exist.
398      */
399     error URIQueryForNonexistentToken();
400 
401     /**
402      * The `quantity` minted with ERC2309 exceeds the safety limit.
403      */
404     error MintERC2309QuantityExceedsLimit();
405 
406     /**
407      * The `extraData` cannot be set on an unintialized ownership slot.
408      */
409     error OwnershipNotInitializedForExtraData();
410 
411     struct TokenOwnership {
412         // The address of the owner.
413         address addr;
414         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
415         uint64 startTimestamp;
416         // Whether the token has been burned.
417         bool burned;
418         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
419         uint24 extraData;
420     }
421 
422     /**
423      * @dev Returns the total amount of tokens stored by the contract.
424      *
425      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
426      */
427     function totalSupply() external view returns (uint256);
428 
429     // ==============================
430     //            IERC165
431     // ==============================
432 
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 
443     // ==============================
444     //            IERC721
445     // ==============================
446 
447     /**
448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
451 
452     /**
453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
454      */
455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
459      */
460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
461 
462     /**
463      * @dev Returns the number of tokens in ``owner``'s account.
464      */
465     function balanceOf(address owner) external view returns (uint256 balance);
466 
467     /**
468      * @dev Returns the owner of the `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function ownerOf(uint256 tokenId) external view returns (address owner);
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`.
478      *
479      * Requirements:
480      *
481      * - `from` cannot be the zero address.
482      * - `to` cannot be the zero address.
483      * - `tokenId` token must exist and be owned by `from`.
484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486      *
487      * Emits a {Transfer} event.
488      */
489     function safeTransferFrom(
490         address from,
491         address to,
492         uint256 tokenId,
493         bytes calldata data
494     ) external;
495 
496     /**
497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
499      *
500      * Requirements:
501      *
502      * - `from` cannot be the zero address.
503      * - `to` cannot be the zero address.
504      * - `tokenId` token must exist and be owned by `from`.
505      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
507      *
508      * Emits a {Transfer} event.
509      */
510     function safeTransferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Transfers `tokenId` token from `from` to `to`.
518      *
519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
538      * The approval is cleared when the token is transferred.
539      *
540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
541      *
542      * Requirements:
543      *
544      * - The caller must own the token or be an approved operator.
545      * - `tokenId` must exist.
546      *
547      * Emits an {Approval} event.
548      */
549     function approve(address to, uint256 tokenId) external;
550 
551     /**
552      * @dev Approve or remove `operator` as an operator for the caller.
553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
554      *
555      * Requirements:
556      *
557      * - The `operator` cannot be the caller.
558      *
559      * Emits an {ApprovalForAll} event.
560      */
561     function setApprovalForAll(address operator, bool _approved) external;
562 
563     /**
564      * @dev Returns the account approved for `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function getApproved(uint256 tokenId) external view returns (address operator);
571 
572     /**
573      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
574      *
575      * See {setApprovalForAll}
576      */
577     function isApprovedForAll(address owner, address operator) external view returns (bool);
578 
579     // ==============================
580     //        IERC721Metadata
581     // ==============================
582 
583     /**
584      * @dev Returns the token collection name.
585      */
586     function name() external view returns (string memory);
587 
588     /**
589      * @dev Returns the token collection symbol.
590      */
591     function symbol() external view returns (string memory);
592 
593     /**
594      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
595      */
596     function tokenURI(uint256 tokenId) external view returns (string memory);
597 
598     // ==============================
599     //            IERC2309
600     // ==============================
601 
602     /**
603      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
604      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
605      */
606     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
607 }
608 
609 // File: erc721a/contracts/ERC721A.sol
610 
611 
612 // ERC721A Contracts v4.1.0
613 // Creator: Chiru Labs
614 
615 pragma solidity ^0.8.4;
616 
617 
618 /**
619  * @dev ERC721 token receiver interface.
620  */
621 interface ERC721A__IERC721Receiver {
622     function onERC721Received(
623         address operator,
624         address from,
625         uint256 tokenId,
626         bytes calldata data
627     ) external returns (bytes4);
628 }
629 
630 /**
631  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
632  * including the Metadata extension. Built to optimize for lower gas during batch mints.
633  *
634  * Assumes serials are sequentially minted starting at `_startTokenId()`
635  * (defaults to 0, e.g. 0, 1, 2, 3..).
636  *
637  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
638  *
639  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
640  */
641 contract ERC721A is IERC721A {
642     // Mask of an entry in packed address data.
643     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
644 
645     // The bit position of `numberMinted` in packed address data.
646     uint256 private constant BITPOS_NUMBER_MINTED = 64;
647 
648     // The bit position of `numberBurned` in packed address data.
649     uint256 private constant BITPOS_NUMBER_BURNED = 128;
650 
651     // The bit position of `aux` in packed address data.
652     uint256 private constant BITPOS_AUX = 192;
653 
654     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
655     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
656 
657     // The bit position of `startTimestamp` in packed ownership.
658     uint256 private constant BITPOS_START_TIMESTAMP = 160;
659 
660     // The bit mask of the `burned` bit in packed ownership.
661     uint256 private constant BITMASK_BURNED = 1 << 224;
662 
663     // The bit position of the `nextInitialized` bit in packed ownership.
664     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
665 
666     // The bit mask of the `nextInitialized` bit in packed ownership.
667     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
668 
669     // The bit position of `extraData` in packed ownership.
670     uint256 private constant BITPOS_EXTRA_DATA = 232;
671 
672     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
673     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
674 
675     // The mask of the lower 160 bits for addresses.
676     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
677 
678     // The maximum `quantity` that can be minted with `_mintERC2309`.
679     // This limit is to prevent overflows on the address data entries.
680     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
681     // is required to cause an overflow, which is unrealistic.
682     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
683 
684     // The tokenId of the next token to be minted.
685     uint256 private _currentIndex;
686 
687     // The number of tokens burned.
688     uint256 private _burnCounter;
689 
690     // Token name
691     string private _name;
692 
693     // Token symbol
694     string private _symbol;
695 
696     // Mapping from token ID to ownership details
697     // An empty struct value does not necessarily mean the token is unowned.
698     // See `_packedOwnershipOf` implementation for details.
699     //
700     // Bits Layout:
701     // - [0..159]   `addr`
702     // - [160..223] `startTimestamp`
703     // - [224]      `burned`
704     // - [225]      `nextInitialized`
705     // - [232..255] `extraData`
706     mapping(uint256 => uint256) private _packedOwnerships;
707 
708     // Mapping owner address to address data.
709     //
710     // Bits Layout:
711     // - [0..63]    `balance`
712     // - [64..127]  `numberMinted`
713     // - [128..191] `numberBurned`
714     // - [192..255] `aux`
715     mapping(address => uint256) private _packedAddressData;
716 
717     // Mapping from token ID to approved address.
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     constructor(string memory name_, string memory symbol_) {
724         _name = name_;
725         _symbol = symbol_;
726         _currentIndex = _startTokenId();
727     }
728 
729     /**
730      * @dev Returns the starting token ID.
731      * To change the starting token ID, please override this function.
732      */
733     function _startTokenId() internal view virtual returns (uint256) {
734         return 0;
735     }
736 
737     /**
738      * @dev Returns the next token ID to be minted.
739      */
740     function _nextTokenId() internal view returns (uint256) {
741         return _currentIndex;
742     }
743 
744     /**
745      * @dev Returns the total number of tokens in existence.
746      * Burned tokens will reduce the count.
747      * To get the total number of tokens minted, please see `_totalMinted`.
748      */
749     function totalSupply() public view override returns (uint256) {
750         // Counter underflow is impossible as _burnCounter cannot be incremented
751         // more than `_currentIndex - _startTokenId()` times.
752         unchecked {
753             return _currentIndex - _burnCounter - _startTokenId();
754         }
755     }
756 
757     /**
758      * @dev Returns the total amount of tokens minted in the contract.
759      */
760     function _totalMinted() internal view returns (uint256) {
761         // Counter underflow is impossible as _currentIndex does not decrement,
762         // and it is initialized to `_startTokenId()`
763         unchecked {
764             return _currentIndex - _startTokenId();
765         }
766     }
767 
768     /**
769      * @dev Returns the total number of tokens burned.
770      */
771     function _totalBurned() internal view returns (uint256) {
772         return _burnCounter;
773     }
774 
775     /**
776      * @dev See {IERC165-supportsInterface}.
777      */
778     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
779         // The interface IDs are constants representing the first 4 bytes of the XOR of
780         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
781         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
782         return
783             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
784             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
785             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) public view override returns (uint256) {
792         if (owner == address(0)) revert BalanceQueryForZeroAddress();
793         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
794     }
795 
796     /**
797      * Returns the number of tokens minted by `owner`.
798      */
799     function _numberMinted(address owner) internal view returns (uint256) {
800         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
801     }
802 
803     /**
804      * Returns the number of tokens burned by or on behalf of `owner`.
805      */
806     function _numberBurned(address owner) internal view returns (uint256) {
807         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
808     }
809 
810     /**
811      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
812      */
813     function _getAux(address owner) internal view returns (uint64) {
814         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
815     }
816 
817     /**
818      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
819      * If there are multiple variables, please pack them into a uint64.
820      */
821     function _setAux(address owner, uint64 aux) internal {
822         uint256 packed = _packedAddressData[owner];
823         uint256 auxCasted;
824         // Cast `aux` with assembly to avoid redundant masking.
825         assembly {
826             auxCasted := aux
827         }
828         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
829         _packedAddressData[owner] = packed;
830     }
831 
832     /**
833      * Returns the packed ownership data of `tokenId`.
834      */
835     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
836         uint256 curr = tokenId;
837 
838         unchecked {
839             if (_startTokenId() <= curr)
840                 if (curr < _currentIndex) {
841                     uint256 packed = _packedOwnerships[curr];
842                     // If not burned.
843                     if (packed & BITMASK_BURNED == 0) {
844                         // Invariant:
845                         // There will always be an ownership that has an address and is not burned
846                         // before an ownership that does not have an address and is not burned.
847                         // Hence, curr will not underflow.
848                         //
849                         // We can directly compare the packed value.
850                         // If the address is zero, packed is zero.
851                         while (packed == 0) {
852                             packed = _packedOwnerships[--curr];
853                         }
854                         return packed;
855                     }
856                 }
857         }
858         revert OwnerQueryForNonexistentToken();
859     }
860 
861     /**
862      * Returns the unpacked `TokenOwnership` struct from `packed`.
863      */
864     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
865         ownership.addr = address(uint160(packed));
866         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
867         ownership.burned = packed & BITMASK_BURNED != 0;
868         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
869     }
870 
871     /**
872      * Returns the unpacked `TokenOwnership` struct at `index`.
873      */
874     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
875         return _unpackedOwnership(_packedOwnerships[index]);
876     }
877 
878     /**
879      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
880      */
881     function _initializeOwnershipAt(uint256 index) internal {
882         if (_packedOwnerships[index] == 0) {
883             _packedOwnerships[index] = _packedOwnershipOf(index);
884         }
885     }
886 
887     /**
888      * Gas spent here starts off proportional to the maximum mint batch size.
889      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
890      */
891     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
892         return _unpackedOwnership(_packedOwnershipOf(tokenId));
893     }
894 
895     /**
896      * @dev Packs ownership data into a single uint256.
897      */
898     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
899         assembly {
900             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
901             owner := and(owner, BITMASK_ADDRESS)
902             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
903             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
904         }
905     }
906 
907     /**
908      * @dev See {IERC721-ownerOf}.
909      */
910     function ownerOf(uint256 tokenId) public view override returns (address) {
911         return address(uint160(_packedOwnershipOf(tokenId)));
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-name}.
916      */
917     function name() public view virtual override returns (string memory) {
918         return _name;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-symbol}.
923      */
924     function symbol() public view virtual override returns (string memory) {
925         return _symbol;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-tokenURI}.
930      */
931     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
932         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
933 
934         string memory baseURI = _baseURI();
935         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
936     }
937 
938     /**
939      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
940      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
941      * by default, it can be overridden in child contracts.
942      */
943     function _baseURI() internal view virtual returns (string memory) {
944         return '';
945     }
946 
947     /**
948      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
949      */
950     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
951         // For branchless setting of the `nextInitialized` flag.
952         assembly {
953             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
954             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
955         }
956     }
957 
958     /**
959      * @dev See {IERC721-approve}.
960      */
961     function approve(address to, uint256 tokenId) public override {
962         address owner = ownerOf(tokenId);
963 
964         if (_msgSenderERC721A() != owner)
965             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
966                 revert ApprovalCallerNotOwnerNorApproved();
967             }
968 
969         _tokenApprovals[tokenId] = to;
970         emit Approval(owner, to, tokenId);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view override returns (address) {
977         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public virtual override {
986         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
987 
988         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
989         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-safeTransferFrom}.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         safeTransferFrom(from, to, tokenId, '');
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) public virtual override {
1019         transferFrom(from, to, tokenId);
1020         if (to.code.length != 0)
1021             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1022                 revert TransferToNonERC721ReceiverImplementer();
1023             }
1024     }
1025 
1026     /**
1027      * @dev Returns whether `tokenId` exists.
1028      *
1029      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1030      *
1031      * Tokens start existing when they are minted (`_mint`),
1032      */
1033     function _exists(uint256 tokenId) internal view returns (bool) {
1034         return
1035             _startTokenId() <= tokenId &&
1036             tokenId < _currentIndex && // If within bounds,
1037             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1038     }
1039 
1040     /**
1041      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1042      */
1043     function _safeMint(address to, uint256 quantity) internal {
1044         _safeMint(to, quantity, '');
1045     }
1046 
1047     /**
1048      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - If `to` refers to a smart contract, it must implement
1053      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1054      * - `quantity` must be greater than 0.
1055      *
1056      * See {_mint}.
1057      *
1058      * Emits a {Transfer} event for each mint.
1059      */
1060     function _safeMint(
1061         address to,
1062         uint256 quantity,
1063         bytes memory _data
1064     ) internal {
1065         _mint(to, quantity);
1066 
1067         unchecked {
1068             if (to.code.length != 0) {
1069                 uint256 end = _currentIndex;
1070                 uint256 index = end - quantity;
1071                 do {
1072                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1073                         revert TransferToNonERC721ReceiverImplementer();
1074                     }
1075                 } while (index < end);
1076                 // Reentrancy protection.
1077                 if (_currentIndex != end) revert();
1078             }
1079         }
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event for each mint.
1091      */
1092     function _mint(address to, uint256 quantity) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // `balance` and `numberMinted` have a maximum limit of 2**64.
1101         // `tokenId` has a maximum limit of 2**256.
1102         unchecked {
1103             // Updates:
1104             // - `balance += quantity`.
1105             // - `numberMinted += quantity`.
1106             //
1107             // We can directly add to the `balance` and `numberMinted`.
1108             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1109 
1110             // Updates:
1111             // - `address` to the owner.
1112             // - `startTimestamp` to the timestamp of minting.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `quantity == 1`.
1115             _packedOwnerships[startTokenId] = _packOwnershipData(
1116                 to,
1117                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1118             );
1119 
1120             uint256 tokenId = startTokenId;
1121             uint256 end = startTokenId + quantity;
1122             do {
1123                 emit Transfer(address(0), to, tokenId++);
1124             } while (tokenId < end);
1125 
1126             _currentIndex = end;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * This function is intended for efficient minting only during contract creation.
1135      *
1136      * It emits only one {ConsecutiveTransfer} as defined in
1137      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1138      * instead of a sequence of {Transfer} event(s).
1139      *
1140      * Calling this function outside of contract creation WILL make your contract
1141      * non-compliant with the ERC721 standard.
1142      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1143      * {ConsecutiveTransfer} event is only permissible during contract creation.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {ConsecutiveTransfer} event.
1151      */
1152     function _mintERC2309(address to, uint256 quantity) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1157 
1158         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1159 
1160         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1161         unchecked {
1162             // Updates:
1163             // - `balance += quantity`.
1164             // - `numberMinted += quantity`.
1165             //
1166             // We can directly add to the `balance` and `numberMinted`.
1167             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1168 
1169             // Updates:
1170             // - `address` to the owner.
1171             // - `startTimestamp` to the timestamp of minting.
1172             // - `burned` to `false`.
1173             // - `nextInitialized` to `quantity == 1`.
1174             _packedOwnerships[startTokenId] = _packOwnershipData(
1175                 to,
1176                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1177             );
1178 
1179             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1180 
1181             _currentIndex = startTokenId + quantity;
1182         }
1183         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1184     }
1185 
1186     /**
1187      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1188      */
1189     function _getApprovedAddress(uint256 tokenId)
1190         private
1191         view
1192         returns (uint256 approvedAddressSlot, address approvedAddress)
1193     {
1194         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1195         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1196         assembly {
1197             // Compute the slot.
1198             mstore(0x00, tokenId)
1199             mstore(0x20, tokenApprovalsPtr.slot)
1200             approvedAddressSlot := keccak256(0x00, 0x40)
1201             // Load the slot's value from storage.
1202             approvedAddress := sload(approvedAddressSlot)
1203         }
1204     }
1205 
1206     /**
1207      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1208      */
1209     function _isOwnerOrApproved(
1210         address approvedAddress,
1211         address from,
1212         address msgSender
1213     ) private pure returns (bool result) {
1214         assembly {
1215             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1216             from := and(from, BITMASK_ADDRESS)
1217             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1218             msgSender := and(msgSender, BITMASK_ADDRESS)
1219             // `msgSender == from || msgSender == approvedAddress`.
1220             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1221         }
1222     }
1223 
1224     /**
1225      * @dev Transfers `tokenId` from `from` to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function transferFrom(
1235         address from,
1236         address to,
1237         uint256 tokenId
1238     ) public virtual override {
1239         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1240 
1241         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1242 
1243         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1244 
1245         // The nested ifs save around 20+ gas over a compound boolean condition.
1246         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1247             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1248 
1249         if (to == address(0)) revert TransferToZeroAddress();
1250 
1251         _beforeTokenTransfers(from, to, tokenId, 1);
1252 
1253         // Clear approvals from the previous owner.
1254         assembly {
1255             if approvedAddress {
1256                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1257                 sstore(approvedAddressSlot, 0)
1258             }
1259         }
1260 
1261         // Underflow of the sender's balance is impossible because we check for
1262         // ownership above and the recipient's balance can't realistically overflow.
1263         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1264         unchecked {
1265             // We can directly increment and decrement the balances.
1266             --_packedAddressData[from]; // Updates: `balance -= 1`.
1267             ++_packedAddressData[to]; // Updates: `balance += 1`.
1268 
1269             // Updates:
1270             // - `address` to the next owner.
1271             // - `startTimestamp` to the timestamp of transfering.
1272             // - `burned` to `false`.
1273             // - `nextInitialized` to `true`.
1274             _packedOwnerships[tokenId] = _packOwnershipData(
1275                 to,
1276                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1277             );
1278 
1279             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1280             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1281                 uint256 nextTokenId = tokenId + 1;
1282                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1283                 if (_packedOwnerships[nextTokenId] == 0) {
1284                     // If the next slot is within bounds.
1285                     if (nextTokenId != _currentIndex) {
1286                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1287                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1288                     }
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(from, to, tokenId);
1294         _afterTokenTransfers(from, to, tokenId, 1);
1295     }
1296 
1297     /**
1298      * @dev Equivalent to `_burn(tokenId, false)`.
1299      */
1300     function _burn(uint256 tokenId) internal virtual {
1301         _burn(tokenId, false);
1302     }
1303 
1304     /**
1305      * @dev Destroys `tokenId`.
1306      * The approval is cleared when the token is burned.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1315         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1316 
1317         address from = address(uint160(prevOwnershipPacked));
1318 
1319         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1320 
1321         if (approvalCheck) {
1322             // The nested ifs save around 20+ gas over a compound boolean condition.
1323             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1324                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1325         }
1326 
1327         _beforeTokenTransfers(from, address(0), tokenId, 1);
1328 
1329         // Clear approvals from the previous owner.
1330         assembly {
1331             if approvedAddress {
1332                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1333                 sstore(approvedAddressSlot, 0)
1334             }
1335         }
1336 
1337         // Underflow of the sender's balance is impossible because we check for
1338         // ownership above and the recipient's balance can't realistically overflow.
1339         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1340         unchecked {
1341             // Updates:
1342             // - `balance -= 1`.
1343             // - `numberBurned += 1`.
1344             //
1345             // We can directly decrement the balance, and increment the number burned.
1346             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1347             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1348 
1349             // Updates:
1350             // - `address` to the last owner.
1351             // - `startTimestamp` to the timestamp of burning.
1352             // - `burned` to `true`.
1353             // - `nextInitialized` to `true`.
1354             _packedOwnerships[tokenId] = _packOwnershipData(
1355                 from,
1356                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1357             );
1358 
1359             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1360             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1361                 uint256 nextTokenId = tokenId + 1;
1362                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1363                 if (_packedOwnerships[nextTokenId] == 0) {
1364                     // If the next slot is within bounds.
1365                     if (nextTokenId != _currentIndex) {
1366                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1367                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1368                     }
1369                 }
1370             }
1371         }
1372 
1373         emit Transfer(from, address(0), tokenId);
1374         _afterTokenTransfers(from, address(0), tokenId, 1);
1375 
1376         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1377         unchecked {
1378             _burnCounter++;
1379         }
1380     }
1381 
1382     /**
1383      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1384      *
1385      * @param from address representing the previous owner of the given token ID
1386      * @param to target address that will receive the tokens
1387      * @param tokenId uint256 ID of the token to be transferred
1388      * @param _data bytes optional data to send along with the call
1389      * @return bool whether the call correctly returned the expected magic value
1390      */
1391     function _checkContractOnERC721Received(
1392         address from,
1393         address to,
1394         uint256 tokenId,
1395         bytes memory _data
1396     ) private returns (bool) {
1397         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1398             bytes4 retval
1399         ) {
1400             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1401         } catch (bytes memory reason) {
1402             if (reason.length == 0) {
1403                 revert TransferToNonERC721ReceiverImplementer();
1404             } else {
1405                 assembly {
1406                     revert(add(32, reason), mload(reason))
1407                 }
1408             }
1409         }
1410     }
1411 
1412     /**
1413      * @dev Directly sets the extra data for the ownership data `index`.
1414      */
1415     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1416         uint256 packed = _packedOwnerships[index];
1417         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1418         uint256 extraDataCasted;
1419         // Cast `extraData` with assembly to avoid redundant masking.
1420         assembly {
1421             extraDataCasted := extraData
1422         }
1423         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1424         _packedOwnerships[index] = packed;
1425     }
1426 
1427     /**
1428      * @dev Returns the next extra data for the packed ownership data.
1429      * The returned result is shifted into position.
1430      */
1431     function _nextExtraData(
1432         address from,
1433         address to,
1434         uint256 prevOwnershipPacked
1435     ) private view returns (uint256) {
1436         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1437         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1438     }
1439 
1440     /**
1441      * @dev Called during each token transfer to set the 24bit `extraData` field.
1442      * Intended to be overridden by the cosumer contract.
1443      *
1444      * `previousExtraData` - the value of `extraData` before transfer.
1445      *
1446      * Calling conditions:
1447      *
1448      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1449      * transferred to `to`.
1450      * - When `from` is zero, `tokenId` will be minted for `to`.
1451      * - When `to` is zero, `tokenId` will be burned by `from`.
1452      * - `from` and `to` are never both zero.
1453      */
1454     function _extraData(
1455         address from,
1456         address to,
1457         uint24 previousExtraData
1458     ) internal view virtual returns (uint24) {}
1459 
1460     /**
1461      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1462      * This includes minting.
1463      * And also called before burning one token.
1464      *
1465      * startTokenId - the first token id to be transferred
1466      * quantity - the amount to be transferred
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` will be minted for `to`.
1473      * - When `to` is zero, `tokenId` will be burned by `from`.
1474      * - `from` and `to` are never both zero.
1475      */
1476     function _beforeTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 
1483     /**
1484      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1485      * This includes minting.
1486      * And also called after one token has been burned.
1487      *
1488      * startTokenId - the first token id to be transferred
1489      * quantity - the amount to be transferred
1490      *
1491      * Calling conditions:
1492      *
1493      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1494      * transferred to `to`.
1495      * - When `from` is zero, `tokenId` has been minted for `to`.
1496      * - When `to` is zero, `tokenId` has been burned by `from`.
1497      * - `from` and `to` are never both zero.
1498      */
1499     function _afterTokenTransfers(
1500         address from,
1501         address to,
1502         uint256 startTokenId,
1503         uint256 quantity
1504     ) internal virtual {}
1505 
1506     /**
1507      * @dev Returns the message sender (defaults to `msg.sender`).
1508      *
1509      * If you are writing GSN compatible contracts, you need to override this function.
1510      */
1511     function _msgSenderERC721A() internal view virtual returns (address) {
1512         return msg.sender;
1513     }
1514 
1515     /**
1516      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1517      */
1518     function _toString(uint256 value) internal pure returns (string memory ptr) {
1519         assembly {
1520             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1521             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1522             // We will need 1 32-byte word to store the length,
1523             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1524             ptr := add(mload(0x40), 128)
1525             // Update the free memory pointer to allocate.
1526             mstore(0x40, ptr)
1527 
1528             // Cache the end of the memory to calculate the length later.
1529             let end := ptr
1530 
1531             // We write the string from the rightmost digit to the leftmost digit.
1532             // The following is essentially a do-while loop that also handles the zero case.
1533             // Costs a bit more than early returning for the zero case,
1534             // but cheaper in terms of deployment and overall runtime costs.
1535             for {
1536                 // Initialize and perform the first pass without check.
1537                 let temp := value
1538                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1539                 ptr := sub(ptr, 1)
1540                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1541                 mstore8(ptr, add(48, mod(temp, 10)))
1542                 temp := div(temp, 10)
1543             } temp {
1544                 // Keep dividing `temp` until zero.
1545                 temp := div(temp, 10)
1546             } {
1547                 // Body of the for loop.
1548                 ptr := sub(ptr, 1)
1549                 mstore8(ptr, add(48, mod(temp, 10)))
1550             }
1551 
1552             let length := sub(end, ptr)
1553             // Move the pointer 32 bytes leftwards to make room for the length.
1554             ptr := sub(ptr, 32)
1555             // Store the length.
1556             mstore(ptr, length)
1557         }
1558     }
1559 }
1560 
1561 // File: ThePrimateExperiment.sol
1562 
1563 
1564 pragma solidity ^0.8.7;
1565 
1566 
1567 
1568 
1569 
1570 
1571 contract The_Primate_Experiment is ERC721A, Ownable {
1572     bool public flipMint;
1573     string public baseURI;  
1574     uint256 public price = 0;
1575     uint256 public primateSupply = 3000;
1576     uint256 public mintMax = 10;
1577 
1578     mapping (address => uint256) public walletPublic;
1579     mapping (address => bool) public minterAddress;
1580 
1581 
1582 
1583 
1584     constructor(string memory _baseUri) ERC721A("ThePrimateExperiment", "TPE") {baseURI = _baseUri; flipMint = false;}
1585 
1586 
1587     function _startTokenId() internal view virtual override returns (uint256) {
1588         return 1;
1589     }
1590 
1591     function mint(uint256 qty) external payable {
1592         // _safeMint's second argument now takes in a quantity, not a tokenId.
1593         require(flipMint , "Mint has not begun.");
1594         require(qty <= mintMax, "Reached Max!");
1595         require(totalSupply() + qty <= primateSupply,"Boxes Sold Out!");
1596         require(msg.value >= qty * price,"Missing ETH!");
1597         walletPublic[msg.sender] += qty;
1598         _safeMint(msg.sender, qty);
1599         
1600         
1601     }
1602 
1603     function mintForteam(uint256 qty) external payable onlyOwner {
1604         require(totalSupply() + qty <= primateSupply, "Not enough tokens left");
1605         _safeMint(msg.sender, qty);
1606     }
1607 
1608     function toggleSaleState() public onlyOwner{
1609         if(!flipMint){
1610             flipMint = true;
1611         }else{
1612             flipMint = false;
1613         }
1614     }
1615 
1616 
1617     function withdraw() external payable onlyOwner {
1618 
1619         payable(owner()).transfer(address(this).balance);
1620     }
1621 
1622     function _baseURI() internal view override returns (string memory) {
1623         return baseURI;
1624     }
1625 
1626  
1627     function newPrice(uint256 _newPrice) public onlyOwner {
1628         price = _newPrice;
1629     }
1630     function setBaseURI(string calldata _base) public onlyOwner {
1631         baseURI = _base;
1632     }
1633     function setMaxMints(uint256 _newMax) public onlyOwner {
1634         mintMax = _newMax;
1635 
1636     }
1637 
1638 }