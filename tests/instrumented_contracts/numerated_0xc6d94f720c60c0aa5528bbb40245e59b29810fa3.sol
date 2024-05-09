1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Context.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/access/Ownable.sol
244 
245 
246 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 
251 /**
252  * @dev Contract module which provides a basic access control mechanism, where
253  * there is an account (an owner) that can be granted exclusive access to
254  * specific functions.
255  *
256  * By default, the owner account will be the one that deploys the contract. This
257  * can later be changed with {transferOwnership}.
258  *
259  * This module is used through inheritance. It will make available the modifier
260  * `onlyOwner`, which can be applied to your functions to restrict their use to
261  * the owner.
262  */
263 abstract contract Ownable is Context {
264     address private _owner;
265 
266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
267 
268     /**
269      * @dev Initializes the contract setting the deployer as the initial owner.
270      */
271     constructor() {
272         _transferOwnership(_msgSender());
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         _checkOwner();
280         _;
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if the sender is not the owner.
292      */
293     function _checkOwner() internal view virtual {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public virtual onlyOwner {
305         _transferOwnership(address(0));
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         _transferOwnership(newOwner);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Internal function without access restriction.
320      */
321     function _transferOwnership(address newOwner) internal virtual {
322         address oldOwner = _owner;
323         _owner = newOwner;
324         emit OwnershipTransferred(oldOwner, newOwner);
325     }
326 }
327 
328 // File: erc721a/contracts/IERC721A.sol
329 
330 
331 // ERC721A Contracts v4.2.2
332 // Creator: Chiru Labs
333 
334 pragma solidity ^0.8.4;
335 
336 /**
337  * @dev Interface of ERC721A.
338  */
339 interface IERC721A {
340     /**
341      * The caller must own the token or be an approved operator.
342      */
343     error ApprovalCallerNotOwnerNorApproved();
344 
345     /**
346      * The token does not exist.
347      */
348     error ApprovalQueryForNonexistentToken();
349 
350     /**
351      * The caller cannot approve to their own address.
352      */
353     error ApproveToCaller();
354 
355     /**
356      * Cannot query the balance for the zero address.
357      */
358     error BalanceQueryForZeroAddress();
359 
360     /**
361      * Cannot mint to the zero address.
362      */
363     error MintToZeroAddress();
364 
365     /**
366      * The quantity of tokens minted must be more than zero.
367      */
368     error MintZeroQuantity();
369 
370     /**
371      * The token does not exist.
372      */
373     error OwnerQueryForNonexistentToken();
374 
375     /**
376      * The caller must own the token or be an approved operator.
377      */
378     error TransferCallerNotOwnerNorApproved();
379 
380     /**
381      * The token must be owned by `from`.
382      */
383     error TransferFromIncorrectOwner();
384 
385     /**
386      * Cannot safely transfer to a contract that does not implement the
387      * ERC721Receiver interface.
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
411     // =============================================================
412     //                            STRUCTS
413     // =============================================================
414 
415     struct TokenOwnership {
416         // The address of the owner.
417         address addr;
418         // Stores the start time of ownership with minimal overhead for tokenomics.
419         uint64 startTimestamp;
420         // Whether the token has been burned.
421         bool burned;
422         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
423         uint24 extraData;
424     }
425 
426     // =============================================================
427     //                         TOKEN COUNTERS
428     // =============================================================
429 
430     /**
431      * @dev Returns the total number of tokens in existence.
432      * Burned tokens will reduce the count.
433      * To get the total number of tokens minted, please see {_totalMinted}.
434      */
435     function totalSupply() external view returns (uint256);
436 
437     // =============================================================
438     //                            IERC165
439     // =============================================================
440 
441     /**
442      * @dev Returns true if this contract implements the interface defined by
443      * `interfaceId`. See the corresponding
444      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
445      * to learn more about how these ids are created.
446      *
447      * This function call must use less than 30000 gas.
448      */
449     function supportsInterface(bytes4 interfaceId) external view returns (bool);
450 
451     // =============================================================
452     //                            IERC721
453     // =============================================================
454 
455     /**
456      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
457      */
458     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
462      */
463     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables or disables
467      * (`approved`) `operator` to manage all of its assets.
468      */
469     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
470 
471     /**
472      * @dev Returns the number of tokens in `owner`'s account.
473      */
474     function balanceOf(address owner) external view returns (uint256 balance);
475 
476     /**
477      * @dev Returns the owner of the `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function ownerOf(uint256 tokenId) external view returns (address owner);
484 
485     /**
486      * @dev Safely transfers `tokenId` token from `from` to `to`,
487      * checking first that contract recipients are aware of the ERC721 protocol
488      * to prevent tokens from being forever locked.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be have been allowed to move
496      * this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement
498      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
499      *
500      * Emits a {Transfer} event.
501      */
502     function safeTransferFrom(
503         address from,
504         address to,
505         uint256 tokenId,
506         bytes calldata data
507     ) external;
508 
509     /**
510      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
511      */
512     function safeTransferFrom(
513         address from,
514         address to,
515         uint256 tokenId
516     ) external;
517 
518     /**
519      * @dev Transfers `tokenId` from `from` to `to`.
520      *
521      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
522      * whenever possible.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token
530      * by either {approve} or {setApprovalForAll}.
531      *
532      * Emits a {Transfer} event.
533      */
534     function transferFrom(
535         address from,
536         address to,
537         uint256 tokenId
538     ) external;
539 
540     /**
541      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
542      * The approval is cleared when the token is transferred.
543      *
544      * Only a single account can be approved at a time, so approving the
545      * zero address clears previous approvals.
546      *
547      * Requirements:
548      *
549      * - The caller must own the token or be an approved operator.
550      * - `tokenId` must exist.
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address to, uint256 tokenId) external;
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom}
559      * for any token owned by the caller.
560      *
561      * Requirements:
562      *
563      * - The `operator` cannot be the caller.
564      *
565      * Emits an {ApprovalForAll} event.
566      */
567     function setApprovalForAll(address operator, bool _approved) external;
568 
569     /**
570      * @dev Returns the account approved for `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function getApproved(uint256 tokenId) external view returns (address operator);
577 
578     /**
579      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
580      *
581      * See {setApprovalForAll}.
582      */
583     function isApprovedForAll(address owner, address operator) external view returns (bool);
584 
585     // =============================================================
586     //                        IERC721Metadata
587     // =============================================================
588 
589     /**
590      * @dev Returns the token collection name.
591      */
592     function name() external view returns (string memory);
593 
594     /**
595      * @dev Returns the token collection symbol.
596      */
597     function symbol() external view returns (string memory);
598 
599     /**
600      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
601      */
602     function tokenURI(uint256 tokenId) external view returns (string memory);
603 
604     // =============================================================
605     //                           IERC2309
606     // =============================================================
607 
608     /**
609      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
610      * (inclusive) is transferred from `from` to `to`, as defined in the
611      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
612      *
613      * See {_mintERC2309} for more details.
614      */
615     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
616 }
617 
618 // File: erc721a/contracts/ERC721A.sol
619 
620 
621 // ERC721A Contracts v4.2.2
622 // Creator: Chiru Labs
623 
624 pragma solidity ^0.8.4;
625 
626 
627 /**
628  * @dev Interface of ERC721 token receiver.
629  */
630 interface ERC721A__IERC721Receiver {
631     function onERC721Received(
632         address operator,
633         address from,
634         uint256 tokenId,
635         bytes calldata data
636     ) external returns (bytes4);
637 }
638 
639 /**
640  * @title ERC721A
641  *
642  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
643  * Non-Fungible Token Standard, including the Metadata extension.
644  * Optimized for lower gas during batch mints.
645  *
646  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
647  * starting from `_startTokenId()`.
648  *
649  * Assumptions:
650  *
651  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
652  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
653  */
654 contract ERC721A is IERC721A {
655     // Reference type for token approval.
656     struct TokenApprovalRef {
657         address value;
658     }
659 
660     // =============================================================
661     //                           CONSTANTS
662     // =============================================================
663 
664     // Mask of an entry in packed address data.
665     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
666 
667     // The bit position of `numberMinted` in packed address data.
668     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
669 
670     // The bit position of `numberBurned` in packed address data.
671     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
672 
673     // The bit position of `aux` in packed address data.
674     uint256 private constant _BITPOS_AUX = 192;
675 
676     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
677     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
678 
679     // The bit position of `startTimestamp` in packed ownership.
680     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
681 
682     // The bit mask of the `burned` bit in packed ownership.
683     uint256 private constant _BITMASK_BURNED = 1 << 224;
684 
685     // The bit position of the `nextInitialized` bit in packed ownership.
686     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
687 
688     // The bit mask of the `nextInitialized` bit in packed ownership.
689     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
690 
691     // The bit position of `extraData` in packed ownership.
692     uint256 private constant _BITPOS_EXTRA_DATA = 232;
693 
694     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
695     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
696 
697     // The mask of the lower 160 bits for addresses.
698     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
699 
700     // The maximum `quantity` that can be minted with {_mintERC2309}.
701     // This limit is to prevent overflows on the address data entries.
702     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
703     // is required to cause an overflow, which is unrealistic.
704     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
705 
706     // The `Transfer` event signature is given by:
707     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
708     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
709         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
710 
711     // =============================================================
712     //                            STORAGE
713     // =============================================================
714 
715     // The next token ID to be minted.
716     uint256 private _currentIndex;
717 
718     // The number of tokens burned.
719     uint256 private _burnCounter;
720 
721     // Token name
722     string private _name;
723 
724     // Token symbol
725     string private _symbol;
726 
727     // Mapping from token ID to ownership details
728     // An empty struct value does not necessarily mean the token is unowned.
729     // See {_packedOwnershipOf} implementation for details.
730     //
731     // Bits Layout:
732     // - [0..159]   `addr`
733     // - [160..223] `startTimestamp`
734     // - [224]      `burned`
735     // - [225]      `nextInitialized`
736     // - [232..255] `extraData`
737     mapping(uint256 => uint256) private _packedOwnerships;
738 
739     // Mapping owner address to address data.
740     //
741     // Bits Layout:
742     // - [0..63]    `balance`
743     // - [64..127]  `numberMinted`
744     // - [128..191] `numberBurned`
745     // - [192..255] `aux`
746     mapping(address => uint256) private _packedAddressData;
747 
748     // Mapping from token ID to approved address.
749     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     // =============================================================
755     //                          CONSTRUCTOR
756     // =============================================================
757 
758     constructor(string memory name_, string memory symbol_) {
759         _name = name_;
760         _symbol = symbol_;
761         _currentIndex = _startTokenId();
762     }
763 
764     // =============================================================
765     //                   TOKEN COUNTING OPERATIONS
766     // =============================================================
767 
768     /**
769      * @dev Returns the starting token ID.
770      * To change the starting token ID, please override this function.
771      */
772     function _startTokenId() internal view virtual returns (uint256) {
773         return 0;
774     }
775 
776     /**
777      * @dev Returns the next token ID to be minted.
778      */
779     function _nextTokenId() internal view virtual returns (uint256) {
780         return _currentIndex;
781     }
782 
783     /**
784      * @dev Returns the total number of tokens in existence.
785      * Burned tokens will reduce the count.
786      * To get the total number of tokens minted, please see {_totalMinted}.
787      */
788     function totalSupply() public view virtual override returns (uint256) {
789         // Counter underflow is impossible as _burnCounter cannot be incremented
790         // more than `_currentIndex - _startTokenId()` times.
791         unchecked {
792             return _currentIndex - _burnCounter - _startTokenId();
793         }
794     }
795 
796     /**
797      * @dev Returns the total amount of tokens minted in the contract.
798      */
799     function _totalMinted() internal view virtual returns (uint256) {
800         // Counter underflow is impossible as `_currentIndex` does not decrement,
801         // and it is initialized to `_startTokenId()`.
802         unchecked {
803             return _currentIndex - _startTokenId();
804         }
805     }
806 
807     /**
808      * @dev Returns the total number of tokens burned.
809      */
810     function _totalBurned() internal view virtual returns (uint256) {
811         return _burnCounter;
812     }
813 
814     // =============================================================
815     //                    ADDRESS DATA OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Returns the number of tokens in `owner`'s account.
820      */
821     function balanceOf(address owner) public view virtual override returns (uint256) {
822         if (owner == address(0)) revert BalanceQueryForZeroAddress();
823         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
824     }
825 
826     /**
827      * Returns the number of tokens minted by `owner`.
828      */
829     function _numberMinted(address owner) internal view returns (uint256) {
830         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
831     }
832 
833     /**
834      * Returns the number of tokens burned by or on behalf of `owner`.
835      */
836     function _numberBurned(address owner) internal view returns (uint256) {
837         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
838     }
839 
840     /**
841      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
842      */
843     function _getAux(address owner) internal view returns (uint64) {
844         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
845     }
846 
847     /**
848      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
849      * If there are multiple variables, please pack them into a uint64.
850      */
851     function _setAux(address owner, uint64 aux) internal virtual {
852         uint256 packed = _packedAddressData[owner];
853         uint256 auxCasted;
854         // Cast `aux` with assembly to avoid redundant masking.
855         assembly {
856             auxCasted := aux
857         }
858         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
859         _packedAddressData[owner] = packed;
860     }
861 
862     // =============================================================
863     //                            IERC165
864     // =============================================================
865 
866     /**
867      * @dev Returns true if this contract implements the interface defined by
868      * `interfaceId`. See the corresponding
869      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
870      * to learn more about how these ids are created.
871      *
872      * This function call must use less than 30000 gas.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
875         // The interface IDs are constants representing the first 4 bytes
876         // of the XOR of all function selectors in the interface.
877         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
878         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
879         return
880             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
881             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
882             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
883     }
884 
885     // =============================================================
886     //                        IERC721Metadata
887     // =============================================================
888 
889     /**
890      * @dev Returns the token collection name.
891      */
892     function name() public view virtual override returns (string memory) {
893         return _name;
894     }
895 
896     /**
897      * @dev Returns the token collection symbol.
898      */
899     function symbol() public view virtual override returns (string memory) {
900         return _symbol;
901     }
902 
903     /**
904      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
905      */
906     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
907         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
908 
909         string memory baseURI = _baseURI();
910         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
911     }
912 
913     /**
914      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
915      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
916      * by default, it can be overridden in child contracts.
917      */
918     function _baseURI() internal view virtual returns (string memory) {
919         return '';
920     }
921 
922     // =============================================================
923     //                     OWNERSHIPS OPERATIONS
924     // =============================================================
925 
926     /**
927      * @dev Returns the owner of the `tokenId` token.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
934         return address(uint160(_packedOwnershipOf(tokenId)));
935     }
936 
937     /**
938      * @dev Gas spent here starts off proportional to the maximum mint batch size.
939      * It gradually moves to O(1) as tokens get transferred around over time.
940      */
941     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
942         return _unpackedOwnership(_packedOwnershipOf(tokenId));
943     }
944 
945     /**
946      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
947      */
948     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
949         return _unpackedOwnership(_packedOwnerships[index]);
950     }
951 
952     /**
953      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
954      */
955     function _initializeOwnershipAt(uint256 index) internal virtual {
956         if (_packedOwnerships[index] == 0) {
957             _packedOwnerships[index] = _packedOwnershipOf(index);
958         }
959     }
960 
961     /**
962      * Returns the packed ownership data of `tokenId`.
963      */
964     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
965         uint256 curr = tokenId;
966 
967         unchecked {
968             if (_startTokenId() <= curr)
969                 if (curr < _currentIndex) {
970                     uint256 packed = _packedOwnerships[curr];
971                     // If not burned.
972                     if (packed & _BITMASK_BURNED == 0) {
973                         // Invariant:
974                         // There will always be an initialized ownership slot
975                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
976                         // before an unintialized ownership slot
977                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
978                         // Hence, `curr` will not underflow.
979                         //
980                         // We can directly compare the packed value.
981                         // If the address is zero, packed will be zero.
982                         while (packed == 0) {
983                             packed = _packedOwnerships[--curr];
984                         }
985                         return packed;
986                     }
987                 }
988         }
989         revert OwnerQueryForNonexistentToken();
990     }
991 
992     /**
993      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
994      */
995     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
996         ownership.addr = address(uint160(packed));
997         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
998         ownership.burned = packed & _BITMASK_BURNED != 0;
999         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1000     }
1001 
1002     /**
1003      * @dev Packs ownership data into a single uint256.
1004      */
1005     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1006         assembly {
1007             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1008             owner := and(owner, _BITMASK_ADDRESS)
1009             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1010             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1011         }
1012     }
1013 
1014     /**
1015      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1016      */
1017     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1018         // For branchless setting of the `nextInitialized` flag.
1019         assembly {
1020             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1021             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1022         }
1023     }
1024 
1025     // =============================================================
1026     //                      APPROVAL OPERATIONS
1027     // =============================================================
1028 
1029     /**
1030      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1031      * The approval is cleared when the token is transferred.
1032      *
1033      * Only a single account can be approved at a time, so approving the
1034      * zero address clears previous approvals.
1035      *
1036      * Requirements:
1037      *
1038      * - The caller must own the token or be an approved operator.
1039      * - `tokenId` must exist.
1040      *
1041      * Emits an {Approval} event.
1042      */
1043     function approve(address to, uint256 tokenId) public virtual override {
1044         address owner = ownerOf(tokenId);
1045 
1046         if (_msgSenderERC721A() != owner)
1047             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1048                 revert ApprovalCallerNotOwnerNorApproved();
1049             }
1050 
1051         _tokenApprovals[tokenId].value = to;
1052         emit Approval(owner, to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Returns the account approved for `tokenId` token.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must exist.
1061      */
1062     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1063         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1064 
1065         return _tokenApprovals[tokenId].value;
1066     }
1067 
1068     /**
1069      * @dev Approve or remove `operator` as an operator for the caller.
1070      * Operators can call {transferFrom} or {safeTransferFrom}
1071      * for any token owned by the caller.
1072      *
1073      * Requirements:
1074      *
1075      * - The `operator` cannot be the caller.
1076      *
1077      * Emits an {ApprovalForAll} event.
1078      */
1079     function setApprovalForAll(address operator, bool approved) public virtual override {
1080         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1081 
1082         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1083         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1088      *
1089      * See {setApprovalForAll}.
1090      */
1091     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1092         return _operatorApprovals[owner][operator];
1093     }
1094 
1095     /**
1096      * @dev Returns whether `tokenId` exists.
1097      *
1098      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099      *
1100      * Tokens start existing when they are minted. See {_mint}.
1101      */
1102     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1103         return
1104             _startTokenId() <= tokenId &&
1105             tokenId < _currentIndex && // If within bounds,
1106             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1107     }
1108 
1109     /**
1110      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1111      */
1112     function _isSenderApprovedOrOwner(
1113         address approvedAddress,
1114         address owner,
1115         address msgSender
1116     ) private pure returns (bool result) {
1117         assembly {
1118             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1119             owner := and(owner, _BITMASK_ADDRESS)
1120             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1121             msgSender := and(msgSender, _BITMASK_ADDRESS)
1122             // `msgSender == owner || msgSender == approvedAddress`.
1123             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1129      */
1130     function _getApprovedSlotAndAddress(uint256 tokenId)
1131         private
1132         view
1133         returns (uint256 approvedAddressSlot, address approvedAddress)
1134     {
1135         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1136         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1137         assembly {
1138             approvedAddressSlot := tokenApproval.slot
1139             approvedAddress := sload(approvedAddressSlot)
1140         }
1141     }
1142 
1143     // =============================================================
1144     //                      TRANSFER OPERATIONS
1145     // =============================================================
1146 
1147     /**
1148      * @dev Transfers `tokenId` from `from` to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `from` cannot be the zero address.
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      * - If the caller is not `from`, it must be approved to move this token
1156      * by either {approve} or {setApprovalForAll}.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function transferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public virtual override {
1165         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1166 
1167         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1168 
1169         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1170 
1171         // The nested ifs save around 20+ gas over a compound boolean condition.
1172         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1173             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1174 
1175         if (to == address(0)) revert TransferToZeroAddress();
1176 
1177         _beforeTokenTransfers(from, to, tokenId, 1);
1178 
1179         // Clear approvals from the previous owner.
1180         assembly {
1181             if approvedAddress {
1182                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1183                 sstore(approvedAddressSlot, 0)
1184             }
1185         }
1186 
1187         // Underflow of the sender's balance is impossible because we check for
1188         // ownership above and the recipient's balance can't realistically overflow.
1189         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1190         unchecked {
1191             // We can directly increment and decrement the balances.
1192             --_packedAddressData[from]; // Updates: `balance -= 1`.
1193             ++_packedAddressData[to]; // Updates: `balance += 1`.
1194 
1195             // Updates:
1196             // - `address` to the next owner.
1197             // - `startTimestamp` to the timestamp of transfering.
1198             // - `burned` to `false`.
1199             // - `nextInitialized` to `true`.
1200             _packedOwnerships[tokenId] = _packOwnershipData(
1201                 to,
1202                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1203             );
1204 
1205             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1206             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1207                 uint256 nextTokenId = tokenId + 1;
1208                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1209                 if (_packedOwnerships[nextTokenId] == 0) {
1210                     // If the next slot is within bounds.
1211                     if (nextTokenId != _currentIndex) {
1212                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1213                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1214                     }
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(from, to, tokenId);
1220         _afterTokenTransfers(from, to, tokenId, 1);
1221     }
1222 
1223     /**
1224      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1225      */
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) public virtual override {
1231         safeTransferFrom(from, to, tokenId, '');
1232     }
1233 
1234     /**
1235      * @dev Safely transfers `tokenId` token from `from` to `to`.
1236      *
1237      * Requirements:
1238      *
1239      * - `from` cannot be the zero address.
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must exist and be owned by `from`.
1242      * - If the caller is not `from`, it must be approved to move this token
1243      * by either {approve} or {setApprovalForAll}.
1244      * - If `to` refers to a smart contract, it must implement
1245      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function safeTransferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) public virtual override {
1255         transferFrom(from, to, tokenId);
1256         if (to.code.length != 0)
1257             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1258                 revert TransferToNonERC721ReceiverImplementer();
1259             }
1260     }
1261 
1262     /**
1263      * @dev Hook that is called before a set of serially-ordered token IDs
1264      * are about to be transferred. This includes minting.
1265      * And also called before burning one token.
1266      *
1267      * `startTokenId` - the first token ID to be transferred.
1268      * `quantity` - the amount to be transferred.
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` will be minted for `to`.
1275      * - When `to` is zero, `tokenId` will be burned by `from`.
1276      * - `from` and `to` are never both zero.
1277      */
1278     function _beforeTokenTransfers(
1279         address from,
1280         address to,
1281         uint256 startTokenId,
1282         uint256 quantity
1283     ) internal virtual {}
1284 
1285     /**
1286      * @dev Hook that is called after a set of serially-ordered token IDs
1287      * have been transferred. This includes minting.
1288      * And also called after one token has been burned.
1289      *
1290      * `startTokenId` - the first token ID to be transferred.
1291      * `quantity` - the amount to be transferred.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` has been minted for `to`.
1298      * - When `to` is zero, `tokenId` has been burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _afterTokenTransfers(
1302         address from,
1303         address to,
1304         uint256 startTokenId,
1305         uint256 quantity
1306     ) internal virtual {}
1307 
1308     /**
1309      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1310      *
1311      * `from` - Previous owner of the given token ID.
1312      * `to` - Target address that will receive the token.
1313      * `tokenId` - Token ID to be transferred.
1314      * `_data` - Optional data to send along with the call.
1315      *
1316      * Returns whether the call correctly returned the expected magic value.
1317      */
1318     function _checkContractOnERC721Received(
1319         address from,
1320         address to,
1321         uint256 tokenId,
1322         bytes memory _data
1323     ) private returns (bool) {
1324         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1325             bytes4 retval
1326         ) {
1327             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1328         } catch (bytes memory reason) {
1329             if (reason.length == 0) {
1330                 revert TransferToNonERC721ReceiverImplementer();
1331             } else {
1332                 assembly {
1333                     revert(add(32, reason), mload(reason))
1334                 }
1335             }
1336         }
1337     }
1338 
1339     // =============================================================
1340     //                        MINT OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Mints `quantity` tokens and transfers them to `to`.
1345      *
1346      * Requirements:
1347      *
1348      * - `to` cannot be the zero address.
1349      * - `quantity` must be greater than 0.
1350      *
1351      * Emits a {Transfer} event for each mint.
1352      */
1353     function _mint(address to, uint256 quantity) internal virtual {
1354         uint256 startTokenId = _currentIndex;
1355         if (quantity == 0) revert MintZeroQuantity();
1356 
1357         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1358 
1359         // Overflows are incredibly unrealistic.
1360         // `balance` and `numberMinted` have a maximum limit of 2**64.
1361         // `tokenId` has a maximum limit of 2**256.
1362         unchecked {
1363             // Updates:
1364             // - `balance += quantity`.
1365             // - `numberMinted += quantity`.
1366             //
1367             // We can directly add to the `balance` and `numberMinted`.
1368             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1369 
1370             // Updates:
1371             // - `address` to the owner.
1372             // - `startTimestamp` to the timestamp of minting.
1373             // - `burned` to `false`.
1374             // - `nextInitialized` to `quantity == 1`.
1375             _packedOwnerships[startTokenId] = _packOwnershipData(
1376                 to,
1377                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1378             );
1379 
1380             uint256 toMasked;
1381             uint256 end = startTokenId + quantity;
1382 
1383             // Use assembly to loop and emit the `Transfer` event for gas savings.
1384             assembly {
1385                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1386                 toMasked := and(to, _BITMASK_ADDRESS)
1387                 // Emit the `Transfer` event.
1388                 log4(
1389                     0, // Start of data (0, since no data).
1390                     0, // End of data (0, since no data).
1391                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1392                     0, // `address(0)`.
1393                     toMasked, // `to`.
1394                     startTokenId // `tokenId`.
1395                 )
1396 
1397                 for {
1398                     let tokenId := add(startTokenId, 1)
1399                 } iszero(eq(tokenId, end)) {
1400                     tokenId := add(tokenId, 1)
1401                 } {
1402                     // Emit the `Transfer` event. Similar to above.
1403                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1404                 }
1405             }
1406             if (toMasked == 0) revert MintToZeroAddress();
1407 
1408             _currentIndex = end;
1409         }
1410         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1411     }
1412 
1413     /**
1414      * @dev Mints `quantity` tokens and transfers them to `to`.
1415      *
1416      * This function is intended for efficient minting only during contract creation.
1417      *
1418      * It emits only one {ConsecutiveTransfer} as defined in
1419      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1420      * instead of a sequence of {Transfer} event(s).
1421      *
1422      * Calling this function outside of contract creation WILL make your contract
1423      * non-compliant with the ERC721 standard.
1424      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1425      * {ConsecutiveTransfer} event is only permissible during contract creation.
1426      *
1427      * Requirements:
1428      *
1429      * - `to` cannot be the zero address.
1430      * - `quantity` must be greater than 0.
1431      *
1432      * Emits a {ConsecutiveTransfer} event.
1433      */
1434     function _mintERC2309(address to, uint256 quantity) internal virtual {
1435         uint256 startTokenId = _currentIndex;
1436         if (to == address(0)) revert MintToZeroAddress();
1437         if (quantity == 0) revert MintZeroQuantity();
1438         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1439 
1440         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1441 
1442         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1443         unchecked {
1444             // Updates:
1445             // - `balance += quantity`.
1446             // - `numberMinted += quantity`.
1447             //
1448             // We can directly add to the `balance` and `numberMinted`.
1449             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1450 
1451             // Updates:
1452             // - `address` to the owner.
1453             // - `startTimestamp` to the timestamp of minting.
1454             // - `burned` to `false`.
1455             // - `nextInitialized` to `quantity == 1`.
1456             _packedOwnerships[startTokenId] = _packOwnershipData(
1457                 to,
1458                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1459             );
1460 
1461             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1462 
1463             _currentIndex = startTokenId + quantity;
1464         }
1465         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1466     }
1467 
1468     /**
1469      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1470      *
1471      * Requirements:
1472      *
1473      * - If `to` refers to a smart contract, it must implement
1474      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1475      * - `quantity` must be greater than 0.
1476      *
1477      * See {_mint}.
1478      *
1479      * Emits a {Transfer} event for each mint.
1480      */
1481     function _safeMint(
1482         address to,
1483         uint256 quantity,
1484         bytes memory _data
1485     ) internal virtual {
1486         _mint(to, quantity);
1487 
1488         unchecked {
1489             if (to.code.length != 0) {
1490                 uint256 end = _currentIndex;
1491                 uint256 index = end - quantity;
1492                 do {
1493                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1494                         revert TransferToNonERC721ReceiverImplementer();
1495                     }
1496                 } while (index < end);
1497                 // Reentrancy protection.
1498                 if (_currentIndex != end) revert();
1499             }
1500         }
1501     }
1502 
1503     /**
1504      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1505      */
1506     function _safeMint(address to, uint256 quantity) internal virtual {
1507         _safeMint(to, quantity, '');
1508     }
1509 
1510     // =============================================================
1511     //                        BURN OPERATIONS
1512     // =============================================================
1513 
1514     /**
1515      * @dev Equivalent to `_burn(tokenId, false)`.
1516      */
1517     function _burn(uint256 tokenId) internal virtual {
1518         _burn(tokenId, false);
1519     }
1520 
1521     /**
1522      * @dev Destroys `tokenId`.
1523      * The approval is cleared when the token is burned.
1524      *
1525      * Requirements:
1526      *
1527      * - `tokenId` must exist.
1528      *
1529      * Emits a {Transfer} event.
1530      */
1531     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1532         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1533 
1534         address from = address(uint160(prevOwnershipPacked));
1535 
1536         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1537 
1538         if (approvalCheck) {
1539             // The nested ifs save around 20+ gas over a compound boolean condition.
1540             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1541                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1542         }
1543 
1544         _beforeTokenTransfers(from, address(0), tokenId, 1);
1545 
1546         // Clear approvals from the previous owner.
1547         assembly {
1548             if approvedAddress {
1549                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1550                 sstore(approvedAddressSlot, 0)
1551             }
1552         }
1553 
1554         // Underflow of the sender's balance is impossible because we check for
1555         // ownership above and the recipient's balance can't realistically overflow.
1556         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1557         unchecked {
1558             // Updates:
1559             // - `balance -= 1`.
1560             // - `numberBurned += 1`.
1561             //
1562             // We can directly decrement the balance, and increment the number burned.
1563             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1564             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1565 
1566             // Updates:
1567             // - `address` to the last owner.
1568             // - `startTimestamp` to the timestamp of burning.
1569             // - `burned` to `true`.
1570             // - `nextInitialized` to `true`.
1571             _packedOwnerships[tokenId] = _packOwnershipData(
1572                 from,
1573                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1574             );
1575 
1576             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1577             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1578                 uint256 nextTokenId = tokenId + 1;
1579                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1580                 if (_packedOwnerships[nextTokenId] == 0) {
1581                     // If the next slot is within bounds.
1582                     if (nextTokenId != _currentIndex) {
1583                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1584                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1585                     }
1586                 }
1587             }
1588         }
1589 
1590         emit Transfer(from, address(0), tokenId);
1591         _afterTokenTransfers(from, address(0), tokenId, 1);
1592 
1593         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1594         unchecked {
1595             _burnCounter++;
1596         }
1597     }
1598 
1599     // =============================================================
1600     //                     EXTRA DATA OPERATIONS
1601     // =============================================================
1602 
1603     /**
1604      * @dev Directly sets the extra data for the ownership data `index`.
1605      */
1606     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1607         uint256 packed = _packedOwnerships[index];
1608         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1609         uint256 extraDataCasted;
1610         // Cast `extraData` with assembly to avoid redundant masking.
1611         assembly {
1612             extraDataCasted := extraData
1613         }
1614         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1615         _packedOwnerships[index] = packed;
1616     }
1617 
1618     /**
1619      * @dev Called during each token transfer to set the 24bit `extraData` field.
1620      * Intended to be overridden by the cosumer contract.
1621      *
1622      * `previousExtraData` - the value of `extraData` before transfer.
1623      *
1624      * Calling conditions:
1625      *
1626      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1627      * transferred to `to`.
1628      * - When `from` is zero, `tokenId` will be minted for `to`.
1629      * - When `to` is zero, `tokenId` will be burned by `from`.
1630      * - `from` and `to` are never both zero.
1631      */
1632     function _extraData(
1633         address from,
1634         address to,
1635         uint24 previousExtraData
1636     ) internal view virtual returns (uint24) {}
1637 
1638     /**
1639      * @dev Returns the next extra data for the packed ownership data.
1640      * The returned result is shifted into position.
1641      */
1642     function _nextExtraData(
1643         address from,
1644         address to,
1645         uint256 prevOwnershipPacked
1646     ) private view returns (uint256) {
1647         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1648         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1649     }
1650 
1651     // =============================================================
1652     //                       OTHER OPERATIONS
1653     // =============================================================
1654 
1655     /**
1656      * @dev Returns the message sender (defaults to `msg.sender`).
1657      *
1658      * If you are writing GSN compatible contracts, you need to override this function.
1659      */
1660     function _msgSenderERC721A() internal view virtual returns (address) {
1661         return msg.sender;
1662     }
1663 
1664     /**
1665      * @dev Converts a uint256 to its ASCII string decimal representation.
1666      */
1667     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1668         assembly {
1669             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1670             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1671             // We will need 1 32-byte word to store the length,
1672             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1673             str := add(mload(0x40), 0x80)
1674             // Update the free memory pointer to allocate.
1675             mstore(0x40, str)
1676 
1677             // Cache the end of the memory to calculate the length later.
1678             let end := str
1679 
1680             // We write the string from rightmost digit to leftmost digit.
1681             // The following is essentially a do-while loop that also handles the zero case.
1682             // prettier-ignore
1683             for { let temp := value } 1 {} {
1684                 str := sub(str, 1)
1685                 // Write the character to the pointer.
1686                 // The ASCII index of the '0' character is 48.
1687                 mstore8(str, add(48, mod(temp, 10)))
1688                 // Keep dividing `temp` until zero.
1689                 temp := div(temp, 10)
1690                 // prettier-ignore
1691                 if iszero(temp) { break }
1692             }
1693 
1694             let length := sub(end, str)
1695             // Move the pointer 32 bytes leftwards to make room for the length.
1696             str := sub(str, 0x20)
1697             // Store the length.
1698             mstore(str, length)
1699         }
1700     }
1701 }
1702 
1703 // File: contracts/Trosten.sol
1704 
1705 
1706 
1707 pragma solidity ^0.8.17;
1708 
1709 
1710 
1711 
1712 
1713 
1714 contract Trosten is Ownable, ERC721A {
1715 
1716     uint256 public MAX_SUPPLY = 2000;
1717 
1718 
1719 
1720     // Price of each token
1721 
1722     uint256 public TROSTLIST_PRICE = 0.035 ether;
1723 
1724     uint256 public PUBLIC_PRICE = 0.039 ether;
1725 
1726 
1727 
1728     // Start time of the sale
1729 
1730     uint256 public PRIVATE_SALE_TIME;
1731 
1732     uint256 public PUBLIC_SALE_TIME;
1733 
1734 
1735 
1736     // Merkle root of the trostlist
1737 
1738     bytes32 public MERKLE_TROSTLIST;
1739 
1740 
1741 
1742     string private _baseTokenURI;
1743 
1744 
1745 
1746     constructor() ERC721A("Trosten - Trost Island", "TROSTEN") {}
1747 
1748 
1749 
1750     // Public functions
1751 
1752 
1753 
1754     function privateMint(bytes32[] memory _proof) external payable {
1755 
1756         uint256 supply = totalSupply();
1757 
1758         require(
1759 
1760             block.timestamp >= PRIVATE_SALE_TIME,
1761 
1762             "Sale has not yet started"
1763 
1764         );
1765 
1766         require(_numberMinted(msg.sender) < 1, "Already minted");
1767 
1768         require(
1769 
1770             MerkleProof.verify(
1771 
1772                 _proof,
1773 
1774                 MERKLE_TROSTLIST,
1775 
1776                 keccak256(abi.encodePacked(msg.sender))
1777 
1778             ),
1779 
1780             "Address not whitelisted"
1781 
1782         );
1783 
1784         require(supply + 1 <= MAX_SUPPLY, "Reached max supply");
1785 
1786         require(msg.value >= TROSTLIST_PRICE);
1787 
1788         _mint(msg.sender, 1);
1789 
1790     }
1791 
1792 
1793 
1794     function publicMint() external payable {
1795 
1796         uint256 supply = totalSupply();
1797 
1798         require(
1799 
1800             block.timestamp >= PUBLIC_SALE_TIME,
1801 
1802             "Sale has not yet started"
1803 
1804         );
1805 
1806         require(supply + 1 <= MAX_SUPPLY, "Reached max supply");
1807 
1808         require(msg.value >= PUBLIC_PRICE);
1809 
1810         _mint(msg.sender, 1);
1811 
1812     }
1813 
1814 
1815 
1816     function getMinted() public view returns (uint256) {
1817 
1818         return _numberMinted(msg.sender);
1819 
1820     }
1821 
1822 
1823 
1824     // Override functions
1825 
1826 
1827 
1828     function _startTokenId() internal view virtual override returns (uint256) {
1829 
1830         return 1;
1831 
1832     }
1833 
1834 
1835 
1836     function _baseURI() internal view virtual override returns (string memory) {
1837 
1838         return _baseTokenURI;
1839 
1840     }
1841 
1842 
1843 
1844     // Only owner functions
1845 
1846 
1847 
1848     function devMint(uint256 _qty) external onlyOwner {
1849 
1850         require(totalSupply() + _qty <= MAX_SUPPLY, "Reached max supply");
1851 
1852         _mint(msg.sender, _qty);
1853 
1854     }
1855 
1856 
1857 
1858     function setBaseURI(string calldata baseURI) external onlyOwner {
1859 
1860         _baseTokenURI = baseURI;
1861 
1862     }
1863 
1864 
1865 
1866     function setTrostListPrice(uint256 _price) external onlyOwner {
1867 
1868         TROSTLIST_PRICE = _price;
1869 
1870     }
1871 
1872 
1873 
1874     function setPublicPrice(uint256 _price) external onlyOwner {
1875 
1876         PUBLIC_PRICE = _price;
1877 
1878     }
1879 
1880 
1881 
1882     function setPrivateSaleTime(uint256 _timestamp) external onlyOwner {
1883 
1884         PRIVATE_SALE_TIME = _timestamp;
1885 
1886     }
1887 
1888 
1889 
1890     function setPublicSaleTime(uint256 _timestamp) external onlyOwner {
1891 
1892         PUBLIC_SALE_TIME = _timestamp;
1893 
1894     }
1895 
1896 
1897 
1898     function setMerkleRoot(bytes32 _root) external onlyOwner {
1899 
1900         MERKLE_TROSTLIST = _root;
1901 
1902     }
1903 
1904 
1905 
1906     function withdraw() external onlyOwner {
1907 
1908         uint256 funds = address(this).balance;
1909 
1910         (bool succ, ) = payable(msg.sender).call{value: funds}("");
1911 
1912         require(succ, "transfer failed");
1913 
1914     }
1915 
1916 }