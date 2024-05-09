1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/IERC721A.sol
4 
5 
6 // ERC721A Contracts v4.2.3
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of ERC721A.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * Cannot query the balance for the zero address.
27      */
28     error BalanceQueryForZeroAddress();
29 
30     /**
31      * Cannot mint to the zero address.
32      */
33     error MintToZeroAddress();
34 
35     /**
36      * The quantity of tokens minted must be more than zero.
37      */
38     error MintZeroQuantity();
39 
40     /**
41      * The token does not exist.
42      */
43     error OwnerQueryForNonexistentToken();
44 
45     /**
46      * The caller must own the token or be an approved operator.
47      */
48     error TransferCallerNotOwnerNorApproved();
49 
50     /**
51      * The token must be owned by `from`.
52      */
53     error TransferFromIncorrectOwner();
54 
55     /**
56      * Cannot safely transfer to a contract that does not implement the
57      * ERC721Receiver interface.
58      */
59     error TransferToNonERC721ReceiverImplementer();
60 
61     /**
62      * Cannot transfer to the zero address.
63      */
64     error TransferToZeroAddress();
65 
66     /**
67      * The token does not exist.
68      */
69     error URIQueryForNonexistentToken();
70 
71     /**
72      * The `quantity` minted with ERC2309 exceeds the safety limit.
73      */
74     error MintERC2309QuantityExceedsLimit();
75 
76     /**
77      * The `extraData` cannot be set on an unintialized ownership slot.
78      */
79     error OwnershipNotInitializedForExtraData();
80 
81     // =============================================================
82     //                            STRUCTS
83     // =============================================================
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Stores the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
93         uint24 extraData;
94     }
95 
96     // =============================================================
97     //                         TOKEN COUNTERS
98     // =============================================================
99 
100     /**
101      * @dev Returns the total number of tokens in existence.
102      * Burned tokens will reduce the count.
103      * To get the total number of tokens minted, please see {_totalMinted}.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     // =============================================================
108     //                            IERC165
109     // =============================================================
110 
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 
121     // =============================================================
122     //                            IERC721
123     // =============================================================
124 
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables
137      * (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in `owner`'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`,
157      * checking first that contract recipients are aware of the ERC721 protocol
158      * to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move
166      * this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement
168      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external payable;
178 
179     /**
180      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external payable;
187 
188     /**
189      * @dev Transfers `tokenId` from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
192      * whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token
200      * by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external payable;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the
215      * zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external payable;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom}
229      * for any token owned by the caller.
230      *
231      * Requirements:
232      *
233      * - The `operator` cannot be the caller.
234      *
235      * Emits an {ApprovalForAll} event.
236      */
237     function setApprovalForAll(address operator, bool _approved) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
250      *
251      * See {setApprovalForAll}.
252      */
253     function isApprovedForAll(address owner, address operator) external view returns (bool);
254 
255     // =============================================================
256     //                        IERC721Metadata
257     // =============================================================
258 
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 
274     // =============================================================
275     //                           IERC2309
276     // =============================================================
277 
278     /**
279      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
280      * (inclusive) is transferred from `from` to `to`, as defined in the
281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
282      *
283      * See {_mintERC2309} for more details.
284      */
285     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
286 }
287 // File: contracts/IERC721AQueryable.sol
288 
289 
290 // ERC721A Contracts v4.2.3
291 // Creator: Chiru Labs
292 
293 pragma solidity ^0.8.4;
294 
295 
296 /**
297  * @dev Interface of ERC721AQueryable.
298  */
299 interface IERC721AQueryable is IERC721A {
300     /**
301      * Invalid query range (`start` >= `stop`).
302      */
303     error InvalidQueryRange();
304 
305     /**
306      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
307      *
308      * If the `tokenId` is out of bounds:
309      *
310      * - `addr = address(0)`
311      * - `startTimestamp = 0`
312      * - `burned = false`
313      * - `extraData = 0`
314      *
315      * If the `tokenId` is burned:
316      *
317      * - `addr = <Address of owner before token was burned>`
318      * - `startTimestamp = <Timestamp when token was burned>`
319      * - `burned = true`
320      * - `extraData = <Extra data when token was burned>`
321      *
322      * Otherwise:
323      *
324      * - `addr = <Address of owner>`
325      * - `startTimestamp = <Timestamp of start of ownership>`
326      * - `burned = false`
327      * - `extraData = <Extra data at start of ownership>`
328      */
329     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
330 
331     /**
332      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
333      * See {ERC721AQueryable-explicitOwnershipOf}
334      */
335     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
336 
337     /**
338      * @dev Returns an array of token IDs owned by `owner`,
339      * in the range [`start`, `stop`)
340      * (i.e. `start <= tokenId < stop`).
341      *
342      * This function allows for tokens to be queried if the collection
343      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
344      *
345      * Requirements:
346      *
347      * - `start < stop`
348      */
349     function tokensOfOwnerIn(
350         address owner,
351         uint256 start,
352         uint256 stop
353     ) external view returns (uint256[] memory);
354 
355     /**
356      * @dev Returns an array of token IDs owned by `owner`.
357      *
358      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
359      * It is meant to be called off-chain.
360      *
361      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
362      * multiple smaller scans if the collection is large enough to cause
363      * an out-of-gas error (10K collections should be fine).
364      */
365     function tokensOfOwner(address owner) external view returns (uint256[] memory);
366 }
367 // File: contracts/ERC721A.sol
368 
369 
370 // ERC721A Contracts v4.2.3
371 // Creator: Chiru Labs
372 
373 pragma solidity ^0.8.4;
374 
375 
376 /**
377  * @dev Interface of ERC721 token receiver.
378  */
379 interface ERC721A__IERC721Receiver {
380     function onERC721Received(
381         address operator,
382         address from,
383         uint256 tokenId,
384         bytes calldata data
385     ) external returns (bytes4);
386 }
387 
388 /**
389  * @title ERC721A
390  *
391  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
392  * Non-Fungible Token Standard, including the Metadata extension.
393  * Optimized for lower gas during batch mints.
394  *
395  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
396  * starting from `_startTokenId()`.
397  *
398  * Assumptions:
399  *
400  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
401  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
402  */
403 contract ERC721A is IERC721A {
404     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
405     struct TokenApprovalRef {
406         address value;
407     }
408 
409     // =============================================================
410     //                           CONSTANTS
411     // =============================================================
412 
413     // Mask of an entry in packed address data.
414     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
415 
416     // The bit position of `numberMinted` in packed address data.
417     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
418 
419     // The bit position of `numberBurned` in packed address data.
420     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
421 
422     // The bit position of `aux` in packed address data.
423     uint256 private constant _BITPOS_AUX = 192;
424 
425     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
426     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
427 
428     // The bit position of `startTimestamp` in packed ownership.
429     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
430 
431     // The bit mask of the `burned` bit in packed ownership.
432     uint256 private constant _BITMASK_BURNED = 1 << 224;
433 
434     // The bit position of the `nextInitialized` bit in packed ownership.
435     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
436 
437     // The bit mask of the `nextInitialized` bit in packed ownership.
438     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
439 
440     // The bit position of `extraData` in packed ownership.
441     uint256 private constant _BITPOS_EXTRA_DATA = 232;
442 
443     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
444     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
445 
446     // The mask of the lower 160 bits for addresses.
447     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
448 
449     // The maximum `quantity` that can be minted with {_mintERC2309}.
450     // This limit is to prevent overflows on the address data entries.
451     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
452     // is required to cause an overflow, which is unrealistic.
453     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
454 
455     // The `Transfer` event signature is given by:
456     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
457     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
458         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
459 
460     // =============================================================
461     //                            STORAGE
462     // =============================================================
463 
464     // The next token ID to be minted.
465     uint256 private _currentIndex;
466 
467     // The number of tokens burned.
468     uint256 private _burnCounter;
469 
470     // Token name
471     string private _name;
472 
473     // Token symbol
474     string private _symbol;
475 
476     // Mapping from token ID to ownership details
477     // An empty struct value does not necessarily mean the token is unowned.
478     // See {_packedOwnershipOf} implementation for details.
479     //
480     // Bits Layout:
481     // - [0..159]   `addr`
482     // - [160..223] `startTimestamp`
483     // - [224]      `burned`
484     // - [225]      `nextInitialized`
485     // - [232..255] `extraData`
486     mapping(uint256 => uint256) private _packedOwnerships;
487 
488     // Mapping owner address to address data.
489     //
490     // Bits Layout:
491     // - [0..63]    `balance`
492     // - [64..127]  `numberMinted`
493     // - [128..191] `numberBurned`
494     // - [192..255] `aux`
495     mapping(address => uint256) private _packedAddressData;
496 
497     // Mapping from token ID to approved address.
498     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
499 
500     // Mapping from owner to operator approvals
501     mapping(address => mapping(address => bool)) private _operatorApprovals;
502 
503     // =============================================================
504     //                          CONSTRUCTOR
505     // =============================================================
506 
507     constructor(string memory name_, string memory symbol_) {
508         _name = name_;
509         _symbol = symbol_;
510         _currentIndex = _startTokenId();
511     }
512 
513     // =============================================================
514     //                   TOKEN COUNTING OPERATIONS
515     // =============================================================
516 
517     /**
518      * @dev Returns the starting token ID.
519      * To change the starting token ID, please override this function.
520      */
521     function _startTokenId() internal view virtual returns (uint256) {
522         return 0;
523     }
524 
525     /**
526      * @dev Returns the next token ID to be minted.
527      */
528     function _nextTokenId() internal view virtual returns (uint256) {
529         return _currentIndex;
530     }
531 
532     /**
533      * @dev Returns the total number of tokens in existence.
534      * Burned tokens will reduce the count.
535      * To get the total number of tokens minted, please see {_totalMinted}.
536      */
537     function totalSupply() public view virtual override returns (uint256) {
538         // Counter underflow is impossible as _burnCounter cannot be incremented
539         // more than `_currentIndex - _startTokenId()` times.
540         unchecked {
541             return _currentIndex - _burnCounter - _startTokenId();
542         }
543     }
544 
545     /**
546      * @dev Returns the total amount of tokens minted in the contract.
547      */
548     function _totalMinted() internal view virtual returns (uint256) {
549         // Counter underflow is impossible as `_currentIndex` does not decrement,
550         // and it is initialized to `_startTokenId()`.
551         unchecked {
552             return _currentIndex - _startTokenId();
553         }
554     }
555 
556     /**
557      * @dev Returns the total number of tokens burned.
558      */
559     function _totalBurned() internal view virtual returns (uint256) {
560         return _burnCounter;
561     }
562 
563     // =============================================================
564     //                    ADDRESS DATA OPERATIONS
565     // =============================================================
566 
567     /**
568      * @dev Returns the number of tokens in `owner`'s account.
569      */
570     function balanceOf(address owner) public view virtual override returns (uint256) {
571         if (owner == address(0)) revert BalanceQueryForZeroAddress();
572         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
573     }
574 
575     /**
576      * Returns the number of tokens minted by `owner`.
577      */
578     function _numberMinted(address owner) internal view returns (uint256) {
579         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
580     }
581 
582     /**
583      * Returns the number of tokens burned by or on behalf of `owner`.
584      */
585     function _numberBurned(address owner) internal view returns (uint256) {
586         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
587     }
588 
589     /**
590      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
591      */
592     function _getAux(address owner) internal view returns (uint64) {
593         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
594     }
595 
596     /**
597      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
598      * If there are multiple variables, please pack them into a uint64.
599      */
600     function _setAux(address owner, uint64 aux) internal virtual {
601         uint256 packed = _packedAddressData[owner];
602         uint256 auxCasted;
603         // Cast `aux` with assembly to avoid redundant masking.
604         assembly {
605             auxCasted := aux
606         }
607         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
608         _packedAddressData[owner] = packed;
609     }
610 
611     // =============================================================
612     //                            IERC165
613     // =============================================================
614 
615     /**
616      * @dev Returns true if this contract implements the interface defined by
617      * `interfaceId`. See the corresponding
618      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
619      * to learn more about how these ids are created.
620      *
621      * This function call must use less than 30000 gas.
622      */
623     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
624         // The interface IDs are constants representing the first 4 bytes
625         // of the XOR of all function selectors in the interface.
626         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
627         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
628         return
629             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
630             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
631             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
632     }
633 
634     // =============================================================
635     //                        IERC721Metadata
636     // =============================================================
637 
638     /**
639      * @dev Returns the token collection name.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev Returns the token collection symbol.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
654      */
655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
656         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
657 
658         string memory baseURI = _baseURI();
659         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
660     }
661 
662     /**
663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
665      * by default, it can be overridden in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return '';
669     }
670 
671     // =============================================================
672     //                     OWNERSHIPS OPERATIONS
673     // =============================================================
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
683         return address(uint160(_packedOwnershipOf(tokenId)));
684     }
685 
686     /**
687      * @dev Gas spent here starts off proportional to the maximum mint batch size.
688      * It gradually moves to O(1) as tokens get transferred around over time.
689      */
690     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
691         return _unpackedOwnership(_packedOwnershipOf(tokenId));
692     }
693 
694     /**
695      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
696      */
697     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
698         return _unpackedOwnership(_packedOwnerships[index]);
699     }
700 
701     /**
702      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
703      */
704     function _initializeOwnershipAt(uint256 index) internal virtual {
705         if (_packedOwnerships[index] == 0) {
706             _packedOwnerships[index] = _packedOwnershipOf(index);
707         }
708     }
709 
710     /**
711      * Returns the packed ownership data of `tokenId`.
712      */
713     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
714         uint256 curr = tokenId;
715 
716         unchecked {
717             if (_startTokenId() <= curr)
718                 if (curr < _currentIndex) {
719                     uint256 packed = _packedOwnerships[curr];
720                     // If not burned.
721                     if (packed & _BITMASK_BURNED == 0) {
722                         // Invariant:
723                         // There will always be an initialized ownership slot
724                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
725                         // before an unintialized ownership slot
726                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
727                         // Hence, `curr` will not underflow.
728                         //
729                         // We can directly compare the packed value.
730                         // If the address is zero, packed will be zero.
731                         while (packed == 0) {
732                             packed = _packedOwnerships[--curr];
733                         }
734                         return packed;
735                     }
736                 }
737         }
738         revert OwnerQueryForNonexistentToken();
739     }
740 
741     /**
742      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
743      */
744     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
745         ownership.addr = address(uint160(packed));
746         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
747         ownership.burned = packed & _BITMASK_BURNED != 0;
748         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
749     }
750 
751     /**
752      * @dev Packs ownership data into a single uint256.
753      */
754     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
755         assembly {
756             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
757             owner := and(owner, _BITMASK_ADDRESS)
758             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
759             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
760         }
761     }
762 
763     /**
764      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
765      */
766     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
767         // For branchless setting of the `nextInitialized` flag.
768         assembly {
769             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
770             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
771         }
772     }
773 
774     // =============================================================
775     //                      APPROVAL OPERATIONS
776     // =============================================================
777 
778     /**
779      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
780      * The approval is cleared when the token is transferred.
781      *
782      * Only a single account can be approved at a time, so approving the
783      * zero address clears previous approvals.
784      *
785      * Requirements:
786      *
787      * - The caller must own the token or be an approved operator.
788      * - `tokenId` must exist.
789      *
790      * Emits an {Approval} event.
791      */
792     function approve(address to, uint256 tokenId) public payable virtual override {
793         address owner = ownerOf(tokenId);
794 
795         if (_msgSenderERC721A() != owner)
796             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
797                 revert ApprovalCallerNotOwnerNorApproved();
798             }
799 
800         _tokenApprovals[tokenId].value = to;
801         emit Approval(owner, to, tokenId);
802     }
803 
804     /**
805      * @dev Returns the account approved for `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function getApproved(uint256 tokenId) public view virtual override returns (address) {
812         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
813 
814         return _tokenApprovals[tokenId].value;
815     }
816 
817     /**
818      * @dev Approve or remove `operator` as an operator for the caller.
819      * Operators can call {transferFrom} or {safeTransferFrom}
820      * for any token owned by the caller.
821      *
822      * Requirements:
823      *
824      * - The `operator` cannot be the caller.
825      *
826      * Emits an {ApprovalForAll} event.
827      */
828     function setApprovalForAll(address operator, bool approved) public virtual override {
829         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
830         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
831     }
832 
833     /**
834      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
835      *
836      * See {setApprovalForAll}.
837      */
838     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
839         return _operatorApprovals[owner][operator];
840     }
841 
842     /**
843      * @dev Returns whether `tokenId` exists.
844      *
845      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
846      *
847      * Tokens start existing when they are minted. See {_mint}.
848      */
849     function _exists(uint256 tokenId) internal view virtual returns (bool) {
850         return
851             _startTokenId() <= tokenId &&
852             tokenId < _currentIndex && // If within bounds,
853             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
854     }
855 
856     /**
857      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
858      */
859     function _isSenderApprovedOrOwner(
860         address approvedAddress,
861         address owner,
862         address msgSender
863     ) private pure returns (bool result) {
864         assembly {
865             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
866             owner := and(owner, _BITMASK_ADDRESS)
867             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
868             msgSender := and(msgSender, _BITMASK_ADDRESS)
869             // `msgSender == owner || msgSender == approvedAddress`.
870             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
871         }
872     }
873 
874     /**
875      * @dev Returns the storage slot and value for the approved address of `tokenId`.
876      */
877     function _getApprovedSlotAndAddress(uint256 tokenId)
878         private
879         view
880         returns (uint256 approvedAddressSlot, address approvedAddress)
881     {
882         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
883         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
884         assembly {
885             approvedAddressSlot := tokenApproval.slot
886             approvedAddress := sload(approvedAddressSlot)
887         }
888     }
889 
890     // =============================================================
891     //                      TRANSFER OPERATIONS
892     // =============================================================
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      * - If the caller is not `from`, it must be approved to move this token
903      * by either {approve} or {setApprovalForAll}.
904      *
905      * Emits a {Transfer} event.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public payable virtual override {
912         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
913 
914         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
915 
916         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
917 
918         // The nested ifs save around 20+ gas over a compound boolean condition.
919         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
920             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
921 
922         if (to == address(0)) revert TransferToZeroAddress();
923 
924         _beforeTokenTransfers(from, to, tokenId, 1);
925 
926         // Clear approvals from the previous owner.
927         assembly {
928             if approvedAddress {
929                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
930                 sstore(approvedAddressSlot, 0)
931             }
932         }
933 
934         // Underflow of the sender's balance is impossible because we check for
935         // ownership above and the recipient's balance can't realistically overflow.
936         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
937         unchecked {
938             // We can directly increment and decrement the balances.
939             --_packedAddressData[from]; // Updates: `balance -= 1`.
940             ++_packedAddressData[to]; // Updates: `balance += 1`.
941 
942             // Updates:
943             // - `address` to the next owner.
944             // - `startTimestamp` to the timestamp of transfering.
945             // - `burned` to `false`.
946             // - `nextInitialized` to `true`.
947             _packedOwnerships[tokenId] = _packOwnershipData(
948                 to,
949                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
950             );
951 
952             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
953             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
954                 uint256 nextTokenId = tokenId + 1;
955                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
956                 if (_packedOwnerships[nextTokenId] == 0) {
957                     // If the next slot is within bounds.
958                     if (nextTokenId != _currentIndex) {
959                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
960                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
961                     }
962                 }
963             }
964         }
965 
966         emit Transfer(from, to, tokenId);
967         _afterTokenTransfers(from, to, tokenId, 1);
968     }
969 
970     /**
971      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public payable virtual override {
978         safeTransferFrom(from, to, tokenId, '');
979     }
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If the caller is not `from`, it must be approved to move this token
990      * by either {approve} or {setApprovalForAll}.
991      * - If `to` refers to a smart contract, it must implement
992      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public payable virtual override {
1002         transferFrom(from, to, tokenId);
1003         if (to.code.length != 0)
1004             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1005                 revert TransferToNonERC721ReceiverImplementer();
1006             }
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before a set of serially-ordered token IDs
1011      * are about to be transferred. This includes minting.
1012      * And also called before burning one token.
1013      *
1014      * `startTokenId` - the first token ID to be transferred.
1015      * `quantity` - the amount to be transferred.
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` will be minted for `to`.
1022      * - When `to` is zero, `tokenId` will be burned by `from`.
1023      * - `from` and `to` are never both zero.
1024      */
1025     function _beforeTokenTransfers(
1026         address from,
1027         address to,
1028         uint256 startTokenId,
1029         uint256 quantity
1030     ) internal virtual {}
1031 
1032     /**
1033      * @dev Hook that is called after a set of serially-ordered token IDs
1034      * have been transferred. This includes minting.
1035      * And also called after one token has been burned.
1036      *
1037      * `startTokenId` - the first token ID to be transferred.
1038      * `quantity` - the amount to be transferred.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` has been minted for `to`.
1045      * - When `to` is zero, `tokenId` has been burned by `from`.
1046      * - `from` and `to` are never both zero.
1047      */
1048     function _afterTokenTransfers(
1049         address from,
1050         address to,
1051         uint256 startTokenId,
1052         uint256 quantity
1053     ) internal virtual {}
1054 
1055     /**
1056      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1057      *
1058      * `from` - Previous owner of the given token ID.
1059      * `to` - Target address that will receive the token.
1060      * `tokenId` - Token ID to be transferred.
1061      * `_data` - Optional data to send along with the call.
1062      *
1063      * Returns whether the call correctly returned the expected magic value.
1064      */
1065     function _checkContractOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1072             bytes4 retval
1073         ) {
1074             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1075         } catch (bytes memory reason) {
1076             if (reason.length == 0) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             } else {
1079                 assembly {
1080                     revert(add(32, reason), mload(reason))
1081                 }
1082             }
1083         }
1084     }
1085 
1086     // =============================================================
1087     //                        MINT OPERATIONS
1088     // =============================================================
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event for each mint.
1099      */
1100     function _mint(address to, uint256 quantity) internal virtual {
1101         uint256 startTokenId = _currentIndex;
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // `balance` and `numberMinted` have a maximum limit of 2**64.
1108         // `tokenId` has a maximum limit of 2**256.
1109         unchecked {
1110             // Updates:
1111             // - `balance += quantity`.
1112             // - `numberMinted += quantity`.
1113             //
1114             // We can directly add to the `balance` and `numberMinted`.
1115             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1116 
1117             // Updates:
1118             // - `address` to the owner.
1119             // - `startTimestamp` to the timestamp of minting.
1120             // - `burned` to `false`.
1121             // - `nextInitialized` to `quantity == 1`.
1122             _packedOwnerships[startTokenId] = _packOwnershipData(
1123                 to,
1124                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1125             );
1126 
1127             uint256 toMasked;
1128             uint256 end = startTokenId + quantity;
1129 
1130             // Use assembly to loop and emit the `Transfer` event for gas savings.
1131             // The duplicated `log4` removes an extra check and reduces stack juggling.
1132             // The assembly, together with the surrounding Solidity code, have been
1133             // delicately arranged to nudge the compiler into producing optimized opcodes.
1134             assembly {
1135                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1136                 toMasked := and(to, _BITMASK_ADDRESS)
1137                 // Emit the `Transfer` event.
1138                 log4(
1139                     0, // Start of data (0, since no data).
1140                     0, // End of data (0, since no data).
1141                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1142                     0, // `address(0)`.
1143                     toMasked, // `to`.
1144                     startTokenId // `tokenId`.
1145                 )
1146 
1147                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1148                 // that overflows uint256 will make the loop run out of gas.
1149                 // The compiler will optimize the `iszero` away for performance.
1150                 for {
1151                     let tokenId := add(startTokenId, 1)
1152                 } iszero(eq(tokenId, end)) {
1153                     tokenId := add(tokenId, 1)
1154                 } {
1155                     // Emit the `Transfer` event. Similar to above.
1156                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1157                 }
1158             }
1159             if (toMasked == 0) revert MintToZeroAddress();
1160 
1161             _currentIndex = end;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     /**
1167      * @dev Mints `quantity` tokens and transfers them to `to`.
1168      *
1169      * This function is intended for efficient minting only during contract creation.
1170      *
1171      * It emits only one {ConsecutiveTransfer} as defined in
1172      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1173      * instead of a sequence of {Transfer} event(s).
1174      *
1175      * Calling this function outside of contract creation WILL make your contract
1176      * non-compliant with the ERC721 standard.
1177      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1178      * {ConsecutiveTransfer} event is only permissible during contract creation.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * Emits a {ConsecutiveTransfer} event.
1186      */
1187     function _mintERC2309(address to, uint256 quantity) internal virtual {
1188         uint256 startTokenId = _currentIndex;
1189         if (to == address(0)) revert MintToZeroAddress();
1190         if (quantity == 0) revert MintZeroQuantity();
1191         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1192 
1193         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1194 
1195         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1196         unchecked {
1197             // Updates:
1198             // - `balance += quantity`.
1199             // - `numberMinted += quantity`.
1200             //
1201             // We can directly add to the `balance` and `numberMinted`.
1202             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1203 
1204             // Updates:
1205             // - `address` to the owner.
1206             // - `startTimestamp` to the timestamp of minting.
1207             // - `burned` to `false`.
1208             // - `nextInitialized` to `quantity == 1`.
1209             _packedOwnerships[startTokenId] = _packOwnershipData(
1210                 to,
1211                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1212             );
1213 
1214             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1215 
1216             _currentIndex = startTokenId + quantity;
1217         }
1218         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1219     }
1220 
1221     /**
1222      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - If `to` refers to a smart contract, it must implement
1227      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1228      * - `quantity` must be greater than 0.
1229      *
1230      * See {_mint}.
1231      *
1232      * Emits a {Transfer} event for each mint.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 quantity,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, quantity);
1240 
1241         unchecked {
1242             if (to.code.length != 0) {
1243                 uint256 end = _currentIndex;
1244                 uint256 index = end - quantity;
1245                 do {
1246                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1247                         revert TransferToNonERC721ReceiverImplementer();
1248                     }
1249                 } while (index < end);
1250                 // Reentrancy protection.
1251                 if (_currentIndex != end) revert();
1252             }
1253         }
1254     }
1255 
1256     /**
1257      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1258      */
1259     function _safeMint(address to, uint256 quantity) internal virtual {
1260         _safeMint(to, quantity, '');
1261     }
1262 
1263     // =============================================================
1264     //                        BURN OPERATIONS
1265     // =============================================================
1266 
1267     /**
1268      * @dev Equivalent to `_burn(tokenId, false)`.
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         _burn(tokenId, false);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1285         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1286 
1287         address from = address(uint160(prevOwnershipPacked));
1288 
1289         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1290 
1291         if (approvalCheck) {
1292             // The nested ifs save around 20+ gas over a compound boolean condition.
1293             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1294                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1295         }
1296 
1297         _beforeTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Clear approvals from the previous owner.
1300         assembly {
1301             if approvedAddress {
1302                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1303                 sstore(approvedAddressSlot, 0)
1304             }
1305         }
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1310         unchecked {
1311             // Updates:
1312             // - `balance -= 1`.
1313             // - `numberBurned += 1`.
1314             //
1315             // We can directly decrement the balance, and increment the number burned.
1316             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1317             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1318 
1319             // Updates:
1320             // - `address` to the last owner.
1321             // - `startTimestamp` to the timestamp of burning.
1322             // - `burned` to `true`.
1323             // - `nextInitialized` to `true`.
1324             _packedOwnerships[tokenId] = _packOwnershipData(
1325                 from,
1326                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1327             );
1328 
1329             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1330             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1331                 uint256 nextTokenId = tokenId + 1;
1332                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1333                 if (_packedOwnerships[nextTokenId] == 0) {
1334                     // If the next slot is within bounds.
1335                     if (nextTokenId != _currentIndex) {
1336                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1337                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1338                     }
1339                 }
1340             }
1341         }
1342 
1343         emit Transfer(from, address(0), tokenId);
1344         _afterTokenTransfers(from, address(0), tokenId, 1);
1345 
1346         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1347         unchecked {
1348             _burnCounter++;
1349         }
1350     }
1351 
1352     // =============================================================
1353     //                     EXTRA DATA OPERATIONS
1354     // =============================================================
1355 
1356     /**
1357      * @dev Directly sets the extra data for the ownership data `index`.
1358      */
1359     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1360         uint256 packed = _packedOwnerships[index];
1361         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1362         uint256 extraDataCasted;
1363         // Cast `extraData` with assembly to avoid redundant masking.
1364         assembly {
1365             extraDataCasted := extraData
1366         }
1367         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1368         _packedOwnerships[index] = packed;
1369     }
1370 
1371     /**
1372      * @dev Called during each token transfer to set the 24bit `extraData` field.
1373      * Intended to be overridden by the cosumer contract.
1374      *
1375      * `previousExtraData` - the value of `extraData` before transfer.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _extraData(
1386         address from,
1387         address to,
1388         uint24 previousExtraData
1389     ) internal view virtual returns (uint24) {}
1390 
1391     /**
1392      * @dev Returns the next extra data for the packed ownership data.
1393      * The returned result is shifted into position.
1394      */
1395     function _nextExtraData(
1396         address from,
1397         address to,
1398         uint256 prevOwnershipPacked
1399     ) private view returns (uint256) {
1400         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1401         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1402     }
1403 
1404     // =============================================================
1405     //                       OTHER OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Returns the message sender (defaults to `msg.sender`).
1410      *
1411      * If you are writing GSN compatible contracts, you need to override this function.
1412      */
1413     function _msgSenderERC721A() internal view virtual returns (address) {
1414         return msg.sender;
1415     }
1416 
1417     /**
1418      * @dev Converts a uint256 to its ASCII string decimal representation.
1419      */
1420     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1421         assembly {
1422             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1423             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1424             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1425             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1426             let m := add(mload(0x40), 0xa0)
1427             // Update the free memory pointer to allocate.
1428             mstore(0x40, m)
1429             // Assign the `str` to the end.
1430             str := sub(m, 0x20)
1431             // Zeroize the slot after the string.
1432             mstore(str, 0)
1433 
1434             // Cache the end of the memory to calculate the length later.
1435             let end := str
1436 
1437             // We write the string from rightmost digit to leftmost digit.
1438             // The following is essentially a do-while loop that also handles the zero case.
1439             // prettier-ignore
1440             for { let temp := value } 1 {} {
1441                 str := sub(str, 1)
1442                 // Write the character to the pointer.
1443                 // The ASCII index of the '0' character is 48.
1444                 mstore8(str, add(48, mod(temp, 10)))
1445                 // Keep dividing `temp` until zero.
1446                 temp := div(temp, 10)
1447                 // prettier-ignore
1448                 if iszero(temp) { break }
1449             }
1450 
1451             let length := sub(end, str)
1452             // Move the pointer 32 bytes leftwards to make room for the length.
1453             str := sub(str, 0x20)
1454             // Store the length.
1455             mstore(str, length)
1456         }
1457     }
1458 }
1459 // File: contracts/ERC721AQueryable.sol
1460 
1461 
1462 // ERC721A Contracts v4.2.3
1463 // Creator: Chiru Labs
1464 
1465 pragma solidity ^0.8.4;
1466 
1467 
1468 
1469 /**
1470  * @title ERC721AQueryable.
1471  *
1472  * @dev ERC721A subclass with convenience query functions.
1473  */
1474 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1475     /**
1476      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1477      *
1478      * If the `tokenId` is out of bounds:
1479      *
1480      * - `addr = address(0)`
1481      * - `startTimestamp = 0`
1482      * - `burned = false`
1483      * - `extraData = 0`
1484      *
1485      * If the `tokenId` is burned:
1486      *
1487      * - `addr = <Address of owner before token was burned>`
1488      * - `startTimestamp = <Timestamp when token was burned>`
1489      * - `burned = true`
1490      * - `extraData = <Extra data when token was burned>`
1491      *
1492      * Otherwise:
1493      *
1494      * - `addr = <Address of owner>`
1495      * - `startTimestamp = <Timestamp of start of ownership>`
1496      * - `burned = false`
1497      * - `extraData = <Extra data at start of ownership>`
1498      */
1499     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1500         TokenOwnership memory ownership;
1501         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1502             return ownership;
1503         }
1504         ownership = _ownershipAt(tokenId);
1505         if (ownership.burned) {
1506             return ownership;
1507         }
1508         return _ownershipOf(tokenId);
1509     }
1510 
1511     /**
1512      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1513      * See {ERC721AQueryable-explicitOwnershipOf}
1514      */
1515     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1516         external
1517         view
1518         virtual
1519         override
1520         returns (TokenOwnership[] memory)
1521     {
1522         unchecked {
1523             uint256 tokenIdsLength = tokenIds.length;
1524             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1525             for (uint256 i; i != tokenIdsLength; ++i) {
1526                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1527             }
1528             return ownerships;
1529         }
1530     }
1531 
1532     /**
1533      * @dev Returns an array of token IDs owned by `owner`,
1534      * in the range [`start`, `stop`)
1535      * (i.e. `start <= tokenId < stop`).
1536      *
1537      * This function allows for tokens to be queried if the collection
1538      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1539      *
1540      * Requirements:
1541      *
1542      * - `start < stop`
1543      */
1544     function tokensOfOwnerIn(
1545         address owner,
1546         uint256 start,
1547         uint256 stop
1548     ) external view virtual override returns (uint256[] memory) {
1549         unchecked {
1550             if (start >= stop) revert InvalidQueryRange();
1551             uint256 tokenIdsIdx;
1552             uint256 stopLimit = _nextTokenId();
1553             // Set `start = max(start, _startTokenId())`.
1554             if (start < _startTokenId()) {
1555                 start = _startTokenId();
1556             }
1557             // Set `stop = min(stop, stopLimit)`.
1558             if (stop > stopLimit) {
1559                 stop = stopLimit;
1560             }
1561             uint256 tokenIdsMaxLength = balanceOf(owner);
1562             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1563             // to cater for cases where `balanceOf(owner)` is too big.
1564             if (start < stop) {
1565                 uint256 rangeLength = stop - start;
1566                 if (rangeLength < tokenIdsMaxLength) {
1567                     tokenIdsMaxLength = rangeLength;
1568                 }
1569             } else {
1570                 tokenIdsMaxLength = 0;
1571             }
1572             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1573             if (tokenIdsMaxLength == 0) {
1574                 return tokenIds;
1575             }
1576             // We need to call `explicitOwnershipOf(start)`,
1577             // because the slot at `start` may not be initialized.
1578             TokenOwnership memory ownership = explicitOwnershipOf(start);
1579             address currOwnershipAddr;
1580             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1581             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1582             if (!ownership.burned) {
1583                 currOwnershipAddr = ownership.addr;
1584             }
1585             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1586                 ownership = _ownershipAt(i);
1587                 if (ownership.burned) {
1588                     continue;
1589                 }
1590                 if (ownership.addr != address(0)) {
1591                     currOwnershipAddr = ownership.addr;
1592                 }
1593                 if (currOwnershipAddr == owner) {
1594                     tokenIds[tokenIdsIdx++] = i;
1595                 }
1596             }
1597             // Downsize the array to fit.
1598             assembly {
1599                 mstore(tokenIds, tokenIdsIdx)
1600             }
1601             return tokenIds;
1602         }
1603     }
1604 
1605     /**
1606      * @dev Returns an array of token IDs owned by `owner`.
1607      *
1608      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1609      * It is meant to be called off-chain.
1610      *
1611      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1612      * multiple smaller scans if the collection is large enough to cause
1613      * an out-of-gas error (10K collections should be fine).
1614      */
1615     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1616         unchecked {
1617             uint256 tokenIdsIdx;
1618             address currOwnershipAddr;
1619             uint256 tokenIdsLength = balanceOf(owner);
1620             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1621             TokenOwnership memory ownership;
1622             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1623                 ownership = _ownershipAt(i);
1624                 if (ownership.burned) {
1625                     continue;
1626                 }
1627                 if (ownership.addr != address(0)) {
1628                     currOwnershipAddr = ownership.addr;
1629                 }
1630                 if (currOwnershipAddr == owner) {
1631                     tokenIds[tokenIdsIdx++] = i;
1632                 }
1633             }
1634             return tokenIds;
1635         }
1636     }
1637 }
1638 // File: @openzeppelin/contracts/utils/Strings.sol
1639 
1640 
1641 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 /**
1646  * @dev String operations.
1647  */
1648 library Strings {
1649     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1650     uint8 private constant _ADDRESS_LENGTH = 20;
1651 
1652     /**
1653      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1654      */
1655     function toString(uint256 value) internal pure returns (string memory) {
1656         // Inspired by OraclizeAPI's implementation - MIT licence
1657         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1658 
1659         if (value == 0) {
1660             return "0";
1661         }
1662         uint256 temp = value;
1663         uint256 digits;
1664         while (temp != 0) {
1665             digits++;
1666             temp /= 10;
1667         }
1668         bytes memory buffer = new bytes(digits);
1669         while (value != 0) {
1670             digits -= 1;
1671             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1672             value /= 10;
1673         }
1674         return string(buffer);
1675     }
1676 
1677     /**
1678      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1679      */
1680     function toHexString(uint256 value) internal pure returns (string memory) {
1681         if (value == 0) {
1682             return "0x00";
1683         }
1684         uint256 temp = value;
1685         uint256 length = 0;
1686         while (temp != 0) {
1687             length++;
1688             temp >>= 8;
1689         }
1690         return toHexString(value, length);
1691     }
1692 
1693     /**
1694      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1695      */
1696     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1697         bytes memory buffer = new bytes(2 * length + 2);
1698         buffer[0] = "0";
1699         buffer[1] = "x";
1700         for (uint256 i = 2 * length + 1; i > 1; --i) {
1701             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1702             value >>= 4;
1703         }
1704         require(value == 0, "Strings: hex length insufficient");
1705         return string(buffer);
1706     }
1707 
1708     /**
1709      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1710      */
1711     function toHexString(address addr) internal pure returns (string memory) {
1712         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1713     }
1714 }
1715 
1716 // File: @openzeppelin/contracts/utils/Context.sol
1717 
1718 
1719 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1720 
1721 pragma solidity ^0.8.0;
1722 
1723 /**
1724  * @dev Provides information about the current execution context, including the
1725  * sender of the transaction and its data. While these are generally available
1726  * via msg.sender and msg.data, they should not be accessed in such a direct
1727  * manner, since when dealing with meta-transactions the account sending and
1728  * paying for execution may not be the actual sender (as far as an application
1729  * is concerned).
1730  *
1731  * This contract is only required for intermediate, library-like contracts.
1732  */
1733 abstract contract Context {
1734     function _msgSender() internal view virtual returns (address) {
1735         return msg.sender;
1736     }
1737 
1738     function _msgData() internal view virtual returns (bytes calldata) {
1739         return msg.data;
1740     }
1741 }
1742 
1743 // File: @openzeppelin/contracts/access/Ownable.sol
1744 
1745 
1746 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1747 
1748 pragma solidity ^0.8.0;
1749 
1750 
1751 /**
1752  * @dev Contract module which provides a basic access control mechanism, where
1753  * there is an account (an owner) that can be granted exclusive access to
1754  * specific functions.
1755  *
1756  * By default, the owner account will be the one that deploys the contract. This
1757  * can later be changed with {transferOwnership}.
1758  *
1759  * This module is used through inheritance. It will make available the modifier
1760  * `onlyOwner`, which can be applied to your functions to restrict their use to
1761  * the owner.
1762  */
1763 abstract contract Ownable is Context {
1764     address private _owner;
1765 
1766     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1767 
1768     /**
1769      * @dev Initializes the contract setting the deployer as the initial owner.
1770      */
1771     constructor() {
1772         _transferOwnership(_msgSender());
1773     }
1774 
1775     /**
1776      * @dev Throws if called by any account other than the owner.
1777      */
1778     modifier onlyOwner() {
1779         _checkOwner();
1780         _;
1781     }
1782 
1783     /**
1784      * @dev Returns the address of the current owner.
1785      */
1786     function owner() public view virtual returns (address) {
1787         return _owner;
1788     }
1789 
1790     /**
1791      * @dev Throws if the sender is not the owner.
1792      */
1793     function _checkOwner() internal view virtual {
1794         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1795     }
1796 
1797     /**
1798      * @dev Leaves the contract without owner. It will not be possible to call
1799      * `onlyOwner` functions anymore. Can only be called by the current owner.
1800      *
1801      * NOTE: Renouncing ownership will leave the contract without an owner,
1802      * thereby removing any functionality that is only available to the owner.
1803      */
1804     function renounceOwnership() public virtual onlyOwner {
1805         _transferOwnership(address(0));
1806     }
1807 
1808     /**
1809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1810      * Can only be called by the current owner.
1811      */
1812     function transferOwnership(address newOwner) public virtual onlyOwner {
1813         require(newOwner != address(0), "Ownable: new owner is the zero address");
1814         _transferOwnership(newOwner);
1815     }
1816 
1817     /**
1818      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1819      * Internal function without access restriction.
1820      */
1821     function _transferOwnership(address newOwner) internal virtual {
1822         address oldOwner = _owner;
1823         _owner = newOwner;
1824         emit OwnershipTransferred(oldOwner, newOwner);
1825     }
1826 }
1827 
1828 // File: contracts/Holidaze.sol
1829 
1830 
1831 pragma solidity ^0.8.4;
1832 
1833 
1834 
1835 
1836 
1837 contract Holidaze is ERC721AQueryable, Ownable {
1838 
1839     uint256 public maxSupply = 500;
1840     address public projectWallet = 0xf794E26f81831028a9b54314722224B9D7BD9Af3; //project wallet
1841     address public payoutWallet = 0xeD2faa60373eC70E57B39152aeE5Ce4ed7C333c7; //wallet for payouts
1842     uint256 public mintPrice = 0.03 ether;
1843     bool public isMinting = false;
1844     string public metadataPath = 'https://theblinkless.s3.amazonaws.com/holidazejson/';
1845 
1846     constructor() ERC721A("The Blinkless: Holidaze", "BLHLD") {
1847         _mint(address(projectWallet),50);
1848     }
1849 
1850 
1851     /*
1852     * Ensures the caller is not a proxy contract or bot, but is an actual wallet.
1853     */
1854     modifier callerIsUser() {
1855         //we only want to mint to real people
1856         require(tx.origin == msg.sender, "The caller is another contract");
1857         _;
1858     }
1859 
1860     /*
1861     * Contract owner can mint
1862     */
1863     function ownerMint(uint256 _amount) public onlyOwner{
1864         require(totalSupply() + _amount <= maxSupply,"Too many");
1865         _mint(address(projectWallet),_amount);
1866     }
1867 
1868     /*
1869     * Public mint
1870     */
1871     function mint(uint256 _amount) public payable callerIsUser{
1872         require(isMinting, "Mint disabled.");
1873         require(_amount <= 10, "Max of 10 per transaction.");
1874         require(msg.value >= _amount * mintPrice, "Not enough eth.");
1875         require(totalSupply() + _amount <= maxSupply,"Too many");
1876 
1877         _mint(address(msg.sender),_amount);
1878     }
1879 
1880     /*
1881     * Update mint price
1882     */
1883     function updateMintPrice(uint256 _price) external onlyOwner{
1884         mintPrice = _price;
1885     }
1886 
1887     /*
1888     * Update mint status
1889     */
1890     function updateIsMinting(bool _isMinting) external onlyOwner{
1891         isMinting = _isMinting;
1892     }
1893 
1894     /**
1895     * Update the base URI for metadata
1896     */
1897     function updateBaseURI(string memory baseURI) external onlyOwner{
1898         //set the path to the metadata
1899          metadataPath = baseURI;
1900     }
1901 
1902     /**
1903     * Return metadata path
1904     */
1905     function tokenURI(uint tokenId) override(ERC721A) public view returns(string memory _uri){
1906         return string(abi.encodePacked(metadataPath,Strings.toString(tokenId),".json"));
1907     } 
1908 
1909     /**
1910     * Update the project wallet address
1911     */
1912     function updateProjectWallet(address _projectWallet) public onlyOwner{
1913         projectWallet = _projectWallet;
1914     }
1915 
1916     /**
1917     * Update the payout wallet address
1918     */
1919     function updatePayoutWallet(address _payoutWallet) public onlyOwner{
1920         payoutWallet = _payoutWallet;
1921     }
1922 
1923      /*
1924     * Withdraw by owner
1925     */
1926     function withdraw() external onlyOwner {
1927         (bool success, ) = payable(payoutWallet).call{value: address(this).balance}("");
1928         require(success, "Transfer failed.");
1929     }
1930 
1931 
1932     /*
1933     * These are here to receive ETH sent to the contract address
1934     */
1935     receive() external payable {}
1936 
1937     fallback() external payable {}
1938 
1939 }