1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.4;
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
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Internal function without access restriction.
95      */
96     function _transferOwnership(address newOwner) internal virtual {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
106 
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
130 
131 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
132 
133 
134 /**
135  * @dev Interface for the NFT Royalty Standard.
136  *
137  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
138  * support for royalty payments across all NFT marketplaces and ecosystem participants.
139  *
140  * _Available since v4.5._
141  */
142 interface IERC2981 is IERC165 {
143     /**
144      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
145      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
146      */
147     function royaltyInfo(uint256 tokenId, uint256 salePrice)
148     external
149     view
150     returns (address receiver, uint256 royaltyAmount);
151 }
152 
153 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
156 
157 
158 /**
159  * @dev Implementation of the {IERC165} interface.
160  *
161  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
162  * for the additional interface id that will be supported. For example:
163  *
164  * ```solidity
165  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
166  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
167  * }
168  * ```
169  *
170  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
171  */
172 abstract contract ERC165 is IERC165 {
173     /**
174      * @dev See {IERC165-supportsInterface}.
175      */
176     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
177         return interfaceId == type(IERC165).interfaceId;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/token/common/ERC2981.sol
182 
183 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
184 
185 
186 
187 /**
188  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
189  *
190  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
191  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
192  *
193  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
194  * fee is specified in basis points by default.
195  *
196  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
197  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
198  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
199  *
200  * _Available since v4.5._
201  */
202 abstract contract ERC2981 is IERC2981, ERC165 {
203     struct RoyaltyInfo {
204         address receiver;
205         uint96 royaltyFraction;
206     }
207 
208     RoyaltyInfo private _defaultRoyaltyInfo;
209     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
210 
211     /**
212      * @dev See {IERC165-supportsInterface}.
213      */
214     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
215         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
216     }
217 
218     /**
219      * @inheritdoc IERC2981
220      */
221     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
222         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
223 
224         if (royalty.receiver == address(0)) {
225             royalty = _defaultRoyaltyInfo;
226         }
227 
228         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
229 
230         return (royalty.receiver, royaltyAmount);
231     }
232 
233     /**
234      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
235      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
236      * override.
237      */
238     function _feeDenominator() internal pure virtual returns (uint96) {
239         return 10000;
240     }
241 
242     /**
243      * @dev Sets the royalty information that all ids in this contract will default to.
244      *
245      * Requirements:
246      *
247      * - `receiver` cannot be the zero address.
248      * - `feeNumerator` cannot be greater than the fee denominator.
249      */
250     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
251         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
252         require(receiver != address(0), "ERC2981: invalid receiver");
253 
254         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
255     }
256 
257     /**
258      * @dev Removes default royalty information.
259      */
260     function _deleteDefaultRoyalty() internal virtual {
261         delete _defaultRoyaltyInfo;
262     }
263 
264     /**
265      * @dev Sets the royalty information for a specific token id, overriding the global default.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must be already minted.
270      * - `receiver` cannot be the zero address.
271      * - `feeNumerator` cannot be greater than the fee denominator.
272      */
273     function _setTokenRoyalty(
274         uint256 tokenId,
275         address receiver,
276         uint96 feeNumerator
277     ) internal virtual {
278         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
279         require(receiver != address(0), "ERC2981: Invalid parameters");
280 
281         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
282     }
283 
284     /**
285      * @dev Resets royalty information for the token id back to the global default.
286      */
287     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
288         delete _tokenRoyaltyInfo[tokenId];
289     }
290 }
291 
292 // File: erc721a/contracts/IERC721A.sol
293 
294 // ERC721A Contracts v4.0.0
295 // Creator: Chiru Labs
296 
297 
298 /**
299  * @dev Interface of an ERC721A compliant contract.
300  */
301 interface IERC721A {
302     /**
303      * The caller must own the token or be an approved operator.
304      */
305     error ApprovalCallerNotOwnerNorApproved();
306 
307     /**
308      * The token does not exist.
309      */
310     error ApprovalQueryForNonexistentToken();
311 
312     /**
313      * The caller cannot approve to their own address.
314      */
315     error ApproveToCaller();
316 
317     /**
318      * The caller cannot approve to the current owner.
319      */
320     error ApprovalToCurrentOwner();
321 
322     /**
323      * Cannot query the balance for the zero address.
324      */
325     error BalanceQueryForZeroAddress();
326 
327     /**
328      * Cannot mint to the zero address.
329      */
330     error MintToZeroAddress();
331 
332     /**
333      * The quantity of tokens minted must be more than zero.
334      */
335     error MintZeroQuantity();
336 
337     /**
338      * The token does not exist.
339      */
340     error OwnerQueryForNonexistentToken();
341 
342     /**
343      * The caller must own the token or be an approved operator.
344      */
345     error TransferCallerNotOwnerNorApproved();
346 
347     /**
348      * The token must be owned by `from`.
349      */
350     error TransferFromIncorrectOwner();
351 
352     /**
353      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
354      */
355     error TransferToNonERC721ReceiverImplementer();
356 
357     /**
358      * Cannot transfer to the zero address.
359      */
360     error TransferToZeroAddress();
361 
362     /**
363      * The token does not exist.
364      */
365     error URIQueryForNonexistentToken();
366 
367     struct TokenOwnership {
368         // The address of the owner.
369         address addr;
370         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
371         uint64 startTimestamp;
372         // Whether the token has been burned.
373         bool burned;
374     }
375 
376     /**
377      * @dev Returns the total amount of tokens stored by the contract.
378      *
379      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     // ==============================
384     //            IERC165
385     // ==============================
386 
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30 000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 
397     // ==============================
398     //            IERC721
399     // ==============================
400 
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Transfers `tokenId` token from `from` to `to`.
472      *
473      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
495      *
496      * Requirements:
497      *
498      * - The caller must own the token or be an approved operator.
499      * - `tokenId` must exist.
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address to, uint256 tokenId) external;
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
528      *
529      * See {setApprovalForAll}
530      */
531     function isApprovedForAll(address owner, address operator) external view returns (bool);
532 
533     // ==============================
534     //        IERC721Metadata
535     // ==============================
536 
537     /**
538      * @dev Returns the token collection name.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the token collection symbol.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
549      */
550     function tokenURI(uint256 tokenId) external view returns (string memory);
551 }
552 
553 // File: erc721a/contracts/ERC721A.sol
554 
555 // ERC721A Contracts v4.0.0
556 // Creator: Chiru Labs
557 
558 /**
559  * @dev ERC721 token receiver interface.
560  */
561 interface ERC721A__IERC721Receiver {
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 /**
571  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
572  * the Metadata extension. Built to optimize for lower gas during batch mints.
573  *
574  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
575  *
576  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
577  *
578  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
579  */
580 contract ERC721A is IERC721A {
581     // Mask of an entry in packed address data.
582     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
583 
584     // The bit position of `numberMinted` in packed address data.
585     uint256 private constant BITPOS_NUMBER_MINTED = 64;
586 
587     // The bit position of `numberBurned` in packed address data.
588     uint256 private constant BITPOS_NUMBER_BURNED = 128;
589 
590     // The bit position of `aux` in packed address data.
591     uint256 private constant BITPOS_AUX = 192;
592 
593     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
594     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
595 
596     // The bit position of `startTimestamp` in packed ownership.
597     uint256 private constant BITPOS_START_TIMESTAMP = 160;
598 
599     // The bit mask of the `burned` bit in packed ownership.
600     uint256 private constant BITMASK_BURNED = 1 << 224;
601 
602     // The bit position of the `nextInitialized` bit in packed ownership.
603     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
604 
605     // The bit mask of the `nextInitialized` bit in packed ownership.
606     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
607 
608     // The tokenId of the next token to be minted.
609     uint256 private _currentIndex;
610 
611     // The number of tokens burned.
612     uint256 private _burnCounter;
613 
614     // Token name
615     string private _name;
616 
617     // Token symbol
618     string private _symbol;
619 
620     // Mapping from token ID to ownership details
621     // An empty struct value does not necessarily mean the token is unowned.
622     // See `_packedOwnershipOf` implementation for details.
623     //
624     // Bits Layout:
625     // - [0..159]   `addr`
626     // - [160..223] `startTimestamp`
627     // - [224]      `burned`
628     // - [225]      `nextInitialized`
629     mapping(uint256 => uint256) private _packedOwnerships;
630 
631     // Mapping owner address to address data.
632     //
633     // Bits Layout:
634     // - [0..63]    `balance`
635     // - [64..127]  `numberMinted`
636     // - [128..191] `numberBurned`
637     // - [192..255] `aux`
638     mapping(address => uint256) private _packedAddressData;
639 
640     // Mapping from token ID to approved address.
641     mapping(uint256 => address) private _tokenApprovals;
642 
643     // Mapping from owner to operator approvals
644     mapping(address => mapping(address => bool)) private _operatorApprovals;
645 
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649         _currentIndex = _startTokenId();
650     }
651 
652     /**
653      * @dev Returns the starting token ID.
654      * To change the starting token ID, please override this function.
655      */
656     function _startTokenId() internal view virtual returns (uint256) {
657         return 0;
658     }
659 
660     /**
661      * @dev Returns the next token ID to be minted.
662      */
663     function _nextTokenId() internal view returns (uint256) {
664         return _currentIndex;
665     }
666 
667     /**
668      * @dev Returns the total number of tokens in existence.
669      * Burned tokens will reduce the count.
670      * To get the total number of tokens minted, please see `_totalMinted`.
671      */
672     function totalSupply() public view override returns (uint256) {
673         // Counter underflow is impossible as _burnCounter cannot be incremented
674         // more than `_currentIndex - _startTokenId()` times.
675     unchecked {
676         return _currentIndex - _burnCounter - _startTokenId();
677     }
678     }
679 
680     /**
681      * @dev Returns the total amount of tokens minted in the contract.
682      */
683     function _totalMinted() internal view returns (uint256) {
684         // Counter underflow is impossible as _currentIndex does not decrement,
685         // and it is initialized to `_startTokenId()`
686     unchecked {
687         return _currentIndex - _startTokenId();
688     }
689     }
690 
691     /**
692      * @dev Returns the total number of tokens burned.
693      */
694     function _totalBurned() internal view returns (uint256) {
695         return _burnCounter;
696     }
697 
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702         // The interface IDs are constants representing the first 4 bytes of the XOR of
703         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
704         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
705         return
706         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
707         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
708         interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
709     }
710 
711     /**
712      * @dev See {IERC721-balanceOf}.
713      */
714     function balanceOf(address owner) public view override returns (uint256) {
715         if (owner == address(0)) revert BalanceQueryForZeroAddress();
716         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
717     }
718 
719     /**
720      * Returns the number of tokens minted by `owner`.
721      */
722     function _numberMinted(address owner) internal view returns (uint256) {
723         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
724     }
725 
726     /**
727      * Returns the number of tokens burned by or on behalf of `owner`.
728      */
729     function _numberBurned(address owner) internal view returns (uint256) {
730         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
731     }
732 
733     /**
734      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
735      */
736     function _getAux(address owner) internal view returns (uint64) {
737         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
738     }
739 
740     /**
741      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
742      * If there are multiple variables, please pack them into a uint64.
743      */
744     function _setAux(address owner, uint64 aux) internal {
745         uint256 packed = _packedAddressData[owner];
746         uint256 auxCasted;
747         assembly { // Cast aux without masking.
748             auxCasted := aux
749         }
750         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
751         _packedAddressData[owner] = packed;
752     }
753 
754     /**
755      * Returns the packed ownership data of `tokenId`.
756      */
757     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
758         uint256 curr = tokenId;
759 
760     unchecked {
761         if (_startTokenId() <= curr)
762             if (curr < _currentIndex) {
763                 uint256 packed = _packedOwnerships[curr];
764                 // If not burned.
765                 if (packed & BITMASK_BURNED == 0) {
766                     // Invariant:
767                     // There will always be an ownership that has an address and is not burned
768                     // before an ownership that does not have an address and is not burned.
769                     // Hence, curr will not underflow.
770                     //
771                     // We can directly compare the packed value.
772                     // If the address is zero, packed is zero.
773                     while (packed == 0) {
774                         packed = _packedOwnerships[--curr];
775                     }
776                     return packed;
777                 }
778             }
779     }
780         revert OwnerQueryForNonexistentToken();
781     }
782 
783     /**
784      * Returns the unpacked `TokenOwnership` struct from `packed`.
785      */
786     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
787         ownership.addr = address(uint160(packed));
788         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
789         ownership.burned = packed & BITMASK_BURNED != 0;
790     }
791 
792     /**
793      * Returns the unpacked `TokenOwnership` struct at `index`.
794      */
795     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
796         return _unpackedOwnership(_packedOwnerships[index]);
797     }
798 
799     /**
800      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
801      */
802     function _initializeOwnershipAt(uint256 index) internal {
803         if (_packedOwnerships[index] == 0) {
804             _packedOwnerships[index] = _packedOwnershipOf(index);
805         }
806     }
807 
808     /**
809      * Gas spent here starts off proportional to the maximum mint batch size.
810      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
811      */
812     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
813         return _unpackedOwnership(_packedOwnershipOf(tokenId));
814     }
815 
816     /**
817      * @dev See {IERC721-ownerOf}.
818      */
819     function ownerOf(uint256 tokenId) public view override returns (address) {
820         return address(uint160(_packedOwnershipOf(tokenId)));
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-name}.
825      */
826     function name() public view virtual override returns (string memory) {
827         return _name;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-symbol}.
832      */
833     function symbol() public view virtual override returns (string memory) {
834         return _symbol;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-tokenURI}.
839      */
840     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
841         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
842 
843         string memory baseURI = _baseURI();
844         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
845     }
846 
847     /**
848      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
849      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
850      * by default, can be overriden in child contracts.
851      */
852     function _baseURI() internal view virtual returns (string memory) {
853         return '';
854     }
855 
856     /**
857      * @dev Casts the address to uint256 without masking.
858      */
859     function _addressToUint256(address value) private pure returns (uint256 result) {
860         assembly {
861             result := value
862         }
863     }
864 
865     /**
866      * @dev Casts the boolean to uint256 without branching.
867      */
868     function _boolToUint256(bool value) private pure returns (uint256 result) {
869         assembly {
870             result := value
871         }
872     }
873 
874     /**
875      * @dev See {IERC721-approve}.
876      */
877     function approve(address to, uint256 tokenId) public override {
878         address owner = address(uint160(_packedOwnershipOf(tokenId)));
879         if (to == owner) revert ApprovalToCurrentOwner();
880 
881         if (_msgSenderERC721A() != owner)
882             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
883                 revert ApprovalCallerNotOwnerNorApproved();
884             }
885 
886         _tokenApprovals[tokenId] = to;
887         emit Approval(owner, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view override returns (address) {
894         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public virtual override {
903         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
904 
905         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
906         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public virtual override {
947         _transfer(from, to, tokenId);
948         if (to.code.length != 0)
949             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
950                 revert TransferToNonERC721ReceiverImplementer();
951             }
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return
963         _startTokenId() <= tokenId &&
964         tokenId < _currentIndex && // If within bounds,
965         _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
966     }
967 
968     /**
969      * @dev Equivalent to `_safeMint(to, quantity, '')`.
970      */
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Safely mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - If `to` refers to a smart contract, it must implement
981      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         uint256 startTokenId = _currentIndex;
992         if (to == address(0)) revert MintToZeroAddress();
993         if (quantity == 0) revert MintZeroQuantity();
994 
995         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
996 
997         // Overflows are incredibly unrealistic.
998         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
999         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1000     unchecked {
1001         // Updates:
1002         // - `balance += quantity`.
1003         // - `numberMinted += quantity`.
1004         //
1005         // We can directly add to the balance and number minted.
1006         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1007 
1008         // Updates:
1009         // - `address` to the owner.
1010         // - `startTimestamp` to the timestamp of minting.
1011         // - `burned` to `false`.
1012         // - `nextInitialized` to `quantity == 1`.
1013         _packedOwnerships[startTokenId] =
1014         _addressToUint256(to) |
1015         (block.timestamp << BITPOS_START_TIMESTAMP) |
1016         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1017 
1018         uint256 updatedIndex = startTokenId;
1019         uint256 end = updatedIndex + quantity;
1020 
1021         if (to.code.length != 0) {
1022             do {
1023                 emit Transfer(address(0), to, updatedIndex);
1024                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1025                     revert TransferToNonERC721ReceiverImplementer();
1026                 }
1027             } while (updatedIndex < end);
1028             // Reentrancy protection
1029             if (_currentIndex != startTokenId) revert();
1030         } else {
1031             do {
1032                 emit Transfer(address(0), to, updatedIndex++);
1033             } while (updatedIndex < end);
1034         }
1035         _currentIndex = updatedIndex;
1036     }
1037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1038     }
1039 
1040     /**
1041      * @dev Mints `quantity` tokens and transfers them to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `quantity` must be greater than 0.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _mint(address to, uint256 quantity) internal {
1051         uint256 startTokenId = _currentIndex;
1052         if (to == address(0)) revert MintToZeroAddress();
1053         if (quantity == 0) revert MintZeroQuantity();
1054 
1055         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1056 
1057         // Overflows are incredibly unrealistic.
1058         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1059         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1060     unchecked {
1061         // Updates:
1062         // - `balance += quantity`.
1063         // - `numberMinted += quantity`.
1064         //
1065         // We can directly add to the balance and number minted.
1066         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1067 
1068         // Updates:
1069         // - `address` to the owner.
1070         // - `startTimestamp` to the timestamp of minting.
1071         // - `burned` to `false`.
1072         // - `nextInitialized` to `quantity == 1`.
1073         _packedOwnerships[startTokenId] =
1074         _addressToUint256(to) |
1075         (block.timestamp << BITPOS_START_TIMESTAMP) |
1076         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1077 
1078         uint256 updatedIndex = startTokenId;
1079         uint256 end = updatedIndex + quantity;
1080 
1081         do {
1082             emit Transfer(address(0), to, updatedIndex++);
1083         } while (updatedIndex < end);
1084 
1085         _currentIndex = updatedIndex;
1086     }
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Transfers `tokenId` from `from` to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must be owned by `from`.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _transfer(
1101         address from,
1102         address to,
1103         uint256 tokenId
1104     ) private {
1105         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1106 
1107         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1108 
1109         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1110         isApprovedForAll(from, _msgSenderERC721A()) ||
1111         getApproved(tokenId) == _msgSenderERC721A());
1112 
1113         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1114         if (to == address(0)) revert TransferToZeroAddress();
1115 
1116         _beforeTokenTransfers(from, to, tokenId, 1);
1117 
1118         // Clear approvals from the previous owner.
1119         delete _tokenApprovals[tokenId];
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1124     unchecked {
1125         // We can directly increment and decrement the balances.
1126         --_packedAddressData[from]; // Updates: `balance -= 1`.
1127         ++_packedAddressData[to]; // Updates: `balance += 1`.
1128 
1129         // Updates:
1130         // - `address` to the next owner.
1131         // - `startTimestamp` to the timestamp of transfering.
1132         // - `burned` to `false`.
1133         // - `nextInitialized` to `true`.
1134         _packedOwnerships[tokenId] =
1135         _addressToUint256(to) |
1136         (block.timestamp << BITPOS_START_TIMESTAMP) |
1137         BITMASK_NEXT_INITIALIZED;
1138 
1139         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1140         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1141             uint256 nextTokenId = tokenId + 1;
1142             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1143             if (_packedOwnerships[nextTokenId] == 0) {
1144                 // If the next slot is within bounds.
1145                 if (nextTokenId != _currentIndex) {
1146                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1147                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1148                 }
1149             }
1150         }
1151     }
1152 
1153         emit Transfer(from, to, tokenId);
1154         _afterTokenTransfers(from, to, tokenId, 1);
1155     }
1156 
1157     /**
1158      * @dev Equivalent to `_burn(tokenId, false)`.
1159      */
1160     function _burn(uint256 tokenId) internal virtual {
1161         _burn(tokenId, false);
1162     }
1163 
1164     /**
1165      * @dev Destroys `tokenId`.
1166      * The approval is cleared when the token is burned.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1175         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1176 
1177         address from = address(uint160(prevOwnershipPacked));
1178 
1179         if (approvalCheck) {
1180             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1181             isApprovedForAll(from, _msgSenderERC721A()) ||
1182             getApproved(tokenId) == _msgSenderERC721A());
1183 
1184             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         }
1186 
1187         _beforeTokenTransfers(from, address(0), tokenId, 1);
1188 
1189         // Clear approvals from the previous owner.
1190         delete _tokenApprovals[tokenId];
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195     unchecked {
1196         // Updates:
1197         // - `balance -= 1`.
1198         // - `numberBurned += 1`.
1199         //
1200         // We can directly decrement the balance, and increment the number burned.
1201         // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1202         _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1203 
1204         // Updates:
1205         // - `address` to the last owner.
1206         // - `startTimestamp` to the timestamp of burning.
1207         // - `burned` to `true`.
1208         // - `nextInitialized` to `true`.
1209         _packedOwnerships[tokenId] =
1210         _addressToUint256(from) |
1211         (block.timestamp << BITPOS_START_TIMESTAMP) |
1212         BITMASK_BURNED |
1213         BITMASK_NEXT_INITIALIZED;
1214 
1215         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1216         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1217             uint256 nextTokenId = tokenId + 1;
1218             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1219             if (_packedOwnerships[nextTokenId] == 0) {
1220                 // If the next slot is within bounds.
1221                 if (nextTokenId != _currentIndex) {
1222                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1223                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1224                 }
1225             }
1226         }
1227     }
1228 
1229         emit Transfer(from, address(0), tokenId);
1230         _afterTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1233     unchecked {
1234         _burnCounter++;
1235     }
1236     }
1237 
1238     /**
1239      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1240      *
1241      * @param from address representing the previous owner of the given token ID
1242      * @param to target address that will receive the tokens
1243      * @param tokenId uint256 ID of the token to be transferred
1244      * @param _data bytes optional data to send along with the call
1245      * @return bool whether the call correctly returned the expected magic value
1246      */
1247     function _checkContractOnERC721Received(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) private returns (bool) {
1253         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1254             bytes4 retval
1255         ) {
1256             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1257         } catch (bytes memory reason) {
1258             if (reason.length == 0) {
1259                 revert TransferToNonERC721ReceiverImplementer();
1260             } else {
1261                 assembly {
1262                     revert(add(32, reason), mload(reason))
1263                 }
1264             }
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1270      * And also called before burning one token.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, `tokenId` will be burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _beforeTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1292      * minting.
1293      * And also called after one token has been burned.
1294      *
1295      * startTokenId - the first token id to be transferred
1296      * quantity - the amount to be transferred
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` has been minted for `to`.
1303      * - When `to` is zero, `tokenId` has been burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _afterTokenTransfers(
1307         address from,
1308         address to,
1309         uint256 startTokenId,
1310         uint256 quantity
1311     ) internal virtual {}
1312 
1313     /**
1314      * @dev Returns the message sender (defaults to `msg.sender`).
1315      *
1316      * If you are writing GSN compatible contracts, you need to override this function.
1317      */
1318     function _msgSenderERC721A() internal view virtual returns (address) {
1319         return msg.sender;
1320     }
1321 
1322     /**
1323      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1324      */
1325     function _toString(uint256 value) internal pure returns (string memory ptr) {
1326         assembly {
1327         // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1328         // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1329         // We will need 1 32-byte word to store the length,
1330         // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1331             ptr := add(mload(0x40), 128)
1332         // Update the free memory pointer to allocate.
1333             mstore(0x40, ptr)
1334 
1335         // Cache the end of the memory to calculate the length later.
1336             let end := ptr
1337 
1338         // We write the string from the rightmost digit to the leftmost digit.
1339         // The following is essentially a do-while loop that also handles the zero case.
1340         // Costs a bit more than early returning for the zero case,
1341         // but cheaper in terms of deployment and overall runtime costs.
1342             for {
1343             // Initialize and perform the first pass without check.
1344                 let temp := value
1345             // Move the pointer 1 byte leftwards to point to an empty character slot.
1346                 ptr := sub(ptr, 1)
1347             // Write the character to the pointer. 48 is the ASCII index of '0'.
1348                 mstore8(ptr, add(48, mod(temp, 10)))
1349                 temp := div(temp, 10)
1350             } temp {
1351             // Keep dividing `temp` until zero.
1352                 temp := div(temp, 10)
1353             } { // Body of the for loop.
1354                 ptr := sub(ptr, 1)
1355                 mstore8(ptr, add(48, mod(temp, 10)))
1356             }
1357 
1358             let length := sub(end, ptr)
1359         // Move the pointer 32 bytes leftwards to make room for the length.
1360             ptr := sub(ptr, 32)
1361         // Store the length.
1362             mstore(ptr, length)
1363         }
1364     }
1365 }
1366 
1367 // File: contracts/WeAreAnimals.sol
1368 
1369 
1370 contract WeAreAnimals is ERC721A, ERC2981, Ownable {
1371     enum Status {
1372         Waiting,
1373         Started,
1374         Finished,
1375         AllowListOnly
1376     }
1377 
1378     Status public status;
1379     string public baseURI;
1380     uint256 public constant MAX_MINT_PER_ADDR = 4;
1381     uint256 public constant MAX_SUPPLY = 1111;
1382     uint256 public constant PRICE = 0.02022 * 10 ** 18; // 0.01 ETH
1383 
1384     address public royaltyReceiver = 0x0862a6B1767c66d486a833A52f04836CEBe1E1e0;
1385     uint96 public royaltyFeeNumerator = 500;
1386 
1387     mapping(address => uint256) public allowlist;
1388 
1389     event Minted(address minter, uint256 amount);
1390     event StatusChanged(Status status);
1391     event BaseURIChanged(string newBaseURI);
1392 
1393     constructor(string memory initBaseURI) ERC721A("WeAreAnimals", "WAA") {
1394         baseURI = initBaseURI;
1395         _setDefaultRoyalty(royaltyReceiver, royaltyFeeNumerator);
1396     }
1397 
1398     function _baseURI() internal view override returns (string memory) {
1399         return baseURI;
1400     }
1401 
1402     function mint(uint256 quantity) external payable {
1403         require(status == Status.Started, "WeAreAnimals: minting is not started");
1404         require(tx.origin == msg.sender, "WeAreAnimals: you are not the owner");
1405         require(numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR, "WeAreAnimals: you have already minted too many NFT");
1406         require(totalSupply() + quantity <= MAX_SUPPLY, "WeAreAnimals: total supply is too high");
1407 
1408         _safeMint(msg.sender, quantity);
1409         refundIfOver(PRICE * quantity);
1410 
1411         emit Minted(msg.sender, quantity);
1412     }
1413 
1414     function allowlistMint(uint256 quantity) external payable {
1415         require(allowlist[msg.sender] > 0, "WeAreAnimals: you are not on the allowlist");
1416         require(status == Status.Started || status == Status.AllowListOnly, "WeAreAnimals: allowlist minting is not started");
1417         require(tx.origin == msg.sender, "WeAreAnimals: ");
1418         require(quantity <= allowlist[msg.sender], "WeAreAnimals: you have already minted too many NFT");
1419         require(totalSupply() + quantity <= MAX_SUPPLY, "WeAreAnimals: total supply is too high");
1420 
1421         allowlist[msg.sender] = allowlist[msg.sender] - quantity;
1422         _safeMint(msg.sender, quantity);
1423 
1424         emit Minted(msg.sender, quantity);
1425     }
1426 
1427     function seedAllowlist(address[] memory addresses, uint256[] memory numSlots) external onlyOwner {
1428         require(addresses.length == numSlots.length, "WeAreAnimals: addresses and numSlots must have the same length");
1429 
1430         for (uint256 i = 0; i < addresses.length; i++) {
1431             allowlist[addresses[i]] = numSlots[i];
1432         }
1433     }
1434 
1435     function numberMinted(address owner) public view returns (uint256) {
1436         return _numberMinted(owner);
1437     }
1438 
1439     function refundIfOver(uint256 price) private {
1440         require(msg.value >= price, "WeAreAnimals: you don't have enough ETH");
1441 
1442         if (msg.value > price) {
1443             payable(msg.sender).transfer(msg.value - price);
1444         }
1445     }
1446 
1447     function setStatus(Status newStatus) external onlyOwner {
1448         status = newStatus;
1449 
1450         emit StatusChanged(status);
1451     }
1452 
1453     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1454         baseURI = newBaseURI;
1455 
1456         emit BaseURIChanged(newBaseURI);
1457     }
1458 
1459     function withdraw(address payable recipient) external onlyOwner {
1460         uint256 balance = address(this).balance;
1461         (bool success,) = recipient.call{value : balance}("");
1462         require(success, "WeAreAnimals: recipient failed to receive ETH");
1463     }
1464 
1465     function setRoyaltyFee(uint96 newRoyaltyFeeNumerator) external onlyOwner {
1466         royaltyFeeNumerator = newRoyaltyFeeNumerator;
1467         _setDefaultRoyalty(royaltyReceiver, royaltyFeeNumerator);
1468     }
1469 
1470     function setRoyaltyAddress(address newRoyaltyReceiver) external onlyOwner {
1471         royaltyReceiver = newRoyaltyReceiver;
1472         _setDefaultRoyalty(royaltyReceiver, royaltyFeeNumerator);
1473     }
1474 
1475     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1476         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
1477     }
1478 }