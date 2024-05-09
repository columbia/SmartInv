1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 // File: contracts/IOperatorFilterRegistry.sol
5 
6 
7 pragma solidity ^0.8.13;
8 
9 interface IOperatorFilterRegistry {
10     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
11     function register(address registrant) external;
12     function registerAndSubscribe(address registrant, address subscription) external;
13     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
14     function updateOperator(address registrant, address operator, bool filtered) external;
15     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
16     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
17     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
18     function subscribe(address registrant, address registrantToSubscribe) external;
19     function unsubscribe(address registrant, bool copyExistingEntries) external;
20     function subscriptionOf(address addr) external returns (address registrant);
21     function subscribers(address registrant) external returns (address[] memory);
22     function subscriberAt(address registrant, uint256 index) external returns (address);
23     function copyEntriesOf(address registrant, address registrantToCopy) external;
24     function isOperatorFiltered(address registrant, address operator) external returns (bool);
25     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
26     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
27     function filteredOperators(address addr) external returns (address[] memory);
28     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
29     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
30     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
31     function isRegistered(address addr) external returns (bool);
32     function codeHashOf(address addr) external returns (bytes32);
33 }
34 
35 // File: contracts/OperatorFilterer.sol
36 
37 
38 pragma solidity ^0.8.13;
39 
40 
41 abstract contract OperatorFilterer {
42     error OperatorNotAllowed(address operator);
43 
44     IOperatorFilterRegistry constant operatorFilterRegistry =
45         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
46 
47     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
48         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
49         // will not revert, but the contract will need to be registered with the registry once it is deployed in
50         // order for the modifier to filter addresses.
51         if (address(operatorFilterRegistry).code.length > 0) {
52             if (subscribe) {
53                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
54             } else {
55                 if (subscriptionOrRegistrantToCopy != address(0)) {
56                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
57                 } else {
58                     operatorFilterRegistry.register(address(this));
59                 }
60             }
61         }
62     }
63 
64     modifier onlyAllowedOperator(address from) virtual {
65         // Check registry code length to facilitate testing in environments without a deployed registry.
66         if (address(operatorFilterRegistry).code.length > 0) {
67             // Allow spending tokens from addresses with balance
68             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
69             // from an EOA.
70             if (from == msg.sender) {
71                 _;
72                 return;
73             }
74             if (
75                 !(
76                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
77                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
78                 )
79             ) {
80                 revert OperatorNotAllowed(msg.sender);
81             }
82         }
83         _;
84     }
85 }
86 
87 // File: contracts/DefaultOperatorFilterer.sol
88 
89 
90 pragma solidity ^0.8.13;
91 
92 
93 abstract contract DefaultOperatorFilterer is OperatorFilterer {
94     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
95 
96     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
97 }
98 
99 // File: contracts/IERC721A.sol
100 
101 
102 // ERC721A Contracts v4.0.0
103 // Creator: Chiru Labs
104 
105 pragma solidity ^0.8.4;
106 
107 /**
108  * @dev Interface of an ERC721A compliant contract.
109  */
110 interface IERC721A {
111     /**
112      * The caller must own the token or be an approved operator.
113      */
114     error ApprovalCallerNotOwnerNorApproved();
115 
116     /**
117      * The token does not exist.
118      */
119     error ApprovalQueryForNonexistentToken();
120 
121     /**
122      * The caller cannot approve to their own address.
123      */
124     error ApproveToCaller();
125 
126     /**
127      * The caller cannot approve to the current owner.
128      */
129     error ApprovalToCurrentOwner();
130 
131     /**
132      * Cannot query the balance for the zero address.
133      */
134     error BalanceQueryForZeroAddress();
135 
136     /**
137      * Cannot mint to the zero address.
138      */
139     error MintToZeroAddress();
140 
141     /**
142      * The quantity of tokens minted must be more than zero.
143      */
144     error MintZeroQuantity();
145 
146     /**
147      * The token does not exist.
148      */
149     error OwnerQueryForNonexistentToken();
150 
151     /**
152      * The caller must own the token or be an approved operator.
153      */
154     error TransferCallerNotOwnerNorApproved();
155 
156     /**
157      * The token must be owned by `from`.
158      */
159     error TransferFromIncorrectOwner();
160 
161     /**
162      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
163      */
164     error TransferToNonERC721ReceiverImplementer();
165 
166     /**
167      * Cannot transfer to the zero address.
168      */
169     error TransferToZeroAddress();
170 
171     /**
172      * The token does not exist.
173      */
174     error URIQueryForNonexistentToken();
175 
176     struct TokenOwnership {
177         // The address of the owner.
178         address addr;
179         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
180         uint64 startTimestamp;
181         // Whether the token has been burned.
182         bool burned;
183     }
184 
185     /**
186      * @dev Returns the total amount of tokens stored by the contract.
187      *
188      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     // ==============================
193     //            IERC165
194     // ==============================
195 
196     /**
197      * @dev Returns true if this contract implements the interface defined by
198      * `interfaceId`. See the corresponding
199      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
200      * to learn more about how these ids are created.
201      *
202      * This function call must use less than 30 000 gas.
203      */
204     function supportsInterface(bytes4 interfaceId) external view returns (bool);
205 
206     // ==============================
207     //            IERC721
208     // ==============================
209 
210     /**
211      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
214 
215     /**
216      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
217      */
218     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
219 
220     /**
221      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
222      */
223     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
224 
225     /**
226      * @dev Returns the number of tokens in ``owner``'s account.
227      */
228     function balanceOf(address owner) external view returns (uint256 balance);
229 
230     /**
231      * @dev Returns the owner of the `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function ownerOf(uint256 tokenId) external view returns (address owner);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
261      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270      *
271      * Emits a {Transfer} event.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     /**
280      * @dev Transfers `tokenId` token from `from` to `to`.
281      *
282      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
283      *
284      * Requirements:
285      *
286      * - `from` cannot be the zero address.
287      * - `to` cannot be the zero address.
288      * - `tokenId` token must be owned by `from`.
289      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     /**
300      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
301      * The approval is cleared when the token is transferred.
302      *
303      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
304      *
305      * Requirements:
306      *
307      * - The caller must own the token or be an approved operator.
308      * - `tokenId` must exist.
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address to, uint256 tokenId) external;
313 
314     /**
315      * @dev Approve or remove `operator` as an operator for the caller.
316      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
317      *
318      * Requirements:
319      *
320      * - The `operator` cannot be the caller.
321      *
322      * Emits an {ApprovalForAll} event.
323      */
324     function setApprovalForAll(address operator, bool _approved) external;
325 
326     /**
327      * @dev Returns the account approved for `tokenId` token.
328      *
329      * Requirements:
330      *
331      * - `tokenId` must exist.
332      */
333     function getApproved(uint256 tokenId) external view returns (address operator);
334 
335     /**
336      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
337      *
338      * See {setApprovalForAll}
339      */
340     function isApprovedForAll(address owner, address operator) external view returns (bool);
341 
342     // ==============================
343     //        IERC721Metadata
344     // ==============================
345 
346     /**
347      * @dev Returns the token collection name.
348      */
349     function name() external view returns (string memory);
350 
351     /**
352      * @dev Returns the token collection symbol.
353      */
354     function symbol() external view returns (string memory);
355 
356     /**
357      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
358      */
359     function tokenURI(uint256 tokenId) external view returns (string memory);
360 }
361 // File: contracts/ERC721A.sol
362 
363 
364 // ERC721A Contracts v4.0.0
365 // Creator: Chiru Labs
366 
367 pragma solidity ^0.8.4;
368 
369 
370 /**
371  * @dev ERC721 token receiver interface.
372  */
373 interface ERC721A__IERC721Receiver {
374     function onERC721Received(
375         address operator,
376         address from,
377         uint256 tokenId,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 /**
383  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
384  * the Metadata extension. Built to optimize for lower gas during batch mints.
385  *
386  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
387  *
388  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
389  *
390  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
391  */
392 contract ERC721A is IERC721A {
393     // Mask of an entry in packed address data.
394     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
395 
396     // The bit position of `numberMinted` in packed address data.
397     uint256 private constant BITPOS_NUMBER_MINTED = 64;
398 
399     // The bit position of `numberBurned` in packed address data.
400     uint256 private constant BITPOS_NUMBER_BURNED = 128;
401 
402     // The bit position of `aux` in packed address data.
403     uint256 private constant BITPOS_AUX = 192;
404 
405     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
406     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
407 
408     // The bit position of `startTimestamp` in packed ownership.
409     uint256 private constant BITPOS_START_TIMESTAMP = 160;
410 
411     // The bit mask of the `burned` bit in packed ownership.
412     uint256 private constant BITMASK_BURNED = 1 << 224;
413 
414     // The bit position of the `nextInitialized` bit in packed ownership.
415     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
416 
417     // The bit mask of the `nextInitialized` bit in packed ownership.
418     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
419 
420     // The tokenId of the next token to be minted.
421     uint256 private _currentIndex;
422 
423     // The number of tokens burned.
424     uint256 private _burnCounter;
425 
426     // Token name
427     string private _name;
428 
429     // Token symbol
430     string private _symbol;
431 
432     // Mapping from token ID to ownership details
433     // An empty struct value does not necessarily mean the token is unowned.
434     // See `_packedOwnershipOf` implementation for details.
435     //
436     // Bits Layout:
437     // - [0..159]   `addr`
438     // - [160..223] `startTimestamp`
439     // - [224]      `burned`
440     // - [225]      `nextInitialized`
441     mapping(uint256 => uint256) private _packedOwnerships;
442 
443     // Mapping owner address to address data.
444     //
445     // Bits Layout:
446     // - [0..63]    `balance`
447     // - [64..127]  `numberMinted`
448     // - [128..191] `numberBurned`
449     // - [192..255] `aux`
450     mapping(address => uint256) private _packedAddressData;
451 
452     // Mapping from token ID to approved address.
453     mapping(uint256 => address) private _tokenApprovals;
454 
455     // Mapping from owner to operator approvals
456     mapping(address => mapping(address => bool)) private _operatorApprovals;
457 
458     constructor(string memory name_, string memory symbol_) {
459         _name = name_;
460         _symbol = symbol_;
461         _currentIndex = _startTokenId();
462     }
463 
464     /**
465      * @dev Returns the starting token ID.
466      * To change the starting token ID, please override this function.
467      */
468     function _startTokenId() internal view virtual returns (uint256) {
469         return 0;
470     }
471 
472     /**
473      * @dev Returns the next token ID to be minted.
474      */
475     function _nextTokenId() internal view returns (uint256) {
476         return _currentIndex;
477     }
478 
479     /**
480      * @dev Returns the total number of tokens in existence.
481      * Burned tokens will reduce the count.
482      * To get the total number of tokens minted, please see `_totalMinted`.
483      */
484     function totalSupply() public view override returns (uint256) {
485         // Counter underflow is impossible as _burnCounter cannot be incremented
486         // more than `_currentIndex - _startTokenId()` times.
487         unchecked {
488             return _currentIndex - _burnCounter - _startTokenId();
489         }
490     }
491 
492     /**
493      * @dev Returns the total amount of tokens minted in the contract.
494      */
495     function _totalMinted() internal view returns (uint256) {
496         // Counter underflow is impossible as _currentIndex does not decrement,
497         // and it is initialized to `_startTokenId()`
498         unchecked {
499             return _currentIndex - _startTokenId();
500         }
501     }
502 
503     /**
504      * @dev Returns the total number of tokens burned.
505      */
506     function _totalBurned() internal view returns (uint256) {
507         return _burnCounter;
508     }
509 
510     /**
511      * @dev See {IERC165-supportsInterface}.
512      */
513     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
514         // The interface IDs are constants representing the first 4 bytes of the XOR of
515         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
516         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
517         return
518             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
519             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
520             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
521     }
522 
523     /**
524      * @dev See {IERC721-balanceOf}.
525      */
526     function balanceOf(address owner) public view override returns (uint256) {
527         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
528         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
529     }
530 
531     /**
532      * Returns the number of tokens minted by `owner`.
533      */
534     function _numberMinted(address owner) internal view returns (uint256) {
535         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
536     }
537 
538     /**
539      * Returns the number of tokens burned by or on behalf of `owner`.
540      */
541     function _numberBurned(address owner) internal view returns (uint256) {
542         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
543     }
544 
545     /**
546      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
547      */
548     function _getAux(address owner) internal view returns (uint64) {
549         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
550     }
551 
552     /**
553      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
554      * If there are multiple variables, please pack them into a uint64.
555      */
556     function _setAux(address owner, uint64 aux) internal {
557         uint256 packed = _packedAddressData[owner];
558         uint256 auxCasted;
559         assembly { // Cast aux without masking.
560             auxCasted := aux
561         }
562         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
563         _packedAddressData[owner] = packed;
564     }
565 
566     /**
567      * Returns the packed ownership data of `tokenId`.
568      */
569     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
570         uint256 curr = tokenId;
571 
572         unchecked {
573             if (_startTokenId() <= curr)
574                 if (curr < _currentIndex) {
575                     uint256 packed = _packedOwnerships[curr];
576                     // If not burned.
577                     if (packed & BITMASK_BURNED == 0) {
578                         // Invariant:
579                         // There will always be an ownership that has an address and is not burned
580                         // before an ownership that does not have an address and is not burned.
581                         // Hence, curr will not underflow.
582                         //
583                         // We can directly compare the packed value.
584                         // If the address is zero, packed is zero.
585                         while (packed == 0) {
586                             packed = _packedOwnerships[--curr];
587                         }
588                         return packed;
589                     }
590                 }
591         }
592         revert OwnerQueryForNonexistentToken();
593     }
594 
595     /**
596      * Returns the unpacked `TokenOwnership` struct from `packed`.
597      */
598     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
599         ownership.addr = address(uint160(packed));
600         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
601         ownership.burned = packed & BITMASK_BURNED != 0;
602     }
603 
604     /**
605      * Returns the unpacked `TokenOwnership` struct at `index`.
606      */
607     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
608         return _unpackedOwnership(_packedOwnerships[index]);
609     }
610 
611     /**
612      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
613      */
614     function _initializeOwnershipAt(uint256 index) internal {
615         if (_packedOwnerships[index] == 0) {
616             _packedOwnerships[index] = _packedOwnershipOf(index);
617         }
618     }
619 
620     /**
621      * Gas spent here starts off proportional to the maximum mint batch size.
622      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
623      */
624     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnershipOf(tokenId));
626     }
627 
628     /**
629      * @dev See {IERC721-ownerOf}.
630      */
631     function ownerOf(uint256 tokenId) public view override returns (address) {
632         return address(uint160(_packedOwnershipOf(tokenId)));
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-name}.
637      */
638     function name() public view virtual override returns (string memory) {
639         return _name;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-symbol}.
644      */
645     function symbol() public view virtual override returns (string memory) {
646         return _symbol;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-tokenURI}.
651      */
652     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
653         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
654 
655         string memory baseURI = _baseURI();
656         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
657     }
658 
659     /**
660      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
661      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
662      * by default, can be overriden in child contracts.
663      */
664     function _baseURI() internal view virtual returns (string memory) {
665         return '';
666     }
667 
668     /**
669      * @dev Casts the address to uint256 without masking.
670      */
671     function _addressToUint256(address value) private pure returns (uint256 result) {
672         assembly {
673             result := value
674         }
675     }
676 
677     /**
678      * @dev Casts the boolean to uint256 without branching.
679      */
680     function _boolToUint256(bool value) private pure returns (uint256 result) {
681         assembly {
682             result := value
683         }
684     }
685 
686     /**
687      * @dev See {IERC721-approve}.
688      */
689     function approve(address to, uint256 tokenId) public override {
690         address owner = address(uint160(_packedOwnershipOf(tokenId)));
691         if (to == owner) revert ApprovalToCurrentOwner();
692 
693         if (_msgSenderERC721A() != owner)
694             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
695                 revert ApprovalCallerNotOwnerNorApproved();
696             }
697 
698         _tokenApprovals[tokenId] = to;
699         emit Approval(owner, to, tokenId);
700     }
701 
702     /**
703      * @dev See {IERC721-getApproved}.
704      */
705     function getApproved(uint256 tokenId) public view override returns (address) {
706         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
707 
708         return _tokenApprovals[tokenId];
709     }
710 
711     /**
712      * @dev See {IERC721-setApprovalForAll}.
713      */
714     function setApprovalForAll(address operator, bool approved) public virtual override {
715         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
716 
717         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
718         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
719     }
720 
721     /**
722      * @dev See {IERC721-isApprovedForAll}.
723      */
724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
725         return _operatorApprovals[owner][operator];
726     }
727 
728     /**
729      * @dev See {IERC721-transferFrom}.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         _transfer(from, to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         safeTransferFrom(from, to, tokenId, '');
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) public virtual override {
759         _transfer(from, to, tokenId);
760         if (to.code.length != 0)
761             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
762                 revert TransferToNonERC721ReceiverImplementer();
763             }
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted (`_mint`),
772      */
773     function _exists(uint256 tokenId) internal view returns (bool) {
774         return
775             _startTokenId() <= tokenId &&
776             tokenId < _currentIndex && // If within bounds,
777             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
778     }
779 
780     /**
781      * @dev Equivalent to `_safeMint(to, quantity, '')`.
782      */
783     function _safeMint(address to, uint256 quantity) internal {
784         _safeMint(to, quantity, '');
785     }
786 
787     /**
788      * @dev Safely mints `quantity` tokens and transfers them to `to`.
789      *
790      * Requirements:
791      *
792      * - If `to` refers to a smart contract, it must implement
793      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
794      * - `quantity` must be greater than 0.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeMint(
799         address to,
800         uint256 quantity,
801         bytes memory _data
802     ) internal {
803         uint256 startTokenId = _currentIndex;
804         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
805         if (quantity == 0) revert MintZeroQuantity();
806 
807         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
808 
809         // Overflows are incredibly unrealistic.
810         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
811         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
812         unchecked {
813             // Updates:
814             // - `balance += quantity`.
815             // - `numberMinted += quantity`.
816             //
817             // We can directly add to the balance and number minted.
818             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
819 
820             // Updates:
821             // - `address` to the owner.
822             // - `startTimestamp` to the timestamp of minting.
823             // - `burned` to `false`.
824             // - `nextInitialized` to `quantity == 1`.
825             _packedOwnerships[startTokenId] =
826                 _addressToUint256(to) |
827                 (block.timestamp << BITPOS_START_TIMESTAMP) |
828                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
829 
830             uint256 updatedIndex = startTokenId;
831             uint256 end = updatedIndex + quantity;
832 
833             if (to.code.length != 0) {
834                 do {
835                     emit Transfer(address(0), to, updatedIndex);
836                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
837                         revert TransferToNonERC721ReceiverImplementer();
838                     }
839                 } while (updatedIndex < end);
840                 // Reentrancy protection
841                 if (_currentIndex != startTokenId) revert();
842             } else {
843                 do {
844                     emit Transfer(address(0), to, updatedIndex++);
845                 } while (updatedIndex < end);
846             }
847             _currentIndex = updatedIndex;
848         }
849         _afterTokenTransfers(address(0), to, startTokenId, quantity);
850     }
851 
852     /**
853      * @dev Mints `quantity` tokens and transfers them to `to`.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `quantity` must be greater than 0.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 quantity) internal {
863         uint256 startTokenId = _currentIndex;
864         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
865         if (quantity == 0) revert MintZeroQuantity();
866 
867         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
868 
869         // Overflows are incredibly unrealistic.
870         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
871         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
872         unchecked {
873             // Updates:
874             // - `balance += quantity`.
875             // - `numberMinted += quantity`.
876             //
877             // We can directly add to the balance and number minted.
878             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
879 
880             // Updates:
881             // - `address` to the owner.
882             // - `startTimestamp` to the timestamp of minting.
883             // - `burned` to `false`.
884             // - `nextInitialized` to `quantity == 1`.
885             _packedOwnerships[startTokenId] =
886                 _addressToUint256(to) |
887                 (block.timestamp << BITPOS_START_TIMESTAMP) |
888                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
889 
890             uint256 updatedIndex = startTokenId;
891             uint256 end = updatedIndex + quantity;
892 
893             do {
894                 emit Transfer(address(0), to, updatedIndex++);
895             } while (updatedIndex < end);
896 
897             _currentIndex = updatedIndex;
898         }
899         _afterTokenTransfers(address(0), to, startTokenId, quantity);
900     }
901 
902     /**
903      * @dev Transfers `tokenId` from `from` to `to`.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must be owned by `from`.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _transfer(
913         address from,
914         address to,
915         uint256 tokenId
916     ) private {
917         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
918 
919         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
920 
921         address approvedAddress = _tokenApprovals[tokenId];
922 
923         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
924             isApprovedForAll(from, _msgSenderERC721A()) ||
925             approvedAddress == _msgSenderERC721A());
926 
927         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
928         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
929 
930         _beforeTokenTransfers(from, to, tokenId, 1);
931 
932         // Clear approvals from the previous owner.
933         if (_addressToUint256(approvedAddress) != 0) {
934             delete _tokenApprovals[tokenId];
935         }
936 
937         // Underflow of the sender's balance is impossible because we check for
938         // ownership above and the recipient's balance can't realistically overflow.
939         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
940         unchecked {
941             // We can directly increment and decrement the balances.
942             --_packedAddressData[from]; // Updates: `balance -= 1`.
943             ++_packedAddressData[to]; // Updates: `balance += 1`.
944 
945             // Updates:
946             // - `address` to the next owner.
947             // - `startTimestamp` to the timestamp of transfering.
948             // - `burned` to `false`.
949             // - `nextInitialized` to `true`.
950             _packedOwnerships[tokenId] =
951                 _addressToUint256(to) |
952                 (block.timestamp << BITPOS_START_TIMESTAMP) |
953                 BITMASK_NEXT_INITIALIZED;
954 
955             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
956             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
957                 uint256 nextTokenId = tokenId + 1;
958                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
959                 if (_packedOwnerships[nextTokenId] == 0) {
960                     // If the next slot is within bounds.
961                     if (nextTokenId != _currentIndex) {
962                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
963                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
964                     }
965                 }
966             }
967         }
968 
969         emit Transfer(from, to, tokenId);
970         _afterTokenTransfers(from, to, tokenId, 1);
971     }
972 
973     /**
974      * @dev Equivalent to `_burn(tokenId, false)`.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         _burn(tokenId, false);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
991         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
992 
993         address from = address(uint160(prevOwnershipPacked));
994         address approvedAddress = _tokenApprovals[tokenId];
995 
996         if (approvalCheck) {
997             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
998                 isApprovedForAll(from, _msgSenderERC721A()) ||
999                 approvedAddress == _msgSenderERC721A());
1000 
1001             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1002         }
1003 
1004         _beforeTokenTransfers(from, address(0), tokenId, 1);
1005 
1006         // Clear approvals from the previous owner.
1007         if (_addressToUint256(approvedAddress) != 0) {
1008             delete _tokenApprovals[tokenId];
1009         }
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1014         unchecked {
1015             // Updates:
1016             // - `balance -= 1`.
1017             // - `numberBurned += 1`.
1018             //
1019             // We can directly decrement the balance, and increment the number burned.
1020             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1021             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1022 
1023             // Updates:
1024             // - `address` to the last owner.
1025             // - `startTimestamp` to the timestamp of burning.
1026             // - `burned` to `true`.
1027             // - `nextInitialized` to `true`.
1028             _packedOwnerships[tokenId] =
1029                 _addressToUint256(from) |
1030                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1031                 BITMASK_BURNED |
1032                 BITMASK_NEXT_INITIALIZED;
1033 
1034             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1035             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1036                 uint256 nextTokenId = tokenId + 1;
1037                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1038                 if (_packedOwnerships[nextTokenId] == 0) {
1039                     // If the next slot is within bounds.
1040                     if (nextTokenId != _currentIndex) {
1041                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1042                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1043                     }
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, address(0), tokenId);
1049         _afterTokenTransfers(from, address(0), tokenId, 1);
1050 
1051         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1052         unchecked {
1053             _burnCounter++;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1059      *
1060      * @param from address representing the previous owner of the given token ID
1061      * @param to target address that will receive the tokens
1062      * @param tokenId uint256 ID of the token to be transferred
1063      * @param _data bytes optional data to send along with the call
1064      * @return bool whether the call correctly returned the expected magic value
1065      */
1066     function _checkContractOnERC721Received(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) private returns (bool) {
1072         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1073             bytes4 retval
1074         ) {
1075             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1076         } catch (bytes memory reason) {
1077             if (reason.length == 0) {
1078                 revert TransferToNonERC721ReceiverImplementer();
1079             } else {
1080                 assembly {
1081                     revert(add(32, reason), mload(reason))
1082                 }
1083             }
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1089      * And also called before burning one token.
1090      *
1091      * startTokenId - the first token id to be transferred
1092      * quantity - the amount to be transferred
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      * - When `to` is zero, `tokenId` will be burned by `from`.
1100      * - `from` and `to` are never both zero.
1101      */
1102     function _beforeTokenTransfers(
1103         address from,
1104         address to,
1105         uint256 startTokenId,
1106         uint256 quantity
1107     ) internal virtual {}
1108 
1109     /**
1110      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1111      * minting.
1112      * And also called after one token has been burned.
1113      *
1114      * startTokenId - the first token id to be transferred
1115      * quantity - the amount to be transferred
1116      *
1117      * Calling conditions:
1118      *
1119      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1120      * transferred to `to`.
1121      * - When `from` is zero, `tokenId` has been minted for `to`.
1122      * - When `to` is zero, `tokenId` has been burned by `from`.
1123      * - `from` and `to` are never both zero.
1124      */
1125     function _afterTokenTransfers(
1126         address from,
1127         address to,
1128         uint256 startTokenId,
1129         uint256 quantity
1130     ) internal virtual {}
1131 
1132     /**
1133      * @dev Returns the message sender (defaults to `msg.sender`).
1134      *
1135      * If you are writing GSN compatible contracts, you need to override this function.
1136      */
1137     function _msgSenderERC721A() internal view virtual returns (address) {
1138         return msg.sender;
1139     }
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1143      */
1144     function _toString(uint256 value) internal pure returns (string memory ptr) {
1145         assembly {
1146             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1147             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1148             // We will need 1 32-byte word to store the length,
1149             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1150             ptr := add(mload(0x40), 128)
1151             // Update the free memory pointer to allocate.
1152             mstore(0x40, ptr)
1153 
1154             // Cache the end of the memory to calculate the length later.
1155             let end := ptr
1156 
1157             // We write the string from the rightmost digit to the leftmost digit.
1158             // The following is essentially a do-while loop that also handles the zero case.
1159             // Costs a bit more than early returning for the zero case,
1160             // but cheaper in terms of deployment and overall runtime costs.
1161             for {
1162                 // Initialize and perform the first pass without check.
1163                 let temp := value
1164                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1165                 ptr := sub(ptr, 1)
1166                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1167                 mstore8(ptr, add(48, mod(temp, 10)))
1168                 temp := div(temp, 10)
1169             } temp {
1170                 // Keep dividing `temp` until zero.
1171                 temp := div(temp, 10)
1172             } { // Body of the for loop.
1173                 ptr := sub(ptr, 1)
1174                 mstore8(ptr, add(48, mod(temp, 10)))
1175             }
1176 
1177             let length := sub(end, ptr)
1178             // Move the pointer 32 bytes leftwards to make room for the length.
1179             ptr := sub(ptr, 32)
1180             // Store the length.
1181             mstore(ptr, length)
1182         }
1183     }
1184 }
1185 // File: @openzeppelin/contracts/utils/Strings.sol
1186 
1187 
1188 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 /**
1193  * @dev String operations.
1194  */
1195 library Strings {
1196     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1197 
1198     /**
1199      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1200      */
1201     function toString(uint256 value) internal pure returns (string memory) {
1202         // Inspired by OraclizeAPI's implementation - MIT licence
1203         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1204 
1205         if (value == 0) {
1206             return "0";
1207         }
1208         uint256 temp = value;
1209         uint256 digits;
1210         while (temp != 0) {
1211             digits++;
1212             temp /= 10;
1213         }
1214         bytes memory buffer = new bytes(digits);
1215         while (value != 0) {
1216             digits -= 1;
1217             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1218             value /= 10;
1219         }
1220         return string(buffer);
1221     }
1222 
1223     /**
1224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1225      */
1226     function toHexString(uint256 value) internal pure returns (string memory) {
1227         if (value == 0) {
1228             return "0x00";
1229         }
1230         uint256 temp = value;
1231         uint256 length = 0;
1232         while (temp != 0) {
1233             length++;
1234             temp >>= 8;
1235         }
1236         return toHexString(value, length);
1237     }
1238 
1239     /**
1240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1241      */
1242     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1243         bytes memory buffer = new bytes(2 * length + 2);
1244         buffer[0] = "0";
1245         buffer[1] = "x";
1246         for (uint256 i = 2 * length + 1; i > 1; --i) {
1247             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1248             value >>= 4;
1249         }
1250         require(value == 0, "Strings: hex length insufficient");
1251         return string(buffer);
1252     }
1253 }
1254 
1255 // File: @openzeppelin/contracts/utils/Context.sol
1256 
1257 
1258 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1259 
1260 pragma solidity ^0.8.0;
1261 
1262 /**
1263  * @dev Provides information about the current execution context, including the
1264  * sender of the transaction and its data. While these are generally available
1265  * via msg.sender and msg.data, they should not be accessed in such a direct
1266  * manner, since when dealing with meta-transactions the account sending and
1267  * paying for execution may not be the actual sender (as far as an application
1268  * is concerned).
1269  *
1270  * This contract is only required for intermediate, library-like contracts.
1271  */
1272 abstract contract Context {
1273     function _msgSender() internal view virtual returns (address) {
1274         return msg.sender;
1275     }
1276 
1277     function _msgData() internal view virtual returns (bytes calldata) {
1278         return msg.data;
1279     }
1280 }
1281 
1282 // File: @openzeppelin/contracts/access/Ownable.sol
1283 
1284 
1285 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 
1290 /**
1291  * @dev Contract module which provides a basic access control mechanism, where
1292  * there is an account (an owner) that can be granted exclusive access to
1293  * specific functions.
1294  *
1295  * By default, the owner account will be the one that deploys the contract. This
1296  * can later be changed with {transferOwnership}.
1297  *
1298  * This module is used through inheritance. It will make available the modifier
1299  * `onlyOwner`, which can be applied to your functions to restrict their use to
1300  * the owner.
1301  */
1302 abstract contract Ownable is Context {
1303     address private _owner;
1304 
1305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1306 
1307     /**
1308      * @dev Initializes the contract setting the deployer as the initial owner.
1309      */
1310     constructor() {
1311         _transferOwnership(_msgSender());
1312     }
1313 
1314     /**
1315      * @dev Returns the address of the current owner.
1316      */
1317     function owner() public view virtual returns (address) {
1318         return _owner;
1319     }
1320 
1321     /**
1322      * @dev Throws if called by any account other than the owner.
1323      */
1324     modifier onlyOwner() {
1325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1326         _;
1327     }
1328 
1329     /**
1330      * @dev Leaves the contract without owner. It will not be possible to call
1331      * `onlyOwner` functions anymore. Can only be called by the current owner.
1332      *
1333      * NOTE: Renouncing ownership will leave the contract without an owner,
1334      * thereby removing any functionality that is only available to the owner.
1335      */
1336     function renounceOwnership() public virtual onlyOwner {
1337         _transferOwnership(address(0));
1338     }
1339 
1340     /**
1341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1342      * Can only be called by the current owner.
1343      */
1344     function transferOwnership(address newOwner) public virtual onlyOwner {
1345         require(newOwner != address(0), "Ownable: new owner is the zero address");
1346         _transferOwnership(newOwner);
1347     }
1348 
1349     /**
1350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351      * Internal function without access restriction.
1352      */
1353     function _transferOwnership(address newOwner) internal virtual {
1354         address oldOwner = _owner;
1355         _owner = newOwner;
1356         emit OwnershipTransferred(oldOwner, newOwner);
1357     }
1358 }
1359 
1360 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1361 
1362 
1363 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1364 
1365 pragma solidity ^0.8.0;
1366 
1367 /**
1368  * @dev These functions deal with verification of Merkle Trees proofs.
1369  *
1370  * The proofs can be generated using the JavaScript library
1371  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1372  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1373  *
1374  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1375  *
1376  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1377  * hashing, or use a hash function other than keccak256 for hashing leaves.
1378  * This is because the concatenation of a sorted pair of internal nodes in
1379  * the merkle tree could be reinterpreted as a leaf value.
1380  */
1381 library MerkleProof {
1382     /**
1383      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1384      * defined by `root`. For this, a `proof` must be provided, containing
1385      * sibling hashes on the branch from the leaf to the root of the tree. Each
1386      * pair of leaves and each pair of pre-images are assumed to be sorted.
1387      */
1388     function verify(
1389         bytes32[] memory proof,
1390         bytes32 root,
1391         bytes32 leaf
1392     ) internal pure returns (bool) {
1393         return processProof(proof, leaf) == root;
1394     }
1395 
1396     /**
1397      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1398      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1399      * hash matches the root of the tree. When processing the proof, the pairs
1400      * of leafs & pre-images are assumed to be sorted.
1401      *
1402      * _Available since v4.4._
1403      */
1404     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1405         bytes32 computedHash = leaf;
1406         for (uint256 i = 0; i < proof.length; i++) {
1407             bytes32 proofElement = proof[i];
1408             if (computedHash <= proofElement) {
1409                 // Hash(current computed hash + current element of the proof)
1410                 computedHash = _efficientHash(computedHash, proofElement);
1411             } else {
1412                 // Hash(current element of the proof + current computed hash)
1413                 computedHash = _efficientHash(proofElement, computedHash);
1414             }
1415         }
1416         return computedHash;
1417     }
1418 
1419     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1420         assembly {
1421             mstore(0x00, a)
1422             mstore(0x20, b)
1423             value := keccak256(0x00, 0x40)
1424         }
1425     }
1426 }
1427 
1428 // File: contracts/ReMyth.sol
1429 
1430 
1431 pragma solidity ^0.8.13;
1432 
1433 
1434 
1435 
1436 
1437 
1438 contract BTCSENDERS is ERC721A, Ownable, DefaultOperatorFilterer {
1439 
1440     using Strings for uint;
1441 
1442     enum Step {
1443         StandBy,
1444         WhitelistSale,
1445         PublicSale,
1446         SoldOut,
1447         Reveal
1448     }
1449 
1450     Step public step;
1451 
1452     string public baseURI;
1453     string public notRevealedURI;
1454 
1455     uint public MAX_SUPPLY = 22222;
1456     uint public MAX_TEAM = 222;
1457     uint public MAX_TX = 100;
1458 
1459     bool private isRevealed = false;
1460 
1461     uint public wl_price = 0 ether;
1462     uint public public_price = 0 ether;
1463 
1464     uint public saleStartTime = 1649298400;
1465 
1466     bytes32 public merkleRoot;
1467 
1468     constructor(string memory _baseURI, bytes32 _merkleRoot) ERC721A("BTC Senders", "BTCSenders")
1469     {
1470         baseURI = _baseURI;
1471         merkleRoot = _merkleRoot;
1472     }
1473 
1474     modifier isNotContract() {
1475         require(tx.origin == msg.sender, "Reentrancy Guard is watching");
1476         _;
1477     }
1478 
1479     function getStep() public view returns(Step actualStep) {
1480         if(block.timestamp < saleStartTime) {
1481             return Step.StandBy;
1482         }
1483         if(block.timestamp >= saleStartTime
1484         &&block.timestamp < saleStartTime + 30 minutes) {
1485             return Step.WhitelistSale;
1486         }
1487         if(block.timestamp >= saleStartTime + 30 minutes) {
1488             return Step.PublicSale;
1489         }
1490     }
1491 
1492     function TeamMint(address _to, uint _quantity) external payable onlyOwner {
1493         require(totalSupply() + _quantity <= MAX_TEAM, "NFT can't be minted anymore");
1494         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1495         _safeMint(_to,  _quantity);
1496     }
1497 
1498     function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable isNotContract {
1499         require(getStep() == Step.WhitelistSale, "Whitelist Mint is not activated");
1500         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
1501         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1502         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1503         require(msg.value >= wl_price * _quantity, "Not enought funds");
1504         _safeMint(_account, _quantity);
1505     }
1506 
1507     function PublicMint(address _account, uint _quantity) external payable isNotContract {
1508         require(getStep() == Step.PublicSale, "Public Mint is not activated");
1509         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be mint anymore");
1510         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1511         require(msg.value >= public_price * _quantity, "Not enought funds");
1512         _safeMint(_account, _quantity);
1513     }
1514 
1515     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1516         baseURI = _newBaseURI;
1517     }
1518 
1519     function setSaleStartTime(uint _newSaleStartTime) external onlyOwner {
1520         saleStartTime = _newSaleStartTime;
1521     }
1522 
1523     function RegisterCommit(uint _newMAX_SUPPLY) external onlyOwner {
1524         MAX_SUPPLY = _newMAX_SUPPLY;
1525     }
1526 
1527     function revealCollection() external onlyOwner {
1528         isRevealed = true;
1529     }
1530 
1531     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1532         require(_exists(_tokenId), "URI query for nonexistent token");
1533         if(isRevealed == true) {
1534             return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1535         }
1536         else {
1537             return string(abi.encodePacked(baseURI, notRevealedURI));
1538         }
1539     }
1540 
1541    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1542         merkleRoot = _merkleRoot;
1543     }
1544 
1545     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
1546         return _verify(leaf(_account), _proof);
1547     }
1548 
1549     function leaf(address _account) internal pure returns(bytes32) {
1550         return keccak256(abi.encodePacked(_account));
1551     }
1552 
1553     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
1554         return MerkleProof.verify(_proof, merkleRoot, _leaf);
1555     }
1556 
1557     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1558         super.transferFrom(from, to, tokenId);
1559     }
1560 
1561     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1562         super.safeTransferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1566         public
1567         override
1568         onlyAllowedOperator(from)
1569     {
1570         super.safeTransferFrom(from, to, tokenId, data);
1571     }
1572 
1573     function Refund(uint amount) public onlyOwner {
1574         payable(msg.sender).transfer(amount);
1575     }
1576 }