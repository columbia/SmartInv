1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: contracts/IERC721A.sol
97 
98 
99 // ERC721A Contracts v4.0.0
100 // Creator: Chiru Labs
101 
102 pragma solidity ^0.8.4;
103 
104 /**
105  * @dev Interface of an ERC721A compliant contract.
106  */
107 interface IERC721A {
108     /**
109      * The caller must own the token or be an approved operator.
110      */
111     error ApprovalCallerNotOwnerNorApproved();
112 
113     /**
114      * The token does not exist.
115      */
116     error ApprovalQueryForNonexistentToken();
117 
118     /**
119      * The caller cannot approve to their own address.
120      */
121     error ApproveToCaller();
122 
123     /**
124      * The caller cannot approve to the current owner.
125      */
126     error ApprovalToCurrentOwner();
127 
128     /**
129      * Cannot query the balance for the zero address.
130      */
131     error BalanceQueryForZeroAddress();
132 
133     /**
134      * Cannot mint to the zero address.
135      */
136     error MintToZeroAddress();
137 
138     /**
139      * The quantity of tokens minted must be more than zero.
140      */
141     error MintZeroQuantity();
142 
143     /**
144      * The token does not exist.
145      */
146     error OwnerQueryForNonexistentToken();
147 
148     /**
149      * The caller must own the token or be an approved operator.
150      */
151     error TransferCallerNotOwnerNorApproved();
152 
153     /**
154      * The token must be owned by `from`.
155      */
156     error TransferFromIncorrectOwner();
157 
158     /**
159      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
160      */
161     error TransferToNonERC721ReceiverImplementer();
162 
163     /**
164      * Cannot transfer to the zero address.
165      */
166     error TransferToZeroAddress();
167 
168     /**
169      * The token does not exist.
170      */
171     error URIQueryForNonexistentToken();
172 
173     struct TokenOwnership {
174         // The address of the owner.
175         address addr;
176         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
177         uint64 startTimestamp;
178         // Whether the token has been burned.
179         bool burned;
180     }
181 
182     /**
183      * @dev Returns the total amount of tokens stored by the contract.
184      *
185      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     // ==============================
190     //            IERC165
191     // ==============================
192 
193     /**
194      * @dev Returns true if this contract implements the interface defined by
195      * `interfaceId`. See the corresponding
196      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
197      * to learn more about how these ids are created.
198      *
199      * This function call must use less than 30 000 gas.
200      */
201     function supportsInterface(bytes4 interfaceId) external view returns (bool);
202 
203     // ==============================
204     //            IERC721
205     // ==============================
206 
207     /**
208      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
209      */
210     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
214      */
215     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
219      */
220     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
221 
222     /**
223      * @dev Returns the number of tokens in ``owner``'s account.
224      */
225     function balanceOf(address owner) external view returns (uint256 balance);
226 
227     /**
228      * @dev Returns the owner of the `tokenId` token.
229      *
230      * Requirements:
231      *
232      * - `tokenId` must exist.
233      */
234     function ownerOf(uint256 tokenId) external view returns (address owner);
235 
236     /**
237      * @dev Safely transfers `tokenId` token from `from` to `to`.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must exist and be owned by `from`.
244      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246      *
247      * Emits a {Transfer} event.
248      */
249     function safeTransferFrom(
250         address from,
251         address to,
252         uint256 tokenId,
253         bytes calldata data
254     ) external;
255 
256     /**
257      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
258      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
259      *
260      * Requirements:
261      *
262      * - `from` cannot be the zero address.
263      * - `to` cannot be the zero address.
264      * - `tokenId` token must exist and be owned by `from`.
265      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
267      *
268      * Emits a {Transfer} event.
269      */
270     function safeTransferFrom(
271         address from,
272         address to,
273         uint256 tokenId
274     ) external;
275 
276     /**
277      * @dev Transfers `tokenId` token from `from` to `to`.
278      *
279      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
280      *
281      * Requirements:
282      *
283      * - `from` cannot be the zero address.
284      * - `to` cannot be the zero address.
285      * - `tokenId` token must be owned by `from`.
286      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transferFrom(
291         address from,
292         address to,
293         uint256 tokenId
294     ) external;
295 
296     /**
297      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
298      * The approval is cleared when the token is transferred.
299      *
300      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
301      *
302      * Requirements:
303      *
304      * - The caller must own the token or be an approved operator.
305      * - `tokenId` must exist.
306      *
307      * Emits an {Approval} event.
308      */
309     function approve(address to, uint256 tokenId) external;
310 
311     /**
312      * @dev Approve or remove `operator` as an operator for the caller.
313      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
314      *
315      * Requirements:
316      *
317      * - The `operator` cannot be the caller.
318      *
319      * Emits an {ApprovalForAll} event.
320      */
321     function setApprovalForAll(address operator, bool _approved) external;
322 
323     /**
324      * @dev Returns the account approved for `tokenId` token.
325      *
326      * Requirements:
327      *
328      * - `tokenId` must exist.
329      */
330     function getApproved(uint256 tokenId) external view returns (address operator);
331 
332     /**
333      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
334      *
335      * See {setApprovalForAll}
336      */
337     function isApprovedForAll(address owner, address operator) external view returns (bool);
338 
339     // ==============================
340     //        IERC721Metadata
341     // ==============================
342 
343     /**
344      * @dev Returns the token collection name.
345      */
346     function name() external view returns (string memory);
347 
348     /**
349      * @dev Returns the token collection symbol.
350      */
351     function symbol() external view returns (string memory);
352 
353     /**
354      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
355      */
356     function tokenURI(uint256 tokenId) external view returns (string memory);
357 }
358 // File: contracts/ERC721A.sol
359 
360 
361 // ERC721A Contracts v4.0.0
362 // Creator: Chiru Labs
363 
364 pragma solidity ^0.8.4;
365 
366 
367 /**
368  * @dev ERC721 token receiver interface.
369  */
370 interface ERC721A__IERC721Receiver {
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 /**
380  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
381  * the Metadata extension. Built to optimize for lower gas during batch mints.
382  *
383  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
384  *
385  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
386  *
387  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
388  */
389 contract ERC721A is IERC721A {
390     // Mask of an entry in packed address data.
391     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
392 
393     // The bit position of `numberMinted` in packed address data.
394     uint256 private constant BITPOS_NUMBER_MINTED = 64;
395 
396     // The bit position of `numberBurned` in packed address data.
397     uint256 private constant BITPOS_NUMBER_BURNED = 128;
398 
399     // The bit position of `aux` in packed address data.
400     uint256 private constant BITPOS_AUX = 192;
401 
402     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
403     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
404 
405     // The bit position of `startTimestamp` in packed ownership.
406     uint256 private constant BITPOS_START_TIMESTAMP = 160;
407 
408     // The bit mask of the `burned` bit in packed ownership.
409     uint256 private constant BITMASK_BURNED = 1 << 224;
410     
411     // The bit position of the `nextInitialized` bit in packed ownership.
412     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
413 
414     // The bit mask of the `nextInitialized` bit in packed ownership.
415     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
416 
417     // The tokenId of the next token to be minted.
418     uint256 private _currentIndex;
419 
420     // The number of tokens burned.
421     uint256 private _burnCounter;
422 
423     // Token name
424     string private _name;
425 
426     // Token symbol
427     string private _symbol;
428 
429     // Mapping from token ID to ownership details
430     // An empty struct value does not necessarily mean the token is unowned.
431     // See `_packedOwnershipOf` implementation for details.
432     //
433     // Bits Layout:
434     // - [0..159]   `addr`
435     // - [160..223] `startTimestamp`
436     // - [224]      `burned`
437     // - [225]      `nextInitialized`
438     mapping(uint256 => uint256) private _packedOwnerships;
439 
440     // Mapping owner address to address data.
441     //
442     // Bits Layout:
443     // - [0..63]    `balance`
444     // - [64..127]  `numberMinted`
445     // - [128..191] `numberBurned`
446     // - [192..255] `aux`
447     mapping(address => uint256) private _packedAddressData;
448 
449     // Mapping from token ID to approved address.
450     mapping(uint256 => address) private _tokenApprovals;
451 
452     // Mapping from owner to operator approvals
453     mapping(address => mapping(address => bool)) private _operatorApprovals;
454 
455     constructor(string memory name_, string memory symbol_) {
456         _name = name_;
457         _symbol = symbol_;
458         _currentIndex = _startTokenId();
459     }
460 
461     /**
462      * @dev Returns the starting token ID. 
463      * To change the starting token ID, please override this function.
464      */
465     function _startTokenId() internal view virtual returns (uint256) {
466         return 0;
467     }
468 
469     /**
470      * @dev Returns the next token ID to be minted.
471      */
472     function _nextTokenId() internal view returns (uint256) {
473         return _currentIndex;
474     }
475 
476     /**
477      * @dev Returns the total number of tokens in existence.
478      * Burned tokens will reduce the count. 
479      * To get the total number of tokens minted, please see `_totalMinted`.
480      */
481     function totalSupply() public view override returns (uint256) {
482         // Counter underflow is impossible as _burnCounter cannot be incremented
483         // more than `_currentIndex - _startTokenId()` times.
484         unchecked {
485             return _currentIndex - _burnCounter - _startTokenId();
486         }
487     }
488 
489     /**
490      * @dev Returns the total amount of tokens minted in the contract.
491      */
492     function _totalMinted() internal view returns (uint256) {
493         // Counter underflow is impossible as _currentIndex does not decrement,
494         // and it is initialized to `_startTokenId()`
495         unchecked {
496             return _currentIndex - _startTokenId();
497         }
498     }
499 
500     /**
501      * @dev Returns the total number of tokens burned.
502      */
503     function _totalBurned() internal view returns (uint256) {
504         return _burnCounter;
505     }
506 
507     /**
508      * @dev See {IERC165-supportsInterface}.
509      */
510     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511         // The interface IDs are constants representing the first 4 bytes of the XOR of
512         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
513         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
514         return
515             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
516             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
517             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
518     }
519 
520     /**
521      * @dev See {IERC721-balanceOf}.
522      */
523     function balanceOf(address owner) public view override returns (uint256) {
524         if (owner == address(0)) revert BalanceQueryForZeroAddress();
525         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
526     }
527 
528     /**
529      * Returns the number of tokens minted by `owner`.
530      */
531     function _numberMinted(address owner) internal view returns (uint256) {
532         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
533     }
534 
535     /**
536      * Returns the number of tokens burned by or on behalf of `owner`.
537      */
538     function _numberBurned(address owner) internal view returns (uint256) {
539         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
540     }
541 
542     /**
543      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
544      */
545     function _getAux(address owner) internal view returns (uint64) {
546         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
547     }
548 
549     /**
550      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
551      * If there are multiple variables, please pack them into a uint64.
552      */
553     function _setAux(address owner, uint64 aux) internal {
554         uint256 packed = _packedAddressData[owner];
555         uint256 auxCasted;
556         assembly { // Cast aux without masking.
557             auxCasted := aux
558         }
559         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
560         _packedAddressData[owner] = packed;
561     }
562 
563     /**
564      * Returns the packed ownership data of `tokenId`.
565      */
566     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
567         uint256 curr = tokenId;
568 
569         unchecked {
570             if (_startTokenId() <= curr)
571                 if (curr < _currentIndex) {
572                     uint256 packed = _packedOwnerships[curr];
573                     // If not burned.
574                     if (packed & BITMASK_BURNED == 0) {
575                         // Invariant:
576                         // There will always be an ownership that has an address and is not burned
577                         // before an ownership that does not have an address and is not burned.
578                         // Hence, curr will not underflow.
579                         //
580                         // We can directly compare the packed value.
581                         // If the address is zero, packed is zero.
582                         while (packed == 0) {
583                             packed = _packedOwnerships[--curr];
584                         }
585                         return packed;
586                     }
587                 }
588         }
589         revert OwnerQueryForNonexistentToken();
590     }
591 
592     /**
593      * Returns the unpacked `TokenOwnership` struct from `packed`.
594      */
595     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
596         ownership.addr = address(uint160(packed));
597         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
598         ownership.burned = packed & BITMASK_BURNED != 0;
599     }
600 
601     /**
602      * Returns the unpacked `TokenOwnership` struct at `index`.
603      */
604     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
605         return _unpackedOwnership(_packedOwnerships[index]);
606     }
607 
608     /**
609      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
610      */
611     function _initializeOwnershipAt(uint256 index) internal {
612         if (_packedOwnerships[index] == 0) {
613             _packedOwnerships[index] = _packedOwnershipOf(index);
614         }
615     }
616 
617     /**
618      * Gas spent here starts off proportional to the maximum mint batch size.
619      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
620      */
621     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnershipOf(tokenId));
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view override returns (address) {
629         return address(uint160(_packedOwnershipOf(tokenId)));
630     }
631 
632     /**
633      * @dev See {IERC721Metadata-name}.
634      */
635     function name() public view virtual override returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-symbol}.
641      */
642     function symbol() public view virtual override returns (string memory) {
643         return _symbol;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-tokenURI}.
648      */
649     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
650         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
651 
652         string memory baseURI = _baseURI();
653         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
654     }
655 
656     /**
657      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
658      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
659      * by default, can be overriden in child contracts.
660      */
661     function _baseURI() internal view virtual returns (string memory) {
662         return '';
663     }
664 
665     /**
666      * @dev Casts the address to uint256 without masking.
667      */
668     function _addressToUint256(address value) private pure returns (uint256 result) {
669         assembly {
670             result := value
671         }
672     }
673 
674     /**
675      * @dev Casts the boolean to uint256 without branching.
676      */
677     function _boolToUint256(bool value) private pure returns (uint256 result) {
678         assembly {
679             result := value
680         }
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = address(uint160(_packedOwnershipOf(tokenId)));
688         if (to == owner) revert ApprovalToCurrentOwner();
689 
690         if (_msgSenderERC721A() != owner)
691             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
692                 revert ApprovalCallerNotOwnerNorApproved();
693             }
694 
695         _tokenApprovals[tokenId] = to;
696         emit Approval(owner, to, tokenId);
697     }
698 
699     /**
700      * @dev See {IERC721-getApproved}.
701      */
702     function getApproved(uint256 tokenId) public view override returns (address) {
703         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
704 
705         return _tokenApprovals[tokenId];
706     }
707 
708     /**
709      * @dev See {IERC721-setApprovalForAll}.
710      */
711     function setApprovalForAll(address operator, bool approved) public virtual override {
712         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
713 
714         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
715         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
716     }
717 
718     /**
719      * @dev See {IERC721-isApprovedForAll}.
720      */
721     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
722         return _operatorApprovals[owner][operator];
723     }
724 
725     /**
726      * @dev See {IERC721-transferFrom}.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public virtual override {
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, '');
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         _transfer(from, to, tokenId);
757         if (to.code.length != 0)
758             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
759                 revert TransferToNonERC721ReceiverImplementer();
760             }
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      */
770     function _exists(uint256 tokenId) internal view returns (bool) {
771         return
772             _startTokenId() <= tokenId &&
773             tokenId < _currentIndex && // If within bounds,
774             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
775     }
776 
777     /**
778      * @dev Equivalent to `_safeMint(to, quantity, '')`.
779      */
780     function _safeMint(address to, uint256 quantity) internal {
781         _safeMint(to, quantity, '');
782     }
783 
784     /**
785      * @dev Safely mints `quantity` tokens and transfers them to `to`.
786      *
787      * Requirements:
788      *
789      * - If `to` refers to a smart contract, it must implement
790      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
791      * - `quantity` must be greater than 0.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeMint(
796         address to,
797         uint256 quantity,
798         bytes memory _data
799     ) internal {
800         uint256 startTokenId = _currentIndex;
801         if (to == address(0)) revert MintToZeroAddress();
802         if (quantity == 0) revert MintZeroQuantity();
803 
804         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
805 
806         // Overflows are incredibly unrealistic.
807         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
808         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
809         unchecked {
810             // Updates:
811             // - `balance += quantity`.
812             // - `numberMinted += quantity`.
813             //
814             // We can directly add to the balance and number minted.
815             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
816 
817             // Updates:
818             // - `address` to the owner.
819             // - `startTimestamp` to the timestamp of minting.
820             // - `burned` to `false`.
821             // - `nextInitialized` to `quantity == 1`.
822             _packedOwnerships[startTokenId] =
823                 _addressToUint256(to) |
824                 (block.timestamp << BITPOS_START_TIMESTAMP) |
825                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
826 
827             uint256 updatedIndex = startTokenId;
828             uint256 end = updatedIndex + quantity;
829 
830             if (to.code.length != 0) {
831                 do {
832                     emit Transfer(address(0), to, updatedIndex);
833                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
834                         revert TransferToNonERC721ReceiverImplementer();
835                     }
836                 } while (updatedIndex < end);
837                 // Reentrancy protection
838                 if (_currentIndex != startTokenId) revert();
839             } else {
840                 do {
841                     emit Transfer(address(0), to, updatedIndex++);
842                 } while (updatedIndex < end);
843             }
844             _currentIndex = updatedIndex;
845         }
846         _afterTokenTransfers(address(0), to, startTokenId, quantity);
847     }
848 
849     /**
850      * @dev Mints `quantity` tokens and transfers them to `to`.
851      *
852      * Requirements:
853      *
854      * - `to` cannot be the zero address.
855      * - `quantity` must be greater than 0.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 quantity) internal {
860         uint256 startTokenId = _currentIndex;
861         if (to == address(0)) revert MintToZeroAddress();
862         if (quantity == 0) revert MintZeroQuantity();
863 
864         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
865 
866         // Overflows are incredibly unrealistic.
867         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
868         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
869         unchecked {
870             // Updates:
871             // - `balance += quantity`.
872             // - `numberMinted += quantity`.
873             //
874             // We can directly add to the balance and number minted.
875             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
876 
877             // Updates:
878             // - `address` to the owner.
879             // - `startTimestamp` to the timestamp of minting.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `quantity == 1`.
882             _packedOwnerships[startTokenId] =
883                 _addressToUint256(to) |
884                 (block.timestamp << BITPOS_START_TIMESTAMP) |
885                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
886 
887             uint256 updatedIndex = startTokenId;
888             uint256 end = updatedIndex + quantity;
889 
890             do {
891                 emit Transfer(address(0), to, updatedIndex++);
892             } while (updatedIndex < end);
893 
894             _currentIndex = updatedIndex;
895         }
896         _afterTokenTransfers(address(0), to, startTokenId, quantity);
897     }
898 
899     /**
900      * @dev Transfers `tokenId` from `from` to `to`.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) private {
914         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
915 
916         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
917 
918         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
919             isApprovedForAll(from, _msgSenderERC721A()) ||
920             getApproved(tokenId) == _msgSenderERC721A());
921 
922         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
923         if (to == address(0)) revert TransferToZeroAddress();
924 
925         _beforeTokenTransfers(from, to, tokenId, 1);
926 
927         // Clear approvals from the previous owner.
928         delete _tokenApprovals[tokenId];
929 
930         // Underflow of the sender's balance is impossible because we check for
931         // ownership above and the recipient's balance can't realistically overflow.
932         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
933         unchecked {
934             // We can directly increment and decrement the balances.
935             --_packedAddressData[from]; // Updates: `balance -= 1`.
936             ++_packedAddressData[to]; // Updates: `balance += 1`.
937 
938             // Updates:
939             // - `address` to the next owner.
940             // - `startTimestamp` to the timestamp of transfering.
941             // - `burned` to `false`.
942             // - `nextInitialized` to `true`.
943             _packedOwnerships[tokenId] =
944                 _addressToUint256(to) |
945                 (block.timestamp << BITPOS_START_TIMESTAMP) |
946                 BITMASK_NEXT_INITIALIZED;
947 
948             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
949             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
950                 uint256 nextTokenId = tokenId + 1;
951                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
952                 if (_packedOwnerships[nextTokenId] == 0) {
953                     // If the next slot is within bounds.
954                     if (nextTokenId != _currentIndex) {
955                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
956                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
957                     }
958                 }
959             }
960         }
961 
962         emit Transfer(from, to, tokenId);
963         _afterTokenTransfers(from, to, tokenId, 1);
964     }
965 
966     /**
967      * @dev Equivalent to `_burn(tokenId, false)`.
968      */
969     function _burn(uint256 tokenId) internal virtual {
970         _burn(tokenId, false);
971     }
972 
973     /**
974      * @dev Destroys `tokenId`.
975      * The approval is cleared when the token is burned.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
984         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
985 
986         address from = address(uint160(prevOwnershipPacked));
987 
988         if (approvalCheck) {
989             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
990                 isApprovedForAll(from, _msgSenderERC721A()) ||
991                 getApproved(tokenId) == _msgSenderERC721A());
992 
993             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
994         }
995 
996         _beforeTokenTransfers(from, address(0), tokenId, 1);
997 
998         // Clear approvals from the previous owner.
999         delete _tokenApprovals[tokenId];
1000 
1001         // Underflow of the sender's balance is impossible because we check for
1002         // ownership above and the recipient's balance can't realistically overflow.
1003         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1004         unchecked {
1005             // Updates:
1006             // - `balance -= 1`.
1007             // - `numberBurned += 1`.
1008             //
1009             // We can directly decrement the balance, and increment the number burned.
1010             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1011             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1012 
1013             // Updates:
1014             // - `address` to the last owner.
1015             // - `startTimestamp` to the timestamp of burning.
1016             // - `burned` to `true`.
1017             // - `nextInitialized` to `true`.
1018             _packedOwnerships[tokenId] =
1019                 _addressToUint256(from) |
1020                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1021                 BITMASK_BURNED | 
1022                 BITMASK_NEXT_INITIALIZED;
1023 
1024             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1025             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1026                 uint256 nextTokenId = tokenId + 1;
1027                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1028                 if (_packedOwnerships[nextTokenId] == 0) {
1029                     // If the next slot is within bounds.
1030                     if (nextTokenId != _currentIndex) {
1031                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1032                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1033                     }
1034                 }
1035             }
1036         }
1037 
1038         emit Transfer(from, address(0), tokenId);
1039         _afterTokenTransfers(from, address(0), tokenId, 1);
1040 
1041         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1042         unchecked {
1043             _burnCounter++;
1044         }
1045     }
1046 
1047     /**
1048      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkContractOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1063             bytes4 retval
1064         ) {
1065             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1066         } catch (bytes memory reason) {
1067             if (reason.length == 0) {
1068                 revert TransferToNonERC721ReceiverImplementer();
1069             } else {
1070                 assembly {
1071                     revert(add(32, reason), mload(reason))
1072                 }
1073             }
1074         }
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1079      * And also called before burning one token.
1080      *
1081      * startTokenId - the first token id to be transferred
1082      * quantity - the amount to be transferred
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` will be minted for `to`.
1089      * - When `to` is zero, `tokenId` will be burned by `from`.
1090      * - `from` and `to` are never both zero.
1091      */
1092     function _beforeTokenTransfers(
1093         address from,
1094         address to,
1095         uint256 startTokenId,
1096         uint256 quantity
1097     ) internal virtual {}
1098 
1099     /**
1100      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1101      * minting.
1102      * And also called after one token has been burned.
1103      *
1104      * startTokenId - the first token id to be transferred
1105      * quantity - the amount to be transferred
1106      *
1107      * Calling conditions:
1108      *
1109      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1110      * transferred to `to`.
1111      * - When `from` is zero, `tokenId` has been minted for `to`.
1112      * - When `to` is zero, `tokenId` has been burned by `from`.
1113      * - `from` and `to` are never both zero.
1114      */
1115     function _afterTokenTransfers(
1116         address from,
1117         address to,
1118         uint256 startTokenId,
1119         uint256 quantity
1120     ) internal virtual {}
1121 
1122     /**
1123      * @dev Returns the message sender (defaults to `msg.sender`).
1124      *
1125      * If you are writing GSN compatible contracts, you need to override this function.
1126      */
1127     function _msgSenderERC721A() internal view virtual returns (address) {
1128         return msg.sender;
1129     }
1130 
1131     /**
1132      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1133      */
1134     function _toString(uint256 value) internal pure returns (string memory ptr) {
1135         assembly {
1136             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1137             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1138             // We will need 1 32-byte word to store the length, 
1139             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1140             ptr := add(mload(0x40), 128)
1141             // Update the free memory pointer to allocate.
1142             mstore(0x40, ptr)
1143 
1144             // Cache the end of the memory to calculate the length later.
1145             let end := ptr
1146 
1147             // We write the string from the rightmost digit to the leftmost digit.
1148             // The following is essentially a do-while loop that also handles the zero case.
1149             // Costs a bit more than early returning for the zero case,
1150             // but cheaper in terms of deployment and overall runtime costs.
1151             for { 
1152                 // Initialize and perform the first pass without check.
1153                 let temp := value
1154                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1155                 ptr := sub(ptr, 1)
1156                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1157                 mstore8(ptr, add(48, mod(temp, 10)))
1158                 temp := div(temp, 10)
1159             } temp { 
1160                 // Keep dividing `temp` until zero.
1161                 temp := div(temp, 10)
1162             } { // Body of the for loop.
1163                 ptr := sub(ptr, 1)
1164                 mstore8(ptr, add(48, mod(temp, 10)))
1165             }
1166             
1167             let length := sub(end, ptr)
1168             // Move the pointer 32 bytes leftwards to make room for the length.
1169             ptr := sub(ptr, 32)
1170             // Store the length.
1171             mstore(ptr, length)
1172         }
1173     }
1174 }
1175 // File: contracts/Strings.sol
1176 
1177 
1178 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev String operations.
1184  */
1185 library Strings {
1186     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1187 
1188     /**
1189      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1190      */
1191     function toString(uint256 value) internal pure returns (string memory) {
1192         // Inspired by OraclizeAPI's implementation - MIT licence
1193         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1194 
1195         if (value == 0) {
1196             return "0";
1197         }
1198         uint256 temp = value;
1199         uint256 digits;
1200         while (temp != 0) {
1201             digits++;
1202             temp /= 10;
1203         }
1204         bytes memory buffer = new bytes(digits);
1205         while (value != 0) {
1206             digits -= 1;
1207             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1208             value /= 10;
1209         }
1210         return string(buffer);
1211     }
1212 
1213     /**
1214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1215      */
1216     function toHexString(uint256 value) internal pure returns (string memory) {
1217         if (value == 0) {
1218             return "0x00";
1219         }
1220         uint256 temp = value;
1221         uint256 length = 0;
1222         while (temp != 0) {
1223             length++;
1224             temp >>= 8;
1225         }
1226         return toHexString(value, length);
1227     }
1228 
1229     /**
1230      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1231      */
1232     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1233         bytes memory buffer = new bytes(2 * length + 2);
1234         buffer[0] = "0";
1235         buffer[1] = "x";
1236         for (uint256 i = 2 * length + 1; i > 1; --i) {
1237             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1238             value >>= 4;
1239         }
1240         require(value == 0, "Strings: hex length insufficient");
1241         return string(buffer);
1242     }
1243 }
1244 // File: contracts/ReentrancyGuard.sol
1245 
1246 
1247 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 /**
1252  * @dev Contract module that helps prevent reentrant calls to a function.
1253  *
1254  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1255  * available, which can be applied to functions to make sure there are no nested
1256  * (reentrant) calls to them.
1257  *
1258  * Note that because there is a single `nonReentrant` guard, functions marked as
1259  * `nonReentrant` may not call one another. This can be worked around by making
1260  * those functions `private`, and then adding `external` `nonReentrant` entry
1261  * points to them.
1262  *
1263  * TIP: If you would like to learn more about reentrancy and alternative ways
1264  * to protect against it, check out our blog post
1265  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1266  */
1267 abstract contract ReentrancyGuard {
1268     // Booleans are more expensive than uint256 or any type that takes up a full
1269     // word because each write operation emits an extra SLOAD to first read the
1270     // slot's contents, replace the bits taken up by the boolean, and then write
1271     // back. This is the compiler's defense against contract upgrades and
1272     // pointer aliasing, and it cannot be disabled.
1273 
1274     // The values being non-zero value makes deployment a bit more expensive,
1275     // but in exchange the refund on every call to nonReentrant will be lower in
1276     // amount. Since refunds are capped to a percentage of the total
1277     // transaction's gas, it is best to keep them low in cases like this one, to
1278     // increase the likelihood of the full refund coming into effect.
1279     uint256 private constant _NOT_ENTERED = 1;
1280     uint256 private constant _ENTERED = 2;
1281 
1282     uint256 private _status;
1283 
1284     constructor() {
1285         _status = _NOT_ENTERED;
1286     }
1287 
1288     /**
1289      * @dev Prevents a contract from calling itself, directly or indirectly.
1290      * Calling a `nonReentrant` function from another `nonReentrant`
1291      * function is not supported. It is possible to prevent this from happening
1292      * by making the `nonReentrant` function external, and making it call a
1293      * `private` function that does the actual work.
1294      */
1295     modifier nonReentrant() {
1296         // On the first call to nonReentrant, _notEntered will be true
1297         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1298 
1299         // Any calls to nonReentrant after this point will fail
1300         _status = _ENTERED;
1301 
1302         _;
1303 
1304         // By storing the original value once again, a refund is triggered (see
1305         // https://eips.ethereum.org/EIPS/eip-2200)
1306         _status = _NOT_ENTERED;
1307     }
1308 }
1309 // File: contracts/Context.sol
1310 
1311 
1312 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 /**
1317  * @dev Provides information about the current execution context, including the
1318  * sender of the transaction and its data. While these are generally available
1319  * via msg.sender and msg.data, they should not be accessed in such a direct
1320  * manner, since when dealing with meta-transactions the account sending and
1321  * paying for execution may not be the actual sender (as far as an application
1322  * is concerned).
1323  *
1324  * This contract is only required for intermediate, library-like contracts.
1325  */
1326 abstract contract Context {
1327     function _msgSender() internal view virtual returns (address) {
1328         return msg.sender;
1329     }
1330 
1331     function _msgData() internal view virtual returns (bytes calldata) {
1332         return msg.data;
1333     }
1334 }
1335 // File: contracts/Ownable.sol
1336 
1337 
1338 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Returns the address of the current owner.
1369      */
1370     function owner() public view virtual returns (address) {
1371         return _owner;
1372     }
1373 
1374     /**
1375      * @dev Throws if called by any account other than the owner.
1376      */
1377     modifier onlyOwner() {
1378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1379         _;
1380     }
1381 
1382     /**
1383      * @dev Leaves the contract without owner. It will not be possible to call
1384      * `onlyOwner` functions anymore. Can only be called by the current owner.
1385      *
1386      * NOTE: Renouncing ownership will leave the contract without an owner,
1387      * thereby removing any functionality that is only available to the owner.
1388      */
1389     function renounceOwnership() public virtual onlyOwner {
1390         _transferOwnership(address(0));
1391     }
1392 
1393     /**
1394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1395      * Can only be called by the current owner.
1396      */
1397     function transferOwnership(address newOwner) public virtual onlyOwner {
1398         require(newOwner != address(0), "Ownable: new owner is the zero address");
1399         _transferOwnership(newOwner);
1400     }
1401 
1402     /**
1403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1404      * Internal function without access restriction.
1405      */
1406     function _transferOwnership(address newOwner) internal virtual {
1407         address oldOwner = _owner;
1408         _owner = newOwner;
1409         emit OwnershipTransferred(oldOwner, newOwner);
1410     }
1411 }
1412 // File: contracts/RoboMonkeys.sol
1413 
1414 
1415 
1416 pragma solidity >=0.8.9 <0.9.0;
1417 
1418 
1419 
1420 
1421 
1422 
1423 contract RoboMonkeys is ERC721A, Ownable, ReentrancyGuard, OperatorFilterer {
1424   using Strings for uint256;
1425 
1426   string public uriPrefix = '';
1427   string public uriSuffix = '.json';
1428   string public hiddenMetadataUri;
1429 
1430   uint256 public cost = 0.003 ether;
1431   uint256 public maxNFTs = 5000;
1432   uint256 public freeMintAmount = 1;
1433   uint256 public txnMax = 11;
1434   uint256 public maxMintAmount = 33;
1435 
1436   bool public paused = true;
1437   bool public revealed = false;
1438 
1439   constructor(
1440     string memory _tokenName,
1441     string memory _tokenSymbol
1442   ) ERC721A(_tokenName, _tokenSymbol) OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), false) {}
1443 
1444   modifier mintCompliance(uint256 _mintAmount) {
1445     require(!paused, "Minting has not started.");
1446     require(_mintAmount > 0 && _mintAmount <= txnMax, "Maximum of 10 NFTs per txn!");
1447     require(totalSupply() + _mintAmount <= maxNFTs, "No NFTs lefts!");
1448     require(tx.origin == msg.sender, "No smart contract minting.");
1449     require(
1450       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1451        "You have minted max number of NFTs!"
1452     );
1453     _;
1454   }
1455 
1456   modifier mintPriceCompliance(uint256 _mintAmount) {
1457     uint256 realCost = 0;
1458     
1459     if (numberMinted(msg.sender) < freeMintAmount) {
1460       uint256 freeMintsLeft = freeMintAmount - numberMinted(msg.sender);
1461       realCost = cost * freeMintsLeft;
1462     }
1463    
1464     require(msg.value >= cost * _mintAmount - realCost, "Insufficient/incorrect funds.");
1465     _;
1466   }
1467 
1468   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1469     _safeMint(_msgSender(), _mintAmount);
1470   }
1471   
1472   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1473     require(totalSupply() + _mintAmount <= maxNFTs, "Max supply exceeded!");
1474     _safeMint(_receiver, _mintAmount);
1475   }
1476 
1477   function _startTokenId() internal view virtual override returns (uint256) {
1478     return 1;
1479   }
1480 
1481   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1482     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1483 
1484     if (revealed == false) {
1485       return hiddenMetadataUri;
1486     }
1487 
1488     string memory currentBaseURI = _baseURI();
1489     return bytes(currentBaseURI).length > 0
1490         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1491         : '';
1492   }
1493 
1494   function setCost(uint256 _cost) public onlyOwner {
1495     cost = _cost;
1496   }
1497 
1498   function setRevealed(bool _state) public onlyOwner {
1499     revealed = _state;
1500   }
1501 
1502    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1503     hiddenMetadataUri = _hiddenMetadataUri;
1504   }
1505 
1506   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1507     uriPrefix = _uriPrefix;
1508   }
1509 
1510   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1511     uriSuffix = _uriSuffix;
1512   }
1513 
1514   function setPaused(bool _state) public onlyOwner {
1515     paused = _state;
1516   }
1517 
1518   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1519     maxMintAmount = _maxMintAmount;
1520   }
1521 
1522   function withdraw() public onlyOwner nonReentrant {
1523     (bool withdrawFunds, ) = payable(owner()).call{value: address(this).balance}("");
1524     require(withdrawFunds);
1525   }
1526 
1527   function numberMinted(address owner) public view returns (uint256) {
1528     return _numberMinted(owner);
1529   }
1530 
1531   function _baseURI() internal view virtual override returns (string memory) {
1532     return uriPrefix;
1533   }
1534 
1535   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1536         super.setApprovalForAll(operator, approved);
1537   }
1538 
1539   function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1540         super.approve(operator, tokenId);
1541   }
1542 
1543   function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1544         super.transferFrom(from, to, tokenId);
1545   }
1546 
1547   function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1548         super.safeTransferFrom(from, to, tokenId);
1549   }
1550 
1551   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1552         public
1553         override
1554         onlyAllowedOperator(from)
1555   {
1556         super.safeTransferFrom(from, to, tokenId, data);
1557   }
1558 
1559 }