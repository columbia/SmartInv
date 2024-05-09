1 // SPDX-License-Identifier: MIT
2  
3 //    ____   ____    ____  ____  ____   _        ___  _____ _____      _____ ____  ____  __  _    ___  _____
4 //   |    \ |    \  /    ||    ||    \ | |      /  _]/ ___// ___/     / ___/|    \|    ||  |/ ]  /  _]/ ___/
5 //   |  o  )|  D  )|  o  | |  | |  _  || |     /  [_(   \_(   \_     (   \_ |  o  )|  | |  ' /  /  [_(   \_ 
6 //   |     ||    / |     | |  | |  |  || |___ |    _]\__  |\__  |     \__  ||   _/ |  | |    \ |    _]\__  |
7 //   |  O  ||    \ |  _  | |  | |  |  ||     ||   [_ /  \ |/  \ |     /  \ ||  |   |  | |     ||   [_ /  \ |
8 //   |     ||  .  \|  |  | |  | |  |  ||     ||     |\    |\    |     \    ||  |   |  | |  .  ||     |\    |
9 //   |_____||__|\_||__|__||____||__|__||_____||_____| \___| \___|      \___||__|  |____||__|\_||_____| \___|
10 
11 // NFT: Brainless Spikes
12                                                                                                         
13 // Twitter: https://twitter.com/BrainlesSpikes
14 // Website: https://brainlesspikes.io/
15 
16 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
17 
18 pragma solidity ^0.8.13;
19 
20 interface IOperatorFilterRegistry {
21     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
22     function register(address registrant) external;
23     function registerAndSubscribe(address registrant, address subscription) external;
24     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
25     function updateOperator(address registrant, address operator, bool filtered) external;
26     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
27     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
28     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
29     function subscribe(address registrant, address registrantToSubscribe) external;
30     function unsubscribe(address registrant, bool copyExistingEntries) external;
31     function subscriptionOf(address addr) external returns (address registrant);
32     function subscribers(address registrant) external returns (address[] memory);
33     function subscriberAt(address registrant, uint256 index) external returns (address);
34     function copyEntriesOf(address registrant, address registrantToCopy) external;
35     function isOperatorFiltered(address registrant, address operator) external returns (bool);
36     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
37     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
38     function filteredOperators(address addr) external returns (address[] memory);
39     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
40     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
41     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
42     function isRegistered(address addr) external returns (bool);
43     function codeHashOf(address addr) external returns (bytes32);
44 }
45 
46 // File: operator-filter-registry/src/OperatorFilterer.sol
47 
48 
49 pragma solidity ^0.8.13;
50 
51 
52 abstract contract OperatorFilterer {
53     error OperatorNotAllowed(address operator);
54 
55     IOperatorFilterRegistry constant operatorFilterRegistry =
56         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
57 
58     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
59         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
60         // will not revert, but the contract will need to be registered with the registry once it is deployed in
61         // order for the modifier to filter addresses.
62         if (address(operatorFilterRegistry).code.length > 0) {
63             if (subscribe) {
64                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
65             } else {
66                 if (subscriptionOrRegistrantToCopy != address(0)) {
67                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
68                 } else {
69                     operatorFilterRegistry.register(address(this));
70                 }
71             }
72         }
73     }
74 
75     modifier onlyAllowedOperator(address from) virtual {
76         // Check registry code length to facilitate testing in environments without a deployed registry.
77         if (address(operatorFilterRegistry).code.length > 0) {
78             // Allow spending tokens from addresses with balance
79             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80             // from an EOA.
81             if (from == msg.sender) {
82                 _;
83                 return;
84             }
85             if (
86                 !(
87                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
88                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
89                 )
90             ) {
91                 revert OperatorNotAllowed(msg.sender);
92             }
93         }
94         _;
95     }
96 }
97 
98 // File: erc721a/contracts/IERC721A.sol
99 
100 
101 // ERC721A Contracts v4.2.3
102 // Creator: Chiru Labs
103 
104 pragma solidity ^0.8.4;
105 
106 /**
107  * @dev Interface of ERC721A.
108  */
109 interface IERC721A {
110     /**
111      * The caller must own the token or be an approved operator.
112      */
113     error ApprovalCallerNotOwnerNorApproved();
114 
115     /**
116      * The token does not exist.
117      */
118     error ApprovalQueryForNonexistentToken();
119 
120     /**
121      * Cannot query the balance for the zero address.
122      */
123     error BalanceQueryForZeroAddress();
124 
125     /**
126      * Cannot mint to the zero address.
127      */
128     error MintToZeroAddress();
129 
130     /**
131      * The quantity of tokens minted must be more than zero.
132      */
133     error MintZeroQuantity();
134 
135     /**
136      * The token does not exist.
137      */
138     error OwnerQueryForNonexistentToken();
139 
140     /**
141      * The caller must own the token or be an approved operator.
142      */
143     error TransferCallerNotOwnerNorApproved();
144 
145     /**
146      * The token must be owned by `from`.
147      */
148     error TransferFromIncorrectOwner();
149 
150     /**
151      * Cannot safely transfer to a contract that does not implement the
152      * ERC721Receiver interface.
153      */
154     error TransferToNonERC721ReceiverImplementer();
155 
156     /**
157      * Cannot transfer to the zero address.
158      */
159     error TransferToZeroAddress();
160 
161     /**
162      * The token does not exist.
163      */
164     error URIQueryForNonexistentToken();
165 
166     /**
167      * The `quantity` minted with ERC2309 exceeds the safety limit.
168      */
169     error MintERC2309QuantityExceedsLimit();
170 
171     /**
172      * The `extraData` cannot be set on an unintialized ownership slot.
173      */
174     error OwnershipNotInitializedForExtraData();
175 
176     // =============================================================
177     //                            STRUCTS
178     // =============================================================
179 
180     struct TokenOwnership {
181         // The address of the owner.
182         address addr;
183         // Stores the start time of ownership with minimal overhead for tokenomics.
184         uint64 startTimestamp;
185         // Whether the token has been burned.
186         bool burned;
187         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
188         uint24 extraData;
189     }
190 
191     // =============================================================
192     //                         TOKEN COUNTERS
193     // =============================================================
194 
195     /**
196      * @dev Returns the total number of tokens in existence.
197      * Burned tokens will reduce the count.
198      * To get the total number of tokens minted, please see {_totalMinted}.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     // =============================================================
203     //                            IERC165
204     // =============================================================
205 
206     /**
207      * @dev Returns true if this contract implements the interface defined by
208      * `interfaceId`. See the corresponding
209      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
210      * to learn more about how these ids are created.
211      *
212      * This function call must use less than 30000 gas.
213      */
214     function supportsInterface(bytes4 interfaceId) external view returns (bool);
215 
216     // =============================================================
217     //                            IERC721
218     // =============================================================
219 
220     /**
221      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
224 
225     /**
226      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
227      */
228     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables or disables
232      * (`approved`) `operator` to manage all of its assets.
233      */
234     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
235 
236     /**
237      * @dev Returns the number of tokens in `owner`'s account.
238      */
239     function balanceOf(address owner) external view returns (uint256 balance);
240 
241     /**
242      * @dev Returns the owner of the `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function ownerOf(uint256 tokenId) external view returns (address owner);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`,
252      * checking first that contract recipients are aware of the ERC721 protocol
253      * to prevent tokens from being forever locked.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be have been allowed to move
261      * this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement
263      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external payable;
273 
274     /**
275      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId
281     ) external payable;
282 
283     /**
284      * @dev Transfers `tokenId` from `from` to `to`.
285      *
286      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
287      * whenever possible.
288      *
289      * Requirements:
290      *
291      * - `from` cannot be the zero address.
292      * - `to` cannot be the zero address.
293      * - `tokenId` token must be owned by `from`.
294      * - If the caller is not `from`, it must be approved to move this token
295      * by either {approve} or {setApprovalForAll}.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external payable;
304 
305     /**
306      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
307      * The approval is cleared when the token is transferred.
308      *
309      * Only a single account can be approved at a time, so approving the
310      * zero address clears previous approvals.
311      *
312      * Requirements:
313      *
314      * - The caller must own the token or be an approved operator.
315      * - `tokenId` must exist.
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address to, uint256 tokenId) external payable;
320 
321     /**
322      * @dev Approve or remove `operator` as an operator for the caller.
323      * Operators can call {transferFrom} or {safeTransferFrom}
324      * for any token owned by the caller.
325      *
326      * Requirements:
327      *
328      * - The `operator` cannot be the caller.
329      *
330      * Emits an {ApprovalForAll} event.
331      */
332     function setApprovalForAll(address operator, bool _approved) external;
333 
334     /**
335      * @dev Returns the account approved for `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function getApproved(uint256 tokenId) external view returns (address operator);
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}.
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     // =============================================================
351     //                        IERC721Metadata
352     // =============================================================
353 
354     /**
355      * @dev Returns the token collection name.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the token collection symbol.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
366      */
367     function tokenURI(uint256 tokenId) external view returns (string memory);
368 
369     // =============================================================
370     //                           IERC2309
371     // =============================================================
372 
373     /**
374      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
375      * (inclusive) is transferred from `from` to `to`, as defined in the
376      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
377      *
378      * See {_mintERC2309} for more details.
379      */
380     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
381 }
382 
383 // File: erc721a/contracts/ERC721A.sol
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
419 contract ERC721A is IERC721A {
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
538         return 0;
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
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public payable virtual override {
928         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
929 
930         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
931 
932         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
933 
934         // The nested ifs save around 20+ gas over a compound boolean condition.
935         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
936             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
937 
938         if (to == address(0)) revert TransferToZeroAddress();
939 
940         _beforeTokenTransfers(from, to, tokenId, 1);
941 
942         // Clear approvals from the previous owner.
943         assembly {
944             if approvedAddress {
945                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
946                 sstore(approvedAddressSlot, 0)
947             }
948         }
949 
950         // Underflow of the sender's balance is impossible because we check for
951         // ownership above and the recipient's balance can't realistically overflow.
952         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
953         unchecked {
954             // We can directly increment and decrement the balances.
955             --_packedAddressData[from]; // Updates: `balance -= 1`.
956             ++_packedAddressData[to]; // Updates: `balance += 1`.
957 
958             // Updates:
959             // - `address` to the next owner.
960             // - `startTimestamp` to the timestamp of transfering.
961             // - `burned` to `false`.
962             // - `nextInitialized` to `true`.
963             _packedOwnerships[tokenId] = _packOwnershipData(
964                 to,
965                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
966             );
967 
968             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
969             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
970                 uint256 nextTokenId = tokenId + 1;
971                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
972                 if (_packedOwnerships[nextTokenId] == 0) {
973                     // If the next slot is within bounds.
974                     if (nextTokenId != _currentIndex) {
975                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
976                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
977                     }
978                 }
979             }
980         }
981 
982         emit Transfer(from, to, tokenId);
983         _afterTokenTransfers(from, to, tokenId, 1);
984     }
985 
986     /**
987      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId
993     ) public payable virtual override {
994         safeTransferFrom(from, to, tokenId, '');
995     }
996 
997     /**
998      * @dev Safely transfers `tokenId` token from `from` to `to`.
999      *
1000      * Requirements:
1001      *
1002      * - `from` cannot be the zero address.
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must exist and be owned by `from`.
1005      * - If the caller is not `from`, it must be approved to move this token
1006      * by either {approve} or {setApprovalForAll}.
1007      * - If `to` refers to a smart contract, it must implement
1008      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) public payable virtual override {
1018         transferFrom(from, to, tokenId);
1019         if (to.code.length != 0)
1020             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1021                 revert TransferToNonERC721ReceiverImplementer();
1022             }
1023     }
1024 
1025     /**
1026      * @dev Hook that is called before a set of serially-ordered token IDs
1027      * are about to be transferred. This includes minting.
1028      * And also called before burning one token.
1029      *
1030      * `startTokenId` - the first token ID to be transferred.
1031      * `quantity` - the amount to be transferred.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` will be minted for `to`.
1038      * - When `to` is zero, `tokenId` will be burned by `from`.
1039      * - `from` and `to` are never both zero.
1040      */
1041     function _beforeTokenTransfers(
1042         address from,
1043         address to,
1044         uint256 startTokenId,
1045         uint256 quantity
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Hook that is called after a set of serially-ordered token IDs
1050      * have been transferred. This includes minting.
1051      * And also called after one token has been burned.
1052      *
1053      * `startTokenId` - the first token ID to be transferred.
1054      * `quantity` - the amount to be transferred.
1055      *
1056      * Calling conditions:
1057      *
1058      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1059      * transferred to `to`.
1060      * - When `from` is zero, `tokenId` has been minted for `to`.
1061      * - When `to` is zero, `tokenId` has been burned by `from`.
1062      * - `from` and `to` are never both zero.
1063      */
1064     function _afterTokenTransfers(
1065         address from,
1066         address to,
1067         uint256 startTokenId,
1068         uint256 quantity
1069     ) internal virtual {}
1070 
1071     /**
1072      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1073      *
1074      * `from` - Previous owner of the given token ID.
1075      * `to` - Target address that will receive the token.
1076      * `tokenId` - Token ID to be transferred.
1077      * `_data` - Optional data to send along with the call.
1078      *
1079      * Returns whether the call correctly returned the expected magic value.
1080      */
1081     function _checkContractOnERC721Received(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) private returns (bool) {
1087         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1088             bytes4 retval
1089         ) {
1090             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1091         } catch (bytes memory reason) {
1092             if (reason.length == 0) {
1093                 revert TransferToNonERC721ReceiverImplementer();
1094             } else {
1095                 assembly {
1096                     revert(add(32, reason), mload(reason))
1097                 }
1098             }
1099         }
1100     }
1101 
1102     // =============================================================
1103     //                        MINT OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {Transfer} event for each mint.
1115      */
1116     function _mint(address to, uint256 quantity) internal virtual {
1117         uint256 startTokenId = _currentIndex;
1118         if (quantity == 0) revert MintZeroQuantity();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are incredibly unrealistic.
1123         // `balance` and `numberMinted` have a maximum limit of 2**64.
1124         // `tokenId` has a maximum limit of 2**256.
1125         unchecked {
1126             // Updates:
1127             // - `balance += quantity`.
1128             // - `numberMinted += quantity`.
1129             //
1130             // We can directly add to the `balance` and `numberMinted`.
1131             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1132 
1133             // Updates:
1134             // - `address` to the owner.
1135             // - `startTimestamp` to the timestamp of minting.
1136             // - `burned` to `false`.
1137             // - `nextInitialized` to `quantity == 1`.
1138             _packedOwnerships[startTokenId] = _packOwnershipData(
1139                 to,
1140                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1141             );
1142 
1143             uint256 toMasked;
1144             uint256 end = startTokenId + quantity;
1145 
1146             // Use assembly to loop and emit the `Transfer` event for gas savings.
1147             // The duplicated `log4` removes an extra check and reduces stack juggling.
1148             // The assembly, together with the surrounding Solidity code, have been
1149             // delicately arranged to nudge the compiler into producing optimized opcodes.
1150             assembly {
1151                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1152                 toMasked := and(to, _BITMASK_ADDRESS)
1153                 // Emit the `Transfer` event.
1154                 log4(
1155                     0, // Start of data (0, since no data).
1156                     0, // End of data (0, since no data).
1157                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1158                     0, // `address(0)`.
1159                     toMasked, // `to`.
1160                     startTokenId // `tokenId`.
1161                 )
1162 
1163                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1164                 // that overflows uint256 will make the loop run out of gas.
1165                 // The compiler will optimize the `iszero` away for performance.
1166                 for {
1167                     let tokenId := add(startTokenId, 1)
1168                 } iszero(eq(tokenId, end)) {
1169                     tokenId := add(tokenId, 1)
1170                 } {
1171                     // Emit the `Transfer` event. Similar to above.
1172                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1173                 }
1174             }
1175             if (toMasked == 0) revert MintToZeroAddress();
1176 
1177             _currentIndex = end;
1178         }
1179         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1180     }
1181 
1182     /**
1183      * @dev Mints `quantity` tokens and transfers them to `to`.
1184      *
1185      * This function is intended for efficient minting only during contract creation.
1186      *
1187      * It emits only one {ConsecutiveTransfer} as defined in
1188      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1189      * instead of a sequence of {Transfer} event(s).
1190      *
1191      * Calling this function outside of contract creation WILL make your contract
1192      * non-compliant with the ERC721 standard.
1193      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1194      * {ConsecutiveTransfer} event is only permissible during contract creation.
1195      *
1196      * Requirements:
1197      *
1198      * - `to` cannot be the zero address.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {ConsecutiveTransfer} event.
1202      */
1203     function _mintERC2309(address to, uint256 quantity) internal virtual {
1204         uint256 startTokenId = _currentIndex;
1205         if (to == address(0)) revert MintToZeroAddress();
1206         if (quantity == 0) revert MintZeroQuantity();
1207         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1208 
1209         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1210 
1211         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1212         unchecked {
1213             // Updates:
1214             // - `balance += quantity`.
1215             // - `numberMinted += quantity`.
1216             //
1217             // We can directly add to the `balance` and `numberMinted`.
1218             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1219 
1220             // Updates:
1221             // - `address` to the owner.
1222             // - `startTimestamp` to the timestamp of minting.
1223             // - `burned` to `false`.
1224             // - `nextInitialized` to `quantity == 1`.
1225             _packedOwnerships[startTokenId] = _packOwnershipData(
1226                 to,
1227                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1228             );
1229 
1230             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1231 
1232             _currentIndex = startTokenId + quantity;
1233         }
1234         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1235     }
1236 
1237     /**
1238      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - If `to` refers to a smart contract, it must implement
1243      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1244      * - `quantity` must be greater than 0.
1245      *
1246      * See {_mint}.
1247      *
1248      * Emits a {Transfer} event for each mint.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal virtual {
1255         _mint(to, quantity);
1256 
1257         unchecked {
1258             if (to.code.length != 0) {
1259                 uint256 end = _currentIndex;
1260                 uint256 index = end - quantity;
1261                 do {
1262                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1263                         revert TransferToNonERC721ReceiverImplementer();
1264                     }
1265                 } while (index < end);
1266                 // Reentrancy protection.
1267                 if (_currentIndex != end) revert();
1268             }
1269         }
1270     }
1271 
1272     /**
1273      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1274      */
1275     function _safeMint(address to, uint256 quantity) internal virtual {
1276         _safeMint(to, quantity, '');
1277     }
1278 
1279     // =============================================================
1280     //                        BURN OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Equivalent to `_burn(tokenId, false)`.
1285      */
1286     function _burn(uint256 tokenId) internal virtual {
1287         _burn(tokenId, false);
1288     }
1289 
1290     /**
1291      * @dev Destroys `tokenId`.
1292      * The approval is cleared when the token is burned.
1293      *
1294      * Requirements:
1295      *
1296      * - `tokenId` must exist.
1297      *
1298      * Emits a {Transfer} event.
1299      */
1300     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1301         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1302 
1303         address from = address(uint160(prevOwnershipPacked));
1304 
1305         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1306 
1307         if (approvalCheck) {
1308             // The nested ifs save around 20+ gas over a compound boolean condition.
1309             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1310                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1311         }
1312 
1313         _beforeTokenTransfers(from, address(0), tokenId, 1);
1314 
1315         // Clear approvals from the previous owner.
1316         assembly {
1317             if approvedAddress {
1318                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1319                 sstore(approvedAddressSlot, 0)
1320             }
1321         }
1322 
1323         // Underflow of the sender's balance is impossible because we check for
1324         // ownership above and the recipient's balance can't realistically overflow.
1325         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1326         unchecked {
1327             // Updates:
1328             // - `balance -= 1`.
1329             // - `numberBurned += 1`.
1330             //
1331             // We can directly decrement the balance, and increment the number burned.
1332             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1333             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1334 
1335             // Updates:
1336             // - `address` to the last owner.
1337             // - `startTimestamp` to the timestamp of burning.
1338             // - `burned` to `true`.
1339             // - `nextInitialized` to `true`.
1340             _packedOwnerships[tokenId] = _packOwnershipData(
1341                 from,
1342                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1343             );
1344 
1345             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1346             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1347                 uint256 nextTokenId = tokenId + 1;
1348                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1349                 if (_packedOwnerships[nextTokenId] == 0) {
1350                     // If the next slot is within bounds.
1351                     if (nextTokenId != _currentIndex) {
1352                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1353                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1354                     }
1355                 }
1356             }
1357         }
1358 
1359         emit Transfer(from, address(0), tokenId);
1360         _afterTokenTransfers(from, address(0), tokenId, 1);
1361 
1362         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1363         unchecked {
1364             _burnCounter++;
1365         }
1366     }
1367 
1368     // =============================================================
1369     //                     EXTRA DATA OPERATIONS
1370     // =============================================================
1371 
1372     /**
1373      * @dev Directly sets the extra data for the ownership data `index`.
1374      */
1375     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1376         uint256 packed = _packedOwnerships[index];
1377         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1378         uint256 extraDataCasted;
1379         // Cast `extraData` with assembly to avoid redundant masking.
1380         assembly {
1381             extraDataCasted := extraData
1382         }
1383         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1384         _packedOwnerships[index] = packed;
1385     }
1386 
1387     /**
1388      * @dev Called during each token transfer to set the 24bit `extraData` field.
1389      * Intended to be overridden by the cosumer contract.
1390      *
1391      * `previousExtraData` - the value of `extraData` before transfer.
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` will be minted for `to`.
1398      * - When `to` is zero, `tokenId` will be burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _extraData(
1402         address from,
1403         address to,
1404         uint24 previousExtraData
1405     ) internal view virtual returns (uint24) {}
1406 
1407     /**
1408      * @dev Returns the next extra data for the packed ownership data.
1409      * The returned result is shifted into position.
1410      */
1411     function _nextExtraData(
1412         address from,
1413         address to,
1414         uint256 prevOwnershipPacked
1415     ) private view returns (uint256) {
1416         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1417         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1418     }
1419 
1420     // =============================================================
1421     //                       OTHER OPERATIONS
1422     // =============================================================
1423 
1424     /**
1425      * @dev Returns the message sender (defaults to `msg.sender`).
1426      *
1427      * If you are writing GSN compatible contracts, you need to override this function.
1428      */
1429     function _msgSenderERC721A() internal view virtual returns (address) {
1430         return msg.sender;
1431     }
1432 
1433     /**
1434      * @dev Converts a uint256 to its ASCII string decimal representation.
1435      */
1436     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1437         assembly {
1438             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1439             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1440             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1441             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1442             let m := add(mload(0x40), 0xa0)
1443             // Update the free memory pointer to allocate.
1444             mstore(0x40, m)
1445             // Assign the `str` to the end.
1446             str := sub(m, 0x20)
1447             // Zeroize the slot after the string.
1448             mstore(str, 0)
1449 
1450             // Cache the end of the memory to calculate the length later.
1451             let end := str
1452 
1453             // We write the string from rightmost digit to leftmost digit.
1454             // The following is essentially a do-while loop that also handles the zero case.
1455             // prettier-ignore
1456             for { let temp := value } 1 {} {
1457                 str := sub(str, 1)
1458                 // Write the character to the pointer.
1459                 // The ASCII index of the '0' character is 48.
1460                 mstore8(str, add(48, mod(temp, 10)))
1461                 // Keep dividing `temp` until zero.
1462                 temp := div(temp, 10)
1463                 // prettier-ignore
1464                 if iszero(temp) { break }
1465             }
1466 
1467             let length := sub(end, str)
1468             // Move the pointer 32 bytes leftwards to make room for the length.
1469             str := sub(str, 0x20)
1470             // Store the length.
1471             mstore(str, length)
1472         }
1473     }
1474 }
1475 
1476 // File: @openzeppelin/contracts/utils/math/Math.sol
1477 
1478 
1479 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 /**
1484  * @dev Standard math utilities missing in the Solidity language.
1485  */
1486 library Math {
1487     enum Rounding {
1488         Down, // Toward negative infinity
1489         Up, // Toward infinity
1490         Zero // Toward zero
1491     }
1492 
1493     /**
1494      * @dev Returns the largest of two numbers.
1495      */
1496     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1497         return a > b ? a : b;
1498     }
1499 
1500     /**
1501      * @dev Returns the smallest of two numbers.
1502      */
1503     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1504         return a < b ? a : b;
1505     }
1506 
1507     /**
1508      * @dev Returns the average of two numbers. The result is rounded towards
1509      * zero.
1510      */
1511     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1512         // (a + b) / 2 can overflow.
1513         return (a & b) + (a ^ b) / 2;
1514     }
1515 
1516     /**
1517      * @dev Returns the ceiling of the division of two numbers.
1518      *
1519      * This differs from standard division with `/` in that it rounds up instead
1520      * of rounding down.
1521      */
1522     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1523         // (a + b - 1) / b can overflow on addition, so we distribute.
1524         return a == 0 ? 0 : (a - 1) / b + 1;
1525     }
1526 
1527     /**
1528      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1529      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1530      * with further edits by Uniswap Labs also under MIT license.
1531      */
1532     function mulDiv(
1533         uint256 x,
1534         uint256 y,
1535         uint256 denominator
1536     ) internal pure returns (uint256 result) {
1537         unchecked {
1538             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1539             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1540             // variables such that product = prod1 * 2^256 + prod0.
1541             uint256 prod0; // Least significant 256 bits of the product
1542             uint256 prod1; // Most significant 256 bits of the product
1543             assembly {
1544                 let mm := mulmod(x, y, not(0))
1545                 prod0 := mul(x, y)
1546                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1547             }
1548 
1549             // Handle non-overflow cases, 256 by 256 division.
1550             if (prod1 == 0) {
1551                 return prod0 / denominator;
1552             }
1553 
1554             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1555             require(denominator > prod1);
1556 
1557             ///////////////////////////////////////////////
1558             // 512 by 256 division.
1559             ///////////////////////////////////////////////
1560 
1561             // Make division exact by subtracting the remainder from [prod1 prod0].
1562             uint256 remainder;
1563             assembly {
1564                 // Compute remainder using mulmod.
1565                 remainder := mulmod(x, y, denominator)
1566 
1567                 // Subtract 256 bit number from 512 bit number.
1568                 prod1 := sub(prod1, gt(remainder, prod0))
1569                 prod0 := sub(prod0, remainder)
1570             }
1571 
1572             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1573             // See https://cs.stackexchange.com/q/138556/92363.
1574 
1575             // Does not overflow because the denominator cannot be zero at this stage in the function.
1576             uint256 twos = denominator & (~denominator + 1);
1577             assembly {
1578                 // Divide denominator by twos.
1579                 denominator := div(denominator, twos)
1580 
1581                 // Divide [prod1 prod0] by twos.
1582                 prod0 := div(prod0, twos)
1583 
1584                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1585                 twos := add(div(sub(0, twos), twos), 1)
1586             }
1587 
1588             // Shift in bits from prod1 into prod0.
1589             prod0 |= prod1 * twos;
1590 
1591             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1592             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1593             // four bits. That is, denominator * inv = 1 mod 2^4.
1594             uint256 inverse = (3 * denominator) ^ 2;
1595 
1596             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1597             // in modular arithmetic, doubling the correct bits in each step.
1598             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1599             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1600             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1601             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1602             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1603             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1604 
1605             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1606             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1607             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1608             // is no longer required.
1609             result = prod0 * inverse;
1610             return result;
1611         }
1612     }
1613 
1614     /**
1615      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1616      */
1617     function mulDiv(
1618         uint256 x,
1619         uint256 y,
1620         uint256 denominator,
1621         Rounding rounding
1622     ) internal pure returns (uint256) {
1623         uint256 result = mulDiv(x, y, denominator);
1624         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1625             result += 1;
1626         }
1627         return result;
1628     }
1629 
1630     /**
1631      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1632      *
1633      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1634      */
1635     function sqrt(uint256 a) internal pure returns (uint256) {
1636         if (a == 0) {
1637             return 0;
1638         }
1639 
1640         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1641         //
1642         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1643         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1644         //
1645         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1646         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1647         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1648         //
1649         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1650         uint256 result = 1 << (log2(a) >> 1);
1651 
1652         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1653         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1654         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1655         // into the expected uint128 result.
1656         unchecked {
1657             result = (result + a / result) >> 1;
1658             result = (result + a / result) >> 1;
1659             result = (result + a / result) >> 1;
1660             result = (result + a / result) >> 1;
1661             result = (result + a / result) >> 1;
1662             result = (result + a / result) >> 1;
1663             result = (result + a / result) >> 1;
1664             return min(result, a / result);
1665         }
1666     }
1667 
1668     /**
1669      * @notice Calculates sqrt(a), following the selected rounding direction.
1670      */
1671     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1672         unchecked {
1673             uint256 result = sqrt(a);
1674             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1675         }
1676     }
1677 
1678     /**
1679      * @dev Return the log in base 2, rounded down, of a positive value.
1680      * Returns 0 if given 0.
1681      */
1682     function log2(uint256 value) internal pure returns (uint256) {
1683         uint256 result = 0;
1684         unchecked {
1685             if (value >> 128 > 0) {
1686                 value >>= 128;
1687                 result += 128;
1688             }
1689             if (value >> 64 > 0) {
1690                 value >>= 64;
1691                 result += 64;
1692             }
1693             if (value >> 32 > 0) {
1694                 value >>= 32;
1695                 result += 32;
1696             }
1697             if (value >> 16 > 0) {
1698                 value >>= 16;
1699                 result += 16;
1700             }
1701             if (value >> 8 > 0) {
1702                 value >>= 8;
1703                 result += 8;
1704             }
1705             if (value >> 4 > 0) {
1706                 value >>= 4;
1707                 result += 4;
1708             }
1709             if (value >> 2 > 0) {
1710                 value >>= 2;
1711                 result += 2;
1712             }
1713             if (value >> 1 > 0) {
1714                 result += 1;
1715             }
1716         }
1717         return result;
1718     }
1719 
1720     /**
1721      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1722      * Returns 0 if given 0.
1723      */
1724     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1725         unchecked {
1726             uint256 result = log2(value);
1727             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1728         }
1729     }
1730 
1731     /**
1732      * @dev Return the log in base 10, rounded down, of a positive value.
1733      * Returns 0 if given 0.
1734      */
1735     function log10(uint256 value) internal pure returns (uint256) {
1736         uint256 result = 0;
1737         unchecked {
1738             if (value >= 10**64) {
1739                 value /= 10**64;
1740                 result += 64;
1741             }
1742             if (value >= 10**32) {
1743                 value /= 10**32;
1744                 result += 32;
1745             }
1746             if (value >= 10**16) {
1747                 value /= 10**16;
1748                 result += 16;
1749             }
1750             if (value >= 10**8) {
1751                 value /= 10**8;
1752                 result += 8;
1753             }
1754             if (value >= 10**4) {
1755                 value /= 10**4;
1756                 result += 4;
1757             }
1758             if (value >= 10**2) {
1759                 value /= 10**2;
1760                 result += 2;
1761             }
1762             if (value >= 10**1) {
1763                 result += 1;
1764             }
1765         }
1766         return result;
1767     }
1768 
1769     /**
1770      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1771      * Returns 0 if given 0.
1772      */
1773     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1774         unchecked {
1775             uint256 result = log10(value);
1776             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1777         }
1778     }
1779 
1780     /**
1781      * @dev Return the log in base 256, rounded down, of a positive value.
1782      * Returns 0 if given 0.
1783      *
1784      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1785      */
1786     function log256(uint256 value) internal pure returns (uint256) {
1787         uint256 result = 0;
1788         unchecked {
1789             if (value >> 128 > 0) {
1790                 value >>= 128;
1791                 result += 16;
1792             }
1793             if (value >> 64 > 0) {
1794                 value >>= 64;
1795                 result += 8;
1796             }
1797             if (value >> 32 > 0) {
1798                 value >>= 32;
1799                 result += 4;
1800             }
1801             if (value >> 16 > 0) {
1802                 value >>= 16;
1803                 result += 2;
1804             }
1805             if (value >> 8 > 0) {
1806                 result += 1;
1807             }
1808         }
1809         return result;
1810     }
1811 
1812     /**
1813      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1814      * Returns 0 if given 0.
1815      */
1816     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1817         unchecked {
1818             uint256 result = log256(value);
1819             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1820         }
1821     }
1822 }
1823 
1824 // File: @openzeppelin/contracts/utils/Strings.sol
1825 
1826 
1827 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1828 
1829 pragma solidity ^0.8.0;
1830 
1831 
1832 /**
1833  * @dev String operations.
1834  */
1835 library Strings {
1836     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1837     uint8 private constant _ADDRESS_LENGTH = 20;
1838 
1839     /**
1840      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1841      */
1842     function toString(uint256 value) internal pure returns (string memory) {
1843         unchecked {
1844             uint256 length = Math.log10(value) + 1;
1845             string memory buffer = new string(length);
1846             uint256 ptr;
1847             /// @solidity memory-safe-assembly
1848             assembly {
1849                 ptr := add(buffer, add(32, length))
1850             }
1851             while (true) {
1852                 ptr--;
1853                 /// @solidity memory-safe-assembly
1854                 assembly {
1855                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1856                 }
1857                 value /= 10;
1858                 if (value == 0) break;
1859             }
1860             return buffer;
1861         }
1862     }
1863 
1864     /**
1865      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1866      */
1867     function toHexString(uint256 value) internal pure returns (string memory) {
1868         unchecked {
1869             return toHexString(value, Math.log256(value) + 1);
1870         }
1871     }
1872 
1873     /**
1874      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1875      */
1876     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1877         bytes memory buffer = new bytes(2 * length + 2);
1878         buffer[0] = "0";
1879         buffer[1] = "x";
1880         for (uint256 i = 2 * length + 1; i > 1; --i) {
1881             buffer[i] = _SYMBOLS[value & 0xf];
1882             value >>= 4;
1883         }
1884         require(value == 0, "Strings: hex length insufficient");
1885         return string(buffer);
1886     }
1887 
1888     /**
1889      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1890      */
1891     function toHexString(address addr) internal pure returns (string memory) {
1892         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1893     }
1894 }
1895 
1896 // File: @openzeppelin/contracts/utils/Context.sol
1897 
1898 
1899 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1900 
1901 pragma solidity ^0.8.0;
1902 
1903 /**
1904  * @dev Provides information about the current execution context, including the
1905  * sender of the transaction and its data. While these are generally available
1906  * via msg.sender and msg.data, they should not be accessed in such a direct
1907  * manner, since when dealing with meta-transactions the account sending and
1908  * paying for execution may not be the actual sender (as far as an application
1909  * is concerned).
1910  *
1911  * This contract is only required for intermediate, library-like contracts.
1912  */
1913 abstract contract Context {
1914     function _msgSender() internal view virtual returns (address) {
1915         return msg.sender;
1916     }
1917 
1918     function _msgData() internal view virtual returns (bytes calldata) {
1919         return msg.data;
1920     }
1921 }
1922 
1923 // File: @openzeppelin/contracts/access/Ownable.sol
1924 
1925 
1926 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1927 
1928 pragma solidity ^0.8.0;
1929 
1930 
1931 /**
1932  * @dev Contract module which provides a basic access control mechanism, where
1933  * there is an account (an owner) that can be granted exclusive access to
1934  * specific functions.
1935  *
1936  * By default, the owner account will be the one that deploys the contract. This
1937  * can later be changed with {transferOwnership}.
1938  *
1939  * This module is used through inheritance. It will make available the modifier
1940  * `onlyOwner`, which can be applied to your functions to restrict their use to
1941  * the owner.
1942  */
1943 abstract contract Ownable is Context {
1944     address private _owner;
1945 
1946     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1947 
1948     /**
1949      * @dev Initializes the contract setting the deployer as the initial owner.
1950      */
1951     constructor() {
1952         _transferOwnership(_msgSender());
1953     }
1954 
1955     /**
1956      * @dev Throws if called by any account other than the owner.
1957      */
1958     modifier onlyOwner() {
1959         _checkOwner();
1960         _;
1961     }
1962 
1963     /**
1964      * @dev Returns the address of the current owner.
1965      */
1966     function owner() public view virtual returns (address) {
1967         return _owner;
1968     }
1969 
1970     /**
1971      * @dev Throws if the sender is not the owner.
1972      */
1973     function _checkOwner() internal view virtual {
1974         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1975     }
1976 
1977     /**
1978      * @dev Leaves the contract without owner. It will not be possible to call
1979      * `onlyOwner` functions anymore. Can only be called by the current owner.
1980      *
1981      * NOTE: Renouncing ownership will leave the contract without an owner,
1982      * thereby removing any functionality that is only available to the owner.
1983      */
1984     function renounceOwnership() public virtual onlyOwner {
1985         _transferOwnership(address(0));
1986     }
1987 
1988     /**
1989      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1990      * Can only be called by the current owner.
1991      */
1992     function transferOwnership(address newOwner) public virtual onlyOwner {
1993         require(newOwner != address(0), "Ownable: new owner is the zero address");
1994         _transferOwnership(newOwner);
1995     }
1996 
1997     /**
1998      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1999      * Internal function without access restriction.
2000      */
2001     function _transferOwnership(address newOwner) internal virtual {
2002         address oldOwner = _owner;
2003         _owner = newOwner;
2004         emit OwnershipTransferred(oldOwner, newOwner);
2005     }
2006 }
2007 
2008 // File: @openzeppelin/contracts/utils/Address.sol
2009 
2010 
2011 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2012 
2013 pragma solidity ^0.8.1;
2014 
2015 /**
2016  * @dev Collection of functions related to the address type
2017  */
2018 library Address {
2019     /**
2020      * @dev Returns true if `account` is a contract.
2021      *
2022      * [IMPORTANT]
2023      * ====
2024      * It is unsafe to assume that an address for which this function returns
2025      * false is an externally-owned account (EOA) and not a contract.
2026      *
2027      * Among others, `isContract` will return false for the following
2028      * types of addresses:
2029      *
2030      *  - an externally-owned account
2031      *  - a contract in construction
2032      *  - an address where a contract will be created
2033      *  - an address where a contract lived, but was destroyed
2034      * ====
2035      *
2036      * [IMPORTANT]
2037      * ====
2038      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2039      *
2040      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2041      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2042      * constructor.
2043      * ====
2044      */
2045     function isContract(address account) internal view returns (bool) {
2046         // This method relies on extcodesize/address.code.length, which returns 0
2047         // for contracts in construction, since the code is only stored at the end
2048         // of the constructor execution.
2049 
2050         return account.code.length > 0;
2051     }
2052 
2053     /**
2054      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2055      * `recipient`, forwarding all available gas and reverting on errors.
2056      *
2057      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2058      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2059      * imposed by `transfer`, making them unable to receive funds via
2060      * `transfer`. {sendValue} removes this limitation.
2061      *
2062      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2063      *
2064      * IMPORTANT: because control is transferred to `recipient`, care must be
2065      * taken to not create reentrancy vulnerabilities. Consider using
2066      * {ReentrancyGuard} or the
2067      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2068      */
2069     function sendValue(address payable recipient, uint256 amount) internal {
2070         require(address(this).balance >= amount, "Address: insufficient balance");
2071 
2072         (bool success, ) = recipient.call{value: amount}("");
2073         require(success, "Address: unable to send value, recipient may have reverted");
2074     }
2075 
2076     /**
2077      * @dev Performs a Solidity function call using a low level `call`. A
2078      * plain `call` is an unsafe replacement for a function call: use this
2079      * function instead.
2080      *
2081      * If `target` reverts with a revert reason, it is bubbled up by this
2082      * function (like regular Solidity function calls).
2083      *
2084      * Returns the raw returned data. To convert to the expected return value,
2085      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2086      *
2087      * Requirements:
2088      *
2089      * - `target` must be a contract.
2090      * - calling `target` with `data` must not revert.
2091      *
2092      * _Available since v3.1._
2093      */
2094     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2095         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2096     }
2097 
2098     /**
2099      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2100      * `errorMessage` as a fallback revert reason when `target` reverts.
2101      *
2102      * _Available since v3.1._
2103      */
2104     function functionCall(
2105         address target,
2106         bytes memory data,
2107         string memory errorMessage
2108     ) internal returns (bytes memory) {
2109         return functionCallWithValue(target, data, 0, errorMessage);
2110     }
2111 
2112     /**
2113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2114      * but also transferring `value` wei to `target`.
2115      *
2116      * Requirements:
2117      *
2118      * - the calling contract must have an ETH balance of at least `value`.
2119      * - the called Solidity function must be `payable`.
2120      *
2121      * _Available since v3.1._
2122      */
2123     function functionCallWithValue(
2124         address target,
2125         bytes memory data,
2126         uint256 value
2127     ) internal returns (bytes memory) {
2128         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2129     }
2130 
2131     /**
2132      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2133      * with `errorMessage` as a fallback revert reason when `target` reverts.
2134      *
2135      * _Available since v3.1._
2136      */
2137     function functionCallWithValue(
2138         address target,
2139         bytes memory data,
2140         uint256 value,
2141         string memory errorMessage
2142     ) internal returns (bytes memory) {
2143         require(address(this).balance >= value, "Address: insufficient balance for call");
2144         (bool success, bytes memory returndata) = target.call{value: value}(data);
2145         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2146     }
2147 
2148     /**
2149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2150      * but performing a static call.
2151      *
2152      * _Available since v3.3._
2153      */
2154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2155         return functionStaticCall(target, data, "Address: low-level static call failed");
2156     }
2157 
2158     /**
2159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2160      * but performing a static call.
2161      *
2162      * _Available since v3.3._
2163      */
2164     function functionStaticCall(
2165         address target,
2166         bytes memory data,
2167         string memory errorMessage
2168     ) internal view returns (bytes memory) {
2169         (bool success, bytes memory returndata) = target.staticcall(data);
2170         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2171     }
2172 
2173     /**
2174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2175      * but performing a delegate call.
2176      *
2177      * _Available since v3.4._
2178      */
2179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2181     }
2182 
2183     /**
2184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2185      * but performing a delegate call.
2186      *
2187      * _Available since v3.4._
2188      */
2189     function functionDelegateCall(
2190         address target,
2191         bytes memory data,
2192         string memory errorMessage
2193     ) internal returns (bytes memory) {
2194         (bool success, bytes memory returndata) = target.delegatecall(data);
2195         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2196     }
2197 
2198     /**
2199      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2200      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2201      *
2202      * _Available since v4.8._
2203      */
2204     function verifyCallResultFromTarget(
2205         address target,
2206         bool success,
2207         bytes memory returndata,
2208         string memory errorMessage
2209     ) internal view returns (bytes memory) {
2210         if (success) {
2211             if (returndata.length == 0) {
2212                 // only check isContract if the call was successful and the return data is empty
2213                 // otherwise we already know that it was a contract
2214                 require(isContract(target), "Address: call to non-contract");
2215             }
2216             return returndata;
2217         } else {
2218             _revert(returndata, errorMessage);
2219         }
2220     }
2221 
2222     /**
2223      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2224      * revert reason or using the provided one.
2225      *
2226      * _Available since v4.3._
2227      */
2228     function verifyCallResult(
2229         bool success,
2230         bytes memory returndata,
2231         string memory errorMessage
2232     ) internal pure returns (bytes memory) {
2233         if (success) {
2234             return returndata;
2235         } else {
2236             _revert(returndata, errorMessage);
2237         }
2238     }
2239 
2240     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2241         // Look for revert reason and bubble it up if present
2242         if (returndata.length > 0) {
2243             // The easiest way to bubble the revert reason is using memory via assembly
2244             /// @solidity memory-safe-assembly
2245             assembly {
2246                 let returndata_size := mload(returndata)
2247                 revert(add(32, returndata), returndata_size)
2248             }
2249         } else {
2250             revert(errorMessage);
2251         }
2252     }
2253 }
2254 
2255 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
2256 
2257 
2258 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
2259 
2260 pragma solidity ^0.8.0;
2261 
2262 /**
2263  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2264  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2265  *
2266  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2267  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2268  * need to send a transaction, and thus is not required to hold Ether at all.
2269  */
2270 interface IERC20Permit {
2271     /**
2272      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2273      * given ``owner``'s signed approval.
2274      *
2275      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2276      * ordering also apply here.
2277      *
2278      * Emits an {Approval} event.
2279      *
2280      * Requirements:
2281      *
2282      * - `spender` cannot be the zero address.
2283      * - `deadline` must be a timestamp in the future.
2284      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2285      * over the EIP712-formatted function arguments.
2286      * - the signature must use ``owner``'s current nonce (see {nonces}).
2287      *
2288      * For more information on the signature format, see the
2289      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2290      * section].
2291      */
2292     function permit(
2293         address owner,
2294         address spender,
2295         uint256 value,
2296         uint256 deadline,
2297         uint8 v,
2298         bytes32 r,
2299         bytes32 s
2300     ) external;
2301 
2302     /**
2303      * @dev Returns the current nonce for `owner`. This value must be
2304      * included whenever a signature is generated for {permit}.
2305      *
2306      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2307      * prevents a signature from being used multiple times.
2308      */
2309     function nonces(address owner) external view returns (uint256);
2310 
2311     /**
2312      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2313      */
2314     // solhint-disable-next-line func-name-mixedcase
2315     function DOMAIN_SEPARATOR() external view returns (bytes32);
2316 }
2317 
2318 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2319 
2320 
2321 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2322 
2323 pragma solidity ^0.8.0;
2324 
2325 /**
2326  * @dev Interface of the ERC20 standard as defined in the EIP.
2327  */
2328 interface IERC20 {
2329     /**
2330      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2331      * another (`to`).
2332      *
2333      * Note that `value` may be zero.
2334      */
2335     event Transfer(address indexed from, address indexed to, uint256 value);
2336 
2337     /**
2338      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2339      * a call to {approve}. `value` is the new allowance.
2340      */
2341     event Approval(address indexed owner, address indexed spender, uint256 value);
2342 
2343     /**
2344      * @dev Returns the amount of tokens in existence.
2345      */
2346     function totalSupply() external view returns (uint256);
2347 
2348     /**
2349      * @dev Returns the amount of tokens owned by `account`.
2350      */
2351     function balanceOf(address account) external view returns (uint256);
2352 
2353     /**
2354      * @dev Moves `amount` tokens from the caller's account to `to`.
2355      *
2356      * Returns a boolean value indicating whether the operation succeeded.
2357      *
2358      * Emits a {Transfer} event.
2359      */
2360     function transfer(address to, uint256 amount) external returns (bool);
2361 
2362     /**
2363      * @dev Returns the remaining number of tokens that `spender` will be
2364      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2365      * zero by default.
2366      *
2367      * This value changes when {approve} or {transferFrom} are called.
2368      */
2369     function allowance(address owner, address spender) external view returns (uint256);
2370 
2371     /**
2372      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2373      *
2374      * Returns a boolean value indicating whether the operation succeeded.
2375      *
2376      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2377      * that someone may use both the old and the new allowance by unfortunate
2378      * transaction ordering. One possible solution to mitigate this race
2379      * condition is to first reduce the spender's allowance to 0 and set the
2380      * desired value afterwards:
2381      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2382      *
2383      * Emits an {Approval} event.
2384      */
2385     function approve(address spender, uint256 amount) external returns (bool);
2386 
2387     /**
2388      * @dev Moves `amount` tokens from `from` to `to` using the
2389      * allowance mechanism. `amount` is then deducted from the caller's
2390      * allowance.
2391      *
2392      * Returns a boolean value indicating whether the operation succeeded.
2393      *
2394      * Emits a {Transfer} event.
2395      */
2396     function transferFrom(
2397         address from,
2398         address to,
2399         uint256 amount
2400     ) external returns (bool);
2401 }
2402 
2403 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2404 
2405 
2406 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2407 
2408 pragma solidity ^0.8.0;
2409 
2410 
2411 
2412 
2413 /**
2414  * @title SafeERC20
2415  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2416  * contract returns false). Tokens that return no value (and instead revert or
2417  * throw on failure) are also supported, non-reverting calls are assumed to be
2418  * successful.
2419  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2420  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2421  */
2422 library SafeERC20 {
2423     using Address for address;
2424 
2425     function safeTransfer(
2426         IERC20 token,
2427         address to,
2428         uint256 value
2429     ) internal {
2430         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2431     }
2432 
2433     function safeTransferFrom(
2434         IERC20 token,
2435         address from,
2436         address to,
2437         uint256 value
2438     ) internal {
2439         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2440     }
2441 
2442     /**
2443      * @dev Deprecated. This function has issues similar to the ones found in
2444      * {IERC20-approve}, and its usage is discouraged.
2445      *
2446      * Whenever possible, use {safeIncreaseAllowance} and
2447      * {safeDecreaseAllowance} instead.
2448      */
2449     function safeApprove(
2450         IERC20 token,
2451         address spender,
2452         uint256 value
2453     ) internal {
2454         // safeApprove should only be called when setting an initial allowance,
2455         // or when resetting it to zero. To increase and decrease it, use
2456         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2457         require(
2458             (value == 0) || (token.allowance(address(this), spender) == 0),
2459             "SafeERC20: approve from non-zero to non-zero allowance"
2460         );
2461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2462     }
2463 
2464     function safeIncreaseAllowance(
2465         IERC20 token,
2466         address spender,
2467         uint256 value
2468     ) internal {
2469         uint256 newAllowance = token.allowance(address(this), spender) + value;
2470         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2471     }
2472 
2473     function safeDecreaseAllowance(
2474         IERC20 token,
2475         address spender,
2476         uint256 value
2477     ) internal {
2478         unchecked {
2479             uint256 oldAllowance = token.allowance(address(this), spender);
2480             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2481             uint256 newAllowance = oldAllowance - value;
2482             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2483         }
2484     }
2485 
2486     function safePermit(
2487         IERC20Permit token,
2488         address owner,
2489         address spender,
2490         uint256 value,
2491         uint256 deadline,
2492         uint8 v,
2493         bytes32 r,
2494         bytes32 s
2495     ) internal {
2496         uint256 nonceBefore = token.nonces(owner);
2497         token.permit(owner, spender, value, deadline, v, r, s);
2498         uint256 nonceAfter = token.nonces(owner);
2499         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2500     }
2501 
2502     /**
2503      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2504      * on the return value: the return value is optional (but if data is returned, it must not be false).
2505      * @param token The token targeted by the call.
2506      * @param data The call data (encoded using abi.encode or one of its variants).
2507      */
2508     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2509         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2510         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2511         // the target address contains contract code and also asserts for success in the low-level call.
2512 
2513         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2514         if (returndata.length > 0) {
2515             // Return data is optional
2516             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2517         }
2518     }
2519 }
2520 
2521 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2522 
2523 
2524 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2525 
2526 pragma solidity ^0.8.0;
2527 
2528 
2529 
2530 
2531 /**
2532  * @title PaymentSplitter
2533  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2534  * that the Ether will be split in this way, since it is handled transparently by the contract.
2535  *
2536  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2537  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2538  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2539  * time of contract deployment and can't be updated thereafter.
2540  *
2541  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2542  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2543  * function.
2544  *
2545  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2546  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2547  * to run tests before sending real value to this contract.
2548  */
2549 contract PaymentSplitter is Context {
2550     event PayeeAdded(address account, uint256 shares);
2551     event PaymentReleased(address to, uint256 amount);
2552     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2553     event PaymentReceived(address from, uint256 amount);
2554 
2555     uint256 private _totalShares;
2556     uint256 private _totalReleased;
2557 
2558     mapping(address => uint256) private _shares;
2559     mapping(address => uint256) private _released;
2560     address[] private _payees;
2561 
2562     mapping(IERC20 => uint256) private _erc20TotalReleased;
2563     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2564 
2565     /**
2566      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2567      * the matching position in the `shares` array.
2568      *
2569      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2570      * duplicates in `payees`.
2571      */
2572     constructor(address[] memory payees, uint256[] memory shares_) payable {
2573         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2574         require(payees.length > 0, "PaymentSplitter: no payees");
2575 
2576         for (uint256 i = 0; i < payees.length; i++) {
2577             _addPayee(payees[i], shares_[i]);
2578         }
2579     }
2580 
2581     /**
2582      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2583      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2584      * reliability of the events, and not the actual splitting of Ether.
2585      *
2586      * To learn more about this see the Solidity documentation for
2587      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2588      * functions].
2589      */
2590     receive() external payable virtual {
2591         emit PaymentReceived(_msgSender(), msg.value);
2592     }
2593 
2594     /**
2595      * @dev Getter for the total shares held by payees.
2596      */
2597     function totalShares() public view returns (uint256) {
2598         return _totalShares;
2599     }
2600 
2601     /**
2602      * @dev Getter for the total amount of Ether already released.
2603      */
2604     function totalReleased() public view returns (uint256) {
2605         return _totalReleased;
2606     }
2607 
2608     /**
2609      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2610      * contract.
2611      */
2612     function totalReleased(IERC20 token) public view returns (uint256) {
2613         return _erc20TotalReleased[token];
2614     }
2615 
2616     /**
2617      * @dev Getter for the amount of shares held by an account.
2618      */
2619     function shares(address account) public view returns (uint256) {
2620         return _shares[account];
2621     }
2622 
2623     /**
2624      * @dev Getter for the amount of Ether already released to a payee.
2625      */
2626     function released(address account) public view returns (uint256) {
2627         return _released[account];
2628     }
2629 
2630     /**
2631      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2632      * IERC20 contract.
2633      */
2634     function released(IERC20 token, address account) public view returns (uint256) {
2635         return _erc20Released[token][account];
2636     }
2637 
2638     /**
2639      * @dev Getter for the address of the payee number `index`.
2640      */
2641     function payee(uint256 index) public view returns (address) {
2642         return _payees[index];
2643     }
2644 
2645     /**
2646      * @dev Getter for the amount of payee's releasable Ether.
2647      */
2648     function releasable(address account) public view returns (uint256) {
2649         uint256 totalReceived = address(this).balance + totalReleased();
2650         return _pendingPayment(account, totalReceived, released(account));
2651     }
2652 
2653     /**
2654      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2655      * IERC20 contract.
2656      */
2657     function releasable(IERC20 token, address account) public view returns (uint256) {
2658         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2659         return _pendingPayment(account, totalReceived, released(token, account));
2660     }
2661 
2662     /**
2663      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2664      * total shares and their previous withdrawals.
2665      */
2666     function release(address payable account) public virtual {
2667         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2668 
2669         uint256 payment = releasable(account);
2670 
2671         require(payment != 0, "PaymentSplitter: account is not due payment");
2672 
2673         // _totalReleased is the sum of all values in _released.
2674         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2675         _totalReleased += payment;
2676         unchecked {
2677             _released[account] += payment;
2678         }
2679 
2680         Address.sendValue(account, payment);
2681         emit PaymentReleased(account, payment);
2682     }
2683 
2684     /**
2685      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2686      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2687      * contract.
2688      */
2689     function release(IERC20 token, address account) public virtual {
2690         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2691 
2692         uint256 payment = releasable(token, account);
2693 
2694         require(payment != 0, "PaymentSplitter: account is not due payment");
2695 
2696         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2697         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2698         // cannot overflow.
2699         _erc20TotalReleased[token] += payment;
2700         unchecked {
2701             _erc20Released[token][account] += payment;
2702         }
2703 
2704         SafeERC20.safeTransfer(token, account, payment);
2705         emit ERC20PaymentReleased(token, account, payment);
2706     }
2707 
2708     /**
2709      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2710      * already released amounts.
2711      */
2712     function _pendingPayment(
2713         address account,
2714         uint256 totalReceived,
2715         uint256 alreadyReleased
2716     ) private view returns (uint256) {
2717         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2718     }
2719 
2720     /**
2721      * @dev Add a new payee to the contract.
2722      * @param account The address of the payee to add.
2723      * @param shares_ The number of shares owned by the payee.
2724      */
2725     function _addPayee(address account, uint256 shares_) private {
2726         require(account != address(0), "PaymentSplitter: account is the zero address");
2727         require(shares_ > 0, "PaymentSplitter: shares are 0");
2728         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2729 
2730         _payees.push(account);
2731         _shares[account] = shares_;
2732         _totalShares = _totalShares + shares_;
2733         emit PayeeAdded(account, shares_);
2734     }
2735 }
2736 
2737 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2738 
2739 
2740 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2741 
2742 pragma solidity ^0.8.0;
2743 
2744 /**
2745  * @dev Contract module that helps prevent reentrant calls to a function.
2746  *
2747  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2748  * available, which can be applied to functions to make sure there are no nested
2749  * (reentrant) calls to them.
2750  *
2751  * Note that because there is a single `nonReentrant` guard, functions marked as
2752  * `nonReentrant` may not call one another. This can be worked around by making
2753  * those functions `private`, and then adding `external` `nonReentrant` entry
2754  * points to them.
2755  *
2756  * TIP: If you would like to learn more about reentrancy and alternative ways
2757  * to protect against it, check out our blog post
2758  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2759  */
2760 abstract contract ReentrancyGuard {
2761     // Booleans are more expensive than uint256 or any type that takes up a full
2762     // word because each write operation emits an extra SLOAD to first read the
2763     // slot's contents, replace the bits taken up by the boolean, and then write
2764     // back. This is the compiler's defense against contract upgrades and
2765     // pointer aliasing, and it cannot be disabled.
2766 
2767     // The values being non-zero value makes deployment a bit more expensive,
2768     // but in exchange the refund on every call to nonReentrant will be lower in
2769     // amount. Since refunds are capped to a percentage of the total
2770     // transaction's gas, it is best to keep them low in cases like this one, to
2771     // increase the likelihood of the full refund coming into effect.
2772     uint256 private constant _NOT_ENTERED = 1;
2773     uint256 private constant _ENTERED = 2;
2774 
2775     uint256 private _status;
2776 
2777     constructor() {
2778         _status = _NOT_ENTERED;
2779     }
2780 
2781     /**
2782      * @dev Prevents a contract from calling itself, directly or indirectly.
2783      * Calling a `nonReentrant` function from another `nonReentrant`
2784      * function is not supported. It is possible to prevent this from happening
2785      * by making the `nonReentrant` function external, and making it call a
2786      * `private` function that does the actual work.
2787      */
2788     modifier nonReentrant() {
2789         _nonReentrantBefore();
2790         _;
2791         _nonReentrantAfter();
2792     }
2793 
2794     function _nonReentrantBefore() private {
2795         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2796         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2797 
2798         // Any calls to nonReentrant after this point will fail
2799         _status = _ENTERED;
2800     }
2801 
2802     function _nonReentrantAfter() private {
2803         // By storing the original value once again, a refund is triggered (see
2804         // https://eips.ethereum.org/EIPS/eip-2200)
2805         _status = _NOT_ENTERED;
2806     }
2807 }
2808 
2809 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2810 
2811 
2812 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2813 
2814 pragma solidity ^0.8.0;
2815 
2816 /**
2817  * @dev These functions deal with verification of Merkle Tree proofs.
2818  *
2819  * The tree and the proofs can be generated using our
2820  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2821  * You will find a quickstart guide in the readme.
2822  *
2823  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2824  * hashing, or use a hash function other than keccak256 for hashing leaves.
2825  * This is because the concatenation of a sorted pair of internal nodes in
2826  * the merkle tree could be reinterpreted as a leaf value.
2827  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2828  * against this attack out of the box.
2829  */
2830 library MerkleProof {
2831     /**
2832      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2833      * defined by `root`. For this, a `proof` must be provided, containing
2834      * sibling hashes on the branch from the leaf to the root of the tree. Each
2835      * pair of leaves and each pair of pre-images are assumed to be sorted.
2836      */
2837     function verify(
2838         bytes32[] memory proof,
2839         bytes32 root,
2840         bytes32 leaf
2841     ) internal pure returns (bool) {
2842         return processProof(proof, leaf) == root;
2843     }
2844 
2845     /**
2846      * @dev Calldata version of {verify}
2847      *
2848      * _Available since v4.7._
2849      */
2850     function verifyCalldata(
2851         bytes32[] calldata proof,
2852         bytes32 root,
2853         bytes32 leaf
2854     ) internal pure returns (bool) {
2855         return processProofCalldata(proof, leaf) == root;
2856     }
2857 
2858     /**
2859      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2860      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2861      * hash matches the root of the tree. When processing the proof, the pairs
2862      * of leafs & pre-images are assumed to be sorted.
2863      *
2864      * _Available since v4.4._
2865      */
2866     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2867         bytes32 computedHash = leaf;
2868         for (uint256 i = 0; i < proof.length; i++) {
2869             computedHash = _hashPair(computedHash, proof[i]);
2870         }
2871         return computedHash;
2872     }
2873 
2874     /**
2875      * @dev Calldata version of {processProof}
2876      *
2877      * _Available since v4.7._
2878      */
2879     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2880         bytes32 computedHash = leaf;
2881         for (uint256 i = 0; i < proof.length; i++) {
2882             computedHash = _hashPair(computedHash, proof[i]);
2883         }
2884         return computedHash;
2885     }
2886 
2887     /**
2888      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2889      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2890      *
2891      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2892      *
2893      * _Available since v4.7._
2894      */
2895     function multiProofVerify(
2896         bytes32[] memory proof,
2897         bool[] memory proofFlags,
2898         bytes32 root,
2899         bytes32[] memory leaves
2900     ) internal pure returns (bool) {
2901         return processMultiProof(proof, proofFlags, leaves) == root;
2902     }
2903 
2904     /**
2905      * @dev Calldata version of {multiProofVerify}
2906      *
2907      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2908      *
2909      * _Available since v4.7._
2910      */
2911     function multiProofVerifyCalldata(
2912         bytes32[] calldata proof,
2913         bool[] calldata proofFlags,
2914         bytes32 root,
2915         bytes32[] memory leaves
2916     ) internal pure returns (bool) {
2917         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2918     }
2919 
2920     /**
2921      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2922      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2923      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2924      * respectively.
2925      *
2926      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2927      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2928      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2929      *
2930      * _Available since v4.7._
2931      */
2932     function processMultiProof(
2933         bytes32[] memory proof,
2934         bool[] memory proofFlags,
2935         bytes32[] memory leaves
2936     ) internal pure returns (bytes32 merkleRoot) {
2937         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2938         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2939         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2940         // the merkle tree.
2941         uint256 leavesLen = leaves.length;
2942         uint256 totalHashes = proofFlags.length;
2943 
2944         // Check proof validity.
2945         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2946 
2947         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2948         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2949         bytes32[] memory hashes = new bytes32[](totalHashes);
2950         uint256 leafPos = 0;
2951         uint256 hashPos = 0;
2952         uint256 proofPos = 0;
2953         // At each step, we compute the next hash using two values:
2954         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2955         //   get the next hash.
2956         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2957         //   `proof` array.
2958         for (uint256 i = 0; i < totalHashes; i++) {
2959             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2960             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2961             hashes[i] = _hashPair(a, b);
2962         }
2963 
2964         if (totalHashes > 0) {
2965             return hashes[totalHashes - 1];
2966         } else if (leavesLen > 0) {
2967             return leaves[0];
2968         } else {
2969             return proof[0];
2970         }
2971     }
2972 
2973     /**
2974      * @dev Calldata version of {processMultiProof}.
2975      *
2976      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2977      *
2978      * _Available since v4.7._
2979      */
2980     function processMultiProofCalldata(
2981         bytes32[] calldata proof,
2982         bool[] calldata proofFlags,
2983         bytes32[] memory leaves
2984     ) internal pure returns (bytes32 merkleRoot) {
2985         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2986         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2987         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2988         // the merkle tree.
2989         uint256 leavesLen = leaves.length;
2990         uint256 totalHashes = proofFlags.length;
2991 
2992         // Check proof validity.
2993         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2994 
2995         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2996         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2997         bytes32[] memory hashes = new bytes32[](totalHashes);
2998         uint256 leafPos = 0;
2999         uint256 hashPos = 0;
3000         uint256 proofPos = 0;
3001         // At each step, we compute the next hash using two values:
3002         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
3003         //   get the next hash.
3004         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
3005         //   `proof` array.
3006         for (uint256 i = 0; i < totalHashes; i++) {
3007             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
3008             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
3009             hashes[i] = _hashPair(a, b);
3010         }
3011 
3012         if (totalHashes > 0) {
3013             return hashes[totalHashes - 1];
3014         } else if (leavesLen > 0) {
3015             return leaves[0];
3016         } else {
3017             return proof[0];
3018         }
3019     }
3020 
3021     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
3022         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
3023     }
3024 
3025     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
3026         /// @solidity memory-safe-assembly
3027         assembly {
3028             mstore(0x00, a)
3029             mstore(0x20, b)
3030             value := keccak256(0x00, 0x40)
3031         }
3032     }
3033 }
3034 
3035 // File: contracts/BrainlessSpikes.sol
3036 
3037 pragma solidity ^0.8.13;
3038 
3039 contract SPK is Ownable, ERC721A, PaymentSplitter, ReentrancyGuard, OperatorFilterer {
3040 
3041     using Strings for uint;
3042 
3043     string private baseURI;
3044     string public hiddenURI;
3045 
3046     uint256 public maxSupply = 2600;
3047     uint256 public maxMintPerTx = 3;
3048     uint256 public nftPerAddressLimit = 3;
3049 
3050     uint256 public wlprice = 0.069 ether;
3051     uint256 public pubprice = 0.0969 ether;
3052 
3053     bool public paused = true;
3054     bool public revealed = false;
3055 
3056     bool public onlyWhitelisted = true;
3057     bool public onlyPublic = false;
3058 
3059     address private royaltyReceiver;
3060     uint96 private royaltyFeesInBeeps = 700;
3061 
3062     bytes32 public merkleRoot;
3063 
3064     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
3065 
3066     mapping(address => uint256) public addressMintedBalance;
3067 
3068     uint private teamLength;
3069 
3070     constructor(
3071         address[] memory _team,
3072         uint[] memory _teamShares,
3073         bytes32 _merkleRoot, 
3074         string memory _baseURI,
3075         string memory _hiddenURI
3076     ) ERC721A ("Brainless Spikes", "SPK")
3077         PaymentSplitter(_team, _teamShares)
3078         OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), false)
3079     {
3080         merkleRoot = _merkleRoot;
3081         baseURI = _baseURI;
3082         hiddenURI = _hiddenURI;
3083         teamLength = _team.length;
3084     }
3085 
3086     modifier callerIsUser() {
3087         require(tx.origin == msg.sender, "Cannot be called from another contract");
3088         _;
3089     }
3090 
3091     // ****** Mint ****** //
3092 
3093     function mint(uint256 _mintAmount, bytes32[] calldata _proof) external payable nonReentrant callerIsUser{
3094         require(!paused, "The contract is paused");
3095         uint256 supply = totalSupply();
3096         require(_mintAmount > 0, "You need to mint at least 1 NFT");
3097         require(supply + _mintAmount <= maxSupply, "Max supply exceeded!");
3098         require(_mintAmount <= maxMintPerTx, "Max mint amount per session exceeded");
3099         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
3100         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
3101         
3102         if(onlyWhitelisted == true) {
3103             uint256 price = wlprice;
3104             require(isWhiteListed(msg.sender, _proof), "You are not whitelisted");
3105             require(msg.value >= price * _mintAmount, "You don't have enought funds");
3106             for (uint256 i = 1; i <= _mintAmount; i++) {
3107                 addressMintedBalance[msg.sender]++;
3108             }
3109             _mint(msg.sender, _mintAmount);
3110         }
3111         
3112         if(onlyPublic == true){
3113             uint256 price = pubprice;
3114             require(msg.value >= price * _mintAmount, "You don't have enought funds");
3115             for (uint256 i = 1; i <= _mintAmount; i++) {
3116                 addressMintedBalance[msg.sender]++;
3117             }
3118             _mint(msg.sender, _mintAmount);
3119         }
3120         
3121     }
3122 
3123     // ****** Miscellaneous ****** //
3124 
3125     function setMaxSupply(uint256 _limit) public onlyOwner {
3126         maxSupply = _limit;
3127     }
3128 
3129     function setmaxMintPerTx(uint256 _limit) public onlyOwner {
3130         maxMintPerTx = _limit;
3131     }
3132 
3133     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
3134         nftPerAddressLimit = _limit;
3135     }
3136 
3137     function setWLPrice(uint256 _limit) public onlyOwner {
3138         wlprice = _limit;
3139     }
3140 
3141     function setPubPrice(uint256 _limit) public onlyOwner {
3142         pubprice = _limit;
3143     }
3144 
3145     function setOnlyWhitelisted(bool _state) public onlyOwner {
3146         onlyWhitelisted = _state;
3147     }
3148 
3149     function setOnlyPublic(bool _state) public onlyOwner {
3150         onlyPublic = _state;
3151     }
3152 
3153     function setRevealed(bool _state) external onlyOwner {
3154         revealed = _state;
3155     }
3156 
3157     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
3158         uint256 _balance = balanceOf(address_);
3159         uint256[] memory _tokens = new uint256[] (_balance);
3160         uint256 _index;
3161         uint256 _loopThrough = totalSupply();
3162         for (uint256 i = 0; i < _loopThrough; i++) {
3163             bool _exists = _exists(i);
3164             if (_exists) {
3165                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
3166             }
3167             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
3168         }
3169         return _tokens;
3170     }
3171 
3172     function _startTokenId() internal view virtual override returns (uint256) {
3173         return 1;
3174     }
3175 
3176     function setPaused(bool _state) external onlyOwner {
3177         paused = _state;
3178     }
3179 
3180     function setBaseUri(string memory _baseURI) external onlyOwner {
3181         baseURI = _baseURI;
3182     }
3183 
3184     function setHiddenMetadataUri(string memory _hiddenURI) external onlyOwner {
3185         hiddenURI = _hiddenURI;
3186     }
3187 
3188     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3189         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3190 
3191         if (revealed == false) {
3192             return hiddenURI;
3193         } 
3194 
3195         string memory currentBaseURI = baseURI;
3196 
3197         return bytes(currentBaseURI).length > 0
3198         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
3199         : '';
3200     }
3201 
3202     // ****** Whitelist ****** //
3203 
3204     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3205         merkleRoot = _merkleRoot;
3206     }
3207 
3208     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
3209         return _verify(leaf(_account), _proof);
3210     }
3211 
3212     function leaf(address _account) internal pure returns(bytes32) {
3213         return keccak256(abi.encodePacked(_account));
3214     }
3215 
3216     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
3217         return MerkleProof.verify(_proof, merkleRoot, _leaf);
3218     }
3219 
3220     // ****** Giveaway ****** //
3221 
3222     function giveawayMint(uint256 _mintAmount, address _receiver) external onlyOwner{
3223         uint256 supply = totalSupply();
3224         require(_mintAmount > 0, "Giveaway need to be at least 1 NFT");
3225         require(supply + _mintAmount <= maxSupply, "Max supply exceeded!");
3226         _mint(_receiver, _mintAmount);
3227     }
3228 
3229     // ****** withdrawal ****** //
3230 
3231     function withdrawalAll() external onlyOwner nonReentrant {
3232         for(uint i = 0 ; i < teamLength ; i++) {
3233             release(payable(payee(i)));
3234         }
3235     }
3236 
3237     // ****** Implementing Royalty Interface (EIP2981) ****** //
3238     
3239     function supportsInterface(bytes4 interfaceId) 
3240         public 
3241         view 
3242         virtual 
3243         override (ERC721A)
3244         returns (bool) 
3245     {
3246         if (interfaceId == _INTERFACE_ID_ERC2981) {
3247             return true;
3248         }
3249         return super.supportsInterface(interfaceId);
3250     }
3251 
3252     // ****** RoyaltyInfo ****** //
3253     
3254     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
3255         external
3256         view
3257         returns (address receiver, uint256 royaltyAmount)
3258     {
3259         require(_exists(_tokenId), "ERC2981Royality: Cannot query non-existent token");
3260         return (royaltyReceiver, (_salePrice * royaltyFeesInBeeps) / 10000);
3261     }
3262 
3263     function calculatingRoyalties(uint256 _salePrice) view public returns (uint256) {
3264         return (_salePrice / 10000) * royaltyFeesInBeeps;
3265     }
3266 
3267     function setRoyalty(uint96 _royaltyFeesInBeeps) external onlyOwner {
3268         royaltyFeesInBeeps = _royaltyFeesInBeeps;
3269     }
3270 
3271     function setRoyaltyReceiver(address _receiver) external onlyOwner{
3272         royaltyReceiver = _receiver;
3273     }
3274 
3275     // ****** Operator Filter Registry ****** //
3276 
3277     function transferFrom(address from, address to, uint256 tokenId)
3278         public
3279         payable
3280         override
3281         onlyAllowedOperator(from)
3282     {
3283         super.transferFrom(from, to, tokenId);
3284     }
3285 
3286     function safeTransferFrom(address from, address to, uint256 tokenId)
3287         public
3288         payable
3289         override
3290         onlyAllowedOperator(from)
3291     {
3292         super.safeTransferFrom(from, to, tokenId);
3293     }
3294 
3295     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3296         public
3297         payable
3298         override
3299         onlyAllowedOperator(from)
3300     {
3301         super.safeTransferFrom(from, to, tokenId, data);
3302     }
3303 }