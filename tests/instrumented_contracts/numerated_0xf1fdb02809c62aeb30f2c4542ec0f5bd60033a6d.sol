1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev Interface of an ERC721A compliant contract.
6  */
7 interface IERC721A {
8     /**
9      * The caller must own the token or be an approved operator.
10      */
11     error ApprovalCallerNotOwnerNorApproved();
12 
13     /**
14      * The token does not exist.
15      */
16     error ApprovalQueryForNonexistentToken();
17 
18     /**
19      * The caller cannot approve to their own address.
20      */
21     error ApproveToCaller();
22 
23     /**
24      * The caller cannot approve to the current owner.
25      */
26     error ApprovalToCurrentOwner();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     struct TokenOwnership {
74         // The address of the owner.
75         address addr;
76         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
77         uint64 startTimestamp;
78         // Whether the token has been burned.
79         bool burned;
80     }
81 
82     /**
83      * @dev Returns the total amount of tokens stored by the contract.
84      *
85      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     // ==============================
90     //            IERC165
91     // ==============================
92 
93     /**
94      * @dev Returns true if this contract implements the interface defined by
95      * `interfaceId`. See the corresponding
96      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
97      * to learn more about how these ids are created.
98      *
99      * This function call must use less than 30 000 gas.
100      */
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 
103     // ==============================
104     //            IERC721
105     // ==============================
106 
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(
150         address from,
151         address to,
152         uint256 tokenId,
153         bytes calldata data
154     ) external;
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns the account approved for `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function getApproved(uint256 tokenId) external view returns (address operator);
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     // ==============================
240     //        IERC721Metadata
241     // ==============================
242 
243     /**
244      * @dev Returns the token collection name.
245      */
246     function name() external view returns (string memory);
247 
248     /**
249      * @dev Returns the token collection symbol.
250      */
251     function symbol() external view returns (string memory);
252 
253     /**
254      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
255      */
256     function tokenURI(uint256 tokenId) external view returns (string memory);
257 }
258 
259 
260 // File erc721a/contracts/ERC721A.sol@v4.0.0
261 
262 
263 // ERC721A Contracts v4.0.0
264 // Creator: Chiru Labs
265 
266 
267 
268 /**
269  * @dev ERC721 token receiver interface.
270  */
271 interface ERC721A__IERC721Receiver {
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 /**
281  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
282  * the Metadata extension. Built to optimize for lower gas during batch mints.
283  *
284  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
285  *
286  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
287  *
288  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
289  */
290 contract ERC721A is IERC721A {
291     // Mask of an entry in packed address data.
292     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
293 
294     // The bit position of `numberMinted` in packed address data.
295     uint256 private constant BITPOS_NUMBER_MINTED = 64;
296 
297     // The bit position of `numberBurned` in packed address data.
298     uint256 private constant BITPOS_NUMBER_BURNED = 128;
299 
300     // The bit position of `aux` in packed address data.
301     uint256 private constant BITPOS_AUX = 192;
302 
303     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
304     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
305 
306     // The bit position of `startTimestamp` in packed ownership.
307     uint256 private constant BITPOS_START_TIMESTAMP = 160;
308 
309     // The bit mask of the `burned` bit in packed ownership.
310     uint256 private constant BITMASK_BURNED = 1 << 224;
311    
312     // The bit position of the `nextInitialized` bit in packed ownership.
313     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
314 
315     // The bit mask of the `nextInitialized` bit in packed ownership.
316     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
317 
318     // The tokenId of the next token to be minted.
319     uint256 private _currentIndex;
320 
321     // The number of tokens burned.
322     uint256 private _burnCounter;
323 
324     // Token name
325     string private _name;
326 
327     // Token symbol
328     string private _symbol;
329 
330     // Mapping from token ID to ownership details
331     // An empty struct value does not necessarily mean the token is unowned.
332     // See `_packedOwnershipOf` implementation for details.
333     //
334     // Bits Layout:
335     // - [0..159]   `addr`
336     // - [160..223] `startTimestamp`
337     // - [224]      `burned`
338     // - [225]      `nextInitialized`
339     mapping(uint256 => uint256) private _packedOwnerships;
340 
341     // Mapping owner address to address data.
342     //
343     // Bits Layout:
344     // - [0..63]    `balance`
345     // - [64..127]  `numberMinted`
346     // - [128..191] `numberBurned`
347     // - [192..255] `aux`
348     mapping(address => uint256) private _packedAddressData;
349 
350     // Mapping from token ID to approved address.
351     mapping(uint256 => address) private _tokenApprovals;
352 
353     // Mapping from owner to operator approvals
354     mapping(address => mapping(address => bool)) private _operatorApprovals;
355 
356     constructor(string memory name_, string memory symbol_) {
357         _name = name_;
358         _symbol = symbol_;
359         _currentIndex = _startTokenId();
360     }
361 
362     /**
363      * @dev Returns the starting token ID.
364      * To change the starting token ID, please override this function.
365      */
366     function _startTokenId() internal view virtual returns (uint256) {
367         return 0;
368     }
369 
370     /**
371      * @dev Returns the next token ID to be minted.
372      */
373     function _nextTokenId() internal view returns (uint256) {
374         return _currentIndex;
375     }
376 
377     /**
378      * @dev Returns the total number of tokens in existence.
379      * Burned tokens will reduce the count.
380      * To get the total number of tokens minted, please see `_totalMinted`.
381      */
382     function totalSupply() public view override returns (uint256) {
383         // Counter underflow is impossible as _burnCounter cannot be incremented
384         // more than `_currentIndex - _startTokenId()` times.
385         unchecked {
386             return _currentIndex - _burnCounter - _startTokenId();
387         }
388     }
389 
390     /**
391      * @dev Returns the total amount of tokens minted in the contract.
392      */
393     function _totalMinted() internal view returns (uint256) {
394         // Counter underflow is impossible as _currentIndex does not decrement,
395         // and it is initialized to `_startTokenId()`
396         unchecked {
397             return _currentIndex - _startTokenId();
398         }
399     }
400 
401     /**
402      * @dev Returns the total number of tokens burned.
403      */
404     function _totalBurned() internal view returns (uint256) {
405         return _burnCounter;
406     }
407 
408     /**
409      * @dev See {IERC165-supportsInterface}.
410      */
411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
412         // The interface IDs are constants representing the first 4 bytes of the XOR of
413         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
414         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
415         return
416             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
417             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
418             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
419     }
420 
421     /**
422      * @dev See {IERC721-balanceOf}.
423      */
424     function balanceOf(address owner) public view override returns (uint256) {
425         if (owner == address(0)) revert BalanceQueryForZeroAddress();
426         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
427     }
428 
429     /**
430      * Returns the number of tokens minted by `owner`.
431      */
432     function _numberMinted(address owner) internal view returns (uint256) {
433         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
434     }
435 
436     /**
437      * Returns the number of tokens burned by or on behalf of `owner`.
438      */
439     function _numberBurned(address owner) internal view returns (uint256) {
440         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
441     }
442 
443     /**
444      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
445      */
446     function _getAux(address owner) internal view returns (uint64) {
447         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
448     }
449 
450     /**
451      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
452      * If there are multiple variables, please pack them into a uint64.
453      */
454     function _setAux(address owner, uint64 aux) internal {
455         uint256 packed = _packedAddressData[owner];
456         uint256 auxCasted;
457         assembly { // Cast aux without masking.
458             auxCasted := aux
459         }
460         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
461         _packedAddressData[owner] = packed;
462     }
463 
464     /**
465      * Returns the packed ownership data of `tokenId`.
466      */
467     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
468         uint256 curr = tokenId;
469 
470         unchecked {
471             if (_startTokenId() <= curr)
472                 if (curr < _currentIndex) {
473                     uint256 packed = _packedOwnerships[curr];
474                     // If not burned.
475                     if (packed & BITMASK_BURNED == 0) {
476                         // Invariant:
477                         // There will always be an ownership that has an address and is not burned
478                         // before an ownership that does not have an address and is not burned.
479                         // Hence, curr will not underflow.
480                         //
481                         // We can directly compare the packed value.
482                         // If the address is zero, packed is zero.
483                         while (packed == 0) {
484                             packed = _packedOwnerships[--curr];
485                         }
486                         return packed;
487                     }
488                 }
489         }
490         revert OwnerQueryForNonexistentToken();
491     }
492 
493     /**
494      * Returns the unpacked `TokenOwnership` struct from `packed`.
495      */
496     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
497         ownership.addr = address(uint160(packed));
498         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
499         ownership.burned = packed & BITMASK_BURNED != 0;
500     }
501 
502     /**
503      * Returns the unpacked `TokenOwnership` struct at `index`.
504      */
505     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
506         return _unpackedOwnership(_packedOwnerships[index]);
507     }
508 
509     /**
510      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
511      */
512     function _initializeOwnershipAt(uint256 index) internal {
513         if (_packedOwnerships[index] == 0) {
514             _packedOwnerships[index] = _packedOwnershipOf(index);
515         }
516     }
517 
518     /**
519      * Gas spent here starts off proportional to the maximum mint batch size.
520      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
521      */
522     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
523         return _unpackedOwnership(_packedOwnershipOf(tokenId));
524     }
525 
526     /**
527      * @dev See {IERC721-ownerOf}.
528      */
529     function ownerOf(uint256 tokenId) public view override returns (address) {
530         return address(uint160(_packedOwnershipOf(tokenId)));
531     }
532 
533     /**
534      * @dev See {IERC721Metadata-name}.
535      */
536     function name() public view virtual override returns (string memory) {
537         return _name;
538     }
539 
540     /**
541      * @dev See {IERC721Metadata-symbol}.
542      */
543     function symbol() public view virtual override returns (string memory) {
544         return _symbol;
545     }
546 
547     /**
548      * @dev See {IERC721Metadata-tokenURI}.
549      */
550     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
551         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
552 
553         string memory baseURI = _baseURI();
554         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
555     }
556 
557     /**
558      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
559      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
560      * by default, can be overriden in child contracts.
561      */
562     function _baseURI() internal view virtual returns (string memory) {
563         return '';
564     }
565 
566     /**
567      * @dev Casts the address to uint256 without masking.
568      */
569     function _addressToUint256(address value) private pure returns (uint256 result) {
570         assembly {
571             result := value
572         }
573     }
574 
575     /**
576      * @dev Casts the boolean to uint256 without branching.
577      */
578     function _boolToUint256(bool value) private pure returns (uint256 result) {
579         assembly {
580             result := value
581         }
582     }
583 
584     /**
585      * @dev See {IERC721-approve}.
586      */
587     function approve(address to, uint256 tokenId) public override {
588         address owner = address(uint160(_packedOwnershipOf(tokenId)));
589         if (to == owner) revert ApprovalToCurrentOwner();
590 
591         if (_msgSenderERC721A() != owner)
592             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
593                 revert ApprovalCallerNotOwnerNorApproved();
594             }
595 
596         _tokenApprovals[tokenId] = to;
597         emit Approval(owner, to, tokenId);
598     }
599 
600     /**
601      * @dev See {IERC721-getApproved}.
602      */
603     function getApproved(uint256 tokenId) public view override returns (address) {
604         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
605 
606         return _tokenApprovals[tokenId];
607     }
608 
609     /**
610      * @dev See {IERC721-setApprovalForAll}.
611      */
612     function setApprovalForAll(address operator, bool approved) public virtual override {
613         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
614 
615         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
616         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
617     }
618 
619     /**
620      * @dev See {IERC721-isApprovedForAll}.
621      */
622     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
623         return _operatorApprovals[owner][operator];
624     }
625 
626     /**
627      * @dev See {IERC721-transferFrom}.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) public virtual override {
634         _transfer(from, to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-safeTransferFrom}.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) public virtual override {
645         safeTransferFrom(from, to, tokenId, '');
646     }
647 
648     /**
649      * @dev See {IERC721-safeTransferFrom}.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId,
655         bytes memory _data
656     ) public virtual override {
657         _transfer(from, to, tokenId);
658         if (to.code.length != 0)
659             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
660                 revert TransferToNonERC721ReceiverImplementer();
661             }
662     }
663 
664     /**
665      * @dev Returns whether `tokenId` exists.
666      *
667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
668      *
669      * Tokens start existing when they are minted (`_mint`),
670      */
671     function _exists(uint256 tokenId) internal view returns (bool) {
672         return
673             _startTokenId() <= tokenId &&
674             tokenId < _currentIndex && // If within bounds,
675             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
676     }
677 
678     /**
679      * @dev Equivalent to `_safeMint(to, quantity, '')`.
680      */
681     function _safeMint(address to, uint256 quantity) internal {
682         _safeMint(to, quantity, '');
683     }
684 
685     /**
686      * @dev Safely mints `quantity` tokens and transfers them to `to`.
687      *
688      * Requirements:
689      *
690      * - If `to` refers to a smart contract, it must implement
691      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
692      * - `quantity` must be greater than 0.
693      *
694      * Emits a {Transfer} event.
695      */
696     function _safeMint(
697         address to,
698         uint256 quantity,
699         bytes memory _data
700     ) internal {
701         uint256 startTokenId = _currentIndex;
702         if (to == address(0)) revert MintToZeroAddress();
703         if (quantity == 0) revert MintZeroQuantity();
704 
705         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
706 
707         // Overflows are incredibly unrealistic.
708         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
709         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
710         unchecked {
711             // Updates:
712             // - `balance += quantity`.
713             // - `numberMinted += quantity`.
714             //
715             // We can directly add to the balance and number minted.
716             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
717 
718             // Updates:
719             // - `address` to the owner.
720             // - `startTimestamp` to the timestamp of minting.
721             // - `burned` to `false`.
722             // - `nextInitialized` to `quantity == 1`.
723             _packedOwnerships[startTokenId] =
724                 _addressToUint256(to) |
725                 (block.timestamp << BITPOS_START_TIMESTAMP) |
726                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
727 
728             uint256 updatedIndex = startTokenId;
729             uint256 end = updatedIndex + quantity;
730 
731             if (to.code.length != 0) {
732                 do {
733                     emit Transfer(address(0), to, updatedIndex);
734                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
735                         revert TransferToNonERC721ReceiverImplementer();
736                     }
737                 } while (updatedIndex < end);
738                 // Reentrancy protection
739                 if (_currentIndex != startTokenId) revert();
740             } else {
741                 do {
742                     emit Transfer(address(0), to, updatedIndex++);
743                 } while (updatedIndex < end);
744             }
745             _currentIndex = updatedIndex;
746         }
747         _afterTokenTransfers(address(0), to, startTokenId, quantity);
748     }
749 
750     /**
751      * @dev Mints `quantity` tokens and transfers them to `to`.
752      *
753      * Requirements:
754      *
755      * - `to` cannot be the zero address.
756      * - `quantity` must be greater than 0.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _mint(address to, uint256 quantity) internal {
761         uint256 startTokenId = _currentIndex;
762         if (to == address(0)) revert MintToZeroAddress();
763         if (quantity == 0) revert MintZeroQuantity();
764 
765         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
766 
767         // Overflows are incredibly unrealistic.
768         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
769         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
770         unchecked {
771             // Updates:
772             // - `balance += quantity`.
773             // - `numberMinted += quantity`.
774             //
775             // We can directly add to the balance and number minted.
776             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
777 
778             // Updates:
779             // - `address` to the owner.
780             // - `startTimestamp` to the timestamp of minting.
781             // - `burned` to `false`.
782             // - `nextInitialized` to `quantity == 1`.
783             _packedOwnerships[startTokenId] =
784                 _addressToUint256(to) |
785                 (block.timestamp << BITPOS_START_TIMESTAMP) |
786                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
787 
788             uint256 updatedIndex = startTokenId;
789             uint256 end = updatedIndex + quantity;
790 
791             do {
792                 emit Transfer(address(0), to, updatedIndex++);
793             } while (updatedIndex < end);
794 
795             _currentIndex = updatedIndex;
796         }
797         _afterTokenTransfers(address(0), to, startTokenId, quantity);
798     }
799 
800     /**
801      * @dev Transfers `tokenId` from `from` to `to`.
802      *
803      * Requirements:
804      *
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must be owned by `from`.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _transfer(
811         address from,
812         address to,
813         uint256 tokenId
814     ) private {
815         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
816 
817         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
818 
819         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
820             isApprovedForAll(from, _msgSenderERC721A()) ||
821             getApproved(tokenId) == _msgSenderERC721A());
822 
823         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
824         if (to == address(0)) revert TransferToZeroAddress();
825 
826         _beforeTokenTransfers(from, to, tokenId, 1);
827 
828         // Clear approvals from the previous owner.
829         delete _tokenApprovals[tokenId];
830 
831         // Underflow of the sender's balance is impossible because we check for
832         // ownership above and the recipient's balance can't realistically overflow.
833         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
834         unchecked {
835             // We can directly increment and decrement the balances.
836             --_packedAddressData[from]; // Updates: `balance -= 1`.
837             ++_packedAddressData[to]; // Updates: `balance += 1`.
838 
839             // Updates:
840             // - `address` to the next owner.
841             // - `startTimestamp` to the timestamp of transfering.
842             // - `burned` to `false`.
843             // - `nextInitialized` to `true`.
844             _packedOwnerships[tokenId] =
845                 _addressToUint256(to) |
846                 (block.timestamp << BITPOS_START_TIMESTAMP) |
847                 BITMASK_NEXT_INITIALIZED;
848 
849             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
850             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
851                 uint256 nextTokenId = tokenId + 1;
852                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
853                 if (_packedOwnerships[nextTokenId] == 0) {
854                     // If the next slot is within bounds.
855                     if (nextTokenId != _currentIndex) {
856                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
857                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
858                     }
859                 }
860             }
861         }
862 
863         emit Transfer(from, to, tokenId);
864         _afterTokenTransfers(from, to, tokenId, 1);
865     }
866 
867     /**
868      * @dev Equivalent to `_burn(tokenId, false)`.
869      */
870     function _burn(uint256 tokenId) internal virtual {
871         _burn(tokenId, false);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
885         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
886 
887         address from = address(uint160(prevOwnershipPacked));
888 
889         if (approvalCheck) {
890             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
891                 isApprovedForAll(from, _msgSenderERC721A()) ||
892                 getApproved(tokenId) == _msgSenderERC721A());
893 
894             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
895         }
896 
897         _beforeTokenTransfers(from, address(0), tokenId, 1);
898 
899         // Clear approvals from the previous owner.
900         delete _tokenApprovals[tokenId];
901 
902         // Underflow of the sender's balance is impossible because we check for
903         // ownership above and the recipient's balance can't realistically overflow.
904         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
905         unchecked {
906             // Updates:
907             // - `balance -= 1`.
908             // - `numberBurned += 1`.
909             //
910             // We can directly decrement the balance, and increment the number burned.
911             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
912             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
913 
914             // Updates:
915             // - `address` to the last owner.
916             // - `startTimestamp` to the timestamp of burning.
917             // - `burned` to `true`.
918             // - `nextInitialized` to `true`.
919             _packedOwnerships[tokenId] =
920                 _addressToUint256(from) |
921                 (block.timestamp << BITPOS_START_TIMESTAMP) |
922                 BITMASK_BURNED |
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
939         emit Transfer(from, address(0), tokenId);
940         _afterTokenTransfers(from, address(0), tokenId, 1);
941 
942         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
943         unchecked {
944             _burnCounter++;
945         }
946     }
947 
948     /**
949      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
950      *
951      * @param from address representing the previous owner of the given token ID
952      * @param to target address that will receive the tokens
953      * @param tokenId uint256 ID of the token to be transferred
954      * @param _data bytes optional data to send along with the call
955      * @return bool whether the call correctly returned the expected magic value
956      */
957     function _checkContractOnERC721Received(
958         address from,
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) private returns (bool) {
963         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
964             bytes4 retval
965         ) {
966             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
967         } catch (bytes memory reason) {
968             if (reason.length == 0) {
969                 revert TransferToNonERC721ReceiverImplementer();
970             } else {
971                 assembly {
972                     revert(add(32, reason), mload(reason))
973                 }
974             }
975         }
976     }
977 
978     /**
979      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
980      * And also called before burning one token.
981      *
982      * startTokenId - the first token id to be transferred
983      * quantity - the amount to be transferred
984      *
985      * Calling conditions:
986      *
987      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
988      * transferred to `to`.
989      * - When `from` is zero, `tokenId` will be minted for `to`.
990      * - When `to` is zero, `tokenId` will be burned by `from`.
991      * - `from` and `to` are never both zero.
992      */
993     function _beforeTokenTransfers(
994         address from,
995         address to,
996         uint256 startTokenId,
997         uint256 quantity
998     ) internal virtual {}
999 
1000     /**
1001      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1002      * minting.
1003      * And also called after one token has been burned.
1004      *
1005      * startTokenId - the first token id to be transferred
1006      * quantity - the amount to be transferred
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` has been minted for `to`.
1013      * - When `to` is zero, `tokenId` has been burned by `from`.
1014      * - `from` and `to` are never both zero.
1015      */
1016     function _afterTokenTransfers(
1017         address from,
1018         address to,
1019         uint256 startTokenId,
1020         uint256 quantity
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Returns the message sender (defaults to `msg.sender`).
1025      *
1026      * If you are writing GSN compatible contracts, you need to override this function.
1027      */
1028     function _msgSenderERC721A() internal view virtual returns (address) {
1029         return msg.sender;
1030     }
1031 
1032     /**
1033      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1034      */
1035     function _toString(uint256 value) internal pure returns (string memory ptr) {
1036         assembly {
1037             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1038             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1039             // We will need 1 32-byte word to store the length,
1040             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1041             ptr := add(mload(0x40), 128)
1042             // Update the free memory pointer to allocate.
1043             mstore(0x40, ptr)
1044 
1045             // Cache the end of the memory to calculate the length later.
1046             let end := ptr
1047 
1048             // We write the string from the rightmost digit to the leftmost digit.
1049             // The following is essentially a do-while loop that also handles the zero case.
1050             // Costs a bit more than early returning for the zero case,
1051             // but cheaper in terms of deployment and overall runtime costs.
1052             for {
1053                 // Initialize and perform the first pass without check.
1054                 let temp := value
1055                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1056                 ptr := sub(ptr, 1)
1057                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1058                 mstore8(ptr, add(48, mod(temp, 10)))
1059                 temp := div(temp, 10)
1060             } temp {
1061                 // Keep dividing `temp` until zero.
1062                 temp := div(temp, 10)
1063             } { // Body of the for loop.
1064                 ptr := sub(ptr, 1)
1065                 mstore8(ptr, add(48, mod(temp, 10)))
1066             }
1067            
1068             let length := sub(end, ptr)
1069             // Move the pointer 32 bytes leftwards to make room for the length.
1070             ptr := sub(ptr, 32)
1071             // Store the length.
1072             mstore(ptr, length)
1073         }
1074     }
1075 }
1076 
1077 
1078 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1082 
1083 
1084 
1085 /**
1086  * @dev Provides information about the current execution context, including the
1087  * sender of the transaction and its data. While these are generally available
1088  * via msg.sender and msg.data, they should not be accessed in such a direct
1089  * manner, since when dealing with meta-transactions the account sending and
1090  * paying for execution may not be the actual sender (as far as an application
1091  * is concerned).
1092  *
1093  * This contract is only required for intermediate, library-like contracts.
1094  */
1095 abstract contract Context {
1096     function _msgSender() internal view virtual returns (address) {
1097         return msg.sender;
1098     }
1099 
1100     function _msgData() internal view virtual returns (bytes calldata) {
1101         return msg.data;
1102     }
1103 }
1104 
1105 
1106 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1107 
1108 
1109 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1110 
1111 
1112 
1113 /**
1114  * @dev Contract module which provides a basic access control mechanism, where
1115  * there is an account (an owner) that can be granted exclusive access to
1116  * specific functions.
1117  *
1118  * By default, the owner account will be the one that deploys the contract. This
1119  * can later be changed with {transferOwnership}.
1120  *
1121  * This module is used through inheritance. It will make available the modifier
1122  * `onlyOwner`, which can be applied to your functions to restrict their use to
1123  * the owner.
1124  */
1125 abstract contract Ownable is Context {
1126     address private _owner;
1127 
1128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1129 
1130     /**
1131      * @dev Initializes the contract setting the deployer as the initial owner.
1132      */
1133     constructor() {
1134         _transferOwnership(_msgSender());
1135     }
1136 
1137     /**
1138      * @dev Returns the address of the current owner.
1139      */
1140     function owner() public view virtual returns (address) {
1141         return _owner;
1142     }
1143 
1144     /**
1145      * @dev Throws if called by any account other than the owner.
1146      */
1147     modifier onlyOwner() {
1148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1149         _;
1150     }
1151 
1152     /**
1153      * @dev Leaves the contract without owner. It will not be possible to call
1154      * `onlyOwner` functions anymore. Can only be called by the current owner.
1155      *
1156      * NOTE: Renouncing ownership will leave the contract without an owner,
1157      * thereby removing any functionality that is only available to the owner.
1158      */
1159     function renounceOwnership() public virtual onlyOwner {
1160         _transferOwnership(address(0));
1161     }
1162 
1163     /**
1164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1165      * Can only be called by the current owner.
1166      */
1167     function transferOwnership(address newOwner) public virtual onlyOwner {
1168         require(newOwner != address(0), "Ownable: new owner is the zero address");
1169         _transferOwnership(newOwner);
1170     }
1171 
1172     /**
1173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1174      * Internal function without access restriction.
1175      */
1176     function _transferOwnership(address newOwner) internal virtual {
1177         address oldOwner = _owner;
1178         _owner = newOwner;
1179         emit OwnershipTransferred(oldOwner, newOwner);
1180     }
1181 }
1182 
1183 
1184 abstract contract TWC {
1185     function ownerOf(uint256 tokenId) public view virtual returns (address);
1186 }
1187 
1188 abstract contract TWS {
1189     function ownerOf(uint256 tokenId) public view virtual returns (address);
1190 }
1191 
1192 
1193 contract UnderTheWickedMoon is ERC721A("UnderTheWickedMoon", "UNDERTHEWICKEDMOON"), Ownable {
1194 
1195     TWC private twc = TWC(0x85f740958906b317de6ed79663012859067E745B);
1196     TWS private tws = TWS(0x45d8f7Db9b437efbc74BA6a945A81AaF62dcedA7);
1197 
1198     mapping (uint => bool) public craniumsRedeemed;
1199     mapping (uint => bool) public stallionsRedeemed;
1200 
1201     bool public isActive = true;
1202 
1203     string public baseURL;
1204 
1205     function devMint() external onlyOwner {
1206         _safeMint(owner(), 2);
1207     }
1208 
1209     function flipActive() public onlyOwner {
1210         isActive = !isActive;
1211     }
1212 
1213     function setBaseURI(string memory uri) public onlyOwner {
1214         baseURL = uri;
1215     }
1216 
1217     function _baseURI() internal view override returns (string memory) {
1218         return baseURL;
1219     }
1220 
1221     function checkTokens(uint256 craniumID, uint256 stallionID) external view returns (bool craniumClaimed, bool stallionClaimed) {
1222       return (craniumsRedeemed[craniumID], stallionsRedeemed[stallionID]);
1223     }
1224 
1225     function claim(uint256 craniumTokenId, uint256 stallionTokenId) public {
1226         require(isActive, "contract should be active");
1227 
1228         address craniumOwner = twc.ownerOf(craniumTokenId);
1229         address stallionOwner = tws.ownerOf(stallionTokenId);
1230 
1231         require(craniumOwner == msg.sender && stallionOwner == msg.sender, "Must hold Cranium & Stallion in wallet");
1232         require(!craniumsRedeemed[craniumTokenId] && !stallionsRedeemed[stallionTokenId], "Must provide unredeemed tokenIds");
1233    
1234         craniumsRedeemed[craniumTokenId] = true;
1235         stallionsRedeemed[stallionTokenId] = true;
1236         _safeMint(msg.sender, 2);
1237     }
1238 }