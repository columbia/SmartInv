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
79 // File: contracts/Apes/IERC721A.sol
80 
81 
82 // ERC721A Contracts v4.2.3
83 // Creator: Chiru Labs
84 
85 pragma solidity ^0.8.4;
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
102      * Cannot query the balance for the zero address.
103      */
104     error BalanceQueryForZeroAddress();
105 
106     /**
107      * Cannot mint to the zero address.
108      */
109     error MintToZeroAddress();
110 
111     /**
112      * The quantity of tokens minted must be more than zero.
113      */
114     error MintZeroQuantity();
115 
116     /**
117      * The token does not exist.
118      */
119     error OwnerQueryForNonexistentToken();
120 
121     /**
122      * The caller must own the token or be an approved operator.
123      */
124     error TransferCallerNotOwnerNorApproved();
125 
126     /**
127      * The token must be owned by `from`.
128      */
129     error TransferFromIncorrectOwner();
130 
131     /**
132      * Cannot safely transfer to a contract that does not implement the
133      * ERC721Receiver interface.
134      */
135     error TransferToNonERC721ReceiverImplementer();
136 
137     /**
138      * Cannot transfer to the zero address.
139      */
140     error TransferToZeroAddress();
141 
142     /**
143      * The token does not exist.
144      */
145     error URIQueryForNonexistentToken();
146 
147     /**
148      * The `quantity` minted with ERC2309 exceeds the safety limit.
149      */
150     error MintERC2309QuantityExceedsLimit();
151 
152     /**
153      * The `extraData` cannot be set on an unintialized ownership slot.
154      */
155     error OwnershipNotInitializedForExtraData();
156 
157     // =============================================================
158     //                            STRUCTS
159     // =============================================================
160 
161     struct TokenOwnership {
162         // The address of the owner.
163         address addr;
164         // Stores the start time of ownership with minimal overhead for tokenomics.
165         uint64 startTimestamp;
166         // Whether the token has been burned.
167         bool burned;
168         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
169         uint24 extraData;
170     }
171 
172     // =============================================================
173     //                         TOKEN COUNTERS
174     // =============================================================
175 
176     /**
177      * @dev Returns the total number of tokens in existence.
178      * Burned tokens will reduce the count.
179      * To get the total number of tokens minted, please see {_totalMinted}.
180      */
181     function totalSupply() external view returns (uint256);
182 
183     // =============================================================
184     //                            IERC165
185     // =============================================================
186 
187     /**
188      * @dev Returns true if this contract implements the interface defined by
189      * `interfaceId`. See the corresponding
190      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
191      * to learn more about how these ids are created.
192      *
193      * This function call must use less than 30000 gas.
194      */
195     function supportsInterface(bytes4 interfaceId) external view returns (bool);
196 
197     // =============================================================
198     //                            IERC721
199     // =============================================================
200 
201     /**
202      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
203      */
204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
205 
206     /**
207      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
208      */
209     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
210 
211     /**
212      * @dev Emitted when `owner` enables or disables
213      * (`approved`) `operator` to manage all of its assets.
214      */
215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
216 
217     /**
218      * @dev Returns the number of tokens in `owner`'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221 
222     /**
223      * @dev Returns the owner of the `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function ownerOf(uint256 tokenId) external view returns (address owner);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`,
233      * checking first that contract recipients are aware of the ERC721 protocol
234      * to prevent tokens from being forever locked.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must exist and be owned by `from`.
241      * - If the caller is not `from`, it must be have been allowed to move
242      * this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement
244      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external payable;
254 
255     /**
256      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId
262     ) external payable;
263 
264     /**
265      * @dev Transfers `tokenId` from `from` to `to`.
266      *
267      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
268      * whenever possible.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token
276      * by either {approve} or {setApprovalForAll}.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external payable;
285 
286     /**
287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
288      * The approval is cleared when the token is transferred.
289      *
290      * Only a single account can be approved at a time, so approving the
291      * zero address clears previous approvals.
292      *
293      * Requirements:
294      *
295      * - The caller must own the token or be an approved operator.
296      * - `tokenId` must exist.
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address to, uint256 tokenId) external payable;
301 
302     /**
303      * @dev Approve or remove `operator` as an operator for the caller.
304      * Operators can call {transferFrom} or {safeTransferFrom}
305      * for any token owned by the caller.
306      *
307      * Requirements:
308      *
309      * - The `operator` cannot be the caller.
310      *
311      * Emits an {ApprovalForAll} event.
312      */
313     function setApprovalForAll(address operator, bool _approved) external;
314 
315     /**
316      * @dev Returns the account approved for `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function getApproved(uint256 tokenId) external view returns (address operator);
323 
324     /**
325      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
326      *
327      * See {setApprovalForAll}.
328      */
329     function isApprovedForAll(address owner, address operator) external view returns (bool);
330 
331     // =============================================================
332     //                        IERC721Metadata
333     // =============================================================
334 
335     /**
336      * @dev Returns the token collection name.
337      */
338     function name() external view returns (string memory);
339 
340     /**
341      * @dev Returns the token collection symbol.
342      */
343     function symbol() external view returns (string memory);
344 
345     /**
346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
347      */
348     function tokenURI(uint256 tokenId) external view returns (string memory);
349 
350     // =============================================================
351     //                           IERC2309
352     // =============================================================
353 
354     /**
355      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
356      * (inclusive) is transferred from `from` to `to`, as defined in the
357      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
358      *
359      * See {_mintERC2309} for more details.
360      */
361     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
362 }
363 // File: contracts/Apes/ERC721A.sol
364 
365 
366 // ERC721A Contracts v4.2.3
367 // Creator: Chiru Labs
368 
369 pragma solidity ^0.8.4;
370 
371 
372 /**
373  * @dev Interface of ERC721 token receiver.
374  */
375 interface ERC721A__IERC721Receiver {
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 /**
385  * @title ERC721A
386  *
387  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
388  * Non-Fungible Token Standard, including the Metadata extension.
389  * Optimized for lower gas during batch mints.
390  *
391  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
392  * starting from `_startTokenId()`.
393  *
394  * Assumptions:
395  *
396  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
397  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
398  */
399 contract ERC721A is IERC721A {
400     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
401     struct TokenApprovalRef {
402         address value;
403     }
404 
405     // =============================================================
406     //                           CONSTANTS
407     // =============================================================
408 
409     // Mask of an entry in packed address data.
410     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
411 
412     // The bit position of `numberMinted` in packed address data.
413     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
414 
415     // The bit position of `numberBurned` in packed address data.
416     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
417 
418     // The bit position of `aux` in packed address data.
419     uint256 private constant _BITPOS_AUX = 192;
420 
421     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
422     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
423 
424     // The bit position of `startTimestamp` in packed ownership.
425     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
426 
427     // The bit mask of the `burned` bit in packed ownership.
428     uint256 private constant _BITMASK_BURNED = 1 << 224;
429 
430     // The bit position of the `nextInitialized` bit in packed ownership.
431     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
432 
433     // The bit mask of the `nextInitialized` bit in packed ownership.
434     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
435 
436     // The bit position of `extraData` in packed ownership.
437     uint256 private constant _BITPOS_EXTRA_DATA = 232;
438 
439     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
440     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
441 
442     // The mask of the lower 160 bits for addresses.
443     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
444 
445     // The maximum `quantity` that can be minted with {_mintERC2309}.
446     // This limit is to prevent overflows on the address data entries.
447     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
448     // is required to cause an overflow, which is unrealistic.
449     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
450 
451     // The `Transfer` event signature is given by:
452     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
453     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
454         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
455 
456     // =============================================================
457     //                            STORAGE
458     // =============================================================
459 
460     // The next token ID to be minted.
461     uint256 private _currentIndex;
462 
463     // The number of tokens burned.
464     uint256 private _burnCounter;
465 
466     // Token name
467     string private _name;
468 
469     // Token symbol
470     string private _symbol;
471 
472     // Mapping from token ID to ownership details
473     // An empty struct value does not necessarily mean the token is unowned.
474     // See {_packedOwnershipOf} implementation for details.
475     //
476     // Bits Layout:
477     // - [0..159]   `addr`
478     // - [160..223] `startTimestamp`
479     // - [224]      `burned`
480     // - [225]      `nextInitialized`
481     // - [232..255] `extraData`
482     mapping(uint256 => uint256) private _packedOwnerships;
483 
484     // Mapping owner address to address data.
485     //
486     // Bits Layout:
487     // - [0..63]    `balance`
488     // - [64..127]  `numberMinted`
489     // - [128..191] `numberBurned`
490     // - [192..255] `aux`
491     mapping(address => uint256) private _packedAddressData;
492 
493     // Mapping from token ID to approved address.
494     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
495 
496     // Mapping from owner to operator approvals
497     mapping(address => mapping(address => bool)) private _operatorApprovals;
498 
499     // =============================================================
500     //                          CONSTRUCTOR
501     // =============================================================
502 
503     constructor(string memory name_, string memory symbol_) {
504         _name = name_;
505         _symbol = symbol_;
506         _currentIndex = _startTokenId();
507     }
508 
509     // =============================================================
510     //                   TOKEN COUNTING OPERATIONS
511     // =============================================================
512 
513     /**
514      * @dev Returns the starting token ID.
515      * To change the starting token ID, please override this function.
516      */
517     function _startTokenId() internal view virtual returns (uint256) {
518         return 0;
519     }
520 
521     /**
522      * @dev Returns the next token ID to be minted.
523      */
524     function _nextTokenId() internal view virtual returns (uint256) {
525         return _currentIndex;
526     }
527 
528     /**
529      * @dev Returns the total number of tokens in existence.
530      * Burned tokens will reduce the count.
531      * To get the total number of tokens minted, please see {_totalMinted}.
532      */
533     function totalSupply() public view virtual override returns (uint256) {
534         // Counter underflow is impossible as _burnCounter cannot be incremented
535         // more than `_currentIndex - _startTokenId()` times.
536         unchecked {
537             return _currentIndex - _burnCounter - _startTokenId();
538         }
539     }
540 
541     /**
542      * @dev Returns the total amount of tokens minted in the contract.
543      */
544     function _totalMinted() internal view virtual returns (uint256) {
545         // Counter underflow is impossible as `_currentIndex` does not decrement,
546         // and it is initialized to `_startTokenId()`.
547         unchecked {
548             return _currentIndex - _startTokenId();
549         }
550     }
551 
552     /**
553      * @dev Returns the total number of tokens burned.
554      */
555     function _totalBurned() internal view virtual returns (uint256) {
556         return _burnCounter;
557     }
558 
559     // =============================================================
560     //                    ADDRESS DATA OPERATIONS
561     // =============================================================
562 
563     /**
564      * @dev Returns the number of tokens in `owner`'s account.
565      */
566     function balanceOf(address owner) public view virtual override returns (uint256) {
567         if (owner == address(0)) revert BalanceQueryForZeroAddress();
568         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
569     }
570 
571     /**
572      * Returns the number of tokens minted by `owner`.
573      */
574     function _numberMinted(address owner) internal view returns (uint256) {
575         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
576     }
577 
578     /**
579      * Returns the number of tokens burned by or on behalf of `owner`.
580      */
581     function _numberBurned(address owner) internal view returns (uint256) {
582         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
583     }
584 
585     /**
586      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
587      */
588     function _getAux(address owner) internal view returns (uint64) {
589         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
590     }
591 
592     /**
593      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
594      * If there are multiple variables, please pack them into a uint64.
595      */
596     function _setAux(address owner, uint64 aux) internal virtual {
597         uint256 packed = _packedAddressData[owner];
598         uint256 auxCasted;
599         // Cast `aux` with assembly to avoid redundant masking.
600         assembly {
601             auxCasted := aux
602         }
603         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
604         _packedAddressData[owner] = packed;
605     }
606 
607     // =============================================================
608     //                            IERC165
609     // =============================================================
610 
611     /**
612      * @dev Returns true if this contract implements the interface defined by
613      * `interfaceId`. See the corresponding
614      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
615      * to learn more about how these ids are created.
616      *
617      * This function call must use less than 30000 gas.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620         // The interface IDs are constants representing the first 4 bytes
621         // of the XOR of all function selectors in the interface.
622         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
623         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
624         return
625             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
626             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
627             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
628     }
629 
630     // =============================================================
631     //                        IERC721Metadata
632     // =============================================================
633 
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() public view virtual override returns (string memory) {
638         return _name;
639     }
640 
641     /**
642      * @dev Returns the token collection symbol.
643      */
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
650      */
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
656     }
657 
658     /**
659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
661      * by default, it can be overridden in child contracts.
662      */
663     function _baseURI() internal view virtual returns (string memory) {
664         return '';
665     }
666 
667     // =============================================================
668     //                     OWNERSHIPS OPERATIONS
669     // =============================================================
670 
671     /**
672      * @dev Returns the owner of the `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679         return address(uint160(_packedOwnershipOf(tokenId)));
680     }
681 
682     /**
683      * @dev Gas spent here starts off proportional to the maximum mint batch size.
684      * It gradually moves to O(1) as tokens get transferred around over time.
685      */
686     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
687         return _unpackedOwnership(_packedOwnershipOf(tokenId));
688     }
689 
690     /**
691      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
692      */
693     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
694         return _unpackedOwnership(_packedOwnerships[index]);
695     }
696 
697     /**
698      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
699      */
700     function _initializeOwnershipAt(uint256 index) internal virtual {
701         if (_packedOwnerships[index] == 0) {
702             _packedOwnerships[index] = _packedOwnershipOf(index);
703         }
704     }
705 
706     /**
707      * Returns the packed ownership data of `tokenId`.
708      */
709     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
710         uint256 curr = tokenId;
711 
712         unchecked {
713             if (_startTokenId() <= curr)
714                 if (curr < _currentIndex) {
715                     uint256 packed = _packedOwnerships[curr];
716                     // If not burned.
717                     if (packed & _BITMASK_BURNED == 0) {
718                         // Invariant:
719                         // There will always be an initialized ownership slot
720                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
721                         // before an unintialized ownership slot
722                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
723                         // Hence, `curr` will not underflow.
724                         //
725                         // We can directly compare the packed value.
726                         // If the address is zero, packed will be zero.
727                         while (packed == 0) {
728                             packed = _packedOwnerships[--curr];
729                         }
730                         return packed;
731                     }
732                 }
733         }
734         revert OwnerQueryForNonexistentToken();
735     }
736 
737     /**
738      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
739      */
740     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
741         ownership.addr = address(uint160(packed));
742         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
743         ownership.burned = packed & _BITMASK_BURNED != 0;
744         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
745     }
746 
747     /**
748      * @dev Packs ownership data into a single uint256.
749      */
750     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
751         assembly {
752             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
753             owner := and(owner, _BITMASK_ADDRESS)
754             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
755             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
756         }
757     }
758 
759     /**
760      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
761      */
762     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
763         // For branchless setting of the `nextInitialized` flag.
764         assembly {
765             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
766             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
767         }
768     }
769 
770     // =============================================================
771     //                      APPROVAL OPERATIONS
772     // =============================================================
773 
774     /**
775      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
776      * The approval is cleared when the token is transferred.
777      *
778      * Only a single account can be approved at a time, so approving the
779      * zero address clears previous approvals.
780      *
781      * Requirements:
782      *
783      * - The caller must own the token or be an approved operator.
784      * - `tokenId` must exist.
785      *
786      * Emits an {Approval} event.
787      */
788     function approve(address to, uint256 tokenId) public payable virtual override {
789         address owner = ownerOf(tokenId);
790 
791         if (_msgSenderERC721A() != owner)
792             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
793                 revert ApprovalCallerNotOwnerNorApproved();
794             }
795 
796         _tokenApprovals[tokenId].value = to;
797         emit Approval(owner, to, tokenId);
798     }
799 
800     /**
801      * @dev Returns the account approved for `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function getApproved(uint256 tokenId) public view virtual override returns (address) {
808         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
809 
810         return _tokenApprovals[tokenId].value;
811     }
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom}
816      * for any token owned by the caller.
817      *
818      * Requirements:
819      *
820      * - The `operator` cannot be the caller.
821      *
822      * Emits an {ApprovalForAll} event.
823      */
824     function setApprovalForAll(address operator, bool approved) public virtual override {
825         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
826         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
827     }
828 
829     /**
830      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
831      *
832      * See {setApprovalForAll}.
833      */
834     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
835         return _operatorApprovals[owner][operator];
836     }
837 
838     /**
839      * @dev Returns whether `tokenId` exists.
840      *
841      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
842      *
843      * Tokens start existing when they are minted. See {_mint}.
844      */
845     function _exists(uint256 tokenId) internal view virtual returns (bool) {
846         return
847             _startTokenId() <= tokenId &&
848             tokenId < _currentIndex && // If within bounds,
849             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
850     }
851 
852     /**
853      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
854      */
855     function _isSenderApprovedOrOwner(
856         address approvedAddress,
857         address owner,
858         address msgSender
859     ) private pure returns (bool result) {
860         assembly {
861             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
862             owner := and(owner, _BITMASK_ADDRESS)
863             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
864             msgSender := and(msgSender, _BITMASK_ADDRESS)
865             // `msgSender == owner || msgSender == approvedAddress`.
866             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
867         }
868     }
869 
870     /**
871      * @dev Returns the storage slot and value for the approved address of `tokenId`.
872      */
873     function _getApprovedSlotAndAddress(uint256 tokenId)
874         private
875         view
876         returns (uint256 approvedAddressSlot, address approvedAddress)
877     {
878         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
879         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
880         assembly {
881             approvedAddressSlot := tokenApproval.slot
882             approvedAddress := sload(approvedAddressSlot)
883         }
884     }
885 
886     // =============================================================
887     //                      TRANSFER OPERATIONS
888     // =============================================================
889 
890     /**
891      * @dev Transfers `tokenId` from `from` to `to`.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must be owned by `from`.
898      * - If the caller is not `from`, it must be approved to move this token
899      * by either {approve} or {setApprovalForAll}.
900      *
901      * Emits a {Transfer} event.
902      */
903     function transferFrom(
904         address from,
905         address to,
906         uint256 tokenId
907     ) public payable virtual override {
908         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
909 
910         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
911 
912         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
913 
914         // The nested ifs save around 20+ gas over a compound boolean condition.
915         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
916             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
917 
918         if (to == address(0)) revert TransferToZeroAddress();
919 
920         _beforeTokenTransfers(from, to, tokenId, 1);
921 
922         // Clear approvals from the previous owner.
923         assembly {
924             if approvedAddress {
925                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
926                 sstore(approvedAddressSlot, 0)
927             }
928         }
929 
930         // Underflow of the sender's balance is impossible because we check for
931         // ownership above and the recipient's balance can't realistically overflow.
932         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
933         unchecked {
934             // We can directly increment and decrement the balances.
935             --_packedAddressData[from]; // Updates: `balance -= 1`.
936             ++_packedAddressData[to]; // Updates: `balance += 1`.
937 
938             // Updates:
939             // - `address` to the next owner.
940             // - `startTimestamp` to the timestamp of transfering.
941             // - `burned` to `false`.
942             // - `nextInitialized` to `true`.
943             _packedOwnerships[tokenId] = _packOwnershipData(
944                 to,
945                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
946             );
947 
948             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
949             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
950                 uint256 nextTokenId = tokenId + 1;
951                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
952                 if (_packedOwnerships[nextTokenId] == 0) {
953                     // If the next slot is within bounds.
954                     if (nextTokenId != _currentIndex) {
955                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
956                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
957                     }
958                 }
959             }
960         }
961 
962         emit Transfer(from, to, tokenId);
963         _afterTokenTransfers(from, to, tokenId, 1);
964     }
965 
966     /**
967      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
968      */
969     function safeTransferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public payable virtual override {
974         safeTransferFrom(from, to, tokenId, '');
975     }
976 
977     /**
978      * @dev Safely transfers `tokenId` token from `from` to `to`.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must exist and be owned by `from`.
985      * - If the caller is not `from`, it must be approved to move this token
986      * by either {approve} or {setApprovalForAll}.
987      * - If `to` refers to a smart contract, it must implement
988      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) public payable virtual override {
998         transferFrom(from, to, tokenId);
999         if (to.code.length != 0)
1000             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1001                 revert TransferToNonERC721ReceiverImplementer();
1002             }
1003     }
1004 
1005     /**
1006      * @dev Hook that is called before a set of serially-ordered token IDs
1007      * are about to be transferred. This includes minting.
1008      * And also called before burning one token.
1009      *
1010      * `startTokenId` - the first token ID to be transferred.
1011      * `quantity` - the amount to be transferred.
1012      *
1013      * Calling conditions:
1014      *
1015      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1016      * transferred to `to`.
1017      * - When `from` is zero, `tokenId` will be minted for `to`.
1018      * - When `to` is zero, `tokenId` will be burned by `from`.
1019      * - `from` and `to` are never both zero.
1020      */
1021     function _beforeTokenTransfers(
1022         address from,
1023         address to,
1024         uint256 startTokenId,
1025         uint256 quantity
1026     ) internal virtual {}
1027 
1028     /**
1029      * @dev Hook that is called after a set of serially-ordered token IDs
1030      * have been transferred. This includes minting.
1031      * And also called after one token has been burned.
1032      *
1033      * `startTokenId` - the first token ID to be transferred.
1034      * `quantity` - the amount to be transferred.
1035      *
1036      * Calling conditions:
1037      *
1038      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1039      * transferred to `to`.
1040      * - When `from` is zero, `tokenId` has been minted for `to`.
1041      * - When `to` is zero, `tokenId` has been burned by `from`.
1042      * - `from` and `to` are never both zero.
1043      */
1044     function _afterTokenTransfers(
1045         address from,
1046         address to,
1047         uint256 startTokenId,
1048         uint256 quantity
1049     ) internal virtual {}
1050 
1051     /**
1052      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1053      *
1054      * `from` - Previous owner of the given token ID.
1055      * `to` - Target address that will receive the token.
1056      * `tokenId` - Token ID to be transferred.
1057      * `_data` - Optional data to send along with the call.
1058      *
1059      * Returns whether the call correctly returned the expected magic value.
1060      */
1061     function _checkContractOnERC721Received(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) private returns (bool) {
1067         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1068             bytes4 retval
1069         ) {
1070             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1071         } catch (bytes memory reason) {
1072             if (reason.length == 0) {
1073                 revert TransferToNonERC721ReceiverImplementer();
1074             } else {
1075                 assembly {
1076                     revert(add(32, reason), mload(reason))
1077                 }
1078             }
1079         }
1080     }
1081 
1082     // =============================================================
1083     //                        MINT OPERATIONS
1084     // =============================================================
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event for each mint.
1095      */
1096     function _mint(address to, uint256 quantity) internal virtual {
1097         uint256 startTokenId = _currentIndex;
1098         if (quantity == 0) revert MintZeroQuantity();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are incredibly unrealistic.
1103         // `balance` and `numberMinted` have a maximum limit of 2**64.
1104         // `tokenId` has a maximum limit of 2**256.
1105         unchecked {
1106             // Updates:
1107             // - `balance += quantity`.
1108             // - `numberMinted += quantity`.
1109             //
1110             // We can directly add to the `balance` and `numberMinted`.
1111             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1112 
1113             // Updates:
1114             // - `address` to the owner.
1115             // - `startTimestamp` to the timestamp of minting.
1116             // - `burned` to `false`.
1117             // - `nextInitialized` to `quantity == 1`.
1118             _packedOwnerships[startTokenId] = _packOwnershipData(
1119                 to,
1120                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1121             );
1122 
1123             uint256 toMasked;
1124             uint256 end = startTokenId + quantity;
1125 
1126             // Use assembly to loop and emit the `Transfer` event for gas savings.
1127             // The duplicated `log4` removes an extra check and reduces stack juggling.
1128             // The assembly, together with the surrounding Solidity code, have been
1129             // delicately arranged to nudge the compiler into producing optimized opcodes.
1130             assembly {
1131                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1132                 toMasked := and(to, _BITMASK_ADDRESS)
1133                 // Emit the `Transfer` event.
1134                 log4(
1135                     0, // Start of data (0, since no data).
1136                     0, // End of data (0, since no data).
1137                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1138                     0, // `address(0)`.
1139                     toMasked, // `to`.
1140                     startTokenId // `tokenId`.
1141                 )
1142 
1143                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1144                 // that overflows uint256 will make the loop run out of gas.
1145                 // The compiler will optimize the `iszero` away for performance.
1146                 for {
1147                     let tokenId := add(startTokenId, 1)
1148                 } iszero(eq(tokenId, end)) {
1149                     tokenId := add(tokenId, 1)
1150                 } {
1151                     // Emit the `Transfer` event. Similar to above.
1152                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1153                 }
1154             }
1155             if (toMasked == 0) revert MintToZeroAddress();
1156 
1157             _currentIndex = end;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * This function is intended for efficient minting only during contract creation.
1166      *
1167      * It emits only one {ConsecutiveTransfer} as defined in
1168      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1169      * instead of a sequence of {Transfer} event(s).
1170      *
1171      * Calling this function outside of contract creation WILL make your contract
1172      * non-compliant with the ERC721 standard.
1173      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1174      * {ConsecutiveTransfer} event is only permissible during contract creation.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `quantity` must be greater than 0.
1180      *
1181      * Emits a {ConsecutiveTransfer} event.
1182      */
1183     function _mintERC2309(address to, uint256 quantity) internal virtual {
1184         uint256 startTokenId = _currentIndex;
1185         if (to == address(0)) revert MintToZeroAddress();
1186         if (quantity == 0) revert MintZeroQuantity();
1187         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1188 
1189         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1190 
1191         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1192         unchecked {
1193             // Updates:
1194             // - `balance += quantity`.
1195             // - `numberMinted += quantity`.
1196             //
1197             // We can directly add to the `balance` and `numberMinted`.
1198             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1199 
1200             // Updates:
1201             // - `address` to the owner.
1202             // - `startTimestamp` to the timestamp of minting.
1203             // - `burned` to `false`.
1204             // - `nextInitialized` to `quantity == 1`.
1205             _packedOwnerships[startTokenId] = _packOwnershipData(
1206                 to,
1207                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1208             );
1209 
1210             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1211 
1212             _currentIndex = startTokenId + quantity;
1213         }
1214         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1215     }
1216 
1217     /**
1218      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1219      *
1220      * Requirements:
1221      *
1222      * - If `to` refers to a smart contract, it must implement
1223      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1224      * - `quantity` must be greater than 0.
1225      *
1226      * See {_mint}.
1227      *
1228      * Emits a {Transfer} event for each mint.
1229      */
1230     function _safeMint(
1231         address to,
1232         uint256 quantity,
1233         bytes memory _data
1234     ) internal virtual {
1235         _mint(to, quantity);
1236 
1237         unchecked {
1238             if (to.code.length != 0) {
1239                 uint256 end = _currentIndex;
1240                 uint256 index = end - quantity;
1241                 do {
1242                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1243                         revert TransferToNonERC721ReceiverImplementer();
1244                     }
1245                 } while (index < end);
1246                 // Reentrancy protection.
1247                 if (_currentIndex != end) revert();
1248             }
1249         }
1250     }
1251 
1252     /**
1253      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1254      */
1255     function _safeMint(address to, uint256 quantity) internal virtual {
1256         _safeMint(to, quantity, '');
1257     }
1258 
1259     // =============================================================
1260     //                        BURN OPERATIONS
1261     // =============================================================
1262 
1263     /**
1264      * @dev Equivalent to `_burn(tokenId, false)`.
1265      */
1266     function _burn(uint256 tokenId) internal virtual {
1267         _burn(tokenId, false);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1281         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1282 
1283         address from = address(uint160(prevOwnershipPacked));
1284 
1285         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1286 
1287         if (approvalCheck) {
1288             // The nested ifs save around 20+ gas over a compound boolean condition.
1289             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1290                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1291         }
1292 
1293         _beforeTokenTransfers(from, address(0), tokenId, 1);
1294 
1295         // Clear approvals from the previous owner.
1296         assembly {
1297             if approvedAddress {
1298                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1299                 sstore(approvedAddressSlot, 0)
1300             }
1301         }
1302 
1303         // Underflow of the sender's balance is impossible because we check for
1304         // ownership above and the recipient's balance can't realistically overflow.
1305         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1306         unchecked {
1307             // Updates:
1308             // - `balance -= 1`.
1309             // - `numberBurned += 1`.
1310             //
1311             // We can directly decrement the balance, and increment the number burned.
1312             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1313             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1314 
1315             // Updates:
1316             // - `address` to the last owner.
1317             // - `startTimestamp` to the timestamp of burning.
1318             // - `burned` to `true`.
1319             // - `nextInitialized` to `true`.
1320             _packedOwnerships[tokenId] = _packOwnershipData(
1321                 from,
1322                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1323             );
1324 
1325             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1326             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1327                 uint256 nextTokenId = tokenId + 1;
1328                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1329                 if (_packedOwnerships[nextTokenId] == 0) {
1330                     // If the next slot is within bounds.
1331                     if (nextTokenId != _currentIndex) {
1332                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1333                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1334                     }
1335                 }
1336             }
1337         }
1338 
1339         emit Transfer(from, address(0), tokenId);
1340         _afterTokenTransfers(from, address(0), tokenId, 1);
1341 
1342         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1343         unchecked {
1344             _burnCounter++;
1345         }
1346     }
1347 
1348     // =============================================================
1349     //                     EXTRA DATA OPERATIONS
1350     // =============================================================
1351 
1352     /**
1353      * @dev Directly sets the extra data for the ownership data `index`.
1354      */
1355     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1356         uint256 packed = _packedOwnerships[index];
1357         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1358         uint256 extraDataCasted;
1359         // Cast `extraData` with assembly to avoid redundant masking.
1360         assembly {
1361             extraDataCasted := extraData
1362         }
1363         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1364         _packedOwnerships[index] = packed;
1365     }
1366 
1367     /**
1368      * @dev Called during each token transfer to set the 24bit `extraData` field.
1369      * Intended to be overridden by the cosumer contract.
1370      *
1371      * `previousExtraData` - the value of `extraData` before transfer.
1372      *
1373      * Calling conditions:
1374      *
1375      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1376      * transferred to `to`.
1377      * - When `from` is zero, `tokenId` will be minted for `to`.
1378      * - When `to` is zero, `tokenId` will be burned by `from`.
1379      * - `from` and `to` are never both zero.
1380      */
1381     function _extraData(
1382         address from,
1383         address to,
1384         uint24 previousExtraData
1385     ) internal view virtual returns (uint24) {}
1386 
1387     /**
1388      * @dev Returns the next extra data for the packed ownership data.
1389      * The returned result is shifted into position.
1390      */
1391     function _nextExtraData(
1392         address from,
1393         address to,
1394         uint256 prevOwnershipPacked
1395     ) private view returns (uint256) {
1396         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1397         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1398     }
1399 
1400     // =============================================================
1401     //                       OTHER OPERATIONS
1402     // =============================================================
1403 
1404     /**
1405      * @dev Returns the message sender (defaults to `msg.sender`).
1406      *
1407      * If you are writing GSN compatible contracts, you need to override this function.
1408      */
1409     function _msgSenderERC721A() internal view virtual returns (address) {
1410         return msg.sender;
1411     }
1412 
1413     /**
1414      * @dev Converts a uint256 to its ASCII string decimal representation.
1415      */
1416     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1417         assembly {
1418             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1419             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1420             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1421             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1422             let m := add(mload(0x40), 0xa0)
1423             // Update the free memory pointer to allocate.
1424             mstore(0x40, m)
1425             // Assign the `str` to the end.
1426             str := sub(m, 0x20)
1427             // Zeroize the slot after the string.
1428             mstore(str, 0)
1429 
1430             // Cache the end of the memory to calculate the length later.
1431             let end := str
1432 
1433             // We write the string from rightmost digit to leftmost digit.
1434             // The following is essentially a do-while loop that also handles the zero case.
1435             // prettier-ignore
1436             for { let temp := value } 1 {} {
1437                 str := sub(str, 1)
1438                 // Write the character to the pointer.
1439                 // The ASCII index of the '0' character is 48.
1440                 mstore8(str, add(48, mod(temp, 10)))
1441                 // Keep dividing `temp` until zero.
1442                 temp := div(temp, 10)
1443                 // prettier-ignore
1444                 if iszero(temp) { break }
1445             }
1446 
1447             let length := sub(end, str)
1448             // Move the pointer 32 bytes leftwards to make room for the length.
1449             str := sub(str, 0x20)
1450             // Store the length.
1451             mstore(str, length)
1452         }
1453     }
1454 }
1455 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1456 
1457 
1458 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1459 
1460 pragma solidity ^0.8.0;
1461 
1462 /**
1463  * @dev Contract module that helps prevent reentrant calls to a function.
1464  *
1465  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1466  * available, which can be applied to functions to make sure there are no nested
1467  * (reentrant) calls to them.
1468  *
1469  * Note that because there is a single `nonReentrant` guard, functions marked as
1470  * `nonReentrant` may not call one another. This can be worked around by making
1471  * those functions `private`, and then adding `external` `nonReentrant` entry
1472  * points to them.
1473  *
1474  * TIP: If you would like to learn more about reentrancy and alternative ways
1475  * to protect against it, check out our blog post
1476  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1477  */
1478 abstract contract ReentrancyGuard {
1479     // Booleans are more expensive than uint256 or any type that takes up a full
1480     // word because each write operation emits an extra SLOAD to first read the
1481     // slot's contents, replace the bits taken up by the boolean, and then write
1482     // back. This is the compiler's defense against contract upgrades and
1483     // pointer aliasing, and it cannot be disabled.
1484 
1485     // The values being non-zero value makes deployment a bit more expensive,
1486     // but in exchange the refund on every call to nonReentrant will be lower in
1487     // amount. Since refunds are capped to a percentage of the total
1488     // transaction's gas, it is best to keep them low in cases like this one, to
1489     // increase the likelihood of the full refund coming into effect.
1490     uint256 private constant _NOT_ENTERED = 1;
1491     uint256 private constant _ENTERED = 2;
1492 
1493     uint256 private _status;
1494 
1495     constructor() {
1496         _status = _NOT_ENTERED;
1497     }
1498 
1499     /**
1500      * @dev Prevents a contract from calling itself, directly or indirectly.
1501      * Calling a `nonReentrant` function from another `nonReentrant`
1502      * function is not supported. It is possible to prevent this from happening
1503      * by making the `nonReentrant` function external, and making it call a
1504      * `private` function that does the actual work.
1505      */
1506     modifier nonReentrant() {
1507         // On the first call to nonReentrant, _notEntered will be true
1508         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1509 
1510         // Any calls to nonReentrant after this point will fail
1511         _status = _ENTERED;
1512 
1513         _;
1514 
1515         // By storing the original value once again, a refund is triggered (see
1516         // https://eips.ethereum.org/EIPS/eip-2200)
1517         _status = _NOT_ENTERED;
1518     }
1519 }
1520 
1521 // File: @openzeppelin/contracts/utils/Context.sol
1522 
1523 
1524 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev Provides information about the current execution context, including the
1530  * sender of the transaction and its data. While these are generally available
1531  * via msg.sender and msg.data, they should not be accessed in such a direct
1532  * manner, since when dealing with meta-transactions the account sending and
1533  * paying for execution may not be the actual sender (as far as an application
1534  * is concerned).
1535  *
1536  * This contract is only required for intermediate, library-like contracts.
1537  */
1538 abstract contract Context {
1539     function _msgSender() internal view virtual returns (address) {
1540         return msg.sender;
1541     }
1542 
1543     function _msgData() internal view virtual returns (bytes calldata) {
1544         return msg.data;
1545     }
1546 }
1547 
1548 // File: @openzeppelin/contracts/access/Ownable.sol
1549 
1550 
1551 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 
1556 /**
1557  * @dev Contract module which provides a basic access control mechanism, where
1558  * there is an account (an owner) that can be granted exclusive access to
1559  * specific functions.
1560  *
1561  * By default, the owner account will be the one that deploys the contract. This
1562  * can later be changed with {transferOwnership}.
1563  *
1564  * This module is used through inheritance. It will make available the modifier
1565  * `onlyOwner`, which can be applied to your functions to restrict their use to
1566  * the owner.
1567  */
1568 abstract contract Ownable is Context {
1569     address private _owner;
1570 
1571     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1572 
1573     /**
1574      * @dev Initializes the contract setting the deployer as the initial owner.
1575      */
1576     constructor() {
1577         _transferOwnership(_msgSender());
1578     }
1579 
1580     /**
1581      * @dev Throws if called by any account other than the owner.
1582      */
1583     modifier onlyOwner() {
1584         _checkOwner();
1585         _;
1586     }
1587 
1588     /**
1589      * @dev Returns the address of the current owner.
1590      */
1591     function owner() public view virtual returns (address) {
1592         return _owner;
1593     }
1594 
1595     /**
1596      * @dev Throws if the sender is not the owner.
1597      */
1598     function _checkOwner() internal view virtual {
1599         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1600     }
1601 
1602     /**
1603      * @dev Leaves the contract without owner. It will not be possible to call
1604      * `onlyOwner` functions anymore. Can only be called by the current owner.
1605      *
1606      * NOTE: Renouncing ownership will leave the contract without an owner,
1607      * thereby removing any functionality that is only available to the owner.
1608      */
1609     function renounceOwnership() public virtual onlyOwner {
1610         _transferOwnership(address(0));
1611     }
1612 
1613     /**
1614      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1615      * Can only be called by the current owner.
1616      */
1617     function transferOwnership(address newOwner) public virtual onlyOwner {
1618         require(newOwner != address(0), "Ownable: new owner is the zero address");
1619         _transferOwnership(newOwner);
1620     }
1621 
1622     /**
1623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1624      * Internal function without access restriction.
1625      */
1626     function _transferOwnership(address newOwner) internal virtual {
1627         address oldOwner = _owner;
1628         _owner = newOwner;
1629         emit OwnershipTransferred(oldOwner, newOwner);
1630     }
1631 }
1632 
1633 // File: contracts/Apes/ATCA.sol
1634 
1635 
1636 
1637 pragma solidity ^0.8.11;
1638 
1639 
1640 
1641 
1642 
1643 contract ATribeCalledApe is Ownable, ERC721A, ReentrancyGuard {
1644     bool public isPublicSaleOn = false;
1645     uint256 public collectionSize = 8888;
1646     string private _baseTokenURI;
1647     uint256 private price = 0.01 ether;
1648     
1649     mapping(address => uint256) _freeMintsDone;
1650 
1651     constructor() ERC721A("ATribeCalledApe", "ATCA") {}
1652 
1653     modifier callerIsUser() {
1654         require(tx.origin == msg.sender, "The caller is another contract");
1655         _;
1656     }
1657 
1658     //mint
1659     function fMint(uint256 quantity) external payable callerIsUser {
1660         quantity = quantity < 2 ? 2 : quantity;
1661         uint256 totPrice = (quantity -2) * price;
1662         require(quantity > 0, "You need more quantity");
1663         require(isPublicSaleOn, "public sale has not begun yet");
1664         require(totalSupply() + quantity <= collectionSize, "reached max supply" );
1665         require( _freeMintsDone[msg.sender] < 2,"you already minted two for free");
1666         require(msg.value >= totPrice, "ether sent not correct");
1667         _freeMintsDone[msg.sender] = 2;
1668         _safeMint(msg.sender, quantity);
1669     }
1670     function mint(uint256 quantity) external payable callerIsUser {
1671         uint256 totPrice = quantity * price;
1672         require(isPublicSaleOn, "public sale has not begun yet");
1673         require( totalSupply() + quantity <= collectionSize,"reached max supply" );
1674         require(msg.value >= totPrice, "ether sent not correct");
1675         _safeMint(msg.sender, quantity);
1676     }
1677 
1678     //override
1679     function _baseURI() internal view virtual override returns (string memory) {
1680         return _baseTokenURI;
1681     }
1682 
1683     //public get
1684     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory){
1685         return _ownershipOf(tokenId);
1686     }
1687     function getMyPrice(uint256 quantity, address owner) external view returns (uint256 priceTotal) {
1688         require(quantity > 0, "You need more quantity");
1689        
1690         if(_freeMintsDone[owner] == 1){
1691           quantity--;
1692         }
1693         else if (_freeMintsDone[owner] == 0){ 
1694           quantity = quantity < 2 ? 0 : quantity -2;
1695         }
1696         return quantity * price;
1697     }
1698     function hasFreeMintsOpen() external view returns (uint256 free) {
1699         return _freeMintsDone[msg.sender];
1700     }
1701     function getTotalSupply() external view returns (uint256 supply) {
1702         return totalSupply();
1703     }
1704 
1705     //onlyowner
1706     function startPublicSale() external onlyOwner {
1707         isPublicSaleOn = true;
1708     }
1709     function setBaseURI(string calldata baseURI) external onlyOwner {
1710         _baseTokenURI = baseURI;
1711     }
1712     function withdraw() external onlyOwner nonReentrant {
1713         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1714         require(success, "Transfer failed.");
1715     }
1716     function devMint(uint256 quantity) external onlyOwner {
1717         _safeMint(msg.sender, quantity);
1718     }
1719 }
1720 
1721 //Deploy
1722 //SetImageUri
1723 //DevMint 888
1724 //StartPublicSale