1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library StringsUpgradeable {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15     uint8 private constant _ADDRESS_LENGTH = 20;
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 
73     /**
74      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
75      */
76     function toHexString(address addr) internal pure returns (string memory) {
77         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
78     }
79 }
80 
81 // File: erc721a/contracts/IERC721A.sol
82 
83 
84 // ERC721A Contracts v4.2.3
85 // Creator: Chiru Labs
86 
87 pragma solidity ^0.8.4;
88 
89 /**
90  * @dev Interface of ERC721A.
91  */
92 interface IERC721A {
93     /**
94      * The caller must own the token or be an approved operator.
95      */
96     error ApprovalCallerNotOwnerNorApproved();
97 
98     /**
99      * The token does not exist.
100      */
101     error ApprovalQueryForNonexistentToken();
102 
103     /**
104      * Cannot query the balance for the zero address.
105      */
106     error BalanceQueryForZeroAddress();
107 
108     /**
109      * Cannot mint to the zero address.
110      */
111     error MintToZeroAddress();
112 
113     /**
114      * The quantity of tokens minted must be more than zero.
115      */
116     error MintZeroQuantity();
117 
118     /**
119      * The token does not exist.
120      */
121     error OwnerQueryForNonexistentToken();
122 
123     /**
124      * The caller must own the token or be an approved operator.
125      */
126     error TransferCallerNotOwnerNorApproved();
127 
128     /**
129      * The token must be owned by `from`.
130      */
131     error TransferFromIncorrectOwner();
132 
133     /**
134      * Cannot safely transfer to a contract that does not implement the
135      * ERC721Receiver interface.
136      */
137     error TransferToNonERC721ReceiverImplementer();
138 
139     /**
140      * Cannot transfer to the zero address.
141      */
142     error TransferToZeroAddress();
143 
144     /**
145      * The token does not exist.
146      */
147     error URIQueryForNonexistentToken();
148 
149     /**
150      * The `quantity` minted with ERC2309 exceeds the safety limit.
151      */
152     error MintERC2309QuantityExceedsLimit();
153 
154     /**
155      * The `extraData` cannot be set on an unintialized ownership slot.
156      */
157     error OwnershipNotInitializedForExtraData();
158 
159     // =============================================================
160     //                            STRUCTS
161     // =============================================================
162 
163     struct TokenOwnership {
164         // The address of the owner.
165         address addr;
166         // Stores the start time of ownership with minimal overhead for tokenomics.
167         uint64 startTimestamp;
168         // Whether the token has been burned.
169         bool burned;
170         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
171         uint24 extraData;
172     }
173 
174     // =============================================================
175     //                         TOKEN COUNTERS
176     // =============================================================
177 
178     /**
179      * @dev Returns the total number of tokens in existence.
180      * Burned tokens will reduce the count.
181      * To get the total number of tokens minted, please see {_totalMinted}.
182      */
183     function totalSupply() external view returns (uint256);
184 
185     // =============================================================
186     //                            IERC165
187     // =============================================================
188 
189     /**
190      * @dev Returns true if this contract implements the interface defined by
191      * `interfaceId`. See the corresponding
192      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
193      * to learn more about how these ids are created.
194      *
195      * This function call must use less than 30000 gas.
196      */
197     function supportsInterface(bytes4 interfaceId) external view returns (bool);
198 
199     // =============================================================
200     //                            IERC721
201     // =============================================================
202 
203     /**
204      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
210      */
211     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
212 
213     /**
214      * @dev Emitted when `owner` enables or disables
215      * (`approved`) `operator` to manage all of its assets.
216      */
217     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
218 
219     /**
220      * @dev Returns the number of tokens in `owner`'s account.
221      */
222     function balanceOf(address owner) external view returns (uint256 balance);
223 
224     /**
225      * @dev Returns the owner of the `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function ownerOf(uint256 tokenId) external view returns (address owner);
232 
233     /**
234      * @dev Safely transfers `tokenId` token from `from` to `to`,
235      * checking first that contract recipients are aware of the ERC721 protocol
236      * to prevent tokens from being forever locked.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be have been allowed to move
244      * this token by either {approve} or {setApprovalForAll}.
245      * - If `to` refers to a smart contract, it must implement
246      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId,
254         bytes calldata data
255     ) external payable;
256 
257     /**
258      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external payable;
265 
266     /**
267      * @dev Transfers `tokenId` from `from` to `to`.
268      *
269      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
270      * whenever possible.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token
278      * by either {approve} or {setApprovalForAll}.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external payable;
287 
288     /**
289      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
290      * The approval is cleared when the token is transferred.
291      *
292      * Only a single account can be approved at a time, so approving the
293      * zero address clears previous approvals.
294      *
295      * Requirements:
296      *
297      * - The caller must own the token or be an approved operator.
298      * - `tokenId` must exist.
299      *
300      * Emits an {Approval} event.
301      */
302     function approve(address to, uint256 tokenId) external payable;
303 
304     /**
305      * @dev Approve or remove `operator` as an operator for the caller.
306      * Operators can call {transferFrom} or {safeTransferFrom}
307      * for any token owned by the caller.
308      *
309      * Requirements:
310      *
311      * - The `operator` cannot be the caller.
312      *
313      * Emits an {ApprovalForAll} event.
314      */
315     function setApprovalForAll(address operator, bool _approved) external;
316 
317     /**
318      * @dev Returns the account approved for `tokenId` token.
319      *
320      * Requirements:
321      *
322      * - `tokenId` must exist.
323      */
324     function getApproved(uint256 tokenId) external view returns (address operator);
325 
326     /**
327      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
328      *
329      * See {setApprovalForAll}.
330      */
331     function isApprovedForAll(address owner, address operator) external view returns (bool);
332 
333     // =============================================================
334     //                        IERC721Metadata
335     // =============================================================
336 
337     /**
338      * @dev Returns the token collection name.
339      */
340     function name() external view returns (string memory);
341 
342     /**
343      * @dev Returns the token collection symbol.
344      */
345     function symbol() external view returns (string memory);
346 
347     /**
348      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
349      */
350     function tokenURI(uint256 tokenId) external view returns (string memory);
351 
352     // =============================================================
353     //                           IERC2309
354     // =============================================================
355 
356     /**
357      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
358      * (inclusive) is transferred from `from` to `to`, as defined in the
359      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
360      *
361      * See {_mintERC2309} for more details.
362      */
363     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
364 }
365 
366 // File: erc721a/contracts/ERC721A.sol
367 
368 
369 // ERC721A Contracts v4.2.3
370 // Creator: Chiru Labs
371 
372 pragma solidity ^0.8.4;
373 
374 
375 /**
376  * @dev Interface of ERC721 token receiver.
377  */
378 interface ERC721A__IERC721Receiver {
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 /**
388  * @title ERC721A
389  *
390  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
391  * Non-Fungible Token Standard, including the Metadata extension.
392  * Optimized for lower gas during batch mints.
393  *
394  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
395  * starting from `_startTokenId()`.
396  *
397  * Assumptions:
398  *
399  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
400  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
401  */
402 contract ERC721A is IERC721A {
403     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
404     struct TokenApprovalRef {
405         address value;
406     }
407 
408     // =============================================================
409     //                           CONSTANTS
410     // =============================================================
411 
412     // Mask of an entry in packed address data.
413     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
414 
415     // The bit position of `numberMinted` in packed address data.
416     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
417 
418     // The bit position of `numberBurned` in packed address data.
419     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
420 
421     // The bit position of `aux` in packed address data.
422     uint256 private constant _BITPOS_AUX = 192;
423 
424     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
425     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
426 
427     // The bit position of `startTimestamp` in packed ownership.
428     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
429 
430     // The bit mask of the `burned` bit in packed ownership.
431     uint256 private constant _BITMASK_BURNED = 1 << 224;
432 
433     // The bit position of the `nextInitialized` bit in packed ownership.
434     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
435 
436     // The bit mask of the `nextInitialized` bit in packed ownership.
437     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
438 
439     // The bit position of `extraData` in packed ownership.
440     uint256 private constant _BITPOS_EXTRA_DATA = 232;
441 
442     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
443     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
444 
445     // The mask of the lower 160 bits for addresses.
446     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
447 
448     // The maximum `quantity` that can be minted with {_mintERC2309}.
449     // This limit is to prevent overflows on the address data entries.
450     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
451     // is required to cause an overflow, which is unrealistic.
452     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
453 
454     // The `Transfer` event signature is given by:
455     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
456     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
457         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
458 
459     // =============================================================
460     //                            STORAGE
461     // =============================================================
462 
463     // The next token ID to be minted.
464     uint256 private _currentIndex;
465 
466     // The number of tokens burned.
467     uint256 private _burnCounter;
468 
469     // Token name
470     string private _name;
471 
472     // Token symbol
473     string private _symbol;
474 
475     // Mapping from token ID to ownership details
476     // An empty struct value does not necessarily mean the token is unowned.
477     // See {_packedOwnershipOf} implementation for details.
478     //
479     // Bits Layout:
480     // - [0..159]   `addr`
481     // - [160..223] `startTimestamp`
482     // - [224]      `burned`
483     // - [225]      `nextInitialized`
484     // - [232..255] `extraData`
485     mapping(uint256 => uint256) private _packedOwnerships;
486 
487     // Mapping owner address to address data.
488     //
489     // Bits Layout:
490     // - [0..63]    `balance`
491     // - [64..127]  `numberMinted`
492     // - [128..191] `numberBurned`
493     // - [192..255] `aux`
494     mapping(address => uint256) private _packedAddressData;
495 
496     // Mapping from token ID to approved address.
497     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
498 
499     // Mapping from owner to operator approvals
500     mapping(address => mapping(address => bool)) private _operatorApprovals;
501 
502     // =============================================================
503     //                          CONSTRUCTOR
504     // =============================================================
505 
506     constructor(string memory name_, string memory symbol_) {
507         _name = name_;
508         _symbol = symbol_;
509         _currentIndex = _startTokenId();
510     }
511 
512     // =============================================================
513     //                   TOKEN COUNTING OPERATIONS
514     // =============================================================
515 
516     /**
517      * @dev Returns the starting token ID.
518      * To change the starting token ID, please override this function.
519      */
520     function _startTokenId() internal view virtual returns (uint256) {
521         return 0;
522     }
523 
524     /**
525      * @dev Returns the next token ID to be minted.
526      */
527     function _nextTokenId() internal view virtual returns (uint256) {
528         return _currentIndex;
529     }
530 
531     /**
532      * @dev Returns the total number of tokens in existence.
533      * Burned tokens will reduce the count.
534      * To get the total number of tokens minted, please see {_totalMinted}.
535      */
536     function totalSupply() public view virtual override returns (uint256) {
537         // Counter underflow is impossible as _burnCounter cannot be incremented
538         // more than `_currentIndex - _startTokenId()` times.
539         unchecked {
540             return _currentIndex - _burnCounter - _startTokenId();
541         }
542     }
543 
544     /**
545      * @dev Returns the total amount of tokens minted in the contract.
546      */
547     function _totalMinted() internal view virtual returns (uint256) {
548         // Counter underflow is impossible as `_currentIndex` does not decrement,
549         // and it is initialized to `_startTokenId()`.
550         unchecked {
551             return _currentIndex - _startTokenId();
552         }
553     }
554 
555     /**
556      * @dev Returns the total number of tokens burned.
557      */
558     function _totalBurned() internal view virtual returns (uint256) {
559         return _burnCounter;
560     }
561 
562     // =============================================================
563     //                    ADDRESS DATA OPERATIONS
564     // =============================================================
565 
566     /**
567      * @dev Returns the number of tokens in `owner`'s account.
568      */
569     function balanceOf(address owner) public view virtual override returns (uint256) {
570         if (owner == address(0)) revert BalanceQueryForZeroAddress();
571         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
572     }
573 
574     /**
575      * Returns the number of tokens minted by `owner`.
576      */
577     function _numberMinted(address owner) internal view returns (uint256) {
578         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
579     }
580 
581     /**
582      * Returns the number of tokens burned by or on behalf of `owner`.
583      */
584     function _numberBurned(address owner) internal view returns (uint256) {
585         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
586     }
587 
588     /**
589      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
590      */
591     function _getAux(address owner) internal view returns (uint64) {
592         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
593     }
594 
595     /**
596      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
597      * If there are multiple variables, please pack them into a uint64.
598      */
599     function _setAux(address owner, uint64 aux) internal virtual {
600         uint256 packed = _packedAddressData[owner];
601         uint256 auxCasted;
602         // Cast `aux` with assembly to avoid redundant masking.
603         assembly {
604             auxCasted := aux
605         }
606         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
607         _packedAddressData[owner] = packed;
608     }
609 
610     // =============================================================
611     //                            IERC165
612     // =============================================================
613 
614     /**
615      * @dev Returns true if this contract implements the interface defined by
616      * `interfaceId`. See the corresponding
617      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
618      * to learn more about how these ids are created.
619      *
620      * This function call must use less than 30000 gas.
621      */
622     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
623         // The interface IDs are constants representing the first 4 bytes
624         // of the XOR of all function selectors in the interface.
625         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
626         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
627         return
628             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
629             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
630             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
631     }
632 
633     // =============================================================
634     //                        IERC721Metadata
635     // =============================================================
636 
637     /**
638      * @dev Returns the token collection name.
639      */
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
653      */
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
656 
657         string memory baseURI = _baseURI();
658         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
659     }
660 
661     /**
662      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
663      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
664      * by default, it can be overridden in child contracts.
665      */
666     function _baseURI() internal view virtual returns (string memory) {
667         return '';
668     }
669 
670     // =============================================================
671     //                     OWNERSHIPS OPERATIONS
672     // =============================================================
673 
674     /**
675      * @dev Returns the owner of the `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
682         return address(uint160(_packedOwnershipOf(tokenId)));
683     }
684 
685     /**
686      * @dev Gas spent here starts off proportional to the maximum mint batch size.
687      * It gradually moves to O(1) as tokens get transferred around over time.
688      */
689     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
690         return _unpackedOwnership(_packedOwnershipOf(tokenId));
691     }
692 
693     /**
694      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
695      */
696     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
697         return _unpackedOwnership(_packedOwnerships[index]);
698     }
699 
700     /**
701      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
702      */
703     function _initializeOwnershipAt(uint256 index) internal virtual {
704         if (_packedOwnerships[index] == 0) {
705             _packedOwnerships[index] = _packedOwnershipOf(index);
706         }
707     }
708 
709     /**
710      * Returns the packed ownership data of `tokenId`.
711      */
712     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
713         uint256 curr = tokenId;
714 
715         unchecked {
716             if (_startTokenId() <= curr)
717                 if (curr < _currentIndex) {
718                     uint256 packed = _packedOwnerships[curr];
719                     // If not burned.
720                     if (packed & _BITMASK_BURNED == 0) {
721                         // Invariant:
722                         // There will always be an initialized ownership slot
723                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
724                         // before an unintialized ownership slot
725                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
726                         // Hence, `curr` will not underflow.
727                         //
728                         // We can directly compare the packed value.
729                         // If the address is zero, packed will be zero.
730                         while (packed == 0) {
731                             packed = _packedOwnerships[--curr];
732                         }
733                         return packed;
734                     }
735                 }
736         }
737         revert OwnerQueryForNonexistentToken();
738     }
739 
740     /**
741      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
742      */
743     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
744         ownership.addr = address(uint160(packed));
745         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
746         ownership.burned = packed & _BITMASK_BURNED != 0;
747         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
748     }
749 
750     /**
751      * @dev Packs ownership data into a single uint256.
752      */
753     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
754         assembly {
755             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
756             owner := and(owner, _BITMASK_ADDRESS)
757             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
758             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
759         }
760     }
761 
762     /**
763      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
764      */
765     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
766         // For branchless setting of the `nextInitialized` flag.
767         assembly {
768             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
769             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
770         }
771     }
772 
773     // =============================================================
774     //                      APPROVAL OPERATIONS
775     // =============================================================
776 
777     /**
778      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
779      * The approval is cleared when the token is transferred.
780      *
781      * Only a single account can be approved at a time, so approving the
782      * zero address clears previous approvals.
783      *
784      * Requirements:
785      *
786      * - The caller must own the token or be an approved operator.
787      * - `tokenId` must exist.
788      *
789      * Emits an {Approval} event.
790      */
791     function approve(address to, uint256 tokenId) public payable virtual override {
792         address owner = ownerOf(tokenId);
793 
794         if (_msgSenderERC721A() != owner)
795             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
796                 revert ApprovalCallerNotOwnerNorApproved();
797             }
798 
799         _tokenApprovals[tokenId].value = to;
800         emit Approval(owner, to, tokenId);
801     }
802 
803     /**
804      * @dev Returns the account approved for `tokenId` token.
805      *
806      * Requirements:
807      *
808      * - `tokenId` must exist.
809      */
810     function getApproved(uint256 tokenId) public view virtual override returns (address) {
811         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
812 
813         return _tokenApprovals[tokenId].value;
814     }
815 
816     /**
817      * @dev Approve or remove `operator` as an operator for the caller.
818      * Operators can call {transferFrom} or {safeTransferFrom}
819      * for any token owned by the caller.
820      *
821      * Requirements:
822      *
823      * - The `operator` cannot be the caller.
824      *
825      * Emits an {ApprovalForAll} event.
826      */
827     function setApprovalForAll(address operator, bool approved) public virtual override {
828         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
829         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
830     }
831 
832     /**
833      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834      *
835      * See {setApprovalForAll}.
836      */
837     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
838         return _operatorApprovals[owner][operator];
839     }
840 
841     /**
842      * @dev Returns whether `tokenId` exists.
843      *
844      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
845      *
846      * Tokens start existing when they are minted. See {_mint}.
847      */
848     function _exists(uint256 tokenId) internal view virtual returns (bool) {
849         return
850             _startTokenId() <= tokenId &&
851             tokenId < _currentIndex && // If within bounds,
852             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
853     }
854 
855     /**
856      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
857      */
858     function _isSenderApprovedOrOwner(
859         address approvedAddress,
860         address owner,
861         address msgSender
862     ) private pure returns (bool result) {
863         assembly {
864             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
865             owner := and(owner, _BITMASK_ADDRESS)
866             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
867             msgSender := and(msgSender, _BITMASK_ADDRESS)
868             // `msgSender == owner || msgSender == approvedAddress`.
869             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
870         }
871     }
872 
873     /**
874      * @dev Returns the storage slot and value for the approved address of `tokenId`.
875      */
876     function _getApprovedSlotAndAddress(uint256 tokenId)
877         private
878         view
879         returns (uint256 approvedAddressSlot, address approvedAddress)
880     {
881         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
882         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
883         assembly {
884             approvedAddressSlot := tokenApproval.slot
885             approvedAddress := sload(approvedAddressSlot)
886         }
887     }
888 
889     // =============================================================
890     //                      TRANSFER OPERATIONS
891     // =============================================================
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      * - If the caller is not `from`, it must be approved to move this token
902      * by either {approve} or {setApprovalForAll}.
903      *
904      * Emits a {Transfer} event.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public payable virtual override {
911         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
912 
913         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
914 
915         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
916 
917         // The nested ifs save around 20+ gas over a compound boolean condition.
918         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
919             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
920 
921         if (to == address(0)) revert TransferToZeroAddress();
922 
923         _beforeTokenTransfers(from, to, tokenId, 1);
924 
925         // Clear approvals from the previous owner.
926         assembly {
927             if approvedAddress {
928                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
929                 sstore(approvedAddressSlot, 0)
930             }
931         }
932 
933         // Underflow of the sender's balance is impossible because we check for
934         // ownership above and the recipient's balance can't realistically overflow.
935         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
936         unchecked {
937             // We can directly increment and decrement the balances.
938             --_packedAddressData[from]; // Updates: `balance -= 1`.
939             ++_packedAddressData[to]; // Updates: `balance += 1`.
940 
941             // Updates:
942             // - `address` to the next owner.
943             // - `startTimestamp` to the timestamp of transfering.
944             // - `burned` to `false`.
945             // - `nextInitialized` to `true`.
946             _packedOwnerships[tokenId] = _packOwnershipData(
947                 to,
948                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
949             );
950 
951             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
952             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
953                 uint256 nextTokenId = tokenId + 1;
954                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
955                 if (_packedOwnerships[nextTokenId] == 0) {
956                     // If the next slot is within bounds.
957                     if (nextTokenId != _currentIndex) {
958                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
959                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
960                     }
961                 }
962             }
963         }
964 
965         emit Transfer(from, to, tokenId);
966         _afterTokenTransfers(from, to, tokenId, 1);
967     }
968 
969     /**
970      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public payable virtual override {
977         safeTransferFrom(from, to, tokenId, '');
978     }
979 
980     /**
981      * @dev Safely transfers `tokenId` token from `from` to `to`.
982      *
983      * Requirements:
984      *
985      * - `from` cannot be the zero address.
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must exist and be owned by `from`.
988      * - If the caller is not `from`, it must be approved to move this token
989      * by either {approve} or {setApprovalForAll}.
990      * - If `to` refers to a smart contract, it must implement
991      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId,
999         bytes memory _data
1000     ) public payable virtual override {
1001         transferFrom(from, to, tokenId);
1002         if (to.code.length != 0)
1003             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1004                 revert TransferToNonERC721ReceiverImplementer();
1005             }
1006     }
1007 
1008     /**
1009      * @dev Hook that is called before a set of serially-ordered token IDs
1010      * are about to be transferred. This includes minting.
1011      * And also called before burning one token.
1012      *
1013      * `startTokenId` - the first token ID to be transferred.
1014      * `quantity` - the amount to be transferred.
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` will be minted for `to`.
1021      * - When `to` is zero, `tokenId` will be burned by `from`.
1022      * - `from` and `to` are never both zero.
1023      */
1024     function _beforeTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Hook that is called after a set of serially-ordered token IDs
1033      * have been transferred. This includes minting.
1034      * And also called after one token has been burned.
1035      *
1036      * `startTokenId` - the first token ID to be transferred.
1037      * `quantity` - the amount to be transferred.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` has been minted for `to`.
1044      * - When `to` is zero, `tokenId` has been burned by `from`.
1045      * - `from` and `to` are never both zero.
1046      */
1047     function _afterTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1056      *
1057      * `from` - Previous owner of the given token ID.
1058      * `to` - Target address that will receive the token.
1059      * `tokenId` - Token ID to be transferred.
1060      * `_data` - Optional data to send along with the call.
1061      *
1062      * Returns whether the call correctly returned the expected magic value.
1063      */
1064     function _checkContractOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1071             bytes4 retval
1072         ) {
1073             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1074         } catch (bytes memory reason) {
1075             if (reason.length == 0) {
1076                 revert TransferToNonERC721ReceiverImplementer();
1077             } else {
1078                 assembly {
1079                     revert(add(32, reason), mload(reason))
1080                 }
1081             }
1082         }
1083     }
1084 
1085     // =============================================================
1086     //                        MINT OPERATIONS
1087     // =============================================================
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `to` cannot be the zero address.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event for each mint.
1098      */
1099     function _mint(address to, uint256 quantity) internal virtual {
1100         uint256 startTokenId = _currentIndex;
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // `balance` and `numberMinted` have a maximum limit of 2**64.
1107         // `tokenId` has a maximum limit of 2**256.
1108         unchecked {
1109             // Updates:
1110             // - `balance += quantity`.
1111             // - `numberMinted += quantity`.
1112             //
1113             // We can directly add to the `balance` and `numberMinted`.
1114             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1115 
1116             // Updates:
1117             // - `address` to the owner.
1118             // - `startTimestamp` to the timestamp of minting.
1119             // - `burned` to `false`.
1120             // - `nextInitialized` to `quantity == 1`.
1121             _packedOwnerships[startTokenId] = _packOwnershipData(
1122                 to,
1123                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1124             );
1125 
1126             uint256 toMasked;
1127             uint256 end = startTokenId + quantity;
1128 
1129             // Use assembly to loop and emit the `Transfer` event for gas savings.
1130             // The duplicated `log4` removes an extra check and reduces stack juggling.
1131             // The assembly, together with the surrounding Solidity code, have been
1132             // delicately arranged to nudge the compiler into producing optimized opcodes.
1133             assembly {
1134                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1135                 toMasked := and(to, _BITMASK_ADDRESS)
1136                 // Emit the `Transfer` event.
1137                 log4(
1138                     0, // Start of data (0, since no data).
1139                     0, // End of data (0, since no data).
1140                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1141                     0, // `address(0)`.
1142                     toMasked, // `to`.
1143                     startTokenId // `tokenId`.
1144                 )
1145 
1146                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1147                 // that overflows uint256 will make the loop run out of gas.
1148                 // The compiler will optimize the `iszero` away for performance.
1149                 for {
1150                     let tokenId := add(startTokenId, 1)
1151                 } iszero(eq(tokenId, end)) {
1152                     tokenId := add(tokenId, 1)
1153                 } {
1154                     // Emit the `Transfer` event. Similar to above.
1155                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1156                 }
1157             }
1158             if (toMasked == 0) revert MintToZeroAddress();
1159 
1160             _currentIndex = end;
1161         }
1162         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1163     }
1164 
1165     /**
1166      * @dev Mints `quantity` tokens and transfers them to `to`.
1167      *
1168      * This function is intended for efficient minting only during contract creation.
1169      *
1170      * It emits only one {ConsecutiveTransfer} as defined in
1171      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1172      * instead of a sequence of {Transfer} event(s).
1173      *
1174      * Calling this function outside of contract creation WILL make your contract
1175      * non-compliant with the ERC721 standard.
1176      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1177      * {ConsecutiveTransfer} event is only permissible during contract creation.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `quantity` must be greater than 0.
1183      *
1184      * Emits a {ConsecutiveTransfer} event.
1185      */
1186     function _mintERC2309(address to, uint256 quantity) internal virtual {
1187         uint256 startTokenId = _currentIndex;
1188         if (to == address(0)) revert MintToZeroAddress();
1189         if (quantity == 0) revert MintZeroQuantity();
1190         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1191 
1192         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1193 
1194         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1195         unchecked {
1196             // Updates:
1197             // - `balance += quantity`.
1198             // - `numberMinted += quantity`.
1199             //
1200             // We can directly add to the `balance` and `numberMinted`.
1201             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1202 
1203             // Updates:
1204             // - `address` to the owner.
1205             // - `startTimestamp` to the timestamp of minting.
1206             // - `burned` to `false`.
1207             // - `nextInitialized` to `quantity == 1`.
1208             _packedOwnerships[startTokenId] = _packOwnershipData(
1209                 to,
1210                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1211             );
1212 
1213             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1214 
1215             _currentIndex = startTokenId + quantity;
1216         }
1217         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1218     }
1219 
1220     /**
1221      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1222      *
1223      * Requirements:
1224      *
1225      * - If `to` refers to a smart contract, it must implement
1226      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1227      * - `quantity` must be greater than 0.
1228      *
1229      * See {_mint}.
1230      *
1231      * Emits a {Transfer} event for each mint.
1232      */
1233     function _safeMint(
1234         address to,
1235         uint256 quantity,
1236         bytes memory _data
1237     ) internal virtual {
1238         _mint(to, quantity);
1239 
1240         unchecked {
1241             if (to.code.length != 0) {
1242                 uint256 end = _currentIndex;
1243                 uint256 index = end - quantity;
1244                 do {
1245                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1246                         revert TransferToNonERC721ReceiverImplementer();
1247                     }
1248                 } while (index < end);
1249                 // Reentrancy protection.
1250                 if (_currentIndex != end) revert();
1251             }
1252         }
1253     }
1254 
1255     /**
1256      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1257      */
1258     function _safeMint(address to, uint256 quantity) internal virtual {
1259         _safeMint(to, quantity, '');
1260     }
1261 
1262     // =============================================================
1263     //                        BURN OPERATIONS
1264     // =============================================================
1265 
1266     /**
1267      * @dev Equivalent to `_burn(tokenId, false)`.
1268      */
1269     function _burn(uint256 tokenId) internal virtual {
1270         _burn(tokenId, false);
1271     }
1272 
1273     /**
1274      * @dev Destroys `tokenId`.
1275      * The approval is cleared when the token is burned.
1276      *
1277      * Requirements:
1278      *
1279      * - `tokenId` must exist.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1284         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1285 
1286         address from = address(uint160(prevOwnershipPacked));
1287 
1288         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1289 
1290         if (approvalCheck) {
1291             // The nested ifs save around 20+ gas over a compound boolean condition.
1292             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1293                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1294         }
1295 
1296         _beforeTokenTransfers(from, address(0), tokenId, 1);
1297 
1298         // Clear approvals from the previous owner.
1299         assembly {
1300             if approvedAddress {
1301                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1302                 sstore(approvedAddressSlot, 0)
1303             }
1304         }
1305 
1306         // Underflow of the sender's balance is impossible because we check for
1307         // ownership above and the recipient's balance can't realistically overflow.
1308         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1309         unchecked {
1310             // Updates:
1311             // - `balance -= 1`.
1312             // - `numberBurned += 1`.
1313             //
1314             // We can directly decrement the balance, and increment the number burned.
1315             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1316             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1317 
1318             // Updates:
1319             // - `address` to the last owner.
1320             // - `startTimestamp` to the timestamp of burning.
1321             // - `burned` to `true`.
1322             // - `nextInitialized` to `true`.
1323             _packedOwnerships[tokenId] = _packOwnershipData(
1324                 from,
1325                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1326             );
1327 
1328             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1329             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1330                 uint256 nextTokenId = tokenId + 1;
1331                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1332                 if (_packedOwnerships[nextTokenId] == 0) {
1333                     // If the next slot is within bounds.
1334                     if (nextTokenId != _currentIndex) {
1335                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1336                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1337                     }
1338                 }
1339             }
1340         }
1341 
1342         emit Transfer(from, address(0), tokenId);
1343         _afterTokenTransfers(from, address(0), tokenId, 1);
1344 
1345         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1346         unchecked {
1347             _burnCounter++;
1348         }
1349     }
1350 
1351     // =============================================================
1352     //                     EXTRA DATA OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Directly sets the extra data for the ownership data `index`.
1357      */
1358     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1359         uint256 packed = _packedOwnerships[index];
1360         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1361         uint256 extraDataCasted;
1362         // Cast `extraData` with assembly to avoid redundant masking.
1363         assembly {
1364             extraDataCasted := extraData
1365         }
1366         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1367         _packedOwnerships[index] = packed;
1368     }
1369 
1370     /**
1371      * @dev Called during each token transfer to set the 24bit `extraData` field.
1372      * Intended to be overridden by the cosumer contract.
1373      *
1374      * `previousExtraData` - the value of `extraData` before transfer.
1375      *
1376      * Calling conditions:
1377      *
1378      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1379      * transferred to `to`.
1380      * - When `from` is zero, `tokenId` will be minted for `to`.
1381      * - When `to` is zero, `tokenId` will be burned by `from`.
1382      * - `from` and `to` are never both zero.
1383      */
1384     function _extraData(
1385         address from,
1386         address to,
1387         uint24 previousExtraData
1388     ) internal view virtual returns (uint24) {}
1389 
1390     /**
1391      * @dev Returns the next extra data for the packed ownership data.
1392      * The returned result is shifted into position.
1393      */
1394     function _nextExtraData(
1395         address from,
1396         address to,
1397         uint256 prevOwnershipPacked
1398     ) private view returns (uint256) {
1399         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1400         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1401     }
1402 
1403     // =============================================================
1404     //                       OTHER OPERATIONS
1405     // =============================================================
1406 
1407     /**
1408      * @dev Returns the message sender (defaults to `msg.sender`).
1409      *
1410      * If you are writing GSN compatible contracts, you need to override this function.
1411      */
1412     function _msgSenderERC721A() internal view virtual returns (address) {
1413         return msg.sender;
1414     }
1415 
1416     /**
1417      * @dev Converts a uint256 to its ASCII string decimal representation.
1418      */
1419     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1420         assembly {
1421             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1422             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1423             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1424             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1425             let m := add(mload(0x40), 0xa0)
1426             // Update the free memory pointer to allocate.
1427             mstore(0x40, m)
1428             // Assign the `str` to the end.
1429             str := sub(m, 0x20)
1430             // Zeroize the slot after the string.
1431             mstore(str, 0)
1432 
1433             // Cache the end of the memory to calculate the length later.
1434             let end := str
1435 
1436             // We write the string from rightmost digit to leftmost digit.
1437             // The following is essentially a do-while loop that also handles the zero case.
1438             // prettier-ignore
1439             for { let temp := value } 1 {} {
1440                 str := sub(str, 1)
1441                 // Write the character to the pointer.
1442                 // The ASCII index of the '0' character is 48.
1443                 mstore8(str, add(48, mod(temp, 10)))
1444                 // Keep dividing `temp` until zero.
1445                 temp := div(temp, 10)
1446                 // prettier-ignore
1447                 if iszero(temp) { break }
1448             }
1449 
1450             let length := sub(end, str)
1451             // Move the pointer 32 bytes leftwards to make room for the length.
1452             str := sub(str, 0x20)
1453             // Store the length.
1454             mstore(str, length)
1455         }
1456     }
1457 }
1458 
1459 // File: @openzeppelin/contracts/utils/Context.sol
1460 
1461 
1462 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1463 
1464 pragma solidity ^0.8.0;
1465 
1466 /**
1467  * @dev Provides information about the current execution context, including the
1468  * sender of the transaction and its data. While these are generally available
1469  * via msg.sender and msg.data, they should not be accessed in such a direct
1470  * manner, since when dealing with meta-transactions the account sending and
1471  * paying for execution may not be the actual sender (as far as an application
1472  * is concerned).
1473  *
1474  * This contract is only required for intermediate, library-like contracts.
1475  */
1476 abstract contract Context {
1477     function _msgSender() internal view virtual returns (address) {
1478         return msg.sender;
1479     }
1480 
1481     function _msgData() internal view virtual returns (bytes calldata) {
1482         return msg.data;
1483     }
1484 }
1485 
1486 // File: @openzeppelin/contracts/access/Ownable.sol
1487 
1488 
1489 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1490 
1491 pragma solidity ^0.8.0;
1492 
1493 
1494 /**
1495  * @dev Contract module which provides a basic access control mechanism, where
1496  * there is an account (an owner) that can be granted exclusive access to
1497  * specific functions.
1498  *
1499  * By default, the owner account will be the one that deploys the contract. This
1500  * can later be changed with {transferOwnership}.
1501  *
1502  * This module is used through inheritance. It will make available the modifier
1503  * `onlyOwner`, which can be applied to your functions to restrict their use to
1504  * the owner.
1505  */
1506 abstract contract Ownable is Context {
1507     address private _owner;
1508 
1509     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1510 
1511     /**
1512      * @dev Initializes the contract setting the deployer as the initial owner.
1513      */
1514     constructor() {
1515         _transferOwnership(_msgSender());
1516     }
1517 
1518     /**
1519      * @dev Throws if called by any account other than the owner.
1520      */
1521     modifier onlyOwner() {
1522         _checkOwner();
1523         _;
1524     }
1525 
1526     /**
1527      * @dev Returns the address of the current owner.
1528      */
1529     function owner() public view virtual returns (address) {
1530         return _owner;
1531     }
1532 
1533     /**
1534      * @dev Throws if the sender is not the owner.
1535      */
1536     function _checkOwner() internal view virtual {
1537         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1538     }
1539 
1540     /**
1541      * @dev Leaves the contract without owner. It will not be possible to call
1542      * `onlyOwner` functions anymore. Can only be called by the current owner.
1543      *
1544      * NOTE: Renouncing ownership will leave the contract without an owner,
1545      * thereby removing any functionality that is only available to the owner.
1546      */
1547     function renounceOwnership() public virtual onlyOwner {
1548         _transferOwnership(address(0));
1549     }
1550 
1551     /**
1552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1553      * Can only be called by the current owner.
1554      */
1555     function transferOwnership(address newOwner) public virtual onlyOwner {
1556         require(newOwner != address(0), "Ownable: new owner is the zero address");
1557         _transferOwnership(newOwner);
1558     }
1559 
1560     /**
1561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1562      * Internal function without access restriction.
1563      */
1564     function _transferOwnership(address newOwner) internal virtual {
1565         address oldOwner = _owner;
1566         _owner = newOwner;
1567         emit OwnershipTransferred(oldOwner, newOwner);
1568     }
1569 }
1570 
1571 // File: contracts/Perritos.sol
1572 
1573 
1574 
1575 // Amended by Achraf
1576 
1577 pragma solidity >=0.7.0 <0.9.0;
1578 
1579 
1580 
1581 
1582 
1583 contract Perritos is Ownable, ERC721A {
1584   using StringsUpgradeable for uint256;
1585 
1586   string public uriPrefix = "";
1587   string public uriSuffix = ".json";
1588   string public hiddenMetadataUri;
1589   
1590   uint256 public cost = 0.04 ether;
1591   uint256 public maxSupply = 999;
1592   uint256 public maxMintAmountPerTx = 5;
1593   uint256 public nftPerAddressLimit = 5;
1594 
1595   bool public paused = false;
1596   bool public revealed = false;
1597 
1598   bool public onlyWhitelisted = true;
1599   address[] public whitelistedAddresses;
1600   mapping(address => uint256) public addressMintedBalance;
1601 
1602   constructor() ERC721A("Perritos con Flow", "PCF")  {
1603     setHiddenMetadataUri("ipfs://bafybeiabrjaosobv36kk2iixnyaxljgmx6nb2gel644djahytcwaji6htu/hidden.json");
1604   }
1605 
1606   modifier mintCompliance(uint256 _mintAmount) {
1607     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1608     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1609     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1610     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1611     require(!paused, "The contract is paused!");
1612     if (msg.sender != owner()) {
1613         if(onlyWhitelisted == true) {
1614             require(isWhitelisted(msg.sender), "user is not whitelisted");
1615         }
1616     }
1617     _;
1618   }
1619 
1620   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1621     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1622 
1623     addressMintedBalance[msg.sender] = addressMintedBalance[msg.sender] + _mintAmount;
1624     _safeMint(msg.sender, _mintAmount);
1625   }
1626   
1627   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1628     addressMintedBalance[_receiver] = addressMintedBalance[_receiver] + _mintAmount;
1629     _safeMint(_receiver, _mintAmount);
1630   }
1631 
1632   function isWhitelisted(address _user) public view returns (bool) {
1633     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1634       if (whitelistedAddresses[i] == _user) {
1635           return true;
1636       }
1637     }
1638     return false;
1639   }
1640 
1641   function setOnlyWhitelisted(bool _state) public onlyOwner {
1642     onlyWhitelisted = _state;
1643   }
1644   
1645   function whitelistUsers(address[] calldata _users) public onlyOwner {
1646     delete whitelistedAddresses;
1647     whitelistedAddresses = _users;
1648   }
1649 
1650   function walletOfOwner(address _owner)
1651     public
1652     view
1653     returns (uint256[] memory)
1654   {
1655     uint256 ownerTokenCount = balanceOf(_owner);
1656     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1657     uint256 currentTokenId = 1;
1658     uint256 ownedTokenIndex = 0;
1659 
1660     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1661       address currentTokenOwner = ownerOf(currentTokenId);
1662 
1663       if (currentTokenOwner == _owner) {
1664         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1665 
1666         ownedTokenIndex++;
1667       }
1668 
1669       currentTokenId++;
1670     }
1671 
1672     return ownedTokenIds;
1673   }
1674 
1675   function tokenURI(uint256 _tokenId)
1676     public
1677     view
1678     virtual
1679     override
1680     returns (string memory)
1681   {
1682     require(
1683       _exists(_tokenId),
1684       "ERC721Metadata: URI query for nonexistent token"
1685     );
1686 
1687     if (revealed == false) {
1688       return hiddenMetadataUri;
1689     }
1690 
1691     string memory currentBaseURI = _baseURI();
1692     return bytes(currentBaseURI).length > 0
1693         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1694         : "";
1695   }
1696 
1697   function setRevealed(bool _state) public onlyOwner {
1698     revealed = _state;
1699   }
1700 
1701   function setCost(uint256 _cost) public onlyOwner {
1702     cost = _cost;
1703   }
1704 
1705   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1706     maxMintAmountPerTx = _maxMintAmountPerTx;
1707   }
1708 
1709   function setNftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1710     nftPerAddressLimit = _nftPerAddressLimit;
1711   }
1712 
1713   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1714     hiddenMetadataUri = _hiddenMetadataUri;
1715   }
1716 
1717   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1718     uriPrefix = _uriPrefix;
1719   }
1720 
1721   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1722     uriSuffix = _uriSuffix;
1723   }
1724 
1725   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1726     maxSupply = _maxSupply;
1727   }
1728 
1729   function setPaused(bool _state) public onlyOwner {
1730     paused = _state;
1731   }
1732 
1733   function withdraw() public onlyOwner {
1734   
1735     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1736     require(os);
1737   }
1738 
1739   function _baseURI() internal view virtual override returns (string memory) {
1740     return uriPrefix;
1741   }
1742 }