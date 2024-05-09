1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 pragma solidity ^0.8.17;
5 
6 /**
7  * @dev Interface of ERC721A.
8  */
9 interface IERC721A {
10     /**
11      * The caller must own the token or be an approved operator.
12      */
13     error ApprovalCallerNotOwnerNorApproved();
14 
15     /**
16      * The token does not exist.
17      */
18     error ApprovalQueryForNonexistentToken();
19 
20     /**
21      * Cannot query the balance for the zero address.
22      */
23     error BalanceQueryForZeroAddress();
24 
25     /**
26      * Cannot mint to the zero address.
27      */
28     error MintToZeroAddress();
29 
30     /**
31      * The quantity of tokens minted must be more than zero.
32      */
33     error MintZeroQuantity();
34 
35     /**
36      * The token does not exist.
37      */
38     error OwnerQueryForNonexistentToken();
39 
40     /**
41      * The caller must own the token or be an approved operator.
42      */
43     error TransferCallerNotOwnerNorApproved();
44 
45     /**
46      * The token must be owned by `from`.
47      */
48     error TransferFromIncorrectOwner();
49 
50     /**
51      * Cannot safely transfer to a contract that does not implement the
52      * ERC721Receiver interface.
53      */
54     error TransferToNonERC721ReceiverImplementer();
55 
56     /**
57      * Cannot transfer to the zero address.
58      */
59     error TransferToZeroAddress();
60 
61     /**
62      * The token does not exist.
63      */
64     error URIQueryForNonexistentToken();
65 
66     /**
67      * The `quantity` minted with ERC2309 exceeds the safety limit.
68      */
69     error MintERC2309QuantityExceedsLimit();
70 
71     /**
72      * The `extraData` cannot be set on an unintialized ownership slot.
73      */
74     error OwnershipNotInitializedForExtraData();
75 
76     // =============================================================
77     //                            STRUCTS
78     // =============================================================
79 
80     struct TokenOwnership {
81         // The address of the owner.
82         address addr;
83         // Stores the start time of ownership with minimal overhead for tokenomics.
84         uint64 startTimestamp;
85         // Whether the token has been burned.
86         bool burned;
87         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
88         uint24 extraData;
89     }
90 
91     // =============================================================
92     //                         TOKEN COUNTERS
93     // =============================================================
94 
95     /**
96      * @dev Returns the total number of tokens in existence.
97      * Burned tokens will reduce the count.
98      * To get the total number of tokens minted, please see {_totalMinted}.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     // =============================================================
103     //                            IERC165
104     // =============================================================
105 
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 
116     // =============================================================
117     //                            IERC721
118     // =============================================================
119 
120     /**
121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
127      */
128     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables or disables
132      * (`approved`) `operator` to manage all of its assets.
133      */
134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
135 
136     /**
137      * @dev Returns the number of tokens in `owner`'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`,
152      * checking first that contract recipients are aware of the ERC721 protocol
153      * to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move
161      * this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement
163      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external payable;
173 
174     /**
175      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId
181     ) external payable;
182 
183     /**
184      * @dev Transfers `tokenId` from `from` to `to`.
185      *
186      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
187      * whenever possible.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token
195      * by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external payable;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the
210      * zero address clears previous approvals.
211      *
212      * Requirements:
213      *
214      * - The caller must own the token or be an approved operator.
215      * - `tokenId` must exist.
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address to, uint256 tokenId) external payable;
220 
221     /**
222      * @dev Approve or remove `operator` as an operator for the caller.
223      * Operators can call {transferFrom} or {safeTransferFrom}
224      * for any token owned by the caller.
225      *
226      * Requirements:
227      *
228      * - The `operator` cannot be the caller.
229      *
230      * Emits an {ApprovalForAll} event.
231      */
232     function setApprovalForAll(address operator, bool _approved) external;
233 
234     /**
235      * @dev Returns the account approved for `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function getApproved(uint256 tokenId) external view returns (address operator);
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}.
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     // =============================================================
251     //                        IERC721Metadata
252     // =============================================================
253 
254     /**
255      * @dev Returns the token collection name.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the token collection symbol.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
266      */
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 
269     // =============================================================
270     //                           IERC2309
271     // =============================================================
272 
273     /**
274      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
275      * (inclusive) is transferred from `from` to `to`, as defined in the
276      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
277      *
278      * See {_mintERC2309} for more details.
279      */
280     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
281 }
282 
283 /**
284  * @title ERC721A
285  *
286  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
287  * Non-Fungible Token Standard, including the Metadata extension.
288  * Optimized for lower gas during batch mints.
289  *
290  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
291  * starting from `_startTokenId()`.
292  *
293  * Assumptions:
294  *
295  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
296  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
490         if (owner == address(0)) revert BalanceQueryForZeroAddress();
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
575         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
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
594     // The `Address` event signature is given by:
595     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
596         
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         return address(uint160(_packedOwnershipOf(tokenId)));
606     }
607 
608     /**
609      * @dev Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around over time.
611      */
612     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnershipOf(tokenId));
614     }
615 
616     /**
617      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
618      */
619     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
620         return _unpackedOwnership(_packedOwnerships[index]);
621     }
622 
623     /**
624      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
625      */
626     function _initializeOwnershipAt(uint256 index) internal virtual {
627         if (_packedOwnerships[index] == 0) {
628             _packedOwnerships[index] = _packedOwnershipOf(index);
629         }
630     }
631 
632     /**
633      * Returns the packed ownership data of `tokenId`.
634      */
635     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
636         uint256 curr = tokenId;
637 
638         unchecked {
639             if (_startTokenId() <= curr)
640                 if (curr < _currentIndex) {
641                     uint256 packed = _packedOwnerships[curr];
642                     // If not burned.
643                     if (packed & _BITMASK_BURNED == 0) {
644                         // Invariant:
645                         // There will always be an initialized ownership slot
646                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
647                         // before an unintialized ownership slot
648                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
649                         // Hence, `curr` will not underflow.
650                         //
651                         // We can directly compare the packed value.
652                         // If the address is zero, packed will be zero.
653                         while (packed == 0) {
654                             packed = _packedOwnerships[--curr];
655                         }
656                         return packed;
657                     }
658                 }
659         }
660         revert OwnerQueryForNonexistentToken();
661     }
662 
663     /**
664      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
665      */
666     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
667         ownership.addr = address(uint160(packed));
668         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
669         ownership.burned = packed & _BITMASK_BURNED != 0;
670         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
671     }
672 
673     /**
674      * @dev Packs ownership data into a single uint256.
675      */
676     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
677         assembly {
678             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
679             owner := and(owner, _BITMASK_ADDRESS)
680             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
681             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
682         }
683     }
684 
685     /**
686      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
687      */
688     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
689         // For branchless setting of the `nextInitialized` flag.
690         assembly {
691             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
692             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
693         }
694     }
695 
696     // =============================================================
697     //                      APPROVAL OPERATIONS
698     // =============================================================
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the
705      * zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) public payable virtual override {
715         address owner = ownerOf(tokenId);
716 
717         if (_msgSenderERC721A() != owner)
718             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
719                 revert ApprovalCallerNotOwnerNorApproved();
720             }
721 
722         _tokenApprovals[tokenId].value = to;
723         emit Approval(owner, to, tokenId);
724     }
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) public view virtual override returns (address) {
734         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
735 
736         return _tokenApprovals[tokenId].value;
737     }
738 
739     /**
740      * @dev Approve or remove `operator` as an operator for the caller.
741      * Operators can call {transferFrom} or {safeTransferFrom}
742      * for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool approved) public virtual override {
751         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
752         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
753     }
754 
755     /**
756      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
757      *
758      * See {setApprovalForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted. See {_mint}.
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return
773             _startTokenId() <= tokenId &&
774             tokenId < _currentIndex && // If within bounds,
775             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
776     }
777 
778     /**
779      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
780      */
781     function _isSenderApprovedOrOwner(
782         address approvedAddress,
783         address owner,
784         address msgSender
785     ) private pure returns (bool result) {
786         assembly {
787             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             owner := and(owner, _BITMASK_ADDRESS)
789             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             msgSender := and(msgSender, _BITMASK_ADDRESS)
791             // `msgSender == owner || msgSender == approvedAddress`.
792             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
793         }
794     }
795 
796     /**
797      * @dev Returns the storage slot and value for the approved address of `tokenId`.
798      */
799     function _getApprovedSlotAndAddress(uint256 tokenId)
800         private
801         view
802         returns (uint256 approvedAddressSlot, address approvedAddress)
803     {
804         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
805         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
806         assembly {
807             approvedAddressSlot := tokenApproval.slot
808             approvedAddress := sload(approvedAddressSlot)
809         }
810     }
811 
812     // =============================================================
813     //                      TRANSFER OPERATIONS
814     // =============================================================
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      * - If the caller is not `from`, it must be approved to move this token
825      * by either {approve} or {setApprovalForAll}.
826      *
827      * Emits a {Transfer} event.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public payable virtual override {
834         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
835 
836         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
837 
838         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
839 
840         // The nested ifs save around 20+ gas over a compound boolean condition.
841         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
842             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
843 
844         if (to == address(0)) revert TransferToZeroAddress();
845 
846         _beforeTokenTransfers(from, to, tokenId, 1);
847 
848         // Clear approvals from the previous owner.
849         assembly {
850             if approvedAddress {
851                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
852                 sstore(approvedAddressSlot, 0)
853             }
854         }
855 
856         // Underflow of the sender's balance is impossible because we check for
857         // ownership above and the recipient's balance can't realistically overflow.
858         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
859         unchecked {
860             // We can directly increment and decrement the balances.
861             --_packedAddressData[from]; // Updates: `balance -= 1`.
862             ++_packedAddressData[to]; // Updates: `balance += 1`.
863 
864             // Updates:
865             // - `address` to the next owner.
866             // - `startTimestamp` to the timestamp of transfering.
867             // - `burned` to `false`.
868             // - `nextInitialized` to `true`.
869             _packedOwnerships[tokenId] = _packOwnershipData(
870                 to,
871                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
872             );
873 
874             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
875             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
876                 uint256 nextTokenId = tokenId + 1;
877                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
878                 if (_packedOwnerships[nextTokenId] == 0) {
879                     // If the next slot is within bounds.
880                     if (nextTokenId != _currentIndex) {
881                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
882                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
883                     }
884                 }
885             }
886         }
887 
888         emit Transfer(from, to, tokenId);
889         _afterTokenTransfers(from, to, tokenId, 1);
890     }
891 
892     /**
893      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public payable virtual override {
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If the caller is not `from`, it must be approved to move this token
912      * by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement
914      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) public payable virtual override {
924         transferFrom(from, to, tokenId);
925         if (to.code.length != 0)
926             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
927                 revert TransferToNonERC721ReceiverImplementer();
928             }
929     }
930 
931     /**
932      * @dev Hook that is called before a set of serially-ordered token IDs
933      * are about to be transferred. This includes minting.
934      * And also called before burning one token.
935      *
936      * `startTokenId` - the first token ID to be transferred.
937      * `quantity` - the amount to be transferred.
938      *
939      * Calling conditions:
940      *
941      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
942      * transferred to `to`.
943      * - When `from` is zero, `tokenId` will be minted for `to`.
944      * - When `to` is zero, `tokenId` will be burned by `from`.
945      * - `from` and `to` are never both zero.
946      */
947     function _beforeTokenTransfers(
948         address from,
949         address to,
950         uint256 startTokenId,
951         uint256 quantity
952     ) internal virtual {}
953 
954     /**
955      * @dev Hook that is called after a set of serially-ordered token IDs
956      * have been transferred. This includes minting.
957      * And also called after one token has been burned.
958      *
959      * `startTokenId` - the first token ID to be transferred.
960      * `quantity` - the amount to be transferred.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` has been minted for `to`.
967      * - When `to` is zero, `tokenId` has been burned by `from`.
968      * - `from` and `to` are never both zero.
969      */
970     function _afterTokenTransfers(
971         address from,
972         address to,
973         uint256 startTokenId,
974         uint256 quantity
975     ) internal virtual {}
976 
977     /**
978      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
979      *
980      * `from` - Previous owner of the given token ID.
981      * `to` - Target address that will receive the token.
982      * `tokenId` - Token ID to be transferred.
983      * `_data` - Optional data to send along with the call.
984      *
985      * Returns whether the call correctly returned the expected magic value.
986      */
987     function _checkContractOnERC721Received(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) private returns (bool) {
993         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
994             bytes4 retval
995         ) {
996             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
997         } catch (bytes memory reason) {
998             if (reason.length == 0) {
999                 revert TransferToNonERC721ReceiverImplementer();
1000             } else {
1001                 assembly {
1002                     revert(add(32, reason), mload(reason))
1003                 }
1004             }
1005         }
1006     }
1007 
1008     // =============================================================
1009     //                        MINT OPERATIONS
1010     // =============================================================
1011 
1012     /**
1013      * @dev Mints `quantity` tokens and transfers them to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * Emits a {Transfer} event for each mint.
1021      */
1022     function _mint(address to, uint256 quantity) internal virtual {
1023         uint256 startTokenId = _currentIndex;
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // `balance` and `numberMinted` have a maximum limit of 2**64.
1030         // `tokenId` has a maximum limit of 2**256.
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the `balance` and `numberMinted`.
1037             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] = _packOwnershipData(
1045                 to,
1046                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1047             );
1048 
1049             uint256 toMasked;
1050             uint256 end = startTokenId + quantity;
1051 
1052             // Use assembly to loop and emit the `Transfer` event for gas savings.
1053             // The duplicated `log4` removes an extra check and reduces stack juggling.
1054             // The assembly, together with the surrounding Solidity code, have been
1055             // delicately arranged to nudge the compiler into producing optimized opcodes.
1056             assembly {
1057                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058                 toMasked := and(to, _BITMASK_ADDRESS)
1059                 // Emit the `Transfer` event.
1060                 log4(
1061                     0, // Start of data (0, since no data).
1062                     0, // End of data (0, since no data).
1063                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1064                     0, // `address(0)`.
1065                     toMasked, // `to`.
1066                     startTokenId // `tokenId`.
1067                 )
1068 
1069                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1070                 // that overflows uint256 will make the loop run out of gas.
1071                 // The compiler will optimize the `iszero` away for performance.
1072                 for {
1073                     let tokenId := add(startTokenId, 1)
1074                 } iszero(eq(tokenId, end)) {
1075                     tokenId := add(tokenId, 1)
1076                 } {
1077                     // Emit the `Transfer` event. Similar to above.
1078                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1079                 }
1080             }
1081             if (toMasked == 0) revert MintToZeroAddress();
1082 
1083             _currentIndex = end;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * This function is intended for efficient minting only during contract creation.
1092      *
1093      * It emits only one {ConsecutiveTransfer} as defined in
1094      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1095      * instead of a sequence of {Transfer} event(s).
1096      *
1097      * Calling this function outside of contract creation WILL make your contract
1098      * non-compliant with the ERC721 standard.
1099      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1100      * {ConsecutiveTransfer} event is only permissible during contract creation.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {ConsecutiveTransfer} event.
1108      */
1109     function _mintERC2309(address to, uint256 quantity) internal virtual {
1110         uint256 startTokenId = _currentIndex;
1111         if (to == address(0)) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1118         unchecked {
1119             // Updates:
1120             // - `balance += quantity`.
1121             // - `numberMinted += quantity`.
1122             //
1123             // We can directly add to the `balance` and `numberMinted`.
1124             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1125 
1126             // Updates:
1127             // - `address` to the owner.
1128             // - `startTimestamp` to the timestamp of minting.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `quantity == 1`.
1131             _packedOwnerships[startTokenId] = _packOwnershipData(
1132                 to,
1133                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1134             );
1135 
1136             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1137 
1138             _currentIndex = startTokenId + quantity;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - If `to` refers to a smart contract, it must implement
1149      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * See {_mint}.
1153      *
1154      * Emits a {Transfer} event for each mint.
1155      */
1156     function _safeMint(
1157         address to,
1158         uint256 quantity,
1159         bytes memory _data
1160     ) internal virtual {
1161         _mint(to, quantity);
1162 
1163         unchecked {
1164             if (to.code.length != 0) {
1165                 uint256 end = _currentIndex;
1166                 uint256 index = end - quantity;
1167                 do {
1168                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1169                         revert TransferToNonERC721ReceiverImplementer();
1170                     }
1171                 } while (index < end);
1172                 // Reentrancy protection.
1173                 if (_currentIndex != end) revert();
1174             }
1175         }
1176     }
1177 
1178     /**
1179      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1180      */
1181     function _safeMint(address to, uint256 quantity) internal virtual {
1182         _safeMint(to, quantity, '');
1183     }
1184 
1185     // =============================================================
1186     //                        BURN OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Equivalent to `_burn(tokenId, false)`.
1191      */
1192     function _burn(uint256 tokenId) internal virtual {
1193         _burn(tokenId, false);
1194     }
1195 
1196     /**
1197      * @dev Destroys `tokenId`.
1198      * The approval is cleared when the token is burned.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1207         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1208 
1209         address from = address(uint160(prevOwnershipPacked));
1210 
1211         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1212 
1213         if (approvalCheck) {
1214             // The nested ifs save around 20+ gas over a compound boolean condition.
1215             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1216                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1217         }
1218 
1219         _beforeTokenTransfers(from, address(0), tokenId, 1);
1220 
1221         // Clear approvals from the previous owner.
1222         assembly {
1223             if approvedAddress {
1224                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1225                 sstore(approvedAddressSlot, 0)
1226             }
1227         }
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1232         unchecked {
1233             // Updates:
1234             // - `balance -= 1`.
1235             // - `numberBurned += 1`.
1236             //
1237             // We can directly decrement the balance, and increment the number burned.
1238             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1239             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1240 
1241             // Updates:
1242             // - `address` to the last owner.
1243             // - `startTimestamp` to the timestamp of burning.
1244             // - `burned` to `true`.
1245             // - `nextInitialized` to `true`.
1246             _packedOwnerships[tokenId] = _packOwnershipData(
1247                 from,
1248                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1249             );
1250 
1251             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1252             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1253                 uint256 nextTokenId = tokenId + 1;
1254                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1255                 if (_packedOwnerships[nextTokenId] == 0) {
1256                     // If the next slot is within bounds.
1257                     if (nextTokenId != _currentIndex) {
1258                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1259                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1260                     }
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, address(0), tokenId);
1266         _afterTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     // =============================================================
1275     //                     EXTRA DATA OPERATIONS
1276     // =============================================================
1277 
1278     /**
1279      * @dev Directly sets the extra data for the ownership data `index`.
1280      */
1281     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1282         uint256 packed = _packedOwnerships[index];
1283         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1284         uint256 extraDataCasted;
1285         // Cast `extraData` with assembly to avoid redundant masking.
1286         assembly {
1287             extraDataCasted := extraData
1288         }
1289         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1290         _packedOwnerships[index] = packed;
1291     }
1292 
1293     /**
1294      * @dev Called during each token transfer to set the 24bit `extraData` field.
1295      * Intended to be overridden by the cosumer contract.
1296      *
1297      * `previousExtraData` - the value of `extraData` before transfer.
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` will be minted for `to`.
1304      * - When `to` is zero, `tokenId` will be burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _extraData(
1308         address from,
1309         address to,
1310         uint24 previousExtraData
1311     ) internal view virtual returns (uint24) {}
1312 
1313     /**
1314      * @dev Returns the next extra data for the packed ownership data.
1315      * The returned result is shifted into position.
1316      */
1317     function _nextExtraData(
1318         address from,
1319         address to,
1320         uint256 prevOwnershipPacked
1321     ) private view returns (uint256) {
1322         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1323         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1324     }
1325 
1326     // =============================================================
1327     //                       OTHER OPERATIONS
1328     // =============================================================
1329 
1330     /**
1331      * @dev Returns the message sender (defaults to `msg.sender`).
1332      *
1333      * If you are writing GSN compatible contracts, you need to override this function.
1334      */
1335     function _msgSenderERC721A() internal view virtual returns (address) {
1336         return msg.sender;
1337     }
1338 
1339     /**
1340      * @dev Converts a uint256 to its ASCII string decimal representation.
1341      */
1342     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1343         assembly {
1344             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1345             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1346             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1347             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1348             let m := add(mload(0x40), 0xa0)
1349             // Update the free memory pointer to allocate.
1350             mstore(0x40, m)
1351             // Assign the `str` to the end.
1352             str := sub(m, 0x20)
1353             // Zeroize the slot after the string.
1354             mstore(str, 0)
1355 
1356             // Cache the end of the memory to calculate the length later.
1357             let end := str
1358 
1359             // We write the string from rightmost digit to leftmost digit.
1360             // The following is essentially a do-while loop that also handles the zero case.
1361             // prettier-ignore
1362             for { let temp := value } 1 {} {
1363                 str := sub(str, 1)
1364                 // Write the character to the pointer.
1365                 // The ASCII index of the '0' character is 48.
1366                 mstore8(str, add(48, mod(temp, 10)))
1367                 // Keep dividing `temp` until zero.
1368                 temp := div(temp, 10)
1369                 // prettier-ignore
1370                 if iszero(temp) { break }
1371             }
1372 
1373             let length := sub(end, str)
1374             // Move the pointer 32 bytes leftwards to make room for the length.
1375             str := sub(str, 0x20)
1376             // Store the length.
1377             mstore(str, length)
1378         }
1379     }
1380 }
1381 
1382 
1383 interface IOperatorFilterRegistry {
1384     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1385     function register(address registrant) external;
1386     function registerAndSubscribe(address registrant, address subscription) external;
1387     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1388     function unregister(address addr) external;
1389     function updateOperator(address registrant, address operator, bool filtered) external;
1390     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1391     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1392     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1393     function subscribe(address registrant, address registrantToSubscribe) external;
1394     function unsubscribe(address registrant, bool copyExistingEntries) external;
1395     function subscriptionOf(address addr) external returns (address registrant);
1396     function subscribers(address registrant) external returns (address[] memory);
1397     function subscriberAt(address registrant, uint256 index) external returns (address);
1398     function copyEntriesOf(address registrant, address registrantToCopy) external;
1399     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1400     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1401     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1402     function filteredOperators(address addr) external returns (address[] memory);
1403     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1404     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1405     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1406     function isRegistered(address addr) external returns (bool);
1407     function codeHashOf(address addr) external returns (bytes32);
1408 }
1409 
1410 
1411 /**
1412  * @title  OperatorFilterer
1413  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1414  *         registrant's entries in the OperatorFilterRegistry.
1415  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1416  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1417  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1418  */
1419 abstract contract OperatorFilterer {
1420     error OperatorNotAllowed(address operator);
1421 
1422     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1423         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1424 
1425     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1426         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1427         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1428         // order for the modifier to filter addresses.
1429         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1430             if (subscribe) {
1431                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1432             } else {
1433                 if (subscriptionOrRegistrantToCopy != address(0)) {
1434                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1435                 } else {
1436                     OPERATOR_FILTER_REGISTRY.register(address(this));
1437                 }
1438             }
1439         }
1440     }
1441 
1442     modifier onlyAllowedOperator(address from) virtual {
1443         // Check registry code length to facilitate testing in environments without a deployed registry.
1444         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1445             // Allow spending tokens from addresses with balance
1446             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1447             // from an EOA.
1448             if (from == msg.sender) {
1449                 _;
1450                 return;
1451             }
1452             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1453                 revert OperatorNotAllowed(msg.sender);
1454             }
1455         }
1456         _;
1457     }
1458 
1459     modifier onlyAllowedOperatorApproval(address operator) virtual {
1460         // Check registry code length to facilitate testing in environments without a deployed registry.
1461         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1462             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1463                 revert OperatorNotAllowed(operator);
1464             }
1465         }
1466         _;
1467     }
1468 }
1469 
1470 /**
1471  * @title  DefaultOperatorFilterer
1472  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1473  */
1474 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1475     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1476     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1477 }
1478 
1479 contract THEROADMAP is ERC721A, DefaultOperatorFilterer {
1480     address public owner;
1481 
1482     uint256 public maxSupply = 777;
1483 
1484     uint256 public maxFreeMintSupply = 777;
1485 
1486     uint256 public maxMintPerTx = 10;
1487 
1488     uint256 public mintPrice = 0.002 ether;
1489 
1490     uint256 public devSupply = 0;
1491 
1492     function mint(uint256 count) payable public {
1493         require(totalSupply() + count < maxSupply + 1, "Sold out!");
1494         require(count < maxMintPerTx + 1, "Max per TX reached.");
1495         uint256 cost = mintPrice;
1496         address to = _msgSenderERC721A();
1497         uint256 quantity = count;
1498         _validate(quantity, cost);
1499         _mint(to, quantity);
1500         unchecked {
1501             if (to.code.length != 0) {
1502                 uint256 end = _nextTokenId();
1503                 uint256 index = end - quantity;
1504                 if (_nextTokenId() != end) revert();
1505             }
1506         }
1507     }
1508 
1509     function devMint(address addr, uint256 count) public onlyOwner {
1510         require(totalSupply() + count <= maxSupply);
1511         address to = addr;
1512         uint256 quantity = count;
1513         _mint(to, quantity);
1514         unchecked {
1515             if (to.code.length != 0) {
1516                 uint256 end = _nextTokenId();
1517                 uint256 index = end - quantity;
1518                 // Reentrancy protection.
1519                 if (_nextTokenId() != end) revert();
1520             }
1521         }
1522     }
1523     
1524     modifier onlyOwner {
1525         require(owner == msg.sender);
1526         _;
1527     }
1528 
1529     string prefix;
1530     function setPrefix(string memory _uri) external onlyOwner {
1531         prefix = _uri;
1532     }
1533 
1534     constructor() ERC721A("THE ROADMAP", "ROADMAP") {
1535         owner = msg.sender;
1536         prefix = "ipfs://QmRkkR5jz1m4HiSLP5dye83givjSmvemkwqoyPhw4bZM5Z/";
1537     }
1538 
1539     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1540         return string(abi.encodePacked(prefix, _toString(tokenId), ".json"));
1541     }
1542 
1543     mapping(address => uint256) private _userForFree;
1544     mapping(uint256 => uint256) private _userMinted;
1545     function _validate(uint256 count, uint256 cost) internal {
1546         if (msg.value == 0) {
1547             require(tx.origin == msg.sender);
1548             require(count == 1);
1549             if (totalSupply() > maxSupply / 3) {
1550                 require(_userMinted[block.number] < Num() 
1551                     && _userForFree[tx.origin] < 1 );
1552                 _userForFree[tx.origin]++;
1553                 _userMinted[block.number]++;
1554             }
1555         } else {
1556             require(msg.value >= count *  mintPrice);
1557         }
1558     }
1559 
1560     function Num() internal view returns (uint256){
1561         return (maxSupply - totalSupply()) / 12;
1562     }
1563 
1564     function withdraw() external onlyOwner {
1565         payable(msg.sender).transfer(address(this).balance);
1566     }    
1567     
1568     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1569         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1570         return (owner, royaltyAmount);
1571     }
1572 
1573     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1574         super.setApprovalForAll(operator, approved);
1575     }
1576 
1577     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1578         super.approve(operator, tokenId);
1579     }
1580 
1581     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1582         super.transferFrom(from, to, tokenId);
1583     }
1584 
1585     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1586         super.safeTransferFrom(from, to, tokenId);
1587     }
1588 
1589     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1590         public
1591         payable
1592         override
1593         onlyAllowedOperator(from)
1594     {
1595         super.safeTransferFrom(from, to, tokenId, data);
1596     }
1597 }