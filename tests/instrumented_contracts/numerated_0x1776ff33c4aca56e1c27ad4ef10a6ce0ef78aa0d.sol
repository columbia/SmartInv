1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /**
6  * @dev Interface of an ERC721A compliant contract.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * The caller cannot approve to their own address.
21      */
22     error ApproveToCaller();
23 
24     /**
25      * The caller cannot approve to the current owner.
26      */
27     error ApprovalToCurrentOwner();
28 
29     /**
30      * Cannot query the balance for the zero address.
31      */
32     error BalanceQueryForZeroAddress();
33 
34     /**
35      * Cannot mint to the zero address.
36      */
37     error MintToZeroAddress();
38 
39     /**
40      * The quantity of tokens minted must be more than zero.
41      */
42     error MintZeroQuantity();
43 
44     /**
45      * The token does not exist.
46      */
47     error OwnerQueryForNonexistentToken();
48 
49     /**
50      * The caller must own the token or be an approved operator.
51      */
52     error TransferCallerNotOwnerNorApproved();
53 
54     /**
55      * The token must be owned by `from`.
56      */
57     error TransferFromIncorrectOwner();
58 
59     /**
60      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     struct TokenOwnership {
75         // The address of the owner.
76         address addr;
77         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
78         uint64 startTimestamp;
79         // Whether the token has been burned.
80         bool burned;
81     }
82 
83     /**
84      * @dev Returns the total amount of tokens stored by the contract.
85      *
86      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     // ==============================
91     //            IERC165
92     // ==============================
93 
94     /**
95      * @dev Returns true if this contract implements the interface defined by
96      * `interfaceId`. See the corresponding
97      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
98      * to learn more about how these ids are created.
99      *
100      * This function call must use less than 30 000 gas.
101      */
102     function supportsInterface(bytes4 interfaceId) external view returns (bool);
103 
104     // ==============================
105     //            IERC721
106     // ==============================
107 
108     /**
109      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
115      */
116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
117 
118     /**
119      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
120      */
121     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
122 
123     /**
124      * @dev Returns the number of tokens in ``owner``'s account.
125      */
126     function balanceOf(address owner) external view returns (uint256 balance);
127 
128     /**
129      * @dev Returns the owner of the `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function ownerOf(uint256 tokenId) external view returns (address owner);
136 
137     /**
138      * @dev Safely transfers `tokenId` token from `from` to `to`.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must exist and be owned by `from`.
145      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147      *
148      * Emits a {Transfer} event.
149      */
150     function safeTransferFrom(
151         address from,
152         address to,
153         uint256 tokenId,
154         bytes calldata data
155     ) external;
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
159      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     /**
178      * @dev Transfers `tokenId` token from `from` to `to`.
179      *
180      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must be owned by `from`.
187      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external;
196 
197     /**
198      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
199      * The approval is cleared when the token is transferred.
200      *
201      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
202      *
203      * Requirements:
204      *
205      * - The caller must own the token or be an approved operator.
206      * - `tokenId` must exist.
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address to, uint256 tokenId) external;
211 
212     /**
213      * @dev Approve or remove `operator` as an operator for the caller.
214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
215      *
216      * Requirements:
217      *
218      * - The `operator` cannot be the caller.
219      *
220      * Emits an {ApprovalForAll} event.
221      */
222     function setApprovalForAll(address operator, bool _approved) external;
223 
224     /**
225      * @dev Returns the account approved for `tokenId` token.
226      *
227      * Requirements:
228      *
229      * - `tokenId` must exist.
230      */
231     function getApproved(uint256 tokenId) external view returns (address operator);
232 
233     /**
234      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
235      *
236      * See {setApprovalForAll}
237      */
238     function isApprovedForAll(address owner, address operator) external view returns (bool);
239 
240     // ==============================
241     //        IERC721Metadata
242     // ==============================
243 
244     /**
245      * @dev Returns the token collection name.
246      */
247     function name() external view returns (string memory);
248 
249     /**
250      * @dev Returns the token collection symbol.
251      */
252     function symbol() external view returns (string memory);
253 
254     /**
255      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
256      */
257     function tokenURI(uint256 tokenId) external view returns (string memory);
258 }
259 
260 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
261 
262 
263 // ERC721A Contracts v3.3.0
264 // Creator: Chiru Labs
265 
266 pragma solidity ^0.8.4;
267 
268 
269 /**
270  * @dev ERC721 token receiver interface.
271  */
272 interface ERC721A__IERC721Receiver {
273     function onERC721Received(
274         address operator,
275         address from,
276         uint256 tokenId,
277         bytes calldata data
278     ) external returns (bytes4);
279 }
280 
281 /**
282  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
283  * the Metadata extension. Built to optimize for lower gas during batch mints.
284  *
285  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
286  *
287  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
288  *
289  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
290  */
291 contract ERC721A is IERC721A {
292     // Mask of an entry in packed address data.
293     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
294 
295     // The bit position of `numberMinted` in packed address data.
296     uint256 private constant BITPOS_NUMBER_MINTED = 64;
297 
298     // The bit position of `numberBurned` in packed address data.
299     uint256 private constant BITPOS_NUMBER_BURNED = 128;
300 
301     // The bit position of `aux` in packed address data.
302     uint256 private constant BITPOS_AUX = 192;
303 
304     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
305     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
306 
307     // The bit position of `startTimestamp` in packed ownership.
308     uint256 private constant BITPOS_START_TIMESTAMP = 160;
309 
310     // The bit mask of the `burned` bit in packed ownership.
311     uint256 private constant BITMASK_BURNED = 1 << 224;
312     
313     // The bit position of the `nextInitialized` bit in packed ownership.
314     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
315 
316     // The bit mask of the `nextInitialized` bit in packed ownership.
317     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
318 
319     // The tokenId of the next token to be minted.
320     uint256 private _currentIndex;
321 
322     // The number of tokens burned.
323     uint256 private _burnCounter;
324 
325     // Token name
326     string private _name;
327 
328     // Token symbol
329     string private _symbol;
330 
331     // Mapping from token ID to ownership details
332     // An empty struct value does not necessarily mean the token is unowned.
333     // See `_packedOwnershipOf` implementation for details.
334     //
335     // Bits Layout:
336     // - [0..159]   `addr`
337     // - [160..223] `startTimestamp`
338     // - [224]      `burned`
339     // - [225]      `nextInitialized`
340     mapping(uint256 => uint256) private _packedOwnerships;
341 
342     // Mapping owner address to address data.
343     //
344     // Bits Layout:
345     // - [0..63]    `balance`
346     // - [64..127]  `numberMinted`
347     // - [128..191] `numberBurned`
348     // - [192..255] `aux`
349     mapping(address => uint256) private _packedAddressData;
350 
351     // Mapping from token ID to approved address.
352     mapping(uint256 => address) private _tokenApprovals;
353 
354     // Mapping from owner to operator approvals
355     mapping(address => mapping(address => bool)) private _operatorApprovals;
356 
357     constructor(string memory name_, string memory symbol_) {
358         _name = name_;
359         _symbol = symbol_;
360         _currentIndex = _startTokenId();
361     }
362 
363     /**
364      * @dev Returns the starting token ID. 
365      * To change the starting token ID, please override this function.
366      */
367     function _startTokenId() internal view virtual returns (uint256) {
368         return 0;
369     }
370 
371     /**
372      * @dev Returns the next token ID to be minted.
373      */
374     function _nextTokenId() internal view returns (uint256) {
375         return _currentIndex;
376     }
377 
378     /**
379      * @dev Returns the total number of tokens in existence.
380      * Burned tokens will reduce the count. 
381      * To get the total number of tokens minted, please see `_totalMinted`.
382      */
383     function totalSupply() public view override returns (uint256) {
384         // Counter underflow is impossible as _burnCounter cannot be incremented
385         // more than `_currentIndex - _startTokenId()` times.
386         unchecked {
387             return _currentIndex - _burnCounter - _startTokenId();
388         }
389     }
390 
391     /**
392      * @dev Returns the total amount of tokens minted in the contract.
393      */
394     function _totalMinted() internal view returns (uint256) {
395         // Counter underflow is impossible as _currentIndex does not decrement,
396         // and it is initialized to `_startTokenId()`
397         unchecked {
398             return _currentIndex - _startTokenId();
399         }
400     }
401 
402     /**
403      * @dev Returns the total number of tokens burned.
404      */
405     function _totalBurned() internal view returns (uint256) {
406         return _burnCounter;
407     }
408 
409     /**
410      * @dev See {IERC165-supportsInterface}.
411      */
412     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
413         // The interface IDs are constants representing the first 4 bytes of the XOR of
414         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
415         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
416         return
417             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
418             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
419             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
420     }
421 
422     /**
423      * @dev See {IERC721-balanceOf}.
424      */
425     function balanceOf(address owner) public view override returns (uint256) {
426         if (owner == address(0)) revert BalanceQueryForZeroAddress();
427         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
428     }
429 
430     /**
431      * Returns the number of tokens minted by `owner`.
432      */
433     function _numberMinted(address owner) internal view returns (uint256) {
434         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
435     }
436 
437     /**
438      * Returns the number of tokens burned by or on behalf of `owner`.
439      */
440     function _numberBurned(address owner) internal view returns (uint256) {
441         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
442     }
443 
444     /**
445      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
446      */
447     function _getAux(address owner) internal view returns (uint64) {
448         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
449     }
450 
451     /**
452      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
453      * If there are multiple variables, please pack them into a uint64.
454      */
455     function _setAux(address owner, uint64 aux) internal {
456         uint256 packed = _packedAddressData[owner];
457         uint256 auxCasted;
458         assembly { // Cast aux without masking.
459             auxCasted := aux
460         }
461         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
462         _packedAddressData[owner] = packed;
463     }
464 
465     /**
466      * Returns the packed ownership data of `tokenId`.
467      */
468     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
469         uint256 curr = tokenId;
470 
471         unchecked {
472             if (_startTokenId() <= curr)
473                 if (curr < _currentIndex) {
474                     uint256 packed = _packedOwnerships[curr];
475                     // If not burned.
476                     if (packed & BITMASK_BURNED == 0) {
477                         // Invariant:
478                         // There will always be an ownership that has an address and is not burned
479                         // before an ownership that does not have an address and is not burned.
480                         // Hence, curr will not underflow.
481                         //
482                         // We can directly compare the packed value.
483                         // If the address is zero, packed is zero.
484                         while (packed == 0) {
485                             packed = _packedOwnerships[--curr];
486                         }
487                         return packed;
488                     }
489                 }
490         }
491         revert OwnerQueryForNonexistentToken();
492     }
493 
494     /**
495      * Returns the unpacked `TokenOwnership` struct from `packed`.
496      */
497     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
498         ownership.addr = address(uint160(packed));
499         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
500         ownership.burned = packed & BITMASK_BURNED != 0;
501     }
502 
503     /**
504      * Returns the unpacked `TokenOwnership` struct at `index`.
505      */
506     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
507         return _unpackedOwnership(_packedOwnerships[index]);
508     }
509 
510     /**
511      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
512      */
513     function _initializeOwnershipAt(uint256 index) internal {
514         if (_packedOwnerships[index] == 0) {
515             _packedOwnerships[index] = _packedOwnershipOf(index);
516         }
517     }
518 
519     /**
520      * Gas spent here starts off proportional to the maximum mint batch size.
521      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
522      */
523     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
524         return _unpackedOwnership(_packedOwnershipOf(tokenId));
525     }
526 
527     /**
528      * @dev See {IERC721-ownerOf}.
529      */
530     function ownerOf(uint256 tokenId) public view override returns (address) {
531         return address(uint160(_packedOwnershipOf(tokenId)));
532     }
533 
534     /**
535      * @dev See {IERC721Metadata-name}.
536      */
537     function name() public view virtual override returns (string memory) {
538         return _name;
539     }
540 
541     /**
542      * @dev See {IERC721Metadata-symbol}.
543      */
544     function symbol() public view virtual override returns (string memory) {
545         return _symbol;
546     }
547 
548     /**
549      * @dev See {IERC721Metadata-tokenURI}.
550      */
551     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
552         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
553 
554         string memory baseURI = _baseURI();
555         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
556     }
557 
558     /**
559      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
560      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
561      * by default, can be overriden in child contracts.
562      */
563     function _baseURI() internal view virtual returns (string memory) {
564         return '';
565     }
566 
567     /**
568      * @dev Casts the address to uint256 without masking.
569      */
570     function _addressToUint256(address value) private pure returns (uint256 result) {
571         assembly {
572             result := value
573         }
574     }
575 
576     /**
577      * @dev Casts the boolean to uint256 without branching.
578      */
579     function _boolToUint256(bool value) private pure returns (uint256 result) {
580         assembly {
581             result := value
582         }
583     }
584 
585     /**
586      * @dev See {IERC721-approve}.
587      */
588     function approve(address to, uint256 tokenId) public override {
589         address owner = address(uint160(_packedOwnershipOf(tokenId)));
590         if (to == owner) revert ApprovalToCurrentOwner();
591 
592         if (_msgSenderERC721A() != owner)
593             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
594                 revert ApprovalCallerNotOwnerNorApproved();
595             }
596 
597         _tokenApprovals[tokenId] = to;
598         emit Approval(owner, to, tokenId);
599     }
600 
601     /**
602      * @dev See {IERC721-getApproved}.
603      */
604     function getApproved(uint256 tokenId) public view override returns (address) {
605         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
606 
607         return _tokenApprovals[tokenId];
608     }
609 
610     /**
611      * @dev See {IERC721-setApprovalForAll}.
612      */
613     function setApprovalForAll(address operator, bool approved) public virtual override {
614         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
615 
616         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
617         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
618     }
619 
620     /**
621      * @dev See {IERC721-isApprovedForAll}.
622      */
623     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
624         return _operatorApprovals[owner][operator];
625     }
626 
627     /**
628      * @dev See {IERC721-transferFrom}.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) public virtual override {
635         _transfer(from, to, tokenId);
636     }
637 
638     /**
639      * @dev See {IERC721-safeTransferFrom}.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) public virtual override {
646         safeTransferFrom(from, to, tokenId, '');
647     }
648 
649     /**
650      * @dev See {IERC721-safeTransferFrom}.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId,
656         bytes memory _data
657     ) public virtual override {
658         _transfer(from, to, tokenId);
659         if (to.code.length != 0)
660             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
661                 revert TransferToNonERC721ReceiverImplementer();
662             }
663     }
664 
665     /**
666      * @dev Returns whether `tokenId` exists.
667      *
668      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
669      *
670      * Tokens start existing when they are minted (`_mint`),
671      */
672     function _exists(uint256 tokenId) internal view returns (bool) {
673         return
674             _startTokenId() <= tokenId &&
675             tokenId < _currentIndex && // If within bounds,
676             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
677     }
678 
679     /**
680      * @dev Equivalent to `_safeMint(to, quantity, '')`.
681      */
682     function _safeMint(address to, uint256 quantity) internal {
683         _safeMint(to, quantity, '');
684     }
685 
686     /**
687      * @dev Safely mints `quantity` tokens and transfers them to `to`.
688      *
689      * Requirements:
690      *
691      * - If `to` refers to a smart contract, it must implement
692      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
693      * - `quantity` must be greater than 0.
694      *
695      * Emits a {Transfer} event.
696      */
697     function _safeMint(
698         address to,
699         uint256 quantity,
700         bytes memory _data
701     ) internal {
702         uint256 startTokenId = _currentIndex;
703         if (to == address(0)) revert MintToZeroAddress();
704         if (quantity == 0) revert MintZeroQuantity();
705 
706         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
707 
708         // Overflows are incredibly unrealistic.
709         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
710         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
711         unchecked {
712             // Updates:
713             // - `balance += quantity`.
714             // - `numberMinted += quantity`.
715             //
716             // We can directly add to the balance and number minted.
717             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
718 
719             // Updates:
720             // - `address` to the owner.
721             // - `startTimestamp` to the timestamp of minting.
722             // - `burned` to `false`.
723             // - `nextInitialized` to `quantity == 1`.
724             _packedOwnerships[startTokenId] =
725                 _addressToUint256(to) |
726                 (block.timestamp << BITPOS_START_TIMESTAMP) |
727                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
728 
729             uint256 updatedIndex = startTokenId;
730             uint256 end = updatedIndex + quantity;
731 
732             if (to.code.length != 0) {
733                 do {
734                     emit Transfer(address(0), to, updatedIndex);
735                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
736                         revert TransferToNonERC721ReceiverImplementer();
737                     }
738                 } while (updatedIndex < end);
739                 // Reentrancy protection
740                 if (_currentIndex != startTokenId) revert();
741             } else {
742                 do {
743                     emit Transfer(address(0), to, updatedIndex++);
744                 } while (updatedIndex < end);
745             }
746             _currentIndex = updatedIndex;
747         }
748         _afterTokenTransfers(address(0), to, startTokenId, quantity);
749     }
750 
751     /**
752      * @dev Mints `quantity` tokens and transfers them to `to`.
753      *
754      * Requirements:
755      *
756      * - `to` cannot be the zero address.
757      * - `quantity` must be greater than 0.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _mint(address to, uint256 quantity) internal {
762         uint256 startTokenId = _currentIndex;
763         if (to == address(0)) revert MintToZeroAddress();
764         if (quantity == 0) revert MintZeroQuantity();
765 
766         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
767 
768         // Overflows are incredibly unrealistic.
769         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
770         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
771         unchecked {
772             // Updates:
773             // - `balance += quantity`.
774             // - `numberMinted += quantity`.
775             //
776             // We can directly add to the balance and number minted.
777             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
778 
779             // Updates:
780             // - `address` to the owner.
781             // - `startTimestamp` to the timestamp of minting.
782             // - `burned` to `false`.
783             // - `nextInitialized` to `quantity == 1`.
784             _packedOwnerships[startTokenId] =
785                 _addressToUint256(to) |
786                 (block.timestamp << BITPOS_START_TIMESTAMP) |
787                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
788 
789             uint256 updatedIndex = startTokenId;
790             uint256 end = updatedIndex + quantity;
791 
792             do {
793                 emit Transfer(address(0), to, updatedIndex++);
794             } while (updatedIndex < end);
795 
796             _currentIndex = updatedIndex;
797         }
798         _afterTokenTransfers(address(0), to, startTokenId, quantity);
799     }
800 
801     /**
802      * @dev Transfers `tokenId` from `from` to `to`.
803      *
804      * Requirements:
805      *
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _transfer(
812         address from,
813         address to,
814         uint256 tokenId
815     ) private {
816         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
817 
818         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
819 
820         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
821             isApprovedForAll(from, _msgSenderERC721A()) ||
822             getApproved(tokenId) == _msgSenderERC721A());
823 
824         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
825         if (to == address(0)) revert TransferToZeroAddress();
826 
827         _beforeTokenTransfers(from, to, tokenId, 1);
828 
829         // Clear approvals from the previous owner.
830         delete _tokenApprovals[tokenId];
831 
832         // Underflow of the sender's balance is impossible because we check for
833         // ownership above and the recipient's balance can't realistically overflow.
834         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
835         unchecked {
836             // We can directly increment and decrement the balances.
837             --_packedAddressData[from]; // Updates: `balance -= 1`.
838             ++_packedAddressData[to]; // Updates: `balance += 1`.
839 
840             // Updates:
841             // - `address` to the next owner.
842             // - `startTimestamp` to the timestamp of transfering.
843             // - `burned` to `false`.
844             // - `nextInitialized` to `true`.
845             _packedOwnerships[tokenId] =
846                 _addressToUint256(to) |
847                 (block.timestamp << BITPOS_START_TIMESTAMP) |
848                 BITMASK_NEXT_INITIALIZED;
849 
850             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
851             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
852                 uint256 nextTokenId = tokenId + 1;
853                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
854                 if (_packedOwnerships[nextTokenId] == 0) {
855                     // If the next slot is within bounds.
856                     if (nextTokenId != _currentIndex) {
857                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
858                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
859                     }
860                 }
861             }
862         }
863 
864         emit Transfer(from, to, tokenId);
865         _afterTokenTransfers(from, to, tokenId, 1);
866     }
867 
868     /**
869      * @dev Equivalent to `_burn(tokenId, false)`.
870      */
871     function _burn(uint256 tokenId) internal virtual {
872         _burn(tokenId, false);
873     }
874 
875     /**
876      * @dev Destroys `tokenId`.
877      * The approval is cleared when the token is burned.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
886         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
887 
888         address from = address(uint160(prevOwnershipPacked));
889 
890         if (approvalCheck) {
891             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
892                 isApprovedForAll(from, _msgSenderERC721A()) ||
893                 getApproved(tokenId) == _msgSenderERC721A());
894 
895             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
896         }
897 
898         _beforeTokenTransfers(from, address(0), tokenId, 1);
899 
900         // Clear approvals from the previous owner.
901         delete _tokenApprovals[tokenId];
902 
903         // Underflow of the sender's balance is impossible because we check for
904         // ownership above and the recipient's balance can't realistically overflow.
905         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
906         unchecked {
907             // Updates:
908             // - `balance -= 1`.
909             // - `numberBurned += 1`.
910             //
911             // We can directly decrement the balance, and increment the number burned.
912             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
913             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
914 
915             // Updates:
916             // - `address` to the last owner.
917             // - `startTimestamp` to the timestamp of burning.
918             // - `burned` to `true`.
919             // - `nextInitialized` to `true`.
920             _packedOwnerships[tokenId] =
921                 _addressToUint256(from) |
922                 (block.timestamp << BITPOS_START_TIMESTAMP) |
923                 BITMASK_BURNED | 
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
940         emit Transfer(from, address(0), tokenId);
941         _afterTokenTransfers(from, address(0), tokenId, 1);
942 
943         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
944         unchecked {
945             _burnCounter++;
946         }
947     }
948 
949     /**
950      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
951      *
952      * @param from address representing the previous owner of the given token ID
953      * @param to target address that will receive the tokens
954      * @param tokenId uint256 ID of the token to be transferred
955      * @param _data bytes optional data to send along with the call
956      * @return bool whether the call correctly returned the expected magic value
957      */
958     function _checkContractOnERC721Received(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) private returns (bool) {
964         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
965             bytes4 retval
966         ) {
967             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
968         } catch (bytes memory reason) {
969             if (reason.length == 0) {
970                 revert TransferToNonERC721ReceiverImplementer();
971             } else {
972                 assembly {
973                     revert(add(32, reason), mload(reason))
974                 }
975             }
976         }
977     }
978 
979     /**
980      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
981      * And also called before burning one token.
982      *
983      * startTokenId - the first token id to be transferred
984      * quantity - the amount to be transferred
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, `tokenId` will be burned by `from`.
992      * - `from` and `to` are never both zero.
993      */
994     function _beforeTokenTransfers(
995         address from,
996         address to,
997         uint256 startTokenId,
998         uint256 quantity
999     ) internal virtual {}
1000 
1001     /**
1002      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1003      * minting.
1004      * And also called after one token has been burned.
1005      *
1006      * startTokenId - the first token id to be transferred
1007      * quantity - the amount to be transferred
1008      *
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` has been minted for `to`.
1014      * - When `to` is zero, `tokenId` has been burned by `from`.
1015      * - `from` and `to` are never both zero.
1016      */
1017     function _afterTokenTransfers(
1018         address from,
1019         address to,
1020         uint256 startTokenId,
1021         uint256 quantity
1022     ) internal virtual {}
1023 
1024     /**
1025      * @dev Returns the message sender (defaults to `msg.sender`).
1026      *
1027      * If you are writing GSN compatible contracts, you need to override this function.
1028      */
1029     function _msgSenderERC721A() internal view virtual returns (address) {
1030         return msg.sender;
1031     }
1032 
1033     /**
1034      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1035      */
1036     function _toString(uint256 value) internal pure returns (string memory ptr) {
1037         assembly {
1038             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1039             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1040             // We will need 1 32-byte word to store the length, 
1041             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1042             ptr := add(mload(0x40), 128)
1043             // Update the free memory pointer to allocate.
1044             mstore(0x40, ptr)
1045 
1046             // Cache the end of the memory to calculate the length later.
1047             let end := ptr
1048 
1049             // We write the string from the rightmost digit to the leftmost digit.
1050             // The following is essentially a do-while loop that also handles the zero case.
1051             // Costs a bit more than early returning for the zero case,
1052             // but cheaper in terms of deployment and overall runtime costs.
1053             for { 
1054                 // Initialize and perform the first pass without check.
1055                 let temp := value
1056                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1057                 ptr := sub(ptr, 1)
1058                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1059                 mstore8(ptr, add(48, mod(temp, 10)))
1060                 temp := div(temp, 10)
1061             } temp { 
1062                 // Keep dividing `temp` until zero.
1063                 temp := div(temp, 10)
1064             } { // Body of the for loop.
1065                 ptr := sub(ptr, 1)
1066                 mstore8(ptr, add(48, mod(temp, 10)))
1067             }
1068             
1069             let length := sub(end, ptr)
1070             // Move the pointer 32 bytes leftwards to make room for the length.
1071             ptr := sub(ptr, 32)
1072             // Store the length.
1073             mstore(ptr, length)
1074         }
1075     }
1076 }
1077 
1078 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1079 
1080 
1081 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 /**
1086  * @dev String operations.
1087  */
1088 library Strings {
1089     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1090     uint8 private constant _ADDRESS_LENGTH = 20;
1091 
1092     /**
1093      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1094      */
1095     function toString(uint256 value) internal pure returns (string memory) {
1096         // Inspired by OraclizeAPI's implementation - MIT licence
1097         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1098 
1099         if (value == 0) {
1100             return "0";
1101         }
1102         uint256 temp = value;
1103         uint256 digits;
1104         while (temp != 0) {
1105             digits++;
1106             temp /= 10;
1107         }
1108         bytes memory buffer = new bytes(digits);
1109         while (value != 0) {
1110             digits -= 1;
1111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1112             value /= 10;
1113         }
1114         return string(buffer);
1115     }
1116 
1117     /**
1118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1119      */
1120     function toHexString(uint256 value) internal pure returns (string memory) {
1121         if (value == 0) {
1122             return "0x00";
1123         }
1124         uint256 temp = value;
1125         uint256 length = 0;
1126         while (temp != 0) {
1127             length++;
1128             temp >>= 8;
1129         }
1130         return toHexString(value, length);
1131     }
1132 
1133     /**
1134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1135      */
1136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1137         bytes memory buffer = new bytes(2 * length + 2);
1138         buffer[0] = "0";
1139         buffer[1] = "x";
1140         for (uint256 i = 2 * length + 1; i > 1; --i) {
1141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1142             value >>= 4;
1143         }
1144         require(value == 0, "Strings: hex length insufficient");
1145         return string(buffer);
1146     }
1147 
1148     /**
1149      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1150      */
1151     function toHexString(address addr) internal pure returns (string memory) {
1152         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1153     }
1154 }
1155 
1156 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1157 
1158 
1159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 /**
1164  * @dev Provides information about the current execution context, including the
1165  * sender of the transaction and its data. While these are generally available
1166  * via msg.sender and msg.data, they should not be accessed in such a direct
1167  * manner, since when dealing with meta-transactions the account sending and
1168  * paying for execution may not be the actual sender (as far as an application
1169  * is concerned).
1170  *
1171  * This contract is only required for intermediate, library-like contracts.
1172  */
1173 abstract contract Context {
1174     function _msgSender() internal view virtual returns (address) {
1175         return msg.sender;
1176     }
1177 
1178     function _msgData() internal view virtual returns (bytes calldata) {
1179         return msg.data;
1180     }
1181 }
1182 
1183 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1184 
1185 
1186 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 /**
1192  * @dev Contract module which provides a basic access control mechanism, where
1193  * there is an account (an owner) that can be granted exclusive access to
1194  * specific functions.
1195  *
1196  * By default, the owner account will be the one that deploys the contract. This
1197  * can later be changed with {transferOwnership}.
1198  *
1199  * This module is used through inheritance. It will make available the modifier
1200  * `onlyOwner`, which can be applied to your functions to restrict their use to
1201  * the owner.
1202  */
1203 abstract contract Ownable is Context {
1204     address private _owner;
1205 
1206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1207 
1208     /**
1209      * @dev Initializes the contract setting the deployer as the initial owner.
1210      */
1211     constructor() {
1212         _transferOwnership(_msgSender());
1213     }
1214 
1215     /**
1216      * @dev Returns the address of the current owner.
1217      */
1218     function owner() public view virtual returns (address) {
1219         return _owner;
1220     }
1221 
1222     /**
1223      * @dev Throws if called by any account other than the owner.
1224      */
1225     modifier onlyOwner() {
1226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1227         _;
1228     }
1229 
1230     /**
1231      * @dev Leaves the contract without owner. It will not be possible to call
1232      * `onlyOwner` functions anymore. Can only be called by the current owner.
1233      *
1234      * NOTE: Renouncing ownership will leave the contract without an owner,
1235      * thereby removing any functionality that is only available to the owner.
1236      */
1237     function renounceOwnership() public virtual onlyOwner {
1238         _transferOwnership(address(0));
1239     }
1240 
1241     /**
1242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1243      * Can only be called by the current owner.
1244      */
1245     function transferOwnership(address newOwner) public virtual onlyOwner {
1246         require(newOwner != address(0), "Ownable: new owner is the zero address");
1247         _transferOwnership(newOwner);
1248     }
1249 
1250     /**
1251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1252      * Internal function without access restriction.
1253      */
1254     function _transferOwnership(address newOwner) internal virtual {
1255         address oldOwner = _owner;
1256         _owner = newOwner;
1257         emit OwnershipTransferred(oldOwner, newOwner);
1258     }
1259 }
1260 
1261 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1262 
1263 
1264 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1265 
1266 pragma solidity ^0.8.1;
1267 
1268 /**
1269  * @dev Collection of functions related to the address type
1270  */
1271 library Address {
1272     /**
1273      * @dev Returns true if `account` is a contract.
1274      *
1275      * [IMPORTANT]
1276      * ====
1277      * It is unsafe to assume that an address for which this function returns
1278      * false is an externally-owned account (EOA) and not a contract.
1279      *
1280      * Among others, `isContract` will return false for the following
1281      * types of addresses:
1282      *
1283      *  - an externally-owned account
1284      *  - a contract in construction
1285      *  - an address where a contract will be created
1286      *  - an address where a contract lived, but was destroyed
1287      * ====
1288      *
1289      * [IMPORTANT]
1290      * ====
1291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1292      *
1293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1295      * constructor.
1296      * ====
1297      */
1298     function isContract(address account) internal view returns (bool) {
1299         // This method relies on extcodesize/address.code.length, which returns 0
1300         // for contracts in construction, since the code is only stored at the end
1301         // of the constructor execution.
1302 
1303         return account.code.length > 0;
1304     }
1305 
1306     /**
1307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1308      * `recipient`, forwarding all available gas and reverting on errors.
1309      *
1310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1312      * imposed by `transfer`, making them unable to receive funds via
1313      * `transfer`. {sendValue} removes this limitation.
1314      *
1315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1316      *
1317      * IMPORTANT: because control is transferred to `recipient`, care must be
1318      * taken to not create reentrancy vulnerabilities. Consider using
1319      * {ReentrancyGuard} or the
1320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1321      */
1322     function sendValue(address payable recipient, uint256 amount) internal {
1323         require(address(this).balance >= amount, "Address: insufficient balance");
1324 
1325         (bool success, ) = recipient.call{value: amount}("");
1326         require(success, "Address: unable to send value, recipient may have reverted");
1327     }
1328 
1329     /**
1330      * @dev Performs a Solidity function call using a low level `call`. A
1331      * plain `call` is an unsafe replacement for a function call: use this
1332      * function instead.
1333      *
1334      * If `target` reverts with a revert reason, it is bubbled up by this
1335      * function (like regular Solidity function calls).
1336      *
1337      * Returns the raw returned data. To convert to the expected return value,
1338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1339      *
1340      * Requirements:
1341      *
1342      * - `target` must be a contract.
1343      * - calling `target` with `data` must not revert.
1344      *
1345      * _Available since v3.1._
1346      */
1347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1348         return functionCall(target, data, "Address: low-level call failed");
1349     }
1350 
1351     /**
1352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1353      * `errorMessage` as a fallback revert reason when `target` reverts.
1354      *
1355      * _Available since v3.1._
1356      */
1357     function functionCall(
1358         address target,
1359         bytes memory data,
1360         string memory errorMessage
1361     ) internal returns (bytes memory) {
1362         return functionCallWithValue(target, data, 0, errorMessage);
1363     }
1364 
1365     /**
1366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1367      * but also transferring `value` wei to `target`.
1368      *
1369      * Requirements:
1370      *
1371      * - the calling contract must have an ETH balance of at least `value`.
1372      * - the called Solidity function must be `payable`.
1373      *
1374      * _Available since v3.1._
1375      */
1376     function functionCallWithValue(
1377         address target,
1378         bytes memory data,
1379         uint256 value
1380     ) internal returns (bytes memory) {
1381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1382     }
1383 
1384     /**
1385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1386      * with `errorMessage` as a fallback revert reason when `target` reverts.
1387      *
1388      * _Available since v3.1._
1389      */
1390     function functionCallWithValue(
1391         address target,
1392         bytes memory data,
1393         uint256 value,
1394         string memory errorMessage
1395     ) internal returns (bytes memory) {
1396         require(address(this).balance >= value, "Address: insufficient balance for call");
1397         require(isContract(target), "Address: call to non-contract");
1398 
1399         (bool success, bytes memory returndata) = target.call{value: value}(data);
1400         return verifyCallResult(success, returndata, errorMessage);
1401     }
1402 
1403     /**
1404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1405      * but performing a static call.
1406      *
1407      * _Available since v3.3._
1408      */
1409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1410         return functionStaticCall(target, data, "Address: low-level static call failed");
1411     }
1412 
1413     /**
1414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1415      * but performing a static call.
1416      *
1417      * _Available since v3.3._
1418      */
1419     function functionStaticCall(
1420         address target,
1421         bytes memory data,
1422         string memory errorMessage
1423     ) internal view returns (bytes memory) {
1424         require(isContract(target), "Address: static call to non-contract");
1425 
1426         (bool success, bytes memory returndata) = target.staticcall(data);
1427         return verifyCallResult(success, returndata, errorMessage);
1428     }
1429 
1430     /**
1431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1432      * but performing a delegate call.
1433      *
1434      * _Available since v3.4._
1435      */
1436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1438     }
1439 
1440     /**
1441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1442      * but performing a delegate call.
1443      *
1444      * _Available since v3.4._
1445      */
1446     function functionDelegateCall(
1447         address target,
1448         bytes memory data,
1449         string memory errorMessage
1450     ) internal returns (bytes memory) {
1451         require(isContract(target), "Address: delegate call to non-contract");
1452 
1453         (bool success, bytes memory returndata) = target.delegatecall(data);
1454         return verifyCallResult(success, returndata, errorMessage);
1455     }
1456 
1457     /**
1458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1459      * revert reason using the provided one.
1460      *
1461      * _Available since v4.3._
1462      */
1463     function verifyCallResult(
1464         bool success,
1465         bytes memory returndata,
1466         string memory errorMessage
1467     ) internal pure returns (bytes memory) {
1468         if (success) {
1469             return returndata;
1470         } else {
1471             // Look for revert reason and bubble it up if present
1472             if (returndata.length > 0) {
1473                 // The easiest way to bubble the revert reason is using memory via assembly
1474 
1475                 assembly {
1476                     let returndata_size := mload(returndata)
1477                     revert(add(32, returndata), returndata_size)
1478                 }
1479             } else {
1480                 revert(errorMessage);
1481             }
1482         }
1483     }
1484 }
1485 
1486 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1487 
1488 
1489 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1490 
1491 pragma solidity ^0.8.0;
1492 
1493 /**
1494  * @title ERC721 token receiver interface
1495  * @dev Interface for any contract that wants to support safeTransfers
1496  * from ERC721 asset contracts.
1497  */
1498 interface IERC721Receiver {
1499     /**
1500      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1501      * by `operator` from `from`, this function is called.
1502      *
1503      * It must return its Solidity selector to confirm the token transfer.
1504      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1505      *
1506      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1507      */
1508     function onERC721Received(
1509         address operator,
1510         address from,
1511         uint256 tokenId,
1512         bytes calldata data
1513     ) external returns (bytes4);
1514 }
1515 
1516 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1517 
1518 
1519 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1520 
1521 pragma solidity ^0.8.0;
1522 
1523 /**
1524  * @dev Interface of the ERC165 standard, as defined in the
1525  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1526  *
1527  * Implementers can declare support of contract interfaces, which can then be
1528  * queried by others ({ERC165Checker}).
1529  *
1530  * For an implementation, see {ERC165}.
1531  */
1532 interface IERC165 {
1533     /**
1534      * @dev Returns true if this contract implements the interface defined by
1535      * `interfaceId`. See the corresponding
1536      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1537      * to learn more about how these ids are created.
1538      *
1539      * This function call must use less than 30 000 gas.
1540      */
1541     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1542 }
1543 
1544 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1545 
1546 
1547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1548 
1549 pragma solidity ^0.8.0;
1550 
1551 
1552 /**
1553  * @dev Implementation of the {IERC165} interface.
1554  *
1555  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1556  * for the additional interface id that will be supported. For example:
1557  *
1558  * ```solidity
1559  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1560  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1561  * }
1562  * ```
1563  *
1564  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1565  */
1566 abstract contract ERC165 is IERC165 {
1567     /**
1568      * @dev See {IERC165-supportsInterface}.
1569      */
1570     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1571         return interfaceId == type(IERC165).interfaceId;
1572     }
1573 }
1574 
1575 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1576 
1577 
1578 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1579 
1580 pragma solidity ^0.8.0;
1581 
1582 
1583 /**
1584  * @dev Required interface of an ERC721 compliant contract.
1585  */
1586 interface IERC721 is IERC165 {
1587     /**
1588      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1589      */
1590     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1591 
1592     /**
1593      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1594      */
1595     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1596 
1597     /**
1598      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1599      */
1600     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1601 
1602     /**
1603      * @dev Returns the number of tokens in ``owner``'s account.
1604      */
1605     function balanceOf(address owner) external view returns (uint256 balance);
1606 
1607     /**
1608      * @dev Returns the owner of the `tokenId` token.
1609      *
1610      * Requirements:
1611      *
1612      * - `tokenId` must exist.
1613      */
1614     function ownerOf(uint256 tokenId) external view returns (address owner);
1615 
1616     /**
1617      * @dev Safely transfers `tokenId` token from `from` to `to`.
1618      *
1619      * Requirements:
1620      *
1621      * - `from` cannot be the zero address.
1622      * - `to` cannot be the zero address.
1623      * - `tokenId` token must exist and be owned by `from`.
1624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1626      *
1627      * Emits a {Transfer} event.
1628      */
1629     function safeTransferFrom(
1630         address from,
1631         address to,
1632         uint256 tokenId,
1633         bytes calldata data
1634     ) external;
1635 
1636     /**
1637      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1638      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1639      *
1640      * Requirements:
1641      *
1642      * - `from` cannot be the zero address.
1643      * - `to` cannot be the zero address.
1644      * - `tokenId` token must exist and be owned by `from`.
1645      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function safeTransferFrom(
1651         address from,
1652         address to,
1653         uint256 tokenId
1654     ) external;
1655 
1656     /**
1657      * @dev Transfers `tokenId` token from `from` to `to`.
1658      *
1659      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1660      *
1661      * Requirements:
1662      *
1663      * - `from` cannot be the zero address.
1664      * - `to` cannot be the zero address.
1665      * - `tokenId` token must be owned by `from`.
1666      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function transferFrom(
1671         address from,
1672         address to,
1673         uint256 tokenId
1674     ) external;
1675 
1676     /**
1677      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1678      * The approval is cleared when the token is transferred.
1679      *
1680      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1681      *
1682      * Requirements:
1683      *
1684      * - The caller must own the token or be an approved operator.
1685      * - `tokenId` must exist.
1686      *
1687      * Emits an {Approval} event.
1688      */
1689     function approve(address to, uint256 tokenId) external;
1690 
1691     /**
1692      * @dev Approve or remove `operator` as an operator for the caller.
1693      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1694      *
1695      * Requirements:
1696      *
1697      * - The `operator` cannot be the caller.
1698      *
1699      * Emits an {ApprovalForAll} event.
1700      */
1701     function setApprovalForAll(address operator, bool _approved) external;
1702 
1703     /**
1704      * @dev Returns the account approved for `tokenId` token.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      */
1710     function getApproved(uint256 tokenId) external view returns (address operator);
1711 
1712     /**
1713      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1714      *
1715      * See {setApprovalForAll}
1716      */
1717     function isApprovedForAll(address owner, address operator) external view returns (bool);
1718 }
1719 
1720 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1721 
1722 
1723 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1724 
1725 pragma solidity ^0.8.0;
1726 
1727 
1728 /**
1729  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1730  * @dev See https://eips.ethereum.org/EIPS/eip-721
1731  */
1732 interface IERC721Metadata is IERC721 {
1733     /**
1734      * @dev Returns the token collection name.
1735      */
1736     function name() external view returns (string memory);
1737 
1738     /**
1739      * @dev Returns the token collection symbol.
1740      */
1741     function symbol() external view returns (string memory);
1742 
1743     /**
1744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1745      */
1746     function tokenURI(uint256 tokenId) external view returns (string memory);
1747 }
1748 
1749 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1750 
1751 
1752 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1753 
1754 pragma solidity ^0.8.0;
1755 
1756 
1757 
1758 
1759 
1760 
1761 
1762 
1763 /**
1764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1765  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1766  * {ERC721Enumerable}.
1767  */
1768 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1769     using Address for address;
1770     using Strings for uint256;
1771 
1772     // Token name
1773     string private _name;
1774 
1775     // Token symbol
1776     string private _symbol;
1777 
1778     // Mapping from token ID to owner address
1779     mapping(uint256 => address) private _owners;
1780 
1781     // Mapping owner address to token count
1782     mapping(address => uint256) private _balances;
1783 
1784     // Mapping from token ID to approved address
1785     mapping(uint256 => address) private _tokenApprovals;
1786 
1787     // Mapping from owner to operator approvals
1788     mapping(address => mapping(address => bool)) private _operatorApprovals;
1789 
1790     /**
1791      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1792      */
1793     constructor(string memory name_, string memory symbol_) {
1794         _name = name_;
1795         _symbol = symbol_;
1796     }
1797 
1798     /**
1799      * @dev See {IERC165-supportsInterface}.
1800      */
1801     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1802         return
1803             interfaceId == type(IERC721).interfaceId ||
1804             interfaceId == type(IERC721Metadata).interfaceId ||
1805             super.supportsInterface(interfaceId);
1806     }
1807 
1808     /**
1809      * @dev See {IERC721-balanceOf}.
1810      */
1811     function balanceOf(address owner) public view virtual override returns (uint256) {
1812         require(owner != address(0), "ERC721: address zero is not a valid owner");
1813         return _balances[owner];
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-ownerOf}.
1818      */
1819     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1820         address owner = _owners[tokenId];
1821         require(owner != address(0), "ERC721: owner query for nonexistent token");
1822         return owner;
1823     }
1824 
1825     /**
1826      * @dev See {IERC721Metadata-name}.
1827      */
1828     function name() public view virtual override returns (string memory) {
1829         return _name;
1830     }
1831 
1832     /**
1833      * @dev See {IERC721Metadata-symbol}.
1834      */
1835     function symbol() public view virtual override returns (string memory) {
1836         return _symbol;
1837     }
1838 
1839     /**
1840      * @dev See {IERC721Metadata-tokenURI}.
1841      */
1842     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1843         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1844 
1845         string memory baseURI = _baseURI();
1846         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1847     }
1848 
1849     /**
1850      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1851      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1852      * by default, can be overridden in child contracts.
1853      */
1854     function _baseURI() internal view virtual returns (string memory) {
1855         return "";
1856     }
1857 
1858     /**
1859      * @dev See {IERC721-approve}.
1860      */
1861     function approve(address to, uint256 tokenId) public virtual override {
1862         address owner = ERC721.ownerOf(tokenId);
1863         require(to != owner, "ERC721: approval to current owner");
1864 
1865         require(
1866             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1867             "ERC721: approve caller is not owner nor approved for all"
1868         );
1869 
1870         _approve(to, tokenId);
1871     }
1872 
1873     /**
1874      * @dev See {IERC721-getApproved}.
1875      */
1876     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1877         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1878 
1879         return _tokenApprovals[tokenId];
1880     }
1881 
1882     /**
1883      * @dev See {IERC721-setApprovalForAll}.
1884      */
1885     function setApprovalForAll(address operator, bool approved) public virtual override {
1886         _setApprovalForAll(_msgSender(), operator, approved);
1887     }
1888 
1889     /**
1890      * @dev See {IERC721-isApprovedForAll}.
1891      */
1892     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1893         return _operatorApprovals[owner][operator];
1894     }
1895 
1896     /**
1897      * @dev See {IERC721-transferFrom}.
1898      */
1899     function transferFrom(
1900         address from,
1901         address to,
1902         uint256 tokenId
1903     ) public virtual override {
1904         //solhint-disable-next-line max-line-length
1905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1906 
1907         _transfer(from, to, tokenId);
1908     }
1909 
1910     /**
1911      * @dev See {IERC721-safeTransferFrom}.
1912      */
1913     function safeTransferFrom(
1914         address from,
1915         address to,
1916         uint256 tokenId
1917     ) public virtual override {
1918         safeTransferFrom(from, to, tokenId, "");
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-safeTransferFrom}.
1923      */
1924     function safeTransferFrom(
1925         address from,
1926         address to,
1927         uint256 tokenId,
1928         bytes memory data
1929     ) public virtual override {
1930         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1931         _safeTransfer(from, to, tokenId, data);
1932     }
1933 
1934     /**
1935      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1936      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1937      *
1938      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1939      *
1940      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1941      * implement alternative mechanisms to perform token transfer, such as signature-based.
1942      *
1943      * Requirements:
1944      *
1945      * - `from` cannot be the zero address.
1946      * - `to` cannot be the zero address.
1947      * - `tokenId` token must exist and be owned by `from`.
1948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1949      *
1950      * Emits a {Transfer} event.
1951      */
1952     function _safeTransfer(
1953         address from,
1954         address to,
1955         uint256 tokenId,
1956         bytes memory data
1957     ) internal virtual {
1958         _transfer(from, to, tokenId);
1959         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1960     }
1961 
1962     /**
1963      * @dev Returns whether `tokenId` exists.
1964      *
1965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1966      *
1967      * Tokens start existing when they are minted (`_mint`),
1968      * and stop existing when they are burned (`_burn`).
1969      */
1970     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1971         return _owners[tokenId] != address(0);
1972     }
1973 
1974     /**
1975      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1976      *
1977      * Requirements:
1978      *
1979      * - `tokenId` must exist.
1980      */
1981     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1982         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1983         address owner = ERC721.ownerOf(tokenId);
1984         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1985     }
1986 
1987     /**
1988      * @dev Safely mints `tokenId` and transfers it to `to`.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must not exist.
1993      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1994      *
1995      * Emits a {Transfer} event.
1996      */
1997     function _safeMint(address to, uint256 tokenId) internal virtual {
1998         _safeMint(to, tokenId, "");
1999     }
2000 
2001     /**
2002      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2003      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2004      */
2005     function _safeMint(
2006         address to,
2007         uint256 tokenId,
2008         bytes memory data
2009     ) internal virtual {
2010         _mint(to, tokenId);
2011         require(
2012             _checkOnERC721Received(address(0), to, tokenId, data),
2013             "ERC721: transfer to non ERC721Receiver implementer"
2014         );
2015     }
2016 
2017     /**
2018      * @dev Mints `tokenId` and transfers it to `to`.
2019      *
2020      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2021      *
2022      * Requirements:
2023      *
2024      * - `tokenId` must not exist.
2025      * - `to` cannot be the zero address.
2026      *
2027      * Emits a {Transfer} event.
2028      */
2029     function _mint(address to, uint256 tokenId) internal virtual {
2030         require(to != address(0), "ERC721: mint to the zero address");
2031         require(!_exists(tokenId), "ERC721: token already minted");
2032 
2033         _beforeTokenTransfer(address(0), to, tokenId);
2034 
2035         _balances[to] += 1;
2036         _owners[tokenId] = to;
2037 
2038         emit Transfer(address(0), to, tokenId);
2039 
2040         _afterTokenTransfer(address(0), to, tokenId);
2041     }
2042 
2043     /**
2044      * @dev Destroys `tokenId`.
2045      * The approval is cleared when the token is burned.
2046      *
2047      * Requirements:
2048      *
2049      * - `tokenId` must exist.
2050      *
2051      * Emits a {Transfer} event.
2052      */
2053     function _burn(uint256 tokenId) internal virtual {
2054         address owner = ERC721.ownerOf(tokenId);
2055 
2056         _beforeTokenTransfer(owner, address(0), tokenId);
2057 
2058         // Clear approvals
2059         _approve(address(0), tokenId);
2060 
2061         _balances[owner] -= 1;
2062         delete _owners[tokenId];
2063 
2064         emit Transfer(owner, address(0), tokenId);
2065 
2066         _afterTokenTransfer(owner, address(0), tokenId);
2067     }
2068 
2069     /**
2070      * @dev Transfers `tokenId` from `from` to `to`.
2071      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2072      *
2073      * Requirements:
2074      *
2075      * - `to` cannot be the zero address.
2076      * - `tokenId` token must be owned by `from`.
2077      *
2078      * Emits a {Transfer} event.
2079      */
2080     function _transfer(
2081         address from,
2082         address to,
2083         uint256 tokenId
2084     ) internal virtual {
2085         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2086         require(to != address(0), "ERC721: transfer to the zero address");
2087 
2088         _beforeTokenTransfer(from, to, tokenId);
2089 
2090         // Clear approvals from the previous owner
2091         _approve(address(0), tokenId);
2092 
2093         _balances[from] -= 1;
2094         _balances[to] += 1;
2095         _owners[tokenId] = to;
2096 
2097         emit Transfer(from, to, tokenId);
2098 
2099         _afterTokenTransfer(from, to, tokenId);
2100     }
2101 
2102     /**
2103      * @dev Approve `to` to operate on `tokenId`
2104      *
2105      * Emits an {Approval} event.
2106      */
2107     function _approve(address to, uint256 tokenId) internal virtual {
2108         _tokenApprovals[tokenId] = to;
2109         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2110     }
2111 
2112     /**
2113      * @dev Approve `operator` to operate on all of `owner` tokens
2114      *
2115      * Emits an {ApprovalForAll} event.
2116      */
2117     function _setApprovalForAll(
2118         address owner,
2119         address operator,
2120         bool approved
2121     ) internal virtual {
2122         require(owner != operator, "ERC721: approve to caller");
2123         _operatorApprovals[owner][operator] = approved;
2124         emit ApprovalForAll(owner, operator, approved);
2125     }
2126 
2127     /**
2128      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2129      * The call is not executed if the target address is not a contract.
2130      *
2131      * @param from address representing the previous owner of the given token ID
2132      * @param to target address that will receive the tokens
2133      * @param tokenId uint256 ID of the token to be transferred
2134      * @param data bytes optional data to send along with the call
2135      * @return bool whether the call correctly returned the expected magic value
2136      */
2137     function _checkOnERC721Received(
2138         address from,
2139         address to,
2140         uint256 tokenId,
2141         bytes memory data
2142     ) private returns (bool) {
2143         if (to.isContract()) {
2144             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2145                 return retval == IERC721Receiver.onERC721Received.selector;
2146             } catch (bytes memory reason) {
2147                 if (reason.length == 0) {
2148                     revert("ERC721: transfer to non ERC721Receiver implementer");
2149                 } else {
2150                     assembly {
2151                         revert(add(32, reason), mload(reason))
2152                     }
2153                 }
2154             }
2155         } else {
2156             return true;
2157         }
2158     }
2159 
2160     /**
2161      * @dev Hook that is called before any token transfer. This includes minting
2162      * and burning.
2163      *
2164      * Calling conditions:
2165      *
2166      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2167      * transferred to `to`.
2168      * - When `from` is zero, `tokenId` will be minted for `to`.
2169      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2170      * - `from` and `to` are never both zero.
2171      *
2172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2173      */
2174     function _beforeTokenTransfer(
2175         address from,
2176         address to,
2177         uint256 tokenId
2178     ) internal virtual {}
2179 
2180     /**
2181      * @dev Hook that is called after any transfer of tokens. This includes
2182      * minting and burning.
2183      *
2184      * Calling conditions:
2185      *
2186      * - when `from` and `to` are both non-zero.
2187      * - `from` and `to` are never both zero.
2188      *
2189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2190      */
2191     function _afterTokenTransfer(
2192         address from,
2193         address to,
2194         uint256 tokenId
2195     ) internal virtual {}
2196 }
2197 
2198 
2199 
2200 
2201 pragma solidity ^0.8.0;
2202 
2203 
2204 contract lilcauli is ERC721A, Ownable {
2205     using Strings for uint256;
2206 
2207     string private baseURI;
2208 
2209     uint256 public price = 0.002 ether;
2210 
2211     uint256 public maxPerTx = 3;
2212 
2213     uint256 public maxFreePerWallet = 3;
2214 
2215     uint256 public totalFree = 2222;
2216 
2217     uint256 public maxSupply = 3333;
2218 
2219     bool public mintEnabled = false;
2220 
2221     mapping(address => uint256) private _mintedFreeAmount;
2222 
2223     constructor(string memory _tokenName,
2224     string memory _tokenSymbol) ERC721A("lil cauli", "LCL") {
2225         _safeMint(msg.sender, 10);
2226         setBaseURI("ipfs://QmeFojYuthtfugpRsWUW3ApdCSierPP284PYaBLA3pmLek/");
2227     }
2228 
2229     function mint(uint256 count) external payable {
2230         uint256 cost = price;
2231         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2232             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2233 
2234         if (isFree) {
2235             cost = 0;
2236         }
2237 
2238         require(msg.value >= count * cost, "Please send the exact amount.");
2239         require(totalSupply() + count < maxSupply + 1, "No more");
2240         require(mintEnabled, "Minting is not live yet");
2241         require(count < maxPerTx + 1, "Max per TX reached.");
2242 
2243         if (isFree) {
2244             _mintedFreeAmount[msg.sender] += count;
2245         }
2246 
2247         _safeMint(msg.sender, count);
2248     }
2249 
2250     function _baseURI() internal view virtual override returns (string memory) {
2251         return baseURI;
2252     }
2253 
2254     function tokenURI(uint256 tokenId)
2255         public
2256         view
2257         virtual
2258         override
2259         returns (string memory)
2260     {
2261         require(
2262             _exists(tokenId),
2263             "ERC721Metadata: URI query for nonexistent token"
2264         );
2265         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2266     }
2267 
2268     function setBaseURI(string memory uri) public onlyOwner {
2269         baseURI = uri;
2270     }
2271 
2272     function setFreeAmount(uint256 amount) external onlyOwner {
2273         totalFree = amount;
2274     }
2275 
2276     function setPrice(uint256 _newPrice) external onlyOwner {
2277         price = _newPrice;
2278     }
2279 
2280     function flipSale() external onlyOwner {
2281         mintEnabled = !mintEnabled;
2282     }
2283 
2284     function withdraw() external onlyOwner {
2285         (bool success, ) = payable(msg.sender).call{
2286             value: address(this).balance
2287         }("");
2288         require(success, "Transfer failed.");
2289     }
2290 }