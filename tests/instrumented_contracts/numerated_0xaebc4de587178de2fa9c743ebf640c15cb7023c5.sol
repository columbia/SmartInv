1 /**
2  ██▓███   ██▓▒██   ██▒▓█████  ██▓                         
3 ▓██░  ██▒▓██▒▒▒ █ █ ▒░▓█   ▀ ▓██▒                         
4 ▓██░ ██▓▒▒██▒░░  █   ░▒███   ▒██░                         
5 ▒██▄█▓▒ ▒░██░ ░ █ █ ▒ ▒▓█  ▄ ▒██░                         
6 ▒██▒ ░  ░░██░▒██▒ ▒██▒░▒████▒░██████▒                     
7 ▒▓▒░ ░  ░░▓  ▒▒ ░ ░▓ ░░░ ▒░ ░░ ▒░▓  ░                     
8 ░▒ ░      ▒ ░░░   ░▒ ░ ░ ░  ░░ ░ ▒  ░                     
9 ░░        ▒ ░ ░    ░     ░     ░ ░                        
10           ░   ░    ░     ░  ░    ░  ░                     
11                                                           
12 ▓█████▄  ▄▄▄       ███▄    █   ██████  ▒█████   ███▄    █ 
13 ▒██▀ ██▌▒████▄     ██ ▀█   █ ▒██    ▒ ▒██▒  ██▒ ██ ▀█   █ 
14 ░██   █▌▒██  ▀█▄  ▓██  ▀█ ██▒░ ▓██▄   ▒██░  ██▒▓██  ▀█ ██▒
15 ░▓█▄   ▌░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▒   ██▒▒██   ██░▓██▒  ▐▌██▒
16 ░▒████▓  ▓█   ▓██▒▒██░   ▓██░▒██████▒▒░ ████▓▒░▒██░   ▓██░
17  ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
18  ░ ▒  ▒   ▒   ▒▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
19  ░ ░  ░   ░   ▒      ░   ░ ░ ░  ░  ░  ░ ░ ░ ▒     ░   ░ ░ 
20    ░          ░  ░         ░       ░      ░ ░           ░ 
21  ░ 
22 https://twitter.com/PixelDanson
23  */
24 
25 // SPDX-License-Identifier: MIT
26 
27 pragma solidity ^0.8.7;
28 
29 /**
30  * @dev Interface of ERC721A.
31  */
32 interface IERC721A {
33     /**
34      * The caller must own the token or be an approved operator.
35      */
36     error ApprovalCallerNotOwnerNorApproved();
37 
38     /**
39      * The token does not exist.
40      */
41     error ApprovalQueryForNonexistentToken();
42 
43     /**
44      * Cannot query the balance for the zero address.
45      */
46     error BalanceQueryForZeroAddress();
47 
48     /**
49      * Cannot mint to the zero address.
50      */
51     error MintToZeroAddress();
52 
53     /**
54      * The quantity of tokens minted must be more than zero.
55      */
56     error MintZeroQuantity();
57 
58     /**
59      * The token does not exist.
60      */
61     error OwnerQueryForNonexistentToken();
62 
63     /**
64      * The caller must own the token or be an approved operator.
65      */
66     error TransferCallerNotOwnerNorApproved();
67 
68     /**
69      * The token must be owned by `from`.
70      */
71     error TransferFromIncorrectOwner();
72 
73     /**
74      * Cannot safely transfer to a contract that does not implement the
75      * ERC721Receiver interface.
76      */
77     error TransferToNonERC721ReceiverImplementer();
78 
79     /**
80      * Cannot transfer to the zero address.
81      */
82     error TransferToZeroAddress();
83 
84     /**
85      * The token does not exist.
86      */
87     error URIQueryForNonexistentToken();
88 
89     /**
90      * The `quantity` minted with ERC2309 exceeds the safety limit.
91      */
92     error MintERC2309QuantityExceedsLimit();
93 
94     /**
95      * The `extraData` cannot be set on an unintialized ownership slot.
96      */
97     error OwnershipNotInitializedForExtraData();
98 
99     // =============================================================
100     //                            STRUCTS
101     // =============================================================
102 
103     struct TokenOwnership {
104         // The address of the owner.
105         address addr;
106         // Stores the start time of ownership with minimal overhead for tokenomics.
107         uint64 startTimestamp;
108         // Whether the token has been burned.
109         bool burned;
110         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
111         uint24 extraData;
112     }
113 
114     // =============================================================
115     //                         TOKEN COUNTERS
116     // =============================================================
117 
118     /**
119      * @dev Returns the total number of tokens in existence.
120      * Burned tokens will reduce the count.
121      * To get the total number of tokens minted, please see {_totalMinted}.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     // =============================================================
126     //                            IERC165
127     // =============================================================
128 
129     /**
130      * @dev Returns true if this contract implements the interface defined by
131      * `interfaceId`. See the corresponding
132      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
133      * to learn more about how these ids are created.
134      *
135      * This function call must use less than 30000 gas.
136      */
137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
138 
139     // =============================================================
140     //                            IERC721
141     // =============================================================
142 
143     /**
144      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
150      */
151     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables or disables
155      * (`approved`) `operator` to manage all of its assets.
156      */
157     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
158 
159     /**
160      * @dev Returns the number of tokens in `owner`'s account.
161      */
162     function balanceOf(address owner) external view returns (uint256 balance);
163 
164     /**
165      * @dev Returns the owner of the `tokenId` token.
166      *
167      * Requirements:
168      *
169      * - `tokenId` must exist.
170      */
171     function ownerOf(uint256 tokenId) external view returns (address owner);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`,
175      * checking first that contract recipients are aware of the ERC721 protocol
176      * to prevent tokens from being forever locked.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must exist and be owned by `from`.
183      * - If the caller is not `from`, it must be have been allowed to move
184      * this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement
186      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external payable;
196 
197     /**
198      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external payable;
205 
206     /**
207      * @dev Transfers `tokenId` from `from` to `to`.
208      *
209      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
210      * whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token
218      * by either {approve} or {setApprovalForAll}.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external payable;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the
233      * zero address clears previous approvals.
234      *
235      * Requirements:
236      *
237      * - The caller must own the token or be an approved operator.
238      * - `tokenId` must exist.
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address to, uint256 tokenId) external payable;
243 
244     /**
245      * @dev Approve or remove `operator` as an operator for the caller.
246      * Operators can call {transferFrom} or {safeTransferFrom}
247      * for any token owned by the caller.
248      *
249      * Requirements:
250      *
251      * - The `operator` cannot be the caller.
252      *
253      * Emits an {ApprovalForAll} event.
254      */
255     function setApprovalForAll(address operator, bool _approved) external;
256 
257     /**
258      * @dev Returns the account approved for `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function getApproved(uint256 tokenId) external view returns (address operator);
265 
266     /**
267      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
268      *
269      * See {setApprovalForAll}.
270      */
271     function isApprovedForAll(address owner, address operator) external view returns (bool);
272 
273     // =============================================================
274     //                        IERC721Metadata
275     // =============================================================
276 
277     /**
278      * @dev Returns the token collection name.
279      */
280     function name() external view returns (string memory);
281 
282     /**
283      * @dev Returns the token collection symbol.
284      */
285     function symbol() external view returns (string memory);
286 
287     /**
288      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
289      */
290     function tokenURI(uint256 tokenId) external view returns (string memory);
291 
292     // =============================================================
293     //                           IERC2309
294     // =============================================================
295 
296     /**
297      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
298      * (inclusive) is transferred from `from` to `to`, as defined in the
299      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
300      *
301      * See {_mintERC2309} for more details.
302      */
303     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
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
321 interface ERC721A__IERC721Receiver {
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 /**
331  * @title ERC721A
332  *
333  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
334  * Non-Fungible Token Standard, including the Metadata extension.
335  * Optimized for lower gas during batch mints.
336  *
337  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
338  * starting from `_startTokenId()`.
339  *
340  * Assumptions:
341  *
342  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
343  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
344  */
345 contract ERC721A is IERC721A {
346     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
347     struct TokenApprovalRef {
348         address value;
349     }
350 
351     // =============================================================
352     //                           CONSTANTS
353     // =============================================================
354 
355     // Mask of an entry in packed address data.
356     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
357 
358     // The bit position of `numberMinted` in packed address data.
359     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
360 
361     // The bit position of `numberBurned` in packed address data.
362     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
363 
364     // The bit position of `aux` in packed address data.
365     uint256 private constant _BITPOS_AUX = 192;
366 
367     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
368     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
369 
370     // The bit position of `startTimestamp` in packed ownership.
371     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
372 
373     // The bit mask of the `burned` bit in packed ownership.
374     uint256 private constant _BITMASK_BURNED = 1 << 224;
375 
376     // The bit position of the `nextInitialized` bit in packed ownership.
377     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
378 
379     // The bit mask of the `nextInitialized` bit in packed ownership.
380     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
381 
382     // The bit position of `extraData` in packed ownership.
383     uint256 private constant _BITPOS_EXTRA_DATA = 232;
384 
385     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
386     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
387 
388     // The mask of the lower 160 bits for addresses.
389     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
390 
391     // The maximum `quantity` that can be minted with {_mintERC2309}.
392     // This limit is to prevent overflows on the address data entries.
393     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
394     // is required to cause an overflow, which is unrealistic.
395     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
396 
397     // The `Transfer` event signature is given by:
398     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
399     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
400         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
401 
402     // =============================================================
403     //                            STORAGE
404     // =============================================================
405 
406     // The next token ID to be minted.
407     uint256 private _currentIndex;
408 
409     // The number of tokens burned.
410     uint256 private _burnCounter;
411 
412     // Token name
413     string private _name;
414 
415     // Token symbol
416     string private _symbol;
417 
418     // Mapping from token ID to ownership details
419     // An empty struct value does not necessarily mean the token is unowned.
420     // See {_packedOwnershipOf} implementation for details.
421     //
422     // Bits Layout:
423     // - [0..159]   `addr`
424     // - [160..223] `startTimestamp`
425     // - [224]      `burned`
426     // - [225]      `nextInitialized`
427     // - [232..255] `extraData`
428     mapping(uint256 => uint256) private _packedOwnerships;
429 
430     // Mapping owner address to address data.
431     //
432     // Bits Layout:
433     // - [0..63]    `balance`
434     // - [64..127]  `numberMinted`
435     // - [128..191] `numberBurned`
436     // - [192..255] `aux`
437     mapping(address => uint256) private _packedAddressData;
438 
439     // Mapping from token ID to approved address.
440     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
441 
442     // Mapping from owner to operator approvals
443     mapping(address => mapping(address => bool)) private _operatorApprovals;
444 
445     // =============================================================
446     //                          CONSTRUCTOR
447     // =============================================================
448 
449     constructor(string memory name_, string memory symbol_) {
450         _name = name_;
451         _symbol = symbol_;
452         _currentIndex = _startTokenId();
453     }
454 
455     // =============================================================
456     //                   TOKEN COUNTING OPERATIONS
457     // =============================================================
458 
459     /**
460      * @dev Returns the starting token ID.
461      * To change the starting token ID, please override this function.
462      */
463     function _startTokenId() internal view virtual returns (uint256) {
464         return 0;
465     }
466 
467     /**
468      * @dev Returns the next token ID to be minted.
469      */
470     function _nextTokenId() internal view virtual returns (uint256) {
471         return _currentIndex;
472     }
473 
474     /**
475      * @dev Returns the total number of tokens in existence.
476      * Burned tokens will reduce the count.
477      * To get the total number of tokens minted, please see {_totalMinted}.
478      */
479     function totalSupply() public view virtual override returns (uint256) {
480         // Counter underflow is impossible as _burnCounter cannot be incremented
481         // more than `_currentIndex - _startTokenId()` times.
482         unchecked {
483             return _currentIndex - _burnCounter - _startTokenId();
484         }
485     }
486 
487     /**
488      * @dev Returns the total amount of tokens minted in the contract.
489      */
490     function _totalMinted() internal view virtual returns (uint256) {
491         // Counter underflow is impossible as `_currentIndex` does not decrement,
492         // and it is initialized to `_startTokenId()`.
493         unchecked {
494             return _currentIndex - _startTokenId();
495         }
496     }
497 
498     /**
499      * @dev Returns the total number of tokens burned.
500      */
501     function _totalBurned() internal view virtual returns (uint256) {
502         return _burnCounter;
503     }
504 
505     // =============================================================
506     //                    ADDRESS DATA OPERATIONS
507     // =============================================================
508 
509     /**
510      * @dev Returns the number of tokens in `owner`'s account.
511      */
512     function balanceOf(address owner) public view virtual override returns (uint256) {
513         if (owner == address(0)) revert BalanceQueryForZeroAddress();
514         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the number of tokens minted by `owner`.
519      */
520     function _numberMinted(address owner) internal view returns (uint256) {
521         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the number of tokens burned by or on behalf of `owner`.
526      */
527     function _numberBurned(address owner) internal view returns (uint256) {
528         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
529     }
530 
531     /**
532      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
533      */
534     function _getAux(address owner) internal view returns (uint64) {
535         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
536     }
537 
538     /**
539      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
540      * If there are multiple variables, please pack them into a uint64.
541      */
542     function _setAux(address owner, uint64 aux) internal virtual {
543         uint256 packed = _packedAddressData[owner];
544         uint256 auxCasted;
545         // Cast `aux` with assembly to avoid redundant masking.
546         assembly {
547             auxCasted := aux
548         }
549         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
550         _packedAddressData[owner] = packed;
551     }
552 
553     // =============================================================
554     //                            IERC165
555     // =============================================================
556 
557     /**
558      * @dev Returns true if this contract implements the interface defined by
559      * `interfaceId`. See the corresponding
560      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
561      * to learn more about how these ids are created.
562      *
563      * This function call must use less than 30000 gas.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         // The interface IDs are constants representing the first 4 bytes
567         // of the XOR of all function selectors in the interface.
568         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
569         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
570         return
571             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
572             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
573             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
574     }
575 
576     // =============================================================
577     //                        IERC721Metadata
578     // =============================================================
579 
580     /**
581      * @dev Returns the token collection name.
582      */
583     function name() public view virtual override returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the token collection symbol.
589      */
590     function symbol() public view virtual override returns (string memory) {
591         return _symbol;
592     }
593 
594     /**
595      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
596      */
597     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
598         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
599 
600         string memory baseURI = _baseURI();
601         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
602     }
603 
604     /**
605      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
606      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
607      * by default, it can be overridden in child contracts.
608      */
609     function _baseURI() internal view virtual returns (string memory) {
610         return '';
611     }
612 
613     // =============================================================
614     //                     OWNERSHIPS OPERATIONS
615     // =============================================================
616 
617     /**
618      * @dev Returns the owner of the `tokenId` token.
619      *
620      * Requirements:
621      *
622      * - `tokenId` must exist.
623      */
624     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
625         return address(uint160(_packedOwnershipOf(tokenId)));
626     }
627 
628     /**
629      * @dev Gas spent here starts off proportional to the maximum mint batch size.
630      * It gradually moves to O(1) as tokens get transferred around over time.
631      */
632     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnershipOf(tokenId));
634     }
635 
636     /**
637      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
638      */
639     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
640         return _unpackedOwnership(_packedOwnerships[index]);
641     }
642 
643     /**
644      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
645      */
646     function _initializeOwnershipAt(uint256 index) internal virtual {
647         if (_packedOwnerships[index] == 0) {
648             _packedOwnerships[index] = _packedOwnershipOf(index);
649         }
650     }
651 
652     /**
653      * Returns the packed ownership data of `tokenId`.
654      */
655     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
656         uint256 curr = tokenId;
657 
658         unchecked {
659             if (_startTokenId() <= curr)
660                 if (curr < _currentIndex) {
661                     uint256 packed = _packedOwnerships[curr];
662                     // If not burned.
663                     if (packed & _BITMASK_BURNED == 0) {
664                         // Invariant:
665                         // There will always be an initialized ownership slot
666                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
667                         // before an unintialized ownership slot
668                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
669                         // Hence, `curr` will not underflow.
670                         //
671                         // We can directly compare the packed value.
672                         // If the address is zero, packed will be zero.
673                         while (packed == 0) {
674                             packed = _packedOwnerships[--curr];
675                         }
676                         return packed;
677                     }
678                 }
679         }
680         revert OwnerQueryForNonexistentToken();
681     }
682 
683     /**
684      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
685      */
686     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
687         ownership.addr = address(uint160(packed));
688         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
689         ownership.burned = packed & _BITMASK_BURNED != 0;
690         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
691     }
692 
693     /**
694      * @dev Packs ownership data into a single uint256.
695      */
696     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
697         assembly {
698             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
699             owner := and(owner, _BITMASK_ADDRESS)
700             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
701             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
702         }
703     }
704 
705     /**
706      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
707      */
708     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
709         // For branchless setting of the `nextInitialized` flag.
710         assembly {
711             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
712             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
713         }
714     }
715 
716     // =============================================================
717     //                      APPROVAL OPERATIONS
718     // =============================================================
719 
720     /**
721      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
722      * The approval is cleared when the token is transferred.
723      *
724      * Only a single account can be approved at a time, so approving the
725      * zero address clears previous approvals.
726      *
727      * Requirements:
728      *
729      * - The caller must own the token or be an approved operator.
730      * - `tokenId` must exist.
731      *
732      * Emits an {Approval} event.
733      */
734     function approve(address to, uint256 tokenId) public payable virtual override {
735         address owner = ownerOf(tokenId);
736 
737         if (_msgSenderERC721A() != owner)
738             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
739                 revert ApprovalCallerNotOwnerNorApproved();
740             }
741 
742         _tokenApprovals[tokenId].value = to;
743         emit Approval(owner, to, tokenId);
744     }
745 
746     /**
747      * @dev Returns the account approved for `tokenId` token.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      */
753     function getApproved(uint256 tokenId) public view virtual override returns (address) {
754         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
755 
756         return _tokenApprovals[tokenId].value;
757     }
758 
759     /**
760      * @dev Approve or remove `operator` as an operator for the caller.
761      * Operators can call {transferFrom} or {safeTransferFrom}
762      * for any token owned by the caller.
763      *
764      * Requirements:
765      *
766      * - The `operator` cannot be the caller.
767      *
768      * Emits an {ApprovalForAll} event.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
772         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
773     }
774 
775     /**
776      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
777      *
778      * See {setApprovalForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev Returns whether `tokenId` exists.
786      *
787      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
788      *
789      * Tokens start existing when they are minted. See {_mint}.
790      */
791     function _exists(uint256 tokenId) internal view virtual returns (bool) {
792         return
793             _startTokenId() <= tokenId &&
794             tokenId < _currentIndex && // If within bounds,
795             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
796     }
797 
798     /**
799      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
800      */
801     function _isSenderApprovedOrOwner(
802         address approvedAddress,
803         address owner,
804         address msgSender
805     ) private pure returns (bool result) {
806         assembly {
807             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
808             owner := and(owner, _BITMASK_ADDRESS)
809             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             msgSender := and(msgSender, _BITMASK_ADDRESS)
811             // `msgSender == owner || msgSender == approvedAddress`.
812             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
813         }
814     }
815 
816     /**
817      * @dev Returns the storage slot and value for the approved address of `tokenId`.
818      */
819     function _getApprovedSlotAndAddress(uint256 tokenId)
820         private
821         view
822         returns (uint256 approvedAddressSlot, address approvedAddress)
823     {
824         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
825         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
826         assembly {
827             approvedAddressSlot := tokenApproval.slot
828             approvedAddress := sload(approvedAddressSlot)
829         }
830     }
831 
832     // =============================================================
833     //                      TRANSFER OPERATIONS
834     // =============================================================
835 
836     /**
837      * @dev Transfers `tokenId` from `from` to `to`.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must be owned by `from`.
844      * - If the caller is not `from`, it must be approved to move this token
845      * by either {approve} or {setApprovalForAll}.
846      *
847      * Emits a {Transfer} event.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public payable virtual override {
854         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
855 
856         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
857 
858         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
859 
860         // The nested ifs save around 20+ gas over a compound boolean condition.
861         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
862             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
863 
864         if (to == address(0)) revert TransferToZeroAddress();
865 
866         _beforeTokenTransfers(from, to, tokenId, 1);
867 
868         // Clear approvals from the previous owner.
869         assembly {
870             if approvedAddress {
871                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
872                 sstore(approvedAddressSlot, 0)
873             }
874         }
875 
876         // Underflow of the sender's balance is impossible because we check for
877         // ownership above and the recipient's balance can't realistically overflow.
878         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
879         unchecked {
880             // We can directly increment and decrement the balances.
881             --_packedAddressData[from]; // Updates: `balance -= 1`.
882             ++_packedAddressData[to]; // Updates: `balance += 1`.
883 
884             // Updates:
885             // - `address` to the next owner.
886             // - `startTimestamp` to the timestamp of transfering.
887             // - `burned` to `false`.
888             // - `nextInitialized` to `true`.
889             _packedOwnerships[tokenId] = _packOwnershipData(
890                 to,
891                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
892             );
893 
894             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
895             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
896                 uint256 nextTokenId = tokenId + 1;
897                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
898                 if (_packedOwnerships[nextTokenId] == 0) {
899                     // If the next slot is within bounds.
900                     if (nextTokenId != _currentIndex) {
901                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
902                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
903                     }
904                 }
905             }
906         }
907 
908         emit Transfer(from, to, tokenId);
909         _afterTokenTransfers(from, to, tokenId, 1);
910     }
911 
912     /**
913      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public payable virtual override {
920         safeTransferFrom(from, to, tokenId, '');
921     }
922 
923     /**
924      * @dev Safely transfers `tokenId` token from `from` to `to`.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If the caller is not `from`, it must be approved to move this token
932      * by either {approve} or {setApprovalForAll}.
933      * - If `to` refers to a smart contract, it must implement
934      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public payable virtual override {
944         transferFrom(from, to, tokenId);
945         if (to.code.length != 0)
946             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
947                 revert TransferToNonERC721ReceiverImplementer();
948             }
949     }
950 
951     /**
952      * @dev Hook that is called before a set of serially-ordered token IDs
953      * are about to be transferred. This includes minting.
954      * And also called before burning one token.
955      *
956      * `startTokenId` - the first token ID to be transferred.
957      * `quantity` - the amount to be transferred.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` will be minted for `to`.
964      * - When `to` is zero, `tokenId` will be burned by `from`.
965      * - `from` and `to` are never both zero.
966      */
967     function _beforeTokenTransfers(
968         address from,
969         address to,
970         uint256 startTokenId,
971         uint256 quantity
972     ) internal virtual {}
973 
974     /**
975      * @dev Hook that is called after a set of serially-ordered token IDs
976      * have been transferred. This includes minting.
977      * And also called after one token has been burned.
978      *
979      * `startTokenId` - the first token ID to be transferred.
980      * `quantity` - the amount to be transferred.
981      *
982      * Calling conditions:
983      *
984      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
985      * transferred to `to`.
986      * - When `from` is zero, `tokenId` has been minted for `to`.
987      * - When `to` is zero, `tokenId` has been burned by `from`.
988      * - `from` and `to` are never both zero.
989      */
990     function _afterTokenTransfers(
991         address from,
992         address to,
993         uint256 startTokenId,
994         uint256 quantity
995     ) internal virtual {}
996 
997     /**
998      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
999      *
1000      * `from` - Previous owner of the given token ID.
1001      * `to` - Target address that will receive the token.
1002      * `tokenId` - Token ID to be transferred.
1003      * `_data` - Optional data to send along with the call.
1004      *
1005      * Returns whether the call correctly returned the expected magic value.
1006      */
1007     function _checkContractOnERC721Received(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) private returns (bool) {
1013         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1014             bytes4 retval
1015         ) {
1016             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1017         } catch (bytes memory reason) {
1018             if (reason.length == 0) {
1019                 revert TransferToNonERC721ReceiverImplementer();
1020             } else {
1021                 assembly {
1022                     revert(add(32, reason), mload(reason))
1023                 }
1024             }
1025         }
1026     }
1027 
1028     // =============================================================
1029     //                        MINT OPERATIONS
1030     // =============================================================
1031 
1032     /**
1033      * @dev Mints `quantity` tokens and transfers them to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `quantity` must be greater than 0.
1039      *
1040      * Emits a {Transfer} event for each mint.
1041      */
1042     function _mint(address to, uint256 quantity) internal virtual {
1043         uint256 startTokenId = _currentIndex;
1044         if (quantity == 0) revert MintZeroQuantity();
1045 
1046         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048         // Overflows are incredibly unrealistic.
1049         // `balance` and `numberMinted` have a maximum limit of 2**64.
1050         // `tokenId` has a maximum limit of 2**256.
1051         unchecked {
1052             // Updates:
1053             // - `balance += quantity`.
1054             // - `numberMinted += quantity`.
1055             //
1056             // We can directly add to the `balance` and `numberMinted`.
1057             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1058 
1059             // Updates:
1060             // - `address` to the owner.
1061             // - `startTimestamp` to the timestamp of minting.
1062             // - `burned` to `false`.
1063             // - `nextInitialized` to `quantity == 1`.
1064             _packedOwnerships[startTokenId] = _packOwnershipData(
1065                 to,
1066                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1067             );
1068 
1069             uint256 toMasked;
1070             uint256 end = startTokenId + quantity;
1071 
1072             // Use assembly to loop and emit the `Transfer` event for gas savings.
1073             // The duplicated `log4` removes an extra check and reduces stack juggling.
1074             // The assembly, together with the surrounding Solidity code, have been
1075             // delicately arranged to nudge the compiler into producing optimized opcodes.
1076             assembly {
1077                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1078                 toMasked := and(to, _BITMASK_ADDRESS)
1079                 // Emit the `Transfer` event.
1080                 log4(
1081                     0, // Start of data (0, since no data).
1082                     0, // End of data (0, since no data).
1083                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1084                     0, // `address(0)`.
1085                     toMasked, // `to`.
1086                     startTokenId // `tokenId`.
1087                 )
1088 
1089                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1090                 // that overflows uint256 will make the loop run out of gas.
1091                 // The compiler will optimize the `iszero` away for performance.
1092                 for {
1093                     let tokenId := add(startTokenId, 1)
1094                 } iszero(eq(tokenId, end)) {
1095                     tokenId := add(tokenId, 1)
1096                 } {
1097                     // Emit the `Transfer` event. Similar to above.
1098                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1099                 }
1100             }
1101             if (toMasked == 0) revert MintToZeroAddress();
1102 
1103             _currentIndex = end;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * This function is intended for efficient minting only during contract creation.
1112      *
1113      * It emits only one {ConsecutiveTransfer} as defined in
1114      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1115      * instead of a sequence of {Transfer} event(s).
1116      *
1117      * Calling this function outside of contract creation WILL make your contract
1118      * non-compliant with the ERC721 standard.
1119      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1120      * {ConsecutiveTransfer} event is only permissible during contract creation.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {ConsecutiveTransfer} event.
1128      */
1129     function _mintERC2309(address to, uint256 quantity) internal virtual {
1130         uint256 startTokenId = _currentIndex;
1131         if (to == address(0)) revert MintToZeroAddress();
1132         if (quantity == 0) revert MintZeroQuantity();
1133         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1138         unchecked {
1139             // Updates:
1140             // - `balance += quantity`.
1141             // - `numberMinted += quantity`.
1142             //
1143             // We can directly add to the `balance` and `numberMinted`.
1144             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1145 
1146             // Updates:
1147             // - `address` to the owner.
1148             // - `startTimestamp` to the timestamp of minting.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `quantity == 1`.
1151             _packedOwnerships[startTokenId] = _packOwnershipData(
1152                 to,
1153                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1154             );
1155 
1156             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1157 
1158             _currentIndex = startTokenId + quantity;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - If `to` refers to a smart contract, it must implement
1169      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1170      * - `quantity` must be greater than 0.
1171      *
1172      * See {_mint}.
1173      *
1174      * Emits a {Transfer} event for each mint.
1175      */
1176     function _safeMint(
1177         address to,
1178         uint256 quantity,
1179         bytes memory _data
1180     ) internal virtual {
1181         _mint(to, quantity);
1182 
1183         unchecked {
1184             if (to.code.length != 0) {
1185                 uint256 end = _currentIndex;
1186                 uint256 index = end - quantity;
1187                 do {
1188                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1189                         revert TransferToNonERC721ReceiverImplementer();
1190                     }
1191                 } while (index < end);
1192                 // Reentrancy protection.
1193                 if (_currentIndex != end) revert();
1194             }
1195         }
1196     }
1197 
1198     /**
1199      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1200      */
1201     function _safeMint(address to, uint256 quantity) internal virtual {
1202         _safeMint(to, quantity, '');
1203     }
1204 
1205     // =============================================================
1206     //                        BURN OPERATIONS
1207     // =============================================================
1208 
1209     /**
1210      * @dev Equivalent to `_burn(tokenId, false)`.
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         _burn(tokenId, false);
1214     }
1215 
1216     /**
1217      * @dev Destroys `tokenId`.
1218      * The approval is cleared when the token is burned.
1219      *
1220      * Requirements:
1221      *
1222      * - `tokenId` must exist.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1227         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1228 
1229         address from = address(uint160(prevOwnershipPacked));
1230 
1231         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1232 
1233         if (approvalCheck) {
1234             // The nested ifs save around 20+ gas over a compound boolean condition.
1235             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1236                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1237         }
1238 
1239         _beforeTokenTransfers(from, address(0), tokenId, 1);
1240 
1241         // Clear approvals from the previous owner.
1242         assembly {
1243             if approvedAddress {
1244                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1245                 sstore(approvedAddressSlot, 0)
1246             }
1247         }
1248 
1249         // Underflow of the sender's balance is impossible because we check for
1250         // ownership above and the recipient's balance can't realistically overflow.
1251         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1252         unchecked {
1253             // Updates:
1254             // - `balance -= 1`.
1255             // - `numberBurned += 1`.
1256             //
1257             // We can directly decrement the balance, and increment the number burned.
1258             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1259             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1260 
1261             // Updates:
1262             // - `address` to the last owner.
1263             // - `startTimestamp` to the timestamp of burning.
1264             // - `burned` to `true`.
1265             // - `nextInitialized` to `true`.
1266             _packedOwnerships[tokenId] = _packOwnershipData(
1267                 from,
1268                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1269             );
1270 
1271             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1272             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1273                 uint256 nextTokenId = tokenId + 1;
1274                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1275                 if (_packedOwnerships[nextTokenId] == 0) {
1276                     // If the next slot is within bounds.
1277                     if (nextTokenId != _currentIndex) {
1278                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1279                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1280                     }
1281                 }
1282             }
1283         }
1284 
1285         emit Transfer(from, address(0), tokenId);
1286         _afterTokenTransfers(from, address(0), tokenId, 1);
1287 
1288         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1289         unchecked {
1290             _burnCounter++;
1291         }
1292     }
1293 
1294     // =============================================================
1295     //                     EXTRA DATA OPERATIONS
1296     // =============================================================
1297 
1298     /**
1299      * @dev Directly sets the extra data for the ownership data `index`.
1300      */
1301     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1302         uint256 packed = _packedOwnerships[index];
1303         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1304         uint256 extraDataCasted;
1305         // Cast `extraData` with assembly to avoid redundant masking.
1306         assembly {
1307             extraDataCasted := extraData
1308         }
1309         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1310         _packedOwnerships[index] = packed;
1311     }
1312 
1313     /**
1314      * @dev Called during each token transfer to set the 24bit `extraData` field.
1315      * Intended to be overridden by the cosumer contract.
1316      *
1317      * `previousExtraData` - the value of `extraData` before transfer.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _extraData(
1328         address from,
1329         address to,
1330         uint24 previousExtraData
1331     ) internal view virtual returns (uint24) {}
1332 
1333     /**
1334      * @dev Returns the next extra data for the packed ownership data.
1335      * The returned result is shifted into position.
1336      */
1337     function _nextExtraData(
1338         address from,
1339         address to,
1340         uint256 prevOwnershipPacked
1341     ) private view returns (uint256) {
1342         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1343         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1344     }
1345 
1346     // =============================================================
1347     //                       OTHER OPERATIONS
1348     // =============================================================
1349 
1350     /**
1351      * @dev Returns the message sender (defaults to `msg.sender`).
1352      *
1353      * If you are writing GSN compatible contracts, you need to override this function.
1354      */
1355     function _msgSenderERC721A() internal view virtual returns (address) {
1356         return msg.sender;
1357     }
1358 
1359     /**
1360      * @dev Converts a uint256 to its ASCII string decimal representation.
1361      */
1362     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1363         assembly {
1364             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1365             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1366             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1367             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1368             let m := add(mload(0x40), 0xa0)
1369             // Update the free memory pointer to allocate.
1370             mstore(0x40, m)
1371             // Assign the `str` to the end.
1372             str := sub(m, 0x20)
1373             // Zeroize the slot after the string.
1374             mstore(str, 0)
1375 
1376             // Cache the end of the memory to calculate the length later.
1377             let end := str
1378 
1379             // We write the string from rightmost digit to leftmost digit.
1380             // The following is essentially a do-while loop that also handles the zero case.
1381             // prettier-ignore
1382             for { let temp := value } 1 {} {
1383                 str := sub(str, 1)
1384                 // Write the character to the pointer.
1385                 // The ASCII index of the '0' character is 48.
1386                 mstore8(str, add(48, mod(temp, 10)))
1387                 // Keep dividing `temp` until zero.
1388                 temp := div(temp, 10)
1389                 // prettier-ignore
1390                 if iszero(temp) { break }
1391             }
1392 
1393             let length := sub(end, str)
1394             // Move the pointer 32 bytes leftwards to make room for the length.
1395             str := sub(str, 0x20)
1396             // Store the length.
1397             mstore(str, length)
1398         }
1399     }
1400 }
1401 
1402 
1403 interface IOperatorFilterRegistry {
1404     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1405     function register(address registrant) external;
1406     function registerAndSubscribe(address registrant, address subscription) external;
1407     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1408     function unregister(address addr) external;
1409     function updateOperator(address registrant, address operator, bool filtered) external;
1410     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1411     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1412     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1413     function subscribe(address registrant, address registrantToSubscribe) external;
1414     function unsubscribe(address registrant, bool copyExistingEntries) external;
1415     function subscriptionOf(address addr) external returns (address registrant);
1416     function subscribers(address registrant) external returns (address[] memory);
1417     function subscriberAt(address registrant, uint256 index) external returns (address);
1418     function copyEntriesOf(address registrant, address registrantToCopy) external;
1419     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1420     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1421     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1422     function filteredOperators(address addr) external returns (address[] memory);
1423     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1424     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1425     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1426     function isRegistered(address addr) external returns (bool);
1427     function codeHashOf(address addr) external returns (bytes32);
1428 }
1429 
1430 
1431 /**
1432  * @title  OperatorFilterer
1433  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1434  *         registrant's entries in the OperatorFilterRegistry.
1435  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1436  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1437  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1438  */
1439 abstract contract OperatorFilterer {
1440     error OperatorNotAllowed(address operator);
1441 
1442     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1443         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1444 
1445     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1446         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1447         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1448         // order for the modifier to filter addresses.
1449         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1450             if (subscribe) {
1451                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1452             } else {
1453                 if (subscriptionOrRegistrantToCopy != address(0)) {
1454                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1455                 } else {
1456                     OPERATOR_FILTER_REGISTRY.register(address(this));
1457                 }
1458             }
1459         }
1460     }
1461 
1462     modifier onlyAllowedOperator(address from) virtual {
1463         // Check registry code length to facilitate testing in environments without a deployed registry.
1464         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1465             // Allow spending tokens from addresses with balance
1466             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1467             // from an EOA.
1468             if (from == msg.sender) {
1469                 _;
1470                 return;
1471             }
1472             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1473                 revert OperatorNotAllowed(msg.sender);
1474             }
1475         }
1476         _;
1477     }
1478 
1479     modifier onlyAllowedOperatorApproval(address operator) virtual {
1480         // Check registry code length to facilitate testing in environments without a deployed registry.
1481         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1482             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1483                 revert OperatorNotAllowed(operator);
1484             }
1485         }
1486         _;
1487     }
1488 }
1489 
1490 /**
1491  * @title  DefaultOperatorFilterer
1492  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1493  */
1494 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1495     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1496     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1497 }
1498 
1499 contract PixelDanson is ERC721A, DefaultOperatorFilterer {
1500     mapping(uint256 => uint256) blockFree;
1501 
1502     mapping(address => bool) minted;
1503 
1504     uint256 public maxSupply = 888;
1505 
1506     uint256 public maxPerTx = 8;    
1507 
1508     uint256 public price = 0.0025 ether;
1509 
1510     uint256 public royalty = 50;
1511 
1512     bool pause;
1513 
1514     function mint(uint256 amount) payable public {
1515         require(totalSupply() + amount <= maxSupply);
1516         require(amount <= maxPerTx);
1517         _mint(amount);
1518     }
1519 
1520     string uri = "ipfs://bafybeidb7aaope3v73h3tuh2vn3e2ivfxmk3u2gehw4sxfbim6axep3c4i/";
1521     function setUri(string memory _uri) external onlyOwner {
1522         uri = _uri;
1523     }
1524 
1525     address owner;
1526     modifier onlyOwner {
1527         require(owner == msg.sender);
1528         _;
1529     }
1530     
1531     constructor() ERC721A("Pixel Danson", "PD") {
1532         owner = msg.sender;
1533     }
1534 
1535     function _mint(uint256 amount) internal {
1536         require(msg.sender == tx.origin);
1537         if (msg.value == 0) {
1538             uint256 freeNum = (maxSupply - totalSupply()) / 12;
1539             require(blockFree[block.number] + 1 <= freeNum);
1540             blockFree[block.number] += 1;
1541             _safeMint(msg.sender, 1);
1542             return;
1543         }
1544         require(msg.value >= amount * price);
1545         _safeMint(msg.sender, amount);
1546     }
1547 
1548     function reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1549         uint16 totalSupply = uint16(totalSupply());
1550         require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1551         _safeMint(_receiver , _mintAmount);
1552     }
1553 
1554     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1555         uint256 royaltyAmount = (_salePrice * royalty) / 1000;
1556         return (owner, royaltyAmount);
1557     }
1558 
1559     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1560         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1561     }
1562 
1563     function withdraw() external onlyOwner {
1564         payable(msg.sender).transfer(address(this).balance);
1565     }
1566 
1567     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1568         super.setApprovalForAll(operator, approved);
1569     }
1570 
1571     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1572         super.approve(operator, tokenId);
1573     }
1574 
1575     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1576         super.transferFrom(from, to, tokenId);
1577     }
1578 
1579     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1580         super.safeTransferFrom(from, to, tokenId);
1581     }
1582 
1583     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1584         public
1585         payable
1586         override
1587         onlyAllowedOperator(from)
1588     {
1589         super.safeTransferFrom(from, to, tokenId, data);
1590     }
1591 }