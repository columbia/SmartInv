1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
29 
30 
31 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface for the NFT Royalty Standard.
37  *
38  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
39  * support for royalty payments across all NFT marketplaces and ecosystem participants.
40  *
41  * _Available since v4.5._
42  */
43 interface IERC2981 is IERC165 {
44     /**
45      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
46      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
47      */
48     function royaltyInfo(uint256 tokenId, uint256 salePrice)
49         external
50         view
51         returns (address receiver, uint256 royaltyAmount);
52 }
53 
54 
55 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
56 
57 
58 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev Implementation of the {IERC165} interface.
64  *
65  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
66  * for the additional interface id that will be supported. For example:
67  *
68  * ```solidity
69  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
70  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
71  * }
72  * ```
73  *
74  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
75  */
76 abstract contract ERC165 is IERC165 {
77     /**
78      * @dev See {IERC165-supportsInterface}.
79      */
80     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
81         return interfaceId == type(IERC165).interfaceId;
82     }
83 }
84 
85 
86 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.6.0
87 
88 
89 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 /**
95  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
96  *
97  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
98  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
99  *
100  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
101  * fee is specified in basis points by default.
102  *
103  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
104  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
105  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
106  *
107  * _Available since v4.5._
108  */
109 abstract contract ERC2981 is IERC2981, ERC165 {
110     struct RoyaltyInfo {
111         address receiver;
112         uint96 royaltyFraction;
113     }
114 
115     RoyaltyInfo private _defaultRoyaltyInfo;
116     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
117 
118     /**
119      * @dev See {IERC165-supportsInterface}.
120      */
121     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
122         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
123     }
124 
125     /**
126      * @inheritdoc IERC2981
127      */
128     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
129         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
130 
131         if (royalty.receiver == address(0)) {
132             royalty = _defaultRoyaltyInfo;
133         }
134 
135         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
136 
137         return (royalty.receiver, royaltyAmount);
138     }
139 
140     /**
141      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
142      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
143      * override.
144      */
145     function _feeDenominator() internal pure virtual returns (uint96) {
146         return 10000;
147     }
148 
149     /**
150      * @dev Sets the royalty information that all ids in this contract will default to.
151      *
152      * Requirements:
153      *
154      * - `receiver` cannot be the zero address.
155      * - `feeNumerator` cannot be greater than the fee denominator.
156      */
157     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
158         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
159         require(receiver != address(0), "ERC2981: invalid receiver");
160 
161         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
162     }
163 
164     /**
165      * @dev Removes default royalty information.
166      */
167     function _deleteDefaultRoyalty() internal virtual {
168         delete _defaultRoyaltyInfo;
169     }
170 
171     /**
172      * @dev Sets the royalty information for a specific token id, overriding the global default.
173      *
174      * Requirements:
175      *
176      * - `tokenId` must be already minted.
177      * - `receiver` cannot be the zero address.
178      * - `feeNumerator` cannot be greater than the fee denominator.
179      */
180     function _setTokenRoyalty(
181         uint256 tokenId,
182         address receiver,
183         uint96 feeNumerator
184     ) internal virtual {
185         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
186         require(receiver != address(0), "ERC2981: Invalid parameters");
187 
188         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
189     }
190 
191     /**
192      * @dev Resets royalty information for the token id back to the global default.
193      */
194     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
195         delete _tokenRoyaltyInfo[tokenId];
196     }
197 }
198 
199 
200 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
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
227 
228 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
232 
233 pragma solidity ^0.8.0;
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
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 
306 // File erc721a/contracts/IERC721A.sol@v4.1.0
307 
308 
309 // ERC721A Contracts v4.1.0
310 // Creator: Chiru Labs
311 
312 pragma solidity ^0.8.4;
313 
314 /**
315  * @dev Interface of an ERC721A compliant contract.
316  */
317 interface IERC721A {
318     /**
319      * The caller must own the token or be an approved operator.
320      */
321     error ApprovalCallerNotOwnerNorApproved();
322 
323     /**
324      * The token does not exist.
325      */
326     error ApprovalQueryForNonexistentToken();
327 
328     /**
329      * The caller cannot approve to their own address.
330      */
331     error ApproveToCaller();
332 
333     /**
334      * Cannot query the balance for the zero address.
335      */
336     error BalanceQueryForZeroAddress();
337 
338     /**
339      * Cannot mint to the zero address.
340      */
341     error MintToZeroAddress();
342 
343     /**
344      * The quantity of tokens minted must be more than zero.
345      */
346     error MintZeroQuantity();
347 
348     /**
349      * The token does not exist.
350      */
351     error OwnerQueryForNonexistentToken();
352 
353     /**
354      * The caller must own the token or be an approved operator.
355      */
356     error TransferCallerNotOwnerNorApproved();
357 
358     /**
359      * The token must be owned by `from`.
360      */
361     error TransferFromIncorrectOwner();
362 
363     /**
364      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
365      */
366     error TransferToNonERC721ReceiverImplementer();
367 
368     /**
369      * Cannot transfer to the zero address.
370      */
371     error TransferToZeroAddress();
372 
373     /**
374      * The token does not exist.
375      */
376     error URIQueryForNonexistentToken();
377 
378     /**
379      * The `quantity` minted with ERC2309 exceeds the safety limit.
380      */
381     error MintERC2309QuantityExceedsLimit();
382 
383     /**
384      * The `extraData` cannot be set on an unintialized ownership slot.
385      */
386     error OwnershipNotInitializedForExtraData();
387 
388     struct TokenOwnership {
389         // The address of the owner.
390         address addr;
391         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
392         uint64 startTimestamp;
393         // Whether the token has been burned.
394         bool burned;
395         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
396         uint24 extraData;
397     }
398 
399     /**
400      * @dev Returns the total amount of tokens stored by the contract.
401      *
402      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
403      */
404     function totalSupply() external view returns (uint256);
405 
406     // ==============================
407     //            IERC165
408     // ==============================
409 
410     /**
411      * @dev Returns true if this contract implements the interface defined by
412      * `interfaceId`. See the corresponding
413      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
414      * to learn more about how these ids are created.
415      *
416      * This function call must use less than 30 000 gas.
417      */
418     function supportsInterface(bytes4 interfaceId) external view returns (bool);
419 
420     // ==============================
421     //            IERC721
422     // ==============================
423 
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
431      */
432     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
433 
434     /**
435      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
436      */
437     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
438 
439     /**
440      * @dev Returns the number of tokens in ``owner``'s account.
441      */
442     function balanceOf(address owner) external view returns (uint256 balance);
443 
444     /**
445      * @dev Returns the owner of the `tokenId` token.
446      *
447      * Requirements:
448      *
449      * - `tokenId` must exist.
450      */
451     function ownerOf(uint256 tokenId) external view returns (address owner);
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
475      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Transfers `tokenId` token from `from` to `to`.
495      *
496      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
497      *
498      * Requirements:
499      *
500      * - `from` cannot be the zero address.
501      * - `to` cannot be the zero address.
502      * - `tokenId` token must be owned by `from`.
503      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     /**
514      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
515      * The approval is cleared when the token is transferred.
516      *
517      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
518      *
519      * Requirements:
520      *
521      * - The caller must own the token or be an approved operator.
522      * - `tokenId` must exist.
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address to, uint256 tokenId) external;
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns the account approved for `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function getApproved(uint256 tokenId) external view returns (address operator);
548 
549     /**
550      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
551      *
552      * See {setApprovalForAll}
553      */
554     function isApprovedForAll(address owner, address operator) external view returns (bool);
555 
556     // ==============================
557     //        IERC721Metadata
558     // ==============================
559 
560     /**
561      * @dev Returns the token collection name.
562      */
563     function name() external view returns (string memory);
564 
565     /**
566      * @dev Returns the token collection symbol.
567      */
568     function symbol() external view returns (string memory);
569 
570     /**
571      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
572      */
573     function tokenURI(uint256 tokenId) external view returns (string memory);
574 
575     // ==============================
576     //            IERC2309
577     // ==============================
578 
579     /**
580      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
581      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
582      */
583     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
584 }
585 
586 
587 // File erc721a/contracts/ERC721A.sol@v4.1.0
588 
589 
590 // ERC721A Contracts v4.1.0
591 // Creator: Chiru Labs
592 
593 pragma solidity ^0.8.4;
594 
595 /**
596  * @dev ERC721 token receiver interface.
597  */
598 interface ERC721A__IERC721Receiver {
599     function onERC721Received(
600         address operator,
601         address from,
602         uint256 tokenId,
603         bytes calldata data
604     ) external returns (bytes4);
605 }
606 
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
609  * including the Metadata extension. Built to optimize for lower gas during batch mints.
610  *
611  * Assumes serials are sequentially minted starting at `_startTokenId()`
612  * (defaults to 0, e.g. 0, 1, 2, 3..).
613  *
614  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
615  *
616  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
617  */
618 contract ERC721A is IERC721A {
619     // Mask of an entry in packed address data.
620     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
621 
622     // The bit position of `numberMinted` in packed address data.
623     uint256 private constant BITPOS_NUMBER_MINTED = 64;
624 
625     // The bit position of `numberBurned` in packed address data.
626     uint256 private constant BITPOS_NUMBER_BURNED = 128;
627 
628     // The bit position of `aux` in packed address data.
629     uint256 private constant BITPOS_AUX = 192;
630 
631     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
632     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
633 
634     // The bit position of `startTimestamp` in packed ownership.
635     uint256 private constant BITPOS_START_TIMESTAMP = 160;
636 
637     // The bit mask of the `burned` bit in packed ownership.
638     uint256 private constant BITMASK_BURNED = 1 << 224;
639 
640     // The bit position of the `nextInitialized` bit in packed ownership.
641     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
642 
643     // The bit mask of the `nextInitialized` bit in packed ownership.
644     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
645 
646     // The bit position of `extraData` in packed ownership.
647     uint256 private constant BITPOS_EXTRA_DATA = 232;
648 
649     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
650     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
651 
652     // The mask of the lower 160 bits for addresses.
653     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
654 
655     // The maximum `quantity` that can be minted with `_mintERC2309`.
656     // This limit is to prevent overflows on the address data entries.
657     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
658     // is required to cause an overflow, which is unrealistic.
659     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
660 
661     // The tokenId of the next token to be minted.
662     uint256 private _currentIndex;
663 
664     // The number of tokens burned.
665     uint256 private _burnCounter;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to ownership details
674     // An empty struct value does not necessarily mean the token is unowned.
675     // See `_packedOwnershipOf` implementation for details.
676     //
677     // Bits Layout:
678     // - [0..159]   `addr`
679     // - [160..223] `startTimestamp`
680     // - [224]      `burned`
681     // - [225]      `nextInitialized`
682     // - [232..255] `extraData`
683     mapping(uint256 => uint256) private _packedOwnerships;
684 
685     // Mapping owner address to address data.
686     //
687     // Bits Layout:
688     // - [0..63]    `balance`
689     // - [64..127]  `numberMinted`
690     // - [128..191] `numberBurned`
691     // - [192..255] `aux`
692     mapping(address => uint256) private _packedAddressData;
693 
694     // Mapping from token ID to approved address.
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     constructor(string memory name_, string memory symbol_) {
701         _name = name_;
702         _symbol = symbol_;
703         _currentIndex = _startTokenId();
704     }
705 
706     /**
707      * @dev Returns the starting token ID.
708      * To change the starting token ID, please override this function.
709      */
710     function _startTokenId() internal view virtual returns (uint256) {
711         return 0;
712     }
713 
714     /**
715      * @dev Returns the next token ID to be minted.
716      */
717     function _nextTokenId() internal view returns (uint256) {
718         return _currentIndex;
719     }
720 
721     /**
722      * @dev Returns the total number of tokens in existence.
723      * Burned tokens will reduce the count.
724      * To get the total number of tokens minted, please see `_totalMinted`.
725      */
726     function totalSupply() public view override returns (uint256) {
727         // Counter underflow is impossible as _burnCounter cannot be incremented
728         // more than `_currentIndex - _startTokenId()` times.
729         unchecked {
730             return _currentIndex - _burnCounter - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev Returns the total amount of tokens minted in the contract.
736      */
737     function _totalMinted() internal view returns (uint256) {
738         // Counter underflow is impossible as _currentIndex does not decrement,
739         // and it is initialized to `_startTokenId()`
740         unchecked {
741             return _currentIndex - _startTokenId();
742         }
743     }
744 
745     /**
746      * @dev Returns the total number of tokens burned.
747      */
748     function _totalBurned() internal view returns (uint256) {
749         return _burnCounter;
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
756         // The interface IDs are constants representing the first 4 bytes of the XOR of
757         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
758         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
759         return
760             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
761             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
762             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view override returns (uint256) {
769         if (owner == address(0)) revert BalanceQueryForZeroAddress();
770         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
771     }
772 
773     /**
774      * Returns the number of tokens minted by `owner`.
775      */
776     function _numberMinted(address owner) internal view returns (uint256) {
777         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
778     }
779 
780     /**
781      * Returns the number of tokens burned by or on behalf of `owner`.
782      */
783     function _numberBurned(address owner) internal view returns (uint256) {
784         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
785     }
786 
787     /**
788      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
789      */
790     function _getAux(address owner) internal view returns (uint64) {
791         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
792     }
793 
794     /**
795      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
796      * If there are multiple variables, please pack them into a uint64.
797      */
798     function _setAux(address owner, uint64 aux) internal {
799         uint256 packed = _packedAddressData[owner];
800         uint256 auxCasted;
801         // Cast `aux` with assembly to avoid redundant masking.
802         assembly {
803             auxCasted := aux
804         }
805         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
806         _packedAddressData[owner] = packed;
807     }
808 
809     /**
810      * Returns the packed ownership data of `tokenId`.
811      */
812     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
813         uint256 curr = tokenId;
814 
815         unchecked {
816             if (_startTokenId() <= curr)
817                 if (curr < _currentIndex) {
818                     uint256 packed = _packedOwnerships[curr];
819                     // If not burned.
820                     if (packed & BITMASK_BURNED == 0) {
821                         // Invariant:
822                         // There will always be an ownership that has an address and is not burned
823                         // before an ownership that does not have an address and is not burned.
824                         // Hence, curr will not underflow.
825                         //
826                         // We can directly compare the packed value.
827                         // If the address is zero, packed is zero.
828                         while (packed == 0) {
829                             packed = _packedOwnerships[--curr];
830                         }
831                         return packed;
832                     }
833                 }
834         }
835         revert OwnerQueryForNonexistentToken();
836     }
837 
838     /**
839      * Returns the unpacked `TokenOwnership` struct from `packed`.
840      */
841     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
842         ownership.addr = address(uint160(packed));
843         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
844         ownership.burned = packed & BITMASK_BURNED != 0;
845         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
846     }
847 
848     /**
849      * Returns the unpacked `TokenOwnership` struct at `index`.
850      */
851     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
852         return _unpackedOwnership(_packedOwnerships[index]);
853     }
854 
855     /**
856      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
857      */
858     function _initializeOwnershipAt(uint256 index) internal {
859         if (_packedOwnerships[index] == 0) {
860             _packedOwnerships[index] = _packedOwnershipOf(index);
861         }
862     }
863 
864     /**
865      * Gas spent here starts off proportional to the maximum mint batch size.
866      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
867      */
868     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
869         return _unpackedOwnership(_packedOwnershipOf(tokenId));
870     }
871 
872     /**
873      * @dev Packs ownership data into a single uint256.
874      */
875     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
876         assembly {
877             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
878             owner := and(owner, BITMASK_ADDRESS)
879             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
880             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
881         }
882     }
883 
884     /**
885      * @dev See {IERC721-ownerOf}.
886      */
887     function ownerOf(uint256 tokenId) public view override returns (address) {
888         return address(uint160(_packedOwnershipOf(tokenId)));
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-name}.
893      */
894     function name() public view virtual override returns (string memory) {
895         return _name;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-symbol}.
900      */
901     function symbol() public view virtual override returns (string memory) {
902         return _symbol;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-tokenURI}.
907      */
908     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
909         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
910 
911         string memory baseURI = _baseURI();
912         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
913     }
914 
915     /**
916      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
917      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
918      * by default, it can be overridden in child contracts.
919      */
920     function _baseURI() internal view virtual returns (string memory) {
921         return '';
922     }
923 
924     /**
925      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
926      */
927     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
928         // For branchless setting of the `nextInitialized` flag.
929         assembly {
930             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
931             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
932         }
933     }
934 
935     /**
936      * @dev See {IERC721-approve}.
937      */
938     function approve(address to, uint256 tokenId) public override {
939         address owner = ownerOf(tokenId);
940 
941         if (_msgSenderERC721A() != owner)
942             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
943                 revert ApprovalCallerNotOwnerNorApproved();
944             }
945 
946         _tokenApprovals[tokenId] = to;
947         emit Approval(owner, to, tokenId);
948     }
949 
950     /**
951      * @dev See {IERC721-getApproved}.
952      */
953     function getApproved(uint256 tokenId) public view override returns (address) {
954         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
955 
956         return _tokenApprovals[tokenId];
957     }
958 
959     /**
960      * @dev See {IERC721-setApprovalForAll}.
961      */
962     function setApprovalForAll(address operator, bool approved) public virtual override {
963         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
964 
965         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
966         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
967     }
968 
969     /**
970      * @dev See {IERC721-isApprovedForAll}.
971      */
972     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
973         return _operatorApprovals[owner][operator];
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         safeTransferFrom(from, to, tokenId, '');
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public virtual override {
996         transferFrom(from, to, tokenId);
997         if (to.code.length != 0)
998             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
999                 revert TransferToNonERC721ReceiverImplementer();
1000             }
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      */
1010     function _exists(uint256 tokenId) internal view returns (bool) {
1011         return
1012             _startTokenId() <= tokenId &&
1013             tokenId < _currentIndex && // If within bounds,
1014             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1015     }
1016 
1017     /**
1018      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1019      */
1020     function _safeMint(address to, uint256 quantity) internal {
1021         _safeMint(to, quantity, '');
1022     }
1023 
1024     /**
1025      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - If `to` refers to a smart contract, it must implement
1030      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * See {_mint}.
1034      *
1035      * Emits a {Transfer} event for each mint.
1036      */
1037     function _safeMint(
1038         address to,
1039         uint256 quantity,
1040         bytes memory _data
1041     ) internal {
1042         _mint(to, quantity);
1043 
1044         unchecked {
1045             if (to.code.length != 0) {
1046                 uint256 end = _currentIndex;
1047                 uint256 index = end - quantity;
1048                 do {
1049                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1050                         revert TransferToNonERC721ReceiverImplementer();
1051                     }
1052                 } while (index < end);
1053                 // Reentrancy protection.
1054                 if (_currentIndex != end) revert();
1055             }
1056         }
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event for each mint.
1068      */
1069     function _mint(address to, uint256 quantity) internal {
1070         uint256 startTokenId = _currentIndex;
1071         if (to == address(0)) revert MintToZeroAddress();
1072         if (quantity == 0) revert MintZeroQuantity();
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         // Overflows are incredibly unrealistic.
1077         // `balance` and `numberMinted` have a maximum limit of 2**64.
1078         // `tokenId` has a maximum limit of 2**256.
1079         unchecked {
1080             // Updates:
1081             // - `balance += quantity`.
1082             // - `numberMinted += quantity`.
1083             //
1084             // We can directly add to the `balance` and `numberMinted`.
1085             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1086 
1087             // Updates:
1088             // - `address` to the owner.
1089             // - `startTimestamp` to the timestamp of minting.
1090             // - `burned` to `false`.
1091             // - `nextInitialized` to `quantity == 1`.
1092             _packedOwnerships[startTokenId] = _packOwnershipData(
1093                 to,
1094                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1095             );
1096 
1097             uint256 tokenId = startTokenId;
1098             uint256 end = startTokenId + quantity;
1099             do {
1100                 emit Transfer(address(0), to, tokenId++);
1101             } while (tokenId < end);
1102 
1103             _currentIndex = end;
1104         }
1105         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1106     }
1107 
1108     /**
1109      * @dev Mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * This function is intended for efficient minting only during contract creation.
1112      *
1113      * It emits only one {ConsecutiveTransfer} as defined in
1114      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1115      * instead of a sequence of {Transfer} event(s).
1116      *
1117      * Calling this function outside of contract creation WILL make your contract
1118      * non-compliant with the ERC721 standard.
1119      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1120      * {ConsecutiveTransfer} event is only permissible during contract creation.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {ConsecutiveTransfer} event.
1128      */
1129     function _mintERC2309(address to, uint256 quantity) internal {
1130         uint256 startTokenId = _currentIndex;
1131         if (to == address(0)) revert MintToZeroAddress();
1132         if (quantity == 0) revert MintZeroQuantity();
1133         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1138         unchecked {
1139             // Updates:
1140             // - `balance += quantity`.
1141             // - `numberMinted += quantity`.
1142             //
1143             // We can directly add to the `balance` and `numberMinted`.
1144             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1145 
1146             // Updates:
1147             // - `address` to the owner.
1148             // - `startTimestamp` to the timestamp of minting.
1149             // - `burned` to `false`.
1150             // - `nextInitialized` to `quantity == 1`.
1151             _packedOwnerships[startTokenId] = _packOwnershipData(
1152                 to,
1153                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1154             );
1155 
1156             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1157 
1158             _currentIndex = startTokenId + quantity;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1165      */
1166     function _getApprovedAddress(uint256 tokenId)
1167         private
1168         view
1169         returns (uint256 approvedAddressSlot, address approvedAddress)
1170     {
1171         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1172         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1173         assembly {
1174             // Compute the slot.
1175             mstore(0x00, tokenId)
1176             mstore(0x20, tokenApprovalsPtr.slot)
1177             approvedAddressSlot := keccak256(0x00, 0x40)
1178             // Load the slot's value from storage.
1179             approvedAddress := sload(approvedAddressSlot)
1180         }
1181     }
1182 
1183     /**
1184      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1185      */
1186     function _isOwnerOrApproved(
1187         address approvedAddress,
1188         address from,
1189         address msgSender
1190     ) private pure returns (bool result) {
1191         assembly {
1192             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1193             from := and(from, BITMASK_ADDRESS)
1194             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1195             msgSender := and(msgSender, BITMASK_ADDRESS)
1196             // `msgSender == from || msgSender == approvedAddress`.
1197             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1198         }
1199     }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function transferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) public virtual override {
1216         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1217 
1218         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1219 
1220         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1221 
1222         // The nested ifs save around 20+ gas over a compound boolean condition.
1223         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1224             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1225 
1226         if (to == address(0)) revert TransferToZeroAddress();
1227 
1228         _beforeTokenTransfers(from, to, tokenId, 1);
1229 
1230         // Clear approvals from the previous owner.
1231         assembly {
1232             if approvedAddress {
1233                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1234                 sstore(approvedAddressSlot, 0)
1235             }
1236         }
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             // We can directly increment and decrement the balances.
1243             --_packedAddressData[from]; // Updates: `balance -= 1`.
1244             ++_packedAddressData[to]; // Updates: `balance += 1`.
1245 
1246             // Updates:
1247             // - `address` to the next owner.
1248             // - `startTimestamp` to the timestamp of transfering.
1249             // - `burned` to `false`.
1250             // - `nextInitialized` to `true`.
1251             _packedOwnerships[tokenId] = _packOwnershipData(
1252                 to,
1253                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1254             );
1255 
1256             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1257             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1258                 uint256 nextTokenId = tokenId + 1;
1259                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1260                 if (_packedOwnerships[nextTokenId] == 0) {
1261                     // If the next slot is within bounds.
1262                     if (nextTokenId != _currentIndex) {
1263                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1264                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1265                     }
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, to, tokenId);
1271         _afterTokenTransfers(from, to, tokenId, 1);
1272     }
1273 
1274     /**
1275      * @dev Equivalent to `_burn(tokenId, false)`.
1276      */
1277     function _burn(uint256 tokenId) internal virtual {
1278         _burn(tokenId, false);
1279     }
1280 
1281     /**
1282      * @dev Destroys `tokenId`.
1283      * The approval is cleared when the token is burned.
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must exist.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1292         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1293 
1294         address from = address(uint160(prevOwnershipPacked));
1295 
1296         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1297 
1298         if (approvalCheck) {
1299             // The nested ifs save around 20+ gas over a compound boolean condition.
1300             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1301                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1302         }
1303 
1304         _beforeTokenTransfers(from, address(0), tokenId, 1);
1305 
1306         // Clear approvals from the previous owner.
1307         assembly {
1308             if approvedAddress {
1309                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1310                 sstore(approvedAddressSlot, 0)
1311             }
1312         }
1313 
1314         // Underflow of the sender's balance is impossible because we check for
1315         // ownership above and the recipient's balance can't realistically overflow.
1316         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1317         unchecked {
1318             // Updates:
1319             // - `balance -= 1`.
1320             // - `numberBurned += 1`.
1321             //
1322             // We can directly decrement the balance, and increment the number burned.
1323             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1324             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1325 
1326             // Updates:
1327             // - `address` to the last owner.
1328             // - `startTimestamp` to the timestamp of burning.
1329             // - `burned` to `true`.
1330             // - `nextInitialized` to `true`.
1331             _packedOwnerships[tokenId] = _packOwnershipData(
1332                 from,
1333                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1334             );
1335 
1336             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1337             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1338                 uint256 nextTokenId = tokenId + 1;
1339                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1340                 if (_packedOwnerships[nextTokenId] == 0) {
1341                     // If the next slot is within bounds.
1342                     if (nextTokenId != _currentIndex) {
1343                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1344                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1345                     }
1346                 }
1347             }
1348         }
1349 
1350         emit Transfer(from, address(0), tokenId);
1351         _afterTokenTransfers(from, address(0), tokenId, 1);
1352 
1353         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1354         unchecked {
1355             _burnCounter++;
1356         }
1357     }
1358 
1359     /**
1360      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkContractOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1375             bytes4 retval
1376         ) {
1377             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1378         } catch (bytes memory reason) {
1379             if (reason.length == 0) {
1380                 revert TransferToNonERC721ReceiverImplementer();
1381             } else {
1382                 assembly {
1383                     revert(add(32, reason), mload(reason))
1384                 }
1385             }
1386         }
1387     }
1388 
1389     /**
1390      * @dev Directly sets the extra data for the ownership data `index`.
1391      */
1392     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1393         uint256 packed = _packedOwnerships[index];
1394         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1395         uint256 extraDataCasted;
1396         // Cast `extraData` with assembly to avoid redundant masking.
1397         assembly {
1398             extraDataCasted := extraData
1399         }
1400         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1401         _packedOwnerships[index] = packed;
1402     }
1403 
1404     /**
1405      * @dev Returns the next extra data for the packed ownership data.
1406      * The returned result is shifted into position.
1407      */
1408     function _nextExtraData(
1409         address from,
1410         address to,
1411         uint256 prevOwnershipPacked
1412     ) private view returns (uint256) {
1413         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1414         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1415     }
1416 
1417     /**
1418      * @dev Called during each token transfer to set the 24bit `extraData` field.
1419      * Intended to be overridden by the cosumer contract.
1420      *
1421      * `previousExtraData` - the value of `extraData` before transfer.
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` will be minted for `to`.
1428      * - When `to` is zero, `tokenId` will be burned by `from`.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _extraData(
1432         address from,
1433         address to,
1434         uint24 previousExtraData
1435     ) internal view virtual returns (uint24) {}
1436 
1437     /**
1438      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1439      * This includes minting.
1440      * And also called before burning one token.
1441      *
1442      * startTokenId - the first token id to be transferred
1443      * quantity - the amount to be transferred
1444      *
1445      * Calling conditions:
1446      *
1447      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1448      * transferred to `to`.
1449      * - When `from` is zero, `tokenId` will be minted for `to`.
1450      * - When `to` is zero, `tokenId` will be burned by `from`.
1451      * - `from` and `to` are never both zero.
1452      */
1453     function _beforeTokenTransfers(
1454         address from,
1455         address to,
1456         uint256 startTokenId,
1457         uint256 quantity
1458     ) internal virtual {}
1459 
1460     /**
1461      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1462      * This includes minting.
1463      * And also called after one token has been burned.
1464      *
1465      * startTokenId - the first token id to be transferred
1466      * quantity - the amount to be transferred
1467      *
1468      * Calling conditions:
1469      *
1470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1471      * transferred to `to`.
1472      * - When `from` is zero, `tokenId` has been minted for `to`.
1473      * - When `to` is zero, `tokenId` has been burned by `from`.
1474      * - `from` and `to` are never both zero.
1475      */
1476     function _afterTokenTransfers(
1477         address from,
1478         address to,
1479         uint256 startTokenId,
1480         uint256 quantity
1481     ) internal virtual {}
1482 
1483     /**
1484      * @dev Returns the message sender (defaults to `msg.sender`).
1485      *
1486      * If you are writing GSN compatible contracts, you need to override this function.
1487      */
1488     function _msgSenderERC721A() internal view virtual returns (address) {
1489         return msg.sender;
1490     }
1491 
1492     /**
1493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1494      */
1495     function _toString(uint256 value) internal pure returns (string memory ptr) {
1496         assembly {
1497             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1498             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1499             // We will need 1 32-byte word to store the length,
1500             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1501             ptr := add(mload(0x40), 128)
1502             // Update the free memory pointer to allocate.
1503             mstore(0x40, ptr)
1504 
1505             // Cache the end of the memory to calculate the length later.
1506             let end := ptr
1507 
1508             // We write the string from the rightmost digit to the leftmost digit.
1509             // The following is essentially a do-while loop that also handles the zero case.
1510             // Costs a bit more than early returning for the zero case,
1511             // but cheaper in terms of deployment and overall runtime costs.
1512             for {
1513                 // Initialize and perform the first pass without check.
1514                 let temp := value
1515                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1516                 ptr := sub(ptr, 1)
1517                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1518                 mstore8(ptr, add(48, mod(temp, 10)))
1519                 temp := div(temp, 10)
1520             } temp {
1521                 // Keep dividing `temp` until zero.
1522                 temp := div(temp, 10)
1523             } {
1524                 // Body of the for loop.
1525                 ptr := sub(ptr, 1)
1526                 mstore8(ptr, add(48, mod(temp, 10)))
1527             }
1528 
1529             let length := sub(end, ptr)
1530             // Move the pointer 32 bytes leftwards to make room for the length.
1531             ptr := sub(ptr, 32)
1532             // Store the length.
1533             mstore(ptr, length)
1534         }
1535     }
1536 }
1537 
1538 
1539 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
1540 
1541 
1542 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1543 
1544 pragma solidity ^0.8.1;
1545 
1546 /**
1547  * @dev Collection of functions related to the address type
1548  */
1549 library Address {
1550     /**
1551      * @dev Returns true if `account` is a contract.
1552      *
1553      * [IMPORTANT]
1554      * ====
1555      * It is unsafe to assume that an address for which this function returns
1556      * false is an externally-owned account (EOA) and not a contract.
1557      *
1558      * Among others, `isContract` will return false for the following
1559      * types of addresses:
1560      *
1561      *  - an externally-owned account
1562      *  - a contract in construction
1563      *  - an address where a contract will be created
1564      *  - an address where a contract lived, but was destroyed
1565      * ====
1566      *
1567      * [IMPORTANT]
1568      * ====
1569      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1570      *
1571      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1572      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1573      * constructor.
1574      * ====
1575      */
1576     function isContract(address account) internal view returns (bool) {
1577         // This method relies on extcodesize/address.code.length, which returns 0
1578         // for contracts in construction, since the code is only stored at the end
1579         // of the constructor execution.
1580 
1581         return account.code.length > 0;
1582     }
1583 
1584     /**
1585      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1586      * `recipient`, forwarding all available gas and reverting on errors.
1587      *
1588      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1589      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1590      * imposed by `transfer`, making them unable to receive funds via
1591      * `transfer`. {sendValue} removes this limitation.
1592      *
1593      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1594      *
1595      * IMPORTANT: because control is transferred to `recipient`, care must be
1596      * taken to not create reentrancy vulnerabilities. Consider using
1597      * {ReentrancyGuard} or the
1598      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1599      */
1600     function sendValue(address payable recipient, uint256 amount) internal {
1601         require(address(this).balance >= amount, "Address: insufficient balance");
1602 
1603         (bool success, ) = recipient.call{value: amount}("");
1604         require(success, "Address: unable to send value, recipient may have reverted");
1605     }
1606 
1607     /**
1608      * @dev Performs a Solidity function call using a low level `call`. A
1609      * plain `call` is an unsafe replacement for a function call: use this
1610      * function instead.
1611      *
1612      * If `target` reverts with a revert reason, it is bubbled up by this
1613      * function (like regular Solidity function calls).
1614      *
1615      * Returns the raw returned data. To convert to the expected return value,
1616      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1617      *
1618      * Requirements:
1619      *
1620      * - `target` must be a contract.
1621      * - calling `target` with `data` must not revert.
1622      *
1623      * _Available since v3.1._
1624      */
1625     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1626         return functionCall(target, data, "Address: low-level call failed");
1627     }
1628 
1629     /**
1630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1631      * `errorMessage` as a fallback revert reason when `target` reverts.
1632      *
1633      * _Available since v3.1._
1634      */
1635     function functionCall(
1636         address target,
1637         bytes memory data,
1638         string memory errorMessage
1639     ) internal returns (bytes memory) {
1640         return functionCallWithValue(target, data, 0, errorMessage);
1641     }
1642 
1643     /**
1644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1645      * but also transferring `value` wei to `target`.
1646      *
1647      * Requirements:
1648      *
1649      * - the calling contract must have an ETH balance of at least `value`.
1650      * - the called Solidity function must be `payable`.
1651      *
1652      * _Available since v3.1._
1653      */
1654     function functionCallWithValue(
1655         address target,
1656         bytes memory data,
1657         uint256 value
1658     ) internal returns (bytes memory) {
1659         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1660     }
1661 
1662     /**
1663      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1664      * with `errorMessage` as a fallback revert reason when `target` reverts.
1665      *
1666      * _Available since v3.1._
1667      */
1668     function functionCallWithValue(
1669         address target,
1670         bytes memory data,
1671         uint256 value,
1672         string memory errorMessage
1673     ) internal returns (bytes memory) {
1674         require(address(this).balance >= value, "Address: insufficient balance for call");
1675         require(isContract(target), "Address: call to non-contract");
1676 
1677         (bool success, bytes memory returndata) = target.call{value: value}(data);
1678         return verifyCallResult(success, returndata, errorMessage);
1679     }
1680 
1681     /**
1682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1683      * but performing a static call.
1684      *
1685      * _Available since v3.3._
1686      */
1687     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1688         return functionStaticCall(target, data, "Address: low-level static call failed");
1689     }
1690 
1691     /**
1692      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1693      * but performing a static call.
1694      *
1695      * _Available since v3.3._
1696      */
1697     function functionStaticCall(
1698         address target,
1699         bytes memory data,
1700         string memory errorMessage
1701     ) internal view returns (bytes memory) {
1702         require(isContract(target), "Address: static call to non-contract");
1703 
1704         (bool success, bytes memory returndata) = target.staticcall(data);
1705         return verifyCallResult(success, returndata, errorMessage);
1706     }
1707 
1708     /**
1709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1710      * but performing a delegate call.
1711      *
1712      * _Available since v3.4._
1713      */
1714     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1715         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1716     }
1717 
1718     /**
1719      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1720      * but performing a delegate call.
1721      *
1722      * _Available since v3.4._
1723      */
1724     function functionDelegateCall(
1725         address target,
1726         bytes memory data,
1727         string memory errorMessage
1728     ) internal returns (bytes memory) {
1729         require(isContract(target), "Address: delegate call to non-contract");
1730 
1731         (bool success, bytes memory returndata) = target.delegatecall(data);
1732         return verifyCallResult(success, returndata, errorMessage);
1733     }
1734 
1735     /**
1736      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1737      * revert reason using the provided one.
1738      *
1739      * _Available since v4.3._
1740      */
1741     function verifyCallResult(
1742         bool success,
1743         bytes memory returndata,
1744         string memory errorMessage
1745     ) internal pure returns (bytes memory) {
1746         if (success) {
1747             return returndata;
1748         } else {
1749             // Look for revert reason and bubble it up if present
1750             if (returndata.length > 0) {
1751                 // The easiest way to bubble the revert reason is using memory via assembly
1752 
1753                 assembly {
1754                     let returndata_size := mload(returndata)
1755                     revert(add(32, returndata), returndata_size)
1756                 }
1757             } else {
1758                 revert(errorMessage);
1759             }
1760         }
1761     }
1762 }
1763 
1764 
1765 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1766 
1767 
1768 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 /**
1773  * @dev String operations.
1774  */
1775 library Strings {
1776     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1777 
1778     /**
1779      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1780      */
1781     function toString(uint256 value) internal pure returns (string memory) {
1782         // Inspired by OraclizeAPI's implementation - MIT licence
1783         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1784 
1785         if (value == 0) {
1786             return "0";
1787         }
1788         uint256 temp = value;
1789         uint256 digits;
1790         while (temp != 0) {
1791             digits++;
1792             temp /= 10;
1793         }
1794         bytes memory buffer = new bytes(digits);
1795         while (value != 0) {
1796             digits -= 1;
1797             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1798             value /= 10;
1799         }
1800         return string(buffer);
1801     }
1802 
1803     /**
1804      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1805      */
1806     function toHexString(uint256 value) internal pure returns (string memory) {
1807         if (value == 0) {
1808             return "0x00";
1809         }
1810         uint256 temp = value;
1811         uint256 length = 0;
1812         while (temp != 0) {
1813             length++;
1814             temp >>= 8;
1815         }
1816         return toHexString(value, length);
1817     }
1818 
1819     /**
1820      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1821      */
1822     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1823         bytes memory buffer = new bytes(2 * length + 2);
1824         buffer[0] = "0";
1825         buffer[1] = "x";
1826         for (uint256 i = 2 * length + 1; i > 1; --i) {
1827             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1828             value >>= 4;
1829         }
1830         require(value == 0, "Strings: hex length insufficient");
1831         return string(buffer);
1832     }
1833 }
1834 
1835 
1836 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
1837 
1838 
1839 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1840 
1841 pragma solidity ^0.8.0;
1842 
1843 /**
1844  * @dev Required interface of an ERC721 compliant contract.
1845  */
1846 interface IERC721 is IERC165 {
1847     /**
1848      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1849      */
1850     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1851 
1852     /**
1853      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1854      */
1855     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1856 
1857     /**
1858      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1859      */
1860     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1861 
1862     /**
1863      * @dev Returns the number of tokens in ``owner``'s account.
1864      */
1865     function balanceOf(address owner) external view returns (uint256 balance);
1866 
1867     /**
1868      * @dev Returns the owner of the `tokenId` token.
1869      *
1870      * Requirements:
1871      *
1872      * - `tokenId` must exist.
1873      */
1874     function ownerOf(uint256 tokenId) external view returns (address owner);
1875 
1876     /**
1877      * @dev Safely transfers `tokenId` token from `from` to `to`.
1878      *
1879      * Requirements:
1880      *
1881      * - `from` cannot be the zero address.
1882      * - `to` cannot be the zero address.
1883      * - `tokenId` token must exist and be owned by `from`.
1884      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1885      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1886      *
1887      * Emits a {Transfer} event.
1888      */
1889     function safeTransferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId,
1893         bytes calldata data
1894     ) external;
1895 
1896     /**
1897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1899      *
1900      * Requirements:
1901      *
1902      * - `from` cannot be the zero address.
1903      * - `to` cannot be the zero address.
1904      * - `tokenId` token must exist and be owned by `from`.
1905      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1907      *
1908      * Emits a {Transfer} event.
1909      */
1910     function safeTransferFrom(
1911         address from,
1912         address to,
1913         uint256 tokenId
1914     ) external;
1915 
1916     /**
1917      * @dev Transfers `tokenId` token from `from` to `to`.
1918      *
1919      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1920      *
1921      * Requirements:
1922      *
1923      * - `from` cannot be the zero address.
1924      * - `to` cannot be the zero address.
1925      * - `tokenId` token must be owned by `from`.
1926      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1927      *
1928      * Emits a {Transfer} event.
1929      */
1930     function transferFrom(
1931         address from,
1932         address to,
1933         uint256 tokenId
1934     ) external;
1935 
1936     /**
1937      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1938      * The approval is cleared when the token is transferred.
1939      *
1940      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1941      *
1942      * Requirements:
1943      *
1944      * - The caller must own the token or be an approved operator.
1945      * - `tokenId` must exist.
1946      *
1947      * Emits an {Approval} event.
1948      */
1949     function approve(address to, uint256 tokenId) external;
1950 
1951     /**
1952      * @dev Approve or remove `operator` as an operator for the caller.
1953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1954      *
1955      * Requirements:
1956      *
1957      * - The `operator` cannot be the caller.
1958      *
1959      * Emits an {ApprovalForAll} event.
1960      */
1961     function setApprovalForAll(address operator, bool _approved) external;
1962 
1963     /**
1964      * @dev Returns the account approved for `tokenId` token.
1965      *
1966      * Requirements:
1967      *
1968      * - `tokenId` must exist.
1969      */
1970     function getApproved(uint256 tokenId) external view returns (address operator);
1971 
1972     /**
1973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1974      *
1975      * See {setApprovalForAll}
1976      */
1977     function isApprovedForAll(address owner, address operator) external view returns (bool);
1978 }
1979 
1980 
1981 // File contracts/Bella.sol
1982 
1983 
1984 pragma solidity ^0.8.9;
1985 
1986 
1987 
1988 
1989 
1990 
1991 contract Bella is ERC2981, ERC721A, Ownable {
1992     using Address for address payable;
1993     using Strings for uint256;
1994 
1995     event Winning(address minter, uint32 amount);
1996 
1997     bytes32 public immutable _lotterySalt;
1998     uint256 public immutable _price;
1999     uint32 public immutable _maxSupply;
2000     uint32 public immutable _randomFreeSupply;
2001     uint32 public immutable _instantFreeWalletLimit;
2002     uint32 public immutable _walletLimit;
2003     uint32 public immutable _mintLimit;
2004     address public immutable PAYMENT_ADDRESS;
2005     uint32 public _teamMinted;
2006     uint32 public _randomFreeMinted;
2007     uint32 public _instantFreeMinted;
2008     uint32 public _freeQuota;
2009     bool public _started = true;
2010     string public _metadataURI = "ipfs://QmQskPXK7jy4c3bcusQjUnJcmUGuQMgG1jiUwujhrrXzYo/";
2011 
2012     struct Status {
2013         // config
2014         uint256 price;
2015         uint32 maxSupply;
2016         uint32 publicSupply;
2017         uint32 randomFreeSupply;
2018         uint32 instantFreeWalletLimit;
2019         uint32 walletLimit;
2020 
2021         // state
2022         uint32 publicMinted;
2023         uint32 instantFreeMintLeft;
2024         uint32 randomFreeMintLeft;
2025         uint32 userMinted;
2026         bool soldout;
2027         bool started;
2028         uint32 freeQuota;
2029     }
2030 
2031     constructor(
2032         uint256 price,
2033         uint32 maxSupply,
2034         uint32 randomFreeSupply,
2035         uint32 instantFreeWalletLimit,
2036         uint32 walletLimit,
2037         uint32 freeQuota,
2038         address paymentsAddress_
2039     ) ERC721A("Bella", "BELLA") {
2040         require(maxSupply -  freeQuota >= randomFreeSupply);
2041         _lotterySalt = keccak256(abi.encodePacked(address(this), block.timestamp));
2042         _price = price;
2043         _maxSupply = maxSupply;
2044         _instantFreeWalletLimit = instantFreeWalletLimit;
2045         _randomFreeSupply = randomFreeSupply;
2046         _walletLimit = walletLimit;
2047         _freeQuota = freeQuota;
2048         PAYMENT_ADDRESS = paymentsAddress_;
2049         _mintLimit = 10;
2050         setFeeNumerator(750);
2051     }
2052 
2053     function mint(uint32 amount) external payable {
2054         require(_started, "Bella: Sale is not started");
2055         require(amount <= _mintLimit, "Bella: Over limit per mint");
2056         //total minted
2057         uint32 publicMinted = _publicMinted();
2058         uint32 publicSupply = _maxSupply;
2059         require(amount + publicMinted <= _maxSupply, "Bella: Exceed max supply");
2060 
2061         uint32 minted = uint32(_numberMinted(msg.sender));
2062         require(amount + minted <= _walletLimit, "Bella: Exceed wallet limit");
2063 
2064         uint32 instantFreeWalletLimit = _instantFreeWalletLimit;
2065         uint32 freeAmount = 0;
2066         if (minted < instantFreeWalletLimit && _freeQuota > 0) {
2067             uint32 freeWalletQuota = instantFreeWalletLimit - minted;
2068             freeWalletQuota = _freeQuota >  freeWalletQuota ? freeWalletQuota : _freeQuota;
2069             freeAmount += freeWalletQuota > amount ? amount : freeWalletQuota;
2070             _freeQuota -= freeAmount;
2071         }
2072         // if (minted < instantFreeWalletLimit) {
2073         //     uint32 quota = instantFreeWalletLimit - minted;
2074         //     freeAmount += quota > amount ? amount : quota;
2075         // }
2076         uint32 enterLotteryAmount = amount - freeAmount;
2077         if (enterLotteryAmount > 0) {
2078             uint32 randomFreeAmount = 0;
2079             uint32 randomFreeMinted = _randomFreeMinted;
2080             uint32 quota = _randomFreeSupply - randomFreeMinted;
2081 
2082             if (quota > 0) {
2083                 uint256 randomSeed = uint256(keccak256(abi.encodePacked(
2084                     msg.sender,
2085                     publicMinted,
2086                     block.difficulty,
2087                     _lotterySalt)));
2088 
2089                 for (uint256 i = 0; i < enterLotteryAmount && quota > 0; ) {
2090                     if (uint16((randomSeed & 0xFFFF) % publicSupply) < quota) {
2091                         randomFreeAmount += 1;
2092                         quota -= 1;
2093                     }
2094 
2095                     unchecked {
2096                         i++;
2097                         randomSeed = randomSeed >> 16;
2098                     }
2099                 }
2100 
2101                 if (randomFreeAmount > 0) {
2102                     freeAmount += randomFreeAmount;
2103                     _randomFreeMinted += randomFreeAmount;
2104                     emit Winning(msg.sender, randomFreeAmount);
2105                 }
2106             }
2107         }
2108 
2109         uint256 requiredValue = (amount - freeAmount) * _price;
2110         require(msg.value >= requiredValue, "Bella: Insufficient fund");
2111 
2112         _safeMint(msg.sender, amount);
2113         if (msg.value > requiredValue) {
2114             payable(msg.sender).sendValue(msg.value - requiredValue);
2115         }
2116     }
2117 
2118     function _publicMinted() public view returns (uint32) {
2119         return uint32(_totalMinted()) - _teamMinted;
2120     }
2121 
2122     function _status(address minter) external view returns (Status memory) {
2123         uint32 publicSupply = _maxSupply;
2124         uint32 publicMinted = uint32(ERC721A._totalMinted()) - _teamMinted;
2125 
2126         return Status({
2127             // config
2128             price: _price,
2129             maxSupply: _maxSupply,
2130             publicSupply:publicSupply,
2131             randomFreeSupply: _randomFreeSupply,
2132             instantFreeWalletLimit: _instantFreeWalletLimit,
2133             walletLimit: _walletLimit,
2134             // state
2135             publicMinted: publicMinted,
2136             instantFreeMintLeft: _freeQuota,
2137             randomFreeMintLeft: _randomFreeSupply - _randomFreeMinted,
2138             soldout:  publicMinted >= publicSupply,
2139             userMinted: uint32(_numberMinted(minter)),
2140             started: _started,
2141             freeQuota: _freeQuota
2142         });
2143     }
2144 
2145     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2146         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2147 
2148         string memory baseURI = _metadataURI;
2149         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2150     }
2151 
2152     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721A) returns (bool) {
2153         return
2154             interfaceId == type(IERC2981).interfaceId ||
2155             interfaceId == type(IERC721).interfaceId ||
2156             super.supportsInterface(interfaceId);
2157     }
2158 
2159     function devMint(address to, uint32 amount) external onlyOwner {
2160         _teamMinted += amount;
2161         require(_teamMinted <= _maxSupply, "Bella: Exceed max supply");
2162         _safeMint(to, amount);
2163     }
2164 
2165     function setFeeNumerator(uint96 feeNumerator) public onlyOwner {
2166         _setDefaultRoyalty(owner(), feeNumerator);
2167     }
2168 
2169 	function _startTokenId() internal pure override returns (uint) {
2170 		return 1;
2171 	}
2172 
2173     function setStarted(bool started) external onlyOwner {
2174         _started = started;
2175     }
2176 
2177     function setMetadataURI(string memory uri) external onlyOwner {
2178         _metadataURI = uri;
2179     }
2180 
2181 	function withdraw() external onlyOwner {
2182 		uint balance = address(this).balance;
2183 		require(balance > 0, "No Balance");
2184 		payable(PAYMENT_ADDRESS).transfer(balance);
2185 	}
2186 }