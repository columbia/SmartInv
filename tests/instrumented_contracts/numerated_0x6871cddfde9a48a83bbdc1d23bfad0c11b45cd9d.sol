1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
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
75 // ERC721A Contracts v4.0.0
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
100      * The caller cannot approve to the current owner.
101      */
102     error ApprovalToCurrentOwner();
103 
104     /**
105      * Cannot query the balance for the zero address.
106      */
107     error BalanceQueryForZeroAddress();
108 
109     /**
110      * Cannot mint to the zero address.
111      */
112     error MintToZeroAddress();
113 
114     /**
115      * The quantity of tokens minted must be more than zero.
116      */
117     error MintZeroQuantity();
118 
119     /**
120      * The token does not exist.
121      */
122     error OwnerQueryForNonexistentToken();
123 
124     /**
125      * The caller must own the token or be an approved operator.
126      */
127     error TransferCallerNotOwnerNorApproved();
128 
129     /**
130      * The token must be owned by `from`.
131      */
132     error TransferFromIncorrectOwner();
133 
134     /**
135      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
149     struct TokenOwnership {
150         // The address of the owner.
151         address addr;
152         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
153         uint64 startTimestamp;
154         // Whether the token has been burned.
155         bool burned;
156     }
157 
158     /**
159      * @dev Returns the total amount of tokens stored by the contract.
160      *
161      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     // ==============================
166     //            IERC165
167     // ==============================
168 
169     /**
170      * @dev Returns true if this contract implements the interface defined by
171      * `interfaceId`. See the corresponding
172      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
173      * to learn more about how these ids are created.
174      *
175      * This function call must use less than 30 000 gas.
176      */
177     function supportsInterface(bytes4 interfaceId) external view returns (bool);
178 
179     // ==============================
180     //            IERC721
181     // ==============================
182 
183     /**
184      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
187 
188     /**
189      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
190      */
191     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
192 
193     /**
194      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
195      */
196     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
197 
198     /**
199      * @dev Returns the number of tokens in ``owner``'s account.
200      */
201     function balanceOf(address owner) external view returns (uint256 balance);
202 
203     /**
204      * @dev Returns the owner of the `tokenId` token.
205      *
206      * Requirements:
207      *
208      * - `tokenId` must exist.
209      */
210     function ownerOf(uint256 tokenId) external view returns (address owner);
211 
212     /**
213      * @dev Safely transfers `tokenId` token from `from` to `to`.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must exist and be owned by `from`.
220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
222      *
223      * Emits a {Transfer} event.
224      */
225     function safeTransferFrom(
226         address from,
227         address to,
228         uint256 tokenId,
229         bytes calldata data
230     ) external;
231 
232     /**
233      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
234      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must exist and be owned by `from`.
241      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
243      *
244      * Emits a {Transfer} event.
245      */
246     function safeTransferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251 
252     /**
253      * @dev Transfers `tokenId` token from `from` to `to`.
254      *
255      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) external;
271 
272     /**
273      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
274      * The approval is cleared when the token is transferred.
275      *
276      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
277      *
278      * Requirements:
279      *
280      * - The caller must own the token or be an approved operator.
281      * - `tokenId` must exist.
282      *
283      * Emits an {Approval} event.
284      */
285     function approve(address to, uint256 tokenId) external;
286 
287     /**
288      * @dev Approve or remove `operator` as an operator for the caller.
289      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
290      *
291      * Requirements:
292      *
293      * - The `operator` cannot be the caller.
294      *
295      * Emits an {ApprovalForAll} event.
296      */
297     function setApprovalForAll(address operator, bool _approved) external;
298 
299     /**
300      * @dev Returns the account approved for `tokenId` token.
301      *
302      * Requirements:
303      *
304      * - `tokenId` must exist.
305      */
306     function getApproved(uint256 tokenId) external view returns (address operator);
307 
308     /**
309      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
310      *
311      * See {setApprovalForAll}
312      */
313     function isApprovedForAll(address owner, address operator) external view returns (bool);
314 
315     // ==============================
316     //        IERC721Metadata
317     // ==============================
318 
319     /**
320      * @dev Returns the token collection name.
321      */
322     function name() external view returns (string memory);
323 
324     /**
325      * @dev Returns the token collection symbol.
326      */
327     function symbol() external view returns (string memory);
328 
329     /**
330      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
331      */
332     function tokenURI(uint256 tokenId) external view returns (string memory);
333 }
334 
335 // File: erc721a/contracts/ERC721A.sol
336 
337 
338 // ERC721A Contracts v4.0.0
339 // Creator: Chiru Labs
340 
341 pragma solidity ^0.8.4;
342 
343 
344 /**
345  * @dev ERC721 token receiver interface.
346  */
347 interface ERC721A__IERC721Receiver {
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 /**
357  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
358  * the Metadata extension. Built to optimize for lower gas during batch mints.
359  *
360  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
361  *
362  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
363  *
364  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
365  */
366 contract ERC721A is IERC721A {
367     // Mask of an entry in packed address data.
368     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
369 
370     // The bit position of `numberMinted` in packed address data.
371     uint256 private constant BITPOS_NUMBER_MINTED = 64;
372 
373     // The bit position of `numberBurned` in packed address data.
374     uint256 private constant BITPOS_NUMBER_BURNED = 128;
375 
376     // The bit position of `aux` in packed address data.
377     uint256 private constant BITPOS_AUX = 192;
378 
379     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
380     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
381 
382     // The bit position of `startTimestamp` in packed ownership.
383     uint256 private constant BITPOS_START_TIMESTAMP = 160;
384 
385     // The bit mask of the `burned` bit in packed ownership.
386     uint256 private constant BITMASK_BURNED = 1 << 224;
387     
388     // The bit position of the `nextInitialized` bit in packed ownership.
389     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
390 
391     // The bit mask of the `nextInitialized` bit in packed ownership.
392     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
393 
394     // The tokenId of the next token to be minted.
395     uint256 private _currentIndex;
396 
397     // The number of tokens burned.
398     uint256 private _burnCounter;
399 
400     // Token name
401     string private _name;
402 
403     // Token symbol
404     string private _symbol;
405 
406     // Mapping from token ID to ownership details
407     // An empty struct value does not necessarily mean the token is unowned.
408     // See `_packedOwnershipOf` implementation for details.
409     //
410     // Bits Layout:
411     // - [0..159]   `addr`
412     // - [160..223] `startTimestamp`
413     // - [224]      `burned`
414     // - [225]      `nextInitialized`
415     mapping(uint256 => uint256) private _packedOwnerships;
416 
417     // Mapping owner address to address data.
418     //
419     // Bits Layout:
420     // - [0..63]    `balance`
421     // - [64..127]  `numberMinted`
422     // - [128..191] `numberBurned`
423     // - [192..255] `aux`
424     mapping(address => uint256) private _packedAddressData;
425 
426     // Mapping from token ID to approved address.
427     mapping(uint256 => address) private _tokenApprovals;
428 
429     // Mapping from owner to operator approvals
430     mapping(address => mapping(address => bool)) private _operatorApprovals;
431 
432     constructor(string memory name_, string memory symbol_) {
433         _name = name_;
434         _symbol = symbol_;
435         _currentIndex = _startTokenId();
436     }
437 
438     /**
439      * @dev Returns the starting token ID. 
440      * To change the starting token ID, please override this function.
441      */
442     function _startTokenId() internal view virtual returns (uint256) {
443         return 0;
444     }
445 
446     /**
447      * @dev Returns the next token ID to be minted.
448      */
449     function _nextTokenId() internal view returns (uint256) {
450         return _currentIndex;
451     }
452 
453     /**
454      * @dev Returns the total number of tokens in existence.
455      * Burned tokens will reduce the count. 
456      * To get the total number of tokens minted, please see `_totalMinted`.
457      */
458     function totalSupply() public view override returns (uint256) {
459         // Counter underflow is impossible as _burnCounter cannot be incremented
460         // more than `_currentIndex - _startTokenId()` times.
461         unchecked {
462             return _currentIndex - _burnCounter - _startTokenId();
463         }
464     }
465 
466     /**
467      * @dev Returns the total amount of tokens minted in the contract.
468      */
469     function _totalMinted() internal view returns (uint256) {
470         // Counter underflow is impossible as _currentIndex does not decrement,
471         // and it is initialized to `_startTokenId()`
472         unchecked {
473             return _currentIndex - _startTokenId();
474         }
475     }
476 
477     /**
478      * @dev Returns the total number of tokens burned.
479      */
480     function _totalBurned() internal view returns (uint256) {
481         return _burnCounter;
482     }
483 
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         // The interface IDs are constants representing the first 4 bytes of the XOR of
489         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
490         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
491         return
492             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
493             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
494             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
495     }
496 
497     /**
498      * @dev See {IERC721-balanceOf}.
499      */
500     function balanceOf(address owner) public view override returns (uint256) {
501         if (owner == address(0)) revert BalanceQueryForZeroAddress();
502         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the number of tokens minted by `owner`.
507      */
508     function _numberMinted(address owner) internal view returns (uint256) {
509         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the number of tokens burned by or on behalf of `owner`.
514      */
515     function _numberBurned(address owner) internal view returns (uint256) {
516         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
521      */
522     function _getAux(address owner) internal view returns (uint64) {
523         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
524     }
525 
526     /**
527      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
528      * If there are multiple variables, please pack them into a uint64.
529      */
530     function _setAux(address owner, uint64 aux) internal {
531         uint256 packed = _packedAddressData[owner];
532         uint256 auxCasted;
533         assembly { // Cast aux without masking.
534             auxCasted := aux
535         }
536         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
537         _packedAddressData[owner] = packed;
538     }
539 
540     /**
541      * Returns the packed ownership data of `tokenId`.
542      */
543     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
544         uint256 curr = tokenId;
545 
546         unchecked {
547             if (_startTokenId() <= curr)
548                 if (curr < _currentIndex) {
549                     uint256 packed = _packedOwnerships[curr];
550                     // If not burned.
551                     if (packed & BITMASK_BURNED == 0) {
552                         // Invariant:
553                         // There will always be an ownership that has an address and is not burned
554                         // before an ownership that does not have an address and is not burned.
555                         // Hence, curr will not underflow.
556                         //
557                         // We can directly compare the packed value.
558                         // If the address is zero, packed is zero.
559                         while (packed == 0) {
560                             packed = _packedOwnerships[--curr];
561                         }
562                         return packed;
563                     }
564                 }
565         }
566         revert OwnerQueryForNonexistentToken();
567     }
568 
569     /**
570      * Returns the unpacked `TokenOwnership` struct from `packed`.
571      */
572     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
573         ownership.addr = address(uint160(packed));
574         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
575         ownership.burned = packed & BITMASK_BURNED != 0;
576     }
577 
578     /**
579      * Returns the unpacked `TokenOwnership` struct at `index`.
580      */
581     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
582         return _unpackedOwnership(_packedOwnerships[index]);
583     }
584 
585     /**
586      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
587      */
588     function _initializeOwnershipAt(uint256 index) internal {
589         if (_packedOwnerships[index] == 0) {
590             _packedOwnerships[index] = _packedOwnershipOf(index);
591         }
592     }
593 
594     /**
595      * Gas spent here starts off proportional to the maximum mint batch size.
596      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
597      */
598     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
599         return _unpackedOwnership(_packedOwnershipOf(tokenId));
600     }
601 
602     /**
603      * @dev See {IERC721-ownerOf}.
604      */
605     function ownerOf(uint256 tokenId) public view override returns (address) {
606         return address(uint160(_packedOwnershipOf(tokenId)));
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-name}.
611      */
612     function name() public view virtual override returns (string memory) {
613         return _name;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-symbol}.
618      */
619     function symbol() public view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-tokenURI}.
625      */
626     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
627         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
628 
629         string memory baseURI = _baseURI();
630         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
631     }
632 
633     /**
634      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
635      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
636      * by default, can be overriden in child contracts.
637      */
638     function _baseURI() internal view virtual returns (string memory) {
639         return '';
640     }
641 
642     /**
643      * @dev Casts the address to uint256 without masking.
644      */
645     function _addressToUint256(address value) private pure returns (uint256 result) {
646         assembly {
647             result := value
648         }
649     }
650 
651     /**
652      * @dev Casts the boolean to uint256 without branching.
653      */
654     function _boolToUint256(bool value) private pure returns (uint256 result) {
655         assembly {
656             result := value
657         }
658     }
659 
660     /**
661      * @dev See {IERC721-approve}.
662      */
663     function approve(address to, uint256 tokenId) public override {
664         address owner = address(uint160(_packedOwnershipOf(tokenId)));
665         if (to == owner) revert ApprovalToCurrentOwner();
666 
667         if (_msgSenderERC721A() != owner)
668             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
669                 revert ApprovalCallerNotOwnerNorApproved();
670             }
671 
672         _tokenApprovals[tokenId] = to;
673         emit Approval(owner, to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-getApproved}.
678      */
679     function getApproved(uint256 tokenId) public view override returns (address) {
680         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
681 
682         return _tokenApprovals[tokenId];
683     }
684 
685     /**
686      * @dev See {IERC721-setApprovalForAll}.
687      */
688     function setApprovalForAll(address operator, bool approved) public virtual override {
689         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
690 
691         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
692         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
693     }
694 
695     /**
696      * @dev See {IERC721-isApprovedForAll}.
697      */
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702     /**
703      * @dev See {IERC721-transferFrom}.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) public virtual override {
710         _transfer(from, to, tokenId);
711     }
712 
713     /**
714      * @dev See {IERC721-safeTransferFrom}.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) public virtual override {
721         safeTransferFrom(from, to, tokenId, '');
722     }
723 
724     /**
725      * @dev See {IERC721-safeTransferFrom}.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) public virtual override {
733         _transfer(from, to, tokenId);
734         if (to.code.length != 0)
735             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
736                 revert TransferToNonERC721ReceiverImplementer();
737             }
738     }
739 
740     /**
741      * @dev Returns whether `tokenId` exists.
742      *
743      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
744      *
745      * Tokens start existing when they are minted (`_mint`),
746      */
747     function _exists(uint256 tokenId) internal view returns (bool) {
748         return
749             _startTokenId() <= tokenId &&
750             tokenId < _currentIndex && // If within bounds,
751             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
752     }
753 
754     /**
755      * @dev Equivalent to `_safeMint(to, quantity, '')`.
756      */
757     function _safeMint(address to, uint256 quantity) internal {
758         _safeMint(to, quantity, '');
759     }
760 
761     /**
762      * @dev Safely mints `quantity` tokens and transfers them to `to`.
763      *
764      * Requirements:
765      *
766      * - If `to` refers to a smart contract, it must implement
767      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
768      * - `quantity` must be greater than 0.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeMint(
773         address to,
774         uint256 quantity,
775         bytes memory _data
776     ) internal {
777         uint256 startTokenId = _currentIndex;
778         if (to == address(0)) revert MintToZeroAddress();
779         if (quantity == 0) revert MintZeroQuantity();
780 
781         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
782 
783         // Overflows are incredibly unrealistic.
784         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
785         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
786         unchecked {
787             // Updates:
788             // - `balance += quantity`.
789             // - `numberMinted += quantity`.
790             //
791             // We can directly add to the balance and number minted.
792             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
793 
794             // Updates:
795             // - `address` to the owner.
796             // - `startTimestamp` to the timestamp of minting.
797             // - `burned` to `false`.
798             // - `nextInitialized` to `quantity == 1`.
799             _packedOwnerships[startTokenId] =
800                 _addressToUint256(to) |
801                 (block.timestamp << BITPOS_START_TIMESTAMP) |
802                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
803 
804             uint256 updatedIndex = startTokenId;
805             uint256 end = updatedIndex + quantity;
806 
807             if (to.code.length != 0) {
808                 do {
809                     emit Transfer(address(0), to, updatedIndex);
810                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
811                         revert TransferToNonERC721ReceiverImplementer();
812                     }
813                 } while (updatedIndex < end);
814                 // Reentrancy protection
815                 if (_currentIndex != startTokenId) revert();
816             } else {
817                 do {
818                     emit Transfer(address(0), to, updatedIndex++);
819                 } while (updatedIndex < end);
820             }
821             _currentIndex = updatedIndex;
822         }
823         _afterTokenTransfers(address(0), to, startTokenId, quantity);
824     }
825 
826     /**
827      * @dev Mints `quantity` tokens and transfers them to `to`.
828      *
829      * Requirements:
830      *
831      * - `to` cannot be the zero address.
832      * - `quantity` must be greater than 0.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _mint(address to, uint256 quantity) internal {
837         uint256 startTokenId = _currentIndex;
838         if (to == address(0)) revert MintToZeroAddress();
839         if (quantity == 0) revert MintZeroQuantity();
840 
841         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
842 
843         // Overflows are incredibly unrealistic.
844         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
845         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
846         unchecked {
847             // Updates:
848             // - `balance += quantity`.
849             // - `numberMinted += quantity`.
850             //
851             // We can directly add to the balance and number minted.
852             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
853 
854             // Updates:
855             // - `address` to the owner.
856             // - `startTimestamp` to the timestamp of minting.
857             // - `burned` to `false`.
858             // - `nextInitialized` to `quantity == 1`.
859             _packedOwnerships[startTokenId] =
860                 _addressToUint256(to) |
861                 (block.timestamp << BITPOS_START_TIMESTAMP) |
862                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
863 
864             uint256 updatedIndex = startTokenId;
865             uint256 end = updatedIndex + quantity;
866 
867             do {
868                 emit Transfer(address(0), to, updatedIndex++);
869             } while (updatedIndex < end);
870 
871             _currentIndex = updatedIndex;
872         }
873         _afterTokenTransfers(address(0), to, startTokenId, quantity);
874     }
875 
876     /**
877      * @dev Transfers `tokenId` from `from` to `to`.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _transfer(
887         address from,
888         address to,
889         uint256 tokenId
890     ) private {
891         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
892 
893         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
894 
895         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
896             isApprovedForAll(from, _msgSenderERC721A()) ||
897             getApproved(tokenId) == _msgSenderERC721A());
898 
899         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
900         if (to == address(0)) revert TransferToZeroAddress();
901 
902         _beforeTokenTransfers(from, to, tokenId, 1);
903 
904         // Clear approvals from the previous owner.
905         delete _tokenApprovals[tokenId];
906 
907         // Underflow of the sender's balance is impossible because we check for
908         // ownership above and the recipient's balance can't realistically overflow.
909         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
910         unchecked {
911             // We can directly increment and decrement the balances.
912             --_packedAddressData[from]; // Updates: `balance -= 1`.
913             ++_packedAddressData[to]; // Updates: `balance += 1`.
914 
915             // Updates:
916             // - `address` to the next owner.
917             // - `startTimestamp` to the timestamp of transfering.
918             // - `burned` to `false`.
919             // - `nextInitialized` to `true`.
920             _packedOwnerships[tokenId] =
921                 _addressToUint256(to) |
922                 (block.timestamp << BITPOS_START_TIMESTAMP) |
923                 BITMASK_NEXT_INITIALIZED;
924 
925             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
926             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
927                 uint256 nextTokenId = tokenId + 1;
928                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
929                 if (_packedOwnerships[nextTokenId] == 0) {
930                     // If the next slot is within bounds.
931                     if (nextTokenId != _currentIndex) {
932                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
933                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
934                     }
935                 }
936             }
937         }
938 
939         emit Transfer(from, to, tokenId);
940         _afterTokenTransfers(from, to, tokenId, 1);
941     }
942 
943     /**
944      * @dev Equivalent to `_burn(tokenId, false)`.
945      */
946     function _burn(uint256 tokenId) internal virtual {
947         _burn(tokenId, false);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
961         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
962 
963         address from = address(uint160(prevOwnershipPacked));
964 
965         if (approvalCheck) {
966             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
967                 isApprovedForAll(from, _msgSenderERC721A()) ||
968                 getApproved(tokenId) == _msgSenderERC721A());
969 
970             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
971         }
972 
973         _beforeTokenTransfers(from, address(0), tokenId, 1);
974 
975         // Clear approvals from the previous owner.
976         delete _tokenApprovals[tokenId];
977 
978         // Underflow of the sender's balance is impossible because we check for
979         // ownership above and the recipient's balance can't realistically overflow.
980         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
981         unchecked {
982             // Updates:
983             // - `balance -= 1`.
984             // - `numberBurned += 1`.
985             //
986             // We can directly decrement the balance, and increment the number burned.
987             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
988             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
989 
990             // Updates:
991             // - `address` to the last owner.
992             // - `startTimestamp` to the timestamp of burning.
993             // - `burned` to `true`.
994             // - `nextInitialized` to `true`.
995             _packedOwnerships[tokenId] =
996                 _addressToUint256(from) |
997                 (block.timestamp << BITPOS_START_TIMESTAMP) |
998                 BITMASK_BURNED | 
999                 BITMASK_NEXT_INITIALIZED;
1000 
1001             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1002             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1003                 uint256 nextTokenId = tokenId + 1;
1004                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1005                 if (_packedOwnerships[nextTokenId] == 0) {
1006                     // If the next slot is within bounds.
1007                     if (nextTokenId != _currentIndex) {
1008                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1009                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1010                     }
1011                 }
1012             }
1013         }
1014 
1015         emit Transfer(from, address(0), tokenId);
1016         _afterTokenTransfers(from, address(0), tokenId, 1);
1017 
1018         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1019         unchecked {
1020             _burnCounter++;
1021         }
1022     }
1023 
1024     /**
1025      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1026      *
1027      * @param from address representing the previous owner of the given token ID
1028      * @param to target address that will receive the tokens
1029      * @param tokenId uint256 ID of the token to be transferred
1030      * @param _data bytes optional data to send along with the call
1031      * @return bool whether the call correctly returned the expected magic value
1032      */
1033     function _checkContractOnERC721Received(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) private returns (bool) {
1039         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1040             bytes4 retval
1041         ) {
1042             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1043         } catch (bytes memory reason) {
1044             if (reason.length == 0) {
1045                 revert TransferToNonERC721ReceiverImplementer();
1046             } else {
1047                 assembly {
1048                     revert(add(32, reason), mload(reason))
1049                 }
1050             }
1051         }
1052     }
1053 
1054     /**
1055      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1056      * And also called before burning one token.
1057      *
1058      * startTokenId - the first token id to be transferred
1059      * quantity - the amount to be transferred
1060      *
1061      * Calling conditions:
1062      *
1063      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1064      * transferred to `to`.
1065      * - When `from` is zero, `tokenId` will be minted for `to`.
1066      * - When `to` is zero, `tokenId` will be burned by `from`.
1067      * - `from` and `to` are never both zero.
1068      */
1069     function _beforeTokenTransfers(
1070         address from,
1071         address to,
1072         uint256 startTokenId,
1073         uint256 quantity
1074     ) internal virtual {}
1075 
1076     /**
1077      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1078      * minting.
1079      * And also called after one token has been burned.
1080      *
1081      * startTokenId - the first token id to be transferred
1082      * quantity - the amount to be transferred
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` has been minted for `to`.
1089      * - When `to` is zero, `tokenId` has been burned by `from`.
1090      * - `from` and `to` are never both zero.
1091      */
1092     function _afterTokenTransfers(
1093         address from,
1094         address to,
1095         uint256 startTokenId,
1096         uint256 quantity
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Returns the message sender (defaults to `msg.sender`).
1101      *
1102      * If you are writing GSN compatible contracts, you need to override this function.
1103      */
1104     function _msgSenderERC721A() internal view virtual returns (address) {
1105         return msg.sender;
1106     }
1107 
1108     /**
1109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1110      */
1111     function _toString(uint256 value) internal pure returns (string memory ptr) {
1112         assembly {
1113             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1114             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1115             // We will need 1 32-byte word to store the length, 
1116             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1117             ptr := add(mload(0x40), 128)
1118             // Update the free memory pointer to allocate.
1119             mstore(0x40, ptr)
1120 
1121             // Cache the end of the memory to calculate the length later.
1122             let end := ptr
1123 
1124             // We write the string from the rightmost digit to the leftmost digit.
1125             // The following is essentially a do-while loop that also handles the zero case.
1126             // Costs a bit more than early returning for the zero case,
1127             // but cheaper in terms of deployment and overall runtime costs.
1128             for { 
1129                 // Initialize and perform the first pass without check.
1130                 let temp := value
1131                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1132                 ptr := sub(ptr, 1)
1133                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1134                 mstore8(ptr, add(48, mod(temp, 10)))
1135                 temp := div(temp, 10)
1136             } temp { 
1137                 // Keep dividing `temp` until zero.
1138                 temp := div(temp, 10)
1139             } { // Body of the for loop.
1140                 ptr := sub(ptr, 1)
1141                 mstore8(ptr, add(48, mod(temp, 10)))
1142             }
1143             
1144             let length := sub(end, ptr)
1145             // Move the pointer 32 bytes leftwards to make room for the length.
1146             ptr := sub(ptr, 32)
1147             // Store the length.
1148             mstore(ptr, length)
1149         }
1150     }
1151 }
1152 
1153 // File: @openzeppelin/contracts/utils/Context.sol
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 /**
1161  * @dev Provides information about the current execution context, including the
1162  * sender of the transaction and its data. While these are generally available
1163  * via msg.sender and msg.data, they should not be accessed in such a direct
1164  * manner, since when dealing with meta-transactions the account sending and
1165  * paying for execution may not be the actual sender (as far as an application
1166  * is concerned).
1167  *
1168  * This contract is only required for intermediate, library-like contracts.
1169  */
1170 abstract contract Context {
1171     function _msgSender() internal view virtual returns (address) {
1172         return msg.sender;
1173     }
1174 
1175     function _msgData() internal view virtual returns (bytes calldata) {
1176         return msg.data;
1177     }
1178 }
1179 
1180 // File: @openzeppelin/contracts/access/Ownable.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _transferOwnership(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _transferOwnership(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _transferOwnership(newOwner);
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 // File: contracts/fairytown.wtf.sol
1259 
1260 
1261 
1262 pragma solidity 0.8.7;
1263 
1264 
1265 
1266 
1267 contract fairytownwtf is ERC721A, Ownable {
1268     string private baseURI;
1269     bool private started;
1270     uint256 public constant MAX_SUPPLY_PLUS_ONE = 3334;
1271     uint256 public constant MAX_MINT_PLUS_ONE = 6;
1272 
1273     mapping(address => uint256) private addressClaimed;
1274 
1275     constructor() ERC721A("fairytown.wtf", "FAIRY") {}
1276 
1277     function _startTokenId() internal view virtual override returns (uint256) {
1278         return 1;
1279     }
1280 
1281     function mintSafe(address to_, uint256 amount_) external payable {
1282         require(started, "Not started");
1283         require(
1284             totalSupply() + amount_ < MAX_SUPPLY_PLUS_ONE,
1285             "Exceed max supply"
1286         );
1287         require(
1288             addressClaimed[msg.sender] + amount_ < MAX_MINT_PLUS_ONE,
1289             "Exceed max mint"
1290         );
1291         _safeMint(to_, amount_);
1292     }
1293 
1294     function setBaseURI(string memory baseURI_) external onlyOwner {
1295         baseURI = baseURI_;
1296     }
1297 
1298     function enableMint(bool mintStarted) external onlyOwner {
1299         started = mintStarted;
1300     }
1301 
1302     function tokenURI(uint256 tokenId)
1303         public
1304         view
1305         override
1306         returns (string memory)
1307     {
1308         require(
1309             _exists(tokenId),
1310             "ERC721Metadata: URI query for nonexistent token"
1311         );
1312         return
1313             bytes(baseURI).length > 0
1314                 ? string(
1315                     abi.encodePacked(
1316                         baseURI,
1317                         Strings.toString(tokenId),
1318                         ".json"
1319                     )
1320                 )
1321                 : "";
1322     }
1323 }