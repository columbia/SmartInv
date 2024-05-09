1 // SPDX-License-Identifier: MIT
2 
3 // File: erc721a/contracts/IERC721A.sol
4 
5 // ERC721A Contracts v4.2.3
6 // Creator: Chiru Labs
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Interface of ERC721A.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external payable;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external payable;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external payable;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external payable;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // =============================================================
274     //                           IERC2309
275     // =============================================================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
279      * (inclusive) is transferred from `from` to `to`, as defined in the
280      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
281      *
282      * See {_mintERC2309} for more details.
283      */
284     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
285 }
286 
287 // File: erc721a/contracts/ERC721A.sol
288 
289 // ERC721A Contracts v4.2.3
290 // Creator: Chiru Labs
291 
292 pragma solidity ^0.8.4;
293 
294 /**
295  * @dev Interface of ERC721 token receiver.
296  */
297 interface ERC721A__IERC721Receiver {
298     function onERC721Received(
299         address operator,
300         address from,
301         uint256 tokenId,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 /**
307  * @title ERC721A
308  *
309  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
310  * Non-Fungible Token Standard, including the Metadata extension.
311  * Optimized for lower gas during batch mints.
312  *
313  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
314  * starting from `_startTokenId()`.
315  *
316  * Assumptions:
317  *
318  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
319  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
320  */
321 contract ERC721A is IERC721A {
322     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
323     struct TokenApprovalRef {
324         address value;
325     }
326 
327     // =============================================================
328     //                           CONSTANTS
329     // =============================================================
330 
331     // Mask of an entry in packed address data.
332     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
333 
334     // The bit position of `numberMinted` in packed address data.
335     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
336 
337     // The bit position of `numberBurned` in packed address data.
338     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
339 
340     // The bit position of `aux` in packed address data.
341     uint256 private constant _BITPOS_AUX = 192;
342 
343     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
344     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
345 
346     // The bit position of `startTimestamp` in packed ownership.
347     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
348 
349     // The bit mask of the `burned` bit in packed ownership.
350     uint256 private constant _BITMASK_BURNED = 1 << 224;
351 
352     // The bit position of the `nextInitialized` bit in packed ownership.
353     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
354 
355     // The bit mask of the `nextInitialized` bit in packed ownership.
356     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
357 
358     // The bit position of `extraData` in packed ownership.
359     uint256 private constant _BITPOS_EXTRA_DATA = 232;
360 
361     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
362     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
363 
364     // The mask of the lower 160 bits for addresses.
365     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
366 
367     // The maximum `quantity` that can be minted with {_mintERC2309}.
368     // This limit is to prevent overflows on the address data entries.
369     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
370     // is required to cause an overflow, which is unrealistic.
371     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
372 
373     // The `Transfer` event signature is given by:
374     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
375     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
376         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
377 
378     // =============================================================
379     //                            STORAGE
380     // =============================================================
381 
382     // The next token ID to be minted.
383     uint256 private _currentIndex;
384 
385     // The number of tokens burned.
386     uint256 private _burnCounter;
387 
388     // Token name
389     string private _name;
390 
391     // Token symbol
392     string private _symbol;
393 
394     // Mapping from token ID to ownership details
395     // An empty struct value does not necessarily mean the token is unowned.
396     // See {_packedOwnershipOf} implementation for details.
397     //
398     // Bits Layout:
399     // - [0..159]   `addr`
400     // - [160..223] `startTimestamp`
401     // - [224]      `burned`
402     // - [225]      `nextInitialized`
403     // - [232..255] `extraData`
404     mapping(uint256 => uint256) private _packedOwnerships;
405 
406     // Mapping owner address to address data.
407     //
408     // Bits Layout:
409     // - [0..63]    `balance`
410     // - [64..127]  `numberMinted`
411     // - [128..191] `numberBurned`
412     // - [192..255] `aux`
413     mapping(address => uint256) private _packedAddressData;
414 
415     // Mapping from token ID to approved address.
416     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
417 
418     // Mapping from owner to operator approvals
419     mapping(address => mapping(address => bool)) private _operatorApprovals;
420 
421     // =============================================================
422     //                          CONSTRUCTOR
423     // =============================================================
424 
425     constructor(string memory name_, string memory symbol_) {
426         _name = name_;
427         _symbol = symbol_;
428         _currentIndex = _startTokenId();
429     }
430 
431     // =============================================================
432     //                   TOKEN COUNTING OPERATIONS
433     // =============================================================
434 
435     /**
436      * @dev Returns the starting token ID.
437      * To change the starting token ID, please override this function.
438      */
439     function _startTokenId() internal view virtual returns (uint256) {
440         return 0;
441     }
442 
443     /**
444      * @dev Returns the next token ID to be minted.
445      */
446     function _nextTokenId() internal view virtual returns (uint256) {
447         return _currentIndex;
448     }
449 
450     /**
451      * @dev Returns the total number of tokens in existence.
452      * Burned tokens will reduce the count.
453      * To get the total number of tokens minted, please see {_totalMinted}.
454      */
455     function totalSupply() public view virtual override returns (uint256) {
456         // Counter underflow is impossible as _burnCounter cannot be incremented
457         // more than `_currentIndex - _startTokenId()` times.
458         unchecked {
459             return _currentIndex - _burnCounter - _startTokenId();
460         }
461     }
462 
463     /**
464      * @dev Returns the total amount of tokens minted in the contract.
465      */
466     function _totalMinted() internal view virtual returns (uint256) {
467         // Counter underflow is impossible as `_currentIndex` does not decrement,
468         // and it is initialized to `_startTokenId()`.
469         unchecked {
470             return _currentIndex - _startTokenId();
471         }
472     }
473 
474     /**
475      * @dev Returns the total number of tokens burned.
476      */
477     function _totalBurned() internal view virtual returns (uint256) {
478         return _burnCounter;
479     }
480 
481     // =============================================================
482     //                    ADDRESS DATA OPERATIONS
483     // =============================================================
484 
485     /**
486      * @dev Returns the number of tokens in `owner`'s account.
487      */
488     function balanceOf(address owner) public view virtual override returns (uint256) {
489         if (owner == address(0)) revert BalanceQueryForZeroAddress();
490         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the number of tokens minted by `owner`.
495      */
496     function _numberMinted(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     /**
501      * Returns the number of tokens burned by or on behalf of `owner`.
502      */
503     function _numberBurned(address owner) internal view returns (uint256) {
504         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
505     }
506 
507     /**
508      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
509      */
510     function _getAux(address owner) internal view returns (uint64) {
511         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
512     }
513 
514     /**
515      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
516      * If there are multiple variables, please pack them into a uint64.
517      */
518     function _setAux(address owner, uint64 aux) internal virtual {
519         uint256 packed = _packedAddressData[owner];
520         uint256 auxCasted;
521         // Cast `aux` with assembly to avoid redundant masking.
522         assembly {
523             auxCasted := aux
524         }
525         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
526         _packedAddressData[owner] = packed;
527     }
528 
529     // =============================================================
530     //                            IERC165
531     // =============================================================
532 
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         // The interface IDs are constants representing the first 4 bytes
543         // of the XOR of all function selectors in the interface.
544         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
545         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
546         return
547             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
548             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
549             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
550     }
551 
552     // =============================================================
553     //                        IERC721Metadata
554     // =============================================================
555 
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() public view virtual override returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
572      */
573     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
574         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
575 
576         string memory baseURI = _baseURI();
577         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
578     }
579 
580     /**
581      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
582      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
583      * by default, it can be overridden in child contracts.
584      */
585     function _baseURI() internal view virtual returns (string memory) {
586         return '';
587     }
588 
589     // =============================================================
590     //                     OWNERSHIPS OPERATIONS
591     // =============================================================
592 
593     /**
594      * @dev Returns the owner of the `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
601         return address(uint160(_packedOwnershipOf(tokenId)));
602     }
603 
604     /**
605      * @dev Gas spent here starts off proportional to the maximum mint batch size.
606      * It gradually moves to O(1) as tokens get transferred around over time.
607      */
608     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnershipOf(tokenId));
610     }
611 
612     /**
613      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
614      */
615     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
616         return _unpackedOwnership(_packedOwnerships[index]);
617     }
618 
619     /**
620      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
621      */
622     function _initializeOwnershipAt(uint256 index) internal virtual {
623         if (_packedOwnerships[index] == 0) {
624             _packedOwnerships[index] = _packedOwnershipOf(index);
625         }
626     }
627 
628     /**
629      * Returns the packed ownership data of `tokenId`.
630      */
631     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
632         uint256 curr = tokenId;
633 
634         unchecked {
635             if (_startTokenId() <= curr)
636                 if (curr < _currentIndex) {
637                     uint256 packed = _packedOwnerships[curr];
638                     // If not burned.
639                     if (packed & _BITMASK_BURNED == 0) {
640                         // Invariant:
641                         // There will always be an initialized ownership slot
642                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
643                         // before an unintialized ownership slot
644                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
645                         // Hence, `curr` will not underflow.
646                         //
647                         // We can directly compare the packed value.
648                         // If the address is zero, packed will be zero.
649                         while (packed == 0) {
650                             packed = _packedOwnerships[--curr];
651                         }
652                         return packed;
653                     }
654                 }
655         }
656         revert OwnerQueryForNonexistentToken();
657     }
658 
659     /**
660      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
661      */
662     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
663         ownership.addr = address(uint160(packed));
664         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
665         ownership.burned = packed & _BITMASK_BURNED != 0;
666         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
667     }
668 
669     /**
670      * @dev Packs ownership data into a single uint256.
671      */
672     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
673         assembly {
674             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
675             owner := and(owner, _BITMASK_ADDRESS)
676             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
677             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
678         }
679     }
680 
681     /**
682      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
683      */
684     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
685         // For branchless setting of the `nextInitialized` flag.
686         assembly {
687             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
688             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
689         }
690     }
691 
692     // =============================================================
693     //                      APPROVAL OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the
701      * zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) public payable virtual override {
711         address owner = ownerOf(tokenId);
712 
713         if (_msgSenderERC721A() != owner)
714             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
715                 revert ApprovalCallerNotOwnerNorApproved();
716             }
717 
718         _tokenApprovals[tokenId].value = to;
719         emit Approval(owner, to, tokenId);
720     }
721 
722     /**
723      * @dev Returns the account approved for `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function getApproved(uint256 tokenId) public view virtual override returns (address) {
730         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
731 
732         return _tokenApprovals[tokenId].value;
733     }
734 
735     /**
736      * @dev Approve or remove `operator` as an operator for the caller.
737      * Operators can call {transferFrom} or {safeTransferFrom}
738      * for any token owned by the caller.
739      *
740      * Requirements:
741      *
742      * - The `operator` cannot be the caller.
743      *
744      * Emits an {ApprovalForAll} event.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
748         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
749     }
750 
751     /**
752      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
753      *
754      * See {setApprovalForAll}.
755      */
756     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
757         return _operatorApprovals[owner][operator];
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted. See {_mint}.
766      */
767     function _exists(uint256 tokenId) internal view virtual returns (bool) {
768         return
769             _startTokenId() <= tokenId &&
770             tokenId < _currentIndex && // If within bounds,
771             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
772     }
773 
774     /**
775      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
776      */
777     function _isSenderApprovedOrOwner(
778         address approvedAddress,
779         address owner,
780         address msgSender
781     ) private pure returns (bool result) {
782         assembly {
783             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
784             owner := and(owner, _BITMASK_ADDRESS)
785             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             msgSender := and(msgSender, _BITMASK_ADDRESS)
787             // `msgSender == owner || msgSender == approvedAddress`.
788             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
789         }
790     }
791 
792     /**
793      * @dev Returns the storage slot and value for the approved address of `tokenId`.
794      */
795     function _getApprovedSlotAndAddress(uint256 tokenId)
796         private
797         view
798         returns (uint256 approvedAddressSlot, address approvedAddress)
799     {
800         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
801         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
802         assembly {
803             approvedAddressSlot := tokenApproval.slot
804             approvedAddress := sload(approvedAddressSlot)
805         }
806     }
807 
808     // =============================================================
809     //                      TRANSFER OPERATIONS
810     // =============================================================
811 
812     /**
813      * @dev Transfers `tokenId` from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token
821      * by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public payable virtual override {
830         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
831 
832         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
833 
834         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
835 
836         // The nested ifs save around 20+ gas over a compound boolean condition.
837         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
838             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
839 
840         if (to == address(0)) revert TransferToZeroAddress();
841 
842         _beforeTokenTransfers(from, to, tokenId, 1);
843 
844         // Clear approvals from the previous owner.
845         assembly {
846             if approvedAddress {
847                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
848                 sstore(approvedAddressSlot, 0)
849             }
850         }
851 
852         // Underflow of the sender's balance is impossible because we check for
853         // ownership above and the recipient's balance can't realistically overflow.
854         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
855         unchecked {
856             // We can directly increment and decrement the balances.
857             --_packedAddressData[from]; // Updates: `balance -= 1`.
858             ++_packedAddressData[to]; // Updates: `balance += 1`.
859 
860             // Updates:
861             // - `address` to the next owner.
862             // - `startTimestamp` to the timestamp of transfering.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `true`.
865             _packedOwnerships[tokenId] = _packOwnershipData(
866                 to,
867                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
868             );
869 
870             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
871             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
872                 uint256 nextTokenId = tokenId + 1;
873                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
874                 if (_packedOwnerships[nextTokenId] == 0) {
875                     // If the next slot is within bounds.
876                     if (nextTokenId != _currentIndex) {
877                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
878                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
879                     }
880                 }
881             }
882         }
883 
884         emit Transfer(from, to, tokenId);
885         _afterTokenTransfers(from, to, tokenId, 1);
886     }
887 
888     /**
889      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public payable virtual override {
896         safeTransferFrom(from, to, tokenId, '');
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`.
901      *
902      * Requirements:
903      *
904      * - `from` cannot be the zero address.
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must exist and be owned by `from`.
907      * - If the caller is not `from`, it must be approved to move this token
908      * by either {approve} or {setApprovalForAll}.
909      * - If `to` refers to a smart contract, it must implement
910      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) public payable virtual override {
920         transferFrom(from, to, tokenId);
921         if (to.code.length != 0)
922             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
923                 revert TransferToNonERC721ReceiverImplementer();
924             }
925     }
926 
927     /**
928      * @dev Hook that is called before a set of serially-ordered token IDs
929      * are about to be transferred. This includes minting.
930      * And also called before burning one token.
931      *
932      * `startTokenId` - the first token ID to be transferred.
933      * `quantity` - the amount to be transferred.
934      *
935      * Calling conditions:
936      *
937      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
938      * transferred to `to`.
939      * - When `from` is zero, `tokenId` will be minted for `to`.
940      * - When `to` is zero, `tokenId` will be burned by `from`.
941      * - `from` and `to` are never both zero.
942      */
943     function _beforeTokenTransfers(
944         address from,
945         address to,
946         uint256 startTokenId,
947         uint256 quantity
948     ) internal virtual {}
949 
950     /**
951      * @dev Hook that is called after a set of serially-ordered token IDs
952      * have been transferred. This includes minting.
953      * And also called after one token has been burned.
954      *
955      * `startTokenId` - the first token ID to be transferred.
956      * `quantity` - the amount to be transferred.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` has been minted for `to`.
963      * - When `to` is zero, `tokenId` has been burned by `from`.
964      * - `from` and `to` are never both zero.
965      */
966     function _afterTokenTransfers(
967         address from,
968         address to,
969         uint256 startTokenId,
970         uint256 quantity
971     ) internal virtual {}
972 
973     /**
974      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
975      *
976      * `from` - Previous owner of the given token ID.
977      * `to` - Target address that will receive the token.
978      * `tokenId` - Token ID to be transferred.
979      * `_data` - Optional data to send along with the call.
980      *
981      * Returns whether the call correctly returned the expected magic value.
982      */
983     function _checkContractOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
990             bytes4 retval
991         ) {
992             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
993         } catch (bytes memory reason) {
994             if (reason.length == 0) {
995                 revert TransferToNonERC721ReceiverImplementer();
996             } else {
997                 assembly {
998                     revert(add(32, reason), mload(reason))
999                 }
1000             }
1001         }
1002     }
1003 
1004     // =============================================================
1005     //                        MINT OPERATIONS
1006     // =============================================================
1007 
1008     /**
1009      * @dev Mints `quantity` tokens and transfers them to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event for each mint.
1017      */
1018     function _mint(address to, uint256 quantity) internal virtual {
1019         uint256 startTokenId = _currentIndex;
1020         if (quantity == 0) revert MintZeroQuantity();
1021 
1022         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1023 
1024         // Overflows are incredibly unrealistic.
1025         // `balance` and `numberMinted` have a maximum limit of 2**64.
1026         // `tokenId` has a maximum limit of 2**256.
1027         unchecked {
1028             // Updates:
1029             // - `balance += quantity`.
1030             // - `numberMinted += quantity`.
1031             //
1032             // We can directly add to the `balance` and `numberMinted`.
1033             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1034 
1035             // Updates:
1036             // - `address` to the owner.
1037             // - `startTimestamp` to the timestamp of minting.
1038             // - `burned` to `false`.
1039             // - `nextInitialized` to `quantity == 1`.
1040             _packedOwnerships[startTokenId] = _packOwnershipData(
1041                 to,
1042                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1043             );
1044 
1045             uint256 toMasked;
1046             uint256 end = startTokenId + quantity;
1047 
1048             // Use assembly to loop and emit the `Transfer` event for gas savings.
1049             // The duplicated `log4` removes an extra check and reduces stack juggling.
1050             // The assembly, together with the surrounding Solidity code, have been
1051             // delicately arranged to nudge the compiler into producing optimized opcodes.
1052             assembly {
1053                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1054                 toMasked := and(to, _BITMASK_ADDRESS)
1055                 // Emit the `Transfer` event.
1056                 log4(
1057                     0, // Start of data (0, since no data).
1058                     0, // End of data (0, since no data).
1059                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1060                     0, // `address(0)`.
1061                     toMasked, // `to`.
1062                     startTokenId // `tokenId`.
1063                 )
1064 
1065                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1066                 // that overflows uint256 will make the loop run out of gas.
1067                 // The compiler will optimize the `iszero` away for performance.
1068                 for {
1069                     let tokenId := add(startTokenId, 1)
1070                 } iszero(eq(tokenId, end)) {
1071                     tokenId := add(tokenId, 1)
1072                 } {
1073                     // Emit the `Transfer` event. Similar to above.
1074                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1075                 }
1076             }
1077             if (toMasked == 0) revert MintToZeroAddress();
1078 
1079             _currentIndex = end;
1080         }
1081         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * This function is intended for efficient minting only during contract creation.
1088      *
1089      * It emits only one {ConsecutiveTransfer} as defined in
1090      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1091      * instead of a sequence of {Transfer} event(s).
1092      *
1093      * Calling this function outside of contract creation WILL make your contract
1094      * non-compliant with the ERC721 standard.
1095      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1096      * {ConsecutiveTransfer} event is only permissible during contract creation.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {ConsecutiveTransfer} event.
1104      */
1105     function _mintERC2309(address to, uint256 quantity) internal virtual {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the `balance` and `numberMinted`.
1120             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] = _packOwnershipData(
1128                 to,
1129                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1130             );
1131 
1132             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1133 
1134             _currentIndex = startTokenId + quantity;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - If `to` refers to a smart contract, it must implement
1145      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * See {_mint}.
1149      *
1150      * Emits a {Transfer} event for each mint.
1151      */
1152     function _safeMint(
1153         address to,
1154         uint256 quantity,
1155         bytes memory _data
1156     ) internal virtual {
1157         _mint(to, quantity);
1158 
1159         unchecked {
1160             if (to.code.length != 0) {
1161                 uint256 end = _currentIndex;
1162                 uint256 index = end - quantity;
1163                 do {
1164                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1165                         revert TransferToNonERC721ReceiverImplementer();
1166                     }
1167                 } while (index < end);
1168                 // Reentrancy protection.
1169                 if (_currentIndex != end) revert();
1170             }
1171         }
1172     }
1173 
1174     /**
1175      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1176      */
1177     function _safeMint(address to, uint256 quantity) internal virtual {
1178         _safeMint(to, quantity, '');
1179     }
1180 
1181     // =============================================================
1182     //                        BURN OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Equivalent to `_burn(tokenId, false)`.
1187      */
1188     function _burn(uint256 tokenId) internal virtual {
1189         _burn(tokenId, false);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1203         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1204 
1205         address from = address(uint160(prevOwnershipPacked));
1206 
1207         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1208 
1209         if (approvalCheck) {
1210             // The nested ifs save around 20+ gas over a compound boolean condition.
1211             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1212                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1213         }
1214 
1215         _beforeTokenTransfers(from, address(0), tokenId, 1);
1216 
1217         // Clear approvals from the previous owner.
1218         assembly {
1219             if approvedAddress {
1220                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1221                 sstore(approvedAddressSlot, 0)
1222             }
1223         }
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1228         unchecked {
1229             // Updates:
1230             // - `balance -= 1`.
1231             // - `numberBurned += 1`.
1232             //
1233             // We can directly decrement the balance, and increment the number burned.
1234             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1235             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1236 
1237             // Updates:
1238             // - `address` to the last owner.
1239             // - `startTimestamp` to the timestamp of burning.
1240             // - `burned` to `true`.
1241             // - `nextInitialized` to `true`.
1242             _packedOwnerships[tokenId] = _packOwnershipData(
1243                 from,
1244                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1245             );
1246 
1247             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1248             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1249                 uint256 nextTokenId = tokenId + 1;
1250                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1251                 if (_packedOwnerships[nextTokenId] == 0) {
1252                     // If the next slot is within bounds.
1253                     if (nextTokenId != _currentIndex) {
1254                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1255                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1256                     }
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, address(0), tokenId);
1262         _afterTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     // =============================================================
1271     //                     EXTRA DATA OPERATIONS
1272     // =============================================================
1273 
1274     /**
1275      * @dev Directly sets the extra data for the ownership data `index`.
1276      */
1277     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1278         uint256 packed = _packedOwnerships[index];
1279         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1280         uint256 extraDataCasted;
1281         // Cast `extraData` with assembly to avoid redundant masking.
1282         assembly {
1283             extraDataCasted := extraData
1284         }
1285         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1286         _packedOwnerships[index] = packed;
1287     }
1288 
1289     /**
1290      * @dev Called during each token transfer to set the 24bit `extraData` field.
1291      * Intended to be overridden by the cosumer contract.
1292      *
1293      * `previousExtraData` - the value of `extraData` before transfer.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _extraData(
1304         address from,
1305         address to,
1306         uint24 previousExtraData
1307     ) internal view virtual returns (uint24) {}
1308 
1309     /**
1310      * @dev Returns the next extra data for the packed ownership data.
1311      * The returned result is shifted into position.
1312      */
1313     function _nextExtraData(
1314         address from,
1315         address to,
1316         uint256 prevOwnershipPacked
1317     ) private view returns (uint256) {
1318         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1319         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1320     }
1321 
1322     // =============================================================
1323     //                       OTHER OPERATIONS
1324     // =============================================================
1325 
1326     /**
1327      * @dev Returns the message sender (defaults to `msg.sender`).
1328      *
1329      * If you are writing GSN compatible contracts, you need to override this function.
1330      */
1331     function _msgSenderERC721A() internal view virtual returns (address) {
1332         return msg.sender;
1333     }
1334 
1335     /**
1336      * @dev Converts a uint256 to its ASCII string decimal representation.
1337      */
1338     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1339         assembly {
1340             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1341             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1342             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1343             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1344             let m := add(mload(0x40), 0xa0)
1345             // Update the free memory pointer to allocate.
1346             mstore(0x40, m)
1347             // Assign the `str` to the end.
1348             str := sub(m, 0x20)
1349             // Zeroize the slot after the string.
1350             mstore(str, 0)
1351 
1352             // Cache the end of the memory to calculate the length later.
1353             let end := str
1354 
1355             // We write the string from rightmost digit to leftmost digit.
1356             // The following is essentially a do-while loop that also handles the zero case.
1357             // prettier-ignore
1358             for { let temp := value } 1 {} {
1359                 str := sub(str, 1)
1360                 // Write the character to the pointer.
1361                 // The ASCII index of the '0' character is 48.
1362                 mstore8(str, add(48, mod(temp, 10)))
1363                 // Keep dividing `temp` until zero.
1364                 temp := div(temp, 10)
1365                 // prettier-ignore
1366                 if iszero(temp) { break }
1367             }
1368 
1369             let length := sub(end, str)
1370             // Move the pointer 32 bytes leftwards to make room for the length.
1371             str := sub(str, 0x20)
1372             // Store the length.
1373             mstore(str, length)
1374         }
1375     }
1376 }
1377 
1378 // File: @openzeppelin/contracts/utils/Context.sol
1379 
1380 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 /**
1385  * @dev Provides information about the current execution context, including the
1386  * sender of the transaction and its data. While these are generally available
1387  * via msg.sender and msg.data, they should not be accessed in such a direct
1388  * manner, since when dealing with meta-transactions the account sending and
1389  * paying for execution may not be the actual sender (as far as an application
1390  * is concerned).
1391  *
1392  * This contract is only required for intermediate, library-like contracts.
1393  */
1394 abstract contract Context {
1395     function _msgSender() internal view virtual returns (address) {
1396         return msg.sender;
1397     }
1398 
1399     function _msgData() internal view virtual returns (bytes calldata) {
1400         return msg.data;
1401     }
1402 }
1403 
1404 // File: @openzeppelin/contracts/access/Ownable.sol
1405 
1406 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 /**
1411  * @dev Contract module which provides a basic access control mechanism, where
1412  * there is an account (an owner) that can be granted exclusive access to
1413  * specific functions.
1414  *
1415  * By default, the owner account will be the one that deploys the contract. This
1416  * can later be changed with {transferOwnership}.
1417  *
1418  * This module is used through inheritance. It will make available the modifier
1419  * `onlyOwner`, which can be applied to your functions to restrict their use to
1420  * the owner.
1421  */
1422 abstract contract Ownable is Context {
1423     address private _owner;
1424 
1425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1426 
1427     /**
1428      * @dev Initializes the contract setting the deployer as the initial owner.
1429      */
1430     constructor() {
1431         _transferOwnership(_msgSender());
1432     }
1433 
1434     /**
1435      * @dev Throws if called by any account other than the owner.
1436      */
1437     modifier onlyOwner() {
1438         _checkOwner();
1439         _;
1440     }
1441 
1442     /**
1443      * @dev Returns the address of the current owner.
1444      */
1445     function owner() public view virtual returns (address) {
1446         return _owner;
1447     }
1448 
1449     /**
1450      * @dev Throws if the sender is not the owner.
1451      */
1452     function _checkOwner() internal view virtual {
1453         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1454     }
1455 
1456     /**
1457      * @dev Leaves the contract without owner. It will not be possible to call
1458      * `onlyOwner` functions anymore. Can only be called by the current owner.
1459      *
1460      * NOTE: Renouncing ownership will leave the contract without an owner,
1461      * thereby removing any functionality that is only available to the owner.
1462      */
1463     function renounceOwnership() public virtual onlyOwner {
1464         _transferOwnership(address(0));
1465     }
1466 
1467     /**
1468      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1469      * Can only be called by the current owner.
1470      */
1471     function transferOwnership(address newOwner) public virtual onlyOwner {
1472         require(newOwner != address(0), "Ownable: new owner is the zero address");
1473         _transferOwnership(newOwner);
1474     }
1475 
1476     /**
1477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1478      * Internal function without access restriction.
1479      */
1480     function _transferOwnership(address newOwner) internal virtual {
1481         address oldOwner = _owner;
1482         _owner = newOwner;
1483         emit OwnershipTransferred(oldOwner, newOwner);
1484     }
1485 }
1486 
1487 // File: contract/CrazyRichYellows.sol
1488 
1489 pragma solidity ^0.8.4;
1490 
1491 
1492 contract CrazyRichYellows is ERC721A, Ownable {
1493 
1494     string private _baseTokenURI;
1495 
1496     constructor() ERC721A("CrazyRichYellows", "CRY") {
1497         _baseTokenURI = "ipfs://QmYCczt4PsA2vQ2JYwgaDXWEqgidYEtgYSoqnJPyJyCA7k/";
1498     }
1499 
1500     function _startTokenId() internal view virtual override returns (uint256) {
1501         return 1;
1502     }
1503 
1504     struct MintDatum {
1505         address to;
1506         uint256 quantity;
1507     }
1508 
1509     function bulkMint(MintDatum[] calldata mintData) external onlyOwner {
1510 
1511         for(uint i = 0; i < mintData.length; i++) {
1512             _mint(mintData[i].to, mintData[i].quantity);
1513         }
1514     }
1515 
1516     function setBaseURI(string memory baseURI) public onlyOwner {
1517         _baseTokenURI = baseURI;
1518     }
1519 
1520     function _baseURI() view internal virtual override returns (string memory) {
1521         return _baseTokenURI;
1522     }
1523 
1524     function contractURI() public pure returns (string memory) 
1525     {
1526         return "ipfs://QmXoiTwZpugfjFq8BZJwKJrWp83t8NszYqVaJcpzaucDE1";
1527     }
1528 }