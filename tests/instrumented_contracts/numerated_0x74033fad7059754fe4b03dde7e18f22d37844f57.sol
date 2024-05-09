1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Interface for the NFT Royalty Standard.
39  *
40  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
41  * support for royalty payments across all NFT marketplaces and ecosystem participants.
42  *
43  * _Available since v4.5._
44  */
45 interface IERC2981 is IERC165 {
46     /**
47      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
48      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
49      */
50     function royaltyInfo(uint256 tokenId, uint256 salePrice)
51         external
52         view
53         returns (address receiver, uint256 royaltyAmount);
54 }
55 
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: erc721a/contracts/IERC721A.sol
127 
128 
129 // ERC721A Contracts v4.0.0
130 // Creator: Chiru Labs
131 
132 pragma solidity ^0.8.4;
133 
134 /**
135  * @dev Interface of an ERC721A compliant contract.
136  */
137 interface IERC721A {
138     /**
139      * The caller must own the token or be an approved operator.
140      */
141     error ApprovalCallerNotOwnerNorApproved();
142 
143     /**
144      * The token does not exist.
145      */
146     error ApprovalQueryForNonexistentToken();
147 
148     /**
149      * The caller cannot approve to their own address.
150      */
151     error ApproveToCaller();
152 
153     /**
154      * The caller cannot approve to the current owner.
155      */
156     error ApprovalToCurrentOwner();
157 
158     /**
159      * Cannot query the balance for the zero address.
160      */
161     error BalanceQueryForZeroAddress();
162 
163     /**
164      * Cannot mint to the zero address.
165      */
166     error MintToZeroAddress();
167 
168     /**
169      * The quantity of tokens minted must be more than zero.
170      */
171     error MintZeroQuantity();
172 
173     /**
174      * The token does not exist.
175      */
176     error OwnerQueryForNonexistentToken();
177 
178     /**
179      * The caller must own the token or be an approved operator.
180      */
181     error TransferCallerNotOwnerNorApproved();
182 
183     /**
184      * The token must be owned by `from`.
185      */
186     error TransferFromIncorrectOwner();
187 
188     /**
189      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
190      */
191     error TransferToNonERC721ReceiverImplementer();
192 
193     /**
194      * Cannot transfer to the zero address.
195      */
196     error TransferToZeroAddress();
197 
198     /**
199      * The token does not exist.
200      */
201     error URIQueryForNonexistentToken();
202 
203     struct TokenOwnership {
204         // The address of the owner.
205         address addr;
206         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
207         uint64 startTimestamp;
208         // Whether the token has been burned.
209         bool burned;
210     }
211 
212     /**
213      * @dev Returns the total amount of tokens stored by the contract.
214      *
215      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
216      */
217     function totalSupply() external view returns (uint256);
218 
219     // ==============================
220     //            IERC165
221     // ==============================
222 
223     /**
224      * @dev Returns true if this contract implements the interface defined by
225      * `interfaceId`. See the corresponding
226      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
227      * to learn more about how these ids are created.
228      *
229      * This function call must use less than 30 000 gas.
230      */
231     function supportsInterface(bytes4 interfaceId) external view returns (bool);
232 
233     // ==============================
234     //            IERC721
235     // ==============================
236 
237     /**
238      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
241 
242     /**
243      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
244      */
245     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
246 
247     /**
248      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
249      */
250     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
251 
252     /**
253      * @dev Returns the number of tokens in ``owner``'s account.
254      */
255     function balanceOf(address owner) external view returns (uint256 balance);
256 
257     /**
258      * @dev Returns the owner of the `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function ownerOf(uint256 tokenId) external view returns (address owner);
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must exist and be owned by `from`.
274      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
276      *
277      * Emits a {Transfer} event.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId,
283         bytes calldata data
284     ) external;
285 
286     /**
287      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
288      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
289      *
290      * Requirements:
291      *
292      * - `from` cannot be the zero address.
293      * - `to` cannot be the zero address.
294      * - `tokenId` token must exist and be owned by `from`.
295      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
296      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
297      *
298      * Emits a {Transfer} event.
299      */
300     function safeTransferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external;
305 
306     /**
307      * @dev Transfers `tokenId` token from `from` to `to`.
308      *
309      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
310      *
311      * Requirements:
312      *
313      * - `from` cannot be the zero address.
314      * - `to` cannot be the zero address.
315      * - `tokenId` token must be owned by `from`.
316      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external;
325 
326     /**
327      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
328      * The approval is cleared when the token is transferred.
329      *
330      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
331      *
332      * Requirements:
333      *
334      * - The caller must own the token or be an approved operator.
335      * - `tokenId` must exist.
336      *
337      * Emits an {Approval} event.
338      */
339     function approve(address to, uint256 tokenId) external;
340 
341     /**
342      * @dev Approve or remove `operator` as an operator for the caller.
343      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
344      *
345      * Requirements:
346      *
347      * - The `operator` cannot be the caller.
348      *
349      * Emits an {ApprovalForAll} event.
350      */
351     function setApprovalForAll(address operator, bool _approved) external;
352 
353     /**
354      * @dev Returns the account approved for `tokenId` token.
355      *
356      * Requirements:
357      *
358      * - `tokenId` must exist.
359      */
360     function getApproved(uint256 tokenId) external view returns (address operator);
361 
362     /**
363      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
364      *
365      * See {setApprovalForAll}
366      */
367     function isApprovedForAll(address owner, address operator) external view returns (bool);
368 
369     // ==============================
370     //        IERC721Metadata
371     // ==============================
372 
373     /**
374      * @dev Returns the token collection name.
375      */
376     function name() external view returns (string memory);
377 
378     /**
379      * @dev Returns the token collection symbol.
380      */
381     function symbol() external view returns (string memory);
382 
383     /**
384      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
385      */
386     function tokenURI(uint256 tokenId) external view returns (string memory);
387 }
388 
389 // File: erc721a/contracts/ERC721A.sol
390 
391 
392 // ERC721A Contracts v4.0.0
393 // Creator: Chiru Labs
394 
395 pragma solidity ^0.8.4;
396 
397 
398 /**
399  * @dev ERC721 token receiver interface.
400  */
401 interface ERC721A__IERC721Receiver {
402     function onERC721Received(
403         address operator,
404         address from,
405         uint256 tokenId,
406         bytes calldata data
407     ) external returns (bytes4);
408 }
409 
410 /**
411  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
412  * the Metadata extension. Built to optimize for lower gas during batch mints.
413  *
414  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
415  *
416  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
417  *
418  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
419  */
420 contract ERC721A is IERC721A {
421     // Mask of an entry in packed address data.
422     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
423 
424     // The bit position of `numberMinted` in packed address data.
425     uint256 private constant BITPOS_NUMBER_MINTED = 64;
426 
427     // The bit position of `numberBurned` in packed address data.
428     uint256 private constant BITPOS_NUMBER_BURNED = 128;
429 
430     // The bit position of `aux` in packed address data.
431     uint256 private constant BITPOS_AUX = 192;
432 
433     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
434     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
435 
436     // The bit position of `startTimestamp` in packed ownership.
437     uint256 private constant BITPOS_START_TIMESTAMP = 160;
438 
439     // The bit mask of the `burned` bit in packed ownership.
440     uint256 private constant BITMASK_BURNED = 1 << 224;
441     
442     // The bit position of the `nextInitialized` bit in packed ownership.
443     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
444 
445     // The bit mask of the `nextInitialized` bit in packed ownership.
446     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
447 
448     // The tokenId of the next token to be minted.
449     uint256 private _currentIndex;
450 
451     // The number of tokens burned.
452     uint256 private _burnCounter;
453 
454     // Token name
455     string private _name;
456 
457     // Token symbol
458     string private _symbol;
459 
460     // Mapping from token ID to ownership details
461     // An empty struct value does not necessarily mean the token is unowned.
462     // See `_packedOwnershipOf` implementation for details.
463     //
464     // Bits Layout:
465     // - [0..159]   `addr`
466     // - [160..223] `startTimestamp`
467     // - [224]      `burned`
468     // - [225]      `nextInitialized`
469     mapping(uint256 => uint256) private _packedOwnerships;
470 
471     // Mapping owner address to address data.
472     //
473     // Bits Layout:
474     // - [0..63]    `balance`
475     // - [64..127]  `numberMinted`
476     // - [128..191] `numberBurned`
477     // - [192..255] `aux`
478     mapping(address => uint256) private _packedAddressData;
479 
480     // Mapping from token ID to approved address.
481     mapping(uint256 => address) private _tokenApprovals;
482 
483     // Mapping from owner to operator approvals
484     mapping(address => mapping(address => bool)) private _operatorApprovals;
485 
486     constructor(string memory name_, string memory symbol_) {
487         _name = name_;
488         _symbol = symbol_;
489         _currentIndex = _startTokenId();
490     }
491 
492     /**
493      * @dev Returns the starting token ID. 
494      * To change the starting token ID, please override this function.
495      */
496     function _startTokenId() internal view virtual returns (uint256) {
497         return 0;
498     }
499 
500     /**
501      * @dev Returns the next token ID to be minted.
502      */
503     function _nextTokenId() internal view returns (uint256) {
504         return _currentIndex;
505     }
506 
507     /**
508      * @dev Returns the total number of tokens in existence.
509      * Burned tokens will reduce the count. 
510      * To get the total number of tokens minted, please see `_totalMinted`.
511      */
512     function totalSupply() public view override returns (uint256) {
513         // Counter underflow is impossible as _burnCounter cannot be incremented
514         // more than `_currentIndex - _startTokenId()` times.
515         unchecked {
516             return _currentIndex - _burnCounter - _startTokenId();
517         }
518     }
519 
520     /**
521      * @dev Returns the total amount of tokens minted in the contract.
522      */
523     function _totalMinted() internal view returns (uint256) {
524         // Counter underflow is impossible as _currentIndex does not decrement,
525         // and it is initialized to `_startTokenId()`
526         unchecked {
527             return _currentIndex - _startTokenId();
528         }
529     }
530 
531     /**
532      * @dev Returns the total number of tokens burned.
533      */
534     function _totalBurned() internal view returns (uint256) {
535         return _burnCounter;
536     }
537 
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         // The interface IDs are constants representing the first 4 bytes of the XOR of
543         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
544         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
545         return
546             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
547             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
548             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
549     }
550 
551     /**
552      * @dev See {IERC721-balanceOf}.
553      */
554     function balanceOf(address owner) public view override returns (uint256) {
555         if (owner == address(0)) revert BalanceQueryForZeroAddress();
556         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
557     }
558 
559     /**
560      * Returns the number of tokens minted by `owner`.
561      */
562     function _numberMinted(address owner) internal view returns (uint256) {
563         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
564     }
565 
566     /**
567      * Returns the number of tokens burned by or on behalf of `owner`.
568      */
569     function _numberBurned(address owner) internal view returns (uint256) {
570         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573     /**
574      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
575      */
576     function _getAux(address owner) internal view returns (uint64) {
577         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
578     }
579 
580     /**
581      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
582      * If there are multiple variables, please pack them into a uint64.
583      */
584     function _setAux(address owner, uint64 aux) internal {
585         uint256 packed = _packedAddressData[owner];
586         uint256 auxCasted;
587         assembly { // Cast aux without masking.
588             auxCasted := aux
589         }
590         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
591         _packedAddressData[owner] = packed;
592     }
593 
594     /**
595      * Returns the packed ownership data of `tokenId`.
596      */
597     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
598         uint256 curr = tokenId;
599 
600         unchecked {
601             if (_startTokenId() <= curr)
602                 if (curr < _currentIndex) {
603                     uint256 packed = _packedOwnerships[curr];
604                     // If not burned.
605                     if (packed & BITMASK_BURNED == 0) {
606                         // Invariant:
607                         // There will always be an ownership that has an address and is not burned
608                         // before an ownership that does not have an address and is not burned.
609                         // Hence, curr will not underflow.
610                         //
611                         // We can directly compare the packed value.
612                         // If the address is zero, packed is zero.
613                         while (packed == 0) {
614                             packed = _packedOwnerships[--curr];
615                         }
616                         return packed;
617                     }
618                 }
619         }
620         revert OwnerQueryForNonexistentToken();
621     }
622 
623     /**
624      * Returns the unpacked `TokenOwnership` struct from `packed`.
625      */
626     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
627         ownership.addr = address(uint160(packed));
628         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
629         ownership.burned = packed & BITMASK_BURNED != 0;
630     }
631 
632     /**
633      * Returns the unpacked `TokenOwnership` struct at `index`.
634      */
635     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
636         return _unpackedOwnership(_packedOwnerships[index]);
637     }
638 
639     /**
640      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
641      */
642     function _initializeOwnershipAt(uint256 index) internal {
643         if (_packedOwnerships[index] == 0) {
644             _packedOwnerships[index] = _packedOwnershipOf(index);
645         }
646     }
647 
648     /**
649      * Gas spent here starts off proportional to the maximum mint batch size.
650      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
651      */
652     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
653         return _unpackedOwnership(_packedOwnershipOf(tokenId));
654     }
655 
656     /**
657      * @dev See {IERC721-ownerOf}.
658      */
659     function ownerOf(uint256 tokenId) public view override returns (address) {
660         return address(uint160(_packedOwnershipOf(tokenId)));
661     }
662 
663     /**
664      * @dev See {IERC721Metadata-name}.
665      */
666     function name() public view virtual override returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev See {IERC721Metadata-symbol}.
672      */
673     function symbol() public view virtual override returns (string memory) {
674         return _symbol;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-tokenURI}.
679      */
680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
681         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
682 
683         string memory baseURI = _baseURI();
684         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
685     }
686 
687     /**
688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
690      * by default, can be overriden in child contracts.
691      */
692     function _baseURI() internal view virtual returns (string memory) {
693         return '';
694     }
695 
696     /**
697      * @dev Casts the address to uint256 without masking.
698      */
699     function _addressToUint256(address value) private pure returns (uint256 result) {
700         assembly {
701             result := value
702         }
703     }
704 
705     /**
706      * @dev Casts the boolean to uint256 without branching.
707      */
708     function _boolToUint256(bool value) private pure returns (uint256 result) {
709         assembly {
710             result := value
711         }
712     }
713 
714     /**
715      * @dev See {IERC721-approve}.
716      */
717     function approve(address to, uint256 tokenId) public override {
718         address owner = address(uint160(_packedOwnershipOf(tokenId)));
719         if (to == owner) revert ApprovalToCurrentOwner();
720 
721         if (_msgSenderERC721A() != owner)
722             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
723                 revert ApprovalCallerNotOwnerNorApproved();
724             }
725 
726         _tokenApprovals[tokenId] = to;
727         emit Approval(owner, to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-getApproved}.
732      */
733     function getApproved(uint256 tokenId) public view override returns (address) {
734         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
735 
736         return _tokenApprovals[tokenId];
737     }
738 
739     /**
740      * @dev See {IERC721-setApprovalForAll}.
741      */
742     function setApprovalForAll(address operator, bool approved) public virtual override {
743         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
744 
745         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
746         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
747     }
748 
749     /**
750      * @dev See {IERC721-isApprovedForAll}.
751      */
752     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
753         return _operatorApprovals[owner][operator];
754     }
755 
756     /**
757      * @dev See {IERC721-transferFrom}.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) public virtual override {
764         _transfer(from, to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-safeTransferFrom}.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) public virtual override {
775         safeTransferFrom(from, to, tokenId, '');
776     }
777 
778     /**
779      * @dev See {IERC721-safeTransferFrom}.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) public virtual override {
787         _transfer(from, to, tokenId);
788         if (to.code.length != 0)
789             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
790                 revert TransferToNonERC721ReceiverImplementer();
791             }
792     }
793 
794     /**
795      * @dev Returns whether `tokenId` exists.
796      *
797      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
798      *
799      * Tokens start existing when they are minted (`_mint`),
800      */
801     function _exists(uint256 tokenId) internal view returns (bool) {
802         return
803             _startTokenId() <= tokenId &&
804             tokenId < _currentIndex && // If within bounds,
805             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
806     }
807 
808     /**
809      * @dev Equivalent to `_safeMint(to, quantity, '')`.
810      */
811     function _safeMint(address to, uint256 quantity) internal {
812         _safeMint(to, quantity, '');
813     }
814 
815     /**
816      * @dev Safely mints `quantity` tokens and transfers them to `to`.
817      *
818      * Requirements:
819      *
820      * - If `to` refers to a smart contract, it must implement
821      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
822      * - `quantity` must be greater than 0.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _safeMint(
827         address to,
828         uint256 quantity,
829         bytes memory _data
830     ) internal {
831         uint256 startTokenId = _currentIndex;
832         if (to == address(0)) revert MintToZeroAddress();
833         if (quantity == 0) revert MintZeroQuantity();
834 
835         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
836 
837         // Overflows are incredibly unrealistic.
838         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
839         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
840         unchecked {
841             // Updates:
842             // - `balance += quantity`.
843             // - `numberMinted += quantity`.
844             //
845             // We can directly add to the balance and number minted.
846             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
847 
848             // Updates:
849             // - `address` to the owner.
850             // - `startTimestamp` to the timestamp of minting.
851             // - `burned` to `false`.
852             // - `nextInitialized` to `quantity == 1`.
853             _packedOwnerships[startTokenId] =
854                 _addressToUint256(to) |
855                 (block.timestamp << BITPOS_START_TIMESTAMP) |
856                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
857 
858             uint256 updatedIndex = startTokenId;
859             uint256 end = updatedIndex + quantity;
860 
861             if (to.code.length != 0) {
862                 do {
863                     emit Transfer(address(0), to, updatedIndex);
864                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
865                         revert TransferToNonERC721ReceiverImplementer();
866                     }
867                 } while (updatedIndex < end);
868                 // Reentrancy protection
869                 if (_currentIndex != startTokenId) revert();
870             } else {
871                 do {
872                     emit Transfer(address(0), to, updatedIndex++);
873                 } while (updatedIndex < end);
874             }
875             _currentIndex = updatedIndex;
876         }
877         _afterTokenTransfers(address(0), to, startTokenId, quantity);
878     }
879 
880     /**
881      * @dev Mints `quantity` tokens and transfers them to `to`.
882      *
883      * Requirements:
884      *
885      * - `to` cannot be the zero address.
886      * - `quantity` must be greater than 0.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _mint(address to, uint256 quantity) internal {
891         uint256 startTokenId = _currentIndex;
892         if (to == address(0)) revert MintToZeroAddress();
893         if (quantity == 0) revert MintZeroQuantity();
894 
895         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
896 
897         // Overflows are incredibly unrealistic.
898         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
899         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
900         unchecked {
901             // Updates:
902             // - `balance += quantity`.
903             // - `numberMinted += quantity`.
904             //
905             // We can directly add to the balance and number minted.
906             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
907 
908             // Updates:
909             // - `address` to the owner.
910             // - `startTimestamp` to the timestamp of minting.
911             // - `burned` to `false`.
912             // - `nextInitialized` to `quantity == 1`.
913             _packedOwnerships[startTokenId] =
914                 _addressToUint256(to) |
915                 (block.timestamp << BITPOS_START_TIMESTAMP) |
916                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
917 
918             uint256 updatedIndex = startTokenId;
919             uint256 end = updatedIndex + quantity;
920 
921             do {
922                 emit Transfer(address(0), to, updatedIndex++);
923             } while (updatedIndex < end);
924 
925             _currentIndex = updatedIndex;
926         }
927         _afterTokenTransfers(address(0), to, startTokenId, quantity);
928     }
929 
930     /**
931      * @dev Transfers `tokenId` from `from` to `to`.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must be owned by `from`.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _transfer(
941         address from,
942         address to,
943         uint256 tokenId
944     ) private {
945         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
946 
947         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
948 
949         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
950             isApprovedForAll(from, _msgSenderERC721A()) ||
951             getApproved(tokenId) == _msgSenderERC721A());
952 
953         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
954         if (to == address(0)) revert TransferToZeroAddress();
955 
956         _beforeTokenTransfers(from, to, tokenId, 1);
957 
958         // Clear approvals from the previous owner.
959         delete _tokenApprovals[tokenId];
960 
961         // Underflow of the sender's balance is impossible because we check for
962         // ownership above and the recipient's balance can't realistically overflow.
963         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
964         unchecked {
965             // We can directly increment and decrement the balances.
966             --_packedAddressData[from]; // Updates: `balance -= 1`.
967             ++_packedAddressData[to]; // Updates: `balance += 1`.
968 
969             // Updates:
970             // - `address` to the next owner.
971             // - `startTimestamp` to the timestamp of transfering.
972             // - `burned` to `false`.
973             // - `nextInitialized` to `true`.
974             _packedOwnerships[tokenId] =
975                 _addressToUint256(to) |
976                 (block.timestamp << BITPOS_START_TIMESTAMP) |
977                 BITMASK_NEXT_INITIALIZED;
978 
979             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
980             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
981                 uint256 nextTokenId = tokenId + 1;
982                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
983                 if (_packedOwnerships[nextTokenId] == 0) {
984                     // If the next slot is within bounds.
985                     if (nextTokenId != _currentIndex) {
986                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
987                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
988                     }
989                 }
990             }
991         }
992 
993         emit Transfer(from, to, tokenId);
994         _afterTokenTransfers(from, to, tokenId, 1);
995     }
996 
997     /**
998      * @dev Equivalent to `_burn(tokenId, false)`.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         _burn(tokenId, false);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1015         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1016 
1017         address from = address(uint160(prevOwnershipPacked));
1018 
1019         if (approvalCheck) {
1020             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1021                 isApprovedForAll(from, _msgSenderERC721A()) ||
1022                 getApproved(tokenId) == _msgSenderERC721A());
1023 
1024             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1025         }
1026 
1027         _beforeTokenTransfers(from, address(0), tokenId, 1);
1028 
1029         // Clear approvals from the previous owner.
1030         delete _tokenApprovals[tokenId];
1031 
1032         // Underflow of the sender's balance is impossible because we check for
1033         // ownership above and the recipient's balance can't realistically overflow.
1034         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1035         unchecked {
1036             // Updates:
1037             // - `balance -= 1`.
1038             // - `numberBurned += 1`.
1039             //
1040             // We can directly decrement the balance, and increment the number burned.
1041             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1042             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1043 
1044             // Updates:
1045             // - `address` to the last owner.
1046             // - `startTimestamp` to the timestamp of burning.
1047             // - `burned` to `true`.
1048             // - `nextInitialized` to `true`.
1049             _packedOwnerships[tokenId] =
1050                 _addressToUint256(from) |
1051                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1052                 BITMASK_BURNED | 
1053                 BITMASK_NEXT_INITIALIZED;
1054 
1055             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1056             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1057                 uint256 nextTokenId = tokenId + 1;
1058                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1059                 if (_packedOwnerships[nextTokenId] == 0) {
1060                     // If the next slot is within bounds.
1061                     if (nextTokenId != _currentIndex) {
1062                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1063                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1064                     }
1065                 }
1066             }
1067         }
1068 
1069         emit Transfer(from, address(0), tokenId);
1070         _afterTokenTransfers(from, address(0), tokenId, 1);
1071 
1072         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1073         unchecked {
1074             _burnCounter++;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1080      *
1081      * @param from address representing the previous owner of the given token ID
1082      * @param to target address that will receive the tokens
1083      * @param tokenId uint256 ID of the token to be transferred
1084      * @param _data bytes optional data to send along with the call
1085      * @return bool whether the call correctly returned the expected magic value
1086      */
1087     function _checkContractOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) private returns (bool) {
1093         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1094             bytes4 retval
1095         ) {
1096             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1097         } catch (bytes memory reason) {
1098             if (reason.length == 0) {
1099                 revert TransferToNonERC721ReceiverImplementer();
1100             } else {
1101                 assembly {
1102                     revert(add(32, reason), mload(reason))
1103                 }
1104             }
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1110      * And also called before burning one token.
1111      *
1112      * startTokenId - the first token id to be transferred
1113      * quantity - the amount to be transferred
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, `tokenId` will be burned by `from`.
1121      * - `from` and `to` are never both zero.
1122      */
1123     function _beforeTokenTransfers(
1124         address from,
1125         address to,
1126         uint256 startTokenId,
1127         uint256 quantity
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1132      * minting.
1133      * And also called after one token has been burned.
1134      *
1135      * startTokenId - the first token id to be transferred
1136      * quantity - the amount to be transferred
1137      *
1138      * Calling conditions:
1139      *
1140      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1141      * transferred to `to`.
1142      * - When `from` is zero, `tokenId` has been minted for `to`.
1143      * - When `to` is zero, `tokenId` has been burned by `from`.
1144      * - `from` and `to` are never both zero.
1145      */
1146     function _afterTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 
1153     /**
1154      * @dev Returns the message sender (defaults to `msg.sender`).
1155      *
1156      * If you are writing GSN compatible contracts, you need to override this function.
1157      */
1158     function _msgSenderERC721A() internal view virtual returns (address) {
1159         return msg.sender;
1160     }
1161 
1162     /**
1163      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1164      */
1165     function _toString(uint256 value) internal pure returns (string memory ptr) {
1166         assembly {
1167             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1168             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1169             // We will need 1 32-byte word to store the length, 
1170             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1171             ptr := add(mload(0x40), 128)
1172             // Update the free memory pointer to allocate.
1173             mstore(0x40, ptr)
1174 
1175             // Cache the end of the memory to calculate the length later.
1176             let end := ptr
1177 
1178             // We write the string from the rightmost digit to the leftmost digit.
1179             // The following is essentially a do-while loop that also handles the zero case.
1180             // Costs a bit more than early returning for the zero case,
1181             // but cheaper in terms of deployment and overall runtime costs.
1182             for { 
1183                 // Initialize and perform the first pass without check.
1184                 let temp := value
1185                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1186                 ptr := sub(ptr, 1)
1187                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1188                 mstore8(ptr, add(48, mod(temp, 10)))
1189                 temp := div(temp, 10)
1190             } temp { 
1191                 // Keep dividing `temp` until zero.
1192                 temp := div(temp, 10)
1193             } { // Body of the for loop.
1194                 ptr := sub(ptr, 1)
1195                 mstore8(ptr, add(48, mod(temp, 10)))
1196             }
1197             
1198             let length := sub(end, ptr)
1199             // Move the pointer 32 bytes leftwards to make room for the length.
1200             ptr := sub(ptr, 32)
1201             // Store the length.
1202             mstore(ptr, length)
1203         }
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev Contract module that helps prevent reentrant calls to a function.
1216  *
1217  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1218  * available, which can be applied to functions to make sure there are no nested
1219  * (reentrant) calls to them.
1220  *
1221  * Note that because there is a single `nonReentrant` guard, functions marked as
1222  * `nonReentrant` may not call one another. This can be worked around by making
1223  * those functions `private`, and then adding `external` `nonReentrant` entry
1224  * points to them.
1225  *
1226  * TIP: If you would like to learn more about reentrancy and alternative ways
1227  * to protect against it, check out our blog post
1228  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1229  */
1230 abstract contract ReentrancyGuard {
1231     // Booleans are more expensive than uint256 or any type that takes up a full
1232     // word because each write operation emits an extra SLOAD to first read the
1233     // slot's contents, replace the bits taken up by the boolean, and then write
1234     // back. This is the compiler's defense against contract upgrades and
1235     // pointer aliasing, and it cannot be disabled.
1236 
1237     // The values being non-zero value makes deployment a bit more expensive,
1238     // but in exchange the refund on every call to nonReentrant will be lower in
1239     // amount. Since refunds are capped to a percentage of the total
1240     // transaction's gas, it is best to keep them low in cases like this one, to
1241     // increase the likelihood of the full refund coming into effect.
1242     uint256 private constant _NOT_ENTERED = 1;
1243     uint256 private constant _ENTERED = 2;
1244 
1245     uint256 private _status;
1246 
1247     constructor() {
1248         _status = _NOT_ENTERED;
1249     }
1250 
1251     /**
1252      * @dev Prevents a contract from calling itself, directly or indirectly.
1253      * Calling a `nonReentrant` function from another `nonReentrant`
1254      * function is not supported. It is possible to prevent this from happening
1255      * by making the `nonReentrant` function external, and making it call a
1256      * `private` function that does the actual work.
1257      */
1258     modifier nonReentrant() {
1259         // On the first call to nonReentrant, _notEntered will be true
1260         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1261 
1262         // Any calls to nonReentrant after this point will fail
1263         _status = _ENTERED;
1264 
1265         _;
1266 
1267         // By storing the original value once again, a refund is triggered (see
1268         // https://eips.ethereum.org/EIPS/eip-2200)
1269         _status = _NOT_ENTERED;
1270     }
1271 }
1272 
1273 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1274 
1275 
1276 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1277 
1278 pragma solidity ^0.8.0;
1279 
1280 /**
1281  * @dev These functions deal with verification of Merkle Trees proofs.
1282  *
1283  * The proofs can be generated using the JavaScript library
1284  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1285  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1286  *
1287  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1288  *
1289  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1290  * hashing, or use a hash function other than keccak256 for hashing leaves.
1291  * This is because the concatenation of a sorted pair of internal nodes in
1292  * the merkle tree could be reinterpreted as a leaf value.
1293  */
1294 library MerkleProof {
1295     /**
1296      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1297      * defined by `root`. For this, a `proof` must be provided, containing
1298      * sibling hashes on the branch from the leaf to the root of the tree. Each
1299      * pair of leaves and each pair of pre-images are assumed to be sorted.
1300      */
1301     function verify(
1302         bytes32[] memory proof,
1303         bytes32 root,
1304         bytes32 leaf
1305     ) internal pure returns (bool) {
1306         return processProof(proof, leaf) == root;
1307     }
1308 
1309     /**
1310      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1311      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1312      * hash matches the root of the tree. When processing the proof, the pairs
1313      * of leafs & pre-images are assumed to be sorted.
1314      *
1315      * _Available since v4.4._
1316      */
1317     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1318         bytes32 computedHash = leaf;
1319         for (uint256 i = 0; i < proof.length; i++) {
1320             bytes32 proofElement = proof[i];
1321             if (computedHash <= proofElement) {
1322                 // Hash(current computed hash + current element of the proof)
1323                 computedHash = _efficientHash(computedHash, proofElement);
1324             } else {
1325                 // Hash(current element of the proof + current computed hash)
1326                 computedHash = _efficientHash(proofElement, computedHash);
1327             }
1328         }
1329         return computedHash;
1330     }
1331 
1332     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1333         assembly {
1334             mstore(0x00, a)
1335             mstore(0x20, b)
1336             value := keccak256(0x00, 0x40)
1337         }
1338     }
1339 }
1340 
1341 // File: @openzeppelin/contracts/utils/Address.sol
1342 
1343 
1344 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1345 
1346 pragma solidity ^0.8.1;
1347 
1348 /**
1349  * @dev Collection of functions related to the address type
1350  */
1351 library Address {
1352     /**
1353      * @dev Returns true if `account` is a contract.
1354      *
1355      * [IMPORTANT]
1356      * ====
1357      * It is unsafe to assume that an address for which this function returns
1358      * false is an externally-owned account (EOA) and not a contract.
1359      *
1360      * Among others, `isContract` will return false for the following
1361      * types of addresses:
1362      *
1363      *  - an externally-owned account
1364      *  - a contract in construction
1365      *  - an address where a contract will be created
1366      *  - an address where a contract lived, but was destroyed
1367      * ====
1368      *
1369      * [IMPORTANT]
1370      * ====
1371      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1372      *
1373      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1374      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1375      * constructor.
1376      * ====
1377      */
1378     function isContract(address account) internal view returns (bool) {
1379         // This method relies on extcodesize/address.code.length, which returns 0
1380         // for contracts in construction, since the code is only stored at the end
1381         // of the constructor execution.
1382 
1383         return account.code.length > 0;
1384     }
1385 
1386     /**
1387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1388      * `recipient`, forwarding all available gas and reverting on errors.
1389      *
1390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1392      * imposed by `transfer`, making them unable to receive funds via
1393      * `transfer`. {sendValue} removes this limitation.
1394      *
1395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1396      *
1397      * IMPORTANT: because control is transferred to `recipient`, care must be
1398      * taken to not create reentrancy vulnerabilities. Consider using
1399      * {ReentrancyGuard} or the
1400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1401      */
1402     function sendValue(address payable recipient, uint256 amount) internal {
1403         require(address(this).balance >= amount, "Address: insufficient balance");
1404 
1405         (bool success, ) = recipient.call{value: amount}("");
1406         require(success, "Address: unable to send value, recipient may have reverted");
1407     }
1408 
1409     /**
1410      * @dev Performs a Solidity function call using a low level `call`. A
1411      * plain `call` is an unsafe replacement for a function call: use this
1412      * function instead.
1413      *
1414      * If `target` reverts with a revert reason, it is bubbled up by this
1415      * function (like regular Solidity function calls).
1416      *
1417      * Returns the raw returned data. To convert to the expected return value,
1418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1419      *
1420      * Requirements:
1421      *
1422      * - `target` must be a contract.
1423      * - calling `target` with `data` must not revert.
1424      *
1425      * _Available since v3.1._
1426      */
1427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1428         return functionCall(target, data, "Address: low-level call failed");
1429     }
1430 
1431     /**
1432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1433      * `errorMessage` as a fallback revert reason when `target` reverts.
1434      *
1435      * _Available since v3.1._
1436      */
1437     function functionCall(
1438         address target,
1439         bytes memory data,
1440         string memory errorMessage
1441     ) internal returns (bytes memory) {
1442         return functionCallWithValue(target, data, 0, errorMessage);
1443     }
1444 
1445     /**
1446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1447      * but also transferring `value` wei to `target`.
1448      *
1449      * Requirements:
1450      *
1451      * - the calling contract must have an ETH balance of at least `value`.
1452      * - the called Solidity function must be `payable`.
1453      *
1454      * _Available since v3.1._
1455      */
1456     function functionCallWithValue(
1457         address target,
1458         bytes memory data,
1459         uint256 value
1460     ) internal returns (bytes memory) {
1461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1466      * with `errorMessage` as a fallback revert reason when `target` reverts.
1467      *
1468      * _Available since v3.1._
1469      */
1470     function functionCallWithValue(
1471         address target,
1472         bytes memory data,
1473         uint256 value,
1474         string memory errorMessage
1475     ) internal returns (bytes memory) {
1476         require(address(this).balance >= value, "Address: insufficient balance for call");
1477         require(isContract(target), "Address: call to non-contract");
1478 
1479         (bool success, bytes memory returndata) = target.call{value: value}(data);
1480         return verifyCallResult(success, returndata, errorMessage);
1481     }
1482 
1483     /**
1484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1485      * but performing a static call.
1486      *
1487      * _Available since v3.3._
1488      */
1489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1490         return functionStaticCall(target, data, "Address: low-level static call failed");
1491     }
1492 
1493     /**
1494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1495      * but performing a static call.
1496      *
1497      * _Available since v3.3._
1498      */
1499     function functionStaticCall(
1500         address target,
1501         bytes memory data,
1502         string memory errorMessage
1503     ) internal view returns (bytes memory) {
1504         require(isContract(target), "Address: static call to non-contract");
1505 
1506         (bool success, bytes memory returndata) = target.staticcall(data);
1507         return verifyCallResult(success, returndata, errorMessage);
1508     }
1509 
1510     /**
1511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1512      * but performing a delegate call.
1513      *
1514      * _Available since v3.4._
1515      */
1516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1518     }
1519 
1520     /**
1521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1522      * but performing a delegate call.
1523      *
1524      * _Available since v3.4._
1525      */
1526     function functionDelegateCall(
1527         address target,
1528         bytes memory data,
1529         string memory errorMessage
1530     ) internal returns (bytes memory) {
1531         require(isContract(target), "Address: delegate call to non-contract");
1532 
1533         (bool success, bytes memory returndata) = target.delegatecall(data);
1534         return verifyCallResult(success, returndata, errorMessage);
1535     }
1536 
1537     /**
1538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1539      * revert reason using the provided one.
1540      *
1541      * _Available since v4.3._
1542      */
1543     function verifyCallResult(
1544         bool success,
1545         bytes memory returndata,
1546         string memory errorMessage
1547     ) internal pure returns (bytes memory) {
1548         if (success) {
1549             return returndata;
1550         } else {
1551             // Look for revert reason and bubble it up if present
1552             if (returndata.length > 0) {
1553                 // The easiest way to bubble the revert reason is using memory via assembly
1554 
1555                 assembly {
1556                     let returndata_size := mload(returndata)
1557                     revert(add(32, returndata), returndata_size)
1558                 }
1559             } else {
1560                 revert(errorMessage);
1561             }
1562         }
1563     }
1564 }
1565 
1566 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1567 
1568 
1569 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 /**
1574  * @dev Interface of the ERC20 standard as defined in the EIP.
1575  */
1576 interface IERC20 {
1577     /**
1578      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1579      * another (`to`).
1580      *
1581      * Note that `value` may be zero.
1582      */
1583     event Transfer(address indexed from, address indexed to, uint256 value);
1584 
1585     /**
1586      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1587      * a call to {approve}. `value` is the new allowance.
1588      */
1589     event Approval(address indexed owner, address indexed spender, uint256 value);
1590 
1591     /**
1592      * @dev Returns the amount of tokens in existence.
1593      */
1594     function totalSupply() external view returns (uint256);
1595 
1596     /**
1597      * @dev Returns the amount of tokens owned by `account`.
1598      */
1599     function balanceOf(address account) external view returns (uint256);
1600 
1601     /**
1602      * @dev Moves `amount` tokens from the caller's account to `to`.
1603      *
1604      * Returns a boolean value indicating whether the operation succeeded.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function transfer(address to, uint256 amount) external returns (bool);
1609 
1610     /**
1611      * @dev Returns the remaining number of tokens that `spender` will be
1612      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1613      * zero by default.
1614      *
1615      * This value changes when {approve} or {transferFrom} are called.
1616      */
1617     function allowance(address owner, address spender) external view returns (uint256);
1618 
1619     /**
1620      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1621      *
1622      * Returns a boolean value indicating whether the operation succeeded.
1623      *
1624      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1625      * that someone may use both the old and the new allowance by unfortunate
1626      * transaction ordering. One possible solution to mitigate this race
1627      * condition is to first reduce the spender's allowance to 0 and set the
1628      * desired value afterwards:
1629      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1630      *
1631      * Emits an {Approval} event.
1632      */
1633     function approve(address spender, uint256 amount) external returns (bool);
1634 
1635     /**
1636      * @dev Moves `amount` tokens from `from` to `to` using the
1637      * allowance mechanism. `amount` is then deducted from the caller's
1638      * allowance.
1639      *
1640      * Returns a boolean value indicating whether the operation succeeded.
1641      *
1642      * Emits a {Transfer} event.
1643      */
1644     function transferFrom(
1645         address from,
1646         address to,
1647         uint256 amount
1648     ) external returns (bool);
1649 }
1650 
1651 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1652 
1653 
1654 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1655 
1656 pragma solidity ^0.8.0;
1657 
1658 
1659 
1660 /**
1661  * @title SafeERC20
1662  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1663  * contract returns false). Tokens that return no value (and instead revert or
1664  * throw on failure) are also supported, non-reverting calls are assumed to be
1665  * successful.
1666  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1667  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1668  */
1669 library SafeERC20 {
1670     using Address for address;
1671 
1672     function safeTransfer(
1673         IERC20 token,
1674         address to,
1675         uint256 value
1676     ) internal {
1677         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1678     }
1679 
1680     function safeTransferFrom(
1681         IERC20 token,
1682         address from,
1683         address to,
1684         uint256 value
1685     ) internal {
1686         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1687     }
1688 
1689     /**
1690      * @dev Deprecated. This function has issues similar to the ones found in
1691      * {IERC20-approve}, and its usage is discouraged.
1692      *
1693      * Whenever possible, use {safeIncreaseAllowance} and
1694      * {safeDecreaseAllowance} instead.
1695      */
1696     function safeApprove(
1697         IERC20 token,
1698         address spender,
1699         uint256 value
1700     ) internal {
1701         // safeApprove should only be called when setting an initial allowance,
1702         // or when resetting it to zero. To increase and decrease it, use
1703         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1704         require(
1705             (value == 0) || (token.allowance(address(this), spender) == 0),
1706             "SafeERC20: approve from non-zero to non-zero allowance"
1707         );
1708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1709     }
1710 
1711     function safeIncreaseAllowance(
1712         IERC20 token,
1713         address spender,
1714         uint256 value
1715     ) internal {
1716         uint256 newAllowance = token.allowance(address(this), spender) + value;
1717         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1718     }
1719 
1720     function safeDecreaseAllowance(
1721         IERC20 token,
1722         address spender,
1723         uint256 value
1724     ) internal {
1725         unchecked {
1726             uint256 oldAllowance = token.allowance(address(this), spender);
1727             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1728             uint256 newAllowance = oldAllowance - value;
1729             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1730         }
1731     }
1732 
1733     /**
1734      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1735      * on the return value: the return value is optional (but if data is returned, it must not be false).
1736      * @param token The token targeted by the call.
1737      * @param data The call data (encoded using abi.encode or one of its variants).
1738      */
1739     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1740         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1741         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1742         // the target address contains contract code and also asserts for success in the low-level call.
1743 
1744         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1745         if (returndata.length > 0) {
1746             // Return data is optional
1747             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1748         }
1749     }
1750 }
1751 
1752 // File: @openzeppelin/contracts/utils/Counters.sol
1753 
1754 
1755 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 /**
1760  * @title Counters
1761  * @author Matt Condon (@shrugs)
1762  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1763  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1764  *
1765  * Include with `using Counters for Counters.Counter;`
1766  */
1767 library Counters {
1768     struct Counter {
1769         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1770         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1771         // this feature: see https://github.com/ethereum/solidity/issues/4637
1772         uint256 _value; // default: 0
1773     }
1774 
1775     function current(Counter storage counter) internal view returns (uint256) {
1776         return counter._value;
1777     }
1778 
1779     function increment(Counter storage counter) internal {
1780         unchecked {
1781             counter._value += 1;
1782         }
1783     }
1784 
1785     function decrement(Counter storage counter) internal {
1786         uint256 value = counter._value;
1787         require(value > 0, "Counter: decrement overflow");
1788         unchecked {
1789             counter._value = value - 1;
1790         }
1791     }
1792 
1793     function reset(Counter storage counter) internal {
1794         counter._value = 0;
1795     }
1796 }
1797 
1798 // File: @openzeppelin/contracts/utils/Context.sol
1799 
1800 
1801 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1802 
1803 pragma solidity ^0.8.0;
1804 
1805 /**
1806  * @dev Provides information about the current execution context, including the
1807  * sender of the transaction and its data. While these are generally available
1808  * via msg.sender and msg.data, they should not be accessed in such a direct
1809  * manner, since when dealing with meta-transactions the account sending and
1810  * paying for execution may not be the actual sender (as far as an application
1811  * is concerned).
1812  *
1813  * This contract is only required for intermediate, library-like contracts.
1814  */
1815 abstract contract Context {
1816     function _msgSender() internal view virtual returns (address) {
1817         return msg.sender;
1818     }
1819 
1820     function _msgData() internal view virtual returns (bytes calldata) {
1821         return msg.data;
1822     }
1823 }
1824 
1825 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1826 
1827 
1828 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1829 
1830 pragma solidity ^0.8.0;
1831 
1832 
1833 
1834 
1835 /**
1836  * @title PaymentSplitter
1837  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1838  * that the Ether will be split in this way, since it is handled transparently by the contract.
1839  *
1840  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1841  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1842  * an amount proportional to the percentage of total shares they were assigned.
1843  *
1844  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1845  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1846  * function.
1847  *
1848  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1849  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1850  * to run tests before sending real value to this contract.
1851  */
1852 contract PaymentSplitter is Context {
1853     event PayeeAdded(address account, uint256 shares);
1854     event PaymentReleased(address to, uint256 amount);
1855     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1856     event PaymentReceived(address from, uint256 amount);
1857 
1858     uint256 private _totalShares;
1859     uint256 private _totalReleased;
1860 
1861     mapping(address => uint256) private _shares;
1862     mapping(address => uint256) private _released;
1863     address[] private _payees;
1864 
1865     mapping(IERC20 => uint256) private _erc20TotalReleased;
1866     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1867 
1868     /**
1869      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1870      * the matching position in the `shares` array.
1871      *
1872      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1873      * duplicates in `payees`.
1874      */
1875     constructor(address[] memory payees, uint256[] memory shares_) payable {
1876         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1877         require(payees.length > 0, "PaymentSplitter: no payees");
1878 
1879         for (uint256 i = 0; i < payees.length; i++) {
1880             _addPayee(payees[i], shares_[i]);
1881         }
1882     }
1883 
1884     /**
1885      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1886      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1887      * reliability of the events, and not the actual splitting of Ether.
1888      *
1889      * To learn more about this see the Solidity documentation for
1890      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1891      * functions].
1892      */
1893     receive() external payable virtual {
1894         emit PaymentReceived(_msgSender(), msg.value);
1895     }
1896 
1897     /**
1898      * @dev Getter for the total shares held by payees.
1899      */
1900     function totalShares() public view returns (uint256) {
1901         return _totalShares;
1902     }
1903 
1904     /**
1905      * @dev Getter for the total amount of Ether already released.
1906      */
1907     function totalReleased() public view returns (uint256) {
1908         return _totalReleased;
1909     }
1910 
1911     /**
1912      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1913      * contract.
1914      */
1915     function totalReleased(IERC20 token) public view returns (uint256) {
1916         return _erc20TotalReleased[token];
1917     }
1918 
1919     /**
1920      * @dev Getter for the amount of shares held by an account.
1921      */
1922     function shares(address account) public view returns (uint256) {
1923         return _shares[account];
1924     }
1925 
1926     /**
1927      * @dev Getter for the amount of Ether already released to a payee.
1928      */
1929     function released(address account) public view returns (uint256) {
1930         return _released[account];
1931     }
1932 
1933     /**
1934      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1935      * IERC20 contract.
1936      */
1937     function released(IERC20 token, address account) public view returns (uint256) {
1938         return _erc20Released[token][account];
1939     }
1940 
1941     /**
1942      * @dev Getter for the address of the payee number `index`.
1943      */
1944     function payee(uint256 index) public view returns (address) {
1945         return _payees[index];
1946     }
1947 
1948     /**
1949      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1950      * total shares and their previous withdrawals.
1951      */
1952     function release(address payable account) public virtual {
1953         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1954 
1955         uint256 totalReceived = address(this).balance + totalReleased();
1956         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1957 
1958         require(payment != 0, "PaymentSplitter: account is not due payment");
1959 
1960         _released[account] += payment;
1961         _totalReleased += payment;
1962 
1963         Address.sendValue(account, payment);
1964         emit PaymentReleased(account, payment);
1965     }
1966 
1967     /**
1968      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1969      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1970      * contract.
1971      */
1972     function release(IERC20 token, address account) public virtual {
1973         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1974 
1975         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1976         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1977 
1978         require(payment != 0, "PaymentSplitter: account is not due payment");
1979 
1980         _erc20Released[token][account] += payment;
1981         _erc20TotalReleased[token] += payment;
1982 
1983         SafeERC20.safeTransfer(token, account, payment);
1984         emit ERC20PaymentReleased(token, account, payment);
1985     }
1986 
1987     /**
1988      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1989      * already released amounts.
1990      */
1991     function _pendingPayment(
1992         address account,
1993         uint256 totalReceived,
1994         uint256 alreadyReleased
1995     ) private view returns (uint256) {
1996         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1997     }
1998 
1999     /**
2000      * @dev Add a new payee to the contract.
2001      * @param account The address of the payee to add.
2002      * @param shares_ The number of shares owned by the payee.
2003      */
2004     function _addPayee(address account, uint256 shares_) private {
2005         require(account != address(0), "PaymentSplitter: account is the zero address");
2006         require(shares_ > 0, "PaymentSplitter: shares are 0");
2007         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2008 
2009         _payees.push(account);
2010         _shares[account] = shares_;
2011         _totalShares = _totalShares + shares_;
2012         emit PayeeAdded(account, shares_);
2013     }
2014 }
2015 
2016 // File: @openzeppelin/contracts/access/Ownable.sol
2017 
2018 
2019 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2020 
2021 pragma solidity ^0.8.0;
2022 
2023 
2024 /**
2025  * @dev Contract module which provides a basic access control mechanism, where
2026  * there is an account (an owner) that can be granted exclusive access to
2027  * specific functions.
2028  *
2029  * By default, the owner account will be the one that deploys the contract. This
2030  * can later be changed with {transferOwnership}.
2031  *
2032  * This module is used through inheritance. It will make available the modifier
2033  * `onlyOwner`, which can be applied to your functions to restrict their use to
2034  * the owner.
2035  */
2036 abstract contract Ownable is Context {
2037     address private _owner;
2038 
2039     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2040 
2041     /**
2042      * @dev Initializes the contract setting the deployer as the initial owner.
2043      */
2044     constructor() {
2045         _transferOwnership(_msgSender());
2046     }
2047 
2048     /**
2049      * @dev Returns the address of the current owner.
2050      */
2051     function owner() public view virtual returns (address) {
2052         return _owner;
2053     }
2054 
2055     /**
2056      * @dev Throws if called by any account other than the owner.
2057      */
2058     modifier onlyOwner() {
2059         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2060         _;
2061     }
2062 
2063     /**
2064      * @dev Leaves the contract without owner. It will not be possible to call
2065      * `onlyOwner` functions anymore. Can only be called by the current owner.
2066      *
2067      * NOTE: Renouncing ownership will leave the contract without an owner,
2068      * thereby removing any functionality that is only available to the owner.
2069      */
2070     function renounceOwnership() public virtual onlyOwner {
2071         _transferOwnership(address(0));
2072     }
2073 
2074     /**
2075      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2076      * Can only be called by the current owner.
2077      */
2078     function transferOwnership(address newOwner) public virtual onlyOwner {
2079         require(newOwner != address(0), "Ownable: new owner is the zero address");
2080         _transferOwnership(newOwner);
2081     }
2082 
2083     /**
2084      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2085      * Internal function without access restriction.
2086      */
2087     function _transferOwnership(address newOwner) internal virtual {
2088         address oldOwner = _owner;
2089         _owner = newOwner;
2090         emit OwnershipTransferred(oldOwner, newOwner);
2091     }
2092 }
2093 
2094 // File: Demorgussy.sol
2095 
2096 
2097 pragma solidity ^0.8.2;
2098 
2099 
2100 
2101 
2102 
2103 
2104 
2105 
2106 
2107 contract Demorgussy is ERC721A, IERC2981, Ownable, ReentrancyGuard {
2108     using Strings for uint256;
2109     uint256 public constant MAX_SUPPLY = 6699;
2110     bool public _publicSaleStarted = false;
2111     string public baseURI;
2112     address public royaltyAddress;
2113 
2114     constructor()
2115         ERC721A("Demorgussy", "DMGY")
2116     {}
2117 
2118     function setBaseURI(string memory _URI) public onlyOwner {
2119         baseURI = _URI;
2120     }
2121 
2122     function flipPublicSaleStarted() public onlyOwner {
2123         _publicSaleStarted = !_publicSaleStarted;
2124     }
2125 
2126     function numberMinted(address owner) public view returns (uint256) {
2127         return _numberMinted(owner);
2128     }
2129 
2130     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
2131         royaltyAddress = _royaltyAddress;
2132     }
2133 
2134     function checkMaxSupply(uint256 amount) view private {
2135         require(totalSupply() + amount <= MAX_SUPPLY, "Will exceed maximum supply");
2136     }
2137 
2138     function publicMintToken() public nonReentrant {
2139         require(_publicSaleStarted, "Sale must be active to mint tokens");
2140         checkMaxSupply(2);
2141         _safeMint(msg.sender, 2);
2142     }
2143 
2144     function ownerMint(address to, uint256 amount) public onlyOwner {
2145         checkMaxSupply(amount);
2146         _safeMint(to, amount);
2147     }
2148 
2149     function tokenURI(uint256 tokenId)
2150         public
2151         view
2152         virtual
2153         override
2154         returns (string memory)
2155     {
2156         require(
2157             _exists(tokenId),
2158             "URI query for nonexistent token"
2159         );
2160         return string(abi.encodePacked(baseURI,Strings.toString(tokenId),'.json'));
2161     }
2162 
2163     // ERC165
2164     function supportsInterface(bytes4 interfaceId) public view override(ERC721A, IERC165) returns (bool) {
2165         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2166     }
2167 
2168     // IERC2981
2169     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) override external view returns (address, uint256 royaltyAmount) {
2170         _tokenId; // silence solc warning
2171         royaltyAmount = (_salePrice / 100) * 7;
2172         return (royaltyAddress, royaltyAmount);
2173     }
2174 
2175     function _startTokenId() override internal view virtual returns (uint256) {
2176         return 1;
2177     }
2178 }