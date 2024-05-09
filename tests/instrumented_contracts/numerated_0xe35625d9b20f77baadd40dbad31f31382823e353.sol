1 /**
2  *Submitted for verification at Etherscan.io on 2023-02-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 // File: contracts/IOperatorFilterRegistry.sol
9 
10 
11 pragma solidity ^0.8.13;
12 
13 interface IOperatorFilterRegistry {
14     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
15     function register(address registrant) external;
16     function registerAndSubscribe(address registrant, address subscription) external;
17     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
18     function updateOperator(address registrant, address operator, bool filtered) external;
19     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
20     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
21     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
22     function subscribe(address registrant, address registrantToSubscribe) external;
23     function unsubscribe(address registrant, bool copyExistingEntries) external;
24     function subscriptionOf(address addr) external returns (address registrant);
25     function subscribers(address registrant) external returns (address[] memory);
26     function subscriberAt(address registrant, uint256 index) external returns (address);
27     function copyEntriesOf(address registrant, address registrantToCopy) external;
28     function isOperatorFiltered(address registrant, address operator) external returns (bool);
29     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
30     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
31     function filteredOperators(address addr) external returns (address[] memory);
32     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
33     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
34     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
35     function isRegistered(address addr) external returns (bool);
36     function codeHashOf(address addr) external returns (bytes32);
37 }
38 
39 // File: contracts/OperatorFilterer.sol
40 
41 
42 pragma solidity ^0.8.13;
43 
44 
45 abstract contract OperatorFilterer {
46     error OperatorNotAllowed(address operator);
47 
48     IOperatorFilterRegistry constant operatorFilterRegistry =
49         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
50 
51     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
52         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
53         // will not revert, but the contract will need to be registered with the registry once it is deployed in
54         // order for the modifier to filter addresses.
55         if (address(operatorFilterRegistry).code.length > 0) {
56             if (subscribe) {
57                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
58             } else {
59                 if (subscriptionOrRegistrantToCopy != address(0)) {
60                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
61                 } else {
62                     operatorFilterRegistry.register(address(this));
63                 }
64             }
65         }
66     }
67 
68     modifier onlyAllowedOperator(address from) virtual {
69         // Check registry code length to facilitate testing in environments without a deployed registry.
70         if (address(operatorFilterRegistry).code.length > 0) {
71             // Allow spending tokens from addresses with balance
72             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73             // from an EOA.
74             if (from == msg.sender) {
75                 _;
76                 return;
77             }
78             if (
79                 !(
80                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
81                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
82                 )
83             ) {
84                 revert OperatorNotAllowed(msg.sender);
85             }
86         }
87         _;
88     }
89 }
90 
91 // File: contracts/DefaultOperatorFilterer.sol
92 
93 
94 pragma solidity ^0.8.13;
95 
96 
97 abstract contract DefaultOperatorFilterer is OperatorFilterer {
98     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
99 
100     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
101 }
102 
103 // File: contracts/IERC721A.sol
104 
105 
106 // ERC721A Contracts v4.0.0
107 // Creator: Chiru Labs
108 
109 pragma solidity ^0.8.4;
110 
111 /**
112  * @dev Interface of an ERC721A compliant contract.
113  */
114 interface IERC721A {
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error ApprovalCallerNotOwnerNorApproved();
119 
120     /**
121      * The token does not exist.
122      */
123     error ApprovalQueryForNonexistentToken();
124 
125     /**
126      * The caller cannot approve to their own address.
127      */
128     error ApproveToCaller();
129 
130     /**
131      * The caller cannot approve to the current owner.
132      */
133     error ApprovalToCurrentOwner();
134 
135     /**
136      * Cannot query the balance for the zero address.
137      */
138     error BalanceQueryForZeroAddress();
139 
140     /**
141      * Cannot mint to the zero address.
142      */
143     error MintToZeroAddress();
144 
145     /**
146      * The quantity of tokens minted must be more than zero.
147      */
148     error MintZeroQuantity();
149 
150     /**
151      * The token does not exist.
152      */
153     error OwnerQueryForNonexistentToken();
154 
155     /**
156      * The caller must own the token or be an approved operator.
157      */
158     error TransferCallerNotOwnerNorApproved();
159 
160     /**
161      * The token must be owned by `from`.
162      */
163     error TransferFromIncorrectOwner();
164 
165     /**
166      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
167      */
168     error TransferToNonERC721ReceiverImplementer();
169 
170     /**
171      * Cannot transfer to the zero address.
172      */
173     error TransferToZeroAddress();
174 
175     /**
176      * The token does not exist.
177      */
178     error URIQueryForNonexistentToken();
179 
180     struct TokenOwnership {
181         // The address of the owner.
182         address addr;
183         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
184         uint64 startTimestamp;
185         // Whether the token has been burned.
186         bool burned;
187     }
188 
189     /**
190      * @dev Returns the total amount of tokens stored by the contract.
191      *
192      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     // ==============================
197     //            IERC165
198     // ==============================
199 
200     /**
201      * @dev Returns true if this contract implements the interface defined by
202      * `interfaceId`. See the corresponding
203      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
204      * to learn more about how these ids are created.
205      *
206      * This function call must use less than 30 000 gas.
207      */
208     function supportsInterface(bytes4 interfaceId) external view returns (bool);
209 
210     // ==============================
211     //            IERC721
212     // ==============================
213 
214     /**
215      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
218 
219     /**
220      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
221      */
222     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
223 
224     /**
225      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
226      */
227     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
228 
229     /**
230      * @dev Returns the number of tokens in ``owner``'s account.
231      */
232     function balanceOf(address owner) external view returns (uint256 balance);
233 
234     /**
235      * @dev Returns the owner of the `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function ownerOf(uint256 tokenId) external view returns (address owner);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
265      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId
281     ) external;
282 
283     /**
284      * @dev Transfers `tokenId` token from `from` to `to`.
285      *
286      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
305      * The approval is cleared when the token is transferred.
306      *
307      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
308      *
309      * Requirements:
310      *
311      * - The caller must own the token or be an approved operator.
312      * - `tokenId` must exist.
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address to, uint256 tokenId) external;
317 
318     /**
319      * @dev Approve or remove `operator` as an operator for the caller.
320      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
321      *
322      * Requirements:
323      *
324      * - The `operator` cannot be the caller.
325      *
326      * Emits an {ApprovalForAll} event.
327      */
328     function setApprovalForAll(address operator, bool _approved) external;
329 
330     /**
331      * @dev Returns the account approved for `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function getApproved(uint256 tokenId) external view returns (address operator);
338 
339     /**
340      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
341      *
342      * See {setApprovalForAll}
343      */
344     function isApprovedForAll(address owner, address operator) external view returns (bool);
345 
346     // ==============================
347     //        IERC721Metadata
348     // ==============================
349 
350     /**
351      * @dev Returns the token collection name.
352      */
353     function name() external view returns (string memory);
354 
355     /**
356      * @dev Returns the token collection symbol.
357      */
358     function symbol() external view returns (string memory);
359 
360     /**
361      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
362      */
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 // File: contracts/ERC721A.sol
366 
367 
368 // ERC721A Contracts v4.0.0
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 
374 /**
375  * @dev ERC721 token receiver interface.
376  */
377 interface ERC721A__IERC721Receiver {
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 /**
387  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
388  * the Metadata extension. Built to optimize for lower gas during batch mints.
389  *
390  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
391  *
392  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
393  *
394  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
395  */
396 contract ERC721A is IERC721A {
397     // Mask of an entry in packed address data.
398     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
399 
400     // The bit position of `numberMinted` in packed address data.
401     uint256 private constant BITPOS_NUMBER_MINTED = 64;
402 
403     // The bit position of `numberBurned` in packed address data.
404     uint256 private constant BITPOS_NUMBER_BURNED = 128;
405 
406     // The bit position of `aux` in packed address data.
407     uint256 private constant BITPOS_AUX = 192;
408 
409     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
410     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
411 
412     // The bit position of `startTimestamp` in packed ownership.
413     uint256 private constant BITPOS_START_TIMESTAMP = 160;
414 
415     // The bit mask of the `burned` bit in packed ownership.
416     uint256 private constant BITMASK_BURNED = 1 << 224;
417 
418     // The bit position of the `nextInitialized` bit in packed ownership.
419     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
420 
421     // The bit mask of the `nextInitialized` bit in packed ownership.
422     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
423 
424     // The tokenId of the next token to be minted.
425     uint256 private _currentIndex;
426 
427     // The number of tokens burned.
428     uint256 private _burnCounter;
429 
430     // Token name
431     string private _name;
432 
433     // Token symbol
434     string private _symbol;
435 
436     // Mapping from token ID to ownership details
437     // An empty struct value does not necessarily mean the token is unowned.
438     // See `_packedOwnershipOf` implementation for details.
439     //
440     // Bits Layout:
441     // - [0..159]   `addr`
442     // - [160..223] `startTimestamp`
443     // - [224]      `burned`
444     // - [225]      `nextInitialized`
445     mapping(uint256 => uint256) private _packedOwnerships;
446 
447     // Mapping owner address to address data.
448     //
449     // Bits Layout:
450     // - [0..63]    `balance`
451     // - [64..127]  `numberMinted`
452     // - [128..191] `numberBurned`
453     // - [192..255] `aux`
454     mapping(address => uint256) private _packedAddressData;
455 
456     // Mapping from token ID to approved address.
457     mapping(uint256 => address) private _tokenApprovals;
458 
459     // Mapping from owner to operator approvals
460     mapping(address => mapping(address => bool)) private _operatorApprovals;
461 
462     constructor(string memory name_, string memory symbol_) {
463         _name = name_;
464         _symbol = symbol_;
465         _currentIndex = _startTokenId();
466     }
467 
468     /**
469      * @dev Returns the starting token ID.
470      * To change the starting token ID, please override this function.
471      */
472     function _startTokenId() internal view virtual returns (uint256) {
473         return 0;
474     }
475 
476     /**
477      * @dev Returns the next token ID to be minted.
478      */
479     function _nextTokenId() internal view returns (uint256) {
480         return _currentIndex;
481     }
482 
483     /**
484      * @dev Returns the total number of tokens in existence.
485      * Burned tokens will reduce the count.
486      * To get the total number of tokens minted, please see `_totalMinted`.
487      */
488     function totalSupply() public view override returns (uint256) {
489         // Counter underflow is impossible as _burnCounter cannot be incremented
490         // more than `_currentIndex - _startTokenId()` times.
491         unchecked {
492             return _currentIndex - _burnCounter - _startTokenId();
493         }
494     }
495 
496     /**
497      * @dev Returns the total amount of tokens minted in the contract.
498      */
499     function _totalMinted() internal view returns (uint256) {
500         // Counter underflow is impossible as _currentIndex does not decrement,
501         // and it is initialized to `_startTokenId()`
502         unchecked {
503             return _currentIndex - _startTokenId();
504         }
505     }
506 
507     /**
508      * @dev Returns the total number of tokens burned.
509      */
510     function _totalBurned() internal view returns (uint256) {
511         return _burnCounter;
512     }
513 
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         // The interface IDs are constants representing the first 4 bytes of the XOR of
519         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
520         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
521         return
522             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
523             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
524             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
525     }
526 
527     /**
528      * @dev See {IERC721-balanceOf}.
529      */
530     function balanceOf(address owner) public view override returns (uint256) {
531         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
532         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
533     }
534 
535     /**
536      * Returns the number of tokens minted by `owner`.
537      */
538     function _numberMinted(address owner) internal view returns (uint256) {
539         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
540     }
541 
542     /**
543      * Returns the number of tokens burned by or on behalf of `owner`.
544      */
545     function _numberBurned(address owner) internal view returns (uint256) {
546         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
547     }
548 
549     /**
550      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
551      */
552     function _getAux(address owner) internal view returns (uint64) {
553         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
554     }
555 
556     /**
557      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
558      * If there are multiple variables, please pack them into a uint64.
559      */
560     function _setAux(address owner, uint64 aux) internal {
561         uint256 packed = _packedAddressData[owner];
562         uint256 auxCasted;
563         assembly { // Cast aux without masking.
564             auxCasted := aux
565         }
566         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
567         _packedAddressData[owner] = packed;
568     }
569 
570     /**
571      * Returns the packed ownership data of `tokenId`.
572      */
573     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
574         uint256 curr = tokenId;
575 
576         unchecked {
577             if (_startTokenId() <= curr)
578                 if (curr < _currentIndex) {
579                     uint256 packed = _packedOwnerships[curr];
580                     // If not burned.
581                     if (packed & BITMASK_BURNED == 0) {
582                         // Invariant:
583                         // There will always be an ownership that has an address and is not burned
584                         // before an ownership that does not have an address and is not burned.
585                         // Hence, curr will not underflow.
586                         //
587                         // We can directly compare the packed value.
588                         // If the address is zero, packed is zero.
589                         while (packed == 0) {
590                             packed = _packedOwnerships[--curr];
591                         }
592                         return packed;
593                     }
594                 }
595         }
596         revert OwnerQueryForNonexistentToken();
597     }
598 
599     /**
600      * Returns the unpacked `TokenOwnership` struct from `packed`.
601      */
602     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
603         ownership.addr = address(uint160(packed));
604         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
605         ownership.burned = packed & BITMASK_BURNED != 0;
606     }
607 
608     /**
609      * Returns the unpacked `TokenOwnership` struct at `index`.
610      */
611     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
612         return _unpackedOwnership(_packedOwnerships[index]);
613     }
614 
615     /**
616      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
617      */
618     function _initializeOwnershipAt(uint256 index) internal {
619         if (_packedOwnerships[index] == 0) {
620             _packedOwnerships[index] = _packedOwnershipOf(index);
621         }
622     }
623 
624     /**
625      * Gas spent here starts off proportional to the maximum mint batch size.
626      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
627      */
628     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
629         return _unpackedOwnership(_packedOwnershipOf(tokenId));
630     }
631 
632     /**
633      * @dev See {IERC721-ownerOf}.
634      */
635     function ownerOf(uint256 tokenId) public view override returns (address) {
636         return address(uint160(_packedOwnershipOf(tokenId)));
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-name}.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-symbol}.
648      */
649     function symbol() public view virtual override returns (string memory) {
650         return _symbol;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-tokenURI}.
655      */
656     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
657         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
658 
659         string memory baseURI = _baseURI();
660         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
665      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
666      * by default, can be overriden in child contracts.
667      */
668     function _baseURI() internal view virtual returns (string memory) {
669         return '';
670     }
671 
672     /**
673      * @dev Casts the address to uint256 without masking.
674      */
675     function _addressToUint256(address value) private pure returns (uint256 result) {
676         assembly {
677             result := value
678         }
679     }
680 
681     /**
682      * @dev Casts the boolean to uint256 without branching.
683      */
684     function _boolToUint256(bool value) private pure returns (uint256 result) {
685         assembly {
686             result := value
687         }
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public override {
694         address owner = address(uint160(_packedOwnershipOf(tokenId)));
695         if (to == owner) revert ApprovalToCurrentOwner();
696 
697         if (_msgSenderERC721A() != owner)
698             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
699                 revert ApprovalCallerNotOwnerNorApproved();
700             }
701 
702         _tokenApprovals[tokenId] = to;
703         emit Approval(owner, to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-getApproved}.
708      */
709     function getApproved(uint256 tokenId) public view override returns (address) {
710         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
711 
712         return _tokenApprovals[tokenId];
713     }
714 
715     /**
716      * @dev See {IERC721-setApprovalForAll}.
717      */
718     function setApprovalForAll(address operator, bool approved) public virtual override {
719         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
720 
721         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
722         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
723     }
724 
725     /**
726      * @dev See {IERC721-isApprovedForAll}.
727      */
728     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
729         return _operatorApprovals[owner][operator];
730     }
731 
732     /**
733      * @dev See {IERC721-transferFrom}.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, '');
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         _transfer(from, to, tokenId);
764         if (to.code.length != 0)
765             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
766                 revert TransferToNonERC721ReceiverImplementer();
767             }
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      */
777     function _exists(uint256 tokenId) internal view returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex && // If within bounds,
781             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
782     }
783 
784     /**
785      * @dev Equivalent to `_safeMint(to, quantity, '')`.
786      */
787     function _safeMint(address to, uint256 quantity) internal {
788         _safeMint(to, quantity, '');
789     }
790 
791     /**
792      * @dev Safely mints `quantity` tokens and transfers them to `to`.
793      *
794      * Requirements:
795      *
796      * - If `to` refers to a smart contract, it must implement
797      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
798      * - `quantity` must be greater than 0.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeMint(
803         address to,
804         uint256 quantity,
805         bytes memory _data
806     ) internal {
807         uint256 startTokenId = _currentIndex;
808         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
809         if (quantity == 0) revert MintZeroQuantity();
810 
811         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
812 
813         // Overflows are incredibly unrealistic.
814         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
815         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
816         unchecked {
817             // Updates:
818             // - `balance += quantity`.
819             // - `numberMinted += quantity`.
820             //
821             // We can directly add to the balance and number minted.
822             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
823 
824             // Updates:
825             // - `address` to the owner.
826             // - `startTimestamp` to the timestamp of minting.
827             // - `burned` to `false`.
828             // - `nextInitialized` to `quantity == 1`.
829             _packedOwnerships[startTokenId] =
830                 _addressToUint256(to) |
831                 (block.timestamp << BITPOS_START_TIMESTAMP) |
832                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
833 
834             uint256 updatedIndex = startTokenId;
835             uint256 end = updatedIndex + quantity;
836 
837             if (to.code.length != 0) {
838                 do {
839                     emit Transfer(address(0), to, updatedIndex);
840                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
841                         revert TransferToNonERC721ReceiverImplementer();
842                     }
843                 } while (updatedIndex < end);
844                 // Reentrancy protection
845                 if (_currentIndex != startTokenId) revert();
846             } else {
847                 do {
848                     emit Transfer(address(0), to, updatedIndex++);
849                 } while (updatedIndex < end);
850             }
851             _currentIndex = updatedIndex;
852         }
853         _afterTokenTransfers(address(0), to, startTokenId, quantity);
854     }
855 
856     /**
857      * @dev Mints `quantity` tokens and transfers them to `to`.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `quantity` must be greater than 0.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 quantity) internal {
867         uint256 startTokenId = _currentIndex;
868         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
869         if (quantity == 0) revert MintZeroQuantity();
870 
871         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
872 
873         // Overflows are incredibly unrealistic.
874         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
875         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
876         unchecked {
877             // Updates:
878             // - `balance += quantity`.
879             // - `numberMinted += quantity`.
880             //
881             // We can directly add to the balance and number minted.
882             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
883 
884             // Updates:
885             // - `address` to the owner.
886             // - `startTimestamp` to the timestamp of minting.
887             // - `burned` to `false`.
888             // - `nextInitialized` to `quantity == 1`.
889             _packedOwnerships[startTokenId] =
890                 _addressToUint256(to) |
891                 (block.timestamp << BITPOS_START_TIMESTAMP) |
892                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
893 
894             uint256 updatedIndex = startTokenId;
895             uint256 end = updatedIndex + quantity;
896 
897             do {
898                 emit Transfer(address(0), to, updatedIndex++);
899             } while (updatedIndex < end);
900 
901             _currentIndex = updatedIndex;
902         }
903         _afterTokenTransfers(address(0), to, startTokenId, quantity);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) private {
921         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
922 
923         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
924 
925         address approvedAddress = _tokenApprovals[tokenId];
926 
927         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
928             isApprovedForAll(from, _msgSenderERC721A()) ||
929             approvedAddress == _msgSenderERC721A());
930 
931         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
932         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
933 
934         _beforeTokenTransfers(from, to, tokenId, 1);
935 
936         // Clear approvals from the previous owner.
937         if (_addressToUint256(approvedAddress) != 0) {
938             delete _tokenApprovals[tokenId];
939         }
940 
941         // Underflow of the sender's balance is impossible because we check for
942         // ownership above and the recipient's balance can't realistically overflow.
943         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
944         unchecked {
945             // We can directly increment and decrement the balances.
946             --_packedAddressData[from]; // Updates: `balance -= 1`.
947             ++_packedAddressData[to]; // Updates: `balance += 1`.
948 
949             // Updates:
950             // - `address` to the next owner.
951             // - `startTimestamp` to the timestamp of transfering.
952             // - `burned` to `false`.
953             // - `nextInitialized` to `true`.
954             _packedOwnerships[tokenId] =
955                 _addressToUint256(to) |
956                 (block.timestamp << BITPOS_START_TIMESTAMP) |
957                 BITMASK_NEXT_INITIALIZED;
958 
959             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
960             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
961                 uint256 nextTokenId = tokenId + 1;
962                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
963                 if (_packedOwnerships[nextTokenId] == 0) {
964                     // If the next slot is within bounds.
965                     if (nextTokenId != _currentIndex) {
966                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
967                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
968                     }
969                 }
970             }
971         }
972 
973         emit Transfer(from, to, tokenId);
974         _afterTokenTransfers(from, to, tokenId, 1);
975     }
976 
977     /**
978      * @dev Equivalent to `_burn(tokenId, false)`.
979      */
980     function _burn(uint256 tokenId) internal virtual {
981         _burn(tokenId, false);
982     }
983 
984     /**
985      * @dev Destroys `tokenId`.
986      * The approval is cleared when the token is burned.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
995         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
996 
997         address from = address(uint160(prevOwnershipPacked));
998         address approvedAddress = _tokenApprovals[tokenId];
999 
1000         if (approvalCheck) {
1001             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1002                 isApprovedForAll(from, _msgSenderERC721A()) ||
1003                 approvedAddress == _msgSenderERC721A());
1004 
1005             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1006         }
1007 
1008         _beforeTokenTransfers(from, address(0), tokenId, 1);
1009 
1010         // Clear approvals from the previous owner.
1011         if (_addressToUint256(approvedAddress) != 0) {
1012             delete _tokenApprovals[tokenId];
1013         }
1014 
1015         // Underflow of the sender's balance is impossible because we check for
1016         // ownership above and the recipient's balance can't realistically overflow.
1017         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1018         unchecked {
1019             // Updates:
1020             // - `balance -= 1`.
1021             // - `numberBurned += 1`.
1022             //
1023             // We can directly decrement the balance, and increment the number burned.
1024             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1025             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1026 
1027             // Updates:
1028             // - `address` to the last owner.
1029             // - `startTimestamp` to the timestamp of burning.
1030             // - `burned` to `true`.
1031             // - `nextInitialized` to `true`.
1032             _packedOwnerships[tokenId] =
1033                 _addressToUint256(from) |
1034                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1035                 BITMASK_BURNED |
1036                 BITMASK_NEXT_INITIALIZED;
1037 
1038             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1039             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1040                 uint256 nextTokenId = tokenId + 1;
1041                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1042                 if (_packedOwnerships[nextTokenId] == 0) {
1043                     // If the next slot is within bounds.
1044                     if (nextTokenId != _currentIndex) {
1045                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1046                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1047                     }
1048                 }
1049             }
1050         }
1051 
1052         emit Transfer(from, address(0), tokenId);
1053         _afterTokenTransfers(from, address(0), tokenId, 1);
1054 
1055         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1056         unchecked {
1057             _burnCounter++;
1058         }
1059     }
1060 
1061     /**
1062      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1063      *
1064      * @param from address representing the previous owner of the given token ID
1065      * @param to target address that will receive the tokens
1066      * @param tokenId uint256 ID of the token to be transferred
1067      * @param _data bytes optional data to send along with the call
1068      * @return bool whether the call correctly returned the expected magic value
1069      */
1070     function _checkContractOnERC721Received(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) private returns (bool) {
1076         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1077             bytes4 retval
1078         ) {
1079             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1080         } catch (bytes memory reason) {
1081             if (reason.length == 0) {
1082                 revert TransferToNonERC721ReceiverImplementer();
1083             } else {
1084                 assembly {
1085                     revert(add(32, reason), mload(reason))
1086                 }
1087             }
1088         }
1089     }
1090 
1091     /**
1092      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1093      * And also called before burning one token.
1094      *
1095      * startTokenId - the first token id to be transferred
1096      * quantity - the amount to be transferred
1097      *
1098      * Calling conditions:
1099      *
1100      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1101      * transferred to `to`.
1102      * - When `from` is zero, `tokenId` will be minted for `to`.
1103      * - When `to` is zero, `tokenId` will be burned by `from`.
1104      * - `from` and `to` are never both zero.
1105      */
1106     function _beforeTokenTransfers(
1107         address from,
1108         address to,
1109         uint256 startTokenId,
1110         uint256 quantity
1111     ) internal virtual {}
1112 
1113     /**
1114      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1115      * minting.
1116      * And also called after one token has been burned.
1117      *
1118      * startTokenId - the first token id to be transferred
1119      * quantity - the amount to be transferred
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` has been minted for `to`.
1126      * - When `to` is zero, `tokenId` has been burned by `from`.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _afterTokenTransfers(
1130         address from,
1131         address to,
1132         uint256 startTokenId,
1133         uint256 quantity
1134     ) internal virtual {}
1135 
1136     /**
1137      * @dev Returns the message sender (defaults to `msg.sender`).
1138      *
1139      * If you are writing GSN compatible contracts, you need to override this function.
1140      */
1141     function _msgSenderERC721A() internal view virtual returns (address) {
1142         return msg.sender;
1143     }
1144 
1145     /**
1146      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1147      */
1148     function _toString(uint256 value) internal pure returns (string memory ptr) {
1149         assembly {
1150             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1151             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1152             // We will need 1 32-byte word to store the length,
1153             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1154             ptr := add(mload(0x40), 128)
1155             // Update the free memory pointer to allocate.
1156             mstore(0x40, ptr)
1157 
1158             // Cache the end of the memory to calculate the length later.
1159             let end := ptr
1160 
1161             // We write the string from the rightmost digit to the leftmost digit.
1162             // The following is essentially a do-while loop that also handles the zero case.
1163             // Costs a bit more than early returning for the zero case,
1164             // but cheaper in terms of deployment and overall runtime costs.
1165             for {
1166                 // Initialize and perform the first pass without check.
1167                 let temp := value
1168                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1169                 ptr := sub(ptr, 1)
1170                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1171                 mstore8(ptr, add(48, mod(temp, 10)))
1172                 temp := div(temp, 10)
1173             } temp {
1174                 // Keep dividing `temp` until zero.
1175                 temp := div(temp, 10)
1176             } { // Body of the for loop.
1177                 ptr := sub(ptr, 1)
1178                 mstore8(ptr, add(48, mod(temp, 10)))
1179             }
1180 
1181             let length := sub(end, ptr)
1182             // Move the pointer 32 bytes leftwards to make room for the length.
1183             ptr := sub(ptr, 32)
1184             // Store the length.
1185             mstore(ptr, length)
1186         }
1187     }
1188 }
1189 // File: @openzeppelin/contracts/utils/Strings.sol
1190 
1191 
1192 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 /**
1197  * @dev String operations.
1198  */
1199 library Strings {
1200     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1201 
1202     /**
1203      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1204      */
1205     function toString(uint256 value) internal pure returns (string memory) {
1206         // Inspired by OraclizeAPI's implementation - MIT licence
1207         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1208 
1209         if (value == 0) {
1210             return "0";
1211         }
1212         uint256 temp = value;
1213         uint256 digits;
1214         while (temp != 0) {
1215             digits++;
1216             temp /= 10;
1217         }
1218         bytes memory buffer = new bytes(digits);
1219         while (value != 0) {
1220             digits -= 1;
1221             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1222             value /= 10;
1223         }
1224         return string(buffer);
1225     }
1226 
1227     /**
1228      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1229      */
1230     function toHexString(uint256 value) internal pure returns (string memory) {
1231         if (value == 0) {
1232             return "0x00";
1233         }
1234         uint256 temp = value;
1235         uint256 length = 0;
1236         while (temp != 0) {
1237             length++;
1238             temp >>= 8;
1239         }
1240         return toHexString(value, length);
1241     }
1242 
1243     /**
1244      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1245      */
1246     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1247         bytes memory buffer = new bytes(2 * length + 2);
1248         buffer[0] = "0";
1249         buffer[1] = "x";
1250         for (uint256 i = 2 * length + 1; i > 1; --i) {
1251             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1252             value >>= 4;
1253         }
1254         require(value == 0, "Strings: hex length insufficient");
1255         return string(buffer);
1256     }
1257 }
1258 
1259 // File: @openzeppelin/contracts/utils/Context.sol
1260 
1261 
1262 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 /**
1267  * @dev Provides information about the current execution context, including the
1268  * sender of the transaction and its data. While these are generally available
1269  * via msg.sender and msg.data, they should not be accessed in such a direct
1270  * manner, since when dealing with meta-transactions the account sending and
1271  * paying for execution may not be the actual sender (as far as an application
1272  * is concerned).
1273  *
1274  * This contract is only required for intermediate, library-like contracts.
1275  */
1276 abstract contract Context {
1277     function _msgSender() internal view virtual returns (address) {
1278         return msg.sender;
1279     }
1280 
1281     function _msgData() internal view virtual returns (bytes calldata) {
1282         return msg.data;
1283     }
1284 }
1285 
1286 // File: @openzeppelin/contracts/access/Ownable.sol
1287 
1288 
1289 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1290 
1291 pragma solidity ^0.8.0;
1292 
1293 
1294 /**
1295  * @dev Contract module which provides a basic access control mechanism, where
1296  * there is an account (an owner) that can be granted exclusive access to
1297  * specific functions.
1298  *
1299  * By default, the owner account will be the one that deploys the contract. This
1300  * can later be changed with {transferOwnership}.
1301  *
1302  * This module is used through inheritance. It will make available the modifier
1303  * `onlyOwner`, which can be applied to your functions to restrict their use to
1304  * the owner.
1305  */
1306 abstract contract Ownable is Context {
1307     address private _owner;
1308 
1309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1310 
1311     /**
1312      * @dev Initializes the contract setting the deployer as the initial owner.
1313      */
1314     constructor() {
1315         _transferOwnership(_msgSender());
1316     }
1317 
1318     /**
1319      * @dev Returns the address of the current owner.
1320      */
1321     function owner() public view virtual returns (address) {
1322         return _owner;
1323     }
1324 
1325     /**
1326      * @dev Throws if called by any account other than the owner.
1327      */
1328     modifier onlyOwner() {
1329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1330         _;
1331     }
1332 
1333     /**
1334      * @dev Leaves the contract without owner. It will not be possible to call
1335      * `onlyOwner` functions anymore. Can only be called by the current owner.
1336      *
1337      * NOTE: Renouncing ownership will leave the contract without an owner,
1338      * thereby removing any functionality that is only available to the owner.
1339      */
1340     function renounceOwnership() public virtual onlyOwner {
1341         _transferOwnership(address(0));
1342     }
1343 
1344     /**
1345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1346      * Can only be called by the current owner.
1347      */
1348     function transferOwnership(address newOwner) public virtual onlyOwner {
1349         require(newOwner != address(0), "Ownable: new owner is the zero address");
1350         _transferOwnership(newOwner);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Internal function without access restriction.
1356      */
1357     function _transferOwnership(address newOwner) internal virtual {
1358         address oldOwner = _owner;
1359         _owner = newOwner;
1360         emit OwnershipTransferred(oldOwner, newOwner);
1361     }
1362 }
1363 
1364 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1365 
1366 
1367 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 /**
1372  * @dev These functions deal with verification of Merkle Trees proofs.
1373  *
1374  * The proofs can be generated using the JavaScript library
1375  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1376  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1377  *
1378  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1379  *
1380  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1381  * hashing, or use a hash function other than keccak256 for hashing leaves.
1382  * This is because the concatenation of a sorted pair of internal nodes in
1383  * the merkle tree could be reinterpreted as a leaf value.
1384  */
1385 library MerkleProof {
1386     /**
1387      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1388      * defined by `root`. For this, a `proof` must be provided, containing
1389      * sibling hashes on the branch from the leaf to the root of the tree. Each
1390      * pair of leaves and each pair of pre-images are assumed to be sorted.
1391      */
1392     function verify(
1393         bytes32[] memory proof,
1394         bytes32 root,
1395         bytes32 leaf
1396     ) internal pure returns (bool) {
1397         return processProof(proof, leaf) == root;
1398     }
1399 
1400     /**
1401      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1402      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1403      * hash matches the root of the tree. When processing the proof, the pairs
1404      * of leafs & pre-images are assumed to be sorted.
1405      *
1406      * _Available since v4.4._
1407      */
1408     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1409         bytes32 computedHash = leaf;
1410         for (uint256 i = 0; i < proof.length; i++) {
1411             bytes32 proofElement = proof[i];
1412             if (computedHash <= proofElement) {
1413                 // Hash(current computed hash + current element of the proof)
1414                 computedHash = _efficientHash(computedHash, proofElement);
1415             } else {
1416                 // Hash(current element of the proof + current computed hash)
1417                 computedHash = _efficientHash(proofElement, computedHash);
1418             }
1419         }
1420         return computedHash;
1421     }
1422 
1423     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1424         assembly {
1425             mstore(0x00, a)
1426             mstore(0x20, b)
1427             value := keccak256(0x00, 0x40)
1428         }
1429     }
1430 }
1431 
1432 // File: contracts/ReMyth.sol
1433 
1434 
1435 pragma solidity ^0.8.13;
1436 
1437 
1438 
1439 
1440 
1441 
1442 contract BEEPLEAVATARS is ERC721A, Ownable, DefaultOperatorFilterer {
1443 
1444     using Strings for uint;
1445 
1446     enum Step {
1447         StandBy,
1448         WhitelistSale,
1449         PublicSale,
1450         SoldOut,
1451         Reveal
1452     }
1453 
1454     Step public step;
1455 
1456     string public baseURI;
1457     string public notRevealedURI;
1458 
1459     uint public MAX_SUPPLY = 111;
1460     uint public MAX_TEAM = 2222;
1461     uint public MAX_TX = 200;
1462 
1463     bool private isRevealed = false;
1464 
1465     uint public wl_price = 0 ether;
1466     uint public public_price = 0 ether;
1467 
1468     uint public saleStartTime = 1649298400;
1469 
1470     bytes32 public merkleRoot;
1471 
1472     constructor(string memory _baseURI, bytes32 _merkleRoot) ERC721A("Beeple Avatars", "BEEPLEAVATARS")
1473     {
1474         baseURI = _baseURI;
1475         merkleRoot = _merkleRoot;
1476     }
1477 
1478     modifier isNotContract() {
1479         require(tx.origin == msg.sender, "Reentrancy Guard is watching");
1480         _;
1481     }
1482 
1483     function getStep() public view returns(Step actualStep) {
1484         if(block.timestamp < saleStartTime) {
1485             return Step.StandBy;
1486         }
1487         if(block.timestamp >= saleStartTime
1488         &&block.timestamp < saleStartTime + 30 minutes) {
1489             return Step.WhitelistSale;
1490         }
1491         if(block.timestamp >= saleStartTime + 30 minutes) {
1492             return Step.PublicSale;
1493         }
1494     }
1495 
1496     function TeamMint(address _to, uint _quantity) external payable onlyOwner {
1497         require(totalSupply() + _quantity <= MAX_TEAM, "NFT can't be minted anymore");
1498         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1499         _safeMint(_to,  _quantity);
1500     }
1501 
1502     function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable isNotContract {
1503         require(getStep() == Step.WhitelistSale, "Whitelist Mint is not activated");
1504         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
1505         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1506         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1507         require(msg.value >= wl_price * _quantity, "Not enought funds");
1508         _safeMint(_account, _quantity);
1509     }
1510 
1511     function PublicMint(address _account, uint _quantity) external payable isNotContract {
1512         require(getStep() == Step.PublicSale, "Public Mint is not activated");
1513         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be mint anymore");
1514         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1515         require(msg.value >= public_price * _quantity, "Not enought funds");
1516         _safeMint(_account, _quantity);
1517     }
1518 
1519     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1520         baseURI = _newBaseURI;
1521     }
1522 
1523     function setSaleStartTime(uint _newSaleStartTime) external onlyOwner {
1524         saleStartTime = _newSaleStartTime;
1525     }
1526 
1527     function setMaxSupply(uint _newMAX_SUPPLY) external onlyOwner {
1528         MAX_SUPPLY = _newMAX_SUPPLY;
1529     }
1530 
1531     function revealCollection() external onlyOwner {
1532         isRevealed = true;
1533     }
1534 
1535     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1536         require(_exists(_tokenId), "URI query for nonexistent token");
1537         if(isRevealed == true) {
1538             return string(abi.encodePacked(baseURI, _tokenId.toString(), ""));
1539         }
1540         else {
1541             return string(abi.encodePacked(baseURI, notRevealedURI));
1542         }
1543     }
1544 
1545    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1546         merkleRoot = _merkleRoot;
1547     }
1548 
1549     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
1550         return _verify(leaf(_account), _proof);
1551     }
1552 
1553     function leaf(address _account) internal pure returns(bytes32) {
1554         return keccak256(abi.encodePacked(_account));
1555     }
1556 
1557     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
1558         return MerkleProof.verify(_proof, merkleRoot, _leaf);
1559     }
1560 
1561     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1562         super.transferFrom(from, to, tokenId);
1563     }
1564 
1565     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1566         super.safeTransferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1570         public
1571         override
1572         onlyAllowedOperator(from)
1573     {
1574         super.safeTransferFrom(from, to, tokenId, data);
1575     }
1576 
1577     function Refund(uint amount) public onlyOwner {
1578         payable(msg.sender).transfer(amount);
1579     }
1580 }