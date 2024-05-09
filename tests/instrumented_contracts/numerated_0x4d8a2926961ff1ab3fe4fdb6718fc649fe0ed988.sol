1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-24
3 */
4 
5 // File: contracts/IOperatorFilterRegistry.sol
6 
7 
8 pragma solidity ^0.8.13;
9 
10 interface IOperatorFilterRegistry {
11     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
12     function register(address registrant) external;
13     function registerAndSubscribe(address registrant, address subscription) external;
14     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
15     function updateOperator(address registrant, address operator, bool filtered) external;
16     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
17     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
18     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
19     function subscribe(address registrant, address registrantToSubscribe) external;
20     function unsubscribe(address registrant, bool copyExistingEntries) external;
21     function subscriptionOf(address addr) external returns (address registrant);
22     function subscribers(address registrant) external returns (address[] memory);
23     function subscriberAt(address registrant, uint256 index) external returns (address);
24     function copyEntriesOf(address registrant, address registrantToCopy) external;
25     function isOperatorFiltered(address registrant, address operator) external returns (bool);
26     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
27     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
28     function filteredOperators(address addr) external returns (address[] memory);
29     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
30     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
31     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
32     function isRegistered(address addr) external returns (bool);
33     function codeHashOf(address addr) external returns (bytes32);
34 }
35 
36 // File: contracts/OperatorFilterer.sol
37 
38 
39 pragma solidity ^0.8.13;
40 
41 
42 abstract contract OperatorFilterer {
43     error OperatorNotAllowed(address operator);
44 
45     IOperatorFilterRegistry constant operatorFilterRegistry =
46         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
47 
48     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
49         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
50         // will not revert, but the contract will need to be registered with the registry once it is deployed in
51         // order for the modifier to filter addresses.
52         if (address(operatorFilterRegistry).code.length > 0) {
53             if (subscribe) {
54                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
55             } else {
56                 if (subscriptionOrRegistrantToCopy != address(0)) {
57                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
58                 } else {
59                     operatorFilterRegistry.register(address(this));
60                 }
61             }
62         }
63     }
64 
65     modifier onlyAllowedOperator(address from) virtual {
66         // Check registry code length to facilitate testing in environments without a deployed registry.
67         if (address(operatorFilterRegistry).code.length > 0) {
68             // Allow spending tokens from addresses with balance
69             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
70             // from an EOA.
71             if (from == msg.sender) {
72                 _;
73                 return;
74             }
75             if (
76                 !(
77                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
78                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
79                 )
80             ) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 }
87 
88 // File: contracts/DefaultOperatorFilterer.sol
89 
90 
91 pragma solidity ^0.8.13;
92 
93 
94 abstract contract DefaultOperatorFilterer is OperatorFilterer {
95     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
96 
97     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
98 }
99 
100 // File: contracts/IERC721A.sol
101 
102 
103 // ERC721A Contracts v4.0.0
104 // Creator: Chiru Labs
105 
106 pragma solidity ^0.8.4;
107 
108 /**
109  * @dev Interface of an ERC721A compliant contract.
110  */
111 interface IERC721A {
112     /**
113      * The caller must own the token or be an approved operator.
114      */
115     error ApprovalCallerNotOwnerNorApproved();
116 
117     /**
118      * The token does not exist.
119      */
120     error ApprovalQueryForNonexistentToken();
121 
122     /**
123      * The caller cannot approve to their own address.
124      */
125     error ApproveToCaller();
126 
127     /**
128      * The caller cannot approve to the current owner.
129      */
130     error ApprovalToCurrentOwner();
131 
132     /**
133      * Cannot query the balance for the zero address.
134      */
135     error BalanceQueryForZeroAddress();
136 
137     /**
138      * Cannot mint to the zero address.
139      */
140     error MintToZeroAddress();
141 
142     /**
143      * The quantity of tokens minted must be more than zero.
144      */
145     error MintZeroQuantity();
146 
147     /**
148      * The token does not exist.
149      */
150     error OwnerQueryForNonexistentToken();
151 
152     /**
153      * The caller must own the token or be an approved operator.
154      */
155     error TransferCallerNotOwnerNorApproved();
156 
157     /**
158      * The token must be owned by `from`.
159      */
160     error TransferFromIncorrectOwner();
161 
162     /**
163      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
164      */
165     error TransferToNonERC721ReceiverImplementer();
166 
167     /**
168      * Cannot transfer to the zero address.
169      */
170     error TransferToZeroAddress();
171 
172     /**
173      * The token does not exist.
174      */
175     error URIQueryForNonexistentToken();
176 
177     struct TokenOwnership {
178         // The address of the owner.
179         address addr;
180         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
181         uint64 startTimestamp;
182         // Whether the token has been burned.
183         bool burned;
184     }
185 
186     /**
187      * @dev Returns the total amount of tokens stored by the contract.
188      *
189      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     // ==============================
194     //            IERC165
195     // ==============================
196 
197     /**
198      * @dev Returns true if this contract implements the interface defined by
199      * `interfaceId`. See the corresponding
200      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
201      * to learn more about how these ids are created.
202      *
203      * This function call must use less than 30 000 gas.
204      */
205     function supportsInterface(bytes4 interfaceId) external view returns (bool);
206 
207     // ==============================
208     //            IERC721
209     // ==============================
210 
211     /**
212      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
215 
216     /**
217      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
218      */
219     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
220 
221     /**
222      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
223      */
224     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
225 
226     /**
227      * @dev Returns the number of tokens in ``owner``'s account.
228      */
229     function balanceOf(address owner) external view returns (uint256 balance);
230 
231     /**
232      * @dev Returns the owner of the `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function ownerOf(uint256 tokenId) external view returns (address owner);
239 
240     /**
241      * @dev Safely transfers `tokenId` token from `from` to `to`.
242      *
243      * Requirements:
244      *
245      * - `from` cannot be the zero address.
246      * - `to` cannot be the zero address.
247      * - `tokenId` token must exist and be owned by `from`.
248      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
249      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
250      *
251      * Emits a {Transfer} event.
252      */
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId,
257         bytes calldata data
258     ) external;
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
262      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must exist and be owned by `from`.
269      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
271      *
272      * Emits a {Transfer} event.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Transfers `tokenId` token from `from` to `to`.
282      *
283      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
284      *
285      * Requirements:
286      *
287      * - `from` cannot be the zero address.
288      * - `to` cannot be the zero address.
289      * - `tokenId` token must be owned by `from`.
290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     /**
301      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
302      * The approval is cleared when the token is transferred.
303      *
304      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
305      *
306      * Requirements:
307      *
308      * - The caller must own the token or be an approved operator.
309      * - `tokenId` must exist.
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address to, uint256 tokenId) external;
314 
315     /**
316      * @dev Approve or remove `operator` as an operator for the caller.
317      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
318      *
319      * Requirements:
320      *
321      * - The `operator` cannot be the caller.
322      *
323      * Emits an {ApprovalForAll} event.
324      */
325     function setApprovalForAll(address operator, bool _approved) external;
326 
327     /**
328      * @dev Returns the account approved for `tokenId` token.
329      *
330      * Requirements:
331      *
332      * - `tokenId` must exist.
333      */
334     function getApproved(uint256 tokenId) external view returns (address operator);
335 
336     /**
337      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
338      *
339      * See {setApprovalForAll}
340      */
341     function isApprovedForAll(address owner, address operator) external view returns (bool);
342 
343     // ==============================
344     //        IERC721Metadata
345     // ==============================
346 
347     /**
348      * @dev Returns the token collection name.
349      */
350     function name() external view returns (string memory);
351 
352     /**
353      * @dev Returns the token collection symbol.
354      */
355     function symbol() external view returns (string memory);
356 
357     /**
358      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
359      */
360     function tokenURI(uint256 tokenId) external view returns (string memory);
361 }
362 // File: contracts/ERC721A.sol
363 
364 
365 // ERC721A Contracts v4.0.0
366 // Creator: Chiru Labs
367 
368 pragma solidity ^0.8.4;
369 
370 
371 /**
372  * @dev ERC721 token receiver interface.
373  */
374 interface ERC721A__IERC721Receiver {
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 /**
384  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
385  * the Metadata extension. Built to optimize for lower gas during batch mints.
386  *
387  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
388  *
389  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
390  *
391  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
392  */
393 contract ERC721A is IERC721A {
394     // Mask of an entry in packed address data.
395     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
396 
397     // The bit position of `numberMinted` in packed address data.
398     uint256 private constant BITPOS_NUMBER_MINTED = 64;
399 
400     // The bit position of `numberBurned` in packed address data.
401     uint256 private constant BITPOS_NUMBER_BURNED = 128;
402 
403     // The bit position of `aux` in packed address data.
404     uint256 private constant BITPOS_AUX = 192;
405 
406     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
407     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
408 
409     // The bit position of `startTimestamp` in packed ownership.
410     uint256 private constant BITPOS_START_TIMESTAMP = 160;
411 
412     // The bit mask of the `burned` bit in packed ownership.
413     uint256 private constant BITMASK_BURNED = 1 << 224;
414 
415     // The bit position of the `nextInitialized` bit in packed ownership.
416     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
417 
418     // The bit mask of the `nextInitialized` bit in packed ownership.
419     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
420 
421     // The tokenId of the next token to be minted.
422     uint256 private _currentIndex;
423 
424     // The number of tokens burned.
425     uint256 private _burnCounter;
426 
427     // Token name
428     string private _name;
429 
430     // Token symbol
431     string private _symbol;
432 
433     // Mapping from token ID to ownership details
434     // An empty struct value does not necessarily mean the token is unowned.
435     // See `_packedOwnershipOf` implementation for details.
436     //
437     // Bits Layout:
438     // - [0..159]   `addr`
439     // - [160..223] `startTimestamp`
440     // - [224]      `burned`
441     // - [225]      `nextInitialized`
442     mapping(uint256 => uint256) private _packedOwnerships;
443 
444     // Mapping owner address to address data.
445     //
446     // Bits Layout:
447     // - [0..63]    `balance`
448     // - [64..127]  `numberMinted`
449     // - [128..191] `numberBurned`
450     // - [192..255] `aux`
451     mapping(address => uint256) private _packedAddressData;
452 
453     // Mapping from token ID to approved address.
454     mapping(uint256 => address) private _tokenApprovals;
455 
456     // Mapping from owner to operator approvals
457     mapping(address => mapping(address => bool)) private _operatorApprovals;
458 
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462         _currentIndex = _startTokenId();
463     }
464 
465     /**
466      * @dev Returns the starting token ID.
467      * To change the starting token ID, please override this function.
468      */
469     function _startTokenId() internal view virtual returns (uint256) {
470         return 0;
471     }
472 
473     /**
474      * @dev Returns the next token ID to be minted.
475      */
476     function _nextTokenId() internal view returns (uint256) {
477         return _currentIndex;
478     }
479 
480     /**
481      * @dev Returns the total number of tokens in existence.
482      * Burned tokens will reduce the count.
483      * To get the total number of tokens minted, please see `_totalMinted`.
484      */
485     function totalSupply() public view override returns (uint256) {
486         // Counter underflow is impossible as _burnCounter cannot be incremented
487         // more than `_currentIndex - _startTokenId()` times.
488         unchecked {
489             return _currentIndex - _burnCounter - _startTokenId();
490         }
491     }
492 
493     /**
494      * @dev Returns the total amount of tokens minted in the contract.
495      */
496     function _totalMinted() internal view returns (uint256) {
497         // Counter underflow is impossible as _currentIndex does not decrement,
498         // and it is initialized to `_startTokenId()`
499         unchecked {
500             return _currentIndex - _startTokenId();
501         }
502     }
503 
504     /**
505      * @dev Returns the total number of tokens burned.
506      */
507     function _totalBurned() internal view returns (uint256) {
508         return _burnCounter;
509     }
510 
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         // The interface IDs are constants representing the first 4 bytes of the XOR of
516         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
517         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
518         return
519             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
520             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
521             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
522     }
523 
524     /**
525      * @dev See {IERC721-balanceOf}.
526      */
527     function balanceOf(address owner) public view override returns (uint256) {
528         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
529         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
530     }
531 
532     /**
533      * Returns the number of tokens minted by `owner`.
534      */
535     function _numberMinted(address owner) internal view returns (uint256) {
536         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens burned by or on behalf of `owner`.
541      */
542     function _numberBurned(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
548      */
549     function _getAux(address owner) internal view returns (uint64) {
550         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
551     }
552 
553     /**
554      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
555      * If there are multiple variables, please pack them into a uint64.
556      */
557     function _setAux(address owner, uint64 aux) internal {
558         uint256 packed = _packedAddressData[owner];
559         uint256 auxCasted;
560         assembly { // Cast aux without masking.
561             auxCasted := aux
562         }
563         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
564         _packedAddressData[owner] = packed;
565     }
566 
567     /**
568      * Returns the packed ownership data of `tokenId`.
569      */
570     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
571         uint256 curr = tokenId;
572 
573         unchecked {
574             if (_startTokenId() <= curr)
575                 if (curr < _currentIndex) {
576                     uint256 packed = _packedOwnerships[curr];
577                     // If not burned.
578                     if (packed & BITMASK_BURNED == 0) {
579                         // Invariant:
580                         // There will always be an ownership that has an address and is not burned
581                         // before an ownership that does not have an address and is not burned.
582                         // Hence, curr will not underflow.
583                         //
584                         // We can directly compare the packed value.
585                         // If the address is zero, packed is zero.
586                         while (packed == 0) {
587                             packed = _packedOwnerships[--curr];
588                         }
589                         return packed;
590                     }
591                 }
592         }
593         revert OwnerQueryForNonexistentToken();
594     }
595 
596     /**
597      * Returns the unpacked `TokenOwnership` struct from `packed`.
598      */
599     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
600         ownership.addr = address(uint160(packed));
601         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
602         ownership.burned = packed & BITMASK_BURNED != 0;
603     }
604 
605     /**
606      * Returns the unpacked `TokenOwnership` struct at `index`.
607      */
608     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnerships[index]);
610     }
611 
612     /**
613      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
614      */
615     function _initializeOwnershipAt(uint256 index) internal {
616         if (_packedOwnerships[index] == 0) {
617             _packedOwnerships[index] = _packedOwnershipOf(index);
618         }
619     }
620 
621     /**
622      * Gas spent here starts off proportional to the maximum mint batch size.
623      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
624      */
625     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnershipOf(tokenId));
627     }
628 
629     /**
630      * @dev See {IERC721-ownerOf}.
631      */
632     function ownerOf(uint256 tokenId) public view override returns (address) {
633         return address(uint160(_packedOwnershipOf(tokenId)));
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-name}.
638      */
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-symbol}.
645      */
646     function symbol() public view virtual override returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-tokenURI}.
652      */
653     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
654         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
655 
656         string memory baseURI = _baseURI();
657         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
658     }
659 
660     /**
661      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
662      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
663      * by default, can be overriden in child contracts.
664      */
665     function _baseURI() internal view virtual returns (string memory) {
666         return '';
667     }
668 
669     /**
670      * @dev Casts the address to uint256 without masking.
671      */
672     function _addressToUint256(address value) private pure returns (uint256 result) {
673         assembly {
674             result := value
675         }
676     }
677 
678     /**
679      * @dev Casts the boolean to uint256 without branching.
680      */
681     function _boolToUint256(bool value) private pure returns (uint256 result) {
682         assembly {
683             result := value
684         }
685     }
686 
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public override {
691         address owner = address(uint160(_packedOwnershipOf(tokenId)));
692         if (to == owner) revert ApprovalToCurrentOwner();
693 
694         if (_msgSenderERC721A() != owner)
695             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
696                 revert ApprovalCallerNotOwnerNorApproved();
697             }
698 
699         _tokenApprovals[tokenId] = to;
700         emit Approval(owner, to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view override returns (address) {
707         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
717 
718         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
719         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, '');
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         _transfer(from, to, tokenId);
761         if (to.code.length != 0)
762             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
763                 revert TransferToNonERC721ReceiverImplementer();
764             }
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted (`_mint`),
773      */
774     function _exists(uint256 tokenId) internal view returns (bool) {
775         return
776             _startTokenId() <= tokenId &&
777             tokenId < _currentIndex && // If within bounds,
778             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
779     }
780 
781     /**
782      * @dev Equivalent to `_safeMint(to, quantity, '')`.
783      */
784     function _safeMint(address to, uint256 quantity) internal {
785         _safeMint(to, quantity, '');
786     }
787 
788     /**
789      * @dev Safely mints `quantity` tokens and transfers them to `to`.
790      *
791      * Requirements:
792      *
793      * - If `to` refers to a smart contract, it must implement
794      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
795      * - `quantity` must be greater than 0.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeMint(
800         address to,
801         uint256 quantity,
802         bytes memory _data
803     ) internal {
804         uint256 startTokenId = _currentIndex;
805         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
806         if (quantity == 0) revert MintZeroQuantity();
807 
808         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
809 
810         // Overflows are incredibly unrealistic.
811         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
812         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
813         unchecked {
814             // Updates:
815             // - `balance += quantity`.
816             // - `numberMinted += quantity`.
817             //
818             // We can directly add to the balance and number minted.
819             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
820 
821             // Updates:
822             // - `address` to the owner.
823             // - `startTimestamp` to the timestamp of minting.
824             // - `burned` to `false`.
825             // - `nextInitialized` to `quantity == 1`.
826             _packedOwnerships[startTokenId] =
827                 _addressToUint256(to) |
828                 (block.timestamp << BITPOS_START_TIMESTAMP) |
829                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
830 
831             uint256 updatedIndex = startTokenId;
832             uint256 end = updatedIndex + quantity;
833 
834             if (to.code.length != 0) {
835                 do {
836                     emit Transfer(address(0), to, updatedIndex);
837                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
838                         revert TransferToNonERC721ReceiverImplementer();
839                     }
840                 } while (updatedIndex < end);
841                 // Reentrancy protection
842                 if (_currentIndex != startTokenId) revert();
843             } else {
844                 do {
845                     emit Transfer(address(0), to, updatedIndex++);
846                 } while (updatedIndex < end);
847             }
848             _currentIndex = updatedIndex;
849         }
850         _afterTokenTransfers(address(0), to, startTokenId, quantity);
851     }
852 
853     /**
854      * @dev Mints `quantity` tokens and transfers them to `to`.
855      *
856      * Requirements:
857      *
858      * - `to` cannot be the zero address.
859      * - `quantity` must be greater than 0.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _mint(address to, uint256 quantity) internal {
864         uint256 startTokenId = _currentIndex;
865         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
866         if (quantity == 0) revert MintZeroQuantity();
867 
868         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
869 
870         // Overflows are incredibly unrealistic.
871         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
872         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
873         unchecked {
874             // Updates:
875             // - `balance += quantity`.
876             // - `numberMinted += quantity`.
877             //
878             // We can directly add to the balance and number minted.
879             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
880 
881             // Updates:
882             // - `address` to the owner.
883             // - `startTimestamp` to the timestamp of minting.
884             // - `burned` to `false`.
885             // - `nextInitialized` to `quantity == 1`.
886             _packedOwnerships[startTokenId] =
887                 _addressToUint256(to) |
888                 (block.timestamp << BITPOS_START_TIMESTAMP) |
889                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
890 
891             uint256 updatedIndex = startTokenId;
892             uint256 end = updatedIndex + quantity;
893 
894             do {
895                 emit Transfer(address(0), to, updatedIndex++);
896             } while (updatedIndex < end);
897 
898             _currentIndex = updatedIndex;
899         }
900         _afterTokenTransfers(address(0), to, startTokenId, quantity);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _transfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) private {
918         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
919 
920         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
921 
922         address approvedAddress = _tokenApprovals[tokenId];
923 
924         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
925             isApprovedForAll(from, _msgSenderERC721A()) ||
926             approvedAddress == _msgSenderERC721A());
927 
928         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
929         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
930 
931         _beforeTokenTransfers(from, to, tokenId, 1);
932 
933         // Clear approvals from the previous owner.
934         if (_addressToUint256(approvedAddress) != 0) {
935             delete _tokenApprovals[tokenId];
936         }
937 
938         // Underflow of the sender's balance is impossible because we check for
939         // ownership above and the recipient's balance can't realistically overflow.
940         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
941         unchecked {
942             // We can directly increment and decrement the balances.
943             --_packedAddressData[from]; // Updates: `balance -= 1`.
944             ++_packedAddressData[to]; // Updates: `balance += 1`.
945 
946             // Updates:
947             // - `address` to the next owner.
948             // - `startTimestamp` to the timestamp of transfering.
949             // - `burned` to `false`.
950             // - `nextInitialized` to `true`.
951             _packedOwnerships[tokenId] =
952                 _addressToUint256(to) |
953                 (block.timestamp << BITPOS_START_TIMESTAMP) |
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
970         emit Transfer(from, to, tokenId);
971         _afterTokenTransfers(from, to, tokenId, 1);
972     }
973 
974     /**
975      * @dev Equivalent to `_burn(tokenId, false)`.
976      */
977     function _burn(uint256 tokenId) internal virtual {
978         _burn(tokenId, false);
979     }
980 
981     /**
982      * @dev Destroys `tokenId`.
983      * The approval is cleared when the token is burned.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
992         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
993 
994         address from = address(uint160(prevOwnershipPacked));
995         address approvedAddress = _tokenApprovals[tokenId];
996 
997         if (approvalCheck) {
998             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
999                 isApprovedForAll(from, _msgSenderERC721A()) ||
1000                 approvedAddress == _msgSenderERC721A());
1001 
1002             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1003         }
1004 
1005         _beforeTokenTransfers(from, address(0), tokenId, 1);
1006 
1007         // Clear approvals from the previous owner.
1008         if (_addressToUint256(approvedAddress) != 0) {
1009             delete _tokenApprovals[tokenId];
1010         }
1011 
1012         // Underflow of the sender's balance is impossible because we check for
1013         // ownership above and the recipient's balance can't realistically overflow.
1014         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1015         unchecked {
1016             // Updates:
1017             // - `balance -= 1`.
1018             // - `numberBurned += 1`.
1019             //
1020             // We can directly decrement the balance, and increment the number burned.
1021             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1022             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1023 
1024             // Updates:
1025             // - `address` to the last owner.
1026             // - `startTimestamp` to the timestamp of burning.
1027             // - `burned` to `true`.
1028             // - `nextInitialized` to `true`.
1029             _packedOwnerships[tokenId] =
1030                 _addressToUint256(from) |
1031                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1032                 BITMASK_BURNED |
1033                 BITMASK_NEXT_INITIALIZED;
1034 
1035             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1036             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1037                 uint256 nextTokenId = tokenId + 1;
1038                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1039                 if (_packedOwnerships[nextTokenId] == 0) {
1040                     // If the next slot is within bounds.
1041                     if (nextTokenId != _currentIndex) {
1042                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1043                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1044                     }
1045                 }
1046             }
1047         }
1048 
1049         emit Transfer(from, address(0), tokenId);
1050         _afterTokenTransfers(from, address(0), tokenId, 1);
1051 
1052         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1053         unchecked {
1054             _burnCounter++;
1055         }
1056     }
1057 
1058     /**
1059      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkContractOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1074             bytes4 retval
1075         ) {
1076             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1077         } catch (bytes memory reason) {
1078             if (reason.length == 0) {
1079                 revert TransferToNonERC721ReceiverImplementer();
1080             } else {
1081                 assembly {
1082                     revert(add(32, reason), mload(reason))
1083                 }
1084             }
1085         }
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1090      * And also called before burning one token.
1091      *
1092      * startTokenId - the first token id to be transferred
1093      * quantity - the amount to be transferred
1094      *
1095      * Calling conditions:
1096      *
1097      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1098      * transferred to `to`.
1099      * - When `from` is zero, `tokenId` will be minted for `to`.
1100      * - When `to` is zero, `tokenId` will be burned by `from`.
1101      * - `from` and `to` are never both zero.
1102      */
1103     function _beforeTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 
1110     /**
1111      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1112      * minting.
1113      * And also called after one token has been burned.
1114      *
1115      * startTokenId - the first token id to be transferred
1116      * quantity - the amount to be transferred
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` has been minted for `to`.
1123      * - When `to` is zero, `tokenId` has been burned by `from`.
1124      * - `from` and `to` are never both zero.
1125      */
1126     function _afterTokenTransfers(
1127         address from,
1128         address to,
1129         uint256 startTokenId,
1130         uint256 quantity
1131     ) internal virtual {}
1132 
1133     /**
1134      * @dev Returns the message sender (defaults to `msg.sender`).
1135      *
1136      * If you are writing GSN compatible contracts, you need to override this function.
1137      */
1138     function _msgSenderERC721A() internal view virtual returns (address) {
1139         return msg.sender;
1140     }
1141 
1142     /**
1143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1144      */
1145     function _toString(uint256 value) internal pure returns (string memory ptr) {
1146         assembly {
1147             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1148             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1149             // We will need 1 32-byte word to store the length,
1150             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1151             ptr := add(mload(0x40), 128)
1152             // Update the free memory pointer to allocate.
1153             mstore(0x40, ptr)
1154 
1155             // Cache the end of the memory to calculate the length later.
1156             let end := ptr
1157 
1158             // We write the string from the rightmost digit to the leftmost digit.
1159             // The following is essentially a do-while loop that also handles the zero case.
1160             // Costs a bit more than early returning for the zero case,
1161             // but cheaper in terms of deployment and overall runtime costs.
1162             for {
1163                 // Initialize and perform the first pass without check.
1164                 let temp := value
1165                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1166                 ptr := sub(ptr, 1)
1167                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1168                 mstore8(ptr, add(48, mod(temp, 10)))
1169                 temp := div(temp, 10)
1170             } temp {
1171                 // Keep dividing `temp` until zero.
1172                 temp := div(temp, 10)
1173             } { // Body of the for loop.
1174                 ptr := sub(ptr, 1)
1175                 mstore8(ptr, add(48, mod(temp, 10)))
1176             }
1177 
1178             let length := sub(end, ptr)
1179             // Move the pointer 32 bytes leftwards to make room for the length.
1180             ptr := sub(ptr, 32)
1181             // Store the length.
1182             mstore(ptr, length)
1183         }
1184     }
1185 }
1186 // File: @openzeppelin/contracts/utils/Strings.sol
1187 
1188 
1189 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @dev String operations.
1195  */
1196 library Strings {
1197     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1198 
1199     /**
1200      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1201      */
1202     function toString(uint256 value) internal pure returns (string memory) {
1203         // Inspired by OraclizeAPI's implementation - MIT licence
1204         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1205 
1206         if (value == 0) {
1207             return "0";
1208         }
1209         uint256 temp = value;
1210         uint256 digits;
1211         while (temp != 0) {
1212             digits++;
1213             temp /= 10;
1214         }
1215         bytes memory buffer = new bytes(digits);
1216         while (value != 0) {
1217             digits -= 1;
1218             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1219             value /= 10;
1220         }
1221         return string(buffer);
1222     }
1223 
1224     /**
1225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1226      */
1227     function toHexString(uint256 value) internal pure returns (string memory) {
1228         if (value == 0) {
1229             return "0x00";
1230         }
1231         uint256 temp = value;
1232         uint256 length = 0;
1233         while (temp != 0) {
1234             length++;
1235             temp >>= 8;
1236         }
1237         return toHexString(value, length);
1238     }
1239 
1240     /**
1241      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1242      */
1243     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1244         bytes memory buffer = new bytes(2 * length + 2);
1245         buffer[0] = "0";
1246         buffer[1] = "x";
1247         for (uint256 i = 2 * length + 1; i > 1; --i) {
1248             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1249             value >>= 4;
1250         }
1251         require(value == 0, "Strings: hex length insufficient");
1252         return string(buffer);
1253     }
1254 }
1255 
1256 // File: @openzeppelin/contracts/utils/Context.sol
1257 
1258 
1259 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 /**
1264  * @dev Provides information about the current execution context, including the
1265  * sender of the transaction and its data. While these are generally available
1266  * via msg.sender and msg.data, they should not be accessed in such a direct
1267  * manner, since when dealing with meta-transactions the account sending and
1268  * paying for execution may not be the actual sender (as far as an application
1269  * is concerned).
1270  *
1271  * This contract is only required for intermediate, library-like contracts.
1272  */
1273 abstract contract Context {
1274     function _msgSender() internal view virtual returns (address) {
1275         return msg.sender;
1276     }
1277 
1278     function _msgData() internal view virtual returns (bytes calldata) {
1279         return msg.data;
1280     }
1281 }
1282 
1283 // File: @openzeppelin/contracts/access/Ownable.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 /**
1292  * @dev Contract module which provides a basic access control mechanism, where
1293  * there is an account (an owner) that can be granted exclusive access to
1294  * specific functions.
1295  *
1296  * By default, the owner account will be the one that deploys the contract. This
1297  * can later be changed with {transferOwnership}.
1298  *
1299  * This module is used through inheritance. It will make available the modifier
1300  * `onlyOwner`, which can be applied to your functions to restrict their use to
1301  * the owner.
1302  */
1303 abstract contract Ownable is Context {
1304     address private _owner;
1305 
1306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1307 
1308     /**
1309      * @dev Initializes the contract setting the deployer as the initial owner.
1310      */
1311     constructor() {
1312         _transferOwnership(_msgSender());
1313     }
1314 
1315     /**
1316      * @dev Returns the address of the current owner.
1317      */
1318     function owner() public view virtual returns (address) {
1319         return _owner;
1320     }
1321 
1322     /**
1323      * @dev Throws if called by any account other than the owner.
1324      */
1325     modifier onlyOwner() {
1326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Leaves the contract without owner. It will not be possible to call
1332      * `onlyOwner` functions anymore. Can only be called by the current owner.
1333      *
1334      * NOTE: Renouncing ownership will leave the contract without an owner,
1335      * thereby removing any functionality that is only available to the owner.
1336      */
1337     function renounceOwnership() public virtual onlyOwner {
1338         _transferOwnership(address(0));
1339     }
1340 
1341     /**
1342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1343      * Can only be called by the current owner.
1344      */
1345     function transferOwnership(address newOwner) public virtual onlyOwner {
1346         require(newOwner != address(0), "Ownable: new owner is the zero address");
1347         _transferOwnership(newOwner);
1348     }
1349 
1350     /**
1351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1352      * Internal function without access restriction.
1353      */
1354     function _transferOwnership(address newOwner) internal virtual {
1355         address oldOwner = _owner;
1356         _owner = newOwner;
1357         emit OwnershipTransferred(oldOwner, newOwner);
1358     }
1359 }
1360 
1361 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1362 
1363 
1364 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 /**
1369  * @dev These functions deal with verification of Merkle Trees proofs.
1370  *
1371  * The proofs can be generated using the JavaScript library
1372  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1373  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1374  *
1375  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1376  *
1377  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1378  * hashing, or use a hash function other than keccak256 for hashing leaves.
1379  * This is because the concatenation of a sorted pair of internal nodes in
1380  * the merkle tree could be reinterpreted as a leaf value.
1381  */
1382 library MerkleProof {
1383     /**
1384      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1385      * defined by `root`. For this, a `proof` must be provided, containing
1386      * sibling hashes on the branch from the leaf to the root of the tree. Each
1387      * pair of leaves and each pair of pre-images are assumed to be sorted.
1388      */
1389     function verify(
1390         bytes32[] memory proof,
1391         bytes32 root,
1392         bytes32 leaf
1393     ) internal pure returns (bool) {
1394         return processProof(proof, leaf) == root;
1395     }
1396 
1397     /**
1398      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1399      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1400      * hash matches the root of the tree. When processing the proof, the pairs
1401      * of leafs & pre-images are assumed to be sorted.
1402      *
1403      * _Available since v4.4._
1404      */
1405     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1406         bytes32 computedHash = leaf;
1407         for (uint256 i = 0; i < proof.length; i++) {
1408             bytes32 proofElement = proof[i];
1409             if (computedHash <= proofElement) {
1410                 // Hash(current computed hash + current element of the proof)
1411                 computedHash = _efficientHash(computedHash, proofElement);
1412             } else {
1413                 // Hash(current element of the proof + current computed hash)
1414                 computedHash = _efficientHash(proofElement, computedHash);
1415             }
1416         }
1417         return computedHash;
1418     }
1419 
1420     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1421         assembly {
1422             mstore(0x00, a)
1423             mstore(0x20, b)
1424             value := keccak256(0x00, 0x40)
1425         }
1426     }
1427 }
1428 
1429 // File: contracts/ReMyth.sol
1430 
1431 
1432 pragma solidity ^0.8.13;
1433 
1434 
1435 
1436 
1437 
1438 
1439 contract ReMyth is ERC721A, Ownable, DefaultOperatorFilterer {
1440 
1441     using Strings for uint;
1442 
1443     enum Step {
1444         StandBy,
1445         WhitelistSale,
1446         PublicSale,
1447         SoldOut,
1448         Reveal
1449     }
1450 
1451     Step public step;
1452 
1453     string public baseURI;
1454     string public notRevealedURI;
1455 
1456     uint public MAX_SUPPLY = 3333;
1457     uint public MAX_TEAM = 3333;
1458     uint public MAX_TX = 30;
1459 
1460     bool private isRevealed = false;
1461 
1462     uint public wl_price = 0 ether;
1463     uint public public_price = 0 ether;
1464 
1465     uint public saleStartTime = 1659298400;
1466 
1467     bytes32 public merkleRoot;
1468 
1469     constructor(string memory _baseURI, bytes32 _merkleRoot) ERC721A("Re:Myth", "REMYTH")
1470     {
1471         baseURI = _baseURI;
1472         merkleRoot = _merkleRoot;
1473     }
1474 
1475     modifier isNotContract() {
1476         require(tx.origin == msg.sender, "Reentrancy Guard is watching");
1477         _;
1478     }
1479 
1480     function getStep() public view returns(Step actualStep) {
1481         if(block.timestamp < saleStartTime) {
1482             return Step.StandBy;
1483         }
1484         if(block.timestamp >= saleStartTime
1485         &&block.timestamp < saleStartTime + 30 minutes) {
1486             return Step.WhitelistSale;
1487         }
1488         if(block.timestamp >= saleStartTime + 30 minutes) {
1489             return Step.PublicSale;
1490         }
1491     }
1492 
1493     function teamMint(address _to, uint _quantity) external payable onlyOwner {
1494         require(totalSupply() + _quantity <= MAX_TEAM, "NFT can't be minted anymore");
1495         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1496         _safeMint(_to,  _quantity);
1497     }
1498 
1499     function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable isNotContract {
1500         require(getStep() == Step.WhitelistSale, "Whitelist Mint is not activated");
1501         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
1502         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1503         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1504         require(msg.value >= wl_price * _quantity, "Not enought funds");
1505         _safeMint(_account, _quantity);
1506     }
1507 
1508     function publicSaleMint(address _account, uint _quantity) external payable isNotContract {
1509         require(getStep() == Step.PublicSale, "Public Mint is not activated");
1510         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be mint anymore");
1511         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1512         require(msg.value >= public_price * _quantity, "Not enought funds");
1513         _safeMint(_account, _quantity);
1514     }
1515 
1516     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1517         baseURI = _newBaseURI;
1518     }
1519 
1520     function setSaleStartTime(uint _newSaleStartTime) external onlyOwner {
1521         saleStartTime = _newSaleStartTime;
1522     }
1523 
1524     function setMaxSupply(uint _newMAX_SUPPLY) external onlyOwner {
1525         MAX_SUPPLY = _newMAX_SUPPLY;
1526     }
1527 
1528     function revealCollection() external onlyOwner {
1529         isRevealed = true;
1530     }
1531 
1532     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1533         require(_exists(_tokenId), "URI query for nonexistent token");
1534         if(isRevealed == true) {
1535             return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1536         }
1537         else {
1538             return string(abi.encodePacked(baseURI, notRevealedURI));
1539         }
1540     }
1541 
1542    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1543         merkleRoot = _merkleRoot;
1544     }
1545 
1546     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
1547         return _verify(leaf(_account), _proof);
1548     }
1549 
1550     function leaf(address _account) internal pure returns(bytes32) {
1551         return keccak256(abi.encodePacked(_account));
1552     }
1553 
1554     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
1555         return MerkleProof.verify(_proof, merkleRoot, _leaf);
1556     }
1557 
1558     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1559         super.transferFrom(from, to, tokenId);
1560     }
1561 
1562     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1563         super.safeTransferFrom(from, to, tokenId);
1564     }
1565 
1566     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1567         public
1568         override
1569         onlyAllowedOperator(from)
1570     {
1571         super.safeTransferFrom(from, to, tokenId, data);
1572     }
1573 
1574     function withdraw(uint amount) public onlyOwner {
1575         payable(msg.sender).transfer(amount);
1576     }
1577 }