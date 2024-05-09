1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 interface IOperatorFilterRegistry {
6     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
7     function register(address registrant) external;
8     function registerAndSubscribe(address registrant, address subscription) external;
9     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
10     function unregister(address addr) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 pragma solidity ^0.8.13;
33 
34 
35 /**
36  * @title  OperatorFilterer
37  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
38  *         registrant's entries in the OperatorFilterRegistry.
39  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
40  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
41  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
42  */
43 abstract contract OperatorFilterer {
44     error OperatorNotAllowed(address operator);
45 
46     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
47         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
48 
49     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
50         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
51         // will not revert, but the contract will need to be registered with the registry once it is deployed in
52         // order for the modifier to filter addresses.
53         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
54             if (subscribe) {
55                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
56             } else {
57                 if (subscriptionOrRegistrantToCopy != address(0)) {
58                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
59                 } else {
60                     OPERATOR_FILTER_REGISTRY.register(address(this));
61                 }
62             }
63         }
64     }
65 
66     modifier onlyAllowedOperator(address from) virtual {
67         // Allow spending tokens from addresses with balance
68         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
69         // from an EOA.
70         if (from != msg.sender) {
71             _checkFilterOperator(msg.sender);
72         }
73         _;
74     }
75 
76     modifier onlyAllowedOperatorApproval(address operator) virtual {
77         _checkFilterOperator(operator);
78         _;
79     }
80 
81     function _checkFilterOperator(address operator) internal view virtual {
82         // Check registry code length to facilitate testing in environments without a deployed registry.
83         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
84             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
85                 revert OperatorNotAllowed(operator);
86             }
87         }
88     }
89 }
90 
91 // ERC721A Contracts v4.0.0
92 // Creator: Chiru Labs
93 
94 pragma solidity ^0.8.4;
95 
96 /**
97  * @dev Interface of an ERC721A compliant contract.
98  */
99 interface IERC721A {
100     /**
101      * The caller must own the token or be an approved operator.
102      */
103     error ApprovalCallerNotOwnerNorApproved();
104 
105     /**
106      * The token does not exist.
107      */
108     error ApprovalQueryForNonexistentToken();
109 
110     /**
111      * The caller cannot approve to their own address.
112      */
113     error ApproveToCaller();
114 
115     /**
116      * The caller cannot approve to the current owner.
117      */
118     error ApprovalToCurrentOwner();
119 
120     /**
121      * Cannot query the balance for the zero address.
122      */
123     error BalanceQueryForZeroAddress();
124 
125     /**
126      * Cannot mint to the zero address.
127      */
128     error MintToZeroAddress();
129 
130     /**
131      * The quantity of tokens minted must be more than zero.
132      */
133     error MintZeroQuantity();
134 
135     /**
136      * The token does not exist.
137      */
138     error OwnerQueryForNonexistentToken();
139 
140     /**
141      * The caller must own the token or be an approved operator.
142      */
143     error TransferCallerNotOwnerNorApproved();
144 
145     /**
146      * The token must be owned by `from`.
147      */
148     error TransferFromIncorrectOwner();
149 
150     /**
151      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
152      */
153     error TransferToNonERC721ReceiverImplementer();
154 
155     /**
156      * Cannot transfer to the zero address.
157      */
158     error TransferToZeroAddress();
159 
160     /**
161      * The token does not exist.
162      */
163     error URIQueryForNonexistentToken();
164 
165     struct TokenOwnership {
166         // The address of the owner.
167         address addr;
168         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
169         uint64 startTimestamp;
170         // Whether the token has been burned.
171         bool burned;
172     }
173 
174     /**
175      * @dev Returns the total amount of tokens stored by the contract.
176      *
177      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     // ==============================
182     //            IERC165
183     // ==============================
184 
185     /**
186      * @dev Returns true if this contract implements the interface defined by
187      * `interfaceId`. See the corresponding
188      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
189      * to learn more about how these ids are created.
190      *
191      * This function call must use less than 30 000 gas.
192      */
193     function supportsInterface(bytes4 interfaceId) external view returns (bool);
194 
195     // ==============================
196     //            IERC721
197     // ==============================
198 
199     /**
200      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
203 
204     /**
205      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
206      */
207     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
208 
209     /**
210      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
211      */
212     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
213 
214     /**
215      * @dev Returns the number of tokens in ``owner``'s account.
216      */
217     function balanceOf(address owner) external view returns (uint256 balance);
218 
219     /**
220      * @dev Returns the owner of the `tokenId` token.
221      *
222      * Requirements:
223      *
224      * - `tokenId` must exist.
225      */
226     function ownerOf(uint256 tokenId) external view returns (address owner);
227 
228     /**
229      * @dev Safely transfers `tokenId` token from `from` to `to`.
230      *
231      * Requirements:
232      *
233      * - `from` cannot be the zero address.
234      * - `to` cannot be the zero address.
235      * - `tokenId` token must exist and be owned by `from`.
236      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238      *
239      * Emits a {Transfer} event.
240      */
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId,
245         bytes calldata data
246     ) external;
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
250      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
251      *
252      * Requirements:
253      *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `tokenId` token must exist and be owned by `from`.
257      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
258      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
259      *
260      * Emits a {Transfer} event.
261      */
262     function safeTransferFrom(
263         address from,
264         address to,
265         uint256 tokenId
266     ) external;
267 
268     /**
269      * @dev Transfers `tokenId` token from `from` to `to`.
270      *
271      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must be owned by `from`.
278      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     /**
289      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
290      * The approval is cleared when the token is transferred.
291      *
292      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
293      *
294      * Requirements:
295      *
296      * - The caller must own the token or be an approved operator.
297      * - `tokenId` must exist.
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address to, uint256 tokenId) external;
302 
303     /**
304      * @dev Approve or remove `operator` as an operator for the caller.
305      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
306      *
307      * Requirements:
308      *
309      * - The `operator` cannot be the caller.
310      *
311      * Emits an {ApprovalForAll} event.
312      */
313     function setApprovalForAll(address operator, bool _approved) external;
314 
315     /**
316      * @dev Returns the account approved for `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function getApproved(uint256 tokenId) external view returns (address operator);
323 
324     /**
325      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
326      *
327      * See {setApprovalForAll}
328      */
329     function isApprovedForAll(address owner, address operator) external view returns (bool);
330 
331     // ==============================
332     //        IERC721Metadata
333     // ==============================
334 
335     /**
336      * @dev Returns the token collection name.
337      */
338     function name() external view returns (string memory);
339 
340     /**
341      * @dev Returns the token collection symbol.
342      */
343     function symbol() external view returns (string memory);
344 
345     /**
346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
347      */
348     function tokenURI(uint256 tokenId) external view returns (string memory);
349 }
350 
351 
352 // ERC721A Contracts v4.0.0
353 // Creator: Chiru Labs
354 
355 pragma solidity ^0.8.4;
356 
357 
358 /**
359  * @dev ERC721 token receiver interface.
360  */
361 interface ERC721A__IERC721Receiver {
362     function onERC721Received(
363         address operator,
364         address from,
365         uint256 tokenId,
366         bytes calldata data
367     ) external returns (bytes4);
368 }
369 
370 /**
371  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
372  * the Metadata extension. Built to optimize for lower gas during batch mints.
373  *
374  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
375  *
376  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
377  *
378  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
379  */
380 contract ERC721A is IERC721A {
381     // Mask of an entry in packed address data.
382     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
383 
384     // The bit position of `numberMinted` in packed address data.
385     uint256 private constant BITPOS_NUMBER_MINTED = 64;
386 
387     // The bit position of `numberBurned` in packed address data.
388     uint256 private constant BITPOS_NUMBER_BURNED = 128;
389 
390     // The bit position of `aux` in packed address data.
391     uint256 private constant BITPOS_AUX = 192;
392 
393     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
394     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
395 
396     // The bit position of `startTimestamp` in packed ownership.
397     uint256 private constant BITPOS_START_TIMESTAMP = 160;
398 
399     // The bit mask of the `burned` bit in packed ownership.
400     uint256 private constant BITMASK_BURNED = 1 << 224;
401     
402     // The bit position of the `nextInitialized` bit in packed ownership.
403     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
404 
405     // The bit mask of the `nextInitialized` bit in packed ownership.
406     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
407 
408     // The tokenId of the next token to be minted.
409     uint256 private _currentIndex;
410 
411     // The number of tokens burned.
412     uint256 private _burnCounter;
413 
414     // Token name
415     string private _name;
416 
417     // Token symbol
418     string private _symbol;
419 
420     // Mapping from token ID to ownership details
421     // An empty struct value does not necessarily mean the token is unowned.
422     // See `_packedOwnershipOf` implementation for details.
423     //
424     // Bits Layout:
425     // - [0..159]   `addr`
426     // - [160..223] `startTimestamp`
427     // - [224]      `burned`
428     // - [225]      `nextInitialized`
429     mapping(uint256 => uint256) private _packedOwnerships;
430 
431     // Mapping owner address to address data.
432     //
433     // Bits Layout:
434     // - [0..63]    `balance`
435     // - [64..127]  `numberMinted`
436     // - [128..191] `numberBurned`
437     // - [192..255] `aux`
438     mapping(address => uint256) private _packedAddressData;
439 
440     // Mapping from token ID to approved address.
441     mapping(uint256 => address) private _tokenApprovals;
442 
443     // Mapping from owner to operator approvals
444     mapping(address => mapping(address => bool)) private _operatorApprovals;
445 
446     constructor(string memory name_, string memory symbol_) {
447         _name = name_;
448         _symbol = symbol_;
449         _currentIndex = _startTokenId();
450     }
451 
452     /**
453      * @dev Returns the starting token ID. 
454      * To change the starting token ID, please override this function.
455      */
456     function _startTokenId() internal view virtual returns (uint256) {
457         return 0;
458     }
459 
460     /**
461      * @dev Returns the next token ID to be minted.
462      */
463     function _nextTokenId() internal view returns (uint256) {
464         return _currentIndex;
465     }
466 
467     /**
468      * @dev Returns the total number of tokens in existence.
469      * Burned tokens will reduce the count. 
470      * To get the total number of tokens minted, please see `_totalMinted`.
471      */
472     function totalSupply() public view override returns (uint256) {
473         // Counter underflow is impossible as _burnCounter cannot be incremented
474         // more than `_currentIndex - _startTokenId()` times.
475         unchecked {
476             return _currentIndex - _burnCounter - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total amount of tokens minted in the contract.
482      */
483     function _totalMinted() internal view returns (uint256) {
484         // Counter underflow is impossible as _currentIndex does not decrement,
485         // and it is initialized to `_startTokenId()`
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total number of tokens burned.
493      */
494     function _totalBurned() internal view returns (uint256) {
495         return _burnCounter;
496     }
497 
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         // The interface IDs are constants representing the first 4 bytes of the XOR of
503         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
504         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
505         return
506             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
507             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
508             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
509     }
510 
511     /**
512      * @dev See {IERC721-balanceOf}.
513      */
514     function balanceOf(address owner) public view override returns (uint256) {
515         if (owner == address(0)) revert BalanceQueryForZeroAddress();
516         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the number of tokens minted by `owner`.
521      */
522     function _numberMinted(address owner) internal view returns (uint256) {
523         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
524     }
525 
526     /**
527      * Returns the number of tokens burned by or on behalf of `owner`.
528      */
529     function _numberBurned(address owner) internal view returns (uint256) {
530         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
531     }
532 
533     /**
534      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
535      */
536     function _getAux(address owner) internal view returns (uint64) {
537         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
538     }
539 
540     /**
541      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
542      * If there are multiple variables, please pack them into a uint64.
543      */
544     function _setAux(address owner, uint64 aux) internal {
545         uint256 packed = _packedAddressData[owner];
546         uint256 auxCasted;
547         assembly { // Cast aux without masking.
548             auxCasted := aux
549         }
550         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
551         _packedAddressData[owner] = packed;
552     }
553 
554     /**
555      * Returns the packed ownership data of `tokenId`.
556      */
557     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
558         uint256 curr = tokenId;
559 
560         unchecked {
561             if (_startTokenId() <= curr)
562                 if (curr < _currentIndex) {
563                     uint256 packed = _packedOwnerships[curr];
564                     // If not burned.
565                     if (packed & BITMASK_BURNED == 0) {
566                         // Invariant:
567                         // There will always be an ownership that has an address and is not burned
568                         // before an ownership that does not have an address and is not burned.
569                         // Hence, curr will not underflow.
570                         //
571                         // We can directly compare the packed value.
572                         // If the address is zero, packed is zero.
573                         while (packed == 0) {
574                             packed = _packedOwnerships[--curr];
575                         }
576                         return packed;
577                     }
578                 }
579         }
580         revert OwnerQueryForNonexistentToken();
581     }
582 
583     /**
584      * Returns the unpacked `TokenOwnership` struct from `packed`.
585      */
586     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
587         ownership.addr = address(uint160(packed));
588         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
589         ownership.burned = packed & BITMASK_BURNED != 0;
590     }
591 
592     /**
593      * Returns the unpacked `TokenOwnership` struct at `index`.
594      */
595     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
596         return _unpackedOwnership(_packedOwnerships[index]);
597     }
598 
599     /**
600      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
601      */
602     function _initializeOwnershipAt(uint256 index) internal {
603         if (_packedOwnerships[index] == 0) {
604             _packedOwnerships[index] = _packedOwnershipOf(index);
605         }
606     }
607 
608     /**
609      * Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
611      */
612     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnershipOf(tokenId));
614     }
615 
616     /**
617      * @dev See {IERC721-ownerOf}.
618      */
619     function ownerOf(uint256 tokenId) public view override returns (address) {
620         return address(uint160(_packedOwnershipOf(tokenId)));
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-name}.
625      */
626     function name() public view virtual override returns (string memory) {
627         return _name;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-symbol}.
632      */
633     function symbol() public view virtual override returns (string memory) {
634         return _symbol;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-tokenURI}.
639      */
640     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
641         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
642 
643         string memory baseURI = _baseURI();
644         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
645     }
646 
647     /**
648      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
649      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
650      * by default, can be overriden in child contracts.
651      */
652     function _baseURI() internal view virtual returns (string memory) {
653         return '';
654     }
655 
656     /**
657      * @dev Casts the address to uint256 without masking.
658      */
659     function _addressToUint256(address value) private pure returns (uint256 result) {
660         assembly {
661             result := value
662         }
663     }
664 
665     /**
666      * @dev Casts the boolean to uint256 without branching.
667      */
668     function _boolToUint256(bool value) private pure returns (uint256 result) {
669         assembly {
670             result := value
671         }
672     }
673 
674     /**
675      * @dev See {IERC721-approve}.
676      */
677     function approve(address to, uint256 tokenId) public virtual override {
678         address owner = address(uint160(_packedOwnershipOf(tokenId)));
679         if (to == owner) revert ApprovalToCurrentOwner();
680 
681         if (_msgSenderERC721A() != owner)
682             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
683                 revert ApprovalCallerNotOwnerNorApproved();
684             }
685 
686         _tokenApprovals[tokenId] = to;
687         emit Approval(owner, to, tokenId);
688     }
689 
690     /**
691      * @dev See {IERC721-getApproved}.
692      */
693     function getApproved(uint256 tokenId) public view override returns (address) {
694         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
695 
696         return _tokenApprovals[tokenId];
697     }
698 
699     /**
700      * @dev See {IERC721-setApprovalForAll}.
701      */
702     function setApprovalForAll(address operator, bool approved) public virtual override {
703         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
704 
705         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
706         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
707     }
708 
709     /**
710      * @dev See {IERC721-isApprovedForAll}.
711      */
712     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
713         return _operatorApprovals[owner][operator];
714     }
715 
716     /**
717      * @dev See {IERC721-transferFrom}.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         _transfer(from, to, tokenId);
725     }
726 
727     /**
728      * @dev See {IERC721-safeTransferFrom}.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         safeTransferFrom(from, to, tokenId, '');
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes memory _data
746     ) public virtual override {
747         _transfer(from, to, tokenId);
748         if (to.code.length != 0)
749             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
750                 revert TransferToNonERC721ReceiverImplementer();
751             }
752     }
753 
754     /**
755      * @dev Returns whether `tokenId` exists.
756      *
757      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
758      *
759      * Tokens start existing when they are minted (`_mint`),
760      */
761     function _exists(uint256 tokenId) internal view returns (bool) {
762         return
763             _startTokenId() <= tokenId &&
764             tokenId < _currentIndex && // If within bounds,
765             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
766     }
767 
768     /**
769      * @dev Equivalent to `_safeMint(to, quantity, '')`.
770      */
771     function _safeMint(address to, uint256 quantity) internal {
772         _safeMint(to, quantity, '');
773     }
774 
775     /**
776      * @dev Safely mints `quantity` tokens and transfers them to `to`.
777      *
778      * Requirements:
779      *
780      * - If `to` refers to a smart contract, it must implement
781      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
782      * - `quantity` must be greater than 0.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _safeMint(
787         address to,
788         uint256 quantity,
789         bytes memory _data
790     ) internal {
791         uint256 startTokenId = _currentIndex;
792         if (to == address(0)) revert MintToZeroAddress();
793         if (quantity == 0) revert MintZeroQuantity();
794 
795         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
796 
797         // Overflows are incredibly unrealistic.
798         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
799         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
800         unchecked {
801             // Updates:
802             // - `balance += quantity`.
803             // - `numberMinted += quantity`.
804             //
805             // We can directly add to the balance and number minted.
806             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
807 
808             // Updates:
809             // - `address` to the owner.
810             // - `startTimestamp` to the timestamp of minting.
811             // - `burned` to `false`.
812             // - `nextInitialized` to `quantity == 1`.
813             _packedOwnerships[startTokenId] =
814                 _addressToUint256(to) |
815                 (block.timestamp << BITPOS_START_TIMESTAMP) |
816                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
817 
818             uint256 updatedIndex = startTokenId;
819             uint256 end = updatedIndex + quantity;
820 
821             if (to.code.length != 0) {
822                 do {
823                     emit Transfer(address(0), to, updatedIndex);
824                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
825                         revert TransferToNonERC721ReceiverImplementer();
826                     }
827                 } while (updatedIndex < end);
828                 // Reentrancy protection
829                 if (_currentIndex != startTokenId) revert();
830             } else {
831                 do {
832                     emit Transfer(address(0), to, updatedIndex++);
833                 } while (updatedIndex < end);
834             }
835             _currentIndex = updatedIndex;
836         }
837         _afterTokenTransfers(address(0), to, startTokenId, quantity);
838     }
839 
840     /**
841      * @dev Mints `quantity` tokens and transfers them to `to`.
842      *
843      * Requirements:
844      *
845      * - `to` cannot be the zero address.
846      * - `quantity` must be greater than 0.
847      *
848      * Emits a {Transfer} event.
849      */
850     function _mint(address to, uint256 quantity) internal {
851         uint256 startTokenId = _currentIndex;
852         if (to == address(0)) revert MintToZeroAddress();
853         if (quantity == 0) revert MintZeroQuantity();
854 
855         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
856 
857         // Overflows are incredibly unrealistic.
858         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
859         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
860         unchecked {
861             // Updates:
862             // - `balance += quantity`.
863             // - `numberMinted += quantity`.
864             //
865             // We can directly add to the balance and number minted.
866             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
867 
868             // Updates:
869             // - `address` to the owner.
870             // - `startTimestamp` to the timestamp of minting.
871             // - `burned` to `false`.
872             // - `nextInitialized` to `quantity == 1`.
873             _packedOwnerships[startTokenId] =
874                 _addressToUint256(to) |
875                 (block.timestamp << BITPOS_START_TIMESTAMP) |
876                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
877 
878             uint256 updatedIndex = startTokenId;
879             uint256 end = updatedIndex + quantity;
880 
881             do {
882                 emit Transfer(address(0), to, updatedIndex++);
883             } while (updatedIndex < end);
884 
885             _currentIndex = updatedIndex;
886         }
887         _afterTokenTransfers(address(0), to, startTokenId, quantity);
888     }
889 
890     /**
891      * @dev Transfers `tokenId` from `from` to `to`.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must be owned by `from`.
897      *
898      * Emits a {Transfer} event.
899      */
900     function _transfer(
901         address from,
902         address to,
903         uint256 tokenId
904     ) private {
905         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
906 
907         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
908 
909         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
910             isApprovedForAll(from, _msgSenderERC721A()) ||
911             getApproved(tokenId) == _msgSenderERC721A());
912 
913         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
914         if (to == address(0)) revert TransferToZeroAddress();
915 
916         _beforeTokenTransfers(from, to, tokenId, 1);
917 
918         // Clear approvals from the previous owner.
919         delete _tokenApprovals[tokenId];
920 
921         // Underflow of the sender's balance is impossible because we check for
922         // ownership above and the recipient's balance can't realistically overflow.
923         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
924         unchecked {
925             // We can directly increment and decrement the balances.
926             --_packedAddressData[from]; // Updates: `balance -= 1`.
927             ++_packedAddressData[to]; // Updates: `balance += 1`.
928 
929             // Updates:
930             // - `address` to the next owner.
931             // - `startTimestamp` to the timestamp of transfering.
932             // - `burned` to `false`.
933             // - `nextInitialized` to `true`.
934             _packedOwnerships[tokenId] =
935                 _addressToUint256(to) |
936                 (block.timestamp << BITPOS_START_TIMESTAMP) |
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
953         emit Transfer(from, to, tokenId);
954         _afterTokenTransfers(from, to, tokenId, 1);
955     }
956 
957     /**
958      * @dev Equivalent to `_burn(tokenId, false)`.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         _burn(tokenId, false);
962     }
963 
964     /**
965      * @dev Destroys `tokenId`.
966      * The approval is cleared when the token is burned.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
975         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
976 
977         address from = address(uint160(prevOwnershipPacked));
978 
979         if (approvalCheck) {
980             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
981                 isApprovedForAll(from, _msgSenderERC721A()) ||
982                 getApproved(tokenId) == _msgSenderERC721A());
983 
984             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
985         }
986 
987         _beforeTokenTransfers(from, address(0), tokenId, 1);
988 
989         // Clear approvals from the previous owner.
990         delete _tokenApprovals[tokenId];
991 
992         // Underflow of the sender's balance is impossible because we check for
993         // ownership above and the recipient's balance can't realistically overflow.
994         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
995         unchecked {
996             // Updates:
997             // - `balance -= 1`.
998             // - `numberBurned += 1`.
999             //
1000             // We can directly decrement the balance, and increment the number burned.
1001             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1002             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1003 
1004             // Updates:
1005             // - `address` to the last owner.
1006             // - `startTimestamp` to the timestamp of burning.
1007             // - `burned` to `true`.
1008             // - `nextInitialized` to `true`.
1009             _packedOwnerships[tokenId] =
1010                 _addressToUint256(from) |
1011                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1012                 BITMASK_BURNED | 
1013                 BITMASK_NEXT_INITIALIZED;
1014 
1015             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1016             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1017                 uint256 nextTokenId = tokenId + 1;
1018                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1019                 if (_packedOwnerships[nextTokenId] == 0) {
1020                     // If the next slot is within bounds.
1021                     if (nextTokenId != _currentIndex) {
1022                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1023                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1024                     }
1025                 }
1026             }
1027         }
1028 
1029         emit Transfer(from, address(0), tokenId);
1030         _afterTokenTransfers(from, address(0), tokenId, 1);
1031 
1032         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1033         unchecked {
1034             _burnCounter++;
1035         }
1036     }
1037 
1038     /**
1039      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkContractOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1054             bytes4 retval
1055         ) {
1056             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1057         } catch (bytes memory reason) {
1058             if (reason.length == 0) {
1059                 revert TransferToNonERC721ReceiverImplementer();
1060             } else {
1061                 assembly {
1062                     revert(add(32, reason), mload(reason))
1063                 }
1064             }
1065         }
1066     }
1067 
1068     /**
1069      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1070      * And also called before burning one token.
1071      *
1072      * startTokenId - the first token id to be transferred
1073      * quantity - the amount to be transferred
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` will be minted for `to`.
1080      * - When `to` is zero, `tokenId` will be burned by `from`.
1081      * - `from` and `to` are never both zero.
1082      */
1083     function _beforeTokenTransfers(
1084         address from,
1085         address to,
1086         uint256 startTokenId,
1087         uint256 quantity
1088     ) internal virtual {}
1089 
1090     /**
1091      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1092      * minting.
1093      * And also called after one token has been burned.
1094      *
1095      * startTokenId - the first token id to be transferred
1096      * quantity - the amount to be transferred
1097      *
1098      * Calling conditions:
1099      *
1100      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1101      * transferred to `to`.
1102      * - When `from` is zero, `tokenId` has been minted for `to`.
1103      * - When `to` is zero, `tokenId` has been burned by `from`.
1104      * - `from` and `to` are never both zero.
1105      */
1106     function _afterTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 
1113     /**
1114      * @dev Returns the message sender (defaults to `msg.sender`).
1115      *
1116      * If you are writing GSN compatible contracts, you need to override this function.
1117      */
1118     function _msgSenderERC721A() internal view virtual returns (address) {
1119         return msg.sender;
1120     }
1121 
1122     /**
1123      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1124      */
1125     function _toString(uint256 value) internal pure returns (string memory ptr) {
1126         assembly {
1127             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1128             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1129             // We will need 1 32-byte word to store the length, 
1130             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1131             ptr := add(mload(0x40), 128)
1132             // Update the free memory pointer to allocate.
1133             mstore(0x40, ptr)
1134 
1135             // Cache the end of the memory to calculate the length later.
1136             let end := ptr
1137 
1138             // We write the string from the rightmost digit to the leftmost digit.
1139             // The following is essentially a do-while loop that also handles the zero case.
1140             // Costs a bit more than early returning for the zero case,
1141             // but cheaper in terms of deployment and overall runtime costs.
1142             for { 
1143                 // Initialize and perform the first pass without check.
1144                 let temp := value
1145                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1146                 ptr := sub(ptr, 1)
1147                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1148                 mstore8(ptr, add(48, mod(temp, 10)))
1149                 temp := div(temp, 10)
1150             } temp { 
1151                 // Keep dividing `temp` until zero.
1152                 temp := div(temp, 10)
1153             } { // Body of the for loop.
1154                 ptr := sub(ptr, 1)
1155                 mstore8(ptr, add(48, mod(temp, 10)))
1156             }
1157             
1158             let length := sub(end, ptr)
1159             // Move the pointer 32 bytes leftwards to make room for the length.
1160             ptr := sub(ptr, 32)
1161             // Store the length.
1162             mstore(ptr, length)
1163         }
1164     }
1165 }
1166 
1167 
1168 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 /**
1173  * @dev String operations.
1174  */
1175 library Strings {
1176     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1177 
1178     /**
1179      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1180      */
1181     function toString(uint256 value) internal pure returns (string memory) {
1182         // Inspired by OraclizeAPI's implementation - MIT licence
1183         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1184 
1185         if (value == 0) {
1186             return "0";
1187         }
1188         uint256 temp = value;
1189         uint256 digits;
1190         while (temp != 0) {
1191             digits++;
1192             temp /= 10;
1193         }
1194         bytes memory buffer = new bytes(digits);
1195         while (value != 0) {
1196             digits -= 1;
1197             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1198             value /= 10;
1199         }
1200         return string(buffer);
1201     }
1202 
1203     /**
1204      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1205      */
1206     function toHexString(uint256 value) internal pure returns (string memory) {
1207         if (value == 0) {
1208             return "0x00";
1209         }
1210         uint256 temp = value;
1211         uint256 length = 0;
1212         while (temp != 0) {
1213             length++;
1214             temp >>= 8;
1215         }
1216         return toHexString(value, length);
1217     }
1218 
1219     /**
1220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1221      */
1222     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1223         bytes memory buffer = new bytes(2 * length + 2);
1224         buffer[0] = "0";
1225         buffer[1] = "x";
1226         for (uint256 i = 2 * length + 1; i > 1; --i) {
1227             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1228             value >>= 4;
1229         }
1230         require(value == 0, "Strings: hex length insufficient");
1231         return string(buffer);
1232     }
1233 }
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 /**
1241  * @dev Contract module that helps prevent reentrant calls to a function.
1242  *
1243  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1244  * available, which can be applied to functions to make sure there are no nested
1245  * (reentrant) calls to them.
1246  *
1247  * Note that because there is a single `nonReentrant` guard, functions marked as
1248  * `nonReentrant` may not call one another. This can be worked around by making
1249  * those functions `private`, and then adding `external` `nonReentrant` entry
1250  * points to them.
1251  *
1252  * TIP: If you would like to learn more about reentrancy and alternative ways
1253  * to protect against it, check out our blog post
1254  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1255  */
1256 abstract contract ReentrancyGuard {
1257     // Booleans are more expensive than uint256 or any type that takes up a full
1258     // word because each write operation emits an extra SLOAD to first read the
1259     // slot's contents, replace the bits taken up by the boolean, and then write
1260     // back. This is the compiler's defense against contract upgrades and
1261     // pointer aliasing, and it cannot be disabled.
1262 
1263     // The values being non-zero value makes deployment a bit more expensive,
1264     // but in exchange the refund on every call to nonReentrant will be lower in
1265     // amount. Since refunds are capped to a percentage of the total
1266     // transaction's gas, it is best to keep them low in cases like this one, to
1267     // increase the likelihood of the full refund coming into effect.
1268     uint256 private constant _NOT_ENTERED = 1;
1269     uint256 private constant _ENTERED = 2;
1270 
1271     uint256 private _status;
1272 
1273     constructor() {
1274         _status = _NOT_ENTERED;
1275     }
1276 
1277     /**
1278      * @dev Prevents a contract from calling itself, directly or indirectly.
1279      * Calling a `nonReentrant` function from another `nonReentrant`
1280      * function is not supported. It is possible to prevent this from happening
1281      * by making the `nonReentrant` function external, and making it call a
1282      * `private` function that does the actual work.
1283      */
1284     modifier nonReentrant() {
1285         // On the first call to nonReentrant, _notEntered will be true
1286         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1287 
1288         // Any calls to nonReentrant after this point will fail
1289         _status = _ENTERED;
1290 
1291         _;
1292 
1293         // By storing the original value once again, a refund is triggered (see
1294         // https://eips.ethereum.org/EIPS/eip-2200)
1295         _status = _NOT_ENTERED;
1296     }
1297 }
1298 
1299 
1300 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 /**
1305  * @dev Provides information about the current execution context, including the
1306  * sender of the transaction and its data. While these are generally available
1307  * via msg.sender and msg.data, they should not be accessed in such a direct
1308  * manner, since when dealing with meta-transactions the account sending and
1309  * paying for execution may not be the actual sender (as far as an application
1310  * is concerned).
1311  *
1312  * This contract is only required for intermediate, library-like contracts.
1313  */
1314 abstract contract Context {
1315     function _msgSender() internal view virtual returns (address) {
1316         return msg.sender;
1317     }
1318 
1319     function _msgData() internal view virtual returns (bytes calldata) {
1320         return msg.data;
1321     }
1322 }
1323 
1324 
1325 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1326 
1327 pragma solidity ^0.8.0;
1328 
1329 
1330 /**
1331  * @dev Contract module which provides a basic access control mechanism, where
1332  * there is an account (an owner) that can be granted exclusive access to
1333  * specific functions.
1334  *
1335  * By default, the owner account will be the one that deploys the contract. This
1336  * can later be changed with {transferOwnership}.
1337  *
1338  * This module is used through inheritance. It will make available the modifier
1339  * `onlyOwner`, which can be applied to your functions to restrict their use to
1340  * the owner.
1341  */
1342 abstract contract Ownable is Context {
1343     address private _owner;
1344 
1345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1346 
1347     /**
1348      * @dev Initializes the contract setting the deployer as the initial owner.
1349      */
1350     constructor() {
1351         _transferOwnership(_msgSender());
1352     }
1353 
1354     /**
1355      * @dev Returns the address of the current owner.
1356      */
1357     function owner() public view virtual returns (address) {
1358         return _owner;
1359     }
1360 
1361     /**
1362      * @dev Throws if called by any account other than the owner.
1363      */
1364     modifier onlyOwner() {
1365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1366         _;
1367     }
1368 
1369     /**
1370      * @dev Leaves the contract without owner. It will not be possible to call
1371      * `onlyOwner` functions anymore. Can only be called by the current owner.
1372      *
1373      * NOTE: Renouncing ownership will leave the contract without an owner,
1374      * thereby removing any functionality that is only available to the owner.
1375      */
1376     function renounceOwnership() public virtual onlyOwner {
1377         _transferOwnership(address(0));
1378     }
1379 
1380     /**
1381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1382      * Can only be called by the current owner.
1383      */
1384     function transferOwnership(address newOwner) public virtual onlyOwner {
1385         require(newOwner != address(0), "Ownable: new owner is the zero address");
1386         _transferOwnership(newOwner);
1387     }
1388 
1389     /**
1390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1391      * Internal function without access restriction.
1392      */
1393     function _transferOwnership(address newOwner) internal virtual {
1394         address oldOwner = _owner;
1395         _owner = newOwner;
1396         emit OwnershipTransferred(oldOwner, newOwner);
1397     }
1398 }
1399 
1400 pragma solidity >=0.8.9 <0.9.0;
1401 
1402 contract FoxFamily is ERC721A, Ownable, ReentrancyGuard, OperatorFilterer {
1403   using Strings for uint256;
1404 
1405   string public uriPrefix = '';
1406   string public uriSuffix = '.json';
1407   string public hiddenMetadataUri;
1408 
1409   uint256 public cost = 0.015 ether;
1410   uint256 public maxNFTs = 3333;
1411   uint256 public maxPerTxn = 5;
1412   uint256 public maxMintAmount = 5;
1413 
1414   bool public paused = true;
1415   bool public revealed = true;
1416 
1417   constructor(
1418     string memory _tokenName,
1419     string memory _tokenSymbol
1420   ) ERC721A(_tokenName, _tokenSymbol) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), false) {}
1421 
1422   modifier mintCompliance(uint256 _mintAmount) {
1423     require(!paused, "Minting has not started yet.");
1424     require(_mintAmount > 0 && _mintAmount <= maxPerTxn, "You can only mint 5 foxes per transaction.");
1425     require(totalSupply() + _mintAmount <= maxNFTs, "There are no foxes lefts!");
1426     require(tx.origin == msg.sender, "No minting with smart contract.");
1427     require(
1428       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1429        "You have minted the max number of foxes!"
1430     );
1431     require(msg.value >= cost * _mintAmount, "Insufficient or incorrect funds.");
1432     _;
1433   }
1434 
1435   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1436     _safeMint(_msgSender(), _mintAmount);
1437   }
1438   
1439   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1440     require(totalSupply() + _mintAmount <= maxNFTs, "Max supply exceeded!");
1441     _safeMint(_receiver, _mintAmount);
1442   }
1443 
1444   function _startTokenId() internal view virtual override returns (uint256) {
1445     return 1;
1446   }
1447 
1448   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1449     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1450 
1451     if (revealed == false) {
1452       return hiddenMetadataUri;
1453     }
1454 
1455     string memory currentBaseURI = _baseURI();
1456     return bytes(currentBaseURI).length > 0
1457         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1458         : '';
1459   }
1460 
1461   function setCost(uint256 _cost) public onlyOwner {
1462     cost = _cost;
1463   }
1464 
1465   function setRevealed(bool _state) public onlyOwner {
1466     revealed = _state;
1467   }
1468 
1469    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1470     hiddenMetadataUri = _hiddenMetadataUri;
1471   }
1472 
1473   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1474     uriPrefix = _uriPrefix;
1475   }
1476 
1477   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1478     uriSuffix = _uriSuffix;
1479   }
1480 
1481   function setPaused(bool _state) public onlyOwner {
1482     paused = _state;
1483   }
1484 
1485   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1486     maxMintAmount = _maxMintAmount;
1487   }
1488 
1489   function withdraw() public onlyOwner nonReentrant {
1490     (bool withdrawFunds, ) = payable(owner()).call{value: address(this).balance}("");
1491     require(withdrawFunds);
1492   }
1493 
1494   function numberMinted(address owner) public view returns (uint256) {
1495     return _numberMinted(owner);
1496   }
1497 
1498   function _baseURI() internal view virtual override returns (string memory) {
1499     return uriPrefix;
1500   }
1501 
1502   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1503         super.setApprovalForAll(operator, approved);
1504   }
1505 
1506   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1507         super.approve(operator, tokenId);
1508   }
1509 
1510   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1511         super.transferFrom(from, to, tokenId);
1512   }
1513 
1514   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1515         super.safeTransferFrom(from, to, tokenId);
1516   }
1517 
1518   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1519         public
1520         override
1521         onlyAllowedOperator(from)
1522   {
1523         super.safeTransferFrom(from, to, tokenId, data);
1524   }
1525 
1526 }