1 /**
2    ___                          _             
3   / __|     ___      ___     __| |      o O O 
4  | (_ |    / _ \    / _ \   / _` |     o      
5   \___|    \___/    \___/   \__,_|    TS__[O] 
6 _|"""""| _|"""""| _|"""""| _|"""""|  {======| 
7 "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' ./o--000' 
8    ___      _  _                              
9   | _ )    | || |    ___                      
10   | _ \     \_, |   / -_)                     
11   |___/    _|__/    \___|                     
12 _|"""""| _| """"| _|"""""|                    
13 "`-0-0-' "`-0-0-' "`-0-0-'                    
14    ___       __      ___      ___             
15   |_  )     /  \    |_  )    |_  )            
16    / /     | () |    / /      / /             
17   /___|    _\__/    /___|    /___|            
18 _|"""""| _|"""""| _|"""""| _|"""""|           
19 "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-'           
20  */
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity ^0.8.7;
25 
26 /**
27  * @dev Interface of ERC721A.
28  */
29 interface IERC721A {
30     /**
31      * The caller must own the token or be an approved operator.
32      */
33     error ApprovalCallerNotOwnerNorApproved();
34 
35     /**
36      * The token does not exist.
37      */
38     error ApprovalQueryForNonexistentToken();
39 
40     /**
41      * Cannot query the balance for the zero address.
42      */
43     error BalanceQueryForZeroAddress();
44 
45     /**
46      * Cannot mint to the zero address.
47      */
48     error MintToZeroAddress();
49 
50     /**
51      * The quantity of tokens minted must be more than zero.
52      */
53     error MintZeroQuantity();
54 
55     /**
56      * The token does not exist.
57      */
58     error OwnerQueryForNonexistentToken();
59 
60     /**
61      * The caller must own the token or be an approved operator.
62      */
63     error TransferCallerNotOwnerNorApproved();
64 
65     /**
66      * The token must be owned by `from`.
67      */
68     error TransferFromIncorrectOwner();
69 
70     /**
71      * Cannot safely transfer to a contract that does not implement the
72      * ERC721Receiver interface.
73      */
74     error TransferToNonERC721ReceiverImplementer();
75 
76     /**
77      * Cannot transfer to the zero address.
78      */
79     error TransferToZeroAddress();
80 
81     /**
82      * The token does not exist.
83      */
84     error URIQueryForNonexistentToken();
85 
86     /**
87      * The `quantity` minted with ERC2309 exceeds the safety limit.
88      */
89     error MintERC2309QuantityExceedsLimit();
90 
91     /**
92      * The `extraData` cannot be set on an unintialized ownership slot.
93      */
94     error OwnershipNotInitializedForExtraData();
95 
96     // =============================================================
97     //                            STRUCTS
98     // =============================================================
99 
100     struct TokenOwnership {
101         // The address of the owner.
102         address addr;
103         // Stores the start time of ownership with minimal overhead for tokenomics.
104         uint64 startTimestamp;
105         // Whether the token has been burned.
106         bool burned;
107         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
108         uint24 extraData;
109     }
110 
111     // =============================================================
112     //                         TOKEN COUNTERS
113     // =============================================================
114 
115     /**
116      * @dev Returns the total number of tokens in existence.
117      * Burned tokens will reduce the count.
118      * To get the total number of tokens minted, please see {_totalMinted}.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     // =============================================================
123     //                            IERC165
124     // =============================================================
125 
126     /**
127      * @dev Returns true if this contract implements the interface defined by
128      * `interfaceId`. See the corresponding
129      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
130      * to learn more about how these ids are created.
131      *
132      * This function call must use less than 30000 gas.
133      */
134     function supportsInterface(bytes4 interfaceId) external view returns (bool);
135 
136     // =============================================================
137     //                            IERC721
138     // =============================================================
139 
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables
152      * (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in `owner`'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`,
172      * checking first that contract recipients are aware of the ERC721 protocol
173      * to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move
181      * this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement
183      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external payable;
193 
194     /**
195      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external payable;
202 
203     /**
204      * @dev Transfers `tokenId` from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
207      * whenever possible.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must be owned by `from`.
214      * - If the caller is not `from`, it must be approved to move this token
215      * by either {approve} or {setApprovalForAll}.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external payable;
224 
225     /**
226      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
227      * The approval is cleared when the token is transferred.
228      *
229      * Only a single account can be approved at a time, so approving the
230      * zero address clears previous approvals.
231      *
232      * Requirements:
233      *
234      * - The caller must own the token or be an approved operator.
235      * - `tokenId` must exist.
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address to, uint256 tokenId) external payable;
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom}
244      * for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}.
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 
270     // =============================================================
271     //                        IERC721Metadata
272     // =============================================================
273 
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 
289     // =============================================================
290     //                           IERC2309
291     // =============================================================
292 
293     /**
294      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
295      * (inclusive) is transferred from `from` to `to`, as defined in the
296      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
297      *
298      * See {_mintERC2309} for more details.
299      */
300     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
301 }
302 
303 /**
304  * @title ERC721A
305  *
306  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
307  * Non-Fungible Token Standard, including the Metadata extension.
308  * Optimized for lower gas during batch mints.
309  *
310  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
311  * starting from `_startTokenId()`.
312  *
313  * Assumptions:
314  *
315  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
316  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
317  */
318 interface ERC721A__IERC721Receiver {
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 /**
328  * @title ERC721A
329  *
330  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
331  * Non-Fungible Token Standard, including the Metadata extension.
332  * Optimized for lower gas during batch mints.
333  *
334  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
335  * starting from `_startTokenId()`.
336  *
337  * Assumptions:
338  *
339  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
340  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
341  */
342 contract ERC721A is IERC721A {
343     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
344     struct TokenApprovalRef {
345         address value;
346     }
347 
348     // =============================================================
349     //                           CONSTANTS
350     // =============================================================
351 
352     // Mask of an entry in packed address data.
353     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
354 
355     // The bit position of `numberMinted` in packed address data.
356     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
357 
358     // The bit position of `numberBurned` in packed address data.
359     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
360 
361     // The bit position of `aux` in packed address data.
362     uint256 private constant _BITPOS_AUX = 192;
363 
364     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
365     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
366 
367     // The bit position of `startTimestamp` in packed ownership.
368     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
369 
370     // The bit mask of the `burned` bit in packed ownership.
371     uint256 private constant _BITMASK_BURNED = 1 << 224;
372 
373     // The bit position of the `nextInitialized` bit in packed ownership.
374     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
375 
376     // The bit mask of the `nextInitialized` bit in packed ownership.
377     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
378 
379     // The bit position of `extraData` in packed ownership.
380     uint256 private constant _BITPOS_EXTRA_DATA = 232;
381 
382     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
383     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
384 
385     // The mask of the lower 160 bits for addresses.
386     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
387 
388     // The maximum `quantity` that can be minted with {_mintERC2309}.
389     // This limit is to prevent overflows on the address data entries.
390     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
391     // is required to cause an overflow, which is unrealistic.
392     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
393 
394     // The `Transfer` event signature is given by:
395     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
396     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
397         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
398 
399     // =============================================================
400     //                            STORAGE
401     // =============================================================
402 
403     // The next token ID to be minted.
404     uint256 private _currentIndex;
405 
406     // The number of tokens burned.
407     uint256 private _burnCounter;
408 
409     // Token name
410     string private _name;
411 
412     // Token symbol
413     string private _symbol;
414 
415     // Mapping from token ID to ownership details
416     // An empty struct value does not necessarily mean the token is unowned.
417     // See {_packedOwnershipOf} implementation for details.
418     //
419     // Bits Layout:
420     // - [0..159]   `addr`
421     // - [160..223] `startTimestamp`
422     // - [224]      `burned`
423     // - [225]      `nextInitialized`
424     // - [232..255] `extraData`
425     mapping(uint256 => uint256) private _packedOwnerships;
426 
427     // Mapping owner address to address data.
428     //
429     // Bits Layout:
430     // - [0..63]    `balance`
431     // - [64..127]  `numberMinted`
432     // - [128..191] `numberBurned`
433     // - [192..255] `aux`
434     mapping(address => uint256) private _packedAddressData;
435 
436     // Mapping from token ID to approved address.
437     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
438 
439     // Mapping from owner to operator approvals
440     mapping(address => mapping(address => bool)) private _operatorApprovals;
441 
442     // =============================================================
443     //                          CONSTRUCTOR
444     // =============================================================
445 
446     constructor(string memory name_, string memory symbol_) {
447         _name = name_;
448         _symbol = symbol_;
449         _currentIndex = _startTokenId();
450     }
451 
452     // =============================================================
453     //                   TOKEN COUNTING OPERATIONS
454     // =============================================================
455 
456     /**
457      * @dev Returns the starting token ID.
458      * To change the starting token ID, please override this function.
459      */
460     function _startTokenId() internal view virtual returns (uint256) {
461         return 0;
462     }
463 
464     /**
465      * @dev Returns the next token ID to be minted.
466      */
467     function _nextTokenId() internal view virtual returns (uint256) {
468         return _currentIndex;
469     }
470 
471     /**
472      * @dev Returns the total number of tokens in existence.
473      * Burned tokens will reduce the count.
474      * To get the total number of tokens minted, please see {_totalMinted}.
475      */
476     function totalSupply() public view virtual override returns (uint256) {
477         // Counter underflow is impossible as _burnCounter cannot be incremented
478         // more than `_currentIndex - _startTokenId()` times.
479         unchecked {
480             return _currentIndex - _burnCounter - _startTokenId();
481         }
482     }
483 
484     /**
485      * @dev Returns the total amount of tokens minted in the contract.
486      */
487     function _totalMinted() internal view virtual returns (uint256) {
488         // Counter underflow is impossible as `_currentIndex` does not decrement,
489         // and it is initialized to `_startTokenId()`.
490         unchecked {
491             return _currentIndex - _startTokenId();
492         }
493     }
494 
495     /**
496      * @dev Returns the total number of tokens burned.
497      */
498     function _totalBurned() internal view virtual returns (uint256) {
499         return _burnCounter;
500     }
501 
502     // =============================================================
503     //                    ADDRESS DATA OPERATIONS
504     // =============================================================
505 
506     /**
507      * @dev Returns the number of tokens in `owner`'s account.
508      */
509     function balanceOf(address owner) public view virtual override returns (uint256) {
510         if (owner == address(0)) revert BalanceQueryForZeroAddress();
511         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     /**
515      * Returns the number of tokens minted by `owner`.
516      */
517     function _numberMinted(address owner) internal view returns (uint256) {
518         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     /**
522      * Returns the number of tokens burned by or on behalf of `owner`.
523      */
524     function _numberBurned(address owner) internal view returns (uint256) {
525         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
526     }
527 
528     /**
529      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
530      */
531     function _getAux(address owner) internal view returns (uint64) {
532         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
533     }
534 
535     /**
536      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
537      * If there are multiple variables, please pack them into a uint64.
538      */
539     function _setAux(address owner, uint64 aux) internal virtual {
540         uint256 packed = _packedAddressData[owner];
541         uint256 auxCasted;
542         // Cast `aux` with assembly to avoid redundant masking.
543         assembly {
544             auxCasted := aux
545         }
546         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
547         _packedAddressData[owner] = packed;
548     }
549 
550     // =============================================================
551     //                            IERC165
552     // =============================================================
553 
554     /**
555      * @dev Returns true if this contract implements the interface defined by
556      * `interfaceId`. See the corresponding
557      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
558      * to learn more about how these ids are created.
559      *
560      * This function call must use less than 30000 gas.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         // The interface IDs are constants representing the first 4 bytes
564         // of the XOR of all function selectors in the interface.
565         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
566         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
567         return
568             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
569             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
570             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
571     }
572 
573     // =============================================================
574     //                        IERC721Metadata
575     // =============================================================
576 
577     /**
578      * @dev Returns the token collection name.
579      */
580     function name() public view virtual override returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev Returns the token collection symbol.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     /**
592      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
593      */
594     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
595         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
596 
597         string memory baseURI = _baseURI();
598         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
599     }
600 
601     /**
602      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
603      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
604      * by default, it can be overridden in child contracts.
605      */
606     function _baseURI() internal view virtual returns (string memory) {
607         return '';
608     }
609 
610     // =============================================================
611     //                     OWNERSHIPS OPERATIONS
612     // =============================================================
613 
614     /**
615      * @dev Returns the owner of the `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         return address(uint160(_packedOwnershipOf(tokenId)));
623     }
624 
625     /**
626      * @dev Gas spent here starts off proportional to the maximum mint batch size.
627      * It gradually moves to O(1) as tokens get transferred around over time.
628      */
629     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
630         return _unpackedOwnership(_packedOwnershipOf(tokenId));
631     }
632 
633     /**
634      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
635      */
636     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
637         return _unpackedOwnership(_packedOwnerships[index]);
638     }
639 
640     /**
641      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
642      */
643     function _initializeOwnershipAt(uint256 index) internal virtual {
644         if (_packedOwnerships[index] == 0) {
645             _packedOwnerships[index] = _packedOwnershipOf(index);
646         }
647     }
648 
649     /**
650      * Returns the packed ownership data of `tokenId`.
651      */
652     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
653         uint256 curr = tokenId;
654 
655         unchecked {
656             if (_startTokenId() <= curr)
657                 if (curr < _currentIndex) {
658                     uint256 packed = _packedOwnerships[curr];
659                     // If not burned.
660                     if (packed & _BITMASK_BURNED == 0) {
661                         // Invariant:
662                         // There will always be an initialized ownership slot
663                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
664                         // before an unintialized ownership slot
665                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
666                         // Hence, `curr` will not underflow.
667                         //
668                         // We can directly compare the packed value.
669                         // If the address is zero, packed will be zero.
670                         while (packed == 0) {
671                             packed = _packedOwnerships[--curr];
672                         }
673                         return packed;
674                     }
675                 }
676         }
677         revert OwnerQueryForNonexistentToken();
678     }
679 
680     /**
681      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
682      */
683     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
684         ownership.addr = address(uint160(packed));
685         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
686         ownership.burned = packed & _BITMASK_BURNED != 0;
687         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
688     }
689 
690     /**
691      * @dev Packs ownership data into a single uint256.
692      */
693     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
694         assembly {
695             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
696             owner := and(owner, _BITMASK_ADDRESS)
697             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
698             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
699         }
700     }
701 
702     /**
703      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
704      */
705     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
706         // For branchless setting of the `nextInitialized` flag.
707         assembly {
708             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
709             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
710         }
711     }
712 
713     // =============================================================
714     //                      APPROVAL OPERATIONS
715     // =============================================================
716 
717     /**
718      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
719      * The approval is cleared when the token is transferred.
720      *
721      * Only a single account can be approved at a time, so approving the
722      * zero address clears previous approvals.
723      *
724      * Requirements:
725      *
726      * - The caller must own the token or be an approved operator.
727      * - `tokenId` must exist.
728      *
729      * Emits an {Approval} event.
730      */
731     function approve(address to, uint256 tokenId) public payable virtual override {
732         address owner = ownerOf(tokenId);
733 
734         if (_msgSenderERC721A() != owner)
735             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
736                 revert ApprovalCallerNotOwnerNorApproved();
737             }
738 
739         _tokenApprovals[tokenId].value = to;
740         emit Approval(owner, to, tokenId);
741     }
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) public view virtual override returns (address) {
751         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
752 
753         return _tokenApprovals[tokenId].value;
754     }
755 
756     /**
757      * @dev Approve or remove `operator` as an operator for the caller.
758      * Operators can call {transferFrom} or {safeTransferFrom}
759      * for any token owned by the caller.
760      *
761      * Requirements:
762      *
763      * - The `operator` cannot be the caller.
764      *
765      * Emits an {ApprovalForAll} event.
766      */
767     function setApprovalForAll(address operator, bool approved) public virtual override {
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
822         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
850     ) public payable virtual override {
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
916     ) public payable virtual override {
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
940     ) public payable virtual override {
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
1070             // The duplicated `log4` removes an extra check and reduces stack juggling.
1071             // The assembly, together with the surrounding Solidity code, have been
1072             // delicately arranged to nudge the compiler into producing optimized opcodes.
1073             assembly {
1074                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1075                 toMasked := and(to, _BITMASK_ADDRESS)
1076                 // Emit the `Transfer` event.
1077                 log4(
1078                     0, // Start of data (0, since no data).
1079                     0, // End of data (0, since no data).
1080                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1081                     0, // `address(0)`.
1082                     toMasked, // `to`.
1083                     startTokenId // `tokenId`.
1084                 )
1085 
1086                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1087                 // that overflows uint256 will make the loop run out of gas.
1088                 // The compiler will optimize the `iszero` away for performance.
1089                 for {
1090                     let tokenId := add(startTokenId, 1)
1091                 } iszero(eq(tokenId, end)) {
1092                     tokenId := add(tokenId, 1)
1093                 } {
1094                     // Emit the `Transfer` event. Similar to above.
1095                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1096                 }
1097             }
1098             if (toMasked == 0) revert MintToZeroAddress();
1099 
1100             _currentIndex = end;
1101         }
1102         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1103     }
1104 
1105     /**
1106      * @dev Mints `quantity` tokens and transfers them to `to`.
1107      *
1108      * This function is intended for efficient minting only during contract creation.
1109      *
1110      * It emits only one {ConsecutiveTransfer} as defined in
1111      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1112      * instead of a sequence of {Transfer} event(s).
1113      *
1114      * Calling this function outside of contract creation WILL make your contract
1115      * non-compliant with the ERC721 standard.
1116      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1117      * {ConsecutiveTransfer} event is only permissible during contract creation.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `quantity` must be greater than 0.
1123      *
1124      * Emits a {ConsecutiveTransfer} event.
1125      */
1126     function _mintERC2309(address to, uint256 quantity) internal virtual {
1127         uint256 startTokenId = _currentIndex;
1128         if (to == address(0)) revert MintToZeroAddress();
1129         if (quantity == 0) revert MintZeroQuantity();
1130         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1135         unchecked {
1136             // Updates:
1137             // - `balance += quantity`.
1138             // - `numberMinted += quantity`.
1139             //
1140             // We can directly add to the `balance` and `numberMinted`.
1141             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1142 
1143             // Updates:
1144             // - `address` to the owner.
1145             // - `startTimestamp` to the timestamp of minting.
1146             // - `burned` to `false`.
1147             // - `nextInitialized` to `quantity == 1`.
1148             _packedOwnerships[startTokenId] = _packOwnershipData(
1149                 to,
1150                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1151             );
1152 
1153             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1154 
1155             _currentIndex = startTokenId + quantity;
1156         }
1157         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1158     }
1159 
1160     /**
1161      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1162      *
1163      * Requirements:
1164      *
1165      * - If `to` refers to a smart contract, it must implement
1166      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1167      * - `quantity` must be greater than 0.
1168      *
1169      * See {_mint}.
1170      *
1171      * Emits a {Transfer} event for each mint.
1172      */
1173     function _safeMint(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data
1177     ) internal virtual {
1178         _mint(to, quantity);
1179 
1180         unchecked {
1181             if (to.code.length != 0) {
1182                 uint256 end = _currentIndex;
1183                 uint256 index = end - quantity;
1184                 do {
1185                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1186                         revert TransferToNonERC721ReceiverImplementer();
1187                     }
1188                 } while (index < end);
1189                 // Reentrancy protection.
1190                 if (_currentIndex != end) revert();
1191             }
1192         }
1193     }
1194 
1195     /**
1196      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1197      */
1198     function _safeMint(address to, uint256 quantity) internal virtual {
1199         _safeMint(to, quantity, '');
1200     }
1201 
1202     // =============================================================
1203     //                        BURN OPERATIONS
1204     // =============================================================
1205 
1206     /**
1207      * @dev Equivalent to `_burn(tokenId, false)`.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         _burn(tokenId, false);
1211     }
1212 
1213     /**
1214      * @dev Destroys `tokenId`.
1215      * The approval is cleared when the token is burned.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1224         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1225 
1226         address from = address(uint160(prevOwnershipPacked));
1227 
1228         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1229 
1230         if (approvalCheck) {
1231             // The nested ifs save around 20+ gas over a compound boolean condition.
1232             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1233                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1234         }
1235 
1236         _beforeTokenTransfers(from, address(0), tokenId, 1);
1237 
1238         // Clear approvals from the previous owner.
1239         assembly {
1240             if approvedAddress {
1241                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1242                 sstore(approvedAddressSlot, 0)
1243             }
1244         }
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1249         unchecked {
1250             // Updates:
1251             // - `balance -= 1`.
1252             // - `numberBurned += 1`.
1253             //
1254             // We can directly decrement the balance, and increment the number burned.
1255             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1256             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1257 
1258             // Updates:
1259             // - `address` to the last owner.
1260             // - `startTimestamp` to the timestamp of burning.
1261             // - `burned` to `true`.
1262             // - `nextInitialized` to `true`.
1263             _packedOwnerships[tokenId] = _packOwnershipData(
1264                 from,
1265                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1266             );
1267 
1268             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1269             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1270                 uint256 nextTokenId = tokenId + 1;
1271                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1272                 if (_packedOwnerships[nextTokenId] == 0) {
1273                     // If the next slot is within bounds.
1274                     if (nextTokenId != _currentIndex) {
1275                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1276                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1277                     }
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, address(0), tokenId);
1283         _afterTokenTransfers(from, address(0), tokenId, 1);
1284 
1285         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1286         unchecked {
1287             _burnCounter++;
1288         }
1289     }
1290 
1291     // =============================================================
1292     //                     EXTRA DATA OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Directly sets the extra data for the ownership data `index`.
1297      */
1298     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1299         uint256 packed = _packedOwnerships[index];
1300         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1301         uint256 extraDataCasted;
1302         // Cast `extraData` with assembly to avoid redundant masking.
1303         assembly {
1304             extraDataCasted := extraData
1305         }
1306         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1307         _packedOwnerships[index] = packed;
1308     }
1309 
1310     /**
1311      * @dev Called during each token transfer to set the 24bit `extraData` field.
1312      * Intended to be overridden by the cosumer contract.
1313      *
1314      * `previousExtraData` - the value of `extraData` before transfer.
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _extraData(
1325         address from,
1326         address to,
1327         uint24 previousExtraData
1328     ) internal view virtual returns (uint24) {}
1329 
1330     /**
1331      * @dev Returns the next extra data for the packed ownership data.
1332      * The returned result is shifted into position.
1333      */
1334     function _nextExtraData(
1335         address from,
1336         address to,
1337         uint256 prevOwnershipPacked
1338     ) private view returns (uint256) {
1339         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1340         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1341     }
1342 
1343     // =============================================================
1344     //                       OTHER OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Returns the message sender (defaults to `msg.sender`).
1349      *
1350      * If you are writing GSN compatible contracts, you need to override this function.
1351      */
1352     function _msgSenderERC721A() internal view virtual returns (address) {
1353         return msg.sender;
1354     }
1355 
1356     /**
1357      * @dev Converts a uint256 to its ASCII string decimal representation.
1358      */
1359     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1360         assembly {
1361             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1362             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1363             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1364             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1365             let m := add(mload(0x40), 0xa0)
1366             // Update the free memory pointer to allocate.
1367             mstore(0x40, m)
1368             // Assign the `str` to the end.
1369             str := sub(m, 0x20)
1370             // Zeroize the slot after the string.
1371             mstore(str, 0)
1372 
1373             // Cache the end of the memory to calculate the length later.
1374             let end := str
1375 
1376             // We write the string from rightmost digit to leftmost digit.
1377             // The following is essentially a do-while loop that also handles the zero case.
1378             // prettier-ignore
1379             for { let temp := value } 1 {} {
1380                 str := sub(str, 1)
1381                 // Write the character to the pointer.
1382                 // The ASCII index of the '0' character is 48.
1383                 mstore8(str, add(48, mod(temp, 10)))
1384                 // Keep dividing `temp` until zero.
1385                 temp := div(temp, 10)
1386                 // prettier-ignore
1387                 if iszero(temp) { break }
1388             }
1389 
1390             let length := sub(end, str)
1391             // Move the pointer 32 bytes leftwards to make room for the length.
1392             str := sub(str, 0x20)
1393             // Store the length.
1394             mstore(str, length)
1395         }
1396     }
1397 }
1398 
1399 
1400 interface IOperatorFilterRegistry {
1401     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1402     function register(address registrant) external;
1403     function registerAndSubscribe(address registrant, address subscription) external;
1404     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1405     function unregister(address addr) external;
1406     function updateOperator(address registrant, address operator, bool filtered) external;
1407     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1408     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1409     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1410     function subscribe(address registrant, address registrantToSubscribe) external;
1411     function unsubscribe(address registrant, bool copyExistingEntries) external;
1412     function subscriptionOf(address addr) external returns (address registrant);
1413     function subscribers(address registrant) external returns (address[] memory);
1414     function subscriberAt(address registrant, uint256 index) external returns (address);
1415     function copyEntriesOf(address registrant, address registrantToCopy) external;
1416     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1417     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1418     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1419     function filteredOperators(address addr) external returns (address[] memory);
1420     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1421     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1422     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1423     function isRegistered(address addr) external returns (bool);
1424     function codeHashOf(address addr) external returns (bytes32);
1425 }
1426 
1427 
1428 /**
1429  * @title  OperatorFilterer
1430  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1431  *         registrant's entries in the OperatorFilterRegistry.
1432  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1433  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1434  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1435  */
1436 abstract contract OperatorFilterer {
1437     error OperatorNotAllowed(address operator);
1438 
1439     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1440         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1441 
1442     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1443         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1444         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1445         // order for the modifier to filter addresses.
1446         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1447             if (subscribe) {
1448                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1449             } else {
1450                 if (subscriptionOrRegistrantToCopy != address(0)) {
1451                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1452                 } else {
1453                     OPERATOR_FILTER_REGISTRY.register(address(this));
1454                 }
1455             }
1456         }
1457     }
1458 
1459     modifier onlyAllowedOperator(address from) virtual {
1460         // Check registry code length to facilitate testing in environments without a deployed registry.
1461         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1462             // Allow spending tokens from addresses with balance
1463             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1464             // from an EOA.
1465             if (from == msg.sender) {
1466                 _;
1467                 return;
1468             }
1469             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1470                 revert OperatorNotAllowed(msg.sender);
1471             }
1472         }
1473         _;
1474     }
1475 
1476     modifier onlyAllowedOperatorApproval(address operator) virtual {
1477         // Check registry code length to facilitate testing in environments without a deployed registry.
1478         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1479             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1480                 revert OperatorNotAllowed(operator);
1481             }
1482         }
1483         _;
1484     }
1485 }
1486 
1487 /**
1488  * @title  DefaultOperatorFilterer
1489  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1490  */
1491 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1492     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1493 
1494     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1495 }
1496 
1497 
1498 contract GoodBye2022 is ERC721A, DefaultOperatorFilterer {
1499     /// @notice Reference to the handler contract for transfer hooks
1500 
1501     address public beforeTokenTransferHandler;
1502     address public paymentSplitterAddress;
1503     uint256 public currentTokenId = 1;
1504     uint256 public maxSupply = 999;
1505     uint256 public mintPhase = 0;
1506     uint256 public price = 0.002 ether;     
1507     uint256 public publicMintCost = 0.002 ether;
1508     uint256 public whitelistMintCost = 0.002 ether;
1509     mapping (address => bool) public isWhitelisted;
1510    
1511     string public baseURI = "ipfs://bafybeifc7a4sahin3qmmsbjlkweic6w3dc56qpyncmipzw236wzupihswe/";         
1512     uint256 public maxPerTx = 10;   
1513     uint256 private _baseGasLimit = 80000;
1514     uint256 private _baseDifficulty = 10;
1515     uint256 private _difficultyBais = 120;
1516 
1517     function mint(uint256 amount) payable public {
1518         require(totalSupply() + amount <= maxSupply);
1519         require(amount <= maxPerTx);
1520         require(msg.value >= amount * price);
1521         _safeMint(msg.sender, amount);
1522     }
1523 
1524     function _baseURI() internal view virtual override returns (string memory) {
1525         return baseURI;
1526     }
1527 
1528     function setBaseURI(string memory baseURI_) external onlyOwner {
1529         baseURI = baseURI_;
1530     }     
1531 
1532     function mint() public {
1533         require(gasleft() > _baseGasLimit);       
1534         if (!raffle()) return;
1535         require(msg.sender == tx.origin);
1536         require(totalSupply() + 1 <= maxSupply);
1537         require(balanceOf(msg.sender) == 0);
1538         _safeMint(msg.sender, 1);
1539     }
1540 
1541     function raffle() public view returns(bool) {
1542         uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
1543         return num > difficulty();
1544     }
1545 
1546     function difficulty() public view returns(uint256) {
1547         return _baseDifficulty + totalSupply() * _difficultyBais / maxSupply;
1548     }
1549 
1550     address public owner;
1551     modifier onlyOwner {
1552         require(owner == msg.sender);
1553         _;
1554     }
1555 
1556     constructor() ERC721A("Good Bye 2022", "GB2022") {
1557         owner = msg.sender;
1558     }
1559     
1560     // function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1561     //     uint256 royaltyAmount = (_salePrice * 50) / 1000;
1562     //     return (owner, royaltyAmount);
1563     // }
1564     
1565     function withdraw() external onlyOwner {
1566         payable(msg.sender).transfer(address(this).balance);
1567     }
1568 
1569     /////////////////////////////
1570     // OPENSEA FILTER REGISTRY 
1571     /////////////////////////////
1572 
1573     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1574         super.setApprovalForAll(operator, approved);
1575     }
1576 
1577     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1578         super.approve(operator, tokenId);
1579     }
1580 
1581     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1582         super.transferFrom(from, to, tokenId);
1583     }
1584 
1585     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1586         super.safeTransferFrom(from, to, tokenId);
1587     }
1588 
1589     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1590         public
1591         payable
1592         override
1593         onlyAllowedOperator(from)
1594     {
1595         super.safeTransferFrom(from, to, tokenId, data);
1596     }
1597 }