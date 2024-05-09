1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: erc721a/contracts/IERC721A.sol
69 
70 
71 // ERC721A Contracts v4.2.2
72 // Creator: Chiru Labs
73 
74 pragma solidity ^0.8.4;
75 
76 /**
77  * @dev Interface of ERC721A.
78  */
79 interface IERC721A {
80     /**
81      * The caller must own the token or be an approved operator.
82      */
83     error ApprovalCallerNotOwnerNorApproved();
84 
85     /**
86      * The token does not exist.
87      */
88     error ApprovalQueryForNonexistentToken();
89 
90     /**
91      * The caller cannot approve to their own address.
92      */
93     error ApproveToCaller();
94 
95     /**
96      * Cannot query the balance for the zero address.
97      */
98     error BalanceQueryForZeroAddress();
99 
100     /**
101      * Cannot mint to the zero address.
102      */
103     error MintToZeroAddress();
104 
105     /**
106      * The quantity of tokens minted must be more than zero.
107      */
108     error MintZeroQuantity();
109 
110     /**
111      * The token does not exist.
112      */
113     error OwnerQueryForNonexistentToken();
114 
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error TransferCallerNotOwnerNorApproved();
119 
120     /**
121      * The token must be owned by `from`.
122      */
123     error TransferFromIncorrectOwner();
124 
125     /**
126      * Cannot safely transfer to a contract that does not implement the
127      * ERC721Receiver interface.
128      */
129     error TransferToNonERC721ReceiverImplementer();
130 
131     /**
132      * Cannot transfer to the zero address.
133      */
134     error TransferToZeroAddress();
135 
136     /**
137      * The token does not exist.
138      */
139     error URIQueryForNonexistentToken();
140 
141     /**
142      * The `quantity` minted with ERC2309 exceeds the safety limit.
143      */
144     error MintERC2309QuantityExceedsLimit();
145 
146     /**
147      * The `extraData` cannot be set on an unintialized ownership slot.
148      */
149     error OwnershipNotInitializedForExtraData();
150 
151     // =============================================================
152     //                            STRUCTS
153     // =============================================================
154 
155     struct TokenOwnership {
156         // The address of the owner.
157         address addr;
158         // Stores the start time of ownership with minimal overhead for tokenomics.
159         uint64 startTimestamp;
160         // Whether the token has been burned.
161         bool burned;
162         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
163         uint24 extraData;
164     }
165 
166     // =============================================================
167     //                         TOKEN COUNTERS
168     // =============================================================
169 
170     /**
171      * @dev Returns the total number of tokens in existence.
172      * Burned tokens will reduce the count.
173      * To get the total number of tokens minted, please see {_totalMinted}.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     // =============================================================
178     //                            IERC165
179     // =============================================================
180 
181     /**
182      * @dev Returns true if this contract implements the interface defined by
183      * `interfaceId`. See the corresponding
184      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
185      * to learn more about how these ids are created.
186      *
187      * This function call must use less than 30000 gas.
188      */
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 
191     // =============================================================
192     //                            IERC721
193     // =============================================================
194 
195     /**
196      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
202      */
203     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
204 
205     /**
206      * @dev Emitted when `owner` enables or disables
207      * (`approved`) `operator` to manage all of its assets.
208      */
209     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
210 
211     /**
212      * @dev Returns the number of tokens in `owner`'s account.
213      */
214     function balanceOf(address owner) external view returns (uint256 balance);
215 
216     /**
217      * @dev Returns the owner of the `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function ownerOf(uint256 tokenId) external view returns (address owner);
224 
225     /**
226      * @dev Safely transfers `tokenId` token from `from` to `to`,
227      * checking first that contract recipients are aware of the ERC721 protocol
228      * to prevent tokens from being forever locked.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be have been allowed to move
236      * this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement
238      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId,
246         bytes calldata data
247     ) external;
248 
249     /**
250      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external;
257 
258     /**
259      * @dev Transfers `tokenId` from `from` to `to`.
260      *
261      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
262      * whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token
270      * by either {approve} or {setApprovalForAll}.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
282      * The approval is cleared when the token is transferred.
283      *
284      * Only a single account can be approved at a time, so approving the
285      * zero address clears previous approvals.
286      *
287      * Requirements:
288      *
289      * - The caller must own the token or be an approved operator.
290      * - `tokenId` must exist.
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address to, uint256 tokenId) external;
295 
296     /**
297      * @dev Approve or remove `operator` as an operator for the caller.
298      * Operators can call {transferFrom} or {safeTransferFrom}
299      * for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns the account approved for `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function getApproved(uint256 tokenId) external view returns (address operator);
317 
318     /**
319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
320      *
321      * See {setApprovalForAll}.
322      */
323     function isApprovedForAll(address owner, address operator) external view returns (bool);
324 
325     // =============================================================
326     //                        IERC721Metadata
327     // =============================================================
328 
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 
344     // =============================================================
345     //                           IERC2309
346     // =============================================================
347 
348     /**
349      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
350      * (inclusive) is transferred from `from` to `to`, as defined in the
351      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
352      *
353      * See {_mintERC2309} for more details.
354      */
355     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
356 }
357 
358 // File: erc721a/contracts/ERC721A.sol
359 
360 
361 // ERC721A Contracts v4.2.2
362 // Creator: Chiru Labs
363 
364 pragma solidity ^0.8.4;
365 
366 
367 /**
368  * @dev Interface of ERC721 token receiver.
369  */
370 interface ERC721A__IERC721Receiver {
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 /**
380  * @title ERC721A
381  *
382  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
383  * Non-Fungible Token Standard, including the Metadata extension.
384  * Optimized for lower gas during batch mints.
385  *
386  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
387  * starting from `_startTokenId()`.
388  *
389  * Assumptions:
390  *
391  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
392  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
393  */
394 contract ERC721A is IERC721A {
395     // Reference type for token approval.
396     struct TokenApprovalRef {
397         address value;
398     }
399 
400     // =============================================================
401     //                           CONSTANTS
402     // =============================================================
403 
404     // Mask of an entry in packed address data.
405     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
406 
407     // The bit position of `numberMinted` in packed address data.
408     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
409 
410     // The bit position of `numberBurned` in packed address data.
411     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
412 
413     // The bit position of `aux` in packed address data.
414     uint256 private constant _BITPOS_AUX = 192;
415 
416     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
417     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
418 
419     // The bit position of `startTimestamp` in packed ownership.
420     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
421 
422     // The bit mask of the `burned` bit in packed ownership.
423     uint256 private constant _BITMASK_BURNED = 1 << 224;
424 
425     // The bit position of the `nextInitialized` bit in packed ownership.
426     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
427 
428     // The bit mask of the `nextInitialized` bit in packed ownership.
429     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
430 
431     // The bit position of `extraData` in packed ownership.
432     uint256 private constant _BITPOS_EXTRA_DATA = 232;
433 
434     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
435     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
436 
437     // The mask of the lower 160 bits for addresses.
438     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
439 
440     // The maximum `quantity` that can be minted with {_mintERC2309}.
441     // This limit is to prevent overflows on the address data entries.
442     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
443     // is required to cause an overflow, which is unrealistic.
444     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
445 
446     // The `Transfer` event signature is given by:
447     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
448     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
449         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
450 
451     // =============================================================
452     //                            STORAGE
453     // =============================================================
454 
455     // The next token ID to be minted.
456     uint256 private _currentIndex;
457 
458     // The number of tokens burned.
459     uint256 private _burnCounter;
460 
461     // Token name
462     string private _name;
463 
464     // Token symbol
465     string private _symbol;
466 
467     // Mapping from token ID to ownership details
468     // An empty struct value does not necessarily mean the token is unowned.
469     // See {_packedOwnershipOf} implementation for details.
470     //
471     // Bits Layout:
472     // - [0..159]   `addr`
473     // - [160..223] `startTimestamp`
474     // - [224]      `burned`
475     // - [225]      `nextInitialized`
476     // - [232..255] `extraData`
477     mapping(uint256 => uint256) private _packedOwnerships;
478 
479     // Mapping owner address to address data.
480     //
481     // Bits Layout:
482     // - [0..63]    `balance`
483     // - [64..127]  `numberMinted`
484     // - [128..191] `numberBurned`
485     // - [192..255] `aux`
486     mapping(address => uint256) private _packedAddressData;
487 
488     // Mapping from token ID to approved address.
489     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
490 
491     // Mapping from owner to operator approvals
492     mapping(address => mapping(address => bool)) private _operatorApprovals;
493 
494     // =============================================================
495     //                          CONSTRUCTOR
496     // =============================================================
497 
498     constructor(string memory name_, string memory symbol_) {
499         _name = name_;
500         _symbol = symbol_;
501         _currentIndex = _startTokenId();
502     }
503 
504     // =============================================================
505     //                   TOKEN COUNTING OPERATIONS
506     // =============================================================
507 
508     /**
509      * @dev Returns the starting token ID.
510      * To change the starting token ID, please override this function.
511      */
512     function _startTokenId() internal view virtual returns (uint256) {
513         return 0;
514     }
515 
516     /**
517      * @dev Returns the next token ID to be minted.
518      */
519     function _nextTokenId() internal view virtual returns (uint256) {
520         return _currentIndex;
521     }
522 
523     /**
524      * @dev Returns the total number of tokens in existence.
525      * Burned tokens will reduce the count.
526      * To get the total number of tokens minted, please see {_totalMinted}.
527      */
528     function totalSupply() public view virtual override returns (uint256) {
529         // Counter underflow is impossible as _burnCounter cannot be incremented
530         // more than `_currentIndex - _startTokenId()` times.
531         unchecked {
532             return _currentIndex - _burnCounter - _startTokenId();
533         }
534     }
535 
536     /**
537      * @dev Returns the total amount of tokens minted in the contract.
538      */
539     function _totalMinted() internal view virtual returns (uint256) {
540         // Counter underflow is impossible as `_currentIndex` does not decrement,
541         // and it is initialized to `_startTokenId()`.
542         unchecked {
543             return _currentIndex - _startTokenId();
544         }
545     }
546 
547     /**
548      * @dev Returns the total number of tokens burned.
549      */
550     function _totalBurned() internal view virtual returns (uint256) {
551         return _burnCounter;
552     }
553 
554     // =============================================================
555     //                    ADDRESS DATA OPERATIONS
556     // =============================================================
557 
558     /**
559      * @dev Returns the number of tokens in `owner`'s account.
560      */
561     function balanceOf(address owner) public view virtual override returns (uint256) {
562         if (owner == address(0)) revert BalanceQueryForZeroAddress();
563         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
564     }
565 
566     /**
567      * Returns the number of tokens minted by `owner`.
568      */
569     function _numberMinted(address owner) internal view returns (uint256) {
570         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573     /**
574      * Returns the number of tokens burned by or on behalf of `owner`.
575      */
576     function _numberBurned(address owner) internal view returns (uint256) {
577         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
578     }
579 
580     /**
581      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
582      */
583     function _getAux(address owner) internal view returns (uint64) {
584         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
585     }
586 
587     /**
588      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
589      * If there are multiple variables, please pack them into a uint64.
590      */
591     function _setAux(address owner, uint64 aux) internal virtual {
592         uint256 packed = _packedAddressData[owner];
593         uint256 auxCasted;
594         // Cast `aux` with assembly to avoid redundant masking.
595         assembly {
596             auxCasted := aux
597         }
598         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
599         _packedAddressData[owner] = packed;
600     }
601 
602     // =============================================================
603     //                            IERC165
604     // =============================================================
605 
606     /**
607      * @dev Returns true if this contract implements the interface defined by
608      * `interfaceId`. See the corresponding
609      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
610      * to learn more about how these ids are created.
611      *
612      * This function call must use less than 30000 gas.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         // The interface IDs are constants representing the first 4 bytes
616         // of the XOR of all function selectors in the interface.
617         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
618         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
619         return
620             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
621             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
622             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
623     }
624 
625     // =============================================================
626     //                        IERC721Metadata
627     // =============================================================
628 
629     /**
630      * @dev Returns the token collection name.
631      */
632     function name() public view virtual override returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev Returns the token collection symbol.
638      */
639     function symbol() public view virtual override returns (string memory) {
640         return _symbol;
641     }
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
647         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
648 
649         string memory baseURI = _baseURI();
650         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
655      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
656      * by default, it can be overridden in child contracts.
657      */
658     function _baseURI() internal view virtual returns (string memory) {
659         return '';
660     }
661 
662     // =============================================================
663     //                     OWNERSHIPS OPERATIONS
664     // =============================================================
665 
666     /**
667      * @dev Returns the owner of the `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
674         return address(uint160(_packedOwnershipOf(tokenId)));
675     }
676 
677     /**
678      * @dev Gas spent here starts off proportional to the maximum mint batch size.
679      * It gradually moves to O(1) as tokens get transferred around over time.
680      */
681     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
682         return _unpackedOwnership(_packedOwnershipOf(tokenId));
683     }
684 
685     /**
686      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
687      */
688     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
689         return _unpackedOwnership(_packedOwnerships[index]);
690     }
691 
692     /**
693      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
694      */
695     function _initializeOwnershipAt(uint256 index) internal virtual {
696         if (_packedOwnerships[index] == 0) {
697             _packedOwnerships[index] = _packedOwnershipOf(index);
698         }
699     }
700 
701     /**
702      * Returns the packed ownership data of `tokenId`.
703      */
704     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
705         uint256 curr = tokenId;
706 
707         unchecked {
708             if (_startTokenId() <= curr)
709                 if (curr < _currentIndex) {
710                     uint256 packed = _packedOwnerships[curr];
711                     // If not burned.
712                     if (packed & _BITMASK_BURNED == 0) {
713                         // Invariant:
714                         // There will always be an initialized ownership slot
715                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
716                         // before an unintialized ownership slot
717                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
718                         // Hence, `curr` will not underflow.
719                         //
720                         // We can directly compare the packed value.
721                         // If the address is zero, packed will be zero.
722                         while (packed == 0) {
723                             packed = _packedOwnerships[--curr];
724                         }
725                         return packed;
726                     }
727                 }
728         }
729         revert OwnerQueryForNonexistentToken();
730     }
731 
732     /**
733      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
734      */
735     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
736         ownership.addr = address(uint160(packed));
737         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
738         ownership.burned = packed & _BITMASK_BURNED != 0;
739         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
740     }
741 
742     /**
743      * @dev Packs ownership data into a single uint256.
744      */
745     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
746         assembly {
747             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
748             owner := and(owner, _BITMASK_ADDRESS)
749             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
750             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
751         }
752     }
753 
754     /**
755      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
756      */
757     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
758         // For branchless setting of the `nextInitialized` flag.
759         assembly {
760             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
761             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
762         }
763     }
764 
765     // =============================================================
766     //                      APPROVAL OPERATIONS
767     // =============================================================
768 
769     /**
770      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
771      * The approval is cleared when the token is transferred.
772      *
773      * Only a single account can be approved at a time, so approving the
774      * zero address clears previous approvals.
775      *
776      * Requirements:
777      *
778      * - The caller must own the token or be an approved operator.
779      * - `tokenId` must exist.
780      *
781      * Emits an {Approval} event.
782      */
783     function approve(address to, uint256 tokenId) public virtual override {
784         address owner = ownerOf(tokenId);
785 
786         if (_msgSenderERC721A() != owner)
787             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
788                 revert ApprovalCallerNotOwnerNorApproved();
789             }
790 
791         _tokenApprovals[tokenId].value = to;
792         emit Approval(owner, to, tokenId);
793     }
794 
795     /**
796      * @dev Returns the account approved for `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function getApproved(uint256 tokenId) public view virtual override returns (address) {
803         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
804 
805         return _tokenApprovals[tokenId].value;
806     }
807 
808     /**
809      * @dev Approve or remove `operator` as an operator for the caller.
810      * Operators can call {transferFrom} or {safeTransferFrom}
811      * for any token owned by the caller.
812      *
813      * Requirements:
814      *
815      * - The `operator` cannot be the caller.
816      *
817      * Emits an {ApprovalForAll} event.
818      */
819     function setApprovalForAll(address operator, bool approved) public virtual override {
820         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
821 
822         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
823         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
824     }
825 
826     /**
827      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
828      *
829      * See {setApprovalForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev Returns whether `tokenId` exists.
837      *
838      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
839      *
840      * Tokens start existing when they are minted. See {_mint}.
841      */
842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
843         return
844             _startTokenId() <= tokenId &&
845             tokenId < _currentIndex && // If within bounds,
846             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
847     }
848 
849     /**
850      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
851      */
852     function _isSenderApprovedOrOwner(
853         address approvedAddress,
854         address owner,
855         address msgSender
856     ) private pure returns (bool result) {
857         assembly {
858             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
859             owner := and(owner, _BITMASK_ADDRESS)
860             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
861             msgSender := and(msgSender, _BITMASK_ADDRESS)
862             // `msgSender == owner || msgSender == approvedAddress`.
863             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
864         }
865     }
866 
867     /**
868      * @dev Returns the storage slot and value for the approved address of `tokenId`.
869      */
870     function _getApprovedSlotAndAddress(uint256 tokenId)
871         private
872         view
873         returns (uint256 approvedAddressSlot, address approvedAddress)
874     {
875         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
876         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
877         assembly {
878             approvedAddressSlot := tokenApproval.slot
879             approvedAddress := sload(approvedAddressSlot)
880         }
881     }
882 
883     // =============================================================
884     //                      TRANSFER OPERATIONS
885     // =============================================================
886 
887     /**
888      * @dev Transfers `tokenId` from `from` to `to`.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      * - If the caller is not `from`, it must be approved to move this token
896      * by either {approve} or {setApprovalForAll}.
897      *
898      * Emits a {Transfer} event.
899      */
900     function transferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
906 
907         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
908 
909         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
910 
911         // The nested ifs save around 20+ gas over a compound boolean condition.
912         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
913             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
914 
915         if (to == address(0)) revert TransferToZeroAddress();
916 
917         _beforeTokenTransfers(from, to, tokenId, 1);
918 
919         // Clear approvals from the previous owner.
920         assembly {
921             if approvedAddress {
922                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
923                 sstore(approvedAddressSlot, 0)
924             }
925         }
926 
927         // Underflow of the sender's balance is impossible because we check for
928         // ownership above and the recipient's balance can't realistically overflow.
929         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
930         unchecked {
931             // We can directly increment and decrement the balances.
932             --_packedAddressData[from]; // Updates: `balance -= 1`.
933             ++_packedAddressData[to]; // Updates: `balance += 1`.
934 
935             // Updates:
936             // - `address` to the next owner.
937             // - `startTimestamp` to the timestamp of transfering.
938             // - `burned` to `false`.
939             // - `nextInitialized` to `true`.
940             _packedOwnerships[tokenId] = _packOwnershipData(
941                 to,
942                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
943             );
944 
945             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
946             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
947                 uint256 nextTokenId = tokenId + 1;
948                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
949                 if (_packedOwnerships[nextTokenId] == 0) {
950                     // If the next slot is within bounds.
951                     if (nextTokenId != _currentIndex) {
952                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
953                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
954                     }
955                 }
956             }
957         }
958 
959         emit Transfer(from, to, tokenId);
960         _afterTokenTransfers(from, to, tokenId, 1);
961     }
962 
963     /**
964      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId
970     ) public virtual override {
971         safeTransferFrom(from, to, tokenId, '');
972     }
973 
974     /**
975      * @dev Safely transfers `tokenId` token from `from` to `to`.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must exist and be owned by `from`.
982      * - If the caller is not `from`, it must be approved to move this token
983      * by either {approve} or {setApprovalForAll}.
984      * - If `to` refers to a smart contract, it must implement
985      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) public virtual override {
995         transferFrom(from, to, tokenId);
996         if (to.code.length != 0)
997             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
998                 revert TransferToNonERC721ReceiverImplementer();
999             }
1000     }
1001 
1002     /**
1003      * @dev Hook that is called before a set of serially-ordered token IDs
1004      * are about to be transferred. This includes minting.
1005      * And also called before burning one token.
1006      *
1007      * `startTokenId` - the first token ID to be transferred.
1008      * `quantity` - the amount to be transferred.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, `tokenId` will be burned by `from`.
1016      * - `from` and `to` are never both zero.
1017      */
1018     function _beforeTokenTransfers(
1019         address from,
1020         address to,
1021         uint256 startTokenId,
1022         uint256 quantity
1023     ) internal virtual {}
1024 
1025     /**
1026      * @dev Hook that is called after a set of serially-ordered token IDs
1027      * have been transferred. This includes minting.
1028      * And also called after one token has been burned.
1029      *
1030      * `startTokenId` - the first token ID to be transferred.
1031      * `quantity` - the amount to be transferred.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` has been minted for `to`.
1038      * - When `to` is zero, `tokenId` has been burned by `from`.
1039      * - `from` and `to` are never both zero.
1040      */
1041     function _afterTokenTransfers(
1042         address from,
1043         address to,
1044         uint256 startTokenId,
1045         uint256 quantity
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1050      *
1051      * `from` - Previous owner of the given token ID.
1052      * `to` - Target address that will receive the token.
1053      * `tokenId` - Token ID to be transferred.
1054      * `_data` - Optional data to send along with the call.
1055      *
1056      * Returns whether the call correctly returned the expected magic value.
1057      */
1058     function _checkContractOnERC721Received(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) private returns (bool) {
1064         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1065             bytes4 retval
1066         ) {
1067             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1068         } catch (bytes memory reason) {
1069             if (reason.length == 0) {
1070                 revert TransferToNonERC721ReceiverImplementer();
1071             } else {
1072                 assembly {
1073                     revert(add(32, reason), mload(reason))
1074                 }
1075             }
1076         }
1077     }
1078 
1079     // =============================================================
1080     //                        MINT OPERATIONS
1081     // =============================================================
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event for each mint.
1092      */
1093     function _mint(address to, uint256 quantity) internal virtual {
1094         uint256 startTokenId = _currentIndex;
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // `balance` and `numberMinted` have a maximum limit of 2**64.
1101         // `tokenId` has a maximum limit of 2**256.
1102         unchecked {
1103             // Updates:
1104             // - `balance += quantity`.
1105             // - `numberMinted += quantity`.
1106             //
1107             // We can directly add to the `balance` and `numberMinted`.
1108             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1109 
1110             // Updates:
1111             // - `address` to the owner.
1112             // - `startTimestamp` to the timestamp of minting.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `quantity == 1`.
1115             _packedOwnerships[startTokenId] = _packOwnershipData(
1116                 to,
1117                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1118             );
1119 
1120             uint256 toMasked;
1121             uint256 end = startTokenId + quantity;
1122 
1123             // Use assembly to loop and emit the `Transfer` event for gas savings.
1124             assembly {
1125                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1126                 toMasked := and(to, _BITMASK_ADDRESS)
1127                 // Emit the `Transfer` event.
1128                 log4(
1129                     0, // Start of data (0, since no data).
1130                     0, // End of data (0, since no data).
1131                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1132                     0, // `address(0)`.
1133                     toMasked, // `to`.
1134                     startTokenId // `tokenId`.
1135                 )
1136 
1137                 for {
1138                     let tokenId := add(startTokenId, 1)
1139                 } iszero(eq(tokenId, end)) {
1140                     tokenId := add(tokenId, 1)
1141                 } {
1142                     // Emit the `Transfer` event. Similar to above.
1143                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1144                 }
1145             }
1146             if (toMasked == 0) revert MintToZeroAddress();
1147 
1148             _currentIndex = end;
1149         }
1150         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1151     }
1152 
1153     /**
1154      * @dev Mints `quantity` tokens and transfers them to `to`.
1155      *
1156      * This function is intended for efficient minting only during contract creation.
1157      *
1158      * It emits only one {ConsecutiveTransfer} as defined in
1159      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1160      * instead of a sequence of {Transfer} event(s).
1161      *
1162      * Calling this function outside of contract creation WILL make your contract
1163      * non-compliant with the ERC721 standard.
1164      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1165      * {ConsecutiveTransfer} event is only permissible during contract creation.
1166      *
1167      * Requirements:
1168      *
1169      * - `to` cannot be the zero address.
1170      * - `quantity` must be greater than 0.
1171      *
1172      * Emits a {ConsecutiveTransfer} event.
1173      */
1174     function _mintERC2309(address to, uint256 quantity) internal virtual {
1175         uint256 startTokenId = _currentIndex;
1176         if (to == address(0)) revert MintToZeroAddress();
1177         if (quantity == 0) revert MintZeroQuantity();
1178         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1179 
1180         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1181 
1182         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1183         unchecked {
1184             // Updates:
1185             // - `balance += quantity`.
1186             // - `numberMinted += quantity`.
1187             //
1188             // We can directly add to the `balance` and `numberMinted`.
1189             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1190 
1191             // Updates:
1192             // - `address` to the owner.
1193             // - `startTimestamp` to the timestamp of minting.
1194             // - `burned` to `false`.
1195             // - `nextInitialized` to `quantity == 1`.
1196             _packedOwnerships[startTokenId] = _packOwnershipData(
1197                 to,
1198                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1199             );
1200 
1201             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1202 
1203             _currentIndex = startTokenId + quantity;
1204         }
1205         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1206     }
1207 
1208     /**
1209      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - If `to` refers to a smart contract, it must implement
1214      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * See {_mint}.
1218      *
1219      * Emits a {Transfer} event for each mint.
1220      */
1221     function _safeMint(
1222         address to,
1223         uint256 quantity,
1224         bytes memory _data
1225     ) internal virtual {
1226         _mint(to, quantity);
1227 
1228         unchecked {
1229             if (to.code.length != 0) {
1230                 uint256 end = _currentIndex;
1231                 uint256 index = end - quantity;
1232                 do {
1233                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1234                         revert TransferToNonERC721ReceiverImplementer();
1235                     }
1236                 } while (index < end);
1237                 // Reentrancy protection.
1238                 if (_currentIndex != end) revert();
1239             }
1240         }
1241     }
1242 
1243     /**
1244      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1245      */
1246     function _safeMint(address to, uint256 quantity) internal virtual {
1247         _safeMint(to, quantity, '');
1248     }
1249 
1250     // =============================================================
1251     //                        BURN OPERATIONS
1252     // =============================================================
1253 
1254     /**
1255      * @dev Equivalent to `_burn(tokenId, false)`.
1256      */
1257     function _burn(uint256 tokenId) internal virtual {
1258         _burn(tokenId, false);
1259     }
1260 
1261     /**
1262      * @dev Destroys `tokenId`.
1263      * The approval is cleared when the token is burned.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1272         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1273 
1274         address from = address(uint160(prevOwnershipPacked));
1275 
1276         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1277 
1278         if (approvalCheck) {
1279             // The nested ifs save around 20+ gas over a compound boolean condition.
1280             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1281                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1282         }
1283 
1284         _beforeTokenTransfers(from, address(0), tokenId, 1);
1285 
1286         // Clear approvals from the previous owner.
1287         assembly {
1288             if approvedAddress {
1289                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1290                 sstore(approvedAddressSlot, 0)
1291             }
1292         }
1293 
1294         // Underflow of the sender's balance is impossible because we check for
1295         // ownership above and the recipient's balance can't realistically overflow.
1296         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1297         unchecked {
1298             // Updates:
1299             // - `balance -= 1`.
1300             // - `numberBurned += 1`.
1301             //
1302             // We can directly decrement the balance, and increment the number burned.
1303             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1304             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1305 
1306             // Updates:
1307             // - `address` to the last owner.
1308             // - `startTimestamp` to the timestamp of burning.
1309             // - `burned` to `true`.
1310             // - `nextInitialized` to `true`.
1311             _packedOwnerships[tokenId] = _packOwnershipData(
1312                 from,
1313                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1314             );
1315 
1316             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1317             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1318                 uint256 nextTokenId = tokenId + 1;
1319                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1320                 if (_packedOwnerships[nextTokenId] == 0) {
1321                     // If the next slot is within bounds.
1322                     if (nextTokenId != _currentIndex) {
1323                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1324                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1325                     }
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(from, address(0), tokenId);
1331         _afterTokenTransfers(from, address(0), tokenId, 1);
1332 
1333         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1334         unchecked {
1335             _burnCounter++;
1336         }
1337     }
1338 
1339     // =============================================================
1340     //                     EXTRA DATA OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Directly sets the extra data for the ownership data `index`.
1345      */
1346     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1347         uint256 packed = _packedOwnerships[index];
1348         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1349         uint256 extraDataCasted;
1350         // Cast `extraData` with assembly to avoid redundant masking.
1351         assembly {
1352             extraDataCasted := extraData
1353         }
1354         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1355         _packedOwnerships[index] = packed;
1356     }
1357 
1358     /**
1359      * @dev Called during each token transfer to set the 24bit `extraData` field.
1360      * Intended to be overridden by the cosumer contract.
1361      *
1362      * `previousExtraData` - the value of `extraData` before transfer.
1363      *
1364      * Calling conditions:
1365      *
1366      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1367      * transferred to `to`.
1368      * - When `from` is zero, `tokenId` will be minted for `to`.
1369      * - When `to` is zero, `tokenId` will be burned by `from`.
1370      * - `from` and `to` are never both zero.
1371      */
1372     function _extraData(
1373         address from,
1374         address to,
1375         uint24 previousExtraData
1376     ) internal view virtual returns (uint24) {}
1377 
1378     /**
1379      * @dev Returns the next extra data for the packed ownership data.
1380      * The returned result is shifted into position.
1381      */
1382     function _nextExtraData(
1383         address from,
1384         address to,
1385         uint256 prevOwnershipPacked
1386     ) private view returns (uint256) {
1387         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1388         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1389     }
1390 
1391     // =============================================================
1392     //                       OTHER OPERATIONS
1393     // =============================================================
1394 
1395     /**
1396      * @dev Returns the message sender (defaults to `msg.sender`).
1397      *
1398      * If you are writing GSN compatible contracts, you need to override this function.
1399      */
1400     function _msgSenderERC721A() internal view virtual returns (address) {
1401         return msg.sender;
1402     }
1403 
1404     /**
1405      * @dev Converts a uint256 to its ASCII string decimal representation.
1406      */
1407     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1408         assembly {
1409             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1410             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1411             // We will need 1 32-byte word to store the length,
1412             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1413             str := add(mload(0x40), 0x80)
1414             // Update the free memory pointer to allocate.
1415             mstore(0x40, str)
1416 
1417             // Cache the end of the memory to calculate the length later.
1418             let end := str
1419 
1420             // We write the string from rightmost digit to leftmost digit.
1421             // The following is essentially a do-while loop that also handles the zero case.
1422             // prettier-ignore
1423             for { let temp := value } 1 {} {
1424                 str := sub(str, 1)
1425                 // Write the character to the pointer.
1426                 // The ASCII index of the '0' character is 48.
1427                 mstore8(str, add(48, mod(temp, 10)))
1428                 // Keep dividing `temp` until zero.
1429                 temp := div(temp, 10)
1430                 // prettier-ignore
1431                 if iszero(temp) { break }
1432             }
1433 
1434             let length := sub(end, str)
1435             // Move the pointer 32 bytes leftwards to make room for the length.
1436             str := sub(str, 0x20)
1437             // Store the length.
1438             mstore(str, length)
1439         }
1440     }
1441 }
1442 
1443 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1444 
1445 
1446 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 /**
1451  * @dev These functions deal with verification of Merkle Tree proofs.
1452  *
1453  * The proofs can be generated using the JavaScript library
1454  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1455  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1456  *
1457  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1458  *
1459  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1460  * hashing, or use a hash function other than keccak256 for hashing leaves.
1461  * This is because the concatenation of a sorted pair of internal nodes in
1462  * the merkle tree could be reinterpreted as a leaf value.
1463  */
1464 library MerkleProof {
1465     /**
1466      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1467      * defined by `root`. For this, a `proof` must be provided, containing
1468      * sibling hashes on the branch from the leaf to the root of the tree. Each
1469      * pair of leaves and each pair of pre-images are assumed to be sorted.
1470      */
1471     function verify(
1472         bytes32[] memory proof,
1473         bytes32 root,
1474         bytes32 leaf
1475     ) internal pure returns (bool) {
1476         return processProof(proof, leaf) == root;
1477     }
1478 
1479     /**
1480      * @dev Calldata version of {verify}
1481      *
1482      * _Available since v4.7._
1483      */
1484     function verifyCalldata(
1485         bytes32[] calldata proof,
1486         bytes32 root,
1487         bytes32 leaf
1488     ) internal pure returns (bool) {
1489         return processProofCalldata(proof, leaf) == root;
1490     }
1491 
1492     /**
1493      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1494      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1495      * hash matches the root of the tree. When processing the proof, the pairs
1496      * of leafs & pre-images are assumed to be sorted.
1497      *
1498      * _Available since v4.4._
1499      */
1500     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1501         bytes32 computedHash = leaf;
1502         for (uint256 i = 0; i < proof.length; i++) {
1503             computedHash = _hashPair(computedHash, proof[i]);
1504         }
1505         return computedHash;
1506     }
1507 
1508     /**
1509      * @dev Calldata version of {processProof}
1510      *
1511      * _Available since v4.7._
1512      */
1513     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1514         bytes32 computedHash = leaf;
1515         for (uint256 i = 0; i < proof.length; i++) {
1516             computedHash = _hashPair(computedHash, proof[i]);
1517         }
1518         return computedHash;
1519     }
1520 
1521     /**
1522      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1523      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1524      *
1525      * _Available since v4.7._
1526      */
1527     function multiProofVerify(
1528         bytes32[] memory proof,
1529         bool[] memory proofFlags,
1530         bytes32 root,
1531         bytes32[] memory leaves
1532     ) internal pure returns (bool) {
1533         return processMultiProof(proof, proofFlags, leaves) == root;
1534     }
1535 
1536     /**
1537      * @dev Calldata version of {multiProofVerify}
1538      *
1539      * _Available since v4.7._
1540      */
1541     function multiProofVerifyCalldata(
1542         bytes32[] calldata proof,
1543         bool[] calldata proofFlags,
1544         bytes32 root,
1545         bytes32[] memory leaves
1546     ) internal pure returns (bool) {
1547         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1548     }
1549 
1550     /**
1551      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1552      * consuming from one or the other at each step according to the instructions given by
1553      * `proofFlags`.
1554      *
1555      * _Available since v4.7._
1556      */
1557     function processMultiProof(
1558         bytes32[] memory proof,
1559         bool[] memory proofFlags,
1560         bytes32[] memory leaves
1561     ) internal pure returns (bytes32 merkleRoot) {
1562         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1563         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1564         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1565         // the merkle tree.
1566         uint256 leavesLen = leaves.length;
1567         uint256 totalHashes = proofFlags.length;
1568 
1569         // Check proof validity.
1570         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1571 
1572         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1573         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1574         bytes32[] memory hashes = new bytes32[](totalHashes);
1575         uint256 leafPos = 0;
1576         uint256 hashPos = 0;
1577         uint256 proofPos = 0;
1578         // At each step, we compute the next hash using two values:
1579         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1580         //   get the next hash.
1581         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1582         //   `proof` array.
1583         for (uint256 i = 0; i < totalHashes; i++) {
1584             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1585             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1586             hashes[i] = _hashPair(a, b);
1587         }
1588 
1589         if (totalHashes > 0) {
1590             return hashes[totalHashes - 1];
1591         } else if (leavesLen > 0) {
1592             return leaves[0];
1593         } else {
1594             return proof[0];
1595         }
1596     }
1597 
1598     /**
1599      * @dev Calldata version of {processMultiProof}
1600      *
1601      * _Available since v4.7._
1602      */
1603     function processMultiProofCalldata(
1604         bytes32[] calldata proof,
1605         bool[] calldata proofFlags,
1606         bytes32[] memory leaves
1607     ) internal pure returns (bytes32 merkleRoot) {
1608         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1609         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1610         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1611         // the merkle tree.
1612         uint256 leavesLen = leaves.length;
1613         uint256 totalHashes = proofFlags.length;
1614 
1615         // Check proof validity.
1616         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1617 
1618         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1619         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1620         bytes32[] memory hashes = new bytes32[](totalHashes);
1621         uint256 leafPos = 0;
1622         uint256 hashPos = 0;
1623         uint256 proofPos = 0;
1624         // At each step, we compute the next hash using two values:
1625         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1626         //   get the next hash.
1627         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1628         //   `proof` array.
1629         for (uint256 i = 0; i < totalHashes; i++) {
1630             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1631             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1632             hashes[i] = _hashPair(a, b);
1633         }
1634 
1635         if (totalHashes > 0) {
1636             return hashes[totalHashes - 1];
1637         } else if (leavesLen > 0) {
1638             return leaves[0];
1639         } else {
1640             return proof[0];
1641         }
1642     }
1643 
1644     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1645         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1646     }
1647 
1648     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1649         /// @solidity memory-safe-assembly
1650         assembly {
1651             mstore(0x00, a)
1652             mstore(0x20, b)
1653             value := keccak256(0x00, 0x40)
1654         }
1655     }
1656 }
1657 
1658 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1659 
1660 
1661 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 /**
1666  * @dev Contract module that helps prevent reentrant calls to a function.
1667  *
1668  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1669  * available, which can be applied to functions to make sure there are no nested
1670  * (reentrant) calls to them.
1671  *
1672  * Note that because there is a single `nonReentrant` guard, functions marked as
1673  * `nonReentrant` may not call one another. This can be worked around by making
1674  * those functions `private`, and then adding `external` `nonReentrant` entry
1675  * points to them.
1676  *
1677  * TIP: If you would like to learn more about reentrancy and alternative ways
1678  * to protect against it, check out our blog post
1679  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1680  */
1681 abstract contract ReentrancyGuard {
1682     // Booleans are more expensive than uint256 or any type that takes up a full
1683     // word because each write operation emits an extra SLOAD to first read the
1684     // slot's contents, replace the bits taken up by the boolean, and then write
1685     // back. This is the compiler's defense against contract upgrades and
1686     // pointer aliasing, and it cannot be disabled.
1687 
1688     // The values being non-zero value makes deployment a bit more expensive,
1689     // but in exchange the refund on every call to nonReentrant will be lower in
1690     // amount. Since refunds are capped to a percentage of the total
1691     // transaction's gas, it is best to keep them low in cases like this one, to
1692     // increase the likelihood of the full refund coming into effect.
1693     uint256 private constant _NOT_ENTERED = 1;
1694     uint256 private constant _ENTERED = 2;
1695 
1696     uint256 private _status;
1697 
1698     constructor() {
1699         _status = _NOT_ENTERED;
1700     }
1701 
1702     /**
1703      * @dev Prevents a contract from calling itself, directly or indirectly.
1704      * Calling a `nonReentrant` function from another `nonReentrant`
1705      * function is not supported. It is possible to prevent this from happening
1706      * by making the `nonReentrant` function external, and making it call a
1707      * `private` function that does the actual work.
1708      */
1709     modifier nonReentrant() {
1710         // On the first call to nonReentrant, _notEntered will be true
1711         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1712 
1713         // Any calls to nonReentrant after this point will fail
1714         _status = _ENTERED;
1715 
1716         _;
1717 
1718         // By storing the original value once again, a refund is triggered (see
1719         // https://eips.ethereum.org/EIPS/eip-2200)
1720         _status = _NOT_ENTERED;
1721     }
1722 }
1723 
1724 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1725 
1726 
1727 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1728 
1729 pragma solidity ^0.8.0;
1730 
1731 /**
1732  * @dev Interface of the ERC165 standard, as defined in the
1733  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1734  *
1735  * Implementers can declare support of contract interfaces, which can then be
1736  * queried by others ({ERC165Checker}).
1737  *
1738  * For an implementation, see {ERC165}.
1739  */
1740 interface IERC165 {
1741     /**
1742      * @dev Returns true if this contract implements the interface defined by
1743      * `interfaceId`. See the corresponding
1744      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1745      * to learn more about how these ids are created.
1746      *
1747      * This function call must use less than 30 000 gas.
1748      */
1749     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1750 }
1751 
1752 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1753 
1754 
1755 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 
1760 /**
1761  * @dev Implementation of the {IERC165} interface.
1762  *
1763  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1764  * for the additional interface id that will be supported. For example:
1765  *
1766  * ```solidity
1767  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1768  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1769  * }
1770  * ```
1771  *
1772  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1773  */
1774 abstract contract ERC165 is IERC165 {
1775     /**
1776      * @dev See {IERC165-supportsInterface}.
1777      */
1778     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1779         return interfaceId == type(IERC165).interfaceId;
1780     }
1781 }
1782 
1783 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1784 
1785 
1786 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1787 
1788 pragma solidity ^0.8.0;
1789 
1790 
1791 /**
1792  * @dev Interface for the NFT Royalty Standard.
1793  *
1794  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1795  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1796  *
1797  * _Available since v4.5._
1798  */
1799 interface IERC2981 is IERC165 {
1800     /**
1801      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1802      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1803      */
1804     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1805         external
1806         view
1807         returns (address receiver, uint256 royaltyAmount);
1808 }
1809 
1810 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1811 
1812 
1813 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1814 
1815 pragma solidity ^0.8.0;
1816 
1817 
1818 
1819 /**
1820  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1821  *
1822  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1823  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1824  *
1825  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1826  * fee is specified in basis points by default.
1827  *
1828  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1829  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1830  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1831  *
1832  * _Available since v4.5._
1833  */
1834 abstract contract ERC2981 is IERC2981, ERC165 {
1835     struct RoyaltyInfo {
1836         address receiver;
1837         uint96 royaltyFraction;
1838     }
1839 
1840     RoyaltyInfo private _defaultRoyaltyInfo;
1841     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1842 
1843     /**
1844      * @dev See {IERC165-supportsInterface}.
1845      */
1846     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1847         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1848     }
1849 
1850     /**
1851      * @inheritdoc IERC2981
1852      */
1853     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1854         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1855 
1856         if (royalty.receiver == address(0)) {
1857             royalty = _defaultRoyaltyInfo;
1858         }
1859 
1860         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1861 
1862         return (royalty.receiver, royaltyAmount);
1863     }
1864 
1865     /**
1866      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1867      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1868      * override.
1869      */
1870     function _feeDenominator() internal pure virtual returns (uint96) {
1871         return 10000;
1872     }
1873 
1874     /**
1875      * @dev Sets the royalty information that all ids in this contract will default to.
1876      *
1877      * Requirements:
1878      *
1879      * - `receiver` cannot be the zero address.
1880      * - `feeNumerator` cannot be greater than the fee denominator.
1881      */
1882     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1883         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1884         require(receiver != address(0), "ERC2981: invalid receiver");
1885 
1886         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1887     }
1888 
1889     /**
1890      * @dev Removes default royalty information.
1891      */
1892     function _deleteDefaultRoyalty() internal virtual {
1893         delete _defaultRoyaltyInfo;
1894     }
1895 
1896     /**
1897      * @dev Sets the royalty information for a specific token id, overriding the global default.
1898      *
1899      * Requirements:
1900      *
1901      * - `receiver` cannot be the zero address.
1902      * - `feeNumerator` cannot be greater than the fee denominator.
1903      */
1904     function _setTokenRoyalty(
1905         uint256 tokenId,
1906         address receiver,
1907         uint96 feeNumerator
1908     ) internal virtual {
1909         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1910         require(receiver != address(0), "ERC2981: Invalid parameters");
1911 
1912         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1913     }
1914 
1915     /**
1916      * @dev Resets royalty information for the token id back to the global default.
1917      */
1918     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1919         delete _tokenRoyaltyInfo[tokenId];
1920     }
1921 }
1922 
1923 // File: @openzeppelin/contracts/utils/Context.sol
1924 
1925 
1926 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1927 
1928 pragma solidity ^0.8.0;
1929 
1930 /**
1931  * @dev Provides information about the current execution context, including the
1932  * sender of the transaction and its data. While these are generally available
1933  * via msg.sender and msg.data, they should not be accessed in such a direct
1934  * manner, since when dealing with meta-transactions the account sending and
1935  * paying for execution may not be the actual sender (as far as an application
1936  * is concerned).
1937  *
1938  * This contract is only required for intermediate, library-like contracts.
1939  */
1940 abstract contract Context {
1941     function _msgSender() internal view virtual returns (address) {
1942         return msg.sender;
1943     }
1944 
1945     function _msgData() internal view virtual returns (bytes calldata) {
1946         return msg.data;
1947     }
1948 }
1949 
1950 // File: @openzeppelin/contracts/access/Ownable.sol
1951 
1952 
1953 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1954 
1955 pragma solidity ^0.8.0;
1956 
1957 
1958 /**
1959  * @dev Contract module which provides a basic access control mechanism, where
1960  * there is an account (an owner) that can be granted exclusive access to
1961  * specific functions.
1962  *
1963  * By default, the owner account will be the one that deploys the contract. This
1964  * can later be changed with {transferOwnership}.
1965  *
1966  * This module is used through inheritance. It will make available the modifier
1967  * `onlyOwner`, which can be applied to your functions to restrict their use to
1968  * the owner.
1969  */
1970 abstract contract Ownable is Context {
1971     address private _owner;
1972 
1973     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1974 
1975     /**
1976      * @dev Initializes the contract setting the deployer as the initial owner.
1977      */
1978     constructor() {
1979         _transferOwnership(_msgSender());
1980     }
1981 
1982     /**
1983      * @dev Throws if called by any account other than the owner.
1984      */
1985     modifier onlyOwner() {
1986         _checkOwner();
1987         _;
1988     }
1989 
1990     /**
1991      * @dev Returns the address of the current owner.
1992      */
1993     function owner() public view virtual returns (address) {
1994         return _owner;
1995     }
1996 
1997     /**
1998      * @dev Throws if the sender is not the owner.
1999      */
2000     function _checkOwner() internal view virtual {
2001         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2002     }
2003 
2004     /**
2005      * @dev Leaves the contract without owner. It will not be possible to call
2006      * `onlyOwner` functions anymore. Can only be called by the current owner.
2007      *
2008      * NOTE: Renouncing ownership will leave the contract without an owner,
2009      * thereby removing any functionality that is only available to the owner.
2010      */
2011     function renounceOwnership() public virtual onlyOwner {
2012         _transferOwnership(address(0));
2013     }
2014 
2015     /**
2016      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2017      * Can only be called by the current owner.
2018      */
2019     function transferOwnership(address newOwner) public virtual onlyOwner {
2020         require(newOwner != address(0), "Ownable: new owner is the zero address");
2021         _transferOwnership(newOwner);
2022     }
2023 
2024     /**
2025      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2026      * Internal function without access restriction.
2027      */
2028     function _transferOwnership(address newOwner) internal virtual {
2029         address oldOwner = _owner;
2030         _owner = newOwner;
2031         emit OwnershipTransferred(oldOwner, newOwner);
2032     }
2033 }
2034 
2035 
2036 
2037 pragma solidity ^0.8.9;
2038 
2039 
2040 
2041 
2042 
2043 
2044 enum ContractStatus {
2045         disable,
2046         whitelist,
2047         open
2048     }
2049 
2050 contract TOYBIRDS is Ownable, ERC721A, ERC2981, ReentrancyGuard {
2051     bytes32 public rootHash =
2052         0x15fe95d79678244fdf487ef03caada0a0273930894ececd9f9ffa666bb74710f;
2053 
2054     ContractStatus public CONTRACT_STATUS = ContractStatus.disable;
2055 
2056     uint96 public immutable ROYALTY_FEE_NUMERATOR = 750;
2057 
2058     uint256 public immutable MAX_FREE_PER_WALLET = 1;
2059     uint256 public immutable MAX_TX_PER_WALLET = 2;
2060     uint256 public immutable PRICE = 0.012 ether;
2061     uint256 public immutable TOTAL_SUPPLY = 3000;
2062     uint256 public immutable WHITELIST_TOTAL_SUPPLY = 3000;
2063     string public uriSuffix = '.json';
2064 
2065     string internal baseURI = "";
2066 
2067     modifier isEthAvailable(uint256 quantity) {
2068         require(msg.value >= getSalePrice(msg.sender, quantity), "Insufficient funds");
2069         _;
2070     }
2071 
2072     modifier isMaxTxReached(uint256 quantity) {
2073         require(_numberMinted(msg.sender) + quantity <= MAX_TX_PER_WALLET, "Exceeded tx limit");
2074         _;
2075     }
2076 
2077     modifier isSupplyUnavailable(uint256 quantity) {
2078         require(totalSupply() + quantity <= TOTAL_SUPPLY, "Max supply reached");
2079         _;
2080     }
2081 
2082     modifier isUser() {
2083         require(tx.origin == msg.sender, "Invalid User");
2084         _;
2085     }
2086 
2087     constructor() ERC721A("Toybirds", "TOYBIRD") {
2088         _setDefaultRoyalty(owner(), ROYALTY_FEE_NUMERATOR);
2089     }
2090 
2091     function getTotalSupplyLeft() public view returns (uint256) {
2092         return TOTAL_SUPPLY - totalSupply();
2093     }
2094 
2095     function _baseURI() internal view virtual override returns (string memory) {
2096         return baseURI;
2097     }
2098 
2099     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2100         rootHash = _merkleRoot;
2101     }
2102 
2103     function isWhitelisted(bytes32[] memory merkleProof)
2104         public
2105         view
2106         returns (bool)
2107     {
2108         bytes memory encodedUserAddress = abi.encodePacked(msg.sender);
2109         bytes32 leaf = keccak256(encodedUserAddress);
2110         bool isProofValid = MerkleProof.verify(merkleProof, rootHash, leaf);
2111 
2112         return isProofValid;
2113     }
2114 
2115     function internalMint(address buyerAddress, uint256 quantity)
2116         external
2117         onlyOwner
2118         nonReentrant
2119         isUser
2120         isSupplyUnavailable(quantity)
2121     {
2122         _mint(buyerAddress, quantity);
2123     }
2124 
2125     function whitelistMint(uint256 quantity, bytes32[] memory merkleProof)
2126         public
2127         payable
2128         virtual
2129         nonReentrant
2130         isUser
2131         isSupplyUnavailable(quantity)
2132         isMaxTxReached(quantity)
2133         isEthAvailable(quantity)
2134     {
2135         require(CONTRACT_STATUS == ContractStatus.whitelist,"Not in whitelist mint stage");
2136         require(totalSupply() + quantity <= WHITELIST_TOTAL_SUPPLY, "Max whitelist mint supply reached");
2137         require(isWhitelisted(merkleProof), "Invalid Proof");
2138 
2139         _mint(msg.sender, quantity);
2140     }
2141 
2142     function publicMint(uint256 quantity)
2143         public
2144         payable
2145         virtual
2146         nonReentrant
2147         isUser
2148         isSupplyUnavailable(quantity)
2149         isMaxTxReached(quantity)
2150         isEthAvailable(quantity)
2151     {
2152         require(
2153             CONTRACT_STATUS == ContractStatus.open,
2154             "Not in whitelist mint stage"
2155         );
2156 
2157         _mint(msg.sender, quantity);
2158     }
2159 
2160     function getTotalMinted(address addr)
2161         public
2162         view
2163         returns (uint256)
2164     {
2165         return _numberMinted(addr);
2166     }
2167 
2168     function setBaseURI(string memory newURI) external virtual onlyOwner {
2169         baseURI = newURI;
2170     }
2171 
2172     function setStatus(ContractStatus status) external onlyOwner {
2173         CONTRACT_STATUS = status;
2174     }
2175 
2176     function _startTokenId() internal view virtual override returns (uint256) {
2177         return 1;
2178     }
2179 
2180     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2181         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2182 
2183         string memory currentBaseURI = _baseURI();
2184         return bytes(currentBaseURI).length > 0
2185             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
2186             : '';
2187     }
2188 
2189     function supportsInterface(bytes4 interfaceId)
2190         public
2191         view
2192         virtual
2193         override(ERC721A, ERC2981)
2194         returns (bool)
2195     {
2196         return
2197             ERC721A.supportsInterface(interfaceId) ||
2198             ERC2981.supportsInterface(interfaceId) ||
2199             super.supportsInterface(interfaceId);
2200     }
2201 
2202     function getSalePrice(address sender, uint256 quantity)
2203         private
2204         view
2205         returns (uint256)
2206     {
2207         bool isAlreadyMinted = _numberMinted(sender) > 0;
2208 
2209         return
2210             isAlreadyMinted
2211                 ? PRICE * (quantity)
2212                 : PRICE * (quantity - MAX_FREE_PER_WALLET);
2213     }
2214 
2215     function withdraw(uint256 balance)external onlyOwner nonReentrant isUser {
2216         (bool success, ) = msg.sender.call{value: balance}("");
2217 
2218         require(success, "Transfer failed.");
2219     }
2220 
2221     function withdrawAll() external onlyOwner nonReentrant isUser {
2222         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2223 
2224         require(success, "Transfer failed.");
2225     }
2226 }