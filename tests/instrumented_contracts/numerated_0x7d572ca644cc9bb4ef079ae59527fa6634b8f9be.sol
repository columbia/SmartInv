1 // SPDX-License-Identifier: None
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _transferOwnership(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Internal function without access restriction.
65      */
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 
74 interface IERC721A {
75     /**
76      * The caller must own the token or be an approved operator.
77      */
78     error ApprovalCallerNotOwnerNorApproved();
79 
80     /**
81      * The token does not exist.
82      */
83     error ApprovalQueryForNonexistentToken();
84 
85     /**
86      * The caller cannot approve to their own address.
87      */
88     error ApproveToCaller();
89 
90     /**
91      * The caller cannot approve to the current owner.
92      */
93     error ApprovalToCurrentOwner();
94 
95     /**
96      * Cannot query the balance for the zero address.
97      */
98     error BalanceQueryForZeroAddress();
99 
100     /**
101      * Cannot mint to the zero address.
102      */
103     error MintToZeroAddress();
104 
105     /**
106      * The quantity of tokens minted must be more than zero.
107      */
108     error MintZeroQuantity();
109 
110     /**
111      * The token does not exist.
112      */
113     error OwnerQueryForNonexistentToken();
114 
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error TransferCallerNotOwnerNorApproved();
119 
120     /**
121      * The token must be owned by `from`.
122      */
123     error TransferFromIncorrectOwner();
124 
125     /**
126      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
127      */
128     error TransferToNonERC721ReceiverImplementer();
129 
130     /**
131      * Cannot transfer to the zero address.
132      */
133     error TransferToZeroAddress();
134 
135     /**
136      * The token does not exist.
137      */
138     error URIQueryForNonexistentToken();
139 
140     struct TokenOwnership {
141         // The address of the owner.
142         address addr;
143         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
144         uint64 startTimestamp;
145         // Whether the token has been burned.
146         bool burned;
147     }
148 
149     /**
150      * @dev Returns the total amount of tokens stored by the contract.
151      *
152      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     // ==============================
157     //            IERC165
158     // ==============================
159 
160     /**
161      * @dev Returns true if this contract implements the interface defined by
162      * `interfaceId`. See the corresponding
163      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
164      * to learn more about how these ids are created.
165      *
166      * This function call must use less than 30 000 gas.
167      */
168     function supportsInterface(bytes4 interfaceId) external view returns (bool);
169 
170     // ==============================
171     //            IERC721
172     // ==============================
173 
174     /**
175      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
178 
179     /**
180      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
181      */
182     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
183 
184     /**
185      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
186      */
187     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
188 
189     /**
190      * @dev Returns the number of tokens in ``owner``'s account.
191      */
192     function balanceOf(address owner) external view returns (uint256 balance);
193 
194     /**
195      * @dev Returns the owner of the `tokenId` token.
196      *
197      * Requirements:
198      *
199      * - `tokenId` must exist.
200      */
201     function ownerOf(uint256 tokenId) external view returns (address owner);
202 
203     /**
204      * @dev Safely transfers `tokenId` token from `from` to `to`.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId,
220         bytes calldata data
221     ) external;
222 
223     /**
224      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
225      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId
241     ) external;
242 
243     /**
244      * @dev Transfers `tokenId` token from `from` to `to`.
245      *
246      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(
258         address from,
259         address to,
260         uint256 tokenId
261     ) external;
262 
263     /**
264      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
265      * The approval is cleared when the token is transferred.
266      *
267      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
268      *
269      * Requirements:
270      *
271      * - The caller must own the token or be an approved operator.
272      * - `tokenId` must exist.
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address to, uint256 tokenId) external;
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
281      *
282      * Requirements:
283      *
284      * - The `operator` cannot be the caller.
285      *
286      * Emits an {ApprovalForAll} event.
287      */
288     function setApprovalForAll(address operator, bool _approved) external;
289 
290     /**
291      * @dev Returns the account approved for `tokenId` token.
292      *
293      * Requirements:
294      *
295      * - `tokenId` must exist.
296      */
297     function getApproved(uint256 tokenId) external view returns (address operator);
298 
299     /**
300      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
301      *
302      * See {setApprovalForAll}
303      */
304     function isApprovedForAll(address owner, address operator) external view returns (bool);
305 
306     // ==============================
307     //        IERC721Metadata
308     // ==============================
309 
310     /**
311      * @dev Returns the token collection name.
312      */
313     function name() external view returns (string memory);
314 
315     /**
316      * @dev Returns the token collection symbol.
317      */
318     function symbol() external view returns (string memory);
319 
320     /**
321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
322      */
323     function tokenURI(uint256 tokenId) external view returns (string memory);
324 }
325 
326 
327 interface ERC721A__IERC721Receiver {
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 /**
337  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
338  * the Metadata extension. Built to optimize for lower gas during batch mints.
339  *
340  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
341  *
342  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
343  *
344  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
345  */
346 contract ERC721A is IERC721A {
347     // Mask of an entry in packed address data.
348     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
349 
350     // The bit position of `numberMinted` in packed address data.
351     uint256 private constant BITPOS_NUMBER_MINTED = 64;
352 
353     // The bit position of `numberBurned` in packed address data.
354     uint256 private constant BITPOS_NUMBER_BURNED = 128;
355 
356     // The bit position of `aux` in packed address data.
357     uint256 private constant BITPOS_AUX = 192;
358 
359     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
360     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
361 
362     // The bit position of `startTimestamp` in packed ownership.
363     uint256 private constant BITPOS_START_TIMESTAMP = 160;
364 
365     // The bit mask of the `burned` bit in packed ownership.
366     uint256 private constant BITMASK_BURNED = 1 << 224;
367     
368     // The bit position of the `nextInitialized` bit in packed ownership.
369     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
370 
371     // The bit mask of the `nextInitialized` bit in packed ownership.
372     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
373 
374     // The tokenId of the next token to be minted.
375     uint256 private _currentIndex;
376 
377     // The number of tokens burned.
378     uint256 private _burnCounter;
379 
380     // Token name
381     string private _name;
382 
383     // Token symbol
384     string private _symbol;
385 
386     // Mapping from token ID to ownership details
387     // An empty struct value does not necessarily mean the token is unowned.
388     // See `_packedOwnershipOf` implementation for details.
389     //
390     // Bits Layout:
391     // - [0..159]   `addr`
392     // - [160..223] `startTimestamp`
393     // - [224]      `burned`
394     // - [225]      `nextInitialized`
395     mapping(uint256 => uint256) private _packedOwnerships;
396 
397     // Mapping owner address to address data.
398     //
399     // Bits Layout:
400     // - [0..63]    `balance`
401     // - [64..127]  `numberMinted`
402     // - [128..191] `numberBurned`
403     // - [192..255] `aux`
404     mapping(address => uint256) private _packedAddressData;
405 
406     // Mapping from token ID to approved address.
407     mapping(uint256 => address) private _tokenApprovals;
408 
409     // Mapping from owner to operator approvals
410     mapping(address => mapping(address => bool)) private _operatorApprovals;
411 
412     constructor(string memory name_, string memory symbol_) {
413         _name = name_;
414         _symbol = symbol_;
415         _currentIndex = _startTokenId();
416     }
417 
418     /**
419      * @dev Returns the starting token ID. 
420      * To change the starting token ID, please override this function.
421      */
422     function _startTokenId() internal view virtual returns (uint256) {
423         return 0;
424     }
425 
426     /**
427      * @dev Returns the next token ID to be minted.
428      */
429     function _nextTokenId() internal view returns (uint256) {
430         return _currentIndex;
431     }
432 
433     /**
434      * @dev Returns the total number of tokens in existence.
435      * Burned tokens will reduce the count. 
436      * To get the total number of tokens minted, please see `_totalMinted`.
437      */
438     function totalSupply() public view override returns (uint256) {
439         // Counter underflow is impossible as _burnCounter cannot be incremented
440         // more than `_currentIndex - _startTokenId()` times.
441         unchecked {
442             return _currentIndex - _burnCounter - _startTokenId();
443         }
444     }
445 
446     /**
447      * @dev Returns the total amount of tokens minted in the contract.
448      */
449     function _totalMinted() internal view returns (uint256) {
450         // Counter underflow is impossible as _currentIndex does not decrement,
451         // and it is initialized to `_startTokenId()`
452         unchecked {
453             return _currentIndex - _startTokenId();
454         }
455     }
456 
457     /**
458      * @dev Returns the total number of tokens burned.
459      */
460     function _totalBurned() internal view returns (uint256) {
461         return _burnCounter;
462     }
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468         // The interface IDs are constants representing the first 4 bytes of the XOR of
469         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
470         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
471         return
472             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
473             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
474             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
475     }
476 
477     /**
478      * @dev See {IERC721-balanceOf}.
479      */
480     function balanceOf(address owner) public view override returns (uint256) {
481         if (owner == address(0)) revert BalanceQueryForZeroAddress();
482         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485     /**
486      * Returns the number of tokens minted by `owner`.
487      */
488     function _numberMinted(address owner) internal view returns (uint256) {
489         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
490     }
491 
492     /**
493      * Returns the number of tokens burned by or on behalf of `owner`.
494      */
495     function _numberBurned(address owner) internal view returns (uint256) {
496         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
501      */
502     function _getAux(address owner) internal view returns (uint64) {
503         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
504     }
505 
506     /**
507      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
508      * If there are multiple variables, please pack them into a uint64.
509      */
510     function _setAux(address owner, uint64 aux) internal {
511         uint256 packed = _packedAddressData[owner];
512         uint256 auxCasted;
513         assembly { // Cast aux without masking.
514             auxCasted := aux
515         }
516         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
517         _packedAddressData[owner] = packed;
518     }
519 
520     /**
521      * Returns the packed ownership data of `tokenId`.
522      */
523     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
524         uint256 curr = tokenId;
525 
526         unchecked {
527             if (_startTokenId() <= curr)
528                 if (curr < _currentIndex) {
529                     uint256 packed = _packedOwnerships[curr];
530                     // If not burned.
531                     if (packed & BITMASK_BURNED == 0) {
532                         // Invariant:
533                         // There will always be an ownership that has an address and is not burned
534                         // before an ownership that does not have an address and is not burned.
535                         // Hence, curr will not underflow.
536                         //
537                         // We can directly compare the packed value.
538                         // If the address is zero, packed is zero.
539                         while (packed == 0) {
540                             packed = _packedOwnerships[--curr];
541                         }
542                         return packed;
543                     }
544                 }
545         }
546         revert OwnerQueryForNonexistentToken();
547     }
548 
549     /**
550      * Returns the unpacked `TokenOwnership` struct from `packed`.
551      */
552     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
553         ownership.addr = address(uint160(packed));
554         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
555         ownership.burned = packed & BITMASK_BURNED != 0;
556     }
557 
558     /**
559      * Returns the unpacked `TokenOwnership` struct at `index`.
560      */
561     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
562         return _unpackedOwnership(_packedOwnerships[index]);
563     }
564 
565     /**
566      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
567      */
568     function _initializeOwnershipAt(uint256 index) internal {
569         if (_packedOwnerships[index] == 0) {
570             _packedOwnerships[index] = _packedOwnershipOf(index);
571         }
572     }
573 
574     /**
575      * Gas spent here starts off proportional to the maximum mint batch size.
576      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
577      */
578     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
579         return _unpackedOwnership(_packedOwnershipOf(tokenId));
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId) public view override returns (address) {
586         return address(uint160(_packedOwnershipOf(tokenId)));
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
608 
609         string memory baseURI = _baseURI();
610         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
611     }
612 
613     /**
614      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
615      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
616      * by default, can be overriden in child contracts.
617      */
618     function _baseURI() internal view virtual returns (string memory) {
619         return '';
620     }
621 
622     /**
623      * @dev Casts the address to uint256 without masking.
624      */
625     function _addressToUint256(address value) private pure returns (uint256 result) {
626         assembly {
627             result := value
628         }
629     }
630 
631     /**
632      * @dev Casts the boolean to uint256 without branching.
633      */
634     function _boolToUint256(bool value) private pure returns (uint256 result) {
635         assembly {
636             result := value
637         }
638     }
639 
640     /**
641      * @dev See {IERC721-approve}.
642      */
643     function approve(address to, uint256 tokenId) public override {
644         address owner = address(uint160(_packedOwnershipOf(tokenId)));
645         if (to == owner) revert ApprovalToCurrentOwner();
646 
647         if (_msgSenderERC721A() != owner)
648             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
649                 revert ApprovalCallerNotOwnerNorApproved();
650             }
651 
652         _tokenApprovals[tokenId] = to;
653         emit Approval(owner, to, tokenId);
654     }
655 
656     /**
657      * @dev See {IERC721-getApproved}.
658      */
659     function getApproved(uint256 tokenId) public view override returns (address) {
660         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
661 
662         return _tokenApprovals[tokenId];
663     }
664 
665     /**
666      * @dev See {IERC721-setApprovalForAll}.
667      */
668     function setApprovalForAll(address operator, bool approved) public virtual override {
669         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
670 
671         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
672         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC721-isApprovedForAll}.
677      */
678     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
679         return _operatorApprovals[owner][operator];
680     }
681 
682     /**
683      * @dev See {IERC721-transferFrom}.
684      */
685     function transferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) public virtual override {
690         _transfer(from, to, tokenId);
691     }
692 
693     /**
694      * @dev See {IERC721-safeTransferFrom}.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) public virtual override {
701         safeTransferFrom(from, to, tokenId, '');
702     }
703 
704     /**
705      * @dev See {IERC721-safeTransferFrom}.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes memory _data
712     ) public virtual override {
713         _transfer(from, to, tokenId);
714         if (to.code.length != 0)
715             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
716                 revert TransferToNonERC721ReceiverImplementer();
717             }
718     }
719 
720     /**
721      * @dev Returns whether `tokenId` exists.
722      *
723      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
724      *
725      * Tokens start existing when they are minted (`_mint`),
726      */
727     function _exists(uint256 tokenId) internal view returns (bool) {
728         return
729             _startTokenId() <= tokenId &&
730             tokenId < _currentIndex && // If within bounds,
731             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
732     }
733 
734     /**
735      * @dev Equivalent to `_safeMint(to, quantity, '')`.
736      */
737     function _safeMint(address to, uint256 quantity) internal {
738         _safeMint(to, quantity, '');
739     }
740 
741     /**
742      * @dev Safely mints `quantity` tokens and transfers them to `to`.
743      *
744      * Requirements:
745      *
746      * - If `to` refers to a smart contract, it must implement
747      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
748      * - `quantity` must be greater than 0.
749      *
750      * Emits a {Transfer} event.
751      */
752     function _safeMint(
753         address to,
754         uint256 quantity,
755         bytes memory _data
756     ) internal {
757         uint256 startTokenId = _currentIndex;
758         if (to == address(0)) revert MintToZeroAddress();
759         if (quantity == 0) revert MintZeroQuantity();
760 
761         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
762 
763         // Overflows are incredibly unrealistic.
764         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
765         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
766         unchecked {
767             // Updates:
768             // - `balance += quantity`.
769             // - `numberMinted += quantity`.
770             //
771             // We can directly add to the balance and number minted.
772             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
773 
774             // Updates:
775             // - `address` to the owner.
776             // - `startTimestamp` to the timestamp of minting.
777             // - `burned` to `false`.
778             // - `nextInitialized` to `quantity == 1`.
779             _packedOwnerships[startTokenId] =
780                 _addressToUint256(to) |
781                 (block.timestamp << BITPOS_START_TIMESTAMP) |
782                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
783 
784             uint256 updatedIndex = startTokenId;
785             uint256 end = updatedIndex + quantity;
786 
787             if (to.code.length != 0) {
788                 do {
789                     emit Transfer(address(0), to, updatedIndex);
790                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
791                         revert TransferToNonERC721ReceiverImplementer();
792                     }
793                 } while (updatedIndex < end);
794                 // Reentrancy protection
795                 if (_currentIndex != startTokenId) revert();
796             } else {
797                 do {
798                     emit Transfer(address(0), to, updatedIndex++);
799                 } while (updatedIndex < end);
800             }
801             _currentIndex = updatedIndex;
802         }
803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
804     }
805 
806     /**
807      * @dev Mints `quantity` tokens and transfers them to `to`.
808      *
809      * Requirements:
810      *
811      * - `to` cannot be the zero address.
812      * - `quantity` must be greater than 0.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _mint(address to, uint256 quantity) internal {
817         uint256 startTokenId = _currentIndex;
818         if (to == address(0)) revert MintToZeroAddress();
819         if (quantity == 0) revert MintZeroQuantity();
820 
821         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
822 
823         // Overflows are incredibly unrealistic.
824         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
825         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
826         unchecked {
827             // Updates:
828             // - `balance += quantity`.
829             // - `numberMinted += quantity`.
830             //
831             // We can directly add to the balance and number minted.
832             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
833 
834             // Updates:
835             // - `address` to the owner.
836             // - `startTimestamp` to the timestamp of minting.
837             // - `burned` to `false`.
838             // - `nextInitialized` to `quantity == 1`.
839             _packedOwnerships[startTokenId] =
840                 _addressToUint256(to) |
841                 (block.timestamp << BITPOS_START_TIMESTAMP) |
842                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
843 
844             uint256 updatedIndex = startTokenId;
845             uint256 end = updatedIndex + quantity;
846 
847             do {
848                 emit Transfer(address(0), to, updatedIndex++);
849             } while (updatedIndex < end);
850 
851             _currentIndex = updatedIndex;
852         }
853         _afterTokenTransfers(address(0), to, startTokenId, quantity);
854     }
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _transfer(
867         address from,
868         address to,
869         uint256 tokenId
870     ) private {
871         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
872 
873         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
874 
875         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
876             isApprovedForAll(from, _msgSenderERC721A()) ||
877             getApproved(tokenId) == _msgSenderERC721A());
878 
879         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
880         if (to == address(0)) revert TransferToZeroAddress();
881 
882         _beforeTokenTransfers(from, to, tokenId, 1);
883 
884         // Clear approvals from the previous owner.
885         delete _tokenApprovals[tokenId];
886 
887         // Underflow of the sender's balance is impossible because we check for
888         // ownership above and the recipient's balance can't realistically overflow.
889         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
890         unchecked {
891             // We can directly increment and decrement the balances.
892             --_packedAddressData[from]; // Updates: `balance -= 1`.
893             ++_packedAddressData[to]; // Updates: `balance += 1`.
894 
895             // Updates:
896             // - `address` to the next owner.
897             // - `startTimestamp` to the timestamp of transfering.
898             // - `burned` to `false`.
899             // - `nextInitialized` to `true`.
900             _packedOwnerships[tokenId] =
901                 _addressToUint256(to) |
902                 (block.timestamp << BITPOS_START_TIMESTAMP) |
903                 BITMASK_NEXT_INITIALIZED;
904 
905             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
906             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
907                 uint256 nextTokenId = tokenId + 1;
908                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
909                 if (_packedOwnerships[nextTokenId] == 0) {
910                     // If the next slot is within bounds.
911                     if (nextTokenId != _currentIndex) {
912                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
913                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
914                     }
915                 }
916             }
917         }
918 
919         emit Transfer(from, to, tokenId);
920         _afterTokenTransfers(from, to, tokenId, 1);
921     }
922 
923     /**
924      * @dev Equivalent to `_burn(tokenId, false)`.
925      */
926     function _burn(uint256 tokenId) internal virtual {
927         _burn(tokenId, false);
928     }
929 
930     /**
931      * @dev Destroys `tokenId`.
932      * The approval is cleared when the token is burned.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
941         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
942 
943         address from = address(uint160(prevOwnershipPacked));
944 
945         if (approvalCheck) {
946             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
947                 isApprovedForAll(from, _msgSenderERC721A()) ||
948                 getApproved(tokenId) == _msgSenderERC721A());
949 
950             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
951         }
952 
953         _beforeTokenTransfers(from, address(0), tokenId, 1);
954 
955         // Clear approvals from the previous owner.
956         delete _tokenApprovals[tokenId];
957 
958         // Underflow of the sender's balance is impossible because we check for
959         // ownership above and the recipient's balance can't realistically overflow.
960         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
961         unchecked {
962             // Updates:
963             // - `balance -= 1`.
964             // - `numberBurned += 1`.
965             //
966             // We can directly decrement the balance, and increment the number burned.
967             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
968             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
969 
970             // Updates:
971             // - `address` to the last owner.
972             // - `startTimestamp` to the timestamp of burning.
973             // - `burned` to `true`.
974             // - `nextInitialized` to `true`.
975             _packedOwnerships[tokenId] =
976                 _addressToUint256(from) |
977                 (block.timestamp << BITPOS_START_TIMESTAMP) |
978                 BITMASK_BURNED | 
979                 BITMASK_NEXT_INITIALIZED;
980 
981             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
982             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
983                 uint256 nextTokenId = tokenId + 1;
984                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
985                 if (_packedOwnerships[nextTokenId] == 0) {
986                     // If the next slot is within bounds.
987                     if (nextTokenId != _currentIndex) {
988                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
989                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
990                     }
991                 }
992             }
993         }
994 
995         emit Transfer(from, address(0), tokenId);
996         _afterTokenTransfers(from, address(0), tokenId, 1);
997 
998         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
999         unchecked {
1000             _burnCounter++;
1001         }
1002     }
1003 
1004     /**
1005      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1006      *
1007      * @param from address representing the previous owner of the given token ID
1008      * @param to target address that will receive the tokens
1009      * @param tokenId uint256 ID of the token to be transferred
1010      * @param _data bytes optional data to send along with the call
1011      * @return bool whether the call correctly returned the expected magic value
1012      */
1013     function _checkContractOnERC721Received(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) private returns (bool) {
1019         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1020             bytes4 retval
1021         ) {
1022             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1023         } catch (bytes memory reason) {
1024             if (reason.length == 0) {
1025                 revert TransferToNonERC721ReceiverImplementer();
1026             } else {
1027                 assembly {
1028                     revert(add(32, reason), mload(reason))
1029                 }
1030             }
1031         }
1032     }
1033 
1034     /**
1035      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1036      * And also called before burning one token.
1037      *
1038      * startTokenId - the first token id to be transferred
1039      * quantity - the amount to be transferred
1040      *
1041      * Calling conditions:
1042      *
1043      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1044      * transferred to `to`.
1045      * - When `from` is zero, `tokenId` will be minted for `to`.
1046      * - When `to` is zero, `tokenId` will be burned by `from`.
1047      * - `from` and `to` are never both zero.
1048      */
1049     function _beforeTokenTransfers(
1050         address from,
1051         address to,
1052         uint256 startTokenId,
1053         uint256 quantity
1054     ) internal virtual {}
1055 
1056     /**
1057      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1058      * minting.
1059      * And also called after one token has been burned.
1060      *
1061      * startTokenId - the first token id to be transferred
1062      * quantity - the amount to be transferred
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` has been minted for `to`.
1069      * - When `to` is zero, `tokenId` has been burned by `from`.
1070      * - `from` and `to` are never both zero.
1071      */
1072     function _afterTokenTransfers(
1073         address from,
1074         address to,
1075         uint256 startTokenId,
1076         uint256 quantity
1077     ) internal virtual {}
1078 
1079     /**
1080      * @dev Returns the message sender (defaults to `msg.sender`).
1081      *
1082      * If you are writing GSN compatible contracts, you need to override this function.
1083      */
1084     function _msgSenderERC721A() internal view virtual returns (address) {
1085         return msg.sender;
1086     }
1087 
1088     /**
1089      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1090      */
1091     function _toString(uint256 value) internal pure returns (string memory ptr) {
1092         assembly {
1093             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1094             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1095             // We will need 1 32-byte word to store the length, 
1096             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1097             ptr := add(mload(0x40), 128)
1098             // Update the free memory pointer to allocate.
1099             mstore(0x40, ptr)
1100 
1101             // Cache the end of the memory to calculate the length later.
1102             let end := ptr
1103 
1104             // We write the string from the rightmost digit to the leftmost digit.
1105             // The following is essentially a do-while loop that also handles the zero case.
1106             // Costs a bit more than early returning for the zero case,
1107             // but cheaper in terms of deployment and overall runtime costs.
1108             for { 
1109                 // Initialize and perform the first pass without check.
1110                 let temp := value
1111                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1112                 ptr := sub(ptr, 1)
1113                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1114                 mstore8(ptr, add(48, mod(temp, 10)))
1115                 temp := div(temp, 10)
1116             } temp { 
1117                 // Keep dividing `temp` until zero.
1118                 temp := div(temp, 10)
1119             } { // Body of the for loop.
1120                 ptr := sub(ptr, 1)
1121                 mstore8(ptr, add(48, mod(temp, 10)))
1122             }
1123             
1124             let length := sub(end, ptr)
1125             // Move the pointer 32 bytes leftwards to make room for the length.
1126             ptr := sub(ptr, 32)
1127             // Store the length.
1128             mstore(ptr, length)
1129         }
1130     }
1131 }
1132 
1133 
1134 
1135 
1136 contract Insomniacs is ERC721A, Ownable {
1137   uint256 constant EXTRA_MINT_PRICE = 0.0066 ether;
1138   uint256 constant MAX_SUPPLY_PLUS_ONE = 6667;
1139   uint256 constant MAX_PER_TRANSACTION_PLUS_ONE = 7;
1140 
1141   string tokenBaseUri = "ipfs://TBA/";
1142 
1143   bool public paused = true;
1144 
1145   mapping(address => uint256) private _freeMintedCount;
1146 
1147   constructor() ERC721A("Insomniacs", "Insomniacs") {}
1148 
1149   function mint(uint256 _quantity) external payable {
1150     require(!paused, "Minting paused");
1151 
1152     uint256 _totalSupply = totalSupply();
1153 
1154     require(_totalSupply + _quantity < MAX_SUPPLY_PLUS_ONE, "Exceeds supply");
1155     require(_quantity < MAX_PER_TRANSACTION_PLUS_ONE, "Exceeds max per tx");
1156 
1157     uint256 payForCount = _quantity;
1158     uint256 freeMintCount = _freeMintedCount[msg.sender];
1159 
1160     if (freeMintCount < 1) {
1161       if (_quantity > 1) {
1162         payForCount = _quantity - 1;
1163       } else {
1164         payForCount = 0;
1165       }
1166 
1167       _freeMintedCount[msg.sender] = 1;
1168     }
1169 
1170     require(msg.value >= payForCount * EXTRA_MINT_PRICE, "ETH sent not correct");
1171 
1172     _mint(msg.sender, _quantity);
1173   }
1174 
1175   function freeMintedCount(address owner) external view returns (uint256) {
1176     return _freeMintedCount[owner];
1177   }
1178 
1179   function _startTokenId() internal pure override returns (uint256) {
1180     return 1;
1181   }
1182 
1183   function _baseURI() internal view override returns (string memory) {
1184     return tokenBaseUri;
1185   }
1186 
1187   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1188     tokenBaseUri = _newBaseUri;
1189   }
1190 
1191   function flipSale() external onlyOwner {
1192     paused = !paused;
1193   }
1194 
1195   function collectReserves() external onlyOwner {
1196     require(totalSupply() == 0, "Reserves already taken");
1197 
1198     _mint(msg.sender, 100);
1199   }
1200 
1201   function withdraw() external onlyOwner {
1202     require(
1203       payable(owner()).send(address(this).balance),
1204       "Withdraw unsuccessful"
1205     );
1206   }
1207 }