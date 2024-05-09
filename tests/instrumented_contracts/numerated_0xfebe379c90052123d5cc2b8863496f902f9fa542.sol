1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev Interface for the NFT Royalty Standard.
70  *
71  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
72  * support for royalty payments across all NFT marketplaces and ecosystem participants.
73  *
74  * _Available since v4.5._
75  */
76 interface IERC2981 is IERC165 {
77     /**
78      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
79      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
80      */
81     function royaltyInfo(uint256 tokenId, uint256 salePrice)
82         external
83         view
84         returns (address receiver, uint256 royaltyAmount);
85 }
86 
87 // File: @openzeppelin/contracts/token/common/ERC2981.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 
96 /**
97  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
98  *
99  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
100  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
101  *
102  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
103  * fee is specified in basis points by default.
104  *
105  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
106  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
107  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
108  *
109  * _Available since v4.5._
110  */
111 abstract contract ERC2981 is IERC2981, ERC165 {
112     struct RoyaltyInfo {
113         address receiver;
114         uint96 royaltyFraction;
115     }
116 
117     RoyaltyInfo private _defaultRoyaltyInfo;
118     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
119 
120     /**
121      * @dev See {IERC165-supportsInterface}.
122      */
123     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
124         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
125     }
126 
127     /**
128      * @inheritdoc IERC2981
129      */
130     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
131         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
132 
133         if (royalty.receiver == address(0)) {
134             royalty = _defaultRoyaltyInfo;
135         }
136 
137         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
138 
139         return (royalty.receiver, royaltyAmount);
140     }
141 
142     /**
143      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
144      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
145      * override.
146      */
147     function _feeDenominator() internal pure virtual returns (uint96) {
148         return 10000;
149     }
150 
151     /**
152      * @dev Sets the royalty information that all ids in this contract will default to.
153      *
154      * Requirements:
155      *
156      * - `receiver` cannot be the zero address.
157      * - `feeNumerator` cannot be greater than the fee denominator.
158      */
159     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
160         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
161         require(receiver != address(0), "ERC2981: invalid receiver");
162 
163         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
164     }
165 
166     /**
167      * @dev Removes default royalty information.
168      */
169     function _deleteDefaultRoyalty() internal virtual {
170         delete _defaultRoyaltyInfo;
171     }
172 
173     /**
174      * @dev Sets the royalty information for a specific token id, overriding the global default.
175      *
176      * Requirements:
177      *
178      * - `receiver` cannot be the zero address.
179      * - `feeNumerator` cannot be greater than the fee denominator.
180      */
181     function _setTokenRoyalty(
182         uint256 tokenId,
183         address receiver,
184         uint96 feeNumerator
185     ) internal virtual {
186         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
187         require(receiver != address(0), "ERC2981: Invalid parameters");
188 
189         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
190     }
191 
192     /**
193      * @dev Resets royalty information for the token id back to the global default.
194      */
195     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
196         delete _tokenRoyaltyInfo[tokenId];
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Context.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Provides information about the current execution context, including the
209  * sender of the transaction and its data. While these are generally available
210  * via msg.sender and msg.data, they should not be accessed in such a direct
211  * manner, since when dealing with meta-transactions the account sending and
212  * paying for execution may not be the actual sender (as far as an application
213  * is concerned).
214  *
215  * This contract is only required for intermediate, library-like contracts.
216  */
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/access/Ownable.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         _checkOwner();
264         _;
265     }
266 
267     /**
268      * @dev Returns the address of the current owner.
269      */
270     function owner() public view virtual returns (address) {
271         return _owner;
272     }
273 
274     /**
275      * @dev Throws if the sender is not the owner.
276      */
277     function _checkOwner() internal view virtual {
278         require(owner() == _msgSender(), "Ownable: caller is not the owner");
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         _transferOwnership(address(0));
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         _transferOwnership(newOwner);
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      * Internal function without access restriction.
304      */
305     function _transferOwnership(address newOwner) internal virtual {
306         address oldOwner = _owner;
307         _owner = newOwner;
308         emit OwnershipTransferred(oldOwner, newOwner);
309     }
310 }
311 
312 // File: erc721a/contracts/IERC721A.sol
313 
314 
315 // ERC721A Contracts v4.2.3
316 // Creator: Chiru Labs
317 
318 pragma solidity ^0.8.4;
319 
320 /**
321  * @dev Interface of ERC721A.
322  */
323 interface IERC721A {
324     /**
325      * The caller must own the token or be an approved operator.
326      */
327     error ApprovalCallerNotOwnerNorApproved();
328 
329     /**
330      * The token does not exist.
331      */
332     error ApprovalQueryForNonexistentToken();
333 
334     /**
335      * Cannot query the balance for the zero address.
336      */
337     error BalanceQueryForZeroAddress();
338 
339     /**
340      * Cannot mint to the zero address.
341      */
342     error MintToZeroAddress();
343 
344     /**
345      * The quantity of tokens minted must be more than zero.
346      */
347     error MintZeroQuantity();
348 
349     /**
350      * The token does not exist.
351      */
352     error OwnerQueryForNonexistentToken();
353 
354     /**
355      * The caller must own the token or be an approved operator.
356      */
357     error TransferCallerNotOwnerNorApproved();
358 
359     /**
360      * The token must be owned by `from`.
361      */
362     error TransferFromIncorrectOwner();
363 
364     /**
365      * Cannot safely transfer to a contract that does not implement the
366      * ERC721Receiver interface.
367      */
368     error TransferToNonERC721ReceiverImplementer();
369 
370     /**
371      * Cannot transfer to the zero address.
372      */
373     error TransferToZeroAddress();
374 
375     /**
376      * The token does not exist.
377      */
378     error URIQueryForNonexistentToken();
379 
380     /**
381      * The `quantity` minted with ERC2309 exceeds the safety limit.
382      */
383     error MintERC2309QuantityExceedsLimit();
384 
385     /**
386      * The `extraData` cannot be set on an unintialized ownership slot.
387      */
388     error OwnershipNotInitializedForExtraData();
389 
390     // =============================================================
391     //                            STRUCTS
392     // =============================================================
393 
394     struct TokenOwnership {
395         // The address of the owner.
396         address addr;
397         // Stores the start time of ownership with minimal overhead for tokenomics.
398         uint64 startTimestamp;
399         // Whether the token has been burned.
400         bool burned;
401         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
402         uint24 extraData;
403     }
404 
405     // =============================================================
406     //                         TOKEN COUNTERS
407     // =============================================================
408 
409     /**
410      * @dev Returns the total number of tokens in existence.
411      * Burned tokens will reduce the count.
412      * To get the total number of tokens minted, please see {_totalMinted}.
413      */
414     function totalSupply() external view returns (uint256);
415 
416     // =============================================================
417     //                            IERC165
418     // =============================================================
419 
420     /**
421      * @dev Returns true if this contract implements the interface defined by
422      * `interfaceId`. See the corresponding
423      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
424      * to learn more about how these ids are created.
425      *
426      * This function call must use less than 30000 gas.
427      */
428     function supportsInterface(bytes4 interfaceId) external view returns (bool);
429 
430     // =============================================================
431     //                            IERC721
432     // =============================================================
433 
434     /**
435      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
436      */
437     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
438 
439     /**
440      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
441      */
442     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables or disables
446      * (`approved`) `operator` to manage all of its assets.
447      */
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     /**
451      * @dev Returns the number of tokens in `owner`'s account.
452      */
453     function balanceOf(address owner) external view returns (uint256 balance);
454 
455     /**
456      * @dev Returns the owner of the `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function ownerOf(uint256 tokenId) external view returns (address owner);
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`,
466      * checking first that contract recipients are aware of the ERC721 protocol
467      * to prevent tokens from being forever locked.
468      *
469      * Requirements:
470      *
471      * - `from` cannot be the zero address.
472      * - `to` cannot be the zero address.
473      * - `tokenId` token must exist and be owned by `from`.
474      * - If the caller is not `from`, it must be have been allowed to move
475      * this token by either {approve} or {setApprovalForAll}.
476      * - If `to` refers to a smart contract, it must implement
477      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
478      *
479      * Emits a {Transfer} event.
480      */
481     function safeTransferFrom(
482         address from,
483         address to,
484         uint256 tokenId,
485         bytes calldata data
486     ) external payable;
487 
488     /**
489      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external payable;
496 
497     /**
498      * @dev Transfers `tokenId` from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
501      * whenever possible.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token
509      * by either {approve} or {setApprovalForAll}.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external payable;
518 
519     /**
520      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
521      * The approval is cleared when the token is transferred.
522      *
523      * Only a single account can be approved at a time, so approving the
524      * zero address clears previous approvals.
525      *
526      * Requirements:
527      *
528      * - The caller must own the token or be an approved operator.
529      * - `tokenId` must exist.
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address to, uint256 tokenId) external payable;
534 
535     /**
536      * @dev Approve or remove `operator` as an operator for the caller.
537      * Operators can call {transferFrom} or {safeTransferFrom}
538      * for any token owned by the caller.
539      *
540      * Requirements:
541      *
542      * - The `operator` cannot be the caller.
543      *
544      * Emits an {ApprovalForAll} event.
545      */
546     function setApprovalForAll(address operator, bool _approved) external;
547 
548     /**
549      * @dev Returns the account approved for `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function getApproved(uint256 tokenId) external view returns (address operator);
556 
557     /**
558      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
559      *
560      * See {setApprovalForAll}.
561      */
562     function isApprovedForAll(address owner, address operator) external view returns (bool);
563 
564     // =============================================================
565     //                        IERC721Metadata
566     // =============================================================
567 
568     /**
569      * @dev Returns the token collection name.
570      */
571     function name() external view returns (string memory);
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() external view returns (string memory);
577 
578     /**
579      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
580      */
581     function tokenURI(uint256 tokenId) external view returns (string memory);
582 
583     // =============================================================
584     //                           IERC2309
585     // =============================================================
586 
587     /**
588      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
589      * (inclusive) is transferred from `from` to `to`, as defined in the
590      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
591      *
592      * See {_mintERC2309} for more details.
593      */
594     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
595 }
596 
597 // File: erc721a/contracts/ERC721A.sol
598 
599 
600 // ERC721A Contracts v4.2.3
601 // Creator: Chiru Labs
602 
603 pragma solidity ^0.8.4;
604 
605 
606 /**
607  * @dev Interface of ERC721 token receiver.
608  */
609 interface ERC721A__IERC721Receiver {
610     function onERC721Received(
611         address operator,
612         address from,
613         uint256 tokenId,
614         bytes calldata data
615     ) external returns (bytes4);
616 }
617 
618 /**
619  * @title ERC721A
620  *
621  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
622  * Non-Fungible Token Standard, including the Metadata extension.
623  * Optimized for lower gas during batch mints.
624  *
625  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
626  * starting from `_startTokenId()`.
627  *
628  * Assumptions:
629  *
630  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
631  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
632  */
633 contract ERC721A is IERC721A {
634     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
635     struct TokenApprovalRef {
636         address value;
637     }
638 
639     // =============================================================
640     //                           CONSTANTS
641     // =============================================================
642 
643     // Mask of an entry in packed address data.
644     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
645 
646     // The bit position of `numberMinted` in packed address data.
647     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
648 
649     // The bit position of `numberBurned` in packed address data.
650     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
651 
652     // The bit position of `aux` in packed address data.
653     uint256 private constant _BITPOS_AUX = 192;
654 
655     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
656     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
657 
658     // The bit position of `startTimestamp` in packed ownership.
659     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
660 
661     // The bit mask of the `burned` bit in packed ownership.
662     uint256 private constant _BITMASK_BURNED = 1 << 224;
663 
664     // The bit position of the `nextInitialized` bit in packed ownership.
665     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
666 
667     // The bit mask of the `nextInitialized` bit in packed ownership.
668     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
669 
670     // The bit position of `extraData` in packed ownership.
671     uint256 private constant _BITPOS_EXTRA_DATA = 232;
672 
673     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
674     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
675 
676     // The mask of the lower 160 bits for addresses.
677     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
678 
679     // The maximum `quantity` that can be minted with {_mintERC2309}.
680     // This limit is to prevent overflows on the address data entries.
681     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
682     // is required to cause an overflow, which is unrealistic.
683     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
684 
685     // The `Transfer` event signature is given by:
686     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
687     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
688         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
689 
690     // =============================================================
691     //                            STORAGE
692     // =============================================================
693 
694     // The next token ID to be minted.
695     uint256 private _currentIndex;
696 
697     // The number of tokens burned.
698     uint256 private _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned.
708     // See {_packedOwnershipOf} implementation for details.
709     //
710     // Bits Layout:
711     // - [0..159]   `addr`
712     // - [160..223] `startTimestamp`
713     // - [224]      `burned`
714     // - [225]      `nextInitialized`
715     // - [232..255] `extraData`
716     mapping(uint256 => uint256) private _packedOwnerships;
717 
718     // Mapping owner address to address data.
719     //
720     // Bits Layout:
721     // - [0..63]    `balance`
722     // - [64..127]  `numberMinted`
723     // - [128..191] `numberBurned`
724     // - [192..255] `aux`
725     mapping(address => uint256) private _packedAddressData;
726 
727     // Mapping from token ID to approved address.
728     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
729 
730     // Mapping from owner to operator approvals
731     mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733     // =============================================================
734     //                          CONSTRUCTOR
735     // =============================================================
736 
737     constructor(string memory name_, string memory symbol_) {
738         _name = name_;
739         _symbol = symbol_;
740         _currentIndex = _startTokenId();
741     }
742 
743     // =============================================================
744     //                   TOKEN COUNTING OPERATIONS
745     // =============================================================
746 
747     /**
748      * @dev Returns the starting token ID.
749      * To change the starting token ID, please override this function.
750      */
751     function _startTokenId() internal view virtual returns (uint256) {
752         return 0;
753     }
754 
755     /**
756      * @dev Returns the next token ID to be minted.
757      */
758     function _nextTokenId() internal view virtual returns (uint256) {
759         return _currentIndex;
760     }
761 
762     /**
763      * @dev Returns the total number of tokens in existence.
764      * Burned tokens will reduce the count.
765      * To get the total number of tokens minted, please see {_totalMinted}.
766      */
767     function totalSupply() public view virtual override returns (uint256) {
768         // Counter underflow is impossible as _burnCounter cannot be incremented
769         // more than `_currentIndex - _startTokenId()` times.
770         unchecked {
771             return _currentIndex - _burnCounter - _startTokenId();
772         }
773     }
774 
775     /**
776      * @dev Returns the total amount of tokens minted in the contract.
777      */
778     function _totalMinted() internal view virtual returns (uint256) {
779         // Counter underflow is impossible as `_currentIndex` does not decrement,
780         // and it is initialized to `_startTokenId()`.
781         unchecked {
782             return _currentIndex - _startTokenId();
783         }
784     }
785 
786     /**
787      * @dev Returns the total number of tokens burned.
788      */
789     function _totalBurned() internal view virtual returns (uint256) {
790         return _burnCounter;
791     }
792 
793     // =============================================================
794     //                    ADDRESS DATA OPERATIONS
795     // =============================================================
796 
797     /**
798      * @dev Returns the number of tokens in `owner`'s account.
799      */
800     function balanceOf(address owner) public view virtual override returns (uint256) {
801         if (owner == address(0)) revert BalanceQueryForZeroAddress();
802         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
803     }
804 
805     /**
806      * Returns the number of tokens minted by `owner`.
807      */
808     function _numberMinted(address owner) internal view returns (uint256) {
809         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
810     }
811 
812     /**
813      * Returns the number of tokens burned by or on behalf of `owner`.
814      */
815     function _numberBurned(address owner) internal view returns (uint256) {
816         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
817     }
818 
819     /**
820      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
821      */
822     function _getAux(address owner) internal view returns (uint64) {
823         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
824     }
825 
826     /**
827      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
828      * If there are multiple variables, please pack them into a uint64.
829      */
830     function _setAux(address owner, uint64 aux) internal virtual {
831         uint256 packed = _packedAddressData[owner];
832         uint256 auxCasted;
833         // Cast `aux` with assembly to avoid redundant masking.
834         assembly {
835             auxCasted := aux
836         }
837         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
838         _packedAddressData[owner] = packed;
839     }
840 
841     // =============================================================
842     //                            IERC165
843     // =============================================================
844 
845     /**
846      * @dev Returns true if this contract implements the interface defined by
847      * `interfaceId`. See the corresponding
848      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
849      * to learn more about how these ids are created.
850      *
851      * This function call must use less than 30000 gas.
852      */
853     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
854         // The interface IDs are constants representing the first 4 bytes
855         // of the XOR of all function selectors in the interface.
856         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
857         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
858         return
859             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
860             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
861             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
862     }
863 
864     // =============================================================
865     //                        IERC721Metadata
866     // =============================================================
867 
868     /**
869      * @dev Returns the token collection name.
870      */
871     function name() public view virtual override returns (string memory) {
872         return _name;
873     }
874 
875     /**
876      * @dev Returns the token collection symbol.
877      */
878     function symbol() public view virtual override returns (string memory) {
879         return _symbol;
880     }
881 
882     /**
883      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
884      */
885     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
886         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
887 
888         string memory baseURI = _baseURI();
889         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
890     }
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, it can be overridden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return '';
899     }
900 
901     // =============================================================
902     //                     OWNERSHIPS OPERATIONS
903     // =============================================================
904 
905     /**
906      * @dev Returns the owner of the `tokenId` token.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
913         return address(uint160(_packedOwnershipOf(tokenId)));
914     }
915 
916     /**
917      * @dev Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around over time.
919      */
920     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
921         return _unpackedOwnership(_packedOwnershipOf(tokenId));
922     }
923 
924     /**
925      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
926      */
927     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
928         return _unpackedOwnership(_packedOwnerships[index]);
929     }
930 
931     /**
932      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
933      */
934     function _initializeOwnershipAt(uint256 index) internal virtual {
935         if (_packedOwnerships[index] == 0) {
936             _packedOwnerships[index] = _packedOwnershipOf(index);
937         }
938     }
939 
940     /**
941      * Returns the packed ownership data of `tokenId`.
942      */
943     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
944         uint256 curr = tokenId;
945 
946         unchecked {
947             if (_startTokenId() <= curr)
948                 if (curr < _currentIndex) {
949                     uint256 packed = _packedOwnerships[curr];
950                     // If not burned.
951                     if (packed & _BITMASK_BURNED == 0) {
952                         // Invariant:
953                         // There will always be an initialized ownership slot
954                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
955                         // before an unintialized ownership slot
956                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
957                         // Hence, `curr` will not underflow.
958                         //
959                         // We can directly compare the packed value.
960                         // If the address is zero, packed will be zero.
961                         while (packed == 0) {
962                             packed = _packedOwnerships[--curr];
963                         }
964                         return packed;
965                     }
966                 }
967         }
968         revert OwnerQueryForNonexistentToken();
969     }
970 
971     /**
972      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
973      */
974     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
975         ownership.addr = address(uint160(packed));
976         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
977         ownership.burned = packed & _BITMASK_BURNED != 0;
978         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
979     }
980 
981     /**
982      * @dev Packs ownership data into a single uint256.
983      */
984     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
985         assembly {
986             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
987             owner := and(owner, _BITMASK_ADDRESS)
988             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
989             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
990         }
991     }
992 
993     /**
994      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
995      */
996     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
997         // For branchless setting of the `nextInitialized` flag.
998         assembly {
999             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1000             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1001         }
1002     }
1003 
1004     // =============================================================
1005     //                      APPROVAL OPERATIONS
1006     // =============================================================
1007 
1008     /**
1009      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1010      * The approval is cleared when the token is transferred.
1011      *
1012      * Only a single account can be approved at a time, so approving the
1013      * zero address clears previous approvals.
1014      *
1015      * Requirements:
1016      *
1017      * - The caller must own the token or be an approved operator.
1018      * - `tokenId` must exist.
1019      *
1020      * Emits an {Approval} event.
1021      */
1022     function approve(address to, uint256 tokenId) public payable virtual override {
1023         address owner = ownerOf(tokenId);
1024 
1025         if (_msgSenderERC721A() != owner)
1026             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1027                 revert ApprovalCallerNotOwnerNorApproved();
1028             }
1029 
1030         _tokenApprovals[tokenId].value = to;
1031         emit Approval(owner, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Returns the account approved for `tokenId` token.
1036      *
1037      * Requirements:
1038      *
1039      * - `tokenId` must exist.
1040      */
1041     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1042         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1043 
1044         return _tokenApprovals[tokenId].value;
1045     }
1046 
1047     /**
1048      * @dev Approve or remove `operator` as an operator for the caller.
1049      * Operators can call {transferFrom} or {safeTransferFrom}
1050      * for any token owned by the caller.
1051      *
1052      * Requirements:
1053      *
1054      * - The `operator` cannot be the caller.
1055      *
1056      * Emits an {ApprovalForAll} event.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public virtual override {
1059         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1060         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1061     }
1062 
1063     /**
1064      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1065      *
1066      * See {setApprovalForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev Returns whether `tokenId` exists.
1074      *
1075      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1076      *
1077      * Tokens start existing when they are minted. See {_mint}.
1078      */
1079     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1080         return
1081             _startTokenId() <= tokenId &&
1082             tokenId < _currentIndex && // If within bounds,
1083             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1084     }
1085 
1086     /**
1087      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1088      */
1089     function _isSenderApprovedOrOwner(
1090         address approvedAddress,
1091         address owner,
1092         address msgSender
1093     ) private pure returns (bool result) {
1094         assembly {
1095             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1096             owner := and(owner, _BITMASK_ADDRESS)
1097             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1098             msgSender := and(msgSender, _BITMASK_ADDRESS)
1099             // `msgSender == owner || msgSender == approvedAddress`.
1100             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1106      */
1107     function _getApprovedSlotAndAddress(uint256 tokenId)
1108         private
1109         view
1110         returns (uint256 approvedAddressSlot, address approvedAddress)
1111     {
1112         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1113         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1114         assembly {
1115             approvedAddressSlot := tokenApproval.slot
1116             approvedAddress := sload(approvedAddressSlot)
1117         }
1118     }
1119 
1120     // =============================================================
1121     //                      TRANSFER OPERATIONS
1122     // =============================================================
1123 
1124     /**
1125      * @dev Transfers `tokenId` from `from` to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must be owned by `from`.
1132      * - If the caller is not `from`, it must be approved to move this token
1133      * by either {approve} or {setApprovalForAll}.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function transferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) public payable virtual override {
1142         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1143 
1144         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1145 
1146         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1147 
1148         // The nested ifs save around 20+ gas over a compound boolean condition.
1149         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1150             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1151 
1152         if (to == address(0)) revert TransferToZeroAddress();
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner.
1157         assembly {
1158             if approvedAddress {
1159                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1160                 sstore(approvedAddressSlot, 0)
1161             }
1162         }
1163 
1164         // Underflow of the sender's balance is impossible because we check for
1165         // ownership above and the recipient's balance can't realistically overflow.
1166         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1167         unchecked {
1168             // We can directly increment and decrement the balances.
1169             --_packedAddressData[from]; // Updates: `balance -= 1`.
1170             ++_packedAddressData[to]; // Updates: `balance += 1`.
1171 
1172             // Updates:
1173             // - `address` to the next owner.
1174             // - `startTimestamp` to the timestamp of transfering.
1175             // - `burned` to `false`.
1176             // - `nextInitialized` to `true`.
1177             _packedOwnerships[tokenId] = _packOwnershipData(
1178                 to,
1179                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1180             );
1181 
1182             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1183             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1184                 uint256 nextTokenId = tokenId + 1;
1185                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1186                 if (_packedOwnerships[nextTokenId] == 0) {
1187                     // If the next slot is within bounds.
1188                     if (nextTokenId != _currentIndex) {
1189                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1190                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1191                     }
1192                 }
1193             }
1194         }
1195 
1196         emit Transfer(from, to, tokenId);
1197         _afterTokenTransfers(from, to, tokenId, 1);
1198     }
1199 
1200     /**
1201      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1202      */
1203     function safeTransferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) public payable virtual override {
1208         safeTransferFrom(from, to, tokenId, '');
1209     }
1210 
1211     /**
1212      * @dev Safely transfers `tokenId` token from `from` to `to`.
1213      *
1214      * Requirements:
1215      *
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must exist and be owned by `from`.
1219      * - If the caller is not `from`, it must be approved to move this token
1220      * by either {approve} or {setApprovalForAll}.
1221      * - If `to` refers to a smart contract, it must implement
1222      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) public payable virtual override {
1232         transferFrom(from, to, tokenId);
1233         if (to.code.length != 0)
1234             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1235                 revert TransferToNonERC721ReceiverImplementer();
1236             }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token IDs
1241      * are about to be transferred. This includes minting.
1242      * And also called before burning one token.
1243      *
1244      * `startTokenId` - the first token ID to be transferred.
1245      * `quantity` - the amount to be transferred.
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` will be minted for `to`.
1252      * - When `to` is zero, `tokenId` will be burned by `from`.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _beforeTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 
1262     /**
1263      * @dev Hook that is called after a set of serially-ordered token IDs
1264      * have been transferred. This includes minting.
1265      * And also called after one token has been burned.
1266      *
1267      * `startTokenId` - the first token ID to be transferred.
1268      * `quantity` - the amount to be transferred.
1269      *
1270      * Calling conditions:
1271      *
1272      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1273      * transferred to `to`.
1274      * - When `from` is zero, `tokenId` has been minted for `to`.
1275      * - When `to` is zero, `tokenId` has been burned by `from`.
1276      * - `from` and `to` are never both zero.
1277      */
1278     function _afterTokenTransfers(
1279         address from,
1280         address to,
1281         uint256 startTokenId,
1282         uint256 quantity
1283     ) internal virtual {}
1284 
1285     /**
1286      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1287      *
1288      * `from` - Previous owner of the given token ID.
1289      * `to` - Target address that will receive the token.
1290      * `tokenId` - Token ID to be transferred.
1291      * `_data` - Optional data to send along with the call.
1292      *
1293      * Returns whether the call correctly returned the expected magic value.
1294      */
1295     function _checkContractOnERC721Received(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) private returns (bool) {
1301         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1302             bytes4 retval
1303         ) {
1304             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1305         } catch (bytes memory reason) {
1306             if (reason.length == 0) {
1307                 revert TransferToNonERC721ReceiverImplementer();
1308             } else {
1309                 assembly {
1310                     revert(add(32, reason), mload(reason))
1311                 }
1312             }
1313         }
1314     }
1315 
1316     // =============================================================
1317     //                        MINT OPERATIONS
1318     // =============================================================
1319 
1320     /**
1321      * @dev Mints `quantity` tokens and transfers them to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `quantity` must be greater than 0.
1327      *
1328      * Emits a {Transfer} event for each mint.
1329      */
1330     function _mint(address to, uint256 quantity) internal virtual {
1331         uint256 startTokenId = _currentIndex;
1332         if (quantity == 0) revert MintZeroQuantity();
1333 
1334         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1335 
1336         // Overflows are incredibly unrealistic.
1337         // `balance` and `numberMinted` have a maximum limit of 2**64.
1338         // `tokenId` has a maximum limit of 2**256.
1339         unchecked {
1340             // Updates:
1341             // - `balance += quantity`.
1342             // - `numberMinted += quantity`.
1343             //
1344             // We can directly add to the `balance` and `numberMinted`.
1345             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1346 
1347             // Updates:
1348             // - `address` to the owner.
1349             // - `startTimestamp` to the timestamp of minting.
1350             // - `burned` to `false`.
1351             // - `nextInitialized` to `quantity == 1`.
1352             _packedOwnerships[startTokenId] = _packOwnershipData(
1353                 to,
1354                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1355             );
1356 
1357             uint256 toMasked;
1358             uint256 end = startTokenId + quantity;
1359 
1360             // Use assembly to loop and emit the `Transfer` event for gas savings.
1361             // The duplicated `log4` removes an extra check and reduces stack juggling.
1362             // The assembly, together with the surrounding Solidity code, have been
1363             // delicately arranged to nudge the compiler into producing optimized opcodes.
1364             assembly {
1365                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1366                 toMasked := and(to, _BITMASK_ADDRESS)
1367                 // Emit the `Transfer` event.
1368                 log4(
1369                     0, // Start of data (0, since no data).
1370                     0, // End of data (0, since no data).
1371                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1372                     0, // `address(0)`.
1373                     toMasked, // `to`.
1374                     startTokenId // `tokenId`.
1375                 )
1376 
1377                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1378                 // that overflows uint256 will make the loop run out of gas.
1379                 // The compiler will optimize the `iszero` away for performance.
1380                 for {
1381                     let tokenId := add(startTokenId, 1)
1382                 } iszero(eq(tokenId, end)) {
1383                     tokenId := add(tokenId, 1)
1384                 } {
1385                     // Emit the `Transfer` event. Similar to above.
1386                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1387                 }
1388             }
1389             if (toMasked == 0) revert MintToZeroAddress();
1390 
1391             _currentIndex = end;
1392         }
1393         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1394     }
1395 
1396     /**
1397      * @dev Mints `quantity` tokens and transfers them to `to`.
1398      *
1399      * This function is intended for efficient minting only during contract creation.
1400      *
1401      * It emits only one {ConsecutiveTransfer} as defined in
1402      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1403      * instead of a sequence of {Transfer} event(s).
1404      *
1405      * Calling this function outside of contract creation WILL make your contract
1406      * non-compliant with the ERC721 standard.
1407      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1408      * {ConsecutiveTransfer} event is only permissible during contract creation.
1409      *
1410      * Requirements:
1411      *
1412      * - `to` cannot be the zero address.
1413      * - `quantity` must be greater than 0.
1414      *
1415      * Emits a {ConsecutiveTransfer} event.
1416      */
1417     function _mintERC2309(address to, uint256 quantity) internal virtual {
1418         uint256 startTokenId = _currentIndex;
1419         if (to == address(0)) revert MintToZeroAddress();
1420         if (quantity == 0) revert MintZeroQuantity();
1421         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1422 
1423         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1424 
1425         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1426         unchecked {
1427             // Updates:
1428             // - `balance += quantity`.
1429             // - `numberMinted += quantity`.
1430             //
1431             // We can directly add to the `balance` and `numberMinted`.
1432             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1433 
1434             // Updates:
1435             // - `address` to the owner.
1436             // - `startTimestamp` to the timestamp of minting.
1437             // - `burned` to `false`.
1438             // - `nextInitialized` to `quantity == 1`.
1439             _packedOwnerships[startTokenId] = _packOwnershipData(
1440                 to,
1441                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1442             );
1443 
1444             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1445 
1446             _currentIndex = startTokenId + quantity;
1447         }
1448         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1449     }
1450 
1451     /**
1452      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1453      *
1454      * Requirements:
1455      *
1456      * - If `to` refers to a smart contract, it must implement
1457      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1458      * - `quantity` must be greater than 0.
1459      *
1460      * See {_mint}.
1461      *
1462      * Emits a {Transfer} event for each mint.
1463      */
1464     function _safeMint(
1465         address to,
1466         uint256 quantity,
1467         bytes memory _data
1468     ) internal virtual {
1469         _mint(to, quantity);
1470 
1471         unchecked {
1472             if (to.code.length != 0) {
1473                 uint256 end = _currentIndex;
1474                 uint256 index = end - quantity;
1475                 do {
1476                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1477                         revert TransferToNonERC721ReceiverImplementer();
1478                     }
1479                 } while (index < end);
1480                 // Reentrancy protection.
1481                 if (_currentIndex != end) revert();
1482             }
1483         }
1484     }
1485 
1486     /**
1487      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1488      */
1489     function _safeMint(address to, uint256 quantity) internal virtual {
1490         _safeMint(to, quantity, '');
1491     }
1492 
1493     // =============================================================
1494     //                        BURN OPERATIONS
1495     // =============================================================
1496 
1497     /**
1498      * @dev Equivalent to `_burn(tokenId, false)`.
1499      */
1500     function _burn(uint256 tokenId) internal virtual {
1501         _burn(tokenId, false);
1502     }
1503 
1504     /**
1505      * @dev Destroys `tokenId`.
1506      * The approval is cleared when the token is burned.
1507      *
1508      * Requirements:
1509      *
1510      * - `tokenId` must exist.
1511      *
1512      * Emits a {Transfer} event.
1513      */
1514     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1515         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1516 
1517         address from = address(uint160(prevOwnershipPacked));
1518 
1519         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1520 
1521         if (approvalCheck) {
1522             // The nested ifs save around 20+ gas over a compound boolean condition.
1523             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1524                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1525         }
1526 
1527         _beforeTokenTransfers(from, address(0), tokenId, 1);
1528 
1529         // Clear approvals from the previous owner.
1530         assembly {
1531             if approvedAddress {
1532                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1533                 sstore(approvedAddressSlot, 0)
1534             }
1535         }
1536 
1537         // Underflow of the sender's balance is impossible because we check for
1538         // ownership above and the recipient's balance can't realistically overflow.
1539         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1540         unchecked {
1541             // Updates:
1542             // - `balance -= 1`.
1543             // - `numberBurned += 1`.
1544             //
1545             // We can directly decrement the balance, and increment the number burned.
1546             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1547             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1548 
1549             // Updates:
1550             // - `address` to the last owner.
1551             // - `startTimestamp` to the timestamp of burning.
1552             // - `burned` to `true`.
1553             // - `nextInitialized` to `true`.
1554             _packedOwnerships[tokenId] = _packOwnershipData(
1555                 from,
1556                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1557             );
1558 
1559             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1560             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1561                 uint256 nextTokenId = tokenId + 1;
1562                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1563                 if (_packedOwnerships[nextTokenId] == 0) {
1564                     // If the next slot is within bounds.
1565                     if (nextTokenId != _currentIndex) {
1566                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1567                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1568                     }
1569                 }
1570             }
1571         }
1572 
1573         emit Transfer(from, address(0), tokenId);
1574         _afterTokenTransfers(from, address(0), tokenId, 1);
1575 
1576         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1577         unchecked {
1578             _burnCounter++;
1579         }
1580     }
1581 
1582     // =============================================================
1583     //                     EXTRA DATA OPERATIONS
1584     // =============================================================
1585 
1586     /**
1587      * @dev Directly sets the extra data for the ownership data `index`.
1588      */
1589     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1590         uint256 packed = _packedOwnerships[index];
1591         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1592         uint256 extraDataCasted;
1593         // Cast `extraData` with assembly to avoid redundant masking.
1594         assembly {
1595             extraDataCasted := extraData
1596         }
1597         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1598         _packedOwnerships[index] = packed;
1599     }
1600 
1601     /**
1602      * @dev Called during each token transfer to set the 24bit `extraData` field.
1603      * Intended to be overridden by the cosumer contract.
1604      *
1605      * `previousExtraData` - the value of `extraData` before transfer.
1606      *
1607      * Calling conditions:
1608      *
1609      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1610      * transferred to `to`.
1611      * - When `from` is zero, `tokenId` will be minted for `to`.
1612      * - When `to` is zero, `tokenId` will be burned by `from`.
1613      * - `from` and `to` are never both zero.
1614      */
1615     function _extraData(
1616         address from,
1617         address to,
1618         uint24 previousExtraData
1619     ) internal view virtual returns (uint24) {}
1620 
1621     /**
1622      * @dev Returns the next extra data for the packed ownership data.
1623      * The returned result is shifted into position.
1624      */
1625     function _nextExtraData(
1626         address from,
1627         address to,
1628         uint256 prevOwnershipPacked
1629     ) private view returns (uint256) {
1630         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1631         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1632     }
1633 
1634     // =============================================================
1635     //                       OTHER OPERATIONS
1636     // =============================================================
1637 
1638     /**
1639      * @dev Returns the message sender (defaults to `msg.sender`).
1640      *
1641      * If you are writing GSN compatible contracts, you need to override this function.
1642      */
1643     function _msgSenderERC721A() internal view virtual returns (address) {
1644         return msg.sender;
1645     }
1646 
1647     /**
1648      * @dev Converts a uint256 to its ASCII string decimal representation.
1649      */
1650     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1651         assembly {
1652             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1653             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1654             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1655             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1656             let m := add(mload(0x40), 0xa0)
1657             // Update the free memory pointer to allocate.
1658             mstore(0x40, m)
1659             // Assign the `str` to the end.
1660             str := sub(m, 0x20)
1661             // Zeroize the slot after the string.
1662             mstore(str, 0)
1663 
1664             // Cache the end of the memory to calculate the length later.
1665             let end := str
1666 
1667             // We write the string from rightmost digit to leftmost digit.
1668             // The following is essentially a do-while loop that also handles the zero case.
1669             // prettier-ignore
1670             for { let temp := value } 1 {} {
1671                 str := sub(str, 1)
1672                 // Write the character to the pointer.
1673                 // The ASCII index of the '0' character is 48.
1674                 mstore8(str, add(48, mod(temp, 10)))
1675                 // Keep dividing `temp` until zero.
1676                 temp := div(temp, 10)
1677                 // prettier-ignore
1678                 if iszero(temp) { break }
1679             }
1680 
1681             let length := sub(end, str)
1682             // Move the pointer 32 bytes leftwards to make room for the length.
1683             str := sub(str, 0x20)
1684             // Store the length.
1685             mstore(str, length)
1686         }
1687     }
1688 }
1689 
1690 // File: Lucky.sol
1691 
1692 
1693 pragma solidity ^0.8.4;
1694 
1695 
1696 
1697 
1698 contract LuckyFrensNFT is ERC721A, ERC2981, Ownable {
1699 
1700     string public baseURI;
1701     uint256 public MAX_SUPPLY = 5888;
1702     uint256 public MAX_WALLET_MINT = 5;
1703     uint256 public MINT_PRICE = 0.02 ether;
1704 
1705     constructor(string memory _newBaseURI) ERC721A("Lucky Frens", "LF") {
1706         baseURI = _newBaseURI;
1707         setRoyaltyInfo(msg.sender, 750);
1708         mintNFTs(100);
1709     }
1710 
1711     function _startTokenId() internal pure override returns (uint256) {
1712         return 1;
1713     }
1714 
1715     function _baseURI() internal view override returns (string memory) {
1716         return baseURI;
1717     }
1718 
1719     function setBaseURI (string memory _newBaseURI) public onlyOwner {
1720         baseURI = _newBaseURI;
1721     }
1722 
1723 
1724     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1725         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1726 
1727         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), '.json')) : '';
1728     }
1729 
1730     function setMintPrice (uint256 _mintPrice) external onlyOwner {
1731         MINT_PRICE = _mintPrice;
1732     }
1733 
1734     function setMaxMintPerWallet (uint256 _maxMintNum) external onlyOwner {
1735         MAX_WALLET_MINT = _maxMintNum;
1736     }
1737 
1738     function mintNFTs(uint256 quantity) public payable {
1739 
1740         require(quantity > 0, "Quantity cannot be zero");
1741         require(_totalMinted() + quantity <= MAX_SUPPLY, 'All Minted');
1742 
1743         if (msg.sender != owner()) {
1744             require(balanceOf(msg.sender) + quantity  <= MAX_WALLET_MINT, 'Can only mint 5 NFTs per wallet');
1745             require(msg.value >= MINT_PRICE * quantity, 'Not enough ether');
1746         }
1747 
1748         _mint(msg.sender, quantity);
1749     }
1750 
1751     function supportsInterface(
1752         bytes4 interfaceId
1753     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
1754         // Supports the following `interfaceId`s:
1755         // - IERC165: 0x01ffc9a7
1756         // - IERC721: 0x80ac58cd
1757         // - IERC721Metadata: 0x5b5e139f
1758         // - IERC2981: 0x2a55205a
1759         return 
1760             ERC721A.supportsInterface(interfaceId) || 
1761             ERC2981.supportsInterface(interfaceId);
1762     }
1763 
1764     function setRoyaltyInfo(address _receiver, uint96 _royaltyFees) public onlyOwner {
1765         _setDefaultRoyalty(_receiver, _royaltyFees); // in bips
1766     }
1767 
1768     function withdraw() public onlyOwner {
1769         uint balance = address(this).balance;
1770 
1771         require(balance > 0, 'Balance is 0');
1772 
1773         (bool sent,) = payable(owner()).call{value: balance}("");
1774         require(sent, "Failed to send Ether");
1775     }
1776 
1777 }