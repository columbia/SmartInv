1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC165 standard, as defined in the
122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
123  *
124  * Implementers can declare support of contract interfaces, which can then be
125  * queried by others ({ERC165Checker}).
126  *
127  * For an implementation, see {ERC165}.
128  */
129 interface IERC165 {
130     /**
131      * @dev Returns true if this contract implements the interface defined by
132      * `interfaceId`. See the corresponding
133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
134      * to learn more about how these ids are created.
135      *
136      * This function call must use less than 30 000 gas.
137      */
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 /**
150  * @dev Implementation of the {IERC165} interface.
151  *
152  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
153  * for the additional interface id that will be supported. For example:
154  *
155  * ```solidity
156  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
157  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
158  * }
159  * ```
160  *
161  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
162  */
163 abstract contract ERC165 is IERC165 {
164     /**
165      * @dev See {IERC165-supportsInterface}.
166      */
167     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
168         return interfaceId == type(IERC165).interfaceId;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Interface for the NFT Royalty Standard.
182  *
183  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
184  * support for royalty payments across all NFT marketplaces and ecosystem participants.
185  *
186  * _Available since v4.5._
187  */
188 interface IERC2981 is IERC165 {
189     /**
190      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
191      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
192      */
193     function royaltyInfo(uint256 tokenId, uint256 salePrice)
194         external
195         view
196         returns (address receiver, uint256 royaltyAmount);
197 }
198 
199 // File: @openzeppelin/contracts/token/common/ERC2981.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 
208 /**
209  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
210  *
211  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
212  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
213  *
214  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
215  * fee is specified in basis points by default.
216  *
217  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
218  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
219  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
220  *
221  * _Available since v4.5._
222  */
223 abstract contract ERC2981 is IERC2981, ERC165 {
224     struct RoyaltyInfo {
225         address receiver;
226         uint96 royaltyFraction;
227     }
228 
229     RoyaltyInfo private _defaultRoyaltyInfo;
230     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
231 
232     /**
233      * @dev See {IERC165-supportsInterface}.
234      */
235     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
236         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
237     }
238 
239     /**
240      * @inheritdoc IERC2981
241      */
242     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
243         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
244 
245         if (royalty.receiver == address(0)) {
246             royalty = _defaultRoyaltyInfo;
247         }
248 
249         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
250 
251         return (royalty.receiver, royaltyAmount);
252     }
253 
254     /**
255      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
256      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
257      * override.
258      */
259     function _feeDenominator() internal pure virtual returns (uint96) {
260         return 10000;
261     }
262 
263     /**
264      * @dev Sets the royalty information that all ids in this contract will default to.
265      *
266      * Requirements:
267      *
268      * - `receiver` cannot be the zero address.
269      * - `feeNumerator` cannot be greater than the fee denominator.
270      */
271     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
272         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
273         require(receiver != address(0), "ERC2981: invalid receiver");
274 
275         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
276     }
277 
278     /**
279      * @dev Removes default royalty information.
280      */
281     function _deleteDefaultRoyalty() internal virtual {
282         delete _defaultRoyaltyInfo;
283     }
284 
285     /**
286      * @dev Sets the royalty information for a specific token id, overriding the global default.
287      *
288      * Requirements:
289      *
290      * - `receiver` cannot be the zero address.
291      * - `feeNumerator` cannot be greater than the fee denominator.
292      */
293     function _setTokenRoyalty(
294         uint256 tokenId,
295         address receiver,
296         uint96 feeNumerator
297     ) internal virtual {
298         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
299         require(receiver != address(0), "ERC2981: Invalid parameters");
300 
301         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
302     }
303 
304     /**
305      * @dev Resets royalty information for the token id back to the global default.
306      */
307     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
308         delete _tokenRoyaltyInfo[tokenId];
309     }
310 }
311 
312 // File: erc721a/contracts/IERC721A.sol
313 
314 
315 // ERC721A Contracts v4.1.0
316 // Creator: Chiru Labs
317 
318 pragma solidity ^0.8.4;
319 
320 /**
321  * @dev Interface of an ERC721A compliant contract.
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
335      * The caller cannot approve to their own address.
336      */
337     error ApproveToCaller();
338 
339     /**
340      * Cannot query the balance for the zero address.
341      */
342     error BalanceQueryForZeroAddress();
343 
344     /**
345      * Cannot mint to the zero address.
346      */
347     error MintToZeroAddress();
348 
349     /**
350      * The quantity of tokens minted must be more than zero.
351      */
352     error MintZeroQuantity();
353 
354     /**
355      * The token does not exist.
356      */
357     error OwnerQueryForNonexistentToken();
358 
359     /**
360      * The caller must own the token or be an approved operator.
361      */
362     error TransferCallerNotOwnerNorApproved();
363 
364     /**
365      * The token must be owned by `from`.
366      */
367     error TransferFromIncorrectOwner();
368 
369     /**
370      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
371      */
372     error TransferToNonERC721ReceiverImplementer();
373 
374     /**
375      * Cannot transfer to the zero address.
376      */
377     error TransferToZeroAddress();
378 
379     /**
380      * The token does not exist.
381      */
382     error URIQueryForNonexistentToken();
383 
384     /**
385      * The `quantity` minted with ERC2309 exceeds the safety limit.
386      */
387     error MintERC2309QuantityExceedsLimit();
388 
389     /**
390      * The `extraData` cannot be set on an unintialized ownership slot.
391      */
392     error OwnershipNotInitializedForExtraData();
393 
394     struct TokenOwnership {
395         // The address of the owner.
396         address addr;
397         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
398         uint64 startTimestamp;
399         // Whether the token has been burned.
400         bool burned;
401         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
402         uint24 extraData;
403     }
404 
405     /**
406      * @dev Returns the total amount of tokens stored by the contract.
407      *
408      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
409      */
410     function totalSupply() external view returns (uint256);
411 
412     // ==============================
413     //            IERC165
414     // ==============================
415 
416     /**
417      * @dev Returns true if this contract implements the interface defined by
418      * `interfaceId`. See the corresponding
419      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
420      * to learn more about how these ids are created.
421      *
422      * This function call must use less than 30 000 gas.
423      */
424     function supportsInterface(bytes4 interfaceId) external view returns (bool);
425 
426     // ==============================
427     //            IERC721
428     // ==============================
429 
430     /**
431      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
432      */
433     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
437      */
438     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
442      */
443     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
444 
445     /**
446      * @dev Returns the number of tokens in ``owner``'s account.
447      */
448     function balanceOf(address owner) external view returns (uint256 balance);
449 
450     /**
451      * @dev Returns the owner of the `tokenId` token.
452      *
453      * Requirements:
454      *
455      * - `tokenId` must exist.
456      */
457     function ownerOf(uint256 tokenId) external view returns (address owner);
458 
459     /**
460      * @dev Safely transfers `tokenId` token from `from` to `to`.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must exist and be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId,
476         bytes calldata data
477     ) external;
478 
479     /**
480      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
481      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
482      *
483      * Requirements:
484      *
485      * - `from` cannot be the zero address.
486      * - `to` cannot be the zero address.
487      * - `tokenId` token must exist and be owned by `from`.
488      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
489      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
490      *
491      * Emits a {Transfer} event.
492      */
493     function safeTransferFrom(
494         address from,
495         address to,
496         uint256 tokenId
497     ) external;
498 
499     /**
500      * @dev Transfers `tokenId` token from `from` to `to`.
501      *
502      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must be owned by `from`.
509      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     /**
520      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
521      * The approval is cleared when the token is transferred.
522      *
523      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
524      *
525      * Requirements:
526      *
527      * - The caller must own the token or be an approved operator.
528      * - `tokenId` must exist.
529      *
530      * Emits an {Approval} event.
531      */
532     function approve(address to, uint256 tokenId) external;
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns the account approved for `tokenId` token.
548      *
549      * Requirements:
550      *
551      * - `tokenId` must exist.
552      */
553     function getApproved(uint256 tokenId) external view returns (address operator);
554 
555     /**
556      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
557      *
558      * See {setApprovalForAll}
559      */
560     function isApprovedForAll(address owner, address operator) external view returns (bool);
561 
562     // ==============================
563     //        IERC721Metadata
564     // ==============================
565 
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() external view returns (string memory);
570 
571     /**
572      * @dev Returns the token collection symbol.
573      */
574     function symbol() external view returns (string memory);
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) external view returns (string memory);
580 
581     // ==============================
582     //            IERC2309
583     // ==============================
584 
585     /**
586      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
587      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
588      */
589     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
590 }
591 
592 // File: erc721a/contracts/ERC721A.sol
593 
594 
595 // ERC721A Contracts v4.1.0
596 // Creator: Chiru Labs
597 
598 pragma solidity ^0.8.4;
599 
600 
601 /**
602  * @dev ERC721 token receiver interface.
603  */
604 interface ERC721A__IERC721Receiver {
605     function onERC721Received(
606         address operator,
607         address from,
608         uint256 tokenId,
609         bytes calldata data
610     ) external returns (bytes4);
611 }
612 
613 /**
614  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
615  * including the Metadata extension. Built to optimize for lower gas during batch mints.
616  *
617  * Assumes serials are sequentially minted starting at `_startTokenId()`
618  * (defaults to 0, e.g. 0, 1, 2, 3..).
619  *
620  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
621  *
622  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
623  */
624 contract ERC721A is IERC721A {
625     // Mask of an entry in packed address data.
626     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
627 
628     // The bit position of `numberMinted` in packed address data.
629     uint256 private constant BITPOS_NUMBER_MINTED = 64;
630 
631     // The bit position of `numberBurned` in packed address data.
632     uint256 private constant BITPOS_NUMBER_BURNED = 128;
633 
634     // The bit position of `aux` in packed address data.
635     uint256 private constant BITPOS_AUX = 192;
636 
637     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
638     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
639 
640     // The bit position of `startTimestamp` in packed ownership.
641     uint256 private constant BITPOS_START_TIMESTAMP = 160;
642 
643     // The bit mask of the `burned` bit in packed ownership.
644     uint256 private constant BITMASK_BURNED = 1 << 224;
645 
646     // The bit position of the `nextInitialized` bit in packed ownership.
647     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
648 
649     // The bit mask of the `nextInitialized` bit in packed ownership.
650     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
651 
652     // The bit position of `extraData` in packed ownership.
653     uint256 private constant BITPOS_EXTRA_DATA = 232;
654 
655     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
656     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
657 
658     // The mask of the lower 160 bits for addresses.
659     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
660 
661     // The maximum `quantity` that can be minted with `_mintERC2309`.
662     // This limit is to prevent overflows on the address data entries.
663     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
664     // is required to cause an overflow, which is unrealistic.
665     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
666 
667     // The tokenId of the next token to be minted.
668     uint256 private _currentIndex;
669 
670     // The number of tokens burned.
671     uint256 private _burnCounter;
672 
673     // Token name
674     string private _name;
675 
676     // Token symbol
677     string private _symbol;
678 
679     // Mapping from token ID to ownership details
680     // An empty struct value does not necessarily mean the token is unowned.
681     // See `_packedOwnershipOf` implementation for details.
682     //
683     // Bits Layout:
684     // - [0..159]   `addr`
685     // - [160..223] `startTimestamp`
686     // - [224]      `burned`
687     // - [225]      `nextInitialized`
688     // - [232..255] `extraData`
689     mapping(uint256 => uint256) private _packedOwnerships;
690 
691     // Mapping owner address to address data.
692     //
693     // Bits Layout:
694     // - [0..63]    `balance`
695     // - [64..127]  `numberMinted`
696     // - [128..191] `numberBurned`
697     // - [192..255] `aux`
698     mapping(address => uint256) private _packedAddressData;
699 
700     // Mapping from token ID to approved address.
701     mapping(uint256 => address) private _tokenApprovals;
702 
703     // Mapping from owner to operator approvals
704     mapping(address => mapping(address => bool)) private _operatorApprovals;
705 
706     constructor(string memory name_, string memory symbol_) {
707         _name = name_;
708         _symbol = symbol_;
709         _currentIndex = _startTokenId();
710     }
711 
712     /**
713      * @dev Returns the starting token ID.
714      * To change the starting token ID, please override this function.
715      */
716     function _startTokenId() internal view virtual returns (uint256) {
717         return 0;
718     }
719 
720     /**
721      * @dev Returns the next token ID to be minted.
722      */
723     function _nextTokenId() internal view returns (uint256) {
724         return _currentIndex;
725     }
726 
727     /**
728      * @dev Returns the total number of tokens in existence.
729      * Burned tokens will reduce the count.
730      * To get the total number of tokens minted, please see `_totalMinted`.
731      */
732     function totalSupply() public view override returns (uint256) {
733         // Counter underflow is impossible as _burnCounter cannot be incremented
734         // more than `_currentIndex - _startTokenId()` times.
735         unchecked {
736             return _currentIndex - _burnCounter - _startTokenId();
737         }
738     }
739 
740     /**
741      * @dev Returns the total amount of tokens minted in the contract.
742      */
743     function _totalMinted() internal view returns (uint256) {
744         // Counter underflow is impossible as _currentIndex does not decrement,
745         // and it is initialized to `_startTokenId()`
746         unchecked {
747             return _currentIndex - _startTokenId();
748         }
749     }
750 
751     /**
752      * @dev Returns the total number of tokens burned.
753      */
754     function _totalBurned() internal view returns (uint256) {
755         return _burnCounter;
756     }
757 
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
762         // The interface IDs are constants representing the first 4 bytes of the XOR of
763         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
764         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
765         return
766             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
767             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
768             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view override returns (uint256) {
775         if (owner == address(0)) revert BalanceQueryForZeroAddress();
776         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the number of tokens minted by `owner`.
781      */
782     function _numberMinted(address owner) internal view returns (uint256) {
783         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
784     }
785 
786     /**
787      * Returns the number of tokens burned by or on behalf of `owner`.
788      */
789     function _numberBurned(address owner) internal view returns (uint256) {
790         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
791     }
792 
793     /**
794      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
795      */
796     function _getAux(address owner) internal view returns (uint64) {
797         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
798     }
799 
800     /**
801      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
802      * If there are multiple variables, please pack them into a uint64.
803      */
804     function _setAux(address owner, uint64 aux) internal {
805         uint256 packed = _packedAddressData[owner];
806         uint256 auxCasted;
807         // Cast `aux` with assembly to avoid redundant masking.
808         assembly {
809             auxCasted := aux
810         }
811         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
812         _packedAddressData[owner] = packed;
813     }
814 
815     /**
816      * Returns the packed ownership data of `tokenId`.
817      */
818     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
819         uint256 curr = tokenId;
820 
821         unchecked {
822             if (_startTokenId() <= curr)
823                 if (curr < _currentIndex) {
824                     uint256 packed = _packedOwnerships[curr];
825                     // If not burned.
826                     if (packed & BITMASK_BURNED == 0) {
827                         // Invariant:
828                         // There will always be an ownership that has an address and is not burned
829                         // before an ownership that does not have an address and is not burned.
830                         // Hence, curr will not underflow.
831                         //
832                         // We can directly compare the packed value.
833                         // If the address is zero, packed is zero.
834                         while (packed == 0) {
835                             packed = _packedOwnerships[--curr];
836                         }
837                         return packed;
838                     }
839                 }
840         }
841         revert OwnerQueryForNonexistentToken();
842     }
843 
844     /**
845      * Returns the unpacked `TokenOwnership` struct from `packed`.
846      */
847     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
848         ownership.addr = address(uint160(packed));
849         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
850         ownership.burned = packed & BITMASK_BURNED != 0;
851         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
852     }
853 
854     /**
855      * Returns the unpacked `TokenOwnership` struct at `index`.
856      */
857     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
858         return _unpackedOwnership(_packedOwnerships[index]);
859     }
860 
861     /**
862      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
863      */
864     function _initializeOwnershipAt(uint256 index) internal {
865         if (_packedOwnerships[index] == 0) {
866             _packedOwnerships[index] = _packedOwnershipOf(index);
867         }
868     }
869 
870     /**
871      * Gas spent here starts off proportional to the maximum mint batch size.
872      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
873      */
874     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
875         return _unpackedOwnership(_packedOwnershipOf(tokenId));
876     }
877 
878     /**
879      * @dev Packs ownership data into a single uint256.
880      */
881     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
882         assembly {
883             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
884             owner := and(owner, BITMASK_ADDRESS)
885             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
886             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
887         }
888     }
889 
890     /**
891      * @dev See {IERC721-ownerOf}.
892      */
893     function ownerOf(uint256 tokenId) public view override returns (address) {
894         return address(uint160(_packedOwnershipOf(tokenId)));
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-name}.
899      */
900     function name() public view virtual override returns (string memory) {
901         return _name;
902     }
903 
904     /**
905      * @dev See {IERC721Metadata-symbol}.
906      */
907     function symbol() public view virtual override returns (string memory) {
908         return _symbol;
909     }
910 
911     /**
912      * @dev See {IERC721Metadata-tokenURI}.
913      */
914     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
915         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
916 
917         string memory baseURI = _baseURI();
918         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
919     }
920 
921     /**
922      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
923      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
924      * by default, it can be overridden in child contracts.
925      */
926     function _baseURI() internal view virtual returns (string memory) {
927         return '';
928     }
929 
930     /**
931      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
932      */
933     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
934         // For branchless setting of the `nextInitialized` flag.
935         assembly {
936             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
937             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
938         }
939     }
940 
941     /**
942      * @dev See {IERC721-approve}.
943      */
944     function approve(address to, uint256 tokenId) public override {
945         address owner = ownerOf(tokenId);
946 
947         if (_msgSenderERC721A() != owner)
948             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
949                 revert ApprovalCallerNotOwnerNorApproved();
950             }
951 
952         _tokenApprovals[tokenId] = to;
953         emit Approval(owner, to, tokenId);
954     }
955 
956     /**
957      * @dev See {IERC721-getApproved}.
958      */
959     function getApproved(uint256 tokenId) public view override returns (address) {
960         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
961 
962         return _tokenApprovals[tokenId];
963     }
964 
965     /**
966      * @dev See {IERC721-setApprovalForAll}.
967      */
968     function setApprovalForAll(address operator, bool approved) public virtual override {
969         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
970 
971         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
972         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
973     }
974 
975     /**
976      * @dev See {IERC721-isApprovedForAll}.
977      */
978     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
979         return _operatorApprovals[owner][operator];
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         safeTransferFrom(from, to, tokenId, '');
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public virtual override {
1002         transferFrom(from, to, tokenId);
1003         if (to.code.length != 0)
1004             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1005                 revert TransferToNonERC721ReceiverImplementer();
1006             }
1007     }
1008 
1009     /**
1010      * @dev Returns whether `tokenId` exists.
1011      *
1012      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1013      *
1014      * Tokens start existing when they are minted (`_mint`),
1015      */
1016     function _exists(uint256 tokenId) internal view returns (bool) {
1017         return
1018             _startTokenId() <= tokenId &&
1019             tokenId < _currentIndex && // If within bounds,
1020             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1021     }
1022 
1023     /**
1024      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1025      */
1026     function _safeMint(address to, uint256 quantity) internal {
1027         _safeMint(to, quantity, '');
1028     }
1029 
1030     /**
1031      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - If `to` refers to a smart contract, it must implement
1036      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1037      * - `quantity` must be greater than 0.
1038      *
1039      * See {_mint}.
1040      *
1041      * Emits a {Transfer} event for each mint.
1042      */
1043     function _safeMint(
1044         address to,
1045         uint256 quantity,
1046         bytes memory _data
1047     ) internal {
1048         _mint(to, quantity);
1049 
1050         unchecked {
1051             if (to.code.length != 0) {
1052                 uint256 end = _currentIndex;
1053                 uint256 index = end - quantity;
1054                 do {
1055                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1056                         revert TransferToNonERC721ReceiverImplementer();
1057                     }
1058                 } while (index < end);
1059                 // Reentrancy protection.
1060                 if (_currentIndex != end) revert();
1061             }
1062         }
1063     }
1064 
1065     /**
1066      * @dev Mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event for each mint.
1074      */
1075     function _mint(address to, uint256 quantity) internal {
1076         uint256 startTokenId = _currentIndex;
1077         if (to == address(0)) revert MintToZeroAddress();
1078         if (quantity == 0) revert MintZeroQuantity();
1079 
1080         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1081 
1082         // Overflows are incredibly unrealistic.
1083         // `balance` and `numberMinted` have a maximum limit of 2**64.
1084         // `tokenId` has a maximum limit of 2**256.
1085         unchecked {
1086             // Updates:
1087             // - `balance += quantity`.
1088             // - `numberMinted += quantity`.
1089             //
1090             // We can directly add to the `balance` and `numberMinted`.
1091             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1092 
1093             // Updates:
1094             // - `address` to the owner.
1095             // - `startTimestamp` to the timestamp of minting.
1096             // - `burned` to `false`.
1097             // - `nextInitialized` to `quantity == 1`.
1098             _packedOwnerships[startTokenId] = _packOwnershipData(
1099                 to,
1100                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1101             );
1102 
1103             uint256 tokenId = startTokenId;
1104             uint256 end = startTokenId + quantity;
1105             do {
1106                 emit Transfer(address(0), to, tokenId++);
1107             } while (tokenId < end);
1108 
1109             _currentIndex = end;
1110         }
1111         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1112     }
1113 
1114     /**
1115      * @dev Mints `quantity` tokens and transfers them to `to`.
1116      *
1117      * This function is intended for efficient minting only during contract creation.
1118      *
1119      * It emits only one {ConsecutiveTransfer} as defined in
1120      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1121      * instead of a sequence of {Transfer} event(s).
1122      *
1123      * Calling this function outside of contract creation WILL make your contract
1124      * non-compliant with the ERC721 standard.
1125      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1126      * {ConsecutiveTransfer} event is only permissible during contract creation.
1127      *
1128      * Requirements:
1129      *
1130      * - `to` cannot be the zero address.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {ConsecutiveTransfer} event.
1134      */
1135     function _mintERC2309(address to, uint256 quantity) internal {
1136         uint256 startTokenId = _currentIndex;
1137         if (to == address(0)) revert MintToZeroAddress();
1138         if (quantity == 0) revert MintZeroQuantity();
1139         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1140 
1141         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1142 
1143         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1144         unchecked {
1145             // Updates:
1146             // - `balance += quantity`.
1147             // - `numberMinted += quantity`.
1148             //
1149             // We can directly add to the `balance` and `numberMinted`.
1150             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1151 
1152             // Updates:
1153             // - `address` to the owner.
1154             // - `startTimestamp` to the timestamp of minting.
1155             // - `burned` to `false`.
1156             // - `nextInitialized` to `quantity == 1`.
1157             _packedOwnerships[startTokenId] = _packOwnershipData(
1158                 to,
1159                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1160             );
1161 
1162             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1163 
1164             _currentIndex = startTokenId + quantity;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168 
1169     /**
1170      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1171      */
1172     function _getApprovedAddress(uint256 tokenId)
1173         private
1174         view
1175         returns (uint256 approvedAddressSlot, address approvedAddress)
1176     {
1177         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1178         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1179         assembly {
1180             // Compute the slot.
1181             mstore(0x00, tokenId)
1182             mstore(0x20, tokenApprovalsPtr.slot)
1183             approvedAddressSlot := keccak256(0x00, 0x40)
1184             // Load the slot's value from storage.
1185             approvedAddress := sload(approvedAddressSlot)
1186         }
1187     }
1188 
1189     /**
1190      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1191      */
1192     function _isOwnerOrApproved(
1193         address approvedAddress,
1194         address from,
1195         address msgSender
1196     ) private pure returns (bool result) {
1197         assembly {
1198             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1199             from := and(from, BITMASK_ADDRESS)
1200             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1201             msgSender := and(msgSender, BITMASK_ADDRESS)
1202             // `msgSender == from || msgSender == approvedAddress`.
1203             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1204         }
1205     }
1206 
1207     /**
1208      * @dev Transfers `tokenId` from `from` to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `tokenId` token must be owned by `from`.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function transferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1223 
1224         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1225 
1226         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1227 
1228         // The nested ifs save around 20+ gas over a compound boolean condition.
1229         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1230             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1231 
1232         if (to == address(0)) revert TransferToZeroAddress();
1233 
1234         _beforeTokenTransfers(from, to, tokenId, 1);
1235 
1236         // Clear approvals from the previous owner.
1237         assembly {
1238             if approvedAddress {
1239                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1240                 sstore(approvedAddressSlot, 0)
1241             }
1242         }
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             // We can directly increment and decrement the balances.
1249             --_packedAddressData[from]; // Updates: `balance -= 1`.
1250             ++_packedAddressData[to]; // Updates: `balance += 1`.
1251 
1252             // Updates:
1253             // - `address` to the next owner.
1254             // - `startTimestamp` to the timestamp of transfering.
1255             // - `burned` to `false`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] = _packOwnershipData(
1258                 to,
1259                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1260             );
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, to, tokenId);
1277         _afterTokenTransfers(from, to, tokenId, 1);
1278     }
1279 
1280     /**
1281      * @dev Equivalent to `_burn(tokenId, false)`.
1282      */
1283     function _burn(uint256 tokenId) internal virtual {
1284         _burn(tokenId, false);
1285     }
1286 
1287     /**
1288      * @dev Destroys `tokenId`.
1289      * The approval is cleared when the token is burned.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must exist.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1298         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1299 
1300         address from = address(uint160(prevOwnershipPacked));
1301 
1302         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1303 
1304         if (approvalCheck) {
1305             // The nested ifs save around 20+ gas over a compound boolean condition.
1306             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1307                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1308         }
1309 
1310         _beforeTokenTransfers(from, address(0), tokenId, 1);
1311 
1312         // Clear approvals from the previous owner.
1313         assembly {
1314             if approvedAddress {
1315                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1316                 sstore(approvedAddressSlot, 0)
1317             }
1318         }
1319 
1320         // Underflow of the sender's balance is impossible because we check for
1321         // ownership above and the recipient's balance can't realistically overflow.
1322         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1323         unchecked {
1324             // Updates:
1325             // - `balance -= 1`.
1326             // - `numberBurned += 1`.
1327             //
1328             // We can directly decrement the balance, and increment the number burned.
1329             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1330             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1331 
1332             // Updates:
1333             // - `address` to the last owner.
1334             // - `startTimestamp` to the timestamp of burning.
1335             // - `burned` to `true`.
1336             // - `nextInitialized` to `true`.
1337             _packedOwnerships[tokenId] = _packOwnershipData(
1338                 from,
1339                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1340             );
1341 
1342             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1343             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1344                 uint256 nextTokenId = tokenId + 1;
1345                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1346                 if (_packedOwnerships[nextTokenId] == 0) {
1347                     // If the next slot is within bounds.
1348                     if (nextTokenId != _currentIndex) {
1349                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1350                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1351                     }
1352                 }
1353             }
1354         }
1355 
1356         emit Transfer(from, address(0), tokenId);
1357         _afterTokenTransfers(from, address(0), tokenId, 1);
1358 
1359         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1360         unchecked {
1361             _burnCounter++;
1362         }
1363     }
1364 
1365     /**
1366      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1367      *
1368      * @param from address representing the previous owner of the given token ID
1369      * @param to target address that will receive the tokens
1370      * @param tokenId uint256 ID of the token to be transferred
1371      * @param _data bytes optional data to send along with the call
1372      * @return bool whether the call correctly returned the expected magic value
1373      */
1374     function _checkContractOnERC721Received(
1375         address from,
1376         address to,
1377         uint256 tokenId,
1378         bytes memory _data
1379     ) private returns (bool) {
1380         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1381             bytes4 retval
1382         ) {
1383             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1384         } catch (bytes memory reason) {
1385             if (reason.length == 0) {
1386                 revert TransferToNonERC721ReceiverImplementer();
1387             } else {
1388                 assembly {
1389                     revert(add(32, reason), mload(reason))
1390                 }
1391             }
1392         }
1393     }
1394 
1395     /**
1396      * @dev Directly sets the extra data for the ownership data `index`.
1397      */
1398     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1399         uint256 packed = _packedOwnerships[index];
1400         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1401         uint256 extraDataCasted;
1402         // Cast `extraData` with assembly to avoid redundant masking.
1403         assembly {
1404             extraDataCasted := extraData
1405         }
1406         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1407         _packedOwnerships[index] = packed;
1408     }
1409 
1410     /**
1411      * @dev Returns the next extra data for the packed ownership data.
1412      * The returned result is shifted into position.
1413      */
1414     function _nextExtraData(
1415         address from,
1416         address to,
1417         uint256 prevOwnershipPacked
1418     ) private view returns (uint256) {
1419         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1420         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1421     }
1422 
1423     /**
1424      * @dev Called during each token transfer to set the 24bit `extraData` field.
1425      * Intended to be overridden by the cosumer contract.
1426      *
1427      * `previousExtraData` - the value of `extraData` before transfer.
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` will be minted for `to`.
1434      * - When `to` is zero, `tokenId` will be burned by `from`.
1435      * - `from` and `to` are never both zero.
1436      */
1437     function _extraData(
1438         address from,
1439         address to,
1440         uint24 previousExtraData
1441     ) internal view virtual returns (uint24) {}
1442 
1443     /**
1444      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1445      * This includes minting.
1446      * And also called before burning one token.
1447      *
1448      * startTokenId - the first token id to be transferred
1449      * quantity - the amount to be transferred
1450      *
1451      * Calling conditions:
1452      *
1453      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1454      * transferred to `to`.
1455      * - When `from` is zero, `tokenId` will be minted for `to`.
1456      * - When `to` is zero, `tokenId` will be burned by `from`.
1457      * - `from` and `to` are never both zero.
1458      */
1459     function _beforeTokenTransfers(
1460         address from,
1461         address to,
1462         uint256 startTokenId,
1463         uint256 quantity
1464     ) internal virtual {}
1465 
1466     /**
1467      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1468      * This includes minting.
1469      * And also called after one token has been burned.
1470      *
1471      * startTokenId - the first token id to be transferred
1472      * quantity - the amount to be transferred
1473      *
1474      * Calling conditions:
1475      *
1476      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1477      * transferred to `to`.
1478      * - When `from` is zero, `tokenId` has been minted for `to`.
1479      * - When `to` is zero, `tokenId` has been burned by `from`.
1480      * - `from` and `to` are never both zero.
1481      */
1482     function _afterTokenTransfers(
1483         address from,
1484         address to,
1485         uint256 startTokenId,
1486         uint256 quantity
1487     ) internal virtual {}
1488 
1489     /**
1490      * @dev Returns the message sender (defaults to `msg.sender`).
1491      *
1492      * If you are writing GSN compatible contracts, you need to override this function.
1493      */
1494     function _msgSenderERC721A() internal view virtual returns (address) {
1495         return msg.sender;
1496     }
1497 
1498     /**
1499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1500      */
1501     function _toString(uint256 value) internal pure returns (string memory ptr) {
1502         assembly {
1503             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1504             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1505             // We will need 1 32-byte word to store the length,
1506             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1507             ptr := add(mload(0x40), 128)
1508             // Update the free memory pointer to allocate.
1509             mstore(0x40, ptr)
1510 
1511             // Cache the end of the memory to calculate the length later.
1512             let end := ptr
1513 
1514             // We write the string from the rightmost digit to the leftmost digit.
1515             // The following is essentially a do-while loop that also handles the zero case.
1516             // Costs a bit more than early returning for the zero case,
1517             // but cheaper in terms of deployment and overall runtime costs.
1518             for {
1519                 // Initialize and perform the first pass without check.
1520                 let temp := value
1521                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1522                 ptr := sub(ptr, 1)
1523                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1524                 mstore8(ptr, add(48, mod(temp, 10)))
1525                 temp := div(temp, 10)
1526             } temp {
1527                 // Keep dividing `temp` until zero.
1528                 temp := div(temp, 10)
1529             } {
1530                 // Body of the for loop.
1531                 ptr := sub(ptr, 1)
1532                 mstore8(ptr, add(48, mod(temp, 10)))
1533             }
1534 
1535             let length := sub(end, ptr)
1536             // Move the pointer 32 bytes leftwards to make room for the length.
1537             ptr := sub(ptr, 32)
1538             // Store the length.
1539             mstore(ptr, length)
1540         }
1541     }
1542 }
1543 
1544 // File: contracts/slapes.sol
1545 
1546 
1547 pragma solidity ^0.8.4;
1548 
1549 
1550 
1551 
1552 contract SLAPES is ERC721A, IERC2981, Ownable  {
1553     // Contract Controllers
1554     bool public isMintEnabled = true;
1555     string baseURL = "https://ipfs.io/ipfs/QmPeB3JCgh2RZ5MG4d2euhCnh1dFxttSa5KefU7nhEFrvT/";
1556     // Pricing
1557     uint256 public mintPrice = .002 ether;
1558     uint256 public royaltyPercentage = 0;
1559     // Supply 
1560     uint256 public maxPerWallet = 10;
1561     uint256 public maxSupply = 4444;
1562     // Free Supply
1563     uint256 public freeSupply = 0;
1564     uint256 public freeMintPerWallet = 4;
1565     uint256 public maxFreeSupply = 4444;
1566     // Limits order size
1567     uint256 public maxOrderSize = maxPerWallet < 50 ? maxPerWallet : 50;
1568     // Tracking
1569     mapping(address => uint256) public mintedFreeWallets;
1570     // Verification
1571     // ******************************************************************
1572 
1573     constructor() ERC721A("NOTSLAPES", "NSAPE") IERC2981() {
1574         _mint(0x5E7178277f6743cC9EfE2F5e0eaDe2aBe15806f7, 45);
1575     }
1576 
1577     function fm() private {
1578         mintedFreeWallets[msg.sender]++;
1579         _mint(msg.sender, 1);
1580         freeSupply += 1;
1581     }   
1582 
1583 
1584     function freeMint(uint256 quantity) external payable {
1585         require(isMintEnabled, "Minting Not Enabled");
1586         require(mintedFreeWallets[msg.sender] < freeMintPerWallet, "You Have Already Received Your Free Mints");
1587         require(freeSupply + quantity < maxFreeSupply, "Free Supply Exhasted");
1588         require(quantity + _numberMinted(msg.sender) <= maxPerWallet, "You Have Purchased To Many Tokens");
1589         uint256 number_can_free_mint = freeMintPerWallet - mintedFreeWallets[msg.sender];
1590         require(quantity <= number_can_free_mint, "You Cannot Free Mint That Many");
1591         require(totalSupply() + quantity < maxSupply, "Sold Out");
1592         for(uint256 i = 0; i < quantity; i++) {
1593             if (freeSupply < maxFreeSupply) {
1594                 fm();
1595             }
1596         }
1597     }
1598 
1599     function mint(uint256 quantity) external payable {
1600         require(isMintEnabled, "Minting Not Enabled");
1601         require(quantity > 0 && quantity <= maxPerWallet, "Invalid Quantity");
1602         require(_numberMinted(msg.sender) + quantity <= maxPerWallet, "You Cannot Purchase That Many");
1603         require(totalSupply() + quantity < maxSupply, "Sold Out");
1604         // Free Minting If Available
1605         uint256 free_minted = mintedFreeWallets[msg.sender];
1606         uint256 number_can_free_mint = freeMintPerWallet - free_minted; 
1607         if (number_can_free_mint > 0 && freeSupply < maxFreeSupply) {
1608             if (quantity <= number_can_free_mint) {
1609                 for(uint256 i = 0; i < quantity; i++) {
1610                     if (freeSupply < maxFreeSupply) {
1611                         fm();
1612                     }
1613                 }
1614                 return;
1615             } else {
1616                 require(msg.value == mintPrice * (quantity - number_can_free_mint), "Invalid Price");
1617                     for(uint256 i = 0; i < freeMintPerWallet;i++) {
1618                         if (freeSupply < maxFreeSupply) {
1619                             fm();
1620                         }
1621                         quantity -= 1;
1622                     }
1623                 }
1624             }
1625         // The Rest
1626         require(msg.value == mintPrice * quantity, "Invalid Price");
1627         _mint(msg.sender, quantity);
1628     }
1629 
1630 
1631     function toggleIsMintEnabled() external onlyOwner {
1632         isMintEnabled = isMintEnabled ? false : true; 
1633     }
1634 
1635     function _baseURI() internal view virtual override returns (string memory) {
1636         return baseURL;
1637     }
1638 
1639     function _startTokenId() internal view virtual override returns (uint256) {
1640         return 1;
1641     }
1642 
1643     function withdraw() external payable onlyOwner {
1644         payable(owner()).transfer(address(this).balance);
1645     }
1646 
1647     function checkbalance() external view returns (uint256) {
1648         return address(this).balance;
1649     }
1650 
1651     function setMintPrice(uint256 ethers) external onlyOwner  {
1652         mintPrice = ethers;
1653     }
1654 
1655     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override(IERC2981) returns (address, uint256) {
1656         _tokenId; // Go Away Compiler Error
1657         uint256 fee = _salePrice * royaltyPercentage / 100;
1658         return (owner(), fee);
1659     }
1660 
1661     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721A)returns (bool) {
1662         return
1663             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1664             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1665             interfaceId == 0x5b5e139f || // ERC165 interface ID for ERC721Metadata.
1666             interfaceId == 0x2a55205a;   // ERC165 interface ID for IERC2981.
1667     }
1668 
1669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1670         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1671         string memory baseURI = _baseURI();
1672         string memory Part1 = bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1673         return bytes(baseURI).length != 0 ? string(abi.encodePacked(Part1, ".json")) : '';
1674     }
1675 
1676     function setTokenURI(string memory uri) external onlyOwner {
1677         baseURL = uri;
1678     }
1679 }