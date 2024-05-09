1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/IOperatorFilterRegistry.sol
4 
5 
6 pragma solidity ^0.8.13;
7 
8 interface IOperatorFilterRegistry {
9     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
10     function register(address registrant) external;
11     function registerAndSubscribe(address registrant, address subscription) external;
12     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
13     function unregister(address addr) external;
14     function updateOperator(address registrant, address operator, bool filtered) external;
15     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
16     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
17     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
18     function subscribe(address registrant, address registrantToSubscribe) external;
19     function unsubscribe(address registrant, bool copyExistingEntries) external;
20     function subscriptionOf(address addr) external returns (address registrant);
21     function subscribers(address registrant) external returns (address[] memory);
22     function subscriberAt(address registrant, uint256 index) external returns (address);
23     function copyEntriesOf(address registrant, address registrantToCopy) external;
24     function isOperatorFiltered(address registrant, address operator) external returns (bool);
25     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
26     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
27     function filteredOperators(address addr) external returns (address[] memory);
28     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
29     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
30     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
31     function isRegistered(address addr) external returns (bool);
32     function codeHashOf(address addr) external returns (bytes32);
33 }
34 
35 // File: contracts/OperatorFilterer.sol
36 
37 
38 pragma solidity ^0.8.13;
39 
40 
41 abstract contract OperatorFilterer {
42     error OperatorNotAllowed(address operator);
43 
44     IOperatorFilterRegistry constant operatorFilterRegistry =
45         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
46 
47     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
48         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
49         // will not revert, but the contract will need to be registered with the registry once it is deployed in
50         // order for the modifier to filter addresses.
51         if (address(operatorFilterRegistry).code.length > 0) {
52             if (subscribe) {
53                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
54             } else {
55                 if (subscriptionOrRegistrantToCopy != address(0)) {
56                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
57                 } else {
58                     operatorFilterRegistry.register(address(this));
59                 }
60             }
61         }
62     }
63 
64     modifier onlyAllowedOperator(address from) virtual {
65         // Check registry code length to facilitate testing in environments without a deployed registry.
66         if (address(operatorFilterRegistry).code.length > 0) {
67             // Allow spending tokens from addresses with balance
68             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
69             // from an EOA.
70             if (from == msg.sender) {
71                 _;
72                 return;
73             }
74             if (
75                 !(
76                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
77                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
78                 )
79             ) {
80                 revert OperatorNotAllowed(msg.sender);
81             }
82         }
83         _;
84     }
85 }
86 
87 // File: contracts/DefaultOperatorFilterer.sol
88 
89 
90 pragma solidity ^0.8.13;
91 
92 
93 abstract contract DefaultOperatorFilterer is OperatorFilterer {
94     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
95 
96     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
97 }
98 
99 // File: contracts/IERC721A.sol
100 
101 
102 // ERC721A Contracts v4.2.3
103 // Creator: Chiru Labs
104 
105 pragma solidity ^0.8.4;
106 
107 /**
108  * @dev Interface of ERC721A.
109  */
110 interface IERC721A {
111     /**
112      * The caller must own the token or be an approved operator.
113      */
114     error ApprovalCallerNotOwnerNorApproved();
115 
116     /**
117      * The token does not exist.
118      */
119     error ApprovalQueryForNonexistentToken();
120 
121     /**
122      * Cannot query the balance for the zero address.
123      */
124     error BalanceQueryForZeroAddress();
125 
126     /**
127      * Cannot mint to the zero address.
128      */
129     error MintToZeroAddress();
130 
131     /**
132      * The quantity of tokens minted must be more than zero.
133      */
134     error MintZeroQuantity();
135 
136     /**
137      * The token does not exist.
138      */
139     error OwnerQueryForNonexistentToken();
140 
141     /**
142      * The caller must own the token or be an approved operator.
143      */
144     error TransferCallerNotOwnerNorApproved();
145 
146     /**
147      * The token must be owned by `from`.
148      */
149     error TransferFromIncorrectOwner();
150 
151     /**
152      * Cannot safely transfer to a contract that does not implement the
153      * ERC721Receiver interface.
154      */
155     error TransferToNonERC721ReceiverImplementer();
156 
157     /**
158      * Cannot transfer to the zero address.
159      */
160     error TransferToZeroAddress();
161 
162     /**
163      * The token does not exist.
164      */
165     error URIQueryForNonexistentToken();
166 
167     /**
168      * The `quantity` minted with ERC2309 exceeds the safety limit.
169      */
170     error MintERC2309QuantityExceedsLimit();
171 
172     /**
173      * The `extraData` cannot be set on an unintialized ownership slot.
174      */
175     error OwnershipNotInitializedForExtraData();
176 
177     // =============================================================
178     //                            STRUCTS
179     // =============================================================
180 
181     struct TokenOwnership {
182         // The address of the owner.
183         address addr;
184         // Stores the start time of ownership with minimal overhead for tokenomics.
185         uint64 startTimestamp;
186         // Whether the token has been burned.
187         bool burned;
188         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
189         uint24 extraData;
190     }
191 
192     // =============================================================
193     //                         TOKEN COUNTERS
194     // =============================================================
195 
196     /**
197      * @dev Returns the total number of tokens in existence.
198      * Burned tokens will reduce the count.
199      * To get the total number of tokens minted, please see {_totalMinted}.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     // =============================================================
204     //                            IERC165
205     // =============================================================
206 
207     /**
208      * @dev Returns true if this contract implements the interface defined by
209      * `interfaceId`. See the corresponding
210      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
211      * to learn more about how these ids are created.
212      *
213      * This function call must use less than 30000 gas.
214      */
215     function supportsInterface(bytes4 interfaceId) external view returns (bool);
216 
217     // =============================================================
218     //                            IERC721
219     // =============================================================
220 
221     /**
222      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
228      */
229     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables or disables
233      * (`approved`) `operator` to manage all of its assets.
234      */
235     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
236 
237     /**
238      * @dev Returns the number of tokens in `owner`'s account.
239      */
240     function balanceOf(address owner) external view returns (uint256 balance);
241 
242     /**
243      * @dev Returns the owner of the `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function ownerOf(uint256 tokenId) external view returns (address owner);
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`,
253      * checking first that contract recipients are aware of the ERC721 protocol
254      * to prevent tokens from being forever locked.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be have been allowed to move
262      * this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement
264      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
265      *
266      * Emits a {Transfer} event.
267      */
268     function safeTransferFrom(
269         address from,
270         address to,
271         uint256 tokenId,
272         bytes calldata data
273     ) external payable;
274 
275     /**
276      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId
282     ) external payable;
283 
284     /**
285      * @dev Transfers `tokenId` from `from` to `to`.
286      *
287      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
288      * whenever possible.
289      *
290      * Requirements:
291      *
292      * - `from` cannot be the zero address.
293      * - `to` cannot be the zero address.
294      * - `tokenId` token must be owned by `from`.
295      * - If the caller is not `from`, it must be approved to move this token
296      * by either {approve} or {setApprovalForAll}.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external payable;
305 
306     /**
307      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
308      * The approval is cleared when the token is transferred.
309      *
310      * Only a single account can be approved at a time, so approving the
311      * zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external payable;
321 
322     /**
323      * @dev Approve or remove `operator` as an operator for the caller.
324      * Operators can call {transferFrom} or {safeTransferFrom}
325      * for any token owned by the caller.
326      *
327      * Requirements:
328      *
329      * - The `operator` cannot be the caller.
330      *
331      * Emits an {ApprovalForAll} event.
332      */
333     function setApprovalForAll(address operator, bool _approved) external;
334 
335     /**
336      * @dev Returns the account approved for `tokenId` token.
337      *
338      * Requirements:
339      *
340      * - `tokenId` must exist.
341      */
342     function getApproved(uint256 tokenId) external view returns (address operator);
343 
344     /**
345      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
346      *
347      * See {setApprovalForAll}.
348      */
349     function isApprovedForAll(address owner, address operator) external view returns (bool);
350 
351     // =============================================================
352     //                        IERC721Metadata
353     // =============================================================
354 
355     /**
356      * @dev Returns the token collection name.
357      */
358     function name() external view returns (string memory);
359 
360     /**
361      * @dev Returns the token collection symbol.
362      */
363     function symbol() external view returns (string memory);
364 
365     /**
366      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
367      */
368     function tokenURI(uint256 tokenId) external view returns (string memory);
369 
370     // =============================================================
371     //                           IERC2309
372     // =============================================================
373 
374     /**
375      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
376      * (inclusive) is transferred from `from` to `to`, as defined in the
377      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
378      *
379      * See {_mintERC2309} for more details.
380      */
381     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
382 }
383 // File: contracts/ERC721A.sol
384 
385 
386 // ERC721A Contracts v4.2.3
387 // Creator: Chiru Labs
388 
389 pragma solidity ^0.8.4;
390 
391 
392 /**
393  * @dev Interface of ERC721 token receiver.
394  */
395 interface ERC721A__IERC721Receiver {
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 /**
405  * @title ERC721A
406  *
407  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
408  * Non-Fungible Token Standard, including the Metadata extension.
409  * Optimized for lower gas during batch mints.
410  *
411  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
412  * starting from `_startTokenId()`.
413  *
414  * Assumptions:
415  *
416  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
417  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
418  */
419 contract ERC721A is IERC721A, DefaultOperatorFilterer {
420     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
421     struct TokenApprovalRef {
422         address value;
423     }
424 
425     // =============================================================
426     //                           CONSTANTS
427     // =============================================================
428 
429     // Mask of an entry in packed address data.
430     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
431 
432     // The bit position of `numberMinted` in packed address data.
433     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
434 
435     // The bit position of `numberBurned` in packed address data.
436     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
437 
438     // The bit position of `aux` in packed address data.
439     uint256 private constant _BITPOS_AUX = 192;
440 
441     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
442     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
443 
444     // The bit position of `startTimestamp` in packed ownership.
445     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
446 
447     // The bit mask of the `burned` bit in packed ownership.
448     uint256 private constant _BITMASK_BURNED = 1 << 224;
449 
450     // The bit position of the `nextInitialized` bit in packed ownership.
451     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
452 
453     // The bit mask of the `nextInitialized` bit in packed ownership.
454     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
455 
456     // The bit position of `extraData` in packed ownership.
457     uint256 private constant _BITPOS_EXTRA_DATA = 232;
458 
459     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
460     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
461 
462     // The mask of the lower 160 bits for addresses.
463     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
464 
465     // The maximum `quantity` that can be minted with {_mintERC2309}.
466     // This limit is to prevent overflows on the address data entries.
467     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
468     // is required to cause an overflow, which is unrealistic.
469     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
470 
471     // The `Transfer` event signature is given by:
472     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
473     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
474         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
475 
476     // =============================================================
477     //                            STORAGE
478     // =============================================================
479 
480     // The next token ID to be minted.
481     uint256 private _currentIndex;
482 
483     // The number of tokens burned.
484     uint256 private _burnCounter;
485 
486     // Token name
487     string private _name;
488 
489     // Token symbol
490     string private _symbol;
491 
492     // Mapping from token ID to ownership details
493     // An empty struct value does not necessarily mean the token is unowned.
494     // See {_packedOwnershipOf} implementation for details.
495     //
496     // Bits Layout:
497     // - [0..159]   `addr`
498     // - [160..223] `startTimestamp`
499     // - [224]      `burned`
500     // - [225]      `nextInitialized`
501     // - [232..255] `extraData`
502     mapping(uint256 => uint256) private _packedOwnerships;
503 
504     // Mapping owner address to address data.
505     //
506     // Bits Layout:
507     // - [0..63]    `balance`
508     // - [64..127]  `numberMinted`
509     // - [128..191] `numberBurned`
510     // - [192..255] `aux`
511     mapping(address => uint256) private _packedAddressData;
512 
513     // Mapping from token ID to approved address.
514     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
515 
516     // Mapping from owner to operator approvals
517     mapping(address => mapping(address => bool)) private _operatorApprovals;
518 
519     // =============================================================
520     //                          CONSTRUCTOR
521     // =============================================================
522 
523     constructor(string memory name_, string memory symbol_) {
524         _name = name_;
525         _symbol = symbol_;
526         _currentIndex = _startTokenId();
527     }
528 
529     // =============================================================
530     //                   TOKEN COUNTING OPERATIONS
531     // =============================================================
532 
533     /**
534      * @dev Returns the starting token ID.
535      * To change the starting token ID, please override this function.
536      */
537     function _startTokenId() internal view virtual returns (uint256) {
538         return 1;
539     }
540 
541     /**
542      * @dev Returns the next token ID to be minted.
543      */
544     function _nextTokenId() internal view virtual returns (uint256) {
545         return _currentIndex;
546     }
547 
548     /**
549      * @dev Returns the total number of tokens in existence.
550      * Burned tokens will reduce the count.
551      * To get the total number of tokens minted, please see {_totalMinted}.
552      */
553     function totalSupply() public view virtual override returns (uint256) {
554         // Counter underflow is impossible as _burnCounter cannot be incremented
555         // more than `_currentIndex - _startTokenId()` times.
556         unchecked {
557             return _currentIndex - _burnCounter - _startTokenId();
558         }
559     }
560 
561     /**
562      * @dev Returns the total amount of tokens minted in the contract.
563      */
564     function _totalMinted() internal view virtual returns (uint256) {
565         // Counter underflow is impossible as `_currentIndex` does not decrement,
566         // and it is initialized to `_startTokenId()`.
567         unchecked {
568             return _currentIndex - _startTokenId();
569         }
570     }
571 
572     /**
573      * @dev Returns the total number of tokens burned.
574      */
575     function _totalBurned() internal view virtual returns (uint256) {
576         return _burnCounter;
577     }
578 
579     // =============================================================
580     //                    ADDRESS DATA OPERATIONS
581     // =============================================================
582 
583     /**
584      * @dev Returns the number of tokens in `owner`'s account.
585      */
586     function balanceOf(address owner) public view virtual override returns (uint256) {
587         if (owner == address(0)) revert BalanceQueryForZeroAddress();
588         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
589     }
590 
591     /**
592      * Returns the number of tokens minted by `owner`.
593      */
594     function _numberMinted(address owner) internal view returns (uint256) {
595         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
596     }
597 
598     /**
599      * Returns the number of tokens burned by or on behalf of `owner`.
600      */
601     function _numberBurned(address owner) internal view returns (uint256) {
602         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
603     }
604 
605     /**
606      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
607      */
608     function _getAux(address owner) internal view returns (uint64) {
609         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
610     }
611 
612     /**
613      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
614      * If there are multiple variables, please pack them into a uint64.
615      */
616     function _setAux(address owner, uint64 aux) internal virtual {
617         uint256 packed = _packedAddressData[owner];
618         uint256 auxCasted;
619         // Cast `aux` with assembly to avoid redundant masking.
620         assembly {
621             auxCasted := aux
622         }
623         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
624         _packedAddressData[owner] = packed;
625     }
626 
627     // =============================================================
628     //                            IERC165
629     // =============================================================
630 
631     /**
632      * @dev Returns true if this contract implements the interface defined by
633      * `interfaceId`. See the corresponding
634      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
635      * to learn more about how these ids are created.
636      *
637      * This function call must use less than 30000 gas.
638      */
639     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
640         // The interface IDs are constants representing the first 4 bytes
641         // of the XOR of all function selectors in the interface.
642         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
643         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
644         return
645             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
646             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
647             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
648     }
649 
650     // =============================================================
651     //                        IERC721Metadata
652     // =============================================================
653 
654     /**
655      * @dev Returns the token collection name.
656      */
657     function name() public view virtual override returns (string memory) {
658         return _name;
659     }
660 
661     /**
662      * @dev Returns the token collection symbol.
663      */
664     function symbol() public view virtual override returns (string memory) {
665         return _symbol;
666     }
667 
668     /**
669      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
670      */
671     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
672         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
673 
674         string memory baseURI = _baseURI();
675         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
676     }
677 
678     /**
679      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
680      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
681      * by default, it can be overridden in child contracts.
682      */
683     function _baseURI() internal view virtual returns (string memory) {
684         return '';
685     }
686 
687     // =============================================================
688     //                     OWNERSHIPS OPERATIONS
689     // =============================================================
690 
691     /**
692      * @dev Returns the owner of the `tokenId` token.
693      *
694      * Requirements:
695      *
696      * - `tokenId` must exist.
697      */
698     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
699         return address(uint160(_packedOwnershipOf(tokenId)));
700     }
701 
702     /**
703      * @dev Gas spent here starts off proportional to the maximum mint batch size.
704      * It gradually moves to O(1) as tokens get transferred around over time.
705      */
706     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
707         return _unpackedOwnership(_packedOwnershipOf(tokenId));
708     }
709 
710     /**
711      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
712      */
713     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
714         return _unpackedOwnership(_packedOwnerships[index]);
715     }
716 
717     /**
718      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
719      */
720     function _initializeOwnershipAt(uint256 index) internal virtual {
721         if (_packedOwnerships[index] == 0) {
722             _packedOwnerships[index] = _packedOwnershipOf(index);
723         }
724     }
725 
726     /**
727      * Returns the packed ownership data of `tokenId`.
728      */
729     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
730         uint256 curr = tokenId;
731 
732         unchecked {
733             if (_startTokenId() <= curr)
734                 if (curr < _currentIndex) {
735                     uint256 packed = _packedOwnerships[curr];
736                     // If not burned.
737                     if (packed & _BITMASK_BURNED == 0) {
738                         // Invariant:
739                         // There will always be an initialized ownership slot
740                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
741                         // before an unintialized ownership slot
742                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
743                         // Hence, `curr` will not underflow.
744                         //
745                         // We can directly compare the packed value.
746                         // If the address is zero, packed will be zero.
747                         while (packed == 0) {
748                             packed = _packedOwnerships[--curr];
749                         }
750                         return packed;
751                     }
752                 }
753         }
754         revert OwnerQueryForNonexistentToken();
755     }
756 
757     /**
758      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
759      */
760     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
761         ownership.addr = address(uint160(packed));
762         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
763         ownership.burned = packed & _BITMASK_BURNED != 0;
764         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
765     }
766 
767     /**
768      * @dev Packs ownership data into a single uint256.
769      */
770     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
771         assembly {
772             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
773             owner := and(owner, _BITMASK_ADDRESS)
774             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
775             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
776         }
777     }
778 
779     /**
780      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
781      */
782     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
783         // For branchless setting of the `nextInitialized` flag.
784         assembly {
785             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
786             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
787         }
788     }
789 
790     // =============================================================
791     //                      APPROVAL OPERATIONS
792     // =============================================================
793 
794     /**
795      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
796      * The approval is cleared when the token is transferred.
797      *
798      * Only a single account can be approved at a time, so approving the
799      * zero address clears previous approvals.
800      *
801      * Requirements:
802      *
803      * - The caller must own the token or be an approved operator.
804      * - `tokenId` must exist.
805      *
806      * Emits an {Approval} event.
807      */
808     function approve(address to, uint256 tokenId) public payable virtual override {
809         address owner = ownerOf(tokenId);
810 
811         if (_msgSenderERC721A() != owner)
812             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
813                 revert ApprovalCallerNotOwnerNorApproved();
814             }
815 
816         _tokenApprovals[tokenId].value = to;
817         emit Approval(owner, to, tokenId);
818     }
819 
820     /**
821      * @dev Returns the account approved for `tokenId` token.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must exist.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
829 
830         return _tokenApprovals[tokenId].value;
831     }
832 
833     /**
834      * @dev Approve or remove `operator` as an operator for the caller.
835      * Operators can call {transferFrom} or {safeTransferFrom}
836      * for any token owned by the caller.
837      *
838      * Requirements:
839      *
840      * - The `operator` cannot be the caller.
841      *
842      * Emits an {ApprovalForAll} event.
843      */
844     function setApprovalForAll(address operator, bool approved) public virtual override {
845         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
846         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
847     }
848 
849     /**
850      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
851      *
852      * See {setApprovalForAll}.
853      */
854     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
855         return _operatorApprovals[owner][operator];
856     }
857 
858     /**
859      * @dev Returns whether `tokenId` exists.
860      *
861      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
862      *
863      * Tokens start existing when they are minted. See {_mint}.
864      */
865     function _exists(uint256 tokenId) internal view virtual returns (bool) {
866         return
867             _startTokenId() <= tokenId &&
868             tokenId < _currentIndex && // If within bounds,
869             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
870     }
871 
872     /**
873      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
874      */
875     function _isSenderApprovedOrOwner(
876         address approvedAddress,
877         address owner,
878         address msgSender
879     ) private pure returns (bool result) {
880         assembly {
881             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
882             owner := and(owner, _BITMASK_ADDRESS)
883             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
884             msgSender := and(msgSender, _BITMASK_ADDRESS)
885             // `msgSender == owner || msgSender == approvedAddress`.
886             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
887         }
888     }
889 
890     /**
891      * @dev Returns the storage slot and value for the approved address of `tokenId`.
892      */
893     function _getApprovedSlotAndAddress(uint256 tokenId)
894         private
895         view
896         returns (uint256 approvedAddressSlot, address approvedAddress)
897     {
898         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
899         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
900         assembly {
901             approvedAddressSlot := tokenApproval.slot
902             approvedAddress := sload(approvedAddressSlot)
903         }
904     }
905 
906     // =============================================================
907     //                      TRANSFER OPERATIONS
908     // =============================================================
909 
910     /**
911      * @dev Transfers `tokenId` from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must be owned by `from`.
918      * - If the caller is not `from`, it must be approved to move this token
919      * by either {approve} or {setApprovalForAll}.
920      *
921      * Emits a {Transfer} event.
922      */
923         function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
924         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
925         address owner = ERC721A.ownerOf(tokenId);
926         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
927     }
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public payable virtual override onlyAllowedOperator(from){
933         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
934 
935         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
936 
937         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
938 
939         // The nested ifs save around 20+ gas over a compound boolean condition.
940         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
941             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
942 
943         if (to == address(0)) revert TransferToZeroAddress();
944 
945         _beforeTokenTransfers(from, to, tokenId, 1);
946 
947         // Clear approvals from the previous owner.
948         assembly {
949             if approvedAddress {
950                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
951                 sstore(approvedAddressSlot, 0)
952             }
953         }
954 
955         // Underflow of the sender's balance is impossible because we check for
956         // ownership above and the recipient's balance can't realistically overflow.
957         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
958         unchecked {
959             // We can directly increment and decrement the balances.
960             --_packedAddressData[from]; // Updates: `balance -= 1`.
961             ++_packedAddressData[to]; // Updates: `balance += 1`.
962 
963             // Updates:
964             // - `address` to the next owner.
965             // - `startTimestamp` to the timestamp of transfering.
966             // - `burned` to `false`.
967             // - `nextInitialized` to `true`.
968             _packedOwnerships[tokenId] = _packOwnershipData(
969                 to,
970                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
971             );
972 
973             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
974             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
975                 uint256 nextTokenId = tokenId + 1;
976                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
977                 if (_packedOwnerships[nextTokenId] == 0) {
978                     // If the next slot is within bounds.
979                     if (nextTokenId != _currentIndex) {
980                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
981                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
982                     }
983                 }
984             }
985         }
986 
987         emit Transfer(from, to, tokenId);
988         _afterTokenTransfers(from, to, tokenId, 1);
989     }
990 
991     /**
992      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public payable virtual override onlyAllowedOperator(from){
999         safeTransferFrom(from, to, tokenId, '');
1000     }
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If the caller is not `from`, it must be approved to move this token
1011      * by either {approve} or {setApprovalForAll}.
1012      * - If `to` refers to a smart contract, it must implement
1013      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public payable virtual override onlyAllowedOperator(from){
1023         transferFrom(from, to, tokenId);
1024         if (to.code.length != 0)
1025             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1026                 revert TransferToNonERC721ReceiverImplementer();
1027             }
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before a set of serially-ordered token IDs
1032      * are about to be transferred. This includes minting.
1033      * And also called before burning one token.
1034      *
1035      * `startTokenId` - the first token ID to be transferred.
1036      * `quantity` - the amount to be transferred.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` will be minted for `to`.
1043      * - When `to` is zero, `tokenId` will be burned by `from`.
1044      * - `from` and `to` are never both zero.
1045      */
1046     function _beforeTokenTransfers(
1047         address from,
1048         address to,
1049         uint256 startTokenId,
1050         uint256 quantity
1051     ) internal virtual {}
1052 
1053     /**
1054      * @dev Hook that is called after a set of serially-ordered token IDs
1055      * have been transferred. This includes minting.
1056      * And also called after one token has been burned.
1057      *
1058      * `startTokenId` - the first token ID to be transferred.
1059      * `quantity` - the amount to be transferred.
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` has been minted for `to`.
1066      * - When `to` is zero, `tokenId` has been burned by `from`.
1067      * - `from` and `to` are never both zero.
1068      */
1069     function _afterTokenTransfers(
1070         address from,
1071         address to,
1072         uint256 startTokenId,
1073         uint256 quantity
1074     ) internal virtual {}
1075 
1076     /**
1077      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1078      *
1079      * `from` - Previous owner of the given token ID.
1080      * `to` - Target address that will receive the token.
1081      * `tokenId` - Token ID to be transferred.
1082      * `_data` - Optional data to send along with the call.
1083      *
1084      * Returns whether the call correctly returned the expected magic value.
1085      */
1086     function _checkContractOnERC721Received(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) private returns (bool) {
1092         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1093             bytes4 retval
1094         ) {
1095             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1096         } catch (bytes memory reason) {
1097             if (reason.length == 0) {
1098                 revert TransferToNonERC721ReceiverImplementer();
1099             } else {
1100                 assembly {
1101                     revert(add(32, reason), mload(reason))
1102                 }
1103             }
1104         }
1105     }
1106 
1107     // =============================================================
1108     //                        MINT OPERATIONS
1109     // =============================================================
1110 
1111     /**
1112      * @dev Mints `quantity` tokens and transfers them to `to`.
1113      *
1114      * Requirements:
1115      *
1116      * - `to` cannot be the zero address.
1117      * - `quantity` must be greater than 0.
1118      *
1119      * Emits a {Transfer} event for each mint.
1120      */
1121     function _mint(address to, uint256 quantity) internal virtual {
1122         uint256 startTokenId = _currentIndex;
1123         if (quantity == 0) revert MintZeroQuantity();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are incredibly unrealistic.
1128         // `balance` and `numberMinted` have a maximum limit of 2**64.
1129         // `tokenId` has a maximum limit of 2**256.
1130         unchecked {
1131             // Updates:
1132             // - `balance += quantity`.
1133             // - `numberMinted += quantity`.
1134             //
1135             // We can directly add to the `balance` and `numberMinted`.
1136             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1137 
1138             // Updates:
1139             // - `address` to the owner.
1140             // - `startTimestamp` to the timestamp of minting.
1141             // - `burned` to `false`.
1142             // - `nextInitialized` to `quantity == 1`.
1143             _packedOwnerships[startTokenId] = _packOwnershipData(
1144                 to,
1145                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1146             );
1147 
1148             uint256 toMasked;
1149             uint256 end = startTokenId + quantity;
1150 
1151             // Use assembly to loop and emit the `Transfer` event for gas savings.
1152             // The duplicated `log4` removes an extra check and reduces stack juggling.
1153             // The assembly, together with the surrounding Solidity code, have been
1154             // delicately arranged to nudge the compiler into producing optimized opcodes.
1155             assembly {
1156                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1157                 toMasked := and(to, _BITMASK_ADDRESS)
1158                 // Emit the `Transfer` event.
1159                 log4(
1160                     0, // Start of data (0, since no data).
1161                     0, // End of data (0, since no data).
1162                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1163                     0, // `address(0)`.
1164                     toMasked, // `to`.
1165                     startTokenId // `tokenId`.
1166                 )
1167 
1168                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1169                 // that overflows uint256 will make the loop run out of gas.
1170                 // The compiler will optimize the `iszero` away for performance.
1171                 for {
1172                     let tokenId := add(startTokenId, 1)
1173                 } iszero(eq(tokenId, end)) {
1174                     tokenId := add(tokenId, 1)
1175                 } {
1176                     // Emit the `Transfer` event. Similar to above.
1177                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1178                 }
1179             }
1180             if (toMasked == 0) revert MintToZeroAddress();
1181 
1182             _currentIndex = end;
1183         }
1184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185     }
1186 
1187     /**
1188      * @dev Mints `quantity` tokens and transfers them to `to`.
1189      *
1190      * This function is intended for efficient minting only during contract creation.
1191      *
1192      * It emits only one {ConsecutiveTransfer} as defined in
1193      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1194      * instead of a sequence of {Transfer} event(s).
1195      *
1196      * Calling this function outside of contract creation WILL make your contract
1197      * non-compliant with the ERC721 standard.
1198      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1199      * {ConsecutiveTransfer} event is only permissible during contract creation.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `quantity` must be greater than 0.
1205      *
1206      * Emits a {ConsecutiveTransfer} event.
1207      */
1208     function _mintERC2309(address to, uint256 quantity) internal virtual {
1209         uint256 startTokenId = _currentIndex;
1210         if (to == address(0)) revert MintToZeroAddress();
1211         if (quantity == 0) revert MintZeroQuantity();
1212         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1213 
1214         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1215 
1216         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1217         unchecked {
1218             // Updates:
1219             // - `balance += quantity`.
1220             // - `numberMinted += quantity`.
1221             //
1222             // We can directly add to the `balance` and `numberMinted`.
1223             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1224 
1225             // Updates:
1226             // - `address` to the owner.
1227             // - `startTimestamp` to the timestamp of minting.
1228             // - `burned` to `false`.
1229             // - `nextInitialized` to `quantity == 1`.
1230             _packedOwnerships[startTokenId] = _packOwnershipData(
1231                 to,
1232                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1233             );
1234 
1235             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1236 
1237             _currentIndex = startTokenId + quantity;
1238         }
1239         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1240     }
1241 
1242     /**
1243      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - If `to` refers to a smart contract, it must implement
1248      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1249      * - `quantity` must be greater than 0.
1250      *
1251      * See {_mint}.
1252      *
1253      * Emits a {Transfer} event for each mint.
1254      */
1255     function _safeMint(
1256         address to,
1257         uint256 quantity,
1258         bytes memory _data
1259     ) internal virtual {
1260         _mint(to, quantity);
1261 
1262         unchecked {
1263             if (to.code.length != 0) {
1264                 uint256 end = _currentIndex;
1265                 uint256 index = end - quantity;
1266                 do {
1267                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1268                         revert TransferToNonERC721ReceiverImplementer();
1269                     }
1270                 } while (index < end);
1271                 // Reentrancy protection.
1272                 if (_currentIndex != end) revert();
1273             }
1274         }
1275     }
1276 
1277     /**
1278      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1279      */
1280     function _safeMint(address to, uint256 quantity) internal virtual {
1281         _safeMint(to, quantity, '');
1282     }
1283 
1284     // =============================================================
1285     //                        BURN OPERATIONS
1286     // =============================================================
1287 
1288     /**
1289      * @dev Equivalent to `_burn(tokenId, false)`.
1290      */
1291     function _burn(uint256 tokenId) internal virtual {
1292         _burn(tokenId, false);
1293     }
1294 
1295     /**
1296      * @dev Destroys `tokenId`.
1297      * The approval is cleared when the token is burned.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must exist.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1306         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1307 
1308         address from = address(uint160(prevOwnershipPacked));
1309 
1310         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1311 
1312         if (approvalCheck) {
1313             // The nested ifs save around 20+ gas over a compound boolean condition.
1314             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1315                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1316         }
1317 
1318         _beforeTokenTransfers(from, address(0), tokenId, 1);
1319 
1320         // Clear approvals from the previous owner.
1321         assembly {
1322             if approvedAddress {
1323                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1324                 sstore(approvedAddressSlot, 0)
1325             }
1326         }
1327 
1328         // Underflow of the sender's balance is impossible because we check for
1329         // ownership above and the recipient's balance can't realistically overflow.
1330         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1331         unchecked {
1332             // Updates:
1333             // - `balance -= 1`.
1334             // - `numberBurned += 1`.
1335             //
1336             // We can directly decrement the balance, and increment the number burned.
1337             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1338             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1339 
1340             // Updates:
1341             // - `address` to the last owner.
1342             // - `startTimestamp` to the timestamp of burning.
1343             // - `burned` to `true`.
1344             // - `nextInitialized` to `true`.
1345             _packedOwnerships[tokenId] = _packOwnershipData(
1346                 from,
1347                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1348             );
1349 
1350             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1351             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1352                 uint256 nextTokenId = tokenId + 1;
1353                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1354                 if (_packedOwnerships[nextTokenId] == 0) {
1355                     // If the next slot is within bounds.
1356                     if (nextTokenId != _currentIndex) {
1357                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1358                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1359                     }
1360                 }
1361             }
1362         }
1363 
1364         emit Transfer(from, address(0), tokenId);
1365         _afterTokenTransfers(from, address(0), tokenId, 1);
1366 
1367         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1368         unchecked {
1369             _burnCounter++;
1370         }
1371     }
1372 
1373     // =============================================================
1374     //                     EXTRA DATA OPERATIONS
1375     // =============================================================
1376 
1377     /**
1378      * @dev Directly sets the extra data for the ownership data `index`.
1379      */
1380     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1381         uint256 packed = _packedOwnerships[index];
1382         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1383         uint256 extraDataCasted;
1384         // Cast `extraData` with assembly to avoid redundant masking.
1385         assembly {
1386             extraDataCasted := extraData
1387         }
1388         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1389         _packedOwnerships[index] = packed;
1390     }
1391 
1392     /**
1393      * @dev Called during each token transfer to set the 24bit `extraData` field.
1394      * Intended to be overridden by the cosumer contract.
1395      *
1396      * `previousExtraData` - the value of `extraData` before transfer.
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` will be minted for `to`.
1403      * - When `to` is zero, `tokenId` will be burned by `from`.
1404      * - `from` and `to` are never both zero.
1405      */
1406     function _extraData(
1407         address from,
1408         address to,
1409         uint24 previousExtraData
1410     ) internal view virtual returns (uint24) {}
1411 
1412     /**
1413      * @dev Returns the next extra data for the packed ownership data.
1414      * The returned result is shifted into position.
1415      */
1416     function _nextExtraData(
1417         address from,
1418         address to,
1419         uint256 prevOwnershipPacked
1420     ) private view returns (uint256) {
1421         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1422         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1423     }
1424 
1425     // =============================================================
1426     //                       OTHER OPERATIONS
1427     // =============================================================
1428 
1429     /**
1430      * @dev Returns the message sender (defaults to `msg.sender`).
1431      *
1432      * If you are writing GSN compatible contracts, you need to override this function.
1433      */
1434     function _msgSenderERC721A() internal view virtual returns (address) {
1435         return msg.sender;
1436     }
1437 
1438     /**
1439      * @dev Converts a uint256 to its ASCII string decimal representation.
1440      */
1441     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1442         assembly {
1443             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1444             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1445             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1446             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1447             let m := add(mload(0x40), 0xa0)
1448             // Update the free memory pointer to allocate.
1449             mstore(0x40, m)
1450             // Assign the `str` to the end.
1451             str := sub(m, 0x20)
1452             // Zeroize the slot after the string.
1453             mstore(str, 0)
1454 
1455             // Cache the end of the memory to calculate the length later.
1456             let end := str
1457 
1458             // We write the string from rightmost digit to leftmost digit.
1459             // The following is essentially a do-while loop that also handles the zero case.
1460             // prettier-ignore
1461             for { let temp := value } 1 {} {
1462                 str := sub(str, 1)
1463                 // Write the character to the pointer.
1464                 // The ASCII index of the '0' character is 48.
1465                 mstore8(str, add(48, mod(temp, 10)))
1466                 // Keep dividing `temp` until zero.
1467                 temp := div(temp, 10)
1468                 // prettier-ignore
1469                 if iszero(temp) { break }
1470             }
1471 
1472             let length := sub(end, str)
1473             // Move the pointer 32 bytes leftwards to make room for the length.
1474             str := sub(str, 0x20)
1475             // Store the length.
1476             mstore(str, length)
1477         }
1478     }
1479 }
1480 // File: contracts/Math.sol
1481 
1482 
1483 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1484 
1485 pragma solidity ^0.8.0;
1486 
1487 /**
1488  * @dev Standard math utilities missing in the Solidity language.
1489  */
1490 library Math {
1491     enum Rounding {
1492         Down, // Toward negative infinity
1493         Up, // Toward infinity
1494         Zero // Toward zero
1495     }
1496 
1497     /**
1498      * @dev Returns the largest of two numbers.
1499      */
1500     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1501         return a > b ? a : b;
1502     }
1503 
1504     /**
1505      * @dev Returns the smallest of two numbers.
1506      */
1507     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1508         return a < b ? a : b;
1509     }
1510 
1511     /**
1512      * @dev Returns the average of two numbers. The result is rounded towards
1513      * zero.
1514      */
1515     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1516         // (a + b) / 2 can overflow.
1517         return (a & b) + (a ^ b) / 2;
1518     }
1519 
1520     /**
1521      * @dev Returns the ceiling of the division of two numbers.
1522      *
1523      * This differs from standard division with `/` in that it rounds up instead
1524      * of rounding down.
1525      */
1526     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1527         // (a + b - 1) / b can overflow on addition, so we distribute.
1528         return a == 0 ? 0 : (a - 1) / b + 1;
1529     }
1530 
1531     /**
1532      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1533      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1534      * with further edits by Uniswap Labs also under MIT license.
1535      */
1536     function mulDiv(
1537         uint256 x,
1538         uint256 y,
1539         uint256 denominator
1540     ) internal pure returns (uint256 result) {
1541         unchecked {
1542             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1543             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1544             // variables such that product = prod1 * 2^256 + prod0.
1545             uint256 prod0; // Least significant 256 bits of the product
1546             uint256 prod1; // Most significant 256 bits of the product
1547             assembly {
1548                 let mm := mulmod(x, y, not(0))
1549                 prod0 := mul(x, y)
1550                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1551             }
1552 
1553             // Handle non-overflow cases, 256 by 256 division.
1554             if (prod1 == 0) {
1555                 return prod0 / denominator;
1556             }
1557 
1558             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1559             require(denominator > prod1);
1560 
1561             ///////////////////////////////////////////////
1562             // 512 by 256 division.
1563             ///////////////////////////////////////////////
1564 
1565             // Make division exact by subtracting the remainder from [prod1 prod0].
1566             uint256 remainder;
1567             assembly {
1568                 // Compute remainder using mulmod.
1569                 remainder := mulmod(x, y, denominator)
1570 
1571                 // Subtract 256 bit number from 512 bit number.
1572                 prod1 := sub(prod1, gt(remainder, prod0))
1573                 prod0 := sub(prod0, remainder)
1574             }
1575 
1576             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1577             // See https://cs.stackexchange.com/q/138556/92363.
1578 
1579             // Does not overflow because the denominator cannot be zero at this stage in the function.
1580             uint256 twos = denominator & (~denominator + 1);
1581             assembly {
1582                 // Divide denominator by twos.
1583                 denominator := div(denominator, twos)
1584 
1585                 // Divide [prod1 prod0] by twos.
1586                 prod0 := div(prod0, twos)
1587 
1588                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1589                 twos := add(div(sub(0, twos), twos), 1)
1590             }
1591 
1592             // Shift in bits from prod1 into prod0.
1593             prod0 |= prod1 * twos;
1594 
1595             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1596             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1597             // four bits. That is, denominator * inv = 1 mod 2^4.
1598             uint256 inverse = (3 * denominator) ^ 2;
1599 
1600             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1601             // in modular arithmetic, doubling the correct bits in each step.
1602             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1603             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1604             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1605             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1606             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1607             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1608 
1609             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1610             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1611             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1612             // is no longer required.
1613             result = prod0 * inverse;
1614             return result;
1615         }
1616     }
1617 
1618     /**
1619      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1620      */
1621     function mulDiv(
1622         uint256 x,
1623         uint256 y,
1624         uint256 denominator,
1625         Rounding rounding
1626     ) internal pure returns (uint256) {
1627         uint256 result = mulDiv(x, y, denominator);
1628         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1629             result += 1;
1630         }
1631         return result;
1632     }
1633 
1634     /**
1635      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1636      *
1637      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1638      */
1639     function sqrt(uint256 a) internal pure returns (uint256) {
1640         if (a == 0) {
1641             return 0;
1642         }
1643 
1644         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1645         //
1646         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1647         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1648         //
1649         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1650         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1651         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1652         //
1653         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1654         uint256 result = 1 << (log2(a) >> 1);
1655 
1656         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1657         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1658         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1659         // into the expected uint128 result.
1660         unchecked {
1661             result = (result + a / result) >> 1;
1662             result = (result + a / result) >> 1;
1663             result = (result + a / result) >> 1;
1664             result = (result + a / result) >> 1;
1665             result = (result + a / result) >> 1;
1666             result = (result + a / result) >> 1;
1667             result = (result + a / result) >> 1;
1668             return min(result, a / result);
1669         }
1670     }
1671 
1672     /**
1673      * @notice Calculates sqrt(a), following the selected rounding direction.
1674      */
1675     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1676         unchecked {
1677             uint256 result = sqrt(a);
1678             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1679         }
1680     }
1681 
1682     /**
1683      * @dev Return the log in base 2, rounded down, of a positive value.
1684      * Returns 0 if given 0.
1685      */
1686     function log2(uint256 value) internal pure returns (uint256) {
1687         uint256 result = 0;
1688         unchecked {
1689             if (value >> 128 > 0) {
1690                 value >>= 128;
1691                 result += 128;
1692             }
1693             if (value >> 64 > 0) {
1694                 value >>= 64;
1695                 result += 64;
1696             }
1697             if (value >> 32 > 0) {
1698                 value >>= 32;
1699                 result += 32;
1700             }
1701             if (value >> 16 > 0) {
1702                 value >>= 16;
1703                 result += 16;
1704             }
1705             if (value >> 8 > 0) {
1706                 value >>= 8;
1707                 result += 8;
1708             }
1709             if (value >> 4 > 0) {
1710                 value >>= 4;
1711                 result += 4;
1712             }
1713             if (value >> 2 > 0) {
1714                 value >>= 2;
1715                 result += 2;
1716             }
1717             if (value >> 1 > 0) {
1718                 result += 1;
1719             }
1720         }
1721         return result;
1722     }
1723 
1724     /**
1725      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1726      * Returns 0 if given 0.
1727      */
1728     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1729         unchecked {
1730             uint256 result = log2(value);
1731             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1732         }
1733     }
1734 
1735     /**
1736      * @dev Return the log in base 10, rounded down, of a positive value.
1737      * Returns 0 if given 0.
1738      */
1739     function log10(uint256 value) internal pure returns (uint256) {
1740         uint256 result = 0;
1741         unchecked {
1742             if (value >= 10**64) {
1743                 value /= 10**64;
1744                 result += 64;
1745             }
1746             if (value >= 10**32) {
1747                 value /= 10**32;
1748                 result += 32;
1749             }
1750             if (value >= 10**16) {
1751                 value /= 10**16;
1752                 result += 16;
1753             }
1754             if (value >= 10**8) {
1755                 value /= 10**8;
1756                 result += 8;
1757             }
1758             if (value >= 10**4) {
1759                 value /= 10**4;
1760                 result += 4;
1761             }
1762             if (value >= 10**2) {
1763                 value /= 10**2;
1764                 result += 2;
1765             }
1766             if (value >= 10**1) {
1767                 result += 1;
1768             }
1769         }
1770         return result;
1771     }
1772 
1773     /**
1774      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1775      * Returns 0 if given 0.
1776      */
1777     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1778         unchecked {
1779             uint256 result = log10(value);
1780             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1781         }
1782     }
1783 
1784     /**
1785      * @dev Return the log in base 256, rounded down, of a positive value.
1786      * Returns 0 if given 0.
1787      *
1788      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1789      */
1790     function log256(uint256 value) internal pure returns (uint256) {
1791         uint256 result = 0;
1792         unchecked {
1793             if (value >> 128 > 0) {
1794                 value >>= 128;
1795                 result += 16;
1796             }
1797             if (value >> 64 > 0) {
1798                 value >>= 64;
1799                 result += 8;
1800             }
1801             if (value >> 32 > 0) {
1802                 value >>= 32;
1803                 result += 4;
1804             }
1805             if (value >> 16 > 0) {
1806                 value >>= 16;
1807                 result += 2;
1808             }
1809             if (value >> 8 > 0) {
1810                 result += 1;
1811             }
1812         }
1813         return result;
1814     }
1815 
1816     /**
1817      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1818      * Returns 0 if given 0.
1819      */
1820     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1821         unchecked {
1822             uint256 result = log256(value);
1823             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1824         }
1825     }
1826 }
1827 // File: contracts/Strings.sol
1828 
1829 
1830 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1831 
1832 pragma solidity ^0.8.0;
1833 
1834 
1835 /**
1836  * @dev String operations.
1837  */
1838 library Strings {
1839     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1840     uint8 private constant _ADDRESS_LENGTH = 20;
1841 
1842     /**
1843      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1844      */
1845     function toString(uint256 value) internal pure returns (string memory) {
1846         unchecked {
1847             uint256 length = Math.log10(value) + 1;
1848             string memory buffer = new string(length);
1849             uint256 ptr;
1850             /// @solidity memory-safe-assembly
1851             assembly {
1852                 ptr := add(buffer, add(32, length))
1853             }
1854             while (true) {
1855                 ptr--;
1856                 /// @solidity memory-safe-assembly
1857                 assembly {
1858                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1859                 }
1860                 value /= 10;
1861                 if (value == 0) break;
1862             }
1863             return buffer;
1864         }
1865     }
1866 
1867     /**
1868      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1869      */
1870     function toHexString(uint256 value) internal pure returns (string memory) {
1871         unchecked {
1872             return toHexString(value, Math.log256(value) + 1);
1873         }
1874     }
1875 
1876     /**
1877      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1878      */
1879     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1880         bytes memory buffer = new bytes(2 * length + 2);
1881         buffer[0] = "0";
1882         buffer[1] = "x";
1883         for (uint256 i = 2 * length + 1; i > 1; --i) {
1884             buffer[i] = _SYMBOLS[value & 0xf];
1885             value >>= 4;
1886         }
1887         require(value == 0, "Strings: hex length insufficient");
1888         return string(buffer);
1889     }
1890 
1891     /**
1892      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1893      */
1894     function toHexString(address addr) internal pure returns (string memory) {
1895         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1896     }
1897 }
1898 // File: contracts/Context.sol
1899 
1900 
1901 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1902 
1903 pragma solidity ^0.8.0;
1904 
1905 /**
1906  * @dev Provides information about the current execution context, including the
1907  * sender of the transaction and its data. While these are generally available
1908  * via msg.sender and msg.data, they should not be accessed in such a direct
1909  * manner, since when dealing with meta-transactions the account sending and
1910  * paying for execution may not be the actual sender (as far as an application
1911  * is concerned).
1912  *
1913  * This contract is only required for intermediate, library-like contracts.
1914  */
1915 abstract contract Context {
1916     function _msgSender() internal view virtual returns (address) {
1917         return msg.sender;
1918     }
1919 
1920     function _msgData() internal view virtual returns (bytes calldata) {
1921         return msg.data;
1922     }
1923 }
1924 // File: contracts/Ownable.sol
1925 
1926 
1927 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1928 
1929 pragma solidity ^0.8.0;
1930 
1931 
1932 /**
1933  * @dev Contract module which provides a basic access control mechanism, where
1934  * there is an account (an owner) that can be granted exclusive access to
1935  * specific functions.
1936  *
1937  * By default, the owner account will be the one that deploys the contract. This
1938  * can later be changed with {transferOwnership}.
1939  *
1940  * This module is used through inheritance. It will make available the modifier
1941  * `onlyOwner`, which can be applied to your functions to restrict their use to
1942  * the owner.
1943  */
1944 abstract contract Ownable is Context {
1945     address private _owner;
1946 
1947     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1948 
1949     /**
1950      * @dev Initializes the contract setting the deployer as the initial owner.
1951      */
1952     constructor() {
1953         _transferOwnership(_msgSender());
1954     }
1955 
1956     /**
1957      * @dev Throws if called by any account other than the owner.
1958      */
1959     modifier onlyOwner() {
1960         _checkOwner();
1961         _;
1962     }
1963 
1964     /**
1965      * @dev Returns the address of the current owner.
1966      */
1967     function owner() public view virtual returns (address) {
1968         return _owner;
1969     }
1970 
1971     /**
1972      * @dev Throws if the sender is not the owner.
1973      */
1974     function _checkOwner() internal view virtual {
1975         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1976     }
1977 
1978     /**
1979      * @dev Leaves the contract without owner. It will not be possible to call
1980      * `onlyOwner` functions anymore. Can only be called by the current owner.
1981      *
1982      * NOTE: Renouncing ownership will leave the contract without an owner,
1983      * thereby removing any functionality that is only available to the owner.
1984      */
1985     function renounceOwnership() public virtual onlyOwner {
1986         _transferOwnership(address(0));
1987     }
1988 
1989     /**
1990      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1991      * Can only be called by the current owner.
1992      */
1993     function transferOwnership(address newOwner) public virtual onlyOwner {
1994         require(newOwner != address(0), "Ownable: new owner is the zero address");
1995         _transferOwnership(newOwner);
1996     }
1997 
1998     /**
1999      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2000      * Internal function without access restriction.
2001      */
2002     function _transferOwnership(address newOwner) internal virtual {
2003         address oldOwner = _owner;
2004         _owner = newOwner;
2005         emit OwnershipTransferred(oldOwner, newOwner);
2006     }
2007 }
2008 
2009 pragma solidity ^0.8.7;
2010 
2011 contract pepebooty is ERC721A, Ownable{
2012     using Strings for uint256;
2013    
2014     uint public tokenPrice = 0.004 ether;
2015     uint public maxSupply = 6969;
2016     uint public freeNFT = 1;
2017     bool public sale_status = false;
2018     bool public isBurnEnabled = false;
2019     bool public isRevealed = false;
2020     
2021     string public baseURI = "";
2022     string public placeholderTokenUri = "ipfs://QmYipo7FM3EMLiKUAHDguo2iaDxQ9zisHi29AmcGHjt2Tw/";
2023     
2024     mapping(uint256 => address) public burnedby;
2025     mapping(address => bool) public hasMintedFree;
2026     mapping(address => uint256) public addressMintedBalance;
2027 
2028     uint public maxPerTransaction = 21;  //Max Limit for Sale
2029     uint public maxPerWallet = 21; //Max Limit for Presale
2030              
2031     constructor() ERC721A("pepe booty", "THICK"){}
2032 
2033     function mint(uint _count) public payable{
2034         require(sale_status == true, "Sale is Paused.");
2035         require(_count > 0, "mint at least one token");
2036         require(totalSupply() + _count <= maxSupply, "Sold Out!");
2037         require(_count <= maxPerTransaction, "max per transaction 5");
2038         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2039         require(ownerMintedCount + _count <= maxPerWallet, "ERROR: Max NFT per address exceeded");
2040         addressMintedBalance[msg.sender] += _count;        
2041     //  uint count = balanceOf(msg.sender);
2042         if (ownerMintedCount < freeNFT) {
2043             if (_count > freeNFT - ownerMintedCount)
2044             {
2045             require(msg.value >= tokenPrice * (_count - (freeNFT - ownerMintedCount)), "Insufficient funds!");
2046             _safeMint(msg.sender, _count);
2047             }
2048             else
2049             {
2050             _safeMint(msg.sender, _count);
2051             }
2052         }
2053         else
2054         {
2055             require(msg.value >= tokenPrice * _count, "You got max free NFTs! Provide funds");
2056             _safeMint(msg.sender, _count);
2057         }
2058    }
2059 
2060     function adminMint(uint _count) external onlyOwner{
2061         require(_count > 0, "mint at least one token");
2062         require(totalSupply() + _count <= maxSupply, "Sold Out!");
2063         _safeMint(msg.sender, _count);
2064     }
2065 
2066     function sendGifts(address[] memory _wallets) public onlyOwner{
2067         require(totalSupply() + _wallets.length <= maxSupply, "Sold Out!");
2068         for(uint i = 0; i < _wallets.length; i++)
2069         _safeMint(_wallets[i], 1);
2070     }
2071 
2072     function _baseURI() internal view virtual override returns (string memory) {
2073         return baseURI;
2074     }
2075 
2076     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2077         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2078         if(!isRevealed)
2079         {
2080             return placeholderTokenUri;
2081         }
2082         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
2083     }
2084 
2085     function setBaseUri(string memory _uri) external onlyOwner {
2086         baseURI = _uri;
2087     }
2088 
2089     function setPlaceholderTokenUri(string memory newPlaceholderTokenUri) external onlyOwner {
2090         placeholderTokenUri = newPlaceholderTokenUri;
2091     }
2092 
2093     function updateFreeNFT(uint newValue) public onlyOwner {
2094         freeNFT = newValue;
2095     }
2096 
2097     function updateMaxSupply(uint _newMaxSupply) public onlyOwner {
2098         require(_newMaxSupply > totalSupply(), "New maxSupply should be greater than current totalSupply");
2099         maxSupply = _newMaxSupply;
2100     }
2101 
2102     function updateMaxPerTransaction(uint newMax) public onlyOwner {
2103         maxPerTransaction = newMax;
2104     }
2105 
2106     function updateMaxPerWallet(uint newMax) public onlyOwner {
2107         maxPerWallet = newMax;
2108     }
2109 
2110     function toggleSaleStatus() external onlyOwner{
2111         sale_status = !sale_status;
2112     }
2113     
2114     function update_burning_status(bool status) external onlyOwner {
2115         isBurnEnabled = status;
2116     }
2117   
2118     function bulkBurn(uint256[] memory tokenIds) external {
2119         require(isBurnEnabled, "burning disabled");
2120         for (uint i = 0; i < tokenIds.length; i++) {
2121         uint256 tokenId = tokenIds[i];
2122         require(
2123             _isApprovedOrOwner(msg.sender, tokenId),
2124             "burn caller is not approved"
2125         );
2126         _burn(tokenId);
2127         burnedby[tokenId] = msg.sender;
2128     }
2129 }
2130      function public_sale_price(uint pr) external onlyOwner {
2131         tokenPrice = pr;
2132     }
2133 
2134     function toggleReveal() external onlyOwner{
2135         isRevealed = !isRevealed;
2136     }
2137 
2138     function withdraw() external onlyOwner {
2139         uint _balance = address(this).balance;
2140         payable(owner()).transfer(_balance);
2141     }
2142 }