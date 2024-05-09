1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: erc721a/contracts/IERC721A.sol
72 
73 
74 // ERC721A Contracts v4.0.0
75 // Creator: Chiru Labs
76 
77 pragma solidity ^0.8.4;
78 
79 /**
80  * @dev Interface of an ERC721A compliant contract.
81  */
82 interface IERC721A {
83     /**
84      * The caller must own the token or be an approved operator.
85      */
86     error ApprovalCallerNotOwnerNorApproved();
87 
88     /**
89      * The token does not exist.
90      */
91     error ApprovalQueryForNonexistentToken();
92 
93     /**
94      * The caller cannot approve to their own address.
95      */
96     error ApproveToCaller();
97 
98     /**
99      * The caller cannot approve to the current owner.
100      */
101     error ApprovalToCurrentOwner();
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
134      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
148     struct TokenOwnership {
149         // The address of the owner.
150         address addr;
151         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
152         uint64 startTimestamp;
153         // Whether the token has been burned.
154         bool burned;
155     }
156 
157     /**
158      * @dev Returns the total amount of tokens stored by the contract.
159      *
160      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     // ==============================
165     //            IERC165
166     // ==============================
167 
168     /**
169      * @dev Returns true if this contract implements the interface defined by
170      * `interfaceId`. See the corresponding
171      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
172      * to learn more about how these ids are created.
173      *
174      * This function call must use less than 30 000 gas.
175      */
176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
177 
178     // ==============================
179     //            IERC721
180     // ==============================
181 
182     /**
183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
186 
187     /**
188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
189      */
190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
194      */
195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
196 
197     /**
198      * @dev Returns the number of tokens in ``owner``'s account.
199      */
200     function balanceOf(address owner) external view returns (uint256 balance);
201 
202     /**
203      * @dev Returns the owner of the `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId,
228         bytes calldata data
229     ) external;
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
233      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Transfers `tokenId` token from `from` to `to`.
253      *
254      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      *
263      * Emits a {Transfer} event.
264      */
265     function transferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
273      * The approval is cleared when the token is transferred.
274      *
275      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
276      *
277      * Requirements:
278      *
279      * - The caller must own the token or be an approved operator.
280      * - `tokenId` must exist.
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address to, uint256 tokenId) external;
285 
286     /**
287      * @dev Approve or remove `operator` as an operator for the caller.
288      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
289      *
290      * Requirements:
291      *
292      * - The `operator` cannot be the caller.
293      *
294      * Emits an {ApprovalForAll} event.
295      */
296     function setApprovalForAll(address operator, bool _approved) external;
297 
298     /**
299      * @dev Returns the account approved for `tokenId` token.
300      *
301      * Requirements:
302      *
303      * - `tokenId` must exist.
304      */
305     function getApproved(uint256 tokenId) external view returns (address operator);
306 
307     /**
308      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
309      *
310      * See {setApprovalForAll}
311      */
312     function isApprovedForAll(address owner, address operator) external view returns (bool);
313 
314     // ==============================
315     //        IERC721Metadata
316     // ==============================
317 
318     /**
319      * @dev Returns the token collection name.
320      */
321     function name() external view returns (string memory);
322 
323     /**
324      * @dev Returns the token collection symbol.
325      */
326     function symbol() external view returns (string memory);
327 
328     /**
329      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
330      */
331     function tokenURI(uint256 tokenId) external view returns (string memory);
332 }
333 
334 // File: erc721a/contracts/ERC721A.sol
335 
336 
337 // ERC721A Contracts v4.0.0
338 // Creator: Chiru Labs
339 
340 pragma solidity ^0.8.4;
341 
342 
343 /**
344  * @dev ERC721 token receiver interface.
345  */
346 interface ERC721A__IERC721Receiver {
347     function onERC721Received(
348         address operator,
349         address from,
350         uint256 tokenId,
351         bytes calldata data
352     ) external returns (bytes4);
353 }
354 
355 /**
356  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
357  * the Metadata extension. Built to optimize for lower gas during batch mints.
358  *
359  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
360  *
361  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
362  *
363  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
364  */
365 contract ERC721A is IERC721A {
366     // Mask of an entry in packed address data.
367     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
368 
369     // The bit position of `numberMinted` in packed address data.
370     uint256 private constant BITPOS_NUMBER_MINTED = 64;
371 
372     // The bit position of `numberBurned` in packed address data.
373     uint256 private constant BITPOS_NUMBER_BURNED = 128;
374 
375     // The bit position of `aux` in packed address data.
376     uint256 private constant BITPOS_AUX = 192;
377 
378     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
379     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
380 
381     // The bit position of `startTimestamp` in packed ownership.
382     uint256 private constant BITPOS_START_TIMESTAMP = 160;
383 
384     // The bit mask of the `burned` bit in packed ownership.
385     uint256 private constant BITMASK_BURNED = 1 << 224;
386     
387     // The bit position of the `nextInitialized` bit in packed ownership.
388     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
389 
390     // The bit mask of the `nextInitialized` bit in packed ownership.
391     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
392 
393     // The tokenId of the next token to be minted.
394     uint256 private _currentIndex;
395 
396     // The number of tokens burned.
397     uint256 private _burnCounter;
398 
399     // Token name
400     string private _name;
401 
402     // Token symbol
403     string private _symbol;
404 
405     // Mapping from token ID to ownership details
406     // An empty struct value does not necessarily mean the token is unowned.
407     // See `_packedOwnershipOf` implementation for details.
408     //
409     // Bits Layout:
410     // - [0..159]   `addr`
411     // - [160..223] `startTimestamp`
412     // - [224]      `burned`
413     // - [225]      `nextInitialized`
414     mapping(uint256 => uint256) private _packedOwnerships;
415 
416     // Mapping owner address to address data.
417     //
418     // Bits Layout:
419     // - [0..63]    `balance`
420     // - [64..127]  `numberMinted`
421     // - [128..191] `numberBurned`
422     // - [192..255] `aux`
423     mapping(address => uint256) private _packedAddressData;
424 
425     // Mapping from token ID to approved address.
426     mapping(uint256 => address) private _tokenApprovals;
427 
428     // Mapping from owner to operator approvals
429     mapping(address => mapping(address => bool)) private _operatorApprovals;
430 
431     constructor(string memory name_, string memory symbol_) {
432         _name = name_;
433         _symbol = symbol_;
434         _currentIndex = _startTokenId();
435     }
436 
437     /**
438      * @dev Returns the starting token ID. 
439      * To change the starting token ID, please override this function.
440      */
441     function _startTokenId() internal view virtual returns (uint256) {
442         return 0;
443     }
444 
445     /**
446      * @dev Returns the next token ID to be minted.
447      */
448     function _nextTokenId() internal view returns (uint256) {
449         return _currentIndex;
450     }
451 
452     /**
453      * @dev Returns the total number of tokens in existence.
454      * Burned tokens will reduce the count. 
455      * To get the total number of tokens minted, please see `_totalMinted`.
456      */
457     function totalSupply() public view override returns (uint256) {
458         // Counter underflow is impossible as _burnCounter cannot be incremented
459         // more than `_currentIndex - _startTokenId()` times.
460         unchecked {
461             return _currentIndex - _burnCounter - _startTokenId();
462         }
463     }
464 
465     /**
466      * @dev Returns the total amount of tokens minted in the contract.
467      */
468     function _totalMinted() internal view returns (uint256) {
469         // Counter underflow is impossible as _currentIndex does not decrement,
470         // and it is initialized to `_startTokenId()`
471         unchecked {
472             return _currentIndex - _startTokenId();
473         }
474     }
475 
476     /**
477      * @dev Returns the total number of tokens burned.
478      */
479     function _totalBurned() internal view returns (uint256) {
480         return _burnCounter;
481     }
482 
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
487         // The interface IDs are constants representing the first 4 bytes of the XOR of
488         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
489         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
490         return
491             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
492             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
493             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
494     }
495 
496     /**
497      * @dev See {IERC721-balanceOf}.
498      */
499     function balanceOf(address owner) public view override returns (uint256) {
500         if (owner == address(0)) revert BalanceQueryForZeroAddress();
501         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     /**
505      * Returns the number of tokens minted by `owner`.
506      */
507     function _numberMinted(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the number of tokens burned by or on behalf of `owner`.
513      */
514     function _numberBurned(address owner) internal view returns (uint256) {
515         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
516     }
517 
518     /**
519      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
520      */
521     function _getAux(address owner) internal view returns (uint64) {
522         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
523     }
524 
525     /**
526      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
527      * If there are multiple variables, please pack them into a uint64.
528      */
529     function _setAux(address owner, uint64 aux) internal {
530         uint256 packed = _packedAddressData[owner];
531         uint256 auxCasted;
532         assembly { // Cast aux without masking.
533             auxCasted := aux
534         }
535         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
536         _packedAddressData[owner] = packed;
537     }
538 
539     /**
540      * Returns the packed ownership data of `tokenId`.
541      */
542     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
543         uint256 curr = tokenId;
544 
545         unchecked {
546             if (_startTokenId() <= curr)
547                 if (curr < _currentIndex) {
548                     uint256 packed = _packedOwnerships[curr];
549                     // If not burned.
550                     if (packed & BITMASK_BURNED == 0) {
551                         // Invariant:
552                         // There will always be an ownership that has an address and is not burned
553                         // before an ownership that does not have an address and is not burned.
554                         // Hence, curr will not underflow.
555                         //
556                         // We can directly compare the packed value.
557                         // If the address is zero, packed is zero.
558                         while (packed == 0) {
559                             packed = _packedOwnerships[--curr];
560                         }
561                         return packed;
562                     }
563                 }
564         }
565         revert OwnerQueryForNonexistentToken();
566     }
567 
568     /**
569      * Returns the unpacked `TokenOwnership` struct from `packed`.
570      */
571     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
572         ownership.addr = address(uint160(packed));
573         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
574         ownership.burned = packed & BITMASK_BURNED != 0;
575     }
576 
577     /**
578      * Returns the unpacked `TokenOwnership` struct at `index`.
579      */
580     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
581         return _unpackedOwnership(_packedOwnerships[index]);
582     }
583 
584     /**
585      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
586      */
587     function _initializeOwnershipAt(uint256 index) internal {
588         if (_packedOwnerships[index] == 0) {
589             _packedOwnerships[index] = _packedOwnershipOf(index);
590         }
591     }
592 
593     /**
594      * Gas spent here starts off proportional to the maximum mint batch size.
595      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
596      */
597     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
598         return _unpackedOwnership(_packedOwnershipOf(tokenId));
599     }
600 
601     /**
602      * @dev See {IERC721-ownerOf}.
603      */
604     function ownerOf(uint256 tokenId) public view override returns (address) {
605         return address(uint160(_packedOwnershipOf(tokenId)));
606     }
607 
608     /**
609      * @dev See {IERC721Metadata-name}.
610      */
611     function name() public view virtual override returns (string memory) {
612         return _name;
613     }
614 
615     /**
616      * @dev See {IERC721Metadata-symbol}.
617      */
618     function symbol() public view virtual override returns (string memory) {
619         return _symbol;
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-tokenURI}.
624      */
625     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
626         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
627 
628         string memory baseURI = _baseURI();
629         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
630     }
631 
632     /**
633      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
634      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
635      * by default, can be overriden in child contracts.
636      */
637     function _baseURI() internal view virtual returns (string memory) {
638         return '';
639     }
640 
641     /**
642      * @dev Casts the address to uint256 without masking.
643      */
644     function _addressToUint256(address value) private pure returns (uint256 result) {
645         assembly {
646             result := value
647         }
648     }
649 
650     /**
651      * @dev Casts the boolean to uint256 without branching.
652      */
653     function _boolToUint256(bool value) private pure returns (uint256 result) {
654         assembly {
655             result := value
656         }
657     }
658 
659     /**
660      * @dev See {IERC721-approve}.
661      */
662     function approve(address to, uint256 tokenId) public override {
663         address owner = address(uint160(_packedOwnershipOf(tokenId)));
664         if (to == owner) revert ApprovalToCurrentOwner();
665 
666         if (_msgSenderERC721A() != owner)
667             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
668                 revert ApprovalCallerNotOwnerNorApproved();
669             }
670 
671         _tokenApprovals[tokenId] = to;
672         emit Approval(owner, to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-getApproved}.
677      */
678     function getApproved(uint256 tokenId) public view override returns (address) {
679         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev See {IERC721-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved) public virtual override {
688         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
689 
690         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
691         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
692     }
693 
694     /**
695      * @dev See {IERC721-isApprovedForAll}.
696      */
697     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
698         return _operatorApprovals[owner][operator];
699     }
700 
701     /**
702      * @dev See {IERC721-transferFrom}.
703      */
704     function transferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         _transfer(from, to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) public virtual override {
720         safeTransferFrom(from, to, tokenId, '');
721     }
722 
723     /**
724      * @dev See {IERC721-safeTransferFrom}.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) public virtual override {
732         _transfer(from, to, tokenId);
733         if (to.code.length != 0)
734             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
735                 revert TransferToNonERC721ReceiverImplementer();
736             }
737     }
738 
739     /**
740      * @dev Returns whether `tokenId` exists.
741      *
742      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
743      *
744      * Tokens start existing when they are minted (`_mint`),
745      */
746     function _exists(uint256 tokenId) internal view returns (bool) {
747         return
748             _startTokenId() <= tokenId &&
749             tokenId < _currentIndex && // If within bounds,
750             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
751     }
752 
753     /**
754      * @dev Equivalent to `_safeMint(to, quantity, '')`.
755      */
756     function _safeMint(address to, uint256 quantity) internal {
757         _safeMint(to, quantity, '');
758     }
759 
760     /**
761      * @dev Safely mints `quantity` tokens and transfers them to `to`.
762      *
763      * Requirements:
764      *
765      * - If `to` refers to a smart contract, it must implement
766      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
767      * - `quantity` must be greater than 0.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeMint(
772         address to,
773         uint256 quantity,
774         bytes memory _data
775     ) internal {
776         uint256 startTokenId = _currentIndex;
777         if (to == address(0)) revert MintToZeroAddress();
778         if (quantity == 0) revert MintZeroQuantity();
779 
780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
781 
782         // Overflows are incredibly unrealistic.
783         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
784         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
785         unchecked {
786             // Updates:
787             // - `balance += quantity`.
788             // - `numberMinted += quantity`.
789             //
790             // We can directly add to the balance and number minted.
791             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] =
799                 _addressToUint256(to) |
800                 (block.timestamp << BITPOS_START_TIMESTAMP) |
801                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
802 
803             uint256 updatedIndex = startTokenId;
804             uint256 end = updatedIndex + quantity;
805 
806             if (to.code.length != 0) {
807                 do {
808                     emit Transfer(address(0), to, updatedIndex);
809                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
810                         revert TransferToNonERC721ReceiverImplementer();
811                     }
812                 } while (updatedIndex < end);
813                 // Reentrancy protection
814                 if (_currentIndex != startTokenId) revert();
815             } else {
816                 do {
817                     emit Transfer(address(0), to, updatedIndex++);
818                 } while (updatedIndex < end);
819             }
820             _currentIndex = updatedIndex;
821         }
822         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
833      * Emits a {Transfer} event.
834      */
835     function _mint(address to, uint256 quantity) internal {
836         uint256 startTokenId = _currentIndex;
837         if (to == address(0)) revert MintToZeroAddress();
838         if (quantity == 0) revert MintZeroQuantity();
839 
840         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
841 
842         // Overflows are incredibly unrealistic.
843         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
844         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
845         unchecked {
846             // Updates:
847             // - `balance += quantity`.
848             // - `numberMinted += quantity`.
849             //
850             // We can directly add to the balance and number minted.
851             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
852 
853             // Updates:
854             // - `address` to the owner.
855             // - `startTimestamp` to the timestamp of minting.
856             // - `burned` to `false`.
857             // - `nextInitialized` to `quantity == 1`.
858             _packedOwnerships[startTokenId] =
859                 _addressToUint256(to) |
860                 (block.timestamp << BITPOS_START_TIMESTAMP) |
861                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
862 
863             uint256 updatedIndex = startTokenId;
864             uint256 end = updatedIndex + quantity;
865 
866             do {
867                 emit Transfer(address(0), to, updatedIndex++);
868             } while (updatedIndex < end);
869 
870             _currentIndex = updatedIndex;
871         }
872         _afterTokenTransfers(address(0), to, startTokenId, quantity);
873     }
874 
875     /**
876      * @dev Transfers `tokenId` from `from` to `to`.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must be owned by `from`.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _transfer(
886         address from,
887         address to,
888         uint256 tokenId
889     ) private {
890         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
891 
892         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
893 
894         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
895             isApprovedForAll(from, _msgSenderERC721A()) ||
896             getApproved(tokenId) == _msgSenderERC721A());
897 
898         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
899         if (to == address(0)) revert TransferToZeroAddress();
900 
901         _beforeTokenTransfers(from, to, tokenId, 1);
902 
903         // Clear approvals from the previous owner.
904         delete _tokenApprovals[tokenId];
905 
906         // Underflow of the sender's balance is impossible because we check for
907         // ownership above and the recipient's balance can't realistically overflow.
908         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
909         unchecked {
910             // We can directly increment and decrement the balances.
911             --_packedAddressData[from]; // Updates: `balance -= 1`.
912             ++_packedAddressData[to]; // Updates: `balance += 1`.
913 
914             // Updates:
915             // - `address` to the next owner.
916             // - `startTimestamp` to the timestamp of transfering.
917             // - `burned` to `false`.
918             // - `nextInitialized` to `true`.
919             _packedOwnerships[tokenId] =
920                 _addressToUint256(to) |
921                 (block.timestamp << BITPOS_START_TIMESTAMP) |
922                 BITMASK_NEXT_INITIALIZED;
923 
924             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
925             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
926                 uint256 nextTokenId = tokenId + 1;
927                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
928                 if (_packedOwnerships[nextTokenId] == 0) {
929                     // If the next slot is within bounds.
930                     if (nextTokenId != _currentIndex) {
931                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
932                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
933                     }
934                 }
935             }
936         }
937 
938         emit Transfer(from, to, tokenId);
939         _afterTokenTransfers(from, to, tokenId, 1);
940     }
941 
942     /**
943      * @dev Equivalent to `_burn(tokenId, false)`.
944      */
945     function _burn(uint256 tokenId) internal virtual {
946         _burn(tokenId, false);
947     }
948 
949     /**
950      * @dev Destroys `tokenId`.
951      * The approval is cleared when the token is burned.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must exist.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
960         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
961 
962         address from = address(uint160(prevOwnershipPacked));
963 
964         if (approvalCheck) {
965             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
966                 isApprovedForAll(from, _msgSenderERC721A()) ||
967                 getApproved(tokenId) == _msgSenderERC721A());
968 
969             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
970         }
971 
972         _beforeTokenTransfers(from, address(0), tokenId, 1);
973 
974         // Clear approvals from the previous owner.
975         delete _tokenApprovals[tokenId];
976 
977         // Underflow of the sender's balance is impossible because we check for
978         // ownership above and the recipient's balance can't realistically overflow.
979         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
980         unchecked {
981             // Updates:
982             // - `balance -= 1`.
983             // - `numberBurned += 1`.
984             //
985             // We can directly decrement the balance, and increment the number burned.
986             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
987             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
988 
989             // Updates:
990             // - `address` to the last owner.
991             // - `startTimestamp` to the timestamp of burning.
992             // - `burned` to `true`.
993             // - `nextInitialized` to `true`.
994             _packedOwnerships[tokenId] =
995                 _addressToUint256(from) |
996                 (block.timestamp << BITPOS_START_TIMESTAMP) |
997                 BITMASK_BURNED | 
998                 BITMASK_NEXT_INITIALIZED;
999 
1000             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1001             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1002                 uint256 nextTokenId = tokenId + 1;
1003                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1004                 if (_packedOwnerships[nextTokenId] == 0) {
1005                     // If the next slot is within bounds.
1006                     if (nextTokenId != _currentIndex) {
1007                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1008                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1009                     }
1010                 }
1011             }
1012         }
1013 
1014         emit Transfer(from, address(0), tokenId);
1015         _afterTokenTransfers(from, address(0), tokenId, 1);
1016 
1017         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1018         unchecked {
1019             _burnCounter++;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1025      *
1026      * @param from address representing the previous owner of the given token ID
1027      * @param to target address that will receive the tokens
1028      * @param tokenId uint256 ID of the token to be transferred
1029      * @param _data bytes optional data to send along with the call
1030      * @return bool whether the call correctly returned the expected magic value
1031      */
1032     function _checkContractOnERC721Received(
1033         address from,
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) private returns (bool) {
1038         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1039             bytes4 retval
1040         ) {
1041             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1042         } catch (bytes memory reason) {
1043             if (reason.length == 0) {
1044                 revert TransferToNonERC721ReceiverImplementer();
1045             } else {
1046                 assembly {
1047                     revert(add(32, reason), mload(reason))
1048                 }
1049             }
1050         }
1051     }
1052 
1053     /**
1054      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1055      * And also called before burning one token.
1056      *
1057      * startTokenId - the first token id to be transferred
1058      * quantity - the amount to be transferred
1059      *
1060      * Calling conditions:
1061      *
1062      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1063      * transferred to `to`.
1064      * - When `from` is zero, `tokenId` will be minted for `to`.
1065      * - When `to` is zero, `tokenId` will be burned by `from`.
1066      * - `from` and `to` are never both zero.
1067      */
1068     function _beforeTokenTransfers(
1069         address from,
1070         address to,
1071         uint256 startTokenId,
1072         uint256 quantity
1073     ) internal virtual {}
1074 
1075     /**
1076      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1077      * minting.
1078      * And also called after one token has been burned.
1079      *
1080      * startTokenId - the first token id to be transferred
1081      * quantity - the amount to be transferred
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` has been minted for `to`.
1088      * - When `to` is zero, `tokenId` has been burned by `from`.
1089      * - `from` and `to` are never both zero.
1090      */
1091     function _afterTokenTransfers(
1092         address from,
1093         address to,
1094         uint256 startTokenId,
1095         uint256 quantity
1096     ) internal virtual {}
1097 
1098     /**
1099      * @dev Returns the message sender (defaults to `msg.sender`).
1100      *
1101      * If you are writing GSN compatible contracts, you need to override this function.
1102      */
1103     function _msgSenderERC721A() internal view virtual returns (address) {
1104         return msg.sender;
1105     }
1106 
1107     /**
1108      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1109      */
1110     function _toString(uint256 value) internal pure returns (string memory ptr) {
1111         assembly {
1112             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1113             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1114             // We will need 1 32-byte word to store the length, 
1115             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1116             ptr := add(mload(0x40), 128)
1117             // Update the free memory pointer to allocate.
1118             mstore(0x40, ptr)
1119 
1120             // Cache the end of the memory to calculate the length later.
1121             let end := ptr
1122 
1123             // We write the string from the rightmost digit to the leftmost digit.
1124             // The following is essentially a do-while loop that also handles the zero case.
1125             // Costs a bit more than early returning for the zero case,
1126             // but cheaper in terms of deployment and overall runtime costs.
1127             for { 
1128                 // Initialize and perform the first pass without check.
1129                 let temp := value
1130                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1131                 ptr := sub(ptr, 1)
1132                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1133                 mstore8(ptr, add(48, mod(temp, 10)))
1134                 temp := div(temp, 10)
1135             } temp { 
1136                 // Keep dividing `temp` until zero.
1137                 temp := div(temp, 10)
1138             } { // Body of the for loop.
1139                 ptr := sub(ptr, 1)
1140                 mstore8(ptr, add(48, mod(temp, 10)))
1141             }
1142             
1143             let length := sub(end, ptr)
1144             // Move the pointer 32 bytes leftwards to make room for the length.
1145             ptr := sub(ptr, 32)
1146             // Store the length.
1147             mstore(ptr, length)
1148         }
1149     }
1150 }
1151 
1152 // File: @openzeppelin/contracts/utils/Context.sol
1153 
1154 
1155 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1156 
1157 pragma solidity ^0.8.0;
1158 
1159 /**
1160  * @dev Provides information about the current execution context, including the
1161  * sender of the transaction and its data. While these are generally available
1162  * via msg.sender and msg.data, they should not be accessed in such a direct
1163  * manner, since when dealing with meta-transactions the account sending and
1164  * paying for execution may not be the actual sender (as far as an application
1165  * is concerned).
1166  *
1167  * This contract is only required for intermediate, library-like contracts.
1168  */
1169 abstract contract Context {
1170     function _msgSender() internal view virtual returns (address) {
1171         return msg.sender;
1172     }
1173 
1174     function _msgData() internal view virtual returns (bytes calldata) {
1175         return msg.data;
1176     }
1177 }
1178 
1179 // File: @openzeppelin/contracts/access/Ownable.sol
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 /**
1188  * @dev Contract module which provides a basic access control mechanism, where
1189  * there is an account (an owner) that can be granted exclusive access to
1190  * specific functions.
1191  *
1192  * By default, the owner account will be the one that deploys the contract. This
1193  * can later be changed with {transferOwnership}.
1194  *
1195  * This module is used through inheritance. It will make available the modifier
1196  * `onlyOwner`, which can be applied to your functions to restrict their use to
1197  * the owner.
1198  */
1199 abstract contract Ownable is Context {
1200     address private _owner;
1201 
1202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1203 
1204     /**
1205      * @dev Initializes the contract setting the deployer as the initial owner.
1206      */
1207     constructor() {
1208         _transferOwnership(_msgSender());
1209     }
1210 
1211     /**
1212      * @dev Returns the address of the current owner.
1213      */
1214     function owner() public view virtual returns (address) {
1215         return _owner;
1216     }
1217 
1218     /**
1219      * @dev Throws if called by any account other than the owner.
1220      */
1221     modifier onlyOwner() {
1222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1223         _;
1224     }
1225 
1226     /**
1227      * @dev Leaves the contract without owner. It will not be possible to call
1228      * `onlyOwner` functions anymore. Can only be called by the current owner.
1229      *
1230      * NOTE: Renouncing ownership will leave the contract without an owner,
1231      * thereby removing any functionality that is only available to the owner.
1232      */
1233     function renounceOwnership() public virtual onlyOwner {
1234         _transferOwnership(address(0));
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Can only be called by the current owner.
1240      */
1241     function transferOwnership(address newOwner) public virtual onlyOwner {
1242         require(newOwner != address(0), "Ownable: new owner is the zero address");
1243         _transferOwnership(newOwner);
1244     }
1245 
1246     /**
1247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1248      * Internal function without access restriction.
1249      */
1250     function _transferOwnership(address newOwner) internal virtual {
1251         address oldOwner = _owner;
1252         _owner = newOwner;
1253         emit OwnershipTransferred(oldOwner, newOwner);
1254     }
1255 }
1256 
1257 // File: contracts/Zomboki.sol
1258 
1259 //SPDX-License-Identifier: MIT
1260 pragma solidity ^0.8.11;
1261 
1262 
1263 
1264 
1265     
1266 
1267 contract Zomboki is ERC721A, Ownable {
1268     
1269 
1270     constructor() ERC721A("Zomboki", "ZOMBOKI") {}
1271 
1272     string public baseURI;
1273     string public contractURI;
1274     string public unrevealedUri = "ipfs://QmYBYBt414RNekYpgLWdwfUfZjLmZ1qKV6mokZYG1dfhQM";
1275     string public constant baseExtension = ".json";
1276     uint256 public constant MAX_SUPPLY = 3333;        
1277     uint256 public maxPerTx = 3;
1278     uint256 public price = 0 wei;
1279     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1280     bool public paused = true;
1281     bool public revealed = false;
1282 
1283     function _startTokenId() internal override view virtual returns (uint256) {
1284         return 1;
1285     }
1286 
1287     function setContractURI(string memory _contractURI) external onlyOwner {
1288         contractURI = _contractURI;
1289     }
1290 
1291     function mint(uint256 _quantity) external payable {
1292         address _caller = _msgSender();
1293         require(MAX_SUPPLY >= totalSupply() + _quantity, "Exceeds max supply");
1294         require(_quantity > 0, "Mint quantity must be > 0");
1295         require(maxPerTx >= _quantity , "Exceeds max per tx");
1296         require(paused == false, "Mint paused");
1297         _safeMint(_caller, _quantity);
1298     }
1299 
1300     function numberMinted(address owner) public view returns (uint256) {
1301         return _numberMinted(owner);
1302     }
1303 
1304     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
1305         maxPerTx = _maxPerTx;
1306     }
1307 
1308     function setBaseURI(string memory baseURI_) external onlyOwner {
1309         baseURI = baseURI_;
1310     }
1311 
1312     function withdraw() external onlyOwner {
1313         uint256 balance = address(this).balance;
1314         (bool success, ) = _msgSender().call{value: balance}("");
1315         require(success, "Failed to send");
1316     }    
1317 
1318     function pause(bool _state) external onlyOwner {
1319         paused = _state;
1320     }
1321     
1322     function setUnrevealedURI(string memory _unrevealedURI) public onlyOwner {
1323         unrevealedUri = _unrevealedURI;
1324     }
1325 
1326     function reveal() public onlyOwner {
1327         revealed = true;
1328     }
1329 
1330     function setupOS() external onlyOwner {
1331         _safeMint(_msgSender(), 1);
1332     }
1333     
1334     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1335         // Whitelist OpenSea proxy contract for easy trading.
1336         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1337         if (address(proxyRegistry.proxies(owner)) == operator) {
1338             return true;
1339         }
1340 
1341         return super.isApprovedForAll(owner, operator);
1342     }
1343 
1344     
1345 
1346     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1347         require(_exists(_tokenId), "Token does not exist.");
1348         
1349         if (revealed == false) {
1350             return unrevealedUri;
1351         }
1352         
1353         return bytes(baseURI).length > 0 ? string(
1354             abi.encodePacked(
1355             baseURI,
1356             Strings.toString(_tokenId),
1357             baseExtension
1358             )
1359     ) : "";
1360 
1361     }
1362 }
1363 
1364 
1365 contract OwnableDelegateProxy { }
1366 contract ProxyRegistry {
1367     mapping(address => OwnableDelegateProxy) public proxies;
1368 }