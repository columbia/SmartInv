1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: IERC721A.sol
80 
81 
82 // ERC721A Contracts v4.2.0
83 // Creator: Chiru Labs
84 
85 pragma solidity ^0.8.1;
86 
87 /**
88  * @dev Interface of ERC721A.
89  */
90 interface IERC721A {
91     /**
92      * The caller must own the token or be an approved operator.
93      */
94     error ApprovalCallerNotOwnerNorApproved();
95 
96     /**
97      * The token does not exist.
98      */
99     error ApprovalQueryForNonexistentToken();
100 
101     /**
102      * The caller cannot approve to their own address.
103      */
104     error ApproveToCaller();
105 
106     /**
107      * Cannot query the balance for the zero address.
108      */
109     error BalanceQueryForZeroAddress();
110 
111     /**
112      * Cannot mint to the zero address.
113      */
114     error MintToZeroAddress();
115 
116     /**
117      * The quantity of tokens minted must be more than zero.
118      */
119     error MintZeroQuantity();
120 
121     /**
122      * The token does not exist.
123      */
124     error OwnerQueryForNonexistentToken();
125 
126     /**
127      * The caller must own the token or be an approved operator.
128      */
129     error TransferCallerNotOwnerNorApproved();
130 
131     /**
132      * The token must be owned by `from`.
133      */
134     error TransferFromIncorrectOwner();
135 
136     /**
137      * Cannot safely transfer to a contract that does not implement the
138      * ERC721Receiver interface.
139      */
140     error TransferToNonERC721ReceiverImplementer();
141 
142     /**
143      * Cannot transfer to the zero address.
144      */
145     error TransferToZeroAddress();
146 
147     /**
148      * The token does not exist.
149      */
150     error URIQueryForNonexistentToken();
151 
152     /**
153      * The `quantity` minted with ERC2309 exceeds the safety limit.
154      */
155     error MintERC2309QuantityExceedsLimit();
156 
157     /**
158      * The `extraData` cannot be set on an unintialized ownership slot.
159      */
160     error OwnershipNotInitializedForExtraData();
161 
162     // =============================================================
163     //                            STRUCTS
164     // =============================================================
165 
166     struct TokenOwnership {
167         // The address of the owner.
168         address addr;
169         // Stores the start time of ownership with minimal overhead for tokenomics.
170         uint64 startTimestamp;
171         // Whether the token has been burned.
172         bool burned;
173         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
174         uint24 extraData;
175     }
176 
177     // =============================================================
178     //                         TOKEN COUNTERS
179     // =============================================================
180 
181     /**
182      * @dev Returns the total number of tokens in existence.
183      * Burned tokens will reduce the count.
184      * To get the total number of tokens minted, please see {_totalMinted}.
185      */
186     function totalSupply() external view returns (uint256);
187 
188     // =============================================================
189     //                            IERC165
190     // =============================================================
191 
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 
202     // =============================================================
203     //                            IERC721
204     // =============================================================
205 
206     /**
207      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
210 
211     /**
212      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
213      */
214     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
215 
216     /**
217      * @dev Emitted when `owner` enables or disables
218      * (`approved`) `operator` to manage all of its assets.
219      */
220     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
221 
222     /**
223      * @dev Returns the number of tokens in `owner`'s account.
224      */
225     function balanceOf(address owner) external view returns (uint256 balance);
226 
227     /**
228      * @dev Returns the owner of the `tokenId` token.
229      *
230      * Requirements:
231      *
232      * - `tokenId` must exist.
233      */
234     function ownerOf(uint256 tokenId) external view returns (address owner);
235 
236     /**
237      * @dev Safely transfers `tokenId` token from `from` to `to`,
238      * checking first that contract recipients are aware of the ERC721 protocol
239      * to prevent tokens from being forever locked.
240      *
241      * Requirements:
242      *
243      * - `from` cannot be the zero address.
244      * - `to` cannot be the zero address.
245      * - `tokenId` token must exist and be owned by `from`.
246      * - If the caller is not `from`, it must be have been allowed to move
247      * this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement
249      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId,
257         bytes calldata data
258     ) external;
259 
260     /**
261      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId
267     ) external;
268 
269     /**
270      * @dev Transfers `tokenId` from `from` to `to`.
271      *
272      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
273      * whenever possible.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must be owned by `from`.
280      * - If the caller is not `from`, it must be approved to move this token
281      * by either {approve} or {setApprovalForAll}.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
293      * The approval is cleared when the token is transferred.
294      *
295      * Only a single account can be approved at a time, so approving the
296      * zero address clears previous approvals.
297      *
298      * Requirements:
299      *
300      * - The caller must own the token or be an approved operator.
301      * - `tokenId` must exist.
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address to, uint256 tokenId) external;
306 
307     /**
308      * @dev Approve or remove `operator` as an operator for the caller.
309      * Operators can call {transferFrom} or {safeTransferFrom}
310      * for any token owned by the caller.
311      *
312      * Requirements:
313      *
314      * - The `operator` cannot be the caller.
315      *
316      * Emits an {ApprovalForAll} event.
317      */
318     function setApprovalForAll(address operator, bool _approved) external;
319 
320     /**
321      * @dev Returns the account approved for `tokenId` token.
322      *
323      * Requirements:
324      *
325      * - `tokenId` must exist.
326      */
327     function getApproved(uint256 tokenId) external view returns (address operator);
328 
329     /**
330      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
331      *
332      * See {setApprovalForAll}.
333      */
334     function isApprovedForAll(address owner, address operator) external view returns (bool);
335 
336     // =============================================================
337     //                        IERC721Metadata
338     // =============================================================
339 
340     /**
341      * @dev Returns the token collection name.
342      */
343     function name() external view returns (string memory);
344 
345     /**
346      * @dev Returns the token collection symbol.
347      */
348     function symbol() external view returns (string memory);
349 
350     /**
351      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
352      */
353     function tokenURI(uint256 tokenId) external view returns (string memory);
354 
355     // =============================================================
356     //                           IERC2309
357     // =============================================================
358 
359     /**
360      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
361      * (inclusive) is transferred from `from` to `to`, as defined in the
362      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
363      *
364      * See {_mintERC2309} for more details.
365      */
366     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
367 }
368 // File: ERC721A.sol
369 
370 
371 // ERC721A Contracts v4.2.0
372 // Creator: Chiru Labs
373 
374 pragma solidity ^0.8.1;
375 
376 
377 /**
378  * @dev Interface of ERC721 token receiver.
379  */
380 interface ERC721A__IERC721Receiver {
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 /**
390  * @title ERC721A
391  *
392  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
393  * Non-Fungible Token Standard, including the Metadata extension.
394  * Optimized for lower gas during batch mints.
395  *
396  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
397  * starting from `_startTokenId()`.
398  *
399  * Assumptions:
400  *
401  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
402  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
403  */
404 contract ERC721A is IERC721A {
405     // Reference type for token approval.
406     struct TokenApprovalRef {
407         address value;
408     }
409 
410     // =============================================================
411     //                           CONSTANTS
412     // =============================================================
413 
414     // Mask of an entry in packed address data.
415     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
416 
417     // The bit position of `numberMinted` in packed address data.
418     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
419 
420     // The bit position of `numberBurned` in packed address data.
421     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
422 
423     // The bit position of `aux` in packed address data.
424     uint256 private constant _BITPOS_AUX = 192;
425 
426     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
427     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
428 
429     // The bit position of `startTimestamp` in packed ownership.
430     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
431 
432     // The bit mask of the `burned` bit in packed ownership.
433     uint256 private constant _BITMASK_BURNED = 1 << 224;
434 
435     // The bit position of the `nextInitialized` bit in packed ownership.
436     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
437 
438     // The bit mask of the `nextInitialized` bit in packed ownership.
439     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
440 
441     // The bit position of `extraData` in packed ownership.
442     uint256 private constant _BITPOS_EXTRA_DATA = 232;
443 
444     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
445     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
446 
447     // The mask of the lower 160 bits for addresses.
448     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
449 
450     // The maximum `quantity` that can be minted with {_mintERC2309}.
451     // This limit is to prevent overflows on the address data entries.
452     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
453     // is required to cause an overflow, which is unrealistic.
454     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
455 
456     // The `Transfer` event signature is given by:
457     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
458     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
459         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
460 
461     // =============================================================
462     //                            STORAGE
463     // =============================================================
464 
465     // The next token ID to be minted.
466     uint256 private _currentIndex;
467 
468     // The number of tokens burned.
469     uint256 private _burnCounter;
470 
471     // Token name
472     string private _name;
473 
474     // Token symbol
475     string private _symbol;
476 
477     // Mapping from token ID to ownership details
478     // An empty struct value does not necessarily mean the token is unowned.
479     // See {_packedOwnershipOf} implementation for details.
480     //
481     // Bits Layout:
482     // - [0..159]   `addr`
483     // - [160..223] `startTimestamp`
484     // - [224]      `burned`
485     // - [225]      `nextInitialized`
486     // - [232..255] `extraData`
487     mapping(uint256 => uint256) private _packedOwnerships;
488 
489     // Mapping owner address to address data.
490     //
491     // Bits Layout:
492     // - [0..63]    `balance`
493     // - [64..127]  `numberMinted`
494     // - [128..191] `numberBurned`
495     // - [192..255] `aux`
496     mapping(address => uint256) private _packedAddressData;
497 
498     // Mapping from token ID to approved address.
499     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
500 
501     // Mapping from owner to operator approvals
502     mapping(address => mapping(address => bool)) private _operatorApprovals;
503 
504     // =============================================================
505     //                          CONSTRUCTOR
506     // =============================================================
507 
508     constructor(string memory name_, string memory symbol_) {
509         _name = name_;
510         _symbol = symbol_;
511         _currentIndex = _startTokenId();
512     }
513 
514     // =============================================================
515     //                   TOKEN COUNTING OPERATIONS
516     // =============================================================
517 
518     /**
519      * @dev Returns the starting token ID.
520      * To change the starting token ID, please override this function.
521      */
522     function _startTokenId() internal view virtual returns (uint256) {
523         return 0;
524     }
525 
526     /**
527      * @dev Returns the next token ID to be minted.
528      */
529     function _nextTokenId() internal view virtual returns (uint256) {
530         return _currentIndex;
531     }
532 
533     /**
534      * @dev Returns the total number of tokens in existence.
535      * Burned tokens will reduce the count.
536      * To get the total number of tokens minted, please see {_totalMinted}.
537      */
538     function totalSupply() public view virtual override returns (uint256) {
539         // Counter underflow is impossible as _burnCounter cannot be incremented
540         // more than `_currentIndex - _startTokenId()` times.
541         unchecked {
542             return _currentIndex - _burnCounter - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total amount of tokens minted in the contract.
548      */
549     function _totalMinted() internal view virtual returns (uint256) {
550         // Counter underflow is impossible as `_currentIndex` does not decrement,
551         // and it is initialized to `_startTokenId()`.
552         unchecked {
553             return _currentIndex - _startTokenId();
554         }
555     }
556 
557     /**
558      * @dev Returns the total number of tokens burned.
559      */
560     function _totalBurned() internal view virtual returns (uint256) {
561         return _burnCounter;
562     }
563 
564     // =============================================================
565     //                    ADDRESS DATA OPERATIONS
566     // =============================================================
567 
568     /**
569      * @dev Returns the number of tokens in `owner`'s account.
570      */
571     function balanceOf(address owner) public view virtual override returns (uint256) {
572         if (owner == address(0)) revert BalanceQueryForZeroAddress();
573         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
574     }
575 
576     /**
577      * Returns the number of tokens minted by `owner`.
578      */
579     function _numberMinted(address owner) internal view returns (uint256) {
580         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
581     }
582 
583     /**
584      * Returns the number of tokens burned by or on behalf of `owner`.
585      */
586     function _numberBurned(address owner) internal view returns (uint256) {
587         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
588     }
589 
590     /**
591      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
592      */
593     function _getAux(address owner) internal view returns (uint64) {
594         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
595     }
596 
597     /**
598      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
599      * If there are multiple variables, please pack them into a uint64.
600      */
601     function _setAux(address owner, uint64 aux) internal virtual {
602         uint256 packed = _packedAddressData[owner];
603         uint256 auxCasted;
604         // Cast `aux` with assembly to avoid redundant masking.
605         assembly {
606             auxCasted := aux
607         }
608         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
609         _packedAddressData[owner] = packed;
610     }
611 
612     // =============================================================
613     //                            IERC165
614     // =============================================================
615 
616     /**
617      * @dev Returns true if this contract implements the interface defined by
618      * `interfaceId`. See the corresponding
619      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
620      * to learn more about how these ids are created.
621      *
622      * This function call must use less than 30000 gas.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625         // The interface IDs are constants representing the first 4 bytes
626         // of the XOR of all function selectors in the interface.
627         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
628         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
629         return
630             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
631             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
632             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
633     }
634 
635     // =============================================================
636     //                        IERC721Metadata
637     // =============================================================
638 
639     /**
640      * @dev Returns the token collection name.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev Returns the token collection symbol.
648      */
649     function symbol() public view virtual override returns (string memory) {
650         return _symbol;
651     }
652 
653     /**
654      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
655      */
656     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
657         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
658 
659         string memory baseURI = _baseURI();
660         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
665      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
666      * by default, it can be overridden in child contracts.
667      */
668     function _baseURI() internal view virtual returns (string memory) {
669         return '';
670     }
671 
672     // =============================================================
673     //                     OWNERSHIPS OPERATIONS
674     // =============================================================
675 
676     /**
677      * @dev Returns the owner of the `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
684         return address(uint160(_packedOwnershipOf(tokenId)));
685     }
686 
687     /**
688      * @dev Gas spent here starts off proportional to the maximum mint batch size.
689      * It gradually moves to O(1) as tokens get transferred around over time.
690      */
691     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
692         return _unpackedOwnership(_packedOwnershipOf(tokenId));
693     }
694 
695     /**
696      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
697      */
698     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
699         return _unpackedOwnership(_packedOwnerships[index]);
700     }
701 
702     /**
703      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
704      */
705     function _initializeOwnershipAt(uint256 index) internal virtual {
706         if (_packedOwnerships[index] == 0) {
707             _packedOwnerships[index] = _packedOwnershipOf(index);
708         }
709     }
710 
711     /**
712      * Returns the packed ownership data of `tokenId`.
713      */
714     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
715         uint256 curr = tokenId;
716 
717         unchecked {
718             if (_startTokenId() <= curr)
719                 if (curr < _currentIndex) {
720                     uint256 packed = _packedOwnerships[curr];
721                     // If not burned.
722                     if (packed & _BITMASK_BURNED == 0) {
723                         // Invariant:
724                         // There will always be an initialized ownership slot
725                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
726                         // before an unintialized ownership slot
727                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
728                         // Hence, `curr` will not underflow.
729                         //
730                         // We can directly compare the packed value.
731                         // If the address is zero, packed will be zero.
732                         while (packed == 0) {
733                             packed = _packedOwnerships[--curr];
734                         }
735                         return packed;
736                     }
737                 }
738         }
739         revert OwnerQueryForNonexistentToken();
740     }
741 
742     /**
743      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
744      */
745     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
746         ownership.addr = address(uint160(packed));
747         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
748         ownership.burned = packed & _BITMASK_BURNED != 0;
749         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
750     }
751 
752     /**
753      * @dev Packs ownership data into a single uint256.
754      */
755     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
756         assembly {
757             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
758             owner := and(owner, _BITMASK_ADDRESS)
759             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
760             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
761         }
762     }
763 
764     /**
765      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
766      */
767     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
768         // For branchless setting of the `nextInitialized` flag.
769         assembly {
770             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
771             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
772         }
773     }
774 
775     // =============================================================
776     //                      APPROVAL OPERATIONS
777     // =============================================================
778 
779     /**
780      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
781      * The approval is cleared when the token is transferred.
782      *
783      * Only a single account can be approved at a time, so approving the
784      * zero address clears previous approvals.
785      *
786      * Requirements:
787      *
788      * - The caller must own the token or be an approved operator.
789      * - `tokenId` must exist.
790      *
791      * Emits an {Approval} event.
792      */
793     function approve(address to, uint256 tokenId) public virtual override {
794         address owner = ownerOf(tokenId);
795 
796         if (_msgSenderERC721A() != owner)
797             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
798                 revert ApprovalCallerNotOwnerNorApproved();
799             }
800 
801         _tokenApprovals[tokenId].value = to;
802         emit Approval(owner, to, tokenId);
803     }
804 
805     /**
806      * @dev Returns the account approved for `tokenId` token.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function getApproved(uint256 tokenId) public view virtual override returns (address) {
813         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
814 
815         return _tokenApprovals[tokenId].value;
816     }
817 
818     /**
819      * @dev Approve or remove `operator` as an operator for the caller.
820      * Operators can call {transferFrom} or {safeTransferFrom}
821      * for any token owned by the caller.
822      *
823      * Requirements:
824      *
825      * - The `operator` cannot be the caller.
826      *
827      * Emits an {ApprovalForAll} event.
828      */
829     function setApprovalForAll(address operator, bool approved) public virtual override {
830         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
831 
832         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
833         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
834     }
835 
836     /**
837      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
838      *
839      * See {setApprovalForAll}.
840      */
841     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev Returns whether `tokenId` exists.
847      *
848      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
849      *
850      * Tokens start existing when they are minted. See {_mint}.
851      */
852     function _exists(uint256 tokenId) internal view virtual returns (bool) {
853         return
854             _startTokenId() <= tokenId &&
855             tokenId < _currentIndex && // If within bounds,
856             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
857     }
858 
859     /**
860      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
861      */
862     function _isSenderApprovedOrOwner(
863         address approvedAddress,
864         address owner,
865         address msgSender
866     ) private pure returns (bool result) {
867         assembly {
868             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
869             owner := and(owner, _BITMASK_ADDRESS)
870             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
871             msgSender := and(msgSender, _BITMASK_ADDRESS)
872             // `msgSender == owner || msgSender == approvedAddress`.
873             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
874         }
875     }
876 
877     /**
878      * @dev Returns the storage slot and value for the approved address of `tokenId`.
879      */
880     function _getApprovedSlotAndAddress(uint256 tokenId)
881         private
882         view
883         returns (uint256 approvedAddressSlot, address approvedAddress)
884     {
885         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
886         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
887         assembly {
888             approvedAddressSlot := tokenApproval.slot
889             approvedAddress := sload(approvedAddressSlot)
890         }
891     }
892 
893     // =============================================================
894     //                      TRANSFER OPERATIONS
895     // =============================================================
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      * - If the caller is not `from`, it must be approved to move this token
906      * by either {approve} or {setApprovalForAll}.
907      *
908      * Emits a {Transfer} event.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
916 
917         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
918 
919         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
920 
921         // The nested ifs save around 20+ gas over a compound boolean condition.
922         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
923             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
924 
925         if (to == address(0)) revert TransferToZeroAddress();
926 
927         _beforeTokenTransfers(from, to, tokenId, 1);
928 
929         // Clear approvals from the previous owner.
930         assembly {
931             if approvedAddress {
932                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
933                 sstore(approvedAddressSlot, 0)
934             }
935         }
936 
937         // Underflow of the sender's balance is impossible because we check for
938         // ownership above and the recipient's balance can't realistically overflow.
939         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
940         unchecked {
941             // We can directly increment and decrement the balances.
942             --_packedAddressData[from]; // Updates: `balance -= 1`.
943             ++_packedAddressData[to]; // Updates: `balance += 1`.
944 
945             // Updates:
946             // - `address` to the next owner.
947             // - `startTimestamp` to the timestamp of transfering.
948             // - `burned` to `false`.
949             // - `nextInitialized` to `true`.
950             _packedOwnerships[tokenId] = _packOwnershipData(
951                 to,
952                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
953             );
954 
955             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
956             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
957                 uint256 nextTokenId = tokenId + 1;
958                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
959                 if (_packedOwnerships[nextTokenId] == 0) {
960                     // If the next slot is within bounds.
961                     if (nextTokenId != _currentIndex) {
962                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
963                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
964                     }
965                 }
966             }
967         }
968 
969         emit Transfer(from, to, tokenId);
970         _afterTokenTransfers(from, to, tokenId, 1);
971     }
972 
973     /**
974      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId
980     ) public virtual override {
981         safeTransferFrom(from, to, tokenId, '');
982     }
983 
984     /**
985      * @dev Safely transfers `tokenId` token from `from` to `to`.
986      *
987      * Requirements:
988      *
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must exist and be owned by `from`.
992      * - If the caller is not `from`, it must be approved to move this token
993      * by either {approve} or {setApprovalForAll}.
994      * - If `to` refers to a smart contract, it must implement
995      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) public virtual override {
1005         transferFrom(from, to, tokenId);
1006         if (to.code.length != 0)
1007             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1008                 revert TransferToNonERC721ReceiverImplementer();
1009             }
1010     }
1011 
1012     /**
1013      * @dev Hook that is called before a set of serially-ordered token IDs
1014      * are about to be transferred. This includes minting.
1015      * And also called before burning one token.
1016      *
1017      * `startTokenId` - the first token ID to be transferred.
1018      * `quantity` - the amount to be transferred.
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` will be minted for `to`.
1025      * - When `to` is zero, `tokenId` will be burned by `from`.
1026      * - `from` and `to` are never both zero.
1027      */
1028     function _beforeTokenTransfers(
1029         address from,
1030         address to,
1031         uint256 startTokenId,
1032         uint256 quantity
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Hook that is called after a set of serially-ordered token IDs
1037      * have been transferred. This includes minting.
1038      * And also called after one token has been burned.
1039      *
1040      * `startTokenId` - the first token ID to be transferred.
1041      * `quantity` - the amount to be transferred.
1042      *
1043      * Calling conditions:
1044      *
1045      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1046      * transferred to `to`.
1047      * - When `from` is zero, `tokenId` has been minted for `to`.
1048      * - When `to` is zero, `tokenId` has been burned by `from`.
1049      * - `from` and `to` are never both zero.
1050      */
1051     function _afterTokenTransfers(
1052         address from,
1053         address to,
1054         uint256 startTokenId,
1055         uint256 quantity
1056     ) internal virtual {}
1057 
1058     /**
1059      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1060      *
1061      * `from` - Previous owner of the given token ID.
1062      * `to` - Target address that will receive the token.
1063      * `tokenId` - Token ID to be transferred.
1064      * `_data` - Optional data to send along with the call.
1065      *
1066      * Returns whether the call correctly returned the expected magic value.
1067      */
1068     function _checkContractOnERC721Received(
1069         address from,
1070         address to,
1071         uint256 tokenId,
1072         bytes memory _data
1073     ) private returns (bool) {
1074         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1075             bytes4 retval
1076         ) {
1077             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1078         } catch (bytes memory reason) {
1079             if (reason.length == 0) {
1080                 revert TransferToNonERC721ReceiverImplementer();
1081             } else {
1082                 assembly {
1083                     revert(add(32, reason), mload(reason))
1084                 }
1085             }
1086         }
1087     }
1088 
1089     // =============================================================
1090     //                        MINT OPERATIONS
1091     // =============================================================
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {Transfer} event for each mint.
1102      */
1103     function _mint(address to, uint256 quantity) internal virtual {
1104         uint256 startTokenId = _currentIndex;
1105         if (quantity == 0) revert MintZeroQuantity();
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // `balance` and `numberMinted` have a maximum limit of 2**64.
1111         // `tokenId` has a maximum limit of 2**256.
1112         unchecked {
1113             // Updates:
1114             // - `balance += quantity`.
1115             // - `numberMinted += quantity`.
1116             //
1117             // We can directly add to the `balance` and `numberMinted`.
1118             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1119 
1120             // Updates:
1121             // - `address` to the owner.
1122             // - `startTimestamp` to the timestamp of minting.
1123             // - `burned` to `false`.
1124             // - `nextInitialized` to `quantity == 1`.
1125             _packedOwnerships[startTokenId] = _packOwnershipData(
1126                 to,
1127                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1128             );
1129 
1130             uint256 toMasked;
1131             uint256 end = startTokenId + quantity;
1132 
1133             // Use assembly to loop and emit the `Transfer` event for gas savings.
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
1147                 for {
1148                     let tokenId := add(startTokenId, 1)
1149                 } iszero(eq(tokenId, end)) {
1150                     tokenId := add(tokenId, 1)
1151                 } {
1152                     // Emit the `Transfer` event. Similar to above.
1153                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1154                 }
1155             }
1156             if (toMasked == 0) revert MintToZeroAddress();
1157 
1158             _currentIndex = end;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * This function is intended for efficient minting only during contract creation.
1167      *
1168      * It emits only one {ConsecutiveTransfer} as defined in
1169      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1170      * instead of a sequence of {Transfer} event(s).
1171      *
1172      * Calling this function outside of contract creation WILL make your contract
1173      * non-compliant with the ERC721 standard.
1174      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1175      * {ConsecutiveTransfer} event is only permissible during contract creation.
1176      *
1177      * Requirements:
1178      *
1179      * - `to` cannot be the zero address.
1180      * - `quantity` must be greater than 0.
1181      *
1182      * Emits a {ConsecutiveTransfer} event.
1183      */
1184     function _mintERC2309(address to, uint256 quantity) internal virtual {
1185         uint256 startTokenId = _currentIndex;
1186         if (to == address(0)) revert MintToZeroAddress();
1187         if (quantity == 0) revert MintZeroQuantity();
1188         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1189 
1190         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1191 
1192         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1193         unchecked {
1194             // Updates:
1195             // - `balance += quantity`.
1196             // - `numberMinted += quantity`.
1197             //
1198             // We can directly add to the `balance` and `numberMinted`.
1199             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1200 
1201             // Updates:
1202             // - `address` to the owner.
1203             // - `startTimestamp` to the timestamp of minting.
1204             // - `burned` to `false`.
1205             // - `nextInitialized` to `quantity == 1`.
1206             _packedOwnerships[startTokenId] = _packOwnershipData(
1207                 to,
1208                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1209             );
1210 
1211             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1212 
1213             _currentIndex = startTokenId + quantity;
1214         }
1215         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1216     }
1217 
1218     /**
1219      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - If `to` refers to a smart contract, it must implement
1224      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * See {_mint}.
1228      *
1229      * Emits a {Transfer} event for each mint.
1230      */
1231     function _safeMint(
1232         address to,
1233         uint256 quantity,
1234         bytes memory _data
1235     ) internal virtual {
1236         _mint(to, quantity);
1237 
1238         unchecked {
1239             if (to.code.length != 0) {
1240                 uint256 end = _currentIndex;
1241                 uint256 index = end - quantity;
1242                 do {
1243                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1244                         revert TransferToNonERC721ReceiverImplementer();
1245                     }
1246                 } while (index < end);
1247                 // Reentrancy protection.
1248                 if (_currentIndex != end) revert();
1249             }
1250         }
1251     }
1252 
1253     /**
1254      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1255      */
1256     function _safeMint(address to, uint256 quantity) internal virtual {
1257         _safeMint(to, quantity, '');
1258     }
1259 
1260     // =============================================================
1261     //                        BURN OPERATIONS
1262     // =============================================================
1263 
1264     /**
1265      * @dev Equivalent to `_burn(tokenId, false)`.
1266      */
1267     function _burn(uint256 tokenId) internal virtual {
1268         _burn(tokenId, false);
1269     }
1270 
1271     /**
1272      * @dev Destroys `tokenId`.
1273      * The approval is cleared when the token is burned.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1282         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1283 
1284         address from = address(uint160(prevOwnershipPacked));
1285 
1286         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1287 
1288         if (approvalCheck) {
1289             // The nested ifs save around 20+ gas over a compound boolean condition.
1290             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1291                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1292         }
1293 
1294         _beforeTokenTransfers(from, address(0), tokenId, 1);
1295 
1296         // Clear approvals from the previous owner.
1297         assembly {
1298             if approvedAddress {
1299                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1300                 sstore(approvedAddressSlot, 0)
1301             }
1302         }
1303 
1304         // Underflow of the sender's balance is impossible because we check for
1305         // ownership above and the recipient's balance can't realistically overflow.
1306         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1307         unchecked {
1308             // Updates:
1309             // - `balance -= 1`.
1310             // - `numberBurned += 1`.
1311             //
1312             // We can directly decrement the balance, and increment the number burned.
1313             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1314             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1315 
1316             // Updates:
1317             // - `address` to the last owner.
1318             // - `startTimestamp` to the timestamp of burning.
1319             // - `burned` to `true`.
1320             // - `nextInitialized` to `true`.
1321             _packedOwnerships[tokenId] = _packOwnershipData(
1322                 from,
1323                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1324             );
1325 
1326             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1327             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1328                 uint256 nextTokenId = tokenId + 1;
1329                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1330                 if (_packedOwnerships[nextTokenId] == 0) {
1331                     // If the next slot is within bounds.
1332                     if (nextTokenId != _currentIndex) {
1333                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1334                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1335                     }
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, address(0), tokenId);
1341         _afterTokenTransfers(from, address(0), tokenId, 1);
1342 
1343         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1344         unchecked {
1345             _burnCounter++;
1346         }
1347     }
1348 
1349     // =============================================================
1350     //                     EXTRA DATA OPERATIONS
1351     // =============================================================
1352 
1353     /**
1354      * @dev Directly sets the extra data for the ownership data `index`.
1355      */
1356     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1357         uint256 packed = _packedOwnerships[index];
1358         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1359         uint256 extraDataCasted;
1360         // Cast `extraData` with assembly to avoid redundant masking.
1361         assembly {
1362             extraDataCasted := extraData
1363         }
1364         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1365         _packedOwnerships[index] = packed;
1366     }
1367 
1368     /**
1369      * @dev Called during each token transfer to set the 24bit `extraData` field.
1370      * Intended to be overridden by the cosumer contract.
1371      *
1372      * `previousExtraData` - the value of `extraData` before transfer.
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` will be minted for `to`.
1379      * - When `to` is zero, `tokenId` will be burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _extraData(
1383         address from,
1384         address to,
1385         uint24 previousExtraData
1386     ) internal view virtual returns (uint24) {}
1387 
1388     /**
1389      * @dev Returns the next extra data for the packed ownership data.
1390      * The returned result is shifted into position.
1391      */
1392     function _nextExtraData(
1393         address from,
1394         address to,
1395         uint256 prevOwnershipPacked
1396     ) private view returns (uint256) {
1397         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1398         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1399     }
1400 
1401     // =============================================================
1402     //                       OTHER OPERATIONS
1403     // =============================================================
1404 
1405     /**
1406      * @dev Returns the message sender (defaults to `msg.sender`).
1407      *
1408      * If you are writing GSN compatible contracts, you need to override this function.
1409      */
1410     function _msgSenderERC721A() internal view virtual returns (address) {
1411         return msg.sender;
1412     }
1413 
1414     /**
1415      * @dev Converts a uint256 to its ASCII string decimal representation.
1416      */
1417     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1418         assembly {
1419             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1420             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1421             // We will need 1 32-byte word to store the length,
1422             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1423             ptr := add(mload(0x40), 128)
1424             // Update the free memory pointer to allocate.
1425             mstore(0x40, ptr)
1426 
1427             // Cache the end of the memory to calculate the length later.
1428             let end := ptr
1429 
1430             // We write the string from the rightmost digit to the leftmost digit.
1431             // The following is essentially a do-while loop that also handles the zero case.
1432             // Costs a bit more than early returning for the zero case,
1433             // but cheaper in terms of deployment and overall runtime costs.
1434             for {
1435                 // Initialize and perform the first pass without check.
1436                 let temp := value
1437                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1438                 ptr := sub(ptr, 1)
1439                 // Write the character to the pointer.
1440                 // The ASCII index of the '0' character is 48.
1441                 mstore8(ptr, add(48, mod(temp, 10)))
1442                 temp := div(temp, 10)
1443             } temp {
1444                 // Keep dividing `temp` until zero.
1445                 temp := div(temp, 10)
1446             } {
1447                 // Body of the for loop.
1448                 ptr := sub(ptr, 1)
1449                 mstore8(ptr, add(48, mod(temp, 10)))
1450             }
1451 
1452             let length := sub(end, ptr)
1453             // Move the pointer 32 bytes leftwards to make room for the length.
1454             ptr := sub(ptr, 32)
1455             // Store the length.
1456             mstore(ptr, length)
1457         }
1458     }
1459 }
1460 
1461 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1462 
1463 
1464 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 /**
1469  * @dev These functions deal with verification of Merkle Tree proofs.
1470  *
1471  * The proofs can be generated using the JavaScript library
1472  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1473  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1474  *
1475  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1476  *
1477  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1478  * hashing, or use a hash function other than keccak256 for hashing leaves.
1479  * This is because the concatenation of a sorted pair of internal nodes in
1480  * the merkle tree could be reinterpreted as a leaf value.
1481  */
1482 library MerkleProof {
1483     /**
1484      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1485      * defined by `root`. For this, a `proof` must be provided, containing
1486      * sibling hashes on the branch from the leaf to the root of the tree. Each
1487      * pair of leaves and each pair of pre-images are assumed to be sorted.
1488      */
1489     function verify(
1490         bytes32[] memory proof,
1491         bytes32 root,
1492         bytes32 leaf
1493     ) internal pure returns (bool) {
1494         return processProof(proof, leaf) == root;
1495     }
1496 
1497     /**
1498      * @dev Calldata version of {verify}
1499      *
1500      * _Available since v4.7._
1501      */
1502     function verifyCalldata(
1503         bytes32[] calldata proof,
1504         bytes32 root,
1505         bytes32 leaf
1506     ) internal pure returns (bool) {
1507         return processProofCalldata(proof, leaf) == root;
1508     }
1509 
1510     /**
1511      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1512      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1513      * hash matches the root of the tree. When processing the proof, the pairs
1514      * of leafs & pre-images are assumed to be sorted.
1515      *
1516      * _Available since v4.4._
1517      */
1518     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1519         bytes32 computedHash = leaf;
1520         for (uint256 i = 0; i < proof.length; i++) {
1521             computedHash = _hashPair(computedHash, proof[i]);
1522         }
1523         return computedHash;
1524     }
1525 
1526     /**
1527      * @dev Calldata version of {processProof}
1528      *
1529      * _Available since v4.7._
1530      */
1531     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1532         bytes32 computedHash = leaf;
1533         for (uint256 i = 0; i < proof.length; i++) {
1534             computedHash = _hashPair(computedHash, proof[i]);
1535         }
1536         return computedHash;
1537     }
1538 
1539     /**
1540      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1541      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1542      *
1543      * _Available since v4.7._
1544      */
1545     function multiProofVerify(
1546         bytes32[] memory proof,
1547         bool[] memory proofFlags,
1548         bytes32 root,
1549         bytes32[] memory leaves
1550     ) internal pure returns (bool) {
1551         return processMultiProof(proof, proofFlags, leaves) == root;
1552     }
1553 
1554     /**
1555      * @dev Calldata version of {multiProofVerify}
1556      *
1557      * _Available since v4.7._
1558      */
1559     function multiProofVerifyCalldata(
1560         bytes32[] calldata proof,
1561         bool[] calldata proofFlags,
1562         bytes32 root,
1563         bytes32[] memory leaves
1564     ) internal pure returns (bool) {
1565         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1566     }
1567 
1568     /**
1569      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1570      * consuming from one or the other at each step according to the instructions given by
1571      * `proofFlags`.
1572      *
1573      * _Available since v4.7._
1574      */
1575     function processMultiProof(
1576         bytes32[] memory proof,
1577         bool[] memory proofFlags,
1578         bytes32[] memory leaves
1579     ) internal pure returns (bytes32 merkleRoot) {
1580         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1581         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1582         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1583         // the merkle tree.
1584         uint256 leavesLen = leaves.length;
1585         uint256 totalHashes = proofFlags.length;
1586 
1587         // Check proof validity.
1588         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1589 
1590         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1591         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1592         bytes32[] memory hashes = new bytes32[](totalHashes);
1593         uint256 leafPos = 0;
1594         uint256 hashPos = 0;
1595         uint256 proofPos = 0;
1596         // At each step, we compute the next hash using two values:
1597         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1598         //   get the next hash.
1599         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1600         //   `proof` array.
1601         for (uint256 i = 0; i < totalHashes; i++) {
1602             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1603             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1604             hashes[i] = _hashPair(a, b);
1605         }
1606 
1607         if (totalHashes > 0) {
1608             return hashes[totalHashes - 1];
1609         } else if (leavesLen > 0) {
1610             return leaves[0];
1611         } else {
1612             return proof[0];
1613         }
1614     }
1615 
1616     /**
1617      * @dev Calldata version of {processMultiProof}
1618      *
1619      * _Available since v4.7._
1620      */
1621     function processMultiProofCalldata(
1622         bytes32[] calldata proof,
1623         bool[] calldata proofFlags,
1624         bytes32[] memory leaves
1625     ) internal pure returns (bytes32 merkleRoot) {
1626         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1627         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1628         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1629         // the merkle tree.
1630         uint256 leavesLen = leaves.length;
1631         uint256 totalHashes = proofFlags.length;
1632 
1633         // Check proof validity.
1634         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1635 
1636         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1637         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1638         bytes32[] memory hashes = new bytes32[](totalHashes);
1639         uint256 leafPos = 0;
1640         uint256 hashPos = 0;
1641         uint256 proofPos = 0;
1642         // At each step, we compute the next hash using two values:
1643         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1644         //   get the next hash.
1645         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1646         //   `proof` array.
1647         for (uint256 i = 0; i < totalHashes; i++) {
1648             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1649             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1650             hashes[i] = _hashPair(a, b);
1651         }
1652 
1653         if (totalHashes > 0) {
1654             return hashes[totalHashes - 1];
1655         } else if (leavesLen > 0) {
1656             return leaves[0];
1657         } else {
1658             return proof[0];
1659         }
1660     }
1661 
1662     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1663         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1664     }
1665 
1666     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1667         /// @solidity memory-safe-assembly
1668         assembly {
1669             mstore(0x00, a)
1670             mstore(0x20, b)
1671             value := keccak256(0x00, 0x40)
1672         }
1673     }
1674 }
1675 
1676 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1677 
1678 
1679 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1680 
1681 pragma solidity ^0.8.0;
1682 
1683 /**
1684  * @dev Contract module that helps prevent reentrant calls to a function.
1685  *
1686  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1687  * available, which can be applied to functions to make sure there are no nested
1688  * (reentrant) calls to them.
1689  *
1690  * Note that because there is a single `nonReentrant` guard, functions marked as
1691  * `nonReentrant` may not call one another. This can be worked around by making
1692  * those functions `private`, and then adding `external` `nonReentrant` entry
1693  * points to them.
1694  *
1695  * TIP: If you would like to learn more about reentrancy and alternative ways
1696  * to protect against it, check out our blog post
1697  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1698  */
1699 abstract contract ReentrancyGuard {
1700     // Booleans are more expensive than uint256 or any type that takes up a full
1701     // word because each write operation emits an extra SLOAD to first read the
1702     // slot's contents, replace the bits taken up by the boolean, and then write
1703     // back. This is the compiler's defense against contract upgrades and
1704     // pointer aliasing, and it cannot be disabled.
1705 
1706     // The values being non-zero value makes deployment a bit more expensive,
1707     // but in exchange the refund on every call to nonReentrant will be lower in
1708     // amount. Since refunds are capped to a percentage of the total
1709     // transaction's gas, it is best to keep them low in cases like this one, to
1710     // increase the likelihood of the full refund coming into effect.
1711     uint256 private constant _NOT_ENTERED = 1;
1712     uint256 private constant _ENTERED = 2;
1713 
1714     uint256 private _status;
1715 
1716     constructor() {
1717         _status = _NOT_ENTERED;
1718     }
1719 
1720     /**
1721      * @dev Prevents a contract from calling itself, directly or indirectly.
1722      * Calling a `nonReentrant` function from another `nonReentrant`
1723      * function is not supported. It is possible to prevent this from happening
1724      * by making the `nonReentrant` function external, and making it call a
1725      * `private` function that does the actual work.
1726      */
1727     modifier nonReentrant() {
1728         // On the first call to nonReentrant, _notEntered will be true
1729         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1730 
1731         // Any calls to nonReentrant after this point will fail
1732         _status = _ENTERED;
1733 
1734         _;
1735 
1736         // By storing the original value once again, a refund is triggered (see
1737         // https://eips.ethereum.org/EIPS/eip-2200)
1738         _status = _NOT_ENTERED;
1739     }
1740 }
1741 
1742 // File: @openzeppelin/contracts/utils/Context.sol
1743 
1744 
1745 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 /**
1750  * @dev Provides information about the current execution context, including the
1751  * sender of the transaction and its data. While these are generally available
1752  * via msg.sender and msg.data, they should not be accessed in such a direct
1753  * manner, since when dealing with meta-transactions the account sending and
1754  * paying for execution may not be the actual sender (as far as an application
1755  * is concerned).
1756  *
1757  * This contract is only required for intermediate, library-like contracts.
1758  */
1759 abstract contract Context {
1760     function _msgSender() internal view virtual returns (address) {
1761         return msg.sender;
1762     }
1763 
1764     function _msgData() internal view virtual returns (bytes calldata) {
1765         return msg.data;
1766     }
1767 }
1768 
1769 // File: @openzeppelin/contracts/access/Ownable.sol
1770 
1771 
1772 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1773 
1774 pragma solidity ^0.8.0;
1775 
1776 
1777 /**
1778  * @dev Contract module which provides a basic access control mechanism, where
1779  * there is an account (an owner) that can be granted exclusive access to
1780  * specific functions.
1781  *
1782  * By default, the owner account will be the one that deploys the contract. This
1783  * can later be changed with {transferOwnership}.
1784  *
1785  * This module is used through inheritance. It will make available the modifier
1786  * `onlyOwner`, which can be applied to your functions to restrict their use to
1787  * the owner.
1788  */
1789 abstract contract Ownable is Context {
1790     address private _owner;
1791 
1792     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1793 
1794     /**
1795      * @dev Initializes the contract setting the deployer as the initial owner.
1796      */
1797     constructor() {
1798         _transferOwnership(_msgSender());
1799     }
1800 
1801     /**
1802      * @dev Throws if called by any account other than the owner.
1803      */
1804     modifier onlyOwner() {
1805         _checkOwner();
1806         _;
1807     }
1808 
1809     /**
1810      * @dev Returns the address of the current owner.
1811      */
1812     function owner() public view virtual returns (address) {
1813         return _owner;
1814     }
1815 
1816     /**
1817      * @dev Throws if the sender is not the owner.
1818      */
1819     function _checkOwner() internal view virtual {
1820         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1821     }
1822 
1823     /**
1824      * @dev Leaves the contract without owner. It will not be possible to call
1825      * `onlyOwner` functions anymore. Can only be called by the current owner.
1826      *
1827      * NOTE: Renouncing ownership will leave the contract without an owner,
1828      * thereby removing any functionality that is only available to the owner.
1829      */
1830     function renounceOwnership() public virtual onlyOwner {
1831         _transferOwnership(address(0));
1832     }
1833 
1834     /**
1835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1836      * Can only be called by the current owner.
1837      */
1838     function transferOwnership(address newOwner) public virtual onlyOwner {
1839         require(newOwner != address(0), "Ownable: new owner is the zero address");
1840         _transferOwnership(newOwner);
1841     }
1842 
1843     /**
1844      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1845      * Internal function without access restriction.
1846      */
1847     function _transferOwnership(address newOwner) internal virtual {
1848         address oldOwner = _owner;
1849         _owner = newOwner;
1850         emit OwnershipTransferred(oldOwner, newOwner);
1851     }
1852 }
1853 
1854 // File: Egg.sol
1855 
1856 
1857 
1858 pragma solidity ^0.8.1;
1859 
1860 
1861 
1862 
1863 
1864 
1865 interface Kakapo {
1866   function burnMint(uint256 tokenId) external;
1867 }
1868 
1869 contract Egg is Ownable, ERC721A, ReentrancyGuard {
1870   uint256 public immutable maxPerAllowlistAddressMint;       
1871   uint256 public immutable amountForDevs;                    
1872   uint256 public immutable amountForAllowlist;               
1873   uint256 public immutable collectionSize;                   
1874   bytes32 private merkleRoot;     
1875   address private birdContractAddress;                           
1876   Kakapo public kakapo;                                      // V2 contract
1877   uint32  private burnStartTime;                             
1878 
1879   mapping(address => bool) public publicMinted;         
1880 
1881   struct SaleConfig {
1882     uint32 allowlistSaleStartTime;     
1883     uint32 publicSaleStartTime;       
1884     uint32 publicSaleKey;             
1885   }
1886 
1887   SaleConfig public saleConfig;
1888 
1889   constructor(
1890     uint256 maxAllowlistSize_,
1891     uint256 collectionSize_,
1892     uint256 amountForDevs_,
1893     uint256 amountForAllowlist_
1894   ) ERC721A("ItsEgg", "ITSEGG") {
1895     maxPerAllowlistAddressMint = maxAllowlistSize_;
1896     amountForDevs = amountForDevs_;
1897     amountForAllowlist = amountForAllowlist_;
1898     collectionSize = collectionSize_;
1899     require(
1900       amountForAllowlist_ <= collectionSize_,
1901       "larger collection size needed"
1902     );
1903   }
1904 
1905   modifier callerIsUser() {
1906     require(tx.origin == msg.sender, "The caller is another contract");
1907     _;
1908   }
1909 
1910   function allowlistMint(bytes32[] calldata _merkleProof) external payable callerIsUser {
1911     uint256 _saleStartTime = uint256(saleConfig.allowlistSaleStartTime);
1912     require(
1913       _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1914       "sale has not started yet"
1915     );
1916 
1917     require(
1918       numberMinted(msg.sender) + 1 <= maxPerAllowlistAddressMint,
1919       "can not mint this many"
1920     );
1921     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1922     require(isAllowList(msg.sender, _merkleProof), "not eligible for allowlist mint");
1923     _safeMint(msg.sender, 1);
1924   }
1925 
1926   function publicSaleMint(uint256 callerPublicSaleKey)
1927     external
1928     payable
1929     callerIsUser
1930   {
1931     require(msg.sender == tx.origin, "Minting from smart contracts is disallowed");
1932     SaleConfig memory config = saleConfig;
1933     uint256 publicSaleKey = uint256(config.publicSaleKey);
1934     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1935     require(
1936       publicSaleKey == callerPublicSaleKey,
1937       "called with incorrect public sale key"
1938     );
1939 
1940     require(
1941       isPublicSaleOn(publicSaleKey, publicSaleStartTime),
1942       "public sale has not begun yet"
1943     );
1944     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1945     require(!publicMinted[msg.sender], "Already minted.");
1946     _safeMint(msg.sender, 1);
1947     publicMinted[msg.sender] = true;
1948   }
1949 
1950   function devMint(uint256 quantity) external onlyOwner {
1951     require(
1952       totalSupply() + quantity <= amountForDevs,
1953       "too many already minted before dev mint"
1954     );
1955     _safeMint(msg.sender, quantity);
1956   }
1957 
1958   function stakeMint() external {
1959     require(msg.sender != tx.origin, "must mint from smart contracts");
1960     require(msg.sender == birdContractAddress, "sender error");
1961     _safeMint(tx.origin, 1);
1962   }
1963 
1964   function setBirdContractAddr(address _address) external onlyOwner {
1965     birdContractAddress = _address;
1966   }
1967 
1968   function isPublicSaleOn(
1969     uint256 publicSaleKey,
1970     uint256 publicSaleStartTime
1971   ) public view returns (bool) {
1972     return
1973       publicSaleKey != 0 &&
1974       block.timestamp >= publicSaleStartTime;
1975   }
1976 
1977   function setSaleInfo(
1978     uint32 allowlistSaleTime,
1979     uint32 publicSaleStartTime
1980   ) external onlyOwner {
1981     saleConfig = SaleConfig(
1982       allowlistSaleTime,
1983       publicSaleStartTime,
1984       saleConfig.publicSaleKey
1985     );
1986   }
1987 
1988   function setPublicSaleKey(uint32 key) external onlyOwner {
1989     saleConfig.publicSaleKey = key;
1990   }
1991 
1992   function setAllowlistSaleStartTime(uint32 timestamp) external onlyOwner {
1993     saleConfig.allowlistSaleStartTime = timestamp;
1994   }
1995 
1996   function setPublicSaleStartTime(uint32 timestamp) external onlyOwner {
1997     saleConfig.publicSaleStartTime = timestamp;
1998   }
1999 
2000   function setMerkleRoot (bytes32 _merkleRoot) public onlyOwner {              
2001     merkleRoot = _merkleRoot;
2002   }
2003 
2004   function isAllowList(address _address, bytes32[] calldata _merkleProof) public view returns (bool){
2005     bytes32 leaf = keccak256(abi.encodePacked(_address));
2006     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Incorrect proof");
2007     return true; 
2008   }
2009 
2010   // metadata URI
2011   string private _baseTokenURI;
2012 
2013   function _baseURI() internal view virtual override returns (string memory) {
2014     return _baseTokenURI;
2015   }
2016 
2017   function setBaseURI(string calldata baseURI) external onlyOwner {
2018     _baseTokenURI = baseURI;
2019   }
2020 
2021   function withdrawMoney() external onlyOwner nonReentrant {
2022     (bool success, ) = msg.sender.call{value: address(this).balance}("");
2023     require(success, "Transfer failed.");
2024   }
2025 
2026   /**
2027   *@dev Destroy the token and generate a new token in the new contract
2028   */
2029   function burn(uint256 tokenId) public virtual {
2030     uint256 _burnStartTime = uint256(burnStartTime);
2031     require(_burnStartTime != 0 && block.timestamp >= _burnStartTime, "burn has not begun yet");
2032     _burn(tokenId, true);
2033     kakapo.burnMint(tokenId);
2034   }
2035 
2036   function setBurnStartTime(uint32 timestamp) external onlyOwner {
2037     burnStartTime = timestamp;
2038   }
2039 
2040   function setBurnContractAddress(address _Address) external onlyOwner {
2041     kakapo = Kakapo(_Address);
2042   }
2043 
2044   // function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
2045   //   _setOwnersExplicit(quantity);
2046   // }
2047 
2048   function numberMinted(address owner) public view returns (uint256) {
2049     return _numberMinted(owner);
2050   }
2051 
2052   function getOwnershipData(uint256 tokenId)
2053     external
2054     view
2055     returns (TokenOwnership memory)
2056   {
2057     return _ownershipOf(tokenId);
2058   }
2059 }