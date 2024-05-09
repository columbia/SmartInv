1 // 
2 //  ######   ##       #### ########  ######  ##     ##    ########     ###    ########  ##    ## 
3 // ##    ##  ##        ##     ##    ##    ## ##     ##    ##     ##   ## ##   ##     ##  ##  ##  
4 // ##        ##        ##     ##    ##       ##     ##    ##     ##  ##   ##  ##     ##   ####   
5 // ##   #### ##        ##     ##    ##       #########    ########  ##     ## ########     ##    
6 // ##    ##  ##        ##     ##    ##       ##     ##    ##     ## ######### ##     ##    ##    
7 // ##    ##  ##        ##     ##    ##    ## ##     ##    ##     ## ##     ## ##     ##    ##    
8 //  ######   ######## ####    ##     ######  ##     ##    ########  ##     ## ########     ##    
9 // Nextgen baby glitched.
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 // File: erc721a/contracts/IERC721A.sol
15 
16 
17 // ERC721A Contracts v4.2.0
18 // Creator: Chiru Labs
19 
20 pragma solidity ^0.8.4;
21 
22 /**
23  * @dev Interface of ERC721A.
24  */
25 interface IERC721A {
26     /**
27      * The caller must own the token or be an approved operator.
28      */
29     error ApprovalCallerNotOwnerNorApproved();
30 
31     /**
32      * The token does not exist.
33      */
34     error ApprovalQueryForNonexistentToken();
35 
36     /**
37      * The caller cannot approve to their own address.
38      */
39     error ApproveToCaller();
40 
41     /**
42      * Cannot query the balance for the zero address.
43      */
44     error BalanceQueryForZeroAddress();
45 
46     /**
47      * Cannot mint to the zero address.
48      */
49     error MintToZeroAddress();
50 
51     /**
52      * The quantity of tokens minted must be more than zero.
53      */
54     error MintZeroQuantity();
55 
56     /**
57      * The token does not exist.
58      */
59     error OwnerQueryForNonexistentToken();
60 
61     /**
62      * The caller must own the token or be an approved operator.
63      */
64     error TransferCallerNotOwnerNorApproved();
65 
66     /**
67      * The token must be owned by `from`.
68      */
69     error TransferFromIncorrectOwner();
70 
71     /**
72      * Cannot safely transfer to a contract that does not implement the
73      * ERC721Receiver interface.
74      */
75     error TransferToNonERC721ReceiverImplementer();
76 
77     /**
78      * Cannot transfer to the zero address.
79      */
80     error TransferToZeroAddress();
81 
82     /**
83      * The token does not exist.
84      */
85     error URIQueryForNonexistentToken();
86 
87     /**
88      * The `quantity` minted with ERC2309 exceeds the safety limit.
89      */
90     error MintERC2309QuantityExceedsLimit();
91 
92     /**
93      * The `extraData` cannot be set on an unintialized ownership slot.
94      */
95     error OwnershipNotInitializedForExtraData();
96 
97     // =============================================================
98     //                            STRUCTS
99     // =============================================================
100 
101     struct TokenOwnership {
102         // The address of the owner.
103         address addr;
104         // Stores the start time of ownership with minimal overhead for tokenomics.
105         uint64 startTimestamp;
106         // Whether the token has been burned.
107         bool burned;
108         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
109         uint24 extraData;
110     }
111 
112     // =============================================================
113     //                         TOKEN COUNTERS
114     // =============================================================
115 
116     /**
117      * @dev Returns the total number of tokens in existence.
118      * Burned tokens will reduce the count.
119      * To get the total number of tokens minted, please see {_totalMinted}.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     // =============================================================
124     //                            IERC165
125     // =============================================================
126 
127     /**
128      * @dev Returns true if this contract implements the interface defined by
129      * `interfaceId`. See the corresponding
130      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
131      * to learn more about how these ids are created.
132      *
133      * This function call must use less than 30000 gas.
134      */
135     function supportsInterface(bytes4 interfaceId) external view returns (bool);
136 
137     // =============================================================
138     //                            IERC721
139     // =============================================================
140 
141     /**
142      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables or disables
153      * (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
156 
157     /**
158      * @dev Returns the number of tokens in `owner`'s account.
159      */
160     function balanceOf(address owner) external view returns (uint256 balance);
161 
162     /**
163      * @dev Returns the owner of the `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`,
173      * checking first that contract recipients are aware of the ERC721 protocol
174      * to prevent tokens from being forever locked.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must exist and be owned by `from`.
181      * - If the caller is not `from`, it must be have been allowed to move
182      * this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement
184      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185      *
186      * Emits a {Transfer} event.
187      */
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId,
192         bytes calldata data
193     ) external;
194 
195     /**
196      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     /**
205      * @dev Transfers `tokenId` from `from` to `to`.
206      *
207      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
208      * whenever possible.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must be owned by `from`.
215      * - If the caller is not `from`, it must be approved to move this token
216      * by either {approve} or {setApprovalForAll}.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     /**
227      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
228      * The approval is cleared when the token is transferred.
229      *
230      * Only a single account can be approved at a time, so approving the
231      * zero address clears previous approvals.
232      *
233      * Requirements:
234      *
235      * - The caller must own the token or be an approved operator.
236      * - `tokenId` must exist.
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Approve or remove `operator` as an operator for the caller.
244      * Operators can call {transferFrom} or {safeTransferFrom}
245      * for any token owned by the caller.
246      *
247      * Requirements:
248      *
249      * - The `operator` cannot be the caller.
250      *
251      * Emits an {ApprovalForAll} event.
252      */
253     function setApprovalForAll(address operator, bool _approved) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId) external view returns (address operator);
263 
264     /**
265      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
266      *
267      * See {setApprovalForAll}.
268      */
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270 
271     // =============================================================
272     //                        IERC721Metadata
273     // =============================================================
274 
275     /**
276      * @dev Returns the token collection name.
277      */
278     function name() external view returns (string memory);
279 
280     /**
281      * @dev Returns the token collection symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
287      */
288     function tokenURI(uint256 tokenId) external view returns (string memory);
289 
290     // =============================================================
291     //                           IERC2309
292     // =============================================================
293 
294     /**
295      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
296      * (inclusive) is transferred from `from` to `to`, as defined in the
297      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
298      *
299      * See {_mintERC2309} for more details.
300      */
301     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
302 }
303 
304 // File: erc721a/contracts/ERC721A.sol
305 
306 
307 // ERC721A Contracts v4.2.0
308 // Creator: Chiru Labs
309 
310 pragma solidity ^0.8.4;
311 
312 
313 /**
314  * @dev Interface of ERC721 token receiver.
315  */
316 interface ERC721A__IERC721Receiver {
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 /**
326  * @title ERC721A
327  *
328  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
329  * Non-Fungible Token Standard, including the Metadata extension.
330  * Optimized for lower gas during batch mints.
331  *
332  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
333  * starting from `_startTokenId()`.
334  *
335  * Assumptions:
336  *
337  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
338  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
339  */
340 contract ERC721A is IERC721A {
341     // Reference type for token approval.
342     struct TokenApprovalRef {
343         address value;
344     }
345 
346     // =============================================================
347     //                           CONSTANTS
348     // =============================================================
349 
350     // Mask of an entry in packed address data.
351     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
352 
353     // The bit position of `numberMinted` in packed address data.
354     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
355 
356     // The bit position of `numberBurned` in packed address data.
357     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
358 
359     // The bit position of `aux` in packed address data.
360     uint256 private constant _BITPOS_AUX = 192;
361 
362     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
363     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
364 
365     // The bit position of `startTimestamp` in packed ownership.
366     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
367 
368     // The bit mask of the `burned` bit in packed ownership.
369     uint256 private constant _BITMASK_BURNED = 1 << 224;
370 
371     // The bit position of the `nextInitialized` bit in packed ownership.
372     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
373 
374     // The bit mask of the `nextInitialized` bit in packed ownership.
375     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
376 
377     // The bit position of `extraData` in packed ownership.
378     uint256 private constant _BITPOS_EXTRA_DATA = 232;
379 
380     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
381     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
382 
383     // The mask of the lower 160 bits for addresses.
384     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
385 
386     // The maximum `quantity` that can be minted with {_mintERC2309}.
387     // This limit is to prevent overflows on the address data entries.
388     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
389     // is required to cause an overflow, which is unrealistic.
390     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
391 
392     // The `Transfer` event signature is given by:
393     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
394     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
395         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
396 
397     // =============================================================
398     //                            STORAGE
399     // =============================================================
400 
401     // The next token ID to be minted.
402     uint256 private _currentIndex;
403 
404     // The number of tokens burned.
405     uint256 private _burnCounter;
406 
407     // Token name
408     string private _name;
409 
410     // Token symbol
411     string private _symbol;
412 
413     // Mapping from token ID to ownership details
414     // An empty struct value does not necessarily mean the token is unowned.
415     // See {_packedOwnershipOf} implementation for details.
416     //
417     // Bits Layout:
418     // - [0..159]   `addr`
419     // - [160..223] `startTimestamp`
420     // - [224]      `burned`
421     // - [225]      `nextInitialized`
422     // - [232..255] `extraData`
423     mapping(uint256 => uint256) private _packedOwnerships;
424 
425     // Mapping owner address to address data.
426     //
427     // Bits Layout:
428     // - [0..63]    `balance`
429     // - [64..127]  `numberMinted`
430     // - [128..191] `numberBurned`
431     // - [192..255] `aux`
432     mapping(address => uint256) private _packedAddressData;
433 
434     // Mapping from token ID to approved address.
435     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
436 
437     // Mapping from owner to operator approvals
438     mapping(address => mapping(address => bool)) private _operatorApprovals;
439 
440     // =============================================================
441     //                          CONSTRUCTOR
442     // =============================================================
443 
444     constructor(string memory name_, string memory symbol_) {
445         _name = name_;
446         _symbol = symbol_;
447         _currentIndex = _startTokenId();
448     }
449 
450     // =============================================================
451     //                   TOKEN COUNTING OPERATIONS
452     // =============================================================
453 
454     /**
455      * @dev Returns the starting token ID.
456      * To change the starting token ID, please override this function.
457      */
458     function _startTokenId() internal view virtual returns (uint256) {
459         return 0;
460     }
461 
462     /**
463      * @dev Returns the next token ID to be minted.
464      */
465     function _nextTokenId() internal view virtual returns (uint256) {
466         return _currentIndex;
467     }
468 
469     /**
470      * @dev Returns the total number of tokens in existence.
471      * Burned tokens will reduce the count.
472      * To get the total number of tokens minted, please see {_totalMinted}.
473      */
474     function totalSupply() public view virtual override returns (uint256) {
475         // Counter underflow is impossible as _burnCounter cannot be incremented
476         // more than `_currentIndex - _startTokenId()` times.
477         unchecked {
478             return _currentIndex - _burnCounter - _startTokenId();
479         }
480     }
481 
482     /**
483      * @dev Returns the total amount of tokens minted in the contract.
484      */
485     function _totalMinted() internal view virtual returns (uint256) {
486         // Counter underflow is impossible as `_currentIndex` does not decrement,
487         // and it is initialized to `_startTokenId()`.
488         unchecked {
489             return _currentIndex - _startTokenId();
490         }
491     }
492 
493     /**
494      * @dev Returns the total number of tokens burned.
495      */
496     function _totalBurned() internal view virtual returns (uint256) {
497         return _burnCounter;
498     }
499 
500     // =============================================================
501     //                    ADDRESS DATA OPERATIONS
502     // =============================================================
503 
504     /**
505      * @dev Returns the number of tokens in `owner`'s account.
506      */
507     function balanceOf(address owner) public view virtual override returns (uint256) {
508         if (owner == address(0)) revert BalanceQueryForZeroAddress();
509         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the number of tokens minted by `owner`.
514      */
515     function _numberMinted(address owner) internal view returns (uint256) {
516         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the number of tokens burned by or on behalf of `owner`.
521      */
522     function _numberBurned(address owner) internal view returns (uint256) {
523         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
524     }
525 
526     /**
527      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
528      */
529     function _getAux(address owner) internal view returns (uint64) {
530         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
531     }
532 
533     /**
534      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
535      * If there are multiple variables, please pack them into a uint64.
536      */
537     function _setAux(address owner, uint64 aux) internal virtual {
538         uint256 packed = _packedAddressData[owner];
539         uint256 auxCasted;
540         // Cast `aux` with assembly to avoid redundant masking.
541         assembly {
542             auxCasted := aux
543         }
544         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
545         _packedAddressData[owner] = packed;
546     }
547 
548     // =============================================================
549     //                            IERC165
550     // =============================================================
551 
552     /**
553      * @dev Returns true if this contract implements the interface defined by
554      * `interfaceId`. See the corresponding
555      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
556      * to learn more about how these ids are created.
557      *
558      * This function call must use less than 30000 gas.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         // The interface IDs are constants representing the first 4 bytes
562         // of the XOR of all function selectors in the interface.
563         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
564         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
565         return
566             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
567             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
568             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
569     }
570 
571     // =============================================================
572     //                        IERC721Metadata
573     // =============================================================
574 
575     /**
576      * @dev Returns the token collection name.
577      */
578     function name() public view virtual override returns (string memory) {
579         return _name;
580     }
581 
582     /**
583      * @dev Returns the token collection symbol.
584      */
585     function symbol() public view virtual override returns (string memory) {
586         return _symbol;
587     }
588 
589     /**
590      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
591      */
592     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
593         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
594 
595         string memory baseURI = _baseURI();
596         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
597     }
598 
599     /**
600      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
601      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
602      * by default, it can be overridden in child contracts.
603      */
604     function _baseURI() internal view virtual returns (string memory) {
605         return '';
606     }
607 
608     // =============================================================
609     //                     OWNERSHIPS OPERATIONS
610     // =============================================================
611 
612     /**
613      * @dev Returns the owner of the `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
620         return address(uint160(_packedOwnershipOf(tokenId)));
621     }
622 
623     /**
624      * @dev Gas spent here starts off proportional to the maximum mint batch size.
625      * It gradually moves to O(1) as tokens get transferred around over time.
626      */
627     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
628         return _unpackedOwnership(_packedOwnershipOf(tokenId));
629     }
630 
631     /**
632      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
633      */
634     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
635         return _unpackedOwnership(_packedOwnerships[index]);
636     }
637 
638     /**
639      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
640      */
641     function _initializeOwnershipAt(uint256 index) internal virtual {
642         if (_packedOwnerships[index] == 0) {
643             _packedOwnerships[index] = _packedOwnershipOf(index);
644         }
645     }
646 
647     /**
648      * Returns the packed ownership data of `tokenId`.
649      */
650     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
651         uint256 curr = tokenId;
652 
653         unchecked {
654             if (_startTokenId() <= curr)
655                 if (curr < _currentIndex) {
656                     uint256 packed = _packedOwnerships[curr];
657                     // If not burned.
658                     if (packed & _BITMASK_BURNED == 0) {
659                         // Invariant:
660                         // There will always be an initialized ownership slot
661                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
662                         // before an unintialized ownership slot
663                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
664                         // Hence, `curr` will not underflow.
665                         //
666                         // We can directly compare the packed value.
667                         // If the address is zero, packed will be zero.
668                         while (packed == 0) {
669                             packed = _packedOwnerships[--curr];
670                         }
671                         return packed;
672                     }
673                 }
674         }
675         revert OwnerQueryForNonexistentToken();
676     }
677 
678     /**
679      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
680      */
681     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
682         ownership.addr = address(uint160(packed));
683         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
684         ownership.burned = packed & _BITMASK_BURNED != 0;
685         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
686     }
687 
688     /**
689      * @dev Packs ownership data into a single uint256.
690      */
691     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
692         assembly {
693             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
694             owner := and(owner, _BITMASK_ADDRESS)
695             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
696             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
697         }
698     }
699 
700     /**
701      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
702      */
703     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
704         // For branchless setting of the `nextInitialized` flag.
705         assembly {
706             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
707             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
708         }
709     }
710 
711     // =============================================================
712     //                      APPROVAL OPERATIONS
713     // =============================================================
714 
715     /**
716      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
717      * The approval is cleared when the token is transferred.
718      *
719      * Only a single account can be approved at a time, so approving the
720      * zero address clears previous approvals.
721      *
722      * Requirements:
723      *
724      * - The caller must own the token or be an approved operator.
725      * - `tokenId` must exist.
726      *
727      * Emits an {Approval} event.
728      */
729     function approve(address to, uint256 tokenId) public virtual override {
730         address owner = ownerOf(tokenId);
731 
732         if (_msgSenderERC721A() != owner)
733             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
734                 revert ApprovalCallerNotOwnerNorApproved();
735             }
736 
737         _tokenApprovals[tokenId].value = to;
738         emit Approval(owner, to, tokenId);
739     }
740 
741     /**
742      * @dev Returns the account approved for `tokenId` token.
743      *
744      * Requirements:
745      *
746      * - `tokenId` must exist.
747      */
748     function getApproved(uint256 tokenId) public view virtual override returns (address) {
749         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
750 
751         return _tokenApprovals[tokenId].value;
752     }
753 
754     /**
755      * @dev Approve or remove `operator` as an operator for the caller.
756      * Operators can call {transferFrom} or {safeTransferFrom}
757      * for any token owned by the caller.
758      *
759      * Requirements:
760      *
761      * - The `operator` cannot be the caller.
762      *
763      * Emits an {ApprovalForAll} event.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
767 
768         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
769         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
770     }
771 
772     /**
773      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
774      *
775      * See {setApprovalForAll}.
776      */
777     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
778         return _operatorApprovals[owner][operator];
779     }
780 
781     /**
782      * @dev Returns whether `tokenId` exists.
783      *
784      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
785      *
786      * Tokens start existing when they are minted. See {_mint}.
787      */
788     function _exists(uint256 tokenId) internal view virtual returns (bool) {
789         return
790             _startTokenId() <= tokenId &&
791             tokenId < _currentIndex && // If within bounds,
792             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
793     }
794 
795     /**
796      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
797      */
798     function _isSenderApprovedOrOwner(
799         address approvedAddress,
800         address owner,
801         address msgSender
802     ) private pure returns (bool result) {
803         assembly {
804             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
805             owner := and(owner, _BITMASK_ADDRESS)
806             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
807             msgSender := and(msgSender, _BITMASK_ADDRESS)
808             // `msgSender == owner || msgSender == approvedAddress`.
809             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
810         }
811     }
812 
813     /**
814      * @dev Returns the storage slot and value for the approved address of `tokenId`.
815      */
816     function _getApprovedSlotAndAddress(uint256 tokenId)
817         private
818         view
819         returns (uint256 approvedAddressSlot, address approvedAddress)
820     {
821         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
822         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
823         assembly {
824             approvedAddressSlot := tokenApproval.slot
825             approvedAddress := sload(approvedAddressSlot)
826         }
827     }
828 
829     // =============================================================
830     //                      TRANSFER OPERATIONS
831     // =============================================================
832 
833     /**
834      * @dev Transfers `tokenId` from `from` to `to`.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must be owned by `from`.
841      * - If the caller is not `from`, it must be approved to move this token
842      * by either {approve} or {setApprovalForAll}.
843      *
844      * Emits a {Transfer} event.
845      */
846     function transferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public virtual override {
851         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
852 
853         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
854 
855         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
856 
857         // The nested ifs save around 20+ gas over a compound boolean condition.
858         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
859             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
860 
861         if (to == address(0)) revert TransferToZeroAddress();
862 
863         _beforeTokenTransfers(from, to, tokenId, 1);
864 
865         // Clear approvals from the previous owner.
866         assembly {
867             if approvedAddress {
868                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
869                 sstore(approvedAddressSlot, 0)
870             }
871         }
872 
873         // Underflow of the sender's balance is impossible because we check for
874         // ownership above and the recipient's balance can't realistically overflow.
875         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
876         unchecked {
877             // We can directly increment and decrement the balances.
878             --_packedAddressData[from]; // Updates: `balance -= 1`.
879             ++_packedAddressData[to]; // Updates: `balance += 1`.
880 
881             // Updates:
882             // - `address` to the next owner.
883             // - `startTimestamp` to the timestamp of transfering.
884             // - `burned` to `false`.
885             // - `nextInitialized` to `true`.
886             _packedOwnerships[tokenId] = _packOwnershipData(
887                 to,
888                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
889             );
890 
891             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
892             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
893                 uint256 nextTokenId = tokenId + 1;
894                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
895                 if (_packedOwnerships[nextTokenId] == 0) {
896                     // If the next slot is within bounds.
897                     if (nextTokenId != _currentIndex) {
898                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
899                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
900                     }
901                 }
902             }
903         }
904 
905         emit Transfer(from, to, tokenId);
906         _afterTokenTransfers(from, to, tokenId, 1);
907     }
908 
909     /**
910      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) public virtual override {
917         safeTransferFrom(from, to, tokenId, '');
918     }
919 
920     /**
921      * @dev Safely transfers `tokenId` token from `from` to `to`.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must exist and be owned by `from`.
928      * - If the caller is not `from`, it must be approved to move this token
929      * by either {approve} or {setApprovalForAll}.
930      * - If `to` refers to a smart contract, it must implement
931      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public virtual override {
941         transferFrom(from, to, tokenId);
942         if (to.code.length != 0)
943             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
944                 revert TransferToNonERC721ReceiverImplementer();
945             }
946     }
947 
948     /**
949      * @dev Hook that is called before a set of serially-ordered token IDs
950      * are about to be transferred. This includes minting.
951      * And also called before burning one token.
952      *
953      * `startTokenId` - the first token ID to be transferred.
954      * `quantity` - the amount to be transferred.
955      *
956      * Calling conditions:
957      *
958      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
959      * transferred to `to`.
960      * - When `from` is zero, `tokenId` will be minted for `to`.
961      * - When `to` is zero, `tokenId` will be burned by `from`.
962      * - `from` and `to` are never both zero.
963      */
964     function _beforeTokenTransfers(
965         address from,
966         address to,
967         uint256 startTokenId,
968         uint256 quantity
969     ) internal virtual {}
970 
971     /**
972      * @dev Hook that is called after a set of serially-ordered token IDs
973      * have been transferred. This includes minting.
974      * And also called after one token has been burned.
975      *
976      * `startTokenId` - the first token ID to be transferred.
977      * `quantity` - the amount to be transferred.
978      *
979      * Calling conditions:
980      *
981      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
982      * transferred to `to`.
983      * - When `from` is zero, `tokenId` has been minted for `to`.
984      * - When `to` is zero, `tokenId` has been burned by `from`.
985      * - `from` and `to` are never both zero.
986      */
987     function _afterTokenTransfers(
988         address from,
989         address to,
990         uint256 startTokenId,
991         uint256 quantity
992     ) internal virtual {}
993 
994     /**
995      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
996      *
997      * `from` - Previous owner of the given token ID.
998      * `to` - Target address that will receive the token.
999      * `tokenId` - Token ID to be transferred.
1000      * `_data` - Optional data to send along with the call.
1001      *
1002      * Returns whether the call correctly returned the expected magic value.
1003      */
1004     function _checkContractOnERC721Received(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes memory _data
1009     ) private returns (bool) {
1010         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1011             bytes4 retval
1012         ) {
1013             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1014         } catch (bytes memory reason) {
1015             if (reason.length == 0) {
1016                 revert TransferToNonERC721ReceiverImplementer();
1017             } else {
1018                 assembly {
1019                     revert(add(32, reason), mload(reason))
1020                 }
1021             }
1022         }
1023     }
1024 
1025     // =============================================================
1026     //                        MINT OPERATIONS
1027     // =============================================================
1028 
1029     /**
1030      * @dev Mints `quantity` tokens and transfers them to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `quantity` must be greater than 0.
1036      *
1037      * Emits a {Transfer} event for each mint.
1038      */
1039     function _mint(address to, uint256 quantity) internal virtual {
1040         uint256 startTokenId = _currentIndex;
1041         if (quantity == 0) revert MintZeroQuantity();
1042 
1043         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1044 
1045         // Overflows are incredibly unrealistic.
1046         // `balance` and `numberMinted` have a maximum limit of 2**64.
1047         // `tokenId` has a maximum limit of 2**256.
1048         unchecked {
1049             // Updates:
1050             // - `balance += quantity`.
1051             // - `numberMinted += quantity`.
1052             //
1053             // We can directly add to the `balance` and `numberMinted`.
1054             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1055 
1056             // Updates:
1057             // - `address` to the owner.
1058             // - `startTimestamp` to the timestamp of minting.
1059             // - `burned` to `false`.
1060             // - `nextInitialized` to `quantity == 1`.
1061             _packedOwnerships[startTokenId] = _packOwnershipData(
1062                 to,
1063                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1064             );
1065 
1066             uint256 toMasked;
1067             uint256 end = startTokenId + quantity;
1068 
1069             // Use assembly to loop and emit the `Transfer` event for gas savings.
1070             assembly {
1071                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1072                 toMasked := and(to, _BITMASK_ADDRESS)
1073                 // Emit the `Transfer` event.
1074                 log4(
1075                     0, // Start of data (0, since no data).
1076                     0, // End of data (0, since no data).
1077                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1078                     0, // `address(0)`.
1079                     toMasked, // `to`.
1080                     startTokenId // `tokenId`.
1081                 )
1082 
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
1353     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1354         assembly {
1355             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1356             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1357             // We will need 1 32-byte word to store the length,
1358             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1359             ptr := add(mload(0x40), 128)
1360             // Update the free memory pointer to allocate.
1361             mstore(0x40, ptr)
1362 
1363             // Cache the end of the memory to calculate the length later.
1364             let end := ptr
1365 
1366             // We write the string from the rightmost digit to the leftmost digit.
1367             // The following is essentially a do-while loop that also handles the zero case.
1368             // Costs a bit more than early returning for the zero case,
1369             // but cheaper in terms of deployment and overall runtime costs.
1370             for {
1371                 // Initialize and perform the first pass without check.
1372                 let temp := value
1373                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1374                 ptr := sub(ptr, 1)
1375                 // Write the character to the pointer.
1376                 // The ASCII index of the '0' character is 48.
1377                 mstore8(ptr, add(48, mod(temp, 10)))
1378                 temp := div(temp, 10)
1379             } temp {
1380                 // Keep dividing `temp` until zero.
1381                 temp := div(temp, 10)
1382             } {
1383                 // Body of the for loop.
1384                 ptr := sub(ptr, 1)
1385                 mstore8(ptr, add(48, mod(temp, 10)))
1386             }
1387 
1388             let length := sub(end, ptr)
1389             // Move the pointer 32 bytes leftwards to make room for the length.
1390             ptr := sub(ptr, 32)
1391             // Store the length.
1392             mstore(ptr, length)
1393         }
1394     }
1395 }
1396 
1397 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1398 
1399 
1400 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1401 
1402 pragma solidity ^0.8.0;
1403 
1404 /**
1405  * @dev Contract module that helps prevent reentrant calls to a function.
1406  *
1407  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1408  * available, which can be applied to functions to make sure there are no nested
1409  * (reentrant) calls to them.
1410  *
1411  * Note that because there is a single `nonReentrant` guard, functions marked as
1412  * `nonReentrant` may not call one another. This can be worked around by making
1413  * those functions `private`, and then adding `external` `nonReentrant` entry
1414  * points to them.
1415  *
1416  * TIP: If you would like to learn more about reentrancy and alternative ways
1417  * to protect against it, check out our blog post
1418  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1419  */
1420 abstract contract ReentrancyGuard {
1421     // Booleans are more expensive than uint256 or any type that takes up a full
1422     // word because each write operation emits an extra SLOAD to first read the
1423     // slot's contents, replace the bits taken up by the boolean, and then write
1424     // back. This is the compiler's defense against contract upgrades and
1425     // pointer aliasing, and it cannot be disabled.
1426 
1427     // The values being non-zero value makes deployment a bit more expensive,
1428     // but in exchange the refund on every call to nonReentrant will be lower in
1429     // amount. Since refunds are capped to a percentage of the total
1430     // transaction's gas, it is best to keep them low in cases like this one, to
1431     // increase the likelihood of the full refund coming into effect.
1432     uint256 private constant _NOT_ENTERED = 1;
1433     uint256 private constant _ENTERED = 2;
1434 
1435     uint256 private _status;
1436 
1437     constructor() {
1438         _status = _NOT_ENTERED;
1439     }
1440 
1441     /**
1442      * @dev Prevents a contract from calling itself, directly or indirectly.
1443      * Calling a `nonReentrant` function from another `nonReentrant`
1444      * function is not supported. It is possible to prevent this from happening
1445      * by making the `nonReentrant` function external, and making it call a
1446      * `private` function that does the actual work.
1447      */
1448     modifier nonReentrant() {
1449         // On the first call to nonReentrant, _notEntered will be true
1450         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1451 
1452         // Any calls to nonReentrant after this point will fail
1453         _status = _ENTERED;
1454 
1455         _;
1456 
1457         // By storing the original value once again, a refund is triggered (see
1458         // https://eips.ethereum.org/EIPS/eip-2200)
1459         _status = _NOT_ENTERED;
1460     }
1461 }
1462 
1463 // File: @openzeppelin/contracts/utils/Context.sol
1464 
1465 
1466 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1467 
1468 pragma solidity ^0.8.0;
1469 
1470 /**
1471  * @dev Provides information about the current execution context, including the
1472  * sender of the transaction and its data. While these are generally available
1473  * via msg.sender and msg.data, they should not be accessed in such a direct
1474  * manner, since when dealing with meta-transactions the account sending and
1475  * paying for execution may not be the actual sender (as far as an application
1476  * is concerned).
1477  *
1478  * This contract is only required for intermediate, library-like contracts.
1479  */
1480 abstract contract Context {
1481     function _msgSender() internal view virtual returns (address) {
1482         return msg.sender;
1483     }
1484 
1485     function _msgData() internal view virtual returns (bytes calldata) {
1486         return msg.data;
1487     }
1488 }
1489 
1490 // File: @openzeppelin/contracts/access/Ownable.sol
1491 
1492 
1493 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 
1498 /**
1499  * @dev Contract module which provides a basic access control mechanism, where
1500  * there is an account (an owner) that can be granted exclusive access to
1501  * specific functions.
1502  *
1503  * By default, the owner account will be the one that deploys the contract. This
1504  * can later be changed with {transferOwnership}.
1505  *
1506  * This module is used through inheritance. It will make available the modifier
1507  * `onlyOwner`, which can be applied to your functions to restrict their use to
1508  * the owner.
1509  */
1510 abstract contract Ownable is Context {
1511     address private _owner;
1512 
1513     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1514 
1515     /**
1516      * @dev Initializes the contract setting the deployer as the initial owner.
1517      */
1518     constructor() {
1519         _transferOwnership(_msgSender());
1520     }
1521 
1522     /**
1523      * @dev Throws if called by any account other than the owner.
1524      */
1525     modifier onlyOwner() {
1526         _checkOwner();
1527         _;
1528     }
1529 
1530     /**
1531      * @dev Returns the address of the current owner.
1532      */
1533     function owner() public view virtual returns (address) {
1534         return _owner;
1535     }
1536 
1537     /**
1538      * @dev Throws if the sender is not the owner.
1539      */
1540     function _checkOwner() internal view virtual {
1541         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1542     }
1543 
1544     /**
1545      * @dev Leaves the contract without owner. It will not be possible to call
1546      * `onlyOwner` functions anymore. Can only be called by the current owner.
1547      *
1548      * NOTE: Renouncing ownership will leave the contract without an owner,
1549      * thereby removing any functionality that is only available to the owner.
1550      */
1551     function renounceOwnership() public virtual onlyOwner {
1552         _transferOwnership(address(0));
1553     }
1554 
1555     /**
1556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1557      * Can only be called by the current owner.
1558      */
1559     function transferOwnership(address newOwner) public virtual onlyOwner {
1560         require(newOwner != address(0), "Ownable: new owner is the zero address");
1561         _transferOwnership(newOwner);
1562     }
1563 
1564     /**
1565      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1566      * Internal function without access restriction.
1567      */
1568     function _transferOwnership(address newOwner) internal virtual {
1569         address oldOwner = _owner;
1570         _owner = newOwner;
1571         emit OwnershipTransferred(oldOwner, newOwner);
1572     }
1573 }
1574 
1575 // File: contracts/glitchbaby.sol
1576 
1577 pragma solidity ^0.8.4;
1578 
1579 
1580 
1581 
1582 
1583 contract GlitchBaby is Ownable, ERC721A, ReentrancyGuard {
1584     mapping(address => uint256) public minted;
1585     GbConfig public gbConfig;
1586 
1587     struct GbConfig {
1588         uint256 price;
1589         uint256 maxMint;
1590         uint256 maxSupply;
1591         uint256 freeSlot;
1592     }
1593 
1594     constructor() ERC721A("GlitchBaby", "GB") {
1595         gbConfig.maxSupply = 5555;
1596         gbConfig.price = 3500000000000000;
1597         gbConfig.maxMint = 5;
1598         gbConfig.freeSlot = 0;
1599     }
1600 
1601     function mintBaby(uint256 quantity) external payable {
1602         GbConfig memory config = gbConfig;
1603         uint256 price = uint256(config.price);
1604         uint256 maxMint = uint256(config.maxMint);
1605         uint256 buyed = getAddressBuyed(msg.sender);
1606         uint256 freeSlot = uint256(config.freeSlot);
1607 
1608         require(
1609             totalSupply() + quantity <= getMaxSupply(),
1610             "Sold out."
1611         );
1612     
1613         require(
1614             buyed + quantity <= maxMint,
1615             "Exceed maxmium mint."
1616         );
1617 
1618         bool notFree = (quantity > freeSlot || buyed >= freeSlot) ? true : false;
1619         if (notFree) {
1620             uint256 calcPrice = buyed >= freeSlot ? quantity * price : (quantity - freeSlot) * price;
1621 
1622             
1623             require(
1624                 calcPrice <= msg.value,
1625                 "No enough eth."
1626             );
1627         }
1628 
1629         _safeMint(msg.sender, quantity);
1630         minted[msg.sender] += quantity;
1631     }
1632 
1633     function makeBaby(uint256 quantity) external onlyOwner {
1634         require(
1635             totalSupply() + quantity <= getMaxSupply(),
1636             "Sold out."
1637         );
1638 
1639         _safeMint(msg.sender, quantity);
1640     }
1641 
1642     function getAddressBuyed(address owner) public view returns (uint256) {
1643         return minted[owner];
1644     }
1645     
1646     function getMaxSupply() private view returns (uint256) {
1647         GbConfig memory config = gbConfig;
1648         uint256 max = uint256(config.maxSupply);
1649         return max;
1650     }
1651 
1652     string private _baseTokenURI;
1653 
1654     function _baseURI() internal view virtual override returns (string memory) {
1655         return _baseTokenURI;
1656     }
1657 
1658     function setURI(string calldata baseURI) external onlyOwner {
1659         _baseTokenURI = baseURI;
1660     }
1661 
1662     function setPrice(uint256 _price) external onlyOwner {
1663         gbConfig.price = _price;
1664     }
1665 
1666     function setMaxMint(uint256 _amount) external onlyOwner {
1667         gbConfig.maxMint = _amount;
1668     }
1669 
1670     function setFreeSlot(uint256 _slots) external onlyOwner {
1671         gbConfig.freeSlot = _slots;
1672     }
1673 
1674     function withdraw() external onlyOwner nonReentrant {
1675         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1676         require(success, "q");
1677     }
1678 }