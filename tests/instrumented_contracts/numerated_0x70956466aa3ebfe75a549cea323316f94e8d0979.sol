1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Tree proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  *
19  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
20  * hashing, or use a hash function other than keccak256 for hashing leaves.
21  * This is because the concatenation of a sorted pair of internal nodes in
22  * the merkle tree could be reinterpreted as a leaf value.
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(
32         bytes32[] memory proof,
33         bytes32 root,
34         bytes32 leaf
35     ) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Calldata version of {verify}
41      *
42      * _Available since v4.7._
43      */
44     function verifyCalldata(
45         bytes32[] calldata proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         return processProofCalldata(proof, leaf) == root;
50     }
51 
52     /**
53      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
54      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
55      * hash matches the root of the tree. When processing the proof, the pairs
56      * of leafs & pre-images are assumed to be sorted.
57      *
58      * _Available since v4.4._
59      */
60     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             computedHash = _hashPair(computedHash, proof[i]);
64         }
65         return computedHash;
66     }
67 
68     /**
69      * @dev Calldata version of {processProof}
70      *
71      * _Available since v4.7._
72      */
73     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
74         bytes32 computedHash = leaf;
75         for (uint256 i = 0; i < proof.length; i++) {
76             computedHash = _hashPair(computedHash, proof[i]);
77         }
78         return computedHash;
79     }
80 
81     /**
82      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
83      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * _Available since v4.7._
100      */
101     function multiProofVerifyCalldata(
102         bytes32[] calldata proof,
103         bool[] calldata proofFlags,
104         bytes32 root,
105         bytes32[] memory leaves
106     ) internal pure returns (bool) {
107         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
108     }
109 
110     /**
111      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
112      * consuming from one or the other at each step according to the instructions given by
113      * `proofFlags`.
114      *
115      * _Available since v4.7._
116      */
117     function processMultiProof(
118         bytes32[] memory proof,
119         bool[] memory proofFlags,
120         bytes32[] memory leaves
121     ) internal pure returns (bytes32 merkleRoot) {
122         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
123         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
124         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
125         // the merkle tree.
126         uint256 leavesLen = leaves.length;
127         uint256 totalHashes = proofFlags.length;
128 
129         // Check proof validity.
130         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
131 
132         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
133         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
134         bytes32[] memory hashes = new bytes32[](totalHashes);
135         uint256 leafPos = 0;
136         uint256 hashPos = 0;
137         uint256 proofPos = 0;
138         // At each step, we compute the next hash using two values:
139         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
140         //   get the next hash.
141         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
142         //   `proof` array.
143         for (uint256 i = 0; i < totalHashes; i++) {
144             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
145             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
146             hashes[i] = _hashPair(a, b);
147         }
148 
149         if (totalHashes > 0) {
150             return hashes[totalHashes - 1];
151         } else if (leavesLen > 0) {
152             return leaves[0];
153         } else {
154             return proof[0];
155         }
156     }
157 
158     /**
159      * @dev Calldata version of {processMultiProof}
160      *
161      * _Available since v4.7._
162      */
163     function processMultiProofCalldata(
164         bytes32[] calldata proof,
165         bool[] calldata proofFlags,
166         bytes32[] memory leaves
167     ) internal pure returns (bytes32 merkleRoot) {
168         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
169         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
170         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
171         // the merkle tree.
172         uint256 leavesLen = leaves.length;
173         uint256 totalHashes = proofFlags.length;
174 
175         // Check proof validity.
176         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
177 
178         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
179         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
180         bytes32[] memory hashes = new bytes32[](totalHashes);
181         uint256 leafPos = 0;
182         uint256 hashPos = 0;
183         uint256 proofPos = 0;
184         // At each step, we compute the next hash using two values:
185         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
186         //   get the next hash.
187         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
188         //   `proof` array.
189         for (uint256 i = 0; i < totalHashes; i++) {
190             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
191             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
192             hashes[i] = _hashPair(a, b);
193         }
194 
195         if (totalHashes > 0) {
196             return hashes[totalHashes - 1];
197         } else if (leavesLen > 0) {
198             return leaves[0];
199         } else {
200             return proof[0];
201         }
202     }
203 
204     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
205         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
206     }
207 
208     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
209         /// @solidity memory-safe-assembly
210         assembly {
211             mstore(0x00, a)
212             mstore(0x20, b)
213             value := keccak256(0x00, 0x40)
214         }
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 
221 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes calldata) {
241         return msg.data;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/access/Ownable.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 
253 /**
254  * @dev Contract module which provides a basic access control mechanism, where
255  * there is an account (an owner) that can be granted exclusive access to
256  * specific functions.
257  *
258  * By default, the owner account will be the one that deploys the contract. This
259  * can later be changed with {transferOwnership}.
260  *
261  * This module is used through inheritance. It will make available the modifier
262  * `onlyOwner`, which can be applied to your functions to restrict their use to
263  * the owner.
264  */
265 abstract contract Ownable is Context {
266     address private _owner;
267 
268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
269 
270     /**
271      * @dev Initializes the contract setting the deployer as the initial owner.
272      */
273     constructor() {
274         _transferOwnership(_msgSender());
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         _checkOwner();
282         _;
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view virtual returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if the sender is not the owner.
294      */
295     function _checkOwner() internal view virtual {
296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         _transferOwnership(address(0));
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      * Can only be called by the current owner.
313      */
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         _transferOwnership(newOwner);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Internal function without access restriction.
322      */
323     function _transferOwnership(address newOwner) internal virtual {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 // File: erc721a/contracts/IERC721A.sol
331 
332 
333 // ERC721A Contracts v4.1.0
334 // Creator: Chiru Labs
335 
336 pragma solidity ^0.8.4;
337 
338 /**
339  * @dev Interface of an ERC721A compliant contract.
340  */
341 interface IERC721A {
342     /**
343      * The caller must own the token or be an approved operator.
344      */
345     error ApprovalCallerNotOwnerNorApproved();
346 
347     /**
348      * The token does not exist.
349      */
350     error ApprovalQueryForNonexistentToken();
351 
352     /**
353      * The caller cannot approve to their own address.
354      */
355     error ApproveToCaller();
356 
357     /**
358      * Cannot query the balance for the zero address.
359      */
360     error BalanceQueryForZeroAddress();
361 
362     /**
363      * Cannot mint to the zero address.
364      */
365     error MintToZeroAddress();
366 
367     /**
368      * The quantity of tokens minted must be more than zero.
369      */
370     error MintZeroQuantity();
371 
372     /**
373      * The token does not exist.
374      */
375     error OwnerQueryForNonexistentToken();
376 
377     /**
378      * The caller must own the token or be an approved operator.
379      */
380     error TransferCallerNotOwnerNorApproved();
381 
382     /**
383      * The token must be owned by `from`.
384      */
385     error TransferFromIncorrectOwner();
386 
387     /**
388      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
389      */
390     error TransferToNonERC721ReceiverImplementer();
391 
392     /**
393      * Cannot transfer to the zero address.
394      */
395     error TransferToZeroAddress();
396 
397     /**
398      * The token does not exist.
399      */
400     error URIQueryForNonexistentToken();
401 
402     /**
403      * The `quantity` minted with ERC2309 exceeds the safety limit.
404      */
405     error MintERC2309QuantityExceedsLimit();
406 
407     /**
408      * The `extraData` cannot be set on an unintialized ownership slot.
409      */
410     error OwnershipNotInitializedForExtraData();
411 
412     struct TokenOwnership {
413         // The address of the owner.
414         address addr;
415         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
416         uint64 startTimestamp;
417         // Whether the token has been burned.
418         bool burned;
419         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
420         uint24 extraData;
421     }
422 
423     /**
424      * @dev Returns the total amount of tokens stored by the contract.
425      *
426      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
427      */
428     function totalSupply() external view returns (uint256);
429 
430     // ==============================
431     //            IERC165
432     // ==============================
433 
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 
444     // ==============================
445     //            IERC721
446     // ==============================
447 
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId,
494         bytes calldata data
495     ) external;
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Transfers `tokenId` token from `from` to `to`.
519      *
520      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      *
529      * Emits a {Transfer} event.
530      */
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
539      * The approval is cleared when the token is transferred.
540      *
541      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external;
551 
552     /**
553      * @dev Approve or remove `operator` as an operator for the caller.
554      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
555      *
556      * Requirements:
557      *
558      * - The `operator` cannot be the caller.
559      *
560      * Emits an {ApprovalForAll} event.
561      */
562     function setApprovalForAll(address operator, bool _approved) external;
563 
564     /**
565      * @dev Returns the account approved for `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function getApproved(uint256 tokenId) external view returns (address operator);
572 
573     /**
574      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
575      *
576      * See {setApprovalForAll}
577      */
578     function isApprovedForAll(address owner, address operator) external view returns (bool);
579 
580     // ==============================
581     //        IERC721Metadata
582     // ==============================
583 
584     /**
585      * @dev Returns the token collection name.
586      */
587     function name() external view returns (string memory);
588 
589     /**
590      * @dev Returns the token collection symbol.
591      */
592     function symbol() external view returns (string memory);
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) external view returns (string memory);
598 
599     // ==============================
600     //            IERC2309
601     // ==============================
602 
603     /**
604      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
605      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
606      */
607     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
608 }
609 
610 // File: erc721a/contracts/ERC721A.sol
611 
612 
613 // ERC721A Contracts v4.1.0
614 // Creator: Chiru Labs
615 
616 pragma solidity ^0.8.4;
617 
618 
619 /**
620  * @dev ERC721 token receiver interface.
621  */
622 interface ERC721A__IERC721Receiver {
623     function onERC721Received(
624         address operator,
625         address from,
626         uint256 tokenId,
627         bytes calldata data
628     ) external returns (bytes4);
629 }
630 
631 /**
632  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
633  * including the Metadata extension. Built to optimize for lower gas during batch mints.
634  *
635  * Assumes serials are sequentially minted starting at `_startTokenId()`
636  * (defaults to 0, e.g. 0, 1, 2, 3..).
637  *
638  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
639  *
640  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
641  */
642 contract ERC721A is IERC721A {
643     // Mask of an entry in packed address data.
644     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
645 
646     // The bit position of `numberMinted` in packed address data.
647     uint256 private constant BITPOS_NUMBER_MINTED = 64;
648 
649     // The bit position of `numberBurned` in packed address data.
650     uint256 private constant BITPOS_NUMBER_BURNED = 128;
651 
652     // The bit position of `aux` in packed address data.
653     uint256 private constant BITPOS_AUX = 192;
654 
655     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
656     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
657 
658     // The bit position of `startTimestamp` in packed ownership.
659     uint256 private constant BITPOS_START_TIMESTAMP = 160;
660 
661     // The bit mask of the `burned` bit in packed ownership.
662     uint256 private constant BITMASK_BURNED = 1 << 224;
663 
664     // The bit position of the `nextInitialized` bit in packed ownership.
665     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
666 
667     // The bit mask of the `nextInitialized` bit in packed ownership.
668     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
669 
670     // The bit position of `extraData` in packed ownership.
671     uint256 private constant BITPOS_EXTRA_DATA = 232;
672 
673     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
674     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
675 
676     // The mask of the lower 160 bits for addresses.
677     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
678 
679     // The maximum `quantity` that can be minted with `_mintERC2309`.
680     // This limit is to prevent overflows on the address data entries.
681     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
682     // is required to cause an overflow, which is unrealistic.
683     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
684 
685     // The tokenId of the next token to be minted.
686     uint256 private _currentIndex;
687 
688     // The number of tokens burned.
689     uint256 private _burnCounter;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to ownership details
698     // An empty struct value does not necessarily mean the token is unowned.
699     // See `_packedOwnershipOf` implementation for details.
700     //
701     // Bits Layout:
702     // - [0..159]   `addr`
703     // - [160..223] `startTimestamp`
704     // - [224]      `burned`
705     // - [225]      `nextInitialized`
706     // - [232..255] `extraData`
707     mapping(uint256 => uint256) private _packedOwnerships;
708 
709     // Mapping owner address to address data.
710     //
711     // Bits Layout:
712     // - [0..63]    `balance`
713     // - [64..127]  `numberMinted`
714     // - [128..191] `numberBurned`
715     // - [192..255] `aux`
716     mapping(address => uint256) private _packedAddressData;
717 
718     // Mapping from token ID to approved address.
719     mapping(uint256 => address) private _tokenApprovals;
720 
721     // Mapping from owner to operator approvals
722     mapping(address => mapping(address => bool)) private _operatorApprovals;
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727         _currentIndex = _startTokenId();
728     }
729 
730     /**
731      * @dev Returns the starting token ID.
732      * To change the starting token ID, please override this function.
733      */
734     function _startTokenId() internal view virtual returns (uint256) {
735         return 0;
736     }
737 
738     /**
739      * @dev Returns the next token ID to be minted.
740      */
741     function _nextTokenId() internal view returns (uint256) {
742         return _currentIndex;
743     }
744 
745     /**
746      * @dev Returns the total number of tokens in existence.
747      * Burned tokens will reduce the count.
748      * To get the total number of tokens minted, please see `_totalMinted`.
749      */
750     function totalSupply() public view override returns (uint256) {
751         // Counter underflow is impossible as _burnCounter cannot be incremented
752         // more than `_currentIndex - _startTokenId()` times.
753         unchecked {
754             return _currentIndex - _burnCounter - _startTokenId();
755         }
756     }
757 
758     /**
759      * @dev Returns the total amount of tokens minted in the contract.
760      */
761     function _totalMinted() internal view returns (uint256) {
762         // Counter underflow is impossible as _currentIndex does not decrement,
763         // and it is initialized to `_startTokenId()`
764         unchecked {
765             return _currentIndex - _startTokenId();
766         }
767     }
768 
769     /**
770      * @dev Returns the total number of tokens burned.
771      */
772     function _totalBurned() internal view returns (uint256) {
773         return _burnCounter;
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
780         // The interface IDs are constants representing the first 4 bytes of the XOR of
781         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
782         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
783         return
784             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
785             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
786             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
787     }
788 
789     /**
790      * @dev See {IERC721-balanceOf}.
791      */
792     function balanceOf(address owner) public view override returns (uint256) {
793         if (owner == address(0)) revert BalanceQueryForZeroAddress();
794         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
795     }
796 
797     /**
798      * Returns the number of tokens minted by `owner`.
799      */
800     function _numberMinted(address owner) internal view returns (uint256) {
801         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
802     }
803 
804     /**
805      * Returns the number of tokens burned by or on behalf of `owner`.
806      */
807     function _numberBurned(address owner) internal view returns (uint256) {
808         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
809     }
810 
811     /**
812      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
813      */
814     function _getAux(address owner) internal view returns (uint64) {
815         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
816     }
817 
818     /**
819      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
820      * If there are multiple variables, please pack them into a uint64.
821      */
822     function _setAux(address owner, uint64 aux) internal {
823         uint256 packed = _packedAddressData[owner];
824         uint256 auxCasted;
825         // Cast `aux` with assembly to avoid redundant masking.
826         assembly {
827             auxCasted := aux
828         }
829         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
830         _packedAddressData[owner] = packed;
831     }
832 
833     /**
834      * Returns the packed ownership data of `tokenId`.
835      */
836     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
837         uint256 curr = tokenId;
838 
839         unchecked {
840             if (_startTokenId() <= curr)
841                 if (curr < _currentIndex) {
842                     uint256 packed = _packedOwnerships[curr];
843                     // If not burned.
844                     if (packed & BITMASK_BURNED == 0) {
845                         // Invariant:
846                         // There will always be an ownership that has an address and is not burned
847                         // before an ownership that does not have an address and is not burned.
848                         // Hence, curr will not underflow.
849                         //
850                         // We can directly compare the packed value.
851                         // If the address is zero, packed is zero.
852                         while (packed == 0) {
853                             packed = _packedOwnerships[--curr];
854                         }
855                         return packed;
856                     }
857                 }
858         }
859         revert OwnerQueryForNonexistentToken();
860     }
861 
862     /**
863      * Returns the unpacked `TokenOwnership` struct from `packed`.
864      */
865     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
866         ownership.addr = address(uint160(packed));
867         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
868         ownership.burned = packed & BITMASK_BURNED != 0;
869         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
870     }
871 
872     /**
873      * Returns the unpacked `TokenOwnership` struct at `index`.
874      */
875     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
876         return _unpackedOwnership(_packedOwnerships[index]);
877     }
878 
879     /**
880      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
881      */
882     function _initializeOwnershipAt(uint256 index) internal {
883         if (_packedOwnerships[index] == 0) {
884             _packedOwnerships[index] = _packedOwnershipOf(index);
885         }
886     }
887 
888     /**
889      * Gas spent here starts off proportional to the maximum mint batch size.
890      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
891      */
892     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
893         return _unpackedOwnership(_packedOwnershipOf(tokenId));
894     }
895 
896     /**
897      * @dev Packs ownership data into a single uint256.
898      */
899     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
900         assembly {
901             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
902             owner := and(owner, BITMASK_ADDRESS)
903             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
904             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
905         }
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view override returns (address) {
912         return address(uint160(_packedOwnershipOf(tokenId)));
913     }
914 
915     /**
916      * @dev See {IERC721Metadata-name}.
917      */
918     function name() public view virtual override returns (string memory) {
919         return _name;
920     }
921 
922     /**
923      * @dev See {IERC721Metadata-symbol}.
924      */
925     function symbol() public view virtual override returns (string memory) {
926         return _symbol;
927     }
928 
929     /**
930      * @dev See {IERC721Metadata-tokenURI}.
931      */
932     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
933         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
934 
935         string memory baseURI = _baseURI();
936         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
937     }
938 
939     /**
940      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
941      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
942      * by default, it can be overridden in child contracts.
943      */
944     function _baseURI() internal view virtual returns (string memory) {
945         return '';
946     }
947 
948     /**
949      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
950      */
951     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
952         // For branchless setting of the `nextInitialized` flag.
953         assembly {
954             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
955             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
956         }
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public override {
963         address owner = ownerOf(tokenId);
964 
965         if (_msgSenderERC721A() != owner)
966             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
967                 revert ApprovalCallerNotOwnerNorApproved();
968             }
969 
970         _tokenApprovals[tokenId] = to;
971         emit Approval(owner, to, tokenId);
972     }
973 
974     /**
975      * @dev See {IERC721-getApproved}.
976      */
977     function getApproved(uint256 tokenId) public view override returns (address) {
978         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved) public virtual override {
987         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
988 
989         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
990         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
991     }
992 
993     /**
994      * @dev See {IERC721-isApprovedForAll}.
995      */
996     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
997         return _operatorApprovals[owner][operator];
998     }
999 
1000     /**
1001      * @dev See {IERC721-safeTransferFrom}.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) public virtual override {
1008         safeTransferFrom(from, to, tokenId, '');
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) public virtual override {
1020         transferFrom(from, to, tokenId);
1021         if (to.code.length != 0)
1022             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1023                 revert TransferToNonERC721ReceiverImplementer();
1024             }
1025     }
1026 
1027     /**
1028      * @dev Returns whether `tokenId` exists.
1029      *
1030      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1031      *
1032      * Tokens start existing when they are minted (`_mint`),
1033      */
1034     function _exists(uint256 tokenId) internal view returns (bool) {
1035         return
1036             _startTokenId() <= tokenId &&
1037             tokenId < _currentIndex && // If within bounds,
1038             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1039     }
1040 
1041     /**
1042      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1043      */
1044     function _safeMint(address to, uint256 quantity) internal {
1045         _safeMint(to, quantity, '');
1046     }
1047 
1048     /**
1049      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1050      *
1051      * Requirements:
1052      *
1053      * - If `to` refers to a smart contract, it must implement
1054      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1055      * - `quantity` must be greater than 0.
1056      *
1057      * See {_mint}.
1058      *
1059      * Emits a {Transfer} event for each mint.
1060      */
1061     function _safeMint(
1062         address to,
1063         uint256 quantity,
1064         bytes memory _data
1065     ) internal {
1066         _mint(to, quantity);
1067 
1068         unchecked {
1069             if (to.code.length != 0) {
1070                 uint256 end = _currentIndex;
1071                 uint256 index = end - quantity;
1072                 do {
1073                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1074                         revert TransferToNonERC721ReceiverImplementer();
1075                     }
1076                 } while (index < end);
1077                 // Reentrancy protection.
1078                 if (_currentIndex != end) revert();
1079             }
1080         }
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event for each mint.
1092      */
1093     function _mint(address to, uint256 quantity) internal {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) revert MintToZeroAddress();
1096         if (quantity == 0) revert MintZeroQuantity();
1097 
1098         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1099 
1100         // Overflows are incredibly unrealistic.
1101         // `balance` and `numberMinted` have a maximum limit of 2**64.
1102         // `tokenId` has a maximum limit of 2**256.
1103         unchecked {
1104             // Updates:
1105             // - `balance += quantity`.
1106             // - `numberMinted += quantity`.
1107             //
1108             // We can directly add to the `balance` and `numberMinted`.
1109             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1110 
1111             // Updates:
1112             // - `address` to the owner.
1113             // - `startTimestamp` to the timestamp of minting.
1114             // - `burned` to `false`.
1115             // - `nextInitialized` to `quantity == 1`.
1116             _packedOwnerships[startTokenId] = _packOwnershipData(
1117                 to,
1118                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1119             );
1120 
1121             uint256 tokenId = startTokenId;
1122             uint256 end = startTokenId + quantity;
1123             do {
1124                 emit Transfer(address(0), to, tokenId++);
1125             } while (tokenId < end);
1126 
1127             _currentIndex = end;
1128         }
1129         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1130     }
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * This function is intended for efficient minting only during contract creation.
1136      *
1137      * It emits only one {ConsecutiveTransfer} as defined in
1138      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1139      * instead of a sequence of {Transfer} event(s).
1140      *
1141      * Calling this function outside of contract creation WILL make your contract
1142      * non-compliant with the ERC721 standard.
1143      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1144      * {ConsecutiveTransfer} event is only permissible during contract creation.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {ConsecutiveTransfer} event.
1152      */
1153     function _mintERC2309(address to, uint256 quantity) internal {
1154         uint256 startTokenId = _currentIndex;
1155         if (to == address(0)) revert MintToZeroAddress();
1156         if (quantity == 0) revert MintZeroQuantity();
1157         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1158 
1159         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1160 
1161         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1162         unchecked {
1163             // Updates:
1164             // - `balance += quantity`.
1165             // - `numberMinted += quantity`.
1166             //
1167             // We can directly add to the `balance` and `numberMinted`.
1168             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1169 
1170             // Updates:
1171             // - `address` to the owner.
1172             // - `startTimestamp` to the timestamp of minting.
1173             // - `burned` to `false`.
1174             // - `nextInitialized` to `quantity == 1`.
1175             _packedOwnerships[startTokenId] = _packOwnershipData(
1176                 to,
1177                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1178             );
1179 
1180             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1181 
1182             _currentIndex = startTokenId + quantity;
1183         }
1184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185     }
1186 
1187     /**
1188      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1189      */
1190     function _getApprovedAddress(uint256 tokenId)
1191         private
1192         view
1193         returns (uint256 approvedAddressSlot, address approvedAddress)
1194     {
1195         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1196         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1197         assembly {
1198             // Compute the slot.
1199             mstore(0x00, tokenId)
1200             mstore(0x20, tokenApprovalsPtr.slot)
1201             approvedAddressSlot := keccak256(0x00, 0x40)
1202             // Load the slot's value from storage.
1203             approvedAddress := sload(approvedAddressSlot)
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1209      */
1210     function _isOwnerOrApproved(
1211         address approvedAddress,
1212         address from,
1213         address msgSender
1214     ) private pure returns (bool result) {
1215         assembly {
1216             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1217             from := and(from, BITMASK_ADDRESS)
1218             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1219             msgSender := and(msgSender, BITMASK_ADDRESS)
1220             // `msgSender == from || msgSender == approvedAddress`.
1221             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1222         }
1223     }
1224 
1225     /**
1226      * @dev Transfers `tokenId` from `from` to `to`.
1227      *
1228      * Requirements:
1229      *
1230      * - `to` cannot be the zero address.
1231      * - `tokenId` token must be owned by `from`.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function transferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) public virtual override {
1240         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1241 
1242         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1243 
1244         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1245 
1246         // The nested ifs save around 20+ gas over a compound boolean condition.
1247         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
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
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
1277                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1278             );
1279 
1280             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1281             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
1299      * @dev Equivalent to `_burn(tokenId, false)`.
1300      */
1301     function _burn(uint256 tokenId) internal virtual {
1302         _burn(tokenId, false);
1303     }
1304 
1305     /**
1306      * @dev Destroys `tokenId`.
1307      * The approval is cleared when the token is burned.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1316         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1317 
1318         address from = address(uint160(prevOwnershipPacked));
1319 
1320         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1321 
1322         if (approvalCheck) {
1323             // The nested ifs save around 20+ gas over a compound boolean condition.
1324             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1325                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1326         }
1327 
1328         _beforeTokenTransfers(from, address(0), tokenId, 1);
1329 
1330         // Clear approvals from the previous owner.
1331         assembly {
1332             if approvedAddress {
1333                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1334                 sstore(approvedAddressSlot, 0)
1335             }
1336         }
1337 
1338         // Underflow of the sender's balance is impossible because we check for
1339         // ownership above and the recipient's balance can't realistically overflow.
1340         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1341         unchecked {
1342             // Updates:
1343             // - `balance -= 1`.
1344             // - `numberBurned += 1`.
1345             //
1346             // We can directly decrement the balance, and increment the number burned.
1347             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1348             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1349 
1350             // Updates:
1351             // - `address` to the last owner.
1352             // - `startTimestamp` to the timestamp of burning.
1353             // - `burned` to `true`.
1354             // - `nextInitialized` to `true`.
1355             _packedOwnerships[tokenId] = _packOwnershipData(
1356                 from,
1357                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1358             );
1359 
1360             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1361             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1362                 uint256 nextTokenId = tokenId + 1;
1363                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1364                 if (_packedOwnerships[nextTokenId] == 0) {
1365                     // If the next slot is within bounds.
1366                     if (nextTokenId != _currentIndex) {
1367                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1368                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1369                     }
1370                 }
1371             }
1372         }
1373 
1374         emit Transfer(from, address(0), tokenId);
1375         _afterTokenTransfers(from, address(0), tokenId, 1);
1376 
1377         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1378         unchecked {
1379             _burnCounter++;
1380         }
1381     }
1382 
1383     /**
1384      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkContractOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1399             bytes4 retval
1400         ) {
1401             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1402         } catch (bytes memory reason) {
1403             if (reason.length == 0) {
1404                 revert TransferToNonERC721ReceiverImplementer();
1405             } else {
1406                 assembly {
1407                     revert(add(32, reason), mload(reason))
1408                 }
1409             }
1410         }
1411     }
1412 
1413     /**
1414      * @dev Directly sets the extra data for the ownership data `index`.
1415      */
1416     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1417         uint256 packed = _packedOwnerships[index];
1418         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1419         uint256 extraDataCasted;
1420         // Cast `extraData` with assembly to avoid redundant masking.
1421         assembly {
1422             extraDataCasted := extraData
1423         }
1424         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1425         _packedOwnerships[index] = packed;
1426     }
1427 
1428     /**
1429      * @dev Returns the next extra data for the packed ownership data.
1430      * The returned result is shifted into position.
1431      */
1432     function _nextExtraData(
1433         address from,
1434         address to,
1435         uint256 prevOwnershipPacked
1436     ) private view returns (uint256) {
1437         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1438         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1439     }
1440 
1441     /**
1442      * @dev Called during each token transfer to set the 24bit `extraData` field.
1443      * Intended to be overridden by the cosumer contract.
1444      *
1445      * `previousExtraData` - the value of `extraData` before transfer.
1446      *
1447      * Calling conditions:
1448      *
1449      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1450      * transferred to `to`.
1451      * - When `from` is zero, `tokenId` will be minted for `to`.
1452      * - When `to` is zero, `tokenId` will be burned by `from`.
1453      * - `from` and `to` are never both zero.
1454      */
1455     function _extraData(
1456         address from,
1457         address to,
1458         uint24 previousExtraData
1459     ) internal view virtual returns (uint24) {}
1460 
1461     /**
1462      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1463      * This includes minting.
1464      * And also called before burning one token.
1465      *
1466      * startTokenId - the first token id to be transferred
1467      * quantity - the amount to be transferred
1468      *
1469      * Calling conditions:
1470      *
1471      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1472      * transferred to `to`.
1473      * - When `from` is zero, `tokenId` will be minted for `to`.
1474      * - When `to` is zero, `tokenId` will be burned by `from`.
1475      * - `from` and `to` are never both zero.
1476      */
1477     function _beforeTokenTransfers(
1478         address from,
1479         address to,
1480         uint256 startTokenId,
1481         uint256 quantity
1482     ) internal virtual {}
1483 
1484     /**
1485      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1486      * This includes minting.
1487      * And also called after one token has been burned.
1488      *
1489      * startTokenId - the first token id to be transferred
1490      * quantity - the amount to be transferred
1491      *
1492      * Calling conditions:
1493      *
1494      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1495      * transferred to `to`.
1496      * - When `from` is zero, `tokenId` has been minted for `to`.
1497      * - When `to` is zero, `tokenId` has been burned by `from`.
1498      * - `from` and `to` are never both zero.
1499      */
1500     function _afterTokenTransfers(
1501         address from,
1502         address to,
1503         uint256 startTokenId,
1504         uint256 quantity
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Returns the message sender (defaults to `msg.sender`).
1509      *
1510      * If you are writing GSN compatible contracts, you need to override this function.
1511      */
1512     function _msgSenderERC721A() internal view virtual returns (address) {
1513         return msg.sender;
1514     }
1515 
1516     /**
1517      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1518      */
1519     function _toString(uint256 value) internal pure returns (string memory ptr) {
1520         assembly {
1521             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1522             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1523             // We will need 1 32-byte word to store the length,
1524             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1525             ptr := add(mload(0x40), 128)
1526             // Update the free memory pointer to allocate.
1527             mstore(0x40, ptr)
1528 
1529             // Cache the end of the memory to calculate the length later.
1530             let end := ptr
1531 
1532             // We write the string from the rightmost digit to the leftmost digit.
1533             // The following is essentially a do-while loop that also handles the zero case.
1534             // Costs a bit more than early returning for the zero case,
1535             // but cheaper in terms of deployment and overall runtime costs.
1536             for {
1537                 // Initialize and perform the first pass without check.
1538                 let temp := value
1539                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1540                 ptr := sub(ptr, 1)
1541                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1542                 mstore8(ptr, add(48, mod(temp, 10)))
1543                 temp := div(temp, 10)
1544             } temp {
1545                 // Keep dividing `temp` until zero.
1546                 temp := div(temp, 10)
1547             } {
1548                 // Body of the for loop.
1549                 ptr := sub(ptr, 1)
1550                 mstore8(ptr, add(48, mod(temp, 10)))
1551             }
1552 
1553             let length := sub(end, ptr)
1554             // Move the pointer 32 bytes leftwards to make room for the length.
1555             ptr := sub(ptr, 32)
1556             // Store the length.
1557             mstore(ptr, length)
1558         }
1559     }
1560 }
1561 
1562 // File: contracts/SIMP.sol
1563 
1564 
1565 
1566 /*
1567  ___   __ __    _ __ ___    _ __ 
1568 / __|  |   |   | '_ ` _ \   | '_\
1569 \__ \   | |    | | | | | |  |  _/
1570 |___/  | _ |   |_| |_| |_|  |_|
1571                                      
1572 */
1573 
1574 pragma solidity ^0.8.4;
1575 
1576 
1577 
1578 
1579 contract SIMP is ERC721A, Ownable {
1580     enum Status {
1581         Waiting,
1582         Started,
1583         Finished,
1584         AllowListOnly
1585     }
1586 
1587     Status public status;
1588     string public baseURI;
1589     bytes32 public merkleRoot;
1590 
1591     uint256 public constant MAX_RESERVE_AMOUNT = 200;
1592     uint256 public constant MAX_PUBLIC_AMOUNT = 1;
1593     uint256 public constant MAX_ALLOWLIST_AMOUNT = 2;
1594     uint256 public constant MAX_SUPPLY = 3000;
1595 
1596     mapping(address => uint256) public allowlist;
1597 
1598     event Minted(address minter, uint256 amount);
1599     event StatusChanged(Status status);
1600     event BaseURIChanged(string newBaseURI);
1601     event BaseMerkleRootChanged(bytes32 newMerkleRoot);
1602 
1603     constructor(string memory initBaseURI) ERC721A("SIMP", "SIMP") {
1604         baseURI = initBaseURI;
1605     }
1606 
1607     function _baseURI() internal view override returns (string memory) {
1608         return baseURI;
1609     }
1610 
1611     function mint(uint256 quantity) external {
1612         require(status == Status.Started, "SIMP: Public mint is not active.");
1613         require(tx.origin == msg.sender, "SIMP: ?? Not you!");
1614         require(
1615             numberMinted(msg.sender) + quantity <= MAX_PUBLIC_AMOUNT,
1616             "SIMP: Max public mint amount per wallet exceeded"
1617         );
1618         require(
1619             totalSupply() + quantity <= MAX_SUPPLY,
1620             "SIMP: Exceed max supply."
1621         );
1622 
1623         _safeMint(msg.sender, quantity);
1624         emit Minted(msg.sender, quantity);
1625     }
1626 
1627     function allowlistMint(uint256 quantity, bytes32[] calldata _merkleProof)
1628         external
1629     {
1630         require(
1631             status == Status.AllowListOnly,
1632             "SIMP: Allowlist mint is not active or passed."
1633         );
1634         require(tx.origin == msg.sender, "SIMP: ?? Not you!");
1635         require(
1636             allowlist[msg.sender] + quantity <= MAX_ALLOWLIST_AMOUNT,
1637             "SIMP: Max allowlist mint amount per wallet exceeded."
1638         );
1639         require(
1640             totalSupply() + quantity <= MAX_SUPPLY,
1641             "SIMP: Exceed max supply."
1642         );
1643         require(
1644             isAllowlist(msg.sender, _merkleProof),
1645             "SIMP: Invalid Merkle Proof."
1646         );
1647 
1648         allowlist[msg.sender] += quantity;
1649         _safeMint(msg.sender, quantity);
1650 
1651         emit Minted(msg.sender, quantity);
1652     }
1653 
1654     function isAllowlist(address yourAddress, bytes32[] calldata _merkleProof)
1655         public
1656         view
1657         returns (bool)
1658     {
1659         bytes32 leaf = keccak256(abi.encodePacked(yourAddress));
1660         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1661     }
1662 
1663     function reserve() public onlyOwner {
1664         require(
1665             totalSupply() + MAX_RESERVE_AMOUNT <= MAX_SUPPLY,
1666             "SIMP: Exceed max supply."
1667         );
1668         _safeMint(msg.sender, MAX_RESERVE_AMOUNT);
1669     }
1670 
1671     function numberMinted(address owner) public view returns (uint256) {
1672         return _numberMinted(owner);
1673     }
1674 
1675     function setStatus(Status _status) external onlyOwner {
1676         status = _status;
1677         emit StatusChanged(status);
1678     }
1679 
1680     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1681         baseURI = newBaseURI;
1682         emit BaseURIChanged(newBaseURI);
1683     }
1684 
1685     function setAllowlistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1686         merkleRoot = _merkleRoot;
1687         emit BaseMerkleRootChanged(merkleRoot);
1688     }
1689 }