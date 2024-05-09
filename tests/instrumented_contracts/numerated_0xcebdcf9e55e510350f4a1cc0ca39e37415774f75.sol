1 //                                                                                
2 //                                                                                
3 //   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
4 //   @@                     @@                                                @@  
5 //   @@                     @@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@  
6 //   @@                     @@    @@                                   @@     @@  
7 //   @@                     @@    @@                                   @@     @@  
8 //   @@                     @@    @@                                   @@     @@  
9 //   @@                     @@    @@                                   @@     @@  
10 //   @@                     @@    @@                                   @@     @@  
11 //   @@                     @@    @@                                   @@     @@  
12 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
13 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
14 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
15 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
16 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
17 //   @@                     @@    @@                                   @@     @@  
18 //   @@                     @@    @@                                   @@     @@  
19 //   @@                     @@    @@                                   @@     @@  
20 //   @@                     @@    @@                                   @@     @@  
21 //   @@                     @@    @@                                   @@     @@  
22 //   @@                     @@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.      @@  
23 //   @@                     @@                                                @@  
24 //   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
25 //               @/            (@                                 @@              
26 //               @/            (@                                 @@              
27 //               @/            (@                                 @@              
28 //               @/            (@                                 @@              
29 //               @/            (@                                 @@              
30 //               @/            (@                                 @@              
31 //               @/            (@                                 @@              
32 //               @/            (@                                 @@              
33 //               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
34 // 
35 //       
36 ///////////////////////////////////////////////////////////////////////////////////////////////////
37 //
38 //    ___     _   __ ____   ____   ____   __  ___ ______ ______ __  __ ___       _    __ _  __
39 //   /   |   / | / // __ \ / __ \ / __ \ /  |/  // ____// ____// / / //   |     | |  / /| |/ /
40 //  / /| |  /  |/ // / / // /_/ // / / // /|_/ // __/  / /    / /_/ // /| |     | | / / |   / 
41 // / ___ | / /|  // /_/ // _, _// /_/ // /  / // /___ / /___ / __  // ___ |     | |/ / /   |  
42 ///_/  |_|/_/ |_//_____//_/ |_| \____//_/  /_//_____/ \____//_/ /_//_/  |_|     |___/ /_/|_|  
43 //                                                                                            
44 //
45 //////////////////////////////////////////////////////////////////////////////////////////////////     
46 //
47 //   
48 // SPDX-License-Identifier: MIT
49 
50 pragma solidity ^0.8.4;
51 
52 /**
53  * @dev Interface of ERC721A.
54  */
55 interface IERC721A {
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error ApprovalCallerNotOwnerNorApproved();
60 
61     /**
62      * The token does not exist.
63      */
64     error ApprovalQueryForNonexistentToken();
65 
66     /**
67      * Cannot query the balance for the zero address.
68      */
69     error BalanceQueryForZeroAddress();
70 
71     /**
72      * Cannot mint to the zero address.
73      */
74     error MintToZeroAddress();
75 
76     /**
77      * The quantity of tokens minted must be more than zero.
78      */
79     error MintZeroQuantity();
80 
81     /**
82      * The token does not exist.
83      */
84     error OwnerQueryForNonexistentToken();
85 
86     /**
87      * The caller must own the token or be an approved operator.
88      */
89     error TransferCallerNotOwnerNorApproved();
90 
91     /**
92      * The token must be owned by `from`.
93      */
94     error TransferFromIncorrectOwner();
95 
96     /**
97      * Cannot safely transfer to a contract that does not implement the
98      * ERC721Receiver interface.
99      */
100     error TransferToNonERC721ReceiverImplementer();
101 
102     /**
103      * Cannot transfer to the zero address.
104      */
105     error TransferToZeroAddress();
106 
107     /**
108      * The token does not exist.
109      */
110     error URIQueryForNonexistentToken();
111 
112     /**
113      * The `quantity` minted with ERC2309 exceeds the safety limit.
114      */
115     error MintERC2309QuantityExceedsLimit();
116 
117     /**
118      * The `extraData` cannot be set on an unintialized ownership slot.
119      */
120     error OwnershipNotInitializedForExtraData();
121 
122     // =============================================================
123     //                            STRUCTS
124     // =============================================================
125 
126     struct TokenOwnership {
127         // The address of the owner.
128         address addr;
129         // Stores the start time of ownership with minimal overhead for tokenomics.
130         uint64 startTimestamp;
131         // Whether the token has been burned.
132         bool burned;
133         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
134         uint24 extraData;
135     }
136 
137     // =============================================================
138     //                         TOKEN COUNTERS
139     // =============================================================
140 
141     /**
142      * @dev Returns the total number of tokens in existence.
143      * Burned tokens will reduce the count.
144      * To get the total number of tokens minted, please see {_totalMinted}.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     // =============================================================
149     //                            IERC165
150     // =============================================================
151 
152     /**
153      * @dev Returns true if this contract implements the interface defined by
154      * `interfaceId`. See the corresponding
155      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
156      * to learn more about how these ids are created.
157      *
158      * This function call must use less than 30000 gas.
159      */
160     function supportsInterface(bytes4 interfaceId) external view returns (bool);
161 
162     // =============================================================
163     //                            IERC721
164     // =============================================================
165 
166     /**
167      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
170 
171     /**
172      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
173      */
174     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
175 
176     /**
177      * @dev Emitted when `owner` enables or disables
178      * (`approved`) `operator` to manage all of its assets.
179      */
180     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
181 
182     /**
183      * @dev Returns the number of tokens in `owner`'s account.
184      */
185     function balanceOf(address owner) external view returns (uint256 balance);
186 
187     /**
188      * @dev Returns the owner of the `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function ownerOf(uint256 tokenId) external view returns (address owner);
195 
196     /**
197      * @dev Safely transfers `tokenId` token from `from` to `to`,
198      * checking first that contract recipients are aware of the ERC721 protocol
199      * to prevent tokens from being forever locked.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must exist and be owned by `from`.
206      * - If the caller is not `from`, it must be have been allowed to move
207      * this token by either {approve} or {setApprovalForAll}.
208      * - If `to` refers to a smart contract, it must implement
209      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
210      *
211      * Emits a {Transfer} event.
212      */
213     function safeTransferFrom(
214         address from,
215         address to,
216         uint256 tokenId,
217         bytes calldata data
218     ) external payable;
219 
220     /**
221      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
222      */
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 tokenId
227     ) external payable;
228 
229     /**
230      * @dev Transfers `tokenId` from `from` to `to`.
231      *
232      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
233      * whenever possible.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token
241      * by either {approve} or {setApprovalForAll}.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external payable;
250 
251     /**
252      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
253      * The approval is cleared when the token is transferred.
254      *
255      * Only a single account can be approved at a time, so approving the
256      * zero address clears previous approvals.
257      *
258      * Requirements:
259      *
260      * - The caller must own the token or be an approved operator.
261      * - `tokenId` must exist.
262      *
263      * Emits an {Approval} event.
264      */
265     function approve(address to, uint256 tokenId) external payable;
266 
267     /**
268      * @dev Approve or remove `operator` as an operator for the caller.
269      * Operators can call {transferFrom} or {safeTransferFrom}
270      * for any token owned by the caller.
271      *
272      * Requirements:
273      *
274      * - The `operator` cannot be the caller.
275      *
276      * Emits an {ApprovalForAll} event.
277      */
278     function setApprovalForAll(address operator, bool _approved) external;
279 
280     /**
281      * @dev Returns the account approved for `tokenId` token.
282      *
283      * Requirements:
284      *
285      * - `tokenId` must exist.
286      */
287     function getApproved(uint256 tokenId) external view returns (address operator);
288 
289     /**
290      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
291      *
292      * See {setApprovalForAll}.
293      */
294     function isApprovedForAll(address owner, address operator) external view returns (bool);
295 
296     // =============================================================
297     //                        IERC721Metadata
298     // =============================================================
299 
300     /**
301      * @dev Returns the token collection name.
302      */
303     function name() external view returns (string memory);
304 
305     /**
306      * @dev Returns the token collection symbol.
307      */
308     function symbol() external view returns (string memory);
309 
310     /**
311      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
312      */
313     function tokenURI(uint256 tokenId) external view returns (string memory);
314 
315     // =============================================================
316     //                           IERC2309
317     // =============================================================
318 
319     /**
320      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
321      * (inclusive) is transferred from `from` to `to`, as defined in the
322      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
323      *
324      * See {_mintERC2309} for more details.
325      */
326     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
327 }
328 
329 // File: erc721a/contracts/ERC721A.sol
330 
331 
332 // ERC721A Contracts v4.2.3
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 
338 /**
339  * @dev Interface of ERC721 token receiver.
340  */
341 interface ERC721A__IERC721Receiver {
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 
350 /**
351  * @title ERC721A
352  *
353  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
354  * Non-Fungible Token Standard, including the Metadata extension.
355  * Optimized for lower gas during batch mints.
356  *
357  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
358  * starting from `_startTokenId()`.
359  *
360  * Assumptions:
361  *
362  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
363  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
364  */
365 contract ERC721A is IERC721A {
366     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
367     struct TokenApprovalRef {
368         address value;
369     }
370 
371     // =============================================================
372     //                           CONSTANTS
373     // =============================================================
374 
375     // Mask of an entry in packed address data.
376     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
377 
378     // The bit position of `numberMinted` in packed address data.
379     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
380 
381     // The bit position of `numberBurned` in packed address data.
382     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
383 
384     // The bit position of `aux` in packed address data.
385     uint256 private constant _BITPOS_AUX = 192;
386 
387     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
388     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
389 
390     // The bit position of `startTimestamp` in packed ownership.
391     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
392 
393     // The bit mask of the `burned` bit in packed ownership.
394     uint256 private constant _BITMASK_BURNED = 1 << 224;
395 
396     // The bit position of the `nextInitialized` bit in packed ownership.
397     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
398 
399     // The bit mask of the `nextInitialized` bit in packed ownership.
400     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
401 
402     // The bit position of `extraData` in packed ownership.
403     uint256 private constant _BITPOS_EXTRA_DATA = 232;
404 
405     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
406     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
407 
408     // The mask of the lower 160 bits for addresses.
409     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
410 
411     // The maximum `quantity` that can be minted with {_mintERC2309}.
412     // This limit is to prevent overflows on the address data entries.
413     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
414     // is required to cause an overflow, which is unrealistic.
415     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
416 
417     // The `Transfer` event signature is given by:
418     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
419     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
420         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
421 
422     // =============================================================
423     //                            STORAGE
424     // =============================================================
425 
426     // The next token ID to be minted.
427     uint256 private _currentIndex;
428 
429     // The number of tokens burned.
430     uint256 private _burnCounter;
431 
432     // Token name
433     string private _name;
434 
435     // Token symbol
436     string private _symbol;
437 
438     // Mapping from token ID to ownership details
439     // An empty struct value does not necessarily mean the token is unowned.
440     // See {_packedOwnershipOf} implementation for details.
441     //
442     // Bits Layout:
443     // - [0..159]   `addr`
444     // - [160..223] `startTimestamp`
445     // - [224]      `burned`
446     // - [225]      `nextInitialized`
447     // - [232..255] `extraData`
448     mapping(uint256 => uint256) private _packedOwnerships;
449 
450     // Mapping owner address to address data.
451     //
452     // Bits Layout:
453     // - [0..63]    `balance`
454     // - [64..127]  `numberMinted`
455     // - [128..191] `numberBurned`
456     // - [192..255] `aux`
457     mapping(address => uint256) private _packedAddressData;
458 
459     // Mapping from token ID to approved address.
460     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
461 
462     // Mapping from owner to operator approvals
463     mapping(address => mapping(address => bool)) private _operatorApprovals;
464 
465     // =============================================================
466     //                          CONSTRUCTOR
467     // =============================================================
468 
469     constructor(string memory name_, string memory symbol_) {
470         _name = name_;
471         _symbol = symbol_;
472         _currentIndex = _startTokenId();
473     }
474 
475     // =============================================================
476     //                   TOKEN COUNTING OPERATIONS
477     // =============================================================
478 
479     /**
480      * @dev Returns the starting token ID.
481      * To change the starting token ID, please override this function.
482      */
483     function _startTokenId() internal view virtual returns (uint256) {
484         return 0;
485     }
486 
487     /**
488      * @dev Returns the next token ID to be minted.
489      */
490     function _nextTokenId() internal view virtual returns (uint256) {
491         return _currentIndex;
492     }
493 
494     /**
495      * @dev Returns the total number of tokens in existence.
496      * Burned tokens will reduce the count.
497      * To get the total number of tokens minted, please see {_totalMinted}.
498      */
499     function totalSupply() public view virtual override returns (uint256) {
500         // Counter underflow is impossible as _burnCounter cannot be incremented
501         // more than `_currentIndex - _startTokenId()` times.
502         unchecked {
503             return _currentIndex - _burnCounter - _startTokenId();
504         }
505     }
506 
507     /**
508      * @dev Returns the total amount of tokens minted in the contract.
509      */
510     function _totalMinted() internal view virtual returns (uint256) {
511         // Counter underflow is impossible as `_currentIndex` does not decrement,
512         // and it is initialized to `_startTokenId()`.
513         unchecked {
514             return _currentIndex - _startTokenId();
515         }
516     }
517 
518     /**
519      * @dev Returns the total number of tokens burned.
520      */
521     function _totalBurned() internal view virtual returns (uint256) {
522         return _burnCounter;
523     }
524 
525     // =============================================================
526     //                    ADDRESS DATA OPERATIONS
527     // =============================================================
528 
529     /**
530      * @dev Returns the number of tokens in `owner`'s account.
531      */
532     function balanceOf(address owner) public view virtual override returns (uint256) {
533         if (owner == address(0)) revert BalanceQueryForZeroAddress();
534         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
535     }
536 
537     /**
538      * Returns the number of tokens minted by `owner`.
539      */
540     function _numberMinted(address owner) internal view returns (uint256) {
541         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
542     }
543 
544     /**
545      * Returns the number of tokens burned by or on behalf of `owner`.
546      */
547     function _numberBurned(address owner) internal view returns (uint256) {
548         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
549     }
550 
551     /**
552      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
553      */
554     function _getAux(address owner) internal view returns (uint64) {
555         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
556     }
557 
558     /**
559      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
560      * If there are multiple variables, please pack them into a uint64.
561      */
562     function _setAux(address owner, uint64 aux) internal virtual {
563         uint256 packed = _packedAddressData[owner];
564         uint256 auxCasted;
565         // Cast `aux` with assembly to avoid redundant masking.
566         assembly {
567             auxCasted := aux
568         }
569         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
570         _packedAddressData[owner] = packed;
571     }
572 
573     // =============================================================
574     //                            IERC165
575     // =============================================================
576 
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586         // The interface IDs are constants representing the first 4 bytes
587         // of the XOR of all function selectors in the interface.
588         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
589         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
590         return
591             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
592             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
593             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
594     }
595 
596     // =============================================================
597     //                        IERC721Metadata
598     // =============================================================
599 
600     /**
601      * @dev Returns the token collection name.
602      */
603     function name() public view virtual override returns (string memory) {
604         return _name;
605     }
606 
607     /**
608      * @dev Returns the token collection symbol.
609      */
610     function symbol() public view virtual override returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
618         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
619 
620         string memory baseURI = _baseURI();
621         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
622     }
623 
624     /**
625      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
626      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
627      * by default, it can be overridden in child contracts.
628      */
629     function _baseURI() internal view virtual returns (string memory) {
630         return '';
631     }
632 
633     // =============================================================
634     //                     OWNERSHIPS OPERATIONS
635     // =============================================================
636 
637     /**
638      * @dev Returns the owner of the `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         return address(uint160(_packedOwnershipOf(tokenId)));
646     }
647 
648     /**
649      * @dev Gas spent here starts off proportional to the maximum mint batch size.
650      * It gradually moves to O(1) as tokens get transferred around over time.
651      */
652     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
653         return _unpackedOwnership(_packedOwnershipOf(tokenId));
654     }
655 
656     /**
657      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
658      */
659     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
660         return _unpackedOwnership(_packedOwnerships[index]);
661     }
662 
663     /**
664      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
665      */
666     function _initializeOwnershipAt(uint256 index) internal virtual {
667         if (_packedOwnerships[index] == 0) {
668             _packedOwnerships[index] = _packedOwnershipOf(index);
669         }
670     }
671 
672     /**
673      * Returns the packed ownership data of `tokenId`.
674      */
675     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
676         uint256 curr = tokenId;
677 
678         unchecked {
679             if (_startTokenId() <= curr)
680                 if (curr < _currentIndex) {
681                     uint256 packed = _packedOwnerships[curr];
682                     // If not burned.
683                     if (packed & _BITMASK_BURNED == 0) {
684                         // Invariant:
685                         // There will always be an initialized ownership slot
686                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
687                         // before an unintialized ownership slot
688                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
689                         // Hence, `curr` will not underflow.
690                         //
691                         // We can directly compare the packed value.
692                         // If the address is zero, packed will be zero.
693                         while (packed == 0) {
694                             packed = _packedOwnerships[--curr];
695                         }
696                         return packed;
697                     }
698                 }
699         }
700         revert OwnerQueryForNonexistentToken();
701     }
702 
703     /**
704      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
705      */
706     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
707         ownership.addr = address(uint160(packed));
708         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
709         ownership.burned = packed & _BITMASK_BURNED != 0;
710         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
711     }
712 
713     /**
714      * @dev Packs ownership data into a single uint256.
715      */
716     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
717         assembly {
718             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
719             owner := and(owner, _BITMASK_ADDRESS)
720             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
721             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
722         }
723     }
724 
725     /**
726      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
727      */
728     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
729         // For branchless setting of the `nextInitialized` flag.
730         assembly {
731             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
732             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
733         }
734     }
735 
736     // =============================================================
737     //                      APPROVAL OPERATIONS
738     // =============================================================
739 
740     /**
741      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
742      * The approval is cleared when the token is transferred.
743      *
744      * Only a single account can be approved at a time, so approving the
745      * zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) public payable virtual override {
755         address owner = ownerOf(tokenId);
756 
757         if (_msgSenderERC721A() != owner)
758             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
759                 revert ApprovalCallerNotOwnerNorApproved();
760             }
761 
762         _tokenApprovals[tokenId].value = to;
763         emit Approval(owner, to, tokenId);
764     }
765 
766     /**
767      * @dev Returns the account approved for `tokenId` token.
768      *
769      * Requirements:
770      *
771      * - `tokenId` must exist.
772      */
773     function getApproved(uint256 tokenId) public view virtual override returns (address) {
774         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
775 
776         return _tokenApprovals[tokenId].value;
777     }
778 
779     /**
780      * @dev Approve or remove `operator` as an operator for the caller.
781      * Operators can call {transferFrom} or {safeTransferFrom}
782      * for any token owned by the caller.
783      *
784      * Requirements:
785      *
786      * - The `operator` cannot be the caller.
787      *
788      * Emits an {ApprovalForAll} event.
789      */
790     function setApprovalForAll(address operator, bool approved) public virtual override {
791         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
792         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
793     }
794 
795     /**
796      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
797      *
798      * See {setApprovalForAll}.
799      */
800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
801         return _operatorApprovals[owner][operator];
802     }
803 
804     /**
805      * @dev Returns whether `tokenId` exists.
806      *
807      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
808      *
809      * Tokens start existing when they are minted. See {_mint}.
810      */
811     function _exists(uint256 tokenId) internal view virtual returns (bool) {
812         return
813             _startTokenId() <= tokenId &&
814             tokenId < _currentIndex && // If within bounds,
815             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
816     }
817 
818     /**
819      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
820      */
821     function _isSenderApprovedOrOwner(
822         address approvedAddress,
823         address owner,
824         address msgSender
825     ) private pure returns (bool result) {
826         assembly {
827             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
828             owner := and(owner, _BITMASK_ADDRESS)
829             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
830             msgSender := and(msgSender, _BITMASK_ADDRESS)
831             // `msgSender == owner || msgSender == approvedAddress`.
832             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
833         }
834     }
835 
836     /**
837      * @dev Returns the storage slot and value for the approved address of `tokenId`.
838      */
839     function _getApprovedSlotAndAddress(uint256 tokenId)
840         private
841         view
842         returns (uint256 approvedAddressSlot, address approvedAddress)
843     {
844         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
845         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
846         assembly {
847             approvedAddressSlot := tokenApproval.slot
848             approvedAddress := sload(approvedAddressSlot)
849         }
850     }
851 
852     // =============================================================
853     //                      TRANSFER OPERATIONS
854     // =============================================================
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token
865      * by either {approve} or {setApprovalForAll}.
866      *
867      * Emits a {Transfer} event.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public payable virtual override {
874         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
875 
876         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
877 
878         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
879 
880         // The nested ifs save around 20+ gas over a compound boolean condition.
881         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
882             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
883 
884         if (to == address(0)) revert TransferToZeroAddress();
885 
886         _beforeTokenTransfers(from, to, tokenId, 1);
887 
888         // Clear approvals from the previous owner.
889         assembly {
890             if approvedAddress {
891                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
892                 sstore(approvedAddressSlot, 0)
893             }
894         }
895 
896         // Underflow of the sender's balance is impossible because we check for
897         // ownership above and the recipient's balance can't realistically overflow.
898         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
899         unchecked {
900             // We can directly increment and decrement the balances.
901             --_packedAddressData[from]; // Updates: `balance -= 1`.
902             ++_packedAddressData[to]; // Updates: `balance += 1`.
903 
904             // Updates:
905             // - `address` to the next owner.
906             // - `startTimestamp` to the timestamp of transfering.
907             // - `burned` to `false`.
908             // - `nextInitialized` to `true`.
909             _packedOwnerships[tokenId] = _packOwnershipData(
910                 to,
911                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
912             );
913 
914             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
915             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
916                 uint256 nextTokenId = tokenId + 1;
917                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
918                 if (_packedOwnerships[nextTokenId] == 0) {
919                     // If the next slot is within bounds.
920                     if (nextTokenId != _currentIndex) {
921                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
922                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
923                     }
924                 }
925             }
926         }
927 
928         emit Transfer(from, to, tokenId);
929         _afterTokenTransfers(from, to, tokenId, 1);
930     }
931 
932     /**
933      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public payable virtual override {
940         safeTransferFrom(from, to, tokenId, '');
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If the caller is not `from`, it must be approved to move this token
952      * by either {approve} or {setApprovalForAll}.
953      * - If `to` refers to a smart contract, it must implement
954      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public payable virtual override {
964         transferFrom(from, to, tokenId);
965         if (to.code.length != 0)
966             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
967                 revert TransferToNonERC721ReceiverImplementer();
968             }
969     }
970 
971     /**
972      * @dev Hook that is called before a set of serially-ordered token IDs
973      * are about to be transferred. This includes minting.
974      * And also called before burning one token.
975      *
976      * `startTokenId` - the first token ID to be transferred.
977      * `quantity` - the amount to be transferred.
978      *
979      * Calling conditions:
980      *
981      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
982      * transferred to `to`.
983      * - When `from` is zero, `tokenId` will be minted for `to`.
984      * - When `to` is zero, `tokenId` will be burned by `from`.
985      * - `from` and `to` are never both zero.
986      */
987     function _beforeTokenTransfers(
988         address from,
989         address to,
990         uint256 startTokenId,
991         uint256 quantity
992     ) internal virtual {}
993 
994     /**
995      * @dev Hook that is called after a set of serially-ordered token IDs
996      * have been transferred. This includes minting.
997      * And also called after one token has been burned.
998      *
999      * `startTokenId` - the first token ID to be transferred.
1000      * `quantity` - the amount to be transferred.
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` has been minted for `to`.
1007      * - When `to` is zero, `tokenId` has been burned by `from`.
1008      * - `from` and `to` are never both zero.
1009      */
1010     function _afterTokenTransfers(
1011         address from,
1012         address to,
1013         uint256 startTokenId,
1014         uint256 quantity
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1019      *
1020      * `from` - Previous owner of the given token ID.
1021      * `to` - Target address that will receive the token.
1022      * `tokenId` - Token ID to be transferred.
1023      * `_data` - Optional data to send along with the call.
1024      *
1025      * Returns whether the call correctly returned the expected magic value.
1026      */
1027     function _checkContractOnERC721Received(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) private returns (bool) {
1033         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1034             bytes4 retval
1035         ) {
1036             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1037         } catch (bytes memory reason) {
1038             if (reason.length == 0) {
1039                 revert TransferToNonERC721ReceiverImplementer();
1040             } else {
1041                 assembly {
1042                     revert(add(32, reason), mload(reason))
1043                 }
1044             }
1045         }
1046     }
1047 
1048     // =============================================================
1049     //                        MINT OPERATIONS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event for each mint.
1061      */
1062     function _mint(address to, uint256 quantity) internal virtual {
1063         uint256 startTokenId = _currentIndex;
1064         if (quantity == 0) revert MintZeroQuantity();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // `balance` and `numberMinted` have a maximum limit of 2**64.
1070         // `tokenId` has a maximum limit of 2**256.
1071         unchecked {
1072             // Updates:
1073             // - `balance += quantity`.
1074             // - `numberMinted += quantity`.
1075             //
1076             // We can directly add to the `balance` and `numberMinted`.
1077             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1078 
1079             // Updates:
1080             // - `address` to the owner.
1081             // - `startTimestamp` to the timestamp of minting.
1082             // - `burned` to `false`.
1083             // - `nextInitialized` to `quantity == 1`.
1084             _packedOwnerships[startTokenId] = _packOwnershipData(
1085                 to,
1086                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1087             );
1088 
1089             uint256 toMasked;
1090             uint256 end = startTokenId + quantity;
1091 
1092             // Use assembly to loop and emit the `Transfer` event for gas savings.
1093             // The duplicated `log4` removes an extra check and reduces stack juggling.
1094             // The assembly, together with the surrounding Solidity code, have been
1095             // delicately arranged to nudge the compiler into producing optimized opcodes.
1096             assembly {
1097                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1098                 toMasked := and(to, _BITMASK_ADDRESS)
1099                 // Emit the `Transfer` event.
1100                 log4(
1101                     0, // Start of data (0, since no data).
1102                     0, // End of data (0, since no data).
1103                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1104                     0, // `address(0)`.
1105                     toMasked, // `to`.
1106                     startTokenId // `tokenId`.
1107                 )
1108 
1109                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1110                 // that overflows uint256 will make the loop run out of gas.
1111                 // The compiler will optimize the `iszero` away for performance.
1112                 for {
1113                     let tokenId := add(startTokenId, 1)
1114                 } iszero(eq(tokenId, end)) {
1115                     tokenId := add(tokenId, 1)
1116                 } {
1117                     // Emit the `Transfer` event. Similar to above.
1118                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1119                 }
1120             }
1121             if (toMasked == 0) revert MintToZeroAddress();
1122 
1123             _currentIndex = end;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * This function is intended for efficient minting only during contract creation.
1132      *
1133      * It emits only one {ConsecutiveTransfer} as defined in
1134      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1135      * instead of a sequence of {Transfer} event(s).
1136      *
1137      * Calling this function outside of contract creation WILL make your contract
1138      * non-compliant with the ERC721 standard.
1139      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1140      * {ConsecutiveTransfer} event is only permissible during contract creation.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * Emits a {ConsecutiveTransfer} event.
1148      */
1149     function _mintERC2309(address to, uint256 quantity) internal virtual {
1150         uint256 startTokenId = _currentIndex;
1151         if (to == address(0)) revert MintToZeroAddress();
1152         if (quantity == 0) revert MintZeroQuantity();
1153         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1154 
1155         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1156 
1157         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1158         unchecked {
1159             // Updates:
1160             // - `balance += quantity`.
1161             // - `numberMinted += quantity`.
1162             //
1163             // We can directly add to the `balance` and `numberMinted`.
1164             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1165 
1166             // Updates:
1167             // - `address` to the owner.
1168             // - `startTimestamp` to the timestamp of minting.
1169             // - `burned` to `false`.
1170             // - `nextInitialized` to `quantity == 1`.
1171             _packedOwnerships[startTokenId] = _packOwnershipData(
1172                 to,
1173                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1174             );
1175 
1176             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1177 
1178             _currentIndex = startTokenId + quantity;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - If `to` refers to a smart contract, it must implement
1189      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1190      * - `quantity` must be greater than 0.
1191      *
1192      * See {_mint}.
1193      *
1194      * Emits a {Transfer} event for each mint.
1195      */
1196     function _safeMint(
1197         address to,
1198         uint256 quantity,
1199         bytes memory _data
1200     ) internal virtual {
1201         _mint(to, quantity);
1202 
1203         unchecked {
1204             if (to.code.length != 0) {
1205                 uint256 end = _currentIndex;
1206                 uint256 index = end - quantity;
1207                 do {
1208                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1209                         revert TransferToNonERC721ReceiverImplementer();
1210                     }
1211                 } while (index < end);
1212                 // Reentrancy protection.
1213                 if (_currentIndex != end) revert();
1214             }
1215         }
1216     }
1217 
1218     /**
1219      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1220      */
1221     function _safeMint(address to, uint256 quantity) internal virtual {
1222         _safeMint(to, quantity, '');
1223     }
1224 
1225     // =============================================================
1226     //                        BURN OPERATIONS
1227     // =============================================================
1228 
1229     /**
1230      * @dev Equivalent to `_burn(tokenId, false)`.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         _burn(tokenId, false);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1247         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1248 
1249         address from = address(uint160(prevOwnershipPacked));
1250 
1251         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1252 
1253         if (approvalCheck) {
1254             // The nested ifs save around 20+ gas over a compound boolean condition.
1255             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1256                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1257         }
1258 
1259         _beforeTokenTransfers(from, address(0), tokenId, 1);
1260 
1261         // Clear approvals from the previous owner.
1262         assembly {
1263             if approvedAddress {
1264                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1265                 sstore(approvedAddressSlot, 0)
1266             }
1267         }
1268 
1269         // Underflow of the sender's balance is impossible because we check for
1270         // ownership above and the recipient's balance can't realistically overflow.
1271         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1272         unchecked {
1273             // Updates:
1274             // - `balance -= 1`.
1275             // - `numberBurned += 1`.
1276             //
1277             // We can directly decrement the balance, and increment the number burned.
1278             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1279             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1280 
1281             // Updates:
1282             // - `address` to the last owner.
1283             // - `startTimestamp` to the timestamp of burning.
1284             // - `burned` to `true`.
1285             // - `nextInitialized` to `true`.
1286             _packedOwnerships[tokenId] = _packOwnershipData(
1287                 from,
1288                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1289             );
1290 
1291             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1292             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
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
1305         emit Transfer(from, address(0), tokenId);
1306         _afterTokenTransfers(from, address(0), tokenId, 1);
1307 
1308         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1309         unchecked {
1310             _burnCounter++;
1311         }
1312     }
1313 
1314     // =============================================================
1315     //                     EXTRA DATA OPERATIONS
1316     // =============================================================
1317 
1318     /**
1319      * @dev Directly sets the extra data for the ownership data `index`.
1320      */
1321     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1322         uint256 packed = _packedOwnerships[index];
1323         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1324         uint256 extraDataCasted;
1325         // Cast `extraData` with assembly to avoid redundant masking.
1326         assembly {
1327             extraDataCasted := extraData
1328         }
1329         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1330         _packedOwnerships[index] = packed;
1331     }
1332 
1333     /**
1334      * @dev Called during each token transfer to set the 24bit `extraData` field.
1335      * Intended to be overridden by the cosumer contract.
1336      *
1337      * `previousExtraData` - the value of `extraData` before transfer.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, `tokenId` will be burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _extraData(
1348         address from,
1349         address to,
1350         uint24 previousExtraData
1351     ) internal view virtual returns (uint24) {}
1352 
1353     /**
1354      * @dev Returns the next extra data for the packed ownership data.
1355      * The returned result is shifted into position.
1356      */
1357     function _nextExtraData(
1358         address from,
1359         address to,
1360         uint256 prevOwnershipPacked
1361     ) private view returns (uint256) {
1362         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1363         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1364     }
1365 
1366     // =============================================================
1367     //                       OTHER OPERATIONS
1368     // =============================================================
1369 
1370     /**
1371      * @dev Returns the message sender (defaults to `msg.sender`).
1372      *
1373      * If you are writing GSN compatible contracts, you need to override this function.
1374      */
1375     function _msgSenderERC721A() internal view virtual returns (address) {
1376         return msg.sender;
1377     }
1378 
1379     /**
1380      * @dev Converts a uint256 to its ASCII string decimal representation.
1381      */
1382     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1383         assembly {
1384             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1385             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1386             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1387             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1388             let m := add(mload(0x40), 0xa0)
1389             // Update the free memory pointer to allocate.
1390             mstore(0x40, m)
1391             // Assign the `str` to the end.
1392             str := sub(m, 0x20)
1393             // Zeroize the slot after the string.
1394             mstore(str, 0)
1395 
1396             // Cache the end of the memory to calculate the length later.
1397             let end := str
1398 
1399             // We write the string from rightmost digit to leftmost digit.
1400             // The following is essentially a do-while loop that also handles the zero case.
1401             // prettier-ignore
1402             for { let temp := value } 1 {} {
1403                 str := sub(str, 1)
1404                 // Write the character to the pointer.
1405                 // The ASCII index of the '0' character is 48.
1406                 mstore8(str, add(48, mod(temp, 10)))
1407                 // Keep dividing `temp` until zero.
1408                 temp := div(temp, 10)
1409                 // prettier-ignore
1410                 if iszero(temp) { break }
1411             }
1412 
1413             let length := sub(end, str)
1414             // Move the pointer 32 bytes leftwards to make room for the length.
1415             str := sub(str, 0x20)
1416             // Store the length.
1417             mstore(str, length)
1418         }
1419     }
1420 }
1421 
1422 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1423 
1424 
1425 // ERC721A Contracts v4.2.3
1426 // Creator: Chiru Labs
1427 
1428 pragma solidity ^0.8.4;
1429 
1430 
1431 /**
1432  * @dev Interface of ERC721AQueryable.
1433  */
1434 interface IERC721AQueryable is IERC721A {
1435     /**
1436      * Invalid query range (`start` >= `stop`).
1437      */
1438     error InvalidQueryRange();
1439 
1440     /**
1441      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1442      *
1443      * If the `tokenId` is out of bounds:
1444      *
1445      * - `addr = address(0)`
1446      * - `startTimestamp = 0`
1447      * - `burned = false`
1448      * - `extraData = 0`
1449      *
1450      * If the `tokenId` is burned:
1451      *
1452      * - `addr = <Address of owner before token was burned>`
1453      * - `startTimestamp = <Timestamp when token was burned>`
1454      * - `burned = true`
1455      * - `extraData = <Extra data when token was burned>`
1456      *
1457      * Otherwise:
1458      *
1459      * - `addr = <Address of owner>`
1460      * - `startTimestamp = <Timestamp of start of ownership>`
1461      * - `burned = false`
1462      * - `extraData = <Extra data at start of ownership>`
1463      */
1464     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1465 
1466     /**
1467      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1468      * See {ERC721AQueryable-explicitOwnershipOf}
1469      */
1470     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1471 
1472     /**
1473      * @dev Returns an array of token IDs owned by `owner`,
1474      * in the range [`start`, `stop`)
1475      * (i.e. `start <= tokenId < stop`).
1476      *
1477      * This function allows for tokens to be queried if the collection
1478      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1479      *
1480      * Requirements:
1481      *
1482      * - `start < stop`
1483      */
1484     function tokensOfOwnerIn(
1485         address owner,
1486         uint256 start,
1487         uint256 stop
1488     ) external view returns (uint256[] memory);
1489 
1490     /**
1491      * @dev Returns an array of token IDs owned by `owner`.
1492      *
1493      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1494      * It is meant to be called off-chain.
1495      *
1496      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1497      * multiple smaller scans if the collection is large enough to cause
1498      * an out-of-gas error (10K collections should be fine).
1499      */
1500     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1501 }
1502 
1503 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1504 
1505 
1506 // ERC721A Contracts v4.2.3
1507 // Creator: Chiru Labs
1508 
1509 pragma solidity ^0.8.4;
1510 
1511 
1512 
1513 /**
1514  * @title ERC721AQueryable.
1515  *
1516  * @dev ERC721A subclass with convenience query functions.
1517  */
1518 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1519     /**
1520      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1521      *
1522      * If the `tokenId` is out of bounds:
1523      *
1524      * - `addr = address(0)`
1525      * - `startTimestamp = 0`
1526      * - `burned = false`
1527      * - `extraData = 0`
1528      *
1529      * If the `tokenId` is burned:
1530      *
1531      * - `addr = <Address of owner before token was burned>`
1532      * - `startTimestamp = <Timestamp when token was burned>`
1533      * - `burned = true`
1534      * - `extraData = <Extra data when token was burned>`
1535      *
1536      * Otherwise:
1537      *
1538      * - `addr = <Address of owner>`
1539      * - `startTimestamp = <Timestamp of start of ownership>`
1540      * - `burned = false`
1541      * - `extraData = <Extra data at start of ownership>`
1542      */
1543     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1544         TokenOwnership memory ownership;
1545         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1546             return ownership;
1547         }
1548         ownership = _ownershipAt(tokenId);
1549         if (ownership.burned) {
1550             return ownership;
1551         }
1552         return _ownershipOf(tokenId);
1553     }
1554 
1555     /**
1556      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1557      * See {ERC721AQueryable-explicitOwnershipOf}
1558      */
1559     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1560         external
1561         view
1562         virtual
1563         override
1564         returns (TokenOwnership[] memory)
1565     {
1566         unchecked {
1567             uint256 tokenIdsLength = tokenIds.length;
1568             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1569             for (uint256 i; i != tokenIdsLength; ++i) {
1570                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1571             }
1572             return ownerships;
1573         }
1574     }
1575 
1576     /**
1577      * @dev Returns an array of token IDs owned by `owner`,
1578      * in the range [`start`, `stop`)
1579      * (i.e. `start <= tokenId < stop`).
1580      *
1581      * This function allows for tokens to be queried if the collection
1582      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1583      *
1584      * Requirements:
1585      *
1586      * - `start < stop`
1587      */
1588     function tokensOfOwnerIn(
1589         address owner,
1590         uint256 start,
1591         uint256 stop
1592     ) external view virtual override returns (uint256[] memory) {
1593         unchecked {
1594             if (start >= stop) revert InvalidQueryRange();
1595             uint256 tokenIdsIdx;
1596             uint256 stopLimit = _nextTokenId();
1597             // Set `start = max(start, _startTokenId())`.
1598             if (start < _startTokenId()) {
1599                 start = _startTokenId();
1600             }
1601             // Set `stop = min(stop, stopLimit)`.
1602             if (stop > stopLimit) {
1603                 stop = stopLimit;
1604             }
1605             uint256 tokenIdsMaxLength = balanceOf(owner);
1606             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1607             // to cater for cases where `balanceOf(owner)` is too big.
1608             if (start < stop) {
1609                 uint256 rangeLength = stop - start;
1610                 if (rangeLength < tokenIdsMaxLength) {
1611                     tokenIdsMaxLength = rangeLength;
1612                 }
1613             } else {
1614                 tokenIdsMaxLength = 0;
1615             }
1616             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1617             if (tokenIdsMaxLength == 0) {
1618                 return tokenIds;
1619             }
1620             // We need to call `explicitOwnershipOf(start)`,
1621             // because the slot at `start` may not be initialized.
1622             TokenOwnership memory ownership = explicitOwnershipOf(start);
1623             address currOwnershipAddr;
1624             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1625             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1626             if (!ownership.burned) {
1627                 currOwnershipAddr = ownership.addr;
1628             }
1629             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1630                 ownership = _ownershipAt(i);
1631                 if (ownership.burned) {
1632                     continue;
1633                 }
1634                 if (ownership.addr != address(0)) {
1635                     currOwnershipAddr = ownership.addr;
1636                 }
1637                 if (currOwnershipAddr == owner) {
1638                     tokenIds[tokenIdsIdx++] = i;
1639                 }
1640             }
1641             // Downsize the array to fit.
1642             assembly {
1643                 mstore(tokenIds, tokenIdsIdx)
1644             }
1645             return tokenIds;
1646         }
1647     }
1648 
1649     /**
1650      * @dev Returns an array of token IDs owned by `owner`.
1651      *
1652      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1653      * It is meant to be called off-chain.
1654      *
1655      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1656      * multiple smaller scans if the collection is large enough to cause
1657      * an out-of-gas error (10K collections should be fine).
1658      */
1659     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1660         unchecked {
1661             uint256 tokenIdsIdx;
1662             address currOwnershipAddr;
1663             uint256 tokenIdsLength = balanceOf(owner);
1664             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1665             TokenOwnership memory ownership;
1666             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1667                 ownership = _ownershipAt(i);
1668                 if (ownership.burned) {
1669                     continue;
1670                 }
1671                 if (ownership.addr != address(0)) {
1672                     currOwnershipAddr = ownership.addr;
1673                 }
1674                 if (currOwnershipAddr == owner) {
1675                     tokenIds[tokenIdsIdx++] = i;
1676                 }
1677             }
1678             return tokenIds;
1679         }
1680     }
1681 }
1682 
1683 // File: @openzeppelin/contracts/utils/math/Math.sol
1684 
1685 
1686 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1687 
1688 pragma solidity ^0.8.0;
1689 
1690 /**
1691  * @dev Standard math utilities missing in the Solidity language.
1692  */
1693 library Math {
1694     enum Rounding {
1695         Down, // Toward negative infinity
1696         Up, // Toward infinity
1697         Zero // Toward zero
1698     }
1699 
1700     /**
1701      * @dev Returns the largest of two numbers.
1702      */
1703     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1704         return a > b ? a : b;
1705     }
1706 
1707     /**
1708      * @dev Returns the smallest of two numbers.
1709      */
1710     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1711         return a < b ? a : b;
1712     }
1713 
1714     /**
1715      * @dev Returns the average of two numbers. The result is rounded towards
1716      * zero.
1717      */
1718     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1719         // (a + b) / 2 can overflow.
1720         return (a & b) + (a ^ b) / 2;
1721     }
1722 
1723     /**
1724      * @dev Returns the ceiling of the division of two numbers.
1725      *
1726      * This differs from standard division with `/` in that it rounds up instead
1727      * of rounding down.
1728      */
1729     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1730         // (a + b - 1) / b can overflow on addition, so we distribute.
1731         return a == 0 ? 0 : (a - 1) / b + 1;
1732     }
1733 
1734     /**
1735      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1736      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1737      * with further edits by Uniswap Labs also under MIT license.
1738      */
1739     function mulDiv(
1740         uint256 x,
1741         uint256 y,
1742         uint256 denominator
1743     ) internal pure returns (uint256 result) {
1744         unchecked {
1745             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1746             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1747             // variables such that product = prod1 * 2^256 + prod0.
1748             uint256 prod0; // Least significant 256 bits of the product
1749             uint256 prod1; // Most significant 256 bits of the product
1750             assembly {
1751                 let mm := mulmod(x, y, not(0))
1752                 prod0 := mul(x, y)
1753                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1754             }
1755 
1756             // Handle non-overflow cases, 256 by 256 division.
1757             if (prod1 == 0) {
1758                 return prod0 / denominator;
1759             }
1760 
1761             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1762             require(denominator > prod1);
1763 
1764             ///////////////////////////////////////////////
1765             // 512 by 256 division.
1766             ///////////////////////////////////////////////
1767 
1768             // Make division exact by subtracting the remainder from [prod1 prod0].
1769             uint256 remainder;
1770             assembly {
1771                 // Compute remainder using mulmod.
1772                 remainder := mulmod(x, y, denominator)
1773 
1774                 // Subtract 256 bit number from 512 bit number.
1775                 prod1 := sub(prod1, gt(remainder, prod0))
1776                 prod0 := sub(prod0, remainder)
1777             }
1778 
1779             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1780             // See https://cs.stackexchange.com/q/138556/92363.
1781 
1782             // Does not overflow because the denominator cannot be zero at this stage in the function.
1783             uint256 twos = denominator & (~denominator + 1);
1784             assembly {
1785                 // Divide denominator by twos.
1786                 denominator := div(denominator, twos)
1787 
1788                 // Divide [prod1 prod0] by twos.
1789                 prod0 := div(prod0, twos)
1790 
1791                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1792                 twos := add(div(sub(0, twos), twos), 1)
1793             }
1794 
1795             // Shift in bits from prod1 into prod0.
1796             prod0 |= prod1 * twos;
1797 
1798             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1799             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1800             // four bits. That is, denominator * inv = 1 mod 2^4.
1801             uint256 inverse = (3 * denominator) ^ 2;
1802 
1803             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1804             // in modular arithmetic, doubling the correct bits in each step.
1805             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1806             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1807             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1808             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1809             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1810             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1811 
1812             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1813             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1814             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1815             // is no longer required.
1816             result = prod0 * inverse;
1817             return result;
1818         }
1819     }
1820 
1821     /**
1822      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1823      */
1824     function mulDiv(
1825         uint256 x,
1826         uint256 y,
1827         uint256 denominator,
1828         Rounding rounding
1829     ) internal pure returns (uint256) {
1830         uint256 result = mulDiv(x, y, denominator);
1831         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1832             result += 1;
1833         }
1834         return result;
1835     }
1836 
1837     /**
1838      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1839      *
1840      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1841      */
1842     function sqrt(uint256 a) internal pure returns (uint256) {
1843         if (a == 0) {
1844             return 0;
1845         }
1846 
1847         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1848         //
1849         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1850         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1851         //
1852         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1853         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1854         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1855         //
1856         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1857         uint256 result = 1 << (log2(a) >> 1);
1858 
1859         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1860         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1861         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1862         // into the expected uint128 result.
1863         unchecked {
1864             result = (result + a / result) >> 1;
1865             result = (result + a / result) >> 1;
1866             result = (result + a / result) >> 1;
1867             result = (result + a / result) >> 1;
1868             result = (result + a / result) >> 1;
1869             result = (result + a / result) >> 1;
1870             result = (result + a / result) >> 1;
1871             return min(result, a / result);
1872         }
1873     }
1874 
1875     /**
1876      * @notice Calculates sqrt(a), following the selected rounding direction.
1877      */
1878     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1879         unchecked {
1880             uint256 result = sqrt(a);
1881             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1882         }
1883     }
1884 
1885     /**
1886      * @dev Return the log in base 2, rounded down, of a positive value.
1887      * Returns 0 if given 0.
1888      */
1889     function log2(uint256 value) internal pure returns (uint256) {
1890         uint256 result = 0;
1891         unchecked {
1892             if (value >> 128 > 0) {
1893                 value >>= 128;
1894                 result += 128;
1895             }
1896             if (value >> 64 > 0) {
1897                 value >>= 64;
1898                 result += 64;
1899             }
1900             if (value >> 32 > 0) {
1901                 value >>= 32;
1902                 result += 32;
1903             }
1904             if (value >> 16 > 0) {
1905                 value >>= 16;
1906                 result += 16;
1907             }
1908             if (value >> 8 > 0) {
1909                 value >>= 8;
1910                 result += 8;
1911             }
1912             if (value >> 4 > 0) {
1913                 value >>= 4;
1914                 result += 4;
1915             }
1916             if (value >> 2 > 0) {
1917                 value >>= 2;
1918                 result += 2;
1919             }
1920             if (value >> 1 > 0) {
1921                 result += 1;
1922             }
1923         }
1924         return result;
1925     }
1926 
1927     /**
1928      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1929      * Returns 0 if given 0.
1930      */
1931     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1932         unchecked {
1933             uint256 result = log2(value);
1934             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1935         }
1936     }
1937 
1938     /**
1939      * @dev Return the log in base 10, rounded down, of a positive value.
1940      * Returns 0 if given 0.
1941      */
1942     function log10(uint256 value) internal pure returns (uint256) {
1943         uint256 result = 0;
1944         unchecked {
1945             if (value >= 10**64) {
1946                 value /= 10**64;
1947                 result += 64;
1948             }
1949             if (value >= 10**32) {
1950                 value /= 10**32;
1951                 result += 32;
1952             }
1953             if (value >= 10**16) {
1954                 value /= 10**16;
1955                 result += 16;
1956             }
1957             if (value >= 10**8) {
1958                 value /= 10**8;
1959                 result += 8;
1960             }
1961             if (value >= 10**4) {
1962                 value /= 10**4;
1963                 result += 4;
1964             }
1965             if (value >= 10**2) {
1966                 value /= 10**2;
1967                 result += 2;
1968             }
1969             if (value >= 10**1) {
1970                 result += 1;
1971             }
1972         }
1973         return result;
1974     }
1975 
1976     /**
1977      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1978      * Returns 0 if given 0.
1979      */
1980     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1981         unchecked {
1982             uint256 result = log10(value);
1983             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1984         }
1985     }
1986 
1987     /**
1988      * @dev Return the log in base 256, rounded down, of a positive value.
1989      * Returns 0 if given 0.
1990      *
1991      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1992      */
1993     function log256(uint256 value) internal pure returns (uint256) {
1994         uint256 result = 0;
1995         unchecked {
1996             if (value >> 128 > 0) {
1997                 value >>= 128;
1998                 result += 16;
1999             }
2000             if (value >> 64 > 0) {
2001                 value >>= 64;
2002                 result += 8;
2003             }
2004             if (value >> 32 > 0) {
2005                 value >>= 32;
2006                 result += 4;
2007             }
2008             if (value >> 16 > 0) {
2009                 value >>= 16;
2010                 result += 2;
2011             }
2012             if (value >> 8 > 0) {
2013                 result += 1;
2014             }
2015         }
2016         return result;
2017     }
2018 
2019     /**
2020      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2021      * Returns 0 if given 0.
2022      */
2023     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2024         unchecked {
2025             uint256 result = log256(value);
2026             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2027         }
2028     }
2029 }
2030 
2031 // File: @openzeppelin/contracts/utils/Strings.sol
2032 
2033 
2034 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2035 
2036 pragma solidity ^0.8.0;
2037 
2038 
2039 /**
2040  * @dev String operations.
2041  */
2042 library Strings {
2043     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2044     uint8 private constant _ADDRESS_LENGTH = 20;
2045 
2046     /**
2047      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2048      */
2049     function toString(uint256 value) internal pure returns (string memory) {
2050         unchecked {
2051             uint256 length = Math.log10(value) + 1;
2052             string memory buffer = new string(length);
2053             uint256 ptr;
2054             /// @solidity memory-safe-assembly
2055             assembly {
2056                 ptr := add(buffer, add(32, length))
2057             }
2058             while (true) {
2059                 ptr--;
2060                 /// @solidity memory-safe-assembly
2061                 assembly {
2062                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2063                 }
2064                 value /= 10;
2065                 if (value == 0) break;
2066             }
2067             return buffer;
2068         }
2069     }
2070 
2071     /**
2072      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2073      */
2074     function toHexString(uint256 value) internal pure returns (string memory) {
2075         unchecked {
2076             return toHexString(value, Math.log256(value) + 1);
2077         }
2078     }
2079 
2080     /**
2081      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2082      */
2083     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2084         bytes memory buffer = new bytes(2 * length + 2);
2085         buffer[0] = "0";
2086         buffer[1] = "x";
2087         for (uint256 i = 2 * length + 1; i > 1; --i) {
2088             buffer[i] = _SYMBOLS[value & 0xf];
2089             value >>= 4;
2090         }
2091         require(value == 0, "Strings: hex length insufficient");
2092         return string(buffer);
2093     }
2094 
2095     /**
2096      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2097      */
2098     function toHexString(address addr) internal pure returns (string memory) {
2099         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2100     }
2101 }
2102 
2103 // File: @openzeppelin/contracts/utils/StorageSlot.sol
2104 
2105 
2106 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
2107 
2108 pragma solidity ^0.8.0;
2109 
2110 /**
2111  * @dev Library for reading and writing primitive types to specific storage slots.
2112  *
2113  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
2114  * This library helps with reading and writing to such slots without the need for inline assembly.
2115  *
2116  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
2117  *
2118  * Example usage to set ERC1967 implementation slot:
2119  * ```
2120  * contract ERC1967 {
2121  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
2122  *
2123  *     function _getImplementation() internal view returns (address) {
2124  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
2125  *     }
2126  *
2127  *     function _setImplementation(address newImplementation) internal {
2128  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
2129  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
2130  *     }
2131  * }
2132  * ```
2133  *
2134  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
2135  */
2136 library StorageSlot {
2137     struct AddressSlot {
2138         address value;
2139     }
2140 
2141     struct BooleanSlot {
2142         bool value;
2143     }
2144 
2145     struct Bytes32Slot {
2146         bytes32 value;
2147     }
2148 
2149     struct Uint256Slot {
2150         uint256 value;
2151     }
2152 
2153     /**
2154      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
2155      */
2156     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
2157         /// @solidity memory-safe-assembly
2158         assembly {
2159             r.slot := slot
2160         }
2161     }
2162 
2163     /**
2164      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
2165      */
2166     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
2167         /// @solidity memory-safe-assembly
2168         assembly {
2169             r.slot := slot
2170         }
2171     }
2172 
2173     /**
2174      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
2175      */
2176     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
2177         /// @solidity memory-safe-assembly
2178         assembly {
2179             r.slot := slot
2180         }
2181     }
2182 
2183     /**
2184      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
2185      */
2186     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
2187         /// @solidity memory-safe-assembly
2188         assembly {
2189             r.slot := slot
2190         }
2191     }
2192 }
2193 
2194 // File: @openzeppelin/contracts/utils/Arrays.sol
2195 
2196 
2197 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Arrays.sol)
2198 
2199 pragma solidity ^0.8.0;
2200 
2201 
2202 
2203 /**
2204  * @dev Collection of functions related to array types.
2205  */
2206 library Arrays {
2207     using StorageSlot for bytes32;
2208 
2209     /**
2210      * @dev Searches a sorted `array` and returns the first index that contains
2211      * a value greater or equal to `element`. If no such index exists (i.e. all
2212      * values in the array are strictly less than `element`), the array length is
2213      * returned. Time complexity O(log n).
2214      *
2215      * `array` is expected to be sorted in ascending order, and to contain no
2216      * repeated elements.
2217      */
2218     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
2219         if (array.length == 0) {
2220             return 0;
2221         }
2222 
2223         uint256 low = 0;
2224         uint256 high = array.length;
2225 
2226         while (low < high) {
2227             uint256 mid = Math.average(low, high);
2228 
2229             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
2230             // because Math.average rounds down (it does integer division with truncation).
2231             if (unsafeAccess(array, mid).value > element) {
2232                 high = mid;
2233             } else {
2234                 low = mid + 1;
2235             }
2236         }
2237 
2238         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
2239         if (low > 0 && unsafeAccess(array, low - 1).value == element) {
2240             return low - 1;
2241         } else {
2242             return low;
2243         }
2244     }
2245 
2246     /**
2247      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2248      *
2249      * WARNING: Only use if you are certain `pos` is lower than the array length.
2250      */
2251     function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
2252         bytes32 slot;
2253         /// @solidity memory-safe-assembly
2254         assembly {
2255             mstore(0, arr.slot)
2256             slot := add(keccak256(0, 0x20), pos)
2257         }
2258         return slot.getAddressSlot();
2259     }
2260 
2261     /**
2262      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2263      *
2264      * WARNING: Only use if you are certain `pos` is lower than the array length.
2265      */
2266     function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
2267         bytes32 slot;
2268         /// @solidity memory-safe-assembly
2269         assembly {
2270             mstore(0, arr.slot)
2271             slot := add(keccak256(0, 0x20), pos)
2272         }
2273         return slot.getBytes32Slot();
2274     }
2275 
2276     /**
2277      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
2278      *
2279      * WARNING: Only use if you are certain `pos` is lower than the array length.
2280      */
2281     function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
2282         bytes32 slot;
2283         /// @solidity memory-safe-assembly
2284         assembly {
2285             mstore(0, arr.slot)
2286             slot := add(keccak256(0, 0x20), pos)
2287         }
2288         return slot.getUint256Slot();
2289     }
2290 }
2291 
2292 // File: @openzeppelin/contracts/utils/Context.sol
2293 
2294 
2295 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2296 
2297 pragma solidity ^0.8.0;
2298 
2299 /**
2300  * @dev Provides information about the current execution context, including the
2301  * sender of the transaction and its data. While these are generally available
2302  * via msg.sender and msg.data, they should not be accessed in such a direct
2303  * manner, since when dealing with meta-transactions the account sending and
2304  * paying for execution may not be the actual sender (as far as an application
2305  * is concerned).
2306  *
2307  * This contract is only required for intermediate, library-like contracts.
2308  */
2309 abstract contract Context {
2310     function _msgSender() internal view virtual returns (address) {
2311         return msg.sender;
2312     }
2313 
2314     function _msgData() internal view virtual returns (bytes calldata) {
2315         return msg.data;
2316     }
2317 }
2318 
2319 // File: @openzeppelin/contracts/access/Ownable.sol
2320 
2321 
2322 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2323 
2324 pragma solidity ^0.8.0;
2325 
2326 
2327 /**
2328  * @dev Contract module which provides a basic access control mechanism, where
2329  * there is an account (an owner) that can be granted exclusive access to
2330  * specific functions.
2331  *
2332  * By default, the owner account will be the one that deploys the contract. This
2333  * can later be changed with {transferOwnership}.
2334  *
2335  * This module is used through inheritance. It will make available the modifier
2336  * `onlyOwner`, which can be applied to your functions to restrict their use to
2337  * the owner.
2338  */
2339 abstract contract Ownable is Context {
2340     address private _owner;
2341 
2342     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2343 
2344     /**
2345      * @dev Initializes the contract setting the deployer as the initial owner.
2346      */
2347     constructor() {
2348         _transferOwnership(_msgSender());
2349     }
2350 
2351     /**
2352      * @dev Throws if called by any account other than the owner.
2353      */
2354     modifier onlyOwner() {
2355         _checkOwner();
2356         _;
2357     }
2358 
2359     /**
2360      * @dev Returns the address of the current owner.
2361      */
2362     function owner() public view virtual returns (address) {
2363         return _owner;
2364     }
2365 
2366     /**
2367      * @dev Throws if the sender is not the owner.
2368      */
2369     function _checkOwner() internal view virtual {
2370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2371     }
2372 
2373     /**
2374      * @dev Leaves the contract without owner. It will not be possible to call
2375      * `onlyOwner` functions anymore. Can only be called by the current owner.
2376      *
2377      * NOTE: Renouncing ownership will leave the contract without an owner,
2378      * thereby removing any functionality that is only available to the owner.
2379      */
2380     function renounceOwnership() public virtual onlyOwner {
2381         _transferOwnership(address(0));
2382     }
2383 
2384     /**
2385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2386      * Can only be called by the current owner.
2387      */
2388     function transferOwnership(address newOwner) public virtual onlyOwner {
2389         require(newOwner != address(0), "Ownable: new owner is the zero address");
2390         _transferOwnership(newOwner);
2391     }
2392 
2393     /**
2394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2395      * Internal function without access restriction.
2396      */
2397     function _transferOwnership(address newOwner) internal virtual {
2398         address oldOwner = _owner;
2399         _owner = newOwner;
2400         emit OwnershipTransferred(oldOwner, newOwner);
2401     }
2402 }
2403 
2404 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2405 
2406 
2407 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2408 
2409 pragma solidity ^0.8.0;
2410 
2411 /**
2412  * @dev Contract module that helps prevent reentrant calls to a function.
2413  *
2414  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2415  * available, which can be applied to functions to make sure there are no nested
2416  * (reentrant) calls to them.
2417  *
2418  * Note that because there is a single `nonReentrant` guard, functions marked as
2419  * `nonReentrant` may not call one another. This can be worked around by making
2420  * those functions `private`, and then adding `external` `nonReentrant` entry
2421  * points to them.
2422  *
2423  * TIP: If you would like to learn more about reentrancy and alternative ways
2424  * to protect against it, check out our blog post
2425  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2426  */
2427 abstract contract ReentrancyGuard {
2428     // Booleans are more expensive than uint256 or any type that takes up a full
2429     // word because each write operation emits an extra SLOAD to first read the
2430     // slot's contents, replace the bits taken up by the boolean, and then write
2431     // back. This is the compiler's defense against contract upgrades and
2432     // pointer aliasing, and it cannot be disabled.
2433 
2434     // The values being non-zero value makes deployment a bit more expensive,
2435     // but in exchange the refund on every call to nonReentrant will be lower in
2436     // amount. Since refunds are capped to a percentage of the total
2437     // transaction's gas, it is best to keep them low in cases like this one, to
2438     // increase the likelihood of the full refund coming into effect.
2439     uint256 private constant _NOT_ENTERED = 1;
2440     uint256 private constant _ENTERED = 2;
2441 
2442     uint256 private _status;
2443 
2444     constructor() {
2445         _status = _NOT_ENTERED;
2446     }
2447 
2448     /**
2449      * @dev Prevents a contract from calling itself, directly or indirectly.
2450      * Calling a `nonReentrant` function from another `nonReentrant`
2451      * function is not supported. It is possible to prevent this from happening
2452      * by making the `nonReentrant` function external, and making it call a
2453      * `private` function that does the actual work.
2454      */
2455     modifier nonReentrant() {
2456         _nonReentrantBefore();
2457         _;
2458         _nonReentrantAfter();
2459     }
2460 
2461     function _nonReentrantBefore() private {
2462         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2463         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2464 
2465         // Any calls to nonReentrant after this point will fail
2466         _status = _ENTERED;
2467     }
2468 
2469     function _nonReentrantAfter() private {
2470         // By storing the original value once again, a refund is triggered (see
2471         // https://eips.ethereum.org/EIPS/eip-2200)
2472         _status = _NOT_ENTERED;
2473     }
2474 }
2475 
2476 // File: contracts/andromechavx_main.sol
2477 
2478 
2479 
2480 //                                                                                
2481 //                                                                                
2482 //   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
2483 //   @@                     @@                                                @@  
2484 //   @@                     @@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@  
2485 //   @@                     @@    @@                                   @@     @@  
2486 //   @@                     @@    @@                                   @@     @@  
2487 //   @@                     @@    @@                                   @@     @@  
2488 //   @@                     @@    @@                                   @@     @@  
2489 //   @@                     @@    @@                                   @@     @@  
2490 //   @@                     @@    @@                                   @@     @@  
2491 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
2492 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
2493 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
2494 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
2495 //   @@                     @@    @@     @@@@@@            @@@@@@      @@     @@  
2496 //   @@                     @@    @@                                   @@     @@  
2497 //   @@                     @@    @@                                   @@     @@  
2498 //   @@                     @@    @@                                   @@     @@  
2499 //   @@                     @@    @@                                   @@     @@  
2500 //   @@                     @@    @@                                   @@     @@  
2501 //   @@                     @@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.      @@  
2502 //   @@                     @@                                                @@  
2503 //   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
2504 //               @/            (@                                 @@              
2505 //               @/            (@                                 @@              
2506 //               @/            (@                                 @@              
2507 //               @/            (@                                 @@              
2508 //               @/            (@                                 @@              
2509 //               @/            (@                                 @@              
2510 //               @/            (@                                 @@              
2511 //               @/            (@                                 @@              
2512 //               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
2513 // 
2514 //        
2515 
2516 
2517 
2518 
2519 
2520 
2521 
2522 
2523 pragma solidity >=0.8.13 <0.9.0;
2524 
2525 contract AndromechaVXV2 is ERC721A, Ownable, ReentrancyGuard { 
2526 
2527   using Strings for uint256;
2528 
2529 // ================== Variables Start =======================
2530 
2531   string private uri; 
2532   string public uriSuffix = ".json"; 
2533   string public hiddenMetadataUri; 
2534   uint256 public cost = 0.0011 ether; 
2535   uint256 public supplyLimit = 3333;  
2536   uint256 public maxMintAmountPerTx = 10; 
2537   uint256 public maxLimitPerWallet = 10; 
2538   bool public sale = false;  
2539   bool public revealed = true; 
2540 
2541 // ================== Variables End =======================
2542 
2543 
2544 
2545 // ================== Constructor Start =======================
2546   constructor(
2547     string memory _uri,
2548     string memory _hiddenMetadataUri
2549   ) ERC721A("AndromechaVX", "ANDROVX")  { 
2550     seturi(_uri);
2551     setHiddenMetadataUri(_hiddenMetadataUri);
2552   }
2553 
2554 // ================== Mint Functions Start =======================//
2555 
2556 function UpdateCost(uint256 _mintAmount) internal view returns  (uint256 _cost) {
2557 
2558     if (balanceOf(msg.sender) + _mintAmount <= supplyLimit){
2559         return cost;
2560     }
2561   }
2562   
2563 function Mint(uint256 _mintAmount) public payable nonReentrant{
2564 
2565     // Normal requirements 
2566     require(sale, "The Sale is paused!");
2567     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
2568     require(totalSupply() + _mintAmount <= supplyLimit, "Max supply exceeded!");
2569     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, "Max mint per wallet exceeded!");
2570     require(msg.value >= _mintAmount * cost);
2571     require(msg.value == _mintAmount * cost);
2572 
2573      
2574      _safeMint(_msgSender(), _mintAmount);
2575   }  
2576 
2577   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2578     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2579     _safeMint(_receiver, _mintAmount);
2580   }
2581 
2582   function setRevealed(bool _state) public onlyOwner {
2583     revealed = _state;
2584   }
2585 
2586   function seturi(string memory _uri) public onlyOwner {
2587     uri = _uri;
2588   }
2589 
2590   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2591     hiddenMetadataUri = _hiddenMetadataUri;
2592   }
2593 
2594   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2595     uriSuffix = _uriSuffix;
2596   }
2597 
2598   function setSaleStatus(bool _sale) public onlyOwner {
2599     sale = _sale;
2600   }
2601 
2602   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2603     maxMintAmountPerTx = _maxMintAmountPerTx;
2604   }
2605 
2606   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2607     maxLimitPerWallet = _maxLimitPerWallet;
2608   }
2609 
2610   function setcost(uint256 _cost) public onlyOwner {
2611     cost = _cost;
2612   }   
2613 
2614   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
2615     supplyLimit = _supplyLimit;
2616   }
2617 
2618   function withdraw() public onlyOwner nonReentrant{
2619     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2620     require(os);
2621   }
2622  
2623   function price(uint256 _mintAmount) public view returns (uint256){
2624          if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTx && totalSupply() < supplyLimit){
2625           return cost;
2626         }
2627         return cost;
2628   }
2629 
2630 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2631     unchecked {
2632         uint256[] memory a = new uint256[](balanceOf(owner)); 
2633         uint256 end = _nextTokenId();
2634         uint256 tokenIdsIdx;
2635         address currOwnershipAddr;
2636         for (uint256 i; i < end; i++) {
2637             TokenOwnership memory ownership = _ownershipAt(i);
2638             if (ownership.burned) {
2639                 continue;
2640             }
2641             if (ownership.addr != address(0)) {
2642                 currOwnershipAddr = ownership.addr;
2643             }
2644             if (currOwnershipAddr == owner) {
2645                 a[tokenIdsIdx++] = i;
2646             }
2647         }
2648         return a;    
2649     }
2650 }
2651 
2652   function _startTokenId() internal view virtual override returns (uint256) {
2653     return 1;
2654   }
2655 
2656   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2657     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2658 
2659     if (revealed == false) {
2660       return hiddenMetadataUri;
2661     }
2662 
2663     string memory currentBaseURI = _baseURI();
2664     return bytes(currentBaseURI).length > 0
2665         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2666         : '';
2667   }
2668 
2669   function _baseURI() internal view virtual override returns (string memory) {
2670     return uri;
2671   }
2672 
2673     
2674 }