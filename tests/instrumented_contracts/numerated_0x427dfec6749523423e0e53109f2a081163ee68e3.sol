1 /*
2 ┌───────┐        ┌─┐                       ┌────────┐
3 └──┐ ┌──┘        | |                       |      ○ | 
4    | |           | |                       |        | 
5    | |         __| |   ___    _  __        |        | 
6    | |   ●   / __  |  / _ \  | |/ / ●      |  FIND  | 
7 __ | |  ┌─┐ / /  | | | | | | |  /  ┌─┐     |  YOUR  |          
8 \ \/ /  | | | \__| | | |_| | | |   | |     | SELFIE | 
9  \__/   |_|  \_____|  \___/  |_|   |_|     └────────┘
10 
11 */
12 // SPDX-License-Identifier: MIT
13 
14 // File: erc721a/contracts/IERC721A.sol
15 
16 
17 // ERC721A Contracts v4.0.0
18 // Creator: Chiru Labs
19 
20 pragma solidity ^0.8.4;
21 
22 /**
23  * @dev Interface of an ERC721A compliant contract.
24  */
25 interface IERC721A {
26     /**
27      * The caller must own the token or be an approved operator.
28      */
29     error ApprovalCallerNotOwnerNorApproved();
30 
31     /**
32      * The token does not exist.
33      */
34     error ApprovalQueryForNonexistentToken();
35 
36     /**
37      * The caller cannot approve to their own address.
38      */
39     error ApproveToCaller();
40 
41     /**
42      * The caller cannot approve to the current owner.
43      */
44     error ApprovalToCurrentOwner();
45 
46     /**
47      * Cannot query the balance for the zero address.
48      */
49     error BalanceQueryForZeroAddress();
50 
51     /**
52      * Cannot mint to the zero address.
53      */
54     error MintToZeroAddress();
55 
56     /**
57      * The quantity of tokens minted must be more than zero.
58      */
59     error MintZeroQuantity();
60 
61     /**
62      * The token does not exist.
63      */
64     error OwnerQueryForNonexistentToken();
65 
66     /**
67      * The caller must own the token or be an approved operator.
68      */
69     error TransferCallerNotOwnerNorApproved();
70 
71     /**
72      * The token must be owned by `from`.
73      */
74     error TransferFromIncorrectOwner();
75 
76     /**
77      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
78      */
79     error TransferToNonERC721ReceiverImplementer();
80 
81     /**
82      * Cannot transfer to the zero address.
83      */
84     error TransferToZeroAddress();
85 
86     /**
87      * The token does not exist.
88      */
89     error URIQueryForNonexistentToken();
90 
91     struct TokenOwnership {
92         // The address of the owner.
93         address addr;
94         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
95         uint64 startTimestamp;
96         // Whether the token has been burned.
97         bool burned;
98     }
99 
100     /**
101      * @dev Returns the total amount of tokens stored by the contract.
102      *
103      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     // ==============================
108     //            IERC165
109     // ==============================
110 
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 
121     // ==============================
122     //            IERC721
123     // ==============================
124 
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in ``owner``'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
176      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must exist and be owned by `from`.
183      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
185      *
186      * Emits a {Transfer} event.
187      */
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId
192     ) external;
193 
194     /**
195      * @dev Transfers `tokenId` token from `from` to `to`.
196      *
197      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must be owned by `from`.
204      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external;
213 
214     /**
215      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
216      * The approval is cleared when the token is transferred.
217      *
218      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns the account approved for `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function getApproved(uint256 tokenId) external view returns (address operator);
249 
250     /**
251      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
252      *
253      * See {setApprovalForAll}
254      */
255     function isApprovedForAll(address owner, address operator) external view returns (bool);
256 
257     // ==============================
258     //        IERC721Metadata
259     // ==============================
260 
261     /**
262      * @dev Returns the token collection name.
263      */
264     function name() external view returns (string memory);
265 
266     /**
267      * @dev Returns the token collection symbol.
268      */
269     function symbol() external view returns (string memory);
270 
271     /**
272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
273      */
274     function tokenURI(uint256 tokenId) external view returns (string memory);
275 }
276 
277 // File: erc721a/contracts/ERC721A.sol
278 
279 
280 // ERC721A Contracts v4.0.0
281 // Creator: Chiru Labs
282 
283 pragma solidity ^0.8.4;
284 
285 
286 /**
287  * @dev ERC721 token receiver interface.
288  */
289 interface ERC721A__IERC721Receiver {
290     function onERC721Received(
291         address operator,
292         address from,
293         uint256 tokenId,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 /**
299  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
300  * the Metadata extension. Built to optimize for lower gas during batch mints.
301  *
302  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
303  *
304  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
305  *
306  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
307  */
308 contract ERC721A is IERC721A {
309     // Mask of an entry in packed address data.
310     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
311 
312     // The bit position of `numberMinted` in packed address data.
313     uint256 private constant BITPOS_NUMBER_MINTED = 64;
314 
315     // The bit position of `numberBurned` in packed address data.
316     uint256 private constant BITPOS_NUMBER_BURNED = 128;
317 
318     // The bit position of `aux` in packed address data.
319     uint256 private constant BITPOS_AUX = 192;
320 
321     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
322     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
323 
324     // The bit position of `startTimestamp` in packed ownership.
325     uint256 private constant BITPOS_START_TIMESTAMP = 160;
326 
327     // The bit mask of the `burned` bit in packed ownership.
328     uint256 private constant BITMASK_BURNED = 1 << 224;
329     
330     // The bit position of the `nextInitialized` bit in packed ownership.
331     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
332 
333     // The bit mask of the `nextInitialized` bit in packed ownership.
334     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
335 
336     // The tokenId of the next token to be minted.
337     uint256 private _currentIndex;
338 
339     // The number of tokens burned.
340     uint256 private _burnCounter;
341 
342     // Token name
343     string private _name;
344 
345     // Token symbol
346     string private _symbol;
347 
348     // Mapping from token ID to ownership details
349     // An empty struct value does not necessarily mean the token is unowned.
350     // See `_packedOwnershipOf` implementation for details.
351     //
352     // Bits Layout:
353     // - [0..159]   `addr`
354     // - [160..223] `startTimestamp`
355     // - [224]      `burned`
356     // - [225]      `nextInitialized`
357     mapping(uint256 => uint256) private _packedOwnerships;
358 
359     // Mapping owner address to address data.
360     //
361     // Bits Layout:
362     // - [0..63]    `balance`
363     // - [64..127]  `numberMinted`
364     // - [128..191] `numberBurned`
365     // - [192..255] `aux`
366     mapping(address => uint256) private _packedAddressData;
367 
368     // Mapping from token ID to approved address.
369     mapping(uint256 => address) private _tokenApprovals;
370 
371     // Mapping from owner to operator approvals
372     mapping(address => mapping(address => bool)) private _operatorApprovals;
373 
374     constructor(string memory name_, string memory symbol_) {
375         _name = name_;
376         _symbol = symbol_;
377         _currentIndex = _startTokenId();
378     }
379 
380     /**
381      * @dev Returns the starting token ID. 
382      * To change the starting token ID, please override this function.
383      */
384     function _startTokenId() internal view virtual returns (uint256) {
385         return 0;
386     }
387 
388     /**
389      * @dev Returns the next token ID to be minted.
390      */
391     function _nextTokenId() internal view returns (uint256) {
392         return _currentIndex;
393     }
394 
395     /**
396      * @dev Returns the total number of tokens in existence.
397      * Burned tokens will reduce the count. 
398      * To get the total number of tokens minted, please see `_totalMinted`.
399      */
400     function totalSupply() public view override returns (uint256) {
401         // Counter underflow is impossible as _burnCounter cannot be incremented
402         // more than `_currentIndex - _startTokenId()` times.
403         unchecked {
404             return _currentIndex - _burnCounter - _startTokenId();
405         }
406     }
407 
408     /**
409      * @dev Returns the total amount of tokens minted in the contract.
410      */
411     function _totalMinted() internal view returns (uint256) {
412         // Counter underflow is impossible as _currentIndex does not decrement,
413         // and it is initialized to `_startTokenId()`
414         unchecked {
415             return _currentIndex - _startTokenId();
416         }
417     }
418 
419     /**
420      * @dev Returns the total number of tokens burned.
421      */
422     function _totalBurned() internal view returns (uint256) {
423         return _burnCounter;
424     }
425 
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430         // The interface IDs are constants representing the first 4 bytes of the XOR of
431         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
432         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
433         return
434             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
435             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
436             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
437     }
438 
439     /**
440      * @dev See {IERC721-balanceOf}.
441      */
442     function balanceOf(address owner) public view override returns (uint256) {
443         if (owner == address(0)) revert BalanceQueryForZeroAddress();
444         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
445     }
446 
447     /**
448      * Returns the number of tokens minted by `owner`.
449      */
450     function _numberMinted(address owner) internal view returns (uint256) {
451         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
452     }
453 
454     /**
455      * Returns the number of tokens burned by or on behalf of `owner`.
456      */
457     function _numberBurned(address owner) internal view returns (uint256) {
458         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
459     }
460 
461     /**
462      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
463      */
464     function _getAux(address owner) internal view returns (uint64) {
465         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
466     }
467 
468     /**
469      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
470      * If there are multiple variables, please pack them into a uint64.
471      */
472     function _setAux(address owner, uint64 aux) internal {
473         uint256 packed = _packedAddressData[owner];
474         uint256 auxCasted;
475         assembly { // Cast aux without masking.
476             auxCasted := aux
477         }
478         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
479         _packedAddressData[owner] = packed;
480     }
481 
482     /**
483      * Returns the packed ownership data of `tokenId`.
484      */
485     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
486         uint256 curr = tokenId;
487 
488         unchecked {
489             if (_startTokenId() <= curr)
490                 if (curr < _currentIndex) {
491                     uint256 packed = _packedOwnerships[curr];
492                     // If not burned.
493                     if (packed & BITMASK_BURNED == 0) {
494                         // Invariant:
495                         // There will always be an ownership that has an address and is not burned
496                         // before an ownership that does not have an address and is not burned.
497                         // Hence, curr will not underflow.
498                         //
499                         // We can directly compare the packed value.
500                         // If the address is zero, packed is zero.
501                         while (packed == 0) {
502                             packed = _packedOwnerships[--curr];
503                         }
504                         return packed;
505                     }
506                 }
507         }
508         revert OwnerQueryForNonexistentToken();
509     }
510 
511     /**
512      * Returns the unpacked `TokenOwnership` struct from `packed`.
513      */
514     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
515         ownership.addr = address(uint160(packed));
516         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
517         ownership.burned = packed & BITMASK_BURNED != 0;
518     }
519 
520     /**
521      * Returns the unpacked `TokenOwnership` struct at `index`.
522      */
523     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
524         return _unpackedOwnership(_packedOwnerships[index]);
525     }
526 
527     /**
528      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
529      */
530     function _initializeOwnershipAt(uint256 index) internal {
531         if (_packedOwnerships[index] == 0) {
532             _packedOwnerships[index] = _packedOwnershipOf(index);
533         }
534     }
535 
536     /**
537      * Gas spent here starts off proportional to the maximum mint batch size.
538      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
539      */
540     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
541         return _unpackedOwnership(_packedOwnershipOf(tokenId));
542     }
543 
544     /**
545      * @dev See {IERC721-ownerOf}.
546      */
547     function ownerOf(uint256 tokenId) public view override returns (address) {
548         return address(uint160(_packedOwnershipOf(tokenId)));
549     }
550 
551     /**
552      * @dev See {IERC721Metadata-name}.
553      */
554     function name() public view virtual override returns (string memory) {
555         return _name;
556     }
557 
558     /**
559      * @dev See {IERC721Metadata-symbol}.
560      */
561     function symbol() public view virtual override returns (string memory) {
562         return _symbol;
563     }
564 
565     /**
566      * @dev See {IERC721Metadata-tokenURI}.
567      */
568     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
569         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
570 
571         string memory baseURI = _baseURI();
572         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
573     }
574 
575     /**
576      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
577      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
578      * by default, can be overriden in child contracts.
579      */
580     function _baseURI() internal view virtual returns (string memory) {
581         return '';
582     }
583 
584     /**
585      * @dev Casts the address to uint256 without masking.
586      */
587     function _addressToUint256(address value) private pure returns (uint256 result) {
588         assembly {
589             result := value
590         }
591     }
592 
593     /**
594      * @dev Casts the boolean to uint256 without branching.
595      */
596     function _boolToUint256(bool value) private pure returns (uint256 result) {
597         assembly {
598             result := value
599         }
600     }
601 
602     /**
603      * @dev See {IERC721-approve}.
604      */
605     function approve(address to, uint256 tokenId) public override {
606         address owner = address(uint160(_packedOwnershipOf(tokenId)));
607         if (to == owner) revert ApprovalToCurrentOwner();
608 
609         if (_msgSenderERC721A() != owner)
610             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
611                 revert ApprovalCallerNotOwnerNorApproved();
612             }
613 
614         _tokenApprovals[tokenId] = to;
615         emit Approval(owner, to, tokenId);
616     }
617 
618     /**
619      * @dev See {IERC721-getApproved}.
620      */
621     function getApproved(uint256 tokenId) public view override returns (address) {
622         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
623 
624         return _tokenApprovals[tokenId];
625     }
626 
627     /**
628      * @dev See {IERC721-setApprovalForAll}.
629      */
630     function setApprovalForAll(address operator, bool approved) public virtual override {
631         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
632 
633         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
634         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
635     }
636 
637     /**
638      * @dev See {IERC721-isApprovedForAll}.
639      */
640     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
641         return _operatorApprovals[owner][operator];
642     }
643 
644     /**
645      * @dev See {IERC721-transferFrom}.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) public virtual override {
652         _transfer(from, to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-safeTransferFrom}.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) public virtual override {
663         safeTransferFrom(from, to, tokenId, '');
664     }
665 
666     /**
667      * @dev See {IERC721-safeTransferFrom}.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes memory _data
674     ) public virtual override {
675         _transfer(from, to, tokenId);
676         if (to.code.length != 0)
677             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
678                 revert TransferToNonERC721ReceiverImplementer();
679             }
680     }
681 
682     /**
683      * @dev Returns whether `tokenId` exists.
684      *
685      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
686      *
687      * Tokens start existing when they are minted (`_mint`),
688      */
689     function _exists(uint256 tokenId) internal view returns (bool) {
690         return
691             _startTokenId() <= tokenId &&
692             tokenId < _currentIndex && // If within bounds,
693             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
694     }
695 
696     /**
697      * @dev Equivalent to `_safeMint(to, quantity, '')`.
698      */
699     function _safeMint(address to, uint256 quantity) internal {
700         _safeMint(to, quantity, '');
701     }
702 
703     /**
704      * @dev Safely mints `quantity` tokens and transfers them to `to`.
705      *
706      * Requirements:
707      *
708      * - If `to` refers to a smart contract, it must implement
709      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
710      * - `quantity` must be greater than 0.
711      *
712      * Emits a {Transfer} event.
713      */
714     function _safeMint(
715         address to,
716         uint256 quantity,
717         bytes memory _data
718     ) internal {
719         uint256 startTokenId = _currentIndex;
720         if (to == address(0)) revert MintToZeroAddress();
721         if (quantity == 0) revert MintZeroQuantity();
722 
723         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
724 
725         // Overflows are incredibly unrealistic.
726         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
727         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
728         unchecked {
729             // Updates:
730             // - `balance += quantity`.
731             // - `numberMinted += quantity`.
732             //
733             // We can directly add to the balance and number minted.
734             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
735 
736             // Updates:
737             // - `address` to the owner.
738             // - `startTimestamp` to the timestamp of minting.
739             // - `burned` to `false`.
740             // - `nextInitialized` to `quantity == 1`.
741             _packedOwnerships[startTokenId] =
742                 _addressToUint256(to) |
743                 (block.timestamp << BITPOS_START_TIMESTAMP) |
744                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
745 
746             uint256 updatedIndex = startTokenId;
747             uint256 end = updatedIndex + quantity;
748 
749             if (to.code.length != 0) {
750                 do {
751                     emit Transfer(address(0), to, updatedIndex);
752                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
753                         revert TransferToNonERC721ReceiverImplementer();
754                     }
755                 } while (updatedIndex < end);
756                 // Reentrancy protection
757                 if (_currentIndex != startTokenId) revert();
758             } else {
759                 do {
760                     emit Transfer(address(0), to, updatedIndex++);
761                 } while (updatedIndex < end);
762             }
763             _currentIndex = updatedIndex;
764         }
765         _afterTokenTransfers(address(0), to, startTokenId, quantity);
766     }
767 
768     /**
769      * @dev Mints `quantity` tokens and transfers them to `to`.
770      *
771      * Requirements:
772      *
773      * - `to` cannot be the zero address.
774      * - `quantity` must be greater than 0.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _mint(address to, uint256 quantity) internal {
779         uint256 startTokenId = _currentIndex;
780         if (to == address(0)) revert MintToZeroAddress();
781         if (quantity == 0) revert MintZeroQuantity();
782 
783         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
784 
785         // Overflows are incredibly unrealistic.
786         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
787         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
788         unchecked {
789             // Updates:
790             // - `balance += quantity`.
791             // - `numberMinted += quantity`.
792             //
793             // We can directly add to the balance and number minted.
794             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
795 
796             // Updates:
797             // - `address` to the owner.
798             // - `startTimestamp` to the timestamp of minting.
799             // - `burned` to `false`.
800             // - `nextInitialized` to `quantity == 1`.
801             _packedOwnerships[startTokenId] =
802                 _addressToUint256(to) |
803                 (block.timestamp << BITPOS_START_TIMESTAMP) |
804                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
805 
806             uint256 updatedIndex = startTokenId;
807             uint256 end = updatedIndex + quantity;
808 
809             do {
810                 emit Transfer(address(0), to, updatedIndex++);
811             } while (updatedIndex < end);
812 
813             _currentIndex = updatedIndex;
814         }
815         _afterTokenTransfers(address(0), to, startTokenId, quantity);
816     }
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _transfer(
829         address from,
830         address to,
831         uint256 tokenId
832     ) private {
833         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
834 
835         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
836 
837         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
838             isApprovedForAll(from, _msgSenderERC721A()) ||
839             getApproved(tokenId) == _msgSenderERC721A());
840 
841         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
842         if (to == address(0)) revert TransferToZeroAddress();
843 
844         _beforeTokenTransfers(from, to, tokenId, 1);
845 
846         // Clear approvals from the previous owner.
847         delete _tokenApprovals[tokenId];
848 
849         // Underflow of the sender's balance is impossible because we check for
850         // ownership above and the recipient's balance can't realistically overflow.
851         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
852         unchecked {
853             // We can directly increment and decrement the balances.
854             --_packedAddressData[from]; // Updates: `balance -= 1`.
855             ++_packedAddressData[to]; // Updates: `balance += 1`.
856 
857             // Updates:
858             // - `address` to the next owner.
859             // - `startTimestamp` to the timestamp of transfering.
860             // - `burned` to `false`.
861             // - `nextInitialized` to `true`.
862             _packedOwnerships[tokenId] =
863                 _addressToUint256(to) |
864                 (block.timestamp << BITPOS_START_TIMESTAMP) |
865                 BITMASK_NEXT_INITIALIZED;
866 
867             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
868             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
869                 uint256 nextTokenId = tokenId + 1;
870                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
871                 if (_packedOwnerships[nextTokenId] == 0) {
872                     // If the next slot is within bounds.
873                     if (nextTokenId != _currentIndex) {
874                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
875                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
876                     }
877                 }
878             }
879         }
880 
881         emit Transfer(from, to, tokenId);
882         _afterTokenTransfers(from, to, tokenId, 1);
883     }
884 
885     /**
886      * @dev Equivalent to `_burn(tokenId, false)`.
887      */
888     function _burn(uint256 tokenId) internal virtual {
889         _burn(tokenId, false);
890     }
891 
892     /**
893      * @dev Destroys `tokenId`.
894      * The approval is cleared when the token is burned.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
903         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
904 
905         address from = address(uint160(prevOwnershipPacked));
906 
907         if (approvalCheck) {
908             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
909                 isApprovedForAll(from, _msgSenderERC721A()) ||
910                 getApproved(tokenId) == _msgSenderERC721A());
911 
912             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
913         }
914 
915         _beforeTokenTransfers(from, address(0), tokenId, 1);
916 
917         // Clear approvals from the previous owner.
918         delete _tokenApprovals[tokenId];
919 
920         // Underflow of the sender's balance is impossible because we check for
921         // ownership above and the recipient's balance can't realistically overflow.
922         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
923         unchecked {
924             // Updates:
925             // - `balance -= 1`.
926             // - `numberBurned += 1`.
927             //
928             // We can directly decrement the balance, and increment the number burned.
929             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
930             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
931 
932             // Updates:
933             // - `address` to the last owner.
934             // - `startTimestamp` to the timestamp of burning.
935             // - `burned` to `true`.
936             // - `nextInitialized` to `true`.
937             _packedOwnerships[tokenId] =
938                 _addressToUint256(from) |
939                 (block.timestamp << BITPOS_START_TIMESTAMP) |
940                 BITMASK_BURNED | 
941                 BITMASK_NEXT_INITIALIZED;
942 
943             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
944             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
945                 uint256 nextTokenId = tokenId + 1;
946                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
947                 if (_packedOwnerships[nextTokenId] == 0) {
948                     // If the next slot is within bounds.
949                     if (nextTokenId != _currentIndex) {
950                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
951                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
952                     }
953                 }
954             }
955         }
956 
957         emit Transfer(from, address(0), tokenId);
958         _afterTokenTransfers(from, address(0), tokenId, 1);
959 
960         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
961         unchecked {
962             _burnCounter++;
963         }
964     }
965 
966     /**
967      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
968      *
969      * @param from address representing the previous owner of the given token ID
970      * @param to target address that will receive the tokens
971      * @param tokenId uint256 ID of the token to be transferred
972      * @param _data bytes optional data to send along with the call
973      * @return bool whether the call correctly returned the expected magic value
974      */
975     function _checkContractOnERC721Received(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) private returns (bool) {
981         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
982             bytes4 retval
983         ) {
984             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
985         } catch (bytes memory reason) {
986             if (reason.length == 0) {
987                 revert TransferToNonERC721ReceiverImplementer();
988             } else {
989                 assembly {
990                     revert(add(32, reason), mload(reason))
991                 }
992             }
993         }
994     }
995 
996     /**
997      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
998      * And also called before burning one token.
999      *
1000      * startTokenId - the first token id to be transferred
1001      * quantity - the amount to be transferred
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` will be minted for `to`.
1008      * - When `to` is zero, `tokenId` will be burned by `from`.
1009      * - `from` and `to` are never both zero.
1010      */
1011     function _beforeTokenTransfers(
1012         address from,
1013         address to,
1014         uint256 startTokenId,
1015         uint256 quantity
1016     ) internal virtual {}
1017 
1018     /**
1019      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1020      * minting.
1021      * And also called after one token has been burned.
1022      *
1023      * startTokenId - the first token id to be transferred
1024      * quantity - the amount to be transferred
1025      *
1026      * Calling conditions:
1027      *
1028      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1029      * transferred to `to`.
1030      * - When `from` is zero, `tokenId` has been minted for `to`.
1031      * - When `to` is zero, `tokenId` has been burned by `from`.
1032      * - `from` and `to` are never both zero.
1033      */
1034     function _afterTokenTransfers(
1035         address from,
1036         address to,
1037         uint256 startTokenId,
1038         uint256 quantity
1039     ) internal virtual {}
1040 
1041     /**
1042      * @dev Returns the message sender (defaults to `msg.sender`).
1043      *
1044      * If you are writing GSN compatible contracts, you need to override this function.
1045      */
1046     function _msgSenderERC721A() internal view virtual returns (address) {
1047         return msg.sender;
1048     }
1049 
1050     /**
1051      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1052      */
1053     function _toString(uint256 value) internal pure returns (string memory ptr) {
1054         assembly {
1055             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1056             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1057             // We will need 1 32-byte word to store the length, 
1058             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1059             ptr := add(mload(0x40), 128)
1060             // Update the free memory pointer to allocate.
1061             mstore(0x40, ptr)
1062 
1063             // Cache the end of the memory to calculate the length later.
1064             let end := ptr
1065 
1066             // We write the string from the rightmost digit to the leftmost digit.
1067             // The following is essentially a do-while loop that also handles the zero case.
1068             // Costs a bit more than early returning for the zero case,
1069             // but cheaper in terms of deployment and overall runtime costs.
1070             for { 
1071                 // Initialize and perform the first pass without check.
1072                 let temp := value
1073                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1074                 ptr := sub(ptr, 1)
1075                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1076                 mstore8(ptr, add(48, mod(temp, 10)))
1077                 temp := div(temp, 10)
1078             } temp { 
1079                 // Keep dividing `temp` until zero.
1080                 temp := div(temp, 10)
1081             } { // Body of the for loop.
1082                 ptr := sub(ptr, 1)
1083                 mstore8(ptr, add(48, mod(temp, 10)))
1084             }
1085             
1086             let length := sub(end, ptr)
1087             // Move the pointer 32 bytes leftwards to make room for the length.
1088             ptr := sub(ptr, 32)
1089             // Store the length.
1090             mstore(ptr, length)
1091         }
1092     }
1093 }
1094 
1095 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 /**
1103  * @dev Contract module that helps prevent reentrant calls to a function.
1104  *
1105  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1106  * available, which can be applied to functions to make sure there are no nested
1107  * (reentrant) calls to them.
1108  *
1109  * Note that because there is a single `nonReentrant` guard, functions marked as
1110  * `nonReentrant` may not call one another. This can be worked around by making
1111  * those functions `private`, and then adding `external` `nonReentrant` entry
1112  * points to them.
1113  *
1114  * TIP: If you would like to learn more about reentrancy and alternative ways
1115  * to protect against it, check out our blog post
1116  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1117  */
1118 abstract contract ReentrancyGuard {
1119     // Booleans are more expensive than uint256 or any type that takes up a full
1120     // word because each write operation emits an extra SLOAD to first read the
1121     // slot's contents, replace the bits taken up by the boolean, and then write
1122     // back. This is the compiler's defense against contract upgrades and
1123     // pointer aliasing, and it cannot be disabled.
1124 
1125     // The values being non-zero value makes deployment a bit more expensive,
1126     // but in exchange the refund on every call to nonReentrant will be lower in
1127     // amount. Since refunds are capped to a percentage of the total
1128     // transaction's gas, it is best to keep them low in cases like this one, to
1129     // increase the likelihood of the full refund coming into effect.
1130     uint256 private constant _NOT_ENTERED = 1;
1131     uint256 private constant _ENTERED = 2;
1132 
1133     uint256 private _status;
1134 
1135     constructor() {
1136         _status = _NOT_ENTERED;
1137     }
1138 
1139     /**
1140      * @dev Prevents a contract from calling itself, directly or indirectly.
1141      * Calling a `nonReentrant` function from another `nonReentrant`
1142      * function is not supported. It is possible to prevent this from happening
1143      * by making the `nonReentrant` function external, and making it call a
1144      * `private` function that does the actual work.
1145      */
1146     modifier nonReentrant() {
1147         // On the first call to nonReentrant, _notEntered will be true
1148         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1149 
1150         // Any calls to nonReentrant after this point will fail
1151         _status = _ENTERED;
1152 
1153         _;
1154 
1155         // By storing the original value once again, a refund is triggered (see
1156         // https://eips.ethereum.org/EIPS/eip-2200)
1157         _status = _NOT_ENTERED;
1158     }
1159 }
1160 
1161 // File: @openzeppelin/contracts/utils/Context.sol
1162 
1163 
1164 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 /**
1169  * @dev Provides information about the current execution context, including the
1170  * sender of the transaction and its data. While these are generally available
1171  * via msg.sender and msg.data, they should not be accessed in such a direct
1172  * manner, since when dealing with meta-transactions the account sending and
1173  * paying for execution may not be the actual sender (as far as an application
1174  * is concerned).
1175  *
1176  * This contract is only required for intermediate, library-like contracts.
1177  */
1178 abstract contract Context {
1179     function _msgSender() internal view virtual returns (address) {
1180         return msg.sender;
1181     }
1182 
1183     function _msgData() internal view virtual returns (bytes calldata) {
1184         return msg.data;
1185     }
1186 }
1187 
1188 // File: @openzeppelin/contracts/access/Ownable.sol
1189 
1190 
1191 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 
1196 /**
1197  * @dev Contract module which provides a basic access control mechanism, where
1198  * there is an account (an owner) that can be granted exclusive access to
1199  * specific functions.
1200  *
1201  * By default, the owner account will be the one that deploys the contract. This
1202  * can later be changed with {transferOwnership}.
1203  *
1204  * This module is used through inheritance. It will make available the modifier
1205  * `onlyOwner`, which can be applied to your functions to restrict their use to
1206  * the owner.
1207  */
1208 abstract contract Ownable is Context {
1209     address private _owner;
1210 
1211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1212 
1213     /**
1214      * @dev Initializes the contract setting the deployer as the initial owner.
1215      */
1216     constructor() {
1217         _transferOwnership(_msgSender());
1218     }
1219 
1220     /**
1221      * @dev Returns the address of the current owner.
1222      */
1223     function owner() public view virtual returns (address) {
1224         return _owner;
1225     }
1226 
1227     /**
1228      * @dev Throws if called by any account other than the owner.
1229      */
1230     modifier onlyOwner() {
1231         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Leaves the contract without owner. It will not be possible to call
1237      * `onlyOwner` functions anymore. Can only be called by the current owner.
1238      *
1239      * NOTE: Renouncing ownership will leave the contract without an owner,
1240      * thereby removing any functionality that is only available to the owner.
1241      */
1242     function renounceOwnership() public virtual onlyOwner {
1243         _transferOwnership(address(0));
1244     }
1245 
1246     /**
1247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1248      * Can only be called by the current owner.
1249      */
1250     function transferOwnership(address newOwner) public virtual onlyOwner {
1251         require(newOwner != address(0), "Ownable: new owner is the zero address");
1252         _transferOwnership(newOwner);
1253     }
1254 
1255     /**
1256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1257      * Internal function without access restriction.
1258      */
1259     function _transferOwnership(address newOwner) internal virtual {
1260         address oldOwner = _owner;
1261         _owner = newOwner;
1262         emit OwnershipTransferred(oldOwner, newOwner);
1263     }
1264 }
1265 
1266 // File: contracts/jidori_boy.sol
1267 
1268 
1269 pragma solidity ^0.8.4;
1270 
1271 
1272 
1273 
1274 contract JidoriBoy is Ownable, ERC721A, ReentrancyGuard {
1275     mapping(address => uint256) public buyed;
1276     uint256 public freeMintSlots = 0;
1277 
1278     struct JidoriConfig {
1279         uint256 stage;
1280         uint256 publicSaleMaxMint;
1281         uint256 publicSalePrice;
1282         uint256 maxSupply;
1283     }
1284 
1285     JidoriConfig public jidoriConfig;
1286 
1287     constructor() ERC721A("Jidori Boy", "JIDORI-BOY") {
1288         initConfig(1, 1, 12500000000000000, 3950);
1289     }
1290 
1291     function initConfig(
1292         uint256 stage,
1293         uint256 publicSaleMaxMint,
1294         uint256 publicSalePrice,
1295         uint256 maxSupply
1296     ) private onlyOwner {
1297         jidoriConfig.stage = stage;
1298         jidoriConfig.publicSaleMaxMint = publicSaleMaxMint;
1299         jidoriConfig.publicSalePrice = publicSalePrice;
1300         jidoriConfig.maxSupply = maxSupply;
1301     }
1302 
1303     function airdrop(address[] calldata addresses, uint256[] calldata quantity) external onlyOwner airdropEnabled nonReentrant {
1304         for (uint256 i; i < addresses.length; ++i) {
1305             _mint(addresses[i], quantity[i]);
1306         }
1307     }
1308 
1309     function devMint(uint256 quantity) external onlyOwner {
1310         require(
1311             totalSupply() + quantity <= getMaxSupply(),
1312             "Insufficient quantity left."
1313         );
1314 
1315         _safeMint(msg.sender, quantity);
1316     }
1317 
1318     function mint(uint256 quantity) external saleEnabled payable {
1319         JidoriConfig memory config = jidoriConfig;
1320         uint256 publicSalePrice = uint256(config.publicSalePrice);
1321         uint256 publicSaleMaxMint = uint256(config.publicSaleMaxMint);
1322 
1323         require(
1324             totalSupply() + quantity <= getMaxSupply(),
1325             "Insufficient quantity left."
1326         );
1327         require(
1328             getAddressBuyed(msg.sender) + quantity <= publicSaleMaxMint,
1329             "You mint too much."
1330         );
1331 
1332         if (freeMintSlots <= 0) {
1333             require(
1334                 quantity * publicSalePrice <= msg.value,
1335                 "Insufficient balance."
1336             );
1337         } else {
1338             freeMintSlots -= quantity;
1339         }
1340 
1341         _safeMint(msg.sender, quantity);
1342         buyed[msg.sender] += quantity;
1343     }
1344 
1345     function setStage(uint256 _stage) external onlyOwner {
1346         require(_stage > 2, "unable revert");
1347         jidoriConfig.stage = _stage;
1348     }
1349 
1350     function setPrice(uint256 _price) external onlyOwner {
1351         jidoriConfig.publicSalePrice = _price;
1352     }
1353 
1354     function setFreeMintSlots(uint256 _slots) external onlyOwner {
1355         freeMintSlots = _slots;
1356     }
1357 
1358     function getAddressBuyed(address owner) public view returns (uint256) {
1359         return buyed[owner];
1360     }
1361     function getStage() private view returns (uint256) {
1362         JidoriConfig memory config = jidoriConfig;
1363         uint256 stage = uint256(config.stage);
1364         return stage;
1365     }
1366     function getMaxSupply() private view returns (uint256) {
1367         JidoriConfig memory config = jidoriConfig;
1368         uint256 max = uint256(config.maxSupply);
1369         return max;
1370     }
1371 
1372     string private _baseTokenURI;
1373 
1374     function _baseURI() internal view virtual override returns (string memory) {
1375         return _baseTokenURI;
1376     }
1377 
1378     function setBaseURI(string calldata baseURI) external onlyOwner {
1379         _baseTokenURI = baseURI;
1380     }
1381 
1382     function withdraw() external onlyOwner nonReentrant {
1383         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1384         require(success, "Transfer failed.");
1385     }
1386 
1387     // modifiers
1388     modifier airdropEnabled() {
1389         require(getStage() == 1, "Unable to airdrop.");
1390         _;
1391     }
1392 
1393     modifier saleEnabled() {
1394         require(getStage() == 3, "Unable to mint.");
1395         _;
1396     }
1397 }