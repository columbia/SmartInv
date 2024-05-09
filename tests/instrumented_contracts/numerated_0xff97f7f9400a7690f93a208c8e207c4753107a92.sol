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
441         return 1;
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
897         safeTransferFrom(from, to, tokenId, '');
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must exist and be owned by `from`.
908      * - If the caller is not `from`, it must be approved to move this token
909      * by either {approve} or {setApprovalForAll}.
910      * - If `to` refers to a smart contract, it must implement
911      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public payable virtual override {
921         transferFrom(from, to, tokenId);
922         if (to.code.length != 0)
923             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
924                 revert TransferToNonERC721ReceiverImplementer();
925             }
926     }
927 
928     /**
929      * @dev Hook that is called before a set of serially-ordered token IDs
930      * are about to be transferred. This includes minting.
931      * And also called before burning one token.
932      *
933      * `startTokenId` - the first token ID to be transferred.
934      * `quantity` - the amount to be transferred.
935      *
936      * Calling conditions:
937      *
938      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
939      * transferred to `to`.
940      * - When `from` is zero, `tokenId` will be minted for `to`.
941      * - When `to` is zero, `tokenId` will be burned by `from`.
942      * - `from` and `to` are never both zero.
943      */
944     function _beforeTokenTransfers(
945         address from,
946         address to,
947         uint256 startTokenId,
948         uint256 quantity
949     ) internal virtual {}
950 
951     /**
952      * @dev Hook that is called after a set of serially-ordered token IDs
953      * have been transferred. This includes minting.
954      * And also called after one token has been burned.
955      *
956      * `startTokenId` - the first token ID to be transferred.
957      * `quantity` - the amount to be transferred.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` has been minted for `to`.
964      * - When `to` is zero, `tokenId` has been burned by `from`.
965      * - `from` and `to` are never both zero.
966      */
967     function _afterTokenTransfers(
968         address from,
969         address to,
970         uint256 startTokenId,
971         uint256 quantity
972     ) internal virtual {}
973 
974     /**
975      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
976      *
977      * `from` - Previous owner of the given token ID.
978      * `to` - Target address that will receive the token.
979      * `tokenId` - Token ID to be transferred.
980      * `_data` - Optional data to send along with the call.
981      *
982      * Returns whether the call correctly returned the expected magic value.
983      */
984     function _checkContractOnERC721Received(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) private returns (bool) {
990         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
991             bytes4 retval
992         ) {
993             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
994         } catch (bytes memory reason) {
995             if (reason.length == 0) {
996                 revert TransferToNonERC721ReceiverImplementer();
997             } else {
998                 assembly {
999                     revert(add(32, reason), mload(reason))
1000                 }
1001             }
1002         }
1003     }
1004 
1005     // =============================================================
1006     //                        MINT OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Mints `quantity` tokens and transfers them to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `quantity` must be greater than 0.
1016      *
1017      * Emits a {Transfer} event for each mint.
1018      */
1019     function _mint(address to, uint256 quantity) internal virtual {
1020         uint256 startTokenId = _currentIndex;
1021         if (quantity == 0) revert MintZeroQuantity();
1022 
1023         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1024 
1025         // Overflows are incredibly unrealistic.
1026         // `balance` and `numberMinted` have a maximum limit of 2**64.
1027         // `tokenId` has a maximum limit of 2**256.
1028         unchecked {
1029             // Updates:
1030             // - `balance += quantity`.
1031             // - `numberMinted += quantity`.
1032             //
1033             // We can directly add to the `balance` and `numberMinted`.
1034             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1035 
1036             // Updates:
1037             // - `address` to the owner.
1038             // - `startTimestamp` to the timestamp of minting.
1039             // - `burned` to `false`.
1040             // - `nextInitialized` to `quantity == 1`.
1041             _packedOwnerships[startTokenId] = _packOwnershipData(
1042                 to,
1043                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1044             );
1045 
1046             uint256 toMasked;
1047             uint256 end = startTokenId + quantity;
1048 
1049             // Use assembly to loop and emit the `Transfer` event for gas savings.
1050             // The duplicated `log4` removes an extra check and reduces stack juggling.
1051             // The assembly, together with the surrounding Solidity code, have been
1052             // delicately arranged to nudge the compiler into producing optimized opcodes.
1053             assembly {
1054                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1055                 toMasked := and(to, _BITMASK_ADDRESS)
1056                 // Emit the `Transfer` event.
1057                 log4(
1058                     0, // Start of data (0, since no data).
1059                     0, // End of data (0, since no data).
1060                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1061                     0, // `address(0)`.
1062                     toMasked, // `to`.
1063                     startTokenId // `tokenId`.
1064                 )
1065 
1066                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1067                 // that overflows uint256 will make the loop run out of gas.
1068                 // The compiler will optimize the `iszero` away for performance.
1069                 for {
1070                     let tokenId := add(startTokenId, 1)
1071                 } iszero(eq(tokenId, end)) {
1072                     tokenId := add(tokenId, 1)
1073                 } {
1074                     // Emit the `Transfer` event. Similar to above.
1075                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1076                 }
1077             }
1078             if (toMasked == 0) revert MintToZeroAddress();
1079 
1080             _currentIndex = end;
1081         }
1082         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1083     }
1084 
1085     /**
1086      * @dev Mints `quantity` tokens and transfers them to `to`.
1087      *
1088      * This function is intended for efficient minting only during contract creation.
1089      *
1090      * It emits only one {ConsecutiveTransfer} as defined in
1091      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1092      * instead of a sequence of {Transfer} event(s).
1093      *
1094      * Calling this function outside of contract creation WILL make your contract
1095      * non-compliant with the ERC721 standard.
1096      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1097      * {ConsecutiveTransfer} event is only permissible during contract creation.
1098      *
1099      * Requirements:
1100      *
1101      * - `to` cannot be the zero address.
1102      * - `quantity` must be greater than 0.
1103      *
1104      * Emits a {ConsecutiveTransfer} event.
1105      */
1106     function _mintERC2309(address to, uint256 quantity) internal virtual {
1107         uint256 startTokenId = _currentIndex;
1108         if (to == address(0)) revert MintToZeroAddress();
1109         if (quantity == 0) revert MintZeroQuantity();
1110         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1111 
1112         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1113 
1114         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1115         unchecked {
1116             // Updates:
1117             // - `balance += quantity`.
1118             // - `numberMinted += quantity`.
1119             //
1120             // We can directly add to the `balance` and `numberMinted`.
1121             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1122 
1123             // Updates:
1124             // - `address` to the owner.
1125             // - `startTimestamp` to the timestamp of minting.
1126             // - `burned` to `false`.
1127             // - `nextInitialized` to `quantity == 1`.
1128             _packedOwnerships[startTokenId] = _packOwnershipData(
1129                 to,
1130                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1131             );
1132 
1133             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1134 
1135             _currentIndex = startTokenId + quantity;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - If `to` refers to a smart contract, it must implement
1146      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * See {_mint}.
1150      *
1151      * Emits a {Transfer} event for each mint.
1152      */
1153     function _safeMint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data
1157     ) internal virtual {
1158         _mint(to, quantity);
1159 
1160         unchecked {
1161             if (to.code.length != 0) {
1162                 uint256 end = _currentIndex;
1163                 uint256 index = end - quantity;
1164                 do {
1165                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1166                         revert TransferToNonERC721ReceiverImplementer();
1167                     }
1168                 } while (index < end);
1169                 // Reentrancy protection.
1170                 if (_currentIndex != end) revert();
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1177      */
1178     function _safeMint(address to, uint256 quantity) internal virtual {
1179         _safeMint(to, quantity, '');
1180     }
1181 
1182     // =============================================================
1183     //                        BURN OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Equivalent to `_burn(tokenId, false)`.
1188      */
1189     function _burn(uint256 tokenId) internal virtual {
1190         _burn(tokenId, false);
1191     }
1192 
1193     /**
1194      * @dev Destroys `tokenId`.
1195      * The approval is cleared when the token is burned.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1204         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1205 
1206         address from = address(uint160(prevOwnershipPacked));
1207 
1208         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1209 
1210         if (approvalCheck) {
1211             // The nested ifs save around 20+ gas over a compound boolean condition.
1212             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1213                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1214         }
1215 
1216         _beforeTokenTransfers(from, address(0), tokenId, 1);
1217 
1218         // Clear approvals from the previous owner.
1219         assembly {
1220             if approvedAddress {
1221                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1222                 sstore(approvedAddressSlot, 0)
1223             }
1224         }
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1229         unchecked {
1230             // Updates:
1231             // - `balance -= 1`.
1232             // - `numberBurned += 1`.
1233             //
1234             // We can directly decrement the balance, and increment the number burned.
1235             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1236             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1237 
1238             // Updates:
1239             // - `address` to the last owner.
1240             // - `startTimestamp` to the timestamp of burning.
1241             // - `burned` to `true`.
1242             // - `nextInitialized` to `true`.
1243             _packedOwnerships[tokenId] = _packOwnershipData(
1244                 from,
1245                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1246             );
1247 
1248             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1249             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1250                 uint256 nextTokenId = tokenId + 1;
1251                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1252                 if (_packedOwnerships[nextTokenId] == 0) {
1253                     // If the next slot is within bounds.
1254                     if (nextTokenId != _currentIndex) {
1255                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1256                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1257                     }
1258                 }
1259             }
1260         }
1261 
1262         emit Transfer(from, address(0), tokenId);
1263         _afterTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1266         unchecked {
1267             _burnCounter++;
1268         }
1269     }
1270 
1271     // =============================================================
1272     //                     EXTRA DATA OPERATIONS
1273     // =============================================================
1274 
1275     /**
1276      * @dev Directly sets the extra data for the ownership data `index`.
1277      */
1278     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1279         uint256 packed = _packedOwnerships[index];
1280         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1281         uint256 extraDataCasted;
1282         // Cast `extraData` with assembly to avoid redundant masking.
1283         assembly {
1284             extraDataCasted := extraData
1285         }
1286         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1287         _packedOwnerships[index] = packed;
1288     }
1289 
1290     /**
1291      * @dev Called during each token transfer to set the 24bit `extraData` field.
1292      * Intended to be overridden by the cosumer contract.
1293      *
1294      * `previousExtraData` - the value of `extraData` before transfer.
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` will be minted for `to`.
1301      * - When `to` is zero, `tokenId` will be burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _extraData(
1305         address from,
1306         address to,
1307         uint24 previousExtraData
1308     ) internal view virtual returns (uint24) {}
1309 
1310     /**
1311      * @dev Returns the next extra data for the packed ownership data.
1312      * The returned result is shifted into position.
1313      */
1314     function _nextExtraData(
1315         address from,
1316         address to,
1317         uint256 prevOwnershipPacked
1318     ) private view returns (uint256) {
1319         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1320         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1321     }
1322 
1323     // =============================================================
1324     //                       OTHER OPERATIONS
1325     // =============================================================
1326 
1327     /**
1328      * @dev Returns the message sender (defaults to `msg.sender`).
1329      *
1330      * If you are writing GSN compatible contracts, you need to override this function.
1331      */
1332     function _msgSenderERC721A() internal view virtual returns (address) {
1333         return msg.sender;
1334     }
1335 
1336     /**
1337      * @dev Converts a uint256 to its ASCII string decimal representation.
1338      */
1339     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1340         assembly {
1341             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1342             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1343             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1344             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1345             let m := add(mload(0x40), 0xa0)
1346             // Update the free memory pointer to allocate.
1347             mstore(0x40, m)
1348             // Assign the `str` to the end.
1349             str := sub(m, 0x20)
1350             // Zeroize the slot after the string.
1351             mstore(str, 0)
1352 
1353             // Cache the end of the memory to calculate the length later.
1354             let end := str
1355 
1356             // We write the string from rightmost digit to leftmost digit.
1357             // The following is essentially a do-while loop that also handles the zero case.
1358             // prettier-ignore
1359             for { let temp := value } 1 {} {
1360                 str := sub(str, 1)
1361                 // Write the character to the pointer.
1362                 // The ASCII index of the '0' character is 48.
1363                 mstore8(str, add(48, mod(temp, 10)))
1364                 // Keep dividing `temp` until zero.
1365                 temp := div(temp, 10)
1366                 // prettier-ignore
1367                 if iszero(temp) { break }
1368             }
1369 
1370             let length := sub(end, str)
1371             // Move the pointer 32 bytes leftwards to make room for the length.
1372             str := sub(str, 0x20)
1373             // Store the length.
1374             mstore(str, length)
1375         }
1376     }
1377 }
1378 
1379 
1380 interface IOperatorFilterRegistry {
1381     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1382     function register(address registrant) external;
1383     function registerAndSubscribe(address registrant, address subscription) external;
1384     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1385     function unregister(address addr) external;
1386     function updateOperator(address registrant, address operator, bool filtered) external;
1387     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1388     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1389     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1390     function subscribe(address registrant, address registrantToSubscribe) external;
1391     function unsubscribe(address registrant, bool copyExistingEntries) external;
1392     function subscriptionOf(address addr) external returns (address registrant);
1393     function subscribers(address registrant) external returns (address[] memory);
1394     function subscriberAt(address registrant, uint256 index) external returns (address);
1395     function copyEntriesOf(address registrant, address registrantToCopy) external;
1396     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1397     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1398     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1399     function filteredOperators(address addr) external returns (address[] memory);
1400     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1401     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1402     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1403     function isRegistered(address addr) external returns (bool);
1404     function codeHashOf(address addr) external returns (bytes32);
1405 }
1406 
1407 
1408 /**
1409  * @title  OperatorFilterer
1410  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1411  *         registrant's entries in the OperatorFilterRegistry.
1412  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1413  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1414  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1415  */
1416 abstract contract OperatorFilterer {
1417     error OperatorNotAllowed(address operator);
1418 
1419     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1420         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1421 
1422     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1423         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1424         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1425         // order for the modifier to filter addresses.
1426         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1427             if (subscribe) {
1428                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1429             } else {
1430                 if (subscriptionOrRegistrantToCopy != address(0)) {
1431                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1432                 } else {
1433                     OPERATOR_FILTER_REGISTRY.register(address(this));
1434                 }
1435             }
1436         }
1437     }
1438 
1439     modifier onlyAllowedOperator(address from) virtual {
1440         // Check registry code length to facilitate testing in environments without a deployed registry.
1441         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1442             // Allow spending tokens from addresses with balance
1443             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1444             // from an EOA.
1445             if (from == msg.sender) {
1446                 _;
1447                 return;
1448             }
1449             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1450                 revert OperatorNotAllowed(msg.sender);
1451             }
1452         }
1453         _;
1454     }
1455 
1456     modifier onlyAllowedOperatorApproval(address operator) virtual {
1457         // Check registry code length to facilitate testing in environments without a deployed registry.
1458         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1459             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1460                 revert OperatorNotAllowed(operator);
1461             }
1462         }
1463         _;
1464     }
1465 }
1466 
1467 /**
1468  * @title  DefaultOperatorFilterer
1469  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1470  */
1471 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1472     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1473 
1474     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1475 }
1476 
1477 /////////////////////////////////////////////////////////////////////////////////////////
1478 ///  ИЗМЕНЯТЬ ПРОЕКТ ЗДЕСЬ //////////////////////////////////////////////////////////////
1479 ///  ВВЕСТИ СУППЛАЙ, ЦЕНУ, МАКС МИНТОВ НА ТРАНЗАКЦИЮ, МАКС ФРИМИНТОВ ////////////////////
1480 ///  ЦЕНУ В ДВУХ ПОЛЯХ ВВЕСТИ////////////////////////////////////////////////////////////
1481 /// ПОСЛЕ КОНТРАКТ ПИСАТЬ НАЗВАНИЕ КОНТРАКТА ////////////////////////////////////////////
1482 contract GradientAbstractionsByNoona is ERC721A, DefaultOperatorFilterer {
1483     uint256 public maxSupply = 333; 
1484     uint256 private price = 0.003 ether;
1485     string public ShowPrice = "0.003 ether";
1486     uint256 private maxPerTx = 10;
1487     uint256 public maxFree = 100;
1488     string public baseURI;
1489     error LengthsDoNotMatch();
1490 
1491     function PaidMint(uint256 amount) payable public {
1492         require(totalSupply() + amount <= maxSupply);
1493         require(amount <= maxPerTx);
1494         require(msg.value >= amount * price);
1495         _safeMint(msg.sender, amount);
1496     }
1497 ////// ФУНКЦИЯ ФРИМИНТА//////////////////////////////////////////////////////////////////
1498     function FreeMint() external {
1499         require(msg.sender == tx.origin);
1500         require (totalSupply() + 1  <= maxFree);
1501         _safeMint(msg.sender, 1);
1502     }
1503 
1504     function batchMintForAddresses(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
1505         if (addresses_.length != amounts_.length) revert LengthsDoNotMatch();
1506         unchecked {
1507             for (uint32 i = 0; i < addresses_.length; i++) {
1508                 _mint(addresses_[i], amounts_[i]);
1509             }
1510         }
1511     }
1512 
1513     address public owner;
1514     modifier onlyOwner {
1515         require(owner == msg.sender);
1516         _;
1517     }
1518 /////////////////////////////////////////////////////////////////////////////////////////////////////
1519 //////////////// ВНУТРИ ERC721A ПИСАТЬ НАЗВАНИЕ КОЛЛЕКЦИИ (ОПЕНСИ) И НАЗВАНИЕ ТОКЕНА ////////////////
1520 /////////////////////////////////////////////////////////////////////////////////////////////////////
1521     constructor() ERC721A("Gradient Abstractions by Noona", "GAN") {
1522         owner = msg.sender;
1523     }
1524     
1525     function setPrice(uint256 newPrice, uint256 maxFreeMint, uint256 maxPerT) external onlyOwner {
1526         price = newPrice;
1527         maxFree = maxFreeMint;
1528         maxPerTx = maxPerT;
1529     }
1530 
1531 /////// ФУНКЦИЯ ДЛЯ ЗАГРУЗКИ МЕТАДАННЫХ, МЕТАДАННЫЕ СОЗДАВАТЬ НА mintplex.xyz, через NFT UP //////
1532     function setBaseURI(string memory newBaseURI_) external onlyOwner {
1533         baseURI = newBaseURI_;
1534     }
1535 
1536     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1537         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1538     }
1539     
1540     function withdraw() external onlyOwner {
1541         payable(msg.sender).transfer(address(this).balance);
1542     }
1543 
1544     function cutS(uint256 maxT) external onlyOwner {
1545         maxSupply = maxT;
1546     }
1547 
1548     /////////////////////////////
1549     // OPENSEA FILTER REGISTRY 
1550     /////////////////////////////
1551 
1552     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1553         super.setApprovalForAll(operator, approved);
1554     }
1555 
1556     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1557         super.approve(operator, tokenId);
1558     }
1559 
1560     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1561         super.transferFrom(from, to, tokenId);
1562     }
1563 
1564     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1565         super.safeTransferFrom(from, to, tokenId);
1566     }
1567 
1568     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1569         super.safeTransferFrom(from, to, tokenId, data);
1570     }
1571 }