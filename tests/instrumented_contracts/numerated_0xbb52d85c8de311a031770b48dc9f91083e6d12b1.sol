1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /**
5 
6       /$$$$$$   /$$$$$$  /$$      /$$
7      /$$__  $$ /$$__  $$| $$$    /$$$
8     |__/  \ $$| $$  \__/| $$$$  /$$$$
9        /$$$$$/| $$ /$$$$| $$ $$/$$ $$
10       |___  $$| $$|_  $$| $$  $$$| $$
11      /$$  \ $$| $$  \ $$| $$\  $ | $$
12     |  $$$$$$/|  $$$$$$/| $$ \/  | $$
13     \______/  \______/ |__/     |__/
14 
15 
16     ** Website
17        https://3gm.dev/
18 
19     ** Twitter
20        https://twitter.com/3gmdev
21 
22 **/
23 
24 
25 // ERC721A Contracts v4.0.0
26 // Creator: Chiru Labs
27 
28 
29 
30 
31 // ERC721A Contracts v4.0.0
32 // Creator: Chiru Labs
33 
34 
35 
36 /**
37  * @dev Interface of an ERC721A compliant contract.
38  */
39 interface IERC721A {
40     /**
41      * The caller must own the token or be an approved operator.
42      */
43     error ApprovalCallerNotOwnerNorApproved();
44 
45     /**
46      * The token does not exist.
47      */
48     error ApprovalQueryForNonexistentToken();
49 
50     /**
51      * The caller cannot approve to their own address.
52      */
53     error ApproveToCaller();
54 
55     /**
56      * The caller cannot approve to the current owner.
57      */
58     error ApprovalToCurrentOwner();
59 
60     /**
61      * Cannot query the balance for the zero address.
62      */
63     error BalanceQueryForZeroAddress();
64 
65     /**
66      * Cannot mint to the zero address.
67      */
68     error MintToZeroAddress();
69 
70     /**
71      * The quantity of tokens minted must be more than zero.
72      */
73     error MintZeroQuantity();
74 
75     /**
76      * The token does not exist.
77      */
78     error OwnerQueryForNonexistentToken();
79 
80     /**
81      * The caller must own the token or be an approved operator.
82      */
83     error TransferCallerNotOwnerNorApproved();
84 
85     /**
86      * The token must be owned by `from`.
87      */
88     error TransferFromIncorrectOwner();
89 
90     /**
91      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
92      */
93     error TransferToNonERC721ReceiverImplementer();
94 
95     /**
96      * Cannot transfer to the zero address.
97      */
98     error TransferToZeroAddress();
99 
100     /**
101      * The token does not exist.
102      */
103     error URIQueryForNonexistentToken();
104 
105     struct TokenOwnership {
106         // The address of the owner.
107         address addr;
108         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
109         uint64 startTimestamp;
110         // Whether the token has been burned.
111         bool burned;
112     }
113 
114     /**
115      * @dev Returns the total amount of tokens stored by the contract.
116      *
117      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     // ==============================
122     //            IERC165
123     // ==============================
124 
125     /**
126      * @dev Returns true if this contract implements the interface defined by
127      * `interfaceId`. See the corresponding
128      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
129      * to learn more about how these ids are created.
130      *
131      * This function call must use less than 30 000 gas.
132      */
133     function supportsInterface(bytes4 interfaceId) external view returns (bool);
134 
135     // ==============================
136     //            IERC721
137     // ==============================
138 
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
146      */
147     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
151      */
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     /**
155      * @dev Returns the number of tokens in ``owner``'s account.
156      */
157     function balanceOf(address owner) external view returns (uint256 balance);
158 
159     /**
160      * @dev Returns the owner of the `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function ownerOf(uint256 tokenId) external view returns (address owner);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 
188     /**
189      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
190      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must exist and be owned by `from`.
197      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
199      *
200      * Emits a {Transfer} event.
201      */
202     function safeTransferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Transfers `tokenId` token from `from` to `to`.
210      *
211      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
233      *
234      * Requirements:
235      *
236      * - The caller must own the token or be an approved operator.
237      * - `tokenId` must exist.
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address to, uint256 tokenId) external;
242 
243     /**
244      * @dev Approve or remove `operator` as an operator for the caller.
245      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
246      *
247      * Requirements:
248      *
249      * - The `operator` cannot be the caller.
250      *
251      * Emits an {ApprovalForAll} event.
252      */
253     function setApprovalForAll(address operator, bool _approved) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId) external view returns (address operator);
263 
264     /**
265      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
266      *
267      * See {setApprovalForAll}
268      */
269     function isApprovedForAll(address owner, address operator) external view returns (bool);
270 
271     // ==============================
272     //        IERC721Metadata
273     // ==============================
274 
275     /**
276      * @dev Returns the token collection name.
277      */
278     function name() external view returns (string memory);
279 
280     /**
281      * @dev Returns the token collection symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
287      */
288     function tokenURI(uint256 tokenId) external view returns (string memory);
289 }
290 
291 
292 /**
293  * @dev ERC721 token receiver interface.
294  */
295 interface ERC721A__IERC721Receiver {
296     function onERC721Received(
297         address operator,
298         address from,
299         uint256 tokenId,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 /**
305  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
306  * the Metadata extension. Built to optimize for lower gas during batch mints.
307  *
308  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
309  *
310  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
311  *
312  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
313  */
314 contract ERC721A is IERC721A {
315     // Mask of an entry in packed address data.
316     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
317 
318     // The bit position of `numberMinted` in packed address data.
319     uint256 private constant BITPOS_NUMBER_MINTED = 64;
320 
321     // The bit position of `numberBurned` in packed address data.
322     uint256 private constant BITPOS_NUMBER_BURNED = 128;
323 
324     // The bit position of `aux` in packed address data.
325     uint256 private constant BITPOS_AUX = 192;
326 
327     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
328     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
329 
330     // The bit position of `startTimestamp` in packed ownership.
331     uint256 private constant BITPOS_START_TIMESTAMP = 160;
332 
333     // The bit mask of the `burned` bit in packed ownership.
334     uint256 private constant BITMASK_BURNED = 1 << 224;
335 
336     // The bit position of the `nextInitialized` bit in packed ownership.
337     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
338 
339     // The bit mask of the `nextInitialized` bit in packed ownership.
340     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
341 
342     // The tokenId of the next token to be minted.
343     uint256 private _currentIndex;
344 
345     // The number of tokens burned.
346     uint256 private _burnCounter;
347 
348     // Token name
349     string private _name;
350 
351     // Token symbol
352     string private _symbol;
353 
354     // Mapping from token ID to ownership details
355     // An empty struct value does not necessarily mean the token is unowned.
356     // See `_packedOwnershipOf` implementation for details.
357     //
358     // Bits Layout:
359     // - [0..159]   `addr`
360     // - [160..223] `startTimestamp`
361     // - [224]      `burned`
362     // - [225]      `nextInitialized`
363     mapping(uint256 => uint256) private _packedOwnerships;
364 
365     // Mapping owner address to address data.
366     //
367     // Bits Layout:
368     // - [0..63]    `balance`
369     // - [64..127]  `numberMinted`
370     // - [128..191] `numberBurned`
371     // - [192..255] `aux`
372     mapping(address => uint256) private _packedAddressData;
373 
374     // Mapping from token ID to approved address.
375     mapping(uint256 => address) private _tokenApprovals;
376 
377     // Mapping from owner to operator approvals
378     mapping(address => mapping(address => bool)) private _operatorApprovals;
379 
380     constructor(string memory name_, string memory symbol_) {
381         _name = name_;
382         _symbol = symbol_;
383         _currentIndex = _startTokenId();
384     }
385 
386     /**
387      * @dev Returns the starting token ID.
388      * To change the starting token ID, please override this function.
389      */
390     function _startTokenId() internal view virtual returns (uint256) {
391         return 0;
392     }
393 
394     /**
395      * @dev Returns the next token ID to be minted.
396      */
397     function _nextTokenId() internal view returns (uint256) {
398         return _currentIndex;
399     }
400 
401     /**
402      * @dev Returns the total number of tokens in existence.
403      * Burned tokens will reduce the count.
404      * To get the total number of tokens minted, please see `_totalMinted`.
405      */
406     function totalSupply() public view override returns (uint256) {
407         // Counter underflow is impossible as _burnCounter cannot be incremented
408         // more than `_currentIndex - _startTokenId()` times.
409         unchecked {
410             return _currentIndex - _burnCounter - _startTokenId();
411         }
412     }
413 
414     /**
415      * @dev Returns the total amount of tokens minted in the contract.
416      */
417     function _totalMinted() internal view returns (uint256) {
418         // Counter underflow is impossible as _currentIndex does not decrement,
419         // and it is initialized to `_startTokenId()`
420         unchecked {
421             return _currentIndex - _startTokenId();
422         }
423     }
424 
425     /**
426      * @dev Returns the total number of tokens burned.
427      */
428     function _totalBurned() internal view returns (uint256) {
429         return _burnCounter;
430     }
431 
432     /**
433      * @dev See {IERC165-supportsInterface}.
434      */
435     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436         // The interface IDs are constants representing the first 4 bytes of the XOR of
437         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
438         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
439         return
440             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
441             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
442             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
443     }
444 
445     /**
446      * @dev See {IERC721-balanceOf}.
447      */
448     function balanceOf(address owner) public view override returns (uint256) {
449         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
450         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
451     }
452 
453     /**
454      * Returns the number of tokens minted by `owner`.
455      */
456     function _numberMinted(address owner) internal view returns (uint256) {
457         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
458     }
459 
460     /**
461      * Returns the number of tokens burned by or on behalf of `owner`.
462      */
463     function _numberBurned(address owner) internal view returns (uint256) {
464         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
465     }
466 
467     /**
468      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
469      */
470     function _getAux(address owner) internal view returns (uint64) {
471         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
472     }
473 
474     /**
475      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
476      * If there are multiple variables, please pack them into a uint64.
477      */
478     function _setAux(address owner, uint64 aux) internal {
479         uint256 packed = _packedAddressData[owner];
480         uint256 auxCasted;
481         assembly { // Cast aux without masking.
482             auxCasted := aux
483         }
484         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
485         _packedAddressData[owner] = packed;
486     }
487 
488     /**
489      * Returns the packed ownership data of `tokenId`.
490      */
491     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
492         uint256 curr = tokenId;
493 
494         unchecked {
495             if (_startTokenId() <= curr)
496                 if (curr < _currentIndex) {
497                     uint256 packed = _packedOwnerships[curr];
498                     // If not burned.
499                     if (packed & BITMASK_BURNED == 0) {
500                         // Invariant:
501                         // There will always be an ownership that has an address and is not burned
502                         // before an ownership that does not have an address and is not burned.
503                         // Hence, curr will not underflow.
504                         //
505                         // We can directly compare the packed value.
506                         // If the address is zero, packed is zero.
507                         while (packed == 0) {
508                             packed = _packedOwnerships[--curr];
509                         }
510                         return packed;
511                     }
512                 }
513         }
514         revert OwnerQueryForNonexistentToken();
515     }
516 
517     /**
518      * Returns the unpacked `TokenOwnership` struct from `packed`.
519      */
520     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
521         ownership.addr = address(uint160(packed));
522         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
523         ownership.burned = packed & BITMASK_BURNED != 0;
524     }
525 
526     /**
527      * Returns the unpacked `TokenOwnership` struct at `index`.
528      */
529     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
530         return _unpackedOwnership(_packedOwnerships[index]);
531     }
532 
533     /**
534      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
535      */
536     function _initializeOwnershipAt(uint256 index) internal {
537         if (_packedOwnerships[index] == 0) {
538             _packedOwnerships[index] = _packedOwnershipOf(index);
539         }
540     }
541 
542     /**
543      * Gas spent here starts off proportional to the maximum mint batch size.
544      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
545      */
546     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
547         return _unpackedOwnership(_packedOwnershipOf(tokenId));
548     }
549 
550     /**
551      * @dev See {IERC721-ownerOf}.
552      */
553     function ownerOf(uint256 tokenId) public view override returns (address) {
554         return address(uint160(_packedOwnershipOf(tokenId)));
555     }
556 
557     /**
558      * @dev See {IERC721Metadata-name}.
559      */
560     function name() public view virtual override returns (string memory) {
561         return _name;
562     }
563 
564     /**
565      * @dev See {IERC721Metadata-symbol}.
566      */
567     function symbol() public view virtual override returns (string memory) {
568         return _symbol;
569     }
570 
571     /**
572      * @dev See {IERC721Metadata-tokenURI}.
573      */
574     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
575         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
576 
577         string memory baseURI = _baseURI();
578         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
579     }
580 
581     /**
582      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
583      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
584      * by default, can be overriden in child contracts.
585      */
586     function _baseURI() internal view virtual returns (string memory) {
587         return '';
588     }
589 
590     /**
591      * @dev Casts the address to uint256 without masking.
592      */
593     function _addressToUint256(address value) private pure returns (uint256 result) {
594         assembly {
595             result := value
596         }
597     }
598 
599     /**
600      * @dev Casts the boolean to uint256 without branching.
601      */
602     function _boolToUint256(bool value) private pure returns (uint256 result) {
603         assembly {
604             result := value
605         }
606     }
607 
608     /**
609      * @dev See {IERC721-approve}.
610      */
611     function approve(address to, uint256 tokenId) public override {
612         address owner = address(uint160(_packedOwnershipOf(tokenId)));
613         if (to == owner) revert ApprovalToCurrentOwner();
614 
615         if (_msgSenderERC721A() != owner)
616             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
617                 revert ApprovalCallerNotOwnerNorApproved();
618             }
619 
620         _tokenApprovals[tokenId] = to;
621         emit Approval(owner, to, tokenId);
622     }
623 
624     /**
625      * @dev See {IERC721-getApproved}.
626      */
627     function getApproved(uint256 tokenId) public view override returns (address) {
628         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
629 
630         return _tokenApprovals[tokenId];
631     }
632 
633     /**
634      * @dev See {IERC721-setApprovalForAll}.
635      */
636     function setApprovalForAll(address operator, bool approved) public virtual override {
637         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
638 
639         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
640         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
641     }
642 
643     /**
644      * @dev See {IERC721-isApprovedForAll}.
645      */
646     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
647         return _operatorApprovals[owner][operator];
648     }
649 
650     /**
651      * @dev See {IERC721-transferFrom}.
652      */
653     function transferFrom(
654         address from,
655         address to,
656         uint256 tokenId
657     ) public virtual override {
658         _transfer(from, to, tokenId);
659     }
660 
661     /**
662      * @dev See {IERC721-safeTransferFrom}.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) public virtual override {
669         safeTransferFrom(from, to, tokenId, '');
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes memory _data
680     ) public virtual override {
681         _transfer(from, to, tokenId);
682         if (to.code.length != 0)
683             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
684                 revert TransferToNonERC721ReceiverImplementer();
685             }
686     }
687 
688     /**
689      * @dev Returns whether `tokenId` exists.
690      *
691      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
692      *
693      * Tokens start existing when they are minted (`_mint`),
694      */
695     function _exists(uint256 tokenId) internal view returns (bool) {
696         return
697             _startTokenId() <= tokenId &&
698             tokenId < _currentIndex && // If within bounds,
699             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
700     }
701 
702     /**
703      * @dev Equivalent to `_safeMint(to, quantity, '')`.
704      */
705     function _safeMint(address to, uint256 quantity) internal {
706         _safeMint(to, quantity, '');
707     }
708 
709     /**
710      * @dev Safely mints `quantity` tokens and transfers them to `to`.
711      *
712      * Requirements:
713      *
714      * - If `to` refers to a smart contract, it must implement
715      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
716      * - `quantity` must be greater than 0.
717      *
718      * Emits a {Transfer} event.
719      */
720     function _safeMint(
721         address to,
722         uint256 quantity,
723         bytes memory _data
724     ) internal {
725         uint256 startTokenId = _currentIndex;
726         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
727         if (quantity == 0) revert MintZeroQuantity();
728 
729         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
730 
731         // Overflows are incredibly unrealistic.
732         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
733         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
734         unchecked {
735             // Updates:
736             // - `balance += quantity`.
737             // - `numberMinted += quantity`.
738             //
739             // We can directly add to the balance and number minted.
740             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
741 
742             // Updates:
743             // - `address` to the owner.
744             // - `startTimestamp` to the timestamp of minting.
745             // - `burned` to `false`.
746             // - `nextInitialized` to `quantity == 1`.
747             _packedOwnerships[startTokenId] =
748                 _addressToUint256(to) |
749                 (block.timestamp << BITPOS_START_TIMESTAMP) |
750                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
751 
752             uint256 updatedIndex = startTokenId;
753             uint256 end = updatedIndex + quantity;
754 
755             if (to.code.length != 0) {
756                 do {
757                     emit Transfer(address(0), to, updatedIndex);
758                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
759                         revert TransferToNonERC721ReceiverImplementer();
760                     }
761                 } while (updatedIndex < end);
762                 // Reentrancy protection
763                 if (_currentIndex != startTokenId) revert();
764             } else {
765                 do {
766                     emit Transfer(address(0), to, updatedIndex++);
767                 } while (updatedIndex < end);
768             }
769             _currentIndex = updatedIndex;
770         }
771         _afterTokenTransfers(address(0), to, startTokenId, quantity);
772     }
773 
774     /**
775      * @dev Mints `quantity` tokens and transfers them to `to`.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `quantity` must be greater than 0.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _mint(address to, uint256 quantity) internal {
785         uint256 startTokenId = _currentIndex;
786         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
787         if (quantity == 0) revert MintZeroQuantity();
788 
789         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
790 
791         // Overflows are incredibly unrealistic.
792         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
793         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
794         unchecked {
795             // Updates:
796             // - `balance += quantity`.
797             // - `numberMinted += quantity`.
798             //
799             // We can directly add to the balance and number minted.
800             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
801 
802             // Updates:
803             // - `address` to the owner.
804             // - `startTimestamp` to the timestamp of minting.
805             // - `burned` to `false`.
806             // - `nextInitialized` to `quantity == 1`.
807             _packedOwnerships[startTokenId] =
808                 _addressToUint256(to) |
809                 (block.timestamp << BITPOS_START_TIMESTAMP) |
810                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
811 
812             uint256 updatedIndex = startTokenId;
813             uint256 end = updatedIndex + quantity;
814 
815             do {
816                 emit Transfer(address(0), to, updatedIndex++);
817             } while (updatedIndex < end);
818 
819             _currentIndex = updatedIndex;
820         }
821         _afterTokenTransfers(address(0), to, startTokenId, quantity);
822     }
823 
824     /**
825      * @dev Transfers `tokenId` from `from` to `to`.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _transfer(
835         address from,
836         address to,
837         uint256 tokenId
838     ) private {
839         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
840 
841         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
842 
843         address approvedAddress = _tokenApprovals[tokenId];
844 
845         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
846             isApprovedForAll(from, _msgSenderERC721A()) ||
847             approvedAddress == _msgSenderERC721A());
848 
849         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
850         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
851 
852         _beforeTokenTransfers(from, to, tokenId, 1);
853 
854         // Clear approvals from the previous owner.
855         if (_addressToUint256(approvedAddress) != 0) {
856             delete _tokenApprovals[tokenId];
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] =
873                 _addressToUint256(to) |
874                 (block.timestamp << BITPOS_START_TIMESTAMP) |
875                 BITMASK_NEXT_INITIALIZED;
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895     /**
896      * @dev Equivalent to `_burn(tokenId, false)`.
897      */
898     function _burn(uint256 tokenId) internal virtual {
899         _burn(tokenId, false);
900     }
901 
902     /**
903      * @dev Destroys `tokenId`.
904      * The approval is cleared when the token is burned.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
913         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
914 
915         address from = address(uint160(prevOwnershipPacked));
916         address approvedAddress = _tokenApprovals[tokenId];
917 
918         if (approvalCheck) {
919             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
920                 isApprovedForAll(from, _msgSenderERC721A()) ||
921                 approvedAddress == _msgSenderERC721A());
922 
923             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
924         }
925 
926         _beforeTokenTransfers(from, address(0), tokenId, 1);
927 
928         // Clear approvals from the previous owner.
929         if (_addressToUint256(approvedAddress) != 0) {
930             delete _tokenApprovals[tokenId];
931         }
932 
933         // Underflow of the sender's balance is impossible because we check for
934         // ownership above and the recipient's balance can't realistically overflow.
935         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
936         unchecked {
937             // Updates:
938             // - `balance -= 1`.
939             // - `numberBurned += 1`.
940             //
941             // We can directly decrement the balance, and increment the number burned.
942             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
943             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
944 
945             // Updates:
946             // - `address` to the last owner.
947             // - `startTimestamp` to the timestamp of burning.
948             // - `burned` to `true`.
949             // - `nextInitialized` to `true`.
950             _packedOwnerships[tokenId] =
951                 _addressToUint256(from) |
952                 (block.timestamp << BITPOS_START_TIMESTAMP) |
953                 BITMASK_BURNED |
954                 BITMASK_NEXT_INITIALIZED;
955 
956             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
957             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
958                 uint256 nextTokenId = tokenId + 1;
959                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
960                 if (_packedOwnerships[nextTokenId] == 0) {
961                     // If the next slot is within bounds.
962                     if (nextTokenId != _currentIndex) {
963                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
964                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
965                     }
966                 }
967             }
968         }
969 
970         emit Transfer(from, address(0), tokenId);
971         _afterTokenTransfers(from, address(0), tokenId, 1);
972 
973         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
974         unchecked {
975             _burnCounter++;
976         }
977     }
978 
979     /**
980      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
981      *
982      * @param from address representing the previous owner of the given token ID
983      * @param to target address that will receive the tokens
984      * @param tokenId uint256 ID of the token to be transferred
985      * @param _data bytes optional data to send along with the call
986      * @return bool whether the call correctly returned the expected magic value
987      */
988     function _checkContractOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
995             bytes4 retval
996         ) {
997             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
998         } catch (bytes memory reason) {
999             if (reason.length == 0) {
1000                 revert TransferToNonERC721ReceiverImplementer();
1001             } else {
1002                 assembly {
1003                     revert(add(32, reason), mload(reason))
1004                 }
1005             }
1006         }
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1011      * And also called before burning one token.
1012      *
1013      * startTokenId - the first token id to be transferred
1014      * quantity - the amount to be transferred
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` will be minted for `to`.
1021      * - When `to` is zero, `tokenId` will be burned by `from`.
1022      * - `from` and `to` are never both zero.
1023      */
1024     function _beforeTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1033      * minting.
1034      * And also called after one token has been burned.
1035      *
1036      * startTokenId - the first token id to be transferred
1037      * quantity - the amount to be transferred
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` has been minted for `to`.
1044      * - When `to` is zero, `tokenId` has been burned by `from`.
1045      * - `from` and `to` are never both zero.
1046      */
1047     function _afterTokenTransfers(
1048         address from,
1049         address to,
1050         uint256 startTokenId,
1051         uint256 quantity
1052     ) internal virtual {}
1053 
1054     /**
1055      * @dev Returns the message sender (defaults to `msg.sender`).
1056      *
1057      * If you are writing GSN compatible contracts, you need to override this function.
1058      */
1059     function _msgSenderERC721A() internal view virtual returns (address) {
1060         return msg.sender;
1061     }
1062 
1063     /**
1064      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1065      */
1066     function _toString(uint256 value) internal pure returns (string memory ptr) {
1067         assembly {
1068             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1069             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1070             // We will need 1 32-byte word to store the length,
1071             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1072             ptr := add(mload(0x40), 128)
1073             // Update the free memory pointer to allocate.
1074             mstore(0x40, ptr)
1075 
1076             // Cache the end of the memory to calculate the length later.
1077             let end := ptr
1078 
1079             // We write the string from the rightmost digit to the leftmost digit.
1080             // The following is essentially a do-while loop that also handles the zero case.
1081             // Costs a bit more than early returning for the zero case,
1082             // but cheaper in terms of deployment and overall runtime costs.
1083             for {
1084                 // Initialize and perform the first pass without check.
1085                 let temp := value
1086                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1087                 ptr := sub(ptr, 1)
1088                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1089                 mstore8(ptr, add(48, mod(temp, 10)))
1090                 temp := div(temp, 10)
1091             } temp {
1092                 // Keep dividing `temp` until zero.
1093                 temp := div(temp, 10)
1094             } { // Body of the for loop.
1095                 ptr := sub(ptr, 1)
1096                 mstore8(ptr, add(48, mod(temp, 10)))
1097             }
1098 
1099             let length := sub(end, ptr)
1100             // Move the pointer 32 bytes leftwards to make room for the length.
1101             ptr := sub(ptr, 32)
1102             // Store the length.
1103             mstore(ptr, length)
1104         }
1105     }
1106 }
1107 
1108 
1109 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1110 
1111 
1112 
1113 /**
1114  * @dev String operations.
1115  */
1116 library Strings {
1117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1118     uint8 private constant _ADDRESS_LENGTH = 20;
1119 
1120     /**
1121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1122      */
1123     function toString(uint256 value) internal pure returns (string memory) {
1124         // Inspired by OraclizeAPI's implementation - MIT licence
1125         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1126 
1127         if (value == 0) {
1128             return "0";
1129         }
1130         uint256 temp = value;
1131         uint256 digits;
1132         while (temp != 0) {
1133             digits++;
1134             temp /= 10;
1135         }
1136         bytes memory buffer = new bytes(digits);
1137         while (value != 0) {
1138             digits -= 1;
1139             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1140             value /= 10;
1141         }
1142         return string(buffer);
1143     }
1144 
1145     /**
1146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1147      */
1148     function toHexString(uint256 value) internal pure returns (string memory) {
1149         if (value == 0) {
1150             return "0x00";
1151         }
1152         uint256 temp = value;
1153         uint256 length = 0;
1154         while (temp != 0) {
1155             length++;
1156             temp >>= 8;
1157         }
1158         return toHexString(value, length);
1159     }
1160 
1161     /**
1162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1163      */
1164     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1165         bytes memory buffer = new bytes(2 * length + 2);
1166         buffer[0] = "0";
1167         buffer[1] = "x";
1168         for (uint256 i = 2 * length + 1; i > 1; --i) {
1169             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1170             value >>= 4;
1171         }
1172         require(value == 0, "Strings: hex length insufficient");
1173         return string(buffer);
1174     }
1175 
1176     /**
1177      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1178      */
1179     function toHexString(address addr) internal pure returns (string memory) {
1180         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1181     }
1182 }
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1186 
1187 
1188 
1189 
1190 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1191 
1192 
1193 
1194 /**
1195  * @dev Provides information about the current execution context, including the
1196  * sender of the transaction and its data. While these are generally available
1197  * via msg.sender and msg.data, they should not be accessed in such a direct
1198  * manner, since when dealing with meta-transactions the account sending and
1199  * paying for execution may not be the actual sender (as far as an application
1200  * is concerned).
1201  *
1202  * This contract is only required for intermediate, library-like contracts.
1203  */
1204 abstract contract Context {
1205     function _msgSender() internal view virtual returns (address) {
1206         return msg.sender;
1207     }
1208 
1209     function _msgData() internal view virtual returns (bytes calldata) {
1210         return msg.data;
1211     }
1212 }
1213 
1214 
1215 /**
1216  * @dev Contract module which provides a basic access control mechanism, where
1217  * there is an account (an owner) that can be granted exclusive access to
1218  * specific functions.
1219  *
1220  * By default, the owner account will be the one that deploys the contract. This
1221  * can later be changed with {transferOwnership}.
1222  *
1223  * This module is used through inheritance. It will make available the modifier
1224  * `onlyOwner`, which can be applied to your functions to restrict their use to
1225  * the owner.
1226  */
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1231 
1232     /**
1233      * @dev Initializes the contract setting the deployer as the initial owner.
1234      */
1235     constructor() {
1236         _transferOwnership(_msgSender());
1237     }
1238 
1239     /**
1240      * @dev Returns the address of the current owner.
1241      */
1242     function owner() public view virtual returns (address) {
1243         return _owner;
1244     }
1245 
1246     /**
1247      * @dev Throws if called by any account other than the owner.
1248      */
1249     modifier onlyOwner() {
1250         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Leaves the contract without owner. It will not be possible to call
1256      * `onlyOwner` functions anymore. Can only be called by the current owner.
1257      *
1258      * NOTE: Renouncing ownership will leave the contract without an owner,
1259      * thereby removing any functionality that is only available to the owner.
1260      */
1261     function renounceOwnership() public virtual onlyOwner {
1262         _transferOwnership(address(0));
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Can only be called by the current owner.
1268      */
1269     function transferOwnership(address newOwner) public virtual onlyOwner {
1270         require(newOwner != address(0), "Ownable: new owner is the zero address");
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 
1285 
1286 contract ThreeGMGenesisPass is ERC721A, Ownable {
1287 
1288     string public baseURI = "ipfs://QmSiHUyXvNRJWWNf7ekHAeCkzSdgEYVUAM4FNciYJqfSsF/";
1289     string public contractURI = "ipfs://QmdU8yyKEUd242nbhRDqvxnVgFv7Mb8X3fNymse62RNXLC";
1290     uint256 public constant MAX_SUPPLY = 333;
1291     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1292 
1293     bool public paused = true;
1294 
1295     constructor() ERC721A("3GMGenesisPass", "3GM") {}
1296 
1297     function mint(bytes4 _check) external payable {
1298         address _caller = _msgSender();
1299         require(!paused, "Paused");
1300         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1301         require(_numberMinted(_caller) < 1, "Exceeds max per wallet");
1302         require(tx.origin == _caller, "No contracts");
1303         require(checkWebMint(_caller, _check), "Not from web, sus");
1304 
1305         _safeMint(_caller, 1);
1306     }
1307 
1308     function checkWebMint(address _sender, bytes4 _check) internal pure returns(bool){
1309         return bytes4(keccak256(abi.encodePacked(_sender))) == _check;
1310     }
1311 
1312     function _startTokenId() internal override view virtual returns (uint256) {
1313         return 1;
1314     }
1315 
1316     function isApprovedForAll(address owner, address operator)
1317         override
1318         public
1319         view
1320         returns (bool)
1321     {
1322         // Whitelist OpenSea proxy contract for easy trading.
1323         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1324         if (address(proxyRegistry.proxies(owner)) == operator) {
1325             return true;
1326         }
1327 
1328         return super.isApprovedForAll(owner, operator);
1329     }
1330 
1331     function minted(address _owner) public view returns (uint256) {
1332         return _numberMinted(_owner);
1333     }
1334 
1335     function withdraw() external onlyOwner {
1336         uint256 balance = address(this).balance;
1337         (bool success, ) = _msgSender().call{value: balance}("");
1338         require(success, "Failed to send");
1339     }
1340 
1341     function teamMint(address _to, uint256 _amount) external onlyOwner {
1342         _safeMint(_to, _amount);
1343     }
1344 
1345     function toggleMint() external onlyOwner {
1346         paused = !paused;
1347     }
1348 
1349     function setBaseURI(string memory baseURI_) external onlyOwner {
1350         baseURI = baseURI_;
1351     }
1352 
1353     function setContractURI(string memory _contractURI) external onlyOwner {
1354         contractURI = _contractURI;
1355     }
1356 
1357     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1358         require(_exists(_tokenId), "Token does not exist.");
1359         return bytes(baseURI).length > 0 ? string(
1360             abi.encodePacked(
1361               baseURI,
1362               Strings.toString(_tokenId),
1363               ".json"
1364             )
1365         ) : "";
1366     }
1367 }
1368 
1369 contract OwnableDelegateProxy {}
1370 contract ProxyRegistry {
1371     mapping(address => OwnableDelegateProxy) public proxies;
1372 }