1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 
6   (                                 _
7    )                               /=>
8   (  +____________________/\/\___ / /|
9    .''._____________'._____      / /|/\
10   : () :              :\ ----\|    \ )
11    '..'______________.'0|----|      \
12                     0_0/____/        \
13                         |----    /----\
14                        || -\\ --|      \
15           WELCOME      ||   || ||\      \
16              TO         \\____// '|      \
17      HOUSE OF THE DEAD !        .'/       |
18   RESURRECT 1 DEAD BODY FREE   .:/        |
19      OR MORE 0.002 EACH        :/_________|
20 
21 /*
22 pragma solidity ^0.8.7;
23 
24 /**
25  * @dev Interface of an ERC721A compliant contract.
26  */
27 interface IERC721A {
28     /**
29      * The caller must own the token or be an approved operator.
30      */
31     error ApprovalCallerNotOwnerNorApproved();
32 
33     /**
34      * The token does not exist.
35      */
36     error ApprovalQueryForNonexistentToken();
37 
38     /**
39      * The caller cannot approve to their own address.
40      */
41     error ApproveToCaller();
42 
43     /**
44      * The caller cannot approve to the current owner.
45      */
46     error ApprovalToCurrentOwner();
47 
48     /**
49      * Cannot query the balance for the zero address.
50      */
51     error BalanceQueryForZeroAddress();
52 
53     /**
54      * Cannot mint to the zero address.
55      */
56     error MintToZeroAddress();
57 
58     /**
59      * The quantity of tokens minted must be more than zero.
60      */
61     error MintZeroQuantity();
62 
63     /**
64      * The token does not exist.
65      */
66     error OwnerQueryForNonexistentToken();
67 
68     /**
69      * The caller must own the token or be an approved operator.
70      */
71     error TransferCallerNotOwnerNorApproved();
72 
73     /**
74      * The token must be owned by `from`.
75      */
76     error TransferFromIncorrectOwner();
77 
78     /**
79      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
80      */
81     error TransferToNonERC721ReceiverImplementer();
82 
83     /**
84      * Cannot transfer to the zero address.
85      */
86     error TransferToZeroAddress();
87 
88     /**
89      * The token does not exist.
90      */
91     error URIQueryForNonexistentToken();
92 
93     struct TokenOwnership {
94         // The address of the owner.
95         address addr;
96         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
97         uint64 startTimestamp;
98         // Whether the token has been burned.
99         bool burned;
100     }
101 
102     /**
103      * @dev Returns the total amount of tokens stored by the contract.
104      *
105      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     // ==============================
110     //            IERC165
111     // ==============================
112 
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 
123     // ==============================
124     //            IERC721
125     // ==============================
126 
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
178      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` token from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns the account approved for `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function getApproved(uint256 tokenId) external view returns (address operator);
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     // ==============================
260     //        IERC721Metadata
261     // ==============================
262 
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
280 
281 
282 // ERC721A Contracts v3.3.0
283 // Creator: Chiru Labs
284 
285 pragma solidity ^0.8.4;
286 
287 
288 /**
289  * @dev ERC721 token receiver interface.
290  */
291 interface ERC721A__IERC721Receiver {
292     function onERC721Received(
293         address operator,
294         address from,
295         uint256 tokenId,
296         bytes calldata data
297     ) external returns (bytes4);
298 }
299 
300 /**
301  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
302  * the Metadata extension. Built to optimize for lower gas during batch mints.
303  *
304  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
305  *
306  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
307  *
308  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
309  */
310 contract ERC721A is IERC721A {
311     // Mask of an entry in packed address data.
312     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
313 
314     // The bit position of `numberMinted` in packed address data.
315     uint256 private constant BITPOS_NUMBER_MINTED = 64;
316 
317     // The bit position of `numberBurned` in packed address data.
318     uint256 private constant BITPOS_NUMBER_BURNED = 128;
319 
320     // The bit position of `aux` in packed address data.
321     uint256 private constant BITPOS_AUX = 192;
322 
323     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
324     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
325 
326     // The bit position of `startTimestamp` in packed ownership.
327     uint256 private constant BITPOS_START_TIMESTAMP = 160;
328 
329     // The bit mask of the `burned` bit in packed ownership.
330     uint256 private constant BITMASK_BURNED = 1 << 224;
331     
332     // The bit position of the `nextInitialized` bit in packed ownership.
333     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
334 
335     // The bit mask of the `nextInitialized` bit in packed ownership.
336     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
337 
338     // The tokenId of the next token to be minted.
339     uint256 private _currentIndex;
340 
341     // The number of tokens burned.
342     uint256 private _burnCounter;
343 
344     // Token name
345     string private _name;
346 
347     // Token symbol
348     string private _symbol;
349 
350     // Mapping from token ID to ownership details
351     // An empty struct value does not necessarily mean the token is unowned.
352     // See `_packedOwnershipOf` implementation for details.
353     //
354     // Bits Layout:
355     // - [0..159]   `addr`
356     // - [160..223] `startTimestamp`
357     // - [224]      `burned`
358     // - [225]      `nextInitialized`
359     mapping(uint256 => uint256) private _packedOwnerships;
360 
361     // Mapping owner address to address data.
362     //
363     // Bits Layout:
364     // - [0..63]    `balance`
365     // - [64..127]  `numberMinted`
366     // - [128..191] `numberBurned`
367     // - [192..255] `aux`
368     mapping(address => uint256) private _packedAddressData;
369 
370     // Mapping from token ID to approved address.
371     mapping(uint256 => address) private _tokenApprovals;
372 
373     // Mapping from owner to operator approvals
374     mapping(address => mapping(address => bool)) private _operatorApprovals;
375 
376     constructor(string memory name_, string memory symbol_) {
377         _name = name_;
378         _symbol = symbol_;
379         _currentIndex = _startTokenId();
380     }
381 
382     /**
383      * @dev Returns the starting token ID. 
384      * To change the starting token ID, please override this function.
385      */
386     function _startTokenId() internal view virtual returns (uint256) {
387         return 1;
388     }
389 
390     /**
391      * @dev Returns the next token ID to be minted.
392      */
393     function _nextTokenId() internal view returns (uint256) {
394         return _currentIndex;
395     }
396 
397     /**
398      * @dev Returns the total number of tokens in existence.
399      * Burned tokens will reduce the count. 
400      * To get the total number of tokens minted, please see `_totalMinted`.
401      */
402     function totalSupply() public view override returns (uint256) {
403         // Counter underflow is impossible as _burnCounter cannot be incremented
404         // more than `_currentIndex - _startTokenId()` times.
405         unchecked {
406             return _currentIndex - _burnCounter - _startTokenId();
407         }
408     }
409 
410     /**
411      * @dev Returns the total amount of tokens minted in the contract.
412      */
413     function _totalMinted() internal view returns (uint256) {
414         // Counter underflow is impossible as _currentIndex does not decrement,
415         // and it is initialized to `_startTokenId()`
416         unchecked {
417             return _currentIndex - _startTokenId();
418         }
419     }
420 
421     /**
422      * @dev Returns the total number of tokens burned.
423      */
424     function _totalBurned() internal view returns (uint256) {
425         return _burnCounter;
426     }
427 
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         // The interface IDs are constants representing the first 4 bytes of the XOR of
433         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
434         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
435         return
436             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
437             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
438             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
439     }
440 
441     /**
442      * @dev See {IERC721-balanceOf}.
443      */
444     function balanceOf(address owner) public view override returns (uint256) {
445         if (owner == address(0)) revert BalanceQueryForZeroAddress();
446         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
447     }
448 
449     /**
450      * Returns the number of tokens minted by `owner`.
451      */
452     function _numberMinted(address owner) internal view returns (uint256) {
453         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
454     }
455 
456     /**
457      * Returns the number of tokens burned by or on behalf of `owner`.
458      */
459     function _numberBurned(address owner) internal view returns (uint256) {
460         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
461     }
462 
463     /**
464      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
465      */
466     function _getAux(address owner) internal view returns (uint64) {
467         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
468     }
469 
470     /**
471      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
472      * If there are multiple variables, please pack them into a uint64.
473      */
474     function _setAux(address owner, uint64 aux) internal {
475         uint256 packed = _packedAddressData[owner];
476         uint256 auxCasted;
477         assembly { // Cast aux without masking.
478             auxCasted := aux
479         }
480         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
481         _packedAddressData[owner] = packed;
482     }
483 
484     /**
485      * Returns the packed ownership data of `tokenId`.
486      */
487     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
488         uint256 curr = tokenId;
489 
490         unchecked {
491             if (_startTokenId() <= curr)
492                 if (curr < _currentIndex) {
493                     uint256 packed = _packedOwnerships[curr];
494                     // If not burned.
495                     if (packed & BITMASK_BURNED == 0) {
496                         // Invariant:
497                         // There will always be an ownership that has an address and is not burned
498                         // before an ownership that does not have an address and is not burned.
499                         // Hence, curr will not underflow.
500                         //
501                         // We can directly compare the packed value.
502                         // If the address is zero, packed is zero.
503                         while (packed == 0) {
504                             packed = _packedOwnerships[--curr];
505                         }
506                         return packed;
507                     }
508                 }
509         }
510         revert OwnerQueryForNonexistentToken();
511     }
512 
513     /**
514      * Returns the unpacked `TokenOwnership` struct from `packed`.
515      */
516     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
517         ownership.addr = address(uint160(packed));
518         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
519         ownership.burned = packed & BITMASK_BURNED != 0;
520     }
521 
522     /**
523      * Returns the unpacked `TokenOwnership` struct at `index`.
524      */
525     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
526         return _unpackedOwnership(_packedOwnerships[index]);
527     }
528 
529     /**
530      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
531      */
532     function _initializeOwnershipAt(uint256 index) internal {
533         if (_packedOwnerships[index] == 0) {
534             _packedOwnerships[index] = _packedOwnershipOf(index);
535         }
536     }
537 
538     /**
539      * Gas spent here starts off proportional to the maximum mint batch size.
540      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
541      */
542     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
543         return _unpackedOwnership(_packedOwnershipOf(tokenId));
544     }
545 
546     /**
547      * @dev See {IERC721-ownerOf}.
548      */
549     function ownerOf(uint256 tokenId) public view override returns (address) {
550         return address(uint160(_packedOwnershipOf(tokenId)));
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-name}.
555      */
556     function name() public view virtual override returns (string memory) {
557         return _name;
558     }
559 
560     /**
561      * @dev See {IERC721Metadata-symbol}.
562      */
563     function symbol() public view virtual override returns (string memory) {
564         return _symbol;
565     }
566 
567     /**
568      * @dev See {IERC721Metadata-tokenURI}.
569      */
570     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
571         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
572 
573         string memory baseURI = _baseURI();
574         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
575     }
576 
577     /**
578      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
579      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
580      * by default, can be overriden in child contracts.
581      */
582     function _baseURI() internal view virtual returns (string memory) {
583         return '';
584     }
585 
586     /**
587      * @dev Casts the address to uint256 without masking.
588      */
589     function _addressToUint256(address value) private pure returns (uint256 result) {
590         assembly {
591             result := value
592         }
593     }
594 
595     /**
596      * @dev Casts the boolean to uint256 without branching.
597      */
598     function _boolToUint256(bool value) private pure returns (uint256 result) {
599         assembly {
600             result := value
601         }
602     }
603 
604     /**
605      * @dev See {IERC721-approve}.
606      */
607     function approve(address to, uint256 tokenId) public override {
608         address owner = address(uint160(_packedOwnershipOf(tokenId)));
609         if (to == owner) revert ApprovalToCurrentOwner();
610 
611         if (_msgSenderERC721A() != owner)
612             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
613                 revert ApprovalCallerNotOwnerNorApproved();
614             }
615 
616         _tokenApprovals[tokenId] = to;
617         emit Approval(owner, to, tokenId);
618     }
619 
620     /**
621      * @dev See {IERC721-getApproved}.
622      */
623     function getApproved(uint256 tokenId) public view override returns (address) {
624         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
625 
626         return _tokenApprovals[tokenId];
627     }
628 
629     /**
630      * @dev See {IERC721-setApprovalForAll}.
631      */
632     function setApprovalForAll(address operator, bool approved) public virtual override {
633         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
634 
635         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
636         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
637     }
638 
639     /**
640      * @dev See {IERC721-isApprovedForAll}.
641      */
642     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
643         return _operatorApprovals[owner][operator];
644     }
645 
646     /**
647      * @dev See {IERC721-transferFrom}.
648      */
649     function transferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) public virtual override {
654         _transfer(from, to, tokenId);
655     }
656 
657     /**
658      * @dev See {IERC721-safeTransferFrom}.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId
664     ) public virtual override {
665         safeTransferFrom(from, to, tokenId, '');
666     }
667 
668     /**
669      * @dev See {IERC721-safeTransferFrom}.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId,
675         bytes memory _data
676     ) public virtual override {
677         _transfer(from, to, tokenId);
678         if (to.code.length != 0)
679             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
680                 revert TransferToNonERC721ReceiverImplementer();
681             }
682     }
683 
684     /**
685      * @dev Returns whether `tokenId` exists.
686      *
687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
688      *
689      * Tokens start existing when they are minted (`_mint`),
690      */
691     function _exists(uint256 tokenId) internal view returns (bool) {
692         return
693             _startTokenId() <= tokenId &&
694             tokenId < _currentIndex && // If within bounds,
695             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
696     }
697 
698     /**
699      * @dev Equivalent to `_safeMint(to, quantity, '')`.
700      */
701     function _safeMint(address to, uint256 quantity) internal {
702         _safeMint(to, quantity, '');
703     }
704 
705     /**
706      * @dev Safely mints `quantity` tokens and transfers them to `to`.
707      *
708      * Requirements:
709      *
710      * - If `to` refers to a smart contract, it must implement
711      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
712      * - `quantity` must be greater than 0.
713      *
714      * Emits a {Transfer} event.
715      */
716     function _safeMint(
717         address to,
718         uint256 quantity,
719         bytes memory _data
720     ) internal {
721         uint256 startTokenId = _currentIndex;
722         if (to == address(0)) revert MintToZeroAddress();
723         if (quantity == 0) revert MintZeroQuantity();
724 
725         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
726 
727         // Overflows are incredibly unrealistic.
728         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
729         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
730         unchecked {
731             // Updates:
732             // - `balance += quantity`.
733             // - `numberMinted += quantity`.
734             //
735             // We can directly add to the balance and number minted.
736             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
737 
738             // Updates:
739             // - `address` to the owner.
740             // - `startTimestamp` to the timestamp of minting.
741             // - `burned` to `false`.
742             // - `nextInitialized` to `quantity == 1`.
743             _packedOwnerships[startTokenId] =
744                 _addressToUint256(to) |
745                 (block.timestamp << BITPOS_START_TIMESTAMP) |
746                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
747 
748             uint256 updatedIndex = startTokenId;
749             uint256 end = updatedIndex + quantity;
750 
751             if (to.code.length != 0) {
752                 do {
753                     emit Transfer(address(0), to, updatedIndex);
754                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
755                         revert TransferToNonERC721ReceiverImplementer();
756                     }
757                 } while (updatedIndex < end);
758                 // Reentrancy protection
759                 if (_currentIndex != startTokenId) revert();
760             } else {
761                 do {
762                     emit Transfer(address(0), to, updatedIndex++);
763                 } while (updatedIndex < end);
764             }
765             _currentIndex = updatedIndex;
766         }
767         _afterTokenTransfers(address(0), to, startTokenId, quantity);
768     }
769 
770     /**
771      * @dev Mints `quantity` tokens and transfers them to `to`.
772      *
773      * Requirements:
774      *
775      * - `to` cannot be the zero address.
776      * - `quantity` must be greater than 0.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _mint(address to, uint256 quantity) internal {
781         uint256 startTokenId = _currentIndex;
782         if (to == address(0)) revert MintToZeroAddress();
783         if (quantity == 0) revert MintZeroQuantity();
784 
785         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
786 
787         // Overflows are incredibly unrealistic.
788         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
789         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
790         unchecked {
791             // Updates:
792             // - `balance += quantity`.
793             // - `numberMinted += quantity`.
794             //
795             // We can directly add to the balance and number minted.
796             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
797 
798             // Updates:
799             // - `address` to the owner.
800             // - `startTimestamp` to the timestamp of minting.
801             // - `burned` to `false`.
802             // - `nextInitialized` to `quantity == 1`.
803             _packedOwnerships[startTokenId] =
804                 _addressToUint256(to) |
805                 (block.timestamp << BITPOS_START_TIMESTAMP) |
806                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
807 
808             uint256 updatedIndex = startTokenId;
809             uint256 end = updatedIndex + quantity;
810 
811             do {
812                 emit Transfer(address(0), to, updatedIndex++);
813             } while (updatedIndex < end);
814 
815             _currentIndex = updatedIndex;
816         }
817         _afterTokenTransfers(address(0), to, startTokenId, quantity);
818     }
819 
820     /**
821      * @dev Transfers `tokenId` from `from` to `to`.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _transfer(
831         address from,
832         address to,
833         uint256 tokenId
834     ) private {
835         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
836 
837         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
838 
839         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
840             isApprovedForAll(from, _msgSenderERC721A()) ||
841             getApproved(tokenId) == _msgSenderERC721A());
842 
843         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
844         if (to == address(0)) revert TransferToZeroAddress();
845 
846         _beforeTokenTransfers(from, to, tokenId, 1);
847 
848         // Clear approvals from the previous owner.
849         delete _tokenApprovals[tokenId];
850 
851         // Underflow of the sender's balance is impossible because we check for
852         // ownership above and the recipient's balance can't realistically overflow.
853         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
854         unchecked {
855             // We can directly increment and decrement the balances.
856             --_packedAddressData[from]; // Updates: `balance -= 1`.
857             ++_packedAddressData[to]; // Updates: `balance += 1`.
858 
859             // Updates:
860             // - `address` to the next owner.
861             // - `startTimestamp` to the timestamp of transfering.
862             // - `burned` to `false`.
863             // - `nextInitialized` to `true`.
864             _packedOwnerships[tokenId] =
865                 _addressToUint256(to) |
866                 (block.timestamp << BITPOS_START_TIMESTAMP) |
867                 BITMASK_NEXT_INITIALIZED;
868 
869             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
870             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
871                 uint256 nextTokenId = tokenId + 1;
872                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
873                 if (_packedOwnerships[nextTokenId] == 0) {
874                     // If the next slot is within bounds.
875                     if (nextTokenId != _currentIndex) {
876                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
877                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
878                     }
879                 }
880             }
881         }
882 
883         emit Transfer(from, to, tokenId);
884         _afterTokenTransfers(from, to, tokenId, 1);
885     }
886 
887     /**
888      * @dev Equivalent to `_burn(tokenId, false)`.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         _burn(tokenId, false);
892     }
893 
894     /**
895      * @dev Destroys `tokenId`.
896      * The approval is cleared when the token is burned.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
905         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
906 
907         address from = address(uint160(prevOwnershipPacked));
908 
909         if (approvalCheck) {
910             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
911                 isApprovedForAll(from, _msgSenderERC721A()) ||
912                 getApproved(tokenId) == _msgSenderERC721A());
913 
914             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
915         }
916 
917         _beforeTokenTransfers(from, address(0), tokenId, 1);
918 
919         // Clear approvals from the previous owner.
920         delete _tokenApprovals[tokenId];
921 
922         // Underflow of the sender's balance is impossible because we check for
923         // ownership above and the recipient's balance can't realistically overflow.
924         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
925         unchecked {
926             // Updates:
927             // - `balance -= 1`.
928             // - `numberBurned += 1`.
929             //
930             // We can directly decrement the balance, and increment the number burned.
931             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
932             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
933 
934             // Updates:
935             // - `address` to the last owner.
936             // - `startTimestamp` to the timestamp of burning.
937             // - `burned` to `true`.
938             // - `nextInitialized` to `true`.
939             _packedOwnerships[tokenId] =
940                 _addressToUint256(from) |
941                 (block.timestamp << BITPOS_START_TIMESTAMP) |
942                 BITMASK_BURNED | 
943                 BITMASK_NEXT_INITIALIZED;
944 
945             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
946             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
947                 uint256 nextTokenId = tokenId + 1;
948                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
949                 if (_packedOwnerships[nextTokenId] == 0) {
950                     // If the next slot is within bounds.
951                     if (nextTokenId != _currentIndex) {
952                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
953                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
954                     }
955                 }
956             }
957         }
958 
959         emit Transfer(from, address(0), tokenId);
960         _afterTokenTransfers(from, address(0), tokenId, 1);
961 
962         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
963         unchecked {
964             _burnCounter++;
965         }
966     }
967 
968     /**
969      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
970      *
971      * @param from address representing the previous owner of the given token ID
972      * @param to target address that will receive the tokens
973      * @param tokenId uint256 ID of the token to be transferred
974      * @param _data bytes optional data to send along with the call
975      * @return bool whether the call correctly returned the expected magic value
976      */
977     function _checkContractOnERC721Received(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) private returns (bool) {
983         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
984             bytes4 retval
985         ) {
986             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
987         } catch (bytes memory reason) {
988             if (reason.length == 0) {
989                 revert TransferToNonERC721ReceiverImplementer();
990             } else {
991                 assembly {
992                     revert(add(32, reason), mload(reason))
993                 }
994             }
995         }
996     }
997 
998     /**
999      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1000      * And also called before burning one token.
1001      *
1002      * startTokenId - the first token id to be transferred
1003      * quantity - the amount to be transferred
1004      *
1005      * Calling conditions:
1006      *
1007      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1008      * transferred to `to`.
1009      * - When `from` is zero, `tokenId` will be minted for `to`.
1010      * - When `to` is zero, `tokenId` will be burned by `from`.
1011      * - `from` and `to` are never both zero.
1012      */
1013     function _beforeTokenTransfers(
1014         address from,
1015         address to,
1016         uint256 startTokenId,
1017         uint256 quantity
1018     ) internal virtual {}
1019 
1020     /**
1021      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1022      * minting.
1023      * And also called after one token has been burned.
1024      *
1025      * startTokenId - the first token id to be transferred
1026      * quantity - the amount to be transferred
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` has been minted for `to`.
1033      * - When `to` is zero, `tokenId` has been burned by `from`.
1034      * - `from` and `to` are never both zero.
1035      */
1036     function _afterTokenTransfers(
1037         address from,
1038         address to,
1039         uint256 startTokenId,
1040         uint256 quantity
1041     ) internal virtual {}
1042 
1043     /**
1044      * @dev Returns the message sender (defaults to `msg.sender`).
1045      *
1046      * If you are writing GSN compatible contracts, you need to override this function.
1047      */
1048     function _msgSenderERC721A() internal view virtual returns (address) {
1049         return msg.sender;
1050     }
1051 
1052     /**
1053      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1054      */
1055     function _toString(uint256 value) internal pure returns (string memory ptr) {
1056         assembly {
1057             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1058             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1059             // We will need 1 32-byte word to store the length, 
1060             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1061             ptr := add(mload(0x40), 128)
1062             // Update the free memory pointer to allocate.
1063             mstore(0x40, ptr)
1064 
1065             // Cache the end of the memory to calculate the length later.
1066             let end := ptr
1067 
1068             // We write the string from the rightmost digit to the leftmost digit.
1069             // The following is essentially a do-while loop that also handles the zero case.
1070             // Costs a bit more than early returning for the zero case,
1071             // but cheaper in terms of deployment and overall runtime costs.
1072             for { 
1073                 // Initialize and perform the first pass without check.
1074                 let temp := value
1075                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1076                 ptr := sub(ptr, 1)
1077                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1078                 mstore8(ptr, add(48, mod(temp, 10)))
1079                 temp := div(temp, 10)
1080             } temp { 
1081                 // Keep dividing `temp` until zero.
1082                 temp := div(temp, 10)
1083             } { // Body of the for loop.
1084                 ptr := sub(ptr, 1)
1085                 mstore8(ptr, add(48, mod(temp, 10)))
1086             }
1087             
1088             let length := sub(end, ptr)
1089             // Move the pointer 32 bytes leftwards to make room for the length.
1090             ptr := sub(ptr, 32)
1091             // Store the length.
1092             mstore(ptr, length)
1093         }
1094     }
1095 }
1096 
1097 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1098 
1099 
1100 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 /**
1105  * @dev String operations.
1106  */
1107 library Strings {
1108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1109     uint8 private constant _ADDRESS_LENGTH = 20;
1110 
1111     /**
1112      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1113      */
1114     function toString(uint256 value) internal pure returns (string memory) {
1115         // Inspired by OraclizeAPI's implementation - MIT licence
1116         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1117 
1118         if (value == 0) {
1119             return "0";
1120         }
1121         uint256 temp = value;
1122         uint256 digits;
1123         while (temp != 0) {
1124             digits++;
1125             temp /= 10;
1126         }
1127         bytes memory buffer = new bytes(digits);
1128         while (value != 0) {
1129             digits -= 1;
1130             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1131             value /= 10;
1132         }
1133         return string(buffer);
1134     }
1135 
1136     /**
1137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1138      */
1139     function toHexString(uint256 value) internal pure returns (string memory) {
1140         if (value == 0) {
1141             return "0x00";
1142         }
1143         uint256 temp = value;
1144         uint256 length = 0;
1145         while (temp != 0) {
1146             length++;
1147             temp >>= 8;
1148         }
1149         return toHexString(value, length);
1150     }
1151 
1152     /**
1153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1154      */
1155     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1156         bytes memory buffer = new bytes(2 * length + 2);
1157         buffer[0] = "0";
1158         buffer[1] = "x";
1159         for (uint256 i = 2 * length + 1; i > 1; --i) {
1160             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1161             value >>= 4;
1162         }
1163         require(value == 0, "Strings: hex length insufficient");
1164         return string(buffer);
1165     }
1166 
1167     /**
1168      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1169      */
1170     function toHexString(address addr) internal pure returns (string memory) {
1171         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1172     }
1173 }
1174 
1175 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1176 
1177 
1178 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev Provides information about the current execution context, including the
1184  * sender of the transaction and its data. While these are generally available
1185  * via msg.sender and msg.data, they should not be accessed in such a direct
1186  * manner, since when dealing with meta-transactions the account sending and
1187  * paying for execution may not be the actual sender (as far as an application
1188  * is concerned).
1189  *
1190  * This contract is only required for intermediate, library-like contracts.
1191  */
1192 abstract contract Context {
1193     function _msgSender() internal view virtual returns (address) {
1194         return msg.sender;
1195     }
1196 
1197     function _msgData() internal view virtual returns (bytes calldata) {
1198         return msg.data;
1199     }
1200 }
1201 
1202 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1203 
1204 
1205 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 
1210 /**
1211  * @dev Contract module which provides a basic access control mechanism, where
1212  * there is an account (an owner) that can be granted exclusive access to
1213  * specific functions.
1214  *
1215  * By default, the owner account will be the one that deploys the contract. This
1216  * can later be changed with {transferOwnership}.
1217  *
1218  * This module is used through inheritance. It will make available the modifier
1219  * `onlyOwner`, which can be applied to your functions to restrict their use to
1220  * the owner.
1221  */
1222 abstract contract Ownable is Context {
1223     address private _owner;
1224 
1225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _transferOwnership(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _transferOwnership(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(newOwner != address(0), "Ownable: new owner is the zero address");
1266         _transferOwnership(newOwner);
1267     }
1268 
1269     /**
1270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1271      * Internal function without access restriction.
1272      */
1273     function _transferOwnership(address newOwner) internal virtual {
1274         address oldOwner = _owner;
1275         _owner = newOwner;
1276         emit OwnershipTransferred(oldOwner, newOwner);
1277     }
1278 }
1279 
1280 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1281 
1282 
1283 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1284 
1285 pragma solidity ^0.8.1;
1286 
1287 /**
1288  * @dev Collection of functions related to the address type
1289  */
1290 library Address {
1291     /**
1292      * @dev Returns true if `account` is a contract.
1293      *
1294      * [IMPORTANT]
1295      * ====
1296      * It is unsafe to assume that an address for which this function returns
1297      * false is an externally-owned account (EOA) and not a contract.
1298      *
1299      * Among others, `isContract` will return false for the following
1300      * types of addresses:
1301      *
1302      *  - an externally-owned account
1303      *  - a contract in construction
1304      *  - an address where a contract will be created
1305      *  - an address where a contract lived, but was destroyed
1306      * ====
1307      *
1308      * [IMPORTANT]
1309      * ====
1310      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1311      *
1312      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1313      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1314      * constructor.
1315      * ====
1316      */
1317     function isContract(address account) internal view returns (bool) {
1318         // This method relies on extcodesize/address.code.length, which returns 0
1319         // for contracts in construction, since the code is only stored at the end
1320         // of the constructor execution.
1321 
1322         return account.code.length > 0;
1323     }
1324 
1325     /**
1326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1327      * `recipient`, forwarding all available gas and reverting on errors.
1328      *
1329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1331      * imposed by `transfer`, making them unable to receive funds via
1332      * `transfer`. {sendValue} removes this limitation.
1333      *
1334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1335      *
1336      * IMPORTANT: because control is transferred to `recipient`, care must be
1337      * taken to not create reentrancy vulnerabilities. Consider using
1338      * {ReentrancyGuard} or the
1339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1340      */
1341     function sendValue(address payable recipient, uint256 amount) internal {
1342         require(address(this).balance >= amount, "Address: insufficient balance");
1343 
1344         (bool success, ) = recipient.call{value: amount}("");
1345         require(success, "Address: unable to send value, recipient may have reverted");
1346     }
1347 
1348     /**
1349      * @dev Performs a Solidity function call using a low level `call`. A
1350      * plain `call` is an unsafe replacement for a function call: use this
1351      * function instead.
1352      *
1353      * If `target` reverts with a revert reason, it is bubbled up by this
1354      * function (like regular Solidity function calls).
1355      *
1356      * Returns the raw returned data. To convert to the expected return value,
1357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1358      *
1359      * Requirements:
1360      *
1361      * - `target` must be a contract.
1362      * - calling `target` with `data` must not revert.
1363      *
1364      * _Available since v3.1._
1365      */
1366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1367         return functionCall(target, data, "Address: low-level call failed");
1368     }
1369 
1370     /**
1371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1372      * `errorMessage` as a fallback revert reason when `target` reverts.
1373      *
1374      * _Available since v3.1._
1375      */
1376     function functionCall(
1377         address target,
1378         bytes memory data,
1379         string memory errorMessage
1380     ) internal returns (bytes memory) {
1381         return functionCallWithValue(target, data, 0, errorMessage);
1382     }
1383 
1384     /**
1385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1386      * but also transferring `value` wei to `target`.
1387      *
1388      * Requirements:
1389      *
1390      * - the calling contract must have an ETH balance of at least `value`.
1391      * - the called Solidity function must be `payable`.
1392      *
1393      * _Available since v3.1._
1394      */
1395     function functionCallWithValue(
1396         address target,
1397         bytes memory data,
1398         uint256 value
1399     ) internal returns (bytes memory) {
1400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1401     }
1402 
1403     /**
1404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1405      * with `errorMessage` as a fallback revert reason when `target` reverts.
1406      *
1407      * _Available since v3.1._
1408      */
1409     function functionCallWithValue(
1410         address target,
1411         bytes memory data,
1412         uint256 value,
1413         string memory errorMessage
1414     ) internal returns (bytes memory) {
1415         require(address(this).balance >= value, "Address: insufficient balance for call");
1416         require(isContract(target), "Address: call to non-contract");
1417 
1418         (bool success, bytes memory returndata) = target.call{value: value}(data);
1419         return verifyCallResult(success, returndata, errorMessage);
1420     }
1421 
1422     /**
1423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1424      * but performing a static call.
1425      *
1426      * _Available since v3.3._
1427      */
1428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1429         return functionStaticCall(target, data, "Address: low-level static call failed");
1430     }
1431 
1432     /**
1433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1434      * but performing a static call.
1435      *
1436      * _Available since v3.3._
1437      */
1438     function functionStaticCall(
1439         address target,
1440         bytes memory data,
1441         string memory errorMessage
1442     ) internal view returns (bytes memory) {
1443         require(isContract(target), "Address: static call to non-contract");
1444 
1445         (bool success, bytes memory returndata) = target.staticcall(data);
1446         return verifyCallResult(success, returndata, errorMessage);
1447     }
1448 
1449     /**
1450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1451      * but performing a delegate call.
1452      *
1453      * _Available since v3.4._
1454      */
1455     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1456         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1457     }
1458 
1459     /**
1460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1461      * but performing a delegate call.
1462      *
1463      * _Available since v3.4._
1464      */
1465     function functionDelegateCall(
1466         address target,
1467         bytes memory data,
1468         string memory errorMessage
1469     ) internal returns (bytes memory) {
1470         require(isContract(target), "Address: delegate call to non-contract");
1471 
1472         (bool success, bytes memory returndata) = target.delegatecall(data);
1473         return verifyCallResult(success, returndata, errorMessage);
1474     }
1475 
1476     /**
1477      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1478      * revert reason using the provided one.
1479      *
1480      * _Available since v4.3._
1481      */
1482     function verifyCallResult(
1483         bool success,
1484         bytes memory returndata,
1485         string memory errorMessage
1486     ) internal pure returns (bytes memory) {
1487         if (success) {
1488             return returndata;
1489         } else {
1490             // Look for revert reason and bubble it up if present
1491             if (returndata.length > 0) {
1492                 // The easiest way to bubble the revert reason is using memory via assembly
1493 
1494                 assembly {
1495                     let returndata_size := mload(returndata)
1496                     revert(add(32, returndata), returndata_size)
1497                 }
1498             } else {
1499                 revert(errorMessage);
1500             }
1501         }
1502     }
1503 }
1504 
1505 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1506 
1507 
1508 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1509 
1510 pragma solidity ^0.8.0;
1511 
1512 /**
1513  * @title ERC721 token receiver interface
1514  * @dev Interface for any contract that wants to support safeTransfers
1515  * from ERC721 asset contracts.
1516  */
1517 interface IERC721Receiver {
1518     /**
1519      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1520      * by `operator` from `from`, this function is called.
1521      *
1522      * It must return its Solidity selector to confirm the token transfer.
1523      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1524      *
1525      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1526      */
1527     function onERC721Received(
1528         address operator,
1529         address from,
1530         uint256 tokenId,
1531         bytes calldata data
1532     ) external returns (bytes4);
1533 }
1534 
1535 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1536 
1537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1538 
1539 pragma solidity ^0.8.0;
1540 
1541 /**
1542  * @dev Interface of the ERC165 standard, as defined in the
1543  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1544  *
1545  * Implementers can declare support of contract interfaces, which can then be
1546  * queried by others ({ERC165Checker}).
1547  *
1548  * For an implementation, see {ERC165}.
1549  */
1550 interface IERC165 {
1551     /**
1552      * @dev Returns true if this contract implements the interface defined by
1553      * `interfaceId`. See the corresponding
1554      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1555      * to learn more about how these ids are created.
1556      *
1557      * This function call must use less than 30 000 gas.
1558      */
1559     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1560 }
1561 
1562 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1563 
1564 
1565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 
1570 /**
1571  * @dev Implementation of the {IERC165} interface.
1572  *
1573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1574  * for the additional interface id that will be supported. For example:
1575  *
1576  * ```solidity
1577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1579  * }
1580  * ```
1581  *
1582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1583  */
1584 abstract contract ERC165 is IERC165 {
1585     /**
1586      * @dev See {IERC165-supportsInterface}.
1587      */
1588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1589         return interfaceId == type(IERC165).interfaceId;
1590     }
1591 }
1592 
1593 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1594 
1595 
1596 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 
1601 /**
1602  * @dev Required interface of an ERC721 compliant contract.
1603  */
1604 interface IERC721 is IERC165 {
1605     /**
1606      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1607      */
1608     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1609 
1610     /**
1611      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1612      */
1613     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1614 
1615     /**
1616      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1617      */
1618     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1619 
1620     /**
1621      * @dev Returns the number of tokens in ``owner``'s account.
1622      */
1623     function balanceOf(address owner) external view returns (uint256 balance);
1624 
1625     /**
1626      * @dev Returns the owner of the `tokenId` token.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      */
1632     function ownerOf(uint256 tokenId) external view returns (address owner);
1633 
1634     /**
1635      * @dev Safely transfers `tokenId` token from `from` to `to`.
1636      *
1637      * Requirements:
1638      *
1639      * - `from` cannot be the zero address.
1640      * - `to` cannot be the zero address.
1641      * - `tokenId` token must exist and be owned by `from`.
1642      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function safeTransferFrom(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes calldata data
1652     ) external;
1653 
1654     /**
1655      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1656      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1657      *
1658      * Requirements:
1659      *
1660      * - `from` cannot be the zero address.
1661      * - `to` cannot be the zero address.
1662      * - `tokenId` token must exist and be owned by `from`.
1663      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1665      *
1666      * Emits a {Transfer} event.
1667      */
1668     function safeTransferFrom(
1669         address from,
1670         address to,
1671         uint256 tokenId
1672     ) external;
1673 
1674     /**
1675      * @dev Transfers `tokenId` token from `from` to `to`.
1676      *
1677      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1678      *
1679      * Requirements:
1680      *
1681      * - `from` cannot be the zero address.
1682      * - `to` cannot be the zero address.
1683      * - `tokenId` token must be owned by `from`.
1684      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1685      *
1686      * Emits a {Transfer} event.
1687      */
1688     function transferFrom(
1689         address from,
1690         address to,
1691         uint256 tokenId
1692     ) external;
1693 
1694     /**
1695      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1696      * The approval is cleared when the token is transferred.
1697      *
1698      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1699      *
1700      * Requirements:
1701      *
1702      * - The caller must own the token or be an approved operator.
1703      * - `tokenId` must exist.
1704      *
1705      * Emits an {Approval} event.
1706      */
1707     function approve(address to, uint256 tokenId) external;
1708 
1709     /**
1710      * @dev Approve or remove `operator` as an operator for the caller.
1711      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1712      *
1713      * Requirements:
1714      *
1715      * - The `operator` cannot be the caller.
1716      *
1717      * Emits an {ApprovalForAll} event.
1718      */
1719     function setApprovalForAll(address operator, bool _approved) external;
1720 
1721     /**
1722      * @dev Returns the account approved for `tokenId` token.
1723      *
1724      * Requirements:
1725      *
1726      * - `tokenId` must exist.
1727      */
1728     function getApproved(uint256 tokenId) external view returns (address operator);
1729 
1730     /**
1731      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1732      *
1733      * See {setApprovalForAll}
1734      */
1735     function isApprovedForAll(address owner, address operator) external view returns (bool);
1736 }
1737 
1738 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1739 
1740 
1741 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1742 
1743 pragma solidity ^0.8.0;
1744 
1745 
1746 /**
1747  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1748  * @dev See https://eips.ethereum.org/EIPS/eip-721
1749  */
1750 interface IERC721Metadata is IERC721 {
1751     /**
1752      * @dev Returns the token collection name.
1753      */
1754     function name() external view returns (string memory);
1755 
1756     /**
1757      * @dev Returns the token collection symbol.
1758      */
1759     function symbol() external view returns (string memory);
1760 
1761     /**
1762      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1763      */
1764     function tokenURI(uint256 tokenId) external view returns (string memory);
1765 }
1766 
1767 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1768 
1769 
1770 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1771 
1772 pragma solidity ^0.8.0;
1773 
1774 /**
1775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1776  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1777  * {ERC721Enumerable}.
1778  */
1779 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1780     using Address for address;
1781     using Strings for uint256;
1782 
1783     // Token name
1784     string private _name;
1785 
1786     // Token symbol
1787     string private _symbol;
1788 
1789     // Mapping from token ID to owner address
1790     mapping(uint256 => address) private _owners;
1791 
1792     // Mapping owner address to token count
1793     mapping(address => uint256) private _balances;
1794 
1795     // Mapping from token ID to approved address
1796     mapping(uint256 => address) private _tokenApprovals;
1797 
1798     // Mapping from owner to operator approvals
1799     mapping(address => mapping(address => bool)) private _operatorApprovals;
1800 
1801     /**
1802      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1803      */
1804     constructor(string memory name_, string memory symbol_) {
1805         _name = name_;
1806         _symbol = symbol_;
1807     }
1808 
1809     /**
1810      * @dev See {IERC165-supportsInterface}.
1811      */
1812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1813         return
1814             interfaceId == type(IERC721).interfaceId ||
1815             interfaceId == type(IERC721Metadata).interfaceId ||
1816             super.supportsInterface(interfaceId);
1817     }
1818 
1819     /**
1820      * @dev See {IERC721-balanceOf}.
1821      */
1822     function balanceOf(address owner) public view virtual override returns (uint256) {
1823         require(owner != address(0), "ERC721: address zero is not a valid owner");
1824         return _balances[owner];
1825     }
1826 
1827     /**
1828      * @dev See {IERC721-ownerOf}.
1829      */
1830     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1831         address owner = _owners[tokenId];
1832         require(owner != address(0), "ERC721: owner query for nonexistent token");
1833         return owner;
1834     }
1835 
1836     /**
1837      * @dev See {IERC721Metadata-name}.
1838      */
1839     function name() public view virtual override returns (string memory) {
1840         return _name;
1841     }
1842 
1843     /**
1844      * @dev See {IERC721Metadata-symbol}.
1845      */
1846     function symbol() public view virtual override returns (string memory) {
1847         return _symbol;
1848     }
1849 
1850     /**
1851      * @dev See {IERC721Metadata-tokenURI}.
1852      */
1853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1854         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1855 
1856         string memory baseURI = _baseURI();
1857         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1858     }
1859 
1860     /**
1861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1863      * by default, can be overridden in child contracts.
1864      */
1865     function _baseURI() internal view virtual returns (string memory) {
1866         return "";
1867     }
1868 
1869     /**
1870      * @dev See {IERC721-approve}.
1871      */
1872     function approve(address to, uint256 tokenId) public virtual override {
1873         address owner = ERC721.ownerOf(tokenId);
1874         require(to != owner, "ERC721: approval to current owner");
1875 
1876         require(
1877             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1878             "ERC721: approve caller is not owner nor approved for all"
1879         );
1880 
1881         _approve(to, tokenId);
1882     }
1883 
1884     /**
1885      * @dev See {IERC721-getApproved}.
1886      */
1887     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1888         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1889 
1890         return _tokenApprovals[tokenId];
1891     }
1892 
1893     /**
1894      * @dev See {IERC721-setApprovalForAll}.
1895      */
1896     function setApprovalForAll(address operator, bool approved) public virtual override {
1897         _setApprovalForAll(_msgSender(), operator, approved);
1898     }
1899 
1900     /**
1901      * @dev See {IERC721-isApprovedForAll}.
1902      */
1903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1904         return _operatorApprovals[owner][operator];
1905     }
1906 
1907     /**
1908      * @dev See {IERC721-transferFrom}.
1909      */
1910     function transferFrom(
1911         address from,
1912         address to,
1913         uint256 tokenId
1914     ) public virtual override {
1915         //solhint-disable-next-line max-line-length
1916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1917 
1918         _transfer(from, to, tokenId);
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-safeTransferFrom}.
1923      */
1924     function safeTransferFrom(
1925         address from,
1926         address to,
1927         uint256 tokenId
1928     ) public virtual override {
1929         safeTransferFrom(from, to, tokenId, "");
1930     }
1931 
1932     /**
1933      * @dev See {IERC721-safeTransferFrom}.
1934      */
1935     function safeTransferFrom(
1936         address from,
1937         address to,
1938         uint256 tokenId,
1939         bytes memory data
1940     ) public virtual override {
1941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1942         _safeTransfer(from, to, tokenId, data);
1943     }
1944 
1945     /**
1946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1948      *
1949      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1950      *
1951      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1952      * implement alternative mechanisms to perform token transfer, such as signature-based.
1953      *
1954      * Requirements:
1955      *
1956      * - `from` cannot be the zero address.
1957      * - `to` cannot be the zero address.
1958      * - `tokenId` token must exist and be owned by `from`.
1959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _safeTransfer(
1964         address from,
1965         address to,
1966         uint256 tokenId,
1967         bytes memory data
1968     ) internal virtual {
1969         _transfer(from, to, tokenId);
1970         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1971     }
1972 
1973     /**
1974      * @dev Returns whether `tokenId` exists.
1975      *
1976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1977      *
1978      * Tokens start existing when they are minted (`_mint`),
1979      * and stop existing when they are burned (`_burn`).
1980      */
1981     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1982         return _owners[tokenId] != address(0);
1983     }
1984 
1985     /**
1986      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1987      *
1988      * Requirements:
1989      *
1990      * - `tokenId` must exist.
1991      */
1992     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1993         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1994         address owner = ERC721.ownerOf(tokenId);
1995         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1996     }
1997 
1998     /**
1999      * @dev Safely mints `tokenId` and transfers it to `to`.
2000      *
2001      * Requirements:
2002      *
2003      * - `tokenId` must not exist.
2004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2005      *
2006      * Emits a {Transfer} event.
2007      */
2008     function _safeMint(address to, uint256 tokenId) internal virtual {
2009         _safeMint(to, tokenId, "");
2010     }
2011 
2012     /**
2013      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2014      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2015      */
2016     function _safeMint(
2017         address to,
2018         uint256 tokenId,
2019         bytes memory data
2020     ) internal virtual {
2021         _mint(to, tokenId);
2022         require(
2023             _checkOnERC721Received(address(0), to, tokenId, data),
2024             "ERC721: transfer to non ERC721Receiver implementer"
2025         );
2026     }
2027 
2028     /**
2029      * @dev Mints `tokenId` and transfers it to `to`.
2030      *
2031      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2032      *
2033      * Requirements:
2034      *
2035      * - `tokenId` must not exist.
2036      * - `to` cannot be the zero address.
2037      *
2038      * Emits a {Transfer} event.
2039      */
2040     function _mint(address to, uint256 tokenId) internal virtual {
2041         require(to != address(0), "ERC721: mint to the zero address");
2042         require(!_exists(tokenId), "ERC721: token already minted");
2043 
2044         _beforeTokenTransfer(address(0), to, tokenId);
2045 
2046         _balances[to] += 1;
2047         _owners[tokenId] = to;
2048 
2049         emit Transfer(address(0), to, tokenId);
2050 
2051         _afterTokenTransfer(address(0), to, tokenId);
2052     }
2053 
2054     /**
2055      * @dev Destroys `tokenId`.
2056      * The approval is cleared when the token is burned.
2057      *
2058      * Requirements:
2059      *
2060      * - `tokenId` must exist.
2061      *
2062      * Emits a {Transfer} event.
2063      */
2064     function _burn(uint256 tokenId) internal virtual {
2065         address owner = ERC721.ownerOf(tokenId);
2066 
2067         _beforeTokenTransfer(owner, address(0), tokenId);
2068 
2069         // Clear approvals
2070         _approve(address(0), tokenId);
2071 
2072         _balances[owner] -= 1;
2073         delete _owners[tokenId];
2074 
2075         emit Transfer(owner, address(0), tokenId);
2076 
2077         _afterTokenTransfer(owner, address(0), tokenId);
2078     }
2079 
2080     /**
2081      * @dev Transfers `tokenId` from `from` to `to`.
2082      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2083      *
2084      * Requirements:
2085      *
2086      * - `to` cannot be the zero address.
2087      * - `tokenId` token must be owned by `from`.
2088      *
2089      * Emits a {Transfer} event.
2090      */
2091     function _transfer(
2092         address from,
2093         address to,
2094         uint256 tokenId
2095     ) internal virtual {
2096         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2097         require(to != address(0), "ERC721: transfer to the zero address");
2098 
2099         _beforeTokenTransfer(from, to, tokenId);
2100 
2101         // Clear approvals from the previous owner
2102         _approve(address(0), tokenId);
2103 
2104         _balances[from] -= 1;
2105         _balances[to] += 1;
2106         _owners[tokenId] = to;
2107 
2108         emit Transfer(from, to, tokenId);
2109 
2110         _afterTokenTransfer(from, to, tokenId);
2111     }
2112 
2113     /**
2114      * @dev Approve `to` to operate on `tokenId`
2115      *
2116      * Emits an {Approval} event.
2117      */
2118     function _approve(address to, uint256 tokenId) internal virtual {
2119         _tokenApprovals[tokenId] = to;
2120         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2121     }
2122 
2123     /**
2124      * @dev Approve `operator` to operate on all of `owner` tokens
2125      *
2126      * Emits an {ApprovalForAll} event.
2127      */
2128     function _setApprovalForAll(
2129         address owner,
2130         address operator,
2131         bool approved
2132     ) internal virtual {
2133         require(owner != operator, "ERC721: approve to caller");
2134         _operatorApprovals[owner][operator] = approved;
2135         emit ApprovalForAll(owner, operator, approved);
2136     }
2137 
2138     /**
2139      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2140      * The call is not executed if the target address is not a contract.
2141      *
2142      * @param from address representing the previous owner of the given token ID
2143      * @param to target address that will receive the tokens
2144      * @param tokenId uint256 ID of the token to be transferred
2145      * @param data bytes optional data to send along with the call
2146      * @return bool whether the call correctly returned the expected magic value
2147      */
2148     function _checkOnERC721Received(
2149         address from,
2150         address to,
2151         uint256 tokenId,
2152         bytes memory data
2153     ) private returns (bool) {
2154         if (to.isContract()) {
2155             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2156                 return retval == IERC721Receiver.onERC721Received.selector;
2157             } catch (bytes memory reason) {
2158                 if (reason.length == 0) {
2159                     revert("ERC721: transfer to non ERC721Receiver implementer");
2160                 } else {
2161                     assembly {
2162                         revert(add(32, reason), mload(reason))
2163                     }
2164                 }
2165             }
2166         } else {
2167             return true;
2168         }
2169     }
2170 
2171     /**
2172      * @dev Hook that is called before any token transfer. This includes minting
2173      * and burning.
2174      *
2175      * Calling conditions:
2176      *
2177      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2178      * transferred to `to`.
2179      * - When `from` is zero, `tokenId` will be minted for `to`.
2180      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2181      * - `from` and `to` are never both zero.
2182      *
2183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2184      */
2185     function _beforeTokenTransfer(
2186         address from,
2187         address to,
2188         uint256 tokenId
2189     ) internal virtual {}
2190 
2191     /**
2192      * @dev Hook that is called after any transfer of tokens. This includes
2193      * minting and burning.
2194      *
2195      * Calling conditions:
2196      *
2197      * - when `from` and `to` are both non-zero.
2198      * - `from` and `to` are never both zero.
2199      *
2200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2201      */
2202     function _afterTokenTransfer(
2203         address from,
2204         address to,
2205         uint256 tokenId
2206     ) internal virtual {}
2207 }
2208 
2209 
2210 pragma solidity ^0.8.7;
2211 
2212 
2213 contract HOTD is ERC721A, Ownable {
2214 
2215     using Strings for uint256;
2216 
2217     string private baseURI ;
2218 
2219     uint256 public price = 0.002 ether;
2220 
2221     uint256 public maxPerTx = 50;
2222 
2223     uint256 public maxFreePerWallet = 1;
2224 
2225     uint256 public totalFree = 3000;
2226 
2227     uint256 public maxSupply = 5000;
2228 
2229     bool public mintEnabled = true;
2230     
2231     uint   public totalFreeMinted = 0;
2232 
2233     mapping(address => uint256) private _mintedFreeAmount;
2234 
2235     constructor() ERC721A("House OF The Dead", "HOTD") {}
2236 
2237    function mint(uint256 count) external payable {
2238         uint256 cost = price;
2239         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
2240             (_mintedFreeAmount[msg.sender] < maxFreePerWallet));
2241 
2242         if (isFree) { 
2243             require(mintEnabled, "Mint is not live yet");
2244             require(totalSupply() + count <= maxSupply, "No more");
2245             require(count <= maxPerTx, "Max per TX reached.");
2246             if(count >= (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
2247             {
2248              require(msg.value >= (count * cost) - ((maxFreePerWallet - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
2249              _mintedFreeAmount[msg.sender] = maxFreePerWallet;
2250              totalFreeMinted += maxFreePerWallet;
2251             }
2252             else if(count < (maxFreePerWallet - _mintedFreeAmount[msg.sender]))
2253             {
2254              require(msg.value >= 0, "Please send the exact ETH amount");
2255              _mintedFreeAmount[msg.sender] += count;
2256              totalFreeMinted += count;
2257             }
2258         }
2259         else{
2260         require(mintEnabled, "Mint is not live yet");
2261         require(msg.value >= count * cost, "Please send the exact ETH amount");
2262         require(totalSupply() + count <= maxSupply, "Sold out");
2263         require(count <= maxPerTx, "Max per TX reached.");
2264         }
2265 
2266         _safeMint(msg.sender, count);
2267     }
2268 
2269     function tokenURI(uint256 tokenId)
2270         public view virtual override returns (string memory) {
2271         require(
2272             _exists(tokenId),
2273             "ERC721Metadata: URI query for nonexistent token"
2274         );
2275         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2276     }
2277 
2278     function setBaseURI(string memory uri) public onlyOwner {
2279         baseURI = uri;
2280     }
2281 
2282     function setFreeAmount(uint256 amount) external onlyOwner {
2283         totalFree = amount;
2284     }
2285 
2286     function setPrice(uint256 _newPrice) external onlyOwner {
2287         price = _newPrice;
2288     }
2289 
2290     function toggleMint() external onlyOwner {
2291         mintEnabled = !mintEnabled;
2292     }
2293 
2294     function withdraw() external onlyOwner {
2295         (bool success, ) = payable(msg.sender).call{
2296             value: address(this).balance
2297         }("");
2298         require(success, "Transfer failed.");
2299     }
2300     
2301 
2302 }