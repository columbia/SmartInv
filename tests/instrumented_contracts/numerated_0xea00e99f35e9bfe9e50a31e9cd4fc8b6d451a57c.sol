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
331 // ERC721A Contracts v4.1.0
332 // Creator: Chiru Labs
333 
334 pragma solidity ^0.8.4;
335 
336 /**
337  * @dev Interface of an ERC721A compliant contract.
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
386      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
387      */
388     error TransferToNonERC721ReceiverImplementer();
389 
390     /**
391      * Cannot transfer to the zero address.
392      */
393     error TransferToZeroAddress();
394 
395     /**
396      * The token does not exist.
397      */
398     error URIQueryForNonexistentToken();
399 
400     /**
401      * The `quantity` minted with ERC2309 exceeds the safety limit.
402      */
403     error MintERC2309QuantityExceedsLimit();
404 
405     /**
406      * The `extraData` cannot be set on an unintialized ownership slot.
407      */
408     error OwnershipNotInitializedForExtraData();
409 
410     struct TokenOwnership {
411         // The address of the owner.
412         address addr;
413         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
414         uint64 startTimestamp;
415         // Whether the token has been burned.
416         bool burned;
417         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
418         uint24 extraData;
419     }
420 
421     /**
422      * @dev Returns the total amount of tokens stored by the contract.
423      *
424      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
425      */
426     function totalSupply() external view returns (uint256);
427 
428     // ==============================
429     //            IERC165
430     // ==============================
431 
432     /**
433      * @dev Returns true if this contract implements the interface defined by
434      * `interfaceId`. See the corresponding
435      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
436      * to learn more about how these ids are created.
437      *
438      * This function call must use less than 30 000 gas.
439      */
440     function supportsInterface(bytes4 interfaceId) external view returns (bool);
441 
442     // ==============================
443     //            IERC721
444     // ==============================
445 
446     /**
447      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
448      */
449     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
453      */
454     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
458      */
459     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
460 
461     /**
462      * @dev Returns the number of tokens in ``owner``'s account.
463      */
464     function balanceOf(address owner) external view returns (uint256 balance);
465 
466     /**
467      * @dev Returns the owner of the `tokenId` token.
468      *
469      * Requirements:
470      *
471      * - `tokenId` must exist.
472      */
473     function ownerOf(uint256 tokenId) external view returns (address owner);
474 
475     /**
476      * @dev Safely transfers `tokenId` token from `from` to `to`.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId,
492         bytes calldata data
493     ) external;
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Approve or remove `operator` as an operator for the caller.
552      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
553      *
554      * Requirements:
555      *
556      * - The `operator` cannot be the caller.
557      *
558      * Emits an {ApprovalForAll} event.
559      */
560     function setApprovalForAll(address operator, bool _approved) external;
561 
562     /**
563      * @dev Returns the account approved for `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function getApproved(uint256 tokenId) external view returns (address operator);
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 
578     // ==============================
579     //        IERC721Metadata
580     // ==============================
581 
582     /**
583      * @dev Returns the token collection name.
584      */
585     function name() external view returns (string memory);
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() external view returns (string memory);
591 
592     /**
593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
594      */
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 
597     // ==============================
598     //            IERC2309
599     // ==============================
600 
601     /**
602      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
603      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
604      */
605     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
606 }
607 
608 // File: erc721a/contracts/ERC721A.sol
609 
610 
611 // ERC721A Contracts v4.1.0
612 // Creator: Chiru Labs
613 
614 pragma solidity ^0.8.4;
615 
616 
617 /**
618  * @dev ERC721 token receiver interface.
619  */
620 interface ERC721A__IERC721Receiver {
621     function onERC721Received(
622         address operator,
623         address from,
624         uint256 tokenId,
625         bytes calldata data
626     ) external returns (bytes4);
627 }
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
631  * including the Metadata extension. Built to optimize for lower gas during batch mints.
632  *
633  * Assumes serials are sequentially minted starting at `_startTokenId()`
634  * (defaults to 0, e.g. 0, 1, 2, 3..).
635  *
636  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
637  *
638  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
639  */
640 contract ERC721A is IERC721A {
641     // Mask of an entry in packed address data.
642     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
643 
644     // The bit position of `numberMinted` in packed address data.
645     uint256 private constant BITPOS_NUMBER_MINTED = 64;
646 
647     // The bit position of `numberBurned` in packed address data.
648     uint256 private constant BITPOS_NUMBER_BURNED = 128;
649 
650     // The bit position of `aux` in packed address data.
651     uint256 private constant BITPOS_AUX = 192;
652 
653     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
654     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
655 
656     // The bit position of `startTimestamp` in packed ownership.
657     uint256 private constant BITPOS_START_TIMESTAMP = 160;
658 
659     // The bit mask of the `burned` bit in packed ownership.
660     uint256 private constant BITMASK_BURNED = 1 << 224;
661 
662     // The bit position of the `nextInitialized` bit in packed ownership.
663     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
664 
665     // The bit mask of the `nextInitialized` bit in packed ownership.
666     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
667 
668     // The bit position of `extraData` in packed ownership.
669     uint256 private constant BITPOS_EXTRA_DATA = 232;
670 
671     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
672     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
673 
674     // The mask of the lower 160 bits for addresses.
675     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
676 
677     // The maximum `quantity` that can be minted with `_mintERC2309`.
678     // This limit is to prevent overflows on the address data entries.
679     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
680     // is required to cause an overflow, which is unrealistic.
681     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
682 
683     // The tokenId of the next token to be minted.
684     uint256 private _currentIndex;
685 
686     // The number of tokens burned.
687     uint256 private _burnCounter;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to ownership details
696     // An empty struct value does not necessarily mean the token is unowned.
697     // See `_packedOwnershipOf` implementation for details.
698     //
699     // Bits Layout:
700     // - [0..159]   `addr`
701     // - [160..223] `startTimestamp`
702     // - [224]      `burned`
703     // - [225]      `nextInitialized`
704     // - [232..255] `extraData`
705     mapping(uint256 => uint256) private _packedOwnerships;
706 
707     // Mapping owner address to address data.
708     //
709     // Bits Layout:
710     // - [0..63]    `balance`
711     // - [64..127]  `numberMinted`
712     // - [128..191] `numberBurned`
713     // - [192..255] `aux`
714     mapping(address => uint256) private _packedAddressData;
715 
716     // Mapping from token ID to approved address.
717     mapping(uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     constructor(string memory name_, string memory symbol_) {
723         _name = name_;
724         _symbol = symbol_;
725         _currentIndex = _startTokenId();
726     }
727 
728     /**
729      * @dev Returns the starting token ID.
730      * To change the starting token ID, please override this function.
731      */
732     function _startTokenId() internal view virtual returns (uint256) {
733         return 0;
734     }
735 
736     /**
737      * @dev Returns the next token ID to be minted.
738      */
739     function _nextTokenId() internal view returns (uint256) {
740         return _currentIndex;
741     }
742 
743     /**
744      * @dev Returns the total number of tokens in existence.
745      * Burned tokens will reduce the count.
746      * To get the total number of tokens minted, please see `_totalMinted`.
747      */
748     function totalSupply() public view override returns (uint256) {
749         // Counter underflow is impossible as _burnCounter cannot be incremented
750         // more than `_currentIndex - _startTokenId()` times.
751         unchecked {
752             return _currentIndex - _burnCounter - _startTokenId();
753         }
754     }
755 
756     /**
757      * @dev Returns the total amount of tokens minted in the contract.
758      */
759     function _totalMinted() internal view returns (uint256) {
760         // Counter underflow is impossible as _currentIndex does not decrement,
761         // and it is initialized to `_startTokenId()`
762         unchecked {
763             return _currentIndex - _startTokenId();
764         }
765     }
766 
767     /**
768      * @dev Returns the total number of tokens burned.
769      */
770     function _totalBurned() internal view returns (uint256) {
771         return _burnCounter;
772     }
773 
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
778         // The interface IDs are constants representing the first 4 bytes of the XOR of
779         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
780         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
781         return
782             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
783             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
784             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view override returns (uint256) {
791         if (owner == address(0)) revert BalanceQueryForZeroAddress();
792         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
793     }
794 
795     /**
796      * Returns the number of tokens minted by `owner`.
797      */
798     function _numberMinted(address owner) internal view returns (uint256) {
799         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
800     }
801 
802     /**
803      * Returns the number of tokens burned by or on behalf of `owner`.
804      */
805     function _numberBurned(address owner) internal view returns (uint256) {
806         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
807     }
808 
809     /**
810      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
811      */
812     function _getAux(address owner) internal view returns (uint64) {
813         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
814     }
815 
816     /**
817      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
818      * If there are multiple variables, please pack them into a uint64.
819      */
820     function _setAux(address owner, uint64 aux) internal {
821         uint256 packed = _packedAddressData[owner];
822         uint256 auxCasted;
823         // Cast `aux` with assembly to avoid redundant masking.
824         assembly {
825             auxCasted := aux
826         }
827         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
828         _packedAddressData[owner] = packed;
829     }
830 
831     /**
832      * Returns the packed ownership data of `tokenId`.
833      */
834     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
835         uint256 curr = tokenId;
836 
837         unchecked {
838             if (_startTokenId() <= curr)
839                 if (curr < _currentIndex) {
840                     uint256 packed = _packedOwnerships[curr];
841                     // If not burned.
842                     if (packed & BITMASK_BURNED == 0) {
843                         // Invariant:
844                         // There will always be an ownership that has an address and is not burned
845                         // before an ownership that does not have an address and is not burned.
846                         // Hence, curr will not underflow.
847                         //
848                         // We can directly compare the packed value.
849                         // If the address is zero, packed is zero.
850                         while (packed == 0) {
851                             packed = _packedOwnerships[--curr];
852                         }
853                         return packed;
854                     }
855                 }
856         }
857         revert OwnerQueryForNonexistentToken();
858     }
859 
860     /**
861      * Returns the unpacked `TokenOwnership` struct from `packed`.
862      */
863     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
864         ownership.addr = address(uint160(packed));
865         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
866         ownership.burned = packed & BITMASK_BURNED != 0;
867         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
868     }
869 
870     /**
871      * Returns the unpacked `TokenOwnership` struct at `index`.
872      */
873     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
874         return _unpackedOwnership(_packedOwnerships[index]);
875     }
876 
877     /**
878      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
879      */
880     function _initializeOwnershipAt(uint256 index) internal {
881         if (_packedOwnerships[index] == 0) {
882             _packedOwnerships[index] = _packedOwnershipOf(index);
883         }
884     }
885 
886     /**
887      * Gas spent here starts off proportional to the maximum mint batch size.
888      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
889      */
890     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
891         return _unpackedOwnership(_packedOwnershipOf(tokenId));
892     }
893 
894     /**
895      * @dev Packs ownership data into a single uint256.
896      */
897     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
898         assembly {
899             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
900             owner := and(owner, BITMASK_ADDRESS)
901             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
902             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
903         }
904     }
905 
906     /**
907      * @dev See {IERC721-ownerOf}.
908      */
909     function ownerOf(uint256 tokenId) public view override returns (address) {
910         return address(uint160(_packedOwnershipOf(tokenId)));
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-name}.
915      */
916     function name() public view virtual override returns (string memory) {
917         return _name;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-symbol}.
922      */
923     function symbol() public view virtual override returns (string memory) {
924         return _symbol;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-tokenURI}.
929      */
930     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
931         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
932 
933         string memory baseURI = _baseURI();
934         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
935     }
936 
937     /**
938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
940      * by default, it can be overridden in child contracts.
941      */
942     function _baseURI() internal view virtual returns (string memory) {
943         return '';
944     }
945 
946     /**
947      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
948      */
949     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
950         // For branchless setting of the `nextInitialized` flag.
951         assembly {
952             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
953             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
954         }
955     }
956 
957     /**
958      * @dev See {IERC721-approve}.
959      */
960     function approve(address to, uint256 tokenId) public override {
961         address owner = ownerOf(tokenId);
962 
963         if (_msgSenderERC721A() != owner)
964             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
965                 revert ApprovalCallerNotOwnerNorApproved();
966             }
967 
968         _tokenApprovals[tokenId] = to;
969         emit Approval(owner, to, tokenId);
970     }
971 
972     /**
973      * @dev See {IERC721-getApproved}.
974      */
975     function getApproved(uint256 tokenId) public view override returns (address) {
976         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
977 
978         return _tokenApprovals[tokenId];
979     }
980 
981     /**
982      * @dev See {IERC721-setApprovalForAll}.
983      */
984     function setApprovalForAll(address operator, bool approved) public virtual override {
985         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
986 
987         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
988         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
989     }
990 
991     /**
992      * @dev See {IERC721-isApprovedForAll}.
993      */
994     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
995         return _operatorApprovals[owner][operator];
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         safeTransferFrom(from, to, tokenId, '');
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) public virtual override {
1018         transferFrom(from, to, tokenId);
1019         if (to.code.length != 0)
1020             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1021                 revert TransferToNonERC721ReceiverImplementer();
1022             }
1023     }
1024 
1025     /**
1026      * @dev Returns whether `tokenId` exists.
1027      *
1028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1029      *
1030      * Tokens start existing when they are minted (`_mint`),
1031      */
1032     function _exists(uint256 tokenId) internal view returns (bool) {
1033         return
1034             _startTokenId() <= tokenId &&
1035             tokenId < _currentIndex && // If within bounds,
1036             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1037     }
1038 
1039     /**
1040      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1041      */
1042     function _safeMint(address to, uint256 quantity) internal {
1043         _safeMint(to, quantity, '');
1044     }
1045 
1046     /**
1047      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1048      *
1049      * Requirements:
1050      *
1051      * - If `to` refers to a smart contract, it must implement
1052      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * See {_mint}.
1056      *
1057      * Emits a {Transfer} event for each mint.
1058      */
1059     function _safeMint(
1060         address to,
1061         uint256 quantity,
1062         bytes memory _data
1063     ) internal {
1064         _mint(to, quantity);
1065 
1066         unchecked {
1067             if (to.code.length != 0) {
1068                 uint256 end = _currentIndex;
1069                 uint256 index = end - quantity;
1070                 do {
1071                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1072                         revert TransferToNonERC721ReceiverImplementer();
1073                     }
1074                 } while (index < end);
1075                 // Reentrancy protection.
1076                 if (_currentIndex != end) revert();
1077             }
1078         }
1079     }
1080 
1081     /**
1082      * @dev Mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event for each mint.
1090      */
1091     function _mint(address to, uint256 quantity) internal {
1092         uint256 startTokenId = _currentIndex;
1093         if (to == address(0)) revert MintToZeroAddress();
1094         if (quantity == 0) revert MintZeroQuantity();
1095 
1096         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098         // Overflows are incredibly unrealistic.
1099         // `balance` and `numberMinted` have a maximum limit of 2**64.
1100         // `tokenId` has a maximum limit of 2**256.
1101         unchecked {
1102             // Updates:
1103             // - `balance += quantity`.
1104             // - `numberMinted += quantity`.
1105             //
1106             // We can directly add to the `balance` and `numberMinted`.
1107             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1108 
1109             // Updates:
1110             // - `address` to the owner.
1111             // - `startTimestamp` to the timestamp of minting.
1112             // - `burned` to `false`.
1113             // - `nextInitialized` to `quantity == 1`.
1114             _packedOwnerships[startTokenId] = _packOwnershipData(
1115                 to,
1116                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1117             );
1118 
1119             uint256 tokenId = startTokenId;
1120             uint256 end = startTokenId + quantity;
1121             do {
1122                 emit Transfer(address(0), to, tokenId++);
1123             } while (tokenId < end);
1124 
1125             _currentIndex = end;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * This function is intended for efficient minting only during contract creation.
1134      *
1135      * It emits only one {ConsecutiveTransfer} as defined in
1136      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1137      * instead of a sequence of {Transfer} event(s).
1138      *
1139      * Calling this function outside of contract creation WILL make your contract
1140      * non-compliant with the ERC721 standard.
1141      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1142      * {ConsecutiveTransfer} event is only permissible during contract creation.
1143      *
1144      * Requirements:
1145      *
1146      * - `to` cannot be the zero address.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {ConsecutiveTransfer} event.
1150      */
1151     function _mintERC2309(address to, uint256 quantity) internal {
1152         uint256 startTokenId = _currentIndex;
1153         if (to == address(0)) revert MintToZeroAddress();
1154         if (quantity == 0) revert MintZeroQuantity();
1155         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1160         unchecked {
1161             // Updates:
1162             // - `balance += quantity`.
1163             // - `numberMinted += quantity`.
1164             //
1165             // We can directly add to the `balance` and `numberMinted`.
1166             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1167 
1168             // Updates:
1169             // - `address` to the owner.
1170             // - `startTimestamp` to the timestamp of minting.
1171             // - `burned` to `false`.
1172             // - `nextInitialized` to `quantity == 1`.
1173             _packedOwnerships[startTokenId] = _packOwnershipData(
1174                 to,
1175                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1176             );
1177 
1178             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1179 
1180             _currentIndex = startTokenId + quantity;
1181         }
1182         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1183     }
1184 
1185     /**
1186      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1187      */
1188     function _getApprovedAddress(uint256 tokenId)
1189         private
1190         view
1191         returns (uint256 approvedAddressSlot, address approvedAddress)
1192     {
1193         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1194         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1195         assembly {
1196             // Compute the slot.
1197             mstore(0x00, tokenId)
1198             mstore(0x20, tokenApprovalsPtr.slot)
1199             approvedAddressSlot := keccak256(0x00, 0x40)
1200             // Load the slot's value from storage.
1201             approvedAddress := sload(approvedAddressSlot)
1202         }
1203     }
1204 
1205     /**
1206      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1207      */
1208     function _isOwnerOrApproved(
1209         address approvedAddress,
1210         address from,
1211         address msgSender
1212     ) private pure returns (bool result) {
1213         assembly {
1214             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1215             from := and(from, BITMASK_ADDRESS)
1216             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1217             msgSender := and(msgSender, BITMASK_ADDRESS)
1218             // `msgSender == from || msgSender == approvedAddress`.
1219             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1220         }
1221     }
1222 
1223     /**
1224      * @dev Transfers `tokenId` from `from` to `to`.
1225      *
1226      * Requirements:
1227      *
1228      * - `to` cannot be the zero address.
1229      * - `tokenId` token must be owned by `from`.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function transferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) public virtual override {
1238         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1239 
1240         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1241 
1242         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1243 
1244         // The nested ifs save around 20+ gas over a compound boolean condition.
1245         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1246             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1247 
1248         if (to == address(0)) revert TransferToZeroAddress();
1249 
1250         _beforeTokenTransfers(from, to, tokenId, 1);
1251 
1252         // Clear approvals from the previous owner.
1253         assembly {
1254             if approvedAddress {
1255                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1256                 sstore(approvedAddressSlot, 0)
1257             }
1258         }
1259 
1260         // Underflow of the sender's balance is impossible because we check for
1261         // ownership above and the recipient's balance can't realistically overflow.
1262         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1263         unchecked {
1264             // We can directly increment and decrement the balances.
1265             --_packedAddressData[from]; // Updates: `balance -= 1`.
1266             ++_packedAddressData[to]; // Updates: `balance += 1`.
1267 
1268             // Updates:
1269             // - `address` to the next owner.
1270             // - `startTimestamp` to the timestamp of transfering.
1271             // - `burned` to `false`.
1272             // - `nextInitialized` to `true`.
1273             _packedOwnerships[tokenId] = _packOwnershipData(
1274                 to,
1275                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1276             );
1277 
1278             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1279             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1280                 uint256 nextTokenId = tokenId + 1;
1281                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1282                 if (_packedOwnerships[nextTokenId] == 0) {
1283                     // If the next slot is within bounds.
1284                     if (nextTokenId != _currentIndex) {
1285                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1286                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1287                     }
1288                 }
1289             }
1290         }
1291 
1292         emit Transfer(from, to, tokenId);
1293         _afterTokenTransfers(from, to, tokenId, 1);
1294     }
1295 
1296     /**
1297      * @dev Equivalent to `_burn(tokenId, false)`.
1298      */
1299     function _burn(uint256 tokenId) internal virtual {
1300         _burn(tokenId, false);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1314         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1315 
1316         address from = address(uint160(prevOwnershipPacked));
1317 
1318         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1319 
1320         if (approvalCheck) {
1321             // The nested ifs save around 20+ gas over a compound boolean condition.
1322             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1323                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1324         }
1325 
1326         _beforeTokenTransfers(from, address(0), tokenId, 1);
1327 
1328         // Clear approvals from the previous owner.
1329         assembly {
1330             if approvedAddress {
1331                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1332                 sstore(approvedAddressSlot, 0)
1333             }
1334         }
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1339         unchecked {
1340             // Updates:
1341             // - `balance -= 1`.
1342             // - `numberBurned += 1`.
1343             //
1344             // We can directly decrement the balance, and increment the number burned.
1345             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1346             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1347 
1348             // Updates:
1349             // - `address` to the last owner.
1350             // - `startTimestamp` to the timestamp of burning.
1351             // - `burned` to `true`.
1352             // - `nextInitialized` to `true`.
1353             _packedOwnerships[tokenId] = _packOwnershipData(
1354                 from,
1355                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1356             );
1357 
1358             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1359             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1360                 uint256 nextTokenId = tokenId + 1;
1361                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1362                 if (_packedOwnerships[nextTokenId] == 0) {
1363                     // If the next slot is within bounds.
1364                     if (nextTokenId != _currentIndex) {
1365                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1366                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1367                     }
1368                 }
1369             }
1370         }
1371 
1372         emit Transfer(from, address(0), tokenId);
1373         _afterTokenTransfers(from, address(0), tokenId, 1);
1374 
1375         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1376         unchecked {
1377             _burnCounter++;
1378         }
1379     }
1380 
1381     /**
1382      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkContractOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1397             bytes4 retval
1398         ) {
1399             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1400         } catch (bytes memory reason) {
1401             if (reason.length == 0) {
1402                 revert TransferToNonERC721ReceiverImplementer();
1403             } else {
1404                 assembly {
1405                     revert(add(32, reason), mload(reason))
1406                 }
1407             }
1408         }
1409     }
1410 
1411     /**
1412      * @dev Directly sets the extra data for the ownership data `index`.
1413      */
1414     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1415         uint256 packed = _packedOwnerships[index];
1416         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1417         uint256 extraDataCasted;
1418         // Cast `extraData` with assembly to avoid redundant masking.
1419         assembly {
1420             extraDataCasted := extraData
1421         }
1422         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1423         _packedOwnerships[index] = packed;
1424     }
1425 
1426     /**
1427      * @dev Returns the next extra data for the packed ownership data.
1428      * The returned result is shifted into position.
1429      */
1430     function _nextExtraData(
1431         address from,
1432         address to,
1433         uint256 prevOwnershipPacked
1434     ) private view returns (uint256) {
1435         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1436         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1437     }
1438 
1439     /**
1440      * @dev Called during each token transfer to set the 24bit `extraData` field.
1441      * Intended to be overridden by the cosumer contract.
1442      *
1443      * `previousExtraData` - the value of `extraData` before transfer.
1444      *
1445      * Calling conditions:
1446      *
1447      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1448      * transferred to `to`.
1449      * - When `from` is zero, `tokenId` will be minted for `to`.
1450      * - When `to` is zero, `tokenId` will be burned by `from`.
1451      * - `from` and `to` are never both zero.
1452      */
1453     function _extraData(
1454         address from,
1455         address to,
1456         uint24 previousExtraData
1457     ) internal view virtual returns (uint24) {}
1458 
1459     /**
1460      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1461      * This includes minting.
1462      * And also called before burning one token.
1463      *
1464      * startTokenId - the first token id to be transferred
1465      * quantity - the amount to be transferred
1466      *
1467      * Calling conditions:
1468      *
1469      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1470      * transferred to `to`.
1471      * - When `from` is zero, `tokenId` will be minted for `to`.
1472      * - When `to` is zero, `tokenId` will be burned by `from`.
1473      * - `from` and `to` are never both zero.
1474      */
1475     function _beforeTokenTransfers(
1476         address from,
1477         address to,
1478         uint256 startTokenId,
1479         uint256 quantity
1480     ) internal virtual {}
1481 
1482     /**
1483      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1484      * This includes minting.
1485      * And also called after one token has been burned.
1486      *
1487      * startTokenId - the first token id to be transferred
1488      * quantity - the amount to be transferred
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` has been minted for `to`.
1495      * - When `to` is zero, `tokenId` has been burned by `from`.
1496      * - `from` and `to` are never both zero.
1497      */
1498     function _afterTokenTransfers(
1499         address from,
1500         address to,
1501         uint256 startTokenId,
1502         uint256 quantity
1503     ) internal virtual {}
1504 
1505     /**
1506      * @dev Returns the message sender (defaults to `msg.sender`).
1507      *
1508      * If you are writing GSN compatible contracts, you need to override this function.
1509      */
1510     function _msgSenderERC721A() internal view virtual returns (address) {
1511         return msg.sender;
1512     }
1513 
1514     /**
1515      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1516      */
1517     function _toString(uint256 value) internal pure returns (string memory ptr) {
1518         assembly {
1519             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1520             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1521             // We will need 1 32-byte word to store the length,
1522             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1523             ptr := add(mload(0x40), 128)
1524             // Update the free memory pointer to allocate.
1525             mstore(0x40, ptr)
1526 
1527             // Cache the end of the memory to calculate the length later.
1528             let end := ptr
1529 
1530             // We write the string from the rightmost digit to the leftmost digit.
1531             // The following is essentially a do-while loop that also handles the zero case.
1532             // Costs a bit more than early returning for the zero case,
1533             // but cheaper in terms of deployment and overall runtime costs.
1534             for {
1535                 // Initialize and perform the first pass without check.
1536                 let temp := value
1537                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1538                 ptr := sub(ptr, 1)
1539                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1540                 mstore8(ptr, add(48, mod(temp, 10)))
1541                 temp := div(temp, 10)
1542             } temp {
1543                 // Keep dividing `temp` until zero.
1544                 temp := div(temp, 10)
1545             } {
1546                 // Body of the for loop.
1547                 ptr := sub(ptr, 1)
1548                 mstore8(ptr, add(48, mod(temp, 10)))
1549             }
1550 
1551             let length := sub(end, ptr)
1552             // Move the pointer 32 bytes leftwards to make room for the length.
1553             ptr := sub(ptr, 32)
1554             // Store the length.
1555             mstore(ptr, length)
1556         }
1557     }
1558 }
1559 
1560 // File: contracts/Undeeds.sol
1561 
1562 
1563 pragma solidity ^0.8.14;
1564 
1565 
1566 
1567 
1568 contract Undeeds is Ownable, ERC721A {
1569   uint256 public maxSupply = 6969;
1570 
1571   // Quantity per Mint
1572   uint256 public maxPublicMintQty = 2;
1573   uint256 public maxDeedlistMintQty = 2;
1574   uint256 public maxFreeMintQty = 1;
1575 
1576   // Max minted quantity in this sale
1577   uint256 public maxDeedlistAmount = 2;
1578   uint256 public maxFreeMintAmount = 1;
1579 
1580   uint256 public deedlistPrice = 0.00969 ether;
1581   uint256 public publicPrice = 0.00969 ether;
1582 
1583   uint256 public deedlistSaleStartTime;
1584   uint256 public publicSaleStartTime;
1585   uint256 public freeMintSaleStartTime;
1586 
1587   string private _baseTokenURI;
1588 
1589   bytes32 public rootDL;
1590   bytes32 public rootFR;
1591 
1592   constructor() ERC721A('Undeeds', 'UNDEEDS') {}
1593 
1594   function freeMint(bytes32[] memory proof, uint256 quantity) external {
1595     uint256 supply = totalSupply();
1596     require(
1597       freeMintSaleStartTime != 0 && block.timestamp >= freeMintSaleStartTime,
1598       'Sale has not started yet'
1599     );
1600     require(
1601       _getAux(msg.sender) + quantity <= maxFreeMintAmount,
1602       'Already minted'
1603     );
1604     require(
1605       isValidFR(proof, keccak256(abi.encodePacked(msg.sender))),
1606       'Not a part of free mint'
1607     );
1608     require(quantity <= maxFreeMintQty, 'Reached max free mint amount');
1609     require(supply + quantity <= maxSupply, 'Reached max supply');
1610     _setAux(msg.sender, _getAux(msg.sender) + uint64(quantity));
1611     _safeMint(msg.sender, quantity);
1612   }
1613 
1614   function deedlistMint(bytes32[] memory proof, uint256 quantity)
1615     external
1616     payable
1617   {
1618     uint256 supply = totalSupply();
1619     require(
1620       deedlistSaleStartTime != 0 && block.timestamp >= deedlistSaleStartTime,
1621       'Sale has not started yet'
1622     );
1623     require(
1624       _numberMinted(msg.sender) + quantity <= maxDeedlistAmount,
1625       'Already minted'
1626     );
1627     require(
1628       isValidDL(proof, keccak256(abi.encodePacked(msg.sender))),
1629       'Not a part of deedlist'
1630     );
1631     require(quantity <= maxDeedlistMintQty, 'Reached max deedlist amount');
1632     require(supply + quantity <= maxSupply, 'Reached max supply');
1633     require(msg.value >= deedlistPrice * quantity);
1634     _safeMint(msg.sender, quantity);
1635   }
1636 
1637   function publicMint(uint256 quantity) external payable {
1638     uint256 supply = totalSupply();
1639     require(
1640       publicSaleStartTime != 0 && block.timestamp >= publicSaleStartTime,
1641       'Sale has not started yet'
1642     );
1643     require(quantity <= maxPublicMintQty, 'Can not mint this many');
1644     require(supply + quantity <= maxSupply, 'Reached max public supply');
1645     require(msg.value >= publicPrice * quantity);
1646     _safeMint(msg.sender, quantity);
1647   }
1648 
1649   function isValidDL(bytes32[] memory proof, bytes32 leaf)
1650     public
1651     view
1652     returns (bool)
1653   {
1654     return MerkleProof.verify(proof, rootDL, leaf);
1655   }
1656 
1657   function isValidFR(bytes32[] memory proof, bytes32 leaf)
1658     public
1659     view
1660     returns (bool)
1661   {
1662     return MerkleProof.verify(proof, rootFR, leaf);
1663   }
1664 
1665   function getNumMinted() public view returns (uint256) {
1666     return _numberMinted(msg.sender);
1667   }
1668 
1669   function getNumFRMinted() public view returns (uint256) {
1670     return _getAux(msg.sender);
1671   }
1672 
1673   function _startTokenId() internal view virtual override returns (uint256) {
1674     return 1;
1675   }
1676 
1677   // Only Owner
1678   function devMint(uint256 quantity) external onlyOwner {
1679     require(totalSupply() + quantity <= maxSupply, 'Reached max supply');
1680     _safeMint(msg.sender, quantity);
1681   }
1682 
1683   function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1684     maxSupply = _maxSupply;
1685   }
1686 
1687   function setMaxPublicMintQty(uint256 _maxPublicMintQty) external onlyOwner {
1688     maxPublicMintQty = _maxPublicMintQty;
1689   }
1690 
1691   function setMaxDeedlistMintQty(uint256 _maxDeedlistMintQty)
1692     external
1693     onlyOwner
1694   {
1695     maxDeedlistMintQty = _maxDeedlistMintQty;
1696   }
1697 
1698   function setMaxFreeMintQty(uint256 _maxFreeMintQty) external onlyOwner {
1699     maxFreeMintQty = _maxFreeMintQty;
1700   }
1701 
1702   function setMaxDeedlistAmount(uint256 _maxDeedlistAmount) external onlyOwner {
1703     maxDeedlistAmount = _maxDeedlistAmount;
1704   }
1705 
1706   function setMaxFreeMintAmount(uint256 _maxFreeMintAmount) external onlyOwner {
1707     maxFreeMintAmount = _maxFreeMintAmount;
1708   }
1709 
1710   function setDeedlistPrice(uint256 _newPrice) external onlyOwner {
1711     deedlistPrice = _newPrice;
1712   }
1713 
1714   function setPublicPrice(uint256 _newPrice) external onlyOwner {
1715     publicPrice = _newPrice;
1716   }
1717 
1718   function _baseURI() internal view virtual override returns (string memory) {
1719     return _baseTokenURI;
1720   }
1721 
1722   function setBaseURI(string calldata baseURI) external onlyOwner {
1723     _baseTokenURI = baseURI;
1724   }
1725 
1726   function setDeedlistSaleStartTime(uint256 timestamp) external onlyOwner {
1727     deedlistSaleStartTime = timestamp;
1728   }
1729 
1730   function setPublicSaleStartTime(uint256 timestamp) external onlyOwner {
1731     publicSaleStartTime = timestamp;
1732   }
1733 
1734   function setFreeMintSaleStartTime(uint256 timestamp) external onlyOwner {
1735     freeMintSaleStartTime = timestamp;
1736   }
1737 
1738   function setRootDL(bytes32 _rootDL) external onlyOwner {
1739     rootDL = _rootDL;
1740   }
1741 
1742   function setRootFR(bytes32 _rootFR) external onlyOwner {
1743     rootFR = _rootFR;
1744   }
1745 
1746   function withdraw() external onlyOwner {
1747     uint256 funds = address(this).balance;
1748     (bool succ, ) = payable(msg.sender).call{value: funds}('');
1749     require(succ, 'transfer failed');
1750   }
1751 }