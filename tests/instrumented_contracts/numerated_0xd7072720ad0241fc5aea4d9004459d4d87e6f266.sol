1 // SPDX-License-Identifier: MIT
2 /* _____ _            ____                   _                   
3 |_   _| |__   ___  / ___|  __ _ _ __   ___| |_ _   _ _ __ ___  
4   | | | '_ \ / _ \ \___ \ / _` | '_ \ / __| __| | | | '_ ` _ \ 
5   | | | | | |  __/  ___) | (_| | | | | (__| |_| |_| | | | | | |
6   |_| |_| |_|\___| |____/ \__,_|_| |_|\___|\__|\__,_|_| |_| |_|
7 */
8 
9 
10 // File: contracts/IOperatorFilterRegistry.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
17     function register(address registrant) external;
18     function registerAndSubscribe(address registrant, address subscription) external;
19     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
20     function unregister(address addr) external;
21     function updateOperator(address registrant, address operator, bool filtered) external;
22     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
23     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
24     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
25     function subscribe(address registrant, address registrantToSubscribe) external;
26     function unsubscribe(address registrant, bool copyExistingEntries) external;
27     function subscriptionOf(address addr) external returns (address registrant);
28     function subscribers(address registrant) external returns (address[] memory);
29     function subscriberAt(address registrant, uint256 index) external returns (address);
30     function copyEntriesOf(address registrant, address registrantToCopy) external;
31     function isOperatorFiltered(address registrant, address operator) external returns (bool);
32     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
33     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
34     function filteredOperators(address addr) external returns (address[] memory);
35     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
36     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
37     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
38     function isRegistered(address addr) external returns (bool);
39     function codeHashOf(address addr) external returns (bytes32);
40 }
41 
42 // File: contracts/OperatorFilterer.sol
43 
44 
45 pragma solidity ^0.8.13;
46 
47 
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry constant operatorFilterRegistry =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(operatorFilterRegistry).code.length > 0) {
59             if (subscribe) {
60                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     operatorFilterRegistry.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Check registry code length to facilitate testing in environments without a deployed registry.
73         if (address(operatorFilterRegistry).code.length > 0) {
74             // Allow spending tokens from addresses with balance
75             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
76             // from an EOA.
77             if (from == msg.sender) {
78                 _;
79                 return;
80             }
81             if (
82                 !(
83                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
84                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
85                 )
86             ) {
87                 revert OperatorNotAllowed(msg.sender);
88             }
89         }
90         _;
91     }
92 }
93 
94 // File: contracts/DefaultOperatorFilterer.sol
95 
96 
97 pragma solidity ^0.8.13;
98 
99 
100 abstract contract DefaultOperatorFilterer is OperatorFilterer {
101     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
102 
103     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
104 }
105 
106 // File: contracts/IERC721A.sol
107 
108 
109 // ERC721A Contracts v4.2.3
110 // Creator: Chiru Labs
111 
112 pragma solidity ^0.8.4;
113 
114 /**
115  * @dev Interface of ERC721A.
116  */
117 interface IERC721A {
118     /**
119      * The caller must own the token or be an approved operator.
120      */
121     error ApprovalCallerNotOwnerNorApproved();
122 
123     /**
124      * The token does not exist.
125      */
126     error ApprovalQueryForNonexistentToken();
127 
128     /**
129      * Cannot query the balance for the zero address.
130      */
131     error BalanceQueryForZeroAddress();
132 
133     /**
134      * Cannot mint to the zero address.
135      */
136     error MintToZeroAddress();
137 
138     /**
139      * The quantity of tokens minted must be more than zero.
140      */
141     error MintZeroQuantity();
142 
143     /**
144      * The token does not exist.
145      */
146     error OwnerQueryForNonexistentToken();
147 
148     /**
149      * The caller must own the token or be an approved operator.
150      */
151     error TransferCallerNotOwnerNorApproved();
152 
153     /**
154      * The token must be owned by `from`.
155      */
156     error TransferFromIncorrectOwner();
157 
158     /**
159      * Cannot safely transfer to a contract that does not implement the
160      * ERC721Receiver interface.
161      */
162     error TransferToNonERC721ReceiverImplementer();
163 
164     /**
165      * Cannot transfer to the zero address.
166      */
167     error TransferToZeroAddress();
168 
169     /**
170      * The token does not exist.
171      */
172     error URIQueryForNonexistentToken();
173 
174     /**
175      * The `quantity` minted with ERC2309 exceeds the safety limit.
176      */
177     error MintERC2309QuantityExceedsLimit();
178 
179     /**
180      * The `extraData` cannot be set on an unintialized ownership slot.
181      */
182     error OwnershipNotInitializedForExtraData();
183 
184     // =============================================================
185     //                            STRUCTS
186     // =============================================================
187 
188     struct TokenOwnership {
189         // The address of the owner.
190         address addr;
191         // Stores the start time of ownership with minimal overhead for tokenomics.
192         uint64 startTimestamp;
193         // Whether the token has been burned.
194         bool burned;
195         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
196         uint24 extraData;
197     }
198 
199     // =============================================================
200     //                         TOKEN COUNTERS
201     // =============================================================
202 
203     /**
204      * @dev Returns the total number of tokens in existence.
205      * Burned tokens will reduce the count.
206      * To get the total number of tokens minted, please see {_totalMinted}.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     // =============================================================
211     //                            IERC165
212     // =============================================================
213 
214     /**
215      * @dev Returns true if this contract implements the interface defined by
216      * `interfaceId`. See the corresponding
217      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
218      * to learn more about how these ids are created.
219      *
220      * This function call must use less than 30000 gas.
221      */
222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 
224     // =============================================================
225     //                            IERC721
226     // =============================================================
227 
228     /**
229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
232 
233     /**
234      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
235      */
236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables or disables
240      * (`approved`) `operator` to manage all of its assets.
241      */
242     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
243 
244     /**
245      * @dev Returns the number of tokens in `owner`'s account.
246      */
247     function balanceOf(address owner) external view returns (uint256 balance);
248 
249     /**
250      * @dev Returns the owner of the `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function ownerOf(uint256 tokenId) external view returns (address owner);
257 
258     /**
259      * @dev Safely transfers `tokenId` token from `from` to `to`,
260      * checking first that contract recipients are aware of the ERC721 protocol
261      * to prevent tokens from being forever locked.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be have been allowed to move
269      * this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement
271      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId,
279         bytes calldata data
280     ) external payable;
281 
282     /**
283      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
284      */
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external payable;
290 
291     /**
292      * @dev Transfers `tokenId` from `from` to `to`.
293      *
294      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
295      * whenever possible.
296      *
297      * Requirements:
298      *
299      * - `from` cannot be the zero address.
300      * - `to` cannot be the zero address.
301      * - `tokenId` token must be owned by `from`.
302      * - If the caller is not `from`, it must be approved to move this token
303      * by either {approve} or {setApprovalForAll}.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external payable;
312 
313     /**
314      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
315      * The approval is cleared when the token is transferred.
316      *
317      * Only a single account can be approved at a time, so approving the
318      * zero address clears previous approvals.
319      *
320      * Requirements:
321      *
322      * - The caller must own the token or be an approved operator.
323      * - `tokenId` must exist.
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address to, uint256 tokenId) external payable;
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom}
332      * for any token owned by the caller.
333      *
334      * Requirements:
335      *
336      * - The `operator` cannot be the caller.
337      *
338      * Emits an {ApprovalForAll} event.
339      */
340     function setApprovalForAll(address operator, bool _approved) external;
341 
342     /**
343      * @dev Returns the account approved for `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function getApproved(uint256 tokenId) external view returns (address operator);
350 
351     /**
352      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
353      *
354      * See {setApprovalForAll}.
355      */
356     function isApprovedForAll(address owner, address operator) external view returns (bool);
357 
358     // =============================================================
359     //                        IERC721Metadata
360     // =============================================================
361 
362     /**
363      * @dev Returns the token collection name.
364      */
365     function name() external view returns (string memory);
366 
367     /**
368      * @dev Returns the token collection symbol.
369      */
370     function symbol() external view returns (string memory);
371 
372     /**
373      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
374      */
375     function tokenURI(uint256 tokenId) external view returns (string memory);
376 
377     // =============================================================
378     //                           IERC2309
379     // =============================================================
380 
381     /**
382      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
383      * (inclusive) is transferred from `from` to `to`, as defined in the
384      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
385      *
386      * See {_mintERC2309} for more details.
387      */
388     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
389 }
390 // File: contracts/ERC721A.sol
391 
392 
393 // ERC721A Contracts v4.2.3
394 // Creator: Chiru Labs
395 
396 pragma solidity ^0.8.4;
397 
398 
399 /**
400  * @dev Interface of ERC721 token receiver.
401  */
402 interface ERC721A__IERC721Receiver {
403     function onERC721Received(
404         address operator,
405         address from,
406         uint256 tokenId,
407         bytes calldata data
408     ) external returns (bytes4);
409 }
410 
411 /**
412  * @title ERC721A
413  *
414  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
415  * Non-Fungible Token Standard, including the Metadata extension.
416  * Optimized for lower gas during batch mints.
417  *
418  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
419  * starting from `_startTokenId()`.
420  *
421  * Assumptions:
422  *
423  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
424  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
425  */
426 contract ERC721A is IERC721A, DefaultOperatorFilterer {
427     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
428     struct TokenApprovalRef {
429         address value;
430     }
431 
432     // =============================================================
433     //                           CONSTANTS
434     // =============================================================
435 
436     // Mask of an entry in packed address data.
437     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
438 
439     // The bit position of `numberMinted` in packed address data.
440     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
441 
442     // The bit position of `numberBurned` in packed address data.
443     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
444 
445     // The bit position of `aux` in packed address data.
446     uint256 private constant _BITPOS_AUX = 192;
447 
448     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
449     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
450 
451     // The bit position of `startTimestamp` in packed ownership.
452     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
453 
454     // The bit mask of the `burned` bit in packed ownership.
455     uint256 private constant _BITMASK_BURNED = 1 << 224;
456 
457     // The bit position of the `nextInitialized` bit in packed ownership.
458     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
459 
460     // The bit mask of the `nextInitialized` bit in packed ownership.
461     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
462 
463     // The bit position of `extraData` in packed ownership.
464     uint256 private constant _BITPOS_EXTRA_DATA = 232;
465 
466     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
467     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
468 
469     // The mask of the lower 160 bits for addresses.
470     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
471 
472     // The maximum `quantity` that can be minted with {_mintERC2309}.
473     // This limit is to prevent overflows on the address data entries.
474     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
475     // is required to cause an overflow, which is unrealistic.
476     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
477 
478     // The `Transfer` event signature is given by:
479     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
480     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
481         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
482 
483     // =============================================================
484     //                            STORAGE
485     // =============================================================
486 
487     // The next token ID to be minted.
488     uint256 private _currentIndex;
489 
490     // The number of tokens burned.
491     uint256 private _burnCounter;
492 
493     // Token name
494     string private _name;
495 
496     // Token symbol
497     string private _symbol;
498 
499     // Mapping from token ID to ownership details
500     // An empty struct value does not necessarily mean the token is unowned.
501     // See {_packedOwnershipOf} implementation for details.
502     //
503     // Bits Layout:
504     // - [0..159]   `addr`
505     // - [160..223] `startTimestamp`
506     // - [224]      `burned`
507     // - [225]      `nextInitialized`
508     // - [232..255] `extraData`
509     mapping(uint256 => uint256) private _packedOwnerships;
510 
511     // Mapping owner address to address data.
512     //
513     // Bits Layout:
514     // - [0..63]    `balance`
515     // - [64..127]  `numberMinted`
516     // - [128..191] `numberBurned`
517     // - [192..255] `aux`
518     mapping(address => uint256) private _packedAddressData;
519 
520     // Mapping from token ID to approved address.
521     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
522 
523     // Mapping from owner to operator approvals
524     mapping(address => mapping(address => bool)) private _operatorApprovals;
525 
526     // =============================================================
527     //                          CONSTRUCTOR
528     // =============================================================
529 
530     constructor(string memory name_, string memory symbol_) {
531         _name = name_;
532         _symbol = symbol_;
533         _currentIndex = _startTokenId();
534     }
535 
536     // =============================================================
537     //                   TOKEN COUNTING OPERATIONS
538     // =============================================================
539 
540     /**
541      * @dev Returns the starting token ID.
542      * To change the starting token ID, please override this function.
543      */
544     function _startTokenId() internal view virtual returns (uint256) {
545         return 1;
546     }
547 
548     /**
549      * @dev Returns the next token ID to be minted.
550      */
551     function _nextTokenId() internal view virtual returns (uint256) {
552         return _currentIndex;
553     }
554 
555     /**
556      * @dev Returns the total number of tokens in existence.
557      * Burned tokens will reduce the count.
558      * To get the total number of tokens minted, please see {_totalMinted}.
559      */
560     function totalSupply() public view virtual override returns (uint256) {
561         // Counter underflow is impossible as _burnCounter cannot be incremented
562         // more than `_currentIndex - _startTokenId()` times.
563         unchecked {
564             return _currentIndex - _burnCounter - _startTokenId();
565         }
566     }
567 
568     /**
569      * @dev Returns the total amount of tokens minted in the contract.
570      */
571     function _totalMinted() internal view virtual returns (uint256) {
572         // Counter underflow is impossible as `_currentIndex` does not decrement,
573         // and it is initialized to `_startTokenId()`.
574         unchecked {
575             return _currentIndex - _startTokenId();
576         }
577     }
578 
579     /**
580      * @dev Returns the total number of tokens burned.
581      */
582     function _totalBurned() internal view virtual returns (uint256) {
583         return _burnCounter;
584     }
585 
586     // =============================================================
587     //                    ADDRESS DATA OPERATIONS
588     // =============================================================
589 
590     /**
591      * @dev Returns the number of tokens in `owner`'s account.
592      */
593     function balanceOf(address owner) public view virtual override returns (uint256) {
594         if (owner == address(0)) revert BalanceQueryForZeroAddress();
595         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
596     }
597 
598     /**
599      * Returns the number of tokens minted by `owner`.
600      */
601     function _numberMinted(address owner) internal view returns (uint256) {
602         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
603     }
604 
605     /**
606      * Returns the number of tokens burned by or on behalf of `owner`.
607      */
608     function _numberBurned(address owner) internal view returns (uint256) {
609         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     /**
613      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
614      */
615     function _getAux(address owner) internal view returns (uint64) {
616         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
617     }
618 
619     /**
620      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
621      * If there are multiple variables, please pack them into a uint64.
622      */
623     function _setAux(address owner, uint64 aux) internal virtual {
624         uint256 packed = _packedAddressData[owner];
625         uint256 auxCasted;
626         // Cast `aux` with assembly to avoid redundant masking.
627         assembly {
628             auxCasted := aux
629         }
630         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
631         _packedAddressData[owner] = packed;
632     }
633 
634     // =============================================================
635     //                            IERC165
636     // =============================================================
637 
638     /**
639      * @dev Returns true if this contract implements the interface defined by
640      * `interfaceId`. See the corresponding
641      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
642      * to learn more about how these ids are created.
643      *
644      * This function call must use less than 30000 gas.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647         // The interface IDs are constants representing the first 4 bytes
648         // of the XOR of all function selectors in the interface.
649         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
650         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
651         return
652             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
653             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
654             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
655     }
656 
657     // =============================================================
658     //                        IERC721Metadata
659     // =============================================================
660 
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() public view virtual override returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev Returns the token collection symbol.
670      */
671     function symbol() public view virtual override returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
677      */
678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
679         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
680 
681         string memory baseURI = _baseURI();
682         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
683     }
684 
685     /**
686      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
687      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
688      * by default, it can be overridden in child contracts.
689      */
690     function _baseURI() internal view virtual returns (string memory) {
691         return '';
692     }
693 
694     // =============================================================
695     //                     OWNERSHIPS OPERATIONS
696     // =============================================================
697 
698     /**
699      * @dev Returns the owner of the `tokenId` token.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must exist.
704      */
705     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
706         return address(uint160(_packedOwnershipOf(tokenId)));
707     }
708 
709     /**
710      * @dev Gas spent here starts off proportional to the maximum mint batch size.
711      * It gradually moves to O(1) as tokens get transferred around over time.
712      */
713     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
714         return _unpackedOwnership(_packedOwnershipOf(tokenId));
715     }
716 
717     /**
718      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
719      */
720     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
721         return _unpackedOwnership(_packedOwnerships[index]);
722     }
723 
724     /**
725      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
726      */
727     function _initializeOwnershipAt(uint256 index) internal virtual {
728         if (_packedOwnerships[index] == 0) {
729             _packedOwnerships[index] = _packedOwnershipOf(index);
730         }
731     }
732 
733     /**
734      * Returns the packed ownership data of `tokenId`.
735      */
736     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
737         uint256 curr = tokenId;
738 
739         unchecked {
740             if (_startTokenId() <= curr)
741                 if (curr < _currentIndex) {
742                     uint256 packed = _packedOwnerships[curr];
743                     // If not burned.
744                     if (packed & _BITMASK_BURNED == 0) {
745                         // Invariant:
746                         // There will always be an initialized ownership slot
747                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
748                         // before an unintialized ownership slot
749                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
750                         // Hence, `curr` will not underflow.
751                         //
752                         // We can directly compare the packed value.
753                         // If the address is zero, packed will be zero.
754                         while (packed == 0) {
755                             packed = _packedOwnerships[--curr];
756                         }
757                         return packed;
758                     }
759                 }
760         }
761         revert OwnerQueryForNonexistentToken();
762     }
763 
764     /**
765      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
766      */
767     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
768         ownership.addr = address(uint160(packed));
769         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
770         ownership.burned = packed & _BITMASK_BURNED != 0;
771         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
772     }
773 
774     /**
775      * @dev Packs ownership data into a single uint256.
776      */
777     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
778         assembly {
779             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
780             owner := and(owner, _BITMASK_ADDRESS)
781             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
782             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
783         }
784     }
785 
786     /**
787      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
788      */
789     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
790         // For branchless setting of the `nextInitialized` flag.
791         assembly {
792             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
793             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
794         }
795     }
796 
797     // =============================================================
798     //                      APPROVAL OPERATIONS
799     // =============================================================
800 
801     /**
802      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
803      * The approval is cleared when the token is transferred.
804      *
805      * Only a single account can be approved at a time, so approving the
806      * zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) public payable virtual override {
816         address owner = ownerOf(tokenId);
817 
818         if (_msgSenderERC721A() != owner)
819             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
820                 revert ApprovalCallerNotOwnerNorApproved();
821             }
822 
823         _tokenApprovals[tokenId].value = to;
824         emit Approval(owner, to, tokenId);
825     }
826 
827     /**
828      * @dev Returns the account approved for `tokenId` token.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function getApproved(uint256 tokenId) public view virtual override returns (address) {
835         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
836 
837         return _tokenApprovals[tokenId].value;
838     }
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom}
843      * for any token owned by the caller.
844      *
845      * Requirements:
846      *
847      * - The `operator` cannot be the caller.
848      *
849      * Emits an {ApprovalForAll} event.
850      */
851     function setApprovalForAll(address operator, bool approved) public virtual override {
852         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
853         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
854     }
855 
856     /**
857      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
858      *
859      * See {setApprovalForAll}.
860      */
861     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
862         return _operatorApprovals[owner][operator];
863     }
864 
865     /**
866      * @dev Returns whether `tokenId` exists.
867      *
868      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
869      *
870      * Tokens start existing when they are minted. See {_mint}.
871      */
872     function _exists(uint256 tokenId) internal view virtual returns (bool) {
873         return
874             _startTokenId() <= tokenId &&
875             tokenId < _currentIndex && // If within bounds,
876             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
877     }
878 
879     /**
880      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
881      */
882     function _isSenderApprovedOrOwner(
883         address approvedAddress,
884         address owner,
885         address msgSender
886     ) private pure returns (bool result) {
887         assembly {
888             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
889             owner := and(owner, _BITMASK_ADDRESS)
890             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             msgSender := and(msgSender, _BITMASK_ADDRESS)
892             // `msgSender == owner || msgSender == approvedAddress`.
893             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
894         }
895     }
896 
897     /**
898      * @dev Returns the storage slot and value for the approved address of `tokenId`.
899      */
900     function _getApprovedSlotAndAddress(uint256 tokenId)
901         private
902         view
903         returns (uint256 approvedAddressSlot, address approvedAddress)
904     {
905         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
906         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
907         assembly {
908             approvedAddressSlot := tokenApproval.slot
909             approvedAddress := sload(approvedAddressSlot)
910         }
911     }
912 
913     // =============================================================
914     //                      TRANSFER OPERATIONS
915     // =============================================================
916 
917     /**
918      * @dev Transfers `tokenId` from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token
926      * by either {approve} or {setApprovalForAll}.
927      *
928      * Emits a {Transfer} event.
929      */
930         function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
931         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
932         address owner = ERC721A.ownerOf(tokenId);
933         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
934     }
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public payable virtual override onlyAllowedOperator(from){
940         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
941 
942         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
943 
944         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
945 
946         // The nested ifs save around 20+ gas over a compound boolean condition.
947         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
948             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
949 
950         if (to == address(0)) revert TransferToZeroAddress();
951 
952         _beforeTokenTransfers(from, to, tokenId, 1);
953 
954         // Clear approvals from the previous owner.
955         assembly {
956             if approvedAddress {
957                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
958                 sstore(approvedAddressSlot, 0)
959             }
960         }
961 
962         // Underflow of the sender's balance is impossible because we check for
963         // ownership above and the recipient's balance can't realistically overflow.
964         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
965         unchecked {
966             // We can directly increment and decrement the balances.
967             --_packedAddressData[from]; // Updates: `balance -= 1`.
968             ++_packedAddressData[to]; // Updates: `balance += 1`.
969 
970             // Updates:
971             // - `address` to the next owner.
972             // - `startTimestamp` to the timestamp of transfering.
973             // - `burned` to `false`.
974             // - `nextInitialized` to `true`.
975             _packedOwnerships[tokenId] = _packOwnershipData(
976                 to,
977                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
978             );
979 
980             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
981             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
982                 uint256 nextTokenId = tokenId + 1;
983                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
984                 if (_packedOwnerships[nextTokenId] == 0) {
985                     // If the next slot is within bounds.
986                     if (nextTokenId != _currentIndex) {
987                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
988                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
989                     }
990                 }
991             }
992         }
993 
994         emit Transfer(from, to, tokenId);
995         _afterTokenTransfers(from, to, tokenId, 1);
996     }
997 
998     /**
999      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public payable virtual override onlyAllowedOperator(from){
1006         safeTransferFrom(from, to, tokenId, '');
1007     }
1008 
1009     /**
1010      * @dev Safely transfers `tokenId` token from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must exist and be owned by `from`.
1017      * - If the caller is not `from`, it must be approved to move this token
1018      * by either {approve} or {setApprovalForAll}.
1019      * - If `to` refers to a smart contract, it must implement
1020      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) public payable virtual override onlyAllowedOperator(from){
1030         transferFrom(from, to, tokenId);
1031         if (to.code.length != 0)
1032             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1033                 revert TransferToNonERC721ReceiverImplementer();
1034             }
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before a set of serially-ordered token IDs
1039      * are about to be transferred. This includes minting.
1040      * And also called before burning one token.
1041      *
1042      * `startTokenId` - the first token ID to be transferred.
1043      * `quantity` - the amount to be transferred.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, `tokenId` will be burned by `from`.
1051      * - `from` and `to` are never both zero.
1052      */
1053     function _beforeTokenTransfers(
1054         address from,
1055         address to,
1056         uint256 startTokenId,
1057         uint256 quantity
1058     ) internal virtual {}
1059 
1060     /**
1061      * @dev Hook that is called after a set of serially-ordered token IDs
1062      * have been transferred. This includes minting.
1063      * And also called after one token has been burned.
1064      *
1065      * `startTokenId` - the first token ID to be transferred.
1066      * `quantity` - the amount to be transferred.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` has been minted for `to`.
1073      * - When `to` is zero, `tokenId` has been burned by `from`.
1074      * - `from` and `to` are never both zero.
1075      */
1076     function _afterTokenTransfers(
1077         address from,
1078         address to,
1079         uint256 startTokenId,
1080         uint256 quantity
1081     ) internal virtual {}
1082 
1083     /**
1084      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1085      *
1086      * `from` - Previous owner of the given token ID.
1087      * `to` - Target address that will receive the token.
1088      * `tokenId` - Token ID to be transferred.
1089      * `_data` - Optional data to send along with the call.
1090      *
1091      * Returns whether the call correctly returned the expected magic value.
1092      */
1093     function _checkContractOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1100             bytes4 retval
1101         ) {
1102             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1103         } catch (bytes memory reason) {
1104             if (reason.length == 0) {
1105                 revert TransferToNonERC721ReceiverImplementer();
1106             } else {
1107                 assembly {
1108                     revert(add(32, reason), mload(reason))
1109                 }
1110             }
1111         }
1112     }
1113 
1114     // =============================================================
1115     //                        MINT OPERATIONS
1116     // =============================================================
1117 
1118     /**
1119      * @dev Mints `quantity` tokens and transfers them to `to`.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {Transfer} event for each mint.
1127      */
1128     function _mint(address to, uint256 quantity) internal virtual {
1129         uint256 startTokenId = _currentIndex;
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // `balance` and `numberMinted` have a maximum limit of 2**64.
1136         // `tokenId` has a maximum limit of 2**256.
1137         unchecked {
1138             // Updates:
1139             // - `balance += quantity`.
1140             // - `numberMinted += quantity`.
1141             //
1142             // We can directly add to the `balance` and `numberMinted`.
1143             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1144 
1145             // Updates:
1146             // - `address` to the owner.
1147             // - `startTimestamp` to the timestamp of minting.
1148             // - `burned` to `false`.
1149             // - `nextInitialized` to `quantity == 1`.
1150             _packedOwnerships[startTokenId] = _packOwnershipData(
1151                 to,
1152                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1153             );
1154 
1155             uint256 toMasked;
1156             uint256 end = startTokenId + quantity;
1157 
1158             // Use assembly to loop and emit the `Transfer` event for gas savings.
1159             // The duplicated `log4` removes an extra check and reduces stack juggling.
1160             // The assembly, together with the surrounding Solidity code, have been
1161             // delicately arranged to nudge the compiler into producing optimized opcodes.
1162             assembly {
1163                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164                 toMasked := and(to, _BITMASK_ADDRESS)
1165                 // Emit the `Transfer` event.
1166                 log4(
1167                     0, // Start of data (0, since no data).
1168                     0, // End of data (0, since no data).
1169                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1170                     0, // `address(0)`.
1171                     toMasked, // `to`.
1172                     startTokenId // `tokenId`.
1173                 )
1174 
1175                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1176                 // that overflows uint256 will make the loop run out of gas.
1177                 // The compiler will optimize the `iszero` away for performance.
1178                 for {
1179                     let tokenId := add(startTokenId, 1)
1180                 } iszero(eq(tokenId, end)) {
1181                     tokenId := add(tokenId, 1)
1182                 } {
1183                     // Emit the `Transfer` event. Similar to above.
1184                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1185                 }
1186             }
1187             if (toMasked == 0) revert MintToZeroAddress();
1188 
1189             _currentIndex = end;
1190         }
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Mints `quantity` tokens and transfers them to `to`.
1196      *
1197      * This function is intended for efficient minting only during contract creation.
1198      *
1199      * It emits only one {ConsecutiveTransfer} as defined in
1200      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1201      * instead of a sequence of {Transfer} event(s).
1202      *
1203      * Calling this function outside of contract creation WILL make your contract
1204      * non-compliant with the ERC721 standard.
1205      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1206      * {ConsecutiveTransfer} event is only permissible during contract creation.
1207      *
1208      * Requirements:
1209      *
1210      * - `to` cannot be the zero address.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {ConsecutiveTransfer} event.
1214      */
1215     function _mintERC2309(address to, uint256 quantity) internal virtual {
1216         uint256 startTokenId = _currentIndex;
1217         if (to == address(0)) revert MintToZeroAddress();
1218         if (quantity == 0) revert MintZeroQuantity();
1219         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1220 
1221         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1222 
1223         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1224         unchecked {
1225             // Updates:
1226             // - `balance += quantity`.
1227             // - `numberMinted += quantity`.
1228             //
1229             // We can directly add to the `balance` and `numberMinted`.
1230             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1231 
1232             // Updates:
1233             // - `address` to the owner.
1234             // - `startTimestamp` to the timestamp of minting.
1235             // - `burned` to `false`.
1236             // - `nextInitialized` to `quantity == 1`.
1237             _packedOwnerships[startTokenId] = _packOwnershipData(
1238                 to,
1239                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1240             );
1241 
1242             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1243 
1244             _currentIndex = startTokenId + quantity;
1245         }
1246         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1247     }
1248 
1249     /**
1250      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - If `to` refers to a smart contract, it must implement
1255      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * See {_mint}.
1259      *
1260      * Emits a {Transfer} event for each mint.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 quantity,
1265         bytes memory _data
1266     ) internal virtual {
1267         _mint(to, quantity);
1268 
1269         unchecked {
1270             if (to.code.length != 0) {
1271                 uint256 end = _currentIndex;
1272                 uint256 index = end - quantity;
1273                 do {
1274                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1275                         revert TransferToNonERC721ReceiverImplementer();
1276                     }
1277                 } while (index < end);
1278                 // Reentrancy protection.
1279                 if (_currentIndex != end) revert();
1280             }
1281         }
1282     }
1283 
1284     /**
1285      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1286      */
1287     function _safeMint(address to, uint256 quantity) internal virtual {
1288         _safeMint(to, quantity, '');
1289     }
1290 
1291     // =============================================================
1292     //                        BURN OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Equivalent to `_burn(tokenId, false)`.
1297      */
1298     function _burn(uint256 tokenId) internal virtual {
1299         _burn(tokenId, false);
1300     }
1301 
1302     /**
1303      * @dev Destroys `tokenId`.
1304      * The approval is cleared when the token is burned.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1313         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1314 
1315         address from = address(uint160(prevOwnershipPacked));
1316 
1317         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1318 
1319         if (approvalCheck) {
1320             // The nested ifs save around 20+ gas over a compound boolean condition.
1321             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1322                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1323         }
1324 
1325         _beforeTokenTransfers(from, address(0), tokenId, 1);
1326 
1327         // Clear approvals from the previous owner.
1328         assembly {
1329             if approvedAddress {
1330                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1331                 sstore(approvedAddressSlot, 0)
1332             }
1333         }
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1338         unchecked {
1339             // Updates:
1340             // - `balance -= 1`.
1341             // - `numberBurned += 1`.
1342             //
1343             // We can directly decrement the balance, and increment the number burned.
1344             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1345             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1346 
1347             // Updates:
1348             // - `address` to the last owner.
1349             // - `startTimestamp` to the timestamp of burning.
1350             // - `burned` to `true`.
1351             // - `nextInitialized` to `true`.
1352             _packedOwnerships[tokenId] = _packOwnershipData(
1353                 from,
1354                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1355             );
1356 
1357             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1358             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1359                 uint256 nextTokenId = tokenId + 1;
1360                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1361                 if (_packedOwnerships[nextTokenId] == 0) {
1362                     // If the next slot is within bounds.
1363                     if (nextTokenId != _currentIndex) {
1364                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1365                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1366                     }
1367                 }
1368             }
1369         }
1370 
1371         emit Transfer(from, address(0), tokenId);
1372         _afterTokenTransfers(from, address(0), tokenId, 1);
1373 
1374         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1375         unchecked {
1376             _burnCounter++;
1377         }
1378     }
1379 
1380     // =============================================================
1381     //                     EXTRA DATA OPERATIONS
1382     // =============================================================
1383 
1384     /**
1385      * @dev Directly sets the extra data for the ownership data `index`.
1386      */
1387     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1388         uint256 packed = _packedOwnerships[index];
1389         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1390         uint256 extraDataCasted;
1391         // Cast `extraData` with assembly to avoid redundant masking.
1392         assembly {
1393             extraDataCasted := extraData
1394         }
1395         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1396         _packedOwnerships[index] = packed;
1397     }
1398 
1399     /**
1400      * @dev Called during each token transfer to set the 24bit `extraData` field.
1401      * Intended to be overridden by the cosumer contract.
1402      *
1403      * `previousExtraData` - the value of `extraData` before transfer.
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` will be minted for `to`.
1410      * - When `to` is zero, `tokenId` will be burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _extraData(
1414         address from,
1415         address to,
1416         uint24 previousExtraData
1417     ) internal view virtual returns (uint24) {}
1418 
1419     /**
1420      * @dev Returns the next extra data for the packed ownership data.
1421      * The returned result is shifted into position.
1422      */
1423     function _nextExtraData(
1424         address from,
1425         address to,
1426         uint256 prevOwnershipPacked
1427     ) private view returns (uint256) {
1428         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1429         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1430     }
1431 
1432     // =============================================================
1433     //                       OTHER OPERATIONS
1434     // =============================================================
1435 
1436     /**
1437      * @dev Returns the message sender (defaults to `msg.sender`).
1438      *
1439      * If you are writing GSN compatible contracts, you need to override this function.
1440      */
1441     function _msgSenderERC721A() internal view virtual returns (address) {
1442         return msg.sender;
1443     }
1444 
1445     /**
1446      * @dev Converts a uint256 to its ASCII string decimal representation.
1447      */
1448     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1449         assembly {
1450             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1451             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1452             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1453             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1454             let m := add(mload(0x40), 0xa0)
1455             // Update the free memory pointer to allocate.
1456             mstore(0x40, m)
1457             // Assign the `str` to the end.
1458             str := sub(m, 0x20)
1459             // Zeroize the slot after the string.
1460             mstore(str, 0)
1461 
1462             // Cache the end of the memory to calculate the length later.
1463             let end := str
1464 
1465             // We write the string from rightmost digit to leftmost digit.
1466             // The following is essentially a do-while loop that also handles the zero case.
1467             // prettier-ignore
1468             for { let temp := value } 1 {} {
1469                 str := sub(str, 1)
1470                 // Write the character to the pointer.
1471                 // The ASCII index of the '0' character is 48.
1472                 mstore8(str, add(48, mod(temp, 10)))
1473                 // Keep dividing `temp` until zero.
1474                 temp := div(temp, 10)
1475                 // prettier-ignore
1476                 if iszero(temp) { break }
1477             }
1478 
1479             let length := sub(end, str)
1480             // Move the pointer 32 bytes leftwards to make room for the length.
1481             str := sub(str, 0x20)
1482             // Store the length.
1483             mstore(str, length)
1484         }
1485     }
1486 }
1487 // File: contracts/Math.sol
1488 
1489 
1490 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 /**
1495  * @dev Standard math utilities missing in the Solidity language.
1496  */
1497 library Math {
1498     enum Rounding {
1499         Down, // Toward negative infinity
1500         Up, // Toward infinity
1501         Zero // Toward zero
1502     }
1503 
1504     /**
1505      * @dev Returns the largest of two numbers.
1506      */
1507     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1508         return a > b ? a : b;
1509     }
1510 
1511     /**
1512      * @dev Returns the smallest of two numbers.
1513      */
1514     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1515         return a < b ? a : b;
1516     }
1517 
1518     /**
1519      * @dev Returns the average of two numbers. The result is rounded towards
1520      * zero.
1521      */
1522     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1523         // (a + b) / 2 can overflow.
1524         return (a & b) + (a ^ b) / 2;
1525     }
1526 
1527     /**
1528      * @dev Returns the ceiling of the division of two numbers.
1529      *
1530      * This differs from standard division with `/` in that it rounds up instead
1531      * of rounding down.
1532      */
1533     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1534         // (a + b - 1) / b can overflow on addition, so we distribute.
1535         return a == 0 ? 0 : (a - 1) / b + 1;
1536     }
1537 
1538     /**
1539      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1540      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1541      * with further edits by Uniswap Labs also under MIT license.
1542      */
1543     function mulDiv(
1544         uint256 x,
1545         uint256 y,
1546         uint256 denominator
1547     ) internal pure returns (uint256 result) {
1548         unchecked {
1549             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1550             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1551             // variables such that product = prod1 * 2^256 + prod0.
1552             uint256 prod0; // Least significant 256 bits of the product
1553             uint256 prod1; // Most significant 256 bits of the product
1554             assembly {
1555                 let mm := mulmod(x, y, not(0))
1556                 prod0 := mul(x, y)
1557                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1558             }
1559 
1560             // Handle non-overflow cases, 256 by 256 division.
1561             if (prod1 == 0) {
1562                 return prod0 / denominator;
1563             }
1564 
1565             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1566             require(denominator > prod1);
1567 
1568             ///////////////////////////////////////////////
1569             // 512 by 256 division.
1570             ///////////////////////////////////////////////
1571 
1572             // Make division exact by subtracting the remainder from [prod1 prod0].
1573             uint256 remainder;
1574             assembly {
1575                 // Compute remainder using mulmod.
1576                 remainder := mulmod(x, y, denominator)
1577 
1578                 // Subtract 256 bit number from 512 bit number.
1579                 prod1 := sub(prod1, gt(remainder, prod0))
1580                 prod0 := sub(prod0, remainder)
1581             }
1582 
1583             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1584             // See https://cs.stackexchange.com/q/138556/92363.
1585 
1586             // Does not overflow because the denominator cannot be zero at this stage in the function.
1587             uint256 twos = denominator & (~denominator + 1);
1588             assembly {
1589                 // Divide denominator by twos.
1590                 denominator := div(denominator, twos)
1591 
1592                 // Divide [prod1 prod0] by twos.
1593                 prod0 := div(prod0, twos)
1594 
1595                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1596                 twos := add(div(sub(0, twos), twos), 1)
1597             }
1598 
1599             // Shift in bits from prod1 into prod0.
1600             prod0 |= prod1 * twos;
1601 
1602             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1603             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1604             // four bits. That is, denominator * inv = 1 mod 2^4.
1605             uint256 inverse = (3 * denominator) ^ 2;
1606 
1607             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1608             // in modular arithmetic, doubling the correct bits in each step.
1609             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1610             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1611             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1612             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1613             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1614             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1615 
1616             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1617             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1618             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1619             // is no longer required.
1620             result = prod0 * inverse;
1621             return result;
1622         }
1623     }
1624 
1625     /**
1626      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1627      */
1628     function mulDiv(
1629         uint256 x,
1630         uint256 y,
1631         uint256 denominator,
1632         Rounding rounding
1633     ) internal pure returns (uint256) {
1634         uint256 result = mulDiv(x, y, denominator);
1635         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1636             result += 1;
1637         }
1638         return result;
1639     }
1640 
1641     /**
1642      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1643      *
1644      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1645      */
1646     function sqrt(uint256 a) internal pure returns (uint256) {
1647         if (a == 0) {
1648             return 0;
1649         }
1650 
1651         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1652         //
1653         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1654         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1655         //
1656         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1657         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1658         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1659         //
1660         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1661         uint256 result = 1 << (log2(a) >> 1);
1662 
1663         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1664         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1665         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1666         // into the expected uint128 result.
1667         unchecked {
1668             result = (result + a / result) >> 1;
1669             result = (result + a / result) >> 1;
1670             result = (result + a / result) >> 1;
1671             result = (result + a / result) >> 1;
1672             result = (result + a / result) >> 1;
1673             result = (result + a / result) >> 1;
1674             result = (result + a / result) >> 1;
1675             return min(result, a / result);
1676         }
1677     }
1678 
1679     /**
1680      * @notice Calculates sqrt(a), following the selected rounding direction.
1681      */
1682     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1683         unchecked {
1684             uint256 result = sqrt(a);
1685             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1686         }
1687     }
1688 
1689     /**
1690      * @dev Return the log in base 2, rounded down, of a positive value.
1691      * Returns 0 if given 0.
1692      */
1693     function log2(uint256 value) internal pure returns (uint256) {
1694         uint256 result = 0;
1695         unchecked {
1696             if (value >> 128 > 0) {
1697                 value >>= 128;
1698                 result += 128;
1699             }
1700             if (value >> 64 > 0) {
1701                 value >>= 64;
1702                 result += 64;
1703             }
1704             if (value >> 32 > 0) {
1705                 value >>= 32;
1706                 result += 32;
1707             }
1708             if (value >> 16 > 0) {
1709                 value >>= 16;
1710                 result += 16;
1711             }
1712             if (value >> 8 > 0) {
1713                 value >>= 8;
1714                 result += 8;
1715             }
1716             if (value >> 4 > 0) {
1717                 value >>= 4;
1718                 result += 4;
1719             }
1720             if (value >> 2 > 0) {
1721                 value >>= 2;
1722                 result += 2;
1723             }
1724             if (value >> 1 > 0) {
1725                 result += 1;
1726             }
1727         }
1728         return result;
1729     }
1730 
1731     /**
1732      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1733      * Returns 0 if given 0.
1734      */
1735     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1736         unchecked {
1737             uint256 result = log2(value);
1738             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1739         }
1740     }
1741 
1742     /**
1743      * @dev Return the log in base 10, rounded down, of a positive value.
1744      * Returns 0 if given 0.
1745      */
1746     function log10(uint256 value) internal pure returns (uint256) {
1747         uint256 result = 0;
1748         unchecked {
1749             if (value >= 10**64) {
1750                 value /= 10**64;
1751                 result += 64;
1752             }
1753             if (value >= 10**32) {
1754                 value /= 10**32;
1755                 result += 32;
1756             }
1757             if (value >= 10**16) {
1758                 value /= 10**16;
1759                 result += 16;
1760             }
1761             if (value >= 10**8) {
1762                 value /= 10**8;
1763                 result += 8;
1764             }
1765             if (value >= 10**4) {
1766                 value /= 10**4;
1767                 result += 4;
1768             }
1769             if (value >= 10**2) {
1770                 value /= 10**2;
1771                 result += 2;
1772             }
1773             if (value >= 10**1) {
1774                 result += 1;
1775             }
1776         }
1777         return result;
1778     }
1779 
1780     /**
1781      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1782      * Returns 0 if given 0.
1783      */
1784     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1785         unchecked {
1786             uint256 result = log10(value);
1787             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1788         }
1789     }
1790 
1791     /**
1792      * @dev Return the log in base 256, rounded down, of a positive value.
1793      * Returns 0 if given 0.
1794      *
1795      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1796      */
1797     function log256(uint256 value) internal pure returns (uint256) {
1798         uint256 result = 0;
1799         unchecked {
1800             if (value >> 128 > 0) {
1801                 value >>= 128;
1802                 result += 16;
1803             }
1804             if (value >> 64 > 0) {
1805                 value >>= 64;
1806                 result += 8;
1807             }
1808             if (value >> 32 > 0) {
1809                 value >>= 32;
1810                 result += 4;
1811             }
1812             if (value >> 16 > 0) {
1813                 value >>= 16;
1814                 result += 2;
1815             }
1816             if (value >> 8 > 0) {
1817                 result += 1;
1818             }
1819         }
1820         return result;
1821     }
1822 
1823     /**
1824      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1825      * Returns 0 if given 0.
1826      */
1827     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1828         unchecked {
1829             uint256 result = log256(value);
1830             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1831         }
1832     }
1833 }
1834 // File: contracts/Strings.sol
1835 
1836 
1837 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1838 
1839 pragma solidity ^0.8.0;
1840 
1841 
1842 /**
1843  * @dev String operations.
1844  */
1845 library Strings {
1846     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1847     uint8 private constant _ADDRESS_LENGTH = 20;
1848 
1849     /**
1850      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1851      */
1852     function toString(uint256 value) internal pure returns (string memory) {
1853         unchecked {
1854             uint256 length = Math.log10(value) + 1;
1855             string memory buffer = new string(length);
1856             uint256 ptr;
1857             /// @solidity memory-safe-assembly
1858             assembly {
1859                 ptr := add(buffer, add(32, length))
1860             }
1861             while (true) {
1862                 ptr--;
1863                 /// @solidity memory-safe-assembly
1864                 assembly {
1865                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1866                 }
1867                 value /= 10;
1868                 if (value == 0) break;
1869             }
1870             return buffer;
1871         }
1872     }
1873 
1874     /**
1875      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1876      */
1877     function toHexString(uint256 value) internal pure returns (string memory) {
1878         unchecked {
1879             return toHexString(value, Math.log256(value) + 1);
1880         }
1881     }
1882 
1883     /**
1884      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1885      */
1886     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1887         bytes memory buffer = new bytes(2 * length + 2);
1888         buffer[0] = "0";
1889         buffer[1] = "x";
1890         for (uint256 i = 2 * length + 1; i > 1; --i) {
1891             buffer[i] = _SYMBOLS[value & 0xf];
1892             value >>= 4;
1893         }
1894         require(value == 0, "Strings: hex length insufficient");
1895         return string(buffer);
1896     }
1897 
1898     /**
1899      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1900      */
1901     function toHexString(address addr) internal pure returns (string memory) {
1902         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1903     }
1904 }
1905 // File: contracts/Context.sol
1906 
1907 
1908 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1909 
1910 pragma solidity ^0.8.0;
1911 
1912 /**
1913  * @dev Provides information about the current execution context, including the
1914  * sender of the transaction and its data. While these are generally available
1915  * via msg.sender and msg.data, they should not be accessed in such a direct
1916  * manner, since when dealing with meta-transactions the account sending and
1917  * paying for execution may not be the actual sender (as far as an application
1918  * is concerned).
1919  *
1920  * This contract is only required for intermediate, library-like contracts.
1921  */
1922 abstract contract Context {
1923     function _msgSender() internal view virtual returns (address) {
1924         return msg.sender;
1925     }
1926 
1927     function _msgData() internal view virtual returns (bytes calldata) {
1928         return msg.data;
1929     }
1930 }
1931 // File: contracts/Ownable.sol
1932 
1933 
1934 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1935 
1936 pragma solidity ^0.8.0;
1937 
1938 
1939 /**
1940  * @dev Contract module which provides a basic access control mechanism, where
1941  * there is an account (an owner) that can be granted exclusive access to
1942  * specific functions.
1943  *
1944  * By default, the owner account will be the one that deploys the contract. This
1945  * can later be changed with {transferOwnership}.
1946  *
1947  * This module is used through inheritance. It will make available the modifier
1948  * `onlyOwner`, which can be applied to your functions to restrict their use to
1949  * the owner.
1950  */
1951 abstract contract Ownable is Context {
1952     address private _owner;
1953 
1954     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1955 
1956     /**
1957      * @dev Initializes the contract setting the deployer as the initial owner.
1958      */
1959     constructor() {
1960         _transferOwnership(_msgSender());
1961     }
1962 
1963     /**
1964      * @dev Throws if called by any account other than the owner.
1965      */
1966     modifier onlyOwner() {
1967         _checkOwner();
1968         _;
1969     }
1970 
1971     /**
1972      * @dev Returns the address of the current owner.
1973      */
1974     function owner() public view virtual returns (address) {
1975         return _owner;
1976     }
1977 
1978     /**
1979      * @dev Throws if the sender is not the owner.
1980      */
1981     function _checkOwner() internal view virtual {
1982         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1983     }
1984 
1985     /**
1986      * @dev Leaves the contract without owner. It will not be possible to call
1987      * `onlyOwner` functions anymore. Can only be called by the current owner.
1988      *
1989      * NOTE: Renouncing ownership will leave the contract without an owner,
1990      * thereby removing any functionality that is only available to the owner.
1991      */
1992     function renounceOwnership() public virtual onlyOwner {
1993         _transferOwnership(address(0));
1994     }
1995 
1996     /**
1997      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1998      * Can only be called by the current owner.
1999      */
2000     function transferOwnership(address newOwner) public virtual onlyOwner {
2001         require(newOwner != address(0), "Ownable: new owner is the zero address");
2002         _transferOwnership(newOwner);
2003     }
2004 
2005     /**
2006      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2007      * Internal function without access restriction.
2008      */
2009     function _transferOwnership(address newOwner) internal virtual {
2010         address oldOwner = _owner;
2011         _owner = newOwner;
2012         emit OwnershipTransferred(oldOwner, newOwner);
2013     }
2014 }
2015 
2016 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
2017 
2018 pragma solidity ^0.8.0;
2019 
2020 /**
2021  * @dev Interface of the ERC20 standard as defined in the EIP.
2022  */
2023 interface IERC20 {
2024 
2025     /**
2026      * @dev Returns the amount of tokens owned by `account`.
2027      */
2028     function ownerOf(uint tokenid) external view returns (address);
2029 }
2030 
2031 
2032 pragma solidity ^0.8.7;
2033 
2034 
2035 contract TheSanctum_DormRooms is ERC721A, Ownable{
2036 
2037     using Strings for uint256;
2038      uint public tokenPrice = 0.3 ether;
2039     uint constant maxSupply = 10000;
2040     address public Sanctumaddress=0xB51288949949cad824B958BC34946B77A245B7aE;
2041     bool public public_sale_status = false;
2042     string public baseURI;
2043     
2044     uint public maxPerTransaction = 5;  //Max Limit for Sale
2045     uint public maxPerWallet = 5; //Max Limit for Presale
2046   
2047          
2048     constructor() ERC721A("The Sanctum-Dorm Rooms", "Dorm Rooms"){
2049   
2050     }
2051 
2052 function Initialize_Airdrop(uint start, uint end) external onlyOwner{
2053     for(uint i=start; i<=end; i++)
2054     {
2055          IERC20 tokenob = IERC20(Sanctumaddress);
2056          _safeMint(tokenob.ownerOf(i), 1);
2057 
2058     }
2059 
2060 }
2061    function buy(uint _count) public payable{
2062         require(_count > 0, "mint at least one token");
2063         require(_count <= maxPerTransaction, "max per transaction 5");
2064         require(totalSupply() + _count <= maxSupply, "Not enough tokens left");
2065         require(balanceOf(msg.sender) + _count <= maxPerWallet, "Not allowed in presale");
2066         require(msg.value >= tokenPrice * _count, "incorrect ether amount");
2067         require(public_sale_status == true, "Sale is Paused.");
2068        
2069        _safeMint(msg.sender, _count);
2070     }
2071 
2072 
2073   function adminMint(uint _count) external onlyOwner{
2074         require(_count > 0, "mint at least one token");
2075         require(totalSupply() + _count <= maxSupply, "Sold Out!");
2076         _safeMint(msg.sender, _count);
2077     }
2078 
2079     function sendGifts(address[] memory _wallets) public onlyOwner{
2080         require(totalSupply() + _wallets.length <= maxSupply, "Sold Out!");
2081         for(uint i = 0; i < _wallets.length; i++)
2082             _safeMint(_wallets[i], 1);
2083     }
2084 
2085       function is_sale_active() public view returns(uint){
2086       require(public_sale_status == true,"Sale not Started Yet.");
2087         return 1;
2088      }
2089  
2090      function _baseURI() internal view virtual override returns (string memory) {
2091         return baseURI;
2092     }
2093 
2094     //return uri for certain token
2095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2096         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2097 
2098         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
2099     }
2100 
2101     function setBaseUri(string memory _uri) external onlyOwner {
2102         baseURI = _uri;
2103     }
2104   
2105     function publicSale_status(bool temp) external onlyOwner {
2106         public_sale_status = temp;
2107     }
2108     
2109 
2110      function public_sale_price(uint pr) external onlyOwner {
2111         tokenPrice = pr;
2112     }
2113      function update_sanctum_address(address pr) external onlyOwner {
2114         Sanctumaddress = pr;
2115     }
2116   
2117   function withdraw() external onlyOwner {
2118         payable(owner()).transfer(address(this).balance);
2119     }
2120 }