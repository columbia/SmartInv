1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library StringsUpgradeable {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
70 }
71 
72 // File: erc721a/contracts/IERC721A.sol
73 
74 
75 // ERC721A Contracts v4.1.0
76 // Creator: Chiru Labs
77 
78 pragma solidity ^0.8.4;
79 
80 /**
81  * @dev Interface of an ERC721A compliant contract.
82  */
83 interface IERC721A {
84     /**
85      * The caller must own the token or be an approved operator.
86      */
87     error ApprovalCallerNotOwnerNorApproved();
88 
89     /**
90      * The token does not exist.
91      */
92     error ApprovalQueryForNonexistentToken();
93 
94     /**
95      * The caller cannot approve to their own address.
96      */
97     error ApproveToCaller();
98 
99     /**
100      * Cannot query the balance for the zero address.
101      */
102     error BalanceQueryForZeroAddress();
103 
104     /**
105      * Cannot mint to the zero address.
106      */
107     error MintToZeroAddress();
108 
109     /**
110      * The quantity of tokens minted must be more than zero.
111      */
112     error MintZeroQuantity();
113 
114     /**
115      * The token does not exist.
116      */
117     error OwnerQueryForNonexistentToken();
118 
119     /**
120      * The caller must own the token or be an approved operator.
121      */
122     error TransferCallerNotOwnerNorApproved();
123 
124     /**
125      * The token must be owned by `from`.
126      */
127     error TransferFromIncorrectOwner();
128 
129     /**
130      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
131      */
132     error TransferToNonERC721ReceiverImplementer();
133 
134     /**
135      * Cannot transfer to the zero address.
136      */
137     error TransferToZeroAddress();
138 
139     /**
140      * The token does not exist.
141      */
142     error URIQueryForNonexistentToken();
143 
144     /**
145      * The `quantity` minted with ERC2309 exceeds the safety limit.
146      */
147     error MintERC2309QuantityExceedsLimit();
148 
149     /**
150      * The `extraData` cannot be set on an unintialized ownership slot.
151      */
152     error OwnershipNotInitializedForExtraData();
153 
154     struct TokenOwnership {
155         // The address of the owner.
156         address addr;
157         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
158         uint64 startTimestamp;
159         // Whether the token has been burned.
160         bool burned;
161         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
162         uint24 extraData;
163     }
164 
165     /**
166      * @dev Returns the total amount of tokens stored by the contract.
167      *
168      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     // ==============================
173     //            IERC165
174     // ==============================
175 
176     /**
177      * @dev Returns true if this contract implements the interface defined by
178      * `interfaceId`. See the corresponding
179      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
180      * to learn more about how these ids are created.
181      *
182      * This function call must use less than 30 000 gas.
183      */
184     function supportsInterface(bytes4 interfaceId) external view returns (bool);
185 
186     // ==============================
187     //            IERC721
188     // ==============================
189 
190     /**
191      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
197      */
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
204 
205     /**
206      * @dev Returns the number of tokens in ``owner``'s account.
207      */
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     /**
211      * @dev Returns the owner of the `tokenId` token.
212      *
213      * Requirements:
214      *
215      * - `tokenId` must exist.
216      */
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must exist and be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
229      *
230      * Emits a {Transfer} event.
231      */
232     function safeTransferFrom(
233         address from,
234         address to,
235         uint256 tokenId,
236         bytes calldata data
237     ) external;
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
241      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
242      *
243      * Requirements:
244      *
245      * - `from` cannot be the zero address.
246      * - `to` cannot be the zero address.
247      * - `tokenId` token must exist and be owned by `from`.
248      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     /**
260      * @dev Transfers `tokenId` token from `from` to `to`.
261      *
262      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     /**
280      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
281      * The approval is cleared when the token is transferred.
282      *
283      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
284      *
285      * Requirements:
286      *
287      * - The caller must own the token or be an approved operator.
288      * - `tokenId` must exist.
289      *
290      * Emits an {Approval} event.
291      */
292     function approve(address to, uint256 tokenId) external;
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns the account approved for `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     /**
316      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
317      *
318      * See {setApprovalForAll}
319      */
320     function isApprovedForAll(address owner, address operator) external view returns (bool);
321 
322     // ==============================
323     //        IERC721Metadata
324     // ==============================
325 
326     /**
327      * @dev Returns the token collection name.
328      */
329     function name() external view returns (string memory);
330 
331     /**
332      * @dev Returns the token collection symbol.
333      */
334     function symbol() external view returns (string memory);
335 
336     /**
337      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
338      */
339     function tokenURI(uint256 tokenId) external view returns (string memory);
340 
341     // ==============================
342     //            IERC2309
343     // ==============================
344 
345     /**
346      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
347      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
348      */
349     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
350 }
351 
352 // File: erc721a/contracts/ERC721A.sol
353 
354 
355 // ERC721A Contracts v4.1.0
356 // Creator: Chiru Labs
357 
358 pragma solidity ^0.8.4;
359 
360 
361 /**
362  * @dev ERC721 token receiver interface.
363  */
364 interface ERC721A__IERC721Receiver {
365     function onERC721Received(
366         address operator,
367         address from,
368         uint256 tokenId,
369         bytes calldata data
370     ) external returns (bytes4);
371 }
372 
373 /**
374  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
375  * including the Metadata extension. Built to optimize for lower gas during batch mints.
376  *
377  * Assumes serials are sequentially minted starting at `_startTokenId()`
378  * (defaults to 0, e.g. 0, 1, 2, 3..).
379  *
380  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
381  *
382  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
383  */
384 contract ERC721A is IERC721A {
385     // Mask of an entry in packed address data.
386     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
387 
388     // The bit position of `numberMinted` in packed address data.
389     uint256 private constant BITPOS_NUMBER_MINTED = 64;
390 
391     // The bit position of `numberBurned` in packed address data.
392     uint256 private constant BITPOS_NUMBER_BURNED = 128;
393 
394     // The bit position of `aux` in packed address data.
395     uint256 private constant BITPOS_AUX = 192;
396 
397     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
398     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
399 
400     // The bit position of `startTimestamp` in packed ownership.
401     uint256 private constant BITPOS_START_TIMESTAMP = 160;
402 
403     // The bit mask of the `burned` bit in packed ownership.
404     uint256 private constant BITMASK_BURNED = 1 << 224;
405 
406     // The bit position of the `nextInitialized` bit in packed ownership.
407     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
408 
409     // The bit mask of the `nextInitialized` bit in packed ownership.
410     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
411 
412     // The bit position of `extraData` in packed ownership.
413     uint256 private constant BITPOS_EXTRA_DATA = 232;
414 
415     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
416     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
417 
418     // The mask of the lower 160 bits for addresses.
419     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
420 
421     // The maximum `quantity` that can be minted with `_mintERC2309`.
422     // This limit is to prevent overflows on the address data entries.
423     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
424     // is required to cause an overflow, which is unrealistic.
425     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
426 
427     // The tokenId of the next token to be minted.
428     uint256 private _currentIndex;
429 
430     // The number of tokens burned.
431     uint256 private _burnCounter;
432 
433     // Token name
434     string private _name;
435 
436     // Token symbol
437     string private _symbol;
438 
439     // Mapping from token ID to ownership details
440     // An empty struct value does not necessarily mean the token is unowned.
441     // See `_packedOwnershipOf` implementation for details.
442     //
443     // Bits Layout:
444     // - [0..159]   `addr`
445     // - [160..223] `startTimestamp`
446     // - [224]      `burned`
447     // - [225]      `nextInitialized`
448     // - [232..255] `extraData`
449     mapping(uint256 => uint256) private _packedOwnerships;
450 
451     // Mapping owner address to address data.
452     //
453     // Bits Layout:
454     // - [0..63]    `balance`
455     // - [64..127]  `numberMinted`
456     // - [128..191] `numberBurned`
457     // - [192..255] `aux`
458     mapping(address => uint256) private _packedAddressData;
459 
460     // Mapping from token ID to approved address.
461     mapping(uint256 => address) private _tokenApprovals;
462 
463     // Mapping from owner to operator approvals
464     mapping(address => mapping(address => bool)) private _operatorApprovals;
465 
466     constructor(string memory name_, string memory symbol_) {
467         _name = name_;
468         _symbol = symbol_;
469         _currentIndex = _startTokenId();
470     }
471 
472     /**
473      * @dev Returns the starting token ID.
474      * To change the starting token ID, please override this function.
475      */
476     function _startTokenId() internal view virtual returns (uint256) {
477         return 0;
478     }
479 
480     /**
481      * @dev Returns the next token ID to be minted.
482      */
483     function _nextTokenId() internal view returns (uint256) {
484         return _currentIndex;
485     }
486 
487     /**
488      * @dev Returns the total number of tokens in existence.
489      * Burned tokens will reduce the count.
490      * To get the total number of tokens minted, please see `_totalMinted`.
491      */
492     function totalSupply() public view override returns (uint256) {
493         // Counter underflow is impossible as _burnCounter cannot be incremented
494         // more than `_currentIndex - _startTokenId()` times.
495         unchecked {
496             return _currentIndex - _burnCounter - _startTokenId();
497         }
498     }
499 
500     /**
501      * @dev Returns the total amount of tokens minted in the contract.
502      */
503     function _totalMinted() internal view returns (uint256) {
504         // Counter underflow is impossible as _currentIndex does not decrement,
505         // and it is initialized to `_startTokenId()`
506         unchecked {
507             return _currentIndex - _startTokenId();
508         }
509     }
510 
511     /**
512      * @dev Returns the total number of tokens burned.
513      */
514     function _totalBurned() internal view returns (uint256) {
515         return _burnCounter;
516     }
517 
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         // The interface IDs are constants representing the first 4 bytes of the XOR of
523         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
524         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
525         return
526             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
527             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
528             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
529     }
530 
531     /**
532      * @dev See {IERC721-balanceOf}.
533      */
534     function balanceOf(address owner) public view override returns (uint256) {
535         if (owner == address(0)) revert BalanceQueryForZeroAddress();
536         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens minted by `owner`.
541      */
542     function _numberMinted(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the number of tokens burned by or on behalf of `owner`.
548      */
549     function _numberBurned(address owner) internal view returns (uint256) {
550         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
551     }
552 
553     /**
554      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
555      */
556     function _getAux(address owner) internal view returns (uint64) {
557         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
558     }
559 
560     /**
561      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
562      * If there are multiple variables, please pack them into a uint64.
563      */
564     function _setAux(address owner, uint64 aux) internal {
565         uint256 packed = _packedAddressData[owner];
566         uint256 auxCasted;
567         // Cast `aux` with assembly to avoid redundant masking.
568         assembly {
569             auxCasted := aux
570         }
571         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
572         _packedAddressData[owner] = packed;
573     }
574 
575     /**
576      * Returns the packed ownership data of `tokenId`.
577      */
578     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
579         uint256 curr = tokenId;
580 
581         unchecked {
582             if (_startTokenId() <= curr)
583                 if (curr < _currentIndex) {
584                     uint256 packed = _packedOwnerships[curr];
585                     // If not burned.
586                     if (packed & BITMASK_BURNED == 0) {
587                         // Invariant:
588                         // There will always be an ownership that has an address and is not burned
589                         // before an ownership that does not have an address and is not burned.
590                         // Hence, curr will not underflow.
591                         //
592                         // We can directly compare the packed value.
593                         // If the address is zero, packed is zero.
594                         while (packed == 0) {
595                             packed = _packedOwnerships[--curr];
596                         }
597                         return packed;
598                     }
599                 }
600         }
601         revert OwnerQueryForNonexistentToken();
602     }
603 
604     /**
605      * Returns the unpacked `TokenOwnership` struct from `packed`.
606      */
607     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
608         ownership.addr = address(uint160(packed));
609         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
610         ownership.burned = packed & BITMASK_BURNED != 0;
611         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
612     }
613 
614     /**
615      * Returns the unpacked `TokenOwnership` struct at `index`.
616      */
617     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnerships[index]);
619     }
620 
621     /**
622      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
623      */
624     function _initializeOwnershipAt(uint256 index) internal {
625         if (_packedOwnerships[index] == 0) {
626             _packedOwnerships[index] = _packedOwnershipOf(index);
627         }
628     }
629 
630     /**
631      * Gas spent here starts off proportional to the maximum mint batch size.
632      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
633      */
634     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
635         return _unpackedOwnership(_packedOwnershipOf(tokenId));
636     }
637 
638     /**
639      * @dev Packs ownership data into a single uint256.
640      */
641     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
642         assembly {
643             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
644             owner := and(owner, BITMASK_ADDRESS)
645             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
646             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
647         }
648     }
649 
650     /**
651      * @dev See {IERC721-ownerOf}.
652      */
653     function ownerOf(uint256 tokenId) public view override returns (address) {
654         return address(uint160(_packedOwnershipOf(tokenId)));
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, it can be overridden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return '';
688     }
689 
690     /**
691      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
692      */
693     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
694         // For branchless setting of the `nextInitialized` flag.
695         assembly {
696             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
697             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
698         }
699     }
700 
701     /**
702      * @dev See {IERC721-approve}.
703      */
704     function approve(address to, uint256 tokenId) public override {
705         address owner = ownerOf(tokenId);
706 
707         if (_msgSenderERC721A() != owner)
708             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
709                 revert ApprovalCallerNotOwnerNorApproved();
710             }
711 
712         _tokenApprovals[tokenId] = to;
713         emit Approval(owner, to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-getApproved}.
718      */
719     function getApproved(uint256 tokenId) public view override returns (address) {
720         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
721 
722         return _tokenApprovals[tokenId];
723     }
724 
725     /**
726      * @dev See {IERC721-setApprovalForAll}.
727      */
728     function setApprovalForAll(address operator, bool approved) public virtual override {
729         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
730 
731         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
732         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
733     }
734 
735     /**
736      * @dev See {IERC721-isApprovedForAll}.
737      */
738     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
739         return _operatorApprovals[owner][operator];
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, '');
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         transferFrom(from, to, tokenId);
763         if (to.code.length != 0)
764             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
765                 revert TransferToNonERC721ReceiverImplementer();
766             }
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         return
778             _startTokenId() <= tokenId &&
779             tokenId < _currentIndex && // If within bounds,
780             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
781     }
782 
783     /**
784      * @dev Equivalent to `_safeMint(to, quantity, '')`.
785      */
786     function _safeMint(address to, uint256 quantity) internal {
787         _safeMint(to, quantity, '');
788     }
789 
790     /**
791      * @dev Safely mints `quantity` tokens and transfers them to `to`.
792      *
793      * Requirements:
794      *
795      * - If `to` refers to a smart contract, it must implement
796      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
797      * - `quantity` must be greater than 0.
798      *
799      * See {_mint}.
800      *
801      * Emits a {Transfer} event for each mint.
802      */
803     function _safeMint(
804         address to,
805         uint256 quantity,
806         bytes memory _data
807     ) internal {
808         _mint(to, quantity);
809 
810         unchecked {
811             if (to.code.length != 0) {
812                 uint256 end = _currentIndex;
813                 uint256 index = end - quantity;
814                 do {
815                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
816                         revert TransferToNonERC721ReceiverImplementer();
817                     }
818                 } while (index < end);
819                 // Reentrancy protection.
820                 if (_currentIndex != end) revert();
821             }
822         }
823     }
824 
825     /**
826      * @dev Mints `quantity` tokens and transfers them to `to`.
827      *
828      * Requirements:
829      *
830      * - `to` cannot be the zero address.
831      * - `quantity` must be greater than 0.
832      *
833      * Emits a {Transfer} event for each mint.
834      */
835     function _mint(address to, uint256 quantity) internal {
836         uint256 startTokenId = _currentIndex;
837         if (to == address(0)) revert MintToZeroAddress();
838         if (quantity == 0) revert MintZeroQuantity();
839 
840         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
841 
842         // Overflows are incredibly unrealistic.
843         // `balance` and `numberMinted` have a maximum limit of 2**64.
844         // `tokenId` has a maximum limit of 2**256.
845         unchecked {
846             // Updates:
847             // - `balance += quantity`.
848             // - `numberMinted += quantity`.
849             //
850             // We can directly add to the `balance` and `numberMinted`.
851             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
852 
853             // Updates:
854             // - `address` to the owner.
855             // - `startTimestamp` to the timestamp of minting.
856             // - `burned` to `false`.
857             // - `nextInitialized` to `quantity == 1`.
858             _packedOwnerships[startTokenId] = _packOwnershipData(
859                 to,
860                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
861             );
862 
863             uint256 tokenId = startTokenId;
864             uint256 end = startTokenId + quantity;
865             do {
866                 emit Transfer(address(0), to, tokenId++);
867             } while (tokenId < end);
868 
869             _currentIndex = end;
870         }
871         _afterTokenTransfers(address(0), to, startTokenId, quantity);
872     }
873 
874     /**
875      * @dev Mints `quantity` tokens and transfers them to `to`.
876      *
877      * This function is intended for efficient minting only during contract creation.
878      *
879      * It emits only one {ConsecutiveTransfer} as defined in
880      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
881      * instead of a sequence of {Transfer} event(s).
882      *
883      * Calling this function outside of contract creation WILL make your contract
884      * non-compliant with the ERC721 standard.
885      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
886      * {ConsecutiveTransfer} event is only permissible during contract creation.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - `quantity` must be greater than 0.
892      *
893      * Emits a {ConsecutiveTransfer} event.
894      */
895     function _mintERC2309(address to, uint256 quantity) internal {
896         uint256 startTokenId = _currentIndex;
897         if (to == address(0)) revert MintToZeroAddress();
898         if (quantity == 0) revert MintZeroQuantity();
899         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
900 
901         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
902 
903         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
904         unchecked {
905             // Updates:
906             // - `balance += quantity`.
907             // - `numberMinted += quantity`.
908             //
909             // We can directly add to the `balance` and `numberMinted`.
910             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
911 
912             // Updates:
913             // - `address` to the owner.
914             // - `startTimestamp` to the timestamp of minting.
915             // - `burned` to `false`.
916             // - `nextInitialized` to `quantity == 1`.
917             _packedOwnerships[startTokenId] = _packOwnershipData(
918                 to,
919                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
920             );
921 
922             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
923 
924             _currentIndex = startTokenId + quantity;
925         }
926         _afterTokenTransfers(address(0), to, startTokenId, quantity);
927     }
928 
929     /**
930      * @dev Returns the storage slot and value for the approved address of `tokenId`.
931      */
932     function _getApprovedAddress(uint256 tokenId)
933         private
934         view
935         returns (uint256 approvedAddressSlot, address approvedAddress)
936     {
937         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
938         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
939         assembly {
940             // Compute the slot.
941             mstore(0x00, tokenId)
942             mstore(0x20, tokenApprovalsPtr.slot)
943             approvedAddressSlot := keccak256(0x00, 0x40)
944             // Load the slot's value from storage.
945             approvedAddress := sload(approvedAddressSlot)
946         }
947     }
948 
949     /**
950      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
951      */
952     function _isOwnerOrApproved(
953         address approvedAddress,
954         address from,
955         address msgSender
956     ) private pure returns (bool result) {
957         assembly {
958             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
959             from := and(from, BITMASK_ADDRESS)
960             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
961             msgSender := and(msgSender, BITMASK_ADDRESS)
962             // `msgSender == from || msgSender == approvedAddress`.
963             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
964         }
965     }
966 
967     /**
968      * @dev Transfers `tokenId` from `from` to `to`.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `tokenId` token must be owned by `from`.
974      *
975      * Emits a {Transfer} event.
976      */
977     function transferFrom(
978         address from,
979         address to,
980         uint256 tokenId
981     ) public virtual override {
982         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
983 
984         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
985 
986         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
987 
988         // The nested ifs save around 20+ gas over a compound boolean condition.
989         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
990             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
991 
992         if (to == address(0)) revert TransferToZeroAddress();
993 
994         _beforeTokenTransfers(from, to, tokenId, 1);
995 
996         // Clear approvals from the previous owner.
997         assembly {
998             if approvedAddress {
999                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1000                 sstore(approvedAddressSlot, 0)
1001             }
1002         }
1003 
1004         // Underflow of the sender's balance is impossible because we check for
1005         // ownership above and the recipient's balance can't realistically overflow.
1006         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1007         unchecked {
1008             // We can directly increment and decrement the balances.
1009             --_packedAddressData[from]; // Updates: `balance -= 1`.
1010             ++_packedAddressData[to]; // Updates: `balance += 1`.
1011 
1012             // Updates:
1013             // - `address` to the next owner.
1014             // - `startTimestamp` to the timestamp of transfering.
1015             // - `burned` to `false`.
1016             // - `nextInitialized` to `true`.
1017             _packedOwnerships[tokenId] = _packOwnershipData(
1018                 to,
1019                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1020             );
1021 
1022             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1023             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1024                 uint256 nextTokenId = tokenId + 1;
1025                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1026                 if (_packedOwnerships[nextTokenId] == 0) {
1027                     // If the next slot is within bounds.
1028                     if (nextTokenId != _currentIndex) {
1029                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1030                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1031                     }
1032                 }
1033             }
1034         }
1035 
1036         emit Transfer(from, to, tokenId);
1037         _afterTokenTransfers(from, to, tokenId, 1);
1038     }
1039 
1040     /**
1041      * @dev Equivalent to `_burn(tokenId, false)`.
1042      */
1043     function _burn(uint256 tokenId) internal virtual {
1044         _burn(tokenId, false);
1045     }
1046 
1047     /**
1048      * @dev Destroys `tokenId`.
1049      * The approval is cleared when the token is burned.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1058         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1059 
1060         address from = address(uint160(prevOwnershipPacked));
1061 
1062         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1063 
1064         if (approvalCheck) {
1065             // The nested ifs save around 20+ gas over a compound boolean condition.
1066             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1067                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1068         }
1069 
1070         _beforeTokenTransfers(from, address(0), tokenId, 1);
1071 
1072         // Clear approvals from the previous owner.
1073         assembly {
1074             if approvedAddress {
1075                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1076                 sstore(approvedAddressSlot, 0)
1077             }
1078         }
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1083         unchecked {
1084             // Updates:
1085             // - `balance -= 1`.
1086             // - `numberBurned += 1`.
1087             //
1088             // We can directly decrement the balance, and increment the number burned.
1089             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1090             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1091 
1092             // Updates:
1093             // - `address` to the last owner.
1094             // - `startTimestamp` to the timestamp of burning.
1095             // - `burned` to `true`.
1096             // - `nextInitialized` to `true`.
1097             _packedOwnerships[tokenId] = _packOwnershipData(
1098                 from,
1099                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1100             );
1101 
1102             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1103             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1104                 uint256 nextTokenId = tokenId + 1;
1105                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1106                 if (_packedOwnerships[nextTokenId] == 0) {
1107                     // If the next slot is within bounds.
1108                     if (nextTokenId != _currentIndex) {
1109                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1110                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1111                     }
1112                 }
1113             }
1114         }
1115 
1116         emit Transfer(from, address(0), tokenId);
1117         _afterTokenTransfers(from, address(0), tokenId, 1);
1118 
1119         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1120         unchecked {
1121             _burnCounter++;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1127      *
1128      * @param from address representing the previous owner of the given token ID
1129      * @param to target address that will receive the tokens
1130      * @param tokenId uint256 ID of the token to be transferred
1131      * @param _data bytes optional data to send along with the call
1132      * @return bool whether the call correctly returned the expected magic value
1133      */
1134     function _checkContractOnERC721Received(
1135         address from,
1136         address to,
1137         uint256 tokenId,
1138         bytes memory _data
1139     ) private returns (bool) {
1140         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1141             bytes4 retval
1142         ) {
1143             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1144         } catch (bytes memory reason) {
1145             if (reason.length == 0) {
1146                 revert TransferToNonERC721ReceiverImplementer();
1147             } else {
1148                 assembly {
1149                     revert(add(32, reason), mload(reason))
1150                 }
1151             }
1152         }
1153     }
1154 
1155     /**
1156      * @dev Directly sets the extra data for the ownership data `index`.
1157      */
1158     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1159         uint256 packed = _packedOwnerships[index];
1160         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1161         uint256 extraDataCasted;
1162         // Cast `extraData` with assembly to avoid redundant masking.
1163         assembly {
1164             extraDataCasted := extraData
1165         }
1166         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1167         _packedOwnerships[index] = packed;
1168     }
1169 
1170     /**
1171      * @dev Returns the next extra data for the packed ownership data.
1172      * The returned result is shifted into position.
1173      */
1174     function _nextExtraData(
1175         address from,
1176         address to,
1177         uint256 prevOwnershipPacked
1178     ) private view returns (uint256) {
1179         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1180         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1181     }
1182 
1183     /**
1184      * @dev Called during each token transfer to set the 24bit `extraData` field.
1185      * Intended to be overridden by the cosumer contract.
1186      *
1187      * `previousExtraData` - the value of `extraData` before transfer.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, `tokenId` will be burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _extraData(
1198         address from,
1199         address to,
1200         uint24 previousExtraData
1201     ) internal view virtual returns (uint24) {}
1202 
1203     /**
1204      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1205      * This includes minting.
1206      * And also called before burning one token.
1207      *
1208      * startTokenId - the first token id to be transferred
1209      * quantity - the amount to be transferred
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` will be minted for `to`.
1216      * - When `to` is zero, `tokenId` will be burned by `from`.
1217      * - `from` and `to` are never both zero.
1218      */
1219     function _beforeTokenTransfers(
1220         address from,
1221         address to,
1222         uint256 startTokenId,
1223         uint256 quantity
1224     ) internal virtual {}
1225 
1226     /**
1227      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1228      * This includes minting.
1229      * And also called after one token has been burned.
1230      *
1231      * startTokenId - the first token id to be transferred
1232      * quantity - the amount to be transferred
1233      *
1234      * Calling conditions:
1235      *
1236      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1237      * transferred to `to`.
1238      * - When `from` is zero, `tokenId` has been minted for `to`.
1239      * - When `to` is zero, `tokenId` has been burned by `from`.
1240      * - `from` and `to` are never both zero.
1241      */
1242     function _afterTokenTransfers(
1243         address from,
1244         address to,
1245         uint256 startTokenId,
1246         uint256 quantity
1247     ) internal virtual {}
1248 
1249     /**
1250      * @dev Returns the message sender (defaults to `msg.sender`).
1251      *
1252      * If you are writing GSN compatible contracts, you need to override this function.
1253      */
1254     function _msgSenderERC721A() internal view virtual returns (address) {
1255         return msg.sender;
1256     }
1257 
1258     /**
1259      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1260      */
1261     function _toString(uint256 value) internal pure returns (string memory ptr) {
1262         assembly {
1263             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1264             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1265             // We will need 1 32-byte word to store the length,
1266             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1267             ptr := add(mload(0x40), 128)
1268             // Update the free memory pointer to allocate.
1269             mstore(0x40, ptr)
1270 
1271             // Cache the end of the memory to calculate the length later.
1272             let end := ptr
1273 
1274             // We write the string from the rightmost digit to the leftmost digit.
1275             // The following is essentially a do-while loop that also handles the zero case.
1276             // Costs a bit more than early returning for the zero case,
1277             // but cheaper in terms of deployment and overall runtime costs.
1278             for {
1279                 // Initialize and perform the first pass without check.
1280                 let temp := value
1281                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1282                 ptr := sub(ptr, 1)
1283                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1284                 mstore8(ptr, add(48, mod(temp, 10)))
1285                 temp := div(temp, 10)
1286             } temp {
1287                 // Keep dividing `temp` until zero.
1288                 temp := div(temp, 10)
1289             } {
1290                 // Body of the for loop.
1291                 ptr := sub(ptr, 1)
1292                 mstore8(ptr, add(48, mod(temp, 10)))
1293             }
1294 
1295             let length := sub(end, ptr)
1296             // Move the pointer 32 bytes leftwards to make room for the length.
1297             ptr := sub(ptr, 32)
1298             // Store the length.
1299             mstore(ptr, length)
1300         }
1301     }
1302 }
1303 
1304 // File: @openzeppelin/contracts/utils/Context.sol
1305 
1306 
1307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 /**
1312  * @dev Provides information about the current execution context, including the
1313  * sender of the transaction and its data. While these are generally available
1314  * via msg.sender and msg.data, they should not be accessed in such a direct
1315  * manner, since when dealing with meta-transactions the account sending and
1316  * paying for execution may not be the actual sender (as far as an application
1317  * is concerned).
1318  *
1319  * This contract is only required for intermediate, library-like contracts.
1320  */
1321 abstract contract Context {
1322     function _msgSender() internal view virtual returns (address) {
1323         return msg.sender;
1324     }
1325 
1326     function _msgData() internal view virtual returns (bytes calldata) {
1327         return msg.data;
1328     }
1329 }
1330 
1331 // File: @openzeppelin/contracts/access/Ownable.sol
1332 
1333 
1334 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1355 
1356     /**
1357      * @dev Initializes the contract setting the deployer as the initial owner.
1358      */
1359     constructor() {
1360         _transferOwnership(_msgSender());
1361     }
1362 
1363     /**
1364      * @dev Returns the address of the current owner.
1365      */
1366     function owner() public view virtual returns (address) {
1367         return _owner;
1368     }
1369 
1370     /**
1371      * @dev Throws if called by any account other than the owner.
1372      */
1373     modifier onlyOwner() {
1374         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1375         _;
1376     }
1377 
1378     /**
1379      * @dev Leaves the contract without owner. It will not be possible to call
1380      * `onlyOwner` functions anymore. Can only be called by the current owner.
1381      *
1382      * NOTE: Renouncing ownership will leave the contract without an owner,
1383      * thereby removing any functionality that is only available to the owner.
1384      */
1385     function renounceOwnership() public virtual onlyOwner {
1386         _transferOwnership(address(0));
1387     }
1388 
1389     /**
1390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1391      * Can only be called by the current owner.
1392      */
1393     function transferOwnership(address newOwner) public virtual onlyOwner {
1394         require(newOwner != address(0), "Ownable: new owner is the zero address");
1395         _transferOwnership(newOwner);
1396     }
1397 
1398     /**
1399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1400      * Internal function without access restriction.
1401      */
1402     function _transferOwnership(address newOwner) internal virtual {
1403         address oldOwner = _owner;
1404         _owner = newOwner;
1405         emit OwnershipTransferred(oldOwner, newOwner);
1406     }
1407 }
1408 
1409 // File: contracts/ShitCats.sol
1410 
1411 
1412 
1413 // By Abdrahman
1414 
1415 pragma solidity >=0.7.0 <0.9.0;
1416 
1417 
1418 
1419 
1420 contract ShitCats is Ownable, ERC721A {
1421   using StringsUpgradeable for uint256;
1422 
1423   string public uriPrefix = "";
1424   string public uriSuffix = ".json";
1425   string public hiddenMetadataUri;
1426   
1427   uint256 public cost = 0.01 ether;
1428   uint256 public maxSupply = 6000;
1429   uint256 public maxMintAmountPerTx = 6;
1430 
1431   bool public paused = false;
1432   bool public revealed = true;
1433 
1434   constructor() ERC721A("ShitCats", "SCAT")  {
1435     setHiddenMetadataUri("");
1436   }
1437 
1438   modifier mintCompliance(uint256 _mintAmount) {
1439     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1440     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1441     require(!paused, "The contract is paused!");
1442     _;
1443   }
1444 
1445   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1446     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1447 
1448     _safeMint(msg.sender, _mintAmount);
1449   }
1450   
1451   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1452     _safeMint(_receiver, _mintAmount);
1453   }
1454 
1455   function walletOfOwner(address _owner)
1456     public
1457     view
1458     returns (uint256[] memory)
1459   {
1460     uint256 ownerTokenCount = balanceOf(_owner);
1461     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1462     uint256 currentTokenId = 1;
1463     uint256 ownedTokenIndex = 0;
1464 
1465     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1466       address currentTokenOwner = ownerOf(currentTokenId);
1467 
1468       if (currentTokenOwner == _owner) {
1469         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1470 
1471         ownedTokenIndex++;
1472       }
1473 
1474       currentTokenId++;
1475     }
1476 
1477     return ownedTokenIds;
1478   }
1479 
1480   function tokenURI(uint256 _tokenId)
1481     public
1482     view
1483     virtual
1484     override
1485     returns (string memory)
1486   {
1487     require(
1488       _exists(_tokenId),
1489       "ERC721Metadata: URI query for nonexistent token"
1490     );
1491 
1492     if (revealed == false) {
1493       return hiddenMetadataUri;
1494     }
1495 
1496     string memory currentBaseURI = _baseURI();
1497     return bytes(currentBaseURI).length > 0
1498         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1499         : "";
1500   }
1501 
1502   function setRevealed(bool _state) public onlyOwner {
1503     revealed = _state;
1504   }
1505 
1506   function setCost(uint256 _cost) public onlyOwner {
1507     cost = _cost;
1508   }
1509 
1510   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1511     maxMintAmountPerTx = _maxMintAmountPerTx;
1512   }
1513 
1514   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1515     hiddenMetadataUri = _hiddenMetadataUri;
1516   }
1517 
1518   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1519     uriPrefix = _uriPrefix;
1520   }
1521 
1522   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1523     uriSuffix = _uriSuffix;
1524   }
1525 
1526   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1527     maxSupply = _maxSupply;
1528   }
1529 
1530   function setPaused(bool _state) public onlyOwner {
1531     paused = _state;
1532   }
1533 
1534   function withdraw() public onlyOwner {
1535     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1536     require(os);
1537   }
1538 
1539   function _baseURI() internal view virtual override returns (string memory) {
1540     return uriPrefix;
1541   }
1542 }