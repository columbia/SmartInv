1 // SPDX-License-Identifier: MIT
2 
3 // ooooo      ooo                                                             oooo   o8o           
4 // `888b.     `8'                                                             `888   `"'           
5 //  8 `88b.    8   .ooooo.   .ooooo.  oooo d8b  .ooooo.  oo.ooooo.   .ooooo.   888  oooo   .oooo.o 
6 //  8   `88b.  8  d88' `88b d88' `"Y8 `888""8P d88' `88b  888' `88b d88' `88b  888  `888  d88(  "8 
7 //  8     `88b.8  888ooo888 888        888     888   888  888   888 888   888  888   888  `"Y88b.  
8 //  8       `888  888    .o 888   .o8  888     888   888  888   888 888   888  888   888  o.  )88b 
9 // o8o        `8  `Y8bod8P' `Y8bod8P' d888b    `Y8bod8P'  888bod8P' `Y8bod8P' o888o o888o 8""888P' 
10 //                                                        888                                      
11 //                                                       o888o     
12 
13 // ERC721A Contracts v3.3.0
14 // Creator: Chiru Labs
15 
16 pragma solidity ^0.8.4;
17 
18 /**
19  * @dev Interface of an ERC721A compliant contract.
20  */
21 interface IERC721A {
22     /**
23      * The caller must own the token or be an approved operator.
24      */
25     error ApprovalCallerNotOwnerNorApproved();
26 
27     /**
28      * The token does not exist.
29      */
30     error ApprovalQueryForNonexistentToken();
31 
32     /**
33      * The caller cannot approve to their own address.
34      */
35     error ApproveToCaller();
36 
37     /**
38      * The caller cannot approve to the current owner.
39      */
40     error ApprovalToCurrentOwner();
41 
42     /**
43      * Cannot query the balance for the zero address.
44      */
45     error BalanceQueryForZeroAddress();
46 
47     /**
48      * Cannot mint to the zero address.
49      */
50     error MintToZeroAddress();
51 
52     /**
53      * The quantity of tokens minted must be more than zero.
54      */
55     error MintZeroQuantity();
56 
57     /**
58      * The token does not exist.
59      */
60     error OwnerQueryForNonexistentToken();
61 
62     /**
63      * The caller must own the token or be an approved operator.
64      */
65     error TransferCallerNotOwnerNorApproved();
66 
67     /**
68      * The token must be owned by `from`.
69      */
70     error TransferFromIncorrectOwner();
71 
72     /**
73      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
74      */
75     error TransferToNonERC721ReceiverImplementer();
76 
77     /**
78      * Cannot transfer to the zero address.
79      */
80     error TransferToZeroAddress();
81 
82     /**
83      * The token does not exist.
84      */
85     error URIQueryForNonexistentToken();
86 
87     struct TokenOwnership {
88         // The address of the owner.
89         address addr;
90         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
91         uint64 startTimestamp;
92         // Whether the token has been burned.
93         bool burned;
94     }
95 
96     /**
97      * @dev Returns the total amount of tokens stored by the contract.
98      *
99      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     // ==============================
104     //            IERC165
105     // ==============================
106 
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 
117     // ==============================
118     //            IERC721
119     // ==============================
120 
121     /**
122      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
125 
126     /**
127      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
128      */
129     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
133      */
134     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
135 
136     /**
137      * @dev Returns the number of tokens in ``owner``'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     // ==============================
254     //        IERC721Metadata
255     // ==============================
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
274 
275 
276 // ERC721A Contracts v3.3.0
277 // Creator: Chiru Labs
278 
279 pragma solidity ^0.8.4;
280 
281 
282 /**
283  * @dev ERC721 token receiver interface.
284  */
285 interface ERC721A__IERC721Receiver {
286     function onERC721Received(
287         address operator,
288         address from,
289         uint256 tokenId,
290         bytes calldata data
291     ) external returns (bytes4);
292 }
293 
294 /**
295  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
296  * the Metadata extension. Built to optimize for lower gas during batch mints.
297  *
298  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
299  *
300  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
301  *
302  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
303  */
304 contract ERC721A is IERC721A {
305     // Mask of an entry in packed address data.
306     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
307 
308     // The bit position of `numberMinted` in packed address data.
309     uint256 private constant BITPOS_NUMBER_MINTED = 64;
310 
311     // The bit position of `numberBurned` in packed address data.
312     uint256 private constant BITPOS_NUMBER_BURNED = 128;
313 
314     // The bit position of `aux` in packed address data.
315     uint256 private constant BITPOS_AUX = 192;
316 
317     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
318     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
319 
320     // The bit position of `startTimestamp` in packed ownership.
321     uint256 private constant BITPOS_START_TIMESTAMP = 160;
322 
323     // The bit mask of the `burned` bit in packed ownership.
324     uint256 private constant BITMASK_BURNED = 1 << 224;
325     
326     // The bit position of the `nextInitialized` bit in packed ownership.
327     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
328 
329     // The bit mask of the `nextInitialized` bit in packed ownership.
330     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
331 
332     // The tokenId of the next token to be minted.
333     uint256 private _currentIndex;
334 
335     // The number of tokens burned.
336     uint256 private _burnCounter;
337 
338     // Token name
339     string private _name;
340 
341     // Token symbol
342     string private _symbol;
343 
344     // Mapping from token ID to ownership details
345     // An empty struct value does not necessarily mean the token is unowned.
346     // See `_packedOwnershipOf` implementation for details.
347     //
348     // Bits Layout:
349     // - [0..159]   `addr`
350     // - [160..223] `startTimestamp`
351     // - [224]      `burned`
352     // - [225]      `nextInitialized`
353     mapping(uint256 => uint256) private _packedOwnerships;
354 
355     // Mapping owner address to address data.
356     //
357     // Bits Layout:
358     // - [0..63]    `balance`
359     // - [64..127]  `numberMinted`
360     // - [128..191] `numberBurned`
361     // - [192..255] `aux`
362     mapping(address => uint256) private _packedAddressData;
363 
364     // Mapping from token ID to approved address.
365     mapping(uint256 => address) private _tokenApprovals;
366 
367     // Mapping from owner to operator approvals
368     mapping(address => mapping(address => bool)) private _operatorApprovals;
369 
370     constructor(string memory name_, string memory symbol_) {
371         _name = name_;
372         _symbol = symbol_;
373         _currentIndex = _startTokenId();
374     }
375 
376     /**
377      * @dev Returns the starting token ID. 
378      * To change the starting token ID, please override this function.
379      */
380     function _startTokenId() internal view virtual returns (uint256) {
381         return 0;
382     }
383 
384     /**
385      * @dev Returns the next token ID to be minted.
386      */
387     function _nextTokenId() internal view returns (uint256) {
388         return _currentIndex;
389     }
390 
391     /**
392      * @dev Returns the total number of tokens in existence.
393      * Burned tokens will reduce the count. 
394      * To get the total number of tokens minted, please see `_totalMinted`.
395      */
396     function totalSupply() public view override returns (uint256) {
397         // Counter underflow is impossible as _burnCounter cannot be incremented
398         // more than `_currentIndex - _startTokenId()` times.
399         unchecked {
400             return _currentIndex - _burnCounter - _startTokenId();
401         }
402     }
403 
404     /**
405      * @dev Returns the total amount of tokens minted in the contract.
406      */
407     function _totalMinted() internal view returns (uint256) {
408         // Counter underflow is impossible as _currentIndex does not decrement,
409         // and it is initialized to `_startTokenId()`
410         unchecked {
411             return _currentIndex - _startTokenId();
412         }
413     }
414 
415     /**
416      * @dev Returns the total number of tokens burned.
417      */
418     function _totalBurned() internal view returns (uint256) {
419         return _burnCounter;
420     }
421 
422     /**
423      * @dev See {IERC165-supportsInterface}.
424      */
425     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426         // The interface IDs are constants representing the first 4 bytes of the XOR of
427         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
428         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
429         return
430             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
431             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
432             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
433     }
434 
435     /**
436      * @dev See {IERC721-balanceOf}.
437      */
438     function balanceOf(address owner) public view override returns (uint256) {
439         if (owner == address(0)) revert BalanceQueryForZeroAddress();
440         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
441     }
442 
443     /**
444      * Returns the number of tokens minted by `owner`.
445      */
446     function _numberMinted(address owner) internal view returns (uint256) {
447         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
448     }
449 
450     /**
451      * Returns the number of tokens burned by or on behalf of `owner`.
452      */
453     function _numberBurned(address owner) internal view returns (uint256) {
454         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
455     }
456 
457     /**
458      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
459      */
460     function _getAux(address owner) internal view returns (uint64) {
461         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
462     }
463 
464     /**
465      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
466      * If there are multiple variables, please pack them into a uint64.
467      */
468     function _setAux(address owner, uint64 aux) internal {
469         uint256 packed = _packedAddressData[owner];
470         uint256 auxCasted;
471         assembly { // Cast aux without masking.
472             auxCasted := aux
473         }
474         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
475         _packedAddressData[owner] = packed;
476     }
477 
478     /**
479      * Returns the packed ownership data of `tokenId`.
480      */
481     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
482         uint256 curr = tokenId;
483 
484         unchecked {
485             if (_startTokenId() <= curr)
486                 if (curr < _currentIndex) {
487                     uint256 packed = _packedOwnerships[curr];
488                     // If not burned.
489                     if (packed & BITMASK_BURNED == 0) {
490                         // Invariant:
491                         // There will always be an ownership that has an address and is not burned
492                         // before an ownership that does not have an address and is not burned.
493                         // Hence, curr will not underflow.
494                         //
495                         // We can directly compare the packed value.
496                         // If the address is zero, packed is zero.
497                         while (packed == 0) {
498                             packed = _packedOwnerships[--curr];
499                         }
500                         return packed;
501                     }
502                 }
503         }
504         revert OwnerQueryForNonexistentToken();
505     }
506 
507     /**
508      * Returns the unpacked `TokenOwnership` struct from `packed`.
509      */
510     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
511         ownership.addr = address(uint160(packed));
512         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
513         ownership.burned = packed & BITMASK_BURNED != 0;
514     }
515 
516     /**
517      * Returns the unpacked `TokenOwnership` struct at `index`.
518      */
519     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
520         return _unpackedOwnership(_packedOwnerships[index]);
521     }
522 
523     /**
524      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
525      */
526     function _initializeOwnershipAt(uint256 index) internal {
527         if (_packedOwnerships[index] == 0) {
528             _packedOwnerships[index] = _packedOwnershipOf(index);
529         }
530     }
531 
532     /**
533      * Gas spent here starts off proportional to the maximum mint batch size.
534      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
535      */
536     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
537         return _unpackedOwnership(_packedOwnershipOf(tokenId));
538     }
539 
540     /**
541      * @dev See {IERC721-ownerOf}.
542      */
543     function ownerOf(uint256 tokenId) public view override returns (address) {
544         return address(uint160(_packedOwnershipOf(tokenId)));
545     }
546 
547     /**
548      * @dev See {IERC721Metadata-name}.
549      */
550     function name() public view virtual override returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-symbol}.
556      */
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-tokenURI}.
563      */
564     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
565         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
566 
567         string memory baseURI = _baseURI();
568         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
569     }
570 
571     /**
572      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
573      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
574      * by default, can be overriden in child contracts.
575      */
576     function _baseURI() internal view virtual returns (string memory) {
577         return '';
578     }
579 
580     /**
581      * @dev Casts the address to uint256 without masking.
582      */
583     function _addressToUint256(address value) private pure returns (uint256 result) {
584         assembly {
585             result := value
586         }
587     }
588 
589     /**
590      * @dev Casts the boolean to uint256 without branching.
591      */
592     function _boolToUint256(bool value) private pure returns (uint256 result) {
593         assembly {
594             result := value
595         }
596     }
597 
598     /**
599      * @dev See {IERC721-approve}.
600      */
601     function approve(address to, uint256 tokenId) public override {
602         address owner = address(uint160(_packedOwnershipOf(tokenId)));
603         if (to == owner) revert ApprovalToCurrentOwner();
604 
605         if (_msgSenderERC721A() != owner)
606             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
607                 revert ApprovalCallerNotOwnerNorApproved();
608             }
609 
610         _tokenApprovals[tokenId] = to;
611         emit Approval(owner, to, tokenId);
612     }
613 
614     /**
615      * @dev See {IERC721-getApproved}.
616      */
617     function getApproved(uint256 tokenId) public view override returns (address) {
618         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
619 
620         return _tokenApprovals[tokenId];
621     }
622 
623     /**
624      * @dev See {IERC721-setApprovalForAll}.
625      */
626     function setApprovalForAll(address operator, bool approved) public virtual override {
627         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
628 
629         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
630         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
631     }
632 
633     /**
634      * @dev See {IERC721-isApprovedForAll}.
635      */
636     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
637         return _operatorApprovals[owner][operator];
638     }
639 
640     /**
641      * @dev See {IERC721-transferFrom}.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) public virtual override {
648         _transfer(from, to, tokenId);
649     }
650 
651     /**
652      * @dev See {IERC721-safeTransferFrom}.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) public virtual override {
659         safeTransferFrom(from, to, tokenId, '');
660     }
661 
662     /**
663      * @dev See {IERC721-safeTransferFrom}.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes memory _data
670     ) public virtual override {
671         _transfer(from, to, tokenId);
672         if (to.code.length != 0)
673             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
674                 revert TransferToNonERC721ReceiverImplementer();
675             }
676     }
677 
678     /**
679      * @dev Returns whether `tokenId` exists.
680      *
681      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
682      *
683      * Tokens start existing when they are minted (`_mint`),
684      */
685     function _exists(uint256 tokenId) internal view returns (bool) {
686         return
687             _startTokenId() <= tokenId &&
688             tokenId < _currentIndex && // If within bounds,
689             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
690     }
691 
692     /**
693      * @dev Equivalent to `_safeMint(to, quantity, '')`.
694      */
695     function _safeMint(address to, uint256 quantity) internal {
696         _safeMint(to, quantity, '');
697     }
698 
699     /**
700      * @dev Safely mints `quantity` tokens and transfers them to `to`.
701      *
702      * Requirements:
703      *
704      * - If `to` refers to a smart contract, it must implement
705      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
706      * - `quantity` must be greater than 0.
707      *
708      * Emits a {Transfer} event.
709      */
710     function _safeMint(
711         address to,
712         uint256 quantity,
713         bytes memory _data
714     ) internal {
715         uint256 startTokenId = _currentIndex;
716         if (to == address(0)) revert MintToZeroAddress();
717         if (quantity == 0) revert MintZeroQuantity();
718 
719         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
720 
721         // Overflows are incredibly unrealistic.
722         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
723         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
724         unchecked {
725             // Updates:
726             // - `balance += quantity`.
727             // - `numberMinted += quantity`.
728             //
729             // We can directly add to the balance and number minted.
730             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
731 
732             // Updates:
733             // - `address` to the owner.
734             // - `startTimestamp` to the timestamp of minting.
735             // - `burned` to `false`.
736             // - `nextInitialized` to `quantity == 1`.
737             _packedOwnerships[startTokenId] =
738                 _addressToUint256(to) |
739                 (block.timestamp << BITPOS_START_TIMESTAMP) |
740                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
741 
742             uint256 updatedIndex = startTokenId;
743             uint256 end = updatedIndex + quantity;
744 
745             if (to.code.length != 0) {
746                 do {
747                     emit Transfer(address(0), to, updatedIndex);
748                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
749                         revert TransferToNonERC721ReceiverImplementer();
750                     }
751                 } while (updatedIndex < end);
752                 // Reentrancy protection
753                 if (_currentIndex != startTokenId) revert();
754             } else {
755                 do {
756                     emit Transfer(address(0), to, updatedIndex++);
757                 } while (updatedIndex < end);
758             }
759             _currentIndex = updatedIndex;
760         }
761         _afterTokenTransfers(address(0), to, startTokenId, quantity);
762     }
763 
764     /**
765      * @dev Mints `quantity` tokens and transfers them to `to`.
766      *
767      * Requirements:
768      *
769      * - `to` cannot be the zero address.
770      * - `quantity` must be greater than 0.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _mint(address to, uint256 quantity) internal {
775         uint256 startTokenId = _currentIndex;
776         if (to == address(0)) revert MintToZeroAddress();
777         if (quantity == 0) revert MintZeroQuantity();
778 
779         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
780 
781         // Overflows are incredibly unrealistic.
782         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
783         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
784         unchecked {
785             // Updates:
786             // - `balance += quantity`.
787             // - `numberMinted += quantity`.
788             //
789             // We can directly add to the balance and number minted.
790             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
791 
792             // Updates:
793             // - `address` to the owner.
794             // - `startTimestamp` to the timestamp of minting.
795             // - `burned` to `false`.
796             // - `nextInitialized` to `quantity == 1`.
797             _packedOwnerships[startTokenId] =
798                 _addressToUint256(to) |
799                 (block.timestamp << BITPOS_START_TIMESTAMP) |
800                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
801 
802             uint256 updatedIndex = startTokenId;
803             uint256 end = updatedIndex + quantity;
804 
805             do {
806                 emit Transfer(address(0), to, updatedIndex++);
807             } while (updatedIndex < end);
808 
809             _currentIndex = updatedIndex;
810         }
811         _afterTokenTransfers(address(0), to, startTokenId, quantity);
812     }
813 
814     /**
815      * @dev Transfers `tokenId` from `from` to `to`.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _transfer(
825         address from,
826         address to,
827         uint256 tokenId
828     ) private {
829         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
830 
831         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
832 
833         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
834             isApprovedForAll(from, _msgSenderERC721A()) ||
835             getApproved(tokenId) == _msgSenderERC721A());
836 
837         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
838         if (to == address(0)) revert TransferToZeroAddress();
839 
840         _beforeTokenTransfers(from, to, tokenId, 1);
841 
842         // Clear approvals from the previous owner.
843         delete _tokenApprovals[tokenId];
844 
845         // Underflow of the sender's balance is impossible because we check for
846         // ownership above and the recipient's balance can't realistically overflow.
847         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
848         unchecked {
849             // We can directly increment and decrement the balances.
850             --_packedAddressData[from]; // Updates: `balance -= 1`.
851             ++_packedAddressData[to]; // Updates: `balance += 1`.
852 
853             // Updates:
854             // - `address` to the next owner.
855             // - `startTimestamp` to the timestamp of transfering.
856             // - `burned` to `false`.
857             // - `nextInitialized` to `true`.
858             _packedOwnerships[tokenId] =
859                 _addressToUint256(to) |
860                 (block.timestamp << BITPOS_START_TIMESTAMP) |
861                 BITMASK_NEXT_INITIALIZED;
862 
863             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
864             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
865                 uint256 nextTokenId = tokenId + 1;
866                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
867                 if (_packedOwnerships[nextTokenId] == 0) {
868                     // If the next slot is within bounds.
869                     if (nextTokenId != _currentIndex) {
870                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
871                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
872                     }
873                 }
874             }
875         }
876 
877         emit Transfer(from, to, tokenId);
878         _afterTokenTransfers(from, to, tokenId, 1);
879     }
880 
881     /**
882      * @dev Equivalent to `_burn(tokenId, false)`.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         _burn(tokenId, false);
886     }
887 
888     /**
889      * @dev Destroys `tokenId`.
890      * The approval is cleared when the token is burned.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
899         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
900 
901         address from = address(uint160(prevOwnershipPacked));
902 
903         if (approvalCheck) {
904             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
905                 isApprovedForAll(from, _msgSenderERC721A()) ||
906                 getApproved(tokenId) == _msgSenderERC721A());
907 
908             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
909         }
910 
911         _beforeTokenTransfers(from, address(0), tokenId, 1);
912 
913         // Clear approvals from the previous owner.
914         delete _tokenApprovals[tokenId];
915 
916         // Underflow of the sender's balance is impossible because we check for
917         // ownership above and the recipient's balance can't realistically overflow.
918         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
919         unchecked {
920             // Updates:
921             // - `balance -= 1`.
922             // - `numberBurned += 1`.
923             //
924             // We can directly decrement the balance, and increment the number burned.
925             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
926             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
927 
928             // Updates:
929             // - `address` to the last owner.
930             // - `startTimestamp` to the timestamp of burning.
931             // - `burned` to `true`.
932             // - `nextInitialized` to `true`.
933             _packedOwnerships[tokenId] =
934                 _addressToUint256(from) |
935                 (block.timestamp << BITPOS_START_TIMESTAMP) |
936                 BITMASK_BURNED | 
937                 BITMASK_NEXT_INITIALIZED;
938 
939             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
940             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
941                 uint256 nextTokenId = tokenId + 1;
942                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
943                 if (_packedOwnerships[nextTokenId] == 0) {
944                     // If the next slot is within bounds.
945                     if (nextTokenId != _currentIndex) {
946                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
947                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
948                     }
949                 }
950             }
951         }
952 
953         emit Transfer(from, address(0), tokenId);
954         _afterTokenTransfers(from, address(0), tokenId, 1);
955 
956         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
957         unchecked {
958             _burnCounter++;
959         }
960     }
961 
962     /**
963      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
964      *
965      * @param from address representing the previous owner of the given token ID
966      * @param to target address that will receive the tokens
967      * @param tokenId uint256 ID of the token to be transferred
968      * @param _data bytes optional data to send along with the call
969      * @return bool whether the call correctly returned the expected magic value
970      */
971     function _checkContractOnERC721Received(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) private returns (bool) {
977         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
978             bytes4 retval
979         ) {
980             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
981         } catch (bytes memory reason) {
982             if (reason.length == 0) {
983                 revert TransferToNonERC721ReceiverImplementer();
984             } else {
985                 assembly {
986                     revert(add(32, reason), mload(reason))
987                 }
988             }
989         }
990     }
991 
992     /**
993      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
994      * And also called before burning one token.
995      *
996      * startTokenId - the first token id to be transferred
997      * quantity - the amount to be transferred
998      *
999      * Calling conditions:
1000      *
1001      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1002      * transferred to `to`.
1003      * - When `from` is zero, `tokenId` will be minted for `to`.
1004      * - When `to` is zero, `tokenId` will be burned by `from`.
1005      * - `from` and `to` are never both zero.
1006      */
1007     function _beforeTokenTransfers(
1008         address from,
1009         address to,
1010         uint256 startTokenId,
1011         uint256 quantity
1012     ) internal virtual {}
1013 
1014     /**
1015      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1016      * minting.
1017      * And also called after one token has been burned.
1018      *
1019      * startTokenId - the first token id to be transferred
1020      * quantity - the amount to be transferred
1021      *
1022      * Calling conditions:
1023      *
1024      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1025      * transferred to `to`.
1026      * - When `from` is zero, `tokenId` has been minted for `to`.
1027      * - When `to` is zero, `tokenId` has been burned by `from`.
1028      * - `from` and `to` are never both zero.
1029      */
1030     function _afterTokenTransfers(
1031         address from,
1032         address to,
1033         uint256 startTokenId,
1034         uint256 quantity
1035     ) internal virtual {}
1036 
1037     /**
1038      * @dev Returns the message sender (defaults to `msg.sender`).
1039      *
1040      * If you are writing GSN compatible contracts, you need to override this function.
1041      */
1042     function _msgSenderERC721A() internal view virtual returns (address) {
1043         return msg.sender;
1044     }
1045 
1046     /**
1047      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1048      */
1049     function _toString(uint256 value) internal pure returns (string memory ptr) {
1050         assembly {
1051             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1052             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1053             // We will need 1 32-byte word to store the length, 
1054             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1055             ptr := add(mload(0x40), 128)
1056             // Update the free memory pointer to allocate.
1057             mstore(0x40, ptr)
1058 
1059             // Cache the end of the memory to calculate the length later.
1060             let end := ptr
1061 
1062             // We write the string from the rightmost digit to the leftmost digit.
1063             // The following is essentially a do-while loop that also handles the zero case.
1064             // Costs a bit more than early returning for the zero case,
1065             // but cheaper in terms of deployment and overall runtime costs.
1066             for { 
1067                 // Initialize and perform the first pass without check.
1068                 let temp := value
1069                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1070                 ptr := sub(ptr, 1)
1071                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1072                 mstore8(ptr, add(48, mod(temp, 10)))
1073                 temp := div(temp, 10)
1074             } temp { 
1075                 // Keep dividing `temp` until zero.
1076                 temp := div(temp, 10)
1077             } { // Body of the for loop.
1078                 ptr := sub(ptr, 1)
1079                 mstore8(ptr, add(48, mod(temp, 10)))
1080             }
1081             
1082             let length := sub(end, ptr)
1083             // Move the pointer 32 bytes leftwards to make room for the length.
1084             ptr := sub(ptr, 32)
1085             // Store the length.
1086             mstore(ptr, length)
1087         }
1088     }
1089 }
1090 
1091 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1092 
1093 
1094 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 /**
1099  * @dev String operations.
1100  */
1101 library Strings {
1102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1103     uint8 private constant _ADDRESS_LENGTH = 20;
1104 
1105     /**
1106      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1107      */
1108     function toString(uint256 value) internal pure returns (string memory) {
1109         // Inspired by OraclizeAPI's implementation - MIT licence
1110         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1111 
1112         if (value == 0) {
1113             return "0";
1114         }
1115         uint256 temp = value;
1116         uint256 digits;
1117         while (temp != 0) {
1118             digits++;
1119             temp /= 10;
1120         }
1121         bytes memory buffer = new bytes(digits);
1122         while (value != 0) {
1123             digits -= 1;
1124             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1125             value /= 10;
1126         }
1127         return string(buffer);
1128     }
1129 
1130     /**
1131      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1132      */
1133     function toHexString(uint256 value) internal pure returns (string memory) {
1134         if (value == 0) {
1135             return "0x00";
1136         }
1137         uint256 temp = value;
1138         uint256 length = 0;
1139         while (temp != 0) {
1140             length++;
1141             temp >>= 8;
1142         }
1143         return toHexString(value, length);
1144     }
1145 
1146     /**
1147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1148      */
1149     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1150         bytes memory buffer = new bytes(2 * length + 2);
1151         buffer[0] = "0";
1152         buffer[1] = "x";
1153         for (uint256 i = 2 * length + 1; i > 1; --i) {
1154             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1155             value >>= 4;
1156         }
1157         require(value == 0, "Strings: hex length insufficient");
1158         return string(buffer);
1159     }
1160 
1161     /**
1162      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1163      */
1164     function toHexString(address addr) internal pure returns (string memory) {
1165         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1166     }
1167 }
1168 
1169 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1170 
1171 
1172 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev Provides information about the current execution context, including the
1178  * sender of the transaction and its data. While these are generally available
1179  * via msg.sender and msg.data, they should not be accessed in such a direct
1180  * manner, since when dealing with meta-transactions the account sending and
1181  * paying for execution may not be the actual sender (as far as an application
1182  * is concerned).
1183  *
1184  * This contract is only required for intermediate, library-like contracts.
1185  */
1186 abstract contract Context {
1187     function _msgSender() internal view virtual returns (address) {
1188         return msg.sender;
1189     }
1190 
1191     function _msgData() internal view virtual returns (bytes calldata) {
1192         return msg.data;
1193     }
1194 }
1195 
1196 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1197 
1198 
1199 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1200 
1201 pragma solidity ^0.8.0;
1202 
1203 
1204 /**
1205  * @dev Contract module which provides a basic access control mechanism, where
1206  * there is an account (an owner) that can be granted exclusive access to
1207  * specific functions.
1208  *
1209  * By default, the owner account will be the one that deploys the contract. This
1210  * can later be changed with {transferOwnership}.
1211  *
1212  * This module is used through inheritance. It will make available the modifier
1213  * `onlyOwner`, which can be applied to your functions to restrict their use to
1214  * the owner.
1215  */
1216 abstract contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _transferOwnership(_msgSender());
1226     }
1227 
1228     /**
1229      * @dev Returns the address of the current owner.
1230      */
1231     function owner() public view virtual returns (address) {
1232         return _owner;
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Leaves the contract without owner. It will not be possible to call
1245      * `onlyOwner` functions anymore. Can only be called by the current owner.
1246      *
1247      * NOTE: Renouncing ownership will leave the contract without an owner,
1248      * thereby removing any functionality that is only available to the owner.
1249      */
1250     function renounceOwnership() public virtual onlyOwner {
1251         _transferOwnership(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(newOwner != address(0), "Ownable: new owner is the zero address");
1260         _transferOwnership(newOwner);
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Internal function without access restriction.
1266      */
1267     function _transferOwnership(address newOwner) internal virtual {
1268         address oldOwner = _owner;
1269         _owner = newOwner;
1270         emit OwnershipTransferred(oldOwner, newOwner);
1271     }
1272 }
1273 
1274 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1275 
1276 
1277 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1278 
1279 pragma solidity ^0.8.1;
1280 
1281 /**
1282  * @dev Collection of functions related to the address type
1283  */
1284 library Address {
1285     /**
1286      * @dev Returns true if `account` is a contract.
1287      *
1288      * [IMPORTANT]
1289      * ====
1290      * It is unsafe to assume that an address for which this function returns
1291      * false is an externally-owned account (EOA) and not a contract.
1292      *
1293      * Among others, `isContract` will return false for the following
1294      * types of addresses:
1295      *
1296      *  - an externally-owned account
1297      *  - a contract in construction
1298      *  - an address where a contract will be created
1299      *  - an address where a contract lived, but was destroyed
1300      * ====
1301      *
1302      * [IMPORTANT]
1303      * ====
1304      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1305      *
1306      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1307      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1308      * constructor.
1309      * ====
1310      */
1311     function isContract(address account) internal view returns (bool) {
1312         // This method relies on extcodesize/address.code.length, which returns 0
1313         // for contracts in construction, since the code is only stored at the end
1314         // of the constructor execution.
1315 
1316         return account.code.length > 0;
1317     }
1318 
1319     /**
1320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1321      * `recipient`, forwarding all available gas and reverting on errors.
1322      *
1323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1325      * imposed by `transfer`, making them unable to receive funds via
1326      * `transfer`. {sendValue} removes this limitation.
1327      *
1328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1329      *
1330      * IMPORTANT: because control is transferred to `recipient`, care must be
1331      * taken to not create reentrancy vulnerabilities. Consider using
1332      * {ReentrancyGuard} or the
1333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1334      */
1335     function sendValue(address payable recipient, uint256 amount) internal {
1336         require(address(this).balance >= amount, "Address: insufficient balance");
1337 
1338         (bool success, ) = recipient.call{value: amount}("");
1339         require(success, "Address: unable to send value, recipient may have reverted");
1340     }
1341 
1342     /**
1343      * @dev Performs a Solidity function call using a low level `call`. A
1344      * plain `call` is an unsafe replacement for a function call: use this
1345      * function instead.
1346      *
1347      * If `target` reverts with a revert reason, it is bubbled up by this
1348      * function (like regular Solidity function calls).
1349      *
1350      * Returns the raw returned data. To convert to the expected return value,
1351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1352      *
1353      * Requirements:
1354      *
1355      * - `target` must be a contract.
1356      * - calling `target` with `data` must not revert.
1357      *
1358      * _Available since v3.1._
1359      */
1360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1361         return functionCall(target, data, "Address: low-level call failed");
1362     }
1363 
1364     /**
1365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1366      * `errorMessage` as a fallback revert reason when `target` reverts.
1367      *
1368      * _Available since v3.1._
1369      */
1370     function functionCall(
1371         address target,
1372         bytes memory data,
1373         string memory errorMessage
1374     ) internal returns (bytes memory) {
1375         return functionCallWithValue(target, data, 0, errorMessage);
1376     }
1377 
1378     /**
1379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1380      * but also transferring `value` wei to `target`.
1381      *
1382      * Requirements:
1383      *
1384      * - the calling contract must have an ETH balance of at least `value`.
1385      * - the called Solidity function must be `payable`.
1386      *
1387      * _Available since v3.1._
1388      */
1389     function functionCallWithValue(
1390         address target,
1391         bytes memory data,
1392         uint256 value
1393     ) internal returns (bytes memory) {
1394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1395     }
1396 
1397     /**
1398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1399      * with `errorMessage` as a fallback revert reason when `target` reverts.
1400      *
1401      * _Available since v3.1._
1402      */
1403     function functionCallWithValue(
1404         address target,
1405         bytes memory data,
1406         uint256 value,
1407         string memory errorMessage
1408     ) internal returns (bytes memory) {
1409         require(address(this).balance >= value, "Address: insufficient balance for call");
1410         require(isContract(target), "Address: call to non-contract");
1411 
1412         (bool success, bytes memory returndata) = target.call{value: value}(data);
1413         return verifyCallResult(success, returndata, errorMessage);
1414     }
1415 
1416     /**
1417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1418      * but performing a static call.
1419      *
1420      * _Available since v3.3._
1421      */
1422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1423         return functionStaticCall(target, data, "Address: low-level static call failed");
1424     }
1425 
1426     /**
1427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1428      * but performing a static call.
1429      *
1430      * _Available since v3.3._
1431      */
1432     function functionStaticCall(
1433         address target,
1434         bytes memory data,
1435         string memory errorMessage
1436     ) internal view returns (bytes memory) {
1437         require(isContract(target), "Address: static call to non-contract");
1438 
1439         (bool success, bytes memory returndata) = target.staticcall(data);
1440         return verifyCallResult(success, returndata, errorMessage);
1441     }
1442 
1443     /**
1444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1445      * but performing a delegate call.
1446      *
1447      * _Available since v3.4._
1448      */
1449     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1450         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1451     }
1452 
1453     /**
1454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1455      * but performing a delegate call.
1456      *
1457      * _Available since v3.4._
1458      */
1459     function functionDelegateCall(
1460         address target,
1461         bytes memory data,
1462         string memory errorMessage
1463     ) internal returns (bytes memory) {
1464         require(isContract(target), "Address: delegate call to non-contract");
1465 
1466         (bool success, bytes memory returndata) = target.delegatecall(data);
1467         return verifyCallResult(success, returndata, errorMessage);
1468     }
1469 
1470     /**
1471      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1472      * revert reason using the provided one.
1473      *
1474      * _Available since v4.3._
1475      */
1476     function verifyCallResult(
1477         bool success,
1478         bytes memory returndata,
1479         string memory errorMessage
1480     ) internal pure returns (bytes memory) {
1481         if (success) {
1482             return returndata;
1483         } else {
1484             // Look for revert reason and bubble it up if present
1485             if (returndata.length > 0) {
1486                 // The easiest way to bubble the revert reason is using memory via assembly
1487 
1488                 assembly {
1489                     let returndata_size := mload(returndata)
1490                     revert(add(32, returndata), returndata_size)
1491                 }
1492             } else {
1493                 revert(errorMessage);
1494             }
1495         }
1496     }
1497 }
1498 
1499 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1500 
1501 
1502 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1503 
1504 pragma solidity ^0.8.0;
1505 
1506 /**
1507  * @title ERC721 token receiver interface
1508  * @dev Interface for any contract that wants to support safeTransfers
1509  * from ERC721 asset contracts.
1510  */
1511 interface IERC721Receiver {
1512     /**
1513      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1514      * by `operator` from `from`, this function is called.
1515      *
1516      * It must return its Solidity selector to confirm the token transfer.
1517      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1518      *
1519      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1520      */
1521     function onERC721Received(
1522         address operator,
1523         address from,
1524         uint256 tokenId,
1525         bytes calldata data
1526     ) external returns (bytes4);
1527 }
1528 
1529 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1530 
1531 
1532 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @dev Interface of the ERC165 standard, as defined in the
1538  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1539  *
1540  * Implementers can declare support of contract interfaces, which can then be
1541  * queried by others ({ERC165Checker}).
1542  *
1543  * For an implementation, see {ERC165}.
1544  */
1545 interface IERC165 {
1546     /**
1547      * @dev Returns true if this contract implements the interface defined by
1548      * `interfaceId`. See the corresponding
1549      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1550      * to learn more about how these ids are created.
1551      *
1552      * This function call must use less than 30 000 gas.
1553      */
1554     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1555 }
1556 
1557 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1558 
1559 
1560 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1561 
1562 pragma solidity ^0.8.0;
1563 
1564 
1565 /**
1566  * @dev Implementation of the {IERC165} interface.
1567  *
1568  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1569  * for the additional interface id that will be supported. For example:
1570  *
1571  * ```solidity
1572  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1573  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1574  * }
1575  * ```
1576  *
1577  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1578  */
1579 abstract contract ERC165 is IERC165 {
1580     /**
1581      * @dev See {IERC165-supportsInterface}.
1582      */
1583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1584         return interfaceId == type(IERC165).interfaceId;
1585     }
1586 }
1587 
1588 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1589 
1590 
1591 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 
1596 /**
1597  * @dev Required interface of an ERC721 compliant contract.
1598  */
1599 interface IERC721 is IERC165 {
1600     /**
1601      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1602      */
1603     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1604 
1605     /**
1606      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1607      */
1608     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1609 
1610     /**
1611      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1612      */
1613     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1614 
1615     /**
1616      * @dev Returns the number of tokens in ``owner``'s account.
1617      */
1618     function balanceOf(address owner) external view returns (uint256 balance);
1619 
1620     /**
1621      * @dev Returns the owner of the `tokenId` token.
1622      *
1623      * Requirements:
1624      *
1625      * - `tokenId` must exist.
1626      */
1627     function ownerOf(uint256 tokenId) external view returns (address owner);
1628 
1629     /**
1630      * @dev Safely transfers `tokenId` token from `from` to `to`.
1631      *
1632      * Requirements:
1633      *
1634      * - `from` cannot be the zero address.
1635      * - `to` cannot be the zero address.
1636      * - `tokenId` token must exist and be owned by `from`.
1637      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function safeTransferFrom(
1643         address from,
1644         address to,
1645         uint256 tokenId,
1646         bytes calldata data
1647     ) external;
1648 
1649     /**
1650      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1651      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1652      *
1653      * Requirements:
1654      *
1655      * - `from` cannot be the zero address.
1656      * - `to` cannot be the zero address.
1657      * - `tokenId` token must exist and be owned by `from`.
1658      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1660      *
1661      * Emits a {Transfer} event.
1662      */
1663     function safeTransferFrom(
1664         address from,
1665         address to,
1666         uint256 tokenId
1667     ) external;
1668 
1669     /**
1670      * @dev Transfers `tokenId` token from `from` to `to`.
1671      *
1672      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1673      *
1674      * Requirements:
1675      *
1676      * - `from` cannot be the zero address.
1677      * - `to` cannot be the zero address.
1678      * - `tokenId` token must be owned by `from`.
1679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1680      *
1681      * Emits a {Transfer} event.
1682      */
1683     function transferFrom(
1684         address from,
1685         address to,
1686         uint256 tokenId
1687     ) external;
1688 
1689     /**
1690      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1691      * The approval is cleared when the token is transferred.
1692      *
1693      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1694      *
1695      * Requirements:
1696      *
1697      * - The caller must own the token or be an approved operator.
1698      * - `tokenId` must exist.
1699      *
1700      * Emits an {Approval} event.
1701      */
1702     function approve(address to, uint256 tokenId) external;
1703 
1704     /**
1705      * @dev Approve or remove `operator` as an operator for the caller.
1706      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1707      *
1708      * Requirements:
1709      *
1710      * - The `operator` cannot be the caller.
1711      *
1712      * Emits an {ApprovalForAll} event.
1713      */
1714     function setApprovalForAll(address operator, bool _approved) external;
1715 
1716     /**
1717      * @dev Returns the account approved for `tokenId` token.
1718      *
1719      * Requirements:
1720      *
1721      * - `tokenId` must exist.
1722      */
1723     function getApproved(uint256 tokenId) external view returns (address operator);
1724 
1725     /**
1726      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1727      *
1728      * See {setApprovalForAll}
1729      */
1730     function isApprovedForAll(address owner, address operator) external view returns (bool);
1731 }
1732 
1733 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1734 
1735 
1736 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1737 
1738 pragma solidity ^0.8.0;
1739 
1740 
1741 /**
1742  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1743  * @dev See https://eips.ethereum.org/EIPS/eip-721
1744  */
1745 interface IERC721Metadata is IERC721 {
1746     /**
1747      * @dev Returns the token collection name.
1748      */
1749     function name() external view returns (string memory);
1750 
1751     /**
1752      * @dev Returns the token collection symbol.
1753      */
1754     function symbol() external view returns (string memory);
1755 
1756     /**
1757      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1758      */
1759     function tokenURI(uint256 tokenId) external view returns (string memory);
1760 }
1761 
1762 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1763 
1764 
1765 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1766 
1767 pragma solidity ^0.8.0;
1768 
1769 
1770 
1771 
1772 
1773 
1774 
1775 
1776 /**
1777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1778  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1779  * {ERC721Enumerable}.
1780  */
1781 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1782     using Address for address;
1783     using Strings for uint256;
1784 
1785     // Token name
1786     string private _name;
1787 
1788     // Token symbol
1789     string private _symbol;
1790 
1791     // Mapping from token ID to owner address
1792     mapping(uint256 => address) private _owners;
1793 
1794     // Mapping owner address to token count
1795     mapping(address => uint256) private _balances;
1796 
1797     // Mapping from token ID to approved address
1798     mapping(uint256 => address) private _tokenApprovals;
1799 
1800     // Mapping from owner to operator approvals
1801     mapping(address => mapping(address => bool)) private _operatorApprovals;
1802 
1803     /**
1804      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1805      */
1806     constructor(string memory name_, string memory symbol_) {
1807         _name = name_;
1808         _symbol = symbol_;
1809     }
1810 
1811     /**
1812      * @dev See {IERC165-supportsInterface}.
1813      */
1814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1815         return
1816             interfaceId == type(IERC721).interfaceId ||
1817             interfaceId == type(IERC721Metadata).interfaceId ||
1818             super.supportsInterface(interfaceId);
1819     }
1820 
1821     /**
1822      * @dev See {IERC721-balanceOf}.
1823      */
1824     function balanceOf(address owner) public view virtual override returns (uint256) {
1825         require(owner != address(0), "ERC721: address zero is not a valid owner");
1826         return _balances[owner];
1827     }
1828 
1829     /**
1830      * @dev See {IERC721-ownerOf}.
1831      */
1832     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1833         address owner = _owners[tokenId];
1834         require(owner != address(0), "ERC721: owner query for nonexistent token");
1835         return owner;
1836     }
1837 
1838     /**
1839      * @dev See {IERC721Metadata-name}.
1840      */
1841     function name() public view virtual override returns (string memory) {
1842         return _name;
1843     }
1844 
1845     /**
1846      * @dev See {IERC721Metadata-symbol}.
1847      */
1848     function symbol() public view virtual override returns (string memory) {
1849         return _symbol;
1850     }
1851 
1852     /**
1853      * @dev See {IERC721Metadata-tokenURI}.
1854      */
1855     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1856         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1857 
1858         string memory baseURI = _baseURI();
1859         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1860     }
1861 
1862     /**
1863      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1864      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1865      * by default, can be overridden in child contracts.
1866      */
1867     function _baseURI() internal view virtual returns (string memory) {
1868         return "";
1869     }
1870 
1871     /**
1872      * @dev See {IERC721-approve}.
1873      */
1874     function approve(address to, uint256 tokenId) public virtual override {
1875         address owner = ERC721.ownerOf(tokenId);
1876         require(to != owner, "ERC721: approval to current owner");
1877 
1878         require(
1879             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1880             "ERC721: approve caller is not owner nor approved for all"
1881         );
1882 
1883         _approve(to, tokenId);
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-getApproved}.
1888      */
1889     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1890         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1891 
1892         return _tokenApprovals[tokenId];
1893     }
1894 
1895     /**
1896      * @dev See {IERC721-setApprovalForAll}.
1897      */
1898     function setApprovalForAll(address operator, bool approved) public virtual override {
1899         _setApprovalForAll(_msgSender(), operator, approved);
1900     }
1901 
1902     /**
1903      * @dev See {IERC721-isApprovedForAll}.
1904      */
1905     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1906         return _operatorApprovals[owner][operator];
1907     }
1908 
1909     /**
1910      * @dev See {IERC721-transferFrom}.
1911      */
1912     function transferFrom(
1913         address from,
1914         address to,
1915         uint256 tokenId
1916     ) public virtual override {
1917         //solhint-disable-next-line max-line-length
1918         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1919 
1920         _transfer(from, to, tokenId);
1921     }
1922 
1923     /**
1924      * @dev See {IERC721-safeTransferFrom}.
1925      */
1926     function safeTransferFrom(
1927         address from,
1928         address to,
1929         uint256 tokenId
1930     ) public virtual override {
1931         safeTransferFrom(from, to, tokenId, "");
1932     }
1933 
1934     /**
1935      * @dev See {IERC721-safeTransferFrom}.
1936      */
1937     function safeTransferFrom(
1938         address from,
1939         address to,
1940         uint256 tokenId,
1941         bytes memory data
1942     ) public virtual override {
1943         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1944         _safeTransfer(from, to, tokenId, data);
1945     }
1946 
1947     /**
1948      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1949      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1950      *
1951      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1952      *
1953      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1954      * implement alternative mechanisms to perform token transfer, such as signature-based.
1955      *
1956      * Requirements:
1957      *
1958      * - `from` cannot be the zero address.
1959      * - `to` cannot be the zero address.
1960      * - `tokenId` token must exist and be owned by `from`.
1961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1962      *
1963      * Emits a {Transfer} event.
1964      */
1965     function _safeTransfer(
1966         address from,
1967         address to,
1968         uint256 tokenId,
1969         bytes memory data
1970     ) internal virtual {
1971         _transfer(from, to, tokenId);
1972         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1973     }
1974 
1975     /**
1976      * @dev Returns whether `tokenId` exists.
1977      *
1978      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1979      *
1980      * Tokens start existing when they are minted (`_mint`),
1981      * and stop existing when they are burned (`_burn`).
1982      */
1983     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1984         return _owners[tokenId] != address(0);
1985     }
1986 
1987     /**
1988      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1989      *
1990      * Requirements:
1991      *
1992      * - `tokenId` must exist.
1993      */
1994     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1995         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1996         address owner = ERC721.ownerOf(tokenId);
1997         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1998     }
1999 
2000     /**
2001      * @dev Safely mints `tokenId` and transfers it to `to`.
2002      *
2003      * Requirements:
2004      *
2005      * - `tokenId` must not exist.
2006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2007      *
2008      * Emits a {Transfer} event.
2009      */
2010     function _safeMint(address to, uint256 tokenId) internal virtual {
2011         _safeMint(to, tokenId, "");
2012     }
2013 
2014     /**
2015      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2016      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2017      */
2018     function _safeMint(
2019         address to,
2020         uint256 tokenId,
2021         bytes memory data
2022     ) internal virtual {
2023         _mint(to, tokenId);
2024         require(
2025             _checkOnERC721Received(address(0), to, tokenId, data),
2026             "ERC721: transfer to non ERC721Receiver implementer"
2027         );
2028     }
2029 
2030     /**
2031      * @dev Mints `tokenId` and transfers it to `to`.
2032      *
2033      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2034      *
2035      * Requirements:
2036      *
2037      * - `tokenId` must not exist.
2038      * - `to` cannot be the zero address.
2039      *
2040      * Emits a {Transfer} event.
2041      */
2042     function _mint(address to, uint256 tokenId) internal virtual {
2043         require(to != address(0), "ERC721: mint to the zero address");
2044         require(!_exists(tokenId), "ERC721: token already minted");
2045 
2046         _beforeTokenTransfer(address(0), to, tokenId);
2047 
2048         _balances[to] += 1;
2049         _owners[tokenId] = to;
2050 
2051         emit Transfer(address(0), to, tokenId);
2052 
2053         _afterTokenTransfer(address(0), to, tokenId);
2054     }
2055 
2056     /**
2057      * @dev Destroys `tokenId`.
2058      * The approval is cleared when the token is burned.
2059      *
2060      * Requirements:
2061      *
2062      * - `tokenId` must exist.
2063      *
2064      * Emits a {Transfer} event.
2065      */
2066     function _burn(uint256 tokenId) internal virtual {
2067         address owner = ERC721.ownerOf(tokenId);
2068 
2069         _beforeTokenTransfer(owner, address(0), tokenId);
2070 
2071         // Clear approvals
2072         _approve(address(0), tokenId);
2073 
2074         _balances[owner] -= 1;
2075         delete _owners[tokenId];
2076 
2077         emit Transfer(owner, address(0), tokenId);
2078 
2079         _afterTokenTransfer(owner, address(0), tokenId);
2080     }
2081 
2082     /**
2083      * @dev Transfers `tokenId` from `from` to `to`.
2084      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2085      *
2086      * Requirements:
2087      *
2088      * - `to` cannot be the zero address.
2089      * - `tokenId` token must be owned by `from`.
2090      *
2091      * Emits a {Transfer} event.
2092      */
2093     function _transfer(
2094         address from,
2095         address to,
2096         uint256 tokenId
2097     ) internal virtual {
2098         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2099         require(to != address(0), "ERC721: transfer to the zero address");
2100 
2101         _beforeTokenTransfer(from, to, tokenId);
2102 
2103         // Clear approvals from the previous owner
2104         _approve(address(0), tokenId);
2105 
2106         _balances[from] -= 1;
2107         _balances[to] += 1;
2108         _owners[tokenId] = to;
2109 
2110         emit Transfer(from, to, tokenId);
2111 
2112         _afterTokenTransfer(from, to, tokenId);
2113     }
2114 
2115     /**
2116      * @dev Approve `to` to operate on `tokenId`
2117      *
2118      * Emits an {Approval} event.
2119      */
2120     function _approve(address to, uint256 tokenId) internal virtual {
2121         _tokenApprovals[tokenId] = to;
2122         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2123     }
2124 
2125     /**
2126      * @dev Approve `operator` to operate on all of `owner` tokens
2127      *
2128      * Emits an {ApprovalForAll} event.
2129      */
2130     function _setApprovalForAll(
2131         address owner,
2132         address operator,
2133         bool approved
2134     ) internal virtual {
2135         require(owner != operator, "ERC721: approve to caller");
2136         _operatorApprovals[owner][operator] = approved;
2137         emit ApprovalForAll(owner, operator, approved);
2138     }
2139 
2140     /**
2141      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2142      * The call is not executed if the target address is not a contract.
2143      *
2144      * @param from address representing the previous owner of the given token ID
2145      * @param to target address that will receive the tokens
2146      * @param tokenId uint256 ID of the token to be transferred
2147      * @param data bytes optional data to send along with the call
2148      * @return bool whether the call correctly returned the expected magic value
2149      */
2150     function _checkOnERC721Received(
2151         address from,
2152         address to,
2153         uint256 tokenId,
2154         bytes memory data
2155     ) private returns (bool) {
2156         if (to.isContract()) {
2157             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2158                 return retval == IERC721Receiver.onERC721Received.selector;
2159             } catch (bytes memory reason) {
2160                 if (reason.length == 0) {
2161                     revert("ERC721: transfer to non ERC721Receiver implementer");
2162                 } else {
2163                     assembly {
2164                         revert(add(32, reason), mload(reason))
2165                     }
2166                 }
2167             }
2168         } else {
2169             return true;
2170         }
2171     }
2172 
2173     /**
2174      * @dev Hook that is called before any token transfer. This includes minting
2175      * and burning.
2176      *
2177      * Calling conditions:
2178      *
2179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2180      * transferred to `to`.
2181      * - When `from` is zero, `tokenId` will be minted for `to`.
2182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2183      * - `from` and `to` are never both zero.
2184      *
2185      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2186      */
2187     function _beforeTokenTransfer(
2188         address from,
2189         address to,
2190         uint256 tokenId
2191     ) internal virtual {}
2192 
2193     /**
2194      * @dev Hook that is called after any transfer of tokens. This includes
2195      * minting and burning.
2196      *
2197      * Calling conditions:
2198      *
2199      * - when `from` and `to` are both non-zero.
2200      * - `from` and `to` are never both zero.
2201      *
2202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2203      */
2204     function _afterTokenTransfer(
2205         address from,
2206         address to,
2207         uint256 tokenId
2208     ) internal virtual {}
2209 }
2210 
2211 
2212 pragma solidity ^0.8.0;
2213 
2214 
2215 contract Necropolis is ERC721A, Ownable {
2216 
2217     using Strings for uint256;
2218     string private baseURI;
2219     uint256 public price = 0.005 ether;
2220     uint256 public maxPerTx = 10;
2221     uint256 public maxFreePerWallet = 1;
2222     uint256 public totalFree = 8888;
2223     uint256 public maxSupply = 8888;
2224 
2225     bool public mintEnabled = false;
2226 
2227     mapping(address => uint256) private _mintedFreeAmount;
2228 
2229     constructor() ERC721A("Necropolis", "NECRO") {
2230         _safeMint(msg.sender, 1);
2231         setBaseURI("ipfs://bafybeig2bci2l3ozy273brd4s46xwk4s5lz6n5cjo353wi2muc2umxanou/");
2232     }
2233 
2234     function mint(uint256 count) external payable {
2235         uint256 cost = price;
2236         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2237             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2238 
2239         if (isFree) {
2240             cost = 0;
2241         }
2242 
2243         require(msg.value >= count * cost, "Please send the exact amount.");
2244         require(totalSupply() + count < maxSupply + 1, "No more left.");
2245         require(mintEnabled, "Mint is not live yet.");
2246         require(count < maxPerTx + 1, "Max per TX reached.");
2247         require(tx.origin == msg.sender, "Contracts not allowed to mint.");
2248 
2249 
2250         if (isFree) {
2251             _mintedFreeAmount[msg.sender] += count;
2252         }
2253 
2254         _safeMint(msg.sender, count);
2255     }
2256 
2257     function _baseURI() internal view virtual override returns (string memory) {
2258         return baseURI;
2259     }
2260 
2261     function tokenURI(uint256 tokenId)
2262         public
2263         view
2264         virtual
2265         override
2266         returns (string memory)
2267     {
2268         require(
2269             _exists(tokenId),
2270             "ERC721Metadata: URI query for nonexistent token"
2271         );
2272         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2273     }
2274 
2275     function setBaseURI(string memory uri) public onlyOwner {
2276         baseURI = uri;
2277     }
2278 
2279     function setFreeAmount(uint256 amount) external onlyOwner {
2280         totalFree = amount;
2281     }
2282 
2283     function setPrice(uint256 _newPrice) external onlyOwner {
2284         price = _newPrice;
2285     }
2286 
2287     function flipSale() external onlyOwner {
2288         mintEnabled = !mintEnabled;
2289     }
2290 
2291     function withdraw() external onlyOwner {
2292         (bool success, ) = payable(msg.sender).call{
2293             value: address(this).balance
2294         }("");
2295         require(success, "Transfer failed.");
2296     }
2297 }