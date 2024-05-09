1 // File: contracts/goblinbucks.sol
2 
3 /*
4 ╔═══╗╔══╗╔══╗─╔╗──╔══╗╔╗─╔╗───
5 ║╔══╝║╔╗║║╔╗║─║║──╚╗╔╝║╚═╝║───
6 ║║╔═╗║║║║║╚╝╚╗║║───║║─║╔╗─║───
7 ║║╚╗║║║║║║╔═╗║║║───║║─║║╚╗║───
8 ║╚═╝║║╚╝║║╚═╝║║╚═╗╔╝╚╗║║─║║───
9 ╚═══╝╚══╝╚═══╝╚══╝╚══╝╚╝─╚╝───
10 
11 ╔══╗─╔╗╔╗╔══╗╔╗╔══╗╔══╗
12 ║╔╗║─║║║║║╔═╝║║║╔═╝║╔═╝
13 ║╚╝╚╗║║║║║║──║╚╝║──║╚═╗
14 ║╔═╗║║║║║║║──║╔╗║──╚═╗║
15 ║╚═╝║║╚╝║║╚═╗║║║╚═╗╔═╝║
16 ╚═══╝╚══╝╚══╝╚╝╚══╝╚══╝
17 
18 */
19 
20 // ERC721A Contracts v3.3.0
21 pragma solidity ^0.8.4;
22 
23 /**
24  * @dev Interface of an ERC721A compliant contract.
25  */
26 interface IERC721A {
27     /**
28      * The caller must own the token or be an approved operator.
29      */
30     error ApprovalCallerNotOwnerNorApproved();
31 
32     /**
33      * The token does not exist.
34      */
35     error ApprovalQueryForNonexistentToken();
36 
37     /**
38      * The caller cannot approve to their own address.
39      */
40     error ApproveToCaller();
41 
42     /**
43      * The caller cannot approve to the current owner.
44      */
45     error ApprovalToCurrentOwner();
46 
47     /**
48      * Cannot query the balance for the zero address.
49      */
50     error BalanceQueryForZeroAddress();
51 
52     /**
53      * Cannot mint to the zero address.
54      */
55     error MintToZeroAddress();
56 
57     /**
58      * The quantity of tokens minted must be more than zero.
59      */
60     error MintZeroQuantity();
61 
62     /**
63      * The token does not exist.
64      */
65     error OwnerQueryForNonexistentToken();
66 
67     /**
68      * The caller must own the token or be an approved operator.
69      */
70     error TransferCallerNotOwnerNorApproved();
71 
72     /**
73      * The token must be owned by `from`.
74      */
75     error TransferFromIncorrectOwner();
76 
77     /**
78      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
79      */
80     error TransferToNonERC721ReceiverImplementer();
81 
82     /**
83      * Cannot transfer to the zero address.
84      */
85     error TransferToZeroAddress();
86 
87     /**
88      * The token does not exist.
89      */
90     error URIQueryForNonexistentToken();
91 
92     struct TokenOwnership {
93         // The address of the owner.
94         address addr;
95         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
96         uint64 startTimestamp;
97         // Whether the token has been burned.
98         bool burned;
99     }
100 
101     /**
102      * @dev Returns the total amount of tokens stored by the contract.
103      *
104      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // ==============================
109     //            IERC165
110     // ==============================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // ==============================
123     //            IERC721
124     // ==============================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in ``owner``'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Approve or remove `operator` as an operator for the caller.
232      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // ==============================
259     //        IERC721Metadata
260     // ==============================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 }
277 
278 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
279 
280 
281 // ERC721A Contracts v3.3.0
282 // Creator: Chiru Labs
283 
284 pragma solidity ^0.8.4;
285 
286 
287 /**
288  * @dev ERC721 token receiver interface.
289  */
290 interface ERC721A__IERC721Receiver {
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 /**
300  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
301  * the Metadata extension. Built to optimize for lower gas during batch mints.
302  *
303  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
304  *
305  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
306  *
307  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
308  */
309 contract ERC721A is IERC721A {
310     // Mask of an entry in packed address data.
311     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
312 
313     // The bit position of `numberMinted` in packed address data.
314     uint256 private constant BITPOS_NUMBER_MINTED = 64;
315 
316     // The bit position of `numberBurned` in packed address data.
317     uint256 private constant BITPOS_NUMBER_BURNED = 128;
318 
319     // The bit position of `aux` in packed address data.
320     uint256 private constant BITPOS_AUX = 192;
321 
322     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
323     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
324 
325     // The bit position of `startTimestamp` in packed ownership.
326     uint256 private constant BITPOS_START_TIMESTAMP = 160;
327 
328     // The bit mask of the `burned` bit in packed ownership.
329     uint256 private constant BITMASK_BURNED = 1 << 224;
330     
331     // The bit position of the `nextInitialized` bit in packed ownership.
332     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
333 
334     // The bit mask of the `nextInitialized` bit in packed ownership.
335     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
336 
337     // The tokenId of the next token to be minted.
338     uint256 private _currentIndex;
339 
340     // The number of tokens burned.
341     uint256 private _burnCounter;
342 
343     // Token name
344     string private _name;
345 
346     // Token symbol
347     string private _symbol;
348 
349     // Mapping from token ID to ownership details
350     // An empty struct value does not necessarily mean the token is unowned.
351     // See `_packedOwnershipOf` implementation for details.
352     //
353     // Bits Layout:
354     // - [0..159]   `addr`
355     // - [160..223] `startTimestamp`
356     // - [224]      `burned`
357     // - [225]      `nextInitialized`
358     mapping(uint256 => uint256) private _packedOwnerships;
359 
360     // Mapping owner address to address data.
361     //
362     // Bits Layout:
363     // - [0..63]    `balance`
364     // - [64..127]  `numberMinted`
365     // - [128..191] `numberBurned`
366     // - [192..255] `aux`
367     mapping(address => uint256) private _packedAddressData;
368 
369     // Mapping from token ID to approved address.
370     mapping(uint256 => address) private _tokenApprovals;
371 
372     // Mapping from owner to operator approvals
373     mapping(address => mapping(address => bool)) private _operatorApprovals;
374 
375     constructor(string memory name_, string memory symbol_) {
376         _name = name_;
377         _symbol = symbol_;
378         _currentIndex = _startTokenId();
379     }
380 
381     /**
382      * @dev Returns the starting token ID. 
383      * To change the starting token ID, please override this function.
384      */
385     function _startTokenId() internal view virtual returns (uint256) {
386         return 0;
387     }
388 
389     /**
390      * @dev Returns the next token ID to be minted.
391      */
392     function _nextTokenId() internal view returns (uint256) {
393         return _currentIndex;
394     }
395 
396     /**
397      * @dev Returns the total number of tokens in existence.
398      * Burned tokens will reduce the count. 
399      * To get the total number of tokens minted, please see `_totalMinted`.
400      */
401     function totalSupply() public view override returns (uint256) {
402         // Counter underflow is impossible as _burnCounter cannot be incremented
403         // more than `_currentIndex - _startTokenId()` times.
404         unchecked {
405             return _currentIndex - _burnCounter - _startTokenId();
406         }
407     }
408 
409     /**
410      * @dev Returns the total amount of tokens minted in the contract.
411      */
412     function _totalMinted() internal view returns (uint256) {
413         // Counter underflow is impossible as _currentIndex does not decrement,
414         // and it is initialized to `_startTokenId()`
415         unchecked {
416             return _currentIndex - _startTokenId();
417         }
418     }
419 
420     /**
421      * @dev Returns the total number of tokens burned.
422      */
423     function _totalBurned() internal view returns (uint256) {
424         return _burnCounter;
425     }
426 
427     /**
428      * @dev See {IERC165-supportsInterface}.
429      */
430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431         // The interface IDs are constants representing the first 4 bytes of the XOR of
432         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
433         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
434         return
435             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
436             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
437             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
438     }
439 
440     /**
441      * @dev See {IERC721-balanceOf}.
442      */
443     function balanceOf(address owner) public view override returns (uint256) {
444         if (owner == address(0)) revert BalanceQueryForZeroAddress();
445         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
446     }
447 
448     /**
449      * Returns the number of tokens minted by `owner`.
450      */
451     function _numberMinted(address owner) internal view returns (uint256) {
452         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
453     }
454 
455     /**
456      * Returns the number of tokens burned by or on behalf of `owner`.
457      */
458     function _numberBurned(address owner) internal view returns (uint256) {
459         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
464      */
465     function _getAux(address owner) internal view returns (uint64) {
466         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
467     }
468 
469     /**
470      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
471      * If there are multiple variables, please pack them into a uint64.
472      */
473     function _setAux(address owner, uint64 aux) internal {
474         uint256 packed = _packedAddressData[owner];
475         uint256 auxCasted;
476         assembly { // Cast aux without masking.
477             auxCasted := aux
478         }
479         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
480         _packedAddressData[owner] = packed;
481     }
482 
483     /**
484      * Returns the packed ownership data of `tokenId`.
485      */
486     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
487         uint256 curr = tokenId;
488 
489         unchecked {
490             if (_startTokenId() <= curr)
491                 if (curr < _currentIndex) {
492                     uint256 packed = _packedOwnerships[curr];
493                     // If not burned.
494                     if (packed & BITMASK_BURNED == 0) {
495                         // Invariant:
496                         // There will always be an ownership that has an address and is not burned
497                         // before an ownership that does not have an address and is not burned.
498                         // Hence, curr will not underflow.
499                         //
500                         // We can directly compare the packed value.
501                         // If the address is zero, packed is zero.
502                         while (packed == 0) {
503                             packed = _packedOwnerships[--curr];
504                         }
505                         return packed;
506                     }
507                 }
508         }
509         revert OwnerQueryForNonexistentToken();
510     }
511 
512     /**
513      * Returns the unpacked `TokenOwnership` struct from `packed`.
514      */
515     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
516         ownership.addr = address(uint160(packed));
517         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
518         ownership.burned = packed & BITMASK_BURNED != 0;
519     }
520 
521     /**
522      * Returns the unpacked `TokenOwnership` struct at `index`.
523      */
524     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
525         return _unpackedOwnership(_packedOwnerships[index]);
526     }
527 
528     /**
529      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
530      */
531     function _initializeOwnershipAt(uint256 index) internal {
532         if (_packedOwnerships[index] == 0) {
533             _packedOwnerships[index] = _packedOwnershipOf(index);
534         }
535     }
536 
537     /**
538      * Gas spent here starts off proportional to the maximum mint batch size.
539      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
540      */
541     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
542         return _unpackedOwnership(_packedOwnershipOf(tokenId));
543     }
544 
545     /**
546      * @dev See {IERC721-ownerOf}.
547      */
548     function ownerOf(uint256 tokenId) public view override returns (address) {
549         return address(uint160(_packedOwnershipOf(tokenId)));
550     }
551 
552     /**
553      * @dev See {IERC721Metadata-name}.
554      */
555     function name() public view virtual override returns (string memory) {
556         return _name;
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-symbol}.
561      */
562     function symbol() public view virtual override returns (string memory) {
563         return _symbol;
564     }
565 
566     /**
567      * @dev See {IERC721Metadata-tokenURI}.
568      */
569     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
570         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
571 
572         string memory baseURI = _baseURI();
573         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
574     }
575 
576     /**
577      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
578      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
579      * by default, can be overriden in child contracts.
580      */
581     function _baseURI() internal view virtual returns (string memory) {
582         return '';
583     }
584 
585     /**
586      * @dev Casts the address to uint256 without masking.
587      */
588     function _addressToUint256(address value) private pure returns (uint256 result) {
589         assembly {
590             result := value
591         }
592     }
593 
594     /**
595      * @dev Casts the boolean to uint256 without branching.
596      */
597     function _boolToUint256(bool value) private pure returns (uint256 result) {
598         assembly {
599             result := value
600         }
601     }
602 
603     /**
604      * @dev See {IERC721-approve}.
605      */
606     function approve(address to, uint256 tokenId) public override {
607         address owner = address(uint160(_packedOwnershipOf(tokenId)));
608         if (to == owner) revert ApprovalToCurrentOwner();
609 
610         if (_msgSenderERC721A() != owner)
611             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
612                 revert ApprovalCallerNotOwnerNorApproved();
613             }
614 
615         _tokenApprovals[tokenId] = to;
616         emit Approval(owner, to, tokenId);
617     }
618 
619     /**
620      * @dev See {IERC721-getApproved}.
621      */
622     function getApproved(uint256 tokenId) public view override returns (address) {
623         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
624 
625         return _tokenApprovals[tokenId];
626     }
627 
628     /**
629      * @dev See {IERC721-setApprovalForAll}.
630      */
631     function setApprovalForAll(address operator, bool approved) public virtual override {
632         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
633 
634         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
635         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
636     }
637 
638     /**
639      * @dev See {IERC721-isApprovedForAll}.
640      */
641     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
642         return _operatorApprovals[owner][operator];
643     }
644 
645     /**
646      * @dev See {IERC721-transferFrom}.
647      */
648     function transferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) public virtual override {
653         _transfer(from, to, tokenId);
654     }
655 
656     /**
657      * @dev See {IERC721-safeTransferFrom}.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) public virtual override {
664         safeTransferFrom(from, to, tokenId, '');
665     }
666 
667     /**
668      * @dev See {IERC721-safeTransferFrom}.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId,
674         bytes memory _data
675     ) public virtual override {
676         _transfer(from, to, tokenId);
677         if (to.code.length != 0)
678             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
679                 revert TransferToNonERC721ReceiverImplementer();
680             }
681     }
682 
683     /**
684      * @dev Returns whether `tokenId` exists.
685      *
686      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
687      *
688      * Tokens start existing when they are minted (`_mint`),
689      */
690     function _exists(uint256 tokenId) internal view returns (bool) {
691         return
692             _startTokenId() <= tokenId &&
693             tokenId < _currentIndex && // If within bounds,
694             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
695     }
696 
697     /**
698      * @dev Equivalent to `_safeMint(to, quantity, '')`.
699      */
700     function _safeMint(address to, uint256 quantity) internal {
701         _safeMint(to, quantity, '');
702     }
703 
704     /**
705      * @dev Safely mints `quantity` tokens and transfers them to `to`.
706      *
707      * Requirements:
708      *
709      * - If `to` refers to a smart contract, it must implement
710      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
711      * - `quantity` must be greater than 0.
712      *
713      * Emits a {Transfer} event.
714      */
715     function _safeMint(
716         address to,
717         uint256 quantity,
718         bytes memory _data
719     ) internal {
720         uint256 startTokenId = _currentIndex;
721         if (to == address(0)) revert MintToZeroAddress();
722         if (quantity == 0) revert MintZeroQuantity();
723 
724         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
725 
726         // Overflows are incredibly unrealistic.
727         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
728         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
729         unchecked {
730             // Updates:
731             // - `balance += quantity`.
732             // - `numberMinted += quantity`.
733             //
734             // We can directly add to the balance and number minted.
735             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
736 
737             // Updates:
738             // - `address` to the owner.
739             // - `startTimestamp` to the timestamp of minting.
740             // - `burned` to `false`.
741             // - `nextInitialized` to `quantity == 1`.
742             _packedOwnerships[startTokenId] =
743                 _addressToUint256(to) |
744                 (block.timestamp << BITPOS_START_TIMESTAMP) |
745                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
746 
747             uint256 updatedIndex = startTokenId;
748             uint256 end = updatedIndex + quantity;
749 
750             if (to.code.length != 0) {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex);
753                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
754                         revert TransferToNonERC721ReceiverImplementer();
755                     }
756                 } while (updatedIndex < end);
757                 // Reentrancy protection
758                 if (_currentIndex != startTokenId) revert();
759             } else {
760                 do {
761                     emit Transfer(address(0), to, updatedIndex++);
762                 } while (updatedIndex < end);
763             }
764             _currentIndex = updatedIndex;
765         }
766         _afterTokenTransfers(address(0), to, startTokenId, quantity);
767     }
768 
769     /**
770      * @dev Mints `quantity` tokens and transfers them to `to`.
771      *
772      * Requirements:
773      *
774      * - `to` cannot be the zero address.
775      * - `quantity` must be greater than 0.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _mint(address to, uint256 quantity) internal {
780         uint256 startTokenId = _currentIndex;
781         if (to == address(0)) revert MintToZeroAddress();
782         if (quantity == 0) revert MintZeroQuantity();
783 
784         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
785 
786         // Overflows are incredibly unrealistic.
787         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
788         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
789         unchecked {
790             // Updates:
791             // - `balance += quantity`.
792             // - `numberMinted += quantity`.
793             //
794             // We can directly add to the balance and number minted.
795             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
796 
797             // Updates:
798             // - `address` to the owner.
799             // - `startTimestamp` to the timestamp of minting.
800             // - `burned` to `false`.
801             // - `nextInitialized` to `quantity == 1`.
802             _packedOwnerships[startTokenId] =
803                 _addressToUint256(to) |
804                 (block.timestamp << BITPOS_START_TIMESTAMP) |
805                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
806 
807             uint256 updatedIndex = startTokenId;
808             uint256 end = updatedIndex + quantity;
809 
810             do {
811                 emit Transfer(address(0), to, updatedIndex++);
812             } while (updatedIndex < end);
813 
814             _currentIndex = updatedIndex;
815         }
816         _afterTokenTransfers(address(0), to, startTokenId, quantity);
817     }
818 
819     /**
820      * @dev Transfers `tokenId` from `from` to `to`.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _transfer(
830         address from,
831         address to,
832         uint256 tokenId
833     ) private {
834         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
835 
836         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
837 
838         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
839             isApprovedForAll(from, _msgSenderERC721A()) ||
840             getApproved(tokenId) == _msgSenderERC721A());
841 
842         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
843         if (to == address(0)) revert TransferToZeroAddress();
844 
845         _beforeTokenTransfers(from, to, tokenId, 1);
846 
847         // Clear approvals from the previous owner.
848         delete _tokenApprovals[tokenId];
849 
850         // Underflow of the sender's balance is impossible because we check for
851         // ownership above and the recipient's balance can't realistically overflow.
852         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
853         unchecked {
854             // We can directly increment and decrement the balances.
855             --_packedAddressData[from]; // Updates: `balance -= 1`.
856             ++_packedAddressData[to]; // Updates: `balance += 1`.
857 
858             // Updates:
859             // - `address` to the next owner.
860             // - `startTimestamp` to the timestamp of transfering.
861             // - `burned` to `false`.
862             // - `nextInitialized` to `true`.
863             _packedOwnerships[tokenId] =
864                 _addressToUint256(to) |
865                 (block.timestamp << BITPOS_START_TIMESTAMP) |
866                 BITMASK_NEXT_INITIALIZED;
867 
868             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
869             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
870                 uint256 nextTokenId = tokenId + 1;
871                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
872                 if (_packedOwnerships[nextTokenId] == 0) {
873                     // If the next slot is within bounds.
874                     if (nextTokenId != _currentIndex) {
875                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
876                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
877                     }
878                 }
879             }
880         }
881 
882         emit Transfer(from, to, tokenId);
883         _afterTokenTransfers(from, to, tokenId, 1);
884     }
885 
886     /**
887      * @dev Equivalent to `_burn(tokenId, false)`.
888      */
889     function _burn(uint256 tokenId) internal virtual {
890         _burn(tokenId, false);
891     }
892 
893     /**
894      * @dev Destroys `tokenId`.
895      * The approval is cleared when the token is burned.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
904         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
905 
906         address from = address(uint160(prevOwnershipPacked));
907 
908         if (approvalCheck) {
909             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
910                 isApprovedForAll(from, _msgSenderERC721A()) ||
911                 getApproved(tokenId) == _msgSenderERC721A());
912 
913             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
914         }
915 
916         _beforeTokenTransfers(from, address(0), tokenId, 1);
917 
918         // Clear approvals from the previous owner.
919         delete _tokenApprovals[tokenId];
920 
921         // Underflow of the sender's balance is impossible because we check for
922         // ownership above and the recipient's balance can't realistically overflow.
923         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
924         unchecked {
925             // Updates:
926             // - `balance -= 1`.
927             // - `numberBurned += 1`.
928             //
929             // We can directly decrement the balance, and increment the number burned.
930             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
931             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
932 
933             // Updates:
934             // - `address` to the last owner.
935             // - `startTimestamp` to the timestamp of burning.
936             // - `burned` to `true`.
937             // - `nextInitialized` to `true`.
938             _packedOwnerships[tokenId] =
939                 _addressToUint256(from) |
940                 (block.timestamp << BITPOS_START_TIMESTAMP) |
941                 BITMASK_BURNED | 
942                 BITMASK_NEXT_INITIALIZED;
943 
944             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
945             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
946                 uint256 nextTokenId = tokenId + 1;
947                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
948                 if (_packedOwnerships[nextTokenId] == 0) {
949                     // If the next slot is within bounds.
950                     if (nextTokenId != _currentIndex) {
951                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
952                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
953                     }
954                 }
955             }
956         }
957 
958         emit Transfer(from, address(0), tokenId);
959         _afterTokenTransfers(from, address(0), tokenId, 1);
960 
961         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
962         unchecked {
963             _burnCounter++;
964         }
965     }
966 
967     /**
968      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
969      *
970      * @param from address representing the previous owner of the given token ID
971      * @param to target address that will receive the tokens
972      * @param tokenId uint256 ID of the token to be transferred
973      * @param _data bytes optional data to send along with the call
974      * @return bool whether the call correctly returned the expected magic value
975      */
976     function _checkContractOnERC721Received(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) private returns (bool) {
982         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
983             bytes4 retval
984         ) {
985             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
986         } catch (bytes memory reason) {
987             if (reason.length == 0) {
988                 revert TransferToNonERC721ReceiverImplementer();
989             } else {
990                 assembly {
991                     revert(add(32, reason), mload(reason))
992                 }
993             }
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
999      * And also called before burning one token.
1000      *
1001      * startTokenId - the first token id to be transferred
1002      * quantity - the amount to be transferred
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` will be minted for `to`.
1009      * - When `to` is zero, `tokenId` will be burned by `from`.
1010      * - `from` and `to` are never both zero.
1011      */
1012     function _beforeTokenTransfers(
1013         address from,
1014         address to,
1015         uint256 startTokenId,
1016         uint256 quantity
1017     ) internal virtual {}
1018 
1019     /**
1020      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1021      * minting.
1022      * And also called after one token has been burned.
1023      *
1024      * startTokenId - the first token id to be transferred
1025      * quantity - the amount to be transferred
1026      *
1027      * Calling conditions:
1028      *
1029      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1030      * transferred to `to`.
1031      * - When `from` is zero, `tokenId` has been minted for `to`.
1032      * - When `to` is zero, `tokenId` has been burned by `from`.
1033      * - `from` and `to` are never both zero.
1034      */
1035     function _afterTokenTransfers(
1036         address from,
1037         address to,
1038         uint256 startTokenId,
1039         uint256 quantity
1040     ) internal virtual {}
1041 
1042     /**
1043      * @dev Returns the message sender (defaults to `msg.sender`).
1044      *
1045      * If you are writing GSN compatible contracts, you need to override this function.
1046      */
1047     function _msgSenderERC721A() internal view virtual returns (address) {
1048         return msg.sender;
1049     }
1050 
1051     /**
1052      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1053      */
1054     function _toString(uint256 value) internal pure returns (string memory ptr) {
1055         assembly {
1056             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1057             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1058             // We will need 1 32-byte word to store the length, 
1059             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1060             ptr := add(mload(0x40), 128)
1061             // Update the free memory pointer to allocate.
1062             mstore(0x40, ptr)
1063 
1064             // Cache the end of the memory to calculate the length later.
1065             let end := ptr
1066 
1067             // We write the string from the rightmost digit to the leftmost digit.
1068             // The following is essentially a do-while loop that also handles the zero case.
1069             // Costs a bit more than early returning for the zero case,
1070             // but cheaper in terms of deployment and overall runtime costs.
1071             for { 
1072                 // Initialize and perform the first pass without check.
1073                 let temp := value
1074                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1075                 ptr := sub(ptr, 1)
1076                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1077                 mstore8(ptr, add(48, mod(temp, 10)))
1078                 temp := div(temp, 10)
1079             } temp { 
1080                 // Keep dividing `temp` until zero.
1081                 temp := div(temp, 10)
1082             } { // Body of the for loop.
1083                 ptr := sub(ptr, 1)
1084                 mstore8(ptr, add(48, mod(temp, 10)))
1085             }
1086             
1087             let length := sub(end, ptr)
1088             // Move the pointer 32 bytes leftwards to make room for the length.
1089             ptr := sub(ptr, 32)
1090             // Store the length.
1091             mstore(ptr, length)
1092         }
1093     }
1094 }
1095 
1096 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1097 
1098 
1099 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 /**
1104  * @dev String operations.
1105  */
1106 library Strings {
1107     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1108     uint8 private constant _ADDRESS_LENGTH = 20;
1109 
1110     /**
1111      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1112      */
1113     function toString(uint256 value) internal pure returns (string memory) {
1114         // Inspired by OraclizeAPI's implementation - MIT licence
1115         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1116 
1117         if (value == 0) {
1118             return "0";
1119         }
1120         uint256 temp = value;
1121         uint256 digits;
1122         while (temp != 0) {
1123             digits++;
1124             temp /= 10;
1125         }
1126         bytes memory buffer = new bytes(digits);
1127         while (value != 0) {
1128             digits -= 1;
1129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1130             value /= 10;
1131         }
1132         return string(buffer);
1133     }
1134 
1135     /**
1136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1137      */
1138     function toHexString(uint256 value) internal pure returns (string memory) {
1139         if (value == 0) {
1140             return "0x00";
1141         }
1142         uint256 temp = value;
1143         uint256 length = 0;
1144         while (temp != 0) {
1145             length++;
1146             temp >>= 8;
1147         }
1148         return toHexString(value, length);
1149     }
1150 
1151     /**
1152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1153      */
1154     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1155         bytes memory buffer = new bytes(2 * length + 2);
1156         buffer[0] = "0";
1157         buffer[1] = "x";
1158         for (uint256 i = 2 * length + 1; i > 1; --i) {
1159             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1160             value >>= 4;
1161         }
1162         require(value == 0, "Strings: hex length insufficient");
1163         return string(buffer);
1164     }
1165 
1166     /**
1167      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1168      */
1169     function toHexString(address addr) internal pure returns (string memory) {
1170         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1171     }
1172 }
1173 
1174 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 /**
1182  * @dev Provides information about the current execution context, including the
1183  * sender of the transaction and its data. While these are generally available
1184  * via msg.sender and msg.data, they should not be accessed in such a direct
1185  * manner, since when dealing with meta-transactions the account sending and
1186  * paying for execution may not be the actual sender (as far as an application
1187  * is concerned).
1188  *
1189  * This contract is only required for intermediate, library-like contracts.
1190  */
1191 abstract contract Context {
1192     function _msgSender() internal view virtual returns (address) {
1193         return msg.sender;
1194     }
1195 
1196     function _msgData() internal view virtual returns (bytes calldata) {
1197         return msg.data;
1198     }
1199 }
1200 
1201 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1202 
1203 
1204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
1208 
1209 /**
1210  * @dev Contract module which provides a basic access control mechanism, where
1211  * there is an account (an owner) that can be granted exclusive access to
1212  * specific functions.
1213  *
1214  * By default, the owner account will be the one that deploys the contract. This
1215  * can later be changed with {transferOwnership}.
1216  *
1217  * This module is used through inheritance. It will make available the modifier
1218  * `onlyOwner`, which can be applied to your functions to restrict their use to
1219  * the owner.
1220  */
1221 abstract contract Ownable is Context {
1222     address private _owner;
1223 
1224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1225 
1226     /**
1227      * @dev Initializes the contract setting the deployer as the initial owner.
1228      */
1229     constructor() {
1230         _transferOwnership(_msgSender());
1231     }
1232 
1233     /**
1234      * @dev Returns the address of the current owner.
1235      */
1236     function owner() public view virtual returns (address) {
1237         return _owner;
1238     }
1239 
1240     /**
1241      * @dev Throws if called by any account other than the owner.
1242      */
1243     modifier onlyOwner() {
1244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1245         _;
1246     }
1247 
1248     /**
1249      * @dev Leaves the contract without owner. It will not be possible to call
1250      * `onlyOwner` functions anymore. Can only be called by the current owner.
1251      *
1252      * NOTE: Renouncing ownership will leave the contract without an owner,
1253      * thereby removing any functionality that is only available to the owner.
1254      */
1255     function renounceOwnership() public virtual onlyOwner {
1256         _transferOwnership(address(0));
1257     }
1258 
1259     /**
1260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1261      * Can only be called by the current owner.
1262      */
1263     function transferOwnership(address newOwner) public virtual onlyOwner {
1264         require(newOwner != address(0), "Ownable: new owner is the zero address");
1265         _transferOwnership(newOwner);
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Internal function without access restriction.
1271      */
1272     function _transferOwnership(address newOwner) internal virtual {
1273         address oldOwner = _owner;
1274         _owner = newOwner;
1275         emit OwnershipTransferred(oldOwner, newOwner);
1276     }
1277 }
1278 
1279 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1280 
1281 
1282 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1283 
1284 pragma solidity ^0.8.1;
1285 
1286 /**
1287  * @dev Collection of functions related to the address type
1288  */
1289 library Address {
1290     /**
1291      * @dev Returns true if `account` is a contract.
1292      *
1293      * [IMPORTANT]
1294      * ====
1295      * It is unsafe to assume that an address for which this function returns
1296      * false is an externally-owned account (EOA) and not a contract.
1297      *
1298      * Among others, `isContract` will return false for the following
1299      * types of addresses:
1300      *
1301      *  - an externally-owned account
1302      *  - a contract in construction
1303      *  - an address where a contract will be created
1304      *  - an address where a contract lived, but was destroyed
1305      * ====
1306      *
1307      * [IMPORTANT]
1308      * ====
1309      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1310      *
1311      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1312      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1313      * constructor.
1314      * ====
1315      */
1316     function isContract(address account) internal view returns (bool) {
1317         // This method relies on extcodesize/address.code.length, which returns 0
1318         // for contracts in construction, since the code is only stored at the end
1319         // of the constructor execution.
1320 
1321         return account.code.length > 0;
1322     }
1323 
1324     /**
1325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1326      * `recipient`, forwarding all available gas and reverting on errors.
1327      *
1328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1330      * imposed by `transfer`, making them unable to receive funds via
1331      * `transfer`. {sendValue} removes this limitation.
1332      *
1333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1334      *
1335      * IMPORTANT: because control is transferred to `recipient`, care must be
1336      * taken to not create reentrancy vulnerabilities. Consider using
1337      * {ReentrancyGuard} or the
1338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1339      */
1340     function sendValue(address payable recipient, uint256 amount) internal {
1341         require(address(this).balance >= amount, "Address: insufficient balance");
1342 
1343         (bool success, ) = recipient.call{value: amount}("");
1344         require(success, "Address: unable to send value, recipient may have reverted");
1345     }
1346 
1347     /**
1348      * @dev Performs a Solidity function call using a low level `call`. A
1349      * plain `call` is an unsafe replacement for a function call: use this
1350      * function instead.
1351      *
1352      * If `target` reverts with a revert reason, it is bubbled up by this
1353      * function (like regular Solidity function calls).
1354      *
1355      * Returns the raw returned data. To convert to the expected return value,
1356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1357      *
1358      * Requirements:
1359      *
1360      * - `target` must be a contract.
1361      * - calling `target` with `data` must not revert.
1362      *
1363      * _Available since v3.1._
1364      */
1365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1366         return functionCall(target, data, "Address: low-level call failed");
1367     }
1368 
1369     /**
1370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1371      * `errorMessage` as a fallback revert reason when `target` reverts.
1372      *
1373      * _Available since v3.1._
1374      */
1375     function functionCall(
1376         address target,
1377         bytes memory data,
1378         string memory errorMessage
1379     ) internal returns (bytes memory) {
1380         return functionCallWithValue(target, data, 0, errorMessage);
1381     }
1382 
1383     /**
1384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1385      * but also transferring `value` wei to `target`.
1386      *
1387      * Requirements:
1388      *
1389      * - the calling contract must have an ETH balance of at least `value`.
1390      * - the called Solidity function must be `payable`.
1391      *
1392      * _Available since v3.1._
1393      */
1394     function functionCallWithValue(
1395         address target,
1396         bytes memory data,
1397         uint256 value
1398     ) internal returns (bytes memory) {
1399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1400     }
1401 
1402     /**
1403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1404      * with `errorMessage` as a fallback revert reason when `target` reverts.
1405      *
1406      * _Available since v3.1._
1407      */
1408     function functionCallWithValue(
1409         address target,
1410         bytes memory data,
1411         uint256 value,
1412         string memory errorMessage
1413     ) internal returns (bytes memory) {
1414         require(address(this).balance >= value, "Address: insufficient balance for call");
1415         require(isContract(target), "Address: call to non-contract");
1416 
1417         (bool success, bytes memory returndata) = target.call{value: value}(data);
1418         return verifyCallResult(success, returndata, errorMessage);
1419     }
1420 
1421     /**
1422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1423      * but performing a static call.
1424      *
1425      * _Available since v3.3._
1426      */
1427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1428         return functionStaticCall(target, data, "Address: low-level static call failed");
1429     }
1430 
1431     /**
1432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1433      * but performing a static call.
1434      *
1435      * _Available since v3.3._
1436      */
1437     function functionStaticCall(
1438         address target,
1439         bytes memory data,
1440         string memory errorMessage
1441     ) internal view returns (bytes memory) {
1442         require(isContract(target), "Address: static call to non-contract");
1443 
1444         (bool success, bytes memory returndata) = target.staticcall(data);
1445         return verifyCallResult(success, returndata, errorMessage);
1446     }
1447 
1448     /**
1449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1450      * but performing a delegate call.
1451      *
1452      * _Available since v3.4._
1453      */
1454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1456     }
1457 
1458     /**
1459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1460      * but performing a delegate call.
1461      *
1462      * _Available since v3.4._
1463      */
1464     function functionDelegateCall(
1465         address target,
1466         bytes memory data,
1467         string memory errorMessage
1468     ) internal returns (bytes memory) {
1469         require(isContract(target), "Address: delegate call to non-contract");
1470 
1471         (bool success, bytes memory returndata) = target.delegatecall(data);
1472         return verifyCallResult(success, returndata, errorMessage);
1473     }
1474 
1475     /**
1476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1477      * revert reason using the provided one.
1478      *
1479      * _Available since v4.3._
1480      */
1481     function verifyCallResult(
1482         bool success,
1483         bytes memory returndata,
1484         string memory errorMessage
1485     ) internal pure returns (bytes memory) {
1486         if (success) {
1487             return returndata;
1488         } else {
1489             // Look for revert reason and bubble it up if present
1490             if (returndata.length > 0) {
1491                 // The easiest way to bubble the revert reason is using memory via assembly
1492 
1493                 assembly {
1494                     let returndata_size := mload(returndata)
1495                     revert(add(32, returndata), returndata_size)
1496                 }
1497             } else {
1498                 revert(errorMessage);
1499             }
1500         }
1501     }
1502 }
1503 
1504 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1505 
1506 
1507 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1508 
1509 pragma solidity ^0.8.0;
1510 
1511 /**
1512  * @title ERC721 token receiver interface
1513  * @dev Interface for any contract that wants to support safeTransfers
1514  * from ERC721 asset contracts.
1515  */
1516 interface IERC721Receiver {
1517     /**
1518      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1519      * by `operator` from `from`, this function is called.
1520      *
1521      * It must return its Solidity selector to confirm the token transfer.
1522      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1523      *
1524      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1525      */
1526     function onERC721Received(
1527         address operator,
1528         address from,
1529         uint256 tokenId,
1530         bytes calldata data
1531     ) external returns (bytes4);
1532 }
1533 
1534 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1535 
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
1774 
1775 
1776 
1777 
1778 
1779 
1780 
1781 /**
1782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1783  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1784  * {ERC721Enumerable}.
1785  */
1786 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1787     using Address for address;
1788     using Strings for uint256;
1789 
1790     // Token name
1791     string private _name;
1792 
1793     // Token symbol
1794     string private _symbol;
1795 
1796     // Mapping from token ID to owner address
1797     mapping(uint256 => address) private _owners;
1798 
1799     // Mapping owner address to token count
1800     mapping(address => uint256) private _balances;
1801 
1802     // Mapping from token ID to approved address
1803     mapping(uint256 => address) private _tokenApprovals;
1804 
1805     // Mapping from owner to operator approvals
1806     mapping(address => mapping(address => bool)) private _operatorApprovals;
1807 
1808     /**
1809      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1810      */
1811     constructor(string memory name_, string memory symbol_) {
1812         _name = name_;
1813         _symbol = symbol_;
1814     }
1815 
1816     /**
1817      * @dev See {IERC165-supportsInterface}.
1818      */
1819     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1820         return
1821             interfaceId == type(IERC721).interfaceId ||
1822             interfaceId == type(IERC721Metadata).interfaceId ||
1823             super.supportsInterface(interfaceId);
1824     }
1825 
1826     /**
1827      * @dev See {IERC721-balanceOf}.
1828      */
1829     function balanceOf(address owner) public view virtual override returns (uint256) {
1830         require(owner != address(0), "ERC721: address zero is not a valid owner");
1831         return _balances[owner];
1832     }
1833 
1834     /**
1835      * @dev See {IERC721-ownerOf}.
1836      */
1837     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1838         address owner = _owners[tokenId];
1839         require(owner != address(0), "ERC721: owner query for nonexistent token");
1840         return owner;
1841     }
1842 
1843     /**
1844      * @dev See {IERC721Metadata-name}.
1845      */
1846     function name() public view virtual override returns (string memory) {
1847         return _name;
1848     }
1849 
1850     /**
1851      * @dev See {IERC721Metadata-symbol}.
1852      */
1853     function symbol() public view virtual override returns (string memory) {
1854         return _symbol;
1855     }
1856 
1857     /**
1858      * @dev See {IERC721Metadata-tokenURI}.
1859      */
1860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1861         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1862 
1863         string memory baseURI = _baseURI();
1864         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1865     }
1866 
1867     /**
1868      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1869      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1870      * by default, can be overridden in child contracts.
1871      */
1872     function _baseURI() internal view virtual returns (string memory) {
1873         return "";
1874     }
1875 
1876     /**
1877      * @dev See {IERC721-approve}.
1878      */
1879     function approve(address to, uint256 tokenId) public virtual override {
1880         address owner = ERC721.ownerOf(tokenId);
1881         require(to != owner, "ERC721: approval to current owner");
1882 
1883         require(
1884             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1885             "ERC721: approve caller is not owner nor approved for all"
1886         );
1887 
1888         _approve(to, tokenId);
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-getApproved}.
1893      */
1894     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1895         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1896 
1897         return _tokenApprovals[tokenId];
1898     }
1899 
1900     /**
1901      * @dev See {IERC721-setApprovalForAll}.
1902      */
1903     function setApprovalForAll(address operator, bool approved) public virtual override {
1904         _setApprovalForAll(_msgSender(), operator, approved);
1905     }
1906 
1907     /**
1908      * @dev See {IERC721-isApprovedForAll}.
1909      */
1910     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1911         return _operatorApprovals[owner][operator];
1912     }
1913 
1914     /**
1915      * @dev See {IERC721-transferFrom}.
1916      */
1917     function transferFrom(
1918         address from,
1919         address to,
1920         uint256 tokenId
1921     ) public virtual override {
1922         //solhint-disable-next-line max-line-length
1923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1924 
1925         _transfer(from, to, tokenId);
1926     }
1927 
1928     /**
1929      * @dev See {IERC721-safeTransferFrom}.
1930      */
1931     function safeTransferFrom(
1932         address from,
1933         address to,
1934         uint256 tokenId
1935     ) public virtual override {
1936         safeTransferFrom(from, to, tokenId, "");
1937     }
1938 
1939     /**
1940      * @dev See {IERC721-safeTransferFrom}.
1941      */
1942     function safeTransferFrom(
1943         address from,
1944         address to,
1945         uint256 tokenId,
1946         bytes memory data
1947     ) public virtual override {
1948         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1949         _safeTransfer(from, to, tokenId, data);
1950     }
1951 
1952     /**
1953      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1954      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1955      *
1956      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1957      *
1958      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1959      * implement alternative mechanisms to perform token transfer, such as signature-based.
1960      *
1961      * Requirements:
1962      *
1963      * - `from` cannot be the zero address.
1964      * - `to` cannot be the zero address.
1965      * - `tokenId` token must exist and be owned by `from`.
1966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1967      *
1968      * Emits a {Transfer} event.
1969      */
1970     function _safeTransfer(
1971         address from,
1972         address to,
1973         uint256 tokenId,
1974         bytes memory data
1975     ) internal virtual {
1976         _transfer(from, to, tokenId);
1977         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1978     }
1979 
1980     /**
1981      * @dev Returns whether `tokenId` exists.
1982      *
1983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1984      *
1985      * Tokens start existing when they are minted (`_mint`),
1986      * and stop existing when they are burned (`_burn`).
1987      */
1988     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1989         return _owners[tokenId] != address(0);
1990     }
1991 
1992     /**
1993      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1994      *
1995      * Requirements:
1996      *
1997      * - `tokenId` must exist.
1998      */
1999     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2000         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2001         address owner = ERC721.ownerOf(tokenId);
2002         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2003     }
2004 
2005     /**
2006      * @dev Safely mints `tokenId` and transfers it to `to`.
2007      *
2008      * Requirements:
2009      *
2010      * - `tokenId` must not exist.
2011      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2012      *
2013      * Emits a {Transfer} event.
2014      */
2015     function _safeMint(address to, uint256 tokenId) internal virtual {
2016         _safeMint(to, tokenId, "");
2017     }
2018 
2019     /**
2020      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2021      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2022      */
2023     function _safeMint(
2024         address to,
2025         uint256 tokenId,
2026         bytes memory data
2027     ) internal virtual {
2028         _mint(to, tokenId);
2029         require(
2030             _checkOnERC721Received(address(0), to, tokenId, data),
2031             "ERC721: transfer to non ERC721Receiver implementer"
2032         );
2033     }
2034 
2035     /**
2036      * @dev Mints `tokenId` and transfers it to `to`.
2037      *
2038      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2039      *
2040      * Requirements:
2041      *
2042      * - `tokenId` must not exist.
2043      * - `to` cannot be the zero address.
2044      *
2045      * Emits a {Transfer} event.
2046      */
2047     function _mint(address to, uint256 tokenId) internal virtual {
2048         require(to != address(0), "ERC721: mint to the zero address");
2049         require(!_exists(tokenId), "ERC721: token already minted");
2050 
2051         _beforeTokenTransfer(address(0), to, tokenId);
2052 
2053         _balances[to] += 1;
2054         _owners[tokenId] = to;
2055 
2056         emit Transfer(address(0), to, tokenId);
2057 
2058         _afterTokenTransfer(address(0), to, tokenId);
2059     }
2060 
2061     /**
2062      * @dev Destroys `tokenId`.
2063      * The approval is cleared when the token is burned.
2064      *
2065      * Requirements:
2066      *
2067      * - `tokenId` must exist.
2068      *
2069      * Emits a {Transfer} event.
2070      */
2071     function _burn(uint256 tokenId) internal virtual {
2072         address owner = ERC721.ownerOf(tokenId);
2073 
2074         _beforeTokenTransfer(owner, address(0), tokenId);
2075 
2076         // Clear approvals
2077         _approve(address(0), tokenId);
2078 
2079         _balances[owner] -= 1;
2080         delete _owners[tokenId];
2081 
2082         emit Transfer(owner, address(0), tokenId);
2083 
2084         _afterTokenTransfer(owner, address(0), tokenId);
2085     }
2086 
2087     /**
2088      * @dev Transfers `tokenId` from `from` to `to`.
2089      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2090      *
2091      * Requirements:
2092      *
2093      * - `to` cannot be the zero address.
2094      * - `tokenId` token must be owned by `from`.
2095      *
2096      * Emits a {Transfer} event.
2097      */
2098     function _transfer(
2099         address from,
2100         address to,
2101         uint256 tokenId
2102     ) internal virtual {
2103         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2104         require(to != address(0), "ERC721: transfer to the zero address");
2105 
2106         _beforeTokenTransfer(from, to, tokenId);
2107 
2108         // Clear approvals from the previous owner
2109         _approve(address(0), tokenId);
2110 
2111         _balances[from] -= 1;
2112         _balances[to] += 1;
2113         _owners[tokenId] = to;
2114 
2115         emit Transfer(from, to, tokenId);
2116 
2117         _afterTokenTransfer(from, to, tokenId);
2118     }
2119 
2120     /**
2121      * @dev Approve `to` to operate on `tokenId`
2122      *
2123      * Emits an {Approval} event.
2124      */
2125     function _approve(address to, uint256 tokenId) internal virtual {
2126         _tokenApprovals[tokenId] = to;
2127         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2128     }
2129 
2130     /**
2131      * @dev Approve `operator` to operate on all of `owner` tokens
2132      *
2133      * Emits an {ApprovalForAll} event.
2134      */
2135     function _setApprovalForAll(
2136         address owner,
2137         address operator,
2138         bool approved
2139     ) internal virtual {
2140         require(owner != operator, "ERC721: approve to caller");
2141         _operatorApprovals[owner][operator] = approved;
2142         emit ApprovalForAll(owner, operator, approved);
2143     }
2144 
2145     /**
2146      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2147      * The call is not executed if the target address is not a contract.
2148      *
2149      * @param from address representing the previous owner of the given token ID
2150      * @param to target address that will receive the tokens
2151      * @param tokenId uint256 ID of the token to be transferred
2152      * @param data bytes optional data to send along with the call
2153      * @return bool whether the call correctly returned the expected magic value
2154      */
2155     function _checkOnERC721Received(
2156         address from,
2157         address to,
2158         uint256 tokenId,
2159         bytes memory data
2160     ) private returns (bool) {
2161         if (to.isContract()) {
2162             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2163                 return retval == IERC721Receiver.onERC721Received.selector;
2164             } catch (bytes memory reason) {
2165                 if (reason.length == 0) {
2166                     revert("ERC721: transfer to non ERC721Receiver implementer");
2167                 } else {
2168                     assembly {
2169                         revert(add(32, reason), mload(reason))
2170                     }
2171                 }
2172             }
2173         } else {
2174             return true;
2175         }
2176     }
2177 
2178     /**
2179      * @dev Hook that is called before any token transfer. This includes minting
2180      * and burning.
2181      *
2182      * Calling conditions:
2183      *
2184      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2185      * transferred to `to`.
2186      * - When `from` is zero, `tokenId` will be minted for `to`.
2187      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2188      * - `from` and `to` are never both zero.
2189      *
2190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2191      */
2192     function _beforeTokenTransfer(
2193         address from,
2194         address to,
2195         uint256 tokenId
2196     ) internal virtual {}
2197 
2198     /**
2199      * @dev Hook that is called after any transfer of tokens. This includes
2200      * minting and burning.
2201      *
2202      * Calling conditions:
2203      *
2204      * - when `from` and `to` are both non-zero.
2205      * - `from` and `to` are never both zero.
2206      *
2207      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2208      */
2209     function _afterTokenTransfer(
2210         address from,
2211         address to,
2212         uint256 tokenId
2213     ) internal virtual {}
2214 }
2215 
2216 
2217 
2218 
2219 pragma solidity ^0.8.0;
2220 
2221 
2222 
2223 
2224 contract goblinbucks is ERC721A, Ownable {
2225     using Strings for uint256;
2226 
2227     string private baseURI;
2228 
2229     uint256 public price = 0.0044 ether;
2230 
2231     uint256 public maxPerTx = 10;
2232 
2233     uint256 public maxFreePerWallet = 1;
2234 
2235     uint256 public totalFree = 1044;
2236 
2237     uint256 public maxSupply = 7444;
2238 
2239     bool public mintEnabled = false;
2240 
2241     mapping(address => uint256) private _mintedFreeAmount;
2242 
2243     constructor() ERC721A("goblinbucks", "BKS") {
2244         _safeMint(msg.sender, 25);
2245         setBaseURI("");
2246     }
2247 
2248     function mint(uint256 count) external payable {
2249         uint256 cost = price;
2250         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2251             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2252 
2253         if (isFree) {
2254             cost = 0;
2255         }
2256 
2257         require(msg.value >= count * cost, "Please send the exact amount.");
2258         require(totalSupply() + count < maxSupply + 1, "No more");
2259         require(mintEnabled, "Minting is not live yet");
2260         require(count < maxPerTx + 1, "Max per TX reached.");
2261 
2262         if (isFree) {
2263             _mintedFreeAmount[msg.sender] += count;
2264         }
2265 
2266         _safeMint(msg.sender, count);
2267     }
2268 
2269     function _baseURI() internal view virtual override returns (string memory) {
2270         return baseURI;
2271     }
2272 
2273     function tokenURI(uint256 tokenId)
2274         public
2275         view
2276         virtual
2277         override
2278         returns (string memory)
2279     {
2280         require(
2281             _exists(tokenId),
2282             "ERC721Metadata: URI query for nonexistent token"
2283         );
2284         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2285     }
2286 
2287     function setBaseURI(string memory uri) public onlyOwner {
2288         baseURI = uri;
2289     }
2290 
2291     function setFreeAmount(uint256 amount) external onlyOwner {
2292         totalFree = amount;
2293     }
2294 
2295     function setPrice(uint256 _newPrice) external onlyOwner {
2296         price = _newPrice;
2297     }
2298 
2299     function flipSale() external onlyOwner {
2300         mintEnabled = !mintEnabled;
2301     }
2302 
2303     function withdraw() external onlyOwner {
2304         (bool success, ) = payable(msg.sender).call{
2305             value: address(this).balance
2306         }("");
2307         require(success, "Transfer failed.");
2308     }
2309 }