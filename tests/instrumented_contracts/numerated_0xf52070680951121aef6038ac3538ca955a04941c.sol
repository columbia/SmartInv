1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: operator-filter-registry/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 abstract contract OperatorFilterer {
40     error OperatorNotAllowed(address operator);
41 
42     IOperatorFilterRegistry constant operatorFilterRegistry =
43         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
44 
45     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
46         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
47         // will not revert, but the contract will need to be registered with the registry once it is deployed in
48         // order for the modifier to filter addresses.
49         if (address(operatorFilterRegistry).code.length > 0) {
50             if (subscribe) {
51                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
52             } else {
53                 if (subscriptionOrRegistrantToCopy != address(0)) {
54                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
55                 } else {
56                     operatorFilterRegistry.register(address(this));
57                 }
58             }
59         }
60     }
61 
62     modifier onlyAllowedOperator(address from) virtual {
63         // Check registry code length to facilitate testing in environments without a deployed registry.
64         if (address(operatorFilterRegistry).code.length > 0) {
65             // Allow spending tokens from addresses with balance
66             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67             // from an EOA.
68             if (from == msg.sender) {
69                 _;
70                 return;
71             }
72             if (
73                 !(
74                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
75                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
76                 )
77             ) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Strings.sol
86 
87 
88 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev String operations.
94  */
95 library Strings {
96     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
97     uint8 private constant _ADDRESS_LENGTH = 20;
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 
155     /**
156      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
157      */
158     function toHexString(address addr) internal pure returns (string memory) {
159         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
160     }
161 }
162 
163 // File: @openzeppelin/contracts/utils/Context.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 /**
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes calldata) {
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/access/Ownable.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 
198 /**
199  * @dev Contract module which provides a basic access control mechanism, where
200  * there is an account (an owner) that can be granted exclusive access to
201  * specific functions.
202  *
203  * By default, the owner account will be the one that deploys the contract. This
204  * can later be changed with {transferOwnership}.
205  *
206  * This module is used through inheritance. It will make available the modifier
207  * `onlyOwner`, which can be applied to your functions to restrict their use to
208  * the owner.
209  */
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     /**
216      * @dev Initializes the contract setting the deployer as the initial owner.
217      */
218     constructor() {
219         _transferOwnership(_msgSender());
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         _checkOwner();
227         _;
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if the sender is not the owner.
239      */
240     function _checkOwner() internal view virtual {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242     }
243 
244     /**
245      * @dev Leaves the contract without owner. It will not be possible to call
246      * `onlyOwner` functions anymore. Can only be called by the current owner.
247      *
248      * NOTE: Renouncing ownership will leave the contract without an owner,
249      * thereby removing any functionality that is only available to the owner.
250      */
251     function renounceOwnership() public virtual onlyOwner {
252         _transferOwnership(address(0));
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Can only be called by the current owner.
258      */
259     function transferOwnership(address newOwner) public virtual onlyOwner {
260         require(newOwner != address(0), "Ownable: new owner is the zero address");
261         _transferOwnership(newOwner);
262     }
263 
264     /**
265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
266      * Internal function without access restriction.
267      */
268     function _transferOwnership(address newOwner) internal virtual {
269         address oldOwner = _owner;
270         _owner = newOwner;
271         emit OwnershipTransferred(oldOwner, newOwner);
272     }
273 }
274 
275 // File: erc721a/contracts/IERC721A.sol
276 
277 
278 // ERC721A Contracts v4.2.3
279 // Creator: Chiru Labs
280 
281 pragma solidity ^0.8.4;
282 
283 /**
284  * @dev Interface of ERC721A.
285  */
286 interface IERC721A {
287     /**
288      * The caller must own the token or be an approved operator.
289      */
290     error ApprovalCallerNotOwnerNorApproved();
291 
292     /**
293      * The token does not exist.
294      */
295     error ApprovalQueryForNonexistentToken();
296 
297     /**
298      * Cannot query the balance for the zero address.
299      */
300     error BalanceQueryForZeroAddress();
301 
302     /**
303      * Cannot mint to the zero address.
304      */
305     error MintToZeroAddress();
306 
307     /**
308      * The quantity of tokens minted must be more than zero.
309      */
310     error MintZeroQuantity();
311 
312     /**
313      * The token does not exist.
314      */
315     error OwnerQueryForNonexistentToken();
316 
317     /**
318      * The caller must own the token or be an approved operator.
319      */
320     error TransferCallerNotOwnerNorApproved();
321 
322     /**
323      * The token must be owned by `from`.
324      */
325     error TransferFromIncorrectOwner();
326 
327     /**
328      * Cannot safely transfer to a contract that does not implement the
329      * ERC721Receiver interface.
330      */
331     error TransferToNonERC721ReceiverImplementer();
332 
333     /**
334      * Cannot transfer to the zero address.
335      */
336     error TransferToZeroAddress();
337 
338     /**
339      * The token does not exist.
340      */
341     error URIQueryForNonexistentToken();
342 
343     /**
344      * The `quantity` minted with ERC2309 exceeds the safety limit.
345      */
346     error MintERC2309QuantityExceedsLimit();
347 
348     /**
349      * The `extraData` cannot be set on an unintialized ownership slot.
350      */
351     error OwnershipNotInitializedForExtraData();
352 
353     // =============================================================
354     //                            STRUCTS
355     // =============================================================
356 
357     struct TokenOwnership {
358         // The address of the owner.
359         address addr;
360         // Stores the start time of ownership with minimal overhead for tokenomics.
361         uint64 startTimestamp;
362         // Whether the token has been burned.
363         bool burned;
364         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
365         uint24 extraData;
366     }
367 
368     // =============================================================
369     //                         TOKEN COUNTERS
370     // =============================================================
371 
372     /**
373      * @dev Returns the total number of tokens in existence.
374      * Burned tokens will reduce the count.
375      * To get the total number of tokens minted, please see {_totalMinted}.
376      */
377     function totalSupply() external view returns (uint256);
378 
379     // =============================================================
380     //                            IERC165
381     // =============================================================
382 
383     /**
384      * @dev Returns true if this contract implements the interface defined by
385      * `interfaceId`. See the corresponding
386      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
387      * to learn more about how these ids are created.
388      *
389      * This function call must use less than 30000 gas.
390      */
391     function supportsInterface(bytes4 interfaceId) external view returns (bool);
392 
393     // =============================================================
394     //                            IERC721
395     // =============================================================
396 
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables
409      * (`approved`) `operator` to manage all of its assets.
410      */
411     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
412 
413     /**
414      * @dev Returns the number of tokens in `owner`'s account.
415      */
416     function balanceOf(address owner) external view returns (uint256 balance);
417 
418     /**
419      * @dev Returns the owner of the `tokenId` token.
420      *
421      * Requirements:
422      *
423      * - `tokenId` must exist.
424      */
425     function ownerOf(uint256 tokenId) external view returns (address owner);
426 
427     /**
428      * @dev Safely transfers `tokenId` token from `from` to `to`,
429      * checking first that contract recipients are aware of the ERC721 protocol
430      * to prevent tokens from being forever locked.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must exist and be owned by `from`.
437      * - If the caller is not `from`, it must be have been allowed to move
438      * this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement
440      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId,
448         bytes calldata data
449     ) external payable;
450 
451     /**
452      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId
458     ) external payable;
459 
460     /**
461      * @dev Transfers `tokenId` from `from` to `to`.
462      *
463      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
464      * whenever possible.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must be owned by `from`.
471      * - If the caller is not `from`, it must be approved to move this token
472      * by either {approve} or {setApprovalForAll}.
473      *
474      * Emits a {Transfer} event.
475      */
476     function transferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external payable;
481 
482     /**
483      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
484      * The approval is cleared when the token is transferred.
485      *
486      * Only a single account can be approved at a time, so approving the
487      * zero address clears previous approvals.
488      *
489      * Requirements:
490      *
491      * - The caller must own the token or be an approved operator.
492      * - `tokenId` must exist.
493      *
494      * Emits an {Approval} event.
495      */
496     function approve(address to, uint256 tokenId) external payable;
497 
498     /**
499      * @dev Approve or remove `operator` as an operator for the caller.
500      * Operators can call {transferFrom} or {safeTransferFrom}
501      * for any token owned by the caller.
502      *
503      * Requirements:
504      *
505      * - The `operator` cannot be the caller.
506      *
507      * Emits an {ApprovalForAll} event.
508      */
509     function setApprovalForAll(address operator, bool _approved) external;
510 
511     /**
512      * @dev Returns the account approved for `tokenId` token.
513      *
514      * Requirements:
515      *
516      * - `tokenId` must exist.
517      */
518     function getApproved(uint256 tokenId) external view returns (address operator);
519 
520     /**
521      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
522      *
523      * See {setApprovalForAll}.
524      */
525     function isApprovedForAll(address owner, address operator) external view returns (bool);
526 
527     // =============================================================
528     //                        IERC721Metadata
529     // =============================================================
530 
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() external view returns (string memory);
535 
536     /**
537      * @dev Returns the token collection symbol.
538      */
539     function symbol() external view returns (string memory);
540 
541     /**
542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
543      */
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 
546     // =============================================================
547     //                           IERC2309
548     // =============================================================
549 
550     /**
551      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
552      * (inclusive) is transferred from `from` to `to`, as defined in the
553      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
554      *
555      * See {_mintERC2309} for more details.
556      */
557     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
558 }
559 
560 // File: erc721a/contracts/ERC721A.sol
561 
562 
563 // ERC721A Contracts v4.2.3
564 // Creator: Chiru Labs
565 
566 pragma solidity ^0.8.4;
567 
568 
569 /**
570  * @dev Interface of ERC721 token receiver.
571  */
572 interface ERC721A__IERC721Receiver {
573     function onERC721Received(
574         address operator,
575         address from,
576         uint256 tokenId,
577         bytes calldata data
578     ) external returns (bytes4);
579 }
580 
581 /**
582  * @title ERC721A
583  *
584  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
585  * Non-Fungible Token Standard, including the Metadata extension.
586  * Optimized for lower gas during batch mints.
587  *
588  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
589  * starting from `_startTokenId()`.
590  *
591  * Assumptions:
592  *
593  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
594  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
595  */
596 contract ERC721A is IERC721A {
597     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
598     struct TokenApprovalRef {
599         address value;
600     }
601 
602     // =============================================================
603     //                           CONSTANTS
604     // =============================================================
605 
606     // Mask of an entry in packed address data.
607     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
608 
609     // The bit position of `numberMinted` in packed address data.
610     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
611 
612     // The bit position of `numberBurned` in packed address data.
613     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
614 
615     // The bit position of `aux` in packed address data.
616     uint256 private constant _BITPOS_AUX = 192;
617 
618     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
619     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
620 
621     // The bit position of `startTimestamp` in packed ownership.
622     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
623 
624     // The bit mask of the `burned` bit in packed ownership.
625     uint256 private constant _BITMASK_BURNED = 1 << 224;
626 
627     // The bit position of the `nextInitialized` bit in packed ownership.
628     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
629 
630     // The bit mask of the `nextInitialized` bit in packed ownership.
631     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
632 
633     // The bit position of `extraData` in packed ownership.
634     uint256 private constant _BITPOS_EXTRA_DATA = 232;
635 
636     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
637     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
638 
639     // The mask of the lower 160 bits for addresses.
640     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
641 
642     // The maximum `quantity` that can be minted with {_mintERC2309}.
643     // This limit is to prevent overflows on the address data entries.
644     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
645     // is required to cause an overflow, which is unrealistic.
646     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
647 
648     // The `Transfer` event signature is given by:
649     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
650     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
651         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
652 
653     // =============================================================
654     //                            STORAGE
655     // =============================================================
656 
657     // The next token ID to be minted.
658     uint256 private _currentIndex;
659 
660     // The number of tokens burned.
661     uint256 private _burnCounter;
662 
663     // Token name
664     string private _name;
665 
666     // Token symbol
667     string private _symbol;
668 
669     // Mapping from token ID to ownership details
670     // An empty struct value does not necessarily mean the token is unowned.
671     // See {_packedOwnershipOf} implementation for details.
672     //
673     // Bits Layout:
674     // - [0..159]   `addr`
675     // - [160..223] `startTimestamp`
676     // - [224]      `burned`
677     // - [225]      `nextInitialized`
678     // - [232..255] `extraData`
679     mapping(uint256 => uint256) private _packedOwnerships;
680 
681     // Mapping owner address to address data.
682     //
683     // Bits Layout:
684     // - [0..63]    `balance`
685     // - [64..127]  `numberMinted`
686     // - [128..191] `numberBurned`
687     // - [192..255] `aux`
688     mapping(address => uint256) private _packedAddressData;
689 
690     // Mapping from token ID to approved address.
691     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
692 
693     // Mapping from owner to operator approvals
694     mapping(address => mapping(address => bool)) private _operatorApprovals;
695 
696     // =============================================================
697     //                          CONSTRUCTOR
698     // =============================================================
699 
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703         _currentIndex = _startTokenId();
704     }
705 
706     // =============================================================
707     //                   TOKEN COUNTING OPERATIONS
708     // =============================================================
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
721     function _nextTokenId() internal view virtual returns (uint256) {
722         return _currentIndex;
723     }
724 
725     /**
726      * @dev Returns the total number of tokens in existence.
727      * Burned tokens will reduce the count.
728      * To get the total number of tokens minted, please see {_totalMinted}.
729      */
730     function totalSupply() public view virtual override returns (uint256) {
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
741     function _totalMinted() internal view virtual returns (uint256) {
742         // Counter underflow is impossible as `_currentIndex` does not decrement,
743         // and it is initialized to `_startTokenId()`.
744         unchecked {
745             return _currentIndex - _startTokenId();
746         }
747     }
748 
749     /**
750      * @dev Returns the total number of tokens burned.
751      */
752     function _totalBurned() internal view virtual returns (uint256) {
753         return _burnCounter;
754     }
755 
756     // =============================================================
757     //                    ADDRESS DATA OPERATIONS
758     // =============================================================
759 
760     /**
761      * @dev Returns the number of tokens in `owner`'s account.
762      */
763     function balanceOf(address owner) public view virtual override returns (uint256) {
764         if (owner == address(0)) revert BalanceQueryForZeroAddress();
765         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
766     }
767 
768     /**
769      * Returns the number of tokens minted by `owner`.
770      */
771     function _numberMinted(address owner) internal view returns (uint256) {
772         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
773     }
774 
775     /**
776      * Returns the number of tokens burned by or on behalf of `owner`.
777      */
778     function _numberBurned(address owner) internal view returns (uint256) {
779         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
780     }
781 
782     /**
783      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
784      */
785     function _getAux(address owner) internal view returns (uint64) {
786         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
787     }
788 
789     /**
790      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
791      * If there are multiple variables, please pack them into a uint64.
792      */
793     function _setAux(address owner, uint64 aux) internal virtual {
794         uint256 packed = _packedAddressData[owner];
795         uint256 auxCasted;
796         // Cast `aux` with assembly to avoid redundant masking.
797         assembly {
798             auxCasted := aux
799         }
800         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
801         _packedAddressData[owner] = packed;
802     }
803 
804     // =============================================================
805     //                            IERC165
806     // =============================================================
807 
808     /**
809      * @dev Returns true if this contract implements the interface defined by
810      * `interfaceId`. See the corresponding
811      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
812      * to learn more about how these ids are created.
813      *
814      * This function call must use less than 30000 gas.
815      */
816     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
817         // The interface IDs are constants representing the first 4 bytes
818         // of the XOR of all function selectors in the interface.
819         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
820         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
821         return
822             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
823             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
824             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
825     }
826 
827     // =============================================================
828     //                        IERC721Metadata
829     // =============================================================
830 
831     /**
832      * @dev Returns the token collection name.
833      */
834     function name() public view virtual override returns (string memory) {
835         return _name;
836     }
837 
838     /**
839      * @dev Returns the token collection symbol.
840      */
841     function symbol() public view virtual override returns (string memory) {
842         return _symbol;
843     }
844 
845     /**
846      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
847      */
848     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
849         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
850 
851         string memory baseURI = _baseURI();
852         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
853     }
854 
855     /**
856      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
857      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
858      * by default, it can be overridden in child contracts.
859      */
860     function _baseURI() internal view virtual returns (string memory) {
861         return '';
862     }
863 
864     // =============================================================
865     //                     OWNERSHIPS OPERATIONS
866     // =============================================================
867 
868     /**
869      * @dev Returns the owner of the `tokenId` token.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      */
875     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
876         return address(uint160(_packedOwnershipOf(tokenId)));
877     }
878 
879     /**
880      * @dev Gas spent here starts off proportional to the maximum mint batch size.
881      * It gradually moves to O(1) as tokens get transferred around over time.
882      */
883     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
884         return _unpackedOwnership(_packedOwnershipOf(tokenId));
885     }
886 
887     /**
888      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
889      */
890     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
891         return _unpackedOwnership(_packedOwnerships[index]);
892     }
893 
894     /**
895      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
896      */
897     function _initializeOwnershipAt(uint256 index) internal virtual {
898         if (_packedOwnerships[index] == 0) {
899             _packedOwnerships[index] = _packedOwnershipOf(index);
900         }
901     }
902 
903     /**
904      * Returns the packed ownership data of `tokenId`.
905      */
906     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
907         uint256 curr = tokenId;
908 
909         unchecked {
910             if (_startTokenId() <= curr)
911                 if (curr < _currentIndex) {
912                     uint256 packed = _packedOwnerships[curr];
913                     // If not burned.
914                     if (packed & _BITMASK_BURNED == 0) {
915                         // Invariant:
916                         // There will always be an initialized ownership slot
917                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
918                         // before an unintialized ownership slot
919                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
920                         // Hence, `curr` will not underflow.
921                         //
922                         // We can directly compare the packed value.
923                         // If the address is zero, packed will be zero.
924                         while (packed == 0) {
925                             packed = _packedOwnerships[--curr];
926                         }
927                         return packed;
928                     }
929                 }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
936      */
937     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
938         ownership.addr = address(uint160(packed));
939         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
940         ownership.burned = packed & _BITMASK_BURNED != 0;
941         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
942     }
943 
944     /**
945      * @dev Packs ownership data into a single uint256.
946      */
947     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
948         assembly {
949             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
950             owner := and(owner, _BITMASK_ADDRESS)
951             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
952             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
953         }
954     }
955 
956     /**
957      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
958      */
959     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
960         // For branchless setting of the `nextInitialized` flag.
961         assembly {
962             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
963             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
964         }
965     }
966 
967     // =============================================================
968     //                      APPROVAL OPERATIONS
969     // =============================================================
970 
971     /**
972      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
973      * The approval is cleared when the token is transferred.
974      *
975      * Only a single account can be approved at a time, so approving the
976      * zero address clears previous approvals.
977      *
978      * Requirements:
979      *
980      * - The caller must own the token or be an approved operator.
981      * - `tokenId` must exist.
982      *
983      * Emits an {Approval} event.
984      */
985     function approve(address to, uint256 tokenId) public payable virtual override {
986         address owner = ownerOf(tokenId);
987 
988         if (_msgSenderERC721A() != owner)
989             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
990                 revert ApprovalCallerNotOwnerNorApproved();
991             }
992 
993         _tokenApprovals[tokenId].value = to;
994         emit Approval(owner, to, tokenId);
995     }
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId].value;
1008     }
1009 
1010     /**
1011      * @dev Approve or remove `operator` as an operator for the caller.
1012      * Operators can call {transferFrom} or {safeTransferFrom}
1013      * for any token owned by the caller.
1014      *
1015      * Requirements:
1016      *
1017      * - The `operator` cannot be the caller.
1018      *
1019      * Emits an {ApprovalForAll} event.
1020      */
1021     function setApprovalForAll(address operator, bool approved) public virtual override {
1022         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1023         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1028      *
1029      * See {setApprovalForAll}.
1030      */
1031     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1032         return _operatorApprovals[owner][operator];
1033     }
1034 
1035     /**
1036      * @dev Returns whether `tokenId` exists.
1037      *
1038      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1039      *
1040      * Tokens start existing when they are minted. See {_mint}.
1041      */
1042     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1043         return
1044             _startTokenId() <= tokenId &&
1045             tokenId < _currentIndex && // If within bounds,
1046             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1047     }
1048 
1049     /**
1050      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1051      */
1052     function _isSenderApprovedOrOwner(
1053         address approvedAddress,
1054         address owner,
1055         address msgSender
1056     ) private pure returns (bool result) {
1057         assembly {
1058             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1059             owner := and(owner, _BITMASK_ADDRESS)
1060             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1061             msgSender := and(msgSender, _BITMASK_ADDRESS)
1062             // `msgSender == owner || msgSender == approvedAddress`.
1063             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1064         }
1065     }
1066 
1067     /**
1068      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1069      */
1070     function _getApprovedSlotAndAddress(uint256 tokenId)
1071         private
1072         view
1073         returns (uint256 approvedAddressSlot, address approvedAddress)
1074     {
1075         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1076         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1077         assembly {
1078             approvedAddressSlot := tokenApproval.slot
1079             approvedAddress := sload(approvedAddressSlot)
1080         }
1081     }
1082 
1083     // =============================================================
1084     //                      TRANSFER OPERATIONS
1085     // =============================================================
1086 
1087     /**
1088      * @dev Transfers `tokenId` from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `from` cannot be the zero address.
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must be owned by `from`.
1095      * - If the caller is not `from`, it must be approved to move this token
1096      * by either {approve} or {setApprovalForAll}.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function transferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) public payable virtual override {
1105         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1106 
1107         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1108 
1109         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1110 
1111         // The nested ifs save around 20+ gas over a compound boolean condition.
1112         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1113             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1114 
1115         if (to == address(0)) revert TransferToZeroAddress();
1116 
1117         _beforeTokenTransfers(from, to, tokenId, 1);
1118 
1119         // Clear approvals from the previous owner.
1120         assembly {
1121             if approvedAddress {
1122                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1123                 sstore(approvedAddressSlot, 0)
1124             }
1125         }
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1130         unchecked {
1131             // We can directly increment and decrement the balances.
1132             --_packedAddressData[from]; // Updates: `balance -= 1`.
1133             ++_packedAddressData[to]; // Updates: `balance += 1`.
1134 
1135             // Updates:
1136             // - `address` to the next owner.
1137             // - `startTimestamp` to the timestamp of transfering.
1138             // - `burned` to `false`.
1139             // - `nextInitialized` to `true`.
1140             _packedOwnerships[tokenId] = _packOwnershipData(
1141                 to,
1142                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1143             );
1144 
1145             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1146             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1147                 uint256 nextTokenId = tokenId + 1;
1148                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1149                 if (_packedOwnerships[nextTokenId] == 0) {
1150                     // If the next slot is within bounds.
1151                     if (nextTokenId != _currentIndex) {
1152                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1153                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1154                     }
1155                 }
1156             }
1157         }
1158 
1159         emit Transfer(from, to, tokenId);
1160         _afterTokenTransfers(from, to, tokenId, 1);
1161     }
1162 
1163     /**
1164      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) public payable virtual override {
1171         safeTransferFrom(from, to, tokenId, '');
1172     }
1173 
1174     /**
1175      * @dev Safely transfers `tokenId` token from `from` to `to`.
1176      *
1177      * Requirements:
1178      *
1179      * - `from` cannot be the zero address.
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must exist and be owned by `from`.
1182      * - If the caller is not `from`, it must be approved to move this token
1183      * by either {approve} or {setApprovalForAll}.
1184      * - If `to` refers to a smart contract, it must implement
1185      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) public payable virtual override {
1195         transferFrom(from, to, tokenId);
1196         if (to.code.length != 0)
1197             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1198                 revert TransferToNonERC721ReceiverImplementer();
1199             }
1200     }
1201 
1202     /**
1203      * @dev Hook that is called before a set of serially-ordered token IDs
1204      * are about to be transferred. This includes minting.
1205      * And also called before burning one token.
1206      *
1207      * `startTokenId` - the first token ID to be transferred.
1208      * `quantity` - the amount to be transferred.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, `tokenId` will be burned by `from`.
1216      * - `from` and `to` are never both zero.
1217      */
1218     function _beforeTokenTransfers(
1219         address from,
1220         address to,
1221         uint256 startTokenId,
1222         uint256 quantity
1223     ) internal virtual {}
1224 
1225     /**
1226      * @dev Hook that is called after a set of serially-ordered token IDs
1227      * have been transferred. This includes minting.
1228      * And also called after one token has been burned.
1229      *
1230      * `startTokenId` - the first token ID to be transferred.
1231      * `quantity` - the amount to be transferred.
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` has been minted for `to`.
1238      * - When `to` is zero, `tokenId` has been burned by `from`.
1239      * - `from` and `to` are never both zero.
1240      */
1241     function _afterTokenTransfers(
1242         address from,
1243         address to,
1244         uint256 startTokenId,
1245         uint256 quantity
1246     ) internal virtual {}
1247 
1248     /**
1249      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1250      *
1251      * `from` - Previous owner of the given token ID.
1252      * `to` - Target address that will receive the token.
1253      * `tokenId` - Token ID to be transferred.
1254      * `_data` - Optional data to send along with the call.
1255      *
1256      * Returns whether the call correctly returned the expected magic value.
1257      */
1258     function _checkContractOnERC721Received(
1259         address from,
1260         address to,
1261         uint256 tokenId,
1262         bytes memory _data
1263     ) private returns (bool) {
1264         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1265             bytes4 retval
1266         ) {
1267             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1268         } catch (bytes memory reason) {
1269             if (reason.length == 0) {
1270                 revert TransferToNonERC721ReceiverImplementer();
1271             } else {
1272                 assembly {
1273                     revert(add(32, reason), mload(reason))
1274                 }
1275             }
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                        MINT OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Mints `quantity` tokens and transfers them to `to`.
1285      *
1286      * Requirements:
1287      *
1288      * - `to` cannot be the zero address.
1289      * - `quantity` must be greater than 0.
1290      *
1291      * Emits a {Transfer} event for each mint.
1292      */
1293     function _mint(address to, uint256 quantity) internal virtual {
1294         uint256 startTokenId = _currentIndex;
1295         if (quantity == 0) revert MintZeroQuantity();
1296 
1297         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1298 
1299         // Overflows are incredibly unrealistic.
1300         // `balance` and `numberMinted` have a maximum limit of 2**64.
1301         // `tokenId` has a maximum limit of 2**256.
1302         unchecked {
1303             // Updates:
1304             // - `balance += quantity`.
1305             // - `numberMinted += quantity`.
1306             //
1307             // We can directly add to the `balance` and `numberMinted`.
1308             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1309 
1310             // Updates:
1311             // - `address` to the owner.
1312             // - `startTimestamp` to the timestamp of minting.
1313             // - `burned` to `false`.
1314             // - `nextInitialized` to `quantity == 1`.
1315             _packedOwnerships[startTokenId] = _packOwnershipData(
1316                 to,
1317                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1318             );
1319 
1320             uint256 toMasked;
1321             uint256 end = startTokenId + quantity;
1322 
1323             // Use assembly to loop and emit the `Transfer` event for gas savings.
1324             // The duplicated `log4` removes an extra check and reduces stack juggling.
1325             // The assembly, together with the surrounding Solidity code, have been
1326             // delicately arranged to nudge the compiler into producing optimized opcodes.
1327             assembly {
1328                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1329                 toMasked := and(to, _BITMASK_ADDRESS)
1330                 // Emit the `Transfer` event.
1331                 log4(
1332                     0, // Start of data (0, since no data).
1333                     0, // End of data (0, since no data).
1334                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1335                     0, // `address(0)`.
1336                     toMasked, // `to`.
1337                     startTokenId // `tokenId`.
1338                 )
1339 
1340                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1341                 // that overflows uint256 will make the loop run out of gas.
1342                 // The compiler will optimize the `iszero` away for performance.
1343                 for {
1344                     let tokenId := add(startTokenId, 1)
1345                 } iszero(eq(tokenId, end)) {
1346                     tokenId := add(tokenId, 1)
1347                 } {
1348                     // Emit the `Transfer` event. Similar to above.
1349                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1350                 }
1351             }
1352             if (toMasked == 0) revert MintToZeroAddress();
1353 
1354             _currentIndex = end;
1355         }
1356         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1357     }
1358 
1359     /**
1360      * @dev Mints `quantity` tokens and transfers them to `to`.
1361      *
1362      * This function is intended for efficient minting only during contract creation.
1363      *
1364      * It emits only one {ConsecutiveTransfer} as defined in
1365      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1366      * instead of a sequence of {Transfer} event(s).
1367      *
1368      * Calling this function outside of contract creation WILL make your contract
1369      * non-compliant with the ERC721 standard.
1370      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1371      * {ConsecutiveTransfer} event is only permissible during contract creation.
1372      *
1373      * Requirements:
1374      *
1375      * - `to` cannot be the zero address.
1376      * - `quantity` must be greater than 0.
1377      *
1378      * Emits a {ConsecutiveTransfer} event.
1379      */
1380     function _mintERC2309(address to, uint256 quantity) internal virtual {
1381         uint256 startTokenId = _currentIndex;
1382         if (to == address(0)) revert MintToZeroAddress();
1383         if (quantity == 0) revert MintZeroQuantity();
1384         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1385 
1386         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1387 
1388         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1389         unchecked {
1390             // Updates:
1391             // - `balance += quantity`.
1392             // - `numberMinted += quantity`.
1393             //
1394             // We can directly add to the `balance` and `numberMinted`.
1395             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1396 
1397             // Updates:
1398             // - `address` to the owner.
1399             // - `startTimestamp` to the timestamp of minting.
1400             // - `burned` to `false`.
1401             // - `nextInitialized` to `quantity == 1`.
1402             _packedOwnerships[startTokenId] = _packOwnershipData(
1403                 to,
1404                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1405             );
1406 
1407             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1408 
1409             _currentIndex = startTokenId + quantity;
1410         }
1411         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1412     }
1413 
1414     /**
1415      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1416      *
1417      * Requirements:
1418      *
1419      * - If `to` refers to a smart contract, it must implement
1420      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1421      * - `quantity` must be greater than 0.
1422      *
1423      * See {_mint}.
1424      *
1425      * Emits a {Transfer} event for each mint.
1426      */
1427     function _safeMint(
1428         address to,
1429         uint256 quantity,
1430         bytes memory _data
1431     ) internal virtual {
1432         _mint(to, quantity);
1433 
1434         unchecked {
1435             if (to.code.length != 0) {
1436                 uint256 end = _currentIndex;
1437                 uint256 index = end - quantity;
1438                 do {
1439                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1440                         revert TransferToNonERC721ReceiverImplementer();
1441                     }
1442                 } while (index < end);
1443                 // Reentrancy protection.
1444                 if (_currentIndex != end) revert();
1445             }
1446         }
1447     }
1448 
1449     /**
1450      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1451      */
1452     function _safeMint(address to, uint256 quantity) internal virtual {
1453         _safeMint(to, quantity, '');
1454     }
1455 
1456     // =============================================================
1457     //                        BURN OPERATIONS
1458     // =============================================================
1459 
1460     /**
1461      * @dev Equivalent to `_burn(tokenId, false)`.
1462      */
1463     function _burn(uint256 tokenId) internal virtual {
1464         _burn(tokenId, false);
1465     }
1466 
1467     /**
1468      * @dev Destroys `tokenId`.
1469      * The approval is cleared when the token is burned.
1470      *
1471      * Requirements:
1472      *
1473      * - `tokenId` must exist.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1478         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1479 
1480         address from = address(uint160(prevOwnershipPacked));
1481 
1482         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1483 
1484         if (approvalCheck) {
1485             // The nested ifs save around 20+ gas over a compound boolean condition.
1486             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1487                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1488         }
1489 
1490         _beforeTokenTransfers(from, address(0), tokenId, 1);
1491 
1492         // Clear approvals from the previous owner.
1493         assembly {
1494             if approvedAddress {
1495                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1496                 sstore(approvedAddressSlot, 0)
1497             }
1498         }
1499 
1500         // Underflow of the sender's balance is impossible because we check for
1501         // ownership above and the recipient's balance can't realistically overflow.
1502         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1503         unchecked {
1504             // Updates:
1505             // - `balance -= 1`.
1506             // - `numberBurned += 1`.
1507             //
1508             // We can directly decrement the balance, and increment the number burned.
1509             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1510             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1511 
1512             // Updates:
1513             // - `address` to the last owner.
1514             // - `startTimestamp` to the timestamp of burning.
1515             // - `burned` to `true`.
1516             // - `nextInitialized` to `true`.
1517             _packedOwnerships[tokenId] = _packOwnershipData(
1518                 from,
1519                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1520             );
1521 
1522             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1523             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1524                 uint256 nextTokenId = tokenId + 1;
1525                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1526                 if (_packedOwnerships[nextTokenId] == 0) {
1527                     // If the next slot is within bounds.
1528                     if (nextTokenId != _currentIndex) {
1529                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1530                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1531                     }
1532                 }
1533             }
1534         }
1535 
1536         emit Transfer(from, address(0), tokenId);
1537         _afterTokenTransfers(from, address(0), tokenId, 1);
1538 
1539         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1540         unchecked {
1541             _burnCounter++;
1542         }
1543     }
1544 
1545     // =============================================================
1546     //                     EXTRA DATA OPERATIONS
1547     // =============================================================
1548 
1549     /**
1550      * @dev Directly sets the extra data for the ownership data `index`.
1551      */
1552     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1553         uint256 packed = _packedOwnerships[index];
1554         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1555         uint256 extraDataCasted;
1556         // Cast `extraData` with assembly to avoid redundant masking.
1557         assembly {
1558             extraDataCasted := extraData
1559         }
1560         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1561         _packedOwnerships[index] = packed;
1562     }
1563 
1564     /**
1565      * @dev Called during each token transfer to set the 24bit `extraData` field.
1566      * Intended to be overridden by the cosumer contract.
1567      *
1568      * `previousExtraData` - the value of `extraData` before transfer.
1569      *
1570      * Calling conditions:
1571      *
1572      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1573      * transferred to `to`.
1574      * - When `from` is zero, `tokenId` will be minted for `to`.
1575      * - When `to` is zero, `tokenId` will be burned by `from`.
1576      * - `from` and `to` are never both zero.
1577      */
1578     function _extraData(
1579         address from,
1580         address to,
1581         uint24 previousExtraData
1582     ) internal view virtual returns (uint24) {}
1583 
1584     /**
1585      * @dev Returns the next extra data for the packed ownership data.
1586      * The returned result is shifted into position.
1587      */
1588     function _nextExtraData(
1589         address from,
1590         address to,
1591         uint256 prevOwnershipPacked
1592     ) private view returns (uint256) {
1593         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1594         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1595     }
1596 
1597     // =============================================================
1598     //                       OTHER OPERATIONS
1599     // =============================================================
1600 
1601     /**
1602      * @dev Returns the message sender (defaults to `msg.sender`).
1603      *
1604      * If you are writing GSN compatible contracts, you need to override this function.
1605      */
1606     function _msgSenderERC721A() internal view virtual returns (address) {
1607         return msg.sender;
1608     }
1609 
1610     /**
1611      * @dev Converts a uint256 to its ASCII string decimal representation.
1612      */
1613     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1614         assembly {
1615             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1616             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1617             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1618             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1619             let m := add(mload(0x40), 0xa0)
1620             // Update the free memory pointer to allocate.
1621             mstore(0x40, m)
1622             // Assign the `str` to the end.
1623             str := sub(m, 0x20)
1624             // Zeroize the slot after the string.
1625             mstore(str, 0)
1626 
1627             // Cache the end of the memory to calculate the length later.
1628             let end := str
1629 
1630             // We write the string from rightmost digit to leftmost digit.
1631             // The following is essentially a do-while loop that also handles the zero case.
1632             // prettier-ignore
1633             for { let temp := value } 1 {} {
1634                 str := sub(str, 1)
1635                 // Write the character to the pointer.
1636                 // The ASCII index of the '0' character is 48.
1637                 mstore8(str, add(48, mod(temp, 10)))
1638                 // Keep dividing `temp` until zero.
1639                 temp := div(temp, 10)
1640                 // prettier-ignore
1641                 if iszero(temp) { break }
1642             }
1643 
1644             let length := sub(end, str)
1645             // Move the pointer 32 bytes leftwards to make room for the length.
1646             str := sub(str, 0x20)
1647             // Store the length.
1648             mstore(str, length)
1649         }
1650     }
1651 }
1652 
1653 // File: contracts/test.sol
1654 
1655 
1656 pragma solidity ^0.8.13;
1657 
1658 
1659 
1660 
1661 
1662 contract ApeFeetPixWtf is ERC721A, Ownable, OperatorFilterer {
1663     using Strings for uint256;
1664 
1665     uint256 public maxSupply = 5000;
1666 	  uint256 public Ownermint = 1;
1667     uint256 public maxPerAddress = 60;
1668 	  uint256 public maxPerTX = 10;
1669     uint256 public cost = 0.001 ether;
1670 	  mapping(address => bool) public freeMinted; 
1671     address public constant OSlist = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1672 
1673 
1674     bool public paused = true;
1675     bool public revealed = false;
1676 
1677 	  string public uriPrefix = '';
1678     string public uriSuffix = '.json';
1679     string public hiddenURI = '';
1680 	
1681   constructor(string memory baseURI) ERC721A("ApeFeetPix.WTF", "AFPW") OperatorFilterer(address(OSlist), false) {
1682       sethiddenURI(baseURI); 
1683       _safeMint(_msgSender(), Ownermint);
1684 
1685   }
1686 
1687   modifier callerIsUser() {
1688         require(tx.origin == msg.sender, "The caller is another contract");
1689         _;
1690     }
1691 
1692   function numberMinted(address owner) public view returns (uint256) {
1693         return _numberMinted(owner);
1694     }
1695 
1696   function mint(uint256 _mintAmount) public payable callerIsUser{
1697         require(!paused, 'The contract is paused!');
1698         require(numberMinted(msg.sender) + _mintAmount <= maxPerAddress, 'PER_WALLET_LIMIT_REACHED');
1699         require(_mintAmount > 0 && _mintAmount <= maxPerTX, 'Invalid mint amount!');
1700         require(totalSupply() + _mintAmount <= (maxSupply), 'Max supply exceeded!');
1701 	if (freeMinted[_msgSender()]){
1702         require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1703     }
1704     else{
1705 		require(msg.value >= cost * _mintAmount - cost, 'Insufficient funds!');
1706         freeMinted[_msgSender()] = true;
1707 	}
1708 
1709     _safeMint(_msgSender(), _mintAmount);
1710   }
1711 
1712   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1713     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1714      if (!revealed) {
1715             return hiddenURI;
1716         }
1717     string memory currentBaseURI = _baseURI();
1718     return bytes(currentBaseURI).length > 0
1719         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1720         : '';
1721   }
1722 
1723   function setPaused() public onlyOwner {
1724     paused = !paused;
1725   }
1726 
1727   function reveal() public onlyOwner {
1728         revealed = !revealed;
1729   }
1730 
1731   function setCost(uint256 _cost) public onlyOwner {
1732     cost = _cost;
1733   }
1734 
1735   function setmaxPerTX(uint256 _maxPerTX) public onlyOwner {
1736     maxPerTX = _maxPerTX;
1737   }
1738 
1739   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1740     uriPrefix = _uriPrefix;
1741   }
1742   function sethiddenURI(string memory _hiddenURI) public onlyOwner {
1743     hiddenURI = _hiddenURI;
1744   }
1745 
1746   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1747     uriSuffix = _uriSuffix;
1748   }
1749 
1750   function withdraw() external onlyOwner{
1751     payable(msg.sender).transfer(address(this).balance);
1752   }
1753 
1754   // Internal ->
1755   function _startTokenId() internal view virtual override returns (uint256) {
1756     return 1;
1757   }
1758 
1759   function _baseURI() internal view virtual override returns (string memory) {
1760     return uriPrefix;
1761   }
1762 
1763     function transferFrom(address from, address to, uint256 tokenId)
1764         public
1765         payable
1766         override
1767         onlyAllowedOperator(from)
1768     {
1769         super.transferFrom(from, to, tokenId);
1770     }
1771 
1772     function safeTransferFrom(address from, address to, uint256 tokenId)
1773         public
1774         payable
1775         override
1776         onlyAllowedOperator(from)
1777     {
1778         super.safeTransferFrom(from, to, tokenId);
1779     }
1780 
1781     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1782         public
1783         payable
1784         override
1785         onlyAllowedOperator(from)
1786     {
1787         super.safeTransferFrom(from, to, tokenId, data);
1788     }
1789 }