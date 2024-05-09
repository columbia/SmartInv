1 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.2.3
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of ERC721A.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * Cannot query the balance for the zero address.
25      */
26     error BalanceQueryForZeroAddress();
27 
28     /**
29      * Cannot mint to the zero address.
30      */
31     error MintToZeroAddress();
32 
33     /**
34      * The quantity of tokens minted must be more than zero.
35      */
36     error MintZeroQuantity();
37 
38     /**
39      * The token does not exist.
40      */
41     error OwnerQueryForNonexistentToken();
42 
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error TransferCallerNotOwnerNorApproved();
47 
48     /**
49      * The token must be owned by `from`.
50      */
51     error TransferFromIncorrectOwner();
52 
53     /**
54      * Cannot safely transfer to a contract that does not implement the
55      * ERC721Receiver interface.
56      */
57     error TransferToNonERC721ReceiverImplementer();
58 
59     /**
60      * Cannot transfer to the zero address.
61      */
62     error TransferToZeroAddress();
63 
64     /**
65      * The token does not exist.
66      */
67     error URIQueryForNonexistentToken();
68 
69     /**
70      * The `quantity` minted with ERC2309 exceeds the safety limit.
71      */
72     error MintERC2309QuantityExceedsLimit();
73 
74     /**
75      * The `extraData` cannot be set on an unintialized ownership slot.
76      */
77     error OwnershipNotInitializedForExtraData();
78 
79     // =============================================================
80     //                            STRUCTS
81     // =============================================================
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Stores the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
91         uint24 extraData;
92     }
93 
94     // =============================================================
95     //                         TOKEN COUNTERS
96     // =============================================================
97 
98     /**
99      * @dev Returns the total number of tokens in existence.
100      * Burned tokens will reduce the count.
101      * To get the total number of tokens minted, please see {_totalMinted}.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     // =============================================================
106     //                            IERC165
107     // =============================================================
108 
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 
119     // =============================================================
120     //                            IERC721
121     // =============================================================
122 
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables
135      * (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in `owner`'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`,
155      * checking first that contract recipients are aware of the ERC721 protocol
156      * to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move
164      * this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement
166      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external payable;
176 
177     /**
178      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external payable;
185 
186     /**
187      * @dev Transfers `tokenId` from `from` to `to`.
188      *
189      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
190      * whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token
198      * by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external payable;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the
213      * zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external payable;
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom}
227      * for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}.
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     // =============================================================
254     //                        IERC721Metadata
255     // =============================================================
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 
272     // =============================================================
273     //                           IERC2309
274     // =============================================================
275 
276     /**
277      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
278      * (inclusive) is transferred from `from` to `to`, as defined in the
279      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
280      *
281      * See {_mintERC2309} for more details.
282      */
283     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
284 }
285 
286 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
287 
288 
289 // ERC721A Contracts v4.2.3
290 // Creator: Chiru Labs
291 
292 pragma solidity ^0.8.4;
293 
294 
295 /**
296  * @dev Interface of ERC721 token receiver.
297  */
298 interface ERC721A__IERC721Receiver {
299     function onERC721Received(
300         address operator,
301         address from,
302         uint256 tokenId,
303         bytes calldata data
304     ) external returns (bytes4);
305 }
306 
307 /**
308  * @title ERC721A
309  *
310  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
311  * Non-Fungible Token Standard, including the Metadata extension.
312  * Optimized for lower gas during batch mints.
313  *
314  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
315  * starting from `_startTokenId()`.
316  *
317  * Assumptions:
318  *
319  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
320  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
321  */
322 contract ERC721A is IERC721A {
323     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
324     struct TokenApprovalRef {
325         address value;
326     }
327 
328     // =============================================================
329     //                           CONSTANTS
330     // =============================================================
331 
332     // Mask of an entry in packed address data.
333     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
334 
335     // The bit position of `numberMinted` in packed address data.
336     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
337 
338     // The bit position of `numberBurned` in packed address data.
339     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
340 
341     // The bit position of `aux` in packed address data.
342     uint256 private constant _BITPOS_AUX = 192;
343 
344     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
345     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
346 
347     // The bit position of `startTimestamp` in packed ownership.
348     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
349 
350     // The bit mask of the `burned` bit in packed ownership.
351     uint256 private constant _BITMASK_BURNED = 1 << 224;
352 
353     // The bit position of the `nextInitialized` bit in packed ownership.
354     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
355 
356     // The bit mask of the `nextInitialized` bit in packed ownership.
357     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
358 
359     // The bit position of `extraData` in packed ownership.
360     uint256 private constant _BITPOS_EXTRA_DATA = 232;
361 
362     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
363     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
364 
365     // The mask of the lower 160 bits for addresses.
366     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
367 
368     // The maximum `quantity` that can be minted with {_mintERC2309}.
369     // This limit is to prevent overflows on the address data entries.
370     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
371     // is required to cause an overflow, which is unrealistic.
372     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
373 
374     // The `Transfer` event signature is given by:
375     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
376     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
377         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
378 
379     // =============================================================
380     //                            STORAGE
381     // =============================================================
382 
383     // The next token ID to be minted.
384     uint256 private _currentIndex;
385 
386     // The number of tokens burned.
387     uint256 private _burnCounter;
388 
389     // Token name
390     string private _name;
391 
392     // Token symbol
393     string private _symbol;
394 
395     // Mapping from token ID to ownership details
396     // An empty struct value does not necessarily mean the token is unowned.
397     // See {_packedOwnershipOf} implementation for details.
398     //
399     // Bits Layout:
400     // - [0..159]   `addr`
401     // - [160..223] `startTimestamp`
402     // - [224]      `burned`
403     // - [225]      `nextInitialized`
404     // - [232..255] `extraData`
405     mapping(uint256 => uint256) private _packedOwnerships;
406 
407     // Mapping owner address to address data.
408     //
409     // Bits Layout:
410     // - [0..63]    `balance`
411     // - [64..127]  `numberMinted`
412     // - [128..191] `numberBurned`
413     // - [192..255] `aux`
414     mapping(address => uint256) private _packedAddressData;
415 
416     // Mapping from token ID to approved address.
417     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
418 
419     // Mapping from owner to operator approvals
420     mapping(address => mapping(address => bool)) private _operatorApprovals;
421 
422     // =============================================================
423     //                          CONSTRUCTOR
424     // =============================================================
425 
426     constructor(string memory name_, string memory symbol_) {
427         _name = name_;
428         _symbol = symbol_;
429         _currentIndex = _startTokenId();
430     }
431 
432     // =============================================================
433     //                   TOKEN COUNTING OPERATIONS
434     // =============================================================
435 
436     /**
437      * @dev Returns the starting token ID.
438      * To change the starting token ID, please override this function.
439      */
440     function _startTokenId() internal view virtual returns (uint256) {
441         return 0;
442     }
443 
444     /**
445      * @dev Returns the next token ID to be minted.
446      */
447     function _nextTokenId() internal view virtual returns (uint256) {
448         return _currentIndex;
449     }
450 
451     /**
452      * @dev Returns the total number of tokens in existence.
453      * Burned tokens will reduce the count.
454      * To get the total number of tokens minted, please see {_totalMinted}.
455      */
456     function totalSupply() public view virtual override returns (uint256) {
457         // Counter underflow is impossible as _burnCounter cannot be incremented
458         // more than `_currentIndex - _startTokenId()` times.
459         unchecked {
460             return _currentIndex - _burnCounter - _startTokenId();
461         }
462     }
463 
464     /**
465      * @dev Returns the total amount of tokens minted in the contract.
466      */
467     function _totalMinted() internal view virtual returns (uint256) {
468         // Counter underflow is impossible as `_currentIndex` does not decrement,
469         // and it is initialized to `_startTokenId()`.
470         unchecked {
471             return _currentIndex - _startTokenId();
472         }
473     }
474 
475     /**
476      * @dev Returns the total number of tokens burned.
477      */
478     function _totalBurned() internal view virtual returns (uint256) {
479         return _burnCounter;
480     }
481 
482     // =============================================================
483     //                    ADDRESS DATA OPERATIONS
484     // =============================================================
485 
486     /**
487      * @dev Returns the number of tokens in `owner`'s account.
488      */
489     function balanceOf(address owner) public view virtual override returns (uint256) {
490         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
491         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the number of tokens minted by `owner`.
496      */
497     function _numberMinted(address owner) internal view returns (uint256) {
498         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     /**
502      * Returns the number of tokens burned by or on behalf of `owner`.
503      */
504     function _numberBurned(address owner) internal view returns (uint256) {
505         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
506     }
507 
508     /**
509      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
510      */
511     function _getAux(address owner) internal view returns (uint64) {
512         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
513     }
514 
515     /**
516      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
517      * If there are multiple variables, please pack them into a uint64.
518      */
519     function _setAux(address owner, uint64 aux) internal virtual {
520         uint256 packed = _packedAddressData[owner];
521         uint256 auxCasted;
522         // Cast `aux` with assembly to avoid redundant masking.
523         assembly {
524             auxCasted := aux
525         }
526         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
527         _packedAddressData[owner] = packed;
528     }
529 
530     // =============================================================
531     //                            IERC165
532     // =============================================================
533 
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         // The interface IDs are constants representing the first 4 bytes
544         // of the XOR of all function selectors in the interface.
545         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
546         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
547         return
548             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
549             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
550             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
551     }
552 
553     // =============================================================
554     //                        IERC721Metadata
555     // =============================================================
556 
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() public view virtual override returns (string memory) {
561         return _name;
562     }
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() public view virtual override returns (string memory) {
568         return _symbol;
569     }
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
575         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
576 
577         string memory baseURI = _baseURI();
578         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
579     }
580 
581     /**
582      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
583      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
584      * by default, it can be overridden in child contracts.
585      */
586     function _baseURI() internal view virtual returns (string memory) {
587         return '';
588     }
589 
590     // =============================================================
591     //                     OWNERSHIPS OPERATIONS
592     // =============================================================
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602         return address(uint160(_packedOwnershipOf(tokenId)));
603     }
604 
605     /**
606      * @dev Gas spent here starts off proportional to the maximum mint batch size.
607      * It gradually moves to O(1) as tokens get transferred around over time.
608      */
609     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
610         return _unpackedOwnership(_packedOwnershipOf(tokenId));
611     }
612 
613     /**
614      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
615      */
616     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
617         return _unpackedOwnership(_packedOwnerships[index]);
618     }
619 
620     /**
621      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
622      */
623     function _initializeOwnershipAt(uint256 index) internal virtual {
624         if (_packedOwnerships[index] == 0) {
625             _packedOwnerships[index] = _packedOwnershipOf(index);
626         }
627     }
628 
629     /**
630      * Returns the packed ownership data of `tokenId`.
631      */
632     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
633         if (_startTokenId() <= tokenId) {
634             packed = _packedOwnerships[tokenId];
635             // If not burned.
636             if (packed & _BITMASK_BURNED == 0) {
637                 // If the data at the starting slot does not exist, start the scan.
638                 if (packed == 0) {
639                     if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
640                     // Invariant:
641                     // There will always be an initialized ownership slot
642                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
643                     // before an unintialized ownership slot
644                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
645                     // Hence, `tokenId` will not underflow.
646                     //
647                     // We can directly compare the packed value.
648                     // If the address is zero, packed will be zero.
649                     for (;;) {
650                         unchecked {
651                             packed = _packedOwnerships[--tokenId];
652                         }
653                         if (packed == 0) continue;
654                         return packed;
655                     }
656                 }
657                 // Otherwise, the data exists and is not burned. We can skip the scan.
658                 // This is possible because we have already achieved the target condition.
659                 // This saves 2143 gas on transfers of initialized tokens.
660                 return packed;
661             }
662         }
663         _revert(OwnerQueryForNonexistentToken.selector);
664     }
665 
666     /**
667      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
668      */
669     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
670         ownership.addr = address(uint160(packed));
671         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
672         ownership.burned = packed & _BITMASK_BURNED != 0;
673         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
674     }
675 
676     /**
677      * @dev Packs ownership data into a single uint256.
678      */
679     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
680         assembly {
681             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
682             owner := and(owner, _BITMASK_ADDRESS)
683             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
684             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
685         }
686     }
687 
688     /**
689      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
690      */
691     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
692         // For branchless setting of the `nextInitialized` flag.
693         assembly {
694             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
695             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
696         }
697     }
698 
699     // =============================================================
700     //                      APPROVAL OPERATIONS
701     // =============================================================
702 
703     /**
704      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
705      *
706      * Requirements:
707      *
708      * - The caller must own the token or be an approved operator.
709      */
710     function approve(address to, uint256 tokenId) public payable virtual override {
711         _approve(to, tokenId, true);
712     }
713 
714     /**
715      * @dev Returns the account approved for `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function getApproved(uint256 tokenId) public view virtual override returns (address) {
722         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
723 
724         return _tokenApprovals[tokenId].value;
725     }
726 
727     /**
728      * @dev Approve or remove `operator` as an operator for the caller.
729      * Operators can call {transferFrom} or {safeTransferFrom}
730      * for any token owned by the caller.
731      *
732      * Requirements:
733      *
734      * - The `operator` cannot be the caller.
735      *
736      * Emits an {ApprovalForAll} event.
737      */
738     function setApprovalForAll(address operator, bool approved) public virtual override {
739         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
740         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
741     }
742 
743     /**
744      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
745      *
746      * See {setApprovalForAll}.
747      */
748     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
749         return _operatorApprovals[owner][operator];
750     }
751 
752     /**
753      * @dev Returns whether `tokenId` exists.
754      *
755      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
756      *
757      * Tokens start existing when they are minted. See {_mint}.
758      */
759     function _exists(uint256 tokenId) internal view virtual returns (bool) {
760         return
761             _startTokenId() <= tokenId &&
762             tokenId < _currentIndex && // If within bounds,
763             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
764     }
765 
766     /**
767      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
768      */
769     function _isSenderApprovedOrOwner(
770         address approvedAddress,
771         address owner,
772         address msgSender
773     ) private pure returns (bool result) {
774         assembly {
775             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
776             owner := and(owner, _BITMASK_ADDRESS)
777             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
778             msgSender := and(msgSender, _BITMASK_ADDRESS)
779             // `msgSender == owner || msgSender == approvedAddress`.
780             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
781         }
782     }
783 
784     /**
785      * @dev Returns the storage slot and value for the approved address of `tokenId`.
786      */
787     function _getApprovedSlotAndAddress(uint256 tokenId)
788         private
789         view
790         returns (uint256 approvedAddressSlot, address approvedAddress)
791     {
792         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
793         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
794         assembly {
795             approvedAddressSlot := tokenApproval.slot
796             approvedAddress := sload(approvedAddressSlot)
797         }
798     }
799 
800     // =============================================================
801     //                      TRANSFER OPERATIONS
802     // =============================================================
803 
804     /**
805      * @dev Transfers `tokenId` from `from` to `to`.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must be owned by `from`.
812      * - If the caller is not `from`, it must be approved to move this token
813      * by either {approve} or {setApprovalForAll}.
814      *
815      * Emits a {Transfer} event.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) public payable virtual override {
822         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
823 
824         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
825         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
826 
827         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
828 
829         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
830 
831         // The nested ifs save around 20+ gas over a compound boolean condition.
832         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
833             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
834 
835         _beforeTokenTransfers(from, to, tokenId, 1);
836 
837         // Clear approvals from the previous owner.
838         assembly {
839             if approvedAddress {
840                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
841                 sstore(approvedAddressSlot, 0)
842             }
843         }
844 
845         // Underflow of the sender's balance is impossible because we check for
846         // ownership above and the recipient's balance can't realistically overflow.
847         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
848         unchecked {
849             // We can directly increment and decrement the balances.
850             --_packedAddressData[from]; // Updates: `balance -= 1`.
851             ++_packedAddressData[to]; // Updates: `balance += 1`.
852 
853             // Updates:
854             // - `address` to the next owner.
855             // - `startTimestamp` to the timestamp of transfering.
856             // - `burned` to `false`.
857             // - `nextInitialized` to `true`.
858             _packedOwnerships[tokenId] = _packOwnershipData(
859                 to,
860                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
861             );
862 
863             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
864             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
865                 uint256 nextTokenId = tokenId + 1;
866                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
867                 if (_packedOwnerships[nextTokenId] == 0) {
868                     // If the next slot is within bounds.
869                     if (nextTokenId != _currentIndex) {
870                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
871                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
872                     }
873                 }
874             }
875         }
876 
877         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
878         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
879         assembly {
880             // Emit the `Transfer` event.
881             log4(
882                 0, // Start of data (0, since no data).
883                 0, // End of data (0, since no data).
884                 _TRANSFER_EVENT_SIGNATURE, // Signature.
885                 from, // `from`.
886                 toMasked, // `to`.
887                 tokenId // `tokenId`.
888             )
889         }
890         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
891 
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public payable virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If the caller is not `from`, it must be approved to move this token
915      * by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement
917      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public payable virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 _revert(TransferToNonERC721ReceiverImplementer.selector);
931             }
932     }
933 
934     /**
935      * @dev Hook that is called before a set of serially-ordered token IDs
936      * are about to be transferred. This includes minting.
937      * And also called before burning one token.
938      *
939      * `startTokenId` - the first token ID to be transferred.
940      * `quantity` - the amount to be transferred.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, `tokenId` will be burned by `from`.
948      * - `from` and `to` are never both zero.
949      */
950     function _beforeTokenTransfers(
951         address from,
952         address to,
953         uint256 startTokenId,
954         uint256 quantity
955     ) internal virtual {}
956 
957     /**
958      * @dev Hook that is called after a set of serially-ordered token IDs
959      * have been transferred. This includes minting.
960      * And also called after one token has been burned.
961      *
962      * `startTokenId` - the first token ID to be transferred.
963      * `quantity` - the amount to be transferred.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` has been minted for `to`.
970      * - When `to` is zero, `tokenId` has been burned by `from`.
971      * - `from` and `to` are never both zero.
972      */
973     function _afterTokenTransfers(
974         address from,
975         address to,
976         uint256 startTokenId,
977         uint256 quantity
978     ) internal virtual {}
979 
980     /**
981      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
982      *
983      * `from` - Previous owner of the given token ID.
984      * `to` - Target address that will receive the token.
985      * `tokenId` - Token ID to be transferred.
986      * `_data` - Optional data to send along with the call.
987      *
988      * Returns whether the call correctly returned the expected magic value.
989      */
990     function _checkContractOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
997             bytes4 retval
998         ) {
999             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1000         } catch (bytes memory reason) {
1001             if (reason.length == 0) {
1002                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1003             }
1004             assembly {
1005                 revert(add(32, reason), mload(reason))
1006             }
1007         }
1008     }
1009 
1010     // =============================================================
1011     //                        MINT OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event for each mint.
1023      */
1024     function _mint(address to, uint256 quantity) internal virtual {
1025         uint256 startTokenId = _currentIndex;
1026         if (quantity == 0) _revert(MintZeroQuantity.selector);
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are incredibly unrealistic.
1031         // `balance` and `numberMinted` have a maximum limit of 2**64.
1032         // `tokenId` has a maximum limit of 2**256.
1033         unchecked {
1034             // Updates:
1035             // - `address` to the owner.
1036             // - `startTimestamp` to the timestamp of minting.
1037             // - `burned` to `false`.
1038             // - `nextInitialized` to `quantity == 1`.
1039             _packedOwnerships[startTokenId] = _packOwnershipData(
1040                 to,
1041                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1042             );
1043 
1044             // Updates:
1045             // - `balance += quantity`.
1046             // - `numberMinted += quantity`.
1047             //
1048             // We can directly add to the `balance` and `numberMinted`.
1049             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1050 
1051             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1052             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1053 
1054             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1055 
1056             uint256 end = startTokenId + quantity;
1057             uint256 tokenId = startTokenId;
1058 
1059             do {
1060                 assembly {
1061                     // Emit the `Transfer` event.
1062                     log4(
1063                         0, // Start of data (0, since no data).
1064                         0, // End of data (0, since no data).
1065                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1066                         0, // `address(0)`.
1067                         toMasked, // `to`.
1068                         tokenId // `tokenId`.
1069                     )
1070                 }
1071                 // The `!=` check ensures that large values of `quantity`
1072                 // that overflows uint256 will make the loop run out of gas.
1073             } while (++tokenId != end);
1074 
1075             _currentIndex = end;
1076         }
1077         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1078     }
1079 
1080     /**
1081      * @dev Mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * This function is intended for efficient minting only during contract creation.
1084      *
1085      * It emits only one {ConsecutiveTransfer} as defined in
1086      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1087      * instead of a sequence of {Transfer} event(s).
1088      *
1089      * Calling this function outside of contract creation WILL make your contract
1090      * non-compliant with the ERC721 standard.
1091      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1092      * {ConsecutiveTransfer} event is only permissible during contract creation.
1093      *
1094      * Requirements:
1095      *
1096      * - `to` cannot be the zero address.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {ConsecutiveTransfer} event.
1100      */
1101     function _mintERC2309(address to, uint256 quantity) internal virtual {
1102         uint256 startTokenId = _currentIndex;
1103         if (to == address(0)) _revert(MintToZeroAddress.selector);
1104         if (quantity == 0) _revert(MintZeroQuantity.selector);
1105         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1110         unchecked {
1111             // Updates:
1112             // - `balance += quantity`.
1113             // - `numberMinted += quantity`.
1114             //
1115             // We can directly add to the `balance` and `numberMinted`.
1116             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1117 
1118             // Updates:
1119             // - `address` to the owner.
1120             // - `startTimestamp` to the timestamp of minting.
1121             // - `burned` to `false`.
1122             // - `nextInitialized` to `quantity == 1`.
1123             _packedOwnerships[startTokenId] = _packOwnershipData(
1124                 to,
1125                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1126             );
1127 
1128             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1129 
1130             _currentIndex = startTokenId + quantity;
1131         }
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - If `to` refers to a smart contract, it must implement
1141      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * See {_mint}.
1145      *
1146      * Emits a {Transfer} event for each mint.
1147      */
1148     function _safeMint(
1149         address to,
1150         uint256 quantity,
1151         bytes memory _data
1152     ) internal virtual {
1153         _mint(to, quantity);
1154 
1155         unchecked {
1156             if (to.code.length != 0) {
1157                 uint256 end = _currentIndex;
1158                 uint256 index = end - quantity;
1159                 do {
1160                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1161                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1162                     }
1163                 } while (index < end);
1164                 // Reentrancy protection.
1165                 if (_currentIndex != end) _revert(bytes4(0));
1166             }
1167         }
1168     }
1169 
1170     /**
1171      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1172      */
1173     function _safeMint(address to, uint256 quantity) internal virtual {
1174         _safeMint(to, quantity, '');
1175     }
1176 
1177     // =============================================================
1178     //                       APPROVAL OPERATIONS
1179     // =============================================================
1180 
1181     /**
1182      * @dev Equivalent to `_approve(to, tokenId, false)`.
1183      */
1184     function _approve(address to, uint256 tokenId) internal virtual {
1185         _approve(to, tokenId, false);
1186     }
1187 
1188     /**
1189      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1190      * The approval is cleared when the token is transferred.
1191      *
1192      * Only a single account can be approved at a time, so approving the
1193      * zero address clears previous approvals.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      *
1199      * Emits an {Approval} event.
1200      */
1201     function _approve(
1202         address to,
1203         uint256 tokenId,
1204         bool approvalCheck
1205     ) internal virtual {
1206         address owner = ownerOf(tokenId);
1207 
1208         if (approvalCheck && _msgSenderERC721A() != owner)
1209             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1210                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1211             }
1212 
1213         _tokenApprovals[tokenId].value = to;
1214         emit Approval(owner, to, tokenId);
1215     }
1216 
1217     // =============================================================
1218     //                        BURN OPERATIONS
1219     // =============================================================
1220 
1221     /**
1222      * @dev Equivalent to `_burn(tokenId, false)`.
1223      */
1224     function _burn(uint256 tokenId) internal virtual {
1225         _burn(tokenId, false);
1226     }
1227 
1228     /**
1229      * @dev Destroys `tokenId`.
1230      * The approval is cleared when the token is burned.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1239         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1240 
1241         address from = address(uint160(prevOwnershipPacked));
1242 
1243         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1244 
1245         if (approvalCheck) {
1246             // The nested ifs save around 20+ gas over a compound boolean condition.
1247             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1248                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1249         }
1250 
1251         _beforeTokenTransfers(from, address(0), tokenId, 1);
1252 
1253         // Clear approvals from the previous owner.
1254         assembly {
1255             if approvedAddress {
1256                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1257                 sstore(approvedAddressSlot, 0)
1258             }
1259         }
1260 
1261         // Underflow of the sender's balance is impossible because we check for
1262         // ownership above and the recipient's balance can't realistically overflow.
1263         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1264         unchecked {
1265             // Updates:
1266             // - `balance -= 1`.
1267             // - `numberBurned += 1`.
1268             //
1269             // We can directly decrement the balance, and increment the number burned.
1270             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1271             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1272 
1273             // Updates:
1274             // - `address` to the last owner.
1275             // - `startTimestamp` to the timestamp of burning.
1276             // - `burned` to `true`.
1277             // - `nextInitialized` to `true`.
1278             _packedOwnerships[tokenId] = _packOwnershipData(
1279                 from,
1280                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1281             );
1282 
1283             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1284             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1285                 uint256 nextTokenId = tokenId + 1;
1286                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1287                 if (_packedOwnerships[nextTokenId] == 0) {
1288                     // If the next slot is within bounds.
1289                     if (nextTokenId != _currentIndex) {
1290                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1291                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1292                     }
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, address(0), tokenId);
1298         _afterTokenTransfers(from, address(0), tokenId, 1);
1299 
1300         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1301         unchecked {
1302             _burnCounter++;
1303         }
1304     }
1305 
1306     // =============================================================
1307     //                     EXTRA DATA OPERATIONS
1308     // =============================================================
1309 
1310     /**
1311      * @dev Directly sets the extra data for the ownership data `index`.
1312      */
1313     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1314         uint256 packed = _packedOwnerships[index];
1315         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1316         uint256 extraDataCasted;
1317         // Cast `extraData` with assembly to avoid redundant masking.
1318         assembly {
1319             extraDataCasted := extraData
1320         }
1321         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1322         _packedOwnerships[index] = packed;
1323     }
1324 
1325     /**
1326      * @dev Called during each token transfer to set the 24bit `extraData` field.
1327      * Intended to be overridden by the cosumer contract.
1328      *
1329      * `previousExtraData` - the value of `extraData` before transfer.
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` will be minted for `to`.
1336      * - When `to` is zero, `tokenId` will be burned by `from`.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _extraData(
1340         address from,
1341         address to,
1342         uint24 previousExtraData
1343     ) internal view virtual returns (uint24) {}
1344 
1345     /**
1346      * @dev Returns the next extra data for the packed ownership data.
1347      * The returned result is shifted into position.
1348      */
1349     function _nextExtraData(
1350         address from,
1351         address to,
1352         uint256 prevOwnershipPacked
1353     ) private view returns (uint256) {
1354         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1355         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1356     }
1357 
1358     // =============================================================
1359     //                       OTHER OPERATIONS
1360     // =============================================================
1361 
1362     /**
1363      * @dev Returns the message sender (defaults to `msg.sender`).
1364      *
1365      * If you are writing GSN compatible contracts, you need to override this function.
1366      */
1367     function _msgSenderERC721A() internal view virtual returns (address) {
1368         return msg.sender;
1369     }
1370 
1371     /**
1372      * @dev Converts a uint256 to its ASCII string decimal representation.
1373      */
1374     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1375         assembly {
1376             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1377             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1378             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1379             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1380             let m := add(mload(0x40), 0xa0)
1381             // Update the free memory pointer to allocate.
1382             mstore(0x40, m)
1383             // Assign the `str` to the end.
1384             str := sub(m, 0x20)
1385             // Zeroize the slot after the string.
1386             mstore(str, 0)
1387 
1388             // Cache the end of the memory to calculate the length later.
1389             let end := str
1390 
1391             // We write the string from rightmost digit to leftmost digit.
1392             // The following is essentially a do-while loop that also handles the zero case.
1393             // prettier-ignore
1394             for { let temp := value } 1 {} {
1395                 str := sub(str, 1)
1396                 // Write the character to the pointer.
1397                 // The ASCII index of the '0' character is 48.
1398                 mstore8(str, add(48, mod(temp, 10)))
1399                 // Keep dividing `temp` until zero.
1400                 temp := div(temp, 10)
1401                 // prettier-ignore
1402                 if iszero(temp) { break }
1403             }
1404 
1405             let length := sub(end, str)
1406             // Move the pointer 32 bytes leftwards to make room for the length.
1407             str := sub(str, 0x20)
1408             // Store the length.
1409             mstore(str, length)
1410         }
1411     }
1412 
1413     /**
1414      * @dev For more efficient reverts.
1415      */
1416     function _revert(bytes4 errorSelector) internal pure {
1417         assembly {
1418             mstore(0x00, errorSelector)
1419             revert(0x00, 0x04)
1420         }
1421     }
1422 }
1423 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1424 
1425 
1426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1427 
1428 pragma solidity ^0.8.0;
1429 
1430 /**
1431  * @dev Interface of the ERC165 standard, as defined in the
1432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1433  *
1434  * Implementers can declare support of contract interfaces, which can then be
1435  * queried by others ({ERC165Checker}).
1436  *
1437  * For an implementation, see {ERC165}.
1438  */
1439 interface IERC165 {
1440     /**
1441      * @dev Returns true if this contract implements the interface defined by
1442      * `interfaceId`. See the corresponding
1443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1444      * to learn more about how these ids are created.
1445      *
1446      * This function call must use less than 30 000 gas.
1447      */
1448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1449 }
1450 
1451 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1452 
1453 
1454 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 
1459 /**
1460  * @dev Required interface of an ERC721 compliant contract.
1461  */
1462 interface IERC721 is IERC165 {
1463     /**
1464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1465      */
1466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1467 
1468     /**
1469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1470      */
1471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1472 
1473     /**
1474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1475      */
1476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1477 
1478     /**
1479      * @dev Returns the number of tokens in ``owner``'s account.
1480      */
1481     function balanceOf(address owner) external view returns (uint256 balance);
1482 
1483     /**
1484      * @dev Returns the owner of the `tokenId` token.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      */
1490     function ownerOf(uint256 tokenId) external view returns (address owner);
1491 
1492     /**
1493      * @dev Safely transfers `tokenId` token from `from` to `to`.
1494      *
1495      * Requirements:
1496      *
1497      * - `from` cannot be the zero address.
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must exist and be owned by `from`.
1500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes calldata data
1510     ) external;
1511 
1512     /**
1513      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1514      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1515      *
1516      * Requirements:
1517      *
1518      * - `from` cannot be the zero address.
1519      * - `to` cannot be the zero address.
1520      * - `tokenId` token must exist and be owned by `from`.
1521      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1523      *
1524      * Emits a {Transfer} event.
1525      */
1526     function safeTransferFrom(
1527         address from,
1528         address to,
1529         uint256 tokenId
1530     ) external;
1531 
1532     /**
1533      * @dev Transfers `tokenId` token from `from` to `to`.
1534      *
1535      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1536      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1537      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1538      *
1539      * Requirements:
1540      *
1541      * - `from` cannot be the zero address.
1542      * - `to` cannot be the zero address.
1543      * - `tokenId` token must be owned by `from`.
1544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1545      *
1546      * Emits a {Transfer} event.
1547      */
1548     function transferFrom(
1549         address from,
1550         address to,
1551         uint256 tokenId
1552     ) external;
1553 
1554     /**
1555      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1556      * The approval is cleared when the token is transferred.
1557      *
1558      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1559      *
1560      * Requirements:
1561      *
1562      * - The caller must own the token or be an approved operator.
1563      * - `tokenId` must exist.
1564      *
1565      * Emits an {Approval} event.
1566      */
1567     function approve(address to, uint256 tokenId) external;
1568 
1569     /**
1570      * @dev Approve or remove `operator` as an operator for the caller.
1571      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1572      *
1573      * Requirements:
1574      *
1575      * - The `operator` cannot be the caller.
1576      *
1577      * Emits an {ApprovalForAll} event.
1578      */
1579     function setApprovalForAll(address operator, bool _approved) external;
1580 
1581     /**
1582      * @dev Returns the account approved for `tokenId` token.
1583      *
1584      * Requirements:
1585      *
1586      * - `tokenId` must exist.
1587      */
1588     function getApproved(uint256 tokenId) external view returns (address operator);
1589 
1590     /**
1591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1592      *
1593      * See {setApprovalForAll}
1594      */
1595     function isApprovedForAll(address owner, address operator) external view returns (bool);
1596 }
1597 
1598 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1599 
1600 
1601 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 /**
1607  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1608  * @dev See https://eips.ethereum.org/EIPS/eip-721
1609  */
1610 interface IERC721Metadata is IERC721 {
1611     /**
1612      * @dev Returns the token collection name.
1613      */
1614     function name() external view returns (string memory);
1615 
1616     /**
1617      * @dev Returns the token collection symbol.
1618      */
1619     function symbol() external view returns (string memory);
1620 
1621     /**
1622      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1623      */
1624     function tokenURI(uint256 tokenId) external view returns (string memory);
1625 }
1626 
1627 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1628 
1629 
1630 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1631 
1632 pragma solidity ^0.8.0;
1633 
1634 
1635 /**
1636  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1637  * @dev See https://eips.ethereum.org/EIPS/eip-721
1638  */
1639 interface IERC721Enumerable is IERC721 {
1640     /**
1641      * @dev Returns the total amount of tokens stored by the contract.
1642      */
1643     function totalSupply() external view returns (uint256);
1644 
1645     /**
1646      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1647      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1648      */
1649     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1650 
1651     /**
1652      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1653      * Use along with {totalSupply} to enumerate all tokens.
1654      */
1655     function tokenByIndex(uint256 index) external view returns (uint256);
1656 }
1657 
1658 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1659 
1660 
1661 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 
1666 /**
1667  * @dev Implementation of the {IERC165} interface.
1668  *
1669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1670  * for the additional interface id that will be supported. For example:
1671  *
1672  * ```solidity
1673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1675  * }
1676  * ```
1677  *
1678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1679  */
1680 abstract contract ERC165 is IERC165 {
1681     /**
1682      * @dev See {IERC165-supportsInterface}.
1683      */
1684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1685         return interfaceId == type(IERC165).interfaceId;
1686     }
1687 }
1688 
1689 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1690 
1691 
1692 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1693 
1694 pragma solidity ^0.8.0;
1695 
1696 
1697 /**
1698  * @dev Interface for the NFT Royalty Standard.
1699  *
1700  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1701  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1702  *
1703  * _Available since v4.5._
1704  */
1705 interface IERC2981 is IERC165 {
1706     /**
1707      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1708      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1709      */
1710     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1711         external
1712         view
1713         returns (address receiver, uint256 royaltyAmount);
1714 }
1715 
1716 // File: @openzeppelin/contracts/interfaces/IERC165.sol
1717 
1718 
1719 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1720 
1721 pragma solidity ^0.8.0;
1722 
1723 
1724 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1725 
1726 
1727 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1728 
1729 pragma solidity ^0.8.0;
1730 
1731 /**
1732  * @title ERC721 token receiver interface
1733  * @dev Interface for any contract that wants to support safeTransfers
1734  * from ERC721 asset contracts.
1735  */
1736 interface IERC721Receiver {
1737     /**
1738      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1739      * by `operator` from `from`, this function is called.
1740      *
1741      * It must return its Solidity selector to confirm the token transfer.
1742      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1743      *
1744      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1745      */
1746     function onERC721Received(
1747         address operator,
1748         address from,
1749         uint256 tokenId,
1750         bytes calldata data
1751     ) external returns (bytes4);
1752 }
1753 
1754 // File: @openzeppelin/contracts/utils/Address.sol
1755 
1756 
1757 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1758 
1759 pragma solidity ^0.8.1;
1760 
1761 /**
1762  * @dev Collection of functions related to the address type
1763  */
1764 library Address {
1765     /**
1766      * @dev Returns true if `account` is a contract.
1767      *
1768      * [IMPORTANT]
1769      * ====
1770      * It is unsafe to assume that an address for which this function returns
1771      * false is an externally-owned account (EOA) and not a contract.
1772      *
1773      * Among others, `isContract` will return false for the following
1774      * types of addresses:
1775      *
1776      *  - an externally-owned account
1777      *  - a contract in construction
1778      *  - an address where a contract will be created
1779      *  - an address where a contract lived, but was destroyed
1780      * ====
1781      *
1782      * [IMPORTANT]
1783      * ====
1784      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1785      *
1786      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1787      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1788      * constructor.
1789      * ====
1790      */
1791     function isContract(address account) internal view returns (bool) {
1792         // This method relies on extcodesize/address.code.length, which returns 0
1793         // for contracts in construction, since the code is only stored at the end
1794         // of the constructor execution.
1795 
1796         return account.code.length > 0;
1797     }
1798 
1799     /**
1800      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1801      * `recipient`, forwarding all available gas and reverting on errors.
1802      *
1803      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1804      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1805      * imposed by `transfer`, making them unable to receive funds via
1806      * `transfer`. {sendValue} removes this limitation.
1807      *
1808      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1809      *
1810      * IMPORTANT: because control is transferred to `recipient`, care must be
1811      * taken to not create reentrancy vulnerabilities. Consider using
1812      * {ReentrancyGuard} or the
1813      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1814      */
1815     function sendValue(address payable recipient, uint256 amount) internal {
1816         require(address(this).balance >= amount, "Address: insufficient balance");
1817 
1818         (bool success, ) = recipient.call{value: amount}("");
1819         require(success, "Address: unable to send value, recipient may have reverted");
1820     }
1821 
1822     /**
1823      * @dev Performs a Solidity function call using a low level `call`. A
1824      * plain `call` is an unsafe replacement for a function call: use this
1825      * function instead.
1826      *
1827      * If `target` reverts with a revert reason, it is bubbled up by this
1828      * function (like regular Solidity function calls).
1829      *
1830      * Returns the raw returned data. To convert to the expected return value,
1831      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1832      *
1833      * Requirements:
1834      *
1835      * - `target` must be a contract.
1836      * - calling `target` with `data` must not revert.
1837      *
1838      * _Available since v3.1._
1839      */
1840     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1841         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1842     }
1843 
1844     /**
1845      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1846      * `errorMessage` as a fallback revert reason when `target` reverts.
1847      *
1848      * _Available since v3.1._
1849      */
1850     function functionCall(
1851         address target,
1852         bytes memory data,
1853         string memory errorMessage
1854     ) internal returns (bytes memory) {
1855         return functionCallWithValue(target, data, 0, errorMessage);
1856     }
1857 
1858     /**
1859      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1860      * but also transferring `value` wei to `target`.
1861      *
1862      * Requirements:
1863      *
1864      * - the calling contract must have an ETH balance of at least `value`.
1865      * - the called Solidity function must be `payable`.
1866      *
1867      * _Available since v3.1._
1868      */
1869     function functionCallWithValue(
1870         address target,
1871         bytes memory data,
1872         uint256 value
1873     ) internal returns (bytes memory) {
1874         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1875     }
1876 
1877     /**
1878      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1879      * with `errorMessage` as a fallback revert reason when `target` reverts.
1880      *
1881      * _Available since v3.1._
1882      */
1883     function functionCallWithValue(
1884         address target,
1885         bytes memory data,
1886         uint256 value,
1887         string memory errorMessage
1888     ) internal returns (bytes memory) {
1889         require(address(this).balance >= value, "Address: insufficient balance for call");
1890         (bool success, bytes memory returndata) = target.call{value: value}(data);
1891         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1892     }
1893 
1894     /**
1895      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1896      * but performing a static call.
1897      *
1898      * _Available since v3.3._
1899      */
1900     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1901         return functionStaticCall(target, data, "Address: low-level static call failed");
1902     }
1903 
1904     /**
1905      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1906      * but performing a static call.
1907      *
1908      * _Available since v3.3._
1909      */
1910     function functionStaticCall(
1911         address target,
1912         bytes memory data,
1913         string memory errorMessage
1914     ) internal view returns (bytes memory) {
1915         (bool success, bytes memory returndata) = target.staticcall(data);
1916         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1917     }
1918 
1919     /**
1920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1921      * but performing a delegate call.
1922      *
1923      * _Available since v3.4._
1924      */
1925     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1926         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1927     }
1928 
1929     /**
1930      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1931      * but performing a delegate call.
1932      *
1933      * _Available since v3.4._
1934      */
1935     function functionDelegateCall(
1936         address target,
1937         bytes memory data,
1938         string memory errorMessage
1939     ) internal returns (bytes memory) {
1940         (bool success, bytes memory returndata) = target.delegatecall(data);
1941         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1942     }
1943 
1944     /**
1945      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1946      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1947      *
1948      * _Available since v4.8._
1949      */
1950     function verifyCallResultFromTarget(
1951         address target,
1952         bool success,
1953         bytes memory returndata,
1954         string memory errorMessage
1955     ) internal view returns (bytes memory) {
1956         if (success) {
1957             if (returndata.length == 0) {
1958                 // only check isContract if the call was successful and the return data is empty
1959                 // otherwise we already know that it was a contract
1960                 require(isContract(target), "Address: call to non-contract");
1961             }
1962             return returndata;
1963         } else {
1964             _revert(returndata, errorMessage);
1965         }
1966     }
1967 
1968     /**
1969      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1970      * revert reason or using the provided one.
1971      *
1972      * _Available since v4.3._
1973      */
1974     function verifyCallResult(
1975         bool success,
1976         bytes memory returndata,
1977         string memory errorMessage
1978     ) internal pure returns (bytes memory) {
1979         if (success) {
1980             return returndata;
1981         } else {
1982             _revert(returndata, errorMessage);
1983         }
1984     }
1985 
1986     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1987         // Look for revert reason and bubble it up if present
1988         if (returndata.length > 0) {
1989             // The easiest way to bubble the revert reason is using memory via assembly
1990             /// @solidity memory-safe-assembly
1991             assembly {
1992                 let returndata_size := mload(returndata)
1993                 revert(add(32, returndata), returndata_size)
1994             }
1995         } else {
1996             revert(errorMessage);
1997         }
1998     }
1999 }
2000 
2001 // File: @openzeppelin/contracts/utils/Context.sol
2002 
2003 
2004 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2005 
2006 pragma solidity ^0.8.0;
2007 
2008 /**
2009  * @dev Provides information about the current execution context, including the
2010  * sender of the transaction and its data. While these are generally available
2011  * via msg.sender and msg.data, they should not be accessed in such a direct
2012  * manner, since when dealing with meta-transactions the account sending and
2013  * paying for execution may not be the actual sender (as far as an application
2014  * is concerned).
2015  *
2016  * This contract is only required for intermediate, library-like contracts.
2017  */
2018 abstract contract Context {
2019     function _msgSender() internal view virtual returns (address) {
2020         return msg.sender;
2021     }
2022 
2023     function _msgData() internal view virtual returns (bytes calldata) {
2024         return msg.data;
2025     }
2026 }
2027 
2028 // File: @openzeppelin/contracts/access/Ownable.sol
2029 
2030 
2031 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2032 
2033 pragma solidity ^0.8.0;
2034 
2035 
2036 /**
2037  * @dev Contract module which provides a basic access control mechanism, where
2038  * there is an account (an owner) that can be granted exclusive access to
2039  * specific functions.
2040  *
2041  * By default, the owner account will be the one that deploys the contract. This
2042  * can later be changed with {transferOwnership}.
2043  *
2044  * This module is used through inheritance. It will make available the modifier
2045  * `onlyOwner`, which can be applied to your functions to restrict their use to
2046  * the owner.
2047  */
2048 abstract contract Ownable is Context {
2049     address private _owner;
2050 
2051     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2052 
2053     /**
2054      * @dev Initializes the contract setting the deployer as the initial owner.
2055      */
2056     constructor() {
2057         _transferOwnership(_msgSender());
2058     }
2059 
2060     /**
2061      * @dev Throws if called by any account other than the owner.
2062      */
2063     modifier onlyOwner() {
2064         _checkOwner();
2065         _;
2066     }
2067 
2068     /**
2069      * @dev Returns the address of the current owner.
2070      */
2071     function owner() public view virtual returns (address) {
2072         return _owner;
2073     }
2074 
2075     /**
2076      * @dev Throws if the sender is not the owner.
2077      */
2078     function _checkOwner() internal view virtual {
2079         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2080     }
2081 
2082     /**
2083      * @dev Leaves the contract without owner. It will not be possible to call
2084      * `onlyOwner` functions anymore. Can only be called by the current owner.
2085      *
2086      * NOTE: Renouncing ownership will leave the contract without an owner,
2087      * thereby removing any functionality that is only available to the owner.
2088      */
2089     function renounceOwnership() public virtual onlyOwner {
2090         _transferOwnership(address(0));
2091     }
2092 
2093     /**
2094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2095      * Can only be called by the current owner.
2096      */
2097     function transferOwnership(address newOwner) public virtual onlyOwner {
2098         require(newOwner != address(0), "Ownable: new owner is the zero address");
2099         _transferOwnership(newOwner);
2100     }
2101 
2102     /**
2103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2104      * Internal function without access restriction.
2105      */
2106     function _transferOwnership(address newOwner) internal virtual {
2107         address oldOwner = _owner;
2108         _owner = newOwner;
2109         emit OwnershipTransferred(oldOwner, newOwner);
2110     }
2111 }
2112 
2113 // File: @openzeppelin/contracts/utils/math/Math.sol
2114 
2115 
2116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
2117 
2118 pragma solidity ^0.8.0;
2119 
2120 /**
2121  * @dev Standard math utilities missing in the Solidity language.
2122  */
2123 library Math {
2124     enum Rounding {
2125         Down, // Toward negative infinity
2126         Up, // Toward infinity
2127         Zero // Toward zero
2128     }
2129 
2130     /**
2131      * @dev Returns the largest of two numbers.
2132      */
2133     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2134         return a > b ? a : b;
2135     }
2136 
2137     /**
2138      * @dev Returns the smallest of two numbers.
2139      */
2140     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2141         return a < b ? a : b;
2142     }
2143 
2144     /**
2145      * @dev Returns the average of two numbers. The result is rounded towards
2146      * zero.
2147      */
2148     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2149         // (a + b) / 2 can overflow.
2150         return (a & b) + (a ^ b) / 2;
2151     }
2152 
2153     /**
2154      * @dev Returns the ceiling of the division of two numbers.
2155      *
2156      * This differs from standard division with `/` in that it rounds up instead
2157      * of rounding down.
2158      */
2159     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2160         // (a + b - 1) / b can overflow on addition, so we distribute.
2161         return a == 0 ? 0 : (a - 1) / b + 1;
2162     }
2163 
2164     /**
2165      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2166      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2167      * with further edits by Uniswap Labs also under MIT license.
2168      */
2169     function mulDiv(
2170         uint256 x,
2171         uint256 y,
2172         uint256 denominator
2173     ) internal pure returns (uint256 result) {
2174         unchecked {
2175             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2176             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2177             // variables such that product = prod1 * 2^256 + prod0.
2178             uint256 prod0; // Least significant 256 bits of the product
2179             uint256 prod1; // Most significant 256 bits of the product
2180             assembly {
2181                 let mm := mulmod(x, y, not(0))
2182                 prod0 := mul(x, y)
2183                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2184             }
2185 
2186             // Handle non-overflow cases, 256 by 256 division.
2187             if (prod1 == 0) {
2188                 return prod0 / denominator;
2189             }
2190 
2191             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2192             require(denominator > prod1);
2193 
2194             ///////////////////////////////////////////////
2195             // 512 by 256 division.
2196             ///////////////////////////////////////////////
2197 
2198             // Make division exact by subtracting the remainder from [prod1 prod0].
2199             uint256 remainder;
2200             assembly {
2201                 // Compute remainder using mulmod.
2202                 remainder := mulmod(x, y, denominator)
2203 
2204                 // Subtract 256 bit number from 512 bit number.
2205                 prod1 := sub(prod1, gt(remainder, prod0))
2206                 prod0 := sub(prod0, remainder)
2207             }
2208 
2209             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2210             // See https://cs.stackexchange.com/q/138556/92363.
2211 
2212             // Does not overflow because the denominator cannot be zero at this stage in the function.
2213             uint256 twos = denominator & (~denominator + 1);
2214             assembly {
2215                 // Divide denominator by twos.
2216                 denominator := div(denominator, twos)
2217 
2218                 // Divide [prod1 prod0] by twos.
2219                 prod0 := div(prod0, twos)
2220 
2221                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2222                 twos := add(div(sub(0, twos), twos), 1)
2223             }
2224 
2225             // Shift in bits from prod1 into prod0.
2226             prod0 |= prod1 * twos;
2227 
2228             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2229             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2230             // four bits. That is, denominator * inv = 1 mod 2^4.
2231             uint256 inverse = (3 * denominator) ^ 2;
2232 
2233             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2234             // in modular arithmetic, doubling the correct bits in each step.
2235             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2236             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2237             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2238             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2239             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2240             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2241 
2242             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2243             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2244             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2245             // is no longer required.
2246             result = prod0 * inverse;
2247             return result;
2248         }
2249     }
2250 
2251     /**
2252      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2253      */
2254     function mulDiv(
2255         uint256 x,
2256         uint256 y,
2257         uint256 denominator,
2258         Rounding rounding
2259     ) internal pure returns (uint256) {
2260         uint256 result = mulDiv(x, y, denominator);
2261         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2262             result += 1;
2263         }
2264         return result;
2265     }
2266 
2267     /**
2268      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2269      *
2270      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2271      */
2272     function sqrt(uint256 a) internal pure returns (uint256) {
2273         if (a == 0) {
2274             return 0;
2275         }
2276 
2277         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2278         //
2279         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2280         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2281         //
2282         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2283         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2284         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2285         //
2286         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2287         uint256 result = 1 << (log2(a) >> 1);
2288 
2289         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2290         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2291         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2292         // into the expected uint128 result.
2293         unchecked {
2294             result = (result + a / result) >> 1;
2295             result = (result + a / result) >> 1;
2296             result = (result + a / result) >> 1;
2297             result = (result + a / result) >> 1;
2298             result = (result + a / result) >> 1;
2299             result = (result + a / result) >> 1;
2300             result = (result + a / result) >> 1;
2301             return min(result, a / result);
2302         }
2303     }
2304 
2305     /**
2306      * @notice Calculates sqrt(a), following the selected rounding direction.
2307      */
2308     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2309         unchecked {
2310             uint256 result = sqrt(a);
2311             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2312         }
2313     }
2314 
2315     /**
2316      * @dev Return the log in base 2, rounded down, of a positive value.
2317      * Returns 0 if given 0.
2318      */
2319     function log2(uint256 value) internal pure returns (uint256) {
2320         uint256 result = 0;
2321         unchecked {
2322             if (value >> 128 > 0) {
2323                 value >>= 128;
2324                 result += 128;
2325             }
2326             if (value >> 64 > 0) {
2327                 value >>= 64;
2328                 result += 64;
2329             }
2330             if (value >> 32 > 0) {
2331                 value >>= 32;
2332                 result += 32;
2333             }
2334             if (value >> 16 > 0) {
2335                 value >>= 16;
2336                 result += 16;
2337             }
2338             if (value >> 8 > 0) {
2339                 value >>= 8;
2340                 result += 8;
2341             }
2342             if (value >> 4 > 0) {
2343                 value >>= 4;
2344                 result += 4;
2345             }
2346             if (value >> 2 > 0) {
2347                 value >>= 2;
2348                 result += 2;
2349             }
2350             if (value >> 1 > 0) {
2351                 result += 1;
2352             }
2353         }
2354         return result;
2355     }
2356 
2357     /**
2358      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2359      * Returns 0 if given 0.
2360      */
2361     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2362         unchecked {
2363             uint256 result = log2(value);
2364             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2365         }
2366     }
2367 
2368     /**
2369      * @dev Return the log in base 10, rounded down, of a positive value.
2370      * Returns 0 if given 0.
2371      */
2372     function log10(uint256 value) internal pure returns (uint256) {
2373         uint256 result = 0;
2374         unchecked {
2375             if (value >= 10**64) {
2376                 value /= 10**64;
2377                 result += 64;
2378             }
2379             if (value >= 10**32) {
2380                 value /= 10**32;
2381                 result += 32;
2382             }
2383             if (value >= 10**16) {
2384                 value /= 10**16;
2385                 result += 16;
2386             }
2387             if (value >= 10**8) {
2388                 value /= 10**8;
2389                 result += 8;
2390             }
2391             if (value >= 10**4) {
2392                 value /= 10**4;
2393                 result += 4;
2394             }
2395             if (value >= 10**2) {
2396                 value /= 10**2;
2397                 result += 2;
2398             }
2399             if (value >= 10**1) {
2400                 result += 1;
2401             }
2402         }
2403         return result;
2404     }
2405 
2406     /**
2407      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2408      * Returns 0 if given 0.
2409      */
2410     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2411         unchecked {
2412             uint256 result = log10(value);
2413             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2414         }
2415     }
2416 
2417     /**
2418      * @dev Return the log in base 256, rounded down, of a positive value.
2419      * Returns 0 if given 0.
2420      *
2421      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2422      */
2423     function log256(uint256 value) internal pure returns (uint256) {
2424         uint256 result = 0;
2425         unchecked {
2426             if (value >> 128 > 0) {
2427                 value >>= 128;
2428                 result += 16;
2429             }
2430             if (value >> 64 > 0) {
2431                 value >>= 64;
2432                 result += 8;
2433             }
2434             if (value >> 32 > 0) {
2435                 value >>= 32;
2436                 result += 4;
2437             }
2438             if (value >> 16 > 0) {
2439                 value >>= 16;
2440                 result += 2;
2441             }
2442             if (value >> 8 > 0) {
2443                 result += 1;
2444             }
2445         }
2446         return result;
2447     }
2448 
2449     /**
2450      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2451      * Returns 0 if given 0.
2452      */
2453     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2454         unchecked {
2455             uint256 result = log256(value);
2456             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2457         }
2458     }
2459 }
2460 
2461 // File: @openzeppelin/contracts/utils/Strings.sol
2462 
2463 
2464 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2465 
2466 pragma solidity ^0.8.0;
2467 
2468 
2469 /**
2470  * @dev String operations.
2471  */
2472 library Strings {
2473     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2474     uint8 private constant _ADDRESS_LENGTH = 20;
2475 
2476     /**
2477      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2478      */
2479     function toString(uint256 value) internal pure returns (string memory) {
2480         unchecked {
2481             uint256 length = Math.log10(value) + 1;
2482             string memory buffer = new string(length);
2483             uint256 ptr;
2484             /// @solidity memory-safe-assembly
2485             assembly {
2486                 ptr := add(buffer, add(32, length))
2487             }
2488             while (true) {
2489                 ptr--;
2490                 /// @solidity memory-safe-assembly
2491                 assembly {
2492                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2493                 }
2494                 value /= 10;
2495                 if (value == 0) break;
2496             }
2497             return buffer;
2498         }
2499     }
2500 
2501     /**
2502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2503      */
2504     function toHexString(uint256 value) internal pure returns (string memory) {
2505         unchecked {
2506             return toHexString(value, Math.log256(value) + 1);
2507         }
2508     }
2509 
2510     /**
2511      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2512      */
2513     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2514         bytes memory buffer = new bytes(2 * length + 2);
2515         buffer[0] = "0";
2516         buffer[1] = "x";
2517         for (uint256 i = 2 * length + 1; i > 1; --i) {
2518             buffer[i] = _SYMBOLS[value & 0xf];
2519             value >>= 4;
2520         }
2521         require(value == 0, "Strings: hex length insufficient");
2522         return string(buffer);
2523     }
2524 
2525     /**
2526      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2527      */
2528     function toHexString(address addr) internal pure returns (string memory) {
2529         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2530     }
2531 }
2532 
2533 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2534 
2535 
2536 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2537 
2538 pragma solidity ^0.8.0;
2539 
2540 /**
2541  * @dev Interface of the ERC20 standard as defined in the EIP.
2542  */
2543 interface IERC20 {
2544     /**
2545      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2546      * another (`to`).
2547      *
2548      * Note that `value` may be zero.
2549      */
2550     event Transfer(address indexed from, address indexed to, uint256 value);
2551 
2552     /**
2553      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2554      * a call to {approve}. `value` is the new allowance.
2555      */
2556     event Approval(address indexed owner, address indexed spender, uint256 value);
2557 
2558     /**
2559      * @dev Returns the amount of tokens in existence.
2560      */
2561     function totalSupply() external view returns (uint256);
2562 
2563     /**
2564      * @dev Returns the amount of tokens owned by `account`.
2565      */
2566     function balanceOf(address account) external view returns (uint256);
2567 
2568     /**
2569      * @dev Moves `amount` tokens from the caller's account to `to`.
2570      *
2571      * Returns a boolean value indicating whether the operation succeeded.
2572      *
2573      * Emits a {Transfer} event.
2574      */
2575     function transfer(address to, uint256 amount) external returns (bool);
2576 
2577     /**
2578      * @dev Returns the remaining number of tokens that `spender` will be
2579      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2580      * zero by default.
2581      *
2582      * This value changes when {approve} or {transferFrom} are called.
2583      */
2584     function allowance(address owner, address spender) external view returns (uint256);
2585 
2586     /**
2587      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2588      *
2589      * Returns a boolean value indicating whether the operation succeeded.
2590      *
2591      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2592      * that someone may use both the old and the new allowance by unfortunate
2593      * transaction ordering. One possible solution to mitigate this race
2594      * condition is to first reduce the spender's allowance to 0 and set the
2595      * desired value afterwards:
2596      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2597      *
2598      * Emits an {Approval} event.
2599      */
2600     function approve(address spender, uint256 amount) external returns (bool);
2601 
2602     /**
2603      * @dev Moves `amount` tokens from `from` to `to` using the
2604      * allowance mechanism. `amount` is then deducted from the caller's
2605      * allowance.
2606      *
2607      * Returns a boolean value indicating whether the operation succeeded.
2608      *
2609      * Emits a {Transfer} event.
2610      */
2611     function transferFrom(
2612         address from,
2613         address to,
2614         uint256 amount
2615     ) external returns (bool);
2616 }
2617 
2618 // File: @openzeppelin/contracts/interfaces/IERC20.sol
2619 
2620 
2621 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
2622 
2623 pragma solidity ^0.8.0;
2624 
2625 
2626 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2627 
2628 
2629 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2630 
2631 pragma solidity ^0.8.0;
2632 
2633 /**
2634  * @dev Contract module that helps prevent reentrant calls to a function.
2635  *
2636  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2637  * available, which can be applied to functions to make sure there are no nested
2638  * (reentrant) calls to them.
2639  *
2640  * Note that because there is a single `nonReentrant` guard, functions marked as
2641  * `nonReentrant` may not call one another. This can be worked around by making
2642  * those functions `private`, and then adding `external` `nonReentrant` entry
2643  * points to them.
2644  *
2645  * TIP: If you would like to learn more about reentrancy and alternative ways
2646  * to protect against it, check out our blog post
2647  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2648  */
2649 abstract contract ReentrancyGuard {
2650     // Booleans are more expensive than uint256 or any type that takes up a full
2651     // word because each write operation emits an extra SLOAD to first read the
2652     // slot's contents, replace the bits taken up by the boolean, and then write
2653     // back. This is the compiler's defense against contract upgrades and
2654     // pointer aliasing, and it cannot be disabled.
2655 
2656     // The values being non-zero value makes deployment a bit more expensive,
2657     // but in exchange the refund on every call to nonReentrant will be lower in
2658     // amount. Since refunds are capped to a percentage of the total
2659     // transaction's gas, it is best to keep them low in cases like this one, to
2660     // increase the likelihood of the full refund coming into effect.
2661     uint256 private constant _NOT_ENTERED = 1;
2662     uint256 private constant _ENTERED = 2;
2663 
2664     uint256 private _status;
2665 
2666     constructor() {
2667         _status = _NOT_ENTERED;
2668     }
2669 
2670     /**
2671      * @dev Prevents a contract from calling itself, directly or indirectly.
2672      * Calling a `nonReentrant` function from another `nonReentrant`
2673      * function is not supported. It is possible to prevent this from happening
2674      * by making the `nonReentrant` function external, and making it call a
2675      * `private` function that does the actual work.
2676      */
2677     modifier nonReentrant() {
2678         _nonReentrantBefore();
2679         _;
2680         _nonReentrantAfter();
2681     }
2682 
2683     function _nonReentrantBefore() private {
2684         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2685         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2686 
2687         // Any calls to nonReentrant after this point will fail
2688         _status = _ENTERED;
2689     }
2690 
2691     function _nonReentrantAfter() private {
2692         // By storing the original value once again, a refund is triggered (see
2693         // https://eips.ethereum.org/EIPS/eip-2200)
2694         _status = _NOT_ENTERED;
2695     }
2696 }
2697 
2698 // File: @openzeppelin/contracts/utils/Counters.sol
2699 
2700 
2701 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
2702 
2703 pragma solidity ^0.8.0;
2704 
2705 /**
2706  * @title Counters
2707  * @author Matt Condon (@shrugs)
2708  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
2709  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
2710  *
2711  * Include with `using Counters for Counters.Counter;`
2712  */
2713 library Counters {
2714     struct Counter {
2715         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2716         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2717         // this feature: see https://github.com/ethereum/solidity/issues/4637
2718         uint256 _value; // default: 0
2719     }
2720 
2721     function current(Counter storage counter) internal view returns (uint256) {
2722         return counter._value;
2723     }
2724 
2725     function increment(Counter storage counter) internal {
2726         unchecked {
2727             counter._value += 1;
2728         }
2729     }
2730 
2731     function decrement(Counter storage counter) internal {
2732         uint256 value = counter._value;
2733         require(value > 0, "Counter: decrement overflow");
2734         unchecked {
2735             counter._value = value - 1;
2736         }
2737     }
2738 
2739     function reset(Counter storage counter) internal {
2740         counter._value = 0;
2741     }
2742 }
2743 
2744 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2745 
2746 
2747 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
2748 
2749 pragma solidity ^0.8.0;
2750 
2751 // CAUTION
2752 // This version of SafeMath should only be used with Solidity 0.8 or later,
2753 // because it relies on the compiler's built in overflow checks.
2754 
2755 /**
2756  * @dev Wrappers over Solidity's arithmetic operations.
2757  *
2758  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
2759  * now has built in overflow checking.
2760  */
2761 library SafeMath {
2762     /**
2763      * @dev Returns the addition of two unsigned integers, with an overflow flag.
2764      *
2765      * _Available since v3.4._
2766      */
2767     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2768         unchecked {
2769             uint256 c = a + b;
2770             if (c < a) return (false, 0);
2771             return (true, c);
2772         }
2773     }
2774 
2775     /**
2776      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
2777      *
2778      * _Available since v3.4._
2779      */
2780     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2781         unchecked {
2782             if (b > a) return (false, 0);
2783             return (true, a - b);
2784         }
2785     }
2786 
2787     /**
2788      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2789      *
2790      * _Available since v3.4._
2791      */
2792     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2793         unchecked {
2794             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2795             // benefit is lost if 'b' is also tested.
2796             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2797             if (a == 0) return (true, 0);
2798             uint256 c = a * b;
2799             if (c / a != b) return (false, 0);
2800             return (true, c);
2801         }
2802     }
2803 
2804     /**
2805      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2806      *
2807      * _Available since v3.4._
2808      */
2809     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2810         unchecked {
2811             if (b == 0) return (false, 0);
2812             return (true, a / b);
2813         }
2814     }
2815 
2816     /**
2817      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2818      *
2819      * _Available since v3.4._
2820      */
2821     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2822         unchecked {
2823             if (b == 0) return (false, 0);
2824             return (true, a % b);
2825         }
2826     }
2827 
2828     /**
2829      * @dev Returns the addition of two unsigned integers, reverting on
2830      * overflow.
2831      *
2832      * Counterpart to Solidity's `+` operator.
2833      *
2834      * Requirements:
2835      *
2836      * - Addition cannot overflow.
2837      */
2838     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2839         return a + b;
2840     }
2841 
2842     /**
2843      * @dev Returns the subtraction of two unsigned integers, reverting on
2844      * overflow (when the result is negative).
2845      *
2846      * Counterpart to Solidity's `-` operator.
2847      *
2848      * Requirements:
2849      *
2850      * - Subtraction cannot overflow.
2851      */
2852     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2853         return a - b;
2854     }
2855 
2856     /**
2857      * @dev Returns the multiplication of two unsigned integers, reverting on
2858      * overflow.
2859      *
2860      * Counterpart to Solidity's `*` operator.
2861      *
2862      * Requirements:
2863      *
2864      * - Multiplication cannot overflow.
2865      */
2866     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2867         return a * b;
2868     }
2869 
2870     /**
2871      * @dev Returns the integer division of two unsigned integers, reverting on
2872      * division by zero. The result is rounded towards zero.
2873      *
2874      * Counterpart to Solidity's `/` operator.
2875      *
2876      * Requirements:
2877      *
2878      * - The divisor cannot be zero.
2879      */
2880     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2881         return a / b;
2882     }
2883 
2884     /**
2885      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2886      * reverting when dividing by zero.
2887      *
2888      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2889      * opcode (which leaves remaining gas untouched) while Solidity uses an
2890      * invalid opcode to revert (consuming all remaining gas).
2891      *
2892      * Requirements:
2893      *
2894      * - The divisor cannot be zero.
2895      */
2896     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2897         return a % b;
2898     }
2899 
2900     /**
2901      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2902      * overflow (when the result is negative).
2903      *
2904      * CAUTION: This function is deprecated because it requires allocating memory for the error
2905      * message unnecessarily. For custom revert reasons use {trySub}.
2906      *
2907      * Counterpart to Solidity's `-` operator.
2908      *
2909      * Requirements:
2910      *
2911      * - Subtraction cannot overflow.
2912      */
2913     function sub(
2914         uint256 a,
2915         uint256 b,
2916         string memory errorMessage
2917     ) internal pure returns (uint256) {
2918         unchecked {
2919             require(b <= a, errorMessage);
2920             return a - b;
2921         }
2922     }
2923 
2924     /**
2925      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2926      * division by zero. The result is rounded towards zero.
2927      *
2928      * Counterpart to Solidity's `/` operator. Note: this function uses a
2929      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2930      * uses an invalid opcode to revert (consuming all remaining gas).
2931      *
2932      * Requirements:
2933      *
2934      * - The divisor cannot be zero.
2935      */
2936     function div(
2937         uint256 a,
2938         uint256 b,
2939         string memory errorMessage
2940     ) internal pure returns (uint256) {
2941         unchecked {
2942             require(b > 0, errorMessage);
2943             return a / b;
2944         }
2945     }
2946 
2947     /**
2948      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2949      * reverting with custom message when dividing by zero.
2950      *
2951      * CAUTION: This function is deprecated because it requires allocating memory for the error
2952      * message unnecessarily. For custom revert reasons use {tryMod}.
2953      *
2954      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2955      * opcode (which leaves remaining gas untouched) while Solidity uses an
2956      * invalid opcode to revert (consuming all remaining gas).
2957      *
2958      * Requirements:
2959      *
2960      * - The divisor cannot be zero.
2961      */
2962     function mod(
2963         uint256 a,
2964         uint256 b,
2965         string memory errorMessage
2966     ) internal pure returns (uint256) {
2967         unchecked {
2968             require(b > 0, errorMessage);
2969             return a % b;
2970         }
2971     }
2972 }
2973 
2974 // File: wallpaper/wallpapernft.sol
2975 
2976 //SPDX-License-Identifier: MIT
2977 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
2978 
2979 pragma solidity ^0.8.0;
2980 
2981 
2982 
2983 
2984 
2985 
2986 
2987 
2988 
2989 
2990 
2991 
2992 
2993 
2994 
2995 
2996 
2997 
2998 
2999 
3000 
3001 
3002 
3003 
3004 
3005 contract wallpaperpixwtf is ERC721A, IERC2981, Ownable, ReentrancyGuard {
3006     using Counters for Counters.Counter;
3007     using Strings for uint256;
3008 
3009     Counters.Counter private tokenCounter;
3010 
3011     string private baseURI = "ipfs://bafybeicmindhbdofbw5miuuypu4bi277q2wsnn7hmhvdtbwbjgt2vcknra/";
3012     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
3013     bool private isOpenSeaProxyActive = true;
3014 
3015     uint256 public constant MAX_MINTS_PER_TX = 3;
3016     uint256 public maxSupply = 999;
3017 
3018     uint256 public constant PUBLIC_SALE_PRICE = 0.005 ether;
3019     uint256 public NUM_FREE_MINTS = 69 ;
3020     bool public isPublicSaleActive = true;
3021 
3022 
3023 
3024 
3025     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
3026 
3027     modifier publicSaleActive() {
3028         require(isPublicSaleActive, "Public sale is not open");
3029         _;
3030     }
3031 
3032 
3033 
3034     modifier maxMintsPerTX(uint256 numberOfTokens) {
3035         require(
3036             numberOfTokens <= MAX_MINTS_PER_TX,
3037             "Max mints per transaction exceeded"
3038         );
3039         _;
3040     }
3041 
3042     modifier canMintNFTs(uint256 numberOfTokens) {
3043         require(
3044             totalSupply() + numberOfTokens <=
3045                 maxSupply,
3046             "Not enough mints remaining to mint"
3047         );
3048         _;
3049     }
3050 
3051     modifier freeMintsAvailable() {
3052         require(
3053             totalSupply() <=
3054                 NUM_FREE_MINTS,
3055             "Not enough free mints remain"
3056         );
3057         _;
3058     }
3059 
3060 
3061 
3062     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
3063         if(totalSupply()>NUM_FREE_MINTS){
3064         require(
3065             (price * numberOfTokens) == msg.value,
3066             "Incorrect ETH value sent"
3067         );
3068         }
3069         _;
3070     }
3071 
3072 
3073     constructor() ERC721A("wallpaperspix.wtf", "wp") {}
3074 
3075     // ============ PUBLIC FUNCTIONS FOR MINTING ============
3076 
3077     function mint(uint256 numberOfTokens)
3078         external
3079         payable
3080         nonReentrant
3081         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
3082         publicSaleActive
3083         canMintNFTs(numberOfTokens)
3084         maxMintsPerTX(numberOfTokens)
3085     {
3086 
3087         _safeMint(msg.sender, numberOfTokens);
3088     }
3089 
3090 
3091 
3092     //A simple free mint function to avoid confusion
3093     //The normal mint function with a cost of 0 would work too
3094 
3095     // ============ PUBLIC READ-ONLY FUNCTIONS ============
3096 
3097     function getBaseURI() external view returns (string memory) {
3098         return baseURI;
3099     }
3100 
3101     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
3102 
3103     function setBaseURI(string memory _baseURI) external onlyOwner {
3104         baseURI = _baseURI;
3105     }
3106 
3107     // function to disable gasless listings for security in case
3108     // opensea ever shuts down or is compromised
3109     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
3110         external
3111         onlyOwner
3112     {
3113         isOpenSeaProxyActive = _isOpenSeaProxyActive;
3114     }
3115 
3116     function setIsPublicSaleActive(bool _isPublicSaleActive)
3117         external
3118         onlyOwner
3119     {
3120         isPublicSaleActive = _isPublicSaleActive;
3121     }
3122 
3123 
3124     function setNumFreeMints(uint256 _numfreemints)
3125         external
3126         onlyOwner
3127     {
3128         NUM_FREE_MINTS = _numfreemints;
3129     }
3130 
3131 
3132     function withdraw() public onlyOwner {
3133         uint256 balance = address(this).balance;
3134         payable(msg.sender).transfer(balance);
3135     }
3136 
3137     function withdrawTokens(IERC20 token) public onlyOwner {
3138         uint256 balance = token.balanceOf(address(this));
3139         token.transfer(msg.sender, balance);
3140     }
3141 
3142 
3143 
3144     // ============ SUPPORTING FUNCTIONS ============
3145 
3146     function nextTokenId() private returns (uint256) {
3147         tokenCounter.increment();
3148         return tokenCounter.current();
3149     }
3150 
3151     // ============ FUNCTION OVERRIDES ============
3152 
3153     function supportsInterface(bytes4 interfaceId)
3154         public
3155         view
3156         virtual
3157         override(ERC721A, IERC165)
3158         returns (bool)
3159     {
3160         return
3161             interfaceId == type(IERC2981).interfaceId ||
3162             super.supportsInterface(interfaceId);
3163     }
3164 
3165     /**
3166      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
3167      */
3168     function isApprovedForAll(address owner, address operator)
3169         public
3170         view
3171         override
3172         returns (bool)
3173     {
3174         // Get a reference to OpenSea's proxy registry contract by instantiating
3175         // the contract using the already existing address.
3176         ProxyRegistry proxyRegistry = ProxyRegistry(
3177             openSeaProxyRegistryAddress
3178         );
3179         if (
3180             isOpenSeaProxyActive &&
3181             address(proxyRegistry.proxies(owner)) == operator
3182         ) {
3183             return true;
3184         }
3185 
3186         return super.isApprovedForAll(owner, operator);
3187     }
3188 
3189     /**
3190      * @dev See {IERC721Metadata-tokenURI}.
3191      */
3192     function tokenURI(uint256 tokenId)
3193         public
3194         view
3195         virtual
3196         override
3197         returns (string memory)
3198     {
3199         require(_exists(tokenId), "Nonexistent token");
3200 
3201         return
3202             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
3203     }
3204 
3205     /**
3206      * @dev See {IERC165-royaltyInfo}.
3207      */
3208     function royaltyInfo(uint256 tokenId, uint256 salePrice)
3209         external
3210         view
3211         override
3212         returns (address receiver, uint256 royaltyAmount)
3213     {
3214         require(_exists(tokenId), "Nonexistent token");
3215 
3216         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
3217     }
3218 }
3219 
3220 // These contract definitions are used to create a reference to the OpenSea
3221 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
3222 contract OwnableDelegateProxy {
3223 
3224 }
3225 
3226 contract ProxyRegistry {
3227     mapping(address => OwnableDelegateProxy) public proxies;
3228 }