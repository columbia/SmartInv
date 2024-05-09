1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.0.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 // ERC721A Contracts v4.0.0
8 // Creator: Chiru Labs
9 
10 pragma solidity ^0.8.4;
11 
12 /**
13  * @dev Interface of an ERC721A compliant contract.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
25 
26     /**
27      * The caller cannot approve to their own address.
28      */
29     error ApproveToCaller();
30 
31     /**
32      * The caller cannot approve to the current owner.
33      */
34     error ApprovalToCurrentOwner();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
68      */
69     error TransferToNonERC721ReceiverImplementer();
70 
71     /**
72      * Cannot transfer to the zero address.
73      */
74     error TransferToZeroAddress();
75 
76     /**
77      * The token does not exist.
78      */
79     error URIQueryForNonexistentToken();
80 
81     struct TokenOwnership {
82         // The address of the owner.
83         address addr;
84         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
85         uint64 startTimestamp;
86         // Whether the token has been burned.
87         bool burned;
88     }
89 
90     /**
91      * @dev Returns the total amount of tokens stored by the contract.
92      *
93      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     // ==============================
98     //            IERC165
99     // ==============================
100 
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 
111     // ==============================
112     //            IERC721
113     // ==============================
114 
115     /**
116      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
119 
120     /**
121      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
122      */
123     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
127      */
128     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
129 
130     /**
131      * @dev Returns the number of tokens in ``owner``'s account.
132      */
133     function balanceOf(address owner) external view returns (uint256 balance);
134 
135     /**
136      * @dev Returns the owner of the `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function ownerOf(uint256 tokenId) external view returns (address owner);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
166      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     /**
185      * @dev Transfers `tokenId` token from `from` to `to`.
186      *
187      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     /**
205      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
206      * The approval is cleared when the token is transferred.
207      *
208      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
209      *
210      * Requirements:
211      *
212      * - The caller must own the token or be an approved operator.
213      * - `tokenId` must exist.
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address to, uint256 tokenId) external;
218 
219     /**
220      * @dev Approve or remove `operator` as an operator for the caller.
221      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
222      *
223      * Requirements:
224      *
225      * - The `operator` cannot be the caller.
226      *
227      * Emits an {ApprovalForAll} event.
228      */
229     function setApprovalForAll(address operator, bool _approved) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
242      *
243      * See {setApprovalForAll}
244      */
245     function isApprovedForAll(address owner, address operator) external view returns (bool);
246 
247     // ==============================
248     //        IERC721Metadata
249     // ==============================
250 
251     /**
252      * @dev Returns the token collection name.
253      */
254     function name() external view returns (string memory);
255 
256     /**
257      * @dev Returns the token collection symbol.
258      */
259     function symbol() external view returns (string memory);
260 
261     /**
262      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
263      */
264     function tokenURI(uint256 tokenId) external view returns (string memory);
265 }
266 
267 
268 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.0.0
269 
270 // ERC721A Contracts v4.0.0
271 // Creator: Chiru Labs
272 
273 pragma solidity ^0.8.4;
274 
275 /**
276  * @dev Interface of an ERC721AQueryable compliant contract.
277  */
278 interface IERC721AQueryable is IERC721A {
279     /**
280      * Invalid query range (`start` >= `stop`).
281      */
282     error InvalidQueryRange();
283 
284     /**
285      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
286      *
287      * If the `tokenId` is out of bounds:
288      *   - `addr` = `address(0)`
289      *   - `startTimestamp` = `0`
290      *   - `burned` = `false`
291      *
292      * If the `tokenId` is burned:
293      *   - `addr` = `<Address of owner before token was burned>`
294      *   - `startTimestamp` = `<Timestamp when token was burned>`
295      *   - `burned = `true`
296      *
297      * Otherwise:
298      *   - `addr` = `<Address of owner>`
299      *   - `startTimestamp` = `<Timestamp of start of ownership>`
300      *   - `burned = `false`
301      */
302     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
303 
304     /**
305      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
306      * See {ERC721AQueryable-explicitOwnershipOf}
307      */
308     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
309 
310     /**
311      * @dev Returns an array of token IDs owned by `owner`,
312      * in the range [`start`, `stop`)
313      * (i.e. `start <= tokenId < stop`).
314      *
315      * This function allows for tokens to be queried if the collection
316      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
317      *
318      * Requirements:
319      *
320      * - `start` < `stop`
321      */
322     function tokensOfOwnerIn(
323         address owner,
324         uint256 start,
325         uint256 stop
326     ) external view returns (uint256[] memory);
327 
328     /**
329      * @dev Returns an array of token IDs owned by `owner`.
330      *
331      * This function scans the ownership mapping and is O(totalSupply) in complexity.
332      * It is meant to be called off-chain.
333      *
334      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
335      * multiple smaller scans if the collection is large enough to cause
336      * an out-of-gas error (10K pfp collections should be fine).
337      */
338     function tokensOfOwner(address owner) external view returns (uint256[] memory);
339 }
340 
341 
342 // File erc721a/contracts/ERC721A.sol@v4.0.0
343 
344 
345 // ERC721A Contracts v4.0.0
346 // Creator: Chiru Labs
347 
348 pragma solidity ^0.8.4;
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
1159 
1160 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.0.0
1161 
1162 
1163 // ERC721A Contracts v4.0.0
1164 // Creator: Chiru Labs
1165 
1166 pragma solidity ^0.8.4;
1167 
1168 
1169 /**
1170  * @title ERC721A Queryable
1171  * @dev ERC721A subclass with convenience query functions.
1172  */
1173 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1174     /**
1175      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1176      *
1177      * If the `tokenId` is out of bounds:
1178      *   - `addr` = `address(0)`
1179      *   - `startTimestamp` = `0`
1180      *   - `burned` = `false`
1181      *
1182      * If the `tokenId` is burned:
1183      *   - `addr` = `<Address of owner before token was burned>`
1184      *   - `startTimestamp` = `<Timestamp when token was burned>`
1185      *   - `burned = `true`
1186      *
1187      * Otherwise:
1188      *   - `addr` = `<Address of owner>`
1189      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1190      *   - `burned = `false`
1191      */
1192     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1193         TokenOwnership memory ownership;
1194         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1195             return ownership;
1196         }
1197         ownership = _ownershipAt(tokenId);
1198         if (ownership.burned) {
1199             return ownership;
1200         }
1201         return _ownershipOf(tokenId);
1202     }
1203 
1204     /**
1205      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1206      * See {ERC721AQueryable-explicitOwnershipOf}
1207      */
1208     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1209         unchecked {
1210             uint256 tokenIdsLength = tokenIds.length;
1211             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1212             for (uint256 i; i != tokenIdsLength; ++i) {
1213                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1214             }
1215             return ownerships;
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns an array of token IDs owned by `owner`,
1221      * in the range [`start`, `stop`)
1222      * (i.e. `start <= tokenId < stop`).
1223      *
1224      * This function allows for tokens to be queried if the collection
1225      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1226      *
1227      * Requirements:
1228      *
1229      * - `start` < `stop`
1230      */
1231     function tokensOfOwnerIn(
1232         address owner,
1233         uint256 start,
1234         uint256 stop
1235     ) external view override returns (uint256[] memory) {
1236         unchecked {
1237             if (start >= stop) revert InvalidQueryRange();
1238             uint256 tokenIdsIdx;
1239             uint256 stopLimit = _nextTokenId();
1240             // Set `start = max(start, _startTokenId())`.
1241             if (start < _startTokenId()) {
1242                 start = _startTokenId();
1243             }
1244             // Set `stop = min(stop, stopLimit)`.
1245             if (stop > stopLimit) {
1246                 stop = stopLimit;
1247             }
1248             uint256 tokenIdsMaxLength = balanceOf(owner);
1249             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1250             // to cater for cases where `balanceOf(owner)` is too big.
1251             if (start < stop) {
1252                 uint256 rangeLength = stop - start;
1253                 if (rangeLength < tokenIdsMaxLength) {
1254                     tokenIdsMaxLength = rangeLength;
1255                 }
1256             } else {
1257                 tokenIdsMaxLength = 0;
1258             }
1259             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1260             if (tokenIdsMaxLength == 0) {
1261                 return tokenIds;
1262             }
1263             // We need to call `explicitOwnershipOf(start)`,
1264             // because the slot at `start` may not be initialized.
1265             TokenOwnership memory ownership = explicitOwnershipOf(start);
1266             address currOwnershipAddr;
1267             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1268             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1269             if (!ownership.burned) {
1270                 currOwnershipAddr = ownership.addr;
1271             }
1272             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1273                 ownership = _ownershipAt(i);
1274                 if (ownership.burned) {
1275                     continue;
1276                 }
1277                 if (ownership.addr != address(0)) {
1278                     currOwnershipAddr = ownership.addr;
1279                 }
1280                 if (currOwnershipAddr == owner) {
1281                     tokenIds[tokenIdsIdx++] = i;
1282                 }
1283             }
1284             // Downsize the array to fit.
1285             assembly {
1286                 mstore(tokenIds, tokenIdsIdx)
1287             }
1288             return tokenIds;
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns an array of token IDs owned by `owner`.
1294      *
1295      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1296      * It is meant to be called off-chain.
1297      *
1298      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1299      * multiple smaller scans if the collection is large enough to cause
1300      * an out-of-gas error (10K pfp collections should be fine).
1301      */
1302     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1303         unchecked {
1304             uint256 tokenIdsIdx;
1305             address currOwnershipAddr;
1306             uint256 tokenIdsLength = balanceOf(owner);
1307             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1308             TokenOwnership memory ownership;
1309             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1310                 ownership = _ownershipAt(i);
1311                 if (ownership.burned) {
1312                     continue;
1313                 }
1314                 if (ownership.addr != address(0)) {
1315                     currOwnershipAddr = ownership.addr;
1316                 }
1317                 if (currOwnershipAddr == owner) {
1318                     tokenIds[tokenIdsIdx++] = i;
1319                 }
1320             }
1321             return tokenIds;
1322         }
1323     }
1324 }
1325 
1326 
1327 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
1328 
1329 
1330 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1331 
1332 pragma solidity ^0.8.0;
1333 
1334 /**
1335  * @dev Provides information about the current execution context, including the
1336  * sender of the transaction and its data. While these are generally available
1337  * via msg.sender and msg.data, they should not be accessed in such a direct
1338  * manner, since when dealing with meta-transactions the account sending and
1339  * paying for execution may not be the actual sender (as far as an application
1340  * is concerned).
1341  *
1342  * This contract is only required for intermediate, library-like contracts.
1343  */
1344 abstract contract Context {
1345     function _msgSender() internal view virtual returns (address) {
1346         return msg.sender;
1347     }
1348 
1349     function _msgData() internal view virtual returns (bytes calldata) {
1350         return msg.data;
1351     }
1352 }
1353 
1354 
1355 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
1356 
1357 
1358 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1359 
1360 pragma solidity ^0.8.0;
1361 
1362 /**
1363  * @dev Contract module which provides a basic access control mechanism, where
1364  * there is an account (an owner) that can be granted exclusive access to
1365  * specific functions.
1366  *
1367  * By default, the owner account will be the one that deploys the contract. This
1368  * can later be changed with {transferOwnership}.
1369  *
1370  * This module is used through inheritance. It will make available the modifier
1371  * `onlyOwner`, which can be applied to your functions to restrict their use to
1372  * the owner.
1373  */
1374 abstract contract Ownable is Context {
1375     address private _owner;
1376 
1377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1378 
1379     /**
1380      * @dev Initializes the contract setting the deployer as the initial owner.
1381      */
1382     constructor() {
1383         _transferOwnership(_msgSender());
1384     }
1385 
1386     /**
1387      * @dev Returns the address of the current owner.
1388      */
1389     function owner() public view virtual returns (address) {
1390         return _owner;
1391     }
1392 
1393     /**
1394      * @dev Throws if called by any account other than the owner.
1395      */
1396     modifier onlyOwner() {
1397         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1398         _;
1399     }
1400 
1401     /**
1402      * @dev Leaves the contract without owner. It will not be possible to call
1403      * `onlyOwner` functions anymore. Can only be called by the current owner.
1404      *
1405      * NOTE: Renouncing ownership will leave the contract without an owner,
1406      * thereby removing any functionality that is only available to the owner.
1407      */
1408     function renounceOwnership() public virtual onlyOwner {
1409         _transferOwnership(address(0));
1410     }
1411 
1412     /**
1413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1414      * Can only be called by the current owner.
1415      */
1416     function transferOwnership(address newOwner) public virtual onlyOwner {
1417         require(newOwner != address(0), "Ownable: new owner is the zero address");
1418         _transferOwnership(newOwner);
1419     }
1420 
1421     /**
1422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1423      * Internal function without access restriction.
1424      */
1425     function _transferOwnership(address newOwner) internal virtual {
1426         address oldOwner = _owner;
1427         _owner = newOwner;
1428         emit OwnershipTransferred(oldOwner, newOwner);
1429     }
1430 }
1431 
1432 
1433 // File contracts/NONO.sol
1434 
1435 
1436 
1437 
1438 pragma solidity ^0.8.4;
1439 
1440 
1441 contract NONO is ERC721A, ERC721AQueryable, Ownable {
1442 
1443     modifier onlyCores {
1444         require(isCore[msg.sender], "cores only");
1445         _;
1446     }
1447 
1448     bool public revealed;
1449     bool public start;
1450     uint256 public preMintPeriod;
1451     uint256 public alistMintPeriod;
1452 
1453     uint256 public startAt;
1454     string private baseURI_;
1455     string private preRevealURI_;
1456 
1457     address public collabManager;
1458     address[] public cores;
1459     address[] public devs;
1460     address[] public alist;
1461     address[] public whitelist;
1462     mapping(address => bool) public isWhitelisted;
1463     mapping(address => bool) public isCore;
1464     mapping(address => bool) public isAlist;
1465     mapping(address => bool) public isDev;
1466 
1467     uint256 public mintLimit;
1468     uint256 public whitelistMintLimit;
1469     uint256 public alistMintLimit;
1470     uint256 public devMintLimit;
1471     uint256 public collabMintLimit;
1472     uint256 public coreMintLimit;
1473     mapping(address => uint256) public mintCount;
1474     mapping(address => uint256) public alistMintCount;
1475     mapping(address => uint256) public whitelistMintCount;
1476     mapping(address => uint256) public devMintCount;
1477     mapping(address => uint256) public collabMintCount;
1478     mapping(address => uint256) public coreMintCount;
1479 
1480 
1481     uint256 public PRICE;
1482     uint256 public MAX_SUPPLY;
1483 
1484     constructor(
1485         string memory name,
1486         string memory symbol,
1487         string memory uri, 
1488         string memory preUri, 
1489         uint256 mintPrice, 
1490         uint256 maxSupply
1491     ) ERC721A(name, symbol) {
1492         baseURI_ = uri;
1493         preRevealURI_ = preUri;
1494         PRICE = mintPrice;
1495         MAX_SUPPLY = maxSupply;
1496         
1497         alistMintPeriod = 4 hours;
1498         preMintPeriod = 24 hours;
1499     }
1500 
1501     function reveal() external onlyOwner {
1502         revealed = true;
1503     }
1504 
1505     function baseURI() public view returns(string memory) {
1506         if(revealed) {
1507             return baseURI_;
1508         } else {
1509             return preRevealURI_;
1510         }
1511     }
1512 
1513     function tokenURI(uint256 tokenId) public view override returns (string memory) {        
1514         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1515 
1516         string memory base = baseURI();
1517         return revealed ? string(abi.encodePacked(base, _toString(tokenId))) : base;
1518     }
1519 
1520     function setAlistMintPeriod(uint256 timePeriod) external onlyOwner {
1521         alistMintPeriod = timePeriod;
1522     }
1523 
1524     function setPreMintPeriod(uint256 timePeriod) external onlyOwner {
1525         preMintPeriod = timePeriod;
1526     }
1527 
1528     function setBaseURI(string memory uri) external onlyOwner {
1529         baseURI_ = uri;
1530     }
1531 
1532     function setPreRevealURI(string memory uri) external onlyOwner {
1533         preRevealURI_ = uri;
1534     }
1535 
1536     function setPrice(uint256 _price) external onlyOwner {
1537         require(_price > 0, "zero price");
1538         PRICE = _price;
1539     }
1540 
1541     function setMaxSupply(uint256 supply) external onlyOwner {
1542         require(supply >= totalSupply(), "cannot lower than current supply");
1543         MAX_SUPPLY = supply;
1544     }
1545 
1546     function starts() external onlyOwner {
1547         start = true;
1548         startAt = block.timestamp;
1549     }
1550 
1551     function setMintLimit(uint256 _mintLimit) external onlyOwner {
1552         mintLimit = _mintLimit;
1553     }
1554 
1555     function setWhitelistMintLimit(uint256 _whitelistMintLimit) external onlyOwner {
1556         whitelistMintLimit = _whitelistMintLimit;
1557     }
1558 
1559     function setAlistMintLimit(uint256 _alistMintLimit) external onlyOwner {
1560         alistMintLimit = _alistMintLimit;
1561     }
1562 
1563     function setDevMintLimit(uint256 _devMintLimit) external onlyOwner {
1564         devMintLimit = _devMintLimit;
1565     }
1566 
1567     function setCollabMintLimit(uint256 _collabMintLimit) external onlyOwner {
1568         collabMintLimit = _collabMintLimit;
1569     }
1570 
1571     function setCoreMintLimit(uint256 _corebMintLimit) external onlyOwner {
1572         coreMintLimit = _corebMintLimit;
1573     }
1574 
1575     function setCores(address[] memory _cores) external onlyOwner {
1576         cores = _cores;
1577         for(uint256 i = 0; i < _cores.length; i++) {
1578             isCore[_cores[i]] = true;
1579         }
1580     }
1581 
1582     function setDevs(address[] memory _devs) external onlyOwner {
1583         require(_devs.length > 0, "zero length");
1584 
1585         devs = _devs;
1586         for(uint256 i; i < _devs.length; i++) {
1587             isDev[_devs[i]] = true;
1588         }
1589     }
1590 
1591     function setAlist(address[] memory _alist) external onlyOwner {
1592         require(_alist.length > 0, "zero length");
1593 
1594         alist = _alist;
1595         for(uint256 i; i < _alist.length; i++) {
1596             isAlist[_alist[i]] = true;
1597         }
1598     }
1599 
1600    function setCollab(address _collab) external onlyOwner {
1601         require(_collab != address(0), "zero length");
1602 
1603         collabManager = _collab;
1604     }
1605 
1606     function setWhitelist(address[] memory _whitelist) external onlyOwner {
1607         require(_whitelist.length > 0, "zero length");
1608 
1609         whitelist = _whitelist;
1610         for(uint256 i; i < _whitelist.length; i++) {
1611             isWhitelisted[_whitelist[i]] = true;
1612         }
1613     }
1614 
1615     function drop(address at, uint256 quantity) external onlyOwner {
1616         require(totalSupply()+quantity <= MAX_SUPPLY, "max supply reached");
1617         _safeMint(at, quantity);
1618     }
1619 
1620     function withdraw() external onlyOwner {
1621         payable(owner()).transfer(address(this).balance);
1622     }
1623 
1624     function burn(uint256 tokenId) external onlyOwner {
1625         _burn(tokenId);
1626     }
1627 
1628     function mint(uint256 quantity) external payable {
1629         require(start, "sale not start");
1630         require(quantity > 0, "zero quantity");
1631         require(totalSupply() + quantity <= MAX_SUPPLY, "max supply reached");
1632         
1633         bool haveRole;
1634         uint256 mintSize;
1635         if(isDev[msg.sender] && block.timestamp > startAt + alistMintPeriod + preMintPeriod) {
1636             require(devMintCount[msg.sender] + mintCount[msg.sender] + quantity <= devMintLimit + mintLimit, "mint limit reached");
1637             
1638             haveRole = true;
1639 
1640             uint256 devSize = quantity + devMintCount[msg.sender] <= devMintLimit
1641             ? quantity
1642             : devMintLimit - devMintCount[msg.sender];
1643 
1644             mintSize = quantity - devSize;
1645 
1646             devMintCount[msg.sender] += devSize;
1647             if(devSize > 0) {
1648                 alistMint(msg.sender, devSize, 0);
1649             }
1650         }
1651         if(collabManager == msg.sender) {
1652             require(collabMintCount[msg.sender] + mintCount[msg.sender] < mintLimit + collabMintLimit, "mint limit reached");
1653 
1654             haveRole = true;
1655 
1656             uint256 collabSize = quantity + collabMintCount[msg.sender] <= collabMintLimit
1657             ? quantity
1658             : collabMintLimit - collabMintCount[msg.sender];
1659 
1660             mintSize = quantity - collabSize;
1661             
1662             if(collabSize > 0) {
1663                 alistMint(msg.sender, collabSize, 2);
1664             }
1665         }
1666         if(isAlist[msg.sender]) {
1667             require(alistMintCount[msg.sender] + mintCount[msg.sender] < mintLimit + alistMintLimit, "free mint limit reached");
1668             
1669             haveRole = true;
1670 
1671             uint256 alistSize = quantity + alistMintCount[msg.sender] <= alistMintLimit
1672             ? quantity
1673             : alistMintLimit - alistMintCount[msg.sender];
1674 
1675             mintSize = quantity - alistSize;
1676 
1677             if(alistSize > 0) {
1678                 alistMint(msg.sender, alistSize, 1);
1679             }
1680         }
1681 
1682         // premint
1683         if(isWhitelisted[msg.sender]) {
1684             if (block.timestamp > startAt + alistMintPeriod && block.timestamp <= startAt + alistMintPeriod + preMintPeriod) {
1685                 require(whitelistMintCount[msg.sender] + quantity <= whitelistMintLimit, "whitelist mint limit reached");
1686                 require(msg.value >= quantity * PRICE, "value too low");
1687 
1688                 whitelistMintCount[msg.sender] += quantity;
1689                 _safeMint(msg.sender, quantity);
1690                 return;
1691             }
1692         }
1693         
1694         
1695         if(!haveRole) {
1696             require(mintCount[msg.sender] + quantity <= mintLimit, "public mint limit reached");            
1697             mintSize = quantity;
1698         } else {
1699             require(mintCount[msg.sender] + mintSize <= mintLimit, "public mint limit reached");
1700         }
1701 
1702 
1703         if(mintSize > 0) {
1704             if(block.timestamp > startAt + alistMintPeriod) {
1705                 require(msg.value >= mintSize * PRICE, "value too low");
1706                 mintCount[msg.sender] += mintSize;
1707                 _safeMint(msg.sender, mintSize);
1708             } else {
1709                 revert("public mint not start");
1710             }
1711         }
1712     }
1713 
1714     function coreRewards(uint256 quantity) external onlyCores {
1715         require(coreMintCount[msg.sender] + quantity <= coreMintLimit, "core limit reeached");
1716         coreMintCount[msg.sender] += quantity;
1717 
1718         _safeMint(msg.sender, quantity);
1719     }
1720 
1721     function alistMint(address to, uint256 quantity, uint256 role) internal {
1722         if(role == 1) {
1723             alistMintCount[msg.sender] += quantity;
1724         } else if(role == 2) {
1725             collabMintCount[msg.sender] += quantity;
1726         } else {
1727             devMintCount[msg.sender] += quantity;
1728         }
1729 
1730         _safeMint(to, quantity);
1731     }
1732 
1733     receive() external payable {}
1734 }