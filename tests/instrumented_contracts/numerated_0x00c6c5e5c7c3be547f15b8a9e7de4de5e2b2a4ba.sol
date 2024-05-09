1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
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
260 /**
261  * @dev ERC721 token receiver interface.
262  */
263 interface ERC721A__IERC721Receiver {
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 /**
273  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
274  * the Metadata extension. Built to optimize for lower gas during batch mints.
275  *
276  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
277  *
278  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
279  *
280  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
281  */
282 contract ERC721A is IERC721A {
283     // Mask of an entry in packed address data.
284     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
285 
286     // The bit position of `numberMinted` in packed address data.
287     uint256 private constant BITPOS_NUMBER_MINTED = 64;
288 
289     // The bit position of `numberBurned` in packed address data.
290     uint256 private constant BITPOS_NUMBER_BURNED = 128;
291 
292     // The bit position of `aux` in packed address data.
293     uint256 private constant BITPOS_AUX = 192;
294 
295     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
296     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
297 
298     // The bit position of `startTimestamp` in packed ownership.
299     uint256 private constant BITPOS_START_TIMESTAMP = 160;
300 
301     // The bit mask of the `burned` bit in packed ownership.
302     uint256 private constant BITMASK_BURNED = 1 << 224;
303     
304     // The bit position of the `nextInitialized` bit in packed ownership.
305     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
306 
307     // The bit mask of the `nextInitialized` bit in packed ownership.
308     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
309 
310     // The tokenId of the next token to be minted.
311     uint256 private _currentIndex;
312 
313     // The number of tokens burned.
314     uint256 private _burnCounter;
315 
316     // Token name
317     string private _name;
318 
319     // Token symbol
320     string private _symbol;
321 
322     // Mapping from token ID to ownership details
323     // An empty struct value does not necessarily mean the token is unowned.
324     // See `_packedOwnershipOf` implementation for details.
325     //
326     // Bits Layout:
327     // - [0..159]   `addr`
328     // - [160..223] `startTimestamp`
329     // - [224]      `burned`
330     // - [225]      `nextInitialized`
331     mapping(uint256 => uint256) private _packedOwnerships;
332 
333     // Mapping owner address to address data.
334     //
335     // Bits Layout:
336     // - [0..63]    `balance`
337     // - [64..127]  `numberMinted`
338     // - [128..191] `numberBurned`
339     // - [192..255] `aux`
340     mapping(address => uint256) private _packedAddressData;
341 
342     // Mapping from token ID to approved address.
343     mapping(uint256 => address) private _tokenApprovals;
344 
345     // Mapping from owner to operator approvals
346     mapping(address => mapping(address => bool)) private _operatorApprovals;
347 
348     constructor(string memory name_, string memory symbol_) {
349         _name = name_;
350         _symbol = symbol_;
351         _currentIndex = _startTokenId();
352     }
353 
354     /**
355      * @dev Returns the starting token ID. 
356      * To change the starting token ID, please override this function.
357      */
358     function _startTokenId() internal view virtual returns (uint256) {
359         return 0;
360     }
361 
362     /**
363      * @dev Returns the next token ID to be minted.
364      */
365     function _nextTokenId() internal view returns (uint256) {
366         return _currentIndex;
367     }
368 
369     /**
370      * @dev Returns the total number of tokens in existence.
371      * Burned tokens will reduce the count. 
372      * To get the total number of tokens minted, please see `_totalMinted`.
373      */
374     function totalSupply() public view override returns (uint256) {
375         // Counter underflow is impossible as _burnCounter cannot be incremented
376         // more than `_currentIndex - _startTokenId()` times.
377         unchecked {
378             return _currentIndex - _burnCounter - _startTokenId();
379         }
380     }
381 
382     /**
383      * @dev Returns the total amount of tokens minted in the contract.
384      */
385     function _totalMinted() internal view returns (uint256) {
386         // Counter underflow is impossible as _currentIndex does not decrement,
387         // and it is initialized to `_startTokenId()`
388         unchecked {
389             return _currentIndex - _startTokenId();
390         }
391     }
392 
393     /**
394      * @dev Returns the total number of tokens burned.
395      */
396     function _totalBurned() internal view returns (uint256) {
397         return _burnCounter;
398     }
399 
400     /**
401      * @dev See {IERC165-supportsInterface}.
402      */
403     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
404         // The interface IDs are constants representing the first 4 bytes of the XOR of
405         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
406         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
407         return
408             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
409             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
410             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
411     }
412 
413     /**
414      * @dev See {IERC721-balanceOf}.
415      */
416     function balanceOf(address owner) public view override returns (uint256) {
417         if (owner == address(0)) revert BalanceQueryForZeroAddress();
418         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
419     }
420 
421     /**
422      * Returns the number of tokens minted by `owner`.
423      */
424     function _numberMinted(address owner) internal view returns (uint256) {
425         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
426     }
427 
428     /**
429      * Returns the number of tokens burned by or on behalf of `owner`.
430      */
431     function _numberBurned(address owner) internal view returns (uint256) {
432         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
433     }
434 
435     /**
436      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
437      */
438     function _getAux(address owner) internal view returns (uint64) {
439         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
440     }
441 
442     /**
443      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
444      * If there are multiple variables, please pack them into a uint64.
445      */
446     function _setAux(address owner, uint64 aux) internal {
447         uint256 packed = _packedAddressData[owner];
448         uint256 auxCasted;
449         assembly { // Cast aux without masking.
450             auxCasted := aux
451         }
452         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
453         _packedAddressData[owner] = packed;
454     }
455 
456     /**
457      * Returns the packed ownership data of `tokenId`.
458      */
459     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
460         uint256 curr = tokenId;
461 
462         unchecked {
463             if (_startTokenId() <= curr)
464                 if (curr < _currentIndex) {
465                     uint256 packed = _packedOwnerships[curr];
466                     // If not burned.
467                     if (packed & BITMASK_BURNED == 0) {
468                         // Invariant:
469                         // There will always be an ownership that has an address and is not burned
470                         // before an ownership that does not have an address and is not burned.
471                         // Hence, curr will not underflow.
472                         //
473                         // We can directly compare the packed value.
474                         // If the address is zero, packed is zero.
475                         while (packed == 0) {
476                             packed = _packedOwnerships[--curr];
477                         }
478                         return packed;
479                     }
480                 }
481         }
482         revert OwnerQueryForNonexistentToken();
483     }
484 
485     /**
486      * Returns the unpacked `TokenOwnership` struct from `packed`.
487      */
488     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
489         ownership.addr = address(uint160(packed));
490         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
491         ownership.burned = packed & BITMASK_BURNED != 0;
492     }
493 
494     /**
495      * Returns the unpacked `TokenOwnership` struct at `index`.
496      */
497     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
498         return _unpackedOwnership(_packedOwnerships[index]);
499     }
500 
501     /**
502      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
503      */
504     function _initializeOwnershipAt(uint256 index) internal {
505         if (_packedOwnerships[index] == 0) {
506             _packedOwnerships[index] = _packedOwnershipOf(index);
507         }
508     }
509 
510     /**
511      * Gas spent here starts off proportional to the maximum mint batch size.
512      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
513      */
514     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
515         return _unpackedOwnership(_packedOwnershipOf(tokenId));
516     }
517 
518     /**
519      * @dev See {IERC721-ownerOf}.
520      */
521     function ownerOf(uint256 tokenId) public view override returns (address) {
522         return address(uint160(_packedOwnershipOf(tokenId)));
523     }
524 
525     /**
526      * @dev See {IERC721Metadata-name}.
527      */
528     function name() public view virtual override returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev See {IERC721Metadata-symbol}.
534      */
535     function symbol() public view virtual override returns (string memory) {
536         return _symbol;
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-tokenURI}.
541      */
542     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
543         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
544 
545         string memory baseURI = _baseURI();
546         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
547     }
548 
549     /**
550      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
551      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
552      * by default, can be overriden in child contracts.
553      */
554     function _baseURI() internal view virtual returns (string memory) {
555         return '';
556     }
557 
558     /**
559      * @dev Casts the address to uint256 without masking.
560      */
561     function _addressToUint256(address value) private pure returns (uint256 result) {
562         assembly {
563             result := value
564         }
565     }
566 
567     /**
568      * @dev Casts the boolean to uint256 without branching.
569      */
570     function _boolToUint256(bool value) private pure returns (uint256 result) {
571         assembly {
572             result := value
573         }
574     }
575 
576     /**
577      * @dev See {IERC721-approve}.
578      */
579     function approve(address to, uint256 tokenId) public override {
580         address owner = address(uint160(_packedOwnershipOf(tokenId)));
581         if (to == owner) revert ApprovalToCurrentOwner();
582 
583         if (_msgSenderERC721A() != owner)
584             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
585                 revert ApprovalCallerNotOwnerNorApproved();
586             }
587 
588         _tokenApprovals[tokenId] = to;
589         emit Approval(owner, to, tokenId);
590     }
591 
592     /**
593      * @dev See {IERC721-getApproved}.
594      */
595     function getApproved(uint256 tokenId) public view override returns (address) {
596         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
597 
598         return _tokenApprovals[tokenId];
599     }
600 
601     /**
602      * @dev See {IERC721-setApprovalForAll}.
603      */
604     function setApprovalForAll(address operator, bool approved) public virtual override {
605         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
606 
607         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
608         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
609     }
610 
611     /**
612      * @dev See {IERC721-isApprovedForAll}.
613      */
614     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
615         return _operatorApprovals[owner][operator];
616     }
617 
618     /**
619      * @dev See {IERC721-transferFrom}.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) public virtual override {
626         _transfer(from, to, tokenId);
627     }
628 
629     /**
630      * @dev See {IERC721-safeTransferFrom}.
631      */
632     function safeTransferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) public virtual override {
637         safeTransferFrom(from, to, tokenId, '');
638     }
639 
640     /**
641      * @dev See {IERC721-safeTransferFrom}.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId,
647         bytes memory _data
648     ) public virtual override {
649         _transfer(from, to, tokenId);
650         if (to.code.length != 0)
651             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
652                 revert TransferToNonERC721ReceiverImplementer();
653             }
654     }
655 
656     /**
657      * @dev Returns whether `tokenId` exists.
658      *
659      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
660      *
661      * Tokens start existing when they are minted (`_mint`),
662      */
663     function _exists(uint256 tokenId) internal view returns (bool) {
664         return
665             _startTokenId() <= tokenId &&
666             tokenId < _currentIndex && // If within bounds,
667             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
668     }
669 
670     /**
671      * @dev Equivalent to `_safeMint(to, quantity, '')`.
672      */
673     function _safeMint(address to, uint256 quantity) internal {
674         _safeMint(to, quantity, '');
675     }
676 
677     /**
678      * @dev Safely mints `quantity` tokens and transfers them to `to`.
679      *
680      * Requirements:
681      *
682      * - If `to` refers to a smart contract, it must implement
683      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
684      * - `quantity` must be greater than 0.
685      *
686      * Emits a {Transfer} event.
687      */
688     function _safeMint(
689         address to,
690         uint256 quantity,
691         bytes memory _data
692     ) internal {
693         uint256 startTokenId = _currentIndex;
694         if (to == address(0)) revert MintToZeroAddress();
695         if (quantity == 0) revert MintZeroQuantity();
696 
697         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
698 
699         // Overflows are incredibly unrealistic.
700         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
701         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
702         unchecked {
703             // Updates:
704             // - `balance += quantity`.
705             // - `numberMinted += quantity`.
706             //
707             // We can directly add to the balance and number minted.
708             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
709 
710             // Updates:
711             // - `address` to the owner.
712             // - `startTimestamp` to the timestamp of minting.
713             // - `burned` to `false`.
714             // - `nextInitialized` to `quantity == 1`.
715             _packedOwnerships[startTokenId] =
716                 _addressToUint256(to) |
717                 (block.timestamp << BITPOS_START_TIMESTAMP) |
718                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
719 
720             uint256 updatedIndex = startTokenId;
721             uint256 end = updatedIndex + quantity;
722 
723             if (to.code.length != 0) {
724                 do {
725                     emit Transfer(address(0), to, updatedIndex);
726                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
727                         revert TransferToNonERC721ReceiverImplementer();
728                     }
729                 } while (updatedIndex < end);
730                 // Reentrancy protection
731                 if (_currentIndex != startTokenId) revert();
732             } else {
733                 do {
734                     emit Transfer(address(0), to, updatedIndex++);
735                 } while (updatedIndex < end);
736             }
737             _currentIndex = updatedIndex;
738         }
739         _afterTokenTransfers(address(0), to, startTokenId, quantity);
740     }
741 
742     /**
743      * @dev Mints `quantity` tokens and transfers them to `to`.
744      *
745      * Requirements:
746      *
747      * - `to` cannot be the zero address.
748      * - `quantity` must be greater than 0.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _mint(address to, uint256 quantity) internal {
753         uint256 startTokenId = _currentIndex;
754         if (to == address(0)) revert MintToZeroAddress();
755         if (quantity == 0) revert MintZeroQuantity();
756 
757         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
758 
759         // Overflows are incredibly unrealistic.
760         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
761         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
762         unchecked {
763             // Updates:
764             // - `balance += quantity`.
765             // - `numberMinted += quantity`.
766             //
767             // We can directly add to the balance and number minted.
768             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
769 
770             // Updates:
771             // - `address` to the owner.
772             // - `startTimestamp` to the timestamp of minting.
773             // - `burned` to `false`.
774             // - `nextInitialized` to `quantity == 1`.
775             _packedOwnerships[startTokenId] =
776                 _addressToUint256(to) |
777                 (block.timestamp << BITPOS_START_TIMESTAMP) |
778                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
779 
780             uint256 updatedIndex = startTokenId;
781             uint256 end = updatedIndex + quantity;
782 
783             do {
784                 emit Transfer(address(0), to, updatedIndex++);
785             } while (updatedIndex < end);
786 
787             _currentIndex = updatedIndex;
788         }
789         _afterTokenTransfers(address(0), to, startTokenId, quantity);
790     }
791 
792     /**
793      * @dev Transfers `tokenId` from `from` to `to`.
794      *
795      * Requirements:
796      *
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must be owned by `from`.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _transfer(
803         address from,
804         address to,
805         uint256 tokenId
806     ) private {
807         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
808 
809         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
810 
811         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
812             isApprovedForAll(from, _msgSenderERC721A()) ||
813             getApproved(tokenId) == _msgSenderERC721A());
814 
815         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
816         if (to == address(0)) revert TransferToZeroAddress();
817 
818         _beforeTokenTransfers(from, to, tokenId, 1);
819 
820         // Clear approvals from the previous owner.
821         delete _tokenApprovals[tokenId];
822 
823         // Underflow of the sender's balance is impossible because we check for
824         // ownership above and the recipient's balance can't realistically overflow.
825         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
826         unchecked {
827             // We can directly increment and decrement the balances.
828             --_packedAddressData[from]; // Updates: `balance -= 1`.
829             ++_packedAddressData[to]; // Updates: `balance += 1`.
830 
831             // Updates:
832             // - `address` to the next owner.
833             // - `startTimestamp` to the timestamp of transfering.
834             // - `burned` to `false`.
835             // - `nextInitialized` to `true`.
836             _packedOwnerships[tokenId] =
837                 _addressToUint256(to) |
838                 (block.timestamp << BITPOS_START_TIMESTAMP) |
839                 BITMASK_NEXT_INITIALIZED;
840 
841             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
842             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
843                 uint256 nextTokenId = tokenId + 1;
844                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
845                 if (_packedOwnerships[nextTokenId] == 0) {
846                     // If the next slot is within bounds.
847                     if (nextTokenId != _currentIndex) {
848                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
849                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
850                     }
851                 }
852             }
853         }
854 
855         emit Transfer(from, to, tokenId);
856         _afterTokenTransfers(from, to, tokenId, 1);
857     }
858 
859     /**
860      * @dev Equivalent to `_burn(tokenId, false)`.
861      */
862     function _burn(uint256 tokenId) internal virtual {
863         _burn(tokenId, false);
864     }
865 
866     /**
867      * @dev Destroys `tokenId`.
868      * The approval is cleared when the token is burned.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
877         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
878 
879         address from = address(uint160(prevOwnershipPacked));
880 
881         if (approvalCheck) {
882             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
883                 isApprovedForAll(from, _msgSenderERC721A()) ||
884                 getApproved(tokenId) == _msgSenderERC721A());
885 
886             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
887         }
888 
889         _beforeTokenTransfers(from, address(0), tokenId, 1);
890 
891         // Clear approvals from the previous owner.
892         delete _tokenApprovals[tokenId];
893 
894         // Underflow of the sender's balance is impossible because we check for
895         // ownership above and the recipient's balance can't realistically overflow.
896         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
897         unchecked {
898             // Updates:
899             // - `balance -= 1`.
900             // - `numberBurned += 1`.
901             //
902             // We can directly decrement the balance, and increment the number burned.
903             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
904             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
905 
906             // Updates:
907             // - `address` to the last owner.
908             // - `startTimestamp` to the timestamp of burning.
909             // - `burned` to `true`.
910             // - `nextInitialized` to `true`.
911             _packedOwnerships[tokenId] =
912                 _addressToUint256(from) |
913                 (block.timestamp << BITPOS_START_TIMESTAMP) |
914                 BITMASK_BURNED | 
915                 BITMASK_NEXT_INITIALIZED;
916 
917             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
918             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
919                 uint256 nextTokenId = tokenId + 1;
920                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
921                 if (_packedOwnerships[nextTokenId] == 0) {
922                     // If the next slot is within bounds.
923                     if (nextTokenId != _currentIndex) {
924                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
925                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
926                     }
927                 }
928             }
929         }
930 
931         emit Transfer(from, address(0), tokenId);
932         _afterTokenTransfers(from, address(0), tokenId, 1);
933 
934         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
935         unchecked {
936             _burnCounter++;
937         }
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
942      *
943      * @param from address representing the previous owner of the given token ID
944      * @param to target address that will receive the tokens
945      * @param tokenId uint256 ID of the token to be transferred
946      * @param _data bytes optional data to send along with the call
947      * @return bool whether the call correctly returned the expected magic value
948      */
949     function _checkContractOnERC721Received(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) private returns (bool) {
955         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
956             bytes4 retval
957         ) {
958             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
959         } catch (bytes memory reason) {
960             if (reason.length == 0) {
961                 revert TransferToNonERC721ReceiverImplementer();
962             } else {
963                 assembly {
964                     revert(add(32, reason), mload(reason))
965                 }
966             }
967         }
968     }
969 
970     /**
971      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
972      * And also called before burning one token.
973      *
974      * startTokenId - the first token id to be transferred
975      * quantity - the amount to be transferred
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` will be minted for `to`.
982      * - When `to` is zero, `tokenId` will be burned by `from`.
983      * - `from` and `to` are never both zero.
984      */
985     function _beforeTokenTransfers(
986         address from,
987         address to,
988         uint256 startTokenId,
989         uint256 quantity
990     ) internal virtual {}
991 
992     /**
993      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
994      * minting.
995      * And also called after one token has been burned.
996      *
997      * startTokenId - the first token id to be transferred
998      * quantity - the amount to be transferred
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` has been minted for `to`.
1005      * - When `to` is zero, `tokenId` has been burned by `from`.
1006      * - `from` and `to` are never both zero.
1007      */
1008     function _afterTokenTransfers(
1009         address from,
1010         address to,
1011         uint256 startTokenId,
1012         uint256 quantity
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Returns the message sender (defaults to `msg.sender`).
1017      *
1018      * If you are writing GSN compatible contracts, you need to override this function.
1019      */
1020     function _msgSenderERC721A() internal view virtual returns (address) {
1021         return msg.sender;
1022     }
1023 
1024     /**
1025      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1026      */
1027     function _toString(uint256 value) internal pure returns (string memory ptr) {
1028         assembly {
1029             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1030             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1031             // We will need 1 32-byte word to store the length, 
1032             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1033             ptr := add(mload(0x40), 128)
1034             // Update the free memory pointer to allocate.
1035             mstore(0x40, ptr)
1036 
1037             // Cache the end of the memory to calculate the length later.
1038             let end := ptr
1039 
1040             // We write the string from the rightmost digit to the leftmost digit.
1041             // The following is essentially a do-while loop that also handles the zero case.
1042             // Costs a bit more than early returning for the zero case,
1043             // but cheaper in terms of deployment and overall runtime costs.
1044             for { 
1045                 // Initialize and perform the first pass without check.
1046                 let temp := value
1047                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1048                 ptr := sub(ptr, 1)
1049                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1050                 mstore8(ptr, add(48, mod(temp, 10)))
1051                 temp := div(temp, 10)
1052             } temp { 
1053                 // Keep dividing `temp` until zero.
1054                 temp := div(temp, 10)
1055             } { // Body of the for loop.
1056                 ptr := sub(ptr, 1)
1057                 mstore8(ptr, add(48, mod(temp, 10)))
1058             }
1059             
1060             let length := sub(end, ptr)
1061             // Move the pointer 32 bytes leftwards to make room for the length.
1062             ptr := sub(ptr, 32)
1063             // Store the length.
1064             mstore(ptr, length)
1065         }
1066     }
1067 }
1068 
1069 
1070 /**
1071  * @dev Provides information about the current execution context, including the
1072  * sender of the transaction and its data. While these are generally available
1073  * via msg.sender and msg.data, they should not be accessed in such a direct
1074  * manner, since when dealing with meta-transactions the account sending and
1075  * paying for execution may not be the actual sender (as far as an application
1076  * is concerned).
1077  *
1078  * This contract is only required for intermediate, library-like contracts.
1079  */
1080 abstract contract Context {
1081     function _msgSender() internal view virtual returns (address) {
1082         return msg.sender;
1083     }
1084 
1085     function _msgData() internal view virtual returns (bytes calldata) {
1086         return msg.data;
1087     }
1088 }
1089 
1090 
1091 /**
1092  * @dev Contract module which provides a basic access control mechanism, where
1093  * there is an account (an owner) that can be granted exclusive access to
1094  * specific functions.
1095  *
1096  * By default, the owner account will be the one that deploys the contract. This
1097  * can later be changed with {transferOwnership}.
1098  *
1099  * This module is used through inheritance. It will make available the modifier
1100  * `onlyOwner`, which can be applied to your functions to restrict their use to
1101  * the owner.
1102  */
1103 abstract contract Ownable is Context {
1104     address private _owner;
1105 
1106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1107 
1108     /**
1109      * @dev Initializes the contract setting the deployer as the initial owner.
1110      */
1111     constructor() {
1112         _transferOwnership(_msgSender());
1113     }
1114 
1115     /**
1116      * @dev Throws if called by any account other than the owner.
1117      */
1118     modifier onlyOwner() {
1119         _checkOwner();
1120         _;
1121     }
1122 
1123     /**
1124      * @dev Returns the address of the current owner.
1125      */
1126     function owner() public view virtual returns (address) {
1127         return _owner;
1128     }
1129 
1130     /**
1131      * @dev Throws if the sender is not the owner.
1132      */
1133     function _checkOwner() internal view virtual {
1134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1135     }
1136 
1137     /**
1138      * @dev Leaves the contract without owner. It will not be possible to call
1139      * `onlyOwner` functions anymore. Can only be called by the current owner.
1140      *
1141      * NOTE: Renouncing ownership will leave the contract without an owner,
1142      * thereby removing any functionality that is only available to the owner.
1143      */
1144     function renounceOwnership() public virtual onlyOwner {
1145         _transferOwnership(address(0));
1146     }
1147 
1148     /**
1149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1150      * Can only be called by the current owner.
1151      */
1152     function transferOwnership(address newOwner) public virtual onlyOwner {
1153         require(newOwner != address(0), "Ownable: new owner is the zero address");
1154         _transferOwnership(newOwner);
1155     }
1156 
1157     /**
1158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1159      * Internal function without access restriction.
1160      */
1161     function _transferOwnership(address newOwner) internal virtual {
1162         address oldOwner = _owner;
1163         _owner = newOwner;
1164         emit OwnershipTransferred(oldOwner, newOwner);
1165     }
1166 }
1167 
1168 /**
1169  * @dev Interface of the ERC165 standard, as defined in the
1170  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1171  *
1172  * Implementers can declare support of contract interfaces, which can then be
1173  * queried by others ({ERC165Checker}).
1174  *
1175  * For an implementation, see {ERC165}.
1176  */
1177 interface IERC165 {
1178     /**
1179      * @dev Returns true if this contract implements the interface defined by
1180      * `interfaceId`. See the corresponding
1181      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1182      * to learn more about how these ids are created.
1183      *
1184      * This function call must use less than 30 000 gas.
1185      */
1186     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1187 }
1188 
1189 
1190 /**
1191  * @dev Interface for the NFT Royalty Standard.
1192  *
1193  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1194  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1195  *
1196  * _Available since v4.5._
1197  */
1198 interface IERC2981 is IERC165 {
1199     /**
1200      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1201      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1202      */
1203     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1204         external
1205         view
1206         returns (address receiver, uint256 royaltyAmount);
1207 }
1208 
1209 
1210 /// @dev This is a contract used to add ERC2981 support to ERC721A
1211 abstract contract ERC2981 is IERC2981 {
1212     uint256 public constant MULTIPLIER = 10000;
1213     uint256 public value;
1214 
1215     error RoyaltyValueOutOfRange();
1216 
1217     /// @dev Sets token royalties
1218     /// @param _value percentage (using 2 decimals - 10000 = 100, 0 = 0)
1219     function _setTokenRoyalty(uint256 _value) internal {
1220         if (_value > MULTIPLIER) revert RoyaltyValueOutOfRange();
1221         value = _value;
1222     }
1223 }
1224 
1225 
1226 contract PriveSociete is ERC721A, Ownable, ERC2981 {
1227     enum MintStatus {
1228         NOT_WHITELISTED,
1229         WHITELISTED,
1230         MINTED
1231     }
1232 
1233     uint256 private constant MAX_SUPPLY = 999;
1234     uint256 private constant INITIAL_SUPPLY = 587;
1235     uint256 private constant ROYALTY = 500;
1236     uint256 public constant MINT_START_TIME = 1661954400;
1237     uint256 public constant MINT_CLOSE_TIME = 1662559200;
1238 
1239     string public baseURI;
1240     bool public isRevealed;
1241     mapping(address => MintStatus) public userMints;
1242 
1243     event Whitelisted(address[] _userList);
1244     event Blacklisted(address _user);
1245     event PermanentURI(string _value, uint256 indexed _id);
1246 
1247     error ExceedsMaxSupply();
1248     error NotWhitelisted();
1249     error AlreadyMinted();
1250     error CannotBeBlacklisted();
1251     error CannotBeWhitelisted();
1252     error AlreadyRevealed();
1253     error MintNotStarted();
1254     error MintEnded();
1255     error MintInProgress();
1256 
1257     constructor(string memory _initBaseURI) ERC721A("Prive OG", "POG") {
1258         baseURI = _initBaseURI;
1259         value = ROYALTY;
1260         isRevealed = false;
1261 
1262         _safeMint(msg.sender, INITIAL_SUPPLY);
1263     }
1264     
1265     function setRevealed() external onlyOwner {
1266         isRevealed = true;
1267     }
1268 
1269     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1270         if(isRevealed) revert AlreadyRevealed();
1271         baseURI = _newBaseURI;
1272     }
1273 
1274     function _baseURI() internal view override returns (string memory) {
1275         return baseURI;
1276     }
1277 
1278     function tokenURI(uint256 tokenId)
1279         public
1280         view
1281         override
1282         returns (string memory)
1283     {
1284         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1285 
1286         string memory baseURI_ = _baseURI();
1287         return
1288             bytes(baseURI_).length != 0
1289                 ? string(abi.encodePacked(baseURI_, _toString(tokenId), ".json"))
1290                 : "";
1291     }
1292 
1293     function _startTokenId() internal pure override returns (uint256) {
1294         return 1;
1295     }
1296 
1297     /// @inheritdoc IERC2981
1298     function royaltyInfo(uint256 , uint256 _value)
1299         external
1300         view
1301         override
1302         returns (address receiver, uint256 royaltyAmount)
1303     {
1304         return (owner(), (_value * value) / MULTIPLIER);
1305     }
1306 
1307     function setTokenRoyalty(uint256 _value) external onlyOwner {
1308         _setTokenRoyalty(_value);
1309     }
1310 
1311     function whitelist(address[] calldata _users) external onlyOwner {
1312         for (uint256 index = 0; index < _users.length; index++) {
1313             if (userMints[_users[index]] == MintStatus.MINTED)
1314                 revert CannotBeWhitelisted();
1315             userMints[_users[index]] = MintStatus.WHITELISTED;
1316         }
1317 
1318         emit Whitelisted(_users);
1319     }
1320 
1321     function blacklist(address[] calldata _users) external onlyOwner {
1322         for (uint256 index = 0; index < _users.length; index++) {
1323             if (
1324                 userMints[_users[index]] == MintStatus.NOT_WHITELISTED ||
1325                 userMints[_users[index]] == MintStatus.MINTED
1326             ) revert CannotBeBlacklisted();
1327 
1328             userMints[_users[index]] = MintStatus.NOT_WHITELISTED;
1329 
1330             emit Blacklisted(_users[index]);
1331         }
1332     }
1333 
1334     function mint() external {
1335         _checkAndMint(msg.sender);
1336     }
1337 
1338     function mintTo(address to_) external {
1339         _checkAndMint(to_);
1340     }
1341 
1342     function _checkAndMint(address to_) private {
1343         if(block.timestamp < MINT_START_TIME) revert MintNotStarted();
1344         if(block.timestamp > MINT_CLOSE_TIME) revert MintEnded();
1345 
1346         if (userMints[to_] == MintStatus.NOT_WHITELISTED)
1347             revert NotWhitelisted();
1348 
1349         if (userMints[to_] == MintStatus.MINTED) revert AlreadyMinted();
1350 
1351         userMints[to_] = MintStatus.MINTED;
1352         _safeMint(to_, 1);
1353 
1354         if (totalSupply() > MAX_SUPPLY) revert ExceedsMaxSupply();
1355     }
1356 
1357     function mintRemaining() external onlyOwner {
1358         if(block.timestamp < MINT_CLOSE_TIME) revert MintInProgress();
1359         _safeMint(msg.sender, MAX_SUPPLY - totalSupply());
1360     }
1361 
1362     /**
1363      * @dev See {IERC165-supportsInterface}.
1364      */
1365     function supportsInterface(bytes4 interfaceId)
1366         public
1367         view
1368         virtual
1369         override(IERC165, ERC721A)
1370         returns (bool)
1371     {
1372         // The interface IDs are constants representing the first 4 bytes of the XOR of
1373         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1374         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1375         return
1376             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1377             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1378             interfaceId == 0x5b5e139f || // ERC165 interface ID for ERC721Metadata.
1379             interfaceId == type(IERC2981).interfaceId; // ERC165 interface ID for ERC2981
1380     }
1381 }