1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: erc721a/contracts/IERC721A.sol
81 
82 
83 // ERC721A Contracts v4.2.3
84 // Creator: Chiru Labs
85 
86 pragma solidity ^0.8.4;
87 
88 /**
89  * @dev Interface of ERC721A.
90  */
91 interface IERC721A {
92     /**
93      * The caller must own the token or be an approved operator.
94      */
95     error ApprovalCallerNotOwnerNorApproved();
96 
97     /**
98      * The token does not exist.
99      */
100     error ApprovalQueryForNonexistentToken();
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
254     ) external payable;
255 
256     /**
257      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external payable;
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
285     ) external payable;
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
301     function approve(address to, uint256 tokenId) external payable;
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
365 // File: erc721a/contracts/ERC721A.sol
366 
367 
368 // ERC721A Contracts v4.2.3
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 
374 /**
375  * @dev Interface of ERC721 token receiver.
376  */
377 interface ERC721A__IERC721Receiver {
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 /**
387  * @title ERC721A
388  *
389  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
390  * Non-Fungible Token Standard, including the Metadata extension.
391  * Optimized for lower gas during batch mints.
392  *
393  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
394  * starting from `_startTokenId()`.
395  *
396  * Assumptions:
397  *
398  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
399  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
400  */
401 contract ERC721A is IERC721A {
402     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
403     struct TokenApprovalRef {
404         address value;
405     }
406 
407     // =============================================================
408     //                           CONSTANTS
409     // =============================================================
410 
411     // Mask of an entry in packed address data.
412     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
413 
414     // The bit position of `numberMinted` in packed address data.
415     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
416 
417     // The bit position of `numberBurned` in packed address data.
418     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
419 
420     // The bit position of `aux` in packed address data.
421     uint256 private constant _BITPOS_AUX = 192;
422 
423     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
424     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
425 
426     // The bit position of `startTimestamp` in packed ownership.
427     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
428 
429     // The bit mask of the `burned` bit in packed ownership.
430     uint256 private constant _BITMASK_BURNED = 1 << 224;
431 
432     // The bit position of the `nextInitialized` bit in packed ownership.
433     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
434 
435     // The bit mask of the `nextInitialized` bit in packed ownership.
436     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
437 
438     // The bit position of `extraData` in packed ownership.
439     uint256 private constant _BITPOS_EXTRA_DATA = 232;
440 
441     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
442     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
443 
444     // The mask of the lower 160 bits for addresses.
445     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
446 
447     // The maximum `quantity` that can be minted with {_mintERC2309}.
448     // This limit is to prevent overflows on the address data entries.
449     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
450     // is required to cause an overflow, which is unrealistic.
451     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
452 
453     // The `Transfer` event signature is given by:
454     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
455     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
456         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
457 
458     // =============================================================
459     //                            STORAGE
460     // =============================================================
461 
462     // The next token ID to be minted.
463     uint256 private _currentIndex;
464 
465     // The number of tokens burned.
466     uint256 private _burnCounter;
467 
468     // Token name
469     string private _name;
470 
471     // Token symbol
472     string private _symbol;
473 
474     // Mapping from token ID to ownership details
475     // An empty struct value does not necessarily mean the token is unowned.
476     // See {_packedOwnershipOf} implementation for details.
477     //
478     // Bits Layout:
479     // - [0..159]   `addr`
480     // - [160..223] `startTimestamp`
481     // - [224]      `burned`
482     // - [225]      `nextInitialized`
483     // - [232..255] `extraData`
484     mapping(uint256 => uint256) private _packedOwnerships;
485 
486     // Mapping owner address to address data.
487     //
488     // Bits Layout:
489     // - [0..63]    `balance`
490     // - [64..127]  `numberMinted`
491     // - [128..191] `numberBurned`
492     // - [192..255] `aux`
493     mapping(address => uint256) private _packedAddressData;
494 
495     // Mapping from token ID to approved address.
496     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
497 
498     // Mapping from owner to operator approvals
499     mapping(address => mapping(address => bool)) private _operatorApprovals;
500 
501     // =============================================================
502     //                          CONSTRUCTOR
503     // =============================================================
504 
505     constructor(string memory name_, string memory symbol_) {
506         _name = name_;
507         _symbol = symbol_;
508         _currentIndex = _startTokenId();
509     }
510 
511     // =============================================================
512     //                   TOKEN COUNTING OPERATIONS
513     // =============================================================
514 
515     /**
516      * @dev Returns the starting token ID.
517      * To change the starting token ID, please override this function.
518      */
519     function _startTokenId() internal view virtual returns (uint256) {
520         return 0;
521     }
522 
523     /**
524      * @dev Returns the next token ID to be minted.
525      */
526     function _nextTokenId() internal view virtual returns (uint256) {
527         return _currentIndex;
528     }
529 
530     /**
531      * @dev Returns the total number of tokens in existence.
532      * Burned tokens will reduce the count.
533      * To get the total number of tokens minted, please see {_totalMinted}.
534      */
535     function totalSupply() public view virtual override returns (uint256) {
536         // Counter underflow is impossible as _burnCounter cannot be incremented
537         // more than `_currentIndex - _startTokenId()` times.
538         unchecked {
539             return _currentIndex - _burnCounter - _startTokenId();
540         }
541     }
542 
543     /**
544      * @dev Returns the total amount of tokens minted in the contract.
545      */
546     function _totalMinted() internal view virtual returns (uint256) {
547         // Counter underflow is impossible as `_currentIndex` does not decrement,
548         // and it is initialized to `_startTokenId()`.
549         unchecked {
550             return _currentIndex - _startTokenId();
551         }
552     }
553 
554     /**
555      * @dev Returns the total number of tokens burned.
556      */
557     function _totalBurned() internal view virtual returns (uint256) {
558         return _burnCounter;
559     }
560 
561     // =============================================================
562     //                    ADDRESS DATA OPERATIONS
563     // =============================================================
564 
565     /**
566      * @dev Returns the number of tokens in `owner`'s account.
567      */
568     function balanceOf(address owner) public view virtual override returns (uint256) {
569         if (owner == address(0)) revert BalanceQueryForZeroAddress();
570         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573     /**
574      * Returns the number of tokens minted by `owner`.
575      */
576     function _numberMinted(address owner) internal view returns (uint256) {
577         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
578     }
579 
580     /**
581      * Returns the number of tokens burned by or on behalf of `owner`.
582      */
583     function _numberBurned(address owner) internal view returns (uint256) {
584         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
585     }
586 
587     /**
588      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
589      */
590     function _getAux(address owner) internal view returns (uint64) {
591         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
592     }
593 
594     /**
595      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
596      * If there are multiple variables, please pack them into a uint64.
597      */
598     function _setAux(address owner, uint64 aux) internal virtual {
599         uint256 packed = _packedAddressData[owner];
600         uint256 auxCasted;
601         // Cast `aux` with assembly to avoid redundant masking.
602         assembly {
603             auxCasted := aux
604         }
605         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
606         _packedAddressData[owner] = packed;
607     }
608 
609     // =============================================================
610     //                            IERC165
611     // =============================================================
612 
613     /**
614      * @dev Returns true if this contract implements the interface defined by
615      * `interfaceId`. See the corresponding
616      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
617      * to learn more about how these ids are created.
618      *
619      * This function call must use less than 30000 gas.
620      */
621     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622         // The interface IDs are constants representing the first 4 bytes
623         // of the XOR of all function selectors in the interface.
624         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
625         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
626         return
627             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
628             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
629             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
630     }
631 
632     // =============================================================
633     //                        IERC721Metadata
634     // =============================================================
635 
636     /**
637      * @dev Returns the token collection name.
638      */
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev Returns the token collection symbol.
645      */
646     function symbol() public view virtual override returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
652      */
653     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
654         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
655 
656         string memory baseURI = _baseURI();
657         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
658     }
659 
660     /**
661      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
662      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
663      * by default, it can be overridden in child contracts.
664      */
665     function _baseURI() internal view virtual returns (string memory) {
666         return '';
667     }
668 
669     // =============================================================
670     //                     OWNERSHIPS OPERATIONS
671     // =============================================================
672 
673     /**
674      * @dev Returns the owner of the `tokenId` token.
675      *
676      * Requirements:
677      *
678      * - `tokenId` must exist.
679      */
680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
681         return address(uint160(_packedOwnershipOf(tokenId)));
682     }
683 
684     /**
685      * @dev Gas spent here starts off proportional to the maximum mint batch size.
686      * It gradually moves to O(1) as tokens get transferred around over time.
687      */
688     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
689         return _unpackedOwnership(_packedOwnershipOf(tokenId));
690     }
691 
692     /**
693      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
694      */
695     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
696         return _unpackedOwnership(_packedOwnerships[index]);
697     }
698 
699     /**
700      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
701      */
702     function _initializeOwnershipAt(uint256 index) internal virtual {
703         if (_packedOwnerships[index] == 0) {
704             _packedOwnerships[index] = _packedOwnershipOf(index);
705         }
706     }
707 
708     /**
709      * Returns the packed ownership data of `tokenId`.
710      */
711     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
712         uint256 curr = tokenId;
713 
714         unchecked {
715             if (_startTokenId() <= curr)
716                 if (curr < _currentIndex) {
717                     uint256 packed = _packedOwnerships[curr];
718                     // If not burned.
719                     if (packed & _BITMASK_BURNED == 0) {
720                         // Invariant:
721                         // There will always be an initialized ownership slot
722                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
723                         // before an unintialized ownership slot
724                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
725                         // Hence, `curr` will not underflow.
726                         //
727                         // We can directly compare the packed value.
728                         // If the address is zero, packed will be zero.
729                         while (packed == 0) {
730                             packed = _packedOwnerships[--curr];
731                         }
732                         return packed;
733                     }
734                 }
735         }
736         revert OwnerQueryForNonexistentToken();
737     }
738 
739     /**
740      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
741      */
742     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
743         ownership.addr = address(uint160(packed));
744         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
745         ownership.burned = packed & _BITMASK_BURNED != 0;
746         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
747     }
748 
749     /**
750      * @dev Packs ownership data into a single uint256.
751      */
752     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
753         assembly {
754             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
755             owner := and(owner, _BITMASK_ADDRESS)
756             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
757             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
758         }
759     }
760 
761     /**
762      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
763      */
764     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
765         // For branchless setting of the `nextInitialized` flag.
766         assembly {
767             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
768             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
769         }
770     }
771 
772     // =============================================================
773     //                      APPROVAL OPERATIONS
774     // =============================================================
775 
776     /**
777      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
778      * The approval is cleared when the token is transferred.
779      *
780      * Only a single account can be approved at a time, so approving the
781      * zero address clears previous approvals.
782      *
783      * Requirements:
784      *
785      * - The caller must own the token or be an approved operator.
786      * - `tokenId` must exist.
787      *
788      * Emits an {Approval} event.
789      */
790     function approve(address to, uint256 tokenId) public payable virtual override {
791         address owner = ownerOf(tokenId);
792 
793         if (_msgSenderERC721A() != owner)
794             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
795                 revert ApprovalCallerNotOwnerNorApproved();
796             }
797 
798         _tokenApprovals[tokenId].value = to;
799         emit Approval(owner, to, tokenId);
800     }
801 
802     /**
803      * @dev Returns the account approved for `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function getApproved(uint256 tokenId) public view virtual override returns (address) {
810         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
811 
812         return _tokenApprovals[tokenId].value;
813     }
814 
815     /**
816      * @dev Approve or remove `operator` as an operator for the caller.
817      * Operators can call {transferFrom} or {safeTransferFrom}
818      * for any token owned by the caller.
819      *
820      * Requirements:
821      *
822      * - The `operator` cannot be the caller.
823      *
824      * Emits an {ApprovalForAll} event.
825      */
826     function setApprovalForAll(address operator, bool approved) public virtual override {
827         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
828         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
829     }
830 
831     /**
832      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
833      *
834      * See {setApprovalForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted. See {_mint}.
846      */
847     function _exists(uint256 tokenId) internal view virtual returns (bool) {
848         return
849             _startTokenId() <= tokenId &&
850             tokenId < _currentIndex && // If within bounds,
851             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
852     }
853 
854     /**
855      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
856      */
857     function _isSenderApprovedOrOwner(
858         address approvedAddress,
859         address owner,
860         address msgSender
861     ) private pure returns (bool result) {
862         assembly {
863             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
864             owner := and(owner, _BITMASK_ADDRESS)
865             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
866             msgSender := and(msgSender, _BITMASK_ADDRESS)
867             // `msgSender == owner || msgSender == approvedAddress`.
868             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
869         }
870     }
871 
872     /**
873      * @dev Returns the storage slot and value for the approved address of `tokenId`.
874      */
875     function _getApprovedSlotAndAddress(uint256 tokenId)
876         private
877         view
878         returns (uint256 approvedAddressSlot, address approvedAddress)
879     {
880         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
881         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
882         assembly {
883             approvedAddressSlot := tokenApproval.slot
884             approvedAddress := sload(approvedAddressSlot)
885         }
886     }
887 
888     // =============================================================
889     //                      TRANSFER OPERATIONS
890     // =============================================================
891 
892     /**
893      * @dev Transfers `tokenId` from `from` to `to`.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must be owned by `from`.
900      * - If the caller is not `from`, it must be approved to move this token
901      * by either {approve} or {setApprovalForAll}.
902      *
903      * Emits a {Transfer} event.
904      */
905     function transferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public payable virtual override {
910         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
911 
912         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
913 
914         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
915 
916         // The nested ifs save around 20+ gas over a compound boolean condition.
917         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
918             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
919 
920         if (to == address(0)) revert TransferToZeroAddress();
921 
922         _beforeTokenTransfers(from, to, tokenId, 1);
923 
924         // Clear approvals from the previous owner.
925         assembly {
926             if approvedAddress {
927                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
928                 sstore(approvedAddressSlot, 0)
929             }
930         }
931 
932         // Underflow of the sender's balance is impossible because we check for
933         // ownership above and the recipient's balance can't realistically overflow.
934         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
935         unchecked {
936             // We can directly increment and decrement the balances.
937             --_packedAddressData[from]; // Updates: `balance -= 1`.
938             ++_packedAddressData[to]; // Updates: `balance += 1`.
939 
940             // Updates:
941             // - `address` to the next owner.
942             // - `startTimestamp` to the timestamp of transfering.
943             // - `burned` to `false`.
944             // - `nextInitialized` to `true`.
945             _packedOwnerships[tokenId] = _packOwnershipData(
946                 to,
947                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
948             );
949 
950             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
951             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
952                 uint256 nextTokenId = tokenId + 1;
953                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
954                 if (_packedOwnerships[nextTokenId] == 0) {
955                     // If the next slot is within bounds.
956                     if (nextTokenId != _currentIndex) {
957                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
958                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
959                     }
960                 }
961             }
962         }
963 
964         emit Transfer(from, to, tokenId);
965         _afterTokenTransfers(from, to, tokenId, 1);
966     }
967 
968     /**
969      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public payable virtual override {
976         safeTransferFrom(from, to, tokenId, '');
977     }
978 
979     /**
980      * @dev Safely transfers `tokenId` token from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token
988      * by either {approve} or {setApprovalForAll}.
989      * - If `to` refers to a smart contract, it must implement
990      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) public payable virtual override {
1000         transferFrom(from, to, tokenId);
1001         if (to.code.length != 0)
1002             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1003                 revert TransferToNonERC721ReceiverImplementer();
1004             }
1005     }
1006 
1007     /**
1008      * @dev Hook that is called before a set of serially-ordered token IDs
1009      * are about to be transferred. This includes minting.
1010      * And also called before burning one token.
1011      *
1012      * `startTokenId` - the first token ID to be transferred.
1013      * `quantity` - the amount to be transferred.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, `tokenId` will be burned by `from`.
1021      * - `from` and `to` are never both zero.
1022      */
1023     function _beforeTokenTransfers(
1024         address from,
1025         address to,
1026         uint256 startTokenId,
1027         uint256 quantity
1028     ) internal virtual {}
1029 
1030     /**
1031      * @dev Hook that is called after a set of serially-ordered token IDs
1032      * have been transferred. This includes minting.
1033      * And also called after one token has been burned.
1034      *
1035      * `startTokenId` - the first token ID to be transferred.
1036      * `quantity` - the amount to be transferred.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` has been minted for `to`.
1043      * - When `to` is zero, `tokenId` has been burned by `from`.
1044      * - `from` and `to` are never both zero.
1045      */
1046     function _afterTokenTransfers(
1047         address from,
1048         address to,
1049         uint256 startTokenId,
1050         uint256 quantity
1051     ) internal virtual {}
1052 
1053     /**
1054      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1055      *
1056      * `from` - Previous owner of the given token ID.
1057      * `to` - Target address that will receive the token.
1058      * `tokenId` - Token ID to be transferred.
1059      * `_data` - Optional data to send along with the call.
1060      *
1061      * Returns whether the call correctly returned the expected magic value.
1062      */
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1070             bytes4 retval
1071         ) {
1072             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1073         } catch (bytes memory reason) {
1074             if (reason.length == 0) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             } else {
1077                 assembly {
1078                     revert(add(32, reason), mload(reason))
1079                 }
1080             }
1081         }
1082     }
1083 
1084     // =============================================================
1085     //                        MINT OPERATIONS
1086     // =============================================================
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event for each mint.
1097      */
1098     function _mint(address to, uint256 quantity) internal virtual {
1099         uint256 startTokenId = _currentIndex;
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // `balance` and `numberMinted` have a maximum limit of 2**64.
1106         // `tokenId` has a maximum limit of 2**256.
1107         unchecked {
1108             // Updates:
1109             // - `balance += quantity`.
1110             // - `numberMinted += quantity`.
1111             //
1112             // We can directly add to the `balance` and `numberMinted`.
1113             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1114 
1115             // Updates:
1116             // - `address` to the owner.
1117             // - `startTimestamp` to the timestamp of minting.
1118             // - `burned` to `false`.
1119             // - `nextInitialized` to `quantity == 1`.
1120             _packedOwnerships[startTokenId] = _packOwnershipData(
1121                 to,
1122                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1123             );
1124 
1125             uint256 toMasked;
1126             uint256 end = startTokenId + quantity;
1127 
1128             // Use assembly to loop and emit the `Transfer` event for gas savings.
1129             // The duplicated `log4` removes an extra check and reduces stack juggling.
1130             // The assembly, together with the surrounding Solidity code, have been
1131             // delicately arranged to nudge the compiler into producing optimized opcodes.
1132             assembly {
1133                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1134                 toMasked := and(to, _BITMASK_ADDRESS)
1135                 // Emit the `Transfer` event.
1136                 log4(
1137                     0, // Start of data (0, since no data).
1138                     0, // End of data (0, since no data).
1139                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1140                     0, // `address(0)`.
1141                     toMasked, // `to`.
1142                     startTokenId // `tokenId`.
1143                 )
1144 
1145                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1146                 // that overflows uint256 will make the loop run out of gas.
1147                 // The compiler will optimize the `iszero` away for performance.
1148                 for {
1149                     let tokenId := add(startTokenId, 1)
1150                 } iszero(eq(tokenId, end)) {
1151                     tokenId := add(tokenId, 1)
1152                 } {
1153                     // Emit the `Transfer` event. Similar to above.
1154                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1155                 }
1156             }
1157             if (toMasked == 0) revert MintToZeroAddress();
1158 
1159             _currentIndex = end;
1160         }
1161         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1162     }
1163 
1164     /**
1165      * @dev Mints `quantity` tokens and transfers them to `to`.
1166      *
1167      * This function is intended for efficient minting only during contract creation.
1168      *
1169      * It emits only one {ConsecutiveTransfer} as defined in
1170      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1171      * instead of a sequence of {Transfer} event(s).
1172      *
1173      * Calling this function outside of contract creation WILL make your contract
1174      * non-compliant with the ERC721 standard.
1175      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1176      * {ConsecutiveTransfer} event is only permissible during contract creation.
1177      *
1178      * Requirements:
1179      *
1180      * - `to` cannot be the zero address.
1181      * - `quantity` must be greater than 0.
1182      *
1183      * Emits a {ConsecutiveTransfer} event.
1184      */
1185     function _mintERC2309(address to, uint256 quantity) internal virtual {
1186         uint256 startTokenId = _currentIndex;
1187         if (to == address(0)) revert MintToZeroAddress();
1188         if (quantity == 0) revert MintZeroQuantity();
1189         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1190 
1191         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1192 
1193         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1194         unchecked {
1195             // Updates:
1196             // - `balance += quantity`.
1197             // - `numberMinted += quantity`.
1198             //
1199             // We can directly add to the `balance` and `numberMinted`.
1200             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1201 
1202             // Updates:
1203             // - `address` to the owner.
1204             // - `startTimestamp` to the timestamp of minting.
1205             // - `burned` to `false`.
1206             // - `nextInitialized` to `quantity == 1`.
1207             _packedOwnerships[startTokenId] = _packOwnershipData(
1208                 to,
1209                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1210             );
1211 
1212             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1213 
1214             _currentIndex = startTokenId + quantity;
1215         }
1216         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1217     }
1218 
1219     /**
1220      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - If `to` refers to a smart contract, it must implement
1225      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1226      * - `quantity` must be greater than 0.
1227      *
1228      * See {_mint}.
1229      *
1230      * Emits a {Transfer} event for each mint.
1231      */
1232     function _safeMint(
1233         address to,
1234         uint256 quantity,
1235         bytes memory _data
1236     ) internal virtual {
1237         _mint(to, quantity);
1238 
1239         unchecked {
1240             if (to.code.length != 0) {
1241                 uint256 end = _currentIndex;
1242                 uint256 index = end - quantity;
1243                 do {
1244                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1245                         revert TransferToNonERC721ReceiverImplementer();
1246                     }
1247                 } while (index < end);
1248                 // Reentrancy protection.
1249                 if (_currentIndex != end) revert();
1250             }
1251         }
1252     }
1253 
1254     /**
1255      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1256      */
1257     function _safeMint(address to, uint256 quantity) internal virtual {
1258         _safeMint(to, quantity, '');
1259     }
1260 
1261     // =============================================================
1262     //                        BURN OPERATIONS
1263     // =============================================================
1264 
1265     /**
1266      * @dev Equivalent to `_burn(tokenId, false)`.
1267      */
1268     function _burn(uint256 tokenId) internal virtual {
1269         _burn(tokenId, false);
1270     }
1271 
1272     /**
1273      * @dev Destroys `tokenId`.
1274      * The approval is cleared when the token is burned.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1283         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1284 
1285         address from = address(uint160(prevOwnershipPacked));
1286 
1287         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1288 
1289         if (approvalCheck) {
1290             // The nested ifs save around 20+ gas over a compound boolean condition.
1291             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1292                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1293         }
1294 
1295         _beforeTokenTransfers(from, address(0), tokenId, 1);
1296 
1297         // Clear approvals from the previous owner.
1298         assembly {
1299             if approvedAddress {
1300                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1301                 sstore(approvedAddressSlot, 0)
1302             }
1303         }
1304 
1305         // Underflow of the sender's balance is impossible because we check for
1306         // ownership above and the recipient's balance can't realistically overflow.
1307         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1308         unchecked {
1309             // Updates:
1310             // - `balance -= 1`.
1311             // - `numberBurned += 1`.
1312             //
1313             // We can directly decrement the balance, and increment the number burned.
1314             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1315             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1316 
1317             // Updates:
1318             // - `address` to the last owner.
1319             // - `startTimestamp` to the timestamp of burning.
1320             // - `burned` to `true`.
1321             // - `nextInitialized` to `true`.
1322             _packedOwnerships[tokenId] = _packOwnershipData(
1323                 from,
1324                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1325             );
1326 
1327             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1328             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1329                 uint256 nextTokenId = tokenId + 1;
1330                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1331                 if (_packedOwnerships[nextTokenId] == 0) {
1332                     // If the next slot is within bounds.
1333                     if (nextTokenId != _currentIndex) {
1334                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1335                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1336                     }
1337                 }
1338             }
1339         }
1340 
1341         emit Transfer(from, address(0), tokenId);
1342         _afterTokenTransfers(from, address(0), tokenId, 1);
1343 
1344         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1345         unchecked {
1346             _burnCounter++;
1347         }
1348     }
1349 
1350     // =============================================================
1351     //                     EXTRA DATA OPERATIONS
1352     // =============================================================
1353 
1354     /**
1355      * @dev Directly sets the extra data for the ownership data `index`.
1356      */
1357     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1358         uint256 packed = _packedOwnerships[index];
1359         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1360         uint256 extraDataCasted;
1361         // Cast `extraData` with assembly to avoid redundant masking.
1362         assembly {
1363             extraDataCasted := extraData
1364         }
1365         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1366         _packedOwnerships[index] = packed;
1367     }
1368 
1369     /**
1370      * @dev Called during each token transfer to set the 24bit `extraData` field.
1371      * Intended to be overridden by the cosumer contract.
1372      *
1373      * `previousExtraData` - the value of `extraData` before transfer.
1374      *
1375      * Calling conditions:
1376      *
1377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1378      * transferred to `to`.
1379      * - When `from` is zero, `tokenId` will be minted for `to`.
1380      * - When `to` is zero, `tokenId` will be burned by `from`.
1381      * - `from` and `to` are never both zero.
1382      */
1383     function _extraData(
1384         address from,
1385         address to,
1386         uint24 previousExtraData
1387     ) internal view virtual returns (uint24) {}
1388 
1389     /**
1390      * @dev Returns the next extra data for the packed ownership data.
1391      * The returned result is shifted into position.
1392      */
1393     function _nextExtraData(
1394         address from,
1395         address to,
1396         uint256 prevOwnershipPacked
1397     ) private view returns (uint256) {
1398         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1399         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1400     }
1401 
1402     // =============================================================
1403     //                       OTHER OPERATIONS
1404     // =============================================================
1405 
1406     /**
1407      * @dev Returns the message sender (defaults to `msg.sender`).
1408      *
1409      * If you are writing GSN compatible contracts, you need to override this function.
1410      */
1411     function _msgSenderERC721A() internal view virtual returns (address) {
1412         return msg.sender;
1413     }
1414 
1415     /**
1416      * @dev Converts a uint256 to its ASCII string decimal representation.
1417      */
1418     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1419         assembly {
1420             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1421             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1422             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1423             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1424             let m := add(mload(0x40), 0xa0)
1425             // Update the free memory pointer to allocate.
1426             mstore(0x40, m)
1427             // Assign the `str` to the end.
1428             str := sub(m, 0x20)
1429             // Zeroize the slot after the string.
1430             mstore(str, 0)
1431 
1432             // Cache the end of the memory to calculate the length later.
1433             let end := str
1434 
1435             // We write the string from rightmost digit to leftmost digit.
1436             // The following is essentially a do-while loop that also handles the zero case.
1437             // prettier-ignore
1438             for { let temp := value } 1 {} {
1439                 str := sub(str, 1)
1440                 // Write the character to the pointer.
1441                 // The ASCII index of the '0' character is 48.
1442                 mstore8(str, add(48, mod(temp, 10)))
1443                 // Keep dividing `temp` until zero.
1444                 temp := div(temp, 10)
1445                 // prettier-ignore
1446                 if iszero(temp) { break }
1447             }
1448 
1449             let length := sub(end, str)
1450             // Move the pointer 32 bytes leftwards to make room for the length.
1451             str := sub(str, 0x20)
1452             // Store the length.
1453             mstore(str, length)
1454         }
1455     }
1456 }
1457 
1458 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1459 
1460 
1461 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @dev Contract module that helps prevent reentrant calls to a function.
1467  *
1468  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1469  * available, which can be applied to functions to make sure there are no nested
1470  * (reentrant) calls to them.
1471  *
1472  * Note that because there is a single `nonReentrant` guard, functions marked as
1473  * `nonReentrant` may not call one another. This can be worked around by making
1474  * those functions `private`, and then adding `external` `nonReentrant` entry
1475  * points to them.
1476  *
1477  * TIP: If you would like to learn more about reentrancy and alternative ways
1478  * to protect against it, check out our blog post
1479  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1480  */
1481 abstract contract ReentrancyGuard {
1482     // Booleans are more expensive than uint256 or any type that takes up a full
1483     // word because each write operation emits an extra SLOAD to first read the
1484     // slot's contents, replace the bits taken up by the boolean, and then write
1485     // back. This is the compiler's defense against contract upgrades and
1486     // pointer aliasing, and it cannot be disabled.
1487 
1488     // The values being non-zero value makes deployment a bit more expensive,
1489     // but in exchange the refund on every call to nonReentrant will be lower in
1490     // amount. Since refunds are capped to a percentage of the total
1491     // transaction's gas, it is best to keep them low in cases like this one, to
1492     // increase the likelihood of the full refund coming into effect.
1493     uint256 private constant _NOT_ENTERED = 1;
1494     uint256 private constant _ENTERED = 2;
1495 
1496     uint256 private _status;
1497 
1498     constructor() {
1499         _status = _NOT_ENTERED;
1500     }
1501 
1502     /**
1503      * @dev Prevents a contract from calling itself, directly or indirectly.
1504      * Calling a `nonReentrant` function from another `nonReentrant`
1505      * function is not supported. It is possible to prevent this from happening
1506      * by making the `nonReentrant` function external, and making it call a
1507      * `private` function that does the actual work.
1508      */
1509     modifier nonReentrant() {
1510         // On the first call to nonReentrant, _notEntered will be true
1511         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1512 
1513         // Any calls to nonReentrant after this point will fail
1514         _status = _ENTERED;
1515 
1516         _;
1517 
1518         // By storing the original value once again, a refund is triggered (see
1519         // https://eips.ethereum.org/EIPS/eip-2200)
1520         _status = _NOT_ENTERED;
1521     }
1522 }
1523 
1524 // File: @openzeppelin/contracts/utils/Context.sol
1525 
1526 
1527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 /**
1532  * @dev Provides information about the current execution context, including the
1533  * sender of the transaction and its data. While these are generally available
1534  * via msg.sender and msg.data, they should not be accessed in such a direct
1535  * manner, since when dealing with meta-transactions the account sending and
1536  * paying for execution may not be the actual sender (as far as an application
1537  * is concerned).
1538  *
1539  * This contract is only required for intermediate, library-like contracts.
1540  */
1541 abstract contract Context {
1542     function _msgSender() internal view virtual returns (address) {
1543         return msg.sender;
1544     }
1545 
1546     function _msgData() internal view virtual returns (bytes calldata) {
1547         return msg.data;
1548     }
1549 }
1550 
1551 // File: @openzeppelin/contracts/access/Ownable.sol
1552 
1553 
1554 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1555 
1556 pragma solidity ^0.8.0;
1557 
1558 
1559 /**
1560  * @dev Contract module which provides a basic access control mechanism, where
1561  * there is an account (an owner) that can be granted exclusive access to
1562  * specific functions.
1563  *
1564  * By default, the owner account will be the one that deploys the contract. This
1565  * can later be changed with {transferOwnership}.
1566  *
1567  * This module is used through inheritance. It will make available the modifier
1568  * `onlyOwner`, which can be applied to your functions to restrict their use to
1569  * the owner.
1570  */
1571 abstract contract Ownable is Context {
1572     address private _owner;
1573 
1574     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1575 
1576     /**
1577      * @dev Initializes the contract setting the deployer as the initial owner.
1578      */
1579     constructor() {
1580         _transferOwnership(_msgSender());
1581     }
1582 
1583     /**
1584      * @dev Throws if called by any account other than the owner.
1585      */
1586     modifier onlyOwner() {
1587         _checkOwner();
1588         _;
1589     }
1590 
1591     /**
1592      * @dev Returns the address of the current owner.
1593      */
1594     function owner() public view virtual returns (address) {
1595         return _owner;
1596     }
1597 
1598     /**
1599      * @dev Throws if the sender is not the owner.
1600      */
1601     function _checkOwner() internal view virtual {
1602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1603     }
1604 
1605     /**
1606      * @dev Leaves the contract without owner. It will not be possible to call
1607      * `onlyOwner` functions anymore. Can only be called by the current owner.
1608      *
1609      * NOTE: Renouncing ownership will leave the contract without an owner,
1610      * thereby removing any functionality that is only available to the owner.
1611      */
1612     function renounceOwnership() public virtual onlyOwner {
1613         _transferOwnership(address(0));
1614     }
1615 
1616     /**
1617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1618      * Can only be called by the current owner.
1619      */
1620     function transferOwnership(address newOwner) public virtual onlyOwner {
1621         require(newOwner != address(0), "Ownable: new owner is the zero address");
1622         _transferOwnership(newOwner);
1623     }
1624 
1625     /**
1626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1627      * Internal function without access restriction.
1628      */
1629     function _transferOwnership(address newOwner) internal virtual {
1630         address oldOwner = _owner;
1631         _owner = newOwner;
1632         emit OwnershipTransferred(oldOwner, newOwner);
1633     }
1634 }
1635 
1636 // File: contracts/cockroachtown.sol
1637 
1638 
1639 
1640 pragma solidity ^0.8.4;
1641 
1642 
1643 
1644 
1645 
1646 contract c0cKroAcht0wN is ERC721A, Ownable, ReentrancyGuard {
1647 
1648     using Strings for uint256;
1649 
1650     bool private iNvaSioN;
1651     string public c0cKroAchBoDEE;
1652     uint256 public immutable c0cKroAchArmy = 5555;
1653     uint256 public immutable c0cKroAchEGGs;
1654     uint256 private immutable c0cKroAchLaB;
1655     uint256 public c0cKroAchC0st = 0.005 ether;
1656     uint256 public c0cKroAchCaPTuReD;
1657 
1658     mapping(address => uint256) public c0cKroAchViRgiN;
1659 
1660     constructor(
1661         uint256 _EGGs,
1662         uint256 _LaB
1663     ) ERC721A("c0cKroAch t0wN", "c0cK") {
1664         c0cKroAchEGGs = _EGGs;
1665         c0cKroAchLaB = _LaB;
1666     }
1667 
1668     modifier callerIsc0cKroAch() {
1669         require(tx.origin == msg.sender, "The caller is not a c0cKroAch");
1670         _;
1671     }
1672 
1673     function breeDc0cKroAch(uint256 breeDEGGs) external payable callerIsc0cKroAch nonReentrant {
1674         uint256 totalc0cKroAch = totalSupply();
1675         require(iNvaSioN);
1676         require(breeDEGGs > 0);
1677         require(breeDEGGs <= c0cKroAchEGGs);
1678         require(totalc0cKroAch + breeDEGGs <= c0cKroAchArmy);
1679         require(c0cKroAchViRgiN[msg.sender] + breeDEGGs <= c0cKroAchEGGs);
1680         require(totalc0cKroAch - c0cKroAchCaPTuReD + breeDEGGs <= c0cKroAchArmy - c0cKroAchLaB);
1681         if (c0cKroAchViRgiN[msg.sender] == 0) {
1682             require(msg.value >= (breeDEGGs-1) * c0cKroAchC0st);
1683         } else {
1684             require(msg.value >= breeDEGGs * c0cKroAchC0st);
1685         }
1686         _safeMint(msg.sender, breeDEGGs);
1687         c0cKroAchViRgiN[msg.sender] += breeDEGGs;
1688     }
1689 
1690     function _startTokenId() internal view virtual override returns (uint256) {
1691         return 1;
1692     }
1693 
1694     function cAtcHc0cKroAchF0rLaB(address c0cKLaB, uint256 breeDEGGs) public onlyOwner {
1695         uint256 totalc0cKroAch = totalSupply();
1696         require(totalc0cKroAch + breeDEGGs <= c0cKroAchArmy);
1697         require(c0cKroAchCaPTuReD + breeDEGGs <= c0cKroAchLaB);
1698         _safeMint(c0cKLaB, breeDEGGs);
1699         c0cKroAchCaPTuReD += breeDEGGs;
1700     }
1701 
1702     function laUncHiNvaSioN(bool _secret) external onlyOwner {
1703         iNvaSioN = _secret;
1704     }
1705 
1706     function gReEDyc0cKroAch(uint256 nEwC0sT) external onlyOwner {
1707         c0cKroAchC0st = nEwC0sT;
1708     }
1709 
1710     function _baseURI() internal view virtual override returns (string memory) {
1711         return c0cKroAchBoDEE;
1712     }
1713 
1714     function sH0wBoDEE(string memory _BoDEE) external onlyOwner {
1715         c0cKroAchBoDEE = _BoDEE;
1716     }
1717 
1718     function c0cKroAchNeEdMoNi() external onlyOwner nonReentrant {
1719 	    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1720 		require(success);
1721     }
1722 
1723 }