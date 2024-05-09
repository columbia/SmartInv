1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: contracts/IOperatorFilterRegistry.sol
5 
6 
7 pragma solidity ^0.8.13;
8 
9 interface IOperatorFilterRegistry {
10     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
11     function register(address registrant) external;
12     function registerAndSubscribe(address registrant, address subscription) external;
13     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
14     function unregister(address addr) external;
15     function updateOperator(address registrant, address operator, bool filtered) external;
16     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
17     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
18     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
19     function subscribe(address registrant, address registrantToSubscribe) external;
20     function unsubscribe(address registrant, bool copyExistingEntries) external;
21     function subscriptionOf(address addr) external returns (address registrant);
22     function subscribers(address registrant) external returns (address[] memory);
23     function subscriberAt(address registrant, uint256 index) external returns (address);
24     function copyEntriesOf(address registrant, address registrantToCopy) external;
25     function isOperatorFiltered(address registrant, address operator) external returns (bool);
26     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
27     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
28     function filteredOperators(address addr) external returns (address[] memory);
29     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
30     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
31     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
32     function isRegistered(address addr) external returns (bool);
33     function codeHashOf(address addr) external returns (bytes32);
34 }
35 
36 // File: contracts/OperatorFilterer.sol
37 
38 
39 pragma solidity ^0.8.13;
40 
41 
42 abstract contract OperatorFilterer {
43     error OperatorNotAllowed(address operator);
44 
45     IOperatorFilterRegistry constant operatorFilterRegistry =
46         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
47 
48     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
49         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
50         // will not revert, but the contract will need to be registered with the registry once it is deployed in
51         // order for the modifier to filter addresses.
52         if (address(operatorFilterRegistry).code.length > 0) {
53             if (subscribe) {
54                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
55             } else {
56                 if (subscriptionOrRegistrantToCopy != address(0)) {
57                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
58                 } else {
59                     operatorFilterRegistry.register(address(this));
60                 }
61             }
62         }
63     }
64 
65     modifier onlyAllowedOperator(address from) virtual {
66         // Check registry code length to facilitate testing in environments without a deployed registry.
67         if (address(operatorFilterRegistry).code.length > 0) {
68             // Allow spending tokens from addresses with balance
69             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
70             // from an EOA.
71             if (from == msg.sender) {
72                 _;
73                 return;
74             }
75             if (
76                 !(
77                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
78                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
79                 )
80             ) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 }
87 
88 // File: contracts/DefaultOperatorFilterer.sol
89 
90 
91 pragma solidity ^0.8.13;
92 
93 
94 abstract contract DefaultOperatorFilterer is OperatorFilterer {
95     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
96 
97     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
98 }
99 
100 // File: contracts/IERC721A.sol
101 
102 
103 // ERC721A Contracts v4.2.3
104 // Creator: Chiru Labs
105 
106 pragma solidity ^0.8.4;
107 
108 /**
109  * @dev Interface of ERC721A.
110  */
111 interface IERC721A {
112     /**
113      * The caller must own the token or be an approved operator.
114      */
115     error ApprovalCallerNotOwnerNorApproved();
116 
117     /**
118      * The token does not exist.
119      */
120     error ApprovalQueryForNonexistentToken();
121 
122     /**
123      * Cannot query the balance for the zero address.
124      */
125     error BalanceQueryForZeroAddress();
126 
127     /**
128      * Cannot mint to the zero address.
129      */
130     error MintToZeroAddress();
131 
132     /**
133      * The quantity of tokens minted must be more than zero.
134      */
135     error MintZeroQuantity();
136 
137     /**
138      * The token does not exist.
139      */
140     error OwnerQueryForNonexistentToken();
141 
142     /**
143      * The caller must own the token or be an approved operator.
144      */
145     error TransferCallerNotOwnerNorApproved();
146 
147     /**
148      * The token must be owned by `from`.
149      */
150     error TransferFromIncorrectOwner();
151 
152     /**
153      * Cannot safely transfer to a contract that does not implement the
154      * ERC721Receiver interface.
155      */
156     error TransferToNonERC721ReceiverImplementer();
157 
158     /**
159      * Cannot transfer to the zero address.
160      */
161     error TransferToZeroAddress();
162 
163     /**
164      * The token does not exist.
165      */
166     error URIQueryForNonexistentToken();
167 
168     /**
169      * The `quantity` minted with ERC2309 exceeds the safety limit.
170      */
171     error MintERC2309QuantityExceedsLimit();
172 
173     /**
174      * The `extraData` cannot be set on an unintialized ownership slot.
175      */
176     error OwnershipNotInitializedForExtraData();
177 
178     // =============================================================
179     //                            STRUCTS
180     // =============================================================
181 
182     struct TokenOwnership {
183         // The address of the owner.
184         address addr;
185         // Stores the start time of ownership with minimal overhead for tokenomics.
186         uint64 startTimestamp;
187         // Whether the token has been burned.
188         bool burned;
189         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
190         uint24 extraData;
191     }
192 
193     // =============================================================
194     //                         TOKEN COUNTERS
195     // =============================================================
196 
197     /**
198      * @dev Returns the total number of tokens in existence.
199      * Burned tokens will reduce the count.
200      * To get the total number of tokens minted, please see {_totalMinted}.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     // =============================================================
205     //                            IERC165
206     // =============================================================
207 
208     /**
209      * @dev Returns true if this contract implements the interface defined by
210      * `interfaceId`. See the corresponding
211      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
212      * to learn more about how these ids are created.
213      *
214      * This function call must use less than 30000 gas.
215      */
216     function supportsInterface(bytes4 interfaceId) external view returns (bool);
217 
218     // =============================================================
219     //                            IERC721
220     // =============================================================
221 
222     /**
223      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
231 
232     /**
233      * @dev Emitted when `owner` enables or disables
234      * (`approved`) `operator` to manage all of its assets.
235      */
236     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
237 
238     /**
239      * @dev Returns the number of tokens in `owner`'s account.
240      */
241     function balanceOf(address owner) external view returns (uint256 balance);
242 
243     /**
244      * @dev Returns the owner of the `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function ownerOf(uint256 tokenId) external view returns (address owner);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`,
254      * checking first that contract recipients are aware of the ERC721 protocol
255      * to prevent tokens from being forever locked.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be have been allowed to move
263      * this token by either {approve} or {setApprovalForAll}.
264      * - If `to` refers to a smart contract, it must implement
265      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
266      *
267      * Emits a {Transfer} event.
268      */
269     function safeTransferFrom(
270         address from,
271         address to,
272         uint256 tokenId,
273         bytes calldata data
274     ) external payable;
275 
276     /**
277      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     ) external payable;
284 
285     /**
286      * @dev Transfers `tokenId` from `from` to `to`.
287      *
288      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
289      * whenever possible.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must be owned by `from`.
296      * - If the caller is not `from`, it must be approved to move this token
297      * by either {approve} or {setApprovalForAll}.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external payable;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the
312      * zero address clears previous approvals.
313      *
314      * Requirements:
315      *
316      * - The caller must own the token or be an approved operator.
317      * - `tokenId` must exist.
318      *
319      * Emits an {Approval} event.
320      */
321     function approve(address to, uint256 tokenId) external payable;
322 
323     /**
324      * @dev Approve or remove `operator` as an operator for the caller.
325      * Operators can call {transferFrom} or {safeTransferFrom}
326      * for any token owned by the caller.
327      *
328      * Requirements:
329      *
330      * - The `operator` cannot be the caller.
331      *
332      * Emits an {ApprovalForAll} event.
333      */
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     /**
337      * @dev Returns the account approved for `tokenId` token.
338      *
339      * Requirements:
340      *
341      * - `tokenId` must exist.
342      */
343     function getApproved(uint256 tokenId) external view returns (address operator);
344 
345     /**
346      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
347      *
348      * See {setApprovalForAll}.
349      */
350     function isApprovedForAll(address owner, address operator) external view returns (bool);
351 
352     // =============================================================
353     //                        IERC721Metadata
354     // =============================================================
355 
356     /**
357      * @dev Returns the token collection name.
358      */
359     function name() external view returns (string memory);
360 
361     /**
362      * @dev Returns the token collection symbol.
363      */
364     function symbol() external view returns (string memory);
365 
366     /**
367      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
368      */
369     function tokenURI(uint256 tokenId) external view returns (string memory);
370 
371     // =============================================================
372     //                           IERC2309
373     // =============================================================
374 
375     /**
376      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
377      * (inclusive) is transferred from `from` to `to`, as defined in the
378      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
379      *
380      * See {_mintERC2309} for more details.
381      */
382     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
383 }
384 // File: contracts/ERC721A.sol
385 
386 
387 // ERC721A Contracts v4.2.3
388 // Creator: Chiru Labs
389 
390 pragma solidity ^0.8.4;
391 
392 
393 /**
394  * @dev Interface of ERC721 token receiver.
395  */
396 interface ERC721A__IERC721Receiver {
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 /**
406  * @title ERC721A
407  *
408  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
409  * Non-Fungible Token Standard, including the Metadata extension.
410  * Optimized for lower gas during batch mints.
411  *
412  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
413  * starting from `_startTokenId()`.
414  *
415  * Assumptions:
416  *
417  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
418  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
419  */
420 contract ERC721A is IERC721A, DefaultOperatorFilterer {
421     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
422     struct TokenApprovalRef {
423         address value;
424     }
425 
426     // =============================================================
427     //                           CONSTANTS
428     // =============================================================
429 
430     // Mask of an entry in packed address data.
431     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
432 
433     // The bit position of `numberMinted` in packed address data.
434     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
435 
436     // The bit position of `numberBurned` in packed address data.
437     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
438 
439     // The bit position of `aux` in packed address data.
440     uint256 private constant _BITPOS_AUX = 192;
441 
442     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
443     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
444 
445     // The bit position of `startTimestamp` in packed ownership.
446     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
447 
448     // The bit mask of the `burned` bit in packed ownership.
449     uint256 private constant _BITMASK_BURNED = 1 << 224;
450 
451     // The bit position of the `nextInitialized` bit in packed ownership.
452     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
453 
454     // The bit mask of the `nextInitialized` bit in packed ownership.
455     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
456 
457     // The bit position of `extraData` in packed ownership.
458     uint256 private constant _BITPOS_EXTRA_DATA = 232;
459 
460     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
461     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
462 
463     // The mask of the lower 160 bits for addresses.
464     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
465 
466     // The maximum `quantity` that can be minted with {_mintERC2309}.
467     // This limit is to prevent overflows on the address data entries.
468     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
469     // is required to cause an overflow, which is unrealistic.
470     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
471 
472     // The `Transfer` event signature is given by:
473     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
474     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
475         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
476 
477     // =============================================================
478     //                            STORAGE
479     // =============================================================
480 
481     // The next token ID to be minted.
482     uint256 private _currentIndex;
483 
484     // The number of tokens burned.
485     uint256 private _burnCounter;
486 
487     // Token name
488     string private _name;
489 
490     // Token symbol
491     string private _symbol;
492 
493     // Mapping from token ID to ownership details
494     // An empty struct value does not necessarily mean the token is unowned.
495     // See {_packedOwnershipOf} implementation for details.
496     //
497     // Bits Layout:
498     // - [0..159]   `addr`
499     // - [160..223] `startTimestamp`
500     // - [224]      `burned`
501     // - [225]      `nextInitialized`
502     // - [232..255] `extraData`
503     mapping(uint256 => uint256) private _packedOwnerships;
504 
505     // Mapping owner address to address data.
506     //
507     // Bits Layout:
508     // - [0..63]    `balance`
509     // - [64..127]  `numberMinted`
510     // - [128..191] `numberBurned`
511     // - [192..255] `aux`
512     mapping(address => uint256) private _packedAddressData;
513 
514     // Mapping from token ID to approved address.
515     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
516 
517     // Mapping from owner to operator approvals
518     mapping(address => mapping(address => bool)) private _operatorApprovals;
519 
520     // =============================================================
521     //                          CONSTRUCTOR
522     // =============================================================
523 
524     constructor(string memory name_, string memory symbol_) {
525         _name = name_;
526         _symbol = symbol_;
527         _currentIndex = _startTokenId();
528     }
529 
530     // =============================================================
531     //                   TOKEN COUNTING OPERATIONS
532     // =============================================================
533 
534     /**
535      * @dev Returns the starting token ID.
536      * To change the starting token ID, please override this function.
537      */
538     function _startTokenId() internal view virtual returns (uint256) {
539         return 1;
540     }
541 
542     /**
543      * @dev Returns the next token ID to be minted.
544      */
545     function _nextTokenId() internal view virtual returns (uint256) {
546         return _currentIndex;
547     }
548 
549     /**
550      * @dev Returns the total number of tokens in existence.
551      * Burned tokens will reduce the count.
552      * To get the total number of tokens minted, please see {_totalMinted}.
553      */
554     function totalSupply() public view virtual override returns (uint256) {
555         // Counter underflow is impossible as _burnCounter cannot be incremented
556         // more than `_currentIndex - _startTokenId()` times.
557         unchecked {
558             return _currentIndex - _burnCounter - _startTokenId();
559         }
560     }
561 
562     /**
563      * @dev Returns the total amount of tokens minted in the contract.
564      */
565     function _totalMinted() internal view virtual returns (uint256) {
566         // Counter underflow is impossible as `_currentIndex` does not decrement,
567         // and it is initialized to `_startTokenId()`.
568         unchecked {
569             return _currentIndex - _startTokenId();
570         }
571     }
572 
573     /**
574      * @dev Returns the total number of tokens burned.
575      */
576     function _totalBurned() internal view virtual returns (uint256) {
577         return _burnCounter;
578     }
579 
580     // =============================================================
581     //                    ADDRESS DATA OPERATIONS
582     // =============================================================
583 
584     /**
585      * @dev Returns the number of tokens in `owner`'s account.
586      */
587     function balanceOf(address owner) public view virtual override returns (uint256) {
588         if (owner == address(0)) revert BalanceQueryForZeroAddress();
589         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
590     }
591 
592     /**
593      * Returns the number of tokens minted by `owner`.
594      */
595     function _numberMinted(address owner) internal view returns (uint256) {
596         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
597     }
598 
599     /**
600      * Returns the number of tokens burned by or on behalf of `owner`.
601      */
602     function _numberBurned(address owner) internal view returns (uint256) {
603         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
604     }
605 
606     /**
607      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
608      */
609     function _getAux(address owner) internal view returns (uint64) {
610         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
611     }
612 
613     /**
614      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
615      * If there are multiple variables, please pack them into a uint64.
616      */
617     function _setAux(address owner, uint64 aux) internal virtual {
618         uint256 packed = _packedAddressData[owner];
619         uint256 auxCasted;
620         // Cast `aux` with assembly to avoid redundant masking.
621         assembly {
622             auxCasted := aux
623         }
624         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
625         _packedAddressData[owner] = packed;
626     }
627 
628     // =============================================================
629     //                            IERC165
630     // =============================================================
631 
632     /**
633      * @dev Returns true if this contract implements the interface defined by
634      * `interfaceId`. See the corresponding
635      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
636      * to learn more about how these ids are created.
637      *
638      * This function call must use less than 30000 gas.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641         // The interface IDs are constants representing the first 4 bytes
642         // of the XOR of all function selectors in the interface.
643         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
644         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
645         return
646             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
647             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
648             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
649     }
650 
651     // =============================================================
652     //                        IERC721Metadata
653     // =============================================================
654 
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev Returns the token collection symbol.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, it can be overridden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return '';
686     }
687 
688     // =============================================================
689     //                     OWNERSHIPS OPERATIONS
690     // =============================================================
691 
692     /**
693      * @dev Returns the owner of the `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
700         return address(uint160(_packedOwnershipOf(tokenId)));
701     }
702 
703     /**
704      * @dev Gas spent here starts off proportional to the maximum mint batch size.
705      * It gradually moves to O(1) as tokens get transferred around over time.
706      */
707     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
708         return _unpackedOwnership(_packedOwnershipOf(tokenId));
709     }
710 
711     /**
712      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
713      */
714     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
715         return _unpackedOwnership(_packedOwnerships[index]);
716     }
717 
718     /**
719      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
720      */
721     function _initializeOwnershipAt(uint256 index) internal virtual {
722         if (_packedOwnerships[index] == 0) {
723             _packedOwnerships[index] = _packedOwnershipOf(index);
724         }
725     }
726 
727     /**
728      * Returns the packed ownership data of `tokenId`.
729      */
730     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
731         uint256 curr = tokenId;
732 
733         unchecked {
734             if (_startTokenId() <= curr)
735                 if (curr < _currentIndex) {
736                     uint256 packed = _packedOwnerships[curr];
737                     // If not burned.
738                     if (packed & _BITMASK_BURNED == 0) {
739                         // Invariant:
740                         // There will always be an initialized ownership slot
741                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
742                         // before an unintialized ownership slot
743                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
744                         // Hence, `curr` will not underflow.
745                         //
746                         // We can directly compare the packed value.
747                         // If the address is zero, packed will be zero.
748                         while (packed == 0) {
749                             packed = _packedOwnerships[--curr];
750                         }
751                         return packed;
752                     }
753                 }
754         }
755         revert OwnerQueryForNonexistentToken();
756     }
757 
758     /**
759      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
760      */
761     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
762         ownership.addr = address(uint160(packed));
763         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
764         ownership.burned = packed & _BITMASK_BURNED != 0;
765         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
766     }
767 
768     /**
769      * @dev Packs ownership data into a single uint256.
770      */
771     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
772         assembly {
773             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
774             owner := and(owner, _BITMASK_ADDRESS)
775             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
776             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
777         }
778     }
779 
780     /**
781      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
782      */
783     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
784         // For branchless setting of the `nextInitialized` flag.
785         assembly {
786             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
787             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
788         }
789     }
790 
791     // =============================================================
792     //                      APPROVAL OPERATIONS
793     // =============================================================
794 
795     /**
796      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
797      * The approval is cleared when the token is transferred.
798      *
799      * Only a single account can be approved at a time, so approving the
800      * zero address clears previous approvals.
801      *
802      * Requirements:
803      *
804      * - The caller must own the token or be an approved operator.
805      * - `tokenId` must exist.
806      *
807      * Emits an {Approval} event.
808      */
809     function approve(address to, uint256 tokenId) public payable virtual override {
810         address owner = ownerOf(tokenId);
811 
812         if (_msgSenderERC721A() != owner)
813             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
814                 revert ApprovalCallerNotOwnerNorApproved();
815             }
816 
817         _tokenApprovals[tokenId].value = to;
818         emit Approval(owner, to, tokenId);
819     }
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId) public view virtual override returns (address) {
829         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
830 
831         return _tokenApprovals[tokenId].value;
832     }
833 
834     /**
835      * @dev Approve or remove `operator` as an operator for the caller.
836      * Operators can call {transferFrom} or {safeTransferFrom}
837      * for any token owned by the caller.
838      *
839      * Requirements:
840      *
841      * - The `operator` cannot be the caller.
842      *
843      * Emits an {ApprovalForAll} event.
844      */
845     function setApprovalForAll(address operator, bool approved) public virtual override {
846         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
847         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
848     }
849 
850     /**
851      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
852      *
853      * See {setApprovalForAll}.
854      */
855     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev Returns whether `tokenId` exists.
861      *
862      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
863      *
864      * Tokens start existing when they are minted. See {_mint}.
865      */
866     function _exists(uint256 tokenId) internal view virtual returns (bool) {
867         return
868             _startTokenId() <= tokenId &&
869             tokenId < _currentIndex && // If within bounds,
870             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
871     }
872 
873     /**
874      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
875      */
876     function _isSenderApprovedOrOwner(
877         address approvedAddress,
878         address owner,
879         address msgSender
880     ) private pure returns (bool result) {
881         assembly {
882             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
883             owner := and(owner, _BITMASK_ADDRESS)
884             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
885             msgSender := and(msgSender, _BITMASK_ADDRESS)
886             // `msgSender == owner || msgSender == approvedAddress`.
887             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
888         }
889     }
890 
891     /**
892      * @dev Returns the storage slot and value for the approved address of `tokenId`.
893      */
894     function _getApprovedSlotAndAddress(uint256 tokenId)
895         private
896         view
897         returns (uint256 approvedAddressSlot, address approvedAddress)
898     {
899         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
900         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
901         assembly {
902             approvedAddressSlot := tokenApproval.slot
903             approvedAddress := sload(approvedAddressSlot)
904         }
905     }
906 
907     // =============================================================
908     //                      TRANSFER OPERATIONS
909     // =============================================================
910 
911     /**
912      * @dev Transfers `tokenId` from `from` to `to`.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must be owned by `from`.
919      * - If the caller is not `from`, it must be approved to move this token
920      * by either {approve} or {setApprovalForAll}.
921      *
922      * Emits a {Transfer} event.
923      */
924         function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
925         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
926         address owner = ERC721A.ownerOf(tokenId);
927         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
928     }
929     function transferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public payable virtual override onlyAllowedOperator(from){
934         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
935 
936         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
937 
938         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
939 
940         // The nested ifs save around 20+ gas over a compound boolean condition.
941         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
942             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
943 
944         if (to == address(0)) revert TransferToZeroAddress();
945 
946         _beforeTokenTransfers(from, to, tokenId, 1);
947 
948         // Clear approvals from the previous owner.
949         assembly {
950             if approvedAddress {
951                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
952                 sstore(approvedAddressSlot, 0)
953             }
954         }
955 
956         // Underflow of the sender's balance is impossible because we check for
957         // ownership above and the recipient's balance can't realistically overflow.
958         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
959         unchecked {
960             // We can directly increment and decrement the balances.
961             --_packedAddressData[from]; // Updates: `balance -= 1`.
962             ++_packedAddressData[to]; // Updates: `balance += 1`.
963 
964             // Updates:
965             // - `address` to the next owner.
966             // - `startTimestamp` to the timestamp of transfering.
967             // - `burned` to `false`.
968             // - `nextInitialized` to `true`.
969             _packedOwnerships[tokenId] = _packOwnershipData(
970                 to,
971                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
972             );
973 
974             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
975             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
976                 uint256 nextTokenId = tokenId + 1;
977                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
978                 if (_packedOwnerships[nextTokenId] == 0) {
979                     // If the next slot is within bounds.
980                     if (nextTokenId != _currentIndex) {
981                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
982                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
983                     }
984                 }
985             }
986         }
987 
988         emit Transfer(from, to, tokenId);
989         _afterTokenTransfers(from, to, tokenId, 1);
990     }
991 
992     /**
993      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public payable virtual override onlyAllowedOperator(from){
1000         safeTransferFrom(from, to, tokenId, '');
1001     }
1002 
1003     /**
1004      * @dev Safely transfers `tokenId` token from `from` to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must exist and be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token
1012      * by either {approve} or {setApprovalForAll}.
1013      * - If `to` refers to a smart contract, it must implement
1014      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) public payable virtual override onlyAllowedOperator(from){
1024         transferFrom(from, to, tokenId);
1025         if (to.code.length != 0)
1026             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1027                 revert TransferToNonERC721ReceiverImplementer();
1028             }
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before a set of serially-ordered token IDs
1033      * are about to be transferred. This includes minting.
1034      * And also called before burning one token.
1035      *
1036      * `startTokenId` - the first token ID to be transferred.
1037      * `quantity` - the amount to be transferred.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` will be minted for `to`.
1044      * - When `to` is zero, `tokenId` will be burned by `from`.
1045      * - `from` and `to` are never both zero.
1046      */
1047     function _beforeTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Hook that is called after a set of serially-ordered token IDs
1056      * have been transferred. This includes minting.
1057      * And also called after one token has been burned.
1058      *
1059      * `startTokenId` - the first token ID to be transferred.
1060      * `quantity` - the amount to be transferred.
1061      *
1062      * Calling conditions:
1063      *
1064      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1065      * transferred to `to`.
1066      * - When `from` is zero, `tokenId` has been minted for `to`.
1067      * - When `to` is zero, `tokenId` has been burned by `from`.
1068      * - `from` and `to` are never both zero.
1069      */
1070     function _afterTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 
1077     /**
1078      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1079      *
1080      * `from` - Previous owner of the given token ID.
1081      * `to` - Target address that will receive the token.
1082      * `tokenId` - Token ID to be transferred.
1083      * `_data` - Optional data to send along with the call.
1084      *
1085      * Returns whether the call correctly returned the expected magic value.
1086      */
1087     function _checkContractOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) private returns (bool) {
1093         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1094             bytes4 retval
1095         ) {
1096             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1097         } catch (bytes memory reason) {
1098             if (reason.length == 0) {
1099                 revert TransferToNonERC721ReceiverImplementer();
1100             } else {
1101                 assembly {
1102                     revert(add(32, reason), mload(reason))
1103                 }
1104             }
1105         }
1106     }
1107 
1108     // =============================================================
1109     //                        MINT OPERATIONS
1110     // =============================================================
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event for each mint.
1121      */
1122     function _mint(address to, uint256 quantity) internal virtual {
1123         uint256 startTokenId = _currentIndex;
1124         if (quantity == 0) revert MintZeroQuantity();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are incredibly unrealistic.
1129         // `balance` and `numberMinted` have a maximum limit of 2**64.
1130         // `tokenId` has a maximum limit of 2**256.
1131         unchecked {
1132             // Updates:
1133             // - `balance += quantity`.
1134             // - `numberMinted += quantity`.
1135             //
1136             // We can directly add to the `balance` and `numberMinted`.
1137             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1138 
1139             // Updates:
1140             // - `address` to the owner.
1141             // - `startTimestamp` to the timestamp of minting.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `quantity == 1`.
1144             _packedOwnerships[startTokenId] = _packOwnershipData(
1145                 to,
1146                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1147             );
1148 
1149             uint256 toMasked;
1150             uint256 end = startTokenId + quantity;
1151 
1152             // Use assembly to loop and emit the `Transfer` event for gas savings.
1153             // The duplicated `log4` removes an extra check and reduces stack juggling.
1154             // The assembly, together with the surrounding Solidity code, have been
1155             // delicately arranged to nudge the compiler into producing optimized opcodes.
1156             assembly {
1157                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1158                 toMasked := and(to, _BITMASK_ADDRESS)
1159                 // Emit the `Transfer` event.
1160                 log4(
1161                     0, // Start of data (0, since no data).
1162                     0, // End of data (0, since no data).
1163                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1164                     0, // `address(0)`.
1165                     toMasked, // `to`.
1166                     startTokenId // `tokenId`.
1167                 )
1168 
1169                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1170                 // that overflows uint256 will make the loop run out of gas.
1171                 // The compiler will optimize the `iszero` away for performance.
1172                 for {
1173                     let tokenId := add(startTokenId, 1)
1174                 } iszero(eq(tokenId, end)) {
1175                     tokenId := add(tokenId, 1)
1176                 } {
1177                     // Emit the `Transfer` event. Similar to above.
1178                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1179                 }
1180             }
1181             if (toMasked == 0) revert MintToZeroAddress();
1182 
1183             _currentIndex = end;
1184         }
1185         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1186     }
1187 
1188     /**
1189      * @dev Mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * This function is intended for efficient minting only during contract creation.
1192      *
1193      * It emits only one {ConsecutiveTransfer} as defined in
1194      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1195      * instead of a sequence of {Transfer} event(s).
1196      *
1197      * Calling this function outside of contract creation WILL make your contract
1198      * non-compliant with the ERC721 standard.
1199      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1200      * {ConsecutiveTransfer} event is only permissible during contract creation.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `quantity` must be greater than 0.
1206      *
1207      * Emits a {ConsecutiveTransfer} event.
1208      */
1209     function _mintERC2309(address to, uint256 quantity) internal virtual {
1210         uint256 startTokenId = _currentIndex;
1211         if (to == address(0)) revert MintToZeroAddress();
1212         if (quantity == 0) revert MintZeroQuantity();
1213         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1214 
1215         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1216 
1217         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1218         unchecked {
1219             // Updates:
1220             // - `balance += quantity`.
1221             // - `numberMinted += quantity`.
1222             //
1223             // We can directly add to the `balance` and `numberMinted`.
1224             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1225 
1226             // Updates:
1227             // - `address` to the owner.
1228             // - `startTimestamp` to the timestamp of minting.
1229             // - `burned` to `false`.
1230             // - `nextInitialized` to `quantity == 1`.
1231             _packedOwnerships[startTokenId] = _packOwnershipData(
1232                 to,
1233                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1234             );
1235 
1236             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1237 
1238             _currentIndex = startTokenId + quantity;
1239         }
1240         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1241     }
1242 
1243     /**
1244      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1245      *
1246      * Requirements:
1247      *
1248      * - If `to` refers to a smart contract, it must implement
1249      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1250      * - `quantity` must be greater than 0.
1251      *
1252      * See {_mint}.
1253      *
1254      * Emits a {Transfer} event for each mint.
1255      */
1256     function _safeMint(
1257         address to,
1258         uint256 quantity,
1259         bytes memory _data
1260     ) internal virtual {
1261         _mint(to, quantity);
1262 
1263         unchecked {
1264             if (to.code.length != 0) {
1265                 uint256 end = _currentIndex;
1266                 uint256 index = end - quantity;
1267                 do {
1268                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1269                         revert TransferToNonERC721ReceiverImplementer();
1270                     }
1271                 } while (index < end);
1272                 // Reentrancy protection.
1273                 if (_currentIndex != end) revert();
1274             }
1275         }
1276     }
1277 
1278     /**
1279      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1280      */
1281     function _safeMint(address to, uint256 quantity) internal virtual {
1282         _safeMint(to, quantity, '');
1283     }
1284 
1285     // =============================================================
1286     //                        BURN OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Equivalent to `_burn(tokenId, false)`.
1291      */
1292     function _burn(uint256 tokenId) internal virtual {
1293         _burn(tokenId, false);
1294     }
1295 
1296     /**
1297      * @dev Destroys `tokenId`.
1298      * The approval is cleared when the token is burned.
1299      *
1300      * Requirements:
1301      *
1302      * - `tokenId` must exist.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1307         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1308 
1309         address from = address(uint160(prevOwnershipPacked));
1310 
1311         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1312 
1313         if (approvalCheck) {
1314             // The nested ifs save around 20+ gas over a compound boolean condition.
1315             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1316                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1317         }
1318 
1319         _beforeTokenTransfers(from, address(0), tokenId, 1);
1320 
1321         // Clear approvals from the previous owner.
1322         assembly {
1323             if approvedAddress {
1324                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1325                 sstore(approvedAddressSlot, 0)
1326             }
1327         }
1328 
1329         // Underflow of the sender's balance is impossible because we check for
1330         // ownership above and the recipient's balance can't realistically overflow.
1331         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1332         unchecked {
1333             // Updates:
1334             // - `balance -= 1`.
1335             // - `numberBurned += 1`.
1336             //
1337             // We can directly decrement the balance, and increment the number burned.
1338             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1339             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1340 
1341             // Updates:
1342             // - `address` to the last owner.
1343             // - `startTimestamp` to the timestamp of burning.
1344             // - `burned` to `true`.
1345             // - `nextInitialized` to `true`.
1346             _packedOwnerships[tokenId] = _packOwnershipData(
1347                 from,
1348                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1349             );
1350 
1351             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1352             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1353                 uint256 nextTokenId = tokenId + 1;
1354                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1355                 if (_packedOwnerships[nextTokenId] == 0) {
1356                     // If the next slot is within bounds.
1357                     if (nextTokenId != _currentIndex) {
1358                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1359                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1360                     }
1361                 }
1362             }
1363         }
1364 
1365         emit Transfer(from, address(0), tokenId);
1366         _afterTokenTransfers(from, address(0), tokenId, 1);
1367 
1368         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1369         unchecked {
1370             _burnCounter++;
1371         }
1372     }
1373 
1374     // =============================================================
1375     //                     EXTRA DATA OPERATIONS
1376     // =============================================================
1377 
1378     /**
1379      * @dev Directly sets the extra data for the ownership data `index`.
1380      */
1381     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1382         uint256 packed = _packedOwnerships[index];
1383         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1384         uint256 extraDataCasted;
1385         // Cast `extraData` with assembly to avoid redundant masking.
1386         assembly {
1387             extraDataCasted := extraData
1388         }
1389         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1390         _packedOwnerships[index] = packed;
1391     }
1392 
1393     /**
1394      * @dev Called during each token transfer to set the 24bit `extraData` field.
1395      * Intended to be overridden by the cosumer contract.
1396      *
1397      * `previousExtraData` - the value of `extraData` before transfer.
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      * - When `to` is zero, `tokenId` will be burned by `from`.
1405      * - `from` and `to` are never both zero.
1406      */
1407     function _extraData(
1408         address from,
1409         address to,
1410         uint24 previousExtraData
1411     ) internal view virtual returns (uint24) {}
1412 
1413     /**
1414      * @dev Returns the next extra data for the packed ownership data.
1415      * The returned result is shifted into position.
1416      */
1417     function _nextExtraData(
1418         address from,
1419         address to,
1420         uint256 prevOwnershipPacked
1421     ) private view returns (uint256) {
1422         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1423         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1424     }
1425 
1426     // =============================================================
1427     //                       OTHER OPERATIONS
1428     // =============================================================
1429 
1430     /**
1431      * @dev Returns the message sender (defaults to `msg.sender`).
1432      *
1433      * If you are writing GSN compatible contracts, you need to override this function.
1434      */
1435     function _msgSenderERC721A() internal view virtual returns (address) {
1436         return msg.sender;
1437     }
1438 
1439     /**
1440      * @dev Converts a uint256 to its ASCII string decimal representation.
1441      */
1442     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1443         assembly {
1444             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1445             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1446             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1447             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1448             let m := add(mload(0x40), 0xa0)
1449             // Update the free memory pointer to allocate.
1450             mstore(0x40, m)
1451             // Assign the `str` to the end.
1452             str := sub(m, 0x20)
1453             // Zeroize the slot after the string.
1454             mstore(str, 0)
1455 
1456             // Cache the end of the memory to calculate the length later.
1457             let end := str
1458 
1459             // We write the string from rightmost digit to leftmost digit.
1460             // The following is essentially a do-while loop that also handles the zero case.
1461             // prettier-ignore
1462             for { let temp := value } 1 {} {
1463                 str := sub(str, 1)
1464                 // Write the character to the pointer.
1465                 // The ASCII index of the '0' character is 48.
1466                 mstore8(str, add(48, mod(temp, 10)))
1467                 // Keep dividing `temp` until zero.
1468                 temp := div(temp, 10)
1469                 // prettier-ignore
1470                 if iszero(temp) { break }
1471             }
1472 
1473             let length := sub(end, str)
1474             // Move the pointer 32 bytes leftwards to make room for the length.
1475             str := sub(str, 0x20)
1476             // Store the length.
1477             mstore(str, length)
1478         }
1479     }
1480 }
1481 // File: contracts/Math.sol
1482 
1483 
1484 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1485 
1486 pragma solidity ^0.8.0;
1487 
1488 /**
1489  * @dev Standard math utilities missing in the Solidity language.
1490  */
1491 library Math {
1492     enum Rounding {
1493         Down, // Toward negative infinity
1494         Up, // Toward infinity
1495         Zero // Toward zero
1496     }
1497 
1498     /**
1499      * @dev Returns the largest of two numbers.
1500      */
1501     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1502         return a > b ? a : b;
1503     }
1504 
1505     /**
1506      * @dev Returns the smallest of two numbers.
1507      */
1508     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1509         return a < b ? a : b;
1510     }
1511 
1512     /**
1513      * @dev Returns the average of two numbers. The result is rounded towards
1514      * zero.
1515      */
1516     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1517         // (a + b) / 2 can overflow.
1518         return (a & b) + (a ^ b) / 2;
1519     }
1520 
1521     /**
1522      * @dev Returns the ceiling of the division of two numbers.
1523      *
1524      * This differs from standard division with `/` in that it rounds up instead
1525      * of rounding down.
1526      */
1527     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1528         // (a + b - 1) / b can overflow on addition, so we distribute.
1529         return a == 0 ? 0 : (a - 1) / b + 1;
1530     }
1531 
1532     /**
1533      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1534      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1535      * with further edits by Uniswap Labs also under MIT license.
1536      */
1537     function mulDiv(
1538         uint256 x,
1539         uint256 y,
1540         uint256 denominator
1541     ) internal pure returns (uint256 result) {
1542         unchecked {
1543             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1544             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1545             // variables such that product = prod1 * 2^256 + prod0.
1546             uint256 prod0; // Least significant 256 bits of the product
1547             uint256 prod1; // Most significant 256 bits of the product
1548             assembly {
1549                 let mm := mulmod(x, y, not(0))
1550                 prod0 := mul(x, y)
1551                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1552             }
1553 
1554             // Handle non-overflow cases, 256 by 256 division.
1555             if (prod1 == 0) {
1556                 return prod0 / denominator;
1557             }
1558 
1559             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1560             require(denominator > prod1);
1561 
1562             ///////////////////////////////////////////////
1563             // 512 by 256 division.
1564             ///////////////////////////////////////////////
1565 
1566             // Make division exact by subtracting the remainder from [prod1 prod0].
1567             uint256 remainder;
1568             assembly {
1569                 // Compute remainder using mulmod.
1570                 remainder := mulmod(x, y, denominator)
1571 
1572                 // Subtract 256 bit number from 512 bit number.
1573                 prod1 := sub(prod1, gt(remainder, prod0))
1574                 prod0 := sub(prod0, remainder)
1575             }
1576 
1577             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1578             // See https://cs.stackexchange.com/q/138556/92363.
1579 
1580             // Does not overflow because the denominator cannot be zero at this stage in the function.
1581             uint256 twos = denominator & (~denominator + 1);
1582             assembly {
1583                 // Divide denominator by twos.
1584                 denominator := div(denominator, twos)
1585 
1586                 // Divide [prod1 prod0] by twos.
1587                 prod0 := div(prod0, twos)
1588 
1589                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1590                 twos := add(div(sub(0, twos), twos), 1)
1591             }
1592 
1593             // Shift in bits from prod1 into prod0.
1594             prod0 |= prod1 * twos;
1595 
1596             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1597             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1598             // four bits. That is, denominator * inv = 1 mod 2^4.
1599             uint256 inverse = (3 * denominator) ^ 2;
1600 
1601             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1602             // in modular arithmetic, doubling the correct bits in each step.
1603             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1604             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1605             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1606             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1607             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1608             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1609 
1610             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1611             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1612             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1613             // is no longer required.
1614             result = prod0 * inverse;
1615             return result;
1616         }
1617     }
1618 
1619     /**
1620      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1621      */
1622     function mulDiv(
1623         uint256 x,
1624         uint256 y,
1625         uint256 denominator,
1626         Rounding rounding
1627     ) internal pure returns (uint256) {
1628         uint256 result = mulDiv(x, y, denominator);
1629         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1630             result += 1;
1631         }
1632         return result;
1633     }
1634 
1635     /**
1636      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1637      *
1638      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1639      */
1640     function sqrt(uint256 a) internal pure returns (uint256) {
1641         if (a == 0) {
1642             return 0;
1643         }
1644 
1645         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1646         //
1647         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1648         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1649         //
1650         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1651         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1652         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1653         //
1654         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1655         uint256 result = 1 << (log2(a) >> 1);
1656 
1657         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1658         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1659         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1660         // into the expected uint128 result.
1661         unchecked {
1662             result = (result + a / result) >> 1;
1663             result = (result + a / result) >> 1;
1664             result = (result + a / result) >> 1;
1665             result = (result + a / result) >> 1;
1666             result = (result + a / result) >> 1;
1667             result = (result + a / result) >> 1;
1668             result = (result + a / result) >> 1;
1669             return min(result, a / result);
1670         }
1671     }
1672 
1673     /**
1674      * @notice Calculates sqrt(a), following the selected rounding direction.
1675      */
1676     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1677         unchecked {
1678             uint256 result = sqrt(a);
1679             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1680         }
1681     }
1682 
1683     /**
1684      * @dev Return the log in base 2, rounded down, of a positive value.
1685      * Returns 0 if given 0.
1686      */
1687     function log2(uint256 value) internal pure returns (uint256) {
1688         uint256 result = 0;
1689         unchecked {
1690             if (value >> 128 > 0) {
1691                 value >>= 128;
1692                 result += 128;
1693             }
1694             if (value >> 64 > 0) {
1695                 value >>= 64;
1696                 result += 64;
1697             }
1698             if (value >> 32 > 0) {
1699                 value >>= 32;
1700                 result += 32;
1701             }
1702             if (value >> 16 > 0) {
1703                 value >>= 16;
1704                 result += 16;
1705             }
1706             if (value >> 8 > 0) {
1707                 value >>= 8;
1708                 result += 8;
1709             }
1710             if (value >> 4 > 0) {
1711                 value >>= 4;
1712                 result += 4;
1713             }
1714             if (value >> 2 > 0) {
1715                 value >>= 2;
1716                 result += 2;
1717             }
1718             if (value >> 1 > 0) {
1719                 result += 1;
1720             }
1721         }
1722         return result;
1723     }
1724 
1725     /**
1726      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1727      * Returns 0 if given 0.
1728      */
1729     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1730         unchecked {
1731             uint256 result = log2(value);
1732             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1733         }
1734     }
1735 
1736     /**
1737      * @dev Return the log in base 10, rounded down, of a positive value.
1738      * Returns 0 if given 0.
1739      */
1740     function log10(uint256 value) internal pure returns (uint256) {
1741         uint256 result = 0;
1742         unchecked {
1743             if (value >= 10**64) {
1744                 value /= 10**64;
1745                 result += 64;
1746             }
1747             if (value >= 10**32) {
1748                 value /= 10**32;
1749                 result += 32;
1750             }
1751             if (value >= 10**16) {
1752                 value /= 10**16;
1753                 result += 16;
1754             }
1755             if (value >= 10**8) {
1756                 value /= 10**8;
1757                 result += 8;
1758             }
1759             if (value >= 10**4) {
1760                 value /= 10**4;
1761                 result += 4;
1762             }
1763             if (value >= 10**2) {
1764                 value /= 10**2;
1765                 result += 2;
1766             }
1767             if (value >= 10**1) {
1768                 result += 1;
1769             }
1770         }
1771         return result;
1772     }
1773 
1774     /**
1775      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1776      * Returns 0 if given 0.
1777      */
1778     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1779         unchecked {
1780             uint256 result = log10(value);
1781             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1782         }
1783     }
1784 
1785     /**
1786      * @dev Return the log in base 256, rounded down, of a positive value.
1787      * Returns 0 if given 0.
1788      *
1789      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1790      */
1791     function log256(uint256 value) internal pure returns (uint256) {
1792         uint256 result = 0;
1793         unchecked {
1794             if (value >> 128 > 0) {
1795                 value >>= 128;
1796                 result += 16;
1797             }
1798             if (value >> 64 > 0) {
1799                 value >>= 64;
1800                 result += 8;
1801             }
1802             if (value >> 32 > 0) {
1803                 value >>= 32;
1804                 result += 4;
1805             }
1806             if (value >> 16 > 0) {
1807                 value >>= 16;
1808                 result += 2;
1809             }
1810             if (value >> 8 > 0) {
1811                 result += 1;
1812             }
1813         }
1814         return result;
1815     }
1816 
1817     /**
1818      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1819      * Returns 0 if given 0.
1820      */
1821     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1822         unchecked {
1823             uint256 result = log256(value);
1824             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1825         }
1826     }
1827 }
1828 // File: contracts/Strings.sol
1829 
1830 
1831 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1832 
1833 pragma solidity ^0.8.0;
1834 
1835 
1836 /**
1837  * @dev String operations.
1838  */
1839 library Strings {
1840     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1841     uint8 private constant _ADDRESS_LENGTH = 20;
1842 
1843     /**
1844      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1845      */
1846     function toString(uint256 value) internal pure returns (string memory) {
1847         unchecked {
1848             uint256 length = Math.log10(value) + 1;
1849             string memory buffer = new string(length);
1850             uint256 ptr;
1851             /// @solidity memory-safe-assembly
1852             assembly {
1853                 ptr := add(buffer, add(32, length))
1854             }
1855             while (true) {
1856                 ptr--;
1857                 /// @solidity memory-safe-assembly
1858                 assembly {
1859                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1860                 }
1861                 value /= 10;
1862                 if (value == 0) break;
1863             }
1864             return buffer;
1865         }
1866     }
1867 
1868     /**
1869      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1870      */
1871     function toHexString(uint256 value) internal pure returns (string memory) {
1872         unchecked {
1873             return toHexString(value, Math.log256(value) + 1);
1874         }
1875     }
1876 
1877     /**
1878      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1879      */
1880     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1881         bytes memory buffer = new bytes(2 * length + 2);
1882         buffer[0] = "0";
1883         buffer[1] = "x";
1884         for (uint256 i = 2 * length + 1; i > 1; --i) {
1885             buffer[i] = _SYMBOLS[value & 0xf];
1886             value >>= 4;
1887         }
1888         require(value == 0, "Strings: hex length insufficient");
1889         return string(buffer);
1890     }
1891 
1892     /**
1893      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1894      */
1895     function toHexString(address addr) internal pure returns (string memory) {
1896         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1897     }
1898 }
1899 // File: contracts/Context.sol
1900 
1901 
1902 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1903 
1904 pragma solidity ^0.8.0;
1905 
1906 /**
1907  * @dev Provides information about the current execution context, including the
1908  * sender of the transaction and its data. While these are generally available
1909  * via msg.sender and msg.data, they should not be accessed in such a direct
1910  * manner, since when dealing with meta-transactions the account sending and
1911  * paying for execution may not be the actual sender (as far as an application
1912  * is concerned).
1913  *
1914  * This contract is only required for intermediate, library-like contracts.
1915  */
1916 abstract contract Context {
1917     function _msgSender() internal view virtual returns (address) {
1918         return msg.sender;
1919     }
1920 
1921     function _msgData() internal view virtual returns (bytes calldata) {
1922         return msg.data;
1923     }
1924 }
1925 // File: contracts/Ownable.sol
1926 
1927 
1928 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1929 
1930 pragma solidity ^0.8.0;
1931 
1932 
1933 /**
1934  * @dev Contract module which provides a basic access control mechanism, where
1935  * there is an account (an owner) that can be granted exclusive access to
1936  * specific functions.
1937  *
1938  * By default, the owner account will be the one that deploys the contract. This
1939  * can later be changed with {transferOwnership}.
1940  *
1941  * This module is used through inheritance. It will make available the modifier
1942  * `onlyOwner`, which can be applied to your functions to restrict their use to
1943  * the owner.
1944  */
1945 abstract contract Ownable is Context {
1946     address private _owner;
1947 
1948     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1949 
1950     /**
1951      * @dev Initializes the contract setting the deployer as the initial owner.
1952      */
1953     constructor() {
1954         _transferOwnership(_msgSender());
1955     }
1956 
1957     /**
1958      * @dev Throws if called by any account other than the owner.
1959      */
1960     modifier onlyOwner() {
1961         _checkOwner();
1962         _;
1963     }
1964 
1965     /**
1966      * @dev Returns the address of the current owner.
1967      */
1968     function owner() public view virtual returns (address) {
1969         return _owner;
1970     }
1971 
1972     /**
1973      * @dev Throws if the sender is not the owner.
1974      */
1975     function _checkOwner() internal view virtual {
1976         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1977     }
1978 
1979     /**
1980      * @dev Leaves the contract without owner. It will not be possible to call
1981      * `onlyOwner` functions anymore. Can only be called by the current owner.
1982      *
1983      * NOTE: Renouncing ownership will leave the contract without an owner,
1984      * thereby removing any functionality that is only available to the owner.
1985      */
1986     function renounceOwnership() public virtual onlyOwner {
1987         _transferOwnership(address(0));
1988     }
1989 
1990     /**
1991      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1992      * Can only be called by the current owner.
1993      */
1994     function transferOwnership(address newOwner) public virtual onlyOwner {
1995         require(newOwner != address(0), "Ownable: new owner is the zero address");
1996         _transferOwnership(newOwner);
1997     }
1998 
1999     /**
2000      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2001      * Internal function without access restriction.
2002      */
2003     function _transferOwnership(address newOwner) internal virtual {
2004         address oldOwner = _owner;
2005         _owner = newOwner;
2006         emit OwnershipTransferred(oldOwner, newOwner);
2007     }
2008 }
2009 
2010 pragma solidity ^0.8.7;
2011 
2012 contract BitOutlaws is ERC721A, Ownable{
2013     using Strings for uint256;
2014    
2015     uint public tokenPrice = 0.003 ether;
2016     uint public maxSupply = 5000;
2017     uint public freeNFT = 1;
2018     bool public sale_status = false;
2019     bool public isBurnEnabled = false;
2020     bool public isRevealed = true;
2021     
2022     string public baseURI = "ipfs://QmYrzVRcnk7xxiPx6R8kmiviUPVcsrFbvCFeAUaVdgWnvi/";
2023     string public placeholderTokenUri = "";
2024     
2025     mapping(uint256 => address) public burnedby;
2026     mapping(address => bool) public hasMintedFree;
2027     mapping(address => uint256) public addressMintedBalance;
2028 
2029     uint public maxPerTransaction = 11;  //Max Limit for Sale
2030     uint public maxPerWallet = 11; //Max Limit for Presale
2031              
2032     constructor() ERC721A("8 Bit Outlaws", "8BIT"){}
2033 
2034     function mint(uint _count) public payable{
2035         require(sale_status == true, "Sale is Paused.");
2036         require(_count > 0, "mint at least one token");
2037         require(totalSupply() + _count <= maxSupply, "Sold Out!");
2038         require(_count <= maxPerTransaction, "max per transaction 5");
2039         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2040         require(ownerMintedCount + _count <= maxPerWallet, "ERROR: Max NFT per address exceeded");
2041         addressMintedBalance[msg.sender] += _count;        
2042     //  uint count = balanceOf(msg.sender);
2043         if (ownerMintedCount < freeNFT) {
2044             if (_count > freeNFT - ownerMintedCount)
2045             {
2046             require(msg.value >= tokenPrice * (_count - (freeNFT - ownerMintedCount)), "Insufficient funds!");
2047             _safeMint(msg.sender, _count);
2048             }
2049             else
2050             {
2051             _safeMint(msg.sender, _count);
2052             }
2053         }
2054         else
2055         {
2056             require(msg.value >= tokenPrice * _count, "You got max free NFTs! Provide funds");
2057             _safeMint(msg.sender, _count);
2058         }
2059    }
2060 
2061     function adminMint(uint _count) external onlyOwner{
2062         require(_count > 0, "mint at least one token");
2063         require(totalSupply() + _count <= maxSupply, "Sold Out!");
2064         _safeMint(msg.sender, _count);
2065     }
2066 
2067     function sendGifts(address[] memory _wallets) public onlyOwner{
2068         require(totalSupply() + _wallets.length <= maxSupply, "Sold Out!");
2069         for(uint i = 0; i < _wallets.length; i++)
2070         _safeMint(_wallets[i], 1);
2071     }
2072 
2073     function _baseURI() internal view virtual override returns (string memory) {
2074         return baseURI;
2075     }
2076 
2077     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2078         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2079         if(!isRevealed)
2080         {
2081             return placeholderTokenUri;
2082         }
2083         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
2084     }
2085 
2086     function setBaseUri(string memory _uri) external onlyOwner {
2087         baseURI = _uri;
2088     }
2089 
2090     function setPlaceholderTokenUri(string memory newPlaceholderTokenUri) external onlyOwner {
2091         placeholderTokenUri = newPlaceholderTokenUri;
2092     }
2093 
2094     function updateFreeNFT(uint newValue) public onlyOwner {
2095         freeNFT = newValue;
2096     }
2097 
2098     function updateMaxSupply(uint _newMaxSupply) public onlyOwner {
2099         require(_newMaxSupply > totalSupply(), "New maxSupply should be greater than current totalSupply");
2100         maxSupply = _newMaxSupply;
2101     }
2102 
2103     function updateMaxPerTransaction(uint newMax) public onlyOwner {
2104         maxPerTransaction = newMax;
2105     }
2106 
2107     function updateMaxPerWallet(uint newMax) public onlyOwner {
2108         maxPerWallet = newMax;
2109     }
2110 
2111     function toggleSaleStatus() external onlyOwner{
2112         sale_status = !sale_status;
2113     }
2114     
2115     function update_burning_status(bool status) external onlyOwner {
2116         isBurnEnabled = status;
2117     }
2118   
2119     function bulkBurn(uint256[] memory tokenIds) external {
2120         require(isBurnEnabled, "burning disabled");
2121         for (uint i = 0; i < tokenIds.length; i++) {
2122         uint256 tokenId = tokenIds[i];
2123         require(
2124             _isApprovedOrOwner(msg.sender, tokenId),
2125             "burn caller is not approved"
2126         );
2127         _burn(tokenId);
2128         burnedby[tokenId] = msg.sender;
2129     }
2130 }
2131      function public_sale_price(uint pr) external onlyOwner {
2132         tokenPrice = pr;
2133     }
2134 
2135     function toggleReveal() external onlyOwner{
2136         isRevealed = !isRevealed;
2137     }
2138 
2139     function withdraw() external onlyOwner {
2140         uint _balance = address(this).balance;
2141         payable(owner()).transfer(_balance);
2142     }
2143 }