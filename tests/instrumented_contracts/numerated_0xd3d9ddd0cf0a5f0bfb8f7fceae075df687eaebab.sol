1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // Archetype v0.2.0
70 
71 
72 // ERC721A Contracts v4.2.2
73 // Creator: Chiru Labs
74 
75 
76 
77 
78 // ERC721A Contracts v4.2.2
79 // Creator: Chiru Labs
80 
81 
82 
83 /**
84  * @dev Interface of ERC721A.
85  */
86 interface IERC721A {
87     /**
88      * The caller must own the token or be an approved operator.
89      */
90     error ApprovalCallerNotOwnerNorApproved();
91 
92     /**
93      * The token does not exist.
94      */
95     error ApprovalQueryForNonexistentToken();
96 
97     /**
98      * The caller cannot approve to their own address.
99      */
100     error ApproveToCaller();
101 
102     /**
103      * Cannot query the balance for the zero address.
104      */
105     error BalanceQueryForZeroAddress();
106 
107     /**
108      * Cannot mint to the zero address.
109      */
110     error MintToZeroAddress();
111 
112     /**
113      * The quantity of tokens minted must be more than zero.
114      */
115     error MintZeroQuantity();
116 
117     /**
118      * The token does not exist.
119      */
120     error OwnerQueryForNonexistentToken();
121 
122     /**
123      * The caller must own the token or be an approved operator.
124      */
125     error TransferCallerNotOwnerNorApproved();
126 
127     /**
128      * The token must be owned by `from`.
129      */
130     error TransferFromIncorrectOwner();
131 
132     /**
133      * Cannot safely transfer to a contract that does not implement the
134      * ERC721Receiver interface.
135      */
136     error TransferToNonERC721ReceiverImplementer();
137 
138     /**
139      * Cannot transfer to the zero address.
140      */
141     error TransferToZeroAddress();
142 
143     /**
144      * The token does not exist.
145      */
146     error URIQueryForNonexistentToken();
147 
148     /**
149      * The `quantity` minted with ERC2309 exceeds the safety limit.
150      */
151     error MintERC2309QuantityExceedsLimit();
152 
153     /**
154      * The `extraData` cannot be set on an unintialized ownership slot.
155      */
156     error OwnershipNotInitializedForExtraData();
157 
158     // =============================================================
159     //                            STRUCTS
160     // =============================================================
161 
162     struct TokenOwnership {
163         // The address of the owner.
164         address addr;
165         // Stores the start time of ownership with minimal overhead for tokenomics.
166         uint64 startTimestamp;
167         // Whether the token has been burned.
168         bool burned;
169         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
170         uint24 extraData;
171     }
172 
173     // =============================================================
174     //                         TOKEN COUNTERS
175     // =============================================================
176 
177     /**
178      * @dev Returns the total number of tokens in existence.
179      * Burned tokens will reduce the count.
180      * To get the total number of tokens minted, please see {_totalMinted}.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     // =============================================================
185     //                            IERC165
186     // =============================================================
187 
188     /**
189      * @dev Returns true if this contract implements the interface defined by
190      * `interfaceId`. See the corresponding
191      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
192      * to learn more about how these ids are created.
193      *
194      * This function call must use less than 30000 gas.
195      */
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 
198     // =============================================================
199     //                            IERC721
200     // =============================================================
201 
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables
214      * (`approved`) `operator` to manage all of its assets.
215      */
216     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
217 
218     /**
219      * @dev Returns the number of tokens in `owner`'s account.
220      */
221     function balanceOf(address owner) external view returns (uint256 balance);
222 
223     /**
224      * @dev Returns the owner of the `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function ownerOf(uint256 tokenId) external view returns (address owner);
231 
232     /**
233      * @dev Safely transfers `tokenId` token from `from` to `to`,
234      * checking first that contract recipients are aware of the ERC721 protocol
235      * to prevent tokens from being forever locked.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be have been allowed to move
243      * this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement
245      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246      *
247      * Emits a {Transfer} event.
248      */
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 
256     /**
257      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264 
265     /**
266      * @dev Transfers `tokenId` from `from` to `to`.
267      *
268      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
269      * whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token
277      * by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the
292      * zero address clears previous approvals.
293      *
294      * Requirements:
295      *
296      * - The caller must own the token or be an approved operator.
297      * - `tokenId` must exist.
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address to, uint256 tokenId) external;
302 
303     /**
304      * @dev Approve or remove `operator` as an operator for the caller.
305      * Operators can call {transferFrom} or {safeTransferFrom}
306      * for any token owned by the caller.
307      *
308      * Requirements:
309      *
310      * - The `operator` cannot be the caller.
311      *
312      * Emits an {ApprovalForAll} event.
313      */
314     function setApprovalForAll(address operator, bool _approved) external;
315 
316     /**
317      * @dev Returns the account approved for `tokenId` token.
318      *
319      * Requirements:
320      *
321      * - `tokenId` must exist.
322      */
323     function getApproved(uint256 tokenId) external view returns (address operator);
324 
325     /**
326      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
327      *
328      * See {setApprovalForAll}.
329      */
330     function isApprovedForAll(address owner, address operator) external view returns (bool);
331 
332     // =============================================================
333     //                        IERC721Metadata
334     // =============================================================
335 
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 
351     // =============================================================
352     //                           IERC2309
353     // =============================================================
354 
355     /**
356      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
357      * (inclusive) is transferred from `from` to `to`, as defined in the
358      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
359      *
360      * See {_mintERC2309} for more details.
361      */
362     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
363 }
364 
365 
366 /**
367  * @dev Interface of ERC721 token receiver.
368  */
369 interface ERC721A__IERC721Receiver {
370     function onERC721Received(
371         address operator,
372         address from,
373         uint256 tokenId,
374         bytes calldata data
375     ) external returns (bytes4);
376 }
377 
378 /**
379  * @title ERC721A
380  *
381  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
382  * Non-Fungible Token Standard, including the Metadata extension.
383  * Optimized for lower gas during batch mints.
384  *
385  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
386  * starting from `_startTokenId()`.
387  *
388  * Assumptions:
389  *
390  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
391  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
392  */
393 contract ERC721A is IERC721A {
394     // Reference type for token approval.
395     struct TokenApprovalRef {
396         address value;
397     }
398 
399     // =============================================================
400     //                           CONSTANTS
401     // =============================================================
402 
403     // Mask of an entry in packed address data.
404     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
405 
406     // The bit position of `numberMinted` in packed address data.
407     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
408 
409     // The bit position of `numberBurned` in packed address data.
410     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
411 
412     // The bit position of `aux` in packed address data.
413     uint256 private constant _BITPOS_AUX = 192;
414 
415     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
416     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
417 
418     // The bit position of `startTimestamp` in packed ownership.
419     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
420 
421     // The bit mask of the `burned` bit in packed ownership.
422     uint256 private constant _BITMASK_BURNED = 1 << 224;
423 
424     // The bit position of the `nextInitialized` bit in packed ownership.
425     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
426 
427     // The bit mask of the `nextInitialized` bit in packed ownership.
428     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
429 
430     // The bit position of `extraData` in packed ownership.
431     uint256 private constant _BITPOS_EXTRA_DATA = 232;
432 
433     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
434     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
435 
436     // The mask of the lower 160 bits for addresses.
437     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
438 
439     // The maximum `quantity` that can be minted with {_mintERC2309}.
440     // This limit is to prevent overflows on the address data entries.
441     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
442     // is required to cause an overflow, which is unrealistic.
443     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
444 
445     // The `Transfer` event signature is given by:
446     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
447     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
448         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
449 
450     // =============================================================
451     //                            STORAGE
452     // =============================================================
453 
454     // The next token ID to be minted.
455     uint256 private _currentIndex;
456 
457     // The number of tokens burned.
458     uint256 private _burnCounter;
459 
460     // Token name
461     string private _name;
462 
463     // Token symbol
464     string private _symbol;
465 
466     // Mapping from token ID to ownership details
467     // An empty struct value does not necessarily mean the token is unowned.
468     // See {_packedOwnershipOf} implementation for details.
469     //
470     // Bits Layout:
471     // - [0..159]   `addr`
472     // - [160..223] `startTimestamp`
473     // - [224]      `burned`
474     // - [225]      `nextInitialized`
475     // - [232..255] `extraData`
476     mapping(uint256 => uint256) private _packedOwnerships;
477 
478     // Mapping owner address to address data.
479     //
480     // Bits Layout:
481     // - [0..63]    `balance`
482     // - [64..127]  `numberMinted`
483     // - [128..191] `numberBurned`
484     // - [192..255] `aux`
485     mapping(address => uint256) private _packedAddressData;
486 
487     // Mapping from token ID to approved address.
488     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
489 
490     // Mapping from owner to operator approvals
491     mapping(address => mapping(address => bool)) private _operatorApprovals;
492 
493     // =============================================================
494     //                          CONSTRUCTOR
495     // =============================================================
496 
497     constructor(string memory name_, string memory symbol_) {
498         _name = name_;
499         _symbol = symbol_;
500         _currentIndex = _startTokenId();
501     }
502 
503     // =============================================================
504     //                   TOKEN COUNTING OPERATIONS
505     // =============================================================
506 
507     /**
508      * @dev Returns the starting token ID.
509      * To change the starting token ID, please override this function.
510      */
511     function _startTokenId() internal view virtual returns (uint256) {
512         return 0;
513     }
514 
515     /**
516      * @dev Returns the next token ID to be minted.
517      */
518     function _nextTokenId() internal view virtual returns (uint256) {
519         return _currentIndex;
520     }
521 
522     /**
523      * @dev Returns the total number of tokens in existence.
524      * Burned tokens will reduce the count.
525      * To get the total number of tokens minted, please see {_totalMinted}.
526      */
527     function totalSupply() public view virtual override returns (uint256) {
528         // Counter underflow is impossible as _burnCounter cannot be incremented
529         // more than `_currentIndex - _startTokenId()` times.
530         unchecked {
531             return _currentIndex - _burnCounter - _startTokenId();
532         }
533     }
534 
535     /**
536      * @dev Returns the total amount of tokens minted in the contract.
537      */
538     function _totalMinted() internal view virtual returns (uint256) {
539         // Counter underflow is impossible as `_currentIndex` does not decrement,
540         // and it is initialized to `_startTokenId()`.
541         unchecked {
542             return _currentIndex - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total number of tokens burned.
548      */
549     function _totalBurned() internal view virtual returns (uint256) {
550         return _burnCounter;
551     }
552 
553     // =============================================================
554     //                    ADDRESS DATA OPERATIONS
555     // =============================================================
556 
557     /**
558      * @dev Returns the number of tokens in `owner`'s account.
559      */
560     function balanceOf(address owner) public view virtual override returns (uint256) {
561         if (owner == address(0)) revert BalanceQueryForZeroAddress();
562         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens minted by `owner`.
567      */
568     function _numberMinted(address owner) internal view returns (uint256) {
569         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the number of tokens burned by or on behalf of `owner`.
574      */
575     function _numberBurned(address owner) internal view returns (uint256) {
576         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
577     }
578 
579     /**
580      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
581      */
582     function _getAux(address owner) internal view returns (uint64) {
583         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
584     }
585 
586     /**
587      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
588      * If there are multiple variables, please pack them into a uint64.
589      */
590     function _setAux(address owner, uint64 aux) internal virtual {
591         uint256 packed = _packedAddressData[owner];
592         uint256 auxCasted;
593         // Cast `aux` with assembly to avoid redundant masking.
594         assembly {
595             auxCasted := aux
596         }
597         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
598         _packedAddressData[owner] = packed;
599     }
600 
601     // =============================================================
602     //                            IERC165
603     // =============================================================
604 
605     /**
606      * @dev Returns true if this contract implements the interface defined by
607      * `interfaceId`. See the corresponding
608      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
609      * to learn more about how these ids are created.
610      *
611      * This function call must use less than 30000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         // The interface IDs are constants representing the first 4 bytes
615         // of the XOR of all function selectors in the interface.
616         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
617         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
618         return
619             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
620             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
621             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
622     }
623 
624     // =============================================================
625     //                        IERC721Metadata
626     // =============================================================
627 
628     /**
629      * @dev Returns the token collection name.
630      */
631     function name() public view virtual override returns (string memory) {
632         return _name;
633     }
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() public view virtual override returns (string memory) {
639         return _symbol;
640     }
641 
642     /**
643      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
644      */
645     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
646         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
647 
648         string memory baseURI = _baseURI();
649         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, it can be overridden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return '';
659     }
660 
661     // =============================================================
662     //                     OWNERSHIPS OPERATIONS
663     // =============================================================
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
673         return address(uint160(_packedOwnershipOf(tokenId)));
674     }
675 
676     /**
677      * @dev Gas spent here starts off proportional to the maximum mint batch size.
678      * It gradually moves to O(1) as tokens get transferred around over time.
679      */
680     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
681         return _unpackedOwnership(_packedOwnershipOf(tokenId));
682     }
683 
684     /**
685      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
686      */
687     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
688         return _unpackedOwnership(_packedOwnerships[index]);
689     }
690 
691     /**
692      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
693      */
694     function _initializeOwnershipAt(uint256 index) internal virtual {
695         if (_packedOwnerships[index] == 0) {
696             _packedOwnerships[index] = _packedOwnershipOf(index);
697         }
698     }
699 
700     /**
701      * Returns the packed ownership data of `tokenId`.
702      */
703     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
704         uint256 curr = tokenId;
705 
706         unchecked {
707             if (_startTokenId() <= curr)
708                 if (curr < _currentIndex) {
709                     uint256 packed = _packedOwnerships[curr];
710                     // If not burned.
711                     if (packed & _BITMASK_BURNED == 0) {
712                         // Invariant:
713                         // There will always be an initialized ownership slot
714                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
715                         // before an unintialized ownership slot
716                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
717                         // Hence, `curr` will not underflow.
718                         //
719                         // We can directly compare the packed value.
720                         // If the address is zero, packed will be zero.
721                         while (packed == 0) {
722                             packed = _packedOwnerships[--curr];
723                         }
724                         return packed;
725                     }
726                 }
727         }
728         revert OwnerQueryForNonexistentToken();
729     }
730 
731     /**
732      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
733      */
734     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
735         ownership.addr = address(uint160(packed));
736         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
737         ownership.burned = packed & _BITMASK_BURNED != 0;
738         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
739     }
740 
741     /**
742      * @dev Packs ownership data into a single uint256.
743      */
744     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
745         assembly {
746             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
747             owner := and(owner, _BITMASK_ADDRESS)
748             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
749             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
750         }
751     }
752 
753     /**
754      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
755      */
756     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
757         // For branchless setting of the `nextInitialized` flag.
758         assembly {
759             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
760             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
761         }
762     }
763 
764     // =============================================================
765     //                      APPROVAL OPERATIONS
766     // =============================================================
767 
768     /**
769      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
770      * The approval is cleared when the token is transferred.
771      *
772      * Only a single account can be approved at a time, so approving the
773      * zero address clears previous approvals.
774      *
775      * Requirements:
776      *
777      * - The caller must own the token or be an approved operator.
778      * - `tokenId` must exist.
779      *
780      * Emits an {Approval} event.
781      */
782     function approve(address to, uint256 tokenId) public virtual override {
783         address owner = ownerOf(tokenId);
784 
785         if (_msgSenderERC721A() != owner)
786             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
787                 revert ApprovalCallerNotOwnerNorApproved();
788             }
789 
790         _tokenApprovals[tokenId].value = to;
791         emit Approval(owner, to, tokenId);
792     }
793 
794     /**
795      * @dev Returns the account approved for `tokenId` token.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function getApproved(uint256 tokenId) public view virtual override returns (address) {
802         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
803 
804         return _tokenApprovals[tokenId].value;
805     }
806 
807     /**
808      * @dev Approve or remove `operator` as an operator for the caller.
809      * Operators can call {transferFrom} or {safeTransferFrom}
810      * for any token owned by the caller.
811      *
812      * Requirements:
813      *
814      * - The `operator` cannot be the caller.
815      *
816      * Emits an {ApprovalForAll} event.
817      */
818     function setApprovalForAll(address operator, bool approved) public virtual override {
819         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
820 
821         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
822         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
823     }
824 
825     /**
826      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
827      *
828      * See {setApprovalForAll}.
829      */
830     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
831         return _operatorApprovals[owner][operator];
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted. See {_mint}.
840      */
841     function _exists(uint256 tokenId) internal view virtual returns (bool) {
842         return
843             _startTokenId() <= tokenId &&
844             tokenId < _currentIndex && // If within bounds,
845             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
846     }
847 
848     /**
849      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
850      */
851     function _isSenderApprovedOrOwner(
852         address approvedAddress,
853         address owner,
854         address msgSender
855     ) private pure returns (bool result) {
856         assembly {
857             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
858             owner := and(owner, _BITMASK_ADDRESS)
859             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
860             msgSender := and(msgSender, _BITMASK_ADDRESS)
861             // `msgSender == owner || msgSender == approvedAddress`.
862             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
863         }
864     }
865 
866     /**
867      * @dev Returns the storage slot and value for the approved address of `tokenId`.
868      */
869     function _getApprovedSlotAndAddress(uint256 tokenId)
870         private
871         view
872         returns (uint256 approvedAddressSlot, address approvedAddress)
873     {
874         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
875         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
876         assembly {
877             approvedAddressSlot := tokenApproval.slot
878             approvedAddress := sload(approvedAddressSlot)
879         }
880     }
881 
882     // =============================================================
883     //                      TRANSFER OPERATIONS
884     // =============================================================
885 
886     /**
887      * @dev Transfers `tokenId` from `from` to `to`.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must be owned by `from`.
894      * - If the caller is not `from`, it must be approved to move this token
895      * by either {approve} or {setApprovalForAll}.
896      *
897      * Emits a {Transfer} event.
898      */
899     function transferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
905 
906         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
907 
908         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
909 
910         // The nested ifs save around 20+ gas over a compound boolean condition.
911         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
912             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
913 
914         if (to == address(0)) revert TransferToZeroAddress();
915 
916         _beforeTokenTransfers(from, to, tokenId, 1);
917 
918         // Clear approvals from the previous owner.
919         assembly {
920             if approvedAddress {
921                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
922                 sstore(approvedAddressSlot, 0)
923             }
924         }
925 
926         // Underflow of the sender's balance is impossible because we check for
927         // ownership above and the recipient's balance can't realistically overflow.
928         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
929         unchecked {
930             // We can directly increment and decrement the balances.
931             --_packedAddressData[from]; // Updates: `balance -= 1`.
932             ++_packedAddressData[to]; // Updates: `balance += 1`.
933 
934             // Updates:
935             // - `address` to the next owner.
936             // - `startTimestamp` to the timestamp of transfering.
937             // - `burned` to `false`.
938             // - `nextInitialized` to `true`.
939             _packedOwnerships[tokenId] = _packOwnershipData(
940                 to,
941                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
942             );
943 
944             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
945             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
946                 uint256 nextTokenId = tokenId + 1;
947                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
948                 if (_packedOwnerships[nextTokenId] == 0) {
949                     // If the next slot is within bounds.
950                     if (nextTokenId != _currentIndex) {
951                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
952                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
953                     }
954                 }
955             }
956         }
957 
958         emit Transfer(from, to, tokenId);
959         _afterTokenTransfers(from, to, tokenId, 1);
960     }
961 
962     /**
963      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, '');
971     }
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`.
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must exist and be owned by `from`.
981      * - If the caller is not `from`, it must be approved to move this token
982      * by either {approve} or {setApprovalForAll}.
983      * - If `to` refers to a smart contract, it must implement
984      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
985      *
986      * Emits a {Transfer} event.
987      */
988     function safeTransferFrom(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) public virtual override {
994         transferFrom(from, to, tokenId);
995         if (to.code.length != 0)
996             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
997                 revert TransferToNonERC721ReceiverImplementer();
998             }
999     }
1000 
1001     /**
1002      * @dev Hook that is called before a set of serially-ordered token IDs
1003      * are about to be transferred. This includes minting.
1004      * And also called before burning one token.
1005      *
1006      * `startTokenId` - the first token ID to be transferred.
1007      * `quantity` - the amount to be transferred.
1008      *
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` will be minted for `to`.
1014      * - When `to` is zero, `tokenId` will be burned by `from`.
1015      * - `from` and `to` are never both zero.
1016      */
1017     function _beforeTokenTransfers(
1018         address from,
1019         address to,
1020         uint256 startTokenId,
1021         uint256 quantity
1022     ) internal virtual {}
1023 
1024     /**
1025      * @dev Hook that is called after a set of serially-ordered token IDs
1026      * have been transferred. This includes minting.
1027      * And also called after one token has been burned.
1028      *
1029      * `startTokenId` - the first token ID to be transferred.
1030      * `quantity` - the amount to be transferred.
1031      *
1032      * Calling conditions:
1033      *
1034      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1035      * transferred to `to`.
1036      * - When `from` is zero, `tokenId` has been minted for `to`.
1037      * - When `to` is zero, `tokenId` has been burned by `from`.
1038      * - `from` and `to` are never both zero.
1039      */
1040     function _afterTokenTransfers(
1041         address from,
1042         address to,
1043         uint256 startTokenId,
1044         uint256 quantity
1045     ) internal virtual {}
1046 
1047     /**
1048      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1049      *
1050      * `from` - Previous owner of the given token ID.
1051      * `to` - Target address that will receive the token.
1052      * `tokenId` - Token ID to be transferred.
1053      * `_data` - Optional data to send along with the call.
1054      *
1055      * Returns whether the call correctly returned the expected magic value.
1056      */
1057     function _checkContractOnERC721Received(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) private returns (bool) {
1063         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1064             bytes4 retval
1065         ) {
1066             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1067         } catch (bytes memory reason) {
1068             if (reason.length == 0) {
1069                 revert TransferToNonERC721ReceiverImplementer();
1070             } else {
1071                 assembly {
1072                     revert(add(32, reason), mload(reason))
1073                 }
1074             }
1075         }
1076     }
1077 
1078     // =============================================================
1079     //                        MINT OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event for each mint.
1091      */
1092     function _mint(address to, uint256 quantity) internal virtual {
1093         uint256 startTokenId = _currentIndex;
1094         if (quantity == 0) revert MintZeroQuantity();
1095 
1096         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098         // Overflows are incredibly unrealistic.
1099         // `balance` and `numberMinted` have a maximum limit of 2**64.
1100         // `tokenId` has a maximum limit of 2**256.
1101         unchecked {
1102             // Updates:
1103             // - `balance += quantity`.
1104             // - `numberMinted += quantity`.
1105             //
1106             // We can directly add to the `balance` and `numberMinted`.
1107             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1108 
1109             // Updates:
1110             // - `address` to the owner.
1111             // - `startTimestamp` to the timestamp of minting.
1112             // - `burned` to `false`.
1113             // - `nextInitialized` to `quantity == 1`.
1114             _packedOwnerships[startTokenId] = _packOwnershipData(
1115                 to,
1116                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1117             );
1118 
1119             uint256 toMasked;
1120             uint256 end = startTokenId + quantity;
1121 
1122             // Use assembly to loop and emit the `Transfer` event for gas savings.
1123             // The duplicated `log4` removes an extra check and reduces stack juggling.
1124             // The assembly, together with the surrounding Solidity code, have been
1125             // delicately arranged to nudge the compiler into producing optimized opcodes.
1126             assembly {
1127                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1128                 toMasked := and(to, _BITMASK_ADDRESS)
1129                 // Emit the `Transfer` event.
1130                 log4(
1131                     0, // Start of data (0, since no data).
1132                     0, // End of data (0, since no data).
1133                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1134                     0, // `address(0)`.
1135                     toMasked, // `to`.
1136                     startTokenId // `tokenId`.
1137                 )
1138 
1139                 for {
1140                     let tokenId := add(startTokenId, 1)
1141                 } iszero(eq(tokenId, end)) {
1142                     tokenId := add(tokenId, 1)
1143                 } {
1144                     // Emit the `Transfer` event. Similar to above.
1145                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1146                 }
1147             }
1148             if (toMasked == 0) revert MintToZeroAddress();
1149 
1150             _currentIndex = end;
1151         }
1152         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1153     }
1154 
1155     /**
1156      * @dev Mints `quantity` tokens and transfers them to `to`.
1157      *
1158      * This function is intended for efficient minting only during contract creation.
1159      *
1160      * It emits only one {ConsecutiveTransfer} as defined in
1161      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1162      * instead of a sequence of {Transfer} event(s).
1163      *
1164      * Calling this function outside of contract creation WILL make your contract
1165      * non-compliant with the ERC721 standard.
1166      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1167      * {ConsecutiveTransfer} event is only permissible during contract creation.
1168      *
1169      * Requirements:
1170      *
1171      * - `to` cannot be the zero address.
1172      * - `quantity` must be greater than 0.
1173      *
1174      * Emits a {ConsecutiveTransfer} event.
1175      */
1176     function _mintERC2309(address to, uint256 quantity) internal virtual {
1177         uint256 startTokenId = _currentIndex;
1178         if (to == address(0)) revert MintToZeroAddress();
1179         if (quantity == 0) revert MintZeroQuantity();
1180         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1181 
1182         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1183 
1184         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1185         unchecked {
1186             // Updates:
1187             // - `balance += quantity`.
1188             // - `numberMinted += quantity`.
1189             //
1190             // We can directly add to the `balance` and `numberMinted`.
1191             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1192 
1193             // Updates:
1194             // - `address` to the owner.
1195             // - `startTimestamp` to the timestamp of minting.
1196             // - `burned` to `false`.
1197             // - `nextInitialized` to `quantity == 1`.
1198             _packedOwnerships[startTokenId] = _packOwnershipData(
1199                 to,
1200                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1201             );
1202 
1203             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1204 
1205             _currentIndex = startTokenId + quantity;
1206         }
1207         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1208     }
1209 
1210     /**
1211      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - If `to` refers to a smart contract, it must implement
1216      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1217      * - `quantity` must be greater than 0.
1218      *
1219      * See {_mint}.
1220      *
1221      * Emits a {Transfer} event for each mint.
1222      */
1223     function _safeMint(
1224         address to,
1225         uint256 quantity,
1226         bytes memory _data
1227     ) internal virtual {
1228         _mint(to, quantity);
1229 
1230         unchecked {
1231             if (to.code.length != 0) {
1232                 uint256 end = _currentIndex;
1233                 uint256 index = end - quantity;
1234                 do {
1235                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1236                         revert TransferToNonERC721ReceiverImplementer();
1237                     }
1238                 } while (index < end);
1239                 // Reentrancy protection.
1240                 if (_currentIndex != end) revert();
1241             }
1242         }
1243     }
1244 
1245     /**
1246      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1247      */
1248     function _safeMint(address to, uint256 quantity) internal virtual {
1249         _safeMint(to, quantity, '');
1250     }
1251 
1252     // =============================================================
1253     //                        BURN OPERATIONS
1254     // =============================================================
1255 
1256     /**
1257      * @dev Equivalent to `_burn(tokenId, false)`.
1258      */
1259     function _burn(uint256 tokenId) internal virtual {
1260         _burn(tokenId, false);
1261     }
1262 
1263     /**
1264      * @dev Destroys `tokenId`.
1265      * The approval is cleared when the token is burned.
1266      *
1267      * Requirements:
1268      *
1269      * - `tokenId` must exist.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1274         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1275 
1276         address from = address(uint160(prevOwnershipPacked));
1277 
1278         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1279 
1280         if (approvalCheck) {
1281             // The nested ifs save around 20+ gas over a compound boolean condition.
1282             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1283                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1284         }
1285 
1286         _beforeTokenTransfers(from, address(0), tokenId, 1);
1287 
1288         // Clear approvals from the previous owner.
1289         assembly {
1290             if approvedAddress {
1291                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1292                 sstore(approvedAddressSlot, 0)
1293             }
1294         }
1295 
1296         // Underflow of the sender's balance is impossible because we check for
1297         // ownership above and the recipient's balance can't realistically overflow.
1298         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1299         unchecked {
1300             // Updates:
1301             // - `balance -= 1`.
1302             // - `numberBurned += 1`.
1303             //
1304             // We can directly decrement the balance, and increment the number burned.
1305             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1306             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1307 
1308             // Updates:
1309             // - `address` to the last owner.
1310             // - `startTimestamp` to the timestamp of burning.
1311             // - `burned` to `true`.
1312             // - `nextInitialized` to `true`.
1313             _packedOwnerships[tokenId] = _packOwnershipData(
1314                 from,
1315                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1316             );
1317 
1318             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1319             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1320                 uint256 nextTokenId = tokenId + 1;
1321                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1322                 if (_packedOwnerships[nextTokenId] == 0) {
1323                     // If the next slot is within bounds.
1324                     if (nextTokenId != _currentIndex) {
1325                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1326                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1327                     }
1328                 }
1329             }
1330         }
1331 
1332         emit Transfer(from, address(0), tokenId);
1333         _afterTokenTransfers(from, address(0), tokenId, 1);
1334 
1335         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1336         unchecked {
1337             _burnCounter++;
1338         }
1339     }
1340 
1341     // =============================================================
1342     //                     EXTRA DATA OPERATIONS
1343     // =============================================================
1344 
1345     /**
1346      * @dev Directly sets the extra data for the ownership data `index`.
1347      */
1348     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1349         uint256 packed = _packedOwnerships[index];
1350         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1351         uint256 extraDataCasted;
1352         // Cast `extraData` with assembly to avoid redundant masking.
1353         assembly {
1354             extraDataCasted := extraData
1355         }
1356         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1357         _packedOwnerships[index] = packed;
1358     }
1359 
1360     /**
1361      * @dev Called during each token transfer to set the 24bit `extraData` field.
1362      * Intended to be overridden by the cosumer contract.
1363      *
1364      * `previousExtraData` - the value of `extraData` before transfer.
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, `tokenId` will be burned by `from`.
1372      * - `from` and `to` are never both zero.
1373      */
1374     function _extraData(
1375         address from,
1376         address to,
1377         uint24 previousExtraData
1378     ) internal view virtual returns (uint24) {}
1379 
1380     /**
1381      * @dev Returns the next extra data for the packed ownership data.
1382      * The returned result is shifted into position.
1383      */
1384     function _nextExtraData(
1385         address from,
1386         address to,
1387         uint256 prevOwnershipPacked
1388     ) private view returns (uint256) {
1389         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1390         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1391     }
1392 
1393     // =============================================================
1394     //                       OTHER OPERATIONS
1395     // =============================================================
1396 
1397     /**
1398      * @dev Returns the message sender (defaults to `msg.sender`).
1399      *
1400      * If you are writing GSN compatible contracts, you need to override this function.
1401      */
1402     function _msgSenderERC721A() internal view virtual returns (address) {
1403         return msg.sender;
1404     }
1405 
1406     /**
1407      * @dev Converts a uint256 to its ASCII string decimal representation.
1408      */
1409     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1410         assembly {
1411             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1412             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1413             // We will need 1 32-byte word to store the length,
1414             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1415             str := add(mload(0x40), 0x80)
1416             // Update the free memory pointer to allocate.
1417             mstore(0x40, str)
1418 
1419             // Cache the end of the memory to calculate the length later.
1420             let end := str
1421 
1422             // We write the string from rightmost digit to leftmost digit.
1423             // The following is essentially a do-while loop that also handles the zero case.
1424             // prettier-ignore
1425             for { let temp := value } 1 {} {
1426                 str := sub(str, 1)
1427                 // Write the character to the pointer.
1428                 // The ASCII index of the '0' character is 48.
1429                 mstore8(str, add(48, mod(temp, 10)))
1430                 // Keep dividing `temp` until zero.
1431                 temp := div(temp, 10)
1432                 // prettier-ignore
1433                 if iszero(temp) { break }
1434             }
1435 
1436             let length := sub(end, str)
1437             // Move the pointer 32 bytes leftwards to make room for the length.
1438             str := sub(str, 0x20)
1439             // Store the length.
1440             mstore(str, length)
1441         }
1442     }
1443 }
1444 
1445 
1446 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1447 
1448 
1449 
1450 
1451 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1452 
1453 
1454 
1455 /**
1456  * @dev Provides information about the current execution context, including the
1457  * sender of the transaction and its data. While these are generally available
1458  * via msg.sender and msg.data, they should not be accessed in such a direct
1459  * manner, since when dealing with meta-transactions the account sending and
1460  * paying for execution may not be the actual sender (as far as an application
1461  * is concerned).
1462  *
1463  * This contract is only required for intermediate, library-like contracts.
1464  */
1465 abstract contract Context {
1466     function _msgSender() internal view virtual returns (address) {
1467         return msg.sender;
1468     }
1469 
1470     function _msgData() internal view virtual returns (bytes calldata) {
1471         return msg.data;
1472     }
1473 }
1474 
1475 
1476 /**
1477  * @dev Contract module which provides a basic access control mechanism, where
1478  * there is an account (an owner) that can be granted exclusive access to
1479  * specific functions.
1480  *
1481  * By default, the owner account will be the one that deploys the contract. This
1482  * can later be changed with {transferOwnership}.
1483  *
1484  * This module is used through inheritance. It will make available the modifier
1485  * `onlyOwner`, which can be applied to your functions to restrict their use to
1486  * the owner.
1487  */
1488 abstract contract Ownable is Context {
1489     address private _owner;
1490 
1491     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1492 
1493     /**
1494      * @dev Initializes the contract setting the deployer as the initial owner.
1495      */
1496     constructor() {
1497         _transferOwnership(_msgSender());
1498     }
1499 
1500     /**
1501      * @dev Returns the address of the current owner.
1502      */
1503     function owner() public view virtual returns (address) {
1504         return _owner;
1505     }
1506 
1507     /**
1508      * @dev Throws if called by any account other than the owner.
1509      */
1510     modifier onlyOwner() {
1511         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1512         _;
1513     }
1514 
1515     /**
1516      * @dev Leaves the contract without owner. It will not be possible to call
1517      * `onlyOwner` functions anymore. Can only be called by the current owner.
1518      *
1519      * NOTE: Renouncing ownership will leave the contract without an owner,
1520      * thereby removing any functionality that is only available to the owner.
1521      */
1522     function renounceOwnership() public virtual onlyOwner {
1523         _transferOwnership(address(0));
1524     }
1525 
1526     /**
1527      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1528      * Can only be called by the current owner.
1529      */
1530     function transferOwnership(address newOwner) public virtual onlyOwner {
1531         require(newOwner != address(0), "Ownable: new owner is the zero address");
1532         _transferOwnership(newOwner);
1533     }
1534 
1535     /**
1536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1537      * Internal function without access restriction.
1538      */
1539     function _transferOwnership(address newOwner) internal virtual {
1540         address oldOwner = _owner;
1541         _owner = newOwner;
1542         emit OwnershipTransferred(oldOwner, newOwner);
1543     }
1544 }
1545 
1546 
1547 
1548 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1549 
1550 
1551 
1552 
1553 
1554 /**
1555  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1556  *
1557  * These functions can be used to verify that a message was signed by the holder
1558  * of the private keys of a given address.
1559  */
1560 library ECDSA {
1561     enum RecoverError {
1562         NoError,
1563         InvalidSignature,
1564         InvalidSignatureLength,
1565         InvalidSignatureS,
1566         InvalidSignatureV
1567     }
1568 
1569     function _throwError(RecoverError error) private pure {
1570         if (error == RecoverError.NoError) {
1571             return; // no error: do nothing
1572         } else if (error == RecoverError.InvalidSignature) {
1573             revert("ECDSA: invalid signature");
1574         } else if (error == RecoverError.InvalidSignatureLength) {
1575             revert("ECDSA: invalid signature length");
1576         } else if (error == RecoverError.InvalidSignatureS) {
1577             revert("ECDSA: invalid signature 's' value");
1578         } else if (error == RecoverError.InvalidSignatureV) {
1579             revert("ECDSA: invalid signature 'v' value");
1580         }
1581     }
1582 
1583     /**
1584      * @dev Returns the address that signed a hashed message (`hash`) with
1585      * `signature` or error string. This address can then be used for verification purposes.
1586      *
1587      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1588      * this function rejects them by requiring the `s` value to be in the lower
1589      * half order, and the `v` value to be either 27 or 28.
1590      *
1591      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1592      * verification to be secure: it is possible to craft signatures that
1593      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1594      * this is by receiving a hash of the original message (which may otherwise
1595      * be too long), and then calling {toEthSignedMessageHash} on it.
1596      *
1597      * Documentation for signature generation:
1598      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1599      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1600      *
1601      * _Available since v4.3._
1602      */
1603     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1604         // Check the signature length
1605         // - case 65: r,s,v signature (standard)
1606         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1607         if (signature.length == 65) {
1608             bytes32 r;
1609             bytes32 s;
1610             uint8 v;
1611             // ecrecover takes the signature parameters, and the only way to get them
1612             // currently is to use assembly.
1613             assembly {
1614                 r := mload(add(signature, 0x20))
1615                 s := mload(add(signature, 0x40))
1616                 v := byte(0, mload(add(signature, 0x60)))
1617             }
1618             return tryRecover(hash, v, r, s);
1619         } else if (signature.length == 64) {
1620             bytes32 r;
1621             bytes32 vs;
1622             // ecrecover takes the signature parameters, and the only way to get them
1623             // currently is to use assembly.
1624             assembly {
1625                 r := mload(add(signature, 0x20))
1626                 vs := mload(add(signature, 0x40))
1627             }
1628             return tryRecover(hash, r, vs);
1629         } else {
1630             return (address(0), RecoverError.InvalidSignatureLength);
1631         }
1632     }
1633 
1634     /**
1635      * @dev Returns the address that signed a hashed message (`hash`) with
1636      * `signature`. This address can then be used for verification purposes.
1637      *
1638      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1639      * this function rejects them by requiring the `s` value to be in the lower
1640      * half order, and the `v` value to be either 27 or 28.
1641      *
1642      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1643      * verification to be secure: it is possible to craft signatures that
1644      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1645      * this is by receiving a hash of the original message (which may otherwise
1646      * be too long), and then calling {toEthSignedMessageHash} on it.
1647      */
1648     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1649         (address recovered, RecoverError error) = tryRecover(hash, signature);
1650         _throwError(error);
1651         return recovered;
1652     }
1653 
1654     /**
1655      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1656      *
1657      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1658      *
1659      * _Available since v4.3._
1660      */
1661     function tryRecover(
1662         bytes32 hash,
1663         bytes32 r,
1664         bytes32 vs
1665     ) internal pure returns (address, RecoverError) {
1666         bytes32 s;
1667         uint8 v;
1668         assembly {
1669             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1670             v := add(shr(255, vs), 27)
1671         }
1672         return tryRecover(hash, v, r, s);
1673     }
1674 
1675     /**
1676      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1677      *
1678      * _Available since v4.2._
1679      */
1680     function recover(
1681         bytes32 hash,
1682         bytes32 r,
1683         bytes32 vs
1684     ) internal pure returns (address) {
1685         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1686         _throwError(error);
1687         return recovered;
1688     }
1689 
1690     /**
1691      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1692      * `r` and `s` signature fields separately.
1693      *
1694      * _Available since v4.3._
1695      */
1696     function tryRecover(
1697         bytes32 hash,
1698         uint8 v,
1699         bytes32 r,
1700         bytes32 s
1701     ) internal pure returns (address, RecoverError) {
1702         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1703         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1704         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1705         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1706         //
1707         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1708         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1709         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1710         // these malleable signatures as well.
1711         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1712             return (address(0), RecoverError.InvalidSignatureS);
1713         }
1714         if (v != 27 && v != 28) {
1715             return (address(0), RecoverError.InvalidSignatureV);
1716         }
1717 
1718         // If the signature is valid (and not malleable), return the signer address
1719         address signer = ecrecover(hash, v, r, s);
1720         if (signer == address(0)) {
1721             return (address(0), RecoverError.InvalidSignature);
1722         }
1723 
1724         return (signer, RecoverError.NoError);
1725     }
1726 
1727     /**
1728      * @dev Overload of {ECDSA-recover} that receives the `v`,
1729      * `r` and `s` signature fields separately.
1730      */
1731     function recover(
1732         bytes32 hash,
1733         uint8 v,
1734         bytes32 r,
1735         bytes32 s
1736     ) internal pure returns (address) {
1737         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1738         _throwError(error);
1739         return recovered;
1740     }
1741 
1742     /**
1743      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1744      * produces hash corresponding to the one signed with the
1745      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1746      * JSON-RPC method as part of EIP-191.
1747      *
1748      * See {recover}.
1749      */
1750     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1751         // 32 is the length in bytes of hash,
1752         // enforced by the type signature above
1753         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1754     }
1755 
1756     /**
1757      * @dev Returns an Ethereum Signed Message, created from `s`. This
1758      * produces hash corresponding to the one signed with the
1759      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1760      * JSON-RPC method as part of EIP-191.
1761      *
1762      * See {recover}.
1763      */
1764     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1765         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1766     }
1767 
1768     /**
1769      * @dev Returns an Ethereum Signed Typed Data, created from a
1770      * `domainSeparator` and a `structHash`. This produces hash corresponding
1771      * to the one signed with the
1772      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1773      * JSON-RPC method as part of EIP-712.
1774      *
1775      * See {recover}.
1776      */
1777     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1778         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1779     }
1780 }
1781 
1782 //import "hardhat/console.sol";
1783 
1784 error InvalidConfig();
1785 error MintNotYetStarted();
1786 error WalletUnauthorizedToMint();
1787 error InsufficientEthSent();
1788 error ExcessiveEthSent();
1789 error MaxSupplyExceeded();
1790 error NumberOfMintsExceeded();
1791 error MintingPaused();
1792 error InvalidReferral();
1793 error InvalidSignature();
1794 error BalanceEmpty();
1795 error TransferFailed();
1796 error MaxBatchSizeExceeded();
1797 error WrongPassword();
1798 error LockedForever();
1799 
1800 contract Remilia is ERC721A, Ownable {
1801   //
1802   // EVENTS
1803   //
1804   event Invited(bytes32 indexed key, bytes32 indexed cid);
1805   event Referral(address indexed affiliate, uint128 wad);
1806   event Withdrawal(address indexed src, uint128 wad);
1807 
1808   //
1809   // STRUCTS
1810   //
1811   struct Auth {
1812     bytes32 key;
1813     bytes32[] proof;
1814   }
1815 
1816   struct Config {
1817     string unrevealedUri;
1818     string baseUri;
1819     address affiliateSigner;
1820     uint32 maxSupply;
1821     uint32 maxBatchSize;
1822     uint32 affiliateFee;
1823     uint32 platformFee;
1824   }
1825 
1826   struct Invite {
1827     uint128 price;
1828     uint64 start;
1829     uint64 limit;
1830   }
1831 
1832   struct Invitelist {
1833     bytes32 key;
1834     bytes32 cid;
1835     Invite invite;
1836   }
1837 
1838   struct OwnerBalance {
1839     uint128 owner;
1840     uint128 platform;
1841   }
1842 
1843   //
1844   // VARIABLES
1845   //
1846   mapping(bytes32 => Invite) public invites;
1847   mapping(address => mapping(bytes32 => uint256)) private minted;
1848   mapping(address => uint128) public affiliateBalance;
1849   address private constant PLATFORM = 0x86B82972282Dd22348374bC63fd21620F7ED847B;
1850   // address private constant PLATFORM = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC; // TEST (account[2])
1851   bool public revealed;
1852   bool public uriUnlocked;
1853   string public provenance;
1854   bool public provenanceHashUnlocked;
1855   OwnerBalance public ownerBalance;
1856   Config public config;
1857 
1858   //
1859   // METHODS
1860   //
1861   constructor(
1862 
1863   ) ERC721A("TEST NFT", "TEST") {
1864   
1865 	config.baseUri = "";
1866 	config.affiliateSigner = 0x1f285dD528cf4cDE3081C6d48D9df7A4F8FA9383;
1867 	config.maxSupply = 10000;
1868 	config.maxBatchSize = 1000;
1869 	config.affiliateFee = 1500;
1870 	config.platformFee = 500;
1871 	/*  
1872     // affiliateFee max is 50%, platformFee min is 5% and max is 50%
1873     if (config_.affiliateFee > 5000 || config_.platformFee > 5000 || config_.platformFee < 500) {
1874       revert InvalidConfig();
1875     }
1876     config = config_;*/
1877     revealed = false;
1878     uriUnlocked = true;
1879     provenanceHashUnlocked = true;
1880   }
1881 
1882   function mint(
1883     Auth calldata auth,
1884     uint256 quantity,
1885     address affiliate,
1886     bytes calldata signature
1887   ) external payable {
1888     Invite memory i = invites[auth.key];
1889 
1890     if (affiliate != address(0)) {
1891       if (affiliate == PLATFORM || affiliate == owner() || affiliate == msg.sender) {
1892         revert InvalidReferral();
1893       }
1894       validateAffiliate(affiliate, signature, config.affiliateSigner);
1895     }
1896 
1897     if (i.limit == 0) {
1898       revert MintingPaused();
1899     }
1900 
1901     if (!verify(auth, _msgSender())) {
1902       revert WalletUnauthorizedToMint();
1903     }
1904 
1905     if (block.timestamp < i.start) {
1906       revert MintNotYetStarted();
1907     }
1908 
1909     if (i.limit < config.maxSupply) {
1910       uint256 totalAfterMint = minted[_msgSender()][auth.key] + quantity;
1911 
1912       if (totalAfterMint > i.limit) {
1913         revert NumberOfMintsExceeded();
1914       }
1915     }
1916 
1917     if (quantity > config.maxBatchSize) {
1918       revert MaxBatchSizeExceeded();
1919     }
1920 
1921     if ((_totalMinted() + quantity) > config.maxSupply) {
1922       revert MaxSupplyExceeded();
1923     }
1924 
1925     uint256 cost = computePrice(i.price, quantity);
1926 
1927     if (msg.value < cost) {
1928       revert InsufficientEthSent();
1929     }
1930 
1931     if (msg.value > cost) {
1932       revert ExcessiveEthSent();
1933     }
1934 
1935     _safeMint(msg.sender, quantity);
1936 
1937     if (i.limit < config.maxSupply) {
1938       minted[_msgSender()][auth.key] += quantity;
1939     }
1940 
1941     uint128 value = uint128(msg.value);
1942 
1943     uint128 affiliateWad = 0;
1944     if (affiliate != address(0)) {
1945       affiliateWad = (value * config.affiliateFee) / 10000;
1946       affiliateBalance[affiliate] += affiliateWad;
1947       emit Referral(affiliate, affiliateWad);
1948     }
1949 
1950     OwnerBalance memory balance = ownerBalance;
1951     uint128 platformWad = (value * config.platformFee) / 10000;
1952     uint128 ownerWad = value - affiliateWad - platformWad;
1953     ownerBalance = OwnerBalance({
1954       owner: balance.owner + ownerWad,
1955       platform: balance.platform + platformWad
1956     });
1957   }
1958 
1959   function computePrice(uint128 price, uint256 numTokens) public pure returns (uint256){
1960       // 5+ = 4% off
1961       // 10+ = 10% off
1962       // 30+ = 13.33% off
1963       // 100+ = 20% off
1964       uint256 cost = price * numTokens;
1965 
1966       if (numTokens >= 100) {
1967         return cost * 8 / 10;
1968       } else if (numTokens >= 30) {
1969         return cost * 8667 / 10000;
1970       } else if (numTokens >= 10) {
1971         return cost * 9 / 10;
1972       } else if (numTokens >= 5) {
1973         return cost * 96 / 100;
1974       } else {
1975         return cost;
1976       }
1977   }
1978 
1979   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1980     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1981 
1982     if (revealed == false) {
1983       return string(abi.encodePacked(config.unrevealedUri, Strings.toString(tokenId)));
1984     }
1985 
1986     return
1987       bytes(config.baseUri).length != 0
1988         ? string(abi.encodePacked(config.baseUri, Strings.toString(tokenId)))
1989         : "";
1990   }
1991 
1992   function reveal() public onlyOwner {
1993     revealed = true;
1994   }
1995 
1996   function _startTokenId() internal view virtual override returns (uint256) {
1997     return 1;
1998   }
1999 
2000   /// @notice the password is "forever"
2001   function lockURI(string memory password) public onlyOwner {
2002     if (keccak256(abi.encodePacked(password)) != keccak256(abi.encodePacked("forever"))) {
2003       revert WrongPassword();
2004     }
2005 
2006     uriUnlocked = false;
2007   }
2008 
2009   function setUnrevealedURI(string memory _unrevealedURI) public onlyOwner {
2010     config.unrevealedUri = _unrevealedURI;
2011   }
2012 
2013   function setBaseURI(string memory baseUri_) public onlyOwner {
2014     if (!uriUnlocked) {
2015       revert LockedForever();
2016     }
2017 
2018     config.baseUri = baseUri_;
2019   }
2020 
2021   /// @notice Set BAYC-style provenance once it's calculated
2022   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2023     if (!provenanceHashUnlocked) {
2024       revert LockedForever();
2025     }
2026 
2027     provenance = provenanceHash;
2028   }
2029 
2030   /// @notice the password is "forever"
2031   function lockProvenanceHash(string memory password) public onlyOwner {
2032     if (keccak256(abi.encodePacked(password)) != keccak256(abi.encodePacked("forever"))) {
2033       revert WrongPassword();
2034     }
2035 
2036     provenanceHashUnlocked = false;
2037   }
2038 
2039   function withdraw() public {
2040     uint128 wad = 0;
2041 
2042     if (msg.sender == owner() || msg.sender == PLATFORM) {
2043       OwnerBalance memory balance = ownerBalance;
2044       if (msg.sender == owner()) {
2045         wad = balance.owner;
2046         ownerBalance = OwnerBalance({ owner: 0, platform: balance.platform });
2047       } else {
2048         wad = balance.platform;
2049         ownerBalance = OwnerBalance({ owner: balance.owner, platform: 0 });
2050       }
2051     } else {
2052       wad = affiliateBalance[msg.sender];
2053       affiliateBalance[msg.sender] = 0;
2054     }
2055 
2056     if (wad == 0) {
2057       revert BalanceEmpty();
2058     }
2059     (bool success, ) = msg.sender.call{ value: wad }("");
2060     if (!success) {
2061       revert TransferFailed();
2062     }
2063     emit Withdrawal(msg.sender, wad);
2064   }
2065 
2066   function setInvites(Invitelist[] calldata invitelist) external onlyOwner {
2067     for (uint256 i = 0; i < invitelist.length; i++) {
2068       Invitelist calldata list = invitelist[i];
2069       invites[list.key] = list.invite;
2070       emit Invited(list.key, list.cid);
2071     }
2072   }
2073 
2074   function setInvite(
2075     bytes32 _key,
2076     bytes32 _cid,
2077     Invite calldata _invite
2078   ) external onlyOwner {
2079     invites[_key] = _invite;
2080     emit Invited(_key, _cid);
2081   }
2082 
2083   // based on: https://github.com/miguelmota/merkletreejs-solidity/blob/master/contracts/MerkleProof.sol
2084   function verify(Auth calldata auth, address account) internal pure returns (bool) {
2085     if (auth.key == "") return true;
2086 
2087     bytes32 computedHash = keccak256(abi.encodePacked(account));
2088     for (uint256 i = 0; i < auth.proof.length; i++) {
2089       bytes32 proofElement = auth.proof[i];
2090       if (computedHash <= proofElement) {
2091         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
2092       } else {
2093         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
2094       }
2095     }
2096     return computedHash == auth.key;
2097   }
2098 
2099   function validateAffiliate(
2100     address affiliate,
2101     bytes memory signature,
2102     address affiliateSigner
2103   ) internal view {
2104 
2105     //console.log("affiliate");
2106     //console.log(affiliate);
2107 
2108     bytes32 signedMessagehash = ECDSA.toEthSignedMessageHash(
2109       keccak256(abi.encodePacked(affiliate))
2110     );
2111     address signer = ECDSA.recover(signedMessagehash, signature);
2112 
2113     //console.log("affiliateSigner");
2114     //console.log(affiliateSigner);
2115 
2116     //console.log("signer");
2117     //console.log(signer);
2118 
2119     if (signer != affiliateSigner) {
2120       revert InvalidSignature();
2121     }
2122   }
2123 }