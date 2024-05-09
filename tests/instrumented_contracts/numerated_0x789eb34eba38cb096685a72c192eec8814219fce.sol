1 // File: contracts/3_Ballot.sol
2 
3 // ERC721A Contracts v3.3.0
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev Interface of an ERC721A compliant contract.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * The caller cannot approve to their own address.
23      */
24     error ApproveToCaller();
25 
26     /**
27      * The caller cannot approve to the current owner.
28      */
29     error ApprovalToCurrentOwner();
30 
31     /**
32      * Cannot query the balance for the zero address.
33      */
34     error BalanceQueryForZeroAddress();
35 
36     /**
37      * Cannot mint to the zero address.
38      */
39     error MintToZeroAddress();
40 
41     /**
42      * The quantity of tokens minted must be more than zero.
43      */
44     error MintZeroQuantity();
45 
46     /**
47      * The token does not exist.
48      */
49     error OwnerQueryForNonexistentToken();
50 
51     /**
52      * The caller must own the token or be an approved operator.
53      */
54     error TransferCallerNotOwnerNorApproved();
55 
56     /**
57      * The token must be owned by `from`.
58      */
59     error TransferFromIncorrectOwner();
60 
61     /**
62      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
63      */
64     error TransferToNonERC721ReceiverImplementer();
65 
66     /**
67      * Cannot transfer to the zero address.
68      */
69     error TransferToZeroAddress();
70 
71     /**
72      * The token does not exist.
73      */
74     error URIQueryForNonexistentToken();
75 
76     struct TokenOwnership {
77         // The address of the owner.
78         address addr;
79         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
80         uint64 startTimestamp;
81         // Whether the token has been burned.
82         bool burned;
83     }
84 
85     /**
86      * @dev Returns the total amount of tokens stored by the contract.
87      *
88      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
89      */
90     function totalSupply() external view returns (uint256);
91 
92     // ==============================
93     //            IERC165
94     // ==============================
95 
96     /**
97      * @dev Returns true if this contract implements the interface defined by
98      * `interfaceId`. See the corresponding
99      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
100      * to learn more about how these ids are created.
101      *
102      * This function call must use less than 30 000 gas.
103      */
104     function supportsInterface(bytes4 interfaceId) external view returns (bool);
105 
106     // ==============================
107     //            IERC721
108     // ==============================
109 
110     /**
111      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
114 
115     /**
116      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
117      */
118     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
119 
120     /**
121      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
122      */
123     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
124 
125     /**
126      * @dev Returns the number of tokens in ``owner``'s account.
127      */
128     function balanceOf(address owner) external view returns (uint256 balance);
129 
130     /**
131      * @dev Returns the owner of the `tokenId` token.
132      *
133      * Requirements:
134      *
135      * - `tokenId` must exist.
136      */
137     function ownerOf(uint256 tokenId) external view returns (address owner);
138 
139     /**
140      * @dev Safely transfers `tokenId` token from `from` to `to`.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must exist and be owned by `from`.
147      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
148      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
149      *
150      * Emits a {Transfer} event.
151      */
152     function safeTransferFrom(
153         address from,
154         address to,
155         uint256 tokenId,
156         bytes calldata data
157     ) external;
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
161      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId
177     ) external;
178 
179     /**
180      * @dev Transfers `tokenId` token from `from` to `to`.
181      *
182      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
201      * The approval is cleared when the token is transferred.
202      *
203      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
204      *
205      * Requirements:
206      *
207      * - The caller must own the token or be an approved operator.
208      * - `tokenId` must exist.
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address to, uint256 tokenId) external;
213 
214     /**
215      * @dev Approve or remove `operator` as an operator for the caller.
216      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
217      *
218      * Requirements:
219      *
220      * - The `operator` cannot be the caller.
221      *
222      * Emits an {ApprovalForAll} event.
223      */
224     function setApprovalForAll(address operator, bool _approved) external;
225 
226     /**
227      * @dev Returns the account approved for `tokenId` token.
228      *
229      * Requirements:
230      *
231      * - `tokenId` must exist.
232      */
233     function getApproved(uint256 tokenId) external view returns (address operator);
234 
235     /**
236      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
237      *
238      * See {setApprovalForAll}
239      */
240     function isApprovedForAll(address owner, address operator) external view returns (bool);
241 
242     // ==============================
243     //        IERC721Metadata
244     // ==============================
245 
246     /**
247      * @dev Returns the token collection name.
248      */
249     function name() external view returns (string memory);
250 
251     /**
252      * @dev Returns the token collection symbol.
253      */
254     function symbol() external view returns (string memory);
255 
256     /**
257      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
258      */
259     function tokenURI(uint256 tokenId) external view returns (string memory);
260 }
261 
262 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
263 
264 
265 // ERC721A Contracts v3.3.0
266 // Creator: Chiru Labs
267 
268 pragma solidity ^0.8.4;
269 
270 
271 /**
272  * @dev ERC721 token receiver interface.
273  */
274 interface ERC721A__IERC721Receiver {
275     function onERC721Received(
276         address operator,
277         address from,
278         uint256 tokenId,
279         bytes calldata data
280     ) external returns (bytes4);
281 }
282 
283 /**
284  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
285  * the Metadata extension. Built to optimize for lower gas during batch mints.
286  *
287  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
288  *
289  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
290  *
291  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
292  */
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
1080 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1081 
1082 
1083 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 /**
1088  * @dev String operations.
1089  */
1090 library Strings {
1091     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1092     uint8 private constant _ADDRESS_LENGTH = 20;
1093 
1094     /**
1095      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1096      */
1097     function toString(uint256 value) internal pure returns (string memory) {
1098         // Inspired by OraclizeAPI's implementation - MIT licence
1099         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1100 
1101         if (value == 0) {
1102             return "0";
1103         }
1104         uint256 temp = value;
1105         uint256 digits;
1106         while (temp != 0) {
1107             digits++;
1108             temp /= 10;
1109         }
1110         bytes memory buffer = new bytes(digits);
1111         while (value != 0) {
1112             digits -= 1;
1113             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1114             value /= 10;
1115         }
1116         return string(buffer);
1117     }
1118 
1119     /**
1120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1121      */
1122     function toHexString(uint256 value) internal pure returns (string memory) {
1123         if (value == 0) {
1124             return "0x00";
1125         }
1126         uint256 temp = value;
1127         uint256 length = 0;
1128         while (temp != 0) {
1129             length++;
1130             temp >>= 8;
1131         }
1132         return toHexString(value, length);
1133     }
1134 
1135     /**
1136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1137      */
1138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1139         bytes memory buffer = new bytes(2 * length + 2);
1140         buffer[0] = "0";
1141         buffer[1] = "x";
1142         for (uint256 i = 2 * length + 1; i > 1; --i) {
1143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1144             value >>= 4;
1145         }
1146         require(value == 0, "Strings: hex length insufficient");
1147         return string(buffer);
1148     }
1149 
1150     /**
1151      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1152      */
1153     function toHexString(address addr) internal pure returns (string memory) {
1154         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1155     }
1156 }
1157 
1158 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1159 
1160 
1161 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 /**
1166  * @dev Provides information about the current execution context, including the
1167  * sender of the transaction and its data. While these are generally available
1168  * via msg.sender and msg.data, they should not be accessed in such a direct
1169  * manner, since when dealing with meta-transactions the account sending and
1170  * paying for execution may not be the actual sender (as far as an application
1171  * is concerned).
1172  *
1173  * This contract is only required for intermediate, library-like contracts.
1174  */
1175 abstract contract Context {
1176     function _msgSender() internal view virtual returns (address) {
1177         return msg.sender;
1178     }
1179 
1180     function _msgData() internal view virtual returns (bytes calldata) {
1181         return msg.data;
1182     }
1183 }
1184 
1185 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1186 
1187 
1188 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 
1193 /**
1194  * @dev Contract module which provides a basic access control mechanism, where
1195  * there is an account (an owner) that can be granted exclusive access to
1196  * specific functions.
1197  *
1198  * By default, the owner account will be the one that deploys the contract. This
1199  * can later be changed with {transferOwnership}.
1200  *
1201  * This module is used through inheritance. It will make available the modifier
1202  * `onlyOwner`, which can be applied to your functions to restrict their use to
1203  * the owner.
1204  */
1205 abstract contract Ownable is Context {
1206     address private _owner;
1207 
1208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1209 
1210     /**
1211      * @dev Initializes the contract setting the deployer as the initial owner.
1212      */
1213     constructor() {
1214         _transferOwnership(_msgSender());
1215     }
1216 
1217     /**
1218      * @dev Returns the address of the current owner.
1219      */
1220     function owner() public view virtual returns (address) {
1221         return _owner;
1222     }
1223 
1224     /**
1225      * @dev Throws if called by any account other than the owner.
1226      */
1227     modifier onlyOwner() {
1228         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1229         _;
1230     }
1231 
1232     /**
1233      * @dev Leaves the contract without owner. It will not be possible to call
1234      * `onlyOwner` functions anymore. Can only be called by the current owner.
1235      *
1236      * NOTE: Renouncing ownership will leave the contract without an owner,
1237      * thereby removing any functionality that is only available to the owner.
1238      */
1239     function renounceOwnership() public virtual onlyOwner {
1240         _transferOwnership(address(0));
1241     }
1242 
1243     /**
1244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1245      * Can only be called by the current owner.
1246      */
1247     function transferOwnership(address newOwner) public virtual onlyOwner {
1248         require(newOwner != address(0), "Ownable: new owner is the zero address");
1249         _transferOwnership(newOwner);
1250     }
1251 
1252     /**
1253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1254      * Internal function without access restriction.
1255      */
1256     function _transferOwnership(address newOwner) internal virtual {
1257         address oldOwner = _owner;
1258         _owner = newOwner;
1259         emit OwnershipTransferred(oldOwner, newOwner);
1260     }
1261 }
1262 
1263 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1264 
1265 
1266 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1267 
1268 pragma solidity ^0.8.1;
1269 
1270 /**
1271  * @dev Collection of functions related to the address type
1272  */
1273 library Address {
1274     /**
1275      * @dev Returns true if `account` is a contract.
1276      *
1277      * [IMPORTANT]
1278      * ====
1279      * It is unsafe to assume that an address for which this function returns
1280      * false is an externally-owned account (EOA) and not a contract.
1281      *
1282      * Among others, `isContract` will return false for the following
1283      * types of addresses:
1284      *
1285      *  - an externally-owned account
1286      *  - a contract in construction
1287      *  - an address where a contract will be created
1288      *  - an address where a contract lived, but was destroyed
1289      * ====
1290      *
1291      * [IMPORTANT]
1292      * ====
1293      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1294      *
1295      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1296      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1297      * constructor.
1298      * ====
1299      */
1300     function isContract(address account) internal view returns (bool) {
1301         // This method relies on extcodesize/address.code.length, which returns 0
1302         // for contracts in construction, since the code is only stored at the end
1303         // of the constructor execution.
1304 
1305         return account.code.length > 0;
1306     }
1307 
1308     /**
1309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1310      * `recipient`, forwarding all available gas and reverting on errors.
1311      *
1312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1314      * imposed by `transfer`, making them unable to receive funds via
1315      * `transfer`. {sendValue} removes this limitation.
1316      *
1317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1318      *
1319      * IMPORTANT: because control is transferred to `recipient`, care must be
1320      * taken to not create reentrancy vulnerabilities. Consider using
1321      * {ReentrancyGuard} or the
1322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1323      */
1324     function sendValue(address payable recipient, uint256 amount) internal {
1325         require(address(this).balance >= amount, "Address: insufficient balance");
1326 
1327         (bool success, ) = recipient.call{value: amount}("");
1328         require(success, "Address: unable to send value, recipient may have reverted");
1329     }
1330 
1331     /**
1332      * @dev Performs a Solidity function call using a low level `call`. A
1333      * plain `call` is an unsafe replacement for a function call: use this
1334      * function instead.
1335      *
1336      * If `target` reverts with a revert reason, it is bubbled up by this
1337      * function (like regular Solidity function calls).
1338      *
1339      * Returns the raw returned data. To convert to the expected return value,
1340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1341      *
1342      * Requirements:
1343      *
1344      * - `target` must be a contract.
1345      * - calling `target` with `data` must not revert.
1346      *
1347      * _Available since v3.1._
1348      */
1349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1350         return functionCall(target, data, "Address: low-level call failed");
1351     }
1352 
1353     /**
1354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1355      * `errorMessage` as a fallback revert reason when `target` reverts.
1356      *
1357      * _Available since v3.1._
1358      */
1359     function functionCall(
1360         address target,
1361         bytes memory data,
1362         string memory errorMessage
1363     ) internal returns (bytes memory) {
1364         return functionCallWithValue(target, data, 0, errorMessage);
1365     }
1366 
1367     /**
1368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1369      * but also transferring `value` wei to `target`.
1370      *
1371      * Requirements:
1372      *
1373      * - the calling contract must have an ETH balance of at least `value`.
1374      * - the called Solidity function must be `payable`.
1375      *
1376      * _Available since v3.1._
1377      */
1378     function functionCallWithValue(
1379         address target,
1380         bytes memory data,
1381         uint256 value
1382     ) internal returns (bytes memory) {
1383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1384     }
1385 
1386     /**
1387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1388      * with `errorMessage` as a fallback revert reason when `target` reverts.
1389      *
1390      * _Available since v3.1._
1391      */
1392     function functionCallWithValue(
1393         address target,
1394         bytes memory data,
1395         uint256 value,
1396         string memory errorMessage
1397     ) internal returns (bytes memory) {
1398         require(address(this).balance >= value, "Address: insufficient balance for call");
1399         require(isContract(target), "Address: call to non-contract");
1400 
1401         (bool success, bytes memory returndata) = target.call{value: value}(data);
1402         return verifyCallResult(success, returndata, errorMessage);
1403     }
1404 
1405     /**
1406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1407      * but performing a static call.
1408      *
1409      * _Available since v3.3._
1410      */
1411     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1412         return functionStaticCall(target, data, "Address: low-level static call failed");
1413     }
1414 
1415     /**
1416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1417      * but performing a static call.
1418      *
1419      * _Available since v3.3._
1420      */
1421     function functionStaticCall(
1422         address target,
1423         bytes memory data,
1424         string memory errorMessage
1425     ) internal view returns (bytes memory) {
1426         require(isContract(target), "Address: static call to non-contract");
1427 
1428         (bool success, bytes memory returndata) = target.staticcall(data);
1429         return verifyCallResult(success, returndata, errorMessage);
1430     }
1431 
1432     /**
1433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1434      * but performing a delegate call.
1435      *
1436      * _Available since v3.4._
1437      */
1438     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1439         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1440     }
1441 
1442     /**
1443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1444      * but performing a delegate call.
1445      *
1446      * _Available since v3.4._
1447      */
1448     function functionDelegateCall(
1449         address target,
1450         bytes memory data,
1451         string memory errorMessage
1452     ) internal returns (bytes memory) {
1453         require(isContract(target), "Address: delegate call to non-contract");
1454 
1455         (bool success, bytes memory returndata) = target.delegatecall(data);
1456         return verifyCallResult(success, returndata, errorMessage);
1457     }
1458 
1459     /**
1460      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1461      * revert reason using the provided one.
1462      *
1463      * _Available since v4.3._
1464      */
1465     function verifyCallResult(
1466         bool success,
1467         bytes memory returndata,
1468         string memory errorMessage
1469     ) internal pure returns (bytes memory) {
1470         if (success) {
1471             return returndata;
1472         } else {
1473             // Look for revert reason and bubble it up if present
1474             if (returndata.length > 0) {
1475                 // The easiest way to bubble the revert reason is using memory via assembly
1476 
1477                 assembly {
1478                     let returndata_size := mload(returndata)
1479                     revert(add(32, returndata), returndata_size)
1480                 }
1481             } else {
1482                 revert(errorMessage);
1483             }
1484         }
1485     }
1486 }
1487 
1488 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1489 
1490 
1491 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1492 
1493 pragma solidity ^0.8.0;
1494 
1495 /**
1496  * @title ERC721 token receiver interface
1497  * @dev Interface for any contract that wants to support safeTransfers
1498  * from ERC721 asset contracts.
1499  */
1500 interface IERC721Receiver {
1501     /**
1502      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1503      * by `operator` from `from`, this function is called.
1504      *
1505      * It must return its Solidity selector to confirm the token transfer.
1506      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1507      *
1508      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1509      */
1510     function onERC721Received(
1511         address operator,
1512         address from,
1513         uint256 tokenId,
1514         bytes calldata data
1515     ) external returns (bytes4);
1516 }
1517 
1518 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1519 
1520 
1521 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1522 
1523 pragma solidity ^0.8.0;
1524 
1525 /**
1526  * @dev Interface of the ERC165 standard, as defined in the
1527  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1528  *
1529  * Implementers can declare support of contract interfaces, which can then be
1530  * queried by others ({ERC165Checker}).
1531  *
1532  * For an implementation, see {ERC165}.
1533  */
1534 interface IERC165 {
1535     /**
1536      * @dev Returns true if this contract implements the interface defined by
1537      * `interfaceId`. See the corresponding
1538      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1539      * to learn more about how these ids are created.
1540      *
1541      * This function call must use less than 30 000 gas.
1542      */
1543     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1544 }
1545 
1546 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1547 
1548 
1549 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1550 
1551 pragma solidity ^0.8.0;
1552 
1553 
1554 /**
1555  * @dev Implementation of the {IERC165} interface.
1556  *
1557  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1558  * for the additional interface id that will be supported. For example:
1559  *
1560  * ```solidity
1561  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1562  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1563  * }
1564  * ```
1565  *
1566  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1567  */
1568 abstract contract ERC165 is IERC165 {
1569     /**
1570      * @dev See {IERC165-supportsInterface}.
1571      */
1572     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1573         return interfaceId == type(IERC165).interfaceId;
1574     }
1575 }
1576 
1577 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1578 
1579 
1580 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1581 
1582 pragma solidity ^0.8.0;
1583 
1584 
1585 /**
1586  * @dev Required interface of an ERC721 compliant contract.
1587  */
1588 interface IERC721 is IERC165 {
1589     /**
1590      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1591      */
1592     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1593 
1594     /**
1595      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1596      */
1597     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1598 
1599     /**
1600      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1601      */
1602     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1603 
1604     /**
1605      * @dev Returns the number of tokens in ``owner``'s account.
1606      */
1607     function balanceOf(address owner) external view returns (uint256 balance);
1608 
1609     /**
1610      * @dev Returns the owner of the `tokenId` token.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      */
1616     function ownerOf(uint256 tokenId) external view returns (address owner);
1617 
1618     /**
1619      * @dev Safely transfers `tokenId` token from `from` to `to`.
1620      *
1621      * Requirements:
1622      *
1623      * - `from` cannot be the zero address.
1624      * - `to` cannot be the zero address.
1625      * - `tokenId` token must exist and be owned by `from`.
1626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1627      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1628      *
1629      * Emits a {Transfer} event.
1630      */
1631     function safeTransferFrom(
1632         address from,
1633         address to,
1634         uint256 tokenId,
1635         bytes calldata data
1636     ) external;
1637 
1638     /**
1639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1641      *
1642      * Requirements:
1643      *
1644      * - `from` cannot be the zero address.
1645      * - `to` cannot be the zero address.
1646      * - `tokenId` token must exist and be owned by `from`.
1647      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function safeTransferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) external;
1657 
1658     /**
1659      * @dev Transfers `tokenId` token from `from` to `to`.
1660      *
1661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1662      *
1663      * Requirements:
1664      *
1665      * - `from` cannot be the zero address.
1666      * - `to` cannot be the zero address.
1667      * - `tokenId` token must be owned by `from`.
1668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1669      *
1670      * Emits a {Transfer} event.
1671      */
1672     function transferFrom(
1673         address from,
1674         address to,
1675         uint256 tokenId
1676     ) external;
1677 
1678     /**
1679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1680      * The approval is cleared when the token is transferred.
1681      *
1682      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1683      *
1684      * Requirements:
1685      *
1686      * - The caller must own the token or be an approved operator.
1687      * - `tokenId` must exist.
1688      *
1689      * Emits an {Approval} event.
1690      */
1691     function approve(address to, uint256 tokenId) external;
1692 
1693     /**
1694      * @dev Approve or remove `operator` as an operator for the caller.
1695      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1696      *
1697      * Requirements:
1698      *
1699      * - The `operator` cannot be the caller.
1700      *
1701      * Emits an {ApprovalForAll} event.
1702      */
1703     function setApprovalForAll(address operator, bool _approved) external;
1704 
1705     /**
1706      * @dev Returns the account approved for `tokenId` token.
1707      *
1708      * Requirements:
1709      *
1710      * - `tokenId` must exist.
1711      */
1712     function getApproved(uint256 tokenId) external view returns (address operator);
1713 
1714     /**
1715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1716      *
1717      * See {setApprovalForAll}
1718      */
1719     function isApprovedForAll(address owner, address operator) external view returns (bool);
1720 }
1721 
1722 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1723 
1724 
1725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1726 
1727 pragma solidity ^0.8.0;
1728 
1729 
1730 /**
1731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1732  * @dev See https://eips.ethereum.org/EIPS/eip-721
1733  */
1734 interface IERC721Metadata is IERC721 {
1735     /**
1736      * @dev Returns the token collection name.
1737      */
1738     function name() external view returns (string memory);
1739 
1740     /**
1741      * @dev Returns the token collection symbol.
1742      */
1743     function symbol() external view returns (string memory);
1744 
1745     /**
1746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1747      */
1748     function tokenURI(uint256 tokenId) external view returns (string memory);
1749 }
1750 
1751 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1752 
1753 
1754 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1755 
1756 pragma solidity ^0.8.0;
1757 
1758 
1759 
1760 
1761 
1762 
1763 
1764 
1765 /**
1766  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1767  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1768  * {ERC721Enumerable}.
1769  */
1770 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1771     using Address for address;
1772     using Strings for uint256;
1773 
1774     // Token name
1775     string private _name;
1776 
1777     // Token symbol
1778     string private _symbol;
1779 
1780     // Mapping from token ID to owner address
1781     mapping(uint256 => address) private _owners;
1782 
1783     // Mapping owner address to token count
1784     mapping(address => uint256) private _balances;
1785 
1786     // Mapping from token ID to approved address
1787     mapping(uint256 => address) private _tokenApprovals;
1788 
1789     // Mapping from owner to operator approvals
1790     mapping(address => mapping(address => bool)) private _operatorApprovals;
1791 
1792     /**
1793      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1794      */
1795     constructor(string memory name_, string memory symbol_) {
1796         _name = name_;
1797         _symbol = symbol_;
1798     }
1799 
1800     /**
1801      * @dev See {IERC165-supportsInterface}.
1802      */
1803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1804         return
1805             interfaceId == type(IERC721).interfaceId ||
1806             interfaceId == type(IERC721Metadata).interfaceId ||
1807             super.supportsInterface(interfaceId);
1808     }
1809 
1810     /**
1811      * @dev See {IERC721-balanceOf}.
1812      */
1813     function balanceOf(address owner) public view virtual override returns (uint256) {
1814         require(owner != address(0), "ERC721: address zero is not a valid owner");
1815         return _balances[owner];
1816     }
1817 
1818     /**
1819      * @dev See {IERC721-ownerOf}.
1820      */
1821     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1822         address owner = _owners[tokenId];
1823         require(owner != address(0), "ERC721: owner query for nonexistent token");
1824         return owner;
1825     }
1826 
1827     /**
1828      * @dev See {IERC721Metadata-name}.
1829      */
1830     function name() public view virtual override returns (string memory) {
1831         return _name;
1832     }
1833 
1834     /**
1835      * @dev See {IERC721Metadata-symbol}.
1836      */
1837     function symbol() public view virtual override returns (string memory) {
1838         return _symbol;
1839     }
1840 
1841     /**
1842      * @dev See {IERC721Metadata-tokenURI}.
1843      */
1844     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1845         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1846 
1847         string memory baseURI = _baseURI();
1848         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1849     }
1850 
1851     /**
1852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1854      * by default, can be overridden in child contracts.
1855      */
1856     function _baseURI() internal view virtual returns (string memory) {
1857         return "";
1858     }
1859 
1860     /**
1861      * @dev See {IERC721-approve}.
1862      */
1863     function approve(address to, uint256 tokenId) public virtual override {
1864         address owner = ERC721.ownerOf(tokenId);
1865         require(to != owner, "ERC721: approval to current owner");
1866 
1867         require(
1868             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1869             "ERC721: approve caller is not owner nor approved for all"
1870         );
1871 
1872         _approve(to, tokenId);
1873     }
1874 
1875     /**
1876      * @dev See {IERC721-getApproved}.
1877      */
1878     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1879         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1880 
1881         return _tokenApprovals[tokenId];
1882     }
1883 
1884     /**
1885      * @dev See {IERC721-setApprovalForAll}.
1886      */
1887     function setApprovalForAll(address operator, bool approved) public virtual override {
1888         _setApprovalForAll(_msgSender(), operator, approved);
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-isApprovedForAll}.
1893      */
1894     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1895         return _operatorApprovals[owner][operator];
1896     }
1897 
1898     /**
1899      * @dev See {IERC721-transferFrom}.
1900      */
1901     function transferFrom(
1902         address from,
1903         address to,
1904         uint256 tokenId
1905     ) public virtual override {
1906         //solhint-disable-next-line max-line-length
1907         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1908 
1909         _transfer(from, to, tokenId);
1910     }
1911 
1912     /**
1913      * @dev See {IERC721-safeTransferFrom}.
1914      */
1915     function safeTransferFrom(
1916         address from,
1917         address to,
1918         uint256 tokenId
1919     ) public virtual override {
1920         safeTransferFrom(from, to, tokenId, "");
1921     }
1922 
1923     /**
1924      * @dev See {IERC721-safeTransferFrom}.
1925      */
1926     function safeTransferFrom(
1927         address from,
1928         address to,
1929         uint256 tokenId,
1930         bytes memory data
1931     ) public virtual override {
1932         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1933         _safeTransfer(from, to, tokenId, data);
1934     }
1935 
1936     /**
1937      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1938      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1939      *
1940      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1941      *
1942      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1943      * implement alternative mechanisms to perform token transfer, such as signature-based.
1944      *
1945      * Requirements:
1946      *
1947      * - `from` cannot be the zero address.
1948      * - `to` cannot be the zero address.
1949      * - `tokenId` token must exist and be owned by `from`.
1950      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1951      *
1952      * Emits a {Transfer} event.
1953      */
1954     function _safeTransfer(
1955         address from,
1956         address to,
1957         uint256 tokenId,
1958         bytes memory data
1959     ) internal virtual {
1960         _transfer(from, to, tokenId);
1961         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1962     }
1963 
1964     /**
1965      * @dev Returns whether `tokenId` exists.
1966      *
1967      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1968      *
1969      * Tokens start existing when they are minted (`_mint`),
1970      * and stop existing when they are burned (`_burn`).
1971      */
1972     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1973         return _owners[tokenId] != address(0);
1974     }
1975 
1976     /**
1977      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1978      *
1979      * Requirements:
1980      *
1981      * - `tokenId` must exist.
1982      */
1983     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1984         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1985         address owner = ERC721.ownerOf(tokenId);
1986         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1987     }
1988 
1989     /**
1990      * @dev Safely mints `tokenId` and transfers it to `to`.
1991      *
1992      * Requirements:
1993      *
1994      * - `tokenId` must not exist.
1995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1996      *
1997      * Emits a {Transfer} event.
1998      */
1999     function _safeMint(address to, uint256 tokenId) internal virtual {
2000         _safeMint(to, tokenId, "");
2001     }
2002 
2003     /**
2004      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2005      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2006      */
2007     function _safeMint(
2008         address to,
2009         uint256 tokenId,
2010         bytes memory data
2011     ) internal virtual {
2012         _mint(to, tokenId);
2013         require(
2014             _checkOnERC721Received(address(0), to, tokenId, data),
2015             "ERC721: transfer to non ERC721Receiver implementer"
2016         );
2017     }
2018 
2019     /**
2020      * @dev Mints `tokenId` and transfers it to `to`.
2021      *
2022      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2023      *
2024      * Requirements:
2025      *
2026      * - `tokenId` must not exist.
2027      * - `to` cannot be the zero address.
2028      *
2029      * Emits a {Transfer} event.
2030      */
2031     function _mint(address to, uint256 tokenId) internal virtual {
2032         require(to != address(0), "ERC721: mint to the zero address");
2033         require(!_exists(tokenId), "ERC721: token already minted");
2034 
2035         _beforeTokenTransfer(address(0), to, tokenId);
2036 
2037         _balances[to] += 1;
2038         _owners[tokenId] = to;
2039 
2040         emit Transfer(address(0), to, tokenId);
2041 
2042         _afterTokenTransfer(address(0), to, tokenId);
2043     }
2044 
2045     /**
2046      * @dev Destroys `tokenId`.
2047      * The approval is cleared when the token is burned.
2048      *
2049      * Requirements:
2050      *
2051      * - `tokenId` must exist.
2052      *
2053      * Emits a {Transfer} event.
2054      */
2055     function _burn(uint256 tokenId) internal virtual {
2056         address owner = ERC721.ownerOf(tokenId);
2057 
2058         _beforeTokenTransfer(owner, address(0), tokenId);
2059 
2060         // Clear approvals
2061         _approve(address(0), tokenId);
2062 
2063         _balances[owner] -= 1;
2064         delete _owners[tokenId];
2065 
2066         emit Transfer(owner, address(0), tokenId);
2067 
2068         _afterTokenTransfer(owner, address(0), tokenId);
2069     }
2070 
2071     /**
2072      * @dev Transfers `tokenId` from `from` to `to`.
2073      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2074      *
2075      * Requirements:
2076      *
2077      * - `to` cannot be the zero address.
2078      * - `tokenId` token must be owned by `from`.
2079      *
2080      * Emits a {Transfer} event.
2081      */
2082     function _transfer(
2083         address from,
2084         address to,
2085         uint256 tokenId
2086     ) internal virtual {
2087         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2088         require(to != address(0), "ERC721: transfer to the zero address");
2089 
2090         _beforeTokenTransfer(from, to, tokenId);
2091 
2092         // Clear approvals from the previous owner
2093         _approve(address(0), tokenId);
2094 
2095         _balances[from] -= 1;
2096         _balances[to] += 1;
2097         _owners[tokenId] = to;
2098 
2099         emit Transfer(from, to, tokenId);
2100 
2101         _afterTokenTransfer(from, to, tokenId);
2102     }
2103 
2104     /**
2105      * @dev Approve `to` to operate on `tokenId`
2106      *
2107      * Emits an {Approval} event.
2108      */
2109     function _approve(address to, uint256 tokenId) internal virtual {
2110         _tokenApprovals[tokenId] = to;
2111         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2112     }
2113 
2114     /**
2115      * @dev Approve `operator` to operate on all of `owner` tokens
2116      *
2117      * Emits an {ApprovalForAll} event.
2118      */
2119     function _setApprovalForAll(
2120         address owner,
2121         address operator,
2122         bool approved
2123     ) internal virtual {
2124         require(owner != operator, "ERC721: approve to caller");
2125         _operatorApprovals[owner][operator] = approved;
2126         emit ApprovalForAll(owner, operator, approved);
2127     }
2128 
2129     /**
2130      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2131      * The call is not executed if the target address is not a contract.
2132      *
2133      * @param from address representing the previous owner of the given token ID
2134      * @param to target address that will receive the tokens
2135      * @param tokenId uint256 ID of the token to be transferred
2136      * @param data bytes optional data to send along with the call
2137      * @return bool whether the call correctly returned the expected magic value
2138      */
2139     function _checkOnERC721Received(
2140         address from,
2141         address to,
2142         uint256 tokenId,
2143         bytes memory data
2144     ) private returns (bool) {
2145         if (to.isContract()) {
2146             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2147                 return retval == IERC721Receiver.onERC721Received.selector;
2148             } catch (bytes memory reason) {
2149                 if (reason.length == 0) {
2150                     revert("ERC721: transfer to non ERC721Receiver implementer");
2151                 } else {
2152                     assembly {
2153                         revert(add(32, reason), mload(reason))
2154                     }
2155                 }
2156             }
2157         } else {
2158             return true;
2159         }
2160     }
2161 
2162     /**
2163      * @dev Hook that is called before any token transfer. This includes minting
2164      * and burning.
2165      *
2166      * Calling conditions:
2167      *
2168      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2169      * transferred to `to`.
2170      * - When `from` is zero, `tokenId` will be minted for `to`.
2171      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2172      * - `from` and `to` are never both zero.
2173      *
2174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2175      */
2176     function _beforeTokenTransfer(
2177         address from,
2178         address to,
2179         uint256 tokenId
2180     ) internal virtual {}
2181 
2182     /**
2183      * @dev Hook that is called after any transfer of tokens. This includes
2184      * minting and burning.
2185      *
2186      * Calling conditions:
2187      *
2188      * - when `from` and `to` are both non-zero.
2189      * - `from` and `to` are never both zero.
2190      *
2191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2192      */
2193     function _afterTokenTransfer(
2194         address from,
2195         address to,
2196         uint256 tokenId
2197     ) internal virtual {}
2198 }
2199 
2200 
2201 
2202 
2203 pragma solidity ^0.8.0;
2204 
2205 
2206 
2207 
2208 contract BoredGrinchYachtClub is ERC721A, Ownable {
2209     using Strings for uint256;
2210 
2211     string private baseURI;
2212 
2213     uint256 public price = 0.0033 ether;
2214 
2215     uint256 public maxPerTx = 10;
2216 
2217     uint256 public maxFreePerWallet = 1;
2218 
2219     uint256 public totalFree = 10000;
2220 
2221     uint256 public maxSupply = 10000;
2222 
2223     bool public mintEnabled = false;
2224 
2225     mapping(address => uint256) private _mintedFreeAmount;
2226 
2227     constructor() ERC721A("Bored Grinch Yacht Club", "BGYC") {
2228         _safeMint(msg.sender, 5);
2229         setBaseURI("ipfs://QmaSzQAsQWzswVGp4kZWXQNWCWjZD5uTkTV1WLyR5pbyBC/");
2230     }
2231 
2232     function mint(uint256 count) external payable {
2233         uint256 cost = price;
2234         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2235             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2236 
2237         if (isFree) {
2238             cost = 0;
2239         }
2240 
2241         require(msg.value >= count * cost, "Please send the exact amount.");
2242         require(totalSupply() + count < maxSupply + 1, "No more");
2243         require(mintEnabled, "Minting is not live yet");
2244         require(count < maxPerTx + 1, "Max per TX reached.");
2245 
2246         if (isFree) {
2247             _mintedFreeAmount[msg.sender] += count;
2248         }
2249 
2250         _safeMint(msg.sender, count);
2251     }
2252 
2253     function _baseURI() internal view virtual override returns (string memory) {
2254         return baseURI;
2255     }
2256 
2257     function tokenURI(uint256 tokenId)
2258         public
2259         view
2260         virtual
2261         override
2262         returns (string memory)
2263     {
2264         require(
2265             _exists(tokenId),
2266             "ERC721Metadata: URI query for nonexistent token"
2267         );
2268         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2269     }
2270 
2271     function setBaseURI(string memory uri) public onlyOwner {
2272         baseURI = uri;
2273     }
2274 
2275     function setFreeAmount(uint256 amount) external onlyOwner {
2276         totalFree = amount;
2277     }
2278 
2279     function setPrice(uint256 _newPrice) external onlyOwner {
2280         price = _newPrice;
2281     }
2282 
2283     function flipSale() external onlyOwner {
2284         mintEnabled = !mintEnabled;
2285     }
2286 
2287     function withdraw() external onlyOwner {
2288         (bool success, ) = payable(msg.sender).call{
2289             value: address(this).balance
2290         }("");
2291         require(success, "Transfer failed.");
2292     }
2293 }