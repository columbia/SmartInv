1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _transferOwnership(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Internal function without access restriction.
164      */
165     function _transferOwnership(address newOwner) internal virtual {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev These functions deal with verification of Merkle Trees proofs.
181  *
182  * The proofs can be generated using the JavaScript library
183  * https://github.com/miguelmota/merkletreejs[merkletreejs].
184  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
185  *
186  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
187  *
188  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
189  * hashing, or use a hash function other than keccak256 for hashing leaves.
190  * This is because the concatenation of a sorted pair of internal nodes in
191  * the merkle tree could be reinterpreted as a leaf value.
192  */
193 library MerkleProof {
194     /**
195      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
196      * defined by `root`. For this, a `proof` must be provided, containing
197      * sibling hashes on the branch from the leaf to the root of the tree. Each
198      * pair of leaves and each pair of pre-images are assumed to be sorted.
199      */
200     function verify(
201         bytes32[] memory proof,
202         bytes32 root,
203         bytes32 leaf
204     ) internal pure returns (bool) {
205         return processProof(proof, leaf) == root;
206     }
207 
208     /**
209      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
210      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
211      * hash matches the root of the tree. When processing the proof, the pairs
212      * of leafs & pre-images are assumed to be sorted.
213      *
214      * _Available since v4.4._
215      */
216     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
217         bytes32 computedHash = leaf;
218         for (uint256 i = 0; i < proof.length; i++) {
219             bytes32 proofElement = proof[i];
220             if (computedHash <= proofElement) {
221                 // Hash(current computed hash + current element of the proof)
222                 computedHash = _efficientHash(computedHash, proofElement);
223             } else {
224                 // Hash(current element of the proof + current computed hash)
225                 computedHash = _efficientHash(proofElement, computedHash);
226             }
227         }
228         return computedHash;
229     }
230 
231     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
232         assembly {
233             mstore(0x00, a)
234             mstore(0x20, b)
235             value := keccak256(0x00, 0x40)
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Strings.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev String operations.
249  */
250 library Strings {
251     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
255      */
256     function toString(uint256 value) internal pure returns (string memory) {
257         // Inspired by OraclizeAPI's implementation - MIT licence
258         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
259 
260         if (value == 0) {
261             return "0";
262         }
263         uint256 temp = value;
264         uint256 digits;
265         while (temp != 0) {
266             digits++;
267             temp /= 10;
268         }
269         bytes memory buffer = new bytes(digits);
270         while (value != 0) {
271             digits -= 1;
272             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
273             value /= 10;
274         }
275         return string(buffer);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
280      */
281     function toHexString(uint256 value) internal pure returns (string memory) {
282         if (value == 0) {
283             return "0x00";
284         }
285         uint256 temp = value;
286         uint256 length = 0;
287         while (temp != 0) {
288             length++;
289             temp >>= 8;
290         }
291         return toHexString(value, length);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
296      */
297     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
298         bytes memory buffer = new bytes(2 * length + 2);
299         buffer[0] = "0";
300         buffer[1] = "x";
301         for (uint256 i = 2 * length + 1; i > 1; --i) {
302             buffer[i] = _HEX_SYMBOLS[value & 0xf];
303             value >>= 4;
304         }
305         require(value == 0, "Strings: hex length insufficient");
306         return string(buffer);
307     }
308 }
309 
310 // File: erc721a/contracts/IERC721A.sol
311 
312 
313 // ERC721A Contracts v4.1.0
314 // Creator: Chiru Labs
315 
316 pragma solidity ^0.8.4;
317 
318 /**
319  * @dev Interface of an ERC721A compliant contract.
320  */
321 interface IERC721A {
322     /**
323      * The caller must own the token or be an approved operator.
324      */
325     error ApprovalCallerNotOwnerNorApproved();
326 
327     /**
328      * The token does not exist.
329      */
330     error ApprovalQueryForNonexistentToken();
331 
332     /**
333      * The caller cannot approve to their own address.
334      */
335     error ApproveToCaller();
336 
337     /**
338      * Cannot query the balance for the zero address.
339      */
340     error BalanceQueryForZeroAddress();
341 
342     /**
343      * Cannot mint to the zero address.
344      */
345     error MintToZeroAddress();
346 
347     /**
348      * The quantity of tokens minted must be more than zero.
349      */
350     error MintZeroQuantity();
351 
352     /**
353      * The token does not exist.
354      */
355     error OwnerQueryForNonexistentToken();
356 
357     /**
358      * The caller must own the token or be an approved operator.
359      */
360     error TransferCallerNotOwnerNorApproved();
361 
362     /**
363      * The token must be owned by `from`.
364      */
365     error TransferFromIncorrectOwner();
366 
367     /**
368      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
369      */
370     error TransferToNonERC721ReceiverImplementer();
371 
372     /**
373      * Cannot transfer to the zero address.
374      */
375     error TransferToZeroAddress();
376 
377     /**
378      * The token does not exist.
379      */
380     error URIQueryForNonexistentToken();
381 
382     /**
383      * The `quantity` minted with ERC2309 exceeds the safety limit.
384      */
385     error MintERC2309QuantityExceedsLimit();
386 
387     /**
388      * The `extraData` cannot be set on an unintialized ownership slot.
389      */
390     error OwnershipNotInitializedForExtraData();
391 
392     struct TokenOwnership {
393         // The address of the owner.
394         address addr;
395         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
396         uint64 startTimestamp;
397         // Whether the token has been burned.
398         bool burned;
399         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
400         uint24 extraData;
401     }
402 
403     /**
404      * @dev Returns the total amount of tokens stored by the contract.
405      *
406      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
407      */
408     function totalSupply() external view returns (uint256);
409 
410     // ==============================
411     //            IERC165
412     // ==============================
413 
414     /**
415      * @dev Returns true if this contract implements the interface defined by
416      * `interfaceId`. See the corresponding
417      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
418      * to learn more about how these ids are created.
419      *
420      * This function call must use less than 30 000 gas.
421      */
422     function supportsInterface(bytes4 interfaceId) external view returns (bool);
423 
424     // ==============================
425     //            IERC721
426     // ==============================
427 
428     /**
429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
435      */
436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
440      */
441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
442 
443     /**
444      * @dev Returns the number of tokens in ``owner``'s account.
445      */
446     function balanceOf(address owner) external view returns (uint256 balance);
447 
448     /**
449      * @dev Returns the owner of the `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function ownerOf(uint256 tokenId) external view returns (address owner);
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     // ==============================
561     //        IERC721Metadata
562     // ==============================
563 
564     /**
565      * @dev Returns the token collection name.
566      */
567     function name() external view returns (string memory);
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() external view returns (string memory);
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) external view returns (string memory);
578 
579     // ==============================
580     //            IERC2309
581     // ==============================
582 
583     /**
584      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
585      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
586      */
587     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
588 }
589 
590 // File: erc721a/contracts/ERC721A.sol
591 
592 
593 // ERC721A Contracts v4.1.0
594 // Creator: Chiru Labs
595 
596 pragma solidity ^0.8.4;
597 
598 
599 /**
600  * @dev ERC721 token receiver interface.
601  */
602 interface ERC721A__IERC721Receiver {
603     function onERC721Received(
604         address operator,
605         address from,
606         uint256 tokenId,
607         bytes calldata data
608     ) external returns (bytes4);
609 }
610 
611 /**
612  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
613  * including the Metadata extension. Built to optimize for lower gas during batch mints.
614  *
615  * Assumes serials are sequentially minted starting at `_startTokenId()`
616  * (defaults to 0, e.g. 0, 1, 2, 3..).
617  *
618  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
619  *
620  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
621  */
622 contract ERC721A is IERC721A {
623     // Mask of an entry in packed address data.
624     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
625 
626     // The bit position of `numberMinted` in packed address data.
627     uint256 private constant BITPOS_NUMBER_MINTED = 64;
628 
629     // The bit position of `numberBurned` in packed address data.
630     uint256 private constant BITPOS_NUMBER_BURNED = 128;
631 
632     // The bit position of `aux` in packed address data.
633     uint256 private constant BITPOS_AUX = 192;
634 
635     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
636     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
637 
638     // The bit position of `startTimestamp` in packed ownership.
639     uint256 private constant BITPOS_START_TIMESTAMP = 160;
640 
641     // The bit mask of the `burned` bit in packed ownership.
642     uint256 private constant BITMASK_BURNED = 1 << 224;
643 
644     // The bit position of the `nextInitialized` bit in packed ownership.
645     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
646 
647     // The bit mask of the `nextInitialized` bit in packed ownership.
648     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
649 
650     // The bit position of `extraData` in packed ownership.
651     uint256 private constant BITPOS_EXTRA_DATA = 232;
652 
653     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
654     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
655 
656     // The mask of the lower 160 bits for addresses.
657     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
658 
659     // The maximum `quantity` that can be minted with `_mintERC2309`.
660     // This limit is to prevent overflows on the address data entries.
661     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
662     // is required to cause an overflow, which is unrealistic.
663     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
664 
665     // The tokenId of the next token to be minted.
666     uint256 private _currentIndex;
667 
668     // The number of tokens burned.
669     uint256 private _burnCounter;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to ownership details
678     // An empty struct value does not necessarily mean the token is unowned.
679     // See `_packedOwnershipOf` implementation for details.
680     //
681     // Bits Layout:
682     // - [0..159]   `addr`
683     // - [160..223] `startTimestamp`
684     // - [224]      `burned`
685     // - [225]      `nextInitialized`
686     // - [232..255] `extraData`
687     mapping(uint256 => uint256) private _packedOwnerships;
688 
689     // Mapping owner address to address data.
690     //
691     // Bits Layout:
692     // - [0..63]    `balance`
693     // - [64..127]  `numberMinted`
694     // - [128..191] `numberBurned`
695     // - [192..255] `aux`
696     mapping(address => uint256) private _packedAddressData;
697 
698     // Mapping from token ID to approved address.
699     mapping(uint256 => address) private _tokenApprovals;
700 
701     // Mapping from owner to operator approvals
702     mapping(address => mapping(address => bool)) private _operatorApprovals;
703 
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707         _currentIndex = _startTokenId();
708     }
709 
710     /**
711      * @dev Returns the starting token ID.
712      * To change the starting token ID, please override this function.
713      */
714     function _startTokenId() internal view virtual returns (uint256) {
715         return 0;
716     }
717 
718     /**
719      * @dev Returns the next token ID to be minted.
720      */
721     function _nextTokenId() internal view returns (uint256) {
722         return _currentIndex;
723     }
724 
725     /**
726      * @dev Returns the total number of tokens in existence.
727      * Burned tokens will reduce the count.
728      * To get the total number of tokens minted, please see `_totalMinted`.
729      */
730     function totalSupply() public view override returns (uint256) {
731         // Counter underflow is impossible as _burnCounter cannot be incremented
732         // more than `_currentIndex - _startTokenId()` times.
733         unchecked {
734             return _currentIndex - _burnCounter - _startTokenId();
735         }
736     }
737 
738     /**
739      * @dev Returns the total amount of tokens minted in the contract.
740      */
741     function _totalMinted() internal view returns (uint256) {
742         // Counter underflow is impossible as _currentIndex does not decrement,
743         // and it is initialized to `_startTokenId()`
744         unchecked {
745             return _currentIndex - _startTokenId();
746         }
747     }
748 
749     /**
750      * @dev Returns the total number of tokens burned.
751      */
752     function _totalBurned() internal view returns (uint256) {
753         return _burnCounter;
754     }
755 
756     /**
757      * @dev See {IERC165-supportsInterface}.
758      */
759     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
760         // The interface IDs are constants representing the first 4 bytes of the XOR of
761         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
762         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
763         return
764             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
765             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
766             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
767     }
768 
769     /**
770      * @dev See {IERC721-balanceOf}.
771      */
772     function balanceOf(address owner) public view override returns (uint256) {
773         if (owner == address(0)) revert BalanceQueryForZeroAddress();
774         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
775     }
776 
777     /**
778      * Returns the number of tokens minted by `owner`.
779      */
780     function _numberMinted(address owner) internal view returns (uint256) {
781         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
782     }
783 
784     /**
785      * Returns the number of tokens burned by or on behalf of `owner`.
786      */
787     function _numberBurned(address owner) internal view returns (uint256) {
788         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
789     }
790 
791     /**
792      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
793      */
794     function _getAux(address owner) internal view returns (uint64) {
795         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
796     }
797 
798     /**
799      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
800      * If there are multiple variables, please pack them into a uint64.
801      */
802     function _setAux(address owner, uint64 aux) internal {
803         uint256 packed = _packedAddressData[owner];
804         uint256 auxCasted;
805         // Cast `aux` with assembly to avoid redundant masking.
806         assembly {
807             auxCasted := aux
808         }
809         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
810         _packedAddressData[owner] = packed;
811     }
812 
813     /**
814      * Returns the packed ownership data of `tokenId`.
815      */
816     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
817         uint256 curr = tokenId;
818 
819         unchecked {
820             if (_startTokenId() <= curr)
821                 if (curr < _currentIndex) {
822                     uint256 packed = _packedOwnerships[curr];
823                     // If not burned.
824                     if (packed & BITMASK_BURNED == 0) {
825                         // Invariant:
826                         // There will always be an ownership that has an address and is not burned
827                         // before an ownership that does not have an address and is not burned.
828                         // Hence, curr will not underflow.
829                         //
830                         // We can directly compare the packed value.
831                         // If the address is zero, packed is zero.
832                         while (packed == 0) {
833                             packed = _packedOwnerships[--curr];
834                         }
835                         return packed;
836                     }
837                 }
838         }
839         revert OwnerQueryForNonexistentToken();
840     }
841 
842     /**
843      * Returns the unpacked `TokenOwnership` struct from `packed`.
844      */
845     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
846         ownership.addr = address(uint160(packed));
847         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
848         ownership.burned = packed & BITMASK_BURNED != 0;
849         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
850     }
851 
852     /**
853      * Returns the unpacked `TokenOwnership` struct at `index`.
854      */
855     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
856         return _unpackedOwnership(_packedOwnerships[index]);
857     }
858 
859     /**
860      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
861      */
862     function _initializeOwnershipAt(uint256 index) internal {
863         if (_packedOwnerships[index] == 0) {
864             _packedOwnerships[index] = _packedOwnershipOf(index);
865         }
866     }
867 
868     /**
869      * Gas spent here starts off proportional to the maximum mint batch size.
870      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
871      */
872     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
873         return _unpackedOwnership(_packedOwnershipOf(tokenId));
874     }
875 
876     /**
877      * @dev Packs ownership data into a single uint256.
878      */
879     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
880         assembly {
881             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
882             owner := and(owner, BITMASK_ADDRESS)
883             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
884             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
885         }
886     }
887 
888     /**
889      * @dev See {IERC721-ownerOf}.
890      */
891     function ownerOf(uint256 tokenId) public view override returns (address) {
892         return address(uint160(_packedOwnershipOf(tokenId)));
893     }
894 
895     /**
896      * @dev See {IERC721Metadata-name}.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-symbol}.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-tokenURI}.
911      */
912     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
913         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
914 
915         string memory baseURI = _baseURI();
916         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
917     }
918 
919     /**
920      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
921      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
922      * by default, it can be overridden in child contracts.
923      */
924     function _baseURI() internal view virtual returns (string memory) {
925         return '';
926     }
927 
928     /**
929      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
930      */
931     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
932         // For branchless setting of the `nextInitialized` flag.
933         assembly {
934             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
935             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
936         }
937     }
938 
939     /**
940      * @dev See {IERC721-approve}.
941      */
942     function approve(address to, uint256 tokenId) public override {
943         address owner = ownerOf(tokenId);
944 
945         if (_msgSenderERC721A() != owner)
946             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
947                 revert ApprovalCallerNotOwnerNorApproved();
948             }
949 
950         _tokenApprovals[tokenId] = to;
951         emit Approval(owner, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-getApproved}.
956      */
957     function getApproved(uint256 tokenId) public view override returns (address) {
958         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
959 
960         return _tokenApprovals[tokenId];
961     }
962 
963     /**
964      * @dev See {IERC721-setApprovalForAll}.
965      */
966     function setApprovalForAll(address operator, bool approved) public virtual override {
967         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
968 
969         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
970         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
971     }
972 
973     /**
974      * @dev See {IERC721-isApprovedForAll}.
975      */
976     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
977         return _operatorApprovals[owner][operator];
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) public virtual override {
988         safeTransferFrom(from, to, tokenId, '');
989     }
990 
991     /**
992      * @dev See {IERC721-safeTransferFrom}.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) public virtual override {
1000         transferFrom(from, to, tokenId);
1001         if (to.code.length != 0)
1002             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1003                 revert TransferToNonERC721ReceiverImplementer();
1004             }
1005     }
1006 
1007     /**
1008      * @dev Returns whether `tokenId` exists.
1009      *
1010      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1011      *
1012      * Tokens start existing when they are minted (`_mint`),
1013      */
1014     function _exists(uint256 tokenId) internal view returns (bool) {
1015         return
1016             _startTokenId() <= tokenId &&
1017             tokenId < _currentIndex && // If within bounds,
1018             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1019     }
1020 
1021     /**
1022      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1023      */
1024     function _safeMint(address to, uint256 quantity) internal {
1025         _safeMint(to, quantity, '');
1026     }
1027 
1028     /**
1029      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - If `to` refers to a smart contract, it must implement
1034      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1035      * - `quantity` must be greater than 0.
1036      *
1037      * See {_mint}.
1038      *
1039      * Emits a {Transfer} event for each mint.
1040      */
1041     function _safeMint(
1042         address to,
1043         uint256 quantity,
1044         bytes memory _data
1045     ) internal {
1046         _mint(to, quantity);
1047 
1048         unchecked {
1049             if (to.code.length != 0) {
1050                 uint256 end = _currentIndex;
1051                 uint256 index = end - quantity;
1052                 do {
1053                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1054                         revert TransferToNonERC721ReceiverImplementer();
1055                     }
1056                 } while (index < end);
1057                 // Reentrancy protection.
1058                 if (_currentIndex != end) revert();
1059             }
1060         }
1061     }
1062 
1063     /**
1064      * @dev Mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event for each mint.
1072      */
1073     function _mint(address to, uint256 quantity) internal {
1074         uint256 startTokenId = _currentIndex;
1075         if (to == address(0)) revert MintToZeroAddress();
1076         if (quantity == 0) revert MintZeroQuantity();
1077 
1078         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1079 
1080         // Overflows are incredibly unrealistic.
1081         // `balance` and `numberMinted` have a maximum limit of 2**64.
1082         // `tokenId` has a maximum limit of 2**256.
1083         unchecked {
1084             // Updates:
1085             // - `balance += quantity`.
1086             // - `numberMinted += quantity`.
1087             //
1088             // We can directly add to the `balance` and `numberMinted`.
1089             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1090 
1091             // Updates:
1092             // - `address` to the owner.
1093             // - `startTimestamp` to the timestamp of minting.
1094             // - `burned` to `false`.
1095             // - `nextInitialized` to `quantity == 1`.
1096             _packedOwnerships[startTokenId] = _packOwnershipData(
1097                 to,
1098                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1099             );
1100 
1101             uint256 tokenId = startTokenId;
1102             uint256 end = startTokenId + quantity;
1103             do {
1104                 emit Transfer(address(0), to, tokenId++);
1105             } while (tokenId < end);
1106 
1107             _currentIndex = end;
1108         }
1109         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1110     }
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * This function is intended for efficient minting only during contract creation.
1116      *
1117      * It emits only one {ConsecutiveTransfer} as defined in
1118      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1119      * instead of a sequence of {Transfer} event(s).
1120      *
1121      * Calling this function outside of contract creation WILL make your contract
1122      * non-compliant with the ERC721 standard.
1123      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1124      * {ConsecutiveTransfer} event is only permissible during contract creation.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {ConsecutiveTransfer} event.
1132      */
1133     function _mintERC2309(address to, uint256 quantity) internal {
1134         uint256 startTokenId = _currentIndex;
1135         if (to == address(0)) revert MintToZeroAddress();
1136         if (quantity == 0) revert MintZeroQuantity();
1137         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1142         unchecked {
1143             // Updates:
1144             // - `balance += quantity`.
1145             // - `numberMinted += quantity`.
1146             //
1147             // We can directly add to the `balance` and `numberMinted`.
1148             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1149 
1150             // Updates:
1151             // - `address` to the owner.
1152             // - `startTimestamp` to the timestamp of minting.
1153             // - `burned` to `false`.
1154             // - `nextInitialized` to `quantity == 1`.
1155             _packedOwnerships[startTokenId] = _packOwnershipData(
1156                 to,
1157                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1158             );
1159 
1160             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1161 
1162             _currentIndex = startTokenId + quantity;
1163         }
1164         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1165     }
1166 
1167     /**
1168      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1169      */
1170     function _getApprovedAddress(uint256 tokenId)
1171         private
1172         view
1173         returns (uint256 approvedAddressSlot, address approvedAddress)
1174     {
1175         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1176         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1177         assembly {
1178             // Compute the slot.
1179             mstore(0x00, tokenId)
1180             mstore(0x20, tokenApprovalsPtr.slot)
1181             approvedAddressSlot := keccak256(0x00, 0x40)
1182             // Load the slot's value from storage.
1183             approvedAddress := sload(approvedAddressSlot)
1184         }
1185     }
1186 
1187     /**
1188      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1189      */
1190     function _isOwnerOrApproved(
1191         address approvedAddress,
1192         address from,
1193         address msgSender
1194     ) private pure returns (bool result) {
1195         assembly {
1196             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1197             from := and(from, BITMASK_ADDRESS)
1198             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1199             msgSender := and(msgSender, BITMASK_ADDRESS)
1200             // `msgSender == from || msgSender == approvedAddress`.
1201             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1202         }
1203     }
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must be owned by `from`.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function transferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) public virtual override {
1220         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1221 
1222         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1223 
1224         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1225 
1226         // The nested ifs save around 20+ gas over a compound boolean condition.
1227         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1228             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1229 
1230         if (to == address(0)) revert TransferToZeroAddress();
1231 
1232         _beforeTokenTransfers(from, to, tokenId, 1);
1233 
1234         // Clear approvals from the previous owner.
1235         assembly {
1236             if approvedAddress {
1237                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1238                 sstore(approvedAddressSlot, 0)
1239             }
1240         }
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1245         unchecked {
1246             // We can directly increment and decrement the balances.
1247             --_packedAddressData[from]; // Updates: `balance -= 1`.
1248             ++_packedAddressData[to]; // Updates: `balance += 1`.
1249 
1250             // Updates:
1251             // - `address` to the next owner.
1252             // - `startTimestamp` to the timestamp of transfering.
1253             // - `burned` to `false`.
1254             // - `nextInitialized` to `true`.
1255             _packedOwnerships[tokenId] = _packOwnershipData(
1256                 to,
1257                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1258             );
1259 
1260             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1261             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1262                 uint256 nextTokenId = tokenId + 1;
1263                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1264                 if (_packedOwnerships[nextTokenId] == 0) {
1265                     // If the next slot is within bounds.
1266                     if (nextTokenId != _currentIndex) {
1267                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1268                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1269                     }
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, to, tokenId);
1275         _afterTokenTransfers(from, to, tokenId, 1);
1276     }
1277 
1278     /**
1279      * @dev Equivalent to `_burn(tokenId, false)`.
1280      */
1281     function _burn(uint256 tokenId) internal virtual {
1282         _burn(tokenId, false);
1283     }
1284 
1285     /**
1286      * @dev Destroys `tokenId`.
1287      * The approval is cleared when the token is burned.
1288      *
1289      * Requirements:
1290      *
1291      * - `tokenId` must exist.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1296         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1297 
1298         address from = address(uint160(prevOwnershipPacked));
1299 
1300         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1301 
1302         if (approvalCheck) {
1303             // The nested ifs save around 20+ gas over a compound boolean condition.
1304             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1305                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1306         }
1307 
1308         _beforeTokenTransfers(from, address(0), tokenId, 1);
1309 
1310         // Clear approvals from the previous owner.
1311         assembly {
1312             if approvedAddress {
1313                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1314                 sstore(approvedAddressSlot, 0)
1315             }
1316         }
1317 
1318         // Underflow of the sender's balance is impossible because we check for
1319         // ownership above and the recipient's balance can't realistically overflow.
1320         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1321         unchecked {
1322             // Updates:
1323             // - `balance -= 1`.
1324             // - `numberBurned += 1`.
1325             //
1326             // We can directly decrement the balance, and increment the number burned.
1327             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1328             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1329 
1330             // Updates:
1331             // - `address` to the last owner.
1332             // - `startTimestamp` to the timestamp of burning.
1333             // - `burned` to `true`.
1334             // - `nextInitialized` to `true`.
1335             _packedOwnerships[tokenId] = _packOwnershipData(
1336                 from,
1337                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1338             );
1339 
1340             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1341             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1342                 uint256 nextTokenId = tokenId + 1;
1343                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1344                 if (_packedOwnerships[nextTokenId] == 0) {
1345                     // If the next slot is within bounds.
1346                     if (nextTokenId != _currentIndex) {
1347                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1348                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1349                     }
1350                 }
1351             }
1352         }
1353 
1354         emit Transfer(from, address(0), tokenId);
1355         _afterTokenTransfers(from, address(0), tokenId, 1);
1356 
1357         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1358         unchecked {
1359             _burnCounter++;
1360         }
1361     }
1362 
1363     /**
1364      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1365      *
1366      * @param from address representing the previous owner of the given token ID
1367      * @param to target address that will receive the tokens
1368      * @param tokenId uint256 ID of the token to be transferred
1369      * @param _data bytes optional data to send along with the call
1370      * @return bool whether the call correctly returned the expected magic value
1371      */
1372     function _checkContractOnERC721Received(
1373         address from,
1374         address to,
1375         uint256 tokenId,
1376         bytes memory _data
1377     ) private returns (bool) {
1378         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1379             bytes4 retval
1380         ) {
1381             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1382         } catch (bytes memory reason) {
1383             if (reason.length == 0) {
1384                 revert TransferToNonERC721ReceiverImplementer();
1385             } else {
1386                 assembly {
1387                     revert(add(32, reason), mload(reason))
1388                 }
1389             }
1390         }
1391     }
1392 
1393     /**
1394      * @dev Directly sets the extra data for the ownership data `index`.
1395      */
1396     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1397         uint256 packed = _packedOwnerships[index];
1398         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1399         uint256 extraDataCasted;
1400         // Cast `extraData` with assembly to avoid redundant masking.
1401         assembly {
1402             extraDataCasted := extraData
1403         }
1404         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1405         _packedOwnerships[index] = packed;
1406     }
1407 
1408     /**
1409      * @dev Returns the next extra data for the packed ownership data.
1410      * The returned result is shifted into position.
1411      */
1412     function _nextExtraData(
1413         address from,
1414         address to,
1415         uint256 prevOwnershipPacked
1416     ) private view returns (uint256) {
1417         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1418         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1419     }
1420 
1421     /**
1422      * @dev Called during each token transfer to set the 24bit `extraData` field.
1423      * Intended to be overridden by the cosumer contract.
1424      *
1425      * `previousExtraData` - the value of `extraData` before transfer.
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` will be minted for `to`.
1432      * - When `to` is zero, `tokenId` will be burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _extraData(
1436         address from,
1437         address to,
1438         uint24 previousExtraData
1439     ) internal view virtual returns (uint24) {}
1440 
1441     /**
1442      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1443      * This includes minting.
1444      * And also called before burning one token.
1445      *
1446      * startTokenId - the first token id to be transferred
1447      * quantity - the amount to be transferred
1448      *
1449      * Calling conditions:
1450      *
1451      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1452      * transferred to `to`.
1453      * - When `from` is zero, `tokenId` will be minted for `to`.
1454      * - When `to` is zero, `tokenId` will be burned by `from`.
1455      * - `from` and `to` are never both zero.
1456      */
1457     function _beforeTokenTransfers(
1458         address from,
1459         address to,
1460         uint256 startTokenId,
1461         uint256 quantity
1462     ) internal virtual {}
1463 
1464     /**
1465      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1466      * This includes minting.
1467      * And also called after one token has been burned.
1468      *
1469      * startTokenId - the first token id to be transferred
1470      * quantity - the amount to be transferred
1471      *
1472      * Calling conditions:
1473      *
1474      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1475      * transferred to `to`.
1476      * - When `from` is zero, `tokenId` has been minted for `to`.
1477      * - When `to` is zero, `tokenId` has been burned by `from`.
1478      * - `from` and `to` are never both zero.
1479      */
1480     function _afterTokenTransfers(
1481         address from,
1482         address to,
1483         uint256 startTokenId,
1484         uint256 quantity
1485     ) internal virtual {}
1486 
1487     /**
1488      * @dev Returns the message sender (defaults to `msg.sender`).
1489      *
1490      * If you are writing GSN compatible contracts, you need to override this function.
1491      */
1492     function _msgSenderERC721A() internal view virtual returns (address) {
1493         return msg.sender;
1494     }
1495 
1496     /**
1497      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1498      */
1499     function _toString(uint256 value) internal pure returns (string memory ptr) {
1500         assembly {
1501             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1502             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1503             // We will need 1 32-byte word to store the length,
1504             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1505             ptr := add(mload(0x40), 128)
1506             // Update the free memory pointer to allocate.
1507             mstore(0x40, ptr)
1508 
1509             // Cache the end of the memory to calculate the length later.
1510             let end := ptr
1511 
1512             // We write the string from the rightmost digit to the leftmost digit.
1513             // The following is essentially a do-while loop that also handles the zero case.
1514             // Costs a bit more than early returning for the zero case,
1515             // but cheaper in terms of deployment and overall runtime costs.
1516             for {
1517                 // Initialize and perform the first pass without check.
1518                 let temp := value
1519                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1520                 ptr := sub(ptr, 1)
1521                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1522                 mstore8(ptr, add(48, mod(temp, 10)))
1523                 temp := div(temp, 10)
1524             } temp {
1525                 // Keep dividing `temp` until zero.
1526                 temp := div(temp, 10)
1527             } {
1528                 // Body of the for loop.
1529                 ptr := sub(ptr, 1)
1530                 mstore8(ptr, add(48, mod(temp, 10)))
1531             }
1532 
1533             let length := sub(end, ptr)
1534             // Move the pointer 32 bytes leftwards to make room for the length.
1535             ptr := sub(ptr, 32)
1536             // Store the length.
1537             mstore(ptr, length)
1538         }
1539     }
1540 }
1541 
1542 // File: contracts/PoorDudes.sol
1543 
1544 
1545 
1546 pragma solidity ^0.8.4;
1547 
1548 
1549 
1550 
1551 
1552 
1553 contract PoorDudes is ERC721A, Ownable, ReentrancyGuard {
1554     using Strings for uint256;
1555     
1556     bool public private_sale_running = false;
1557     bool public public_sale_running = false;
1558 
1559     uint public MAX_SUPPLY = 9999;
1560 
1561     uint public public_minted;
1562 
1563     bytes32 public merkle_root;
1564 
1565     constructor () ERC721A("Poor Dudes", "DUDES") {
1566         _safeMint(msg.sender, 250);
1567     }
1568     
1569     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1570         return string(abi.encodePacked("https://poordudes.life/metadata/", tokenId.toString(), ".json"));
1571     }   
1572 
1573     function _startTokenId() internal view virtual override returns (uint256) {
1574         return 1;
1575     }
1576 
1577     function isWhitelisted(address _user, bytes32 [] calldata _merkleProof) public view returns(bool) {
1578         bytes32 leaf = keccak256(abi.encodePacked(_user));
1579         return MerkleProof.verify(_merkleProof, merkle_root, leaf);
1580     }
1581 
1582     function getNumMinted(address _user) public view returns(uint256) {
1583         return _numberMinted(_user);
1584     }
1585     
1586     function whitelistMint(bytes32 [] calldata _merkleProof, uint64 _quantity) external nonReentrant {
1587         require(tx.origin == msg.sender);
1588         require(private_sale_running, "Whitelist is not running");
1589         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1590         require(isWhitelisted(msg.sender, _merkleProof), "User is not whitelisted");
1591 
1592         uint256 num_claimed = _numberMinted(msg.sender);
1593 
1594         require(num_claimed + _quantity <= 5, "Can't claim more than 5 total");
1595 
1596         _safeMint(msg.sender, _quantity);
1597     }
1598 
1599     function publicMint(uint64 _quantity) external nonReentrant {
1600         require(tx.origin == msg.sender);
1601         require(public_sale_running, "Public sale is not running");
1602         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1603 
1604         uint256 num_claimed = _numberMinted(msg.sender);
1605         
1606         require(num_claimed + _quantity <= 2, "Invalid number of tokens queries for minting");
1607 
1608         _safeMint(msg.sender, _quantity);
1609     }
1610 
1611     function burn(uint _token_id) external {
1612         _burn(_token_id, true);
1613     }
1614     
1615     function togglePublicSale() external onlyOwner {
1616         public_sale_running = !public_sale_running;
1617     }
1618 
1619     function togglePrivateSale() external onlyOwner {
1620         private_sale_running = !private_sale_running;
1621     }
1622 
1623     function adminMint(address _destination, uint _quantity) external onlyOwner {
1624         require(totalSupply() + _quantity <= MAX_SUPPLY, "Not enough tokens left to mint");
1625         _safeMint(_destination, _quantity);
1626     }
1627 
1628     function updateWhitelistMerkleRoot(bytes32 _new_root) external onlyOwner {
1629         merkle_root = _new_root;
1630     }
1631 }