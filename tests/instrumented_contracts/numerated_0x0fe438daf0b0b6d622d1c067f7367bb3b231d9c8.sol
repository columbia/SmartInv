1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract ReentrancyGuard {
6 
7     uint256 private constant _NOT_ENTERED = 1;
8     uint256 private constant _ENTERED = 2;
9 
10     uint256 private _status;
11 
12     constructor() {
13         _status = _NOT_ENTERED;
14     }
15 
16     modifier nonReentrant() {
17         // On the first call to nonReentrant, _notEntered will be true
18         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
19 
20         // Any calls to nonReentrant after this point will fail
21         _status = _ENTERED;
22 
23         _;
24 
25         // By storing the original value once again, a refund is triggered (see
26         // https://eips.ethereum.org/EIPS/eip-2200)
27         _status = _NOT_ENTERED;
28     }
29 }
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 /**
95  * @dev Interface of an ERC721A compliant contract.
96  */
97 interface IERC721A {
98     /**
99      * The caller must own the token or be an approved operator.
100      */
101     error ApprovalCallerNotOwnerNorApproved();
102 
103     /**
104      * The token does not exist.
105      */
106     error ApprovalQueryForNonexistentToken();
107 
108     /**
109      * The caller cannot approve to their own address.
110      */
111     error ApproveToCaller();
112 
113     /**
114      * Cannot query the balance for the zero address.
115      */
116     error BalanceQueryForZeroAddress();
117 
118     /**
119      * Cannot mint to the zero address.
120      */
121     error MintToZeroAddress();
122 
123     /**
124      * The quantity of tokens minted must be more than zero.
125      */
126     error MintZeroQuantity();
127 
128     /**
129      * The token does not exist.
130      */
131     error OwnerQueryForNonexistentToken();
132 
133     /**
134      * The caller must own the token or be an approved operator.
135      */
136     error TransferCallerNotOwnerNorApproved();
137 
138     /**
139      * The token must be owned by `from`.
140      */
141     error TransferFromIncorrectOwner();
142 
143     /**
144      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
145      */
146     error TransferToNonERC721ReceiverImplementer();
147 
148     /**
149      * Cannot transfer to the zero address.
150      */
151     error TransferToZeroAddress();
152 
153     /**
154      * The token does not exist.
155      */
156     error URIQueryForNonexistentToken();
157 
158     /**
159      * The `quantity` minted with ERC2309 exceeds the safety limit.
160      */
161     error MintERC2309QuantityExceedsLimit();
162 
163     /**
164      * The `extraData` cannot be set on an unintialized ownership slot.
165      */
166     error OwnershipNotInitializedForExtraData();
167 
168     struct TokenOwnership {
169         // The address of the owner.
170         address addr;
171         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
172         uint64 startTimestamp;
173         // Whether the token has been burned.
174         bool burned;
175         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
176         uint24 extraData;
177     }
178 
179     function totalSupply() external view returns (uint256);
180 
181     function supportsInterface(bytes4 interfaceId) external view returns (bool);
182 
183     // ==============================
184     //            IERC721
185     // ==============================
186 
187     /**
188      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
194      */
195     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
196 
197     /**
198      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
199      */
200     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
201 
202     /**
203      * @dev Returns the number of tokens in ``owner``'s account.
204      */
205     function balanceOf(address owner) external view returns (uint256 balance);
206 
207     function ownerOf(uint256 tokenId) external view returns (address owner);
208 
209     function safeTransferFrom(
210         address from,
211         address to,
212         uint256 tokenId,
213         bytes calldata data
214     ) external;
215 
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222 
223     function transferFrom(
224         address from,
225         address to,
226         uint256 tokenId
227     ) external;
228 
229     function approve(address to, uint256 tokenId) external;
230 
231     function setApprovalForAll(address operator, bool _approved) external;
232 
233     function getApproved(uint256 tokenId) external view returns (address operator);
234 
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237 
238     function name() external view returns (string memory);
239 
240     /**
241      * @dev Returns the token collection symbol.
242      */
243     function symbol() external view returns (string memory);
244 
245     /**
246      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
247      */
248     function tokenURI(uint256 tokenId) external view returns (string memory);
249 
250 
251     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
252 }
253 
254 /**
255  * @dev ERC721 token receiver interface.
256  */
257 interface ERC721A__IERC721Receiver {
258     function onERC721Received(
259         address operator,
260         address from,
261         uint256 tokenId,
262         bytes calldata data
263     ) external returns (bytes4);
264 }
265 
266 
267 contract ERC721A is IERC721A {
268     // Mask of an entry in packed address data.
269     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
270 
271     // The bit position of `numberMinted` in packed address data.
272     uint256 private constant BITPOS_NUMBER_MINTED = 64;
273 
274     // The bit position of `numberBurned` in packed address data.
275     uint256 private constant BITPOS_NUMBER_BURNED = 128;
276 
277     // The bit position of `aux` in packed address data.
278     uint256 private constant BITPOS_AUX = 192;
279 
280     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
281     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
282 
283     // The bit position of `startTimestamp` in packed ownership.
284     uint256 private constant BITPOS_START_TIMESTAMP = 160;
285 
286     // The bit mask of the `burned` bit in packed ownership.
287     uint256 private constant BITMASK_BURNED = 1 << 224;
288 
289     // The bit position of the `nextInitialized` bit in packed ownership.
290     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
291 
292     // The bit mask of the `nextInitialized` bit in packed ownership.
293     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
294 
295     // The bit position of `extraData` in packed ownership.
296     uint256 private constant BITPOS_EXTRA_DATA = 232;
297 
298     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
299     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
300 
301     // The mask of the lower 160 bits for addresses.
302     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
303 
304 
305     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
306 
307     // The tokenId of the next token to be minted.
308     uint256 private _currentIndex;
309 
310     // The number of tokens burned.
311     uint256 private _burnCounter;
312 
313     // Token name
314     string private _name;
315 
316     // Token symbol
317     string private _symbol;
318 
319 
320     mapping(uint256 => uint256) private _packedOwnerships;
321 
322 
323     mapping(address => uint256) private _packedAddressData;
324 
325     // Mapping from token ID to approved address.
326     mapping(uint256 => address) private _tokenApprovals;
327 
328     // Mapping from owner to operator approvals
329     mapping(address => mapping(address => bool)) private _operatorApprovals;
330 
331     constructor(string memory name_, string memory symbol_) {
332         _name = name_;
333         _symbol = symbol_;
334         _currentIndex = _startTokenId();
335     }
336 
337     /**
338      * @dev Returns the starting token ID.
339      * To change the starting token ID, please override this function.
340      */
341     function _startTokenId() internal view virtual returns (uint256) {
342         return 0;
343     }
344 
345     /**
346      * @dev Returns the next token ID to be minted.
347      */
348     function _nextTokenId() internal view returns (uint256) {
349         return _currentIndex;
350     }
351 
352     /**
353      * @dev Returns the total number of tokens in existence.
354      * Burned tokens will reduce the count.
355      * To get the total number of tokens minted, please see `_totalMinted`.
356      */
357     function totalSupply() public view override returns (uint256) {
358         // Counter underflow is impossible as _burnCounter cannot be incremented
359         // more than `_currentIndex - _startTokenId()` times.
360         unchecked {
361             return _currentIndex - _burnCounter - _startTokenId();
362         }
363     }
364 
365     /**
366      * @dev Returns the total amount of tokens minted in the contract.
367      */
368     function _totalMinted() internal view returns (uint256) {
369         // Counter underflow is impossible as _currentIndex does not decrement,
370         // and it is initialized to `_startTokenId()`
371         unchecked {
372             return _currentIndex - _startTokenId();
373         }
374     }
375 
376     /**
377      * @dev Returns the total number of tokens burned.
378      */
379     function _totalBurned() internal view returns (uint256) {
380         return _burnCounter;
381     }
382 
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      */
386     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387         // The interface IDs are constants representing the first 4 bytes of the XOR of
388         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
389         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
390         return
391             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
392             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
393             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
394     }
395 
396     /**
397      * @dev See {IERC721-balanceOf}.
398      */
399     function balanceOf(address owner) public view override returns (uint256) {
400         if (owner == address(0)) revert BalanceQueryForZeroAddress();
401         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
402     }
403 
404     /**
405      * Returns the number of tokens minted by `owner`.
406      */
407     function _numberMinted(address owner) internal view returns (uint256) {
408         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
409     }
410 
411     /**
412      * Returns the number of tokens burned by or on behalf of `owner`.
413      */
414     function _numberBurned(address owner) internal view returns (uint256) {
415         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
416     }
417 
418     /**
419      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
420      */
421     function _getAux(address owner) internal view returns (uint64) {
422         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
423     }
424 
425     /**
426      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
427      * If there are multiple variables, please pack them into a uint64.
428      */
429     function _setAux(address owner, uint64 aux) internal {
430         uint256 packed = _packedAddressData[owner];
431         uint256 auxCasted;
432         // Cast `aux` with assembly to avoid redundant masking.
433         assembly {
434             auxCasted := aux
435         }
436         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
437         _packedAddressData[owner] = packed;
438     }
439 
440     /**
441      * Returns the packed ownership data of `tokenId`.
442      */
443     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
444         uint256 curr = tokenId;
445 
446         unchecked {
447             if (_startTokenId() <= curr)
448                 if (curr < _currentIndex) {
449                     uint256 packed = _packedOwnerships[curr];
450                     // If not burned.
451                     if (packed & BITMASK_BURNED == 0) {
452                         // Invariant:
453                         // There will always be an ownership that has an address and is not burned
454                         // before an ownership that does not have an address and is not burned.
455                         // Hence, curr will not underflow.
456                         //
457                         // We can directly compare the packed value.
458                         // If the address is zero, packed is zero.
459                         while (packed == 0) {
460                             packed = _packedOwnerships[--curr];
461                         }
462                         return packed;
463                     }
464                 }
465         }
466         revert OwnerQueryForNonexistentToken();
467     }
468 
469     /**
470      * Returns the unpacked `TokenOwnership` struct from `packed`.
471      */
472     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
473         ownership.addr = address(uint160(packed));
474         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
475         ownership.burned = packed & BITMASK_BURNED != 0;
476         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
477     }
478 
479     /**
480      * Returns the unpacked `TokenOwnership` struct at `index`.
481      */
482     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
483         return _unpackedOwnership(_packedOwnerships[index]);
484     }
485 
486     /**
487      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
488      */
489     function _initializeOwnershipAt(uint256 index) internal {
490         if (_packedOwnerships[index] == 0) {
491             _packedOwnerships[index] = _packedOwnershipOf(index);
492         }
493     }
494 
495     /**
496      * Gas spent here starts off proportional to the maximum mint batch size.
497      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
498      */
499     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
500         return _unpackedOwnership(_packedOwnershipOf(tokenId));
501     }
502 
503     /**
504      * @dev Packs ownership data into a single uint256.
505      */
506     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
507         assembly {
508             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
509             owner := and(owner, BITMASK_ADDRESS)
510             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
511             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
512         }
513     }
514 
515     /**
516      * @dev See {IERC721-ownerOf}.
517      */
518     function ownerOf(uint256 tokenId) public view override returns (address) {
519         return address(uint160(_packedOwnershipOf(tokenId)));
520     }
521 
522     /**
523      * @dev See {IERC721Metadata-name}.
524      */
525     function name() public view virtual override returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev See {IERC721Metadata-symbol}.
531      */
532     function symbol() public view virtual override returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev See {IERC721Metadata-tokenURI}.
538      */
539     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
540         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
541 
542         string memory baseURI = _baseURI();
543         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
544     }
545 
546     /**
547      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
548      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
549      * by default, it can be overridden in child contracts.
550      */
551     function _baseURI() internal view virtual returns (string memory) {
552         return '';
553     }
554 
555     /**
556      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
557      */
558     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
559         // For branchless setting of the `nextInitialized` flag.
560         assembly {
561             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
562             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
563         }
564     }
565 
566     /**
567      * @dev See {IERC721-approve}.
568      */
569     function approve(address to, uint256 tokenId) public override {
570         address owner = ownerOf(tokenId);
571 
572         if (_msgSenderERC721A() != owner)
573             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
574                 revert ApprovalCallerNotOwnerNorApproved();
575             }
576 
577         _tokenApprovals[tokenId] = to;
578         emit Approval(owner, to, tokenId);
579     }
580 
581     /**
582      * @dev See {IERC721-getApproved}.
583      */
584     function getApproved(uint256 tokenId) public view override returns (address) {
585         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
586 
587         return _tokenApprovals[tokenId];
588     }
589 
590     /**
591      * @dev See {IERC721-setApprovalForAll}.
592      */
593     function setApprovalForAll(address operator, bool approved) public virtual override {
594         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
595 
596         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
597         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
598     }
599 
600     /**
601      * @dev See {IERC721-isApprovedForAll}.
602      */
603     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
604         return _operatorApprovals[owner][operator];
605     }
606 
607     /**
608      * @dev See {IERC721-safeTransferFrom}.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) public virtual override {
615         safeTransferFrom(from, to, tokenId, '');
616     }
617 
618     /**
619      * @dev See {IERC721-safeTransferFrom}.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes memory _data
626     ) public virtual override {
627         transferFrom(from, to, tokenId);
628         if (to.code.length != 0)
629             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
630                 revert TransferToNonERC721ReceiverImplementer();
631             }
632     }
633 
634     /**
635      * @dev Returns whether `tokenId` exists.
636      *
637      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
638      *
639      * Tokens start existing when they are minted (`_mint`),
640      */
641     function _exists(uint256 tokenId) internal view returns (bool) {
642         return
643             _startTokenId() <= tokenId &&
644             tokenId < _currentIndex && // If within bounds,
645             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
646     }
647 
648     /**
649      * @dev Equivalent to `_safeMint(to, quantity, '')`.
650      */
651     function _safeMint(address to, uint256 quantity) internal {
652         _safeMint(to, quantity, '');
653     }
654 
655     /**
656      * @dev Safely mints `quantity` tokens and transfers them to `to`.
657      *
658      * Requirements:
659      *
660      * - If `to` refers to a smart contract, it must implement
661      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
662      * - `quantity` must be greater than 0.
663      *
664      * See {_mint}.
665      *
666      * Emits a {Transfer} event for each mint.
667      */
668     function _safeMint(
669         address to,
670         uint256 quantity,
671         bytes memory _data
672     ) internal {
673         _mint(to, quantity);
674 
675         unchecked {
676             if (to.code.length != 0) {
677                 uint256 end = _currentIndex;
678                 uint256 index = end - quantity;
679                 do {
680                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
681                         revert TransferToNonERC721ReceiverImplementer();
682                     }
683                 } while (index < end);
684                 // Reentrancy protection.
685                 if (_currentIndex != end) revert();
686             }
687         }
688     }
689 
690     /**
691      * @dev Mints `quantity` tokens and transfers them to `to`.
692      *
693      * Requirements:
694      *
695      * - `to` cannot be the zero address.
696      * - `quantity` must be greater than 0.
697      *
698      * Emits a {Transfer} event for each mint.
699      */
700     function _mint(address to, uint256 quantity) internal {
701         uint256 startTokenId = _currentIndex;
702         if (to == address(0)) revert MintToZeroAddress();
703         if (quantity == 0) revert MintZeroQuantity();
704 
705         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
706 
707         // Overflows are incredibly unrealistic.
708         // `balance` and `numberMinted` have a maximum limit of 2**64.
709         // `tokenId` has a maximum limit of 2**256.
710         unchecked {
711             // Updates:
712             // - `balance += quantity`.
713             // - `numberMinted += quantity`.
714             //
715             // We can directly add to the `balance` and `numberMinted`.
716             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
717 
718             // Updates:
719             // - `address` to the owner.
720             // - `startTimestamp` to the timestamp of minting.
721             // - `burned` to `false`.
722             // - `nextInitialized` to `quantity == 1`.
723             _packedOwnerships[startTokenId] = _packOwnershipData(
724                 to,
725                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
726             );
727 
728             uint256 tokenId = startTokenId;
729             uint256 end = startTokenId + quantity;
730             do {
731                 emit Transfer(address(0), to, tokenId++);
732             } while (tokenId < end);
733 
734             _currentIndex = end;
735         }
736         _afterTokenTransfers(address(0), to, startTokenId, quantity);
737     }
738 
739     /**
740      * @dev Mints `quantity` tokens and transfers them to `to`.
741      *
742      * This function is intended for efficient minting only during contract creation.
743      *
744      * It emits only one {ConsecutiveTransfer} as defined in
745      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
746      * instead of a sequence of {Transfer} event(s).
747      *
748      * Calling this function outside of contract creation WILL make your contract
749      * non-compliant with the ERC721 standard.
750      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
751      * {ConsecutiveTransfer} event is only permissible during contract creation.
752      *
753      * Requirements:
754      *
755      * - `to` cannot be the zero address.
756      * - `quantity` must be greater than 0.
757      *
758      * Emits a {ConsecutiveTransfer} event.
759      */
760     function _mintERC2309(address to, uint256 quantity) internal {
761         uint256 startTokenId = _currentIndex;
762         if (to == address(0)) revert MintToZeroAddress();
763         if (quantity == 0) revert MintZeroQuantity();
764         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
765 
766         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
767 
768         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
769         unchecked {
770             // Updates:
771             // - `balance += quantity`.
772             // - `numberMinted += quantity`.
773             //
774             // We can directly add to the `balance` and `numberMinted`.
775             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
776 
777             // Updates:
778             // - `address` to the owner.
779             // - `startTimestamp` to the timestamp of minting.
780             // - `burned` to `false`.
781             // - `nextInitialized` to `quantity == 1`.
782             _packedOwnerships[startTokenId] = _packOwnershipData(
783                 to,
784                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
785             );
786 
787             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
788 
789             _currentIndex = startTokenId + quantity;
790         }
791         _afterTokenTransfers(address(0), to, startTokenId, quantity);
792     }
793 
794     /**
795      * @dev Returns the storage slot and value for the approved address of `tokenId`.
796      */
797     function _getApprovedAddress(uint256 tokenId)
798         private
799         view
800         returns (uint256 approvedAddressSlot, address approvedAddress)
801     {
802         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
803         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
804         assembly {
805             // Compute the slot.
806             mstore(0x00, tokenId)
807             mstore(0x20, tokenApprovalsPtr.slot)
808             approvedAddressSlot := keccak256(0x00, 0x40)
809             // Load the slot's value from storage.
810             approvedAddress := sload(approvedAddressSlot)
811         }
812     }
813 
814     /**
815      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
816      */
817     function _isOwnerOrApproved(
818         address approvedAddress,
819         address from,
820         address msgSender
821     ) private pure returns (bool result) {
822         assembly {
823             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
824             from := and(from, BITMASK_ADDRESS)
825             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
826             msgSender := and(msgSender, BITMASK_ADDRESS)
827             // `msgSender == from || msgSender == approvedAddress`.
828             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
829         }
830     }
831 
832     /**
833      * @dev Transfers `tokenId` from `from` to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
848 
849         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
850 
851         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
852 
853         // The nested ifs save around 20+ gas over a compound boolean condition.
854         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
855             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
856 
857         if (to == address(0)) revert TransferToZeroAddress();
858 
859         _beforeTokenTransfers(from, to, tokenId, 1);
860 
861         // Clear approvals from the previous owner.
862         assembly {
863             if approvedAddress {
864                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
865                 sstore(approvedAddressSlot, 0)
866             }
867         }
868 
869         // Underflow of the sender's balance is impossible because we check for
870         // ownership above and the recipient's balance can't realistically overflow.
871         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
872         unchecked {
873             // We can directly increment and decrement the balances.
874             --_packedAddressData[from]; // Updates: `balance -= 1`.
875             ++_packedAddressData[to]; // Updates: `balance += 1`.
876 
877             // Updates:
878             // - `address` to the next owner.
879             // - `startTimestamp` to the timestamp of transfering.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `true`.
882             _packedOwnerships[tokenId] = _packOwnershipData(
883                 to,
884                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
885             );
886 
887             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
888             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
889                 uint256 nextTokenId = tokenId + 1;
890                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
891                 if (_packedOwnerships[nextTokenId] == 0) {
892                     // If the next slot is within bounds.
893                     if (nextTokenId != _currentIndex) {
894                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
895                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
896                     }
897                 }
898             }
899         }
900 
901         emit Transfer(from, to, tokenId);
902         _afterTokenTransfers(from, to, tokenId, 1);
903     }
904 
905     /**
906      * @dev Equivalent to `_burn(tokenId, false)`.
907      */
908     function _burn(uint256 tokenId) internal virtual {
909         _burn(tokenId, false);
910     }
911 
912     /**
913      * @dev Destroys `tokenId`.
914      * The approval is cleared when the token is burned.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
923         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
924 
925         address from = address(uint160(prevOwnershipPacked));
926 
927         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
928 
929         if (approvalCheck) {
930             // The nested ifs save around 20+ gas over a compound boolean condition.
931             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
932                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
933         }
934 
935         _beforeTokenTransfers(from, address(0), tokenId, 1);
936 
937         // Clear approvals from the previous owner.
938         assembly {
939             if approvedAddress {
940                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
941                 sstore(approvedAddressSlot, 0)
942             }
943         }
944 
945         // Underflow of the sender's balance is impossible because we check for
946         // ownership above and the recipient's balance can't realistically overflow.
947         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
948         unchecked {
949             // Updates:
950             // - `balance -= 1`.
951             // - `numberBurned += 1`.
952             //
953             // We can directly decrement the balance, and increment the number burned.
954             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
955             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
956 
957             // Updates:
958             // - `address` to the last owner.
959             // - `startTimestamp` to the timestamp of burning.
960             // - `burned` to `true`.
961             // - `nextInitialized` to `true`.
962             _packedOwnerships[tokenId] = _packOwnershipData(
963                 from,
964                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
965             );
966 
967             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
968             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
969                 uint256 nextTokenId = tokenId + 1;
970                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
971                 if (_packedOwnerships[nextTokenId] == 0) {
972                     // If the next slot is within bounds.
973                     if (nextTokenId != _currentIndex) {
974                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
975                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
976                     }
977                 }
978             }
979         }
980 
981         emit Transfer(from, address(0), tokenId);
982         _afterTokenTransfers(from, address(0), tokenId, 1);
983 
984         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
985         unchecked {
986             _burnCounter++;
987         }
988     }
989 
990     /**
991      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
992      *
993      * @param from address representing the previous owner of the given token ID
994      * @param to target address that will receive the tokens
995      * @param tokenId uint256 ID of the token to be transferred
996      * @param _data bytes optional data to send along with the call
997      * @return bool whether the call correctly returned the expected magic value
998      */
999     function _checkContractOnERC721Received(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) private returns (bool) {
1005         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1006             bytes4 retval
1007         ) {
1008             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1009         } catch (bytes memory reason) {
1010             if (reason.length == 0) {
1011                 revert TransferToNonERC721ReceiverImplementer();
1012             } else {
1013                 assembly {
1014                     revert(add(32, reason), mload(reason))
1015                 }
1016             }
1017         }
1018     }
1019 
1020     /**
1021      * @dev Directly sets the extra data for the ownership data `index`.
1022      */
1023     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1024         uint256 packed = _packedOwnerships[index];
1025         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1026         uint256 extraDataCasted;
1027         // Cast `extraData` with assembly to avoid redundant masking.
1028         assembly {
1029             extraDataCasted := extraData
1030         }
1031         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1032         _packedOwnerships[index] = packed;
1033     }
1034 
1035     /**
1036      * @dev Returns the next extra data for the packed ownership data.
1037      * The returned result is shifted into position.
1038      */
1039     function _nextExtraData(
1040         address from,
1041         address to,
1042         uint256 prevOwnershipPacked
1043     ) private view returns (uint256) {
1044         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1045         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1046     }
1047 
1048     /**
1049      * @dev Called during each token transfer to set the 24bit `extraData` field.
1050      * Intended to be overridden by the cosumer contract.
1051      *
1052      * `previousExtraData` - the value of `extraData` before transfer.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, `tokenId` will be burned by `from`.
1060      * - `from` and `to` are never both zero.
1061      */
1062     function _extraData(
1063         address from,
1064         address to,
1065         uint24 previousExtraData
1066     ) internal view virtual returns (uint24) {}
1067 
1068     /**
1069      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1070      * This includes minting.
1071      * And also called before burning one token.
1072      *
1073      * startTokenId - the first token id to be transferred
1074      * quantity - the amount to be transferred
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, `tokenId` will be burned by `from`.
1082      * - `from` and `to` are never both zero.
1083      */
1084     function _beforeTokenTransfers(
1085         address from,
1086         address to,
1087         uint256 startTokenId,
1088         uint256 quantity
1089     ) internal virtual {}
1090 
1091     /**
1092      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1093      * This includes minting.
1094      * And also called after one token has been burned.
1095      *
1096      * startTokenId - the first token id to be transferred
1097      * quantity - the amount to be transferred
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` has been minted for `to`.
1104      * - When `to` is zero, `tokenId` has been burned by `from`.
1105      * - `from` and `to` are never both zero.
1106      */
1107     function _afterTokenTransfers(
1108         address from,
1109         address to,
1110         uint256 startTokenId,
1111         uint256 quantity
1112     ) internal virtual {}
1113 
1114     /**
1115      * @dev Returns the message sender (defaults to `msg.sender`).
1116      *
1117      * If you are writing GSN compatible contracts, you need to override this function.
1118      */
1119     function _msgSenderERC721A() internal view virtual returns (address) {
1120         return msg.sender;
1121     }
1122 
1123     /**
1124      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1125      */
1126     function _toString(uint256 value) internal pure returns (string memory ptr) {
1127         assembly {
1128             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1129             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1130             // We will need 1 32-byte word to store the length,
1131             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1132             ptr := add(mload(0x40), 128)
1133             // Update the free memory pointer to allocate.
1134             mstore(0x40, ptr)
1135 
1136             // Cache the end of the memory to calculate the length later.
1137             let end := ptr
1138 
1139             // We write the string from the rightmost digit to the leftmost digit.
1140             // The following is essentially a do-while loop that also handles the zero case.
1141             // Costs a bit more than early returning for the zero case,
1142             // but cheaper in terms of deployment and overall runtime costs.
1143             for {
1144                 // Initialize and perform the first pass without check.
1145                 let temp := value
1146                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1147                 ptr := sub(ptr, 1)
1148                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1149                 mstore8(ptr, add(48, mod(temp, 10)))
1150                 temp := div(temp, 10)
1151             } temp {
1152                 // Keep dividing `temp` until zero.
1153                 temp := div(temp, 10)
1154             } {
1155                 // Body of the for loop.
1156                 ptr := sub(ptr, 1)
1157                 mstore8(ptr, add(48, mod(temp, 10)))
1158             }
1159 
1160             let length := sub(end, ptr)
1161             // Move the pointer 32 bytes leftwards to make room for the length.
1162             ptr := sub(ptr, 32)
1163             // Store the length.
1164             mstore(ptr, length)
1165         }
1166     }
1167 }
1168 
1169 /**
1170  * @dev Provides information about the current execution context, including the
1171  * sender of the transaction and its data. While these are generally available
1172  * via msg.sender and msg.data, they should not be accessed in such a direct
1173  * manner, since when dealing with meta-transactions the account sending and
1174  * paying for execution may not be the actual sender (as far as an application
1175  * is concerned).
1176  *
1177  * This contract is only required for intermediate, library-like contracts.
1178  */
1179 abstract contract Context {
1180     function _msgSender() internal view virtual returns (address) {
1181         return msg.sender;
1182     }
1183 
1184     function _msgData() internal view virtual returns (bytes calldata) {
1185         return msg.data;
1186     }
1187 }
1188 
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _transferOwnership(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _transferOwnership(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _transferOwnership(newOwner);
1234     }
1235 
1236     /**
1237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1238      * Internal function without access restriction.
1239      */
1240     function _transferOwnership(address newOwner) internal virtual {
1241         address oldOwner = _owner;
1242         _owner = newOwner;
1243         emit OwnershipTransferred(oldOwner, newOwner);
1244     }
1245 }
1246 
1247 contract SavvySeagulls is ERC721A, Ownable, ReentrancyGuard {
1248     using Strings for uint256;
1249 
1250     uint256 public price = 0.02 ether;
1251     uint256 public _maxSupply = 6969;
1252     uint256 public maxMintAmountPerTx = 10;
1253     uint256 maxMintAmountPerWallet = 10;
1254 
1255     string baseURL = "https://ipfs.io/ipfs/Qmat6M1of73j8QtU1UCAQSHApmN43A34a2v7das2Lcwo8Q/";
1256     string ExtensionURL = ".json";
1257 
1258     uint256 totalFreeSupply = 2000;
1259 
1260     bool public paused = true;
1261 
1262     constructor() ERC721A("Savvy Seagulls", "SVYSGLS") {
1263     }
1264 
1265     // ================== Mint Function =======================
1266 
1267     modifier mintComp(uint256 _mintAmount){
1268         require(!paused, "The contract is paused!");
1269         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1270         require(totalSupply() + _mintAmount <= _maxSupply, "Max supply exceeded!");
1271         require(balanceOf(_msgSender()) + _mintAmount <= maxMintAmountPerWallet, "You have 10 Seagulls.");
1272         _;
1273     }
1274 
1275     function mint(uint256 _mintAmount) public payable nonReentrant mintComp(_mintAmount){
1276         require(_msgSender() == tx.origin);    
1277         if(checkMintStage() == 1){
1278             _safeMint(_msgSender(), _mintAmount);
1279         }else{
1280             require(msg.value >= _mintAmount * price, "Insufficient payment.");
1281             _safeMint(_msgSender(), _mintAmount);
1282         }       
1283     }
1284 
1285     // =================== Orange Functions (Owner Only) ===============
1286 
1287     function pause(bool state) public onlyOwner {
1288         paused = state;
1289     }
1290 
1291     function withdraw() public onlyOwner nonReentrant{
1292         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1293         require(os);
1294     }
1295 
1296     // =================== Blue Functions (View Only) ====================
1297 
1298     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory){
1299 
1300         require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1301         
1302         string memory currentBaseURI = _baseURI();
1303         return bytes(currentBaseURI).length > 0
1304             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ExtensionURL))
1305             : '';
1306     }
1307 
1308     function _startTokenId() internal view virtual override(ERC721A) returns (uint256){
1309         return 1;
1310     }
1311 
1312     function checkMintStage() public view returns (uint8){
1313         if(totalSupply() < totalFreeSupply)
1314         {
1315             return 1;
1316         }else{
1317             return 2;
1318         }
1319     }
1320 
1321     function _baseURI() internal view virtual override returns (string memory) {
1322         return baseURL;
1323     }
1324 
1325     function maxSupply() public view returns (uint256){
1326         return _maxSupply;
1327     }
1328 }