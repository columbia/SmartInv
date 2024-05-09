1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-09
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-02-27
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
11 
12 // File: contracts/IOperatorFilterRegistry.sol
13 
14 
15 pragma solidity ^0.8.13;
16 
17 interface IOperatorFilterRegistry {
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19     function register(address registrant) external;
20     function registerAndSubscribe(address registrant, address subscription) external;
21     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
22     function updateOperator(address registrant, address operator, bool filtered) external;
23     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
24     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
25     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
26     function subscribe(address registrant, address registrantToSubscribe) external;
27     function unsubscribe(address registrant, bool copyExistingEntries) external;
28     function subscriptionOf(address addr) external returns (address registrant);
29     function subscribers(address registrant) external returns (address[] memory);
30     function subscriberAt(address registrant, uint256 index) external returns (address);
31     function copyEntriesOf(address registrant, address registrantToCopy) external;
32     function isOperatorFiltered(address registrant, address operator) external returns (bool);
33     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
34     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
35     function filteredOperators(address addr) external returns (address[] memory);
36     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
37     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
38     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
39     function isRegistered(address addr) external returns (bool);
40     function codeHashOf(address addr) external returns (bytes32);
41 }
42 
43 // File: contracts/OperatorFilterer.sol
44 
45 
46 pragma solidity ^0.8.13;
47 
48 
49 abstract contract OperatorFilterer {
50     error OperatorNotAllowed(address operator);
51 
52     IOperatorFilterRegistry constant operatorFilterRegistry =
53         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
54 
55     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
56         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
57         // will not revert, but the contract will need to be registered with the registry once it is deployed in
58         // order for the modifier to filter addresses.
59         if (address(operatorFilterRegistry).code.length > 0) {
60             if (subscribe) {
61                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
62             } else {
63                 if (subscriptionOrRegistrantToCopy != address(0)) {
64                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
65                 } else {
66                     operatorFilterRegistry.register(address(this));
67                 }
68             }
69         }
70     }
71 
72     modifier onlyAllowedOperator(address from) virtual {
73         // Check registry code length to facilitate testing in environments without a deployed registry.
74         if (address(operatorFilterRegistry).code.length > 0) {
75             // Allow spending tokens from addresses with balance
76             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
77             // from an EOA.
78             if (from == msg.sender) {
79                 _;
80                 return;
81             }
82             if (
83                 !(
84                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
85                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
86                 )
87             ) {
88                 revert OperatorNotAllowed(msg.sender);
89             }
90         }
91         _;
92     }
93 }
94 
95 // File: contracts/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 abstract contract DefaultOperatorFilterer is OperatorFilterer {
102     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
103 
104     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
105 }
106 
107 // File: contracts/IERC721A.sol
108 
109 
110 // ERC721A Contracts v4.0.0
111 // Creator: Chiru Labs
112 
113 pragma solidity ^0.8.4;
114 
115 /**
116  * @dev Interface of an ERC721A compliant contract.
117  */
118 interface IERC721A {
119     /**
120      * The caller must own the token or be an approved operator.
121      */
122     error ApprovalCallerNotOwnerNorApproved();
123 
124     /**
125      * The token does not exist.
126      */
127     error ApprovalQueryForNonexistentToken();
128 
129     /**
130      * The caller cannot approve to their own address.
131      */
132     error ApproveToCaller();
133 
134     /**
135      * The caller cannot approve to the current owner.
136      */
137     error ApprovalToCurrentOwner();
138 
139     /**
140      * Cannot query the balance for the zero address.
141      */
142     error BalanceQueryForZeroAddress();
143 
144     /**
145      * Cannot mint to the zero address.
146      */
147     error MintToZeroAddress();
148 
149     /**
150      * The quantity of tokens minted must be more than zero.
151      */
152     error MintZeroQuantity();
153 
154     /**
155      * The token does not exist.
156      */
157     error OwnerQueryForNonexistentToken();
158 
159     /**
160      * The caller must own the token or be an approved operator.
161      */
162     error TransferCallerNotOwnerNorApproved();
163 
164     /**
165      * The token must be owned by `from`.
166      */
167     error TransferFromIncorrectOwner();
168 
169     /**
170      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
171      */
172     error TransferToNonERC721ReceiverImplementer();
173 
174     /**
175      * Cannot transfer to the zero address.
176      */
177     error TransferToZeroAddress();
178 
179     /**
180      * The token does not exist.
181      */
182     error URIQueryForNonexistentToken();
183 
184     struct TokenOwnership {
185         // The address of the owner.
186         address addr;
187         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
188         uint64 startTimestamp;
189         // Whether the token has been burned.
190         bool burned;
191     }
192 
193     /**
194      * @dev Returns the total amount of tokens stored by the contract.
195      *
196      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     // ==============================
201     //            IERC165
202     // ==============================
203 
204     /**
205      * @dev Returns true if this contract implements the interface defined by
206      * `interfaceId`. See the corresponding
207      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
208      * to learn more about how these ids are created.
209      *
210      * This function call must use less than 30 000 gas.
211      */
212     function supportsInterface(bytes4 interfaceId) external view returns (bool);
213 
214     // ==============================
215     //            IERC721
216     // ==============================
217 
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
230      */
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237 
238     /**
239      * @dev Returns the owner of the `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function ownerOf(uint256 tokenId) external view returns (address owner);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId,
264         bytes calldata data
265     ) external;
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
269      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Transfers `tokenId` token from `from` to `to`.
289      *
290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external;
321 
322     /**
323      * @dev Approve or remove `operator` as an operator for the caller.
324      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
325      *
326      * Requirements:
327      *
328      * - The `operator` cannot be the caller.
329      *
330      * Emits an {ApprovalForAll} event.
331      */
332     function setApprovalForAll(address operator, bool _approved) external;
333 
334     /**
335      * @dev Returns the account approved for `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function getApproved(uint256 tokenId) external view returns (address operator);
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     // ==============================
351     //        IERC721Metadata
352     // ==============================
353 
354     /**
355      * @dev Returns the token collection name.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the token collection symbol.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
366      */
367     function tokenURI(uint256 tokenId) external view returns (string memory);
368 }
369 // File: contracts/ERC721A.sol
370 
371 
372 // ERC721A Contracts v4.0.0
373 // Creator: Chiru Labs
374 
375 pragma solidity ^0.8.4;
376 
377 
378 /**
379  * @dev ERC721 token receiver interface.
380  */
381 interface ERC721A__IERC721Receiver {
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 /**
391  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
392  * the Metadata extension. Built to optimize for lower gas during batch mints.
393  *
394  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
395  *
396  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
397  *
398  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
399  */
400 contract ERC721A is IERC721A {
401     // Mask of an entry in packed address data.
402     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
403 
404     // The bit position of `numberMinted` in packed address data.
405     uint256 private constant BITPOS_NUMBER_MINTED = 64;
406 
407     // The bit position of `numberBurned` in packed address data.
408     uint256 private constant BITPOS_NUMBER_BURNED = 128;
409 
410     // The bit position of `aux` in packed address data.
411     uint256 private constant BITPOS_AUX = 192;
412 
413     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
414     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
415 
416     // The bit position of `startTimestamp` in packed ownership.
417     uint256 private constant BITPOS_START_TIMESTAMP = 160;
418 
419     // The bit mask of the `burned` bit in packed ownership.
420     uint256 private constant BITMASK_BURNED = 1 << 224;
421 
422     // The bit position of the `nextInitialized` bit in packed ownership.
423     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
424 
425     // The bit mask of the `nextInitialized` bit in packed ownership.
426     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
427 
428     // The tokenId of the next token to be minted.
429     uint256 private _currentIndex;
430 
431     // The number of tokens burned.
432     uint256 private _burnCounter;
433 
434     // Token name
435     string private _name;
436 
437     // Token symbol
438     string private _symbol;
439 
440     // Mapping from token ID to ownership details
441     // An empty struct value does not necessarily mean the token is unowned.
442     // See `_packedOwnershipOf` implementation for details.
443     //
444     // Bits Layout:
445     // - [0..159]   `addr`
446     // - [160..223] `startTimestamp`
447     // - [224]      `burned`
448     // - [225]      `nextInitialized`
449     mapping(uint256 => uint256) private _packedOwnerships;
450 
451     // Mapping owner address to address data.
452     //
453     // Bits Layout:
454     // - [0..63]    `balance`
455     // - [64..127]  `numberMinted`
456     // - [128..191] `numberBurned`
457     // - [192..255] `aux`
458     mapping(address => uint256) private _packedAddressData;
459 
460     // Mapping from token ID to approved address.
461     mapping(uint256 => address) private _tokenApprovals;
462 
463     // Mapping from owner to operator approvals
464     mapping(address => mapping(address => bool)) private _operatorApprovals;
465 
466     constructor(string memory name_, string memory symbol_) {
467         _name = name_;
468         _symbol = symbol_;
469         _currentIndex = _startTokenId();
470     }
471 
472     /**
473      * @dev Returns the starting token ID.
474      * To change the starting token ID, please override this function.
475      */
476     function _startTokenId() internal view virtual returns (uint256) {
477         return 0;
478     }
479 
480     /**
481      * @dev Returns the next token ID to be minted.
482      */
483     function _nextTokenId() internal view returns (uint256) {
484         return _currentIndex;
485     }
486 
487     /**
488      * @dev Returns the total number of tokens in existence.
489      * Burned tokens will reduce the count.
490      * To get the total number of tokens minted, please see `_totalMinted`.
491      */
492     function totalSupply() public view override returns (uint256) {
493         // Counter underflow is impossible as _burnCounter cannot be incremented
494         // more than `_currentIndex - _startTokenId()` times.
495         unchecked {
496             return _currentIndex - _burnCounter - _startTokenId();
497         }
498     }
499 
500     /**
501      * @dev Returns the total amount of tokens minted in the contract.
502      */
503     function _totalMinted() internal view returns (uint256) {
504         // Counter underflow is impossible as _currentIndex does not decrement,
505         // and it is initialized to `_startTokenId()`
506         unchecked {
507             return _currentIndex - _startTokenId();
508         }
509     }
510 
511     /**
512      * @dev Returns the total number of tokens burned.
513      */
514     function _totalBurned() internal view returns (uint256) {
515         return _burnCounter;
516     }
517 
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         // The interface IDs are constants representing the first 4 bytes of the XOR of
523         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
524         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
525         return
526             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
527             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
528             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
529     }
530 
531     /**
532      * @dev See {IERC721-balanceOf}.
533      */
534     function balanceOf(address owner) public view override returns (uint256) {
535         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
536         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens minted by `owner`.
541      */
542     function _numberMinted(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the number of tokens burned by or on behalf of `owner`.
548      */
549     function _numberBurned(address owner) internal view returns (uint256) {
550         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
551     }
552 
553     /**
554      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
555      */
556     function _getAux(address owner) internal view returns (uint64) {
557         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
558     }
559 
560     /**
561      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
562      * If there are multiple variables, please pack them into a uint64.
563      */
564     function _setAux(address owner, uint64 aux) internal {
565         uint256 packed = _packedAddressData[owner];
566         uint256 auxCasted;
567         assembly { // Cast aux without masking.
568             auxCasted := aux
569         }
570         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
571         _packedAddressData[owner] = packed;
572     }
573 
574     /**
575      * Returns the packed ownership data of `tokenId`.
576      */
577     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
578         uint256 curr = tokenId;
579 
580         unchecked {
581             if (_startTokenId() <= curr)
582                 if (curr < _currentIndex) {
583                     uint256 packed = _packedOwnerships[curr];
584                     // If not burned.
585                     if (packed & BITMASK_BURNED == 0) {
586                         // Invariant:
587                         // There will always be an ownership that has an address and is not burned
588                         // before an ownership that does not have an address and is not burned.
589                         // Hence, curr will not underflow.
590                         //
591                         // We can directly compare the packed value.
592                         // If the address is zero, packed is zero.
593                         while (packed == 0) {
594                             packed = _packedOwnerships[--curr];
595                         }
596                         return packed;
597                     }
598                 }
599         }
600         revert OwnerQueryForNonexistentToken();
601     }
602 
603     /**
604      * Returns the unpacked `TokenOwnership` struct from `packed`.
605      */
606     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
607         ownership.addr = address(uint160(packed));
608         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
609         ownership.burned = packed & BITMASK_BURNED != 0;
610     }
611 
612     /**
613      * Returns the unpacked `TokenOwnership` struct at `index`.
614      */
615     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
616         return _unpackedOwnership(_packedOwnerships[index]);
617     }
618 
619     /**
620      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
621      */
622     function _initializeOwnershipAt(uint256 index) internal {
623         if (_packedOwnerships[index] == 0) {
624             _packedOwnerships[index] = _packedOwnershipOf(index);
625         }
626     }
627 
628     /**
629      * Gas spent here starts off proportional to the maximum mint batch size.
630      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
631      */
632     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnershipOf(tokenId));
634     }
635 
636     /**
637      * @dev See {IERC721-ownerOf}.
638      */
639     function ownerOf(uint256 tokenId) public view override returns (address) {
640         return address(uint160(_packedOwnershipOf(tokenId)));
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-name}.
645      */
646     function name() public view virtual override returns (string memory) {
647         return _name;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-symbol}.
652      */
653     function symbol() public view virtual override returns (string memory) {
654         return _symbol;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-tokenURI}.
659      */
660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
661         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
662 
663         string memory baseURI = _baseURI();
664         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
665     }
666 
667     /**
668      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
669      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
670      * by default, can be overriden in child contracts.
671      */
672     function _baseURI() internal view virtual returns (string memory) {
673         return '';
674     }
675 
676     /**
677      * @dev Casts the address to uint256 without masking.
678      */
679     function _addressToUint256(address value) private pure returns (uint256 result) {
680         assembly {
681             result := value
682         }
683     }
684 
685     /**
686      * @dev Casts the boolean to uint256 without branching.
687      */
688     function _boolToUint256(bool value) private pure returns (uint256 result) {
689         assembly {
690             result := value
691         }
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public override {
698         address owner = address(uint160(_packedOwnershipOf(tokenId)));
699         if (to == owner) revert ApprovalToCurrentOwner();
700 
701         if (_msgSenderERC721A() != owner)
702             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
703                 revert ApprovalCallerNotOwnerNorApproved();
704             }
705 
706         _tokenApprovals[tokenId] = to;
707         emit Approval(owner, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view override returns (address) {
714         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
724 
725         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
726         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, '');
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         _transfer(from, to, tokenId);
768         if (to.code.length != 0)
769             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
770                 revert TransferToNonERC721ReceiverImplementer();
771             }
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      */
781     function _exists(uint256 tokenId) internal view returns (bool) {
782         return
783             _startTokenId() <= tokenId &&
784             tokenId < _currentIndex && // If within bounds,
785             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
786     }
787 
788     /**
789      * @dev Equivalent to `_safeMint(to, quantity, '')`.
790      */
791     function _safeMint(address to, uint256 quantity) internal {
792         _safeMint(to, quantity, '');
793     }
794 
795     /**
796      * @dev Safely mints `quantity` tokens and transfers them to `to`.
797      *
798      * Requirements:
799      *
800      * - If `to` refers to a smart contract, it must implement
801      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
802      * - `quantity` must be greater than 0.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _safeMint(
807         address to,
808         uint256 quantity,
809         bytes memory _data
810     ) internal {
811         uint256 startTokenId = _currentIndex;
812         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
813         if (quantity == 0) revert MintZeroQuantity();
814 
815         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
816 
817         // Overflows are incredibly unrealistic.
818         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
819         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
820         unchecked {
821             // Updates:
822             // - `balance += quantity`.
823             // - `numberMinted += quantity`.
824             //
825             // We can directly add to the balance and number minted.
826             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
827 
828             // Updates:
829             // - `address` to the owner.
830             // - `startTimestamp` to the timestamp of minting.
831             // - `burned` to `false`.
832             // - `nextInitialized` to `quantity == 1`.
833             _packedOwnerships[startTokenId] =
834                 _addressToUint256(to) |
835                 (block.timestamp << BITPOS_START_TIMESTAMP) |
836                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
837 
838             uint256 updatedIndex = startTokenId;
839             uint256 end = updatedIndex + quantity;
840 
841             if (to.code.length != 0) {
842                 do {
843                     emit Transfer(address(0), to, updatedIndex);
844                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
845                         revert TransferToNonERC721ReceiverImplementer();
846                     }
847                 } while (updatedIndex < end);
848                 // Reentrancy protection
849                 if (_currentIndex != startTokenId) revert();
850             } else {
851                 do {
852                     emit Transfer(address(0), to, updatedIndex++);
853                 } while (updatedIndex < end);
854             }
855             _currentIndex = updatedIndex;
856         }
857         _afterTokenTransfers(address(0), to, startTokenId, quantity);
858     }
859 
860     /**
861      * @dev Mints `quantity` tokens and transfers them to `to`.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `quantity` must be greater than 0.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _mint(address to, uint256 quantity) internal {
871         uint256 startTokenId = _currentIndex;
872         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
873         if (quantity == 0) revert MintZeroQuantity();
874 
875         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
876 
877         // Overflows are incredibly unrealistic.
878         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
879         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
880         unchecked {
881             // Updates:
882             // - `balance += quantity`.
883             // - `numberMinted += quantity`.
884             //
885             // We can directly add to the balance and number minted.
886             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
887 
888             // Updates:
889             // - `address` to the owner.
890             // - `startTimestamp` to the timestamp of minting.
891             // - `burned` to `false`.
892             // - `nextInitialized` to `quantity == 1`.
893             _packedOwnerships[startTokenId] =
894                 _addressToUint256(to) |
895                 (block.timestamp << BITPOS_START_TIMESTAMP) |
896                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
897 
898             uint256 updatedIndex = startTokenId;
899             uint256 end = updatedIndex + quantity;
900 
901             do {
902                 emit Transfer(address(0), to, updatedIndex++);
903             } while (updatedIndex < end);
904 
905             _currentIndex = updatedIndex;
906         }
907         _afterTokenTransfers(address(0), to, startTokenId, quantity);
908     }
909 
910     /**
911      * @dev Transfers `tokenId` from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) private {
925         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
926 
927         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
928 
929         address approvedAddress = _tokenApprovals[tokenId];
930 
931         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
932             isApprovedForAll(from, _msgSenderERC721A()) ||
933             approvedAddress == _msgSenderERC721A());
934 
935         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
936         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
937 
938         _beforeTokenTransfers(from, to, tokenId, 1);
939 
940         // Clear approvals from the previous owner.
941         if (_addressToUint256(approvedAddress) != 0) {
942             delete _tokenApprovals[tokenId];
943         }
944 
945         // Underflow of the sender's balance is impossible because we check for
946         // ownership above and the recipient's balance can't realistically overflow.
947         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
948         unchecked {
949             // We can directly increment and decrement the balances.
950             --_packedAddressData[from]; // Updates: `balance -= 1`.
951             ++_packedAddressData[to]; // Updates: `balance += 1`.
952 
953             // Updates:
954             // - `address` to the next owner.
955             // - `startTimestamp` to the timestamp of transfering.
956             // - `burned` to `false`.
957             // - `nextInitialized` to `true`.
958             _packedOwnerships[tokenId] =
959                 _addressToUint256(to) |
960                 (block.timestamp << BITPOS_START_TIMESTAMP) |
961                 BITMASK_NEXT_INITIALIZED;
962 
963             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
964             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
965                 uint256 nextTokenId = tokenId + 1;
966                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
967                 if (_packedOwnerships[nextTokenId] == 0) {
968                     // If the next slot is within bounds.
969                     if (nextTokenId != _currentIndex) {
970                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
971                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
972                     }
973                 }
974             }
975         }
976 
977         emit Transfer(from, to, tokenId);
978         _afterTokenTransfers(from, to, tokenId, 1);
979     }
980 
981     /**
982      * @dev Equivalent to `_burn(tokenId, false)`.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         _burn(tokenId, false);
986     }
987 
988     /**
989      * @dev Destroys `tokenId`.
990      * The approval is cleared when the token is burned.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
999         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1000 
1001         address from = address(uint160(prevOwnershipPacked));
1002         address approvedAddress = _tokenApprovals[tokenId];
1003 
1004         if (approvalCheck) {
1005             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1006                 isApprovedForAll(from, _msgSenderERC721A()) ||
1007                 approvedAddress == _msgSenderERC721A());
1008 
1009             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1010         }
1011 
1012         _beforeTokenTransfers(from, address(0), tokenId, 1);
1013 
1014         // Clear approvals from the previous owner.
1015         if (_addressToUint256(approvedAddress) != 0) {
1016             delete _tokenApprovals[tokenId];
1017         }
1018 
1019         // Underflow of the sender's balance is impossible because we check for
1020         // ownership above and the recipient's balance can't realistically overflow.
1021         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1022         unchecked {
1023             // Updates:
1024             // - `balance -= 1`.
1025             // - `numberBurned += 1`.
1026             //
1027             // We can directly decrement the balance, and increment the number burned.
1028             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1029             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1030 
1031             // Updates:
1032             // - `address` to the last owner.
1033             // - `startTimestamp` to the timestamp of burning.
1034             // - `burned` to `true`.
1035             // - `nextInitialized` to `true`.
1036             _packedOwnerships[tokenId] =
1037                 _addressToUint256(from) |
1038                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1039                 BITMASK_BURNED |
1040                 BITMASK_NEXT_INITIALIZED;
1041 
1042             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1043             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1044                 uint256 nextTokenId = tokenId + 1;
1045                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1046                 if (_packedOwnerships[nextTokenId] == 0) {
1047                     // If the next slot is within bounds.
1048                     if (nextTokenId != _currentIndex) {
1049                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1050                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1051                     }
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, address(0), tokenId);
1057         _afterTokenTransfers(from, address(0), tokenId, 1);
1058 
1059         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1060         unchecked {
1061             _burnCounter++;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1067      *
1068      * @param from address representing the previous owner of the given token ID
1069      * @param to target address that will receive the tokens
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @param _data bytes optional data to send along with the call
1072      * @return bool whether the call correctly returned the expected magic value
1073      */
1074     function _checkContractOnERC721Received(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) private returns (bool) {
1080         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1081             bytes4 retval
1082         ) {
1083             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1084         } catch (bytes memory reason) {
1085             if (reason.length == 0) {
1086                 revert TransferToNonERC721ReceiverImplementer();
1087             } else {
1088                 assembly {
1089                     revert(add(32, reason), mload(reason))
1090                 }
1091             }
1092         }
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1097      * And also called before burning one token.
1098      *
1099      * startTokenId - the first token id to be transferred
1100      * quantity - the amount to be transferred
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, `tokenId` will be burned by `from`.
1108      * - `from` and `to` are never both zero.
1109      */
1110     function _beforeTokenTransfers(
1111         address from,
1112         address to,
1113         uint256 startTokenId,
1114         uint256 quantity
1115     ) internal virtual {}
1116 
1117     /**
1118      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1119      * minting.
1120      * And also called after one token has been burned.
1121      *
1122      * startTokenId - the first token id to be transferred
1123      * quantity - the amount to be transferred
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` has been minted for `to`.
1130      * - When `to` is zero, `tokenId` has been burned by `from`.
1131      * - `from` and `to` are never both zero.
1132      */
1133     function _afterTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 
1140     /**
1141      * @dev Returns the message sender (defaults to `msg.sender`).
1142      *
1143      * If you are writing GSN compatible contracts, you need to override this function.
1144      */
1145     function _msgSenderERC721A() internal view virtual returns (address) {
1146         return msg.sender;
1147     }
1148 
1149     /**
1150      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1151      */
1152     function _toString(uint256 value) internal pure returns (string memory ptr) {
1153         assembly {
1154             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1155             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1156             // We will need 1 32-byte word to store the length,
1157             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1158             ptr := add(mload(0x40), 128)
1159             // Update the free memory pointer to allocate.
1160             mstore(0x40, ptr)
1161 
1162             // Cache the end of the memory to calculate the length later.
1163             let end := ptr
1164 
1165             // We write the string from the rightmost digit to the leftmost digit.
1166             // The following is essentially a do-while loop that also handles the zero case.
1167             // Costs a bit more than early returning for the zero case,
1168             // but cheaper in terms of deployment and overall runtime costs.
1169             for {
1170                 // Initialize and perform the first pass without check.
1171                 let temp := value
1172                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1173                 ptr := sub(ptr, 1)
1174                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1175                 mstore8(ptr, add(48, mod(temp, 10)))
1176                 temp := div(temp, 10)
1177             } temp {
1178                 // Keep dividing `temp` until zero.
1179                 temp := div(temp, 10)
1180             } { // Body of the for loop.
1181                 ptr := sub(ptr, 1)
1182                 mstore8(ptr, add(48, mod(temp, 10)))
1183             }
1184 
1185             let length := sub(end, ptr)
1186             // Move the pointer 32 bytes leftwards to make room for the length.
1187             ptr := sub(ptr, 32)
1188             // Store the length.
1189             mstore(ptr, length)
1190         }
1191     }
1192 }
1193 // File: @openzeppelin/contracts/utils/Strings.sol
1194 
1195 
1196 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 /**
1201  * @dev String operations.
1202  */
1203 library Strings {
1204     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1205 
1206     /**
1207      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1208      */
1209     function toString(uint256 value) internal pure returns (string memory) {
1210         // Inspired by OraclizeAPI's implementation - MIT licence
1211         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1212 
1213         if (value == 0) {
1214             return "0";
1215         }
1216         uint256 temp = value;
1217         uint256 digits;
1218         while (temp != 0) {
1219             digits++;
1220             temp /= 10;
1221         }
1222         bytes memory buffer = new bytes(digits);
1223         while (value != 0) {
1224             digits -= 1;
1225             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1226             value /= 10;
1227         }
1228         return string(buffer);
1229     }
1230 
1231     /**
1232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1233      */
1234     function toHexString(uint256 value) internal pure returns (string memory) {
1235         if (value == 0) {
1236             return "0x00";
1237         }
1238         uint256 temp = value;
1239         uint256 length = 0;
1240         while (temp != 0) {
1241             length++;
1242             temp >>= 8;
1243         }
1244         return toHexString(value, length);
1245     }
1246 
1247     /**
1248      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1249      */
1250     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1251         bytes memory buffer = new bytes(2 * length + 2);
1252         buffer[0] = "0";
1253         buffer[1] = "x";
1254         for (uint256 i = 2 * length + 1; i > 1; --i) {
1255             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1256             value >>= 4;
1257         }
1258         require(value == 0, "Strings: hex length insufficient");
1259         return string(buffer);
1260     }
1261 }
1262 
1263 // File: @openzeppelin/contracts/utils/Context.sol
1264 
1265 
1266 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 /**
1271  * @dev Provides information about the current execution context, including the
1272  * sender of the transaction and its data. While these are generally available
1273  * via msg.sender and msg.data, they should not be accessed in such a direct
1274  * manner, since when dealing with meta-transactions the account sending and
1275  * paying for execution may not be the actual sender (as far as an application
1276  * is concerned).
1277  *
1278  * This contract is only required for intermediate, library-like contracts.
1279  */
1280 abstract contract Context {
1281     function _msgSender() internal view virtual returns (address) {
1282         return msg.sender;
1283     }
1284 
1285     function _msgData() internal view virtual returns (bytes calldata) {
1286         return msg.data;
1287     }
1288 }
1289 
1290 // File: @openzeppelin/contracts/access/Ownable.sol
1291 
1292 
1293 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 
1298 /**
1299  * @dev Contract module which provides a basic access control mechanism, where
1300  * there is an account (an owner) that can be granted exclusive access to
1301  * specific functions.
1302  *
1303  * By default, the owner account will be the one that deploys the contract. This
1304  * can later be changed with {transferOwnership}.
1305  *
1306  * This module is used through inheritance. It will make available the modifier
1307  * `onlyOwner`, which can be applied to your functions to restrict their use to
1308  * the owner.
1309  */
1310 abstract contract Ownable is Context {
1311     address private _owner;
1312 
1313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1314 
1315     /**
1316      * @dev Initializes the contract setting the deployer as the initial owner.
1317      */
1318     constructor() {
1319         _transferOwnership(_msgSender());
1320     }
1321 
1322     /**
1323      * @dev Returns the address of the current owner.
1324      */
1325     function owner() public view virtual returns (address) {
1326         return _owner;
1327     }
1328 
1329     /**
1330      * @dev Throws if called by any account other than the owner.
1331      */
1332     modifier onlyOwner() {
1333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1334         _;
1335     }
1336 
1337     /**
1338      * @dev Leaves the contract without owner. It will not be possible to call
1339      * `onlyOwner` functions anymore. Can only be called by the current owner.
1340      *
1341      * NOTE: Renouncing ownership will leave the contract without an owner,
1342      * thereby removing any functionality that is only available to the owner.
1343      */
1344     function renounceOwnership() public virtual onlyOwner {
1345         _transferOwnership(address(0));
1346     }
1347 
1348     /**
1349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1350      * Can only be called by the current owner.
1351      */
1352     function transferOwnership(address newOwner) public virtual onlyOwner {
1353         require(newOwner != address(0), "Ownable: new owner is the zero address");
1354         _transferOwnership(newOwner);
1355     }
1356 
1357     /**
1358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1359      * Internal function without access restriction.
1360      */
1361     function _transferOwnership(address newOwner) internal virtual {
1362         address oldOwner = _owner;
1363         _owner = newOwner;
1364         emit OwnershipTransferred(oldOwner, newOwner);
1365     }
1366 }
1367 
1368 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1369 
1370 
1371 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @dev These functions deal with verification of Merkle Trees proofs.
1377  *
1378  * The proofs can be generated using the JavaScript library
1379  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1380  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1381  *
1382  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1383  *
1384  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1385  * hashing, or use a hash function other than keccak256 for hashing leaves.
1386  * This is because the concatenation of a sorted pair of internal nodes in
1387  * the merkle tree could be reinterpreted as a leaf value.
1388  */
1389 library MerkleProof {
1390     /**
1391      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1392      * defined by `root`. For this, a `proof` must be provided, containing
1393      * sibling hashes on the branch from the leaf to the root of the tree. Each
1394      * pair of leaves and each pair of pre-images are assumed to be sorted.
1395      */
1396     function verify(
1397         bytes32[] memory proof,
1398         bytes32 root,
1399         bytes32 leaf
1400     ) internal pure returns (bool) {
1401         return processProof(proof, leaf) == root;
1402     }
1403 
1404     /**
1405      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1406      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1407      * hash matches the root of the tree. When processing the proof, the pairs
1408      * of leafs & pre-images are assumed to be sorted.
1409      *
1410      * _Available since v4.4._
1411      */
1412     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1413         bytes32 computedHash = leaf;
1414         for (uint256 i = 0; i < proof.length; i++) {
1415             bytes32 proofElement = proof[i];
1416             if (computedHash <= proofElement) {
1417                 // Hash(current computed hash + current element of the proof)
1418                 computedHash = _efficientHash(computedHash, proofElement);
1419             } else {
1420                 // Hash(current element of the proof + current computed hash)
1421                 computedHash = _efficientHash(proofElement, computedHash);
1422             }
1423         }
1424         return computedHash;
1425     }
1426 
1427     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1428         assembly {
1429             mstore(0x00, a)
1430             mstore(0x20, b)
1431             value := keccak256(0x00, 0x40)
1432         }
1433     }
1434 }
1435 
1436 // File: contracts/ReMyth.sol
1437 
1438 
1439 pragma solidity ^0.8.13;
1440 
1441 
1442 
1443 
1444 
1445 
1446 contract UMUCOSART is ERC721A, Ownable, DefaultOperatorFilterer {
1447 
1448     using Strings for uint;
1449 
1450     enum Step {
1451         StandBy,
1452         WhitelistSale,
1453         PublicSale,
1454         SoldOut,
1455         Reveal
1456     }
1457 
1458     Step public step;
1459 
1460     string public baseURI;
1461     string public notRevealedURI;
1462 
1463     uint public MAX_SUPPLY = 123;
1464     uint public MAX_TEAM = 2222;
1465     uint public MAX_TX = 200;
1466 
1467     bool private isRevealed = false;
1468 
1469     uint public wl_price = 0 ether;
1470     uint public public_price = 0 ether;
1471 
1472     uint public saleStartTime = 1649298400;
1473 
1474     bytes32 public merkleRoot;
1475 
1476     constructor(string memory _baseURI, bytes32 _merkleRoot) ERC721A("Umuco's Art", "UMUCOSART")
1477     {
1478         baseURI = _baseURI;
1479         merkleRoot = _merkleRoot;
1480     }
1481 
1482     modifier isNotContract() {
1483         require(tx.origin == msg.sender, "Reentrancy Guard is watching");
1484         _;
1485     }
1486 
1487     function getStep() public view returns(Step actualStep) {
1488         if(block.timestamp < saleStartTime) {
1489             return Step.StandBy;
1490         }
1491         if(block.timestamp >= saleStartTime
1492         &&block.timestamp < saleStartTime + 30 minutes) {
1493             return Step.WhitelistSale;
1494         }
1495         if(block.timestamp >= saleStartTime + 30 minutes) {
1496             return Step.PublicSale;
1497         }
1498     }
1499 
1500     function TeamMint(address _to, uint _quantity) external payable onlyOwner {
1501         require(totalSupply() + _quantity <= MAX_TEAM, "NFT can't be minted anymore");
1502         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1503         _safeMint(_to,  _quantity);
1504     }
1505 
1506     function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable isNotContract {
1507         require(getStep() == Step.WhitelistSale, "Whitelist Mint is not activated");
1508         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
1509         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1510         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1511         require(msg.value >= wl_price * _quantity, "Not enought funds");
1512         _safeMint(_account, _quantity);
1513     }
1514 
1515     function PublicMint(address _account, uint _quantity) external payable isNotContract {
1516         require(getStep() == Step.PublicSale, "Public Mint is not activated");
1517         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be mint anymore");
1518         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1519         require(msg.value >= public_price * _quantity, "Not enought funds");
1520         _safeMint(_account, _quantity);
1521     }
1522 
1523     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1524         baseURI = _newBaseURI;
1525     }
1526 
1527     function setSaleStartTime(uint _newSaleStartTime) external onlyOwner {
1528         saleStartTime = _newSaleStartTime;
1529     }
1530 
1531     function setMaxSupply(uint _newMAX_SUPPLY) external onlyOwner {
1532         MAX_SUPPLY = _newMAX_SUPPLY;
1533     }
1534 
1535     function revealCollection() external onlyOwner {
1536         isRevealed = true;
1537     }
1538 
1539     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1540         require(_exists(_tokenId), "URI query for nonexistent token");
1541         if(isRevealed == true) {
1542             return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1543         }
1544         else {
1545             return string(abi.encodePacked(baseURI, notRevealedURI));
1546         }
1547     }
1548 
1549    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1550         merkleRoot = _merkleRoot;
1551     }
1552 
1553     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
1554         return _verify(leaf(_account), _proof);
1555     }
1556 
1557     function leaf(address _account) internal pure returns(bytes32) {
1558         return keccak256(abi.encodePacked(_account));
1559     }
1560 
1561     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
1562         return MerkleProof.verify(_proof, merkleRoot, _leaf);
1563     }
1564 
1565     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1566         super.transferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1570         super.safeTransferFrom(from, to, tokenId);
1571     }
1572 
1573     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1574         public
1575         override
1576         onlyAllowedOperator(from)
1577     {
1578         super.safeTransferFrom(from, to, tokenId, data);
1579     }
1580 
1581     function Refund(uint amount) public onlyOwner {
1582         payable(msg.sender).transfer(amount);
1583     }
1584 }