1 /*
2  Larkin - @CodeLarkin - codelarkin.eth
3  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
4  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
5  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
6  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
7  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
8  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.14;
13 
14 // Sources flattened with hardhat v2.9.6 https://hardhat.org
15 
16 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
20 
21 
22 
23 /**
24  * @dev Interface of the ERC165 standard, as defined in the
25  * https://eips.ethereum.org/EIPS/eip-165[EIP].
26  *
27  * Implementers can declare support of contract interfaces, which can then be
28  * queried by others ({ERC165Checker}).
29  *
30  * For an implementation, see {ERC165}.
31  */
32 interface IERC165 {
33     /**
34      * @dev Returns true if this contract implements the interface defined by
35      * `interfaceId`. See the corresponding
36      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
37      * to learn more about how these ids are created.
38      *
39      * This function call must use less than 30 000 gas.
40      */
41     function supportsInterface(bytes4 interfaceId) external view returns (bool);
42 }
43 
44 
45 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
46 
47 
48 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
49 
50 
51 
52 /**
53  * @dev Interface for the NFT Royalty Standard.
54  *
55  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
56  * support for royalty payments across all NFT marketplaces and ecosystem participants.
57  *
58  * _Available since v4.5._
59  */
60 interface IERC2981 is IERC165 {
61     /**
62      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
63      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
64      */
65     function royaltyInfo(uint256 tokenId, uint256 salePrice)
66         external
67         view
68         returns (address receiver, uint256 royaltyAmount);
69 }
70 
71 
72 // File erc721a/contracts/IERC721A.sol@v4.0.0
73 
74 
75 // ERC721A Contracts v4.0.0
76 // Creator: Chiru Labs
77 
78 
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
335 
336 // File erc721a/contracts/ERC721A.sol@v4.0.0
337 
338 
339 // ERC721A Contracts v4.0.0
340 // Creator: Chiru Labs
341 
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
1153 
1154 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
1155 
1156 
1157 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1158 
1159 
1160 
1161 /**
1162  * @dev Interface of the ERC20 standard as defined in the EIP.
1163  */
1164 interface IERC20 {
1165     /**
1166      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1167      * another (`to`).
1168      *
1169      * Note that `value` may be zero.
1170      */
1171     event Transfer(address indexed from, address indexed to, uint256 value);
1172 
1173     /**
1174      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1175      * a call to {approve}. `value` is the new allowance.
1176      */
1177     event Approval(address indexed owner, address indexed spender, uint256 value);
1178 
1179     /**
1180      * @dev Returns the amount of tokens in existence.
1181      */
1182     function totalSupply() external view returns (uint256);
1183 
1184     /**
1185      * @dev Returns the amount of tokens owned by `account`.
1186      */
1187     function balanceOf(address account) external view returns (uint256);
1188 
1189     /**
1190      * @dev Moves `amount` tokens from the caller's account to `to`.
1191      *
1192      * Returns a boolean value indicating whether the operation succeeded.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function transfer(address to, uint256 amount) external returns (bool);
1197 
1198     /**
1199      * @dev Returns the remaining number of tokens that `spender` will be
1200      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1201      * zero by default.
1202      *
1203      * This value changes when {approve} or {transferFrom} are called.
1204      */
1205     function allowance(address owner, address spender) external view returns (uint256);
1206 
1207     /**
1208      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1209      *
1210      * Returns a boolean value indicating whether the operation succeeded.
1211      *
1212      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1213      * that someone may use both the old and the new allowance by unfortunate
1214      * transaction ordering. One possible solution to mitigate this race
1215      * condition is to first reduce the spender's allowance to 0 and set the
1216      * desired value afterwards:
1217      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1218      *
1219      * Emits an {Approval} event.
1220      */
1221     function approve(address spender, uint256 amount) external returns (bool);
1222 
1223     /**
1224      * @dev Moves `amount` tokens from `from` to `to` using the
1225      * allowance mechanism. `amount` is then deducted from the caller's
1226      * allowance.
1227      *
1228      * Returns a boolean value indicating whether the operation succeeded.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function transferFrom(
1233         address from,
1234         address to,
1235         uint256 amount
1236     ) external returns (bool);
1237 }
1238 
1239 
1240 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1241 
1242 
1243 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1244 
1245 
1246 
1247 /**
1248  * @dev Provides information about the current execution context, including the
1249  * sender of the transaction and its data. While these are generally available
1250  * via msg.sender and msg.data, they should not be accessed in such a direct
1251  * manner, since when dealing with meta-transactions the account sending and
1252  * paying for execution may not be the actual sender (as far as an application
1253  * is concerned).
1254  *
1255  * This contract is only required for intermediate, library-like contracts.
1256  */
1257 abstract contract Context {
1258     function _msgSender() internal view virtual returns (address) {
1259         return msg.sender;
1260     }
1261 
1262     function _msgData() internal view virtual returns (bytes calldata) {
1263         return msg.data;
1264     }
1265 }
1266 
1267 
1268 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1269 
1270 
1271 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1272 
1273 
1274 
1275 /**
1276  * @dev Contract module which provides a basic access control mechanism, where
1277  * there is an account (an owner) that can be granted exclusive access to
1278  * specific functions.
1279  *
1280  * By default, the owner account will be the one that deploys the contract. This
1281  * can later be changed with {transferOwnership}.
1282  *
1283  * This module is used through inheritance. It will make available the modifier
1284  * `onlyOwner`, which can be applied to your functions to restrict their use to
1285  * the owner.
1286  */
1287 abstract contract Ownable is Context {
1288     address private _owner;
1289 
1290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1291 
1292     /**
1293      * @dev Initializes the contract setting the deployer as the initial owner.
1294      */
1295     constructor() {
1296         _transferOwnership(_msgSender());
1297     }
1298 
1299     /**
1300      * @dev Returns the address of the current owner.
1301      */
1302     function owner() public view virtual returns (address) {
1303         return _owner;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _transferOwnership(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(newOwner != address(0), "Ownable: new owner is the zero address");
1331         _transferOwnership(newOwner);
1332     }
1333 
1334     /**
1335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1336      * Internal function without access restriction.
1337      */
1338     function _transferOwnership(address newOwner) internal virtual {
1339         address oldOwner = _owner;
1340         _owner = newOwner;
1341         emit OwnershipTransferred(oldOwner, newOwner);
1342     }
1343 }
1344 
1345 
1346 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
1347 
1348 
1349 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1350 
1351 
1352 
1353 /**
1354  * @dev Collection of functions related to the address type
1355  */
1356 library Address {
1357     /**
1358      * @dev Returns true if `account` is a contract.
1359      *
1360      * [IMPORTANT]
1361      * ====
1362      * It is unsafe to assume that an address for which this function returns
1363      * false is an externally-owned account (EOA) and not a contract.
1364      *
1365      * Among others, `isContract` will return false for the following
1366      * types of addresses:
1367      *
1368      *  - an externally-owned account
1369      *  - a contract in construction
1370      *  - an address where a contract will be created
1371      *  - an address where a contract lived, but was destroyed
1372      * ====
1373      *
1374      * [IMPORTANT]
1375      * ====
1376      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1377      *
1378      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1379      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1380      * constructor.
1381      * ====
1382      */
1383     function isContract(address account) internal view returns (bool) {
1384         // This method relies on extcodesize/address.code.length, which returns 0
1385         // for contracts in construction, since the code is only stored at the end
1386         // of the constructor execution.
1387 
1388         return account.code.length > 0;
1389     }
1390 
1391     /**
1392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1393      * `recipient`, forwarding all available gas and reverting on errors.
1394      *
1395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1397      * imposed by `transfer`, making them unable to receive funds via
1398      * `transfer`. {sendValue} removes this limitation.
1399      *
1400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1401      *
1402      * IMPORTANT: because control is transferred to `recipient`, care must be
1403      * taken to not create reentrancy vulnerabilities. Consider using
1404      * {ReentrancyGuard} or the
1405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1406      */
1407     function sendValue(address payable recipient, uint256 amount) internal {
1408         require(address(this).balance >= amount, "Address: insufficient balance");
1409 
1410         (bool success, ) = recipient.call{value: amount}("");
1411         require(success, "Address: unable to send value, recipient may have reverted");
1412     }
1413 
1414     /**
1415      * @dev Performs a Solidity function call using a low level `call`. A
1416      * plain `call` is an unsafe replacement for a function call: use this
1417      * function instead.
1418      *
1419      * If `target` reverts with a revert reason, it is bubbled up by this
1420      * function (like regular Solidity function calls).
1421      *
1422      * Returns the raw returned data. To convert to the expected return value,
1423      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1424      *
1425      * Requirements:
1426      *
1427      * - `target` must be a contract.
1428      * - calling `target` with `data` must not revert.
1429      *
1430      * _Available since v3.1._
1431      */
1432     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1433         return functionCall(target, data, "Address: low-level call failed");
1434     }
1435 
1436     /**
1437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1438      * `errorMessage` as a fallback revert reason when `target` reverts.
1439      *
1440      * _Available since v3.1._
1441      */
1442     function functionCall(
1443         address target,
1444         bytes memory data,
1445         string memory errorMessage
1446     ) internal returns (bytes memory) {
1447         return functionCallWithValue(target, data, 0, errorMessage);
1448     }
1449 
1450     /**
1451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1452      * but also transferring `value` wei to `target`.
1453      *
1454      * Requirements:
1455      *
1456      * - the calling contract must have an ETH balance of at least `value`.
1457      * - the called Solidity function must be `payable`.
1458      *
1459      * _Available since v3.1._
1460      */
1461     function functionCallWithValue(
1462         address target,
1463         bytes memory data,
1464         uint256 value
1465     ) internal returns (bytes memory) {
1466         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1467     }
1468 
1469     /**
1470      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1471      * with `errorMessage` as a fallback revert reason when `target` reverts.
1472      *
1473      * _Available since v3.1._
1474      */
1475     function functionCallWithValue(
1476         address target,
1477         bytes memory data,
1478         uint256 value,
1479         string memory errorMessage
1480     ) internal returns (bytes memory) {
1481         require(address(this).balance >= value, "Address: insufficient balance for call");
1482         require(isContract(target), "Address: call to non-contract");
1483 
1484         (bool success, bytes memory returndata) = target.call{value: value}(data);
1485         return verifyCallResult(success, returndata, errorMessage);
1486     }
1487 
1488     /**
1489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1490      * but performing a static call.
1491      *
1492      * _Available since v3.3._
1493      */
1494     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1495         return functionStaticCall(target, data, "Address: low-level static call failed");
1496     }
1497 
1498     /**
1499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1500      * but performing a static call.
1501      *
1502      * _Available since v3.3._
1503      */
1504     function functionStaticCall(
1505         address target,
1506         bytes memory data,
1507         string memory errorMessage
1508     ) internal view returns (bytes memory) {
1509         require(isContract(target), "Address: static call to non-contract");
1510 
1511         (bool success, bytes memory returndata) = target.staticcall(data);
1512         return verifyCallResult(success, returndata, errorMessage);
1513     }
1514 
1515     /**
1516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1517      * but performing a delegate call.
1518      *
1519      * _Available since v3.4._
1520      */
1521     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1522         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1523     }
1524 
1525     /**
1526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1527      * but performing a delegate call.
1528      *
1529      * _Available since v3.4._
1530      */
1531     function functionDelegateCall(
1532         address target,
1533         bytes memory data,
1534         string memory errorMessage
1535     ) internal returns (bytes memory) {
1536         require(isContract(target), "Address: delegate call to non-contract");
1537 
1538         (bool success, bytes memory returndata) = target.delegatecall(data);
1539         return verifyCallResult(success, returndata, errorMessage);
1540     }
1541 
1542     /**
1543      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1544      * revert reason using the provided one.
1545      *
1546      * _Available since v4.3._
1547      */
1548     function verifyCallResult(
1549         bool success,
1550         bytes memory returndata,
1551         string memory errorMessage
1552     ) internal pure returns (bytes memory) {
1553         if (success) {
1554             return returndata;
1555         } else {
1556             // Look for revert reason and bubble it up if present
1557             if (returndata.length > 0) {
1558                 // The easiest way to bubble the revert reason is using memory via assembly
1559 
1560                 assembly {
1561                     let returndata_size := mload(returndata)
1562                     revert(add(32, returndata), returndata_size)
1563                 }
1564             } else {
1565                 revert(errorMessage);
1566             }
1567         }
1568     }
1569 }
1570 
1571 
1572 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1573 
1574 
1575 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1576 
1577 
1578 
1579 /**
1580  * @dev String operations.
1581  */
1582 library Strings {
1583     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1584 
1585     /**
1586      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1587      */
1588     function toString(uint256 value) internal pure returns (string memory) {
1589         // Inspired by OraclizeAPI's implementation - MIT licence
1590         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1591 
1592         if (value == 0) {
1593             return "0";
1594         }
1595         uint256 temp = value;
1596         uint256 digits;
1597         while (temp != 0) {
1598             digits++;
1599             temp /= 10;
1600         }
1601         bytes memory buffer = new bytes(digits);
1602         while (value != 0) {
1603             digits -= 1;
1604             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1605             value /= 10;
1606         }
1607         return string(buffer);
1608     }
1609 
1610     /**
1611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1612      */
1613     function toHexString(uint256 value) internal pure returns (string memory) {
1614         if (value == 0) {
1615             return "0x00";
1616         }
1617         uint256 temp = value;
1618         uint256 length = 0;
1619         while (temp != 0) {
1620             length++;
1621             temp >>= 8;
1622         }
1623         return toHexString(value, length);
1624     }
1625 
1626     /**
1627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1628      */
1629     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1630         bytes memory buffer = new bytes(2 * length + 2);
1631         buffer[0] = "0";
1632         buffer[1] = "x";
1633         for (uint256 i = 2 * length + 1; i > 1; --i) {
1634             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1635             value >>= 4;
1636         }
1637         require(value == 0, "Strings: hex length insufficient");
1638         return string(buffer);
1639     }
1640 }
1641 
1642 
1643 // File hardhat/console.sol@v2.9.6
1644 
1645 
1646 
1647 
1648 library console {
1649 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1650 
1651 	function _sendLogPayload(bytes memory payload) private view {
1652 		uint256 payloadLength = payload.length;
1653 		address consoleAddress = CONSOLE_ADDRESS;
1654 		assembly {
1655 			let payloadStart := add(payload, 32)
1656 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1657 		}
1658 	}
1659 
1660 	function log() internal view {
1661 		_sendLogPayload(abi.encodeWithSignature("log()"));
1662 	}
1663 
1664 	function logInt(int p0) internal view {
1665 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1666 	}
1667 
1668 	function logUint(uint p0) internal view {
1669 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1670 	}
1671 
1672 	function logString(string memory p0) internal view {
1673 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1674 	}
1675 
1676 	function logBool(bool p0) internal view {
1677 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1678 	}
1679 
1680 	function logAddress(address p0) internal view {
1681 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1682 	}
1683 
1684 	function logBytes(bytes memory p0) internal view {
1685 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1686 	}
1687 
1688 	function logBytes1(bytes1 p0) internal view {
1689 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1690 	}
1691 
1692 	function logBytes2(bytes2 p0) internal view {
1693 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1694 	}
1695 
1696 	function logBytes3(bytes3 p0) internal view {
1697 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1698 	}
1699 
1700 	function logBytes4(bytes4 p0) internal view {
1701 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1702 	}
1703 
1704 	function logBytes5(bytes5 p0) internal view {
1705 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1706 	}
1707 
1708 	function logBytes6(bytes6 p0) internal view {
1709 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1710 	}
1711 
1712 	function logBytes7(bytes7 p0) internal view {
1713 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1714 	}
1715 
1716 	function logBytes8(bytes8 p0) internal view {
1717 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1718 	}
1719 
1720 	function logBytes9(bytes9 p0) internal view {
1721 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1722 	}
1723 
1724 	function logBytes10(bytes10 p0) internal view {
1725 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1726 	}
1727 
1728 	function logBytes11(bytes11 p0) internal view {
1729 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1730 	}
1731 
1732 	function logBytes12(bytes12 p0) internal view {
1733 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1734 	}
1735 
1736 	function logBytes13(bytes13 p0) internal view {
1737 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1738 	}
1739 
1740 	function logBytes14(bytes14 p0) internal view {
1741 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1742 	}
1743 
1744 	function logBytes15(bytes15 p0) internal view {
1745 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1746 	}
1747 
1748 	function logBytes16(bytes16 p0) internal view {
1749 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1750 	}
1751 
1752 	function logBytes17(bytes17 p0) internal view {
1753 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1754 	}
1755 
1756 	function logBytes18(bytes18 p0) internal view {
1757 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1758 	}
1759 
1760 	function logBytes19(bytes19 p0) internal view {
1761 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1762 	}
1763 
1764 	function logBytes20(bytes20 p0) internal view {
1765 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1766 	}
1767 
1768 	function logBytes21(bytes21 p0) internal view {
1769 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1770 	}
1771 
1772 	function logBytes22(bytes22 p0) internal view {
1773 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1774 	}
1775 
1776 	function logBytes23(bytes23 p0) internal view {
1777 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1778 	}
1779 
1780 	function logBytes24(bytes24 p0) internal view {
1781 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1782 	}
1783 
1784 	function logBytes25(bytes25 p0) internal view {
1785 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1786 	}
1787 
1788 	function logBytes26(bytes26 p0) internal view {
1789 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1790 	}
1791 
1792 	function logBytes27(bytes27 p0) internal view {
1793 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1794 	}
1795 
1796 	function logBytes28(bytes28 p0) internal view {
1797 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1798 	}
1799 
1800 	function logBytes29(bytes29 p0) internal view {
1801 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1802 	}
1803 
1804 	function logBytes30(bytes30 p0) internal view {
1805 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
1806 	}
1807 
1808 	function logBytes31(bytes31 p0) internal view {
1809 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
1810 	}
1811 
1812 	function logBytes32(bytes32 p0) internal view {
1813 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
1814 	}
1815 
1816 	function log(uint p0) internal view {
1817 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1818 	}
1819 
1820 	function log(string memory p0) internal view {
1821 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1822 	}
1823 
1824 	function log(bool p0) internal view {
1825 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1826 	}
1827 
1828 	function log(address p0) internal view {
1829 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1830 	}
1831 
1832 	function log(uint p0, uint p1) internal view {
1833 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
1834 	}
1835 
1836 	function log(uint p0, string memory p1) internal view {
1837 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
1838 	}
1839 
1840 	function log(uint p0, bool p1) internal view {
1841 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
1842 	}
1843 
1844 	function log(uint p0, address p1) internal view {
1845 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
1846 	}
1847 
1848 	function log(string memory p0, uint p1) internal view {
1849 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
1850 	}
1851 
1852 	function log(string memory p0, string memory p1) internal view {
1853 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
1854 	}
1855 
1856 	function log(string memory p0, bool p1) internal view {
1857 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
1858 	}
1859 
1860 	function log(string memory p0, address p1) internal view {
1861 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
1862 	}
1863 
1864 	function log(bool p0, uint p1) internal view {
1865 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
1866 	}
1867 
1868 	function log(bool p0, string memory p1) internal view {
1869 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
1870 	}
1871 
1872 	function log(bool p0, bool p1) internal view {
1873 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
1874 	}
1875 
1876 	function log(bool p0, address p1) internal view {
1877 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
1878 	}
1879 
1880 	function log(address p0, uint p1) internal view {
1881 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
1882 	}
1883 
1884 	function log(address p0, string memory p1) internal view {
1885 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
1886 	}
1887 
1888 	function log(address p0, bool p1) internal view {
1889 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
1890 	}
1891 
1892 	function log(address p0, address p1) internal view {
1893 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
1894 	}
1895 
1896 	function log(uint p0, uint p1, uint p2) internal view {
1897 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
1898 	}
1899 
1900 	function log(uint p0, uint p1, string memory p2) internal view {
1901 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1902 	}
1903 
1904 	function log(uint p0, uint p1, bool p2) internal view {
1905 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1906 	}
1907 
1908 	function log(uint p0, uint p1, address p2) internal view {
1909 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1910 	}
1911 
1912 	function log(uint p0, string memory p1, uint p2) internal view {
1913 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1914 	}
1915 
1916 	function log(uint p0, string memory p1, string memory p2) internal view {
1917 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1918 	}
1919 
1920 	function log(uint p0, string memory p1, bool p2) internal view {
1921 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1922 	}
1923 
1924 	function log(uint p0, string memory p1, address p2) internal view {
1925 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1926 	}
1927 
1928 	function log(uint p0, bool p1, uint p2) internal view {
1929 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1930 	}
1931 
1932 	function log(uint p0, bool p1, string memory p2) internal view {
1933 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1934 	}
1935 
1936 	function log(uint p0, bool p1, bool p2) internal view {
1937 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1938 	}
1939 
1940 	function log(uint p0, bool p1, address p2) internal view {
1941 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1942 	}
1943 
1944 	function log(uint p0, address p1, uint p2) internal view {
1945 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1946 	}
1947 
1948 	function log(uint p0, address p1, string memory p2) internal view {
1949 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1950 	}
1951 
1952 	function log(uint p0, address p1, bool p2) internal view {
1953 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1954 	}
1955 
1956 	function log(uint p0, address p1, address p2) internal view {
1957 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1958 	}
1959 
1960 	function log(string memory p0, uint p1, uint p2) internal view {
1961 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1962 	}
1963 
1964 	function log(string memory p0, uint p1, string memory p2) internal view {
1965 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1966 	}
1967 
1968 	function log(string memory p0, uint p1, bool p2) internal view {
1969 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1970 	}
1971 
1972 	function log(string memory p0, uint p1, address p2) internal view {
1973 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1974 	}
1975 
1976 	function log(string memory p0, string memory p1, uint p2) internal view {
1977 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1978 	}
1979 
1980 	function log(string memory p0, string memory p1, string memory p2) internal view {
1981 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1982 	}
1983 
1984 	function log(string memory p0, string memory p1, bool p2) internal view {
1985 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1986 	}
1987 
1988 	function log(string memory p0, string memory p1, address p2) internal view {
1989 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1990 	}
1991 
1992 	function log(string memory p0, bool p1, uint p2) internal view {
1993 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1994 	}
1995 
1996 	function log(string memory p0, bool p1, string memory p2) internal view {
1997 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1998 	}
1999 
2000 	function log(string memory p0, bool p1, bool p2) internal view {
2001 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2002 	}
2003 
2004 	function log(string memory p0, bool p1, address p2) internal view {
2005 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2006 	}
2007 
2008 	function log(string memory p0, address p1, uint p2) internal view {
2009 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
2010 	}
2011 
2012 	function log(string memory p0, address p1, string memory p2) internal view {
2013 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2014 	}
2015 
2016 	function log(string memory p0, address p1, bool p2) internal view {
2017 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2018 	}
2019 
2020 	function log(string memory p0, address p1, address p2) internal view {
2021 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2022 	}
2023 
2024 	function log(bool p0, uint p1, uint p2) internal view {
2025 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
2026 	}
2027 
2028 	function log(bool p0, uint p1, string memory p2) internal view {
2029 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
2030 	}
2031 
2032 	function log(bool p0, uint p1, bool p2) internal view {
2033 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2034 	}
2035 
2036 	function log(bool p0, uint p1, address p2) internal view {
2037 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2038 	}
2039 
2040 	function log(bool p0, string memory p1, uint p2) internal view {
2041 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2042 	}
2043 
2044 	function log(bool p0, string memory p1, string memory p2) internal view {
2045 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2046 	}
2047 
2048 	function log(bool p0, string memory p1, bool p2) internal view {
2049 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2050 	}
2051 
2052 	function log(bool p0, string memory p1, address p2) internal view {
2053 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2054 	}
2055 
2056 	function log(bool p0, bool p1, uint p2) internal view {
2057 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2058 	}
2059 
2060 	function log(bool p0, bool p1, string memory p2) internal view {
2061 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2062 	}
2063 
2064 	function log(bool p0, bool p1, bool p2) internal view {
2065 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2066 	}
2067 
2068 	function log(bool p0, bool p1, address p2) internal view {
2069 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2070 	}
2071 
2072 	function log(bool p0, address p1, uint p2) internal view {
2073 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2074 	}
2075 
2076 	function log(bool p0, address p1, string memory p2) internal view {
2077 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2078 	}
2079 
2080 	function log(bool p0, address p1, bool p2) internal view {
2081 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2082 	}
2083 
2084 	function log(bool p0, address p1, address p2) internal view {
2085 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2086 	}
2087 
2088 	function log(address p0, uint p1, uint p2) internal view {
2089 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2090 	}
2091 
2092 	function log(address p0, uint p1, string memory p2) internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2094 	}
2095 
2096 	function log(address p0, uint p1, bool p2) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2098 	}
2099 
2100 	function log(address p0, uint p1, address p2) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2102 	}
2103 
2104 	function log(address p0, string memory p1, uint p2) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2106 	}
2107 
2108 	function log(address p0, string memory p1, string memory p2) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2110 	}
2111 
2112 	function log(address p0, string memory p1, bool p2) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2114 	}
2115 
2116 	function log(address p0, string memory p1, address p2) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2118 	}
2119 
2120 	function log(address p0, bool p1, uint p2) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2122 	}
2123 
2124 	function log(address p0, bool p1, string memory p2) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2126 	}
2127 
2128 	function log(address p0, bool p1, bool p2) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2130 	}
2131 
2132 	function log(address p0, bool p1, address p2) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2134 	}
2135 
2136 	function log(address p0, address p1, uint p2) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2138 	}
2139 
2140 	function log(address p0, address p1, string memory p2) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2142 	}
2143 
2144 	function log(address p0, address p1, bool p2) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2146 	}
2147 
2148 	function log(address p0, address p1, address p2) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2150 	}
2151 
2152 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2154 	}
2155 
2156 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2158 	}
2159 
2160 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2162 	}
2163 
2164 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2166 	}
2167 
2168 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2170 	}
2171 
2172 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2174 	}
2175 
2176 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2178 	}
2179 
2180 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2182 	}
2183 
2184 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2186 	}
2187 
2188 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2190 	}
2191 
2192 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2194 	}
2195 
2196 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2198 	}
2199 
2200 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2202 	}
2203 
2204 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2206 	}
2207 
2208 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2210 	}
2211 
2212 	function log(uint p0, uint p1, address p2, address p3) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2214 	}
2215 
2216 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2218 	}
2219 
2220 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2222 	}
2223 
2224 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2226 	}
2227 
2228 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2230 	}
2231 
2232 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2234 	}
2235 
2236 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2238 	}
2239 
2240 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2242 	}
2243 
2244 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2246 	}
2247 
2248 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2250 	}
2251 
2252 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2254 	}
2255 
2256 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2258 	}
2259 
2260 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2262 	}
2263 
2264 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2266 	}
2267 
2268 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2270 	}
2271 
2272 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2274 	}
2275 
2276 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2278 	}
2279 
2280 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2282 	}
2283 
2284 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2286 	}
2287 
2288 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2290 	}
2291 
2292 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2294 	}
2295 
2296 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2298 	}
2299 
2300 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2302 	}
2303 
2304 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2306 	}
2307 
2308 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2310 	}
2311 
2312 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2314 	}
2315 
2316 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2318 	}
2319 
2320 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2322 	}
2323 
2324 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2326 	}
2327 
2328 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2330 	}
2331 
2332 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2334 	}
2335 
2336 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2338 	}
2339 
2340 	function log(uint p0, bool p1, address p2, address p3) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2342 	}
2343 
2344 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2346 	}
2347 
2348 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2350 	}
2351 
2352 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2354 	}
2355 
2356 	function log(uint p0, address p1, uint p2, address p3) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2358 	}
2359 
2360 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2362 	}
2363 
2364 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2366 	}
2367 
2368 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2370 	}
2371 
2372 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2374 	}
2375 
2376 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2378 	}
2379 
2380 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2382 	}
2383 
2384 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2386 	}
2387 
2388 	function log(uint p0, address p1, bool p2, address p3) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2390 	}
2391 
2392 	function log(uint p0, address p1, address p2, uint p3) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2394 	}
2395 
2396 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2398 	}
2399 
2400 	function log(uint p0, address p1, address p2, bool p3) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2402 	}
2403 
2404 	function log(uint p0, address p1, address p2, address p3) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2406 	}
2407 
2408 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2410 	}
2411 
2412 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2414 	}
2415 
2416 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2418 	}
2419 
2420 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2422 	}
2423 
2424 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2426 	}
2427 
2428 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2430 	}
2431 
2432 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2434 	}
2435 
2436 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2438 	}
2439 
2440 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2442 	}
2443 
2444 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2446 	}
2447 
2448 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2450 	}
2451 
2452 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2454 	}
2455 
2456 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2458 	}
2459 
2460 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2462 	}
2463 
2464 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2466 	}
2467 
2468 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2470 	}
2471 
2472 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2474 	}
2475 
2476 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2478 	}
2479 
2480 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2482 	}
2483 
2484 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2486 	}
2487 
2488 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2490 	}
2491 
2492 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2494 	}
2495 
2496 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2498 	}
2499 
2500 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2502 	}
2503 
2504 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2506 	}
2507 
2508 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2510 	}
2511 
2512 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2514 	}
2515 
2516 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2518 	}
2519 
2520 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2522 	}
2523 
2524 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2526 	}
2527 
2528 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2530 	}
2531 
2532 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2534 	}
2535 
2536 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2538 	}
2539 
2540 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2542 	}
2543 
2544 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2546 	}
2547 
2548 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2550 	}
2551 
2552 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2554 	}
2555 
2556 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2558 	}
2559 
2560 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2562 	}
2563 
2564 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2566 	}
2567 
2568 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2570 	}
2571 
2572 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2574 	}
2575 
2576 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2578 	}
2579 
2580 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2582 	}
2583 
2584 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(string memory p0, address p1, address p2, address p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(bool p0, uint p1, address p2, address p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(bool p0, bool p1, bool p2, address p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(bool p0, bool p1, address p2, uint p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(bool p0, bool p1, address p2, bool p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(bool p0, bool p1, address p2, address p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(bool p0, address p1, uint p2, uint p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(bool p0, address p1, uint p2, bool p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(bool p0, address p1, uint p2, address p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
2870 	}
2871 
2872 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
2873 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
2874 	}
2875 
2876 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
2877 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
2878 	}
2879 
2880 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
2881 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
2882 	}
2883 
2884 	function log(bool p0, address p1, string memory p2, address p3) internal view {
2885 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
2886 	}
2887 
2888 	function log(bool p0, address p1, bool p2, uint p3) internal view {
2889 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
2890 	}
2891 
2892 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
2893 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
2894 	}
2895 
2896 	function log(bool p0, address p1, bool p2, bool p3) internal view {
2897 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
2898 	}
2899 
2900 	function log(bool p0, address p1, bool p2, address p3) internal view {
2901 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2902 	}
2903 
2904 	function log(bool p0, address p1, address p2, uint p3) internal view {
2905 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2906 	}
2907 
2908 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2909 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2910 	}
2911 
2912 	function log(bool p0, address p1, address p2, bool p3) internal view {
2913 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2914 	}
2915 
2916 	function log(bool p0, address p1, address p2, address p3) internal view {
2917 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2918 	}
2919 
2920 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2921 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2922 	}
2923 
2924 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2925 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2926 	}
2927 
2928 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2929 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2930 	}
2931 
2932 	function log(address p0, uint p1, uint p2, address p3) internal view {
2933 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2934 	}
2935 
2936 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2937 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2938 	}
2939 
2940 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2941 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2942 	}
2943 
2944 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2945 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2946 	}
2947 
2948 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2949 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2950 	}
2951 
2952 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2953 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2954 	}
2955 
2956 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2957 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2958 	}
2959 
2960 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2961 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2962 	}
2963 
2964 	function log(address p0, uint p1, bool p2, address p3) internal view {
2965 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2966 	}
2967 
2968 	function log(address p0, uint p1, address p2, uint p3) internal view {
2969 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2970 	}
2971 
2972 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2973 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2974 	}
2975 
2976 	function log(address p0, uint p1, address p2, bool p3) internal view {
2977 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2978 	}
2979 
2980 	function log(address p0, uint p1, address p2, address p3) internal view {
2981 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2982 	}
2983 
2984 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2985 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2986 	}
2987 
2988 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2989 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2990 	}
2991 
2992 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2993 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2994 	}
2995 
2996 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2997 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2998 	}
2999 
3000 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
3001 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
3002 	}
3003 
3004 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3005 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3006 	}
3007 
3008 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3009 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3010 	}
3011 
3012 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3013 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3014 	}
3015 
3016 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
3017 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
3018 	}
3019 
3020 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3021 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3022 	}
3023 
3024 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3025 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3026 	}
3027 
3028 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3029 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3030 	}
3031 
3032 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3033 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3034 	}
3035 
3036 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3037 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3038 	}
3039 
3040 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3041 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3042 	}
3043 
3044 	function log(address p0, string memory p1, address p2, address p3) internal view {
3045 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3046 	}
3047 
3048 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3049 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3050 	}
3051 
3052 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3053 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3054 	}
3055 
3056 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3057 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3058 	}
3059 
3060 	function log(address p0, bool p1, uint p2, address p3) internal view {
3061 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3062 	}
3063 
3064 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3065 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3066 	}
3067 
3068 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3069 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3070 	}
3071 
3072 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3073 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3074 	}
3075 
3076 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3077 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3078 	}
3079 
3080 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3081 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3082 	}
3083 
3084 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3085 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3086 	}
3087 
3088 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3089 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3090 	}
3091 
3092 	function log(address p0, bool p1, bool p2, address p3) internal view {
3093 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3094 	}
3095 
3096 	function log(address p0, bool p1, address p2, uint p3) internal view {
3097 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3098 	}
3099 
3100 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3101 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3102 	}
3103 
3104 	function log(address p0, bool p1, address p2, bool p3) internal view {
3105 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3106 	}
3107 
3108 	function log(address p0, bool p1, address p2, address p3) internal view {
3109 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3110 	}
3111 
3112 	function log(address p0, address p1, uint p2, uint p3) internal view {
3113 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3114 	}
3115 
3116 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3117 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3118 	}
3119 
3120 	function log(address p0, address p1, uint p2, bool p3) internal view {
3121 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3122 	}
3123 
3124 	function log(address p0, address p1, uint p2, address p3) internal view {
3125 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3126 	}
3127 
3128 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3129 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3130 	}
3131 
3132 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3133 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3134 	}
3135 
3136 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3137 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3138 	}
3139 
3140 	function log(address p0, address p1, string memory p2, address p3) internal view {
3141 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3142 	}
3143 
3144 	function log(address p0, address p1, bool p2, uint p3) internal view {
3145 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3146 	}
3147 
3148 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3149 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3150 	}
3151 
3152 	function log(address p0, address p1, bool p2, bool p3) internal view {
3153 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3154 	}
3155 
3156 	function log(address p0, address p1, bool p2, address p3) internal view {
3157 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3158 	}
3159 
3160 	function log(address p0, address p1, address p2, uint p3) internal view {
3161 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3162 	}
3163 
3164 	function log(address p0, address p1, address p2, string memory p3) internal view {
3165 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3166 	}
3167 
3168 	function log(address p0, address p1, address p2, bool p3) internal view {
3169 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3170 	}
3171 
3172 	function log(address p0, address p1, address p2, address p3) internal view {
3173 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3174 	}
3175 
3176 }
3177 
3178 
3179 // File contracts/ItsABee.sol
3180 
3181 /*
3182  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
3183  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
3184  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
3185  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
3186  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
3187  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
3188 */
3189 
3190 
3191 contract ItsABee is ERC721A, IERC2981, Ownable {
3192     using Strings for uint256;
3193 
3194     ///////////////////////////////////////////////////////////////////////////
3195     // Public constants
3196     ///////////////////////////////////////////////////////////////////////////
3197     uint256 constant public MAX_SUPPLY = 6969;
3198     //uint256 constant public MAX_PER_WALLET = 5;
3199     uint256 constant public MAX_PER_MINT = 5;
3200     uint256 public PRICE = 0.1 ether;
3201     uint256 constant MAX_TEAM_MINTS = 100;
3202 
3203     ///////////////////////////////////////////////////////////////////////////
3204     // Important Globals
3205     ///////////////////////////////////////////////////////////////////////////
3206     uint256 public publicSaleTime = 1658408400;
3207 
3208     uint256 private teamMintsLeft = MAX_TEAM_MINTS-1;  // contract deployer gets one
3209     // how many has each address minted
3210     mapping (address => uint256) userMinted;
3211 
3212     string constant public PROVENANCE = "74ff6419e8a785b48e234bd6003f0248144ba2cd4ad36b011a9b932fd0244310";
3213     string private baseURI = "ipfs://QmRwTjENj9wHhk4ZiqjXWG6RKuEoFmZm413djYdAEGSmu4/";
3214     string private transformedBaseURI = "ipfs://QmRwTjENj9wHhk4ZiqjXWG6RKuEoFmZm413djYdAEGSmu4/";
3215 
3216 
3217 
3218     ///////////////////////////////////////////////////////////////////////////
3219     // Team members and shares
3220     ///////////////////////////////////////////////////////////////////////////
3221     mapping(address => bool) private isTeam;
3222 
3223     address constant public LARKIN = 0xA4430c68005b1F570a111aA71E1cA7EE5246c4CD;
3224     address constant public MAKER  = 0x7b0B5a326Aa4d95968e88654aF9b87624383A549;
3225 
3226     // Team Addresses
3227     address[] private team = [
3228         0x8eC73aB96d3d89d3882F5d79fa00cE6B0f16b6C7, // makerlee & artist
3229         LARKIN                                    , // Larkin
3230         0x05ed59e9765Ce11ACb387B66f91A99E1514ee7c8, // Pixel
3231         0x84B8C0f4659cDCc7714468167EC5b092C2dce75A  // former partner
3232     ];
3233 
3234     // Team wallet addresses
3235     //                            makerlee Larkin  Pixel partner
3236     uint256[] private teamShares = [50,     20,     15,      15];
3237     uint256 constant private TOTAL_SHARES = 100;
3238     // For EIP-2981 (royalties)
3239     bytes4 private constant INTERFACE_ID_ERC2981 = 0x2a55205a;
3240     uint256 constant private ROYALTIES_PERCENTAGE_X10 = 49;
3241 
3242     mapping (address => uint256[]) public burnedBy;  // tokens burned by a user
3243 
3244     uint256 public MAX_TRANSFORMS = 2100;
3245     uint256 public TRANSFORM_PRICE = 0.01 ether;
3246     uint256 public numTransformed;  // so far
3247     mapping (uint256 => bool) public transformed;  // is each token transformed?
3248     // optional boost to larkin's share of 'transform' payments
3249     uint256 private DEV_TRANSFORM_BOOST = 10;  // this is a percentage, so 10 means 10%
3250 
3251 
3252     ///////////////////////////////////////////////////////////////////////////
3253     // Contract initialization
3254     ///////////////////////////////////////////////////////////////////////////
3255     constructor() ERC721A("ItsABee", "ABEE") {
3256         // Validate that the team size matches number of share buckets for mint and royalties
3257         uint256 teamSize = team.length;
3258         if (teamSize != teamShares.length) revert InvalidTeam(teamShares.length);
3259 
3260         // Validate that the number of teamShares match the expected for mint and royalties
3261         uint256 totalTeamShares;
3262         for (uint256 i; i < teamSize; ) {
3263             isTeam[team[i]] = true;
3264             unchecked {
3265                 totalTeamShares += teamShares[i];
3266                 ++i;
3267             }
3268         }
3269         if (totalTeamShares != TOTAL_SHARES) revert InvalidTeam(totalTeamShares);
3270 
3271         // mint first token ID to creator
3272         _safeMint(msg.sender, 1);
3273     }
3274 
3275 
3276     ///////////////////////////////////////////////////////////////////////////
3277     // Modifiers
3278     ///////////////////////////////////////////////////////////////////////////
3279     modifier onlyDev() {
3280         if (msg.sender != LARKIN) revert OnlyAllowedAddressCanDoThat(LARKIN);
3281         _;
3282     }
3283     modifier onlyTeam() {
3284         if (!isTeam[msg.sender] && msg.sender != MAKER) revert OnlyTeamCanDoThat();
3285         _;
3286     }
3287 
3288 
3289     ///////////////////////////////////////////////////////////////////////////
3290     // Contract setup
3291     ///////////////////////////////////////////////////////////////////////////
3292     // The developer can change a team member (in case of emergency - wallet lost etc)
3293     function setTeamMember(uint256 index, address member) external onlyDev {
3294         require(member != address(0), "Cannot set team member to 0");
3295         require(index < team.length, "Invalid team member index");
3296 
3297         isTeam[team[index]] = false;  // remove team member
3298         team[index] = member; // relace team member
3299         isTeam[member] = true;
3300     }
3301 
3302     // Provenance hash proves that the team didn't play favorites with assigning tokenIds
3303     // for rare NFTs to specific addresses with a post-mint reveal
3304     //function setProvenanceHash(string memory _provenanceHash) external onlyDev {
3305     //    provenance = _provenanceHash;
3306     //}
3307 
3308     // change price after launch
3309     function setPrice(uint256 newPrice) public onlyTeam {
3310         PRICE = newPrice;
3311     }
3312     // Base IPFS URI that points to all metadata for the collection
3313     // It basically points to the IPFS folder containing all metadata.
3314     // So, if it points to ipfs://blah/, then tokenId 69 will have
3315     // metadata URI ipfs://blah/69
3316     //
3317     // Update the base URI (like to reveal)
3318     function setBaseURI(string memory _uri) external onlyDev {
3319         baseURI = _uri;
3320     }
3321     // update transformed URI (like when transformed images are uploaded)
3322     function setTransformedBaseURI(string memory _uri) external onlyDev {
3323         transformedBaseURI = _uri;
3324     }
3325 
3326     // The 'image' tag in the metadat for a tokenId points to its image's IPFS URI
3327     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3328         if (tokenId >= _totalMinted()) revert TokenDNE(tokenId);
3329 
3330         string memory mBaseURI = transformed[tokenId] ? transformedBaseURI : baseURI;
3331         return bytes(mBaseURI).length > 0 ? string(abi.encodePacked(mBaseURI, tokenId.toString())) : "";
3332     }
3333 
3334     // when does mint start
3335     function setPublicSaleTime(uint256 _newTime) public onlyDev {
3336         publicSaleTime = _newTime;
3337     }
3338 
3339     // set transform constants
3340     function setMaxTransforms(uint256 _max) public onlyDev {
3341         MAX_TRANSFORMS = _max;
3342     }
3343     function setTransformPrice(uint256 _price) public onlyDev {
3344         TRANSFORM_PRICE = _price;
3345     }
3346     function setDevTransformBoost(uint256 _boostPercent) public onlyDev {
3347         DEV_TRANSFORM_BOOST = _boostPercent;
3348     }
3349 
3350 
3351     ///////////////////////////////////////////////////////////////////////////
3352     // Mint and Burn
3353     ///////////////////////////////////////////////////////////////////////////
3354     function teamMint(uint256 _amount) external onlyTeam {
3355         if (teamMintsLeft < _amount) revert TooManyTeamMints(_amount - teamMintsLeft);
3356         teamMintsLeft -= _amount;
3357 
3358         _safeMint(msg.sender, _amount);
3359     }
3360 
3361     function mint(uint256 _amount) external payable {
3362         if (msg.value != _amount * PRICE) revert WrongPayment(msg.value, _amount * PRICE);
3363         if (block.timestamp < publicSaleTime) revert MintClosed();
3364         if (_totalMinted() + _amount + teamMintsLeft > MAX_SUPPLY) revert WouldPassSupplyCap(_totalMinted() + _amount + teamMintsLeft);
3365         if (_amount > MAX_PER_MINT) revert OverMaxMint(_amount, MAX_PER_MINT);
3366         //if (_numberMinted(msg.sender) + _amount > MAX_PER_WALLET) revert WalletCanOnlyMintNMore(MAX_PER_WALLET - _numberMinted(msg.sender));
3367 
3368         _safeMint(msg.sender, _amount);
3369     }
3370 
3371     function burn(uint256 _tokenId) external {
3372         if (ownerOf(_tokenId) != msg.sender) revert OnlyTokenOwnerCanDoThat(_tokenId, ownerOf(_tokenId));
3373 
3374         // Keep track of all tokens this address has burned
3375         burnedBy[msg.sender].push(_tokenId);
3376         _burn(_tokenId);
3377     }
3378 
3379     function getBurnedBy(address _by) external view returns (uint256[] memory) {
3380         return burnedBy[_by];
3381     }
3382 
3383 
3384     ///////////////////////////////////////////////////////////////////////////
3385     // Withdraw funds from contract
3386     ///////////////////////////////////////////////////////////////////////////
3387     // ETH is received for mint and royalties
3388     function withdrawETH() public onlyTeam {
3389         uint256 totalETH = address(this).balance;
3390         if (totalETH == 0) revert EmptyWithdraw();
3391 
3392         uint256 teamSize = team.length;
3393         for (uint256 i; i < teamSize; ) {
3394             address payable wallet = payable(team[i]);
3395             // How much is this wallet owed
3396             uint256 payment = (totalETH * teamShares[i]) / TOTAL_SHARES;
3397             // Send payment
3398             Address.sendValue(wallet, payment);
3399 
3400             unchecked { ++i; }
3401         }
3402         emit ETHWithdrawn(totalETH);
3403     }
3404 
3405     // Royalties in any ERC20 are accepted
3406     function withdrawERC20(IERC20 _token) public onlyTeam {
3407         uint256 totalERC20 = _token.balanceOf(address(this));
3408         if (totalERC20 == 0) revert EmptyWithdraw();
3409 
3410         uint256 teamSize = team.length;
3411         for (uint256 i; i < teamSize; ) {
3412             // How much is this wallet owed
3413             uint256 payment = (totalERC20 * teamShares[i]) / TOTAL_SHARES;
3414             // Send payment
3415             _token.transfer(team[i], payment);
3416 
3417             unchecked { ++i; }
3418         }
3419         emit ERC20Withdrawn(address(_token), totalERC20);
3420     }
3421 
3422 
3423     ///////////////////////////////////////////////////////////////////////////
3424     // Royalties - ERC2981
3425     ///////////////////////////////////////////////////////////////////////////
3426     // Supports ERC2981 for royalties as well as ofc 721 and 165
3427     function supportsInterface(bytes4 _interfaceId) public view override(ERC721A, IERC165) returns (bool) {
3428         return _interfaceId == INTERFACE_ID_ERC2981 || super.supportsInterface(_interfaceId);
3429     }
3430 
3431     // NFT marketplaces will call this function to determine amount of royalties
3432     // to charge and who to send them to
3433     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address _receiver, uint256 _royaltyAmount) {
3434         _receiver = address(this);
3435         _royaltyAmount = (_salePrice * ROYALTIES_PERCENTAGE_X10) / 1000;
3436     }
3437 
3438     // ensure this contract can receive payments (royalties)
3439     receive() external payable { }
3440 
3441 
3442     ///////////////////////////////////////////////////////////////////////////
3443     // Custom functions
3444     ///////////////////////////////////////////////////////////////////////////
3445     function transform(uint256 _tokenId) public payable {
3446         if (msg.value != TRANSFORM_PRICE) revert WrongTransformPrice(msg.value, TRANSFORM_PRICE);
3447         if (ownerOf(_tokenId) != msg.sender) revert OnlyTokenOwnerCanDoThat(_tokenId, ownerOf(_tokenId));
3448         if (transformed[_tokenId]) revert AlreadyTransformed(_tokenId);
3449         if (numTransformed >= MAX_TRANSFORMS) revert TransformingEnded();
3450 
3451         // As dev, Larkin may get a bump in payments for transforms
3452         if (DEV_TRANSFORM_BOOST > 0) {
3453             Address.sendValue(payable(LARKIN), msg.value * DEV_TRANSFORM_BOOST / 100);
3454         }
3455 
3456         numTransformed += 1;
3457         transformed[_tokenId] = true;
3458         emit Transformed(_tokenId);
3459     }
3460 
3461 
3462     ///////////////////////////////////////////////////////////////////////////
3463     // Errors and Events
3464     ///////////////////////////////////////////////////////////////////////////
3465     error InvalidTeam(uint256 sizeOrShares);
3466     error OnlyTeamCanDoThat();
3467     error OnlyAllowedAddressCanDoThat(address allowed);
3468     error WrongPayment(uint256 was, uint256 shouldBe);
3469     error MintClosed();
3470     error TooManyTeamMints(uint256 wouldBeTeamMints);
3471     error WouldPassSupplyCap(uint256 wouldBeSupply);
3472     //error WalletCanOnlyMintNMore(uint256 more);
3473     error OverMaxMint(uint256 over, uint256 max);
3474     error EmptyWithdraw();
3475     error TokenDNE(uint256 tokenId);
3476     error OnlyTokenOwnerCanDoThat(uint256 tokenId, address owner);
3477     error WrongTransformPrice(uint256 payed, uint256 price);
3478     error AlreadyTransformed(uint256 tokenId);
3479     error TransformingEnded();
3480 
3481     event ETHWithdrawn(uint256 amount);
3482     event ERC20Withdrawn(address erc20, uint256 amount);
3483     event Transformed(uint256 tokenId);
3484 }
3485 
3486 /*
3487  Larkin - @CodeLarkin - codelarkin.eth
3488  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
3489  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
3490  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
3491  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
3492  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
3493  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
3494  */