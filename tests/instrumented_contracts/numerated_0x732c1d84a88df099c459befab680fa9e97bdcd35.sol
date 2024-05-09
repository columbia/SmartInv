1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // ERC721A Contracts v4.0.0
7 // Creator: Chiru Labs
8 
9 pragma solidity ^0.8.4;
10 
11 /**
12  * @dev Interface of an ERC721A compliant contract.
13  */
14 
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
268 /**
269  * @dev ERC721 token receiver interface.
270  */
271 
272 interface ERC721A__IERC721Receiver {
273     function onERC721Received(
274         address operator,
275         address from,
276         uint256 tokenId,
277         bytes calldata data
278     ) external returns (bytes4);
279 }
280 
281 
282 /**
283  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
284  * the Metadata extension. Built to optimize for lower gas during batch mints.
285  *
286  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
287  *
288  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
289  *
290  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
291  */
292 
293 contract ERC721A is IERC721A {
294     // Mask of an entry in packed address data.
295     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
296 
297     // The bit position of `numberMinted` in packed address data.
298     uint256 private constant BITPOS_NUMBER_MINTED = 64;
299 
300     // The bit position of `numberBurned` in packed address data.
301     uint256 private constant BITPOS_NUMBER_BURNED = 128;
302 
303     // The bit position of `aux` in packed address data.
304     uint256 private constant BITPOS_AUX = 192;
305 
306     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
307     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
308 
309     // The bit position of `startTimestamp` in packed ownership.
310     uint256 private constant BITPOS_START_TIMESTAMP = 160;
311 
312     // The bit mask of the `burned` bit in packed ownership.
313     uint256 private constant BITMASK_BURNED = 1 << 224;
314     
315     // The bit position of the `nextInitialized` bit in packed ownership.
316     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
317 
318     // The bit mask of the `nextInitialized` bit in packed ownership.
319     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
320 
321     // The tokenId of the next token to be minted.
322     uint256 private _currentIndex;
323 
324     // The number of tokens burned.
325     uint256 private _burnCounter;
326 
327     // Token name
328     string private _name;
329 
330     // Token symbol
331     string private _symbol;
332 
333     // Mapping from token ID to ownership details
334     // An empty struct value does not necessarily mean the token is unowned.
335     // See `_packedOwnershipOf` implementation for details.
336     //
337     // Bits Layout:
338     // - [0..159]   `addr`
339     // - [160..223] `startTimestamp`
340     // - [224]      `burned`
341     // - [225]      `nextInitialized`
342     mapping(uint256 => uint256) private _packedOwnerships;
343 
344     // Mapping owner address to address data.
345     //
346     // Bits Layout:
347     // - [0..63]    `balance`
348     // - [64..127]  `numberMinted`
349     // - [128..191] `numberBurned`
350     // - [192..255] `aux`
351     mapping(address => uint256) private _packedAddressData;
352 
353     // Mapping from token ID to approved address.
354     mapping(uint256 => address) private _tokenApprovals;
355 
356     // Mapping from owner to operator approvals
357     mapping(address => mapping(address => bool)) private _operatorApprovals;
358 
359     constructor(string memory name_, string memory symbol_) {
360         _name = name_;
361         _symbol = symbol_;
362         _currentIndex = _startTokenId();
363     }
364 
365     /**
366      * @dev Returns the starting token ID. 
367      * To change the starting token ID, please override this function.
368      */
369     function _startTokenId() internal view virtual returns (uint256) {
370         return 0;
371     }
372 
373     /**
374      * @dev Returns the next token ID to be minted.
375      */
376     function _nextTokenId() internal view returns (uint256) {
377         return _currentIndex;
378     }
379 
380     /**
381      * @dev Returns the total number of tokens in existence.
382      * Burned tokens will reduce the count. 
383      * To get the total number of tokens minted, please see `_totalMinted`.
384      */
385     function totalSupply() public view override returns (uint256) {
386         // Counter underflow is impossible as _burnCounter cannot be incremented
387         // more than `_currentIndex - _startTokenId()` times.
388         unchecked {
389             return _currentIndex - _burnCounter - _startTokenId();
390         }
391     }
392 
393     /**
394      * @dev Returns the total amount of tokens minted in the contract.
395      */
396     function _totalMinted() internal view returns (uint256) {
397         // Counter underflow is impossible as _currentIndex does not decrement,
398         // and it is initialized to `_startTokenId()`
399         unchecked {
400             return _currentIndex - _startTokenId();
401         }
402     }
403 
404     /**
405      * @dev Returns the total number of tokens burned.
406      */
407     function _totalBurned() internal view returns (uint256) {
408         return _burnCounter;
409     }
410 
411     /**
412      * @dev See {IERC165-supportsInterface}.
413      */
414     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
415         // The interface IDs are constants representing the first 4 bytes of the XOR of
416         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
417         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
418         return
419             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
420             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
421             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
422     }
423 
424     /**
425      * @dev See {IERC721-balanceOf}.
426      */
427     function balanceOf(address owner) public view override returns (uint256) {
428         if (owner == address(0)) revert BalanceQueryForZeroAddress();
429         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
430     }
431 
432     /**
433      * Returns the number of tokens minted by `owner`.
434      */
435     function _numberMinted(address owner) internal view returns (uint256) {
436         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
437     }
438 
439     /**
440      * Returns the number of tokens burned by or on behalf of `owner`.
441      */
442     function _numberBurned(address owner) internal view returns (uint256) {
443         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
444     }
445 
446     /**
447      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
448      */
449     function _getAux(address owner) internal view returns (uint64) {
450         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
451     }
452 
453     /**
454      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
455      * If there are multiple variables, please pack them into a uint64.
456      */
457     function _setAux(address owner, uint64 aux) internal {
458         uint256 packed = _packedAddressData[owner];
459         uint256 auxCasted;
460         assembly { // Cast aux without masking.
461             auxCasted := aux
462         }
463         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
464         _packedAddressData[owner] = packed;
465     }
466 
467     /**
468      * Returns the packed ownership data of `tokenId`.
469      */
470     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
471         uint256 curr = tokenId;
472 
473         unchecked {
474             if (_startTokenId() <= curr)
475                 if (curr < _currentIndex) {
476                     uint256 packed = _packedOwnerships[curr];
477                     // If not burned.
478                     if (packed & BITMASK_BURNED == 0) {
479                         // Invariant:
480                         // There will always be an ownership that has an address and is not burned
481                         // before an ownership that does not have an address and is not burned.
482                         // Hence, curr will not underflow.
483                         //
484                         // We can directly compare the packed value.
485                         // If the address is zero, packed is zero.
486                         while (packed == 0) {
487                             packed = _packedOwnerships[--curr];
488                         }
489                         return packed;
490                     }
491                 }
492         }
493         revert OwnerQueryForNonexistentToken();
494     }
495 
496     /**
497      * Returns the unpacked `TokenOwnership` struct from `packed`.
498      */
499     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
500         ownership.addr = address(uint160(packed));
501         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
502         ownership.burned = packed & BITMASK_BURNED != 0;
503     }
504 
505     /**
506      * Returns the unpacked `TokenOwnership` struct at `index`.
507      */
508     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
509         return _unpackedOwnership(_packedOwnerships[index]);
510     }
511 
512     /**
513      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
514      */
515     function _initializeOwnershipAt(uint256 index) internal {
516         if (_packedOwnerships[index] == 0) {
517             _packedOwnerships[index] = _packedOwnershipOf(index);
518         }
519     }
520 
521     /**
522      * Gas spent here starts off proportional to the maximum mint batch size.
523      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
524      */
525     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
526         return _unpackedOwnership(_packedOwnershipOf(tokenId));
527     }
528 
529     /**
530      * @dev See {IERC721-ownerOf}.
531      */
532     function ownerOf(uint256 tokenId) public view override returns (address) {
533         return address(uint160(_packedOwnershipOf(tokenId)));
534     }
535 
536     /**
537      * @dev See {IERC721Metadata-name}.
538      */
539     function name() public view virtual override returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @dev See {IERC721Metadata-symbol}.
545      */
546     function symbol() public view virtual override returns (string memory) {
547         return _symbol;
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-tokenURI}.
552      */
553     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
554         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
555 
556         string memory baseURI = _baseURI();
557         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
558     }
559 
560     /**
561      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
562      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
563      * by default, can be overriden in child contracts.
564      */
565     function _baseURI() internal view virtual returns (string memory) {
566         return '';
567     }
568 
569     /**
570      * @dev Casts the address to uint256 without masking.
571      */
572     function _addressToUint256(address value) private pure returns (uint256 result) {
573         assembly {
574             result := value
575         }
576     }
577 
578     /**
579      * @dev Casts the boolean to uint256 without branching.
580      */
581     function _boolToUint256(bool value) private pure returns (uint256 result) {
582         assembly {
583             result := value
584         }
585     }
586 
587     /**
588      * @dev See {IERC721-approve}.
589      */
590     function approve(address to, uint256 tokenId) public override {
591         address owner = address(uint160(_packedOwnershipOf(tokenId)));
592         if (to == owner) revert ApprovalToCurrentOwner();
593 
594         if (_msgSenderERC721A() != owner)
595             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
596                 revert ApprovalCallerNotOwnerNorApproved();
597             }
598 
599         _tokenApprovals[tokenId] = to;
600         emit Approval(owner, to, tokenId);
601     }
602 
603     /**
604      * @dev See {IERC721-getApproved}.
605      */
606     function getApproved(uint256 tokenId) public view override returns (address) {
607         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
608 
609         return _tokenApprovals[tokenId];
610     }
611 
612     /**
613      * @dev See {IERC721-setApprovalForAll}.
614      */
615     function setApprovalForAll(address operator, bool approved) public virtual override {
616         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
617 
618         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
619         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
620     }
621 
622     /**
623      * @dev See {IERC721-isApprovedForAll}.
624      */
625     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
626         return _operatorApprovals[owner][operator];
627     }
628 
629     /**
630      * @dev See {IERC721-transferFrom}.
631      */
632     function transferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) public virtual override {
637         _transfer(from, to, tokenId);
638     }
639 
640     /**
641      * @dev See {IERC721-safeTransferFrom}.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) public virtual override {
648         safeTransferFrom(from, to, tokenId, '');
649     }
650 
651     /**
652      * @dev See {IERC721-safeTransferFrom}.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes memory _data
659     ) public virtual override {
660         _transfer(from, to, tokenId);
661         if (to.code.length != 0)
662             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
663                 revert TransferToNonERC721ReceiverImplementer();
664             }
665     }
666 
667     /**
668      * @dev Returns whether `tokenId` exists.
669      *
670      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
671      *
672      * Tokens start existing when they are minted (`_mint`),
673      */
674     function _exists(uint256 tokenId) internal view returns (bool) {
675         return
676             _startTokenId() <= tokenId &&
677             tokenId < _currentIndex && // If within bounds,
678             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
679     }
680 
681     /**
682      * @dev Equivalent to `_safeMint(to, quantity, '')`.
683      */
684     function _safeMint(address to, uint256 quantity) internal {
685         _safeMint(to, quantity, '');
686     }
687 
688     /**
689      * @dev Safely mints `quantity` tokens and transfers them to `to`.
690      *
691      * Requirements:
692      *
693      * - If `to` refers to a smart contract, it must implement
694      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
695      * - `quantity` must be greater than 0.
696      *
697      * Emits a {Transfer} event.
698      */
699     function _safeMint(
700         address to,
701         uint256 quantity,
702         bytes memory _data
703     ) internal {
704         uint256 startTokenId = _currentIndex;
705         if (to == address(0)) revert MintToZeroAddress();
706         if (quantity == 0) revert MintZeroQuantity();
707 
708         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
709 
710         // Overflows are incredibly unrealistic.
711         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
712         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
713         unchecked {
714             // Updates:
715             // - `balance += quantity`.
716             // - `numberMinted += quantity`.
717             //
718             // We can directly add to the balance and number minted.
719             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
720 
721             // Updates:
722             // - `address` to the owner.
723             // - `startTimestamp` to the timestamp of minting.
724             // - `burned` to `false`.
725             // - `nextInitialized` to `quantity == 1`.
726             _packedOwnerships[startTokenId] =
727                 _addressToUint256(to) |
728                 (block.timestamp << BITPOS_START_TIMESTAMP) |
729                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
730 
731             uint256 updatedIndex = startTokenId;
732             uint256 end = updatedIndex + quantity;
733 
734             if (to.code.length != 0) {
735                 do {
736                     emit Transfer(address(0), to, updatedIndex);
737                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
738                         revert TransferToNonERC721ReceiverImplementer();
739                     }
740                 } while (updatedIndex < end);
741                 // Reentrancy protection
742                 if (_currentIndex != startTokenId) revert();
743             } else {
744                 do {
745                     emit Transfer(address(0), to, updatedIndex++);
746                 } while (updatedIndex < end);
747             }
748             _currentIndex = updatedIndex;
749         }
750         _afterTokenTransfers(address(0), to, startTokenId, quantity);
751     }
752 
753     /**
754      * @dev Mints `quantity` tokens and transfers them to `to`.
755      *
756      * Requirements:
757      *
758      * - `to` cannot be the zero address.
759      * - `quantity` must be greater than 0.
760      *
761      * Emits a {Transfer} event.
762      */
763     function _mint(address to, uint256 quantity) internal {
764         uint256 startTokenId = _currentIndex;
765         if (to == address(0)) revert MintToZeroAddress();
766         if (quantity == 0) revert MintZeroQuantity();
767 
768         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
769 
770         // Overflows are incredibly unrealistic.
771         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
772         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
773         unchecked {
774             // Updates:
775             // - `balance += quantity`.
776             // - `numberMinted += quantity`.
777             //
778             // We can directly add to the balance and number minted.
779             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
780 
781             // Updates:
782             // - `address` to the owner.
783             // - `startTimestamp` to the timestamp of minting.
784             // - `burned` to `false`.
785             // - `nextInitialized` to `quantity == 1`.
786             _packedOwnerships[startTokenId] =
787                 _addressToUint256(to) |
788                 (block.timestamp << BITPOS_START_TIMESTAMP) |
789                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
790 
791             uint256 updatedIndex = startTokenId;
792             uint256 end = updatedIndex + quantity;
793 
794             do {
795                 emit Transfer(address(0), to, updatedIndex++);
796             } while (updatedIndex < end);
797 
798             _currentIndex = updatedIndex;
799         }
800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
801     }
802 
803     /**
804      * @dev Transfers `tokenId` from `from` to `to`.
805      *
806      * Requirements:
807      *
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _transfer(
814         address from,
815         address to,
816         uint256 tokenId
817     ) private {
818         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
819 
820         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
821 
822         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
823             isApprovedForAll(from, _msgSenderERC721A()) ||
824             getApproved(tokenId) == _msgSenderERC721A());
825 
826         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
827         if (to == address(0)) revert TransferToZeroAddress();
828 
829         _beforeTokenTransfers(from, to, tokenId, 1);
830 
831         // Clear approvals from the previous owner.
832         delete _tokenApprovals[tokenId];
833 
834         // Underflow of the sender's balance is impossible because we check for
835         // ownership above and the recipient's balance can't realistically overflow.
836         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
837         unchecked {
838             // We can directly increment and decrement the balances.
839             --_packedAddressData[from]; // Updates: `balance -= 1`.
840             ++_packedAddressData[to]; // Updates: `balance += 1`.
841 
842             // Updates:
843             // - `address` to the next owner.
844             // - `startTimestamp` to the timestamp of transfering.
845             // - `burned` to `false`.
846             // - `nextInitialized` to `true`.
847             _packedOwnerships[tokenId] =
848                 _addressToUint256(to) |
849                 (block.timestamp << BITPOS_START_TIMESTAMP) |
850                 BITMASK_NEXT_INITIALIZED;
851 
852             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
853             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
854                 uint256 nextTokenId = tokenId + 1;
855                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
856                 if (_packedOwnerships[nextTokenId] == 0) {
857                     // If the next slot is within bounds.
858                     if (nextTokenId != _currentIndex) {
859                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
860                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
861                     }
862                 }
863             }
864         }
865 
866         emit Transfer(from, to, tokenId);
867         _afterTokenTransfers(from, to, tokenId, 1);
868     }
869 
870     /**
871      * @dev Equivalent to `_burn(tokenId, false)`.
872      */
873     function _burn(uint256 tokenId) internal virtual {
874         _burn(tokenId, false);
875     }
876 
877     /**
878      * @dev Destroys `tokenId`.
879      * The approval is cleared when the token is burned.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
888         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
889 
890         address from = address(uint160(prevOwnershipPacked));
891 
892         if (approvalCheck) {
893             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
894                 isApprovedForAll(from, _msgSenderERC721A()) ||
895                 getApproved(tokenId) == _msgSenderERC721A());
896 
897             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
898         }
899 
900         _beforeTokenTransfers(from, address(0), tokenId, 1);
901 
902         // Clear approvals from the previous owner.
903         delete _tokenApprovals[tokenId];
904 
905         // Underflow of the sender's balance is impossible because we check for
906         // ownership above and the recipient's balance can't realistically overflow.
907         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
908         unchecked {
909             // Updates:
910             // - `balance -= 1`.
911             // - `numberBurned += 1`.
912             //
913             // We can directly decrement the balance, and increment the number burned.
914             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
915             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
916 
917             // Updates:
918             // - `address` to the last owner.
919             // - `startTimestamp` to the timestamp of burning.
920             // - `burned` to `true`.
921             // - `nextInitialized` to `true`.
922             _packedOwnerships[tokenId] =
923                 _addressToUint256(from) |
924                 (block.timestamp << BITPOS_START_TIMESTAMP) |
925                 BITMASK_BURNED | 
926                 BITMASK_NEXT_INITIALIZED;
927 
928             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
929             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
930                 uint256 nextTokenId = tokenId + 1;
931                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
932                 if (_packedOwnerships[nextTokenId] == 0) {
933                     // If the next slot is within bounds.
934                     if (nextTokenId != _currentIndex) {
935                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
936                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
937                     }
938                 }
939             }
940         }
941 
942         emit Transfer(from, address(0), tokenId);
943         _afterTokenTransfers(from, address(0), tokenId, 1);
944 
945         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
946         unchecked {
947             _burnCounter++;
948         }
949     }
950 
951     /**
952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkContractOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
967             bytes4 retval
968         ) {
969             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
970         } catch (bytes memory reason) {
971             if (reason.length == 0) {
972                 revert TransferToNonERC721ReceiverImplementer();
973             } else {
974                 assembly {
975                     revert(add(32, reason), mload(reason))
976                 }
977             }
978         }
979     }
980 
981     /**
982      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
983      * And also called before burning one token.
984      *
985      * startTokenId - the first token id to be transferred
986      * quantity - the amount to be transferred
987      *
988      * Calling conditions:
989      *
990      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
991      * transferred to `to`.
992      * - When `from` is zero, `tokenId` will be minted for `to`.
993      * - When `to` is zero, `tokenId` will be burned by `from`.
994      * - `from` and `to` are never both zero.
995      */
996     function _beforeTokenTransfers(
997         address from,
998         address to,
999         uint256 startTokenId,
1000         uint256 quantity
1001     ) internal virtual {}
1002 
1003     /**
1004      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1005      * minting.
1006      * And also called after one token has been burned.
1007      *
1008      * startTokenId - the first token id to be transferred
1009      * quantity - the amount to be transferred
1010      *
1011      * Calling conditions:
1012      *
1013      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1014      * transferred to `to`.
1015      * - When `from` is zero, `tokenId` has been minted for `to`.
1016      * - When `to` is zero, `tokenId` has been burned by `from`.
1017      * - `from` and `to` are never both zero.
1018      */
1019     function _afterTokenTransfers(
1020         address from,
1021         address to,
1022         uint256 startTokenId,
1023         uint256 quantity
1024     ) internal virtual {}
1025 
1026     /**
1027      * @dev Returns the message sender (defaults to `msg.sender`).
1028      *
1029      * If you are writing GSN compatible contracts, you need to override this function.
1030      */
1031     function _msgSenderERC721A() internal view virtual returns (address) {
1032         return msg.sender;
1033     }
1034 
1035     /**
1036      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1037      */
1038     function _toString(uint256 value) internal pure returns (string memory ptr) {
1039         assembly {
1040             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1041             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1042             // We will need 1 32-byte word to store the length, 
1043             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1044             ptr := add(mload(0x40), 128)
1045             // Update the free memory pointer to allocate.
1046             mstore(0x40, ptr)
1047 
1048             // Cache the end of the memory to calculate the length later.
1049             let end := ptr
1050 
1051             // We write the string from the rightmost digit to the leftmost digit.
1052             // The following is essentially a do-while loop that also handles the zero case.
1053             // Costs a bit more than early returning for the zero case,
1054             // but cheaper in terms of deployment and overall runtime costs.
1055             for { 
1056                 // Initialize and perform the first pass without check.
1057                 let temp := value
1058                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1059                 ptr := sub(ptr, 1)
1060                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1061                 mstore8(ptr, add(48, mod(temp, 10)))
1062                 temp := div(temp, 10)
1063             } temp { 
1064                 // Keep dividing `temp` until zero.
1065                 temp := div(temp, 10)
1066             } { // Body of the for loop.
1067                 ptr := sub(ptr, 1)
1068                 mstore8(ptr, add(48, mod(temp, 10)))
1069             }
1070             
1071             let length := sub(end, ptr)
1072             // Move the pointer 32 bytes leftwards to make room for the length.
1073             ptr := sub(ptr, 32)
1074             // Store the length.
1075             mstore(ptr, length)
1076         }
1077     }
1078 }
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1082 
1083 /**
1084  * @dev String operations.
1085  */
1086 
1087 library Strings {
1088     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1089     uint8 private constant _ADDRESS_LENGTH = 20;
1090 
1091     /**
1092      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1093      */
1094     function toString(uint256 value) internal pure returns (string memory) {
1095         // Inspired by OraclizeAPI's implementation - MIT licence
1096         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1097 
1098         if (value == 0) {
1099             return "0";
1100         }
1101         uint256 temp = value;
1102         uint256 digits;
1103         while (temp != 0) {
1104             digits++;
1105             temp /= 10;
1106         }
1107         bytes memory buffer = new bytes(digits);
1108         while (value != 0) {
1109             digits -= 1;
1110             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1111             value /= 10;
1112         }
1113         return string(buffer);
1114     }
1115 
1116     /**
1117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1118      */
1119     function toHexString(uint256 value) internal pure returns (string memory) {
1120         if (value == 0) {
1121             return "0x00";
1122         }
1123         uint256 temp = value;
1124         uint256 length = 0;
1125         while (temp != 0) {
1126             length++;
1127             temp >>= 8;
1128         }
1129         return toHexString(value, length);
1130     }
1131 
1132     /**
1133      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1134      */
1135     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1136         bytes memory buffer = new bytes(2 * length + 2);
1137         buffer[0] = "0";
1138         buffer[1] = "x";
1139         for (uint256 i = 2 * length + 1; i > 1; --i) {
1140             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1141             value >>= 4;
1142         }
1143         require(value == 0, "Strings: hex length insufficient");
1144         return string(buffer);
1145     }
1146 
1147     /**
1148      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1149      */
1150     function toHexString(address addr) internal pure returns (string memory) {
1151         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1152     }
1153 }
1154 
1155 
1156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1157 
1158 /**
1159  * @dev Provides information about the current execution context, including the
1160  * sender of the transaction and its data. While these are generally available
1161  * via msg.sender and msg.data, they should not be accessed in such a direct
1162  * manner, since when dealing with meta-transactions the account sending and
1163  * paying for execution may not be the actual sender (as far as an application
1164  * is concerned).
1165  *
1166  * This contract is only required for intermediate, library-like contracts.
1167  */
1168 
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
1179 
1180 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1181 
1182 /**
1183  * @dev Contract module which provides a basic access control mechanism, where
1184  * there is an account (an owner) that can be granted exclusive access to
1185  * specific functions.
1186  *
1187  * By default, the owner account will be the one that deploys the contract. This
1188  * can later be changed with {transferOwnership}.
1189  *
1190  * This module is used through inheritance. It will make available the modifier
1191  * `onlyOwner`, which can be applied to your functions to restrict their use to
1192  * the owner.
1193  */
1194 
1195 abstract contract Ownable is Context {
1196     address private _owner;
1197 
1198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1199 
1200     /**
1201      * @dev Initializes the contract setting the deployer as the initial owner.
1202      */
1203     constructor() {
1204         _transferOwnership(_msgSender());
1205     }
1206 
1207     /**
1208      * @dev Returns the address of the current owner.
1209      */
1210     function owner() public view virtual returns (address) {
1211         return _owner;
1212     }
1213 
1214     /**
1215      * @dev Throws if called by any account other than the owner.
1216      */
1217     modifier onlyOwner() {
1218         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1219         _;
1220     }
1221 
1222     /**
1223      * @dev Leaves the contract without owner. It will not be possible to call
1224      * `onlyOwner` functions anymore. Can only be called by the current owner.
1225      *
1226      * NOTE: Renouncing ownership will leave the contract without an owner,
1227      * thereby removing any functionality that is only available to the owner.
1228      */
1229     function renounceOwnership() public virtual onlyOwner {
1230         _transferOwnership(address(0));
1231     }
1232 
1233     /**
1234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1235      * Can only be called by the current owner.
1236      */
1237     function transferOwnership(address newOwner) public virtual onlyOwner {
1238         require(newOwner != address(0), "Ownable: new owner is the zero address");
1239         _transferOwnership(newOwner);
1240     }
1241 
1242     /**
1243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1244      * Internal function without access restriction.
1245      */
1246     function _transferOwnership(address newOwner) internal virtual {
1247         address oldOwner = _owner;
1248         _owner = newOwner;
1249         emit OwnershipTransferred(oldOwner, newOwner);
1250     }
1251 }
1252 
1253 
1254 contract Empyreal is ERC721A, Ownable {
1255 
1256     string public baseURI = "";
1257     string public contractURI = "";
1258     uint256 public constant MAX_SUPPLY = 945;
1259     uint256 public constant publicPrice = 20000000000000000;
1260     bool public unpaused = false;
1261 
1262     constructor() ERC721A("Empyreal", "Empyreal") {}
1263 
1264     modifier callerIsUser() {
1265     require(tx.origin == msg.sender, "The caller is another contract");
1266     _;
1267   }
1268 
1269     function devMint(uint256 quantity) external onlyOwner {
1270         _safeMint(msg.sender, quantity);
1271     }
1272 
1273     function publicMint(uint256 quantity) external payable callerIsUser {
1274         address _minter = _msgSender();
1275         require(unpaused, "Sale currently paused");
1276         require(msg.value >= publicPrice * quantity, "Need to send more Ether");
1277         require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds max supply");
1278         require(minted(_minter) + quantity <= 3, "Exceeds max per wallet/transaction");
1279 
1280         _safeMint(_minter, quantity);
1281         refundIfOver(publicPrice * quantity);
1282     }
1283 
1284     function refundIfOver(uint256 price) private {
1285         require(msg.value >= price, "Need to send more ETH.");
1286         if (msg.value > price) {
1287             payable(msg.sender).transfer(msg.value - price);
1288         }
1289     }
1290 
1291     // Override token counter to start at 1 instead of 0
1292     function _startTokenId() internal override view virtual returns (uint256) {
1293         return 1;
1294     }
1295 
1296     function minted(address _owner) public view returns (uint256) {
1297         return _numberMinted(_owner);
1298     }
1299 
1300     function withdraw() external onlyOwner {
1301         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1302         require(success, "Transfer failed.");
1303     }
1304 
1305     function toggleMint() external onlyOwner {
1306         unpaused = !unpaused;
1307     }
1308 
1309     function setBaseURI(string memory _baseURI) external onlyOwner {
1310         baseURI = _baseURI;
1311     }
1312 
1313     function setContractURI(string memory _contractURI) external onlyOwner {
1314         contractURI = _contractURI;
1315     }
1316 
1317     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1318         require(_exists(_tokenId), "Token does not exist.");
1319         return bytes(baseURI).length > 0 ? string(
1320             abi.encodePacked(
1321               baseURI,
1322               Strings.toString(_tokenId),
1323               ".json"
1324             )
1325         ) : "";
1326     }
1327 }