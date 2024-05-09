1 // File: pass-interface.sol
2 
3 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
4 
5 pragma solidity ^0.8.0;
6 
7 interface Pass {
8    function hasPass(address account) external view returns(bool);
9 
10    function usePass(address account) external;
11 }
12 // File: erc721a/contracts/IERC721A.sol
13 
14 
15 // ERC721A Contracts v4.2.0
16 // Creator: Chiru Labs
17 
18 pragma solidity ^0.8.4;
19 
20 /**
21  * @dev Interface of ERC721A.
22  */
23 interface IERC721A {
24     /**
25      * The caller must own the token or be an approved operator.
26      */
27     error ApprovalCallerNotOwnerNorApproved();
28 
29     /**
30      * The token does not exist.
31      */
32     error ApprovalQueryForNonexistentToken();
33 
34     /**
35      * The caller cannot approve to their own address.
36      */
37     error ApproveToCaller();
38 
39     /**
40      * Cannot query the balance for the zero address.
41      */
42     error BalanceQueryForZeroAddress();
43 
44     /**
45      * Cannot mint to the zero address.
46      */
47     error MintToZeroAddress();
48 
49     /**
50      * The quantity of tokens minted must be more than zero.
51      */
52     error MintZeroQuantity();
53 
54     /**
55      * The token does not exist.
56      */
57     error OwnerQueryForNonexistentToken();
58 
59     /**
60      * The caller must own the token or be an approved operator.
61      */
62     error TransferCallerNotOwnerNorApproved();
63 
64     /**
65      * The token must be owned by `from`.
66      */
67     error TransferFromIncorrectOwner();
68 
69     /**
70      * Cannot safely transfer to a contract that does not implement the
71      * ERC721Receiver interface.
72      */
73     error TransferToNonERC721ReceiverImplementer();
74 
75     /**
76      * Cannot transfer to the zero address.
77      */
78     error TransferToZeroAddress();
79 
80     /**
81      * The token does not exist.
82      */
83     error URIQueryForNonexistentToken();
84 
85     /**
86      * The `quantity` minted with ERC2309 exceeds the safety limit.
87      */
88     error MintERC2309QuantityExceedsLimit();
89 
90     /**
91      * The `extraData` cannot be set on an unintialized ownership slot.
92      */
93     error OwnershipNotInitializedForExtraData();
94 
95     // =============================================================
96     //                            STRUCTS
97     // =============================================================
98 
99     struct TokenOwnership {
100         // The address of the owner.
101         address addr;
102         // Stores the start time of ownership with minimal overhead for tokenomics.
103         uint64 startTimestamp;
104         // Whether the token has been burned.
105         bool burned;
106         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
107         uint24 extraData;
108     }
109 
110     // =============================================================
111     //                         TOKEN COUNTERS
112     // =============================================================
113 
114     /**
115      * @dev Returns the total number of tokens in existence.
116      * Burned tokens will reduce the count.
117      * To get the total number of tokens minted, please see {_totalMinted}.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     // =============================================================
122     //                            IERC165
123     // =============================================================
124 
125     /**
126      * @dev Returns true if this contract implements the interface defined by
127      * `interfaceId`. See the corresponding
128      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
129      * to learn more about how these ids are created.
130      *
131      * This function call must use less than 30000 gas.
132      */
133     function supportsInterface(bytes4 interfaceId) external view returns (bool);
134 
135     // =============================================================
136     //                            IERC721
137     // =============================================================
138 
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
146      */
147     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables or disables
151      * (`approved`) `operator` to manage all of its assets.
152      */
153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
154 
155     /**
156      * @dev Returns the number of tokens in `owner`'s account.
157      */
158     function balanceOf(address owner) external view returns (uint256 balance);
159 
160     /**
161      * @dev Returns the owner of the `tokenId` token.
162      *
163      * Requirements:
164      *
165      * - `tokenId` must exist.
166      */
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`,
171      * checking first that contract recipients are aware of the ERC721 protocol
172      * to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move
180      * this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement
182      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external;
192 
193     /**
194      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Transfers `tokenId` from `from` to `to`.
204      *
205      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
206      * whenever possible.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token
214      * by either {approve} or {setApprovalForAll}.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external;
223 
224     /**
225      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
226      * The approval is cleared when the token is transferred.
227      *
228      * Only a single account can be approved at a time, so approving the
229      * zero address clears previous approvals.
230      *
231      * Requirements:
232      *
233      * - The caller must own the token or be an approved operator.
234      * - `tokenId` must exist.
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address to, uint256 tokenId) external;
239 
240     /**
241      * @dev Approve or remove `operator` as an operator for the caller.
242      * Operators can call {transferFrom} or {safeTransferFrom}
243      * for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns the account approved for `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function getApproved(uint256 tokenId) external view returns (address operator);
261 
262     /**
263      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
264      *
265      * See {setApprovalForAll}.
266      */
267     function isApprovedForAll(address owner, address operator) external view returns (bool);
268 
269     // =============================================================
270     //                        IERC721Metadata
271     // =============================================================
272 
273     /**
274      * @dev Returns the token collection name.
275      */
276     function name() external view returns (string memory);
277 
278     /**
279      * @dev Returns the token collection symbol.
280      */
281     function symbol() external view returns (string memory);
282 
283     /**
284      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
285      */
286     function tokenURI(uint256 tokenId) external view returns (string memory);
287 
288     // =============================================================
289     //                           IERC2309
290     // =============================================================
291 
292     /**
293      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
294      * (inclusive) is transferred from `from` to `to`, as defined in the
295      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
296      *
297      * See {_mintERC2309} for more details.
298      */
299     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
300 }
301 
302 // File: erc721a/contracts/ERC721A.sol
303 
304 
305 // ERC721A Contracts v4.2.0
306 // Creator: Chiru Labs
307 
308 pragma solidity ^0.8.4;
309 
310 
311 /**
312  * @dev Interface of ERC721 token receiver.
313  */
314 interface ERC721A__IERC721Receiver {
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 /**
324  * @title ERC721A
325  *
326  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
327  * Non-Fungible Token Standard, including the Metadata extension.
328  * Optimized for lower gas during batch mints.
329  *
330  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
331  * starting from `_startTokenId()`.
332  *
333  * Assumptions:
334  *
335  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
336  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
337  */
338 contract ERC721A is IERC721A {
339     // Reference type for token approval.
340     struct TokenApprovalRef {
341         address value;
342     }
343 
344     // =============================================================
345     //                           CONSTANTS
346     // =============================================================
347 
348     // Mask of an entry in packed address data.
349     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
350 
351     // The bit position of `numberMinted` in packed address data.
352     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
353 
354     // The bit position of `numberBurned` in packed address data.
355     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
356 
357     // The bit position of `aux` in packed address data.
358     uint256 private constant _BITPOS_AUX = 192;
359 
360     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
361     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
362 
363     // The bit position of `startTimestamp` in packed ownership.
364     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
365 
366     // The bit mask of the `burned` bit in packed ownership.
367     uint256 private constant _BITMASK_BURNED = 1 << 224;
368 
369     // The bit position of the `nextInitialized` bit in packed ownership.
370     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
371 
372     // The bit mask of the `nextInitialized` bit in packed ownership.
373     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
374 
375     // The bit position of `extraData` in packed ownership.
376     uint256 private constant _BITPOS_EXTRA_DATA = 232;
377 
378     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
379     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
380 
381     // The mask of the lower 160 bits for addresses.
382     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
383 
384     // The maximum `quantity` that can be minted with {_mintERC2309}.
385     // This limit is to prevent overflows on the address data entries.
386     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
387     // is required to cause an overflow, which is unrealistic.
388     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
389 
390     // The `Transfer` event signature is given by:
391     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
392     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
393         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
394 
395     // =============================================================
396     //                            STORAGE
397     // =============================================================
398 
399     // The next token ID to be minted.
400     uint256 private _currentIndex;
401 
402     // The number of tokens burned.
403     uint256 private _burnCounter;
404 
405     // Token name
406     string private _name;
407 
408     // Token symbol
409     string private _symbol;
410 
411     // Mapping from token ID to ownership details
412     // An empty struct value does not necessarily mean the token is unowned.
413     // See {_packedOwnershipOf} implementation for details.
414     //
415     // Bits Layout:
416     // - [0..159]   `addr`
417     // - [160..223] `startTimestamp`
418     // - [224]      `burned`
419     // - [225]      `nextInitialized`
420     // - [232..255] `extraData`
421     mapping(uint256 => uint256) private _packedOwnerships;
422 
423     // Mapping owner address to address data.
424     //
425     // Bits Layout:
426     // - [0..63]    `balance`
427     // - [64..127]  `numberMinted`
428     // - [128..191] `numberBurned`
429     // - [192..255] `aux`
430     mapping(address => uint256) private _packedAddressData;
431 
432     // Mapping from token ID to approved address.
433     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
434 
435     // Mapping from owner to operator approvals
436     mapping(address => mapping(address => bool)) private _operatorApprovals;
437 
438     // =============================================================
439     //                          CONSTRUCTOR
440     // =============================================================
441 
442     constructor(string memory name_, string memory symbol_) {
443         _name = name_;
444         _symbol = symbol_;
445         _currentIndex = _startTokenId();
446     }
447 
448     // =============================================================
449     //                   TOKEN COUNTING OPERATIONS
450     // =============================================================
451 
452     /**
453      * @dev Returns the starting token ID.
454      * To change the starting token ID, please override this function.
455      */
456     function _startTokenId() internal view virtual returns (uint256) {
457         return 0;
458     }
459 
460     /**
461      * @dev Returns the next token ID to be minted.
462      */
463     function _nextTokenId() internal view virtual returns (uint256) {
464         return _currentIndex;
465     }
466 
467     /**
468      * @dev Returns the total number of tokens in existence.
469      * Burned tokens will reduce the count.
470      * To get the total number of tokens minted, please see {_totalMinted}.
471      */
472     function totalSupply() public view virtual override returns (uint256) {
473         // Counter underflow is impossible as _burnCounter cannot be incremented
474         // more than `_currentIndex - _startTokenId()` times.
475         unchecked {
476             return _currentIndex - _burnCounter - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total amount of tokens minted in the contract.
482      */
483     function _totalMinted() internal view virtual returns (uint256) {
484         // Counter underflow is impossible as `_currentIndex` does not decrement,
485         // and it is initialized to `_startTokenId()`.
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total number of tokens burned.
493      */
494     function _totalBurned() internal view virtual returns (uint256) {
495         return _burnCounter;
496     }
497 
498     // =============================================================
499     //                    ADDRESS DATA OPERATIONS
500     // =============================================================
501 
502     /**
503      * @dev Returns the number of tokens in `owner`'s account.
504      */
505     function balanceOf(address owner) public view virtual override returns (uint256) {
506         if (owner == address(0)) revert BalanceQueryForZeroAddress();
507         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the number of tokens minted by `owner`.
512      */
513     function _numberMinted(address owner) internal view returns (uint256) {
514         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the number of tokens burned by or on behalf of `owner`.
519      */
520     function _numberBurned(address owner) internal view returns (uint256) {
521         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
526      */
527     function _getAux(address owner) internal view returns (uint64) {
528         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
529     }
530 
531     /**
532      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
533      * If there are multiple variables, please pack them into a uint64.
534      */
535     function _setAux(address owner, uint64 aux) internal virtual {
536         uint256 packed = _packedAddressData[owner];
537         uint256 auxCasted;
538         // Cast `aux` with assembly to avoid redundant masking.
539         assembly {
540             auxCasted := aux
541         }
542         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
543         _packedAddressData[owner] = packed;
544     }
545 
546     // =============================================================
547     //                            IERC165
548     // =============================================================
549 
550     /**
551      * @dev Returns true if this contract implements the interface defined by
552      * `interfaceId`. See the corresponding
553      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
554      * to learn more about how these ids are created.
555      *
556      * This function call must use less than 30000 gas.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         // The interface IDs are constants representing the first 4 bytes
560         // of the XOR of all function selectors in the interface.
561         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
562         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
563         return
564             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
565             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
566             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
567     }
568 
569     // =============================================================
570     //                        IERC721Metadata
571     // =============================================================
572 
573     /**
574      * @dev Returns the token collection name.
575      */
576     function name() public view virtual override returns (string memory) {
577         return _name;
578     }
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() public view virtual override returns (string memory) {
584         return _symbol;
585     }
586 
587     /**
588      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
589      */
590     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
591         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
592 
593         string memory baseURI = _baseURI();
594         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
595     }
596 
597     /**
598      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
599      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
600      * by default, it can be overridden in child contracts.
601      */
602     function _baseURI() internal view virtual returns (string memory) {
603         return '';
604     }
605 
606     // =============================================================
607     //                     OWNERSHIPS OPERATIONS
608     // =============================================================
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
618         return address(uint160(_packedOwnershipOf(tokenId)));
619     }
620 
621     /**
622      * @dev Gas spent here starts off proportional to the maximum mint batch size.
623      * It gradually moves to O(1) as tokens get transferred around over time.
624      */
625     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnershipOf(tokenId));
627     }
628 
629     /**
630      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
631      */
632     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnerships[index]);
634     }
635 
636     /**
637      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
638      */
639     function _initializeOwnershipAt(uint256 index) internal virtual {
640         if (_packedOwnerships[index] == 0) {
641             _packedOwnerships[index] = _packedOwnershipOf(index);
642         }
643     }
644 
645     /**
646      * Returns the packed ownership data of `tokenId`.
647      */
648     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
649         uint256 curr = tokenId;
650 
651         unchecked {
652             if (_startTokenId() <= curr)
653                 if (curr < _currentIndex) {
654                     uint256 packed = _packedOwnerships[curr];
655                     // If not burned.
656                     if (packed & _BITMASK_BURNED == 0) {
657                         // Invariant:
658                         // There will always be an initialized ownership slot
659                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
660                         // before an unintialized ownership slot
661                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
662                         // Hence, `curr` will not underflow.
663                         //
664                         // We can directly compare the packed value.
665                         // If the address is zero, packed will be zero.
666                         while (packed == 0) {
667                             packed = _packedOwnerships[--curr];
668                         }
669                         return packed;
670                     }
671                 }
672         }
673         revert OwnerQueryForNonexistentToken();
674     }
675 
676     /**
677      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
678      */
679     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
680         ownership.addr = address(uint160(packed));
681         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
682         ownership.burned = packed & _BITMASK_BURNED != 0;
683         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
684     }
685 
686     /**
687      * @dev Packs ownership data into a single uint256.
688      */
689     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
690         assembly {
691             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
692             owner := and(owner, _BITMASK_ADDRESS)
693             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
694             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
695         }
696     }
697 
698     /**
699      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
700      */
701     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
702         // For branchless setting of the `nextInitialized` flag.
703         assembly {
704             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
705             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
706         }
707     }
708 
709     // =============================================================
710     //                      APPROVAL OPERATIONS
711     // =============================================================
712 
713     /**
714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
715      * The approval is cleared when the token is transferred.
716      *
717      * Only a single account can be approved at a time, so approving the
718      * zero address clears previous approvals.
719      *
720      * Requirements:
721      *
722      * - The caller must own the token or be an approved operator.
723      * - `tokenId` must exist.
724      *
725      * Emits an {Approval} event.
726      */
727     function approve(address to, uint256 tokenId) public virtual override {
728         address owner = ownerOf(tokenId);
729 
730         if (_msgSenderERC721A() != owner)
731             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
732                 revert ApprovalCallerNotOwnerNorApproved();
733             }
734 
735         _tokenApprovals[tokenId].value = to;
736         emit Approval(owner, to, tokenId);
737     }
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) public view virtual override returns (address) {
747         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
748 
749         return _tokenApprovals[tokenId].value;
750     }
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom}
755      * for any token owned by the caller.
756      *
757      * Requirements:
758      *
759      * - The `operator` cannot be the caller.
760      *
761      * Emits an {ApprovalForAll} event.
762      */
763     function setApprovalForAll(address operator, bool approved) public virtual override {
764         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
765 
766         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
767         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
768     }
769 
770     /**
771      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
772      *
773      * See {setApprovalForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev Returns whether `tokenId` exists.
781      *
782      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
783      *
784      * Tokens start existing when they are minted. See {_mint}.
785      */
786     function _exists(uint256 tokenId) internal view virtual returns (bool) {
787         return
788             _startTokenId() <= tokenId &&
789             tokenId < _currentIndex && // If within bounds,
790             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
791     }
792 
793     /**
794      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
795      */
796     function _isSenderApprovedOrOwner(
797         address approvedAddress,
798         address owner,
799         address msgSender
800     ) private pure returns (bool result) {
801         assembly {
802             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
803             owner := and(owner, _BITMASK_ADDRESS)
804             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
805             msgSender := and(msgSender, _BITMASK_ADDRESS)
806             // `msgSender == owner || msgSender == approvedAddress`.
807             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
808         }
809     }
810 
811     /**
812      * @dev Returns the storage slot and value for the approved address of `tokenId`.
813      */
814     function _getApprovedSlotAndAddress(uint256 tokenId)
815         private
816         view
817         returns (uint256 approvedAddressSlot, address approvedAddress)
818     {
819         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
820         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
821         assembly {
822             approvedAddressSlot := tokenApproval.slot
823             approvedAddress := sload(approvedAddressSlot)
824         }
825     }
826 
827     // =============================================================
828     //                      TRANSFER OPERATIONS
829     // =============================================================
830 
831     /**
832      * @dev Transfers `tokenId` from `from` to `to`.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token
840      * by either {approve} or {setApprovalForAll}.
841      *
842      * Emits a {Transfer} event.
843      */
844     function transferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
850 
851         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
852 
853         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
854 
855         // The nested ifs save around 20+ gas over a compound boolean condition.
856         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
857             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
858 
859         if (to == address(0)) revert TransferToZeroAddress();
860 
861         _beforeTokenTransfers(from, to, tokenId, 1);
862 
863         // Clear approvals from the previous owner.
864         assembly {
865             if approvedAddress {
866                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
867                 sstore(approvedAddressSlot, 0)
868             }
869         }
870 
871         // Underflow of the sender's balance is impossible because we check for
872         // ownership above and the recipient's balance can't realistically overflow.
873         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
874         unchecked {
875             // We can directly increment and decrement the balances.
876             --_packedAddressData[from]; // Updates: `balance -= 1`.
877             ++_packedAddressData[to]; // Updates: `balance += 1`.
878 
879             // Updates:
880             // - `address` to the next owner.
881             // - `startTimestamp` to the timestamp of transfering.
882             // - `burned` to `false`.
883             // - `nextInitialized` to `true`.
884             _packedOwnerships[tokenId] = _packOwnershipData(
885                 to,
886                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
887             );
888 
889             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
890             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
891                 uint256 nextTokenId = tokenId + 1;
892                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
893                 if (_packedOwnerships[nextTokenId] == 0) {
894                     // If the next slot is within bounds.
895                     if (nextTokenId != _currentIndex) {
896                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
897                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
898                     }
899                 }
900             }
901         }
902 
903         emit Transfer(from, to, tokenId);
904         _afterTokenTransfers(from, to, tokenId, 1);
905     }
906 
907     /**
908      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, '');
916     }
917 
918     /**
919      * @dev Safely transfers `tokenId` token from `from` to `to`.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must exist and be owned by `from`.
926      * - If the caller is not `from`, it must be approved to move this token
927      * by either {approve} or {setApprovalForAll}.
928      * - If `to` refers to a smart contract, it must implement
929      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         transferFrom(from, to, tokenId);
940         if (to.code.length != 0)
941             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
942                 revert TransferToNonERC721ReceiverImplementer();
943             }
944     }
945 
946     /**
947      * @dev Hook that is called before a set of serially-ordered token IDs
948      * are about to be transferred. This includes minting.
949      * And also called before burning one token.
950      *
951      * `startTokenId` - the first token ID to be transferred.
952      * `quantity` - the amount to be transferred.
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` will be minted for `to`.
959      * - When `to` is zero, `tokenId` will be burned by `from`.
960      * - `from` and `to` are never both zero.
961      */
962     function _beforeTokenTransfers(
963         address from,
964         address to,
965         uint256 startTokenId,
966         uint256 quantity
967     ) internal virtual {}
968 
969     /**
970      * @dev Hook that is called after a set of serially-ordered token IDs
971      * have been transferred. This includes minting.
972      * And also called after one token has been burned.
973      *
974      * `startTokenId` - the first token ID to be transferred.
975      * `quantity` - the amount to be transferred.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` has been minted for `to`.
982      * - When `to` is zero, `tokenId` has been burned by `from`.
983      * - `from` and `to` are never both zero.
984      */
985     function _afterTokenTransfers(
986         address from,
987         address to,
988         uint256 startTokenId,
989         uint256 quantity
990     ) internal virtual {}
991 
992     /**
993      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
994      *
995      * `from` - Previous owner of the given token ID.
996      * `to` - Target address that will receive the token.
997      * `tokenId` - Token ID to be transferred.
998      * `_data` - Optional data to send along with the call.
999      *
1000      * Returns whether the call correctly returned the expected magic value.
1001      */
1002     function _checkContractOnERC721Received(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes memory _data
1007     ) private returns (bool) {
1008         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1009             bytes4 retval
1010         ) {
1011             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1012         } catch (bytes memory reason) {
1013             if (reason.length == 0) {
1014                 revert TransferToNonERC721ReceiverImplementer();
1015             } else {
1016                 assembly {
1017                     revert(add(32, reason), mload(reason))
1018                 }
1019             }
1020         }
1021     }
1022 
1023     // =============================================================
1024     //                        MINT OPERATIONS
1025     // =============================================================
1026 
1027     /**
1028      * @dev Mints `quantity` tokens and transfers them to `to`.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `quantity` must be greater than 0.
1034      *
1035      * Emits a {Transfer} event for each mint.
1036      */
1037     function _mint(address to, uint256 quantity) internal virtual {
1038         uint256 startTokenId = _currentIndex;
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // `balance` and `numberMinted` have a maximum limit of 2**64.
1045         // `tokenId` has a maximum limit of 2**256.
1046         unchecked {
1047             // Updates:
1048             // - `balance += quantity`.
1049             // - `numberMinted += quantity`.
1050             //
1051             // We can directly add to the `balance` and `numberMinted`.
1052             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1053 
1054             // Updates:
1055             // - `address` to the owner.
1056             // - `startTimestamp` to the timestamp of minting.
1057             // - `burned` to `false`.
1058             // - `nextInitialized` to `quantity == 1`.
1059             _packedOwnerships[startTokenId] = _packOwnershipData(
1060                 to,
1061                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1062             );
1063 
1064             uint256 toMasked;
1065             uint256 end = startTokenId + quantity;
1066 
1067             // Use assembly to loop and emit the `Transfer` event for gas savings.
1068             assembly {
1069                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1070                 toMasked := and(to, _BITMASK_ADDRESS)
1071                 // Emit the `Transfer` event.
1072                 log4(
1073                     0, // Start of data (0, since no data).
1074                     0, // End of data (0, since no data).
1075                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1076                     0, // `address(0)`.
1077                     toMasked, // `to`.
1078                     startTokenId // `tokenId`.
1079                 )
1080 
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
1351     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1352         assembly {
1353             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1354             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1355             // We will need 1 32-byte word to store the length,
1356             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1357             ptr := add(mload(0x40), 128)
1358             // Update the free memory pointer to allocate.
1359             mstore(0x40, ptr)
1360 
1361             // Cache the end of the memory to calculate the length later.
1362             let end := ptr
1363 
1364             // We write the string from the rightmost digit to the leftmost digit.
1365             // The following is essentially a do-while loop that also handles the zero case.
1366             // Costs a bit more than early returning for the zero case,
1367             // but cheaper in terms of deployment and overall runtime costs.
1368             for {
1369                 // Initialize and perform the first pass without check.
1370                 let temp := value
1371                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1372                 ptr := sub(ptr, 1)
1373                 // Write the character to the pointer.
1374                 // The ASCII index of the '0' character is 48.
1375                 mstore8(ptr, add(48, mod(temp, 10)))
1376                 temp := div(temp, 10)
1377             } temp {
1378                 // Keep dividing `temp` until zero.
1379                 temp := div(temp, 10)
1380             } {
1381                 // Body of the for loop.
1382                 ptr := sub(ptr, 1)
1383                 mstore8(ptr, add(48, mod(temp, 10)))
1384             }
1385 
1386             let length := sub(end, ptr)
1387             // Move the pointer 32 bytes leftwards to make room for the length.
1388             ptr := sub(ptr, 32)
1389             // Store the length.
1390             mstore(ptr, length)
1391         }
1392     }
1393 }
1394 
1395 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1396 
1397 
1398 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 /**
1403  * @dev These functions deal with verification of Merkle Tree proofs.
1404  *
1405  * The proofs can be generated using the JavaScript library
1406  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1407  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1408  *
1409  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1410  *
1411  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1412  * hashing, or use a hash function other than keccak256 for hashing leaves.
1413  * This is because the concatenation of a sorted pair of internal nodes in
1414  * the merkle tree could be reinterpreted as a leaf value.
1415  */
1416 library MerkleProof {
1417     /**
1418      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1419      * defined by `root`. For this, a `proof` must be provided, containing
1420      * sibling hashes on the branch from the leaf to the root of the tree. Each
1421      * pair of leaves and each pair of pre-images are assumed to be sorted.
1422      */
1423     function verify(
1424         bytes32[] memory proof,
1425         bytes32 root,
1426         bytes32 leaf
1427     ) internal pure returns (bool) {
1428         return processProof(proof, leaf) == root;
1429     }
1430 
1431     /**
1432      * @dev Calldata version of {verify}
1433      *
1434      * _Available since v4.7._
1435      */
1436     function verifyCalldata(
1437         bytes32[] calldata proof,
1438         bytes32 root,
1439         bytes32 leaf
1440     ) internal pure returns (bool) {
1441         return processProofCalldata(proof, leaf) == root;
1442     }
1443 
1444     /**
1445      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1446      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1447      * hash matches the root of the tree. When processing the proof, the pairs
1448      * of leafs & pre-images are assumed to be sorted.
1449      *
1450      * _Available since v4.4._
1451      */
1452     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1453         bytes32 computedHash = leaf;
1454         for (uint256 i = 0; i < proof.length; i++) {
1455             computedHash = _hashPair(computedHash, proof[i]);
1456         }
1457         return computedHash;
1458     }
1459 
1460     /**
1461      * @dev Calldata version of {processProof}
1462      *
1463      * _Available since v4.7._
1464      */
1465     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1466         bytes32 computedHash = leaf;
1467         for (uint256 i = 0; i < proof.length; i++) {
1468             computedHash = _hashPair(computedHash, proof[i]);
1469         }
1470         return computedHash;
1471     }
1472 
1473     /**
1474      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1475      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1476      *
1477      * _Available since v4.7._
1478      */
1479     function multiProofVerify(
1480         bytes32[] memory proof,
1481         bool[] memory proofFlags,
1482         bytes32 root,
1483         bytes32[] memory leaves
1484     ) internal pure returns (bool) {
1485         return processMultiProof(proof, proofFlags, leaves) == root;
1486     }
1487 
1488     /**
1489      * @dev Calldata version of {multiProofVerify}
1490      *
1491      * _Available since v4.7._
1492      */
1493     function multiProofVerifyCalldata(
1494         bytes32[] calldata proof,
1495         bool[] calldata proofFlags,
1496         bytes32 root,
1497         bytes32[] memory leaves
1498     ) internal pure returns (bool) {
1499         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1500     }
1501 
1502     /**
1503      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1504      * consuming from one or the other at each step according to the instructions given by
1505      * `proofFlags`.
1506      *
1507      * _Available since v4.7._
1508      */
1509     function processMultiProof(
1510         bytes32[] memory proof,
1511         bool[] memory proofFlags,
1512         bytes32[] memory leaves
1513     ) internal pure returns (bytes32 merkleRoot) {
1514         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1515         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1516         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1517         // the merkle tree.
1518         uint256 leavesLen = leaves.length;
1519         uint256 totalHashes = proofFlags.length;
1520 
1521         // Check proof validity.
1522         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1523 
1524         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1525         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1526         bytes32[] memory hashes = new bytes32[](totalHashes);
1527         uint256 leafPos = 0;
1528         uint256 hashPos = 0;
1529         uint256 proofPos = 0;
1530         // At each step, we compute the next hash using two values:
1531         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1532         //   get the next hash.
1533         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1534         //   `proof` array.
1535         for (uint256 i = 0; i < totalHashes; i++) {
1536             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1537             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1538             hashes[i] = _hashPair(a, b);
1539         }
1540 
1541         if (totalHashes > 0) {
1542             return hashes[totalHashes - 1];
1543         } else if (leavesLen > 0) {
1544             return leaves[0];
1545         } else {
1546             return proof[0];
1547         }
1548     }
1549 
1550     /**
1551      * @dev Calldata version of {processMultiProof}
1552      *
1553      * _Available since v4.7._
1554      */
1555     function processMultiProofCalldata(
1556         bytes32[] calldata proof,
1557         bool[] calldata proofFlags,
1558         bytes32[] memory leaves
1559     ) internal pure returns (bytes32 merkleRoot) {
1560         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1561         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1562         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1563         // the merkle tree.
1564         uint256 leavesLen = leaves.length;
1565         uint256 totalHashes = proofFlags.length;
1566 
1567         // Check proof validity.
1568         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1569 
1570         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1571         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1572         bytes32[] memory hashes = new bytes32[](totalHashes);
1573         uint256 leafPos = 0;
1574         uint256 hashPos = 0;
1575         uint256 proofPos = 0;
1576         // At each step, we compute the next hash using two values:
1577         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1578         //   get the next hash.
1579         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1580         //   `proof` array.
1581         for (uint256 i = 0; i < totalHashes; i++) {
1582             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1583             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1584             hashes[i] = _hashPair(a, b);
1585         }
1586 
1587         if (totalHashes > 0) {
1588             return hashes[totalHashes - 1];
1589         } else if (leavesLen > 0) {
1590             return leaves[0];
1591         } else {
1592             return proof[0];
1593         }
1594     }
1595 
1596     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1597         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1598     }
1599 
1600     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1601         /// @solidity memory-safe-assembly
1602         assembly {
1603             mstore(0x00, a)
1604             mstore(0x20, b)
1605             value := keccak256(0x00, 0x40)
1606         }
1607     }
1608 }
1609 
1610 // File: @openzeppelin/contracts/utils/math/Math.sol
1611 
1612 
1613 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 /**
1618  * @dev Standard math utilities missing in the Solidity language.
1619  */
1620 library Math {
1621     enum Rounding {
1622         Down, // Toward negative infinity
1623         Up, // Toward infinity
1624         Zero // Toward zero
1625     }
1626 
1627     /**
1628      * @dev Returns the largest of two numbers.
1629      */
1630     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1631         return a >= b ? a : b;
1632     }
1633 
1634     /**
1635      * @dev Returns the smallest of two numbers.
1636      */
1637     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1638         return a < b ? a : b;
1639     }
1640 
1641     /**
1642      * @dev Returns the average of two numbers. The result is rounded towards
1643      * zero.
1644      */
1645     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1646         // (a + b) / 2 can overflow.
1647         return (a & b) + (a ^ b) / 2;
1648     }
1649 
1650     /**
1651      * @dev Returns the ceiling of the division of two numbers.
1652      *
1653      * This differs from standard division with `/` in that it rounds up instead
1654      * of rounding down.
1655      */
1656     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1657         // (a + b - 1) / b can overflow on addition, so we distribute.
1658         return a == 0 ? 0 : (a - 1) / b + 1;
1659     }
1660 
1661     /**
1662      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1663      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1664      * with further edits by Uniswap Labs also under MIT license.
1665      */
1666     function mulDiv(
1667         uint256 x,
1668         uint256 y,
1669         uint256 denominator
1670     ) internal pure returns (uint256 result) {
1671         unchecked {
1672             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1673             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1674             // variables such that product = prod1 * 2^256 + prod0.
1675             uint256 prod0; // Least significant 256 bits of the product
1676             uint256 prod1; // Most significant 256 bits of the product
1677             assembly {
1678                 let mm := mulmod(x, y, not(0))
1679                 prod0 := mul(x, y)
1680                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1681             }
1682 
1683             // Handle non-overflow cases, 256 by 256 division.
1684             if (prod1 == 0) {
1685                 return prod0 / denominator;
1686             }
1687 
1688             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1689             require(denominator > prod1);
1690 
1691             ///////////////////////////////////////////////
1692             // 512 by 256 division.
1693             ///////////////////////////////////////////////
1694 
1695             // Make division exact by subtracting the remainder from [prod1 prod0].
1696             uint256 remainder;
1697             assembly {
1698                 // Compute remainder using mulmod.
1699                 remainder := mulmod(x, y, denominator)
1700 
1701                 // Subtract 256 bit number from 512 bit number.
1702                 prod1 := sub(prod1, gt(remainder, prod0))
1703                 prod0 := sub(prod0, remainder)
1704             }
1705 
1706             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1707             // See https://cs.stackexchange.com/q/138556/92363.
1708 
1709             // Does not overflow because the denominator cannot be zero at this stage in the function.
1710             uint256 twos = denominator & (~denominator + 1);
1711             assembly {
1712                 // Divide denominator by twos.
1713                 denominator := div(denominator, twos)
1714 
1715                 // Divide [prod1 prod0] by twos.
1716                 prod0 := div(prod0, twos)
1717 
1718                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1719                 twos := add(div(sub(0, twos), twos), 1)
1720             }
1721 
1722             // Shift in bits from prod1 into prod0.
1723             prod0 |= prod1 * twos;
1724 
1725             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1726             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1727             // four bits. That is, denominator * inv = 1 mod 2^4.
1728             uint256 inverse = (3 * denominator) ^ 2;
1729 
1730             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1731             // in modular arithmetic, doubling the correct bits in each step.
1732             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1733             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1734             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1735             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1736             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1737             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1738 
1739             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1740             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1741             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1742             // is no longer required.
1743             result = prod0 * inverse;
1744             return result;
1745         }
1746     }
1747 
1748     /**
1749      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1750      */
1751     function mulDiv(
1752         uint256 x,
1753         uint256 y,
1754         uint256 denominator,
1755         Rounding rounding
1756     ) internal pure returns (uint256) {
1757         uint256 result = mulDiv(x, y, denominator);
1758         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1759             result += 1;
1760         }
1761         return result;
1762     }
1763 
1764     /**
1765      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
1766      *
1767      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1768      */
1769     function sqrt(uint256 a) internal pure returns (uint256) {
1770         if (a == 0) {
1771             return 0;
1772         }
1773 
1774         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1775         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1776         // `msb(a) <= a < 2*msb(a)`.
1777         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
1778         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
1779         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
1780         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
1781         uint256 result = 1;
1782         uint256 x = a;
1783         if (x >> 128 > 0) {
1784             x >>= 128;
1785             result <<= 64;
1786         }
1787         if (x >> 64 > 0) {
1788             x >>= 64;
1789             result <<= 32;
1790         }
1791         if (x >> 32 > 0) {
1792             x >>= 32;
1793             result <<= 16;
1794         }
1795         if (x >> 16 > 0) {
1796             x >>= 16;
1797             result <<= 8;
1798         }
1799         if (x >> 8 > 0) {
1800             x >>= 8;
1801             result <<= 4;
1802         }
1803         if (x >> 4 > 0) {
1804             x >>= 4;
1805             result <<= 2;
1806         }
1807         if (x >> 2 > 0) {
1808             result <<= 1;
1809         }
1810 
1811         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1812         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1813         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1814         // into the expected uint128 result.
1815         unchecked {
1816             result = (result + a / result) >> 1;
1817             result = (result + a / result) >> 1;
1818             result = (result + a / result) >> 1;
1819             result = (result + a / result) >> 1;
1820             result = (result + a / result) >> 1;
1821             result = (result + a / result) >> 1;
1822             result = (result + a / result) >> 1;
1823             return min(result, a / result);
1824         }
1825     }
1826 
1827     /**
1828      * @notice Calculates sqrt(a), following the selected rounding direction.
1829      */
1830     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1831         uint256 result = sqrt(a);
1832         if (rounding == Rounding.Up && result * result < a) {
1833             result += 1;
1834         }
1835         return result;
1836     }
1837 }
1838 
1839 // File: @openzeppelin/contracts/utils/Address.sol
1840 
1841 
1842 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1843 
1844 pragma solidity ^0.8.1;
1845 
1846 /**
1847  * @dev Collection of functions related to the address type
1848  */
1849 library Address {
1850     /**
1851      * @dev Returns true if `account` is a contract.
1852      *
1853      * [IMPORTANT]
1854      * ====
1855      * It is unsafe to assume that an address for which this function returns
1856      * false is an externally-owned account (EOA) and not a contract.
1857      *
1858      * Among others, `isContract` will return false for the following
1859      * types of addresses:
1860      *
1861      *  - an externally-owned account
1862      *  - a contract in construction
1863      *  - an address where a contract will be created
1864      *  - an address where a contract lived, but was destroyed
1865      * ====
1866      *
1867      * [IMPORTANT]
1868      * ====
1869      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1870      *
1871      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1872      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1873      * constructor.
1874      * ====
1875      */
1876     function isContract(address account) internal view returns (bool) {
1877         // This method relies on extcodesize/address.code.length, which returns 0
1878         // for contracts in construction, since the code is only stored at the end
1879         // of the constructor execution.
1880 
1881         return account.code.length > 0;
1882     }
1883 
1884     /**
1885      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1886      * `recipient`, forwarding all available gas and reverting on errors.
1887      *
1888      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1889      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1890      * imposed by `transfer`, making them unable to receive funds via
1891      * `transfer`. {sendValue} removes this limitation.
1892      *
1893      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1894      *
1895      * IMPORTANT: because control is transferred to `recipient`, care must be
1896      * taken to not create reentrancy vulnerabilities. Consider using
1897      * {ReentrancyGuard} or the
1898      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1899      */
1900     function sendValue(address payable recipient, uint256 amount) internal {
1901         require(address(this).balance >= amount, "Address: insufficient balance");
1902 
1903         (bool success, ) = recipient.call{value: amount}("");
1904         require(success, "Address: unable to send value, recipient may have reverted");
1905     }
1906 
1907     /**
1908      * @dev Performs a Solidity function call using a low level `call`. A
1909      * plain `call` is an unsafe replacement for a function call: use this
1910      * function instead.
1911      *
1912      * If `target` reverts with a revert reason, it is bubbled up by this
1913      * function (like regular Solidity function calls).
1914      *
1915      * Returns the raw returned data. To convert to the expected return value,
1916      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1917      *
1918      * Requirements:
1919      *
1920      * - `target` must be a contract.
1921      * - calling `target` with `data` must not revert.
1922      *
1923      * _Available since v3.1._
1924      */
1925     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1926         return functionCall(target, data, "Address: low-level call failed");
1927     }
1928 
1929     /**
1930      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1931      * `errorMessage` as a fallback revert reason when `target` reverts.
1932      *
1933      * _Available since v3.1._
1934      */
1935     function functionCall(
1936         address target,
1937         bytes memory data,
1938         string memory errorMessage
1939     ) internal returns (bytes memory) {
1940         return functionCallWithValue(target, data, 0, errorMessage);
1941     }
1942 
1943     /**
1944      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1945      * but also transferring `value` wei to `target`.
1946      *
1947      * Requirements:
1948      *
1949      * - the calling contract must have an ETH balance of at least `value`.
1950      * - the called Solidity function must be `payable`.
1951      *
1952      * _Available since v3.1._
1953      */
1954     function functionCallWithValue(
1955         address target,
1956         bytes memory data,
1957         uint256 value
1958     ) internal returns (bytes memory) {
1959         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1960     }
1961 
1962     /**
1963      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1964      * with `errorMessage` as a fallback revert reason when `target` reverts.
1965      *
1966      * _Available since v3.1._
1967      */
1968     function functionCallWithValue(
1969         address target,
1970         bytes memory data,
1971         uint256 value,
1972         string memory errorMessage
1973     ) internal returns (bytes memory) {
1974         require(address(this).balance >= value, "Address: insufficient balance for call");
1975         require(isContract(target), "Address: call to non-contract");
1976 
1977         (bool success, bytes memory returndata) = target.call{value: value}(data);
1978         return verifyCallResult(success, returndata, errorMessage);
1979     }
1980 
1981     /**
1982      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1983      * but performing a static call.
1984      *
1985      * _Available since v3.3._
1986      */
1987     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1988         return functionStaticCall(target, data, "Address: low-level static call failed");
1989     }
1990 
1991     /**
1992      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1993      * but performing a static call.
1994      *
1995      * _Available since v3.3._
1996      */
1997     function functionStaticCall(
1998         address target,
1999         bytes memory data,
2000         string memory errorMessage
2001     ) internal view returns (bytes memory) {
2002         require(isContract(target), "Address: static call to non-contract");
2003 
2004         (bool success, bytes memory returndata) = target.staticcall(data);
2005         return verifyCallResult(success, returndata, errorMessage);
2006     }
2007 
2008     /**
2009      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2010      * but performing a delegate call.
2011      *
2012      * _Available since v3.4._
2013      */
2014     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2015         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2016     }
2017 
2018     /**
2019      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2020      * but performing a delegate call.
2021      *
2022      * _Available since v3.4._
2023      */
2024     function functionDelegateCall(
2025         address target,
2026         bytes memory data,
2027         string memory errorMessage
2028     ) internal returns (bytes memory) {
2029         require(isContract(target), "Address: delegate call to non-contract");
2030 
2031         (bool success, bytes memory returndata) = target.delegatecall(data);
2032         return verifyCallResult(success, returndata, errorMessage);
2033     }
2034 
2035     /**
2036      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2037      * revert reason using the provided one.
2038      *
2039      * _Available since v4.3._
2040      */
2041     function verifyCallResult(
2042         bool success,
2043         bytes memory returndata,
2044         string memory errorMessage
2045     ) internal pure returns (bytes memory) {
2046         if (success) {
2047             return returndata;
2048         } else {
2049             // Look for revert reason and bubble it up if present
2050             if (returndata.length > 0) {
2051                 // The easiest way to bubble the revert reason is using memory via assembly
2052                 /// @solidity memory-safe-assembly
2053                 assembly {
2054                     let returndata_size := mload(returndata)
2055                     revert(add(32, returndata), returndata_size)
2056                 }
2057             } else {
2058                 revert(errorMessage);
2059             }
2060         }
2061     }
2062 }
2063 
2064 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2065 
2066 
2067 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2068 
2069 pragma solidity ^0.8.0;
2070 
2071 /**
2072  * @title ERC721 token receiver interface
2073  * @dev Interface for any contract that wants to support safeTransfers
2074  * from ERC721 asset contracts.
2075  */
2076 interface IERC721Receiver {
2077     /**
2078      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2079      * by `operator` from `from`, this function is called.
2080      *
2081      * It must return its Solidity selector to confirm the token transfer.
2082      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2083      *
2084      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2085      */
2086     function onERC721Received(
2087         address operator,
2088         address from,
2089         uint256 tokenId,
2090         bytes calldata data
2091     ) external returns (bytes4);
2092 }
2093 
2094 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2095 
2096 
2097 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2098 
2099 pragma solidity ^0.8.0;
2100 
2101 /**
2102  * @dev Interface of the ERC165 standard, as defined in the
2103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2104  *
2105  * Implementers can declare support of contract interfaces, which can then be
2106  * queried by others ({ERC165Checker}).
2107  *
2108  * For an implementation, see {ERC165}.
2109  */
2110 interface IERC165 {
2111     /**
2112      * @dev Returns true if this contract implements the interface defined by
2113      * `interfaceId`. See the corresponding
2114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2115      * to learn more about how these ids are created.
2116      *
2117      * This function call must use less than 30 000 gas.
2118      */
2119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2120 }
2121 
2122 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
2123 
2124 
2125 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2126 
2127 pragma solidity ^0.8.0;
2128 
2129 
2130 /**
2131  * @dev Interface for the NFT Royalty Standard.
2132  *
2133  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2134  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2135  *
2136  * _Available since v4.5._
2137  */
2138 interface IERC2981 is IERC165 {
2139     /**
2140      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2141      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2142      */
2143     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2144         external
2145         view
2146         returns (address receiver, uint256 royaltyAmount);
2147 }
2148 
2149 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2150 
2151 
2152 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2153 
2154 pragma solidity ^0.8.0;
2155 
2156 
2157 /**
2158  * @dev Implementation of the {IERC165} interface.
2159  *
2160  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2161  * for the additional interface id that will be supported. For example:
2162  *
2163  * ```solidity
2164  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2165  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2166  * }
2167  * ```
2168  *
2169  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2170  */
2171 abstract contract ERC165 is IERC165 {
2172     /**
2173      * @dev See {IERC165-supportsInterface}.
2174      */
2175     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2176         return interfaceId == type(IERC165).interfaceId;
2177     }
2178 }
2179 
2180 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2181 
2182 
2183 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2184 
2185 pragma solidity ^0.8.0;
2186 
2187 
2188 
2189 /**
2190  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2191  *
2192  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2193  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2194  *
2195  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2196  * fee is specified in basis points by default.
2197  *
2198  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2199  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2200  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2201  *
2202  * _Available since v4.5._
2203  */
2204 abstract contract ERC2981 is IERC2981, ERC165 {
2205     struct RoyaltyInfo {
2206         address receiver;
2207         uint96 royaltyFraction;
2208     }
2209 
2210     RoyaltyInfo private _defaultRoyaltyInfo;
2211     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2212 
2213     /**
2214      * @dev See {IERC165-supportsInterface}.
2215      */
2216     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2217         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2218     }
2219 
2220     /**
2221      * @inheritdoc IERC2981
2222      */
2223     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2224         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2225 
2226         if (royalty.receiver == address(0)) {
2227             royalty = _defaultRoyaltyInfo;
2228         }
2229 
2230         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2231 
2232         return (royalty.receiver, royaltyAmount);
2233     }
2234 
2235     /**
2236      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2237      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2238      * override.
2239      */
2240     function _feeDenominator() internal pure virtual returns (uint96) {
2241         return 10000;
2242     }
2243 
2244     /**
2245      * @dev Sets the royalty information that all ids in this contract will default to.
2246      *
2247      * Requirements:
2248      *
2249      * - `receiver` cannot be the zero address.
2250      * - `feeNumerator` cannot be greater than the fee denominator.
2251      */
2252     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2253         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2254         require(receiver != address(0), "ERC2981: invalid receiver");
2255 
2256         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2257     }
2258 
2259     /**
2260      * @dev Removes default royalty information.
2261      */
2262     function _deleteDefaultRoyalty() internal virtual {
2263         delete _defaultRoyaltyInfo;
2264     }
2265 
2266     /**
2267      * @dev Sets the royalty information for a specific token id, overriding the global default.
2268      *
2269      * Requirements:
2270      *
2271      * - `receiver` cannot be the zero address.
2272      * - `feeNumerator` cannot be greater than the fee denominator.
2273      */
2274     function _setTokenRoyalty(
2275         uint256 tokenId,
2276         address receiver,
2277         uint96 feeNumerator
2278     ) internal virtual {
2279         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2280         require(receiver != address(0), "ERC2981: Invalid parameters");
2281 
2282         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2283     }
2284 
2285     /**
2286      * @dev Resets royalty information for the token id back to the global default.
2287      */
2288     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2289         delete _tokenRoyaltyInfo[tokenId];
2290     }
2291 }
2292 
2293 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2294 
2295 
2296 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
2297 
2298 pragma solidity ^0.8.0;
2299 
2300 
2301 /**
2302  * @dev Required interface of an ERC721 compliant contract.
2303  */
2304 interface IERC721 is IERC165 {
2305     /**
2306      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2307      */
2308     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2309 
2310     /**
2311      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2312      */
2313     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2314 
2315     /**
2316      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2317      */
2318     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2319 
2320     /**
2321      * @dev Returns the number of tokens in ``owner``'s account.
2322      */
2323     function balanceOf(address owner) external view returns (uint256 balance);
2324 
2325     /**
2326      * @dev Returns the owner of the `tokenId` token.
2327      *
2328      * Requirements:
2329      *
2330      * - `tokenId` must exist.
2331      */
2332     function ownerOf(uint256 tokenId) external view returns (address owner);
2333 
2334     /**
2335      * @dev Safely transfers `tokenId` token from `from` to `to`.
2336      *
2337      * Requirements:
2338      *
2339      * - `from` cannot be the zero address.
2340      * - `to` cannot be the zero address.
2341      * - `tokenId` token must exist and be owned by `from`.
2342      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2344      *
2345      * Emits a {Transfer} event.
2346      */
2347     function safeTransferFrom(
2348         address from,
2349         address to,
2350         uint256 tokenId,
2351         bytes calldata data
2352     ) external;
2353 
2354     /**
2355      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2356      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2357      *
2358      * Requirements:
2359      *
2360      * - `from` cannot be the zero address.
2361      * - `to` cannot be the zero address.
2362      * - `tokenId` token must exist and be owned by `from`.
2363      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2364      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2365      *
2366      * Emits a {Transfer} event.
2367      */
2368     function safeTransferFrom(
2369         address from,
2370         address to,
2371         uint256 tokenId
2372     ) external;
2373 
2374     /**
2375      * @dev Transfers `tokenId` token from `from` to `to`.
2376      *
2377      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2378      *
2379      * Requirements:
2380      *
2381      * - `from` cannot be the zero address.
2382      * - `to` cannot be the zero address.
2383      * - `tokenId` token must be owned by `from`.
2384      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2385      *
2386      * Emits a {Transfer} event.
2387      */
2388     function transferFrom(
2389         address from,
2390         address to,
2391         uint256 tokenId
2392     ) external;
2393 
2394     /**
2395      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2396      * The approval is cleared when the token is transferred.
2397      *
2398      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2399      *
2400      * Requirements:
2401      *
2402      * - The caller must own the token or be an approved operator.
2403      * - `tokenId` must exist.
2404      *
2405      * Emits an {Approval} event.
2406      */
2407     function approve(address to, uint256 tokenId) external;
2408 
2409     /**
2410      * @dev Approve or remove `operator` as an operator for the caller.
2411      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2412      *
2413      * Requirements:
2414      *
2415      * - The `operator` cannot be the caller.
2416      *
2417      * Emits an {ApprovalForAll} event.
2418      */
2419     function setApprovalForAll(address operator, bool _approved) external;
2420 
2421     /**
2422      * @dev Returns the account approved for `tokenId` token.
2423      *
2424      * Requirements:
2425      *
2426      * - `tokenId` must exist.
2427      */
2428     function getApproved(uint256 tokenId) external view returns (address operator);
2429 
2430     /**
2431      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2432      *
2433      * See {setApprovalForAll}
2434      */
2435     function isApprovedForAll(address owner, address operator) external view returns (bool);
2436 }
2437 
2438 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2439 
2440 
2441 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2442 
2443 pragma solidity ^0.8.0;
2444 
2445 
2446 /**
2447  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2448  * @dev See https://eips.ethereum.org/EIPS/eip-721
2449  */
2450 interface IERC721Metadata is IERC721 {
2451     /**
2452      * @dev Returns the token collection name.
2453      */
2454     function name() external view returns (string memory);
2455 
2456     /**
2457      * @dev Returns the token collection symbol.
2458      */
2459     function symbol() external view returns (string memory);
2460 
2461     /**
2462      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2463      */
2464     function tokenURI(uint256 tokenId) external view returns (string memory);
2465 }
2466 
2467 // File: @openzeppelin/contracts/utils/Context.sol
2468 
2469 
2470 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2471 
2472 pragma solidity ^0.8.0;
2473 
2474 /**
2475  * @dev Provides information about the current execution context, including the
2476  * sender of the transaction and its data. While these are generally available
2477  * via msg.sender and msg.data, they should not be accessed in such a direct
2478  * manner, since when dealing with meta-transactions the account sending and
2479  * paying for execution may not be the actual sender (as far as an application
2480  * is concerned).
2481  *
2482  * This contract is only required for intermediate, library-like contracts.
2483  */
2484 abstract contract Context {
2485     function _msgSender() internal view virtual returns (address) {
2486         return msg.sender;
2487     }
2488 
2489     function _msgData() internal view virtual returns (bytes calldata) {
2490         return msg.data;
2491     }
2492 }
2493 
2494 // File: @openzeppelin/contracts/access/Ownable.sol
2495 
2496 
2497 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2498 
2499 pragma solidity ^0.8.0;
2500 
2501 
2502 /**
2503  * @dev Contract module which provides a basic access control mechanism, where
2504  * there is an account (an owner) that can be granted exclusive access to
2505  * specific functions.
2506  *
2507  * By default, the owner account will be the one that deploys the contract. This
2508  * can later be changed with {transferOwnership}.
2509  *
2510  * This module is used through inheritance. It will make available the modifier
2511  * `onlyOwner`, which can be applied to your functions to restrict their use to
2512  * the owner.
2513  */
2514 abstract contract Ownable is Context {
2515     address private _owner;
2516 
2517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2518 
2519     /**
2520      * @dev Initializes the contract setting the deployer as the initial owner.
2521      */
2522     constructor() {
2523         _transferOwnership(_msgSender());
2524     }
2525 
2526     /**
2527      * @dev Throws if called by any account other than the owner.
2528      */
2529     modifier onlyOwner() {
2530         _checkOwner();
2531         _;
2532     }
2533 
2534     /**
2535      * @dev Returns the address of the current owner.
2536      */
2537     function owner() public view virtual returns (address) {
2538         return _owner;
2539     }
2540 
2541     /**
2542      * @dev Throws if the sender is not the owner.
2543      */
2544     function _checkOwner() internal view virtual {
2545         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2546     }
2547 
2548     /**
2549      * @dev Leaves the contract without owner. It will not be possible to call
2550      * `onlyOwner` functions anymore. Can only be called by the current owner.
2551      *
2552      * NOTE: Renouncing ownership will leave the contract without an owner,
2553      * thereby removing any functionality that is only available to the owner.
2554      */
2555     function renounceOwnership() public virtual onlyOwner {
2556         _transferOwnership(address(0));
2557     }
2558 
2559     /**
2560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2561      * Can only be called by the current owner.
2562      */
2563     function transferOwnership(address newOwner) public virtual onlyOwner {
2564         require(newOwner != address(0), "Ownable: new owner is the zero address");
2565         _transferOwnership(newOwner);
2566     }
2567 
2568     /**
2569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2570      * Internal function without access restriction.
2571      */
2572     function _transferOwnership(address newOwner) internal virtual {
2573         address oldOwner = _owner;
2574         _owner = newOwner;
2575         emit OwnershipTransferred(oldOwner, newOwner);
2576     }
2577 }
2578 
2579 // File: @openzeppelin/contracts/utils/Strings.sol
2580 
2581 
2582 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2583 
2584 pragma solidity ^0.8.0;
2585 
2586 /**
2587  * @dev String operations.
2588  */
2589 library Strings {
2590     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2591     uint8 private constant _ADDRESS_LENGTH = 20;
2592 
2593     /**
2594      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2595      */
2596     function toString(uint256 value) internal pure returns (string memory) {
2597         // Inspired by OraclizeAPI's implementation - MIT licence
2598         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2599 
2600         if (value == 0) {
2601             return "0";
2602         }
2603         uint256 temp = value;
2604         uint256 digits;
2605         while (temp != 0) {
2606             digits++;
2607             temp /= 10;
2608         }
2609         bytes memory buffer = new bytes(digits);
2610         while (value != 0) {
2611             digits -= 1;
2612             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2613             value /= 10;
2614         }
2615         return string(buffer);
2616     }
2617 
2618     /**
2619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2620      */
2621     function toHexString(uint256 value) internal pure returns (string memory) {
2622         if (value == 0) {
2623             return "0x00";
2624         }
2625         uint256 temp = value;
2626         uint256 length = 0;
2627         while (temp != 0) {
2628             length++;
2629             temp >>= 8;
2630         }
2631         return toHexString(value, length);
2632     }
2633 
2634     /**
2635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2636      */
2637     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2638         bytes memory buffer = new bytes(2 * length + 2);
2639         buffer[0] = "0";
2640         buffer[1] = "x";
2641         for (uint256 i = 2 * length + 1; i > 1; --i) {
2642             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2643             value >>= 4;
2644         }
2645         require(value == 0, "Strings: hex length insufficient");
2646         return string(buffer);
2647     }
2648 
2649     /**
2650      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2651      */
2652     function toHexString(address addr) internal pure returns (string memory) {
2653         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2654     }
2655 }
2656 
2657 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2658 
2659 
2660 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
2661 
2662 pragma solidity ^0.8.0;
2663 
2664 
2665 
2666 
2667 
2668 
2669 
2670 
2671 /**
2672  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2673  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2674  * {ERC721Enumerable}.
2675  */
2676 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2677     using Address for address;
2678     using Strings for uint256;
2679 
2680     // Token name
2681     string private _name;
2682 
2683     // Token symbol
2684     string private _symbol;
2685 
2686     // Mapping from token ID to owner address
2687     mapping(uint256 => address) private _owners;
2688 
2689     // Mapping owner address to token count
2690     mapping(address => uint256) private _balances;
2691 
2692     // Mapping from token ID to approved address
2693     mapping(uint256 => address) private _tokenApprovals;
2694 
2695     // Mapping from owner to operator approvals
2696     mapping(address => mapping(address => bool)) private _operatorApprovals;
2697 
2698     /**
2699      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2700      */
2701     constructor(string memory name_, string memory symbol_) {
2702         _name = name_;
2703         _symbol = symbol_;
2704     }
2705 
2706     /**
2707      * @dev See {IERC165-supportsInterface}.
2708      */
2709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2710         return
2711             interfaceId == type(IERC721).interfaceId ||
2712             interfaceId == type(IERC721Metadata).interfaceId ||
2713             super.supportsInterface(interfaceId);
2714     }
2715 
2716     /**
2717      * @dev See {IERC721-balanceOf}.
2718      */
2719     function balanceOf(address owner) public view virtual override returns (uint256) {
2720         require(owner != address(0), "ERC721: address zero is not a valid owner");
2721         return _balances[owner];
2722     }
2723 
2724     /**
2725      * @dev See {IERC721-ownerOf}.
2726      */
2727     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2728         address owner = _owners[tokenId];
2729         require(owner != address(0), "ERC721: invalid token ID");
2730         return owner;
2731     }
2732 
2733     /**
2734      * @dev See {IERC721Metadata-name}.
2735      */
2736     function name() public view virtual override returns (string memory) {
2737         return _name;
2738     }
2739 
2740     /**
2741      * @dev See {IERC721Metadata-symbol}.
2742      */
2743     function symbol() public view virtual override returns (string memory) {
2744         return _symbol;
2745     }
2746 
2747     /**
2748      * @dev See {IERC721Metadata-tokenURI}.
2749      */
2750     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2751         _requireMinted(tokenId);
2752 
2753         string memory baseURI = _baseURI();
2754         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2755     }
2756 
2757     /**
2758      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2759      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2760      * by default, can be overridden in child contracts.
2761      */
2762     function _baseURI() internal view virtual returns (string memory) {
2763         return "";
2764     }
2765 
2766     /**
2767      * @dev See {IERC721-approve}.
2768      */
2769     function approve(address to, uint256 tokenId) public virtual override {
2770         address owner = ERC721.ownerOf(tokenId);
2771         require(to != owner, "ERC721: approval to current owner");
2772 
2773         require(
2774             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2775             "ERC721: approve caller is not token owner nor approved for all"
2776         );
2777 
2778         _approve(to, tokenId);
2779     }
2780 
2781     /**
2782      * @dev See {IERC721-getApproved}.
2783      */
2784     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2785         _requireMinted(tokenId);
2786 
2787         return _tokenApprovals[tokenId];
2788     }
2789 
2790     /**
2791      * @dev See {IERC721-setApprovalForAll}.
2792      */
2793     function setApprovalForAll(address operator, bool approved) public virtual override {
2794         _setApprovalForAll(_msgSender(), operator, approved);
2795     }
2796 
2797     /**
2798      * @dev See {IERC721-isApprovedForAll}.
2799      */
2800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2801         return _operatorApprovals[owner][operator];
2802     }
2803 
2804     /**
2805      * @dev See {IERC721-transferFrom}.
2806      */
2807     function transferFrom(
2808         address from,
2809         address to,
2810         uint256 tokenId
2811     ) public virtual override {
2812         //solhint-disable-next-line max-line-length
2813         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2814 
2815         _transfer(from, to, tokenId);
2816     }
2817 
2818     /**
2819      * @dev See {IERC721-safeTransferFrom}.
2820      */
2821     function safeTransferFrom(
2822         address from,
2823         address to,
2824         uint256 tokenId
2825     ) public virtual override {
2826         safeTransferFrom(from, to, tokenId, "");
2827     }
2828 
2829     /**
2830      * @dev See {IERC721-safeTransferFrom}.
2831      */
2832     function safeTransferFrom(
2833         address from,
2834         address to,
2835         uint256 tokenId,
2836         bytes memory data
2837     ) public virtual override {
2838         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2839         _safeTransfer(from, to, tokenId, data);
2840     }
2841 
2842     /**
2843      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2844      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2845      *
2846      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2847      *
2848      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2849      * implement alternative mechanisms to perform token transfer, such as signature-based.
2850      *
2851      * Requirements:
2852      *
2853      * - `from` cannot be the zero address.
2854      * - `to` cannot be the zero address.
2855      * - `tokenId` token must exist and be owned by `from`.
2856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2857      *
2858      * Emits a {Transfer} event.
2859      */
2860     function _safeTransfer(
2861         address from,
2862         address to,
2863         uint256 tokenId,
2864         bytes memory data
2865     ) internal virtual {
2866         _transfer(from, to, tokenId);
2867         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2868     }
2869 
2870     /**
2871      * @dev Returns whether `tokenId` exists.
2872      *
2873      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2874      *
2875      * Tokens start existing when they are minted (`_mint`),
2876      * and stop existing when they are burned (`_burn`).
2877      */
2878     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2879         return _owners[tokenId] != address(0);
2880     }
2881 
2882     /**
2883      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2884      *
2885      * Requirements:
2886      *
2887      * - `tokenId` must exist.
2888      */
2889     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2890         address owner = ERC721.ownerOf(tokenId);
2891         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2892     }
2893 
2894     /**
2895      * @dev Safely mints `tokenId` and transfers it to `to`.
2896      *
2897      * Requirements:
2898      *
2899      * - `tokenId` must not exist.
2900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2901      *
2902      * Emits a {Transfer} event.
2903      */
2904     function _safeMint(address to, uint256 tokenId) internal virtual {
2905         _safeMint(to, tokenId, "");
2906     }
2907 
2908     /**
2909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2911      */
2912     function _safeMint(
2913         address to,
2914         uint256 tokenId,
2915         bytes memory data
2916     ) internal virtual {
2917         _mint(to, tokenId);
2918         require(
2919             _checkOnERC721Received(address(0), to, tokenId, data),
2920             "ERC721: transfer to non ERC721Receiver implementer"
2921         );
2922     }
2923 
2924     /**
2925      * @dev Mints `tokenId` and transfers it to `to`.
2926      *
2927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2928      *
2929      * Requirements:
2930      *
2931      * - `tokenId` must not exist.
2932      * - `to` cannot be the zero address.
2933      *
2934      * Emits a {Transfer} event.
2935      */
2936     function _mint(address to, uint256 tokenId) internal virtual {
2937         require(to != address(0), "ERC721: mint to the zero address");
2938         require(!_exists(tokenId), "ERC721: token already minted");
2939 
2940         _beforeTokenTransfer(address(0), to, tokenId);
2941 
2942         _balances[to] += 1;
2943         _owners[tokenId] = to;
2944 
2945         emit Transfer(address(0), to, tokenId);
2946 
2947         _afterTokenTransfer(address(0), to, tokenId);
2948     }
2949 
2950     /**
2951      * @dev Destroys `tokenId`.
2952      * The approval is cleared when the token is burned.
2953      *
2954      * Requirements:
2955      *
2956      * - `tokenId` must exist.
2957      *
2958      * Emits a {Transfer} event.
2959      */
2960     function _burn(uint256 tokenId) internal virtual {
2961         address owner = ERC721.ownerOf(tokenId);
2962 
2963         _beforeTokenTransfer(owner, address(0), tokenId);
2964 
2965         // Clear approvals
2966         _approve(address(0), tokenId);
2967 
2968         _balances[owner] -= 1;
2969         delete _owners[tokenId];
2970 
2971         emit Transfer(owner, address(0), tokenId);
2972 
2973         _afterTokenTransfer(owner, address(0), tokenId);
2974     }
2975 
2976     /**
2977      * @dev Transfers `tokenId` from `from` to `to`.
2978      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2979      *
2980      * Requirements:
2981      *
2982      * - `to` cannot be the zero address.
2983      * - `tokenId` token must be owned by `from`.
2984      *
2985      * Emits a {Transfer} event.
2986      */
2987     function _transfer(
2988         address from,
2989         address to,
2990         uint256 tokenId
2991     ) internal virtual {
2992         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2993         require(to != address(0), "ERC721: transfer to the zero address");
2994 
2995         _beforeTokenTransfer(from, to, tokenId);
2996 
2997         // Clear approvals from the previous owner
2998         _approve(address(0), tokenId);
2999 
3000         _balances[from] -= 1;
3001         _balances[to] += 1;
3002         _owners[tokenId] = to;
3003 
3004         emit Transfer(from, to, tokenId);
3005 
3006         _afterTokenTransfer(from, to, tokenId);
3007     }
3008 
3009     /**
3010      * @dev Approve `to` to operate on `tokenId`
3011      *
3012      * Emits an {Approval} event.
3013      */
3014     function _approve(address to, uint256 tokenId) internal virtual {
3015         _tokenApprovals[tokenId] = to;
3016         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3017     }
3018 
3019     /**
3020      * @dev Approve `operator` to operate on all of `owner` tokens
3021      *
3022      * Emits an {ApprovalForAll} event.
3023      */
3024     function _setApprovalForAll(
3025         address owner,
3026         address operator,
3027         bool approved
3028     ) internal virtual {
3029         require(owner != operator, "ERC721: approve to caller");
3030         _operatorApprovals[owner][operator] = approved;
3031         emit ApprovalForAll(owner, operator, approved);
3032     }
3033 
3034     /**
3035      * @dev Reverts if the `tokenId` has not been minted yet.
3036      */
3037     function _requireMinted(uint256 tokenId) internal view virtual {
3038         require(_exists(tokenId), "ERC721: invalid token ID");
3039     }
3040 
3041     /**
3042      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3043      * The call is not executed if the target address is not a contract.
3044      *
3045      * @param from address representing the previous owner of the given token ID
3046      * @param to target address that will receive the tokens
3047      * @param tokenId uint256 ID of the token to be transferred
3048      * @param data bytes optional data to send along with the call
3049      * @return bool whether the call correctly returned the expected magic value
3050      */
3051     function _checkOnERC721Received(
3052         address from,
3053         address to,
3054         uint256 tokenId,
3055         bytes memory data
3056     ) private returns (bool) {
3057         if (to.isContract()) {
3058             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3059                 return retval == IERC721Receiver.onERC721Received.selector;
3060             } catch (bytes memory reason) {
3061                 if (reason.length == 0) {
3062                     revert("ERC721: transfer to non ERC721Receiver implementer");
3063                 } else {
3064                     /// @solidity memory-safe-assembly
3065                     assembly {
3066                         revert(add(32, reason), mload(reason))
3067                     }
3068                 }
3069             }
3070         } else {
3071             return true;
3072         }
3073     }
3074 
3075     /**
3076      * @dev Hook that is called before any token transfer. This includes minting
3077      * and burning.
3078      *
3079      * Calling conditions:
3080      *
3081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3082      * transferred to `to`.
3083      * - When `from` is zero, `tokenId` will be minted for `to`.
3084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3085      * - `from` and `to` are never both zero.
3086      *
3087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3088      */
3089     function _beforeTokenTransfer(
3090         address from,
3091         address to,
3092         uint256 tokenId
3093     ) internal virtual {}
3094 
3095     /**
3096      * @dev Hook that is called after any transfer of tokens. This includes
3097      * minting and burning.
3098      *
3099      * Calling conditions:
3100      *
3101      * - when `from` and `to` are both non-zero.
3102      * - `from` and `to` are never both zero.
3103      *
3104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3105      */
3106     function _afterTokenTransfer(
3107         address from,
3108         address to,
3109         uint256 tokenId
3110     ) internal virtual {}
3111 }
3112 
3113 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol
3114 
3115 
3116 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
3117 
3118 pragma solidity ^0.8.0;
3119 
3120 
3121 
3122 
3123 /**
3124  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
3125  * information.
3126  *
3127  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
3128  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
3129  *
3130  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
3131  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
3132  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
3133  *
3134  * _Available since v4.5._
3135  */
3136 abstract contract ERC721Royalty is ERC2981, ERC721 {
3137     /**
3138      * @dev See {IERC165-supportsInterface}.
3139      */
3140     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
3141         return super.supportsInterface(interfaceId);
3142     }
3143 
3144     /**
3145      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
3146      */
3147     function _burn(uint256 tokenId) internal virtual override {
3148         super._burn(tokenId);
3149         _resetTokenRoyalty(tokenId);
3150     }
3151 }
3152 
3153 // File: kamitama-kabuki-collections.sol
3154 
3155 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
3156 
3157 pragma solidity ^0.8.0;
3158 
3159 
3160 
3161 
3162 
3163 
3164 
3165 
3166 
3167 
3168 contract KamiTamaKabukiColections is ERC721A, ERC2981, Ownable {
3169     struct Offer {
3170         uint price;
3171         uint256 quantity;
3172         bytes32 root;
3173         address contractAddress;
3174         bool isFree;
3175         uint256 range;
3176     }
3177 
3178     using Address for address;
3179     
3180     uint8 private constant NOTSTART = 0;
3181     uint8 private constant PRESALE = 1;
3182     uint8 private constant SALE = 2;
3183     uint8 private _saleStatus = NOTSTART;
3184 
3185     bool private _revealed = true;
3186     uint private _basePrice = 0.088 ether;
3187     mapping(uint256 => Offer) private _preSaleOffers;
3188     mapping(bytes => bool) _attendedOffer;
3189 
3190     string private _url = 'https://bafybeifrdkm3xeu4qbydarvutxr6fxcegeom7rzrph7kjs7x7qldh3ho7q.ipfs.nftstorage.link/metadata';
3191 
3192     uint256 public constant MAX_SUPPLY = 7777;
3193     uint256 public constant RESEVRED = 150;
3194 
3195     constructor() ERC721A("KamiTama", "KT")
3196     {
3197       _setDefaultRoyalty(owner(), 500);
3198       _reserve(owner());
3199     }
3200 
3201     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3202         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
3203 
3204         string memory baseURI = _baseURI();
3205         if (bytes(baseURI).length != 0) {
3206           return _revealed ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), '.json')) : 
3207           string(abi.encodePacked(baseURI, '0.json'));
3208         } 
3209         
3210         return '';
3211     }
3212 
3213     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
3214         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
3215     }
3216 
3217     function repository() public view returns (uint256) {
3218        return MAX_SUPPLY > totalSupply() ? MAX_SUPPLY - totalSupply() : 0;
3219     }
3220     
3221     function preSaleRepository(uint256 round) public view returns (uint256) {
3222        Offer memory offer = _preSaleOffers[round];
3223 
3224         if(offer.range <= 0) return repository();
3225 
3226         uint256 maxSupply = Math.min(offer.range, MAX_SUPPLY);
3227         return maxSupply > totalSupply() ? maxSupply - totalSupply() : 0;
3228     }
3229 
3230     function flipReveal() public onlyOwner {
3231         _revealed = !_revealed;
3232     }
3233     
3234     function setSaleStatus(uint8 status) public onlyOwner {
3235         _saleStatus = status;
3236     }
3237 
3238     function mint(uint256 quantity) external payable {
3239         require(
3240             bytes(_url).length > 0,
3241             "Base url not set"
3242         );
3243 
3244         require(
3245             isSaleStart(),
3246             "Sale is not yet started"
3247         );
3248 
3249         require(
3250             quantity > 0,
3251             "Quantity should be larger than 1"
3252         );
3253 
3254         require(
3255             !saleSoldOut(quantity),
3256             "Sale would exceed max supply"
3257         );
3258 
3259         require(
3260             totalPrice(quantity) <= msg.value,
3261             "Not enough ether sent"
3262         );
3263 
3264         _safeMint(msg.sender, quantity);
3265 
3266         uint refund = msg.value - totalPrice(quantity);
3267         if(refund > 0){
3268             payable(msg.sender).transfer(refund);
3269         }
3270     }
3271 
3272     function saleSoldOut(uint256 quantity) public view returns (bool) {
3273         return quantity > repository();
3274     }
3275 
3276     function isSaleStart() public view returns (bool){
3277         return _saleStatus == SALE;
3278     }
3279     
3280     function totalPrice(uint256 quantity) public view returns (uint){
3281         return _basePrice * quantity;
3282     }
3283 
3284     function setBasePrice(uint price) public onlyOwner {
3285         require(price > 0, "Price should be greater than 0");
3286         
3287         _basePrice = price;
3288     }
3289 
3290     
3291     function setBaseUrl(string memory url) public onlyOwner {
3292         _url = url;
3293     }
3294 
3295     function preSaleMint(uint256 round, uint256 quantity, bytes32[] memory password) external payable {
3296         require(
3297             bytes(_url).length > 0,
3298             "Base url not set"
3299         );
3300 
3301         require(
3302             isPreSaleStart(),
3303             "Pre-sale is not yet started"
3304         );
3305 
3306         require(
3307             ableToJoinPreSale(round, password),
3308             "You are not allow to attend."
3309         );
3310 
3311         require(
3312             quantity > 0,
3313             "Quantity should be larger than 1"
3314         );
3315 
3316         require(
3317             !preSaleSoldOut(round, quantity),
3318             "Sale would exceed max supply"
3319         );
3320 
3321         require(
3322             notExceedOfferQuantity(round, quantity), 
3323             "Pre-sale would exceed offer quantity"
3324         );
3325 
3326         require(
3327             totalOfferPrice(round, quantity) <= msg.value,
3328             "Not enough ether sent"
3329         );
3330 
3331         _usePass(round, msg.sender);
3332 
3333         _attendOffer(round, password);
3334 
3335         _safeMint(msg.sender, quantity);
3336         
3337         uint refund = msg.value - totalOfferPrice(round, quantity);
3338         if(refund > 0){
3339             payable(msg.sender).transfer(refund);
3340         }
3341     }
3342 
3343     function isPreSaleStart() public view returns (bool){
3344         return _saleStatus == PRESALE;
3345     }
3346     
3347     function ableToJoinPreSale(uint256 round, bytes32[] memory password) public view returns (bool) {
3348         Offer memory offer = _preSaleOffers[round];
3349         
3350         if (offer.contractAddress != address(0)){
3351             return _hasPass(offer.contractAddress, msg.sender);
3352         } else {
3353             return _inList(offer.root, msg.sender, password) && !alreadyAttendedOffer(round, password);
3354         }
3355     }
3356 
3357     function alreadyAttendedOffer(uint256 round, bytes32[] memory password) public view returns (bool) {
3358         bytes memory token = _hashPassword(round, password);
3359         return _attendedOffer[token] == true;
3360     }
3361 
3362     function notExceedOfferQuantity(uint256 round, uint256 quantity) public view returns (bool){
3363         Offer memory offer = _preSaleOffers[round];
3364         return quantity <= offer.quantity;
3365     }
3366 
3367     function totalOfferPrice(uint256 round, uint256 quantity) public view returns (uint){
3368         Offer memory offer = _preSaleOffers[round];
3369 
3370         if(offer.isFree == true) return 0;
3371 
3372         return quantity * offer.price;
3373     }
3374 
3375     function totalOfferQuantity(uint256 round) public view returns (uint){
3376         return Math.min(_preSaleOffers[round].quantity, preSaleRepository(round));
3377     }
3378 
3379     function preSaleSoldOut(uint256 round, uint256 quantity) public view returns (bool) {
3380         return quantity > preSaleRepository(round);
3381     }
3382 
3383     function preSaleOffer(uint256 round) public onlyOwner view returns (Offer memory) {
3384         return _preSaleOffers[round];
3385     }
3386 
3387     function setPreSaleOffer(uint256 round, uint price, uint256 quantity, bytes32 root, address contractAddress, bool isFree, uint256 range) public onlyOwner {
3388         if(contractAddress != address(0)){
3389             require(
3390                 contractAddress.isContract() && 
3391                 IERC165(contractAddress).supportsInterface(type(Pass).interfaceId),
3392                 "Contract not implmenented reigstration interface");
3393         }
3394         
3395         _preSaleOffers[round] = Offer(price, quantity, root, contractAddress, isFree, range);
3396     }
3397     
3398     function withdraw(address to) public onlyOwner {
3399         uint256 balance = address(this).balance;
3400         payable(to).transfer(balance);
3401     }
3402     
3403     function _startTokenId() internal view virtual override returns (uint256) {
3404         return 1;
3405     }
3406 
3407     function _baseURI() internal view virtual override returns (string memory) {
3408         return _url;
3409     }
3410 
3411     function _attendOffer(uint256 round, bytes32[] memory password) internal {
3412         Offer memory offer = _preSaleOffers[round];
3413         
3414         if(offer.contractAddress == address(0)){
3415             bytes memory token = _hashPassword(round, password);
3416             _attendedOffer[token] = true;
3417         }
3418     }
3419 
3420     function _usePass(uint256 round, address account) internal {
3421         Offer memory offer = _preSaleOffers[round];
3422 
3423         if(offer.contractAddress != address(0)){
3424             Pass(offer.contractAddress).usePass(account);
3425         }
3426     }
3427 
3428     function _reserve(address to) internal onlyOwner {
3429         if(RESEVRED > 0){
3430             require(
3431                 totalSupply() + RESEVRED <= MAX_SUPPLY,
3432                 "Reservation would exceed max supply"
3433             );
3434 
3435             _safeMint(to, RESEVRED);
3436         }
3437     }
3438 
3439     function _hasPass(address contractAddress, address account) internal view returns (bool) {
3440         return Pass(contractAddress).hasPass(account);
3441     }
3442 
3443     function _inList(bytes32 root, address account, bytes32[] memory password) internal pure returns (bool) {
3444         bytes32 leaf = keccak256(abi.encodePacked(account));
3445 
3446         return MerkleProof.verify(password, root, leaf);
3447     }
3448 
3449     function _hashPassword(uint256 round, bytes32[] memory password) internal pure returns (bytes memory){
3450         bytes memory output = abi.encodePacked(round);
3451 
3452         for (uint i = 0; i < password.length; i++) {
3453             output = abi.encodePacked(output, password[i]);
3454         }
3455 
3456         return output;
3457     }
3458 
3459     function _burn(uint256 tokenId) internal virtual override {
3460         ERC721A._burn(tokenId);
3461         _resetTokenRoyalty(tokenId);
3462     }
3463 }