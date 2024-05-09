1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-25
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev These functions deal with verification of Merkle Trees proofs.
84  *
85  * The proofs can be generated using the JavaScript library
86  * https://github.com/miguelmota/merkletreejs[merkletreejs].
87  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
88  *
89  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
90  *
91  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
92  * hashing, or use a hash function other than keccak256 for hashing leaves.
93  * This is because the concatenation of a sorted pair of internal nodes in
94  * the merkle tree could be reinterpreted as a leaf value.
95  */
96 library MerkleProof {
97     /**
98      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
99      * defined by `root`. For this, a `proof` must be provided, containing
100      * sibling hashes on the branch from the leaf to the root of the tree. Each
101      * pair of leaves and each pair of pre-images are assumed to be sorted.
102      */
103     function verify(
104         bytes32[] memory proof,
105         bytes32 root,
106         bytes32 leaf
107     ) internal pure returns (bool) {
108         return processProof(proof, leaf) == root;
109     }
110 
111     /**
112      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
113      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
114      * hash matches the root of the tree. When processing the proof, the pairs
115      * of leafs & pre-images are assumed to be sorted.
116      *
117      * _Available since v4.4._
118      */
119     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
120         bytes32 computedHash = leaf;
121         for (uint256 i = 0; i < proof.length; i++) {
122             bytes32 proofElement = proof[i];
123             if (computedHash <= proofElement) {
124                 // Hash(current computed hash + current element of the proof)
125                 computedHash = _efficientHash(computedHash, proofElement);
126             } else {
127                 // Hash(current element of the proof + current computed hash)
128                 computedHash = _efficientHash(proofElement, computedHash);
129             }
130         }
131         return computedHash;
132     }
133 
134     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
135         assembly {
136             mstore(0x00, a)
137             mstore(0x20, b)
138             value := keccak256(0x00, 0x40)
139         }
140     }
141 }
142 
143 // File: @openzeppelin/contracts/utils/Context.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 // File: @openzeppelin/contracts/security/Pausable.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Contract module which allows children to implement an emergency stop
180  * mechanism that can be triggered by an authorized account.
181  *
182  * This module is used through inheritance. It will make available the
183  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
184  * the functions of your contract. Note that they will not be pausable by
185  * simply including this module, only once the modifiers are put in place.
186  */
187 abstract contract Pausable is Context {
188     /**
189      * @dev Emitted when the pause is triggered by `account`.
190      */
191     event Paused(address account);
192 
193     /**
194      * @dev Emitted when the pause is lifted by `account`.
195      */
196     event Unpaused(address account);
197 
198     bool private _paused;
199 
200     /**
201      * @dev Initializes the contract in unpaused state.
202      */
203     constructor() {
204         _paused = false;
205     }
206 
207     /**
208      * @dev Returns true if the contract is paused, and false otherwise.
209      */
210     function paused() public view virtual returns (bool) {
211         return _paused;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is not paused.
216      *
217      * Requirements:
218      *
219      * - The contract must not be paused.
220      */
221     modifier whenNotPaused() {
222         require(!paused(), "Pausable: paused");
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      *
229      * Requirements:
230      *
231      * - The contract must be paused.
232      */
233     modifier whenPaused() {
234         require(paused(), "Pausable: not paused");
235         _;
236     }
237 
238     /**
239      * @dev Triggers stopped state.
240      *
241      * Requirements:
242      *
243      * - The contract must not be paused.
244      */
245     function _pause() internal virtual whenNotPaused {
246         _paused = true;
247         emit Paused(_msgSender());
248     }
249 
250     /**
251      * @dev Returns to normal state.
252      *
253      * Requirements:
254      *
255      * - The contract must be paused.
256      */
257     function _unpause() internal virtual whenPaused {
258         _paused = false;
259         emit Unpaused(_msgSender());
260     }
261 }
262 
263 // File: @openzeppelin/contracts/access/Ownable.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _transferOwnership(_msgSender());
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
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _transferOwnership(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 // File: erc721a/contracts/IERC721A.sol
342 
343 
344 // ERC721A Contracts v4.1.0
345 // Creator: Chiru Labs
346 
347 pragma solidity ^0.8.4;
348 
349 /**
350  * @dev Interface of an ERC721A compliant contract.
351  */
352 interface IERC721A {
353     /**
354      * The caller must own the token or be an approved operator.
355      */
356     error ApprovalCallerNotOwnerNorApproved();
357 
358     /**
359      * The token does not exist.
360      */
361     error ApprovalQueryForNonexistentToken();
362 
363     /**
364      * The caller cannot approve to their own address.
365      */
366     error ApproveToCaller();
367 
368     /**
369      * Cannot query the balance for the zero address.
370      */
371     error BalanceQueryForZeroAddress();
372 
373     /**
374      * Cannot mint to the zero address.
375      */
376     error MintToZeroAddress();
377 
378     /**
379      * The quantity of tokens minted must be more than zero.
380      */
381     error MintZeroQuantity();
382 
383     /**
384      * The token does not exist.
385      */
386     error OwnerQueryForNonexistentToken();
387 
388     /**
389      * The caller must own the token or be an approved operator.
390      */
391     error TransferCallerNotOwnerNorApproved();
392 
393     /**
394      * The token must be owned by `from`.
395      */
396     error TransferFromIncorrectOwner();
397 
398     /**
399      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
400      */
401     error TransferToNonERC721ReceiverImplementer();
402 
403     /**
404      * Cannot transfer to the zero address.
405      */
406     error TransferToZeroAddress();
407 
408     /**
409      * The token does not exist.
410      */
411     error URIQueryForNonexistentToken();
412 
413     /**
414      * The `quantity` minted with ERC2309 exceeds the safety limit.
415      */
416     error MintERC2309QuantityExceedsLimit();
417 
418     /**
419      * The `extraData` cannot be set on an unintialized ownership slot.
420      */
421     error OwnershipNotInitializedForExtraData();
422 
423     struct TokenOwnership {
424         // The address of the owner.
425         address addr;
426         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
427         uint64 startTimestamp;
428         // Whether the token has been burned.
429         bool burned;
430         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
431         uint24 extraData;
432     }
433 
434     /**
435      * @dev Returns the total amount of tokens stored by the contract.
436      *
437      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
438      */
439     function totalSupply() external view returns (uint256);
440 
441     // ==============================
442     //            IERC165
443     // ==============================
444 
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 
455     // ==============================
456     //            IERC721
457     // ==============================
458 
459     /**
460      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
461      */
462     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
463 
464     /**
465      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
466      */
467     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
468 
469     /**
470      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
471      */
472     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
473 
474     /**
475      * @dev Returns the number of tokens in ``owner``'s account.
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
489      * @dev Safely transfers `tokenId` token from `from` to `to`.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId,
505         bytes calldata data
506     ) external;
507 
508     /**
509      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
510      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId
526     ) external;
527 
528     /**
529      * @dev Transfers `tokenId` token from `from` to `to`.
530      *
531      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must be owned by `from`.
538      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
539      *
540      * Emits a {Transfer} event.
541      */
542     function transferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
550      * The approval is cleared when the token is transferred.
551      *
552      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
553      *
554      * Requirements:
555      *
556      * - The caller must own the token or be an approved operator.
557      * - `tokenId` must exist.
558      *
559      * Emits an {Approval} event.
560      */
561     function approve(address to, uint256 tokenId) external;
562 
563     /**
564      * @dev Approve or remove `operator` as an operator for the caller.
565      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
566      *
567      * Requirements:
568      *
569      * - The `operator` cannot be the caller.
570      *
571      * Emits an {ApprovalForAll} event.
572      */
573     function setApprovalForAll(address operator, bool _approved) external;
574 
575     /**
576      * @dev Returns the account approved for `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function getApproved(uint256 tokenId) external view returns (address operator);
583 
584     /**
585      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
586      *
587      * See {setApprovalForAll}
588      */
589     function isApprovedForAll(address owner, address operator) external view returns (bool);
590 
591     // ==============================
592     //        IERC721Metadata
593     // ==============================
594 
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() external view returns (string memory);
599 
600     /**
601      * @dev Returns the token collection symbol.
602      */
603     function symbol() external view returns (string memory);
604 
605     /**
606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
607      */
608     function tokenURI(uint256 tokenId) external view returns (string memory);
609 
610     // ==============================
611     //            IERC2309
612     // ==============================
613 
614     /**
615      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
616      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
617      */
618     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
619 }
620 
621 // File: erc721a/contracts/ERC721A.sol
622 
623 
624 // ERC721A Contracts v4.1.0
625 // Creator: Chiru Labs
626 
627 pragma solidity ^0.8.4;
628 
629 
630 /**
631  * @dev ERC721 token receiver interface.
632  */
633 interface ERC721A__IERC721Receiver {
634     function onERC721Received(
635         address operator,
636         address from,
637         uint256 tokenId,
638         bytes calldata data
639     ) external returns (bytes4);
640 }
641 
642 /**
643  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
644  * including the Metadata extension. Built to optimize for lower gas during batch mints.
645  *
646  * Assumes serials are sequentially minted starting at `_startTokenId()`
647  * (defaults to 0, e.g. 0, 1, 2, 3..).
648  *
649  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
650  *
651  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
652  */
653 contract ERC721A is IERC721A {
654     // Mask of an entry in packed address data.
655     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
656 
657     // The bit position of `numberMinted` in packed address data.
658     uint256 private constant BITPOS_NUMBER_MINTED = 64;
659 
660     // The bit position of `numberBurned` in packed address data.
661     uint256 private constant BITPOS_NUMBER_BURNED = 128;
662 
663     // The bit position of `aux` in packed address data.
664     uint256 private constant BITPOS_AUX = 192;
665 
666     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
667     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
668 
669     // The bit position of `startTimestamp` in packed ownership.
670     uint256 private constant BITPOS_START_TIMESTAMP = 160;
671 
672     // The bit mask of the `burned` bit in packed ownership.
673     uint256 private constant BITMASK_BURNED = 1 << 224;
674 
675     // The bit position of the `nextInitialized` bit in packed ownership.
676     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
677 
678     // The bit mask of the `nextInitialized` bit in packed ownership.
679     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
680 
681     // The bit position of `extraData` in packed ownership.
682     uint256 private constant BITPOS_EXTRA_DATA = 232;
683 
684     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
685     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
686 
687     // The mask of the lower 160 bits for addresses.
688     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
689 
690     // The maximum `quantity` that can be minted with `_mintERC2309`.
691     // This limit is to prevent overflows on the address data entries.
692     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
693     // is required to cause an overflow, which is unrealistic.
694     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
695 
696     // The tokenId of the next token to be minted.
697     uint256 private _currentIndex;
698 
699     // The number of tokens burned.
700     uint256 private _burnCounter;
701 
702     // Token name
703     string private _name;
704 
705     // Token symbol
706     string private _symbol;
707 
708     // Mapping from token ID to ownership details
709     // An empty struct value does not necessarily mean the token is unowned.
710     // See `_packedOwnershipOf` implementation for details.
711     //
712     // Bits Layout:
713     // - [0..159]   `addr`
714     // - [160..223] `startTimestamp`
715     // - [224]      `burned`
716     // - [225]      `nextInitialized`
717     // - [232..255] `extraData`
718     mapping(uint256 => uint256) private _packedOwnerships;
719 
720     // Mapping owner address to address data.
721     //
722     // Bits Layout:
723     // - [0..63]    `balance`
724     // - [64..127]  `numberMinted`
725     // - [128..191] `numberBurned`
726     // - [192..255] `aux`
727     mapping(address => uint256) private _packedAddressData;
728 
729     // Mapping from token ID to approved address.
730     mapping(uint256 => address) private _tokenApprovals;
731 
732     // Mapping from owner to operator approvals
733     mapping(address => mapping(address => bool)) private _operatorApprovals;
734 
735     constructor(string memory name_, string memory symbol_) {
736         _name = name_;
737         _symbol = symbol_;
738         _currentIndex = _startTokenId();
739     }
740 
741     /**
742      * @dev Returns the starting token ID.
743      * To change the starting token ID, please override this function.
744      */
745     function _startTokenId() internal view virtual returns (uint256) {
746         return 0;
747     }
748 
749     /**
750      * @dev Returns the next token ID to be minted.
751      */
752     function _nextTokenId() internal view returns (uint256) {
753         return _currentIndex;
754     }
755 
756     /**
757      * @dev Returns the total number of tokens in existence.
758      * Burned tokens will reduce the count.
759      * To get the total number of tokens minted, please see `_totalMinted`.
760      */
761     function totalSupply() public view override returns (uint256) {
762         // Counter underflow is impossible as _burnCounter cannot be incremented
763         // more than `_currentIndex - _startTokenId()` times.
764         unchecked {
765             return _currentIndex - _burnCounter - _startTokenId();
766         }
767     }
768 
769     /**
770      * @dev Returns the total amount of tokens minted in the contract.
771      */
772     function _totalMinted() internal view returns (uint256) {
773         // Counter underflow is impossible as _currentIndex does not decrement,
774         // and it is initialized to `_startTokenId()`
775         unchecked {
776             return _currentIndex - _startTokenId();
777         }
778     }
779 
780     /**
781      * @dev Returns the total number of tokens burned.
782      */
783     function _totalBurned() internal view returns (uint256) {
784         return _burnCounter;
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
791         // The interface IDs are constants representing the first 4 bytes of the XOR of
792         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
793         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
794         return
795             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
796             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
797             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view override returns (uint256) {
804         if (owner == address(0)) revert BalanceQueryForZeroAddress();
805         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
806     }
807 
808     /**
809      * Returns the number of tokens minted by `owner`.
810      */
811     function _numberMinted(address owner) internal view returns (uint256) {
812         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
813     }
814 
815     /**
816      * Returns the number of tokens burned by or on behalf of `owner`.
817      */
818     function _numberBurned(address owner) internal view returns (uint256) {
819         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
820     }
821 
822     /**
823      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
824      */
825     function _getAux(address owner) internal view returns (uint64) {
826         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
827     }
828 
829     /**
830      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
831      * If there are multiple variables, please pack them into a uint64.
832      */
833     function _setAux(address owner, uint64 aux) internal {
834         uint256 packed = _packedAddressData[owner];
835         uint256 auxCasted;
836         // Cast `aux` with assembly to avoid redundant masking.
837         assembly {
838             auxCasted := aux
839         }
840         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
841         _packedAddressData[owner] = packed;
842     }
843 
844     /**
845      * Returns the packed ownership data of `tokenId`.
846      */
847     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
848         uint256 curr = tokenId;
849 
850         unchecked {
851             if (_startTokenId() <= curr)
852                 if (curr < _currentIndex) {
853                     uint256 packed = _packedOwnerships[curr];
854                     // If not burned.
855                     if (packed & BITMASK_BURNED == 0) {
856                         // Invariant:
857                         // There will always be an ownership that has an address and is not burned
858                         // before an ownership that does not have an address and is not burned.
859                         // Hence, curr will not underflow.
860                         //
861                         // We can directly compare the packed value.
862                         // If the address is zero, packed is zero.
863                         while (packed == 0) {
864                             packed = _packedOwnerships[--curr];
865                         }
866                         return packed;
867                     }
868                 }
869         }
870         revert OwnerQueryForNonexistentToken();
871     }
872 
873     /**
874      * Returns the unpacked `TokenOwnership` struct from `packed`.
875      */
876     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
877         ownership.addr = address(uint160(packed));
878         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
879         ownership.burned = packed & BITMASK_BURNED != 0;
880         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
881     }
882 
883     /**
884      * Returns the unpacked `TokenOwnership` struct at `index`.
885      */
886     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
887         return _unpackedOwnership(_packedOwnerships[index]);
888     }
889 
890     /**
891      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
892      */
893     function _initializeOwnershipAt(uint256 index) internal {
894         if (_packedOwnerships[index] == 0) {
895             _packedOwnerships[index] = _packedOwnershipOf(index);
896         }
897     }
898 
899     /**
900      * Gas spent here starts off proportional to the maximum mint batch size.
901      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
902      */
903     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
904         return _unpackedOwnership(_packedOwnershipOf(tokenId));
905     }
906 
907     /**
908      * @dev Packs ownership data into a single uint256.
909      */
910     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
911         assembly {
912             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
913             owner := and(owner, BITMASK_ADDRESS)
914             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
915             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
916         }
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view override returns (address) {
923         return address(uint160(_packedOwnershipOf(tokenId)));
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-name}.
928      */
929     function name() public view virtual override returns (string memory) {
930         return _name;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-symbol}.
935      */
936     function symbol() public view virtual override returns (string memory) {
937         return _symbol;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
944         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
945 
946         string memory baseURI = _baseURI();
947         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
948     }
949 
950     /**
951      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
952      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
953      * by default, it can be overridden in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return '';
957     }
958 
959     /**
960      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
961      */
962     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
963         // For branchless setting of the `nextInitialized` flag.
964         assembly {
965             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
966             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
967         }
968     }
969 
970     /**
971      * @dev See {IERC721-approve}.
972      */
973     function approve(address to, uint256 tokenId) public override {
974         address owner = ownerOf(tokenId);
975 
976         if (_msgSenderERC721A() != owner)
977             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
978                 revert ApprovalCallerNotOwnerNorApproved();
979             }
980 
981         _tokenApprovals[tokenId] = to;
982         emit Approval(owner, to, tokenId);
983     }
984 
985     /**
986      * @dev See {IERC721-getApproved}.
987      */
988     function getApproved(uint256 tokenId) public view override returns (address) {
989         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
990 
991         return _tokenApprovals[tokenId];
992     }
993 
994     /**
995      * @dev See {IERC721-setApprovalForAll}.
996      */
997     function setApprovalForAll(address operator, bool approved) public virtual override {
998         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
999 
1000         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1001         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-safeTransferFrom}.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         safeTransferFrom(from, to, tokenId, '');
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes memory _data
1030     ) public virtual override {
1031         transferFrom(from, to, tokenId);
1032         if (to.code.length != 0)
1033             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1034                 revert TransferToNonERC721ReceiverImplementer();
1035             }
1036     }
1037 
1038     /**
1039      * @dev Returns whether `tokenId` exists.
1040      *
1041      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1042      *
1043      * Tokens start existing when they are minted (`_mint`),
1044      */
1045     function _exists(uint256 tokenId) internal view returns (bool) {
1046         return
1047             _startTokenId() <= tokenId &&
1048             tokenId < _currentIndex && // If within bounds,
1049             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1050     }
1051 
1052     /**
1053      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1054      */
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement
1065      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1066      * - `quantity` must be greater than 0.
1067      *
1068      * See {_mint}.
1069      *
1070      * Emits a {Transfer} event for each mint.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data
1076     ) internal {
1077         _mint(to, quantity);
1078 
1079         unchecked {
1080             if (to.code.length != 0) {
1081                 uint256 end = _currentIndex;
1082                 uint256 index = end - quantity;
1083                 do {
1084                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1085                         revert TransferToNonERC721ReceiverImplementer();
1086                     }
1087                 } while (index < end);
1088                 // Reentrancy protection.
1089                 if (_currentIndex != end) revert();
1090             }
1091         }
1092     }
1093 
1094     /**
1095      * @dev Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event for each mint.
1103      */
1104     function _mint(address to, uint256 quantity) internal {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are incredibly unrealistic.
1112         // `balance` and `numberMinted` have a maximum limit of 2**64.
1113         // `tokenId` has a maximum limit of 2**256.
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the `balance` and `numberMinted`.
1120             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] = _packOwnershipData(
1128                 to,
1129                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1130             );
1131 
1132             uint256 tokenId = startTokenId;
1133             uint256 end = startTokenId + quantity;
1134             do {
1135                 emit Transfer(address(0), to, tokenId++);
1136             } while (tokenId < end);
1137 
1138             _currentIndex = end;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * This function is intended for efficient minting only during contract creation.
1147      *
1148      * It emits only one {ConsecutiveTransfer} as defined in
1149      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1150      * instead of a sequence of {Transfer} event(s).
1151      *
1152      * Calling this function outside of contract creation WILL make your contract
1153      * non-compliant with the ERC721 standard.
1154      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1155      * {ConsecutiveTransfer} event is only permissible during contract creation.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      * - `quantity` must be greater than 0.
1161      *
1162      * Emits a {ConsecutiveTransfer} event.
1163      */
1164     function _mintERC2309(address to, uint256 quantity) internal {
1165         uint256 startTokenId = _currentIndex;
1166         if (to == address(0)) revert MintToZeroAddress();
1167         if (quantity == 0) revert MintZeroQuantity();
1168         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1169 
1170         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1171 
1172         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1173         unchecked {
1174             // Updates:
1175             // - `balance += quantity`.
1176             // - `numberMinted += quantity`.
1177             //
1178             // We can directly add to the `balance` and `numberMinted`.
1179             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1180 
1181             // Updates:
1182             // - `address` to the owner.
1183             // - `startTimestamp` to the timestamp of minting.
1184             // - `burned` to `false`.
1185             // - `nextInitialized` to `quantity == 1`.
1186             _packedOwnerships[startTokenId] = _packOwnershipData(
1187                 to,
1188                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1189             );
1190 
1191             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1192 
1193             _currentIndex = startTokenId + quantity;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1200      */
1201     function _getApprovedAddress(uint256 tokenId)
1202         private
1203         view
1204         returns (uint256 approvedAddressSlot, address approvedAddress)
1205     {
1206         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1207         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1208         assembly {
1209             // Compute the slot.
1210             mstore(0x00, tokenId)
1211             mstore(0x20, tokenApprovalsPtr.slot)
1212             approvedAddressSlot := keccak256(0x00, 0x40)
1213             // Load the slot's value from storage.
1214             approvedAddress := sload(approvedAddressSlot)
1215         }
1216     }
1217 
1218     /**
1219      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1220      */
1221     function _isOwnerOrApproved(
1222         address approvedAddress,
1223         address from,
1224         address msgSender
1225     ) private pure returns (bool result) {
1226         assembly {
1227             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1228             from := and(from, BITMASK_ADDRESS)
1229             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1230             msgSender := and(msgSender, BITMASK_ADDRESS)
1231             // `msgSender == from || msgSender == approvedAddress`.
1232             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1233         }
1234     }
1235 
1236     /**
1237      * @dev Transfers `tokenId` from `from` to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `tokenId` token must be owned by `from`.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function transferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) public virtual override {
1251         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1252 
1253         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1254 
1255         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1256 
1257         // The nested ifs save around 20+ gas over a compound boolean condition.
1258         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
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
1275         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
1288                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1289             );
1290 
1291             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1292             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
1310      * @dev Equivalent to `_burn(tokenId, false)`.
1311      */
1312     function _burn(uint256 tokenId) internal virtual {
1313         _burn(tokenId, false);
1314     }
1315 
1316     /**
1317      * @dev Destroys `tokenId`.
1318      * The approval is cleared when the token is burned.
1319      *
1320      * Requirements:
1321      *
1322      * - `tokenId` must exist.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1327         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1328 
1329         address from = address(uint160(prevOwnershipPacked));
1330 
1331         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1332 
1333         if (approvalCheck) {
1334             // The nested ifs save around 20+ gas over a compound boolean condition.
1335             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1336                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1337         }
1338 
1339         _beforeTokenTransfers(from, address(0), tokenId, 1);
1340 
1341         // Clear approvals from the previous owner.
1342         assembly {
1343             if approvedAddress {
1344                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1345                 sstore(approvedAddressSlot, 0)
1346             }
1347         }
1348 
1349         // Underflow of the sender's balance is impossible because we check for
1350         // ownership above and the recipient's balance can't realistically overflow.
1351         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1352         unchecked {
1353             // Updates:
1354             // - `balance -= 1`.
1355             // - `numberBurned += 1`.
1356             //
1357             // We can directly decrement the balance, and increment the number burned.
1358             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1359             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1360 
1361             // Updates:
1362             // - `address` to the last owner.
1363             // - `startTimestamp` to the timestamp of burning.
1364             // - `burned` to `true`.
1365             // - `nextInitialized` to `true`.
1366             _packedOwnerships[tokenId] = _packOwnershipData(
1367                 from,
1368                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1369             );
1370 
1371             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1372             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1373                 uint256 nextTokenId = tokenId + 1;
1374                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1375                 if (_packedOwnerships[nextTokenId] == 0) {
1376                     // If the next slot is within bounds.
1377                     if (nextTokenId != _currentIndex) {
1378                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1379                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1380                     }
1381                 }
1382             }
1383         }
1384 
1385         emit Transfer(from, address(0), tokenId);
1386         _afterTokenTransfers(from, address(0), tokenId, 1);
1387 
1388         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1389         unchecked {
1390             _burnCounter++;
1391         }
1392     }
1393 
1394     /**
1395      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1396      *
1397      * @param from address representing the previous owner of the given token ID
1398      * @param to target address that will receive the tokens
1399      * @param tokenId uint256 ID of the token to be transferred
1400      * @param _data bytes optional data to send along with the call
1401      * @return bool whether the call correctly returned the expected magic value
1402      */
1403     function _checkContractOnERC721Received(
1404         address from,
1405         address to,
1406         uint256 tokenId,
1407         bytes memory _data
1408     ) private returns (bool) {
1409         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1410             bytes4 retval
1411         ) {
1412             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1413         } catch (bytes memory reason) {
1414             if (reason.length == 0) {
1415                 revert TransferToNonERC721ReceiverImplementer();
1416             } else {
1417                 assembly {
1418                     revert(add(32, reason), mload(reason))
1419                 }
1420             }
1421         }
1422     }
1423 
1424     /**
1425      * @dev Directly sets the extra data for the ownership data `index`.
1426      */
1427     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1428         uint256 packed = _packedOwnerships[index];
1429         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1430         uint256 extraDataCasted;
1431         // Cast `extraData` with assembly to avoid redundant masking.
1432         assembly {
1433             extraDataCasted := extraData
1434         }
1435         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1436         _packedOwnerships[index] = packed;
1437     }
1438 
1439     /**
1440      * @dev Returns the next extra data for the packed ownership data.
1441      * The returned result is shifted into position.
1442      */
1443     function _nextExtraData(
1444         address from,
1445         address to,
1446         uint256 prevOwnershipPacked
1447     ) private view returns (uint256) {
1448         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1449         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1450     }
1451 
1452     /**
1453      * @dev Called during each token transfer to set the 24bit `extraData` field.
1454      * Intended to be overridden by the cosumer contract.
1455      *
1456      * `previousExtraData` - the value of `extraData` before transfer.
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` will be minted for `to`.
1463      * - When `to` is zero, `tokenId` will be burned by `from`.
1464      * - `from` and `to` are never both zero.
1465      */
1466     function _extraData(
1467         address from,
1468         address to,
1469         uint24 previousExtraData
1470     ) internal view virtual returns (uint24) {}
1471 
1472     /**
1473      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1474      * This includes minting.
1475      * And also called before burning one token.
1476      *
1477      * startTokenId - the first token id to be transferred
1478      * quantity - the amount to be transferred
1479      *
1480      * Calling conditions:
1481      *
1482      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1483      * transferred to `to`.
1484      * - When `from` is zero, `tokenId` will be minted for `to`.
1485      * - When `to` is zero, `tokenId` will be burned by `from`.
1486      * - `from` and `to` are never both zero.
1487      */
1488     function _beforeTokenTransfers(
1489         address from,
1490         address to,
1491         uint256 startTokenId,
1492         uint256 quantity
1493     ) internal virtual {}
1494 
1495     /**
1496      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1497      * This includes minting.
1498      * And also called after one token has been burned.
1499      *
1500      * startTokenId - the first token id to be transferred
1501      * quantity - the amount to be transferred
1502      *
1503      * Calling conditions:
1504      *
1505      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1506      * transferred to `to`.
1507      * - When `from` is zero, `tokenId` has been minted for `to`.
1508      * - When `to` is zero, `tokenId` has been burned by `from`.
1509      * - `from` and `to` are never both zero.
1510      */
1511     function _afterTokenTransfers(
1512         address from,
1513         address to,
1514         uint256 startTokenId,
1515         uint256 quantity
1516     ) internal virtual {}
1517 
1518     /**
1519      * @dev Returns the message sender (defaults to `msg.sender`).
1520      *
1521      * If you are writing GSN compatible contracts, you need to override this function.
1522      */
1523     function _msgSenderERC721A() internal view virtual returns (address) {
1524         return msg.sender;
1525     }
1526 
1527     /**
1528      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1529      */
1530     function _toString(uint256 value) internal pure returns (string memory ptr) {
1531         assembly {
1532             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1533             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1534             // We will need 1 32-byte word to store the length,
1535             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1536             ptr := add(mload(0x40), 128)
1537             // Update the free memory pointer to allocate.
1538             mstore(0x40, ptr)
1539 
1540             // Cache the end of the memory to calculate the length later.
1541             let end := ptr
1542 
1543             // We write the string from the rightmost digit to the leftmost digit.
1544             // The following is essentially a do-while loop that also handles the zero case.
1545             // Costs a bit more than early returning for the zero case,
1546             // but cheaper in terms of deployment and overall runtime costs.
1547             for {
1548                 // Initialize and perform the first pass without check.
1549                 let temp := value
1550                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1551                 ptr := sub(ptr, 1)
1552                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1553                 mstore8(ptr, add(48, mod(temp, 10)))
1554                 temp := div(temp, 10)
1555             } temp {
1556                 // Keep dividing `temp` until zero.
1557                 temp := div(temp, 10)
1558             } {
1559                 // Body of the for loop.
1560                 ptr := sub(ptr, 1)
1561                 mstore8(ptr, add(48, mod(temp, 10)))
1562             }
1563 
1564             let length := sub(end, ptr)
1565             // Move the pointer 32 bytes leftwards to make room for the length.
1566             ptr := sub(ptr, 32)
1567             // Store the length.
1568             mstore(ptr, length)
1569         }
1570     }
1571 }
1572 
1573 //SPDX-License-Identifier: MIT
1574 pragma solidity ^0.8.0; 
1575 
1576 contract BER is ERC721A, Ownable, Pausable 
1577 {
1578     using Strings for uint256;
1579     
1580     uint256 public collectionSize;
1581     mapping(address => uint256) public mintList;
1582     uint256 public walletMintLimit;
1583     string private baseTokenURI;
1584     string private preRevealTokenURI;
1585     bool public revealed = false;
1586     bool public freeMintActive = false;
1587 
1588     constructor
1589     ( 
1590         string memory _name,
1591         string memory _symbol,
1592         uint256 _collectionSize,
1593         uint256 _walletMintLimit,
1594         string memory _preRevealTokenURI
1595     ) ERC721A(_name, _symbol) 
1596     {
1597         collectionSize = _collectionSize;
1598         walletMintLimit = _walletMintLimit;
1599         preRevealTokenURI = _preRevealTokenURI;
1600     }
1601 
1602     modifier callerIsUser() 
1603     {
1604         require(tx.origin == msg.sender, "Caller is contract");
1605         _;
1606     }
1607 
1608     modifier onlyFreeMintActive() {
1609         require(freeMintActive, "Minting is not active");
1610         _;
1611     }
1612 
1613     function tokenURI(uint256 _tokenId)
1614         public
1615         view
1616         virtual
1617         override
1618         returns (string memory)
1619     {
1620         require(_exists(_tokenId), "Token not existed");
1621 
1622         return !revealed ? preRevealTokenURI : string(abi.encodePacked(baseTokenURI, _tokenId.toString(),".json"));
1623     }
1624     
1625     
1626     function reveal(string calldata _baseTokenURI) external onlyOwner 
1627     {
1628         revealed = true;
1629         baseTokenURI = _baseTokenURI;
1630     }
1631 
1632 
1633     function _startTokenId() internal pure override returns (uint256) {
1634         return 0;
1635     }
1636 
1637     function freeMint(uint256 quantity)
1638         external
1639         payable
1640         onlyFreeMintActive
1641         callerIsUser    
1642     {
1643         require(mintList[msg.sender] + quantity <= walletMintLimit, "Up to 5 mints allowed per wallet");
1644         //3000 reserved NFTs
1645         require(totalSupply() + quantity < collectionSize - 3000, "EXCEED_COL_SIZE");
1646 
1647         mintList[msg.sender] += quantity;
1648         _safeMint(msg.sender, quantity);
1649     }
1650     
1651     function teamMint(uint256 quantity)
1652         external
1653         payable
1654         onlyOwner
1655     {
1656         require(quantity > 0, "Invalid quantity");
1657         require(totalSupply() + quantity <= collectionSize, "EXCEED_COL_SIZE");
1658 
1659         _safeMint(msg.sender, quantity);
1660     }
1661 
1662     function airdrop(address toAdd,uint256 quantity)
1663         external
1664         payable
1665         onlyOwner
1666     {
1667         require(quantity > 0, "Invalid quantity");
1668         require(totalSupply() + quantity <= collectionSize, "EXCEED_COL_SIZE");
1669 
1670         _safeMint(toAdd, quantity);
1671     }
1672 
1673     function activeFreeMint() 
1674         external 
1675         onlyOwner 
1676     {
1677         freeMintActive = !freeMintActive;
1678     }
1679 
1680     function pause() external onlyOwner {
1681         _pause();
1682     }
1683 
1684     function unpause() external onlyOwner {
1685         _unpause();
1686     }
1687 
1688 //The remaining amount that has not been mint
1689     function remaining() public view returns (uint256) {
1690         unchecked {
1691             return collectionSize - totalSupply();
1692         }
1693     }
1694 
1695 }