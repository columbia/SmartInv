1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 interface ERC721A__IERC721Receiver {
5     function onERC721Received(
6         address operator,
7         address from,
8         uint256 tokenId,
9         bytes calldata data
10     ) external returns (bytes4);
11 }
12 
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 abstract contract ERC165 is IERC165 {
26     /**
27      * @dev See {IERC165-supportsInterface}.
28      */
29     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
30         return interfaceId == type(IERC165).interfaceId;
31     }
32 }
33 
34 interface IERC2981 is IERC165 {
35     /**
36      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
37      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
38      */
39     function royaltyInfo(uint256 tokenId, uint256 salePrice)
40         external
41         view
42         returns (address receiver, uint256 royaltyAmount);
43 }
44 
45 abstract contract ERC2981 is IERC2981, ERC165 {
46     struct RoyaltyInfo {
47         address receiver;
48         uint96 royaltyFraction;
49     }
50 
51     RoyaltyInfo private _defaultRoyaltyInfo;
52     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
53 
54     /**
55      * @dev See {IERC165-supportsInterface}.
56      */
57     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
58         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
59     }
60 
61     /**
62      * @inheritdoc IERC2981
63      */
64     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
65         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
66 
67         if (royalty.receiver == address(0)) {
68             royalty = _defaultRoyaltyInfo;
69         }
70 
71         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
72 
73         return (royalty.receiver, royaltyAmount);
74     }
75 
76     /**
77      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
78      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
79      * override.
80      */
81     function _feeDenominator() internal pure virtual returns (uint96) {
82         return 1000;
83     }
84 
85     /**
86      * @dev Sets the royalty information that all ids in this contract will default to.
87      *
88      * Requirements:
89      *
90      * - `receiver` cannot be the zero address.
91      * - `feeNumerator` cannot be greater than the fee denominator.
92      */
93     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
94         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
95         require(receiver != address(0), "ERC2981: invalid receiver");
96 
97         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
98     }
99 
100     /**
101      * @dev Removes default royalty information.
102      */
103     function _deleteDefaultRoyalty() internal virtual {
104         delete _defaultRoyaltyInfo;
105     }
106 
107     /**
108      * @dev Sets the royalty information for a specific token id, overriding the global default.
109      *
110      * Requirements:
111      *
112      * - `receiver` cannot be the zero address.
113      * - `feeNumerator` cannot be greater than the fee denominator.
114      */
115     function _setTokenRoyalty(
116         uint256 tokenId,
117         address receiver,
118         uint96 feeNumerator
119     ) internal virtual {
120         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
121         require(receiver != address(0), "ERC2981: Invalid parameters");
122 
123         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
124     }
125 
126     /**
127      * @dev Resets royalty information for the token id back to the global default.
128      */
129     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
130         delete _tokenRoyaltyInfo[tokenId];
131     }
132 }
133 
134 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
135 /// mandatory on-chain royalty enforcement in order for new collections to
136 /// receive royalties.
137 /// For more information, see:
138 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
139 abstract contract OperatorFilterer {
140     /// @dev The default OpenSea operator blocklist subscription.
141     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
142 
143     /// @dev The OpenSea operator filter registry.
144     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
145 
146     /// @dev Registers the current contract to OpenSea's operator filter,
147     /// and subscribe to the default OpenSea operator blocklist.
148     /// Note: Will not revert nor update existing settings for repeated registration.
149     function _registerForOperatorFiltering() internal virtual {
150         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
151     }
152 
153     /// @dev Registers the current contract to OpenSea's operator filter.
154     /// Note: Will not revert nor update existing settings for repeated registration.
155     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
156         internal
157         virtual
158     {
159         /// @solidity memory-safe-assembly
160         assembly {
161             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
162 
163             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
164             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
165 
166             for {} iszero(subscribe) {} {
167                 if iszero(subscriptionOrRegistrantToCopy) {
168                     functionSelector := 0x4420e486 // `register(address)`.
169                     break
170                 }
171                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
172                 break
173             }
174             // Store the function selector.
175             mstore(0x00, shl(224, functionSelector))
176             // Store the `address(this)`.
177             mstore(0x04, address())
178             // Store the `subscriptionOrRegistrantToCopy`.
179             mstore(0x24, subscriptionOrRegistrantToCopy)
180             // Register into the registry.
181             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
182                 // If the function selector has not been overwritten,
183                 // it is an out-of-gas error.
184                 if eq(shr(224, mload(0x00)), functionSelector) {
185                     // To prevent gas under-estimation.
186                     revert(0, 0)
187                 }
188             }
189             // Restore the part of the free memory pointer that was overwritten,
190             // which is guaranteed to be zero, because of Solidity's memory size limits.
191             mstore(0x24, 0)
192         }
193     }
194 
195     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
196     modifier onlyAllowedOperator(address from) virtual {
197         if (from != msg.sender) {
198             if (!_isPriorityOperator(msg.sender)) {
199                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
200             }
201         }
202         _;
203     }
204 
205     /// @dev Modifier to guard a function from approving a blocked operator..
206     modifier onlyAllowedOperatorApproval(address operator) virtual {
207         if (!_isPriorityOperator(operator)) {
208             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
209         }
210         _;
211     }
212 
213     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
214     function _revertIfBlocked(address operator) private view {
215         /// @solidity memory-safe-assembly
216         assembly {
217             // Store the function selector of `isOperatorAllowed(address,address)`,
218             // shifted left by 6 bytes, which is enough for 8tb of memory.
219             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
220             mstore(0x00, 0xc6171134001122334455)
221             // Store the `address(this)`.
222             mstore(0x1a, address())
223             // Store the `operator`.
224             mstore(0x3a, operator)
225 
226             // `isOperatorAllowed` always returns true if it does not revert.
227             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
228                 // Bubble up the revert if the staticcall reverts.
229                 returndatacopy(0x00, 0x00, returndatasize())
230                 revert(0x00, returndatasize())
231             }
232 
233             // We'll skip checking if `from` is inside the blacklist.
234             // Even though that can block transferring out of wrapper contracts,
235             // we don't want tokens to be stuck.
236 
237             // Restore the part of the free memory pointer that was overwritten,
238             // which is guaranteed to be zero, if less than 8tb of memory is used.
239             mstore(0x3a, 0)
240         }
241     }
242 
243     /// @dev For deriving contracts to override, so that operator filtering
244     /// can be turned on / off.
245     /// Returns true by default.
246     function _operatorFilteringEnabled() internal view virtual returns (bool) {
247         return true;
248     }
249 
250     /// @dev For deriving contracts to override, so that preferred marketplaces can
251     /// skip operator filtering, helping users save gas.
252     /// Returns false for all inputs by default.
253     function _isPriorityOperator(address) internal view virtual returns (bool) {
254         return false;
255     }
256 }
257 
258 interface IERC721A {
259     /**
260      * The caller must own the token or be an approved operator.
261      */
262     error ApprovalCallerNotOwnerNorApproved();
263 
264     /**
265      * The token does not exist.
266      */
267     error ApprovalQueryForNonexistentToken();
268 
269     /**
270      * Cannot query the balance for the zero address.
271      */
272     error BalanceQueryForZeroAddress();
273 
274     /**
275      * Cannot mint to the zero address.
276      */
277     error MintToZeroAddress();
278 
279     /**
280      * The quantity of tokens minted must be more than zero.
281      */
282     error MintZeroQuantity();
283 
284     /**
285      * The token does not exist.
286      */
287     error OwnerQueryForNonexistentToken();
288 
289     /**
290      * The caller must own the token or be an approved operator.
291      */
292     error TransferCallerNotOwnerNorApproved();
293 
294     /**
295      * The token must be owned by `from`.
296      */
297     error TransferFromIncorrectOwner();
298 
299     /**
300      * Cannot safely transfer to a contract that does not implement the
301      * ERC721Receiver interface.
302      */
303     error TransferToNonERC721ReceiverImplementer();
304 
305     /**
306      * Cannot transfer to the zero address.
307      */
308     error TransferToZeroAddress();
309 
310     /**
311      * The token does not exist.
312      */
313     error URIQueryForNonexistentToken();
314 
315     /**
316      * The `quantity` minted with ERC2309 exceeds the safety limit.
317      */
318     error MintERC2309QuantityExceedsLimit();
319 
320     /**
321      * The `extraData` cannot be set on an unintialized ownership slot.
322      */
323     error OwnershipNotInitializedForExtraData();
324 
325     // =============================================================
326     //                            STRUCTS
327     // =============================================================
328 
329     struct TokenOwnership {
330         // The address of the owner.
331         address addr;
332         // Stores the start time of ownership with minimal overhead for tokenomics.
333         uint64 startTimestamp;
334         // Whether the token has been burned.
335         bool burned;
336         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
337         uint24 extraData;
338     }
339 
340     // =============================================================
341     //                         TOKEN COUNTERS
342     // =============================================================
343 
344     /**
345      * @dev Returns the total number of tokens in existence.
346      * Burned tokens will reduce the count.
347      * To get the total number of tokens minted, please see {_totalMinted}.
348      */
349     function totalSupply() external view returns (uint256);
350 
351     // =============================================================
352     //                            IERC165
353     // =============================================================
354 
355     /**
356      * @dev Returns true if this contract implements the interface defined by
357      * `interfaceId`. See the corresponding
358      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
359      * to learn more about how these ids are created.
360      *
361      * This function call must use less than 30000 gas.
362      */
363     function supportsInterface(bytes4 interfaceId) external view returns (bool);
364 
365     // =============================================================
366     //                            IERC721
367     // =============================================================
368 
369     /**
370      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
371      */
372     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
373 
374     /**
375      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
376      */
377     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
378 
379     /**
380      * @dev Emitted when `owner` enables or disables
381      * (`approved`) `operator` to manage all of its assets.
382      */
383     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
384 
385     /**
386      * @dev Returns the number of tokens in `owner`'s account.
387      */
388     function balanceOf(address owner) external view returns (uint256 balance);
389 
390     /**
391      * @dev Returns the owner of the `tokenId` token.
392      *
393      * Requirements:
394      *
395      * - `tokenId` must exist.
396      */
397     function ownerOf(uint256 tokenId) external view returns (address owner);
398 
399     /**
400      * @dev Safely transfers `tokenId` token from `from` to `to`,
401      * checking first that contract recipients are aware of the ERC721 protocol
402      * to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move
410      * this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement
412      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId,
420         bytes calldata data
421     ) external payable;
422 
423     /**
424      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId
430     ) external payable;
431 
432     /**
433      * @dev Transfers `tokenId` from `from` to `to`.
434      *
435      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
436      * whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token
444      * by either {approve} or {setApprovalForAll}.
445      *
446      * Emits a {Transfer} event.
447      */
448     function transferFrom(
449         address from,
450         address to,
451         uint256 tokenId
452     ) external payable;
453 
454     /**
455      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
456      * The approval is cleared when the token is transferred.
457      *
458      * Only a single account can be approved at a time, so approving the
459      * zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external payable;
469 
470     /**
471      * @dev Approve or remove `operator` as an operator for the caller.
472      * Operators can call {transferFrom} or {safeTransferFrom}
473      * for any token owned by the caller.
474      *
475      * Requirements:
476      *
477      * - The `operator` cannot be the caller.
478      *
479      * Emits an {ApprovalForAll} event.
480      */
481     function setApprovalForAll(address operator, bool _approved) external;
482 
483     /**
484      * @dev Returns the account approved for `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function getApproved(uint256 tokenId) external view returns (address operator);
491 
492     /**
493      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
494      *
495      * See {setApprovalForAll}.
496      */
497     function isApprovedForAll(address owner, address operator) external view returns (bool);
498 
499     // =============================================================
500     //                        IERC721Metadata
501     // =============================================================
502 
503     /**
504      * @dev Returns the token collection name.
505      */
506     function name() external view returns (string memory);
507 
508     /**
509      * @dev Returns the token collection symbol.
510      */
511     function symbol() external view returns (string memory);
512 
513     /**
514      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
515      */
516     function tokenURI(uint256 tokenId) external view returns (string memory);
517 
518     // =============================================================
519     //                           IERC2309
520     // =============================================================
521 
522     /**
523      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
524      * (inclusive) is transferred from `from` to `to`, as defined in the
525      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
526      *
527      * See {_mintERC2309} for more details.
528      */
529     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
530 }
531 
532 contract ERC721A is IERC721A, ERC2981 {
533     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
534     struct TokenApprovalRef {
535         address value;
536     }
537 
538     // =============================================================
539     //                           CONSTANTS
540     // =============================================================
541 
542     // Mask of an entry in packed address data.
543     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
544 
545     // The bit position of `numberMinted` in packed address data.
546     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
547 
548     // The bit position of `numberBurned` in packed address data.
549     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
550 
551     // The bit position of `aux` in packed address data.
552     uint256 private constant _BITPOS_AUX = 192;
553 
554     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
555     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
556 
557     // The bit position of `startTimestamp` in packed ownership.
558     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
559 
560     // The bit mask of the `burned` bit in packed ownership.
561     uint256 private constant _BITMASK_BURNED = 1 << 224;
562 
563     // The bit position of the `nextInitialized` bit in packed ownership.
564     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
565 
566     // The bit mask of the `nextInitialized` bit in packed ownership.
567     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
568 
569     // The bit position of `extraData` in packed ownership.
570     uint256 private constant _BITPOS_EXTRA_DATA = 232;
571 
572     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
573     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
574 
575     // The mask of the lower 160 bits for addresses.
576     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
577 
578     // The maximum `quantity` that can be minted with {_mintERC2309}.
579     // This limit is to prevent overflows on the address data entries.
580     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
581     // is required to cause an overflow, which is unrealistic.
582     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
583 
584     // The `Transfer` event signature is given by:
585     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
586     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
587         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
588 
589     // =============================================================
590     //                            STORAGE
591     // =============================================================
592 
593     // The next token ID to be minted.
594     uint256 private _currentIndex;
595 
596     // The number of tokens burned.
597     uint256 private _burnCounter;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to ownership details
606     // An empty struct value does not necessarily mean the token is unowned.
607     // See {_packedOwnershipOf} implementation for details.
608     //
609     // Bits Layout:
610     // - [0..159]   `addr`
611     // - [160..223] `startTimestamp`
612     // - [224]      `burned`
613     // - [225]      `nextInitialized`
614     // - [232..255] `extraData`
615     mapping(uint256 => uint256) private _packedOwnerships;
616 
617     // Mapping owner address to address data.
618     //
619     // Bits Layout:
620     // - [0..63]    `balance`
621     // - [64..127]  `numberMinted`
622     // - [128..191] `numberBurned`
623     // - [192..255] `aux`
624     mapping(address => uint256) private _packedAddressData;
625 
626     // Mapping from token ID to approved address.
627     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
628 
629     // Mapping from owner to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     // =============================================================
633     //                          CONSTRUCTOR
634     // =============================================================
635 
636     function initial(string memory name_, string memory symbol_) internal {
637         _name = name_;
638         _symbol = symbol_;
639         _currentIndex = _startTokenId();
640     }
641 
642     // =============================================================
643     //                   TOKEN COUNTING OPERATIONS
644     // =============================================================
645 
646     /**
647      * @dev Returns the starting token ID.
648      * To change the starting token ID, please override this function.
649      */
650     function _startTokenId() internal view virtual returns (uint256) {
651         return 0;
652     }
653 
654     /**
655      * @dev Returns the next token ID to be minted.
656      */
657     function _nextTokenId() internal view virtual returns (uint256) {
658         return _currentIndex;
659     }
660 
661     /**
662      * @dev Returns the total number of tokens in existence.
663      * Burned tokens will reduce the count.
664      * To get the total number of tokens minted, please see {_totalMinted}.
665      */
666     function totalSupply() public view virtual override returns (uint256) {
667         // Counter underflow is impossible as _burnCounter cannot be incremented
668         // more than `_currentIndex - _startTokenId()` times.
669         unchecked {
670             return _currentIndex - _burnCounter - _startTokenId();
671         }
672     }
673 
674     /**
675      * @dev Returns the total amount of tokens minted in the contract.
676      */
677     function _totalMinted() internal view virtual returns (uint256) {
678         // Counter underflow is impossible as `_currentIndex` does not decrement,
679         // and it is initialized to `_startTokenId()`.
680         unchecked {
681             return _currentIndex - _startTokenId();
682         }
683     }
684 
685     /**
686      * @dev Returns the total number of tokens burned.
687      */
688     function _totalBurned() internal view virtual returns (uint256) {
689         return _burnCounter;
690     }
691 
692     // =============================================================
693     //                    ADDRESS DATA OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Returns the number of tokens in `owner`'s account.
698      */
699     function balanceOf(address owner) public view virtual override returns (uint256) {
700         if (owner == address(0)) revert BalanceQueryForZeroAddress();
701         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
702     }
703 
704     /**
705      * Returns the number of tokens minted by `owner`.
706      */
707     function _numberMinted(address owner) internal view returns (uint256) {
708         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
709     }
710 
711     /**
712      * Returns the number of tokens burned by or on behalf of `owner`.
713      */
714     function _numberBurned(address owner) internal view returns (uint256) {
715         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
716     }
717 
718     /**
719      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
720      */
721     function _getAux(address owner) internal view returns (uint64) {
722         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
723     }
724 
725     /**
726      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
727      * If there are multiple variables, please pack them into a uint64.
728      */
729     function _setAux(address owner, uint64 aux) internal virtual {
730         uint256 packed = _packedAddressData[owner];
731         uint256 auxCasted;
732         // Cast `aux` with assembly to avoid redundant masking.
733         assembly {
734             auxCasted := aux
735         }
736         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
737         _packedAddressData[owner] = packed;
738     }
739 
740     // =============================================================
741     //                            IERC165
742     // =============================================================
743 
744     /**
745      * @dev Returns true if this contract implements the interface defined by
746      * `interfaceId`. See the corresponding
747      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
748      * to learn more about how these ids are created.
749      *
750      * This function call must use less than 30000 gas.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, IERC721A) returns (bool) {
753         // The interface IDs are constants representing the first 4 bytes
754         // of the XOR of all function selectors in the interface.
755         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
756         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
757         return
758             interfaceId == type(IERC721A).interfaceId ||
759             interfaceId == type(ERC2981).interfaceId ||
760             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
761             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
762             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
763     }
764 
765     // =============================================================
766     //                        IERC721Metadata
767     // =============================================================
768 
769     /**
770      * @dev Returns the token collection name.
771      */
772     function name() public view virtual override returns (string memory) {
773         return _name;
774     }
775 
776     /**
777      * @dev Returns the token collection symbol.
778      */
779     function symbol() public view virtual override returns (string memory) {
780         return _symbol;
781     }
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
787         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
788 
789         string memory baseURI = _baseURI();
790         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
791     }
792 
793     /**
794      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
795      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
796      * by default, it can be overridden in child contracts.
797      */
798     function _baseURI() internal view virtual returns (string memory) {
799         return '';
800     }
801 
802     // =============================================================
803     //                     OWNERSHIPS OPERATIONS
804     // =============================================================
805 
806     /**
807      * @dev Returns the owner of the `tokenId` token.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      */
813     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
814         return address(uint160(_packedOwnershipOf(tokenId)));
815     }
816 
817     /**
818      * @dev Gas spent here starts off proportional to the maximum mint batch size.
819      * It gradually moves to O(1) as tokens get transferred around over time.
820      */
821     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
822         return _unpackedOwnership(_packedOwnershipOf(tokenId));
823     }
824 
825     /**
826      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
827      */
828     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
829         return _unpackedOwnership(_packedOwnerships[index]);
830     }
831 
832     /**
833      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
834      */
835     function _initializeOwnershipAt(uint256 index) internal virtual {
836         if (_packedOwnerships[index] == 0) {
837             _packedOwnerships[index] = _packedOwnershipOf(index);
838         }
839     }
840 
841     /**
842      * Returns the packed ownership data of `tokenId`.
843      */
844     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
845         uint256 curr = tokenId;
846 
847         unchecked {
848             if (_startTokenId() <= curr)
849                 if (curr < _currentIndex) {
850                     uint256 packed = _packedOwnerships[curr];
851                     // If not burned.
852                     if (packed & _BITMASK_BURNED == 0) {
853                         // Invariant:
854                         // There will always be an initialized ownership slot
855                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
856                         // before an unintialized ownership slot
857                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
858                         // Hence, `curr` will not underflow.
859                         //
860                         // We can directly compare the packed value.
861                         // If the address is zero, packed will be zero.
862                         while (packed == 0) {
863                             packed = _packedOwnerships[--curr];
864                         }
865                         return packed;
866                     }
867                 }
868         }
869         revert OwnerQueryForNonexistentToken();
870     }
871 
872     /**
873      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
874      */
875     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
876         ownership.addr = address(uint160(packed));
877         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
878         ownership.burned = packed & _BITMASK_BURNED != 0;
879         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
880     }
881 
882     /**
883      * @dev Packs ownership data into a single uint256.
884      */
885     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
886         assembly {
887             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
888             owner := and(owner, _BITMASK_ADDRESS)
889             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
890             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
891         }
892     }
893 
894     /**
895      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
896      */
897     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
898         // For branchless setting of the `nextInitialized` flag.
899         assembly {
900             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
901             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
902         }
903     }
904 
905     // =============================================================
906     //                      APPROVAL OPERATIONS
907     // =============================================================
908 
909     /**
910      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
911      * The approval is cleared when the token is transferred.
912      *
913      * Only a single account can be approved at a time, so approving the
914      * zero address clears previous approvals.
915      *
916      * Requirements:
917      *
918      * - The caller must own the token or be an approved operator.
919      * - `tokenId` must exist.
920      *
921      * Emits an {Approval} event.
922      */
923     function approve(address to, uint256 tokenId) public payable virtual override {
924         address owner = ownerOf(tokenId);
925 
926         if (_msgSenderERC721A() != owner)
927             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
928                 revert ApprovalCallerNotOwnerNorApproved();
929             }
930 
931         _tokenApprovals[tokenId].value = to;
932         emit Approval(owner, to, tokenId);
933     }
934 
935     /**
936      * @dev Returns the account approved for `tokenId` token.
937      *
938      * Requirements:
939      *
940      * - `tokenId` must exist.
941      */
942     function getApproved(uint256 tokenId) public view virtual override returns (address) {
943         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
944 
945         return _tokenApprovals[tokenId].value;
946     }
947 
948     /**
949      * @dev Approve or remove `operator` as an operator for the caller.
950      * Operators can call {transferFrom} or {safeTransferFrom}
951      * for any token owned by the caller.
952      *
953      * Requirements:
954      *
955      * - The `operator` cannot be the caller.
956      *
957      * Emits an {ApprovalForAll} event.
958      */
959     function setApprovalForAll(address operator, bool approved) public virtual override {
960         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
961         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
962     }
963 
964     /**
965      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
966      *
967      * See {setApprovalForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
970         return _operatorApprovals[owner][operator];
971     }
972 
973     /**
974      * @dev Returns whether `tokenId` exists.
975      *
976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977      *
978      * Tokens start existing when they are minted. See {_mint}.
979      */
980     function _exists(uint256 tokenId) internal view virtual returns (bool) {
981         return
982             _startTokenId() <= tokenId &&
983             tokenId < _currentIndex && // If within bounds,
984             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
985     }
986 
987     /**
988      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
989      */
990     function _isSenderApprovedOrOwner(
991         address approvedAddress,
992         address owner,
993         address msgSender
994     ) private pure returns (bool result) {
995         assembly {
996             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
997             owner := and(owner, _BITMASK_ADDRESS)
998             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
999             msgSender := and(msgSender, _BITMASK_ADDRESS)
1000             // `msgSender == owner || msgSender == approvedAddress`.
1001             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1002         }
1003     }
1004 
1005     /**
1006      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1007      */
1008     function _getApprovedSlotAndAddress(uint256 tokenId)
1009         private
1010         view
1011         returns (uint256 approvedAddressSlot, address approvedAddress)
1012     {
1013         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1014         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1015         assembly {
1016             approvedAddressSlot := tokenApproval.slot
1017             approvedAddress := sload(approvedAddressSlot)
1018         }
1019     }
1020 
1021     // =============================================================
1022     //                      TRANSFER OPERATIONS
1023     // =============================================================
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      * - If the caller is not `from`, it must be approved to move this token
1034      * by either {approve} or {setApprovalForAll}.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) public payable virtual override {
1043         _beforeTransfer();
1044         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1045 
1046         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1047 
1048         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1049 
1050         // The nested ifs save around 20+ gas over a compound boolean condition.
1051         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1052             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1053 
1054         if (to == address(0)) revert TransferToZeroAddress();
1055 
1056         _beforeTokenTransfers(from, to, tokenId, 1);
1057 
1058         // Clear approvals from the previous owner.
1059         assembly {
1060             if approvedAddress {
1061                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1062                 sstore(approvedAddressSlot, 0)
1063             }
1064         }
1065 
1066         // Underflow of the sender's balance is impossible because we check for
1067         // ownership above and the recipient's balance can't realistically overflow.
1068         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1069         unchecked {
1070             // We can directly increment and decrement the balances.
1071             --_packedAddressData[from]; // Updates: `balance -= 1`.
1072             ++_packedAddressData[to]; // Updates: `balance += 1`.
1073 
1074             // Updates:
1075             // - `address` to the next owner.
1076             // - `startTimestamp` to the timestamp of transfering.
1077             // - `burned` to `false`.
1078             // - `nextInitialized` to `true`.
1079             _packedOwnerships[tokenId] = _packOwnershipData(
1080                 to,
1081                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1082             );
1083 
1084             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1085             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1086                 uint256 nextTokenId = tokenId + 1;
1087                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1088                 if (_packedOwnerships[nextTokenId] == 0) {
1089                     // If the next slot is within bounds.
1090                     if (nextTokenId != _currentIndex) {
1091                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1092                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1093                     }
1094                 }
1095             }
1096         }
1097 
1098         emit Transfer(from, to, tokenId);
1099         _afterTokenTransfers(from, to, tokenId, 1);
1100     }
1101 
1102     /**
1103      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public payable virtual override {
1110         safeTransferFrom(from, to, tokenId, '');
1111     }
1112 
1113     /**
1114      * @dev Safely transfers `tokenId` token from `from` to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `from` cannot be the zero address.
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must exist and be owned by `from`.
1121      * - If the caller is not `from`, it must be approved to move this token
1122      * by either {approve} or {setApprovalForAll}.
1123      * - If `to` refers to a smart contract, it must implement
1124      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) public payable virtual override {
1134         transferFrom(from, to, tokenId);
1135         if (to.code.length != 0)
1136             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1137                 revert TransferToNonERC721ReceiverImplementer();
1138             }
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before a set of serially-ordered token IDs
1143      * are about to be transferred. This includes minting.
1144      * And also called before burning one token.
1145      *
1146      * `startTokenId` - the first token ID to be transferred.
1147      * `quantity` - the amount to be transferred.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, `tokenId` will be burned by `from`.
1155      * - `from` and `to` are never both zero.
1156      */
1157     function _beforeTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 
1164     function _beforeTransfer() internal {
1165     }
1166     /**
1167      * @dev Hook that is called after a set of serially-ordered token IDs
1168      * have been transferred. This includes minting.
1169      * And also called after one token has been burned.
1170      *
1171      * `startTokenId` - the first token ID to be transferred.
1172      * `quantity` - the amount to be transferred.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` has been minted for `to`.
1179      * - When `to` is zero, `tokenId` has been burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _afterTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1191      *
1192      * `from` - Previous owner of the given token ID.
1193      * `to` - Target address that will receive the token.
1194      * `tokenId` - Token ID to be transferred.
1195      * `_data` - Optional data to send along with the call.
1196      *
1197      * Returns whether the call correctly returned the expected magic value.
1198      */
1199     function _checkContractOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1206             bytes4 retval
1207         ) {
1208             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1209         } catch (bytes memory reason) {
1210             if (reason.length == 0) {
1211                 revert TransferToNonERC721ReceiverImplementer();
1212             } else {
1213                 assembly {
1214                     revert(add(32, reason), mload(reason))
1215                 }
1216             }
1217         }
1218     }
1219 
1220     // =============================================================
1221     //                        MINT OPERATIONS
1222     // =============================================================
1223 
1224     /**
1225      * @dev Mints `quantity` tokens and transfers them to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `quantity` must be greater than 0.
1231      *
1232      * Emits a {Transfer} event for each mint.
1233      */
1234     function _mint(address to, uint256 quantity) internal virtual {
1235         uint256 startTokenId = _currentIndex;
1236         if (quantity == 0) revert MintZeroQuantity();
1237 
1238         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1239 
1240         // Overflows are incredibly unrealistic.
1241         // `balance` and `numberMinted` have a maximum limit of 2**64.
1242         // `tokenId` has a maximum limit of 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance += quantity`.
1246             // - `numberMinted += quantity`.
1247             //
1248             // We can directly add to the `balance` and `numberMinted`.
1249             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1250 
1251             // Updates:
1252             // - `address` to the owner.
1253             // - `startTimestamp` to the timestamp of minting.
1254             // - `burned` to `false`.
1255             // - `nextInitialized` to `quantity == 1`.
1256             _packedOwnerships[startTokenId] = _packOwnershipData(
1257                 to,
1258                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1259             );
1260 
1261             uint256 toMasked;
1262             uint256 end = startTokenId + quantity;
1263 
1264             // Use assembly to loop and emit the `Transfer` event for gas savings.
1265             // The duplicated `log4` removes an extra check and reduces stack juggling.
1266             // The assembly, together with the surrounding Solidity code, have been
1267             // delicately arranged to nudge the compiler into producing optimized opcodes.
1268             assembly {
1269                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1270                 toMasked := and(to, _BITMASK_ADDRESS)
1271                 // Emit the `Transfer` event.
1272                 log4(
1273                     0, // Start of data (0, since no data).
1274                     0, // End of data (0, since no data).
1275                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1276                     0, // `address(0)`.
1277                     toMasked, // `to`.
1278                     startTokenId // `tokenId`.
1279                 )
1280 
1281                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1282                 // that overflows uint256 will make the loop run out of gas.
1283                 // The compiler will optimize the `iszero` away for performance.
1284                 for {
1285                     let tokenId := add(startTokenId, 1)
1286                 } iszero(eq(tokenId, end)) {
1287                     tokenId := add(tokenId, 1)
1288                 } {
1289                     // Emit the `Transfer` event. Similar to above.
1290                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1291                 }
1292             }
1293             if (toMasked == 0) revert MintToZeroAddress();
1294 
1295             _currentIndex = end;
1296         }
1297         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1298     }
1299 
1300     /**
1301      * @dev Mints `quantity` tokens and transfers them to `to`.
1302      *
1303      * This function is intended for efficient minting only during contract creation.
1304      *
1305      * It emits only one {ConsecutiveTransfer} as defined in
1306      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1307      * instead of a sequence of {Transfer} event(s).
1308      *
1309      * Calling this function outside of contract creation WILL make your contract
1310      * non-compliant with the ERC721 standard.
1311      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1312      * {ConsecutiveTransfer} event is only permissible during contract creation.
1313      *
1314      * Requirements:
1315      *
1316      * - `to` cannot be the zero address.
1317      * - `quantity` must be greater than 0.
1318      *
1319      * Emits a {ConsecutiveTransfer} event.
1320      */
1321     function _mintERC2309(address to, uint256 quantity) internal virtual {
1322         uint256 startTokenId = _currentIndex;
1323         if (to == address(0)) revert MintToZeroAddress();
1324         if (quantity == 0) revert MintZeroQuantity();
1325         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1326 
1327         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1328 
1329         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1330         unchecked {
1331             // Updates:
1332             // - `balance += quantity`.
1333             // - `numberMinted += quantity`.
1334             //
1335             // We can directly add to the `balance` and `numberMinted`.
1336             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1337 
1338             // Updates:
1339             // - `address` to the owner.
1340             // - `startTimestamp` to the timestamp of minting.
1341             // - `burned` to `false`.
1342             // - `nextInitialized` to `quantity == 1`.
1343             _packedOwnerships[startTokenId] = _packOwnershipData(
1344                 to,
1345                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1346             );
1347 
1348             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1349 
1350             _currentIndex = startTokenId + quantity;
1351         }
1352         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1353     }
1354 
1355     /**
1356      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - If `to` refers to a smart contract, it must implement
1361      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1362      * - `quantity` must be greater than 0.
1363      *
1364      * See {_mint}.
1365      *
1366      * Emits a {Transfer} event for each mint.
1367      */
1368     function _safeMint(
1369         address to,
1370         uint256 quantity,
1371         bytes memory _data
1372     ) internal virtual {
1373         _mint(to, quantity);
1374 
1375         unchecked {
1376             if (to.code.length != 0) {
1377                 uint256 end = _currentIndex;
1378                 uint256 index = end - quantity;
1379                 do {
1380                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1381                         revert TransferToNonERC721ReceiverImplementer();
1382                     }
1383                 } while (index < end);
1384                 // Reentrancy protection.
1385                 if (_currentIndex != end) revert();
1386             }
1387         }
1388     }
1389 
1390     /**
1391      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1392      */
1393     function _safeMint(address to, uint256 quantity) internal virtual {
1394         _safeMint(to, quantity, '');
1395     }
1396 
1397     // =============================================================
1398     //                        BURN OPERATIONS
1399     // =============================================================
1400 
1401     /**
1402      * @dev Equivalent to `_burn(tokenId, false)`.
1403      */
1404     function _burn(uint256 tokenId) internal virtual {
1405         _burn(tokenId, false);
1406     }
1407 
1408     /**
1409      * @dev Destroys `tokenId`.
1410      * The approval is cleared when the token is burned.
1411      *
1412      * Requirements:
1413      *
1414      * - `tokenId` must exist.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1419         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1420 
1421         address from = address(uint160(prevOwnershipPacked));
1422 
1423         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1424 
1425         if (approvalCheck) {
1426             // The nested ifs save around 20+ gas over a compound boolean condition.
1427             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1428                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1429         }
1430 
1431         _beforeTokenTransfers(from, address(0), tokenId, 1);
1432 
1433         // Clear approvals from the previous owner.
1434         assembly {
1435             if approvedAddress {
1436                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1437                 sstore(approvedAddressSlot, 0)
1438             }
1439         }
1440 
1441         // Underflow of the sender's balance is impossible because we check for
1442         // ownership above and the recipient's balance can't realistically overflow.
1443         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1444         unchecked {
1445             // Updates:
1446             // - `balance -= 1`.
1447             // - `numberBurned += 1`.
1448             //
1449             // We can directly decrement the balance, and increment the number burned.
1450             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1451             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1452 
1453             // Updates:
1454             // - `address` to the last owner.
1455             // - `startTimestamp` to the timestamp of burning.
1456             // - `burned` to `true`.
1457             // - `nextInitialized` to `true`.
1458             _packedOwnerships[tokenId] = _packOwnershipData(
1459                 from,
1460                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1461             );
1462 
1463             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1464             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1465                 uint256 nextTokenId = tokenId + 1;
1466                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1467                 if (_packedOwnerships[nextTokenId] == 0) {
1468                     // If the next slot is within bounds.
1469                     if (nextTokenId != _currentIndex) {
1470                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1471                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1472                     }
1473                 }
1474             }
1475         }
1476 
1477         emit Transfer(from, address(0), tokenId);
1478         _afterTokenTransfers(from, address(0), tokenId, 1);
1479 
1480         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1481         unchecked {
1482             _burnCounter++;
1483         }
1484     }
1485 
1486     // =============================================================
1487     //                     EXTRA DATA OPERATIONS
1488     // =============================================================
1489 
1490     /**
1491      * @dev Directly sets the extra data for the ownership data `index`.
1492      */
1493     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1494         uint256 packed = _packedOwnerships[index];
1495         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1496         uint256 extraDataCasted;
1497         // Cast `extraData` with assembly to avoid redundant masking.
1498         assembly {
1499             extraDataCasted := extraData
1500         }
1501         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1502         _packedOwnerships[index] = packed;
1503     }
1504 
1505     /**
1506      * @dev Called during each token transfer to set the 24bit `extraData` field.
1507      * Intended to be overridden by the cosumer contract.
1508      *
1509      * `previousExtraData` - the value of `extraData` before transfer.
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      * - When `to` is zero, `tokenId` will be burned by `from`.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _extraData(
1520         address from,
1521         address to,
1522         uint24 previousExtraData
1523     ) internal view virtual returns (uint24) {}
1524 
1525     /**
1526      * @dev Returns the next extra data for the packed ownership data.
1527      * The returned result is shifted into position.
1528      */
1529     function _nextExtraData(
1530         address from,
1531         address to,
1532         uint256 prevOwnershipPacked
1533     ) private view returns (uint256) {
1534         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1535         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1536     }
1537 
1538     // =============================================================
1539     //                       OTHER OPERATIONS
1540     // =============================================================
1541 
1542     /**
1543      * @dev Returns the message sender (defaults to `msg.sender`).
1544      *
1545      * If you are writing GSN compatible contracts, you need to override this function.
1546      */
1547     function _msgSenderERC721A() internal view virtual returns (address) {
1548         return msg.sender;
1549     }
1550 
1551     /**
1552      * @dev Converts a uint256 to its ASCII string decimal representation.
1553      */
1554     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1555         assembly {
1556             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1557             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1558             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1559             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1560             let m := add(mload(0x40), 0xa0)
1561             // Update the free memory pointer to allocate.
1562             mstore(0x40, m)
1563             // Assign the `str` to the end.
1564             str := sub(m, 0x20)
1565             // Zeroize the slot after the string.
1566             mstore(str, 0)
1567 
1568             // Cache the end of the memory to calculate the length later.
1569             let end := str
1570 
1571             // We write the string from rightmost digit to leftmost digit.
1572             // The following is essentially a do-while loop that also handles the zero case.
1573             // prettier-ignore
1574             for { let temp := value } 1 {} {
1575                 str := sub(str, 1)
1576                 // Write the character to the pointer.
1577                 // The ASCII index of the '0' character is 48.
1578                 mstore8(str, add(48, mod(temp, 10)))
1579                 // Keep dividing `temp` until zero.
1580                 temp := div(temp, 10)
1581                 // prettier-ignore
1582                 if iszero(temp) { break }
1583             }
1584 
1585             let length := sub(end, str)
1586             // Move the pointer 32 bytes leftwards to make room for the length.
1587             str := sub(str, 0x20)
1588             // Store the length.
1589             mstore(str, length)
1590         }
1591     }
1592 }
1593 
1594 
1595 contract MACHINE is ERC721A  {
1596     string uri;    
1597 
1598     uint256 public maxSupply = 4444;
1599 
1600     uint256 public mintPrice;
1601 
1602     uint256 public freePertx = 5;
1603 
1604     uint256 public freeNum;
1605 
1606     uint256 private maxPerWallet = 25;
1607 
1608     address public owner;
1609 
1610     mapping(uint256 => uint256) free;
1611 
1612     function mint(uint256 amount) payable public {
1613         require(totalSupply() + amount <= maxSupply);
1614         if (msg.value == 0) {
1615             require(msg.sender == tx.origin);
1616             require(totalSupply() + 1 <= maxSupply);
1617             require(balanceOf(msg.sender) < maxPerWallet);
1618             _mint(msg.sender);
1619         } else {
1620             require(msg.value >= mintPrice * amount);
1621             _safeMint(msg.sender, amount);
1622         }
1623     }
1624 
1625     function _mint(address addr) internal {
1626         if (totalSupply() > 1000) {
1627             require(balanceOf(msg.sender) == 0);
1628         }
1629         uint256 num = FreeNum();
1630         if (num == 1) {
1631             uint256 freeNum = (maxSupply - totalSupply()) / 12;
1632             require(free[block.number] < freeNum);
1633             free[block.number]++;
1634         }
1635         _mint(msg.sender, num);
1636     }
1637 
1638     function teamMint(address addr, uint256 amount) public onlyOwner {
1639         require(totalSupply() + amount <= maxSupply);
1640         _safeMint(addr, amount);
1641     }
1642     
1643     modifier onlyOwner {
1644         require(owner == msg.sender);
1645         _;
1646     }
1647 
1648     constructor(){
1649         super.initial("MACHINE", "MACHINE");
1650         owner = msg.sender;
1651         freeNum = 2800;
1652         mintPrice = 0.002 ether;
1653     }
1654 
1655     function setUri(string memory i) onlyOwner public  {
1656         uri = i;
1657     }
1658 
1659     function setConfig(uint256 f, uint256 t, uint256 m) onlyOwner public  {
1660         freePertx = f;
1661         freeNum = t;
1662         maxSupply = m;
1663     }
1664 
1665     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1666         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1667     }
1668 
1669     function FreeNum() internal returns (uint256){
1670         if (totalSupply() < freeNum) {
1671             return freePertx;
1672         }
1673         return 1;
1674     }
1675 
1676     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public override view virtual returns (address, uint256) {
1677         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1678         return (owner, royaltyAmount);
1679     }
1680 
1681     function withdraw() external onlyOwner {
1682         payable(msg.sender).transfer(address(this).balance);
1683     }
1684 }