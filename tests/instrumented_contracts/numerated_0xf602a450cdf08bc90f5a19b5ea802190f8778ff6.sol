1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-24
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
8 
9 
10 // ERC721A Contracts v3.3.0
11 // Creator: Chiru Labs
12 
13 pragma solidity ^0.8.4;
14 
15 /**
16  * @dev Interface of an ERC721A compliant contract.
17  */
18 interface IERC721A {
19     /**
20      * The caller must own the token or be an approved operator.
21      */
22     error ApprovalCallerNotOwnerNorApproved();
23 
24     /**
25      * The token does not exist.
26      */
27     error ApprovalQueryForNonexistentToken();
28 
29     /**
30      * The caller cannot approve to their own address.
31      */
32     error ApproveToCaller();
33 
34     /**
35      * The caller cannot approve to the current owner.
36      */
37     error ApprovalToCurrentOwner();
38 
39     /**
40      * Cannot query the balance for the zero address.
41      */
42     error BalanceQueryForZeroAddress();
43 
44     /**
45      * Cannot mint to the zero address.
46      */
47     error MintToZeroAddress();
48 
49     /**
50      * The quantity of tokens minted must be more than zero.
51      */
52     error MintZeroQuantity();
53 
54     /**
55      * The token does not exist.
56      */
57     error OwnerQueryForNonexistentToken();
58 
59     /**
60      * The caller must own the token or be an approved operator.
61      */
62     error TransferCallerNotOwnerNorApproved();
63 
64     /**
65      * The token must be owned by `from`.
66      */
67     error TransferFromIncorrectOwner();
68 
69     /**
70      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
71      */
72     error TransferToNonERC721ReceiverImplementer();
73 
74     /**
75      * Cannot transfer to the zero address.
76      */
77     error TransferToZeroAddress();
78 
79     /**
80      * The token does not exist.
81      */
82     error URIQueryForNonexistentToken();
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91     }
92 
93     /**
94      * @dev Returns the total amount of tokens stored by the contract.
95      *
96      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     // ==============================
101     //            IERC165
102     // ==============================
103 
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 
114     // ==============================
115     //            IERC721
116     // ==============================
117 
118     /**
119      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
130      */
131     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
132 
133     /**
134      * @dev Returns the number of tokens in ``owner``'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
169      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
186 
187     /**
188      * @dev Transfers `tokenId` token from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
209      * The approval is cleared when the token is transferred.
210      *
211      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
212      *
213      * Requirements:
214      *
215      * - The caller must own the token or be an approved operator.
216      * - `tokenId` must exist.
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address to, uint256 tokenId) external;
221 
222     /**
223      * @dev Approve or remove `operator` as an operator for the caller.
224      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
225      *
226      * Requirements:
227      *
228      * - The `operator` cannot be the caller.
229      *
230      * Emits an {ApprovalForAll} event.
231      */
232     function setApprovalForAll(address operator, bool _approved) external;
233 
234     /**
235      * @dev Returns the account approved for `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function getApproved(uint256 tokenId) external view returns (address operator);
242 
243     /**
244      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
245      *
246      * See {setApprovalForAll}
247      */
248     function isApprovedForAll(address owner, address operator) external view returns (bool);
249 
250     // ==============================
251     //        IERC721Metadata
252     // ==============================
253 
254     /**
255      * @dev Returns the token collection name.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the token collection symbol.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
266      */
267     function tokenURI(uint256 tokenId) external view returns (string memory);
268 }
269 
270 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
271 
272 
273 // ERC721A Contracts v3.3.0
274 // Creator: Chiru Labs
275 
276 pragma solidity ^0.8.4;
277 
278 
279 /**
280  * @dev ERC721 token receiver interface.
281  */
282 interface ERC721A__IERC721Receiver {
283     function onERC721Received(
284         address operator,
285         address from,
286         uint256 tokenId,
287         bytes calldata data
288     ) external returns (bytes4);
289 }
290 
291 /**
292  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
293  * the Metadata extension. Built to optimize for lower gas during batch mints.
294  *
295  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
296  *
297  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
298  *
299  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
300  */
301 contract ERC721A is IERC721A {
302     // Mask of an entry in packed address data.
303     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
304 
305     // The bit position of `numberMinted` in packed address data.
306     uint256 private constant BITPOS_NUMBER_MINTED = 64;
307 
308     // The bit position of `numberBurned` in packed address data.
309     uint256 private constant BITPOS_NUMBER_BURNED = 128;
310 
311     // The bit position of `aux` in packed address data.
312     uint256 private constant BITPOS_AUX = 192;
313 
314     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
315     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
316 
317     // The bit position of `startTimestamp` in packed ownership.
318     uint256 private constant BITPOS_START_TIMESTAMP = 160;
319 
320     // The bit mask of the `burned` bit in packed ownership.
321     uint256 private constant BITMASK_BURNED = 1 << 224;
322     
323     // The bit position of the `nextInitialized` bit in packed ownership.
324     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
325 
326     // The bit mask of the `nextInitialized` bit in packed ownership.
327     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
328 
329     // The tokenId of the next token to be minted.
330     uint256 private _currentIndex;
331 
332     // The number of tokens burned.
333     uint256 private _burnCounter;
334 
335     // Token name
336     string private _name;
337 
338     // Token symbol
339     string private _symbol;
340 
341     // Mapping from token ID to ownership details
342     // An empty struct value does not necessarily mean the token is unowned.
343     // See `_packedOwnershipOf` implementation for details.
344     //
345     // Bits Layout:
346     // - [0..159]   `addr`
347     // - [160..223] `startTimestamp`
348     // - [224]      `burned`
349     // - [225]      `nextInitialized`
350     mapping(uint256 => uint256) private _packedOwnerships;
351 
352     // Mapping owner address to address data.
353     //
354     // Bits Layout:
355     // - [0..63]    `balance`
356     // - [64..127]  `numberMinted`
357     // - [128..191] `numberBurned`
358     // - [192..255] `aux`
359     mapping(address => uint256) private _packedAddressData;
360 
361     // Mapping from token ID to approved address.
362     mapping(uint256 => address) private _tokenApprovals;
363 
364     // Mapping from owner to operator approvals
365     mapping(address => mapping(address => bool)) private _operatorApprovals;
366 
367     constructor(string memory name_, string memory symbol_) {
368         _name = name_;
369         _symbol = symbol_;
370         _currentIndex = _startTokenId();
371     }
372 
373     /**
374      * @dev Returns the starting token ID. 
375      * To change the starting token ID, please override this function.
376      */
377     function _startTokenId() internal view virtual returns (uint256) {
378         return 0;
379     }
380 
381     /**
382      * @dev Returns the next token ID to be minted.
383      */
384     function _nextTokenId() internal view returns (uint256) {
385         return _currentIndex;
386     }
387 
388     /**
389      * @dev Returns the total number of tokens in existence.
390      * Burned tokens will reduce the count. 
391      * To get the total number of tokens minted, please see `_totalMinted`.
392      */
393     function totalSupply() public view override returns (uint256) {
394         // Counter underflow is impossible as _burnCounter cannot be incremented
395         // more than `_currentIndex - _startTokenId()` times.
396         unchecked {
397             return _currentIndex - _burnCounter - _startTokenId();
398         }
399     }
400 
401     /**
402      * @dev Returns the total amount of tokens minted in the contract.
403      */
404     function _totalMinted() internal view returns (uint256) {
405         // Counter underflow is impossible as _currentIndex does not decrement,
406         // and it is initialized to `_startTokenId()`
407         unchecked {
408             return _currentIndex - _startTokenId();
409         }
410     }
411 
412     /**
413      * @dev Returns the total number of tokens burned.
414      */
415     function _totalBurned() internal view returns (uint256) {
416         return _burnCounter;
417     }
418 
419     /**
420      * @dev See {IERC165-supportsInterface}.
421      */
422     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
423         // The interface IDs are constants representing the first 4 bytes of the XOR of
424         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
425         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
426         return
427             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
428             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
429             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
430     }
431 
432     /**
433      * @dev See {IERC721-balanceOf}.
434      */
435     function balanceOf(address owner) public view override returns (uint256) {
436         if (owner == address(0)) revert BalanceQueryForZeroAddress();
437         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
438     }
439 
440     /**
441      * Returns the number of tokens minted by `owner`.
442      */
443     function _numberMinted(address owner) internal view returns (uint256) {
444         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
445     }
446 
447     /**
448      * Returns the number of tokens burned by or on behalf of `owner`.
449      */
450     function _numberBurned(address owner) internal view returns (uint256) {
451         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
452     }
453 
454     /**
455      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
456      */
457     function _getAux(address owner) internal view returns (uint64) {
458         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
459     }
460 
461     /**
462      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
463      * If there are multiple variables, please pack them into a uint64.
464      */
465     function _setAux(address owner, uint64 aux) internal {
466         uint256 packed = _packedAddressData[owner];
467         uint256 auxCasted;
468         assembly { // Cast aux without masking.
469             auxCasted := aux
470         }
471         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
472         _packedAddressData[owner] = packed;
473     }
474 
475     /**
476      * Returns the packed ownership data of `tokenId`.
477      */
478     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
479         uint256 curr = tokenId;
480 
481         unchecked {
482             if (_startTokenId() <= curr)
483                 if (curr < _currentIndex) {
484                     uint256 packed = _packedOwnerships[curr];
485                     // If not burned.
486                     if (packed & BITMASK_BURNED == 0) {
487                         // Invariant:
488                         // There will always be an ownership that has an address and is not burned
489                         // before an ownership that does not have an address and is not burned.
490                         // Hence, curr will not underflow.
491                         //
492                         // We can directly compare the packed value.
493                         // If the address is zero, packed is zero.
494                         while (packed == 0) {
495                             packed = _packedOwnerships[--curr];
496                         }
497                         return packed;
498                     }
499                 }
500         }
501         revert OwnerQueryForNonexistentToken();
502     }
503 
504     /**
505      * Returns the unpacked `TokenOwnership` struct from `packed`.
506      */
507     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
508         ownership.addr = address(uint160(packed));
509         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
510         ownership.burned = packed & BITMASK_BURNED != 0;
511     }
512 
513     /**
514      * Returns the unpacked `TokenOwnership` struct at `index`.
515      */
516     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
517         return _unpackedOwnership(_packedOwnerships[index]);
518     }
519 
520     /**
521      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
522      */
523     function _initializeOwnershipAt(uint256 index) internal {
524         if (_packedOwnerships[index] == 0) {
525             _packedOwnerships[index] = _packedOwnershipOf(index);
526         }
527     }
528 
529     /**
530      * Gas spent here starts off proportional to the maximum mint batch size.
531      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
532      */
533     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
534         return _unpackedOwnership(_packedOwnershipOf(tokenId));
535     }
536 
537     /**
538      * @dev See {IERC721-ownerOf}.
539      */
540     function ownerOf(uint256 tokenId) public view override returns (address) {
541         return address(uint160(_packedOwnershipOf(tokenId)));
542     }
543 
544     /**
545      * @dev See {IERC721Metadata-name}.
546      */
547     function name() public view virtual override returns (string memory) {
548         return _name;
549     }
550 
551     /**
552      * @dev See {IERC721Metadata-symbol}.
553      */
554     function symbol() public view virtual override returns (string memory) {
555         return _symbol;
556     }
557 
558     /**
559      * @dev See {IERC721Metadata-tokenURI}.
560      */
561     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
562         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
563 
564         string memory baseURI = _baseURI();
565         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
566     }
567 
568     /**
569      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
570      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
571      * by default, can be overriden in child contracts.
572      */
573     function _baseURI() internal view virtual returns (string memory) {
574         return '';
575     }
576 
577     /**
578      * @dev Casts the address to uint256 without masking.
579      */
580     function _addressToUint256(address value) private pure returns (uint256 result) {
581         assembly {
582             result := value
583         }
584     }
585 
586     /**
587      * @dev Casts the boolean to uint256 without branching.
588      */
589     function _boolToUint256(bool value) private pure returns (uint256 result) {
590         assembly {
591             result := value
592         }
593     }
594 
595     /**
596      * @dev See {IERC721-approve}.
597      */
598     function approve(address to, uint256 tokenId) public override {
599         address owner = address(uint160(_packedOwnershipOf(tokenId)));
600         if (to == owner) revert ApprovalToCurrentOwner();
601 
602         if (_msgSenderERC721A() != owner)
603             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
604                 revert ApprovalCallerNotOwnerNorApproved();
605             }
606 
607         _tokenApprovals[tokenId] = to;
608         emit Approval(owner, to, tokenId);
609     }
610 
611     /**
612      * @dev See {IERC721-getApproved}.
613      */
614     function getApproved(uint256 tokenId) public view override returns (address) {
615         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
616 
617         return _tokenApprovals[tokenId];
618     }
619 
620     /**
621      * @dev See {IERC721-setApprovalForAll}.
622      */
623     function setApprovalForAll(address operator, bool approved) public virtual override {
624         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
625 
626         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
627         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
628     }
629 
630     /**
631      * @dev See {IERC721-isApprovedForAll}.
632      */
633     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
634         return _operatorApprovals[owner][operator];
635     }
636 
637     /**
638      * @dev See {IERC721-transferFrom}.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) public virtual override {
645         _transfer(from, to, tokenId);
646     }
647 
648     /**
649      * @dev See {IERC721-safeTransferFrom}.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId
655     ) public virtual override {
656         safeTransferFrom(from, to, tokenId, '');
657     }
658 
659     /**
660      * @dev See {IERC721-safeTransferFrom}.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes memory _data
667     ) public virtual override {
668         _transfer(from, to, tokenId);
669         if (to.code.length != 0)
670             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
671                 revert TransferToNonERC721ReceiverImplementer();
672             }
673     }
674 
675     /**
676      * @dev Returns whether `tokenId` exists.
677      *
678      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
679      *
680      * Tokens start existing when they are minted (`_mint`),
681      */
682     function _exists(uint256 tokenId) internal view returns (bool) {
683         return
684             _startTokenId() <= tokenId &&
685             tokenId < _currentIndex && // If within bounds,
686             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
687     }
688 
689     /**
690      * @dev Equivalent to `_safeMint(to, quantity, '')`.
691      */
692     function _safeMint(address to, uint256 quantity) internal {
693         _safeMint(to, quantity, '');
694     }
695 
696     /**
697      * @dev Safely mints `quantity` tokens and transfers them to `to`.
698      *
699      * Requirements:
700      *
701      * - If `to` refers to a smart contract, it must implement
702      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
703      * - `quantity` must be greater than 0.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeMint(
708         address to,
709         uint256 quantity,
710         bytes memory _data
711     ) internal {
712         uint256 startTokenId = _currentIndex;
713         if (to == address(0)) revert MintToZeroAddress();
714         if (quantity == 0) revert MintZeroQuantity();
715 
716         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
717 
718         // Overflows are incredibly unrealistic.
719         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
720         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
721         unchecked {
722             // Updates:
723             // - `balance += quantity`.
724             // - `numberMinted += quantity`.
725             //
726             // We can directly add to the balance and number minted.
727             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
728 
729             // Updates:
730             // - `address` to the owner.
731             // - `startTimestamp` to the timestamp of minting.
732             // - `burned` to `false`.
733             // - `nextInitialized` to `quantity == 1`.
734             _packedOwnerships[startTokenId] =
735                 _addressToUint256(to) |
736                 (block.timestamp << BITPOS_START_TIMESTAMP) |
737                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
738 
739             uint256 updatedIndex = startTokenId;
740             uint256 end = updatedIndex + quantity;
741 
742             if (to.code.length != 0) {
743                 do {
744                     emit Transfer(address(0), to, updatedIndex);
745                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
746                         revert TransferToNonERC721ReceiverImplementer();
747                     }
748                 } while (updatedIndex < end);
749                 // Reentrancy protection
750                 if (_currentIndex != startTokenId) revert();
751             } else {
752                 do {
753                     emit Transfer(address(0), to, updatedIndex++);
754                 } while (updatedIndex < end);
755             }
756             _currentIndex = updatedIndex;
757         }
758         _afterTokenTransfers(address(0), to, startTokenId, quantity);
759     }
760 
761     /**
762      * @dev Mints `quantity` tokens and transfers them to `to`.
763      *
764      * Requirements:
765      *
766      * - `to` cannot be the zero address.
767      * - `quantity` must be greater than 0.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _mint(address to, uint256 quantity) internal {
772         uint256 startTokenId = _currentIndex;
773         if (to == address(0)) revert MintToZeroAddress();
774         if (quantity == 0) revert MintZeroQuantity();
775 
776         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
777 
778         // Overflows are incredibly unrealistic.
779         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
780         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
781         unchecked {
782             // Updates:
783             // - `balance += quantity`.
784             // - `numberMinted += quantity`.
785             //
786             // We can directly add to the balance and number minted.
787             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
788 
789             // Updates:
790             // - `address` to the owner.
791             // - `startTimestamp` to the timestamp of minting.
792             // - `burned` to `false`.
793             // - `nextInitialized` to `quantity == 1`.
794             _packedOwnerships[startTokenId] =
795                 _addressToUint256(to) |
796                 (block.timestamp << BITPOS_START_TIMESTAMP) |
797                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
798 
799             uint256 updatedIndex = startTokenId;
800             uint256 end = updatedIndex + quantity;
801 
802             do {
803                 emit Transfer(address(0), to, updatedIndex++);
804             } while (updatedIndex < end);
805 
806             _currentIndex = updatedIndex;
807         }
808         _afterTokenTransfers(address(0), to, startTokenId, quantity);
809     }
810 
811     /**
812      * @dev Transfers `tokenId` from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _transfer(
822         address from,
823         address to,
824         uint256 tokenId
825     ) private {
826         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
827 
828         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
829 
830         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
831             isApprovedForAll(from, _msgSenderERC721A()) ||
832             getApproved(tokenId) == _msgSenderERC721A());
833 
834         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
835         if (to == address(0)) revert TransferToZeroAddress();
836 
837         _beforeTokenTransfers(from, to, tokenId, 1);
838 
839         // Clear approvals from the previous owner.
840         delete _tokenApprovals[tokenId];
841 
842         // Underflow of the sender's balance is impossible because we check for
843         // ownership above and the recipient's balance can't realistically overflow.
844         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
845         unchecked {
846             // We can directly increment and decrement the balances.
847             --_packedAddressData[from]; // Updates: `balance -= 1`.
848             ++_packedAddressData[to]; // Updates: `balance += 1`.
849 
850             // Updates:
851             // - `address` to the next owner.
852             // - `startTimestamp` to the timestamp of transfering.
853             // - `burned` to `false`.
854             // - `nextInitialized` to `true`.
855             _packedOwnerships[tokenId] =
856                 _addressToUint256(to) |
857                 (block.timestamp << BITPOS_START_TIMESTAMP) |
858                 BITMASK_NEXT_INITIALIZED;
859 
860             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
861             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
862                 uint256 nextTokenId = tokenId + 1;
863                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
864                 if (_packedOwnerships[nextTokenId] == 0) {
865                     // If the next slot is within bounds.
866                     if (nextTokenId != _currentIndex) {
867                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
868                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
869                     }
870                 }
871             }
872         }
873 
874         emit Transfer(from, to, tokenId);
875         _afterTokenTransfers(from, to, tokenId, 1);
876     }
877 
878     /**
879      * @dev Equivalent to `_burn(tokenId, false)`.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         _burn(tokenId, false);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
896         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
897 
898         address from = address(uint160(prevOwnershipPacked));
899 
900         if (approvalCheck) {
901             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
902                 isApprovedForAll(from, _msgSenderERC721A()) ||
903                 getApproved(tokenId) == _msgSenderERC721A());
904 
905             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
906         }
907 
908         _beforeTokenTransfers(from, address(0), tokenId, 1);
909 
910         // Clear approvals from the previous owner.
911         delete _tokenApprovals[tokenId];
912 
913         // Underflow of the sender's balance is impossible because we check for
914         // ownership above and the recipient's balance can't realistically overflow.
915         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
916         unchecked {
917             // Updates:
918             // - `balance -= 1`.
919             // - `numberBurned += 1`.
920             //
921             // We can directly decrement the balance, and increment the number burned.
922             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
923             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
924 
925             // Updates:
926             // - `address` to the last owner.
927             // - `startTimestamp` to the timestamp of burning.
928             // - `burned` to `true`.
929             // - `nextInitialized` to `true`.
930             _packedOwnerships[tokenId] =
931                 _addressToUint256(from) |
932                 (block.timestamp << BITPOS_START_TIMESTAMP) |
933                 BITMASK_BURNED | 
934                 BITMASK_NEXT_INITIALIZED;
935 
936             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
937             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
938                 uint256 nextTokenId = tokenId + 1;
939                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
940                 if (_packedOwnerships[nextTokenId] == 0) {
941                     // If the next slot is within bounds.
942                     if (nextTokenId != _currentIndex) {
943                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
944                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
945                     }
946                 }
947             }
948         }
949 
950         emit Transfer(from, address(0), tokenId);
951         _afterTokenTransfers(from, address(0), tokenId, 1);
952 
953         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
954         unchecked {
955             _burnCounter++;
956         }
957     }
958 
959     /**
960      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
961      *
962      * @param from address representing the previous owner of the given token ID
963      * @param to target address that will receive the tokens
964      * @param tokenId uint256 ID of the token to be transferred
965      * @param _data bytes optional data to send along with the call
966      * @return bool whether the call correctly returned the expected magic value
967      */
968     function _checkContractOnERC721Received(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) private returns (bool) {
974         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
975             bytes4 retval
976         ) {
977             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
978         } catch (bytes memory reason) {
979             if (reason.length == 0) {
980                 revert TransferToNonERC721ReceiverImplementer();
981             } else {
982                 assembly {
983                     revert(add(32, reason), mload(reason))
984                 }
985             }
986         }
987     }
988 
989     /**
990      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
991      * And also called before burning one token.
992      *
993      * startTokenId - the first token id to be transferred
994      * quantity - the amount to be transferred
995      *
996      * Calling conditions:
997      *
998      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
999      * transferred to `to`.
1000      * - When `from` is zero, `tokenId` will be minted for `to`.
1001      * - When `to` is zero, `tokenId` will be burned by `from`.
1002      * - `from` and `to` are never both zero.
1003      */
1004     function _beforeTokenTransfers(
1005         address from,
1006         address to,
1007         uint256 startTokenId,
1008         uint256 quantity
1009     ) internal virtual {}
1010 
1011     /**
1012      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1013      * minting.
1014      * And also called after one token has been burned.
1015      *
1016      * startTokenId - the first token id to be transferred
1017      * quantity - the amount to be transferred
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` has been minted for `to`.
1024      * - When `to` is zero, `tokenId` has been burned by `from`.
1025      * - `from` and `to` are never both zero.
1026      */
1027     function _afterTokenTransfers(
1028         address from,
1029         address to,
1030         uint256 startTokenId,
1031         uint256 quantity
1032     ) internal virtual {}
1033 
1034     /**
1035      * @dev Returns the message sender (defaults to `msg.sender`).
1036      *
1037      * If you are writing GSN compatible contracts, you need to override this function.
1038      */
1039     function _msgSenderERC721A() internal view virtual returns (address) {
1040         return msg.sender;
1041     }
1042 
1043     /**
1044      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1045      */
1046     function _toString(uint256 value) internal pure returns (string memory ptr) {
1047         assembly {
1048             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1049             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1050             // We will need 1 32-byte word to store the length, 
1051             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1052             ptr := add(mload(0x40), 128)
1053             // Update the free memory pointer to allocate.
1054             mstore(0x40, ptr)
1055 
1056             // Cache the end of the memory to calculate the length later.
1057             let end := ptr
1058 
1059             // We write the string from the rightmost digit to the leftmost digit.
1060             // The following is essentially a do-while loop that also handles the zero case.
1061             // Costs a bit more than early returning for the zero case,
1062             // but cheaper in terms of deployment and overall runtime costs.
1063             for { 
1064                 // Initialize and perform the first pass without check.
1065                 let temp := value
1066                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1067                 ptr := sub(ptr, 1)
1068                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1069                 mstore8(ptr, add(48, mod(temp, 10)))
1070                 temp := div(temp, 10)
1071             } temp { 
1072                 // Keep dividing `temp` until zero.
1073                 temp := div(temp, 10)
1074             } { // Body of the for loop.
1075                 ptr := sub(ptr, 1)
1076                 mstore8(ptr, add(48, mod(temp, 10)))
1077             }
1078             
1079             let length := sub(end, ptr)
1080             // Move the pointer 32 bytes leftwards to make room for the length.
1081             ptr := sub(ptr, 32)
1082             // Store the length.
1083             mstore(ptr, length)
1084         }
1085     }
1086 }
1087 
1088 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1089 
1090 
1091 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 /**
1096  * @dev String operations.
1097  */
1098 library Strings {
1099     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1100     uint8 private constant _ADDRESS_LENGTH = 20;
1101 
1102     /**
1103      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1104      */
1105     function toString(uint256 value) internal pure returns (string memory) {
1106         // Inspired by OraclizeAPI's implementation - MIT licence
1107         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1108 
1109         if (value == 0) {
1110             return "0";
1111         }
1112         uint256 temp = value;
1113         uint256 digits;
1114         while (temp != 0) {
1115             digits++;
1116             temp /= 10;
1117         }
1118         bytes memory buffer = new bytes(digits);
1119         while (value != 0) {
1120             digits -= 1;
1121             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1122             value /= 10;
1123         }
1124         return string(buffer);
1125     }
1126 
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1129      */
1130     function toHexString(uint256 value) internal pure returns (string memory) {
1131         if (value == 0) {
1132             return "0x00";
1133         }
1134         uint256 temp = value;
1135         uint256 length = 0;
1136         while (temp != 0) {
1137             length++;
1138             temp >>= 8;
1139         }
1140         return toHexString(value, length);
1141     }
1142 
1143     /**
1144      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1145      */
1146     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1147         bytes memory buffer = new bytes(2 * length + 2);
1148         buffer[0] = "0";
1149         buffer[1] = "x";
1150         for (uint256 i = 2 * length + 1; i > 1; --i) {
1151             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1152             value >>= 4;
1153         }
1154         require(value == 0, "Strings: hex length insufficient");
1155         return string(buffer);
1156     }
1157 
1158     /**
1159      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1160      */
1161     function toHexString(address addr) internal pure returns (string memory) {
1162         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1163     }
1164 }
1165 
1166 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1167 
1168 
1169 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 /**
1174  * @dev Provides information about the current execution context, including the
1175  * sender of the transaction and its data. While these are generally available
1176  * via msg.sender and msg.data, they should not be accessed in such a direct
1177  * manner, since when dealing with meta-transactions the account sending and
1178  * paying for execution may not be the actual sender (as far as an application
1179  * is concerned).
1180  *
1181  * This contract is only required for intermediate, library-like contracts.
1182  */
1183 abstract contract Context {
1184     function _msgSender() internal view virtual returns (address) {
1185         return msg.sender;
1186     }
1187 
1188     function _msgData() internal view virtual returns (bytes calldata) {
1189         return msg.data;
1190     }
1191 }
1192 
1193 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1194 
1195 
1196 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 /**
1202  * @dev Contract module which provides a basic access control mechanism, where
1203  * there is an account (an owner) that can be granted exclusive access to
1204  * specific functions.
1205  *
1206  * By default, the owner account will be the one that deploys the contract. This
1207  * can later be changed with {transferOwnership}.
1208  *
1209  * This module is used through inheritance. It will make available the modifier
1210  * `onlyOwner`, which can be applied to your functions to restrict their use to
1211  * the owner.
1212  */
1213 abstract contract Ownable is Context {
1214     address private _owner;
1215 
1216     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1217 
1218     /**
1219      * @dev Initializes the contract setting the deployer as the initial owner.
1220      */
1221     constructor() {
1222         _transferOwnership(_msgSender());
1223     }
1224 
1225     /**
1226      * @dev Returns the address of the current owner.
1227      */
1228     function owner() public view virtual returns (address) {
1229         return _owner;
1230     }
1231 
1232     /**
1233      * @dev Throws if called by any account other than the owner.
1234      */
1235     modifier onlyOwner() {
1236         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1237         _;
1238     }
1239 
1240     /**
1241      * @dev Leaves the contract without owner. It will not be possible to call
1242      * `onlyOwner` functions anymore. Can only be called by the current owner.
1243      *
1244      * NOTE: Renouncing ownership will leave the contract without an owner,
1245      * thereby removing any functionality that is only available to the owner.
1246      */
1247     function renounceOwnership() public virtual onlyOwner {
1248         _transferOwnership(address(0));
1249     }
1250 
1251     /**
1252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1253      * Can only be called by the current owner.
1254      */
1255     function transferOwnership(address newOwner) public virtual onlyOwner {
1256         require(newOwner != address(0), "Ownable: new owner is the zero address");
1257         _transferOwnership(newOwner);
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Internal function without access restriction.
1263      */
1264     function _transferOwnership(address newOwner) internal virtual {
1265         address oldOwner = _owner;
1266         _owner = newOwner;
1267         emit OwnershipTransferred(oldOwner, newOwner);
1268     }
1269 }
1270 
1271 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1272 
1273 
1274 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1275 
1276 pragma solidity ^0.8.1;
1277 
1278 /**
1279  * @dev Collection of functions related to the address type
1280  */
1281 library Address {
1282     /**
1283      * @dev Returns true if `account` is a contract.
1284      *
1285      * [IMPORTANT]
1286      * ====
1287      * It is unsafe to assume that an address for which this function returns
1288      * false is an externally-owned account (EOA) and not a contract.
1289      *
1290      * Among others, `isContract` will return false for the following
1291      * types of addresses:
1292      *
1293      *  - an externally-owned account
1294      *  - a contract in construction
1295      *  - an address where a contract will be created
1296      *  - an address where a contract lived, but was destroyed
1297      * ====
1298      *
1299      * [IMPORTANT]
1300      * ====
1301      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1302      *
1303      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1304      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1305      * constructor.
1306      * ====
1307      */
1308     function isContract(address account) internal view returns (bool) {
1309         // This method relies on extcodesize/address.code.length, which returns 0
1310         // for contracts in construction, since the code is only stored at the end
1311         // of the constructor execution.
1312 
1313         return account.code.length > 0;
1314     }
1315 
1316     /**
1317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1318      * `recipient`, forwarding all available gas and reverting on errors.
1319      *
1320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1322      * imposed by `transfer`, making them unable to receive funds via
1323      * `transfer`. {sendValue} removes this limitation.
1324      *
1325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1326      *
1327      * IMPORTANT: because control is transferred to `recipient`, care must be
1328      * taken to not create reentrancy vulnerabilities. Consider using
1329      * {ReentrancyGuard} or the
1330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1331      */
1332     function sendValue(address payable recipient, uint256 amount) internal {
1333         require(address(this).balance >= amount, "Address: insufficient balance");
1334 
1335         (bool success, ) = recipient.call{value: amount}("");
1336         require(success, "Address: unable to send value, recipient may have reverted");
1337     }
1338 
1339     /**
1340      * @dev Performs a Solidity function call using a low level `call`. A
1341      * plain `call` is an unsafe replacement for a function call: use this
1342      * function instead.
1343      *
1344      * If `target` reverts with a revert reason, it is bubbled up by this
1345      * function (like regular Solidity function calls).
1346      *
1347      * Returns the raw returned data. To convert to the expected return value,
1348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1349      *
1350      * Requirements:
1351      *
1352      * - `target` must be a contract.
1353      * - calling `target` with `data` must not revert.
1354      *
1355      * _Available since v3.1._
1356      */
1357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1358         return functionCall(target, data, "Address: low-level call failed");
1359     }
1360 
1361     /**
1362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1363      * `errorMessage` as a fallback revert reason when `target` reverts.
1364      *
1365      * _Available since v3.1._
1366      */
1367     function functionCall(
1368         address target,
1369         bytes memory data,
1370         string memory errorMessage
1371     ) internal returns (bytes memory) {
1372         return functionCallWithValue(target, data, 0, errorMessage);
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1377      * but also transferring `value` wei to `target`.
1378      *
1379      * Requirements:
1380      *
1381      * - the calling contract must have an ETH balance of at least `value`.
1382      * - the called Solidity function must be `payable`.
1383      *
1384      * _Available since v3.1._
1385      */
1386     function functionCallWithValue(
1387         address target,
1388         bytes memory data,
1389         uint256 value
1390     ) internal returns (bytes memory) {
1391         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1392     }
1393 
1394     /**
1395      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1396      * with `errorMessage` as a fallback revert reason when `target` reverts.
1397      *
1398      * _Available since v3.1._
1399      */
1400     function functionCallWithValue(
1401         address target,
1402         bytes memory data,
1403         uint256 value,
1404         string memory errorMessage
1405     ) internal returns (bytes memory) {
1406         require(address(this).balance >= value, "Address: insufficient balance for call");
1407         require(isContract(target), "Address: call to non-contract");
1408 
1409         (bool success, bytes memory returndata) = target.call{value: value}(data);
1410         return verifyCallResult(success, returndata, errorMessage);
1411     }
1412 
1413     /**
1414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1415      * but performing a static call.
1416      *
1417      * _Available since v3.3._
1418      */
1419     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1420         return functionStaticCall(target, data, "Address: low-level static call failed");
1421     }
1422 
1423     /**
1424      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1425      * but performing a static call.
1426      *
1427      * _Available since v3.3._
1428      */
1429     function functionStaticCall(
1430         address target,
1431         bytes memory data,
1432         string memory errorMessage
1433     ) internal view returns (bytes memory) {
1434         require(isContract(target), "Address: static call to non-contract");
1435 
1436         (bool success, bytes memory returndata) = target.staticcall(data);
1437         return verifyCallResult(success, returndata, errorMessage);
1438     }
1439 
1440     /**
1441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1442      * but performing a delegate call.
1443      *
1444      * _Available since v3.4._
1445      */
1446     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1447         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1448     }
1449 
1450     /**
1451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1452      * but performing a delegate call.
1453      *
1454      * _Available since v3.4._
1455      */
1456     function functionDelegateCall(
1457         address target,
1458         bytes memory data,
1459         string memory errorMessage
1460     ) internal returns (bytes memory) {
1461         require(isContract(target), "Address: delegate call to non-contract");
1462 
1463         (bool success, bytes memory returndata) = target.delegatecall(data);
1464         return verifyCallResult(success, returndata, errorMessage);
1465     }
1466 
1467     /**
1468      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1469      * revert reason using the provided one.
1470      *
1471      * _Available since v4.3._
1472      */
1473     function verifyCallResult(
1474         bool success,
1475         bytes memory returndata,
1476         string memory errorMessage
1477     ) internal pure returns (bytes memory) {
1478         if (success) {
1479             return returndata;
1480         } else {
1481             // Look for revert reason and bubble it up if present
1482             if (returndata.length > 0) {
1483                 // The easiest way to bubble the revert reason is using memory via assembly
1484 
1485                 assembly {
1486                     let returndata_size := mload(returndata)
1487                     revert(add(32, returndata), returndata_size)
1488                 }
1489             } else {
1490                 revert(errorMessage);
1491             }
1492         }
1493     }
1494 }
1495 
1496 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1497 
1498 
1499 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 /**
1504  * @title ERC721 token receiver interface
1505  * @dev Interface for any contract that wants to support safeTransfers
1506  * from ERC721 asset contracts.
1507  */
1508 interface IERC721Receiver {
1509     /**
1510      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1511      * by `operator` from `from`, this function is called.
1512      *
1513      * It must return its Solidity selector to confirm the token transfer.
1514      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1515      *
1516      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1517      */
1518     function onERC721Received(
1519         address operator,
1520         address from,
1521         uint256 tokenId,
1522         bytes calldata data
1523     ) external returns (bytes4);
1524 }
1525 
1526 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1527 
1528 
1529 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 /**
1534  * @dev Interface of the ERC165 standard, as defined in the
1535  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1536  *
1537  * Implementers can declare support of contract interfaces, which can then be
1538  * queried by others ({ERC165Checker}).
1539  *
1540  * For an implementation, see {ERC165}.
1541  */
1542 interface IERC165 {
1543     /**
1544      * @dev Returns true if this contract implements the interface defined by
1545      * `interfaceId`. See the corresponding
1546      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1547      * to learn more about how these ids are created.
1548      *
1549      * This function call must use less than 30 000 gas.
1550      */
1551     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1552 }
1553 
1554 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1555 
1556 
1557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1558 
1559 pragma solidity ^0.8.0;
1560 
1561 
1562 /**
1563  * @dev Implementation of the {IERC165} interface.
1564  *
1565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1566  * for the additional interface id that will be supported. For example:
1567  *
1568  * ```solidity
1569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1571  * }
1572  * ```
1573  *
1574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1575  */
1576 abstract contract ERC165 is IERC165 {
1577     /**
1578      * @dev See {IERC165-supportsInterface}.
1579      */
1580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1581         return interfaceId == type(IERC165).interfaceId;
1582     }
1583 }
1584 
1585 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1586 
1587 
1588 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1589 
1590 pragma solidity ^0.8.0;
1591 
1592 
1593 /**
1594  * @dev Required interface of an ERC721 compliant contract.
1595  */
1596 interface IERC721 is IERC165 {
1597     /**
1598      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1599      */
1600     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1601 
1602     /**
1603      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1604      */
1605     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1606 
1607     /**
1608      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1609      */
1610     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1611 
1612     /**
1613      * @dev Returns the number of tokens in ``owner``'s account.
1614      */
1615     function balanceOf(address owner) external view returns (uint256 balance);
1616 
1617     /**
1618      * @dev Returns the owner of the `tokenId` token.
1619      *
1620      * Requirements:
1621      *
1622      * - `tokenId` must exist.
1623      */
1624     function ownerOf(uint256 tokenId) external view returns (address owner);
1625 
1626     /**
1627      * @dev Safely transfers `tokenId` token from `from` to `to`.
1628      *
1629      * Requirements:
1630      *
1631      * - `from` cannot be the zero address.
1632      * - `to` cannot be the zero address.
1633      * - `tokenId` token must exist and be owned by `from`.
1634      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function safeTransferFrom(
1640         address from,
1641         address to,
1642         uint256 tokenId,
1643         bytes calldata data
1644     ) external;
1645 
1646     /**
1647      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1648      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1649      *
1650      * Requirements:
1651      *
1652      * - `from` cannot be the zero address.
1653      * - `to` cannot be the zero address.
1654      * - `tokenId` token must exist and be owned by `from`.
1655      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1656      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1657      *
1658      * Emits a {Transfer} event.
1659      */
1660     function safeTransferFrom(
1661         address from,
1662         address to,
1663         uint256 tokenId
1664     ) external;
1665 
1666     /**
1667      * @dev Transfers `tokenId` token from `from` to `to`.
1668      *
1669      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1670      *
1671      * Requirements:
1672      *
1673      * - `from` cannot be the zero address.
1674      * - `to` cannot be the zero address.
1675      * - `tokenId` token must be owned by `from`.
1676      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1677      *
1678      * Emits a {Transfer} event.
1679      */
1680     function transferFrom(
1681         address from,
1682         address to,
1683         uint256 tokenId
1684     ) external;
1685 
1686     /**
1687      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1688      * The approval is cleared when the token is transferred.
1689      *
1690      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1691      *
1692      * Requirements:
1693      *
1694      * - The caller must own the token or be an approved operator.
1695      * - `tokenId` must exist.
1696      *
1697      * Emits an {Approval} event.
1698      */
1699     function approve(address to, uint256 tokenId) external;
1700 
1701     /**
1702      * @dev Approve or remove `operator` as an operator for the caller.
1703      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1704      *
1705      * Requirements:
1706      *
1707      * - The `operator` cannot be the caller.
1708      *
1709      * Emits an {ApprovalForAll} event.
1710      */
1711     function setApprovalForAll(address operator, bool _approved) external;
1712 
1713     /**
1714      * @dev Returns the account approved for `tokenId` token.
1715      *
1716      * Requirements:
1717      *
1718      * - `tokenId` must exist.
1719      */
1720     function getApproved(uint256 tokenId) external view returns (address operator);
1721 
1722     /**
1723      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1724      *
1725      * See {setApprovalForAll}
1726      */
1727     function isApprovedForAll(address owner, address operator) external view returns (bool);
1728 }
1729 
1730 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1731 
1732 
1733 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1734 
1735 pragma solidity ^0.8.0;
1736 
1737 
1738 /**
1739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1740  * @dev See https://eips.ethereum.org/EIPS/eip-721
1741  */
1742 interface IERC721Metadata is IERC721 {
1743     /**
1744      * @dev Returns the token collection name.
1745      */
1746     function name() external view returns (string memory);
1747 
1748     /**
1749      * @dev Returns the token collection symbol.
1750      */
1751     function symbol() external view returns (string memory);
1752 
1753     /**
1754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1755      */
1756     function tokenURI(uint256 tokenId) external view returns (string memory);
1757 }
1758 
1759 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1760 
1761 
1762 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1763 
1764 pragma solidity ^0.8.0;
1765 
1766 
1767 
1768 
1769 
1770 
1771 
1772 
1773 /**
1774  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1775  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1776  * {ERC721Enumerable}.
1777  */
1778 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1779     using Address for address;
1780     using Strings for uint256;
1781 
1782     // Token name
1783     string private _name;
1784 
1785     // Token symbol
1786     string private _symbol;
1787 
1788     // Mapping from token ID to owner address
1789     mapping(uint256 => address) private _owners;
1790 
1791     // Mapping owner address to token count
1792     mapping(address => uint256) private _balances;
1793 
1794     // Mapping from token ID to approved address
1795     mapping(uint256 => address) private _tokenApprovals;
1796 
1797     // Mapping from owner to operator approvals
1798     mapping(address => mapping(address => bool)) private _operatorApprovals;
1799 
1800     /**
1801      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1802      */
1803     constructor(string memory name_, string memory symbol_) {
1804         _name = name_;
1805         _symbol = symbol_;
1806     }
1807 
1808     /**
1809      * @dev See {IERC165-supportsInterface}.
1810      */
1811     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1812         return
1813             interfaceId == type(IERC721).interfaceId ||
1814             interfaceId == type(IERC721Metadata).interfaceId ||
1815             super.supportsInterface(interfaceId);
1816     }
1817 
1818     /**
1819      * @dev See {IERC721-balanceOf}.
1820      */
1821     function balanceOf(address owner) public view virtual override returns (uint256) {
1822         require(owner != address(0), "ERC721: address zero is not a valid owner");
1823         return _balances[owner];
1824     }
1825 
1826     /**
1827      * @dev See {IERC721-ownerOf}.
1828      */
1829     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1830         address owner = _owners[tokenId];
1831         require(owner != address(0), "ERC721: owner query for nonexistent token");
1832         return owner;
1833     }
1834 
1835     /**
1836      * @dev See {IERC721Metadata-name}.
1837      */
1838     function name() public view virtual override returns (string memory) {
1839         return _name;
1840     }
1841 
1842     /**
1843      * @dev See {IERC721Metadata-symbol}.
1844      */
1845     function symbol() public view virtual override returns (string memory) {
1846         return _symbol;
1847     }
1848 
1849     /**
1850      * @dev See {IERC721Metadata-tokenURI}.
1851      */
1852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1853         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1854 
1855         string memory baseURI = _baseURI();
1856         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1857     }
1858 
1859     /**
1860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1862      * by default, can be overridden in child contracts.
1863      */
1864     function _baseURI() internal view virtual returns (string memory) {
1865         return "";
1866     }
1867 
1868     /**
1869      * @dev See {IERC721-approve}.
1870      */
1871     function approve(address to, uint256 tokenId) public virtual override {
1872         address owner = ERC721.ownerOf(tokenId);
1873         require(to != owner, "ERC721: approval to current owner");
1874 
1875         require(
1876             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1877             "ERC721: approve caller is not owner nor approved for all"
1878         );
1879 
1880         _approve(to, tokenId);
1881     }
1882 
1883     /**
1884      * @dev See {IERC721-getApproved}.
1885      */
1886     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1887         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1888 
1889         return _tokenApprovals[tokenId];
1890     }
1891 
1892     /**
1893      * @dev See {IERC721-setApprovalForAll}.
1894      */
1895     function setApprovalForAll(address operator, bool approved) public virtual override {
1896         _setApprovalForAll(_msgSender(), operator, approved);
1897     }
1898 
1899     /**
1900      * @dev See {IERC721-isApprovedForAll}.
1901      */
1902     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1903         return _operatorApprovals[owner][operator];
1904     }
1905 
1906     /**
1907      * @dev See {IERC721-transferFrom}.
1908      */
1909     function transferFrom(
1910         address from,
1911         address to,
1912         uint256 tokenId
1913     ) public virtual override {
1914         //solhint-disable-next-line max-line-length
1915         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1916 
1917         _transfer(from, to, tokenId);
1918     }
1919 
1920     /**
1921      * @dev See {IERC721-safeTransferFrom}.
1922      */
1923     function safeTransferFrom(
1924         address from,
1925         address to,
1926         uint256 tokenId
1927     ) public virtual override {
1928         safeTransferFrom(from, to, tokenId, "");
1929     }
1930 
1931     /**
1932      * @dev See {IERC721-safeTransferFrom}.
1933      */
1934     function safeTransferFrom(
1935         address from,
1936         address to,
1937         uint256 tokenId,
1938         bytes memory data
1939     ) public virtual override {
1940         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1941         _safeTransfer(from, to, tokenId, data);
1942     }
1943 
1944     /**
1945      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1946      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1947      *
1948      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1949      *
1950      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1951      * implement alternative mechanisms to perform token transfer, such as signature-based.
1952      *
1953      * Requirements:
1954      *
1955      * - `from` cannot be the zero address.
1956      * - `to` cannot be the zero address.
1957      * - `tokenId` token must exist and be owned by `from`.
1958      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1959      *
1960      * Emits a {Transfer} event.
1961      */
1962     function _safeTransfer(
1963         address from,
1964         address to,
1965         uint256 tokenId,
1966         bytes memory data
1967     ) internal virtual {
1968         _transfer(from, to, tokenId);
1969         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1970     }
1971 
1972     /**
1973      * @dev Returns whether `tokenId` exists.
1974      *
1975      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1976      *
1977      * Tokens start existing when they are minted (`_mint`),
1978      * and stop existing when they are burned (`_burn`).
1979      */
1980     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1981         return _owners[tokenId] != address(0);
1982     }
1983 
1984     /**
1985      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1986      *
1987      * Requirements:
1988      *
1989      * - `tokenId` must exist.
1990      */
1991     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1992         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1993         address owner = ERC721.ownerOf(tokenId);
1994         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1995     }
1996 
1997     /**
1998      * @dev Safely mints `tokenId` and transfers it to `to`.
1999      *
2000      * Requirements:
2001      *
2002      * - `tokenId` must not exist.
2003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2004      *
2005      * Emits a {Transfer} event.
2006      */
2007     function _safeMint(address to, uint256 tokenId) internal virtual {
2008         _safeMint(to, tokenId, "");
2009     }
2010 
2011     /**
2012      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2013      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2014      */
2015     function _safeMint(
2016         address to,
2017         uint256 tokenId,
2018         bytes memory data
2019     ) internal virtual {
2020         _mint(to, tokenId);
2021         require(
2022             _checkOnERC721Received(address(0), to, tokenId, data),
2023             "ERC721: transfer to non ERC721Receiver implementer"
2024         );
2025     }
2026 
2027     /**
2028      * @dev Mints `tokenId` and transfers it to `to`.
2029      *
2030      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2031      *
2032      * Requirements:
2033      *
2034      * - `tokenId` must not exist.
2035      * - `to` cannot be the zero address.
2036      *
2037      * Emits a {Transfer} event.
2038      */
2039     function _mint(address to, uint256 tokenId) internal virtual {
2040         require(to != address(0), "ERC721: mint to the zero address");
2041         require(!_exists(tokenId), "ERC721: token already minted");
2042 
2043         _beforeTokenTransfer(address(0), to, tokenId);
2044 
2045         _balances[to] += 1;
2046         _owners[tokenId] = to;
2047 
2048         emit Transfer(address(0), to, tokenId);
2049 
2050         _afterTokenTransfer(address(0), to, tokenId);
2051     }
2052 
2053     /**
2054      * @dev Destroys `tokenId`.
2055      * The approval is cleared when the token is burned.
2056      *
2057      * Requirements:
2058      *
2059      * - `tokenId` must exist.
2060      *
2061      * Emits a {Transfer} event.
2062      */
2063     function _burn(uint256 tokenId) internal virtual {
2064         address owner = ERC721.ownerOf(tokenId);
2065 
2066         _beforeTokenTransfer(owner, address(0), tokenId);
2067 
2068         // Clear approvals
2069         _approve(address(0), tokenId);
2070 
2071         _balances[owner] -= 1;
2072         delete _owners[tokenId];
2073 
2074         emit Transfer(owner, address(0), tokenId);
2075 
2076         _afterTokenTransfer(owner, address(0), tokenId);
2077     }
2078 
2079     /**
2080      * @dev Transfers `tokenId` from `from` to `to`.
2081      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2082      *
2083      * Requirements:
2084      *
2085      * - `to` cannot be the zero address.
2086      * - `tokenId` token must be owned by `from`.
2087      *
2088      * Emits a {Transfer} event.
2089      */
2090     function _transfer(
2091         address from,
2092         address to,
2093         uint256 tokenId
2094     ) internal virtual {
2095         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2096         require(to != address(0), "ERC721: transfer to the zero address");
2097 
2098         _beforeTokenTransfer(from, to, tokenId);
2099 
2100         // Clear approvals from the previous owner
2101         _approve(address(0), tokenId);
2102 
2103         _balances[from] -= 1;
2104         _balances[to] += 1;
2105         _owners[tokenId] = to;
2106 
2107         emit Transfer(from, to, tokenId);
2108 
2109         _afterTokenTransfer(from, to, tokenId);
2110     }
2111 
2112     /**
2113      * @dev Approve `to` to operate on `tokenId`
2114      *
2115      * Emits an {Approval} event.
2116      */
2117     function _approve(address to, uint256 tokenId) internal virtual {
2118         _tokenApprovals[tokenId] = to;
2119         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2120     }
2121 
2122     /**
2123      * @dev Approve `operator` to operate on all of `owner` tokens
2124      *
2125      * Emits an {ApprovalForAll} event.
2126      */
2127     function _setApprovalForAll(
2128         address owner,
2129         address operator,
2130         bool approved
2131     ) internal virtual {
2132         require(owner != operator, "ERC721: approve to caller");
2133         _operatorApprovals[owner][operator] = approved;
2134         emit ApprovalForAll(owner, operator, approved);
2135     }
2136 
2137     /**
2138      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2139      * The call is not executed if the target address is not a contract.
2140      *
2141      * @param from address representing the previous owner of the given token ID
2142      * @param to target address that will receive the tokens
2143      * @param tokenId uint256 ID of the token to be transferred
2144      * @param data bytes optional data to send along with the call
2145      * @return bool whether the call correctly returned the expected magic value
2146      */
2147     function _checkOnERC721Received(
2148         address from,
2149         address to,
2150         uint256 tokenId,
2151         bytes memory data
2152     ) private returns (bool) {
2153         if (to.isContract()) {
2154             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2155                 return retval == IERC721Receiver.onERC721Received.selector;
2156             } catch (bytes memory reason) {
2157                 if (reason.length == 0) {
2158                     revert("ERC721: transfer to non ERC721Receiver implementer");
2159                 } else {
2160                     assembly {
2161                         revert(add(32, reason), mload(reason))
2162                     }
2163                 }
2164             }
2165         } else {
2166             return true;
2167         }
2168     }
2169 
2170     /**
2171      * @dev Hook that is called before any token transfer. This includes minting
2172      * and burning.
2173      *
2174      * Calling conditions:
2175      *
2176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2177      * transferred to `to`.
2178      * - When `from` is zero, `tokenId` will be minted for `to`.
2179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2180      * - `from` and `to` are never both zero.
2181      *
2182      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2183      */
2184     function _beforeTokenTransfer(
2185         address from,
2186         address to,
2187         uint256 tokenId
2188     ) internal virtual {}
2189 
2190     /**
2191      * @dev Hook that is called after any transfer of tokens. This includes
2192      * minting and burning.
2193      *
2194      * Calling conditions:
2195      *
2196      * - when `from` and `to` are both non-zero.
2197      * - `from` and `to` are never both zero.
2198      *
2199      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2200      */
2201     function _afterTokenTransfer(
2202         address from,
2203         address to,
2204         uint256 tokenId
2205     ) internal virtual {}
2206 }
2207 
2208 // File: contracts/ODYC.sol
2209 
2210 
2211 pragma solidity ^0.8.0;
2212 
2213 
2214 
2215 
2216 contract ZombieTownWTF is ERC721A, Ownable {
2217     using Strings for uint256;
2218 
2219     string private baseURI;
2220 
2221     uint256 public price = 0.005 ether;
2222 
2223     uint256 public maxPerTx = 10;
2224 
2225     uint256 public maxFreePerWallet = 2;
2226 
2227     uint256 public totalFree = 2500;
2228 
2229     uint256 public maxSupply = 4000;
2230 
2231     bool public mintEnabled = false;
2232 
2233     mapping(address => uint256) private _mintedFreeAmount;
2234 
2235     constructor() ERC721A("ZombietownWtf", "ZTWTF") {
2236         _safeMint(msg.sender, 5);
2237         setBaseURI("ipfs://QmcFXmwR6hCe4MQ68whskGHcuF7MUcwjtcEixKRfpJZrt2/hidden.json/");
2238     }
2239 
2240     function mint(uint256 count) external payable {
2241         uint256 cost = price;
2242         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2243             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2244 
2245         if (isFree) {
2246             cost = 0;
2247         }
2248 
2249         require(msg.value >= count * cost, "Please send the exact amount.");
2250         require(totalSupply() + count < maxSupply + 1, "No more");
2251         require(mintEnabled, "Minting is not live yet");
2252         require(count < maxPerTx + 1, "Max per TX reached.");
2253 
2254         if (isFree) {
2255             _mintedFreeAmount[msg.sender] += count;
2256         }
2257 
2258         _safeMint(msg.sender, count);
2259     }
2260 
2261     function _baseURI() internal view virtual override returns (string memory) {
2262         return baseURI;
2263     }
2264 
2265     function tokenURI(uint256 tokenId)
2266         public
2267         view
2268         virtual
2269         override
2270         returns (string memory)
2271     {
2272         require(
2273             _exists(tokenId),
2274             "ERC721Metadata: URI query for nonexistent token"
2275         );
2276         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2277     }
2278 
2279     function setBaseURI(string memory uri) public onlyOwner {
2280         baseURI = uri;
2281     }
2282 
2283     function setFreeAmount(uint256 amount) external onlyOwner {
2284         totalFree = amount;
2285     }
2286 
2287     function setPrice(uint256 _newPrice) external onlyOwner {
2288         price = _newPrice;
2289     }
2290 
2291     function flipSale() external onlyOwner {
2292         mintEnabled = !mintEnabled;
2293     }
2294 
2295     function withdraw() external onlyOwner {
2296         (bool success, ) = payable(msg.sender).call{
2297             value: address(this).balance
2298         }("");
2299         require(success, "Transfer failed.");
2300     }
2301 }