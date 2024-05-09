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
216 // File: contracts/1_Storage.sol
217 
218 /**
219  *Submitted for verification at Etherscan.io on 2022-10-05
220 */
221 
222 // File: @openzeppelin/contracts/utils/Context.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/access/Ownable.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280 
281     /**
282      * @dev Throws if called by any account other than the owner.
283      */
284     modifier onlyOwner() {
285         _checkOwner();
286         _;
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if the sender is not the owner.
298      */
299     function _checkOwner() internal view virtual {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _transferOwnership(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Internal function without access restriction.
326      */
327     function _transferOwnership(address newOwner) internal virtual {
328         address oldOwner = _owner;
329         _owner = newOwner;
330         emit OwnershipTransferred(oldOwner, newOwner);
331     }
332 }
333 
334 // File: erc721a/contracts/IERC721A.sol
335 
336 
337 // ERC721A Contracts v4.1.0
338 // Creator: Chiru Labs
339 
340 pragma solidity ^0.8.4;
341 
342 /**
343  * @dev Interface of an ERC721A compliant contract.
344  */
345 interface IERC721A {
346     /**
347      * The caller must own the token or be an approved operator.
348      */
349     error ApprovalCallerNotOwnerNorApproved();
350 
351     /**
352      * The token does not exist.
353      */
354     error ApprovalQueryForNonexistentToken();
355 
356     /**
357      * The caller cannot approve to their own address.
358      */
359     error ApproveToCaller();
360 
361     /**
362      * Cannot query the balance for the zero address.
363      */
364     error BalanceQueryForZeroAddress();
365 
366     /**
367      * Cannot mint to the zero address.
368      */
369     error MintToZeroAddress();
370 
371     /**
372      * The quantity of tokens minted must be more than zero.
373      */
374     error MintZeroQuantity();
375 
376     /**
377      * The token does not exist.
378      */
379     error OwnerQueryForNonexistentToken();
380 
381     /**
382      * The caller must own the token or be an approved operator.
383      */
384     error TransferCallerNotOwnerNorApproved();
385 
386     /**
387      * The token must be owned by `from`.
388      */
389     error TransferFromIncorrectOwner();
390 
391     /**
392      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
393      */
394     error TransferToNonERC721ReceiverImplementer();
395 
396     /**
397      * Cannot transfer to the zero address.
398      */
399     error TransferToZeroAddress();
400 
401     /**
402      * The token does not exist.
403      */
404     error URIQueryForNonexistentToken();
405 
406     /**
407      * The `quantity` minted with ERC2309 exceeds the safety limit.
408      */
409     error MintERC2309QuantityExceedsLimit();
410 
411     /**
412      * The `extraData` cannot be set on an unintialized ownership slot.
413      */
414     error OwnershipNotInitializedForExtraData();
415 
416     struct TokenOwnership {
417         // The address of the owner.
418         address addr;
419         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
420         uint64 startTimestamp;
421         // Whether the token has been burned.
422         bool burned;
423         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
424         uint24 extraData;
425     }
426 
427     /**
428      * @dev Returns the total amount of tokens stored by the contract.
429      *
430      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
431      */
432     function totalSupply() external view returns (uint256);
433 
434     // ==============================
435     //            IERC165
436     // ==============================
437 
438     /**
439      * @dev Returns true if this contract implements the interface defined by
440      * `interfaceId`. See the corresponding
441      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
442      * to learn more about how these ids are created.
443      *
444      * This function call must use less than 30 000 gas.
445      */
446     function supportsInterface(bytes4 interfaceId) external view returns (bool);
447 
448     // ==============================
449     //            IERC721
450     // ==============================
451 
452     /**
453      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
459      */
460     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
464      */
465     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
466 
467     /**
468      * @dev Returns the number of tokens in ``owner``"s account.
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
482      * @dev Safely transfers `tokenId` token from `from` to `to`.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes calldata data
499     ) external;
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
503      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Transfers `tokenId` token from `from` to `to`.
523      *
524      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must be owned by `from`.
531      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
532      *
533      * Emits a {Transfer} event.
534      */
535     function transferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) external;
540 
541     /**
542      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
543      * The approval is cleared when the token is transferred.
544      *
545      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
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
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns the account approved for `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function getApproved(uint256 tokenId) external view returns (address operator);
576 
577     /**
578      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
579      *
580      * See {setApprovalForAll}
581      */
582     function isApprovedForAll(address owner, address operator) external view returns (bool);
583 
584     // ==============================
585     //        IERC721Metadata
586     // ==============================
587 
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 
603     // ==============================
604     //            IERC2309
605     // ==============================
606 
607     /**
608      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
609      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
610      */
611     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
612 }
613 
614 // File: erc721a/contracts/ERC721A.sol
615 
616 
617 // ERC721A Contracts v4.1.0
618 // Creator: Chiru Labs
619 
620 pragma solidity ^0.8.4;
621 
622 
623 /**
624  * @dev ERC721 token receiver interface.
625  */
626 interface ERC721A__IERC721Receiver {
627     function onERC721Received(
628         address operator,
629         address from,
630         uint256 tokenId,
631         bytes calldata data
632     ) external returns (bytes4);
633 }
634 
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
637  * including the Metadata extension. Built to optimize for lower gas during batch mints.
638  *
639  * Assumes serials are sequentially minted starting at `_startTokenId()`
640  * (defaults to 0, e.g. 0, 1, 2, 3..).
641  *
642  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
643  *
644  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
645  */
646 contract ERC721A is IERC721A {
647     // Mask of an entry in packed address data.
648     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
649 
650     // The bit position of `numberMinted` in packed address data.
651     uint256 private constant BITPOS_NUMBER_MINTED = 64;
652 
653     // The bit position of `numberBurned` in packed address data.
654     uint256 private constant BITPOS_NUMBER_BURNED = 128;
655 
656     // The bit position of `aux` in packed address data.
657     uint256 private constant BITPOS_AUX = 192;
658 
659     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
660     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
661 
662     // The bit position of `startTimestamp` in packed ownership.
663     uint256 private constant BITPOS_START_TIMESTAMP = 160;
664 
665     // The bit mask of the `burned` bit in packed ownership.
666     uint256 private constant BITMASK_BURNED = 1 << 224;
667 
668     // The bit position of the `nextInitialized` bit in packed ownership.
669     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
670 
671     // The bit mask of the `nextInitialized` bit in packed ownership.
672     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
673 
674     // The bit position of `extraData` in packed ownership.
675     uint256 private constant BITPOS_EXTRA_DATA = 232;
676 
677     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
678     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
679 
680     // The mask of the lower 160 bits for addresses.
681     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
682 
683     // The maximum `quantity` that can be minted with `_mintERC2309`.
684     // This limit is to prevent overflows on the address data entries.
685     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
686     // is required to cause an overflow, which is unrealistic.
687     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
688 
689     // The tokenId of the next token to be minted.
690     uint256 private _currentIndex;
691 
692     // The number of tokens burned.
693     uint256 private _burnCounter;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to ownership details
702     // An empty struct value does not necessarily mean the token is unowned.
703     // See `_packedOwnershipOf` implementation for details.
704     //
705     // Bits Layout:
706     // - [0..159]   `addr`
707     // - [160..223] `startTimestamp`
708     // - [224]      `burned`
709     // - [225]      `nextInitialized`
710     // - [232..255] `extraData`
711     mapping(uint256 => uint256) private _packedOwnerships;
712 
713     // Mapping owner address to address data.
714     //
715     // Bits Layout:
716     // - [0..63]    `balance`
717     // - [64..127]  `numberMinted`
718     // - [128..191] `numberBurned`
719     // - [192..255] `aux`
720     mapping(address => uint256) private _packedAddressData;
721 
722     // Mapping from token ID to approved address.
723     mapping(uint256 => address) private _tokenApprovals;
724 
725     // Mapping from owner to operator approvals
726     mapping(address => mapping(address => bool)) private _operatorApprovals;
727 
728     constructor(string memory name_, string memory symbol_) {
729         _name = name_;
730         _symbol = symbol_;
731         _currentIndex = _startTokenId();
732     }
733 
734     /**
735      * @dev Returns the starting token ID.
736      * To change the starting token ID, please override this function.
737      */
738     function _startTokenId() internal view virtual returns (uint256) {
739         return 0;
740     }
741 
742     /**
743      * @dev Returns the next token ID to be minted.
744      */
745     function _nextTokenId() internal view returns (uint256) {
746         return _currentIndex;
747     }
748 
749     /**
750      * @dev Returns the total number of tokens in existence.
751      * Burned tokens will reduce the count.
752      * To get the total number of tokens minted, please see `_totalMinted`.
753      */
754     function totalSupply() public view override returns (uint256) {
755         // Counter underflow is impossible as _burnCounter cannot be incremented
756         // more than `_currentIndex - _startTokenId()` times.
757         unchecked {
758             return _currentIndex - _burnCounter - _startTokenId();
759         }
760     }
761 
762     /**
763      * @dev Returns the total amount of tokens minted in the contract.
764      */
765     function _totalMinted() internal view returns (uint256) {
766         // Counter underflow is impossible as _currentIndex does not decrement,
767         // and it is initialized to `_startTokenId()`
768         unchecked {
769             return _currentIndex - _startTokenId();
770         }
771     }
772 
773     /**
774      * @dev Returns the total number of tokens burned.
775      */
776     function _totalBurned() internal view returns (uint256) {
777         return _burnCounter;
778     }
779 
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
784         // The interface IDs are constants representing the first 4 bytes of the XOR of
785         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
786         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
787         return
788             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
789             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
790             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
791     }
792 
793     /**
794      * @dev See {IERC721-balanceOf}.
795      */
796     function balanceOf(address owner) public view override returns (uint256) {
797         if (owner == address(0)) revert BalanceQueryForZeroAddress();
798         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
799     }
800 
801     /**
802      * Returns the number of tokens minted by `owner`.
803      */
804     function _numberMinted(address owner) internal view returns (uint256) {
805         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
806     }
807 
808     /**
809      * Returns the number of tokens burned by or on behalf of `owner`.
810      */
811     function _numberBurned(address owner) internal view returns (uint256) {
812         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
813     }
814 
815     /**
816      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
817      */
818     function _getAux(address owner) internal view returns (uint64) {
819         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
820     }
821 
822     /**
823      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
824      * If there are multiple variables, please pack them into a uint64.
825      */
826     function _setAux(address owner, uint64 aux) internal {
827         uint256 packed = _packedAddressData[owner];
828         uint256 auxCasted;
829         // Cast `aux` with assembly to avoid redundant masking.
830         assembly {
831             auxCasted := aux
832         }
833         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
834         _packedAddressData[owner] = packed;
835     }
836 
837     /**
838      * Returns the packed ownership data of `tokenId`.
839      */
840     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
841         uint256 curr = tokenId;
842 
843         unchecked {
844             if (_startTokenId() <= curr)
845                 if (curr < _currentIndex) {
846                     uint256 packed = _packedOwnerships[curr];
847                     // If not burned.
848                     if (packed & BITMASK_BURNED == 0) {
849                         // Invariant:
850                         // There will always be an ownership that has an address and is not burned
851                         // before an ownership that does not have an address and is not burned.
852                         // Hence, curr will not underflow.
853                         //
854                         // We can directly compare the packed value.
855                         // If the address is zero, packed is zero.
856                         while (packed == 0) {
857                             packed = _packedOwnerships[--curr];
858                         }
859                         return packed;
860                     }
861                 }
862         }
863         revert OwnerQueryForNonexistentToken();
864     }
865 
866     /**
867      * Returns the unpacked `TokenOwnership` struct from `packed`.
868      */
869     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
870         ownership.addr = address(uint160(packed));
871         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
872         ownership.burned = packed & BITMASK_BURNED != 0;
873         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
874     }
875 
876     /**
877      * Returns the unpacked `TokenOwnership` struct at `index`.
878      */
879     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
880         return _unpackedOwnership(_packedOwnerships[index]);
881     }
882 
883     /**
884      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
885      */
886     function _initializeOwnershipAt(uint256 index) internal {
887         if (_packedOwnerships[index] == 0) {
888             _packedOwnerships[index] = _packedOwnershipOf(index);
889         }
890     }
891 
892     /**
893      * Gas spent here starts off proportional to the maximum mint batch size.
894      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
895      */
896     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
897         return _unpackedOwnership(_packedOwnershipOf(tokenId));
898     }
899 
900     /**
901      * @dev Packs ownership data into a single uint256.
902      */
903     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
904         assembly {
905             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
906             owner := and(owner, BITMASK_ADDRESS)
907             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
908             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
909         }
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view override returns (address) {
916         return address(uint160(_packedOwnershipOf(tokenId)));
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
938 
939         string memory baseURI = _baseURI();
940         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, it can be overridden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return "";
950     }
951 
952     /**
953      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
954      */
955     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
956         // For branchless setting of the `nextInitialized` flag.
957         assembly {
958             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
959             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
960         }
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public override {
967         address owner = ownerOf(tokenId);
968 
969         if (_msgSenderERC721A() != owner)
970             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
971                 revert ApprovalCallerNotOwnerNorApproved();
972             }
973 
974         _tokenApprovals[tokenId] = to;
975         emit Approval(owner, to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public virtual override {
991         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
992 
993         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
994         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-safeTransferFrom}.
1006      */
1007     function safeTransferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         safeTransferFrom(from, to, tokenId, "");
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public virtual override {
1024         transferFrom(from, to, tokenId);
1025         if (to.code.length != 0)
1026             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1027                 revert TransferToNonERC721ReceiverImplementer();
1028             }
1029     }
1030 
1031     /**
1032      * @dev Returns whether `tokenId` exists.
1033      *
1034      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1035      *
1036      * Tokens start existing when they are minted (`_mint`),
1037      */
1038     function _exists(uint256 tokenId) internal view returns (bool) {
1039         return
1040             _startTokenId() <= tokenId &&
1041             tokenId < _currentIndex && // If within bounds,
1042             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1043     }
1044 
1045     /**
1046      * @dev Equivalent to `_safeMint(to, quantity, "")`.
1047      */
1048     function _safeMint(address to, uint256 quantity) internal {
1049         _safeMint(to, quantity, "");
1050     }
1051 
1052     /**
1053      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - If `to` refers to a smart contract, it must implement
1058      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * See {_mint}.
1062      *
1063      * Emits a {Transfer} event for each mint.
1064      */
1065     function _safeMint(
1066         address to,
1067         uint256 quantity,
1068         bytes memory _data
1069     ) internal {
1070         _mint(to, quantity);
1071 
1072         unchecked {
1073             if (to.code.length != 0) {
1074                 uint256 end = _currentIndex;
1075                 uint256 index = end - quantity;
1076                 do {
1077                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1078                         revert TransferToNonERC721ReceiverImplementer();
1079                     }
1080                 } while (index < end);
1081                 // Reentrancy protection.
1082                 if (_currentIndex != end) revert();
1083             }
1084         }
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {Transfer} event for each mint.
1096      */
1097     function _mint(address to, uint256 quantity) internal {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // `balance` and `numberMinted` have a maximum limit of 2**64.
1106         // `tokenId` has a maximum limit of 2**256.
1107         unchecked {
1108             // Updates:
1109             // - `balance += quantity`.
1110             // - `numberMinted += quantity`.
1111             //
1112             // We can directly add to the `balance` and `numberMinted`.
1113             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1114 
1115             // Updates:
1116             // - `address` to the owner.
1117             // - `startTimestamp` to the timestamp of minting.
1118             // - `burned` to `false`.
1119             // - `nextInitialized` to `quantity == 1`.
1120             _packedOwnerships[startTokenId] = _packOwnershipData(
1121                 to,
1122                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1123             );
1124 
1125             uint256 tokenId = startTokenId;
1126             uint256 end = startTokenId + quantity;
1127             do {
1128                 emit Transfer(address(0), to, tokenId++);
1129             } while (tokenId < end);
1130 
1131             _currentIndex = end;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * This function is intended for efficient minting only during contract creation.
1140      *
1141      * It emits only one {ConsecutiveTransfer} as defined in
1142      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1143      * instead of a sequence of {Transfer} event(s).
1144      *
1145      * Calling this function outside of contract creation WILL make your contract
1146      * non-compliant with the ERC721 standard.
1147      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1148      * {ConsecutiveTransfer} event is only permissible during contract creation.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {ConsecutiveTransfer} event.
1156      */
1157     function _mintERC2309(address to, uint256 quantity) internal {
1158         uint256 startTokenId = _currentIndex;
1159         if (to == address(0)) revert MintToZeroAddress();
1160         if (quantity == 0) revert MintZeroQuantity();
1161         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1166         unchecked {
1167             // Updates:
1168             // - `balance += quantity`.
1169             // - `numberMinted += quantity`.
1170             //
1171             // We can directly add to the `balance` and `numberMinted`.
1172             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1173 
1174             // Updates:
1175             // - `address` to the owner.
1176             // - `startTimestamp` to the timestamp of minting.
1177             // - `burned` to `false`.
1178             // - `nextInitialized` to `quantity == 1`.
1179             _packedOwnerships[startTokenId] = _packOwnershipData(
1180                 to,
1181                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1182             );
1183 
1184             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1185 
1186             _currentIndex = startTokenId + quantity;
1187         }
1188         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189     }
1190 
1191     /**
1192      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1193      */
1194     function _getApprovedAddress(uint256 tokenId)
1195         private
1196         view
1197         returns (uint256 approvedAddressSlot, address approvedAddress)
1198     {
1199         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1200         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1201         assembly {
1202             // Compute the slot.
1203             mstore(0x00, tokenId)
1204             mstore(0x20, tokenApprovalsPtr.slot)
1205             approvedAddressSlot := keccak256(0x00, 0x40)
1206             // Load the slot"s value from storage.
1207             approvedAddress := sload(approvedAddressSlot)
1208         }
1209     }
1210 
1211     /**
1212      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1213      */
1214     function _isOwnerOrApproved(
1215         address approvedAddress,
1216         address from,
1217         address msgSender
1218     ) private pure returns (bool result) {
1219         assembly {
1220             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1221             from := and(from, BITMASK_ADDRESS)
1222             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1223             msgSender := and(msgSender, BITMASK_ADDRESS)
1224             // `msgSender == from || msgSender == approvedAddress`.
1225             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1226         }
1227     }
1228 
1229     /**
1230      * @dev Transfers `tokenId` from `from` to `to`.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must be owned by `from`.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) public virtual override {
1244         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1245 
1246         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1247 
1248         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1249 
1250         // The nested ifs save around 20+ gas over a compound boolean condition.
1251         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1252             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1253 
1254         if (to == address(0)) revert TransferToZeroAddress();
1255 
1256         _beforeTokenTransfers(from, to, tokenId, 1);
1257 
1258         // Clear approvals from the previous owner.
1259         assembly {
1260             if approvedAddress {
1261                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1262                 sstore(approvedAddressSlot, 0)
1263             }
1264         }
1265 
1266         // Underflow of the sender"s balance is impossible because we check for
1267         // ownership above and the recipient"s balance can"t realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             // We can directly increment and decrement the balances.
1271             --_packedAddressData[from]; // Updates: `balance -= 1`.
1272             ++_packedAddressData[to]; // Updates: `balance += 1`.
1273 
1274             // Updates:
1275             // - `address` to the next owner.
1276             // - `startTimestamp` to the timestamp of transfering.
1277             // - `burned` to `false`.
1278             // - `nextInitialized` to `true`.
1279             _packedOwnerships[tokenId] = _packOwnershipData(
1280                 to,
1281                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1282             );
1283 
1284             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1285             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1286                 uint256 nextTokenId = tokenId + 1;
1287                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1288                 if (_packedOwnerships[nextTokenId] == 0) {
1289                     // If the next slot is within bounds.
1290                     if (nextTokenId != _currentIndex) {
1291                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1292                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1293                     }
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(from, to, tokenId);
1299         _afterTokenTransfers(from, to, tokenId, 1);
1300     }
1301 
1302     /**
1303      * @dev Equivalent to `_burn(tokenId, false)`.
1304      */
1305     function _burn(uint256 tokenId) internal virtual {
1306         _burn(tokenId, false);
1307     }
1308 
1309     /**
1310      * @dev Destroys `tokenId`.
1311      * The approval is cleared when the token is burned.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1320         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1321 
1322         address from = address(uint160(prevOwnershipPacked));
1323 
1324         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1325 
1326         if (approvalCheck) {
1327             // The nested ifs save around 20+ gas over a compound boolean condition.
1328             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1329                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1330         }
1331 
1332         _beforeTokenTransfers(from, address(0), tokenId, 1);
1333 
1334         // Clear approvals from the previous owner.
1335         assembly {
1336             if approvedAddress {
1337                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1338                 sstore(approvedAddressSlot, 0)
1339             }
1340         }
1341 
1342         // Underflow of the sender"s balance is impossible because we check for
1343         // ownership above and the recipient"s balance can"t realistically overflow.
1344         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1345         unchecked {
1346             // Updates:
1347             // - `balance -= 1`.
1348             // - `numberBurned += 1`.
1349             //
1350             // We can directly decrement the balance, and increment the number burned.
1351             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1352             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1353 
1354             // Updates:
1355             // - `address` to the last owner.
1356             // - `startTimestamp` to the timestamp of burning.
1357             // - `burned` to `true`.
1358             // - `nextInitialized` to `true`.
1359             _packedOwnerships[tokenId] = _packOwnershipData(
1360                 from,
1361                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1362             );
1363 
1364             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1365             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1366                 uint256 nextTokenId = tokenId + 1;
1367                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1368                 if (_packedOwnerships[nextTokenId] == 0) {
1369                     // If the next slot is within bounds.
1370                     if (nextTokenId != _currentIndex) {
1371                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1372                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1373                     }
1374                 }
1375             }
1376         }
1377 
1378         emit Transfer(from, address(0), tokenId);
1379         _afterTokenTransfers(from, address(0), tokenId, 1);
1380 
1381         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1382         unchecked {
1383             _burnCounter++;
1384         }
1385     }
1386 
1387     /**
1388      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1389      *
1390      * @param from address representing the previous owner of the given token ID
1391      * @param to target address that will receive the tokens
1392      * @param tokenId uint256 ID of the token to be transferred
1393      * @param _data bytes optional data to send along with the call
1394      * @return bool whether the call correctly returned the expected magic value
1395      */
1396     function _checkContractOnERC721Received(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) private returns (bool) {
1402         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1403             bytes4 retval
1404         ) {
1405             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1406         } catch (bytes memory reason) {
1407             if (reason.length == 0) {
1408                 revert TransferToNonERC721ReceiverImplementer();
1409             } else {
1410                 assembly {
1411                     revert(add(32, reason), mload(reason))
1412                 }
1413             }
1414         }
1415     }
1416 
1417     /**
1418      * @dev Directly sets the extra data for the ownership data `index`.
1419      */
1420     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1421         uint256 packed = _packedOwnerships[index];
1422         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1423         uint256 extraDataCasted;
1424         // Cast `extraData` with assembly to avoid redundant masking.
1425         assembly {
1426             extraDataCasted := extraData
1427         }
1428         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1429         _packedOwnerships[index] = packed;
1430     }
1431 
1432     /**
1433      * @dev Returns the next extra data for the packed ownership data.
1434      * The returned result is shifted into position.
1435      */
1436     function _nextExtraData(
1437         address from,
1438         address to,
1439         uint256 prevOwnershipPacked
1440     ) private view returns (uint256) {
1441         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1442         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1443     }
1444 
1445     /**
1446      * @dev Called during each token transfer to set the 24bit `extraData` field.
1447      * Intended to be overridden by the cosumer contract.
1448      *
1449      * `previousExtraData` - the value of `extraData` before transfer.
1450      *
1451      * Calling conditions:
1452      *
1453      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1454      * transferred to `to`.
1455      * - When `from` is zero, `tokenId` will be minted for `to`.
1456      * - When `to` is zero, `tokenId` will be burned by `from`.
1457      * - `from` and `to` are never both zero.
1458      */
1459     function _extraData(
1460         address from,
1461         address to,
1462         uint24 previousExtraData
1463     ) internal view virtual returns (uint24) {}
1464 
1465     /**
1466      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1467      * This includes minting.
1468      * And also called before burning one token.
1469      *
1470      * startTokenId - the first token id to be transferred
1471      * quantity - the amount to be transferred
1472      *
1473      * Calling conditions:
1474      *
1475      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1476      * transferred to `to`.
1477      * - When `from` is zero, `tokenId` will be minted for `to`.
1478      * - When `to` is zero, `tokenId` will be burned by `from`.
1479      * - `from` and `to` are never both zero.
1480      */
1481     function _beforeTokenTransfers(
1482         address from,
1483         address to,
1484         uint256 startTokenId,
1485         uint256 quantity
1486     ) internal virtual {}
1487 
1488     /**
1489      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1490      * This includes minting.
1491      * And also called after one token has been burned.
1492      *
1493      * startTokenId - the first token id to be transferred
1494      * quantity - the amount to be transferred
1495      *
1496      * Calling conditions:
1497      *
1498      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1499      * transferred to `to`.
1500      * - When `from` is zero, `tokenId` has been minted for `to`.
1501      * - When `to` is zero, `tokenId` has been burned by `from`.
1502      * - `from` and `to` are never both zero.
1503      */
1504     function _afterTokenTransfers(
1505         address from,
1506         address to,
1507         uint256 startTokenId,
1508         uint256 quantity
1509     ) internal virtual {}
1510 
1511     /**
1512      * @dev Returns the message sender (defaults to `msg.sender`).
1513      *
1514      * If you are writing GSN compatible contracts, you need to override this function.
1515      */
1516     function _msgSenderERC721A() internal view virtual returns (address) {
1517         return msg.sender;
1518     }
1519 
1520     /**
1521      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1522      */
1523     function _toString(uint256 value) internal pure returns (string memory ptr) {
1524         assembly {
1525             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1526             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1527             // We will need 1 32-byte word to store the length,
1528             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1529             ptr := add(mload(0x40), 128)
1530             // Update the free memory pointer to allocate.
1531             mstore(0x40, ptr)
1532 
1533             // Cache the end of the memory to calculate the length later.
1534             let end := ptr
1535 
1536             // We write the string from the rightmost digit to the leftmost digit.
1537             // The following is essentially a do-while loop that also handles the zero case.
1538             // Costs a bit more than early returning for the zero case,
1539             // but cheaper in terms of deployment and overall runtime costs.
1540             for {
1541                 // Initialize and perform the first pass without check.
1542                 let temp := value
1543                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1544                 ptr := sub(ptr, 1)
1545                 // Write the character to the pointer. 48 is the ASCII index of "0".
1546                 mstore8(ptr, add(48, mod(temp, 10)))
1547                 temp := div(temp, 10)
1548             } temp {
1549                 // Keep dividing `temp` until zero.
1550                 temp := div(temp, 10)
1551             } {
1552                 // Body of the for loop.
1553                 ptr := sub(ptr, 1)
1554                 mstore8(ptr, add(48, mod(temp, 10)))
1555             }
1556 
1557             let length := sub(end, ptr)
1558             // Move the pointer 32 bytes leftwards to make room for the length.
1559             ptr := sub(ptr, 32)
1560             // Store the length.
1561             mstore(ptr, length)
1562         }
1563     }
1564 }
1565 
1566 
1567 
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 /**
1572  * @dev String operations.
1573  */
1574 library Strings {
1575     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1576 
1577     /**
1578      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1579      */
1580     function toString(uint256 value) internal pure returns (string memory) {
1581         // Inspired by OraclizeAPI"s implementation - MIT licence
1582         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1583 
1584         if (value == 0) {
1585             return "0";
1586         }
1587         uint256 temp = value;
1588         uint256 digits;
1589         while (temp != 0) {
1590             digits++;
1591             temp /= 10;
1592         }
1593         bytes memory buffer = new bytes(digits);
1594         while (value != 0) {
1595             digits -= 1;
1596             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1597             value /= 10;
1598         }
1599         return string(buffer);
1600     }
1601 
1602     /**
1603      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1604      */
1605     function toHexString(uint256 value) internal pure returns (string memory) {
1606         if (value == 0) {
1607             return "0x00";
1608         }
1609         uint256 temp = value;
1610         uint256 length = 0;
1611         while (temp != 0) {
1612             length++;
1613             temp >>= 8;
1614         }
1615         return toHexString(value, length);
1616     }
1617 
1618     /**
1619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1620      */
1621     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1622         bytes memory buffer = new bytes(2 * length + 2);
1623         buffer[0] = "0";
1624         buffer[1] = "x";
1625         for (uint256 i = 2 * length + 1; i > 1; --i) {
1626             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1627             value >>= 4;
1628         }
1629         require(value == 0, "Strings: hex length insufficient");
1630         return string(buffer);
1631     }
1632 }
1633 
1634 
1635 pragma solidity ^0.8.0;
1636 
1637 /**
1638  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1639  *
1640  * These functions can be used to verify that a message was signed by the holder
1641  * of the private keys of a given address.
1642  */
1643 library ECDSA {
1644     enum RecoverError {
1645         NoError,
1646         InvalidSignature,
1647         InvalidSignatureLength,
1648         InvalidSignatureS,
1649         InvalidSignatureV // Deprecated in v4.8
1650     }
1651 
1652     function _throwError(RecoverError error) private pure {
1653         if (error == RecoverError.NoError) {
1654             return; // no error: do nothing
1655         } else if (error == RecoverError.InvalidSignature) {
1656             revert("ECDSA: invalid signature");
1657         } else if (error == RecoverError.InvalidSignatureLength) {
1658             revert("ECDSA: invalid signature length");
1659         } else if (error == RecoverError.InvalidSignatureS) {
1660             revert("ECDSA: invalid signature 's' value");
1661         }
1662     }
1663 
1664     /**
1665      * @dev Returns the address that signed a hashed message (`hash`) with
1666      * `signature` or error string. This address can then be used for verification purposes.
1667      *
1668      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1669      * this function rejects them by requiring the `s` value to be in the lower
1670      * half order, and the `v` value to be either 27 or 28.
1671      *
1672      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1673      * verification to be secure: it is possible to craft signatures that
1674      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1675      * this is by receiving a hash of the original message (which may otherwise
1676      * be too long), and then calling {toEthSignedMessageHash} on it.
1677      *
1678      * Documentation for signature generation:
1679      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1680      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1681      *
1682      * _Available since v4.3._
1683      */
1684     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1685         if (signature.length == 65) {
1686             bytes32 r;
1687             bytes32 s;
1688             uint8 v;
1689             // ecrecover takes the signature parameters, and the only way to get them
1690             // currently is to use assembly.
1691             /// @solidity memory-safe-assembly
1692             assembly {
1693                 r := mload(add(signature, 0x20))
1694                 s := mload(add(signature, 0x40))
1695                 v := byte(0, mload(add(signature, 0x60)))
1696             }
1697             return tryRecover(hash, v, r, s);
1698         } else {
1699             return (address(0), RecoverError.InvalidSignatureLength);
1700         }
1701     }
1702 
1703     /**
1704      * @dev Returns the address that signed a hashed message (`hash`) with
1705      * `signature`. This address can then be used for verification purposes.
1706      *
1707      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1708      * this function rejects them by requiring the `s` value to be in the lower
1709      * half order, and the `v` value to be either 27 or 28.
1710      *
1711      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1712      * verification to be secure: it is possible to craft signatures that
1713      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1714      * this is by receiving a hash of the original message (which may otherwise
1715      * be too long), and then calling {toEthSignedMessageHash} on it.
1716      */
1717     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1718         (address recovered, RecoverError error) = tryRecover(hash, signature);
1719         _throwError(error);
1720         return recovered;
1721     }
1722 
1723     /**
1724      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1725      *
1726      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1727      *
1728      * _Available since v4.3._
1729      */
1730     function tryRecover(
1731         bytes32 hash,
1732         bytes32 r,
1733         bytes32 vs
1734     ) internal pure returns (address, RecoverError) {
1735         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1736         uint8 v = uint8((uint256(vs) >> 255) + 27);
1737         return tryRecover(hash, v, r, s);
1738     }
1739 
1740     /**
1741      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1742      *
1743      * _Available since v4.2._
1744      */
1745     function recover(
1746         bytes32 hash,
1747         bytes32 r,
1748         bytes32 vs
1749     ) internal pure returns (address) {
1750         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1751         _throwError(error);
1752         return recovered;
1753     }
1754 
1755     /**
1756      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1757      * `r` and `s` signature fields separately.
1758      *
1759      * _Available since v4.3._
1760      */
1761     function tryRecover(
1762         bytes32 hash,
1763         uint8 v,
1764         bytes32 r,
1765         bytes32 s
1766     ) internal pure returns (address, RecoverError) {
1767         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1768         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1769         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1770         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1771         //
1772         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1773         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1774         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1775         // these malleable signatures as well.
1776         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1777             return (address(0), RecoverError.InvalidSignatureS);
1778         }
1779 
1780         // If the signature is valid (and not malleable), return the signer address
1781         address signer = ecrecover(hash, v, r, s);
1782         if (signer == address(0)) {
1783             return (address(0), RecoverError.InvalidSignature);
1784         }
1785 
1786         return (signer, RecoverError.NoError);
1787     }
1788 
1789     /**
1790      * @dev Overload of {ECDSA-recover} that receives the `v`,
1791      * `r` and `s` signature fields separately.
1792      */
1793     function recover(
1794         bytes32 hash,
1795         uint8 v,
1796         bytes32 r,
1797         bytes32 s
1798     ) internal pure returns (address) {
1799         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1800         _throwError(error);
1801         return recovered;
1802     }
1803 
1804     /**
1805      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1806      * produces hash corresponding to the one signed with the
1807      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1808      * JSON-RPC method as part of EIP-191.
1809      *
1810      * See {recover}.
1811      */
1812     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1813         // 32 is the length in bytes of hash,
1814         // enforced by the type signature above
1815         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1816     }
1817 
1818     /**
1819      * @dev Returns an Ethereum Signed Message, created from `s`. This
1820      * produces hash corresponding to the one signed with the
1821      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1822      * JSON-RPC method as part of EIP-191.
1823      *
1824      * See {recover}.
1825      */
1826     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1827         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1828     }
1829 
1830     /**
1831      * @dev Returns an Ethereum Signed Typed Data, created from a
1832      * `domainSeparator` and a `structHash`. This produces hash corresponding
1833      * to the one signed with the
1834      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1835      * JSON-RPC method as part of EIP-712.
1836      *
1837      * See {recover}.
1838      */
1839     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1840         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1841     }
1842 }
1843 
1844 pragma solidity ^0.8.0;
1845 
1846 
1847 
1848 contract Skydancers is ERC721A, Ownable {
1849 	using Strings for uint;
1850     using ECDSA for bytes32;
1851 
1852 	uint public constant maxSupply = 5555;
1853     uint public constant maxPerWalletWhitelist = 1;
1854     uint public constant maxPerWalletPublic = 4;
1855     uint public constant priceWhitelist = 0 ether;
1856     uint public constant pricePublic = 0.04 ether;
1857 
1858     bool public revealed = false;
1859     bool public isWhitelistMintEnabled = false;
1860 	bool public isPaused = true;
1861 
1862     string public _baseURL = "";
1863     string public _unrevealedURL = "";
1864 
1865 	mapping(address => uint) private _walletMintedCount;
1866     
1867     bytes32 immutable public merkleRoot;//0xf3245c896ff0766793f684a207a56b641704b13ea50b655f42c69d3e11f09c0f 
1868     
1869 	constructor(bytes32 _merkleRoot)
1870 	ERC721A("Skydancers", "SD") { 
1871         merkleRoot = _merkleRoot;
1872     }
1873 
1874 	function _baseURI() internal view override returns (string memory) {
1875 		return _baseURL;
1876 	}
1877 
1878 	function _startTokenId() internal pure override returns (uint) {
1879 		return 1;
1880 	}
1881 
1882 	function contractURI() public pure returns (string memory) {
1883 		return "";
1884 	}
1885 
1886     function mintedCount(address owner) external view returns (uint) {
1887         return _walletMintedCount[owner];
1888     }
1889 
1890     function PublicMint(uint256 quantity) external payable {
1891 		require(!isPaused, "Sales are off");
1892         require(msg.value >= pricePublic, "Transaction value is underpriced");
1893         require(_totalMinted() + quantity <= maxSupply,"Exceeds max supply");
1894         require(quantity <= maxPerWalletPublic,"Exceeds max per transaction");
1895         require(_walletMintedCount[msg.sender] + quantity <= maxPerWalletPublic,"Exceeds max per wallet");
1896 
1897 		_walletMintedCount[msg.sender] += quantity;
1898 		_safeMint(msg.sender, quantity);
1899 	}
1900 
1901     function WhitelistMint(uint256 quantity, bytes32[] calldata merkleProof) external payable {
1902 		require(!isPaused, "Sales are off");
1903         require(isWhitelistMintEnabled, "Whitelist mint has not started yet");
1904         require(_totalMinted() + quantity <= maxSupply,"Exceeds max supply");
1905         require(quantity <= maxPerWalletWhitelist,"Exceeds max per transaction");
1906         require(_walletMintedCount[msg.sender] + quantity <= maxPerWalletWhitelist,"Exceeds max per wallet");
1907         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))) == true, "invalid merkle proof");
1908 
1909 		_walletMintedCount[msg.sender] += quantity;
1910 		_safeMint(msg.sender, quantity);
1911 	}
1912 
1913     function tokenURI(uint256 tokenId)
1914     public
1915     view
1916     virtual
1917     override
1918     returns(string memory) {
1919         require(
1920             _exists(tokenId),
1921             "ERC721Metadata: URI query for nonexistent token");
1922 
1923         if (revealed == false) {
1924             return _unrevealedURL;
1925         }
1926 
1927         string memory currentBaseURI = _baseURI();
1928         return bytes(currentBaseURI).length > 0
1929          ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1930          : "";
1931     }
1932 
1933     function reveal()public onlyOwner {
1934         revealed = true;
1935     }
1936 
1937     function setBaseUri(string memory url) external onlyOwner {
1938 	    _baseURL = url;
1939 	}
1940 
1941     function setUnrevealedUri(string memory url) external onlyOwner {
1942         _unrevealedURL = url;
1943     }
1944 
1945     function flipWhitelistMintEnabled() external onlyOwner {
1946         isWhitelistMintEnabled = !isWhitelistMintEnabled;
1947     }
1948     
1949 	function start(bool paused) external onlyOwner {
1950 	    isPaused = paused;
1951 	}
1952 
1953 	function withdraw() external onlyOwner {
1954 		(bool success, ) = payable(msg.sender).call{
1955             value: address(this).balance
1956         }("");
1957         require(success);
1958 	}
1959 }