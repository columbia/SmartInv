1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
71 }
72 
73 // File: erc721a/contracts/IERC721A.sol
74 
75 
76 // ERC721A Contracts v4.0.0
77 // Creator: Chiru Labs
78 
79 pragma solidity ^0.8.4;
80 
81 /**
82  * @dev Interface of an ERC721A compliant contract.
83  */
84 interface IERC721A {
85     /**
86      * The caller must own the token or be an approved operator.
87      */
88     error ApprovalCallerNotOwnerNorApproved();
89 
90     /**
91      * The token does not exist.
92      */
93     error ApprovalQueryForNonexistentToken();
94 
95     /**
96      * The caller cannot approve to their own address.
97      */
98     error ApproveToCaller();
99 
100     /**
101      * The caller cannot approve to the current owner.
102      */
103     error ApprovalToCurrentOwner();
104 
105     /**
106      * Cannot query the balance for the zero address.
107      */
108     error BalanceQueryForZeroAddress();
109 
110     /**
111      * Cannot mint to the zero address.
112      */
113     error MintToZeroAddress();
114 
115     /**
116      * The quantity of tokens minted must be more than zero.
117      */
118     error MintZeroQuantity();
119 
120     /**
121      * The token does not exist.
122      */
123     error OwnerQueryForNonexistentToken();
124 
125     /**
126      * The caller must own the token or be an approved operator.
127      */
128     error TransferCallerNotOwnerNorApproved();
129 
130     /**
131      * The token must be owned by `from`.
132      */
133     error TransferFromIncorrectOwner();
134 
135     /**
136      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
137      */
138     error TransferToNonERC721ReceiverImplementer();
139 
140     /**
141      * Cannot transfer to the zero address.
142      */
143     error TransferToZeroAddress();
144 
145     /**
146      * The token does not exist.
147      */
148     error URIQueryForNonexistentToken();
149 
150     struct TokenOwnership {
151         // The address of the owner.
152         address addr;
153         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
154         uint64 startTimestamp;
155         // Whether the token has been burned.
156         bool burned;
157     }
158 
159     /**
160      * @dev Returns the total amount of tokens stored by the contract.
161      *
162      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
163      */
164     function totalSupply() external view returns (uint256);
165 
166     // ==============================
167     //            IERC165
168     // ==============================
169 
170     /**
171      * @dev Returns true if this contract implements the interface defined by
172      * `interfaceId`. See the corresponding
173      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
174      * to learn more about how these ids are created.
175      *
176      * This function call must use less than 30 000 gas.
177      */
178     function supportsInterface(bytes4 interfaceId) external view returns (bool);
179 
180     // ==============================
181     //            IERC721
182     // ==============================
183 
184     /**
185      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
191      */
192     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
193 
194     /**
195      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
196      */
197     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
198 
199     /**
200      * @dev Returns the number of tokens in ``owner``'s account.
201      */
202     function balanceOf(address owner) external view returns (uint256 balance);
203 
204     /**
205      * @dev Returns the owner of the `tokenId` token.
206      *
207      * Requirements:
208      *
209      * - `tokenId` must exist.
210      */
211     function ownerOf(uint256 tokenId) external view returns (address owner);
212 
213     /**
214      * @dev Safely transfers `tokenId` token from `from` to `to`.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must exist and be owned by `from`.
221      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
223      *
224      * Emits a {Transfer} event.
225      */
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId,
230         bytes calldata data
231     ) external;
232 
233     /**
234      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
235      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId
251     ) external;
252 
253     /**
254      * @dev Transfers `tokenId` token from `from` to `to`.
255      *
256      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
257      *
258      * Requirements:
259      *
260      * - `from` cannot be the zero address.
261      * - `to` cannot be the zero address.
262      * - `tokenId` token must be owned by `from`.
263      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
264      *
265      * Emits a {Transfer} event.
266      */
267     function transferFrom(
268         address from,
269         address to,
270         uint256 tokenId
271     ) external;
272 
273     /**
274      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
275      * The approval is cleared when the token is transferred.
276      *
277      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
278      *
279      * Requirements:
280      *
281      * - The caller must own the token or be an approved operator.
282      * - `tokenId` must exist.
283      *
284      * Emits an {Approval} event.
285      */
286     function approve(address to, uint256 tokenId) external;
287 
288     /**
289      * @dev Approve or remove `operator` as an operator for the caller.
290      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
291      *
292      * Requirements:
293      *
294      * - The `operator` cannot be the caller.
295      *
296      * Emits an {ApprovalForAll} event.
297      */
298     function setApprovalForAll(address operator, bool _approved) external;
299 
300     /**
301      * @dev Returns the account approved for `tokenId` token.
302      *
303      * Requirements:
304      *
305      * - `tokenId` must exist.
306      */
307     function getApproved(uint256 tokenId) external view returns (address operator);
308 
309     /**
310      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
311      *
312      * See {setApprovalForAll}
313      */
314     function isApprovedForAll(address owner, address operator) external view returns (bool);
315 
316     // ==============================
317     //        IERC721Metadata
318     // ==============================
319 
320     /**
321      * @dev Returns the token collection name.
322      */
323     function name() external view returns (string memory);
324 
325     /**
326      * @dev Returns the token collection symbol.
327      */
328     function symbol() external view returns (string memory);
329 
330     /**
331      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
332      */
333     function tokenURI(uint256 tokenId) external view returns (string memory);
334 }
335 
336 // File: erc721a/contracts/ERC721A.sol
337 
338 
339 // ERC721A Contracts v4.0.0
340 // Creator: Chiru Labs
341 
342 pragma solidity ^0.8.4;
343 
344 
345 /**
346  * @dev ERC721 token receiver interface.
347  */
348 interface ERC721A__IERC721Receiver {
349     function onERC721Received(
350         address operator,
351         address from,
352         uint256 tokenId,
353         bytes calldata data
354     ) external returns (bytes4);
355 }
356 
357 /**
358  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
359  * the Metadata extension. Built to optimize for lower gas during batch mints.
360  *
361  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
362  *
363  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
364  *
365  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
366  */
367 contract ERC721A is IERC721A {
368     // Mask of an entry in packed address data.
369     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
370 
371     // The bit position of `numberMinted` in packed address data.
372     uint256 private constant BITPOS_NUMBER_MINTED = 64;
373 
374     // The bit position of `numberBurned` in packed address data.
375     uint256 private constant BITPOS_NUMBER_BURNED = 128;
376 
377     // The bit position of `aux` in packed address data.
378     uint256 private constant BITPOS_AUX = 192;
379 
380     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
381     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
382 
383     // The bit position of `startTimestamp` in packed ownership.
384     uint256 private constant BITPOS_START_TIMESTAMP = 160;
385 
386     // The bit mask of the `burned` bit in packed ownership.
387     uint256 private constant BITMASK_BURNED = 1 << 224;
388     
389     // The bit position of the `nextInitialized` bit in packed ownership.
390     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
391 
392     // The bit mask of the `nextInitialized` bit in packed ownership.
393     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
394 
395     // The tokenId of the next token to be minted.
396     uint256 private _currentIndex;
397 
398     // The number of tokens burned.
399     uint256 private _burnCounter;
400 
401     // Token name
402     string private _name;
403 
404     // Token symbol
405     string private _symbol;
406 
407     // Mapping from token ID to ownership details
408     // An empty struct value does not necessarily mean the token is unowned.
409     // See `_packedOwnershipOf` implementation for details.
410     //
411     // Bits Layout:
412     // - [0..159]   `addr`
413     // - [160..223] `startTimestamp`
414     // - [224]      `burned`
415     // - [225]      `nextInitialized`
416     mapping(uint256 => uint256) private _packedOwnerships;
417 
418     // Mapping owner address to address data.
419     //
420     // Bits Layout:
421     // - [0..63]    `balance`
422     // - [64..127]  `numberMinted`
423     // - [128..191] `numberBurned`
424     // - [192..255] `aux`
425     mapping(address => uint256) private _packedAddressData;
426 
427     // Mapping from token ID to approved address.
428     mapping(uint256 => address) private _tokenApprovals;
429 
430     // Mapping from owner to operator approvals
431     mapping(address => mapping(address => bool)) private _operatorApprovals;
432 
433     constructor(string memory name_, string memory symbol_) {
434         _name = name_;
435         _symbol = symbol_;
436         _currentIndex = _startTokenId();
437     }
438 
439     /**
440      * @dev Returns the starting token ID. 
441      * To change the starting token ID, please override this function.
442      */
443     function _startTokenId() internal view virtual returns (uint256) {
444         return 0;
445     }
446 
447     /**
448      * @dev Returns the next token ID to be minted.
449      */
450     function _nextTokenId() internal view returns (uint256) {
451         return _currentIndex;
452     }
453 
454     /**
455      * @dev Returns the total number of tokens in existence.
456      * Burned tokens will reduce the count. 
457      * To get the total number of tokens minted, please see `_totalMinted`.
458      */
459     function totalSupply() public view override returns (uint256) {
460         // Counter underflow is impossible as _burnCounter cannot be incremented
461         // more than `_currentIndex - _startTokenId()` times.
462         unchecked {
463             return _currentIndex - _burnCounter - _startTokenId();
464         }
465     }
466 
467     /**
468      * @dev Returns the total amount of tokens minted in the contract.
469      */
470     function _totalMinted() internal view returns (uint256) {
471         // Counter underflow is impossible as _currentIndex does not decrement,
472         // and it is initialized to `_startTokenId()`
473         unchecked {
474             return _currentIndex - _startTokenId();
475         }
476     }
477 
478     /**
479      * @dev Returns the total number of tokens burned.
480      */
481     function _totalBurned() internal view returns (uint256) {
482         return _burnCounter;
483     }
484 
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         // The interface IDs are constants representing the first 4 bytes of the XOR of
490         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
491         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
492         return
493             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
494             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
495             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
496     }
497 
498     /**
499      * @dev See {IERC721-balanceOf}.
500      */
501     function balanceOf(address owner) public view override returns (uint256) {
502         if (owner == address(0)) revert BalanceQueryForZeroAddress();
503         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the number of tokens minted by `owner`.
508      */
509     function _numberMinted(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the number of tokens burned by or on behalf of `owner`.
515      */
516     function _numberBurned(address owner) internal view returns (uint256) {
517         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
518     }
519 
520     /**
521      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
522      */
523     function _getAux(address owner) internal view returns (uint64) {
524         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
525     }
526 
527     /**
528      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
529      * If there are multiple variables, please pack them into a uint64.
530      */
531     function _setAux(address owner, uint64 aux) internal {
532         uint256 packed = _packedAddressData[owner];
533         uint256 auxCasted;
534         assembly { // Cast aux without masking.
535             auxCasted := aux
536         }
537         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
538         _packedAddressData[owner] = packed;
539     }
540 
541     /**
542      * Returns the packed ownership data of `tokenId`.
543      */
544     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
545         uint256 curr = tokenId;
546 
547         unchecked {
548             if (_startTokenId() <= curr)
549                 if (curr < _currentIndex) {
550                     uint256 packed = _packedOwnerships[curr];
551                     // If not burned.
552                     if (packed & BITMASK_BURNED == 0) {
553                         // Invariant:
554                         // There will always be an ownership that has an address and is not burned
555                         // before an ownership that does not have an address and is not burned.
556                         // Hence, curr will not underflow.
557                         //
558                         // We can directly compare the packed value.
559                         // If the address is zero, packed is zero.
560                         while (packed == 0) {
561                             packed = _packedOwnerships[--curr];
562                         }
563                         return packed;
564                     }
565                 }
566         }
567         revert OwnerQueryForNonexistentToken();
568     }
569 
570     /**
571      * Returns the unpacked `TokenOwnership` struct from `packed`.
572      */
573     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
574         ownership.addr = address(uint160(packed));
575         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
576         ownership.burned = packed & BITMASK_BURNED != 0;
577     }
578 
579     /**
580      * Returns the unpacked `TokenOwnership` struct at `index`.
581      */
582     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
583         return _unpackedOwnership(_packedOwnerships[index]);
584     }
585 
586     /**
587      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
588      */
589     function _initializeOwnershipAt(uint256 index) internal {
590         if (_packedOwnerships[index] == 0) {
591             _packedOwnerships[index] = _packedOwnershipOf(index);
592         }
593     }
594 
595     /**
596      * Gas spent here starts off proportional to the maximum mint batch size.
597      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
598      */
599     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
600         return _unpackedOwnership(_packedOwnershipOf(tokenId));
601     }
602 
603     /**
604      * @dev See {IERC721-ownerOf}.
605      */
606     function ownerOf(uint256 tokenId) public view override returns (address) {
607         return address(uint160(_packedOwnershipOf(tokenId)));
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-name}.
612      */
613     function name() public view virtual override returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-symbol}.
619      */
620     function symbol() public view virtual override returns (string memory) {
621         return _symbol;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-tokenURI}.
626      */
627     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
628         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
629 
630         string memory baseURI = _baseURI();
631         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
632     }
633 
634     /**
635      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
636      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
637      * by default, can be overriden in child contracts.
638      */
639     function _baseURI() internal view virtual returns (string memory) {
640         return '';
641     }
642 
643     /**
644      * @dev Casts the address to uint256 without masking.
645      */
646     function _addressToUint256(address value) private pure returns (uint256 result) {
647         assembly {
648             result := value
649         }
650     }
651 
652     /**
653      * @dev Casts the boolean to uint256 without branching.
654      */
655     function _boolToUint256(bool value) private pure returns (uint256 result) {
656         assembly {
657             result := value
658         }
659     }
660 
661     /**
662      * @dev See {IERC721-approve}.
663      */
664     function approve(address to, uint256 tokenId) public override {
665         address owner = address(uint160(_packedOwnershipOf(tokenId)));
666         if (to == owner) revert ApprovalToCurrentOwner();
667 
668         if (_msgSenderERC721A() != owner)
669             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
670                 revert ApprovalCallerNotOwnerNorApproved();
671             }
672 
673         _tokenApprovals[tokenId] = to;
674         emit Approval(owner, to, tokenId);
675     }
676 
677     /**
678      * @dev See {IERC721-getApproved}.
679      */
680     function getApproved(uint256 tokenId) public view override returns (address) {
681         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
682 
683         return _tokenApprovals[tokenId];
684     }
685 
686     /**
687      * @dev See {IERC721-setApprovalForAll}.
688      */
689     function setApprovalForAll(address operator, bool approved) public virtual override {
690         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
691 
692         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
693         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
694     }
695 
696     /**
697      * @dev See {IERC721-isApprovedForAll}.
698      */
699     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
700         return _operatorApprovals[owner][operator];
701     }
702 
703     /**
704      * @dev See {IERC721-transferFrom}.
705      */
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) public virtual override {
711         _transfer(from, to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-safeTransferFrom}.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         safeTransferFrom(from, to, tokenId, '');
723     }
724 
725     /**
726      * @dev See {IERC721-safeTransferFrom}.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) public virtual override {
734         _transfer(from, to, tokenId);
735         if (to.code.length != 0)
736             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
737                 revert TransferToNonERC721ReceiverImplementer();
738             }
739     }
740 
741     /**
742      * @dev Returns whether `tokenId` exists.
743      *
744      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
745      *
746      * Tokens start existing when they are minted (`_mint`),
747      */
748     function _exists(uint256 tokenId) internal view returns (bool) {
749         return
750             _startTokenId() <= tokenId &&
751             tokenId < _currentIndex && // If within bounds,
752             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
753     }
754 
755     /**
756      * @dev Equivalent to `_safeMint(to, quantity, '')`.
757      */
758     function _safeMint(address to, uint256 quantity) internal {
759         _safeMint(to, quantity, '');
760     }
761 
762     /**
763      * @dev Safely mints `quantity` tokens and transfers them to `to`.
764      *
765      * Requirements:
766      *
767      * - If `to` refers to a smart contract, it must implement
768      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
769      * - `quantity` must be greater than 0.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeMint(
774         address to,
775         uint256 quantity,
776         bytes memory _data
777     ) internal {
778         uint256 startTokenId = _currentIndex;
779         if (to == address(0)) revert MintToZeroAddress();
780         if (quantity == 0) revert MintZeroQuantity();
781 
782         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
783 
784         // Overflows are incredibly unrealistic.
785         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
786         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
787         unchecked {
788             // Updates:
789             // - `balance += quantity`.
790             // - `numberMinted += quantity`.
791             //
792             // We can directly add to the balance and number minted.
793             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
794 
795             // Updates:
796             // - `address` to the owner.
797             // - `startTimestamp` to the timestamp of minting.
798             // - `burned` to `false`.
799             // - `nextInitialized` to `quantity == 1`.
800             _packedOwnerships[startTokenId] =
801                 _addressToUint256(to) |
802                 (block.timestamp << BITPOS_START_TIMESTAMP) |
803                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
804 
805             uint256 updatedIndex = startTokenId;
806             uint256 end = updatedIndex + quantity;
807 
808             if (to.code.length != 0) {
809                 do {
810                     emit Transfer(address(0), to, updatedIndex);
811                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
812                         revert TransferToNonERC721ReceiverImplementer();
813                     }
814                 } while (updatedIndex < end);
815                 // Reentrancy protection
816                 if (_currentIndex != startTokenId) revert();
817             } else {
818                 do {
819                     emit Transfer(address(0), to, updatedIndex++);
820                 } while (updatedIndex < end);
821             }
822             _currentIndex = updatedIndex;
823         }
824         _afterTokenTransfers(address(0), to, startTokenId, quantity);
825     }
826 
827     /**
828      * @dev Mints `quantity` tokens and transfers them to `to`.
829      *
830      * Requirements:
831      *
832      * - `to` cannot be the zero address.
833      * - `quantity` must be greater than 0.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _mint(address to, uint256 quantity) internal {
838         uint256 startTokenId = _currentIndex;
839         if (to == address(0)) revert MintToZeroAddress();
840         if (quantity == 0) revert MintZeroQuantity();
841 
842         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
843 
844         // Overflows are incredibly unrealistic.
845         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
846         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
847         unchecked {
848             // Updates:
849             // - `balance += quantity`.
850             // - `numberMinted += quantity`.
851             //
852             // We can directly add to the balance and number minted.
853             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
854 
855             // Updates:
856             // - `address` to the owner.
857             // - `startTimestamp` to the timestamp of minting.
858             // - `burned` to `false`.
859             // - `nextInitialized` to `quantity == 1`.
860             _packedOwnerships[startTokenId] =
861                 _addressToUint256(to) |
862                 (block.timestamp << BITPOS_START_TIMESTAMP) |
863                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
864 
865             uint256 updatedIndex = startTokenId;
866             uint256 end = updatedIndex + quantity;
867 
868             do {
869                 emit Transfer(address(0), to, updatedIndex++);
870             } while (updatedIndex < end);
871 
872             _currentIndex = updatedIndex;
873         }
874         _afterTokenTransfers(address(0), to, startTokenId, quantity);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *
880      * Requirements:
881      *
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must be owned by `from`.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _transfer(
888         address from,
889         address to,
890         uint256 tokenId
891     ) private {
892         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
893 
894         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
895 
896         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
897             isApprovedForAll(from, _msgSenderERC721A()) ||
898             getApproved(tokenId) == _msgSenderERC721A());
899 
900         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
901         if (to == address(0)) revert TransferToZeroAddress();
902 
903         _beforeTokenTransfers(from, to, tokenId, 1);
904 
905         // Clear approvals from the previous owner.
906         delete _tokenApprovals[tokenId];
907 
908         // Underflow of the sender's balance is impossible because we check for
909         // ownership above and the recipient's balance can't realistically overflow.
910         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
911         unchecked {
912             // We can directly increment and decrement the balances.
913             --_packedAddressData[from]; // Updates: `balance -= 1`.
914             ++_packedAddressData[to]; // Updates: `balance += 1`.
915 
916             // Updates:
917             // - `address` to the next owner.
918             // - `startTimestamp` to the timestamp of transfering.
919             // - `burned` to `false`.
920             // - `nextInitialized` to `true`.
921             _packedOwnerships[tokenId] =
922                 _addressToUint256(to) |
923                 (block.timestamp << BITPOS_START_TIMESTAMP) |
924                 BITMASK_NEXT_INITIALIZED;
925 
926             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
927             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
928                 uint256 nextTokenId = tokenId + 1;
929                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
930                 if (_packedOwnerships[nextTokenId] == 0) {
931                     // If the next slot is within bounds.
932                     if (nextTokenId != _currentIndex) {
933                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
934                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
935                     }
936                 }
937             }
938         }
939 
940         emit Transfer(from, to, tokenId);
941         _afterTokenTransfers(from, to, tokenId, 1);
942     }
943 
944     /**
945      * @dev Equivalent to `_burn(tokenId, false)`.
946      */
947     function _burn(uint256 tokenId) internal virtual {
948         _burn(tokenId, false);
949     }
950 
951     /**
952      * @dev Destroys `tokenId`.
953      * The approval is cleared when the token is burned.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
962         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
963 
964         address from = address(uint160(prevOwnershipPacked));
965 
966         if (approvalCheck) {
967             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
968                 isApprovedForAll(from, _msgSenderERC721A()) ||
969                 getApproved(tokenId) == _msgSenderERC721A());
970 
971             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
972         }
973 
974         _beforeTokenTransfers(from, address(0), tokenId, 1);
975 
976         // Clear approvals from the previous owner.
977         delete _tokenApprovals[tokenId];
978 
979         // Underflow of the sender's balance is impossible because we check for
980         // ownership above and the recipient's balance can't realistically overflow.
981         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
982         unchecked {
983             // Updates:
984             // - `balance -= 1`.
985             // - `numberBurned += 1`.
986             //
987             // We can directly decrement the balance, and increment the number burned.
988             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
989             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
990 
991             // Updates:
992             // - `address` to the last owner.
993             // - `startTimestamp` to the timestamp of burning.
994             // - `burned` to `true`.
995             // - `nextInitialized` to `true`.
996             _packedOwnerships[tokenId] =
997                 _addressToUint256(from) |
998                 (block.timestamp << BITPOS_START_TIMESTAMP) |
999                 BITMASK_BURNED | 
1000                 BITMASK_NEXT_INITIALIZED;
1001 
1002             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1003             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1004                 uint256 nextTokenId = tokenId + 1;
1005                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1006                 if (_packedOwnerships[nextTokenId] == 0) {
1007                     // If the next slot is within bounds.
1008                     if (nextTokenId != _currentIndex) {
1009                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1010                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1011                     }
1012                 }
1013             }
1014         }
1015 
1016         emit Transfer(from, address(0), tokenId);
1017         _afterTokenTransfers(from, address(0), tokenId, 1);
1018 
1019         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1020         unchecked {
1021             _burnCounter++;
1022         }
1023     }
1024 
1025     /**
1026      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1027      *
1028      * @param from address representing the previous owner of the given token ID
1029      * @param to target address that will receive the tokens
1030      * @param tokenId uint256 ID of the token to be transferred
1031      * @param _data bytes optional data to send along with the call
1032      * @return bool whether the call correctly returned the expected magic value
1033      */
1034     function _checkContractOnERC721Received(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) private returns (bool) {
1040         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1041             bytes4 retval
1042         ) {
1043             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1044         } catch (bytes memory reason) {
1045             if (reason.length == 0) {
1046                 revert TransferToNonERC721ReceiverImplementer();
1047             } else {
1048                 assembly {
1049                     revert(add(32, reason), mload(reason))
1050                 }
1051             }
1052         }
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1057      * And also called before burning one token.
1058      *
1059      * startTokenId - the first token id to be transferred
1060      * quantity - the amount to be transferred
1061      *
1062      * Calling conditions:
1063      *
1064      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1065      * transferred to `to`.
1066      * - When `from` is zero, `tokenId` will be minted for `to`.
1067      * - When `to` is zero, `tokenId` will be burned by `from`.
1068      * - `from` and `to` are never both zero.
1069      */
1070     function _beforeTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 
1077     /**
1078      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1079      * minting.
1080      * And also called after one token has been burned.
1081      *
1082      * startTokenId - the first token id to be transferred
1083      * quantity - the amount to be transferred
1084      *
1085      * Calling conditions:
1086      *
1087      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1088      * transferred to `to`.
1089      * - When `from` is zero, `tokenId` has been minted for `to`.
1090      * - When `to` is zero, `tokenId` has been burned by `from`.
1091      * - `from` and `to` are never both zero.
1092      */
1093     function _afterTokenTransfers(
1094         address from,
1095         address to,
1096         uint256 startTokenId,
1097         uint256 quantity
1098     ) internal virtual {}
1099 
1100     /**
1101      * @dev Returns the message sender (defaults to `msg.sender`).
1102      *
1103      * If you are writing GSN compatible contracts, you need to override this function.
1104      */
1105     function _msgSenderERC721A() internal view virtual returns (address) {
1106         return msg.sender;
1107     }
1108 
1109     /**
1110      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1111      */
1112     function _toString(uint256 value) internal pure returns (string memory ptr) {
1113         assembly {
1114             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1115             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1116             // We will need 1 32-byte word to store the length, 
1117             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1118             ptr := add(mload(0x40), 128)
1119             // Update the free memory pointer to allocate.
1120             mstore(0x40, ptr)
1121 
1122             // Cache the end of the memory to calculate the length later.
1123             let end := ptr
1124 
1125             // We write the string from the rightmost digit to the leftmost digit.
1126             // The following is essentially a do-while loop that also handles the zero case.
1127             // Costs a bit more than early returning for the zero case,
1128             // but cheaper in terms of deployment and overall runtime costs.
1129             for { 
1130                 // Initialize and perform the first pass without check.
1131                 let temp := value
1132                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1133                 ptr := sub(ptr, 1)
1134                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1135                 mstore8(ptr, add(48, mod(temp, 10)))
1136                 temp := div(temp, 10)
1137             } temp { 
1138                 // Keep dividing `temp` until zero.
1139                 temp := div(temp, 10)
1140             } { // Body of the for loop.
1141                 ptr := sub(ptr, 1)
1142                 mstore8(ptr, add(48, mod(temp, 10)))
1143             }
1144             
1145             let length := sub(end, ptr)
1146             // Move the pointer 32 bytes leftwards to make room for the length.
1147             ptr := sub(ptr, 32)
1148             // Store the length.
1149             mstore(ptr, length)
1150         }
1151     }
1152 }
1153 
1154 // File: @openzeppelin/contracts/utils/Context.sol
1155 
1156 
1157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 /**
1162  * @dev Provides information about the current execution context, including the
1163  * sender of the transaction and its data. While these are generally available
1164  * via msg.sender and msg.data, they should not be accessed in such a direct
1165  * manner, since when dealing with meta-transactions the account sending and
1166  * paying for execution may not be the actual sender (as far as an application
1167  * is concerned).
1168  *
1169  * This contract is only required for intermediate, library-like contracts.
1170  */
1171 abstract contract Context {
1172     function _msgSender() internal view virtual returns (address) {
1173         return msg.sender;
1174     }
1175 
1176     function _msgData() internal view virtual returns (bytes calldata) {
1177         return msg.data;
1178     }
1179 }
1180 
1181 // File: @openzeppelin/contracts/access/Ownable.sol
1182 
1183 
1184 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 
1189 /**
1190  * @dev Contract module which provides a basic access control mechanism, where
1191  * there is an account (an owner) that can be granted exclusive access to
1192  * specific functions.
1193  *
1194  * By default, the owner account will be the one that deploys the contract. This
1195  * can later be changed with {transferOwnership}.
1196  *
1197  * This module is used through inheritance. It will make available the modifier
1198  * `onlyOwner`, which can be applied to your functions to restrict their use to
1199  * the owner.
1200  */
1201 abstract contract Ownable is Context {
1202     address private _owner;
1203 
1204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1205 
1206     /**
1207      * @dev Initializes the contract setting the deployer as the initial owner.
1208      */
1209     constructor() {
1210         _transferOwnership(_msgSender());
1211     }
1212 
1213     /**
1214      * @dev Returns the address of the current owner.
1215      */
1216     function owner() public view virtual returns (address) {
1217         return _owner;
1218     }
1219 
1220     /**
1221      * @dev Throws if called by any account other than the owner.
1222      */
1223     modifier onlyOwner() {
1224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1225         _;
1226     }
1227 
1228     /**
1229      * @dev Leaves the contract without owner. It will not be possible to call
1230      * `onlyOwner` functions anymore. Can only be called by the current owner.
1231      *
1232      * NOTE: Renouncing ownership will leave the contract without an owner,
1233      * thereby removing any functionality that is only available to the owner.
1234      */
1235     function renounceOwnership() public virtual onlyOwner {
1236         _transferOwnership(address(0));
1237     }
1238 
1239     /**
1240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1241      * Can only be called by the current owner.
1242      */
1243     function transferOwnership(address newOwner) public virtual onlyOwner {
1244         require(newOwner != address(0), "Ownable: new owner is the zero address");
1245         _transferOwnership(newOwner);
1246     }
1247 
1248     /**
1249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1250      * Internal function without access restriction.
1251      */
1252     function _transferOwnership(address newOwner) internal virtual {
1253         address oldOwner = _owner;
1254         _owner = newOwner;
1255         emit OwnershipTransferred(oldOwner, newOwner);
1256     }
1257 }
1258 
1259 
1260 
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 contract SCRY is ERC721A, Ownable {
1265 	using Strings for uint;
1266 	uint public constant SCRY_LIMIT = 10;
1267 	uint public constant MINT_PRICE = 0.0099 ether;
1268 	uint public constant MAX_SUPPLY = 9999;
1269 	address public immutable PAYMENT_ADDRESS;
1270 
1271     bool public isMetadataLocked = false;
1272 	bool public isPaused = false;
1273     string private _baseURL = 'ipfs://QmZ2NTRwtLXgifwUchP58KNj8BLpS11WzvosfJ9tJNeaVV/';
1274 
1275 	constructor(address paymentsAddress_) 
1276 	ERC721A('sorceriestown.wtf', 'SCRY') {
1277         PAYMENT_ADDRESS = paymentsAddress_;
1278     }
1279 
1280 	function _baseURI() internal view override returns (string memory) {
1281 		return _baseURL;
1282 	}
1283 
1284 	function _startTokenId() internal pure override returns (uint) {
1285 		return 1;
1286 	}
1287 
1288     function lockSorceries() external onlyOwner {
1289         isMetadataLocked = true;
1290     }
1291 
1292 	function reveal(string memory url) external onlyOwner {
1293         require(!isMetadataLocked, "locked");
1294 		_baseURL = url;
1295 	}
1296 
1297     function mintedCount(address owner) external view returns (uint256) {
1298         return _numberMinted(owner);
1299     }
1300 
1301 	function withdraw() external onlyOwner {
1302 		uint balance = address(this).balance;
1303 		require(balance > 0, 'broken');
1304 		payable(PAYMENT_ADDRESS).transfer(balance);
1305 	}
1306 
1307 
1308 	function tokenURI(uint tokenId)
1309 		public
1310 		view
1311 		override
1312 		returns (string memory)
1313 	{
1314         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1315 
1316         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1317      
1318 	}
1319 
1320 	function mint(uint count) external payable {
1321 		require(!isPaused, 'Sales are paused');
1322 		require(count <= SCRY_LIMIT,'Your are so thirsty');
1323 		require(_totalMinted() + count <= MAX_SUPPLY,'Sold Out? Sold Out!');
1324 
1325         uint payCount = count;
1326         if(_numberMinted(msg.sender) == 0) {
1327 			payCount--;
1328         }
1329 
1330 		require(
1331 			msg.value >= payCount * MINT_PRICE,
1332 			'Not enough ETH'
1333 		);
1334 
1335 		_safeMint(msg.sender, count);
1336 	}
1337 
1338 	function devAirdrop(address to, uint count) external onlyOwner {
1339 		require(
1340 			_totalMinted() + count <= MAX_SUPPLY,
1341 			'sorceriestown.wtf: Over limit'
1342 		);
1343 		_safeMint(to, count);
1344 	}
1345 
1346     function setPause(bool value) external onlyOwner {
1347 		isPaused = value;
1348 	}
1349 
1350 }