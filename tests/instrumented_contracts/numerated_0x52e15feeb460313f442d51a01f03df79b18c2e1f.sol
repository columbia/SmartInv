1 /**
2  /$$$$$$$  /$$$$$$$$ /$$$$$$$  /$$$$$$$$        /$$$$$$  /$$       /$$ /$$ /$$ /$$                    
3 | $$__  $$| $$_____/| $$__  $$| $$_____/       /$$__  $$| $$      |__/| $$| $$|__/                    
4 | $$  \ $$| $$      | $$  \ $$| $$            | $$  \__/| $$$$$$$  /$$| $$| $$ /$$ /$$$$$$$   /$$$$$$ 
5 | $$$$$$$/| $$$$$   | $$$$$$$/| $$$$$         |  $$$$$$ | $$__  $$| $$| $$| $$| $$| $$__  $$ /$$__  $$
6 | $$____/ | $$__/   | $$____/ | $$__/          \____  $$| $$  \ $$| $$| $$| $$| $$| $$  \ $$| $$  \ $$
7 | $$      | $$      | $$      | $$             /$$  \ $$| $$  | $$| $$| $$| $$| $$| $$  | $$| $$  | $$
8 | $$      | $$$$$$$$| $$      | $$$$$$$$      |  $$$$$$/| $$  | $$| $$| $$| $$| $$| $$  | $$|  $$$$$$$
9 |__/      |________/|__/      |________/       \______/ |__/  |__/|__/|__/|__/|__/|__/  |__/ \____  $$
10                                                                                              /$$  \ $$
11                                                                                             |  $$$$$$/
12                                                                                              \______/ 
13 https://twitter.com/_PEPE_Shilling      
14 A collection of 5,000 PEPE inspired by a lifetime of memes & media. 
15 Free mint                                                                                                                                                                                                                                                                                                                                                                                                                 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 pragma solidity ^0.8.4;
20 
21 interface ERC721A__IERC721Receiver {
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 interface IERC165 {
31     /**
32      * @dev Returns true if this contract implements the interface defined by
33      * `interfaceId`. See the corresponding
34      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
35      * to learn more about how these ids are created.
36      *
37      * This function call must use less than 30 000 gas.
38      */
39     function supportsInterface(bytes4 interfaceId) external view returns (bool);
40 }
41 
42 abstract contract ERC165 is IERC165 {
43     /**
44      * @dev See {IERC165-supportsInterface}.
45      */
46     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
47         return interfaceId == type(IERC165).interfaceId;
48     }
49 }
50 
51 interface IERC2981 is IERC165 {
52     /**
53      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
54      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
55      */
56     function royaltyInfo(uint256 tokenId, uint256 salePrice)
57         external
58         view
59         returns (address receiver, uint256 royaltyAmount);
60 }
61 
62 abstract contract ERC2981 is IERC2981, ERC165 {
63     struct RoyaltyInfo {
64         address receiver;
65         uint96 royaltyFraction;
66     }
67 
68     RoyaltyInfo private _defaultRoyaltyInfo;
69     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
70 
71     /**
72      * @dev See {IERC165-supportsInterface}.
73      */
74     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
75         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
76     }
77 
78     /**
79      * @inheritdoc IERC2981
80      */
81     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
82         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
83 
84         if (royalty.receiver == address(0)) {
85             royalty = _defaultRoyaltyInfo;
86         }
87 
88         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
89 
90         return (royalty.receiver, royaltyAmount);
91     }
92 
93     /**
94      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
95      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
96      * override.
97      */
98     function _feeDenominator() internal pure virtual returns (uint96) {
99         return 1000;
100     }
101 
102     /**
103      * @dev Sets the royalty information that all ids in this contract will default to.
104      *
105      * Requirements:
106      *
107      * - `receiver` cannot be the zero address.
108      * - `feeNumerator` cannot be greater than the fee denominator.
109      */
110     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
111         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
112         require(receiver != address(0), "ERC2981: invalid receiver");
113 
114         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
115     }
116 
117     /**
118      * @dev Removes default royalty information.
119      */
120     function _deleteDefaultRoyalty() internal virtual {
121         delete _defaultRoyaltyInfo;
122     }
123 
124     /**
125      * @dev Sets the royalty information for a specific token id, overriding the global default.
126      *
127      * Requirements:
128      *
129      * - `receiver` cannot be the zero address.
130      * - `feeNumerator` cannot be greater than the fee denominator.
131      */
132     function _setTokenRoyalty(
133         uint256 tokenId,
134         address receiver,
135         uint96 feeNumerator
136     ) internal virtual {
137         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
138         require(receiver != address(0), "ERC2981: Invalid parameters");
139 
140         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
141     }
142 
143     /**
144      * @dev Resets royalty information for the token id back to the global default.
145      */
146     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
147         delete _tokenRoyaltyInfo[tokenId];
148     }
149 }
150 
151 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
152 /// mandatory on-chain royalty enforcement in order for new collections to
153 /// receive royalties.
154 /// For more information, see:
155 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
156 abstract contract OperatorFilterer {
157     /// @dev The default OpenSea operator blocklist subscription.
158     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
159 
160     /// @dev The OpenSea operator filter registry.
161     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
162 
163     /// @dev Registers the current contract to OpenSea's operator filter,
164     /// and subscribe to the default OpenSea operator blocklist.
165     /// Note: Will not revert nor update existing settings for repeated registration.
166     function _registerForOperatorFiltering() internal virtual {
167         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
168     }
169 
170     /// @dev Registers the current contract to OpenSea's operator filter.
171     /// Note: Will not revert nor update existing settings for repeated registration.
172     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
173         internal
174         virtual
175     {
176         /// @solidity memory-safe-assembly
177         assembly {
178             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
179 
180             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
181             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
182 
183             for {} iszero(subscribe) {} {
184                 if iszero(subscriptionOrRegistrantToCopy) {
185                     functionSelector := 0x4420e486 // `register(address)`.
186                     break
187                 }
188                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
189                 break
190             }
191             // Store the function selector.
192             mstore(0x00, shl(224, functionSelector))
193             // Store the `address(this)`.
194             mstore(0x04, address())
195             // Store the `subscriptionOrRegistrantToCopy`.
196             mstore(0x24, subscriptionOrRegistrantToCopy)
197             // Register into the registry.
198             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
199                 // If the function selector has not been overwritten,
200                 // it is an out-of-gas error.
201                 if eq(shr(224, mload(0x00)), functionSelector) {
202                     // To prevent gas under-estimation.
203                     revert(0, 0)
204                 }
205             }
206             // Restore the part of the free memory pointer that was overwritten,
207             // which is guaranteed to be zero, because of Solidity's memory size limits.
208             mstore(0x24, 0)
209         }
210     }
211 
212     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
213     modifier onlyAllowedOperator(address from) virtual {
214         if (from != msg.sender) {
215             if (!_isPriorityOperator(msg.sender)) {
216                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
217             }
218         }
219         _;
220     }
221 
222     /// @dev Modifier to guard a function from approving a blocked operator..
223     modifier onlyAllowedOperatorApproval(address operator) virtual {
224         if (!_isPriorityOperator(operator)) {
225             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
226         }
227         _;
228     }
229 
230     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
231     function _revertIfBlocked(address operator) private view {
232         /// @solidity memory-safe-assembly
233         assembly {
234             // Store the function selector of `isOperatorAllowed(address,address)`,
235             // shifted left by 6 bytes, which is enough for 8tb of memory.
236             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
237             mstore(0x00, 0xc6171134001122334455)
238             // Store the `address(this)`.
239             mstore(0x1a, address())
240             // Store the `operator`.
241             mstore(0x3a, operator)
242 
243             // `isOperatorAllowed` always returns true if it does not revert.
244             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
245                 // Bubble up the revert if the staticcall reverts.
246                 returndatacopy(0x00, 0x00, returndatasize())
247                 revert(0x00, returndatasize())
248             }
249 
250             // We'll skip checking if `from` is inside the blacklist.
251             // Even though that can block transferring out of wrapper contracts,
252             // we don't want tokens to be stuck.
253 
254             // Restore the part of the free memory pointer that was overwritten,
255             // which is guaranteed to be zero, if less than 8tb of memory is used.
256             mstore(0x3a, 0)
257         }
258     }
259 
260     /// @dev For deriving contracts to override, so that operator filtering
261     /// can be turned on / off.
262     /// Returns true by default.
263     function _operatorFilteringEnabled() internal view virtual returns (bool) {
264         return true;
265     }
266 
267     /// @dev For deriving contracts to override, so that preferred marketplaces can
268     /// skip operator filtering, helping users save gas.
269     /// Returns false for all inputs by default.
270     function _isPriorityOperator(address) internal view virtual returns (bool) {
271         return false;
272     }
273 }
274 
275 interface IERC721A {
276     /**
277      * The caller must own the token or be an approved operator.
278      */
279     error ApprovalCallerNotOwnerNorApproved();
280 
281     /**
282      * The token does not exist.
283      */
284     error ApprovalQueryForNonexistentToken();
285 
286     /**
287      * Cannot query the balance for the zero address.
288      */
289     error BalanceQueryForZeroAddress();
290 
291     /**
292      * Cannot mint to the zero address.
293      */
294     error MintToZeroAddress();
295 
296     /**
297      * The quantity of tokens minted must be more than zero.
298      */
299     error MintZeroQuantity();
300 
301     /**
302      * The token does not exist.
303      */
304     error OwnerQueryForNonexistentToken();
305 
306     /**
307      * The caller must own the token or be an approved operator.
308      */
309     error TransferCallerNotOwnerNorApproved();
310 
311     /**
312      * The token must be owned by `from`.
313      */
314     error TransferFromIncorrectOwner();
315 
316     /**
317      * Cannot safely transfer to a contract that does not implement the
318      * ERC721Receiver interface.
319      */
320     error TransferToNonERC721ReceiverImplementer();
321 
322     /**
323      * Cannot transfer to the zero address.
324      */
325     error TransferToZeroAddress();
326 
327     /**
328      * The token does not exist.
329      */
330     error URIQueryForNonexistentToken();
331 
332     /**
333      * The `quantity` minted with ERC2309 exceeds the safety limit.
334      */
335     error MintERC2309QuantityExceedsLimit();
336 
337     /**
338      * The `extraData` cannot be set on an unintialized ownership slot.
339      */
340     error OwnershipNotInitializedForExtraData();
341 
342     // =============================================================
343     //                            STRUCTS
344     // =============================================================
345 
346     struct TokenOwnership {
347         // The address of the owner.
348         address addr;
349         // Stores the start time of ownership with minimal overhead for tokenomics.
350         uint64 startTimestamp;
351         // Whether the token has been burned.
352         bool burned;
353         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
354         uint24 extraData;
355     }
356 
357     // =============================================================
358     //                         TOKEN COUNTERS
359     // =============================================================
360 
361     /**
362      * @dev Returns the total number of tokens in existence.
363      * Burned tokens will reduce the count.
364      * To get the total number of tokens minted, please see {_totalMinted}.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     // =============================================================
369     //                            IERC165
370     // =============================================================
371 
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 
382     // =============================================================
383     //                            IERC721
384     // =============================================================
385 
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables
398      * (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in `owner`'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`,
418      * checking first that contract recipients are aware of the ERC721 protocol
419      * to prevent tokens from being forever locked.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must exist and be owned by `from`.
426      * - If the caller is not `from`, it must be have been allowed to move
427      * this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement
429      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
430      *
431      * Emits a {Transfer} event.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId,
437         bytes calldata data
438     ) external payable;
439 
440     /**
441      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external payable;
448 
449     /**
450      * @dev Transfers `tokenId` from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
453      * whenever possible.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token
461      * by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external payable;
470 
471     /**
472      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
473      * The approval is cleared when the token is transferred.
474      *
475      * Only a single account can be approved at a time, so approving the
476      * zero address clears previous approvals.
477      *
478      * Requirements:
479      *
480      * - The caller must own the token or be an approved operator.
481      * - `tokenId` must exist.
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address to, uint256 tokenId) external payable;
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom}
490      * for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns the account approved for `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function getApproved(uint256 tokenId) external view returns (address operator);
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}.
513      */
514     function isApprovedForAll(address owner, address operator) external view returns (bool);
515 
516     // =============================================================
517     //                        IERC721Metadata
518     // =============================================================
519 
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 
535     // =============================================================
536     //                           IERC2309
537     // =============================================================
538 
539     /**
540      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
541      * (inclusive) is transferred from `from` to `to`, as defined in the
542      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
543      *
544      * See {_mintERC2309} for more details.
545      */
546     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
547 }
548 
549 contract ERC721A is IERC721A, ERC2981 {
550     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
551     struct TokenApprovalRef {
552         address value;
553     }
554 
555     // =============================================================
556     //                           CONSTANTS
557     // =============================================================
558 
559     // Mask of an entry in packed address data.
560     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
561 
562     // The bit position of `numberMinted` in packed address data.
563     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
564 
565     // The bit position of `numberBurned` in packed address data.
566     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
567 
568     // The bit position of `aux` in packed address data.
569     uint256 private constant _BITPOS_AUX = 192;
570 
571     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
572     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
573 
574     // The bit position of `startTimestamp` in packed ownership.
575     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
576 
577     // The bit mask of the `burned` bit in packed ownership.
578     uint256 private constant _BITMASK_BURNED = 1 << 224;
579 
580     // The bit position of the `nextInitialized` bit in packed ownership.
581     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
582 
583     // The bit mask of the `nextInitialized` bit in packed ownership.
584     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
585 
586     // The bit position of `extraData` in packed ownership.
587     uint256 private constant _BITPOS_EXTRA_DATA = 232;
588 
589     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
590     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
591 
592     // The mask of the lower 160 bits for addresses.
593     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
594 
595     // The maximum `quantity` that can be minted with {_mintERC2309}.
596     // This limit is to prevent overflows on the address data entries.
597     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
598     // is required to cause an overflow, which is unrealistic.
599     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
600 
601     // The `Transfer` event signature is given by:
602     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
603     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
604         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
605 
606     // =============================================================
607     //                            STORAGE
608     // =============================================================
609 
610     // The next token ID to be minted.
611     uint256 private _currentIndex;
612 
613     // The number of tokens burned.
614     uint256 private _burnCounter;
615 
616     // Token name
617     string private _name;
618 
619     // Token symbol
620     string private _symbol;
621 
622     // Mapping from token ID to ownership details
623     // An empty struct value does not necessarily mean the token is unowned.
624     // See {_packedOwnershipOf} implementation for details.
625     //
626     // Bits Layout:
627     // - [0..159]   `addr`
628     // - [160..223] `startTimestamp`
629     // - [224]      `burned`
630     // - [225]      `nextInitialized`
631     // - [232..255] `extraData`
632     mapping(uint256 => uint256) private _packedOwnerships;
633 
634     // Mapping owner address to address data.
635     //
636     // Bits Layout:
637     // - [0..63]    `balance`
638     // - [64..127]  `numberMinted`
639     // - [128..191] `numberBurned`
640     // - [192..255] `aux`
641     mapping(address => uint256) private _packedAddressData;
642 
643     // Mapping from token ID to approved address.
644     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
645 
646     // Mapping from owner to operator approvals
647     mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649     // =============================================================
650     //                          CONSTRUCTOR
651     // =============================================================
652 
653     function initial(string memory name_, string memory symbol_) internal {
654         _name = name_;
655         _symbol = symbol_;
656         _currentIndex = _startTokenId();
657     }
658 
659     // =============================================================
660     //                   TOKEN COUNTING OPERATIONS
661     // =============================================================
662 
663     /**
664      * @dev Returns the starting token ID.
665      * To change the starting token ID, please override this function.
666      */
667     function _startTokenId() internal view virtual returns (uint256) {
668         return 0;
669     }
670 
671     /**
672      * @dev Returns the next token ID to be minted.
673      */
674     function _nextTokenId() internal view virtual returns (uint256) {
675         return _currentIndex;
676     }
677 
678     /**
679      * @dev Returns the total number of tokens in existence.
680      * Burned tokens will reduce the count.
681      * To get the total number of tokens minted, please see {_totalMinted}.
682      */
683     function totalSupply() public view virtual override returns (uint256) {
684         // Counter underflow is impossible as _burnCounter cannot be incremented
685         // more than `_currentIndex - _startTokenId()` times.
686         unchecked {
687             return _currentIndex - _burnCounter - _startTokenId();
688         }
689     }
690 
691     /**
692      * @dev Returns the total amount of tokens minted in the contract.
693      */
694     function _totalMinted() internal view virtual returns (uint256) {
695         // Counter underflow is impossible as `_currentIndex` does not decrement,
696         // and it is initialized to `_startTokenId()`.
697         unchecked {
698             return _currentIndex - _startTokenId();
699         }
700     }
701 
702     /**
703      * @dev Returns the total number of tokens burned.
704      */
705     function _totalBurned() internal view virtual returns (uint256) {
706         return _burnCounter;
707     }
708 
709     // =============================================================
710     //                    ADDRESS DATA OPERATIONS
711     // =============================================================
712 
713     /**
714      * @dev Returns the number of tokens in `owner`'s account.
715      */
716     function balanceOf(address owner) public view virtual override returns (uint256) {
717         if (owner == address(0)) revert BalanceQueryForZeroAddress();
718         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
719     }
720 
721     /**
722      * Returns the number of tokens minted by `owner`.
723      */
724     function _numberMinted(address owner) internal view returns (uint256) {
725         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
726     }
727 
728     /**
729      * Returns the number of tokens burned by or on behalf of `owner`.
730      */
731     function _numberBurned(address owner) internal view returns (uint256) {
732         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
733     }
734 
735     /**
736      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
737      */
738     function _getAux(address owner) internal view returns (uint64) {
739         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
740     }
741 
742     /**
743      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
744      * If there are multiple variables, please pack them into a uint64.
745      */
746     function _setAux(address owner, uint64 aux) internal virtual {
747         uint256 packed = _packedAddressData[owner];
748         uint256 auxCasted;
749         // Cast `aux` with assembly to avoid redundant masking.
750         assembly {
751             auxCasted := aux
752         }
753         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
754         _packedAddressData[owner] = packed;
755     }
756 
757     // =============================================================
758     //                            IERC165
759     // =============================================================
760 
761     /**
762      * @dev Returns true if this contract implements the interface defined by
763      * `interfaceId`. See the corresponding
764      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
765      * to learn more about how these ids are created.
766      *
767      * This function call must use less than 30000 gas.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, IERC721A) returns (bool) {
770         // The interface IDs are constants representing the first 4 bytes
771         // of the XOR of all function selectors in the interface.
772         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
773         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
774         return
775             interfaceId == type(IERC721A).interfaceId ||
776             interfaceId == type(ERC2981).interfaceId ||
777             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
778             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
779             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
780     }
781 
782     // =============================================================
783     //                        IERC721Metadata
784     // =============================================================
785 
786     /**
787      * @dev Returns the token collection name.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev Returns the token collection symbol.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, it can be overridden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return '';
817     }
818 
819     // =============================================================
820     //                     OWNERSHIPS OPERATIONS
821     // =============================================================
822 
823     /**
824      * @dev Returns the owner of the `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
831         return address(uint160(_packedOwnershipOf(tokenId)));
832     }
833 
834     /**
835      * @dev Gas spent here starts off proportional to the maximum mint batch size.
836      * It gradually moves to O(1) as tokens get transferred around over time.
837      */
838     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnershipOf(tokenId));
840     }
841 
842     /**
843      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
844      */
845     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
846         return _unpackedOwnership(_packedOwnerships[index]);
847     }
848 
849     /**
850      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
851      */
852     function _initializeOwnershipAt(uint256 index) internal virtual {
853         if (_packedOwnerships[index] == 0) {
854             _packedOwnerships[index] = _packedOwnershipOf(index);
855         }
856     }
857 
858     /**
859      * Returns the packed ownership data of `tokenId`.
860      */
861     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
862         uint256 curr = tokenId;
863 
864         unchecked {
865             if (_startTokenId() <= curr)
866                 if (curr < _currentIndex) {
867                     uint256 packed = _packedOwnerships[curr];
868                     // If not burned.
869                     if (packed & _BITMASK_BURNED == 0) {
870                         // Invariant:
871                         // There will always be an initialized ownership slot
872                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
873                         // before an unintialized ownership slot
874                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
875                         // Hence, `curr` will not underflow.
876                         //
877                         // We can directly compare the packed value.
878                         // If the address is zero, packed will be zero.
879                         while (packed == 0) {
880                             packed = _packedOwnerships[--curr];
881                         }
882                         return packed;
883                     }
884                 }
885         }
886         revert OwnerQueryForNonexistentToken();
887     }
888 
889     /**
890      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
891      */
892     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
893         ownership.addr = address(uint160(packed));
894         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
895         ownership.burned = packed & _BITMASK_BURNED != 0;
896         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
897     }
898 
899     /**
900      * @dev Packs ownership data into a single uint256.
901      */
902     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
903         assembly {
904             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
905             owner := and(owner, _BITMASK_ADDRESS)
906             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
907             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
908         }
909     }
910 
911     /**
912      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
913      */
914     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
915         // For branchless setting of the `nextInitialized` flag.
916         assembly {
917             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
918             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
919         }
920     }
921 
922     // =============================================================
923     //                      APPROVAL OPERATIONS
924     // =============================================================
925 
926     /**
927      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
928      * The approval is cleared when the token is transferred.
929      *
930      * Only a single account can be approved at a time, so approving the
931      * zero address clears previous approvals.
932      *
933      * Requirements:
934      *
935      * - The caller must own the token or be an approved operator.
936      * - `tokenId` must exist.
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address to, uint256 tokenId) public payable virtual override {
941         address owner = ownerOf(tokenId);
942 
943         if (_msgSenderERC721A() != owner)
944             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
945                 revert ApprovalCallerNotOwnerNorApproved();
946             }
947 
948         _tokenApprovals[tokenId].value = to;
949         emit Approval(owner, to, tokenId);
950     }
951 
952     /**
953      * @dev Returns the account approved for `tokenId` token.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function getApproved(uint256 tokenId) public view virtual override returns (address) {
960         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
961 
962         return _tokenApprovals[tokenId].value;
963     }
964 
965     /**
966      * @dev Approve or remove `operator` as an operator for the caller.
967      * Operators can call {transferFrom} or {safeTransferFrom}
968      * for any token owned by the caller.
969      *
970      * Requirements:
971      *
972      * - The `operator` cannot be the caller.
973      *
974      * Emits an {ApprovalForAll} event.
975      */
976     function setApprovalForAll(address operator, bool approved) public virtual override {
977         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
978         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
979     }
980 
981     /**
982      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
983      *
984      * See {setApprovalForAll}.
985      */
986     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
987         return _operatorApprovals[owner][operator];
988     }
989 
990     /**
991      * @dev Returns whether `tokenId` exists.
992      *
993      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
994      *
995      * Tokens start existing when they are minted. See {_mint}.
996      */
997     function _exists(uint256 tokenId) internal view virtual returns (bool) {
998         return
999             _startTokenId() <= tokenId &&
1000             tokenId < _currentIndex && // If within bounds,
1001             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1002     }
1003 
1004     /**
1005      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1006      */
1007     function _isSenderApprovedOrOwner(
1008         address approvedAddress,
1009         address owner,
1010         address msgSender
1011     ) private pure returns (bool result) {
1012         assembly {
1013             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1014             owner := and(owner, _BITMASK_ADDRESS)
1015             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1016             msgSender := and(msgSender, _BITMASK_ADDRESS)
1017             // `msgSender == owner || msgSender == approvedAddress`.
1018             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1019         }
1020     }
1021 
1022     /**
1023      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1024      */
1025     function _getApprovedSlotAndAddress(uint256 tokenId)
1026         private
1027         view
1028         returns (uint256 approvedAddressSlot, address approvedAddress)
1029     {
1030         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1031         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1032         assembly {
1033             approvedAddressSlot := tokenApproval.slot
1034             approvedAddress := sload(approvedAddressSlot)
1035         }
1036     }
1037 
1038     // =============================================================
1039     //                      TRANSFER OPERATIONS
1040     // =============================================================
1041 
1042     /**
1043      * @dev Transfers `tokenId` from `from` to `to`.
1044      *
1045      * Requirements:
1046      *
1047      * - `from` cannot be the zero address.
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      * - If the caller is not `from`, it must be approved to move this token
1051      * by either {approve} or {setApprovalForAll}.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function transferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public payable virtual override {
1060         _beforeTransfer();
1061         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1062 
1063         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1064 
1065         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1066 
1067         // The nested ifs save around 20+ gas over a compound boolean condition.
1068         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1069             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1070 
1071         if (to == address(0)) revert TransferToZeroAddress();
1072 
1073         _beforeTokenTransfers(from, to, tokenId, 1);
1074 
1075         // Clear approvals from the previous owner.
1076         assembly {
1077             if approvedAddress {
1078                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1079                 sstore(approvedAddressSlot, 0)
1080             }
1081         }
1082 
1083         // Underflow of the sender's balance is impossible because we check for
1084         // ownership above and the recipient's balance can't realistically overflow.
1085         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1086         unchecked {
1087             // We can directly increment and decrement the balances.
1088             --_packedAddressData[from]; // Updates: `balance -= 1`.
1089             ++_packedAddressData[to]; // Updates: `balance += 1`.
1090 
1091             // Updates:
1092             // - `address` to the next owner.
1093             // - `startTimestamp` to the timestamp of transfering.
1094             // - `burned` to `false`.
1095             // - `nextInitialized` to `true`.
1096             _packedOwnerships[tokenId] = _packOwnershipData(
1097                 to,
1098                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1099             );
1100 
1101             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1102             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1103                 uint256 nextTokenId = tokenId + 1;
1104                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1105                 if (_packedOwnerships[nextTokenId] == 0) {
1106                     // If the next slot is within bounds.
1107                     if (nextTokenId != _currentIndex) {
1108                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1109                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1110                     }
1111                 }
1112             }
1113         }
1114 
1115         emit Transfer(from, to, tokenId);
1116         _afterTokenTransfers(from, to, tokenId, 1);
1117     }
1118 
1119     /**
1120      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1121      */
1122     function safeTransferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) public payable virtual override {
1127         safeTransferFrom(from, to, tokenId, '');
1128     }
1129 
1130     /**
1131      * @dev Safely transfers `tokenId` token from `from` to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must exist and be owned by `from`.
1138      * - If the caller is not `from`, it must be approved to move this token
1139      * by either {approve} or {setApprovalForAll}.
1140      * - If `to` refers to a smart contract, it must implement
1141      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function safeTransferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) public payable virtual override {
1151         transferFrom(from, to, tokenId);
1152         if (to.code.length != 0)
1153             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1154                 revert TransferToNonERC721ReceiverImplementer();
1155             }
1156     }
1157 
1158     /**
1159      * @dev Hook that is called before a set of serially-ordered token IDs
1160      * are about to be transferred. This includes minting.
1161      * And also called before burning one token.
1162      *
1163      * `startTokenId` - the first token ID to be transferred.
1164      * `quantity` - the amount to be transferred.
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, `tokenId` will be burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _beforeTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     function _beforeTransfer() internal {
1182     }
1183     /**
1184      * @dev Hook that is called after a set of serially-ordered token IDs
1185      * have been transferred. This includes minting.
1186      * And also called after one token has been burned.
1187      *
1188      * `startTokenId` - the first token ID to be transferred.
1189      * `quantity` - the amount to be transferred.
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` has been minted for `to`.
1196      * - When `to` is zero, `tokenId` has been burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _afterTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1208      *
1209      * `from` - Previous owner of the given token ID.
1210      * `to` - Target address that will receive the token.
1211      * `tokenId` - Token ID to be transferred.
1212      * `_data` - Optional data to send along with the call.
1213      *
1214      * Returns whether the call correctly returned the expected magic value.
1215      */
1216     function _checkContractOnERC721Received(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) private returns (bool) {
1222         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1223             bytes4 retval
1224         ) {
1225             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1226         } catch (bytes memory reason) {
1227             if (reason.length == 0) {
1228                 revert TransferToNonERC721ReceiverImplementer();
1229             } else {
1230                 assembly {
1231                     revert(add(32, reason), mload(reason))
1232                 }
1233             }
1234         }
1235     }
1236 
1237     // =============================================================
1238     //                        MINT OPERATIONS
1239     // =============================================================
1240 
1241     /**
1242      * @dev Mints `quantity` tokens and transfers them to `to`.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `quantity` must be greater than 0.
1248      *
1249      * Emits a {Transfer} event for each mint.
1250      */
1251     function _mint(address to, uint256 quantity) internal virtual {
1252         uint256 startTokenId = _currentIndex;
1253         if (quantity == 0) revert MintZeroQuantity();
1254 
1255         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1256 
1257         // Overflows are incredibly unrealistic.
1258         // `balance` and `numberMinted` have a maximum limit of 2**64.
1259         // `tokenId` has a maximum limit of 2**256.
1260         unchecked {
1261             // Updates:
1262             // - `balance += quantity`.
1263             // - `numberMinted += quantity`.
1264             //
1265             // We can directly add to the `balance` and `numberMinted`.
1266             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1267 
1268             // Updates:
1269             // - `address` to the owner.
1270             // - `startTimestamp` to the timestamp of minting.
1271             // - `burned` to `false`.
1272             // - `nextInitialized` to `quantity == 1`.
1273             _packedOwnerships[startTokenId] = _packOwnershipData(
1274                 to,
1275                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1276             );
1277 
1278             uint256 toMasked;
1279             uint256 end = startTokenId + quantity;
1280 
1281             // Use assembly to loop and emit the `Transfer` event for gas savings.
1282             // The duplicated `log4` removes an extra check and reduces stack juggling.
1283             // The assembly, together with the surrounding Solidity code, have been
1284             // delicately arranged to nudge the compiler into producing optimized opcodes.
1285             assembly {
1286                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1287                 toMasked := and(to, _BITMASK_ADDRESS)
1288                 // Emit the `Transfer` event.
1289                 log4(
1290                     0, // Start of data (0, since no data).
1291                     0, // End of data (0, since no data).
1292                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1293                     0, // `address(0)`.
1294                     toMasked, // `to`.
1295                     startTokenId // `tokenId`.
1296                 )
1297 
1298                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1299                 // that overflows uint256 will make the loop run out of gas.
1300                 // The compiler will optimize the `iszero` away for performance.
1301                 for {
1302                     let tokenId := add(startTokenId, 1)
1303                 } iszero(eq(tokenId, end)) {
1304                     tokenId := add(tokenId, 1)
1305                 } {
1306                     // Emit the `Transfer` event. Similar to above.
1307                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1308                 }
1309             }
1310             if (toMasked == 0) revert MintToZeroAddress();
1311 
1312             _currentIndex = end;
1313         }
1314         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1315     }
1316 
1317     /**
1318      * @dev Mints `quantity` tokens and transfers them to `to`.
1319      *
1320      * This function is intended for efficient minting only during contract creation.
1321      *
1322      * It emits only one {ConsecutiveTransfer} as defined in
1323      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1324      * instead of a sequence of {Transfer} event(s).
1325      *
1326      * Calling this function outside of contract creation WILL make your contract
1327      * non-compliant with the ERC721 standard.
1328      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1329      * {ConsecutiveTransfer} event is only permissible during contract creation.
1330      *
1331      * Requirements:
1332      *
1333      * - `to` cannot be the zero address.
1334      * - `quantity` must be greater than 0.
1335      *
1336      * Emits a {ConsecutiveTransfer} event.
1337      */
1338     function _mintERC2309(address to, uint256 quantity) internal virtual {
1339         uint256 startTokenId = _currentIndex;
1340         if (to == address(0)) revert MintToZeroAddress();
1341         if (quantity == 0) revert MintZeroQuantity();
1342         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1343 
1344         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1345 
1346         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1347         unchecked {
1348             // Updates:
1349             // - `balance += quantity`.
1350             // - `numberMinted += quantity`.
1351             //
1352             // We can directly add to the `balance` and `numberMinted`.
1353             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1354 
1355             // Updates:
1356             // - `address` to the owner.
1357             // - `startTimestamp` to the timestamp of minting.
1358             // - `burned` to `false`.
1359             // - `nextInitialized` to `quantity == 1`.
1360             _packedOwnerships[startTokenId] = _packOwnershipData(
1361                 to,
1362                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1363             );
1364 
1365             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1366 
1367             _currentIndex = startTokenId + quantity;
1368         }
1369         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1370     }
1371 
1372     /**
1373      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1374      *
1375      * Requirements:
1376      *
1377      * - If `to` refers to a smart contract, it must implement
1378      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1379      * - `quantity` must be greater than 0.
1380      *
1381      * See {_mint}.
1382      *
1383      * Emits a {Transfer} event for each mint.
1384      */
1385     function _safeMint(
1386         address to,
1387         uint256 quantity,
1388         bytes memory _data
1389     ) internal virtual {
1390         _mint(to, quantity);
1391 
1392         unchecked {
1393             if (to.code.length != 0) {
1394                 uint256 end = _currentIndex;
1395                 uint256 index = end - quantity;
1396                 do {
1397                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1398                         revert TransferToNonERC721ReceiverImplementer();
1399                     }
1400                 } while (index < end);
1401                 // Reentrancy protection.
1402                 if (_currentIndex != end) revert();
1403             }
1404         }
1405     }
1406 
1407     /**
1408      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1409      */
1410     function _safeMint(address to, uint256 quantity) internal virtual {
1411         _safeMint(to, quantity, '');
1412     }
1413 
1414     // =============================================================
1415     //                        BURN OPERATIONS
1416     // =============================================================
1417 
1418     /**
1419      * @dev Equivalent to `_burn(tokenId, false)`.
1420      */
1421     function _burn(uint256 tokenId) internal virtual {
1422         _burn(tokenId, false);
1423     }
1424 
1425     /**
1426      * @dev Destroys `tokenId`.
1427      * The approval is cleared when the token is burned.
1428      *
1429      * Requirements:
1430      *
1431      * - `tokenId` must exist.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1436         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1437 
1438         address from = address(uint160(prevOwnershipPacked));
1439 
1440         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1441 
1442         if (approvalCheck) {
1443             // The nested ifs save around 20+ gas over a compound boolean condition.
1444             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1445                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1446         }
1447 
1448         _beforeTokenTransfers(from, address(0), tokenId, 1);
1449 
1450         // Clear approvals from the previous owner.
1451         assembly {
1452             if approvedAddress {
1453                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1454                 sstore(approvedAddressSlot, 0)
1455             }
1456         }
1457 
1458         // Underflow of the sender's balance is impossible because we check for
1459         // ownership above and the recipient's balance can't realistically overflow.
1460         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1461         unchecked {
1462             // Updates:
1463             // - `balance -= 1`.
1464             // - `numberBurned += 1`.
1465             //
1466             // We can directly decrement the balance, and increment the number burned.
1467             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1468             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1469 
1470             // Updates:
1471             // - `address` to the last owner.
1472             // - `startTimestamp` to the timestamp of burning.
1473             // - `burned` to `true`.
1474             // - `nextInitialized` to `true`.
1475             _packedOwnerships[tokenId] = _packOwnershipData(
1476                 from,
1477                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1478             );
1479 
1480             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1481             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1482                 uint256 nextTokenId = tokenId + 1;
1483                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1484                 if (_packedOwnerships[nextTokenId] == 0) {
1485                     // If the next slot is within bounds.
1486                     if (nextTokenId != _currentIndex) {
1487                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1488                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1489                     }
1490                 }
1491             }
1492         }
1493 
1494         emit Transfer(from, address(0), tokenId);
1495         _afterTokenTransfers(from, address(0), tokenId, 1);
1496 
1497         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1498         unchecked {
1499             _burnCounter++;
1500         }
1501     }
1502 
1503     // =============================================================
1504     //                     EXTRA DATA OPERATIONS
1505     // =============================================================
1506 
1507     /**
1508      * @dev Directly sets the extra data for the ownership data `index`.
1509      */
1510     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1511         uint256 packed = _packedOwnerships[index];
1512         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1513         uint256 extraDataCasted;
1514         // Cast `extraData` with assembly to avoid redundant masking.
1515         assembly {
1516             extraDataCasted := extraData
1517         }
1518         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1519         _packedOwnerships[index] = packed;
1520     }
1521 
1522     /**
1523      * @dev Called during each token transfer to set the 24bit `extraData` field.
1524      * Intended to be overridden by the cosumer contract.
1525      *
1526      * `previousExtraData` - the value of `extraData` before transfer.
1527      *
1528      * Calling conditions:
1529      *
1530      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1531      * transferred to `to`.
1532      * - When `from` is zero, `tokenId` will be minted for `to`.
1533      * - When `to` is zero, `tokenId` will be burned by `from`.
1534      * - `from` and `to` are never both zero.
1535      */
1536     function _extraData(
1537         address from,
1538         address to,
1539         uint24 previousExtraData
1540     ) internal view virtual returns (uint24) {}
1541 
1542     /**
1543      * @dev Returns the next extra data for the packed ownership data.
1544      * The returned result is shifted into position.
1545      */
1546     function _nextExtraData(
1547         address from,
1548         address to,
1549         uint256 prevOwnershipPacked
1550     ) private view returns (uint256) {
1551         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1552         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1553     }
1554 
1555     // =============================================================
1556     //                       OTHER OPERATIONS
1557     // =============================================================
1558 
1559     /**
1560      * @dev Returns the message sender (defaults to `msg.sender`).
1561      *
1562      * If you are writing GSN compatible contracts, you need to override this function.
1563      */
1564     function _msgSenderERC721A() internal view virtual returns (address) {
1565         return msg.sender;
1566     }
1567 
1568     /**
1569      * @dev Converts a uint256 to its ASCII string decimal representation.
1570      */
1571     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1572         assembly {
1573             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1574             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1575             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1576             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1577             let m := add(mload(0x40), 0xa0)
1578             // Update the free memory pointer to allocate.
1579             mstore(0x40, m)
1580             // Assign the `str` to the end.
1581             str := sub(m, 0x20)
1582             // Zeroize the slot after the string.
1583             mstore(str, 0)
1584 
1585             // Cache the end of the memory to calculate the length later.
1586             let end := str
1587 
1588             // We write the string from rightmost digit to leftmost digit.
1589             // The following is essentially a do-while loop that also handles the zero case.
1590             // prettier-ignore
1591             for { let temp := value } 1 {} {
1592                 str := sub(str, 1)
1593                 // Write the character to the pointer.
1594                 // The ASCII index of the '0' character is 48.
1595                 mstore8(str, add(48, mod(temp, 10)))
1596                 // Keep dividing `temp` until zero.
1597                 temp := div(temp, 10)
1598                 // prettier-ignore
1599                 if iszero(temp) { break }
1600             }
1601 
1602             let length := sub(end, str)
1603             // Move the pointer 32 bytes leftwards to make room for the length.
1604             str := sub(str, 0x20)
1605             // Store the length.
1606             mstore(str, length)
1607         }
1608     }
1609 }
1610 
1611 
1612 contract PEPEShilling is ERC721A  {
1613     string uri;    
1614 
1615     uint256 public maxSupply = 5000;
1616 
1617     uint256 public mintPrice;
1618 
1619     uint256 public freePertx = 5;
1620 
1621     uint256 public freeNum;
1622 
1623     uint256 private maxPerWallet = 25;
1624 
1625     address public owner;
1626 
1627     mapping(uint256 => uint256) free;
1628 
1629     function mint(uint256 amount) payable public {
1630         require(totalSupply() + amount <= maxSupply);
1631         if (msg.value == 0) {
1632             require(msg.sender == tx.origin);
1633             require(totalSupply() + 1 <= maxSupply);
1634             require(balanceOf(msg.sender) < maxPerWallet);
1635             _mint(msg.sender);
1636         } else {
1637             require(msg.value >= mintPrice * amount);
1638             _safeMint(msg.sender, amount);
1639         }
1640     }
1641 
1642 
1643     function _mint(address addr) internal {
1644         if (totalSupply() > 1000) {
1645             require(balanceOf(msg.sender) == 0);
1646         }
1647         uint256 num = FreeNum();
1648         if (num == 1) {
1649             uint256 freeNum = (maxSupply - totalSupply()) / 12;
1650             require(free[block.number] < freeNum);
1651             free[block.number]++;
1652         }
1653         _mint(msg.sender, num);
1654     }
1655 
1656     function pepeMint(address addr, uint256 amount) public onlyOwner {
1657         require(totalSupply() + amount <= maxSupply);
1658         _safeMint(addr, amount);
1659     }
1660     
1661     modifier onlyOwner {
1662         require(owner == msg.sender);
1663         _;
1664     }
1665 
1666     constructor(){
1667         super.initial("PEPE Shilling", "PEPE");
1668         owner = msg.sender;
1669         freeNum = 3800;
1670         mintPrice = 0.001 ether;
1671     }
1672 
1673     function setUri(string memory i) onlyOwner public  {
1674         uri = i;
1675     }
1676 
1677     function setConfig(uint256 f, uint256 t, uint256 m) onlyOwner public  {
1678         freePertx = f;
1679         freeNum = t;
1680         maxSupply = m;
1681     }
1682 
1683     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1684         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1685     }
1686 
1687     function FreeNum() internal returns (uint256){
1688         if (totalSupply() < freeNum) {
1689             return freePertx;
1690         }
1691         return 1;
1692     }
1693 
1694     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public override view virtual returns (address, uint256) {
1695         uint256 royaltyAmount = (_salePrice * 5) / 1000;
1696         return (owner, royaltyAmount);
1697     }
1698 
1699     function withdraw() external onlyOwner {
1700         payable(msg.sender).transfer(address(this).balance);
1701     }
1702 }