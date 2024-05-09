1 //. 
2 //. ███╗   ██╗███████╗██╗  ██╗████████╗ ██████╗ ███████╗███╗   ██╗    ██████╗  █████╗ ██████╗ ██╗   ██╗
3 //. ████╗  ██║██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝ ██╔════╝████╗  ██║    ██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
4 //. ██╔██╗ ██║█████╗   ╚███╔╝    ██║   ██║  ███╗█████╗  ██╔██╗ ██║    ██████╔╝███████║██████╔╝ ╚████╔╝ 
5 //. ██║╚██╗██║██╔══╝   ██╔██╗    ██║   ██║   ██║██╔══╝  ██║╚██╗██║    ██╔══██╗██╔══██║██╔══██╗  ╚██╔╝  
6 //. ██║ ╚████║███████╗██╔╝ ██╗   ██║   ╚██████╔╝███████╗██║ ╚████║    ██████╔╝██║  ██║██████╔╝   ██║   
7 //. ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═══╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝    ╚═╝   
8 //.                                                                                                     
9 //. NEXTGEN BABY
10 // SPDX-License-Identifier: MIT
11 // File: erc721a/contracts/IERC721A.sol
12 
13 
14 // ERC721A Contracts v4.2.0
15 // Creator: Chiru Labs
16 
17 pragma solidity ^0.8.4;
18 
19 /**
20  * @dev Interface of ERC721A.
21  */
22 interface IERC721A {
23     /**
24      * The caller must own the token or be an approved operator.
25      */
26     error ApprovalCallerNotOwnerNorApproved();
27 
28     /**
29      * The token does not exist.
30      */
31     error ApprovalQueryForNonexistentToken();
32 
33     /**
34      * The caller cannot approve to their own address.
35      */
36     error ApproveToCaller();
37 
38     /**
39      * Cannot query the balance for the zero address.
40      */
41     error BalanceQueryForZeroAddress();
42 
43     /**
44      * Cannot mint to the zero address.
45      */
46     error MintToZeroAddress();
47 
48     /**
49      * The quantity of tokens minted must be more than zero.
50      */
51     error MintZeroQuantity();
52 
53     /**
54      * The token does not exist.
55      */
56     error OwnerQueryForNonexistentToken();
57 
58     /**
59      * The caller must own the token or be an approved operator.
60      */
61     error TransferCallerNotOwnerNorApproved();
62 
63     /**
64      * The token must be owned by `from`.
65      */
66     error TransferFromIncorrectOwner();
67 
68     /**
69      * Cannot safely transfer to a contract that does not implement the
70      * ERC721Receiver interface.
71      */
72     error TransferToNonERC721ReceiverImplementer();
73 
74     /**
75      * Cannot transfer to the zero address.
76      */
77     error TransferToZeroAddress();
78 
79     /**
80      * The token does not exist.
81      */
82     error URIQueryForNonexistentToken();
83 
84     /**
85      * The `quantity` minted with ERC2309 exceeds the safety limit.
86      */
87     error MintERC2309QuantityExceedsLimit();
88 
89     /**
90      * The `extraData` cannot be set on an unintialized ownership slot.
91      */
92     error OwnershipNotInitializedForExtraData();
93 
94     // =============================================================
95     //                            STRUCTS
96     // =============================================================
97 
98     struct TokenOwnership {
99         // The address of the owner.
100         address addr;
101         // Stores the start time of ownership with minimal overhead for tokenomics.
102         uint64 startTimestamp;
103         // Whether the token has been burned.
104         bool burned;
105         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
106         uint24 extraData;
107     }
108 
109     // =============================================================
110     //                         TOKEN COUNTERS
111     // =============================================================
112 
113     /**
114      * @dev Returns the total number of tokens in existence.
115      * Burned tokens will reduce the count.
116      * To get the total number of tokens minted, please see {_totalMinted}.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     // =============================================================
121     //                            IERC165
122     // =============================================================
123 
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 
134     // =============================================================
135     //                            IERC721
136     // =============================================================
137 
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables
150      * (`approved`) `operator` to manage all of its assets.
151      */
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     /**
155      * @dev Returns the number of tokens in `owner`'s account.
156      */
157     function balanceOf(address owner) external view returns (uint256 balance);
158 
159     /**
160      * @dev Returns the owner of the `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function ownerOf(uint256 tokenId) external view returns (address owner);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`,
170      * checking first that contract recipients are aware of the ERC721 protocol
171      * to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move
179      * this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement
181      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 
192     /**
193      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Transfers `tokenId` from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
205      * whenever possible.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token
213      * by either {approve} or {setApprovalForAll}.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     /**
224      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
225      * The approval is cleared when the token is transferred.
226      *
227      * Only a single account can be approved at a time, so approving the
228      * zero address clears previous approvals.
229      *
230      * Requirements:
231      *
232      * - The caller must own the token or be an approved operator.
233      * - `tokenId` must exist.
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address to, uint256 tokenId) external;
238 
239     /**
240      * @dev Approve or remove `operator` as an operator for the caller.
241      * Operators can call {transferFrom} or {safeTransferFrom}
242      * for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns the account approved for `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function getApproved(uint256 tokenId) external view returns (address operator);
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}.
265      */
266     function isApprovedForAll(address owner, address operator) external view returns (bool);
267 
268     // =============================================================
269     //                        IERC721Metadata
270     // =============================================================
271 
272     /**
273      * @dev Returns the token collection name.
274      */
275     function name() external view returns (string memory);
276 
277     /**
278      * @dev Returns the token collection symbol.
279      */
280     function symbol() external view returns (string memory);
281 
282     /**
283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
284      */
285     function tokenURI(uint256 tokenId) external view returns (string memory);
286 
287     // =============================================================
288     //                           IERC2309
289     // =============================================================
290 
291     /**
292      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
293      * (inclusive) is transferred from `from` to `to`, as defined in the
294      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
295      *
296      * See {_mintERC2309} for more details.
297      */
298     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
299 }
300 
301 // File: erc721a/contracts/ERC721A.sol
302 
303 
304 // ERC721A Contracts v4.2.0
305 // Creator: Chiru Labs
306 
307 pragma solidity ^0.8.4;
308 
309 
310 /**
311  * @dev Interface of ERC721 token receiver.
312  */
313 interface ERC721A__IERC721Receiver {
314     function onERC721Received(
315         address operator,
316         address from,
317         uint256 tokenId,
318         bytes calldata data
319     ) external returns (bytes4);
320 }
321 
322 /**
323  * @title ERC721A
324  *
325  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
326  * Non-Fungible Token Standard, including the Metadata extension.
327  * Optimized for lower gas during batch mints.
328  *
329  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
330  * starting from `_startTokenId()`.
331  *
332  * Assumptions:
333  *
334  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
335  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
336  */
337 contract ERC721A is IERC721A {
338     // Reference type for token approval.
339     struct TokenApprovalRef {
340         address value;
341     }
342 
343     // =============================================================
344     //                           CONSTANTS
345     // =============================================================
346 
347     // Mask of an entry in packed address data.
348     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
349 
350     // The bit position of `numberMinted` in packed address data.
351     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
352 
353     // The bit position of `numberBurned` in packed address data.
354     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
355 
356     // The bit position of `aux` in packed address data.
357     uint256 private constant _BITPOS_AUX = 192;
358 
359     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
360     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
361 
362     // The bit position of `startTimestamp` in packed ownership.
363     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
364 
365     // The bit mask of the `burned` bit in packed ownership.
366     uint256 private constant _BITMASK_BURNED = 1 << 224;
367 
368     // The bit position of the `nextInitialized` bit in packed ownership.
369     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
370 
371     // The bit mask of the `nextInitialized` bit in packed ownership.
372     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
373 
374     // The bit position of `extraData` in packed ownership.
375     uint256 private constant _BITPOS_EXTRA_DATA = 232;
376 
377     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
378     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
379 
380     // The mask of the lower 160 bits for addresses.
381     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
382 
383     // The maximum `quantity` that can be minted with {_mintERC2309}.
384     // This limit is to prevent overflows on the address data entries.
385     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
386     // is required to cause an overflow, which is unrealistic.
387     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
388 
389     // The `Transfer` event signature is given by:
390     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
391     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
392         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
393 
394     // =============================================================
395     //                            STORAGE
396     // =============================================================
397 
398     // The next token ID to be minted.
399     uint256 private _currentIndex;
400 
401     // The number of tokens burned.
402     uint256 private _burnCounter;
403 
404     // Token name
405     string private _name;
406 
407     // Token symbol
408     string private _symbol;
409 
410     // Mapping from token ID to ownership details
411     // An empty struct value does not necessarily mean the token is unowned.
412     // See {_packedOwnershipOf} implementation for details.
413     //
414     // Bits Layout:
415     // - [0..159]   `addr`
416     // - [160..223] `startTimestamp`
417     // - [224]      `burned`
418     // - [225]      `nextInitialized`
419     // - [232..255] `extraData`
420     mapping(uint256 => uint256) private _packedOwnerships;
421 
422     // Mapping owner address to address data.
423     //
424     // Bits Layout:
425     // - [0..63]    `balance`
426     // - [64..127]  `numberMinted`
427     // - [128..191] `numberBurned`
428     // - [192..255] `aux`
429     mapping(address => uint256) private _packedAddressData;
430 
431     // Mapping from token ID to approved address.
432     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
433 
434     // Mapping from owner to operator approvals
435     mapping(address => mapping(address => bool)) private _operatorApprovals;
436 
437     // =============================================================
438     //                          CONSTRUCTOR
439     // =============================================================
440 
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444         _currentIndex = _startTokenId();
445     }
446 
447     // =============================================================
448     //                   TOKEN COUNTING OPERATIONS
449     // =============================================================
450 
451     /**
452      * @dev Returns the starting token ID.
453      * To change the starting token ID, please override this function.
454      */
455     function _startTokenId() internal view virtual returns (uint256) {
456         return 0;
457     }
458 
459     /**
460      * @dev Returns the next token ID to be minted.
461      */
462     function _nextTokenId() internal view virtual returns (uint256) {
463         return _currentIndex;
464     }
465 
466     /**
467      * @dev Returns the total number of tokens in existence.
468      * Burned tokens will reduce the count.
469      * To get the total number of tokens minted, please see {_totalMinted}.
470      */
471     function totalSupply() public view virtual override returns (uint256) {
472         // Counter underflow is impossible as _burnCounter cannot be incremented
473         // more than `_currentIndex - _startTokenId()` times.
474         unchecked {
475             return _currentIndex - _burnCounter - _startTokenId();
476         }
477     }
478 
479     /**
480      * @dev Returns the total amount of tokens minted in the contract.
481      */
482     function _totalMinted() internal view virtual returns (uint256) {
483         // Counter underflow is impossible as `_currentIndex` does not decrement,
484         // and it is initialized to `_startTokenId()`.
485         unchecked {
486             return _currentIndex - _startTokenId();
487         }
488     }
489 
490     /**
491      * @dev Returns the total number of tokens burned.
492      */
493     function _totalBurned() internal view virtual returns (uint256) {
494         return _burnCounter;
495     }
496 
497     // =============================================================
498     //                    ADDRESS DATA OPERATIONS
499     // =============================================================
500 
501     /**
502      * @dev Returns the number of tokens in `owner`'s account.
503      */
504     function balanceOf(address owner) public view virtual override returns (uint256) {
505         if (owner == address(0)) revert BalanceQueryForZeroAddress();
506         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the number of tokens minted by `owner`.
511      */
512     function _numberMinted(address owner) internal view returns (uint256) {
513         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
514     }
515 
516     /**
517      * Returns the number of tokens burned by or on behalf of `owner`.
518      */
519     function _numberBurned(address owner) internal view returns (uint256) {
520         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     /**
524      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
525      */
526     function _getAux(address owner) internal view returns (uint64) {
527         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
528     }
529 
530     /**
531      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
532      * If there are multiple variables, please pack them into a uint64.
533      */
534     function _setAux(address owner, uint64 aux) internal virtual {
535         uint256 packed = _packedAddressData[owner];
536         uint256 auxCasted;
537         // Cast `aux` with assembly to avoid redundant masking.
538         assembly {
539             auxCasted := aux
540         }
541         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
542         _packedAddressData[owner] = packed;
543     }
544 
545     // =============================================================
546     //                            IERC165
547     // =============================================================
548 
549     /**
550      * @dev Returns true if this contract implements the interface defined by
551      * `interfaceId`. See the corresponding
552      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
553      * to learn more about how these ids are created.
554      *
555      * This function call must use less than 30000 gas.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         // The interface IDs are constants representing the first 4 bytes
559         // of the XOR of all function selectors in the interface.
560         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
561         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
562         return
563             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
564             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
565             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
566     }
567 
568     // =============================================================
569     //                        IERC721Metadata
570     // =============================================================
571 
572     /**
573      * @dev Returns the token collection name.
574      */
575     function name() public view virtual override returns (string memory) {
576         return _name;
577     }
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() public view virtual override returns (string memory) {
583         return _symbol;
584     }
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
590         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
591 
592         string memory baseURI = _baseURI();
593         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
594     }
595 
596     /**
597      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
598      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
599      * by default, it can be overridden in child contracts.
600      */
601     function _baseURI() internal view virtual returns (string memory) {
602         return '';
603     }
604 
605     // =============================================================
606     //                     OWNERSHIPS OPERATIONS
607     // =============================================================
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
617         return address(uint160(_packedOwnershipOf(tokenId)));
618     }
619 
620     /**
621      * @dev Gas spent here starts off proportional to the maximum mint batch size.
622      * It gradually moves to O(1) as tokens get transferred around over time.
623      */
624     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnershipOf(tokenId));
626     }
627 
628     /**
629      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
630      */
631     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnerships[index]);
633     }
634 
635     /**
636      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
637      */
638     function _initializeOwnershipAt(uint256 index) internal virtual {
639         if (_packedOwnerships[index] == 0) {
640             _packedOwnerships[index] = _packedOwnershipOf(index);
641         }
642     }
643 
644     /**
645      * Returns the packed ownership data of `tokenId`.
646      */
647     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
648         uint256 curr = tokenId;
649 
650         unchecked {
651             if (_startTokenId() <= curr)
652                 if (curr < _currentIndex) {
653                     uint256 packed = _packedOwnerships[curr];
654                     // If not burned.
655                     if (packed & _BITMASK_BURNED == 0) {
656                         // Invariant:
657                         // There will always be an initialized ownership slot
658                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
659                         // before an unintialized ownership slot
660                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
661                         // Hence, `curr` will not underflow.
662                         //
663                         // We can directly compare the packed value.
664                         // If the address is zero, packed will be zero.
665                         while (packed == 0) {
666                             packed = _packedOwnerships[--curr];
667                         }
668                         return packed;
669                     }
670                 }
671         }
672         revert OwnerQueryForNonexistentToken();
673     }
674 
675     /**
676      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
677      */
678     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
679         ownership.addr = address(uint160(packed));
680         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
681         ownership.burned = packed & _BITMASK_BURNED != 0;
682         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
683     }
684 
685     /**
686      * @dev Packs ownership data into a single uint256.
687      */
688     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
689         assembly {
690             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
691             owner := and(owner, _BITMASK_ADDRESS)
692             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
693             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
694         }
695     }
696 
697     /**
698      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
699      */
700     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
701         // For branchless setting of the `nextInitialized` flag.
702         assembly {
703             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
704             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
705         }
706     }
707 
708     // =============================================================
709     //                      APPROVAL OPERATIONS
710     // =============================================================
711 
712     /**
713      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
714      * The approval is cleared when the token is transferred.
715      *
716      * Only a single account can be approved at a time, so approving the
717      * zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) public virtual override {
727         address owner = ownerOf(tokenId);
728 
729         if (_msgSenderERC721A() != owner)
730             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
731                 revert ApprovalCallerNotOwnerNorApproved();
732             }
733 
734         _tokenApprovals[tokenId].value = to;
735         emit Approval(owner, to, tokenId);
736     }
737 
738     /**
739      * @dev Returns the account approved for `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
747 
748         return _tokenApprovals[tokenId].value;
749     }
750 
751     /**
752      * @dev Approve or remove `operator` as an operator for the caller.
753      * Operators can call {transferFrom} or {safeTransferFrom}
754      * for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool approved) public virtual override {
763         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
764 
765         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
766         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
767     }
768 
769     /**
770      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
771      *
772      * See {setApprovalForAll}.
773      */
774     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
775         return _operatorApprovals[owner][operator];
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted. See {_mint}.
784      */
785     function _exists(uint256 tokenId) internal view virtual returns (bool) {
786         return
787             _startTokenId() <= tokenId &&
788             tokenId < _currentIndex && // If within bounds,
789             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
790     }
791 
792     /**
793      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
794      */
795     function _isSenderApprovedOrOwner(
796         address approvedAddress,
797         address owner,
798         address msgSender
799     ) private pure returns (bool result) {
800         assembly {
801             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
802             owner := and(owner, _BITMASK_ADDRESS)
803             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
804             msgSender := and(msgSender, _BITMASK_ADDRESS)
805             // `msgSender == owner || msgSender == approvedAddress`.
806             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
807         }
808     }
809 
810     /**
811      * @dev Returns the storage slot and value for the approved address of `tokenId`.
812      */
813     function _getApprovedSlotAndAddress(uint256 tokenId)
814         private
815         view
816         returns (uint256 approvedAddressSlot, address approvedAddress)
817     {
818         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
819         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
820         assembly {
821             approvedAddressSlot := tokenApproval.slot
822             approvedAddress := sload(approvedAddressSlot)
823         }
824     }
825 
826     // =============================================================
827     //                      TRANSFER OPERATIONS
828     // =============================================================
829 
830     /**
831      * @dev Transfers `tokenId` from `from` to `to`.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must be owned by `from`.
838      * - If the caller is not `from`, it must be approved to move this token
839      * by either {approve} or {setApprovalForAll}.
840      *
841      * Emits a {Transfer} event.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
849 
850         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
851 
852         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
853 
854         // The nested ifs save around 20+ gas over a compound boolean condition.
855         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
856             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
857 
858         if (to == address(0)) revert TransferToZeroAddress();
859 
860         _beforeTokenTransfers(from, to, tokenId, 1);
861 
862         // Clear approvals from the previous owner.
863         assembly {
864             if approvedAddress {
865                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
866                 sstore(approvedAddressSlot, 0)
867             }
868         }
869 
870         // Underflow of the sender's balance is impossible because we check for
871         // ownership above and the recipient's balance can't realistically overflow.
872         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
873         unchecked {
874             // We can directly increment and decrement the balances.
875             --_packedAddressData[from]; // Updates: `balance -= 1`.
876             ++_packedAddressData[to]; // Updates: `balance += 1`.
877 
878             // Updates:
879             // - `address` to the next owner.
880             // - `startTimestamp` to the timestamp of transfering.
881             // - `burned` to `false`.
882             // - `nextInitialized` to `true`.
883             _packedOwnerships[tokenId] = _packOwnershipData(
884                 to,
885                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
886             );
887 
888             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
889             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
890                 uint256 nextTokenId = tokenId + 1;
891                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
892                 if (_packedOwnerships[nextTokenId] == 0) {
893                     // If the next slot is within bounds.
894                     if (nextTokenId != _currentIndex) {
895                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
896                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
897                     }
898                 }
899             }
900         }
901 
902         emit Transfer(from, to, tokenId);
903         _afterTokenTransfers(from, to, tokenId, 1);
904     }
905 
906     /**
907      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         safeTransferFrom(from, to, tokenId, '');
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token
926      * by either {approve} or {setApprovalForAll}.
927      * - If `to` refers to a smart contract, it must implement
928      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public virtual override {
938         transferFrom(from, to, tokenId);
939         if (to.code.length != 0)
940             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
941                 revert TransferToNonERC721ReceiverImplementer();
942             }
943     }
944 
945     /**
946      * @dev Hook that is called before a set of serially-ordered token IDs
947      * are about to be transferred. This includes minting.
948      * And also called before burning one token.
949      *
950      * `startTokenId` - the first token ID to be transferred.
951      * `quantity` - the amount to be transferred.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` will be minted for `to`.
958      * - When `to` is zero, `tokenId` will be burned by `from`.
959      * - `from` and `to` are never both zero.
960      */
961     function _beforeTokenTransfers(
962         address from,
963         address to,
964         uint256 startTokenId,
965         uint256 quantity
966     ) internal virtual {}
967 
968     /**
969      * @dev Hook that is called after a set of serially-ordered token IDs
970      * have been transferred. This includes minting.
971      * And also called after one token has been burned.
972      *
973      * `startTokenId` - the first token ID to be transferred.
974      * `quantity` - the amount to be transferred.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` has been minted for `to`.
981      * - When `to` is zero, `tokenId` has been burned by `from`.
982      * - `from` and `to` are never both zero.
983      */
984     function _afterTokenTransfers(
985         address from,
986         address to,
987         uint256 startTokenId,
988         uint256 quantity
989     ) internal virtual {}
990 
991     /**
992      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
993      *
994      * `from` - Previous owner of the given token ID.
995      * `to` - Target address that will receive the token.
996      * `tokenId` - Token ID to be transferred.
997      * `_data` - Optional data to send along with the call.
998      *
999      * Returns whether the call correctly returned the expected magic value.
1000      */
1001     function _checkContractOnERC721Received(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) private returns (bool) {
1007         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1008             bytes4 retval
1009         ) {
1010             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1011         } catch (bytes memory reason) {
1012             if (reason.length == 0) {
1013                 revert TransferToNonERC721ReceiverImplementer();
1014             } else {
1015                 assembly {
1016                     revert(add(32, reason), mload(reason))
1017                 }
1018             }
1019         }
1020     }
1021 
1022     // =============================================================
1023     //                        MINT OPERATIONS
1024     // =============================================================
1025 
1026     /**
1027      * @dev Mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event for each mint.
1035      */
1036     function _mint(address to, uint256 quantity) internal virtual {
1037         uint256 startTokenId = _currentIndex;
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // `balance` and `numberMinted` have a maximum limit of 2**64.
1044         // `tokenId` has a maximum limit of 2**256.
1045         unchecked {
1046             // Updates:
1047             // - `balance += quantity`.
1048             // - `numberMinted += quantity`.
1049             //
1050             // We can directly add to the `balance` and `numberMinted`.
1051             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1052 
1053             // Updates:
1054             // - `address` to the owner.
1055             // - `startTimestamp` to the timestamp of minting.
1056             // - `burned` to `false`.
1057             // - `nextInitialized` to `quantity == 1`.
1058             _packedOwnerships[startTokenId] = _packOwnershipData(
1059                 to,
1060                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1061             );
1062 
1063             uint256 toMasked;
1064             uint256 end = startTokenId + quantity;
1065 
1066             // Use assembly to loop and emit the `Transfer` event for gas savings.
1067             assembly {
1068                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1069                 toMasked := and(to, _BITMASK_ADDRESS)
1070                 // Emit the `Transfer` event.
1071                 log4(
1072                     0, // Start of data (0, since no data).
1073                     0, // End of data (0, since no data).
1074                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1075                     0, // `address(0)`.
1076                     toMasked, // `to`.
1077                     startTokenId // `tokenId`.
1078                 )
1079 
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
1350     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1351         assembly {
1352             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1353             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1354             // We will need 1 32-byte word to store the length,
1355             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1356             ptr := add(mload(0x40), 128)
1357             // Update the free memory pointer to allocate.
1358             mstore(0x40, ptr)
1359 
1360             // Cache the end of the memory to calculate the length later.
1361             let end := ptr
1362 
1363             // We write the string from the rightmost digit to the leftmost digit.
1364             // The following is essentially a do-while loop that also handles the zero case.
1365             // Costs a bit more than early returning for the zero case,
1366             // but cheaper in terms of deployment and overall runtime costs.
1367             for {
1368                 // Initialize and perform the first pass without check.
1369                 let temp := value
1370                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1371                 ptr := sub(ptr, 1)
1372                 // Write the character to the pointer.
1373                 // The ASCII index of the '0' character is 48.
1374                 mstore8(ptr, add(48, mod(temp, 10)))
1375                 temp := div(temp, 10)
1376             } temp {
1377                 // Keep dividing `temp` until zero.
1378                 temp := div(temp, 10)
1379             } {
1380                 // Body of the for loop.
1381                 ptr := sub(ptr, 1)
1382                 mstore8(ptr, add(48, mod(temp, 10)))
1383             }
1384 
1385             let length := sub(end, ptr)
1386             // Move the pointer 32 bytes leftwards to make room for the length.
1387             ptr := sub(ptr, 32)
1388             // Store the length.
1389             mstore(ptr, length)
1390         }
1391     }
1392 }
1393 
1394 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1395 
1396 
1397 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1398 
1399 pragma solidity ^0.8.0;
1400 
1401 /**
1402  * @dev Contract module that helps prevent reentrant calls to a function.
1403  *
1404  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1405  * available, which can be applied to functions to make sure there are no nested
1406  * (reentrant) calls to them.
1407  *
1408  * Note that because there is a single `nonReentrant` guard, functions marked as
1409  * `nonReentrant` may not call one another. This can be worked around by making
1410  * those functions `private`, and then adding `external` `nonReentrant` entry
1411  * points to them.
1412  *
1413  * TIP: If you would like to learn more about reentrancy and alternative ways
1414  * to protect against it, check out our blog post
1415  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1416  */
1417 abstract contract ReentrancyGuard {
1418     // Booleans are more expensive than uint256 or any type that takes up a full
1419     // word because each write operation emits an extra SLOAD to first read the
1420     // slot's contents, replace the bits taken up by the boolean, and then write
1421     // back. This is the compiler's defense against contract upgrades and
1422     // pointer aliasing, and it cannot be disabled.
1423 
1424     // The values being non-zero value makes deployment a bit more expensive,
1425     // but in exchange the refund on every call to nonReentrant will be lower in
1426     // amount. Since refunds are capped to a percentage of the total
1427     // transaction's gas, it is best to keep them low in cases like this one, to
1428     // increase the likelihood of the full refund coming into effect.
1429     uint256 private constant _NOT_ENTERED = 1;
1430     uint256 private constant _ENTERED = 2;
1431 
1432     uint256 private _status;
1433 
1434     constructor() {
1435         _status = _NOT_ENTERED;
1436     }
1437 
1438     /**
1439      * @dev Prevents a contract from calling itself, directly or indirectly.
1440      * Calling a `nonReentrant` function from another `nonReentrant`
1441      * function is not supported. It is possible to prevent this from happening
1442      * by making the `nonReentrant` function external, and making it call a
1443      * `private` function that does the actual work.
1444      */
1445     modifier nonReentrant() {
1446         // On the first call to nonReentrant, _notEntered will be true
1447         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1448 
1449         // Any calls to nonReentrant after this point will fail
1450         _status = _ENTERED;
1451 
1452         _;
1453 
1454         // By storing the original value once again, a refund is triggered (see
1455         // https://eips.ethereum.org/EIPS/eip-2200)
1456         _status = _NOT_ENTERED;
1457     }
1458 }
1459 
1460 // File: @openzeppelin/contracts/utils/Context.sol
1461 
1462 
1463 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @dev Provides information about the current execution context, including the
1469  * sender of the transaction and its data. While these are generally available
1470  * via msg.sender and msg.data, they should not be accessed in such a direct
1471  * manner, since when dealing with meta-transactions the account sending and
1472  * paying for execution may not be the actual sender (as far as an application
1473  * is concerned).
1474  *
1475  * This contract is only required for intermediate, library-like contracts.
1476  */
1477 abstract contract Context {
1478     function _msgSender() internal view virtual returns (address) {
1479         return msg.sender;
1480     }
1481 
1482     function _msgData() internal view virtual returns (bytes calldata) {
1483         return msg.data;
1484     }
1485 }
1486 
1487 // File: @openzeppelin/contracts/access/Ownable.sol
1488 
1489 
1490 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 
1495 /**
1496  * @dev Contract module which provides a basic access control mechanism, where
1497  * there is an account (an owner) that can be granted exclusive access to
1498  * specific functions.
1499  *
1500  * By default, the owner account will be the one that deploys the contract. This
1501  * can later be changed with {transferOwnership}.
1502  *
1503  * This module is used through inheritance. It will make available the modifier
1504  * `onlyOwner`, which can be applied to your functions to restrict their use to
1505  * the owner.
1506  */
1507 abstract contract Ownable is Context {
1508     address private _owner;
1509 
1510     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1511 
1512     /**
1513      * @dev Initializes the contract setting the deployer as the initial owner.
1514      */
1515     constructor() {
1516         _transferOwnership(_msgSender());
1517     }
1518 
1519     /**
1520      * @dev Throws if called by any account other than the owner.
1521      */
1522     modifier onlyOwner() {
1523         _checkOwner();
1524         _;
1525     }
1526 
1527     /**
1528      * @dev Returns the address of the current owner.
1529      */
1530     function owner() public view virtual returns (address) {
1531         return _owner;
1532     }
1533 
1534     /**
1535      * @dev Throws if the sender is not the owner.
1536      */
1537     function _checkOwner() internal view virtual {
1538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1539     }
1540 
1541     /**
1542      * @dev Leaves the contract without owner. It will not be possible to call
1543      * `onlyOwner` functions anymore. Can only be called by the current owner.
1544      *
1545      * NOTE: Renouncing ownership will leave the contract without an owner,
1546      * thereby removing any functionality that is only available to the owner.
1547      */
1548     function renounceOwnership() public virtual onlyOwner {
1549         _transferOwnership(address(0));
1550     }
1551 
1552     /**
1553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1554      * Can only be called by the current owner.
1555      */
1556     function transferOwnership(address newOwner) public virtual onlyOwner {
1557         require(newOwner != address(0), "Ownable: new owner is the zero address");
1558         _transferOwnership(newOwner);
1559     }
1560 
1561     /**
1562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1563      * Internal function without access restriction.
1564      */
1565     function _transferOwnership(address newOwner) internal virtual {
1566         address oldOwner = _owner;
1567         _owner = newOwner;
1568         emit OwnershipTransferred(oldOwner, newOwner);
1569     }
1570 }
1571 
1572 // File: contracts/nextgenbaby.sol
1573 
1574 
1575 pragma solidity ^0.8.4;
1576 
1577 
1578 
1579 
1580 
1581 contract NextgenBaby is Ownable, ERC721A, ReentrancyGuard {
1582     mapping(address => uint256) public minted;
1583     NgbConfig public ngbConfig;
1584 
1585     struct NgbConfig {
1586         uint256 price;
1587         uint256 maxMint;
1588         uint256 maxSupply;
1589         uint256 freeSlot;
1590     }
1591 
1592     constructor() ERC721A("NextgenBaby", "NGB") {
1593         ngbConfig.maxSupply = 10000;
1594         ngbConfig.price = 20000000000000000;
1595         ngbConfig.maxMint = 3;
1596         ngbConfig.freeSlot = 0;
1597     }
1598 
1599     function mintBaby(uint256 quantity) external payable {
1600         NgbConfig memory config = ngbConfig;
1601         uint256 price = uint256(config.price);
1602         uint256 maxMint = uint256(config.maxMint);
1603         uint256 buyed = getAddressBuyed(msg.sender);
1604         uint256 freeSlot = uint256(config.freeSlot);
1605 
1606         require(
1607             totalSupply() + quantity <= getMaxSupply(),
1608             "Sold out."
1609         );
1610     
1611         require(
1612             buyed + quantity <= maxMint,
1613             "Exceed maxmium mint."
1614         );
1615 
1616         bool notFree = (quantity > freeSlot || buyed >= freeSlot) ? true : false;
1617         if (notFree) {
1618             uint256 calcPrice = buyed >= freeSlot ? quantity * price : (quantity - freeSlot) * price;
1619 
1620             
1621             require(
1622                 calcPrice <= msg.value,
1623                 "No enough eth."
1624             );
1625         }
1626 
1627         _safeMint(msg.sender, quantity);
1628         minted[msg.sender] += quantity;
1629     }
1630 
1631     function makeBaby(uint256 quantity) external onlyOwner {
1632         require(
1633             totalSupply() + quantity <= getMaxSupply(),
1634             "Sold out."
1635         );
1636 
1637         _safeMint(msg.sender, quantity);
1638     }
1639 
1640     function getAddressBuyed(address owner) public view returns (uint256) {
1641         return minted[owner];
1642     }
1643     
1644     function getMaxSupply() private view returns (uint256) {
1645         NgbConfig memory config = ngbConfig;
1646         uint256 max = uint256(config.maxSupply);
1647         return max;
1648     }
1649 
1650     string private _baseTokenURI;
1651 
1652     function _baseURI() internal view virtual override returns (string memory) {
1653         return _baseTokenURI;
1654     }
1655 
1656     function setURI(string calldata baseURI) external onlyOwner {
1657         _baseTokenURI = baseURI;
1658     }
1659 
1660     function setPrice(uint256 _price) external onlyOwner {
1661         ngbConfig.price = _price;
1662     }
1663 
1664     function setMaxMint(uint256 _amount) external onlyOwner {
1665         ngbConfig.maxMint = _amount;
1666     }
1667 
1668     function setFreeSlot(uint256 _slots) external onlyOwner {
1669         ngbConfig.freeSlot = _slots;
1670     }
1671 
1672     function withdraw() external onlyOwner nonReentrant {
1673         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1674         require(success, "q");
1675     }
1676 }