1 // SPDX-License-Identifier: MIT
2 // File: contracts/RoRo.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-05-25
6 */
7 
8 // File: @openzeppelin/contracts/utils/Strings.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: erc721a/contracts/IERC721A.sol
79 
80 
81 // ERC721A Contracts v4.0.0
82 // Creator: Chiru Labs
83 
84 pragma solidity ^0.8.4;
85 
86 /**
87  * @dev Interface of an ERC721A compliant contract.
88  */
89 interface IERC721A {
90     /**
91      * The caller must own the token or be an approved operator.
92      */
93     error ApprovalCallerNotOwnerNorApproved();
94 
95     /**
96      * The token does not exist.
97      */
98     error ApprovalQueryForNonexistentToken();
99 
100     /**
101      * The caller cannot approve to their own address.
102      */
103     error ApproveToCaller();
104 
105     /**
106      * The caller cannot approve to the current owner.
107      */
108     error ApprovalToCurrentOwner();
109 
110     /**
111      * Cannot query the balance for the zero address.
112      */
113     error BalanceQueryForZeroAddress();
114 
115     /**
116      * Cannot mint to the zero address.
117      */
118     error MintToZeroAddress();
119 
120     /**
121      * The quantity of tokens minted must be more than zero.
122      */
123     error MintZeroQuantity();
124 
125     /**
126      * The token does not exist.
127      */
128     error OwnerQueryForNonexistentToken();
129 
130     /**
131      * The caller must own the token or be an approved operator.
132      */
133     error TransferCallerNotOwnerNorApproved();
134 
135     /**
136      * The token must be owned by `from`.
137      */
138     error TransferFromIncorrectOwner();
139 
140     /**
141      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
142      */
143     error TransferToNonERC721ReceiverImplementer();
144 
145     /**
146      * Cannot transfer to the zero address.
147      */
148     error TransferToZeroAddress();
149 
150     /**
151      * The token does not exist.
152      */
153     error URIQueryForNonexistentToken();
154 
155     struct TokenOwnership {
156         // The address of the owner.
157         address addr;
158         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
159         uint64 startTimestamp;
160         // Whether the token has been burned.
161         bool burned;
162     }
163 
164     /**
165      * @dev Returns the total amount of tokens stored by the contract.
166      *
167      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     // ==============================
172     //            IERC165
173     // ==============================
174 
175     /**
176      * @dev Returns true if this contract implements the interface defined by
177      * `interfaceId`. See the corresponding
178      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
179      * to learn more about how these ids are created.
180      *
181      * This function call must use less than 30 000 gas.
182      */
183     function supportsInterface(bytes4 interfaceId) external view returns (bool);
184 
185     // ==============================
186     //            IERC721
187     // ==============================
188 
189     /**
190      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
193 
194     /**
195      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
196      */
197     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
198 
199     /**
200      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
201      */
202     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
203 
204     /**
205      * @dev Returns the number of tokens in ``owner``'s account.
206      */
207     function balanceOf(address owner) external view returns (uint256 balance);
208 
209     /**
210      * @dev Returns the owner of the `tokenId` token.
211      *
212      * Requirements:
213      *
214      * - `tokenId` must exist.
215      */
216     function ownerOf(uint256 tokenId) external view returns (address owner);
217 
218     /**
219      * @dev Safely transfers `tokenId` token from `from` to `to`.
220      *
221      * Requirements:
222      *
223      * - `from` cannot be the zero address.
224      * - `to` cannot be the zero address.
225      * - `tokenId` token must exist and be owned by `from`.
226      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
227      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
228      *
229      * Emits a {Transfer} event.
230      */
231     function safeTransferFrom(
232         address from,
233         address to,
234         uint256 tokenId,
235         bytes calldata data
236     ) external;
237 
238     /**
239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external;
257 
258     /**
259      * @dev Transfers `tokenId` token from `from` to `to`.
260      *
261      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must be owned by `from`.
268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transferFrom(
273         address from,
274         address to,
275         uint256 tokenId
276     ) external;
277 
278     /**
279      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
280      * The approval is cleared when the token is transferred.
281      *
282      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
283      *
284      * Requirements:
285      *
286      * - The caller must own the token or be an approved operator.
287      * - `tokenId` must exist.
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address to, uint256 tokenId) external;
292 
293     /**
294      * @dev Approve or remove `operator` as an operator for the caller.
295      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
296      *
297      * Requirements:
298      *
299      * - The `operator` cannot be the caller.
300      *
301      * Emits an {ApprovalForAll} event.
302      */
303     function setApprovalForAll(address operator, bool _approved) external;
304 
305     /**
306      * @dev Returns the account approved for `tokenId` token.
307      *
308      * Requirements:
309      *
310      * - `tokenId` must exist.
311      */
312     function getApproved(uint256 tokenId) external view returns (address operator);
313 
314     /**
315      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
316      *
317      * See {setApprovalForAll}
318      */
319     function isApprovedForAll(address owner, address operator) external view returns (bool);
320 
321     // ==============================
322     //        IERC721Metadata
323     // ==============================
324 
325     /**
326      * @dev Returns the token collection name.
327      */
328     function name() external view returns (string memory);
329 
330     /**
331      * @dev Returns the token collection symbol.
332      */
333     function symbol() external view returns (string memory);
334 
335     /**
336      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
337      */
338     function tokenURI(uint256 tokenId) external view returns (string memory);
339 }
340 
341 // File: erc721a/contracts/ERC721A.sol
342 
343 
344 // ERC721A Contracts v4.0.0
345 // Creator: Chiru Labs
346 
347 pragma solidity ^0.8.4;
348 
349 
350 /**
351  * @dev ERC721 token receiver interface.
352  */
353 interface ERC721A__IERC721Receiver {
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 /**
363  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
364  * the Metadata extension. Built to optimize for lower gas during batch mints.
365  *
366  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
367  *
368  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
369  *
370  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
371  */
372 contract ERC721A is IERC721A {
373     // Mask of an entry in packed address data.
374     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
375 
376     // The bit position of `numberMinted` in packed address data.
377     uint256 private constant BITPOS_NUMBER_MINTED = 64;
378 
379     // The bit position of `numberBurned` in packed address data.
380     uint256 private constant BITPOS_NUMBER_BURNED = 128;
381 
382     // The bit position of `aux` in packed address data.
383     uint256 private constant BITPOS_AUX = 192;
384 
385     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
386     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
387 
388     // The bit position of `startTimestamp` in packed ownership.
389     uint256 private constant BITPOS_START_TIMESTAMP = 160;
390 
391     // The bit mask of the `burned` bit in packed ownership.
392     uint256 private constant BITMASK_BURNED = 1 << 224;
393     
394     // The bit position of the `nextInitialized` bit in packed ownership.
395     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
396 
397     // The bit mask of the `nextInitialized` bit in packed ownership.
398     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
399 
400     // The tokenId of the next token to be minted.
401     uint256 private _currentIndex;
402 
403     // The number of tokens burned.
404     uint256 private _burnCounter;
405 
406     // Token name
407     string private _name;
408 
409     // Token symbol
410     string private _symbol;
411 
412     // Mapping from token ID to ownership details
413     // An empty struct value does not necessarily mean the token is unowned.
414     // See `_packedOwnershipOf` implementation for details.
415     //
416     // Bits Layout:
417     // - [0..159]   `addr`
418     // - [160..223] `startTimestamp`
419     // - [224]      `burned`
420     // - [225]      `nextInitialized`
421     mapping(uint256 => uint256) private _packedOwnerships;
422 
423     // Mapping owner address to address data.
424     //
425     // Bits Layout:
426     // - [0..63]    `balance`
427     // - [64..127]  `numberMinted`
428     // - [128..191] `numberBurned`
429     // - [192..255] `aux`
430     mapping(address => uint256) private _packedAddressData;
431 
432     // Mapping from token ID to approved address.
433     mapping(uint256 => address) private _tokenApprovals;
434 
435     // Mapping from owner to operator approvals
436     mapping(address => mapping(address => bool)) private _operatorApprovals;
437 
438     constructor(string memory name_, string memory symbol_) {
439         _name = name_;
440         _symbol = symbol_;
441         _currentIndex = _startTokenId();
442     }
443 
444     /**
445      * @dev Returns the starting token ID. 
446      * To change the starting token ID, please override this function.
447      */
448     function _startTokenId() internal view virtual returns (uint256) {
449         return 0;
450     }
451 
452     /**
453      * @dev Returns the next token ID to be minted.
454      */
455     function _nextTokenId() internal view returns (uint256) {
456         return _currentIndex;
457     }
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count. 
462      * To get the total number of tokens minted, please see `_totalMinted`.
463      */
464     function totalSupply() public view override returns (uint256) {
465         // Counter underflow is impossible as _burnCounter cannot be incremented
466         // more than `_currentIndex - _startTokenId()` times.
467         unchecked {
468             return _currentIndex - _burnCounter - _startTokenId();
469         }
470     }
471 
472     /**
473      * @dev Returns the total amount of tokens minted in the contract.
474      */
475     function _totalMinted() internal view returns (uint256) {
476         // Counter underflow is impossible as _currentIndex does not decrement,
477         // and it is initialized to `_startTokenId()`
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483     /**
484      * @dev Returns the total number of tokens burned.
485      */
486     function _totalBurned() internal view returns (uint256) {
487         return _burnCounter;
488     }
489 
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         // The interface IDs are constants representing the first 4 bytes of the XOR of
495         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
496         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
497         return
498             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
499             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
500             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
501     }
502 
503     /**
504      * @dev See {IERC721-balanceOf}.
505      */
506     function balanceOf(address owner) public view override returns (uint256) {
507         if (owner == address(0)) revert BalanceQueryForZeroAddress();
508         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the number of tokens minted by `owner`.
513      */
514     function _numberMinted(address owner) internal view returns (uint256) {
515         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
516     }
517 
518     /**
519      * Returns the number of tokens burned by or on behalf of `owner`.
520      */
521     function _numberBurned(address owner) internal view returns (uint256) {
522         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
523     }
524 
525     /**
526      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
527      */
528     function _getAux(address owner) internal view returns (uint64) {
529         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
530     }
531 
532     /**
533      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
534      * If there are multiple variables, please pack them into a uint64.
535      */
536     function _setAux(address owner, uint64 aux) internal {
537         uint256 packed = _packedAddressData[owner];
538         uint256 auxCasted;
539         assembly { // Cast aux without masking.
540             auxCasted := aux
541         }
542         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
543         _packedAddressData[owner] = packed;
544     }
545 
546     /**
547      * Returns the packed ownership data of `tokenId`.
548      */
549     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
550         uint256 curr = tokenId;
551 
552         unchecked {
553             if (_startTokenId() <= curr)
554                 if (curr < _currentIndex) {
555                     uint256 packed = _packedOwnerships[curr];
556                     // If not burned.
557                     if (packed & BITMASK_BURNED == 0) {
558                         // Invariant:
559                         // There will always be an ownership that has an address and is not burned
560                         // before an ownership that does not have an address and is not burned.
561                         // Hence, curr will not underflow.
562                         //
563                         // We can directly compare the packed value.
564                         // If the address is zero, packed is zero.
565                         while (packed == 0) {
566                             packed = _packedOwnerships[--curr];
567                         }
568                         return packed;
569                     }
570                 }
571         }
572         revert OwnerQueryForNonexistentToken();
573     }
574 
575     /**
576      * Returns the unpacked `TokenOwnership` struct from `packed`.
577      */
578     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
579         ownership.addr = address(uint160(packed));
580         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
581         ownership.burned = packed & BITMASK_BURNED != 0;
582     }
583 
584     /**
585      * Returns the unpacked `TokenOwnership` struct at `index`.
586      */
587     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
588         return _unpackedOwnership(_packedOwnerships[index]);
589     }
590 
591     /**
592      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
593      */
594     function _initializeOwnershipAt(uint256 index) internal {
595         if (_packedOwnerships[index] == 0) {
596             _packedOwnerships[index] = _packedOwnershipOf(index);
597         }
598     }
599 
600     /**
601      * Gas spent here starts off proportional to the maximum mint batch size.
602      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
603      */
604     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
605         return _unpackedOwnership(_packedOwnershipOf(tokenId));
606     }
607 
608     /**
609      * @dev See {IERC721-ownerOf}.
610      */
611     function ownerOf(uint256 tokenId) public view override returns (address) {
612         return address(uint160(_packedOwnershipOf(tokenId)));
613     }
614 
615     /**
616      * @dev See {IERC721Metadata-name}.
617      */
618     function name() public view virtual override returns (string memory) {
619         return _name;
620     }
621 
622     /**
623      * @dev See {IERC721Metadata-symbol}.
624      */
625     function symbol() public view virtual override returns (string memory) {
626         return _symbol;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-tokenURI}.
631      */
632     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
633         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
634 
635         string memory baseURI = _baseURI();
636         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
637     }
638 
639     /**
640      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
641      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
642      * by default, can be overriden in child contracts.
643      */
644     function _baseURI() internal view virtual returns (string memory) {
645         return '';
646     }
647 
648     /**
649      * @dev Casts the address to uint256 without masking.
650      */
651     function _addressToUint256(address value) private pure returns (uint256 result) {
652         assembly {
653             result := value
654         }
655     }
656 
657     /**
658      * @dev Casts the boolean to uint256 without branching.
659      */
660     function _boolToUint256(bool value) private pure returns (uint256 result) {
661         assembly {
662             result := value
663         }
664     }
665 
666     /**
667      * @dev See {IERC721-approve}.
668      */
669     function approve(address to, uint256 tokenId) public override {
670         address owner = address(uint160(_packedOwnershipOf(tokenId)));
671         if (to == owner) revert ApprovalToCurrentOwner();
672 
673         if (_msgSenderERC721A() != owner)
674             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
675                 revert ApprovalCallerNotOwnerNorApproved();
676             }
677 
678         _tokenApprovals[tokenId] = to;
679         emit Approval(owner, to, tokenId);
680     }
681 
682     /**
683      * @dev See {IERC721-getApproved}.
684      */
685     function getApproved(uint256 tokenId) public view override returns (address) {
686         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
687 
688         return _tokenApprovals[tokenId];
689     }
690 
691     /**
692      * @dev See {IERC721-setApprovalForAll}.
693      */
694     function setApprovalForAll(address operator, bool approved) public virtual override {
695         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
696 
697         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
698         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
699     }
700 
701     /**
702      * @dev See {IERC721-isApprovedForAll}.
703      */
704     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
705         return _operatorApprovals[owner][operator];
706     }
707 
708     /**
709      * @dev See {IERC721-transferFrom}.
710      */
711     function transferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         _transfer(from, to, tokenId);
717     }
718 
719     /**
720      * @dev See {IERC721-safeTransferFrom}.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) public virtual override {
727         safeTransferFrom(from, to, tokenId, '');
728     }
729 
730     /**
731      * @dev See {IERC721-safeTransferFrom}.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes memory _data
738     ) public virtual override {
739         _transfer(from, to, tokenId);
740         if (to.code.length != 0)
741             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
742                 revert TransferToNonERC721ReceiverImplementer();
743             }
744     }
745 
746     /**
747      * @dev Returns whether `tokenId` exists.
748      *
749      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
750      *
751      * Tokens start existing when they are minted (`_mint`),
752      */
753     function _exists(uint256 tokenId) internal view returns (bool) {
754         return
755             _startTokenId() <= tokenId &&
756             tokenId < _currentIndex && // If within bounds,
757             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
758     }
759 
760     /**
761      * @dev Equivalent to `_safeMint(to, quantity, '')`.
762      */
763     function _safeMint(address to, uint256 quantity) internal {
764         _safeMint(to, quantity, '');
765     }
766 
767     /**
768      * @dev Safely mints `quantity` tokens and transfers them to `to`.
769      *
770      * Requirements:
771      *
772      * - If `to` refers to a smart contract, it must implement
773      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
774      * - `quantity` must be greater than 0.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeMint(
779         address to,
780         uint256 quantity,
781         bytes memory _data
782     ) internal {
783         uint256 startTokenId = _currentIndex;
784         if (to == address(0)) revert MintToZeroAddress();
785         if (quantity == 0) revert MintZeroQuantity();
786 
787         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
788 
789         // Overflows are incredibly unrealistic.
790         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
791         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
792         unchecked {
793             // Updates:
794             // - `balance += quantity`.
795             // - `numberMinted += quantity`.
796             //
797             // We can directly add to the balance and number minted.
798             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
799 
800             // Updates:
801             // - `address` to the owner.
802             // - `startTimestamp` to the timestamp of minting.
803             // - `burned` to `false`.
804             // - `nextInitialized` to `quantity == 1`.
805             _packedOwnerships[startTokenId] =
806                 _addressToUint256(to) |
807                 (block.timestamp << BITPOS_START_TIMESTAMP) |
808                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
809 
810             uint256 updatedIndex = startTokenId;
811             uint256 end = updatedIndex + quantity;
812 
813             if (to.code.length != 0) {
814                 do {
815                     emit Transfer(address(0), to, updatedIndex);
816                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
817                         revert TransferToNonERC721ReceiverImplementer();
818                     }
819                 } while (updatedIndex < end);
820                 // Reentrancy protection
821                 if (_currentIndex != startTokenId) revert();
822             } else {
823                 do {
824                     emit Transfer(address(0), to, updatedIndex++);
825                 } while (updatedIndex < end);
826             }
827             _currentIndex = updatedIndex;
828         }
829         _afterTokenTransfers(address(0), to, startTokenId, quantity);
830     }
831 
832     /**
833      * @dev Mints `quantity` tokens and transfers them to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `quantity` must be greater than 0.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _mint(address to, uint256 quantity) internal {
843         uint256 startTokenId = _currentIndex;
844         if (to == address(0)) revert MintToZeroAddress();
845         if (quantity == 0) revert MintZeroQuantity();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         // Overflows are incredibly unrealistic.
850         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
851         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
852         unchecked {
853             // Updates:
854             // - `balance += quantity`.
855             // - `numberMinted += quantity`.
856             //
857             // We can directly add to the balance and number minted.
858             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
859 
860             // Updates:
861             // - `address` to the owner.
862             // - `startTimestamp` to the timestamp of minting.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `quantity == 1`.
865             _packedOwnerships[startTokenId] =
866                 _addressToUint256(to) |
867                 (block.timestamp << BITPOS_START_TIMESTAMP) |
868                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
869 
870             uint256 updatedIndex = startTokenId;
871             uint256 end = updatedIndex + quantity;
872 
873             do {
874                 emit Transfer(address(0), to, updatedIndex++);
875             } while (updatedIndex < end);
876 
877             _currentIndex = updatedIndex;
878         }
879         _afterTokenTransfers(address(0), to, startTokenId, quantity);
880     }
881 
882     /**
883      * @dev Transfers `tokenId` from `from` to `to`.
884      *
885      * Requirements:
886      *
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must be owned by `from`.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _transfer(
893         address from,
894         address to,
895         uint256 tokenId
896     ) private {
897         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
898 
899         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
900 
901         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
902             isApprovedForAll(from, _msgSenderERC721A()) ||
903             getApproved(tokenId) == _msgSenderERC721A());
904 
905         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
906         if (to == address(0)) revert TransferToZeroAddress();
907 
908         _beforeTokenTransfers(from, to, tokenId, 1);
909 
910         // Clear approvals from the previous owner.
911         delete _tokenApprovals[tokenId];
912 
913         // Underflow of the sender's balance is impossible because we check for
914         // ownership above and the recipient's balance can't realistically overflow.
915         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
916         unchecked {
917             // We can directly increment and decrement the balances.
918             --_packedAddressData[from]; // Updates: `balance -= 1`.
919             ++_packedAddressData[to]; // Updates: `balance += 1`.
920 
921             // Updates:
922             // - `address` to the next owner.
923             // - `startTimestamp` to the timestamp of transfering.
924             // - `burned` to `false`.
925             // - `nextInitialized` to `true`.
926             _packedOwnerships[tokenId] =
927                 _addressToUint256(to) |
928                 (block.timestamp << BITPOS_START_TIMESTAMP) |
929                 BITMASK_NEXT_INITIALIZED;
930 
931             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
932             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
933                 uint256 nextTokenId = tokenId + 1;
934                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
935                 if (_packedOwnerships[nextTokenId] == 0) {
936                     // If the next slot is within bounds.
937                     if (nextTokenId != _currentIndex) {
938                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
939                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
940                     }
941                 }
942             }
943         }
944 
945         emit Transfer(from, to, tokenId);
946         _afterTokenTransfers(from, to, tokenId, 1);
947     }
948 
949     /**
950      * @dev Equivalent to `_burn(tokenId, false)`.
951      */
952     function _burn(uint256 tokenId) internal virtual {
953         _burn(tokenId, false);
954     }
955 
956     /**
957      * @dev Destroys `tokenId`.
958      * The approval is cleared when the token is burned.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
967         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
968 
969         address from = address(uint160(prevOwnershipPacked));
970 
971         if (approvalCheck) {
972             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
973                 isApprovedForAll(from, _msgSenderERC721A()) ||
974                 getApproved(tokenId) == _msgSenderERC721A());
975 
976             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
977         }
978 
979         _beforeTokenTransfers(from, address(0), tokenId, 1);
980 
981         // Clear approvals from the previous owner.
982         delete _tokenApprovals[tokenId];
983 
984         // Underflow of the sender's balance is impossible because we check for
985         // ownership above and the recipient's balance can't realistically overflow.
986         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
987         unchecked {
988             // Updates:
989             // - `balance -= 1`.
990             // - `numberBurned += 1`.
991             //
992             // We can directly decrement the balance, and increment the number burned.
993             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
994             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
995 
996             // Updates:
997             // - `address` to the last owner.
998             // - `startTimestamp` to the timestamp of burning.
999             // - `burned` to `true`.
1000             // - `nextInitialized` to `true`.
1001             _packedOwnerships[tokenId] =
1002                 _addressToUint256(from) |
1003                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1004                 BITMASK_BURNED | 
1005                 BITMASK_NEXT_INITIALIZED;
1006 
1007             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1008             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1009                 uint256 nextTokenId = tokenId + 1;
1010                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1011                 if (_packedOwnerships[nextTokenId] == 0) {
1012                     // If the next slot is within bounds.
1013                     if (nextTokenId != _currentIndex) {
1014                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1015                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1016                     }
1017                 }
1018             }
1019         }
1020 
1021         emit Transfer(from, address(0), tokenId);
1022         _afterTokenTransfers(from, address(0), tokenId, 1);
1023 
1024         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1025         unchecked {
1026             _burnCounter++;
1027         }
1028     }
1029 
1030     /**
1031      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1032      *
1033      * @param from address representing the previous owner of the given token ID
1034      * @param to target address that will receive the tokens
1035      * @param tokenId uint256 ID of the token to be transferred
1036      * @param _data bytes optional data to send along with the call
1037      * @return bool whether the call correctly returned the expected magic value
1038      */
1039     function _checkContractOnERC721Received(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) private returns (bool) {
1045         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1046             bytes4 retval
1047         ) {
1048             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1049         } catch (bytes memory reason) {
1050             if (reason.length == 0) {
1051                 revert TransferToNonERC721ReceiverImplementer();
1052             } else {
1053                 assembly {
1054                     revert(add(32, reason), mload(reason))
1055                 }
1056             }
1057         }
1058     }
1059 
1060     /**
1061      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1062      * And also called before burning one token.
1063      *
1064      * startTokenId - the first token id to be transferred
1065      * quantity - the amount to be transferred
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, `tokenId` will be burned by `from`.
1073      * - `from` and `to` are never both zero.
1074      */
1075     function _beforeTokenTransfers(
1076         address from,
1077         address to,
1078         uint256 startTokenId,
1079         uint256 quantity
1080     ) internal virtual {}
1081 
1082     /**
1083      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1084      * minting.
1085      * And also called after one token has been burned.
1086      *
1087      * startTokenId - the first token id to be transferred
1088      * quantity - the amount to be transferred
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` has been minted for `to`.
1095      * - When `to` is zero, `tokenId` has been burned by `from`.
1096      * - `from` and `to` are never both zero.
1097      */
1098     function _afterTokenTransfers(
1099         address from,
1100         address to,
1101         uint256 startTokenId,
1102         uint256 quantity
1103     ) internal virtual {}
1104 
1105     /**
1106      * @dev Returns the message sender (defaults to `msg.sender`).
1107      *
1108      * If you are writing GSN compatible contracts, you need to override this function.
1109      */
1110     function _msgSenderERC721A() internal view virtual returns (address) {
1111         return msg.sender;
1112     }
1113 
1114     /**
1115      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1116      */
1117     function _toString(uint256 value) internal pure returns (string memory ptr) {
1118         assembly {
1119             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1120             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1121             // We will need 1 32-byte word to store the length, 
1122             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1123             ptr := add(mload(0x40), 128)
1124             // Update the free memory pointer to allocate.
1125             mstore(0x40, ptr)
1126 
1127             // Cache the end of the memory to calculate the length later.
1128             let end := ptr
1129 
1130             // We write the string from the rightmost digit to the leftmost digit.
1131             // The following is essentially a do-while loop that also handles the zero case.
1132             // Costs a bit more than early returning for the zero case,
1133             // but cheaper in terms of deployment and overall runtime costs.
1134             for { 
1135                 // Initialize and perform the first pass without check.
1136                 let temp := value
1137                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1138                 ptr := sub(ptr, 1)
1139                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1140                 mstore8(ptr, add(48, mod(temp, 10)))
1141                 temp := div(temp, 10)
1142             } temp { 
1143                 // Keep dividing `temp` until zero.
1144                 temp := div(temp, 10)
1145             } { // Body of the for loop.
1146                 ptr := sub(ptr, 1)
1147                 mstore8(ptr, add(48, mod(temp, 10)))
1148             }
1149             
1150             let length := sub(end, ptr)
1151             // Move the pointer 32 bytes leftwards to make room for the length.
1152             ptr := sub(ptr, 32)
1153             // Store the length.
1154             mstore(ptr, length)
1155         }
1156     }
1157 }
1158 
1159 // File: @openzeppelin/contracts/utils/Context.sol
1160 
1161 
1162 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @dev Provides information about the current execution context, including the
1168  * sender of the transaction and its data. While these are generally available
1169  * via msg.sender and msg.data, they should not be accessed in such a direct
1170  * manner, since when dealing with meta-transactions the account sending and
1171  * paying for execution may not be the actual sender (as far as an application
1172  * is concerned).
1173  *
1174  * This contract is only required for intermediate, library-like contracts.
1175  */
1176 abstract contract Context {
1177     function _msgSender() internal view virtual returns (address) {
1178         return msg.sender;
1179     }
1180 
1181     function _msgData() internal view virtual returns (bytes calldata) {
1182         return msg.data;
1183     }
1184 }
1185 
1186 // File: @openzeppelin/contracts/access/Ownable.sol
1187 
1188 
1189 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _transferOwnership(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Returns the address of the current owner.
1220      */
1221     function owner() public view virtual returns (address) {
1222         return _owner;
1223     }
1224 
1225     /**
1226      * @dev Throws if called by any account other than the owner.
1227      */
1228     modifier onlyOwner() {
1229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Leaves the contract without owner. It will not be possible to call
1235      * `onlyOwner` functions anymore. Can only be called by the current owner.
1236      *
1237      * NOTE: Renouncing ownership will leave the contract without an owner,
1238      * thereby removing any functionality that is only available to the owner.
1239      */
1240     function renounceOwnership() public virtual onlyOwner {
1241         _transferOwnership(address(0));
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Can only be called by the current owner.
1247      */
1248     function transferOwnership(address newOwner) public virtual onlyOwner {
1249         require(newOwner != address(0), "Ownable: new owner is the zero address");
1250         _transferOwnership(newOwner);
1251     }
1252 
1253     /**
1254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1255      * Internal function without access restriction.
1256      */
1257     function _transferOwnership(address newOwner) internal virtual {
1258         address oldOwner = _owner;
1259         _owner = newOwner;
1260         emit OwnershipTransferred(oldOwner, newOwner);
1261     }
1262 }
1263 
1264 // File: contracts/RoRo.sol
1265 
1266 
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 
1272 
1273 contract RoRo is ERC721A, Ownable {
1274 	using Strings for uint;
1275 
1276 	uint public constant MAX_SUPPLY = 6666;
1277 	uint public constant RORO_LIMIT = 20;
1278 	uint public constant MINT_PRICE = 0.015 ether;
1279 	
1280 	address public immutable PAYMENT_PROCESSOR;
1281 
1282     bool public isMetadataLocked = false;
1283 	bool public isPaused = false;
1284     string private _baseURL;
1285 	string public prerevealURL = 'ipfs://QmTBGGU954NiMnrvf2KzWAHaHmXVAuruJMtBL3N5TTwpYL/hidden.json';
1286 	mapping(address => uint) private _roroWhisperCount;
1287 
1288 	constructor(address paymentsAddress_) 
1289 	ERC721A('RoRo', 'RR') {
1290         PAYMENT_PROCESSOR = paymentsAddress_;
1291     }
1292 
1293 	function _baseURI() internal view override returns (string memory) {
1294 		return _baseURL;
1295 	}
1296 
1297 	function _startTokenId() internal pure override returns (uint) {
1298 		return 1;
1299 	}
1300 
1301     function lockMetadata() external onlyOwner {
1302         isMetadataLocked = true;
1303     }
1304 
1305 	function reveal(string memory url) external onlyOwner {
1306         require(!isMetadataLocked, "RoRo: Metadata is finalized");
1307 		_baseURL = url;
1308 	}
1309 
1310     function mintedCount(address owner) external view returns (uint) {
1311         return _roroWhisperCount[owner];
1312     }
1313 
1314 
1315 	function setPause(bool value) external onlyOwner {
1316 		isPaused = value;
1317 	}
1318 
1319 	function withdraw() external onlyOwner {
1320 		uint balance = address(this).balance;
1321 		require(balance > 0, 'Nothing to Withdraw');
1322 		payable(PAYMENT_PROCESSOR).transfer(balance);
1323 	}
1324 
1325 	function airdrop(address to, uint count) external onlyOwner {
1326 		require(
1327 			_totalMinted() + count <= MAX_SUPPLY,
1328 			'RoRo: Over limit'
1329 		);
1330 		_safeMint(to, count);
1331 	}
1332 
1333 	function tokenURI(uint tokenId)
1334 		public
1335 		view
1336 		override
1337 		returns (string memory)
1338 	{
1339         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1340 
1341         return bytes(_baseURI()).length > 0 
1342             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1343             : prerevealURL;
1344 	}
1345 
1346 	function mint(uint count) external payable {
1347 		require(!isPaused, 'RoRo: Sales are off');
1348 		require(count <= RORO_LIMIT,'RoRo: Over limit');
1349 		require(_totalMinted() + count <= MAX_SUPPLY,'RoRo: Over limit');
1350 
1351         uint payForCount = count;
1352         if(_roroWhisperCount[msg.sender] == 0) {
1353 			payForCount--;
1354         }
1355 
1356 		require(
1357 			msg.value >= payForCount * MINT_PRICE,
1358 			'RoRo: Ether value sent is not sufficient'
1359 		);
1360 
1361 		_roroWhisperCount[msg.sender] += count;
1362 		_safeMint(msg.sender, count);
1363 	}
1364 	
1365 }