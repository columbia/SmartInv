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
200 // File: @openzeppelin/contracts/utils/Strings.sol
201 
202 
203 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev String operations.
209  */
210 library Strings {
211     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
212     uint8 private constant _ADDRESS_LENGTH = 20;
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
216      */
217     function toString(uint256 value) internal pure returns (string memory) {
218         // Inspired by OraclizeAPI's implementation - MIT licence
219         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
220 
221         if (value == 0) {
222             return "0";
223         }
224         uint256 temp = value;
225         uint256 digits;
226         while (temp != 0) {
227             digits++;
228             temp /= 10;
229         }
230         bytes memory buffer = new bytes(digits);
231         while (value != 0) {
232             digits -= 1;
233             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
234             value /= 10;
235         }
236         return string(buffer);
237     }
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
241      */
242     function toHexString(uint256 value) internal pure returns (string memory) {
243         if (value == 0) {
244             return "0x00";
245         }
246         uint256 temp = value;
247         uint256 length = 0;
248         while (temp != 0) {
249             length++;
250             temp >>= 8;
251         }
252         return toHexString(value, length);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
257      */
258     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
259         bytes memory buffer = new bytes(2 * length + 2);
260         buffer[0] = "0";
261         buffer[1] = "x";
262         for (uint256 i = 2 * length + 1; i > 1; --i) {
263             buffer[i] = _HEX_SYMBOLS[value & 0xf];
264             value >>= 4;
265         }
266         require(value == 0, "Strings: hex length insufficient");
267         return string(buffer);
268     }
269 
270     /**
271      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
272      */
273     function toHexString(address addr) internal pure returns (string memory) {
274         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Contract module that helps prevent reentrant calls to a function.
287  *
288  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
289  * available, which can be applied to functions to make sure there are no nested
290  * (reentrant) calls to them.
291  *
292  * Note that because there is a single `nonReentrant` guard, functions marked as
293  * `nonReentrant` may not call one another. This can be worked around by making
294  * those functions `private`, and then adding `external` `nonReentrant` entry
295  * points to them.
296  *
297  * TIP: If you would like to learn more about reentrancy and alternative ways
298  * to protect against it, check out our blog post
299  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
300  */
301 abstract contract ReentrancyGuard {
302     // Booleans are more expensive than uint256 or any type that takes up a full
303     // word because each write operation emits an extra SLOAD to first read the
304     // slot's contents, replace the bits taken up by the boolean, and then write
305     // back. This is the compiler's defense against contract upgrades and
306     // pointer aliasing, and it cannot be disabled.
307 
308     // The values being non-zero value makes deployment a bit more expensive,
309     // but in exchange the refund on every call to nonReentrant will be lower in
310     // amount. Since refunds are capped to a percentage of the total
311     // transaction's gas, it is best to keep them low in cases like this one, to
312     // increase the likelihood of the full refund coming into effect.
313     uint256 private constant _NOT_ENTERED = 1;
314     uint256 private constant _ENTERED = 2;
315 
316     uint256 private _status;
317 
318     constructor() {
319         _status = _NOT_ENTERED;
320     }
321 
322     /**
323      * @dev Prevents a contract from calling itself, directly or indirectly.
324      * Calling a `nonReentrant` function from another `nonReentrant`
325      * function is not supported. It is possible to prevent this from happening
326      * by making the `nonReentrant` function external, and making it call a
327      * `private` function that does the actual work.
328      */
329     modifier nonReentrant() {
330         // On the first call to nonReentrant, _notEntered will be true
331         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
332 
333         // Any calls to nonReentrant after this point will fail
334         _status = _ENTERED;
335 
336         _;
337 
338         // By storing the original value once again, a refund is triggered (see
339         // https://eips.ethereum.org/EIPS/eip-2200)
340         _status = _NOT_ENTERED;
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Context.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes calldata) {
367         return msg.data;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/access/Ownable.sol
372 
373 
374 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Contract module which provides a basic access control mechanism, where
381  * there is an account (an owner) that can be granted exclusive access to
382  * specific functions.
383  *
384  * By default, the owner account will be the one that deploys the contract. This
385  * can later be changed with {transferOwnership}.
386  *
387  * This module is used through inheritance. It will make available the modifier
388  * `onlyOwner`, which can be applied to your functions to restrict their use to
389  * the owner.
390  */
391 abstract contract Ownable is Context {
392     address private _owner;
393 
394     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
395 
396     /**
397      * @dev Initializes the contract setting the deployer as the initial owner.
398      */
399     constructor() {
400         _transferOwnership(_msgSender());
401     }
402 
403     /**
404      * @dev Throws if called by any account other than the owner.
405      */
406     modifier onlyOwner() {
407         _checkOwner();
408         _;
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view virtual returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if the sender is not the owner.
420      */
421     function _checkOwner() internal view virtual {
422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         _transferOwnership(address(0));
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         _transferOwnership(newOwner);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Internal function without access restriction.
448      */
449     function _transferOwnership(address newOwner) internal virtual {
450         address oldOwner = _owner;
451         _owner = newOwner;
452         emit OwnershipTransferred(oldOwner, newOwner);
453     }
454 }
455 
456 // File: erc721a/contracts/IERC721A.sol
457 
458 
459 // ERC721A Contracts v4.2.3
460 // Creator: Chiru Labs
461 
462 pragma solidity ^0.8.4;
463 
464 /**
465  * @dev Interface of ERC721A.
466  */
467 interface IERC721A {
468     /**
469      * The caller must own the token or be an approved operator.
470      */
471     error ApprovalCallerNotOwnerNorApproved();
472 
473     /**
474      * The token does not exist.
475      */
476     error ApprovalQueryForNonexistentToken();
477 
478     /**
479      * Cannot query the balance for the zero address.
480      */
481     error BalanceQueryForZeroAddress();
482 
483     /**
484      * Cannot mint to the zero address.
485      */
486     error MintToZeroAddress();
487 
488     /**
489      * The quantity of tokens minted must be more than zero.
490      */
491     error MintZeroQuantity();
492 
493     /**
494      * The token does not exist.
495      */
496     error OwnerQueryForNonexistentToken();
497 
498     /**
499      * The caller must own the token or be an approved operator.
500      */
501     error TransferCallerNotOwnerNorApproved();
502 
503     /**
504      * The token must be owned by `from`.
505      */
506     error TransferFromIncorrectOwner();
507 
508     /**
509      * Cannot safely transfer to a contract that does not implement the
510      * ERC721Receiver interface.
511      */
512     error TransferToNonERC721ReceiverImplementer();
513 
514     /**
515      * Cannot transfer to the zero address.
516      */
517     error TransferToZeroAddress();
518 
519     /**
520      * The token does not exist.
521      */
522     error URIQueryForNonexistentToken();
523 
524     /**
525      * The `quantity` minted with ERC2309 exceeds the safety limit.
526      */
527     error MintERC2309QuantityExceedsLimit();
528 
529     /**
530      * The `extraData` cannot be set on an unintialized ownership slot.
531      */
532     error OwnershipNotInitializedForExtraData();
533 
534     // =============================================================
535     //                            STRUCTS
536     // =============================================================
537 
538     struct TokenOwnership {
539         // The address of the owner.
540         address addr;
541         // Stores the start time of ownership with minimal overhead for tokenomics.
542         uint64 startTimestamp;
543         // Whether the token has been burned.
544         bool burned;
545         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
546         uint24 extraData;
547     }
548 
549     // =============================================================
550     //                         TOKEN COUNTERS
551     // =============================================================
552 
553     /**
554      * @dev Returns the total number of tokens in existence.
555      * Burned tokens will reduce the count.
556      * To get the total number of tokens minted, please see {_totalMinted}.
557      */
558     function totalSupply() external view returns (uint256);
559 
560     // =============================================================
561     //                            IERC165
562     // =============================================================
563 
564     /**
565      * @dev Returns true if this contract implements the interface defined by
566      * `interfaceId`. See the corresponding
567      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
568      * to learn more about how these ids are created.
569      *
570      * This function call must use less than 30000 gas.
571      */
572     function supportsInterface(bytes4 interfaceId) external view returns (bool);
573 
574     // =============================================================
575     //                            IERC721
576     // =============================================================
577 
578     /**
579      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
580      */
581     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
582 
583     /**
584      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
585      */
586     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables or disables
590      * (`approved`) `operator` to manage all of its assets.
591      */
592     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
593 
594     /**
595      * @dev Returns the number of tokens in `owner`'s account.
596      */
597     function balanceOf(address owner) external view returns (uint256 balance);
598 
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) external view returns (address owner);
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`,
610      * checking first that contract recipients are aware of the ERC721 protocol
611      * to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be have been allowed to move
619      * this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement
621      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId,
629         bytes calldata data
630     ) external payable;
631 
632     /**
633      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external payable;
640 
641     /**
642      * @dev Transfers `tokenId` from `from` to `to`.
643      *
644      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
645      * whenever possible.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must be owned by `from`.
652      * - If the caller is not `from`, it must be approved to move this token
653      * by either {approve} or {setApprovalForAll}.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) external payable;
662 
663     /**
664      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
665      * The approval is cleared when the token is transferred.
666      *
667      * Only a single account can be approved at a time, so approving the
668      * zero address clears previous approvals.
669      *
670      * Requirements:
671      *
672      * - The caller must own the token or be an approved operator.
673      * - `tokenId` must exist.
674      *
675      * Emits an {Approval} event.
676      */
677     function approve(address to, uint256 tokenId) external payable;
678 
679     /**
680      * @dev Approve or remove `operator` as an operator for the caller.
681      * Operators can call {transferFrom} or {safeTransferFrom}
682      * for any token owned by the caller.
683      *
684      * Requirements:
685      *
686      * - The `operator` cannot be the caller.
687      *
688      * Emits an {ApprovalForAll} event.
689      */
690     function setApprovalForAll(address operator, bool _approved) external;
691 
692     /**
693      * @dev Returns the account approved for `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function getApproved(uint256 tokenId) external view returns (address operator);
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}.
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 
708     // =============================================================
709     //                        IERC721Metadata
710     // =============================================================
711 
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 
727     // =============================================================
728     //                           IERC2309
729     // =============================================================
730 
731     /**
732      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
733      * (inclusive) is transferred from `from` to `to`, as defined in the
734      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
735      *
736      * See {_mintERC2309} for more details.
737      */
738     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
739 }
740 
741 // File: erc721a/contracts/ERC721A.sol
742 
743 
744 // ERC721A Contracts v4.2.3
745 // Creator: Chiru Labs
746 
747 pragma solidity ^0.8.4;
748 
749 
750 /**
751  * @dev Interface of ERC721 token receiver.
752  */
753 interface ERC721A__IERC721Receiver {
754     function onERC721Received(
755         address operator,
756         address from,
757         uint256 tokenId,
758         bytes calldata data
759     ) external returns (bytes4);
760 }
761 
762 /**
763  * @title ERC721A
764  *
765  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
766  * Non-Fungible Token Standard, including the Metadata extension.
767  * Optimized for lower gas during batch mints.
768  *
769  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
770  * starting from `_startTokenId()`.
771  *
772  * Assumptions:
773  *
774  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
775  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
776  */
777 contract ERC721A is IERC721A {
778     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
779     struct TokenApprovalRef {
780         address value;
781     }
782 
783     // =============================================================
784     //                           CONSTANTS
785     // =============================================================
786 
787     // Mask of an entry in packed address data.
788     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
789 
790     // The bit position of `numberMinted` in packed address data.
791     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
792 
793     // The bit position of `numberBurned` in packed address data.
794     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
795 
796     // The bit position of `aux` in packed address data.
797     uint256 private constant _BITPOS_AUX = 192;
798 
799     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
800     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
801 
802     // The bit position of `startTimestamp` in packed ownership.
803     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
804 
805     // The bit mask of the `burned` bit in packed ownership.
806     uint256 private constant _BITMASK_BURNED = 1 << 224;
807 
808     // The bit position of the `nextInitialized` bit in packed ownership.
809     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
810 
811     // The bit mask of the `nextInitialized` bit in packed ownership.
812     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
813 
814     // The bit position of `extraData` in packed ownership.
815     uint256 private constant _BITPOS_EXTRA_DATA = 232;
816 
817     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
818     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
819 
820     // The mask of the lower 160 bits for addresses.
821     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
822 
823     // The maximum `quantity` that can be minted with {_mintERC2309}.
824     // This limit is to prevent overflows on the address data entries.
825     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
826     // is required to cause an overflow, which is unrealistic.
827     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
828 
829     // The `Transfer` event signature is given by:
830     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
831     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
832         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
833 
834     // =============================================================
835     //                            STORAGE
836     // =============================================================
837 
838     // The next token ID to be minted.
839     uint256 private _currentIndex;
840 
841     // The number of tokens burned.
842     uint256 private _burnCounter;
843 
844     // Token name
845     string private _name;
846 
847     // Token symbol
848     string private _symbol;
849 
850     // Mapping from token ID to ownership details
851     // An empty struct value does not necessarily mean the token is unowned.
852     // See {_packedOwnershipOf} implementation for details.
853     //
854     // Bits Layout:
855     // - [0..159]   `addr`
856     // - [160..223] `startTimestamp`
857     // - [224]      `burned`
858     // - [225]      `nextInitialized`
859     // - [232..255] `extraData`
860     mapping(uint256 => uint256) private _packedOwnerships;
861 
862     // Mapping owner address to address data.
863     //
864     // Bits Layout:
865     // - [0..63]    `balance`
866     // - [64..127]  `numberMinted`
867     // - [128..191] `numberBurned`
868     // - [192..255] `aux`
869     mapping(address => uint256) private _packedAddressData;
870 
871     // Mapping from token ID to approved address.
872     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
873 
874     // Mapping from owner to operator approvals
875     mapping(address => mapping(address => bool)) private _operatorApprovals;
876 
877     // =============================================================
878     //                          CONSTRUCTOR
879     // =============================================================
880 
881     constructor(string memory name_, string memory symbol_) {
882         _name = name_;
883         _symbol = symbol_;
884         _currentIndex = _startTokenId();
885     }
886 
887     // =============================================================
888     //                   TOKEN COUNTING OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Returns the starting token ID.
893      * To change the starting token ID, please override this function.
894      */
895     function _startTokenId() internal view virtual returns (uint256) {
896         return 0;
897     }
898 
899     /**
900      * @dev Returns the next token ID to be minted.
901      */
902     function _nextTokenId() internal view virtual returns (uint256) {
903         return _currentIndex;
904     }
905 
906     /**
907      * @dev Returns the total number of tokens in existence.
908      * Burned tokens will reduce the count.
909      * To get the total number of tokens minted, please see {_totalMinted}.
910      */
911     function totalSupply() public view virtual override returns (uint256) {
912         // Counter underflow is impossible as _burnCounter cannot be incremented
913         // more than `_currentIndex - _startTokenId()` times.
914         unchecked {
915             return _currentIndex - _burnCounter - _startTokenId();
916         }
917     }
918 
919     /**
920      * @dev Returns the total amount of tokens minted in the contract.
921      */
922     function _totalMinted() internal view virtual returns (uint256) {
923         // Counter underflow is impossible as `_currentIndex` does not decrement,
924         // and it is initialized to `_startTokenId()`.
925         unchecked {
926             return _currentIndex - _startTokenId();
927         }
928     }
929 
930     /**
931      * @dev Returns the total number of tokens burned.
932      */
933     function _totalBurned() internal view virtual returns (uint256) {
934         return _burnCounter;
935     }
936 
937     // =============================================================
938     //                    ADDRESS DATA OPERATIONS
939     // =============================================================
940 
941     /**
942      * @dev Returns the number of tokens in `owner`'s account.
943      */
944     function balanceOf(address owner) public view virtual override returns (uint256) {
945         if (owner == address(0)) revert BalanceQueryForZeroAddress();
946         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
947     }
948 
949     /**
950      * Returns the number of tokens minted by `owner`.
951      */
952     function _numberMinted(address owner) internal view returns (uint256) {
953         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
954     }
955 
956     /**
957      * Returns the number of tokens burned by or on behalf of `owner`.
958      */
959     function _numberBurned(address owner) internal view returns (uint256) {
960         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
961     }
962 
963     /**
964      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
965      */
966     function _getAux(address owner) internal view returns (uint64) {
967         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
968     }
969 
970     /**
971      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
972      * If there are multiple variables, please pack them into a uint64.
973      */
974     function _setAux(address owner, uint64 aux) internal virtual {
975         uint256 packed = _packedAddressData[owner];
976         uint256 auxCasted;
977         // Cast `aux` with assembly to avoid redundant masking.
978         assembly {
979             auxCasted := aux
980         }
981         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
982         _packedAddressData[owner] = packed;
983     }
984 
985     // =============================================================
986     //                            IERC165
987     // =============================================================
988 
989     /**
990      * @dev Returns true if this contract implements the interface defined by
991      * `interfaceId`. See the corresponding
992      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
993      * to learn more about how these ids are created.
994      *
995      * This function call must use less than 30000 gas.
996      */
997     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
998         // The interface IDs are constants representing the first 4 bytes
999         // of the XOR of all function selectors in the interface.
1000         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1001         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1002         return
1003             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1004             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1005             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1006     }
1007 
1008     // =============================================================
1009     //                        IERC721Metadata
1010     // =============================================================
1011 
1012     /**
1013      * @dev Returns the token collection name.
1014      */
1015     function name() public view virtual override returns (string memory) {
1016         return _name;
1017     }
1018 
1019     /**
1020      * @dev Returns the token collection symbol.
1021      */
1022     function symbol() public view virtual override returns (string memory) {
1023         return _symbol;
1024     }
1025 
1026     /**
1027      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1028      */
1029     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1030         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1031 
1032         string memory baseURI = _baseURI();
1033         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1034     }
1035 
1036     /**
1037      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1038      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1039      * by default, it can be overridden in child contracts.
1040      */
1041     function _baseURI() internal view virtual returns (string memory) {
1042         return '';
1043     }
1044 
1045     // =============================================================
1046     //                     OWNERSHIPS OPERATIONS
1047     // =============================================================
1048 
1049     /**
1050      * @dev Returns the owner of the `tokenId` token.
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must exist.
1055      */
1056     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1057         return address(uint160(_packedOwnershipOf(tokenId)));
1058     }
1059 
1060     /**
1061      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1062      * It gradually moves to O(1) as tokens get transferred around over time.
1063      */
1064     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1065         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1066     }
1067 
1068     /**
1069      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1070      */
1071     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1072         return _unpackedOwnership(_packedOwnerships[index]);
1073     }
1074 
1075     /**
1076      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1077      */
1078     function _initializeOwnershipAt(uint256 index) internal virtual {
1079         if (_packedOwnerships[index] == 0) {
1080             _packedOwnerships[index] = _packedOwnershipOf(index);
1081         }
1082     }
1083 
1084     /**
1085      * Returns the packed ownership data of `tokenId`.
1086      */
1087     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1088         uint256 curr = tokenId;
1089 
1090         unchecked {
1091             if (_startTokenId() <= curr)
1092                 if (curr < _currentIndex) {
1093                     uint256 packed = _packedOwnerships[curr];
1094                     // If not burned.
1095                     if (packed & _BITMASK_BURNED == 0) {
1096                         // Invariant:
1097                         // There will always be an initialized ownership slot
1098                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1099                         // before an unintialized ownership slot
1100                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1101                         // Hence, `curr` will not underflow.
1102                         //
1103                         // We can directly compare the packed value.
1104                         // If the address is zero, packed will be zero.
1105                         while (packed == 0) {
1106                             packed = _packedOwnerships[--curr];
1107                         }
1108                         return packed;
1109                     }
1110                 }
1111         }
1112         revert OwnerQueryForNonexistentToken();
1113     }
1114 
1115     /**
1116      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1117      */
1118     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1119         ownership.addr = address(uint160(packed));
1120         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1121         ownership.burned = packed & _BITMASK_BURNED != 0;
1122         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1123     }
1124 
1125     /**
1126      * @dev Packs ownership data into a single uint256.
1127      */
1128     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1129         assembly {
1130             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1131             owner := and(owner, _BITMASK_ADDRESS)
1132             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1133             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1134         }
1135     }
1136 
1137     /**
1138      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1139      */
1140     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1141         // For branchless setting of the `nextInitialized` flag.
1142         assembly {
1143             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1144             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1145         }
1146     }
1147 
1148     // =============================================================
1149     //                      APPROVAL OPERATIONS
1150     // =============================================================
1151 
1152     /**
1153      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1154      * The approval is cleared when the token is transferred.
1155      *
1156      * Only a single account can be approved at a time, so approving the
1157      * zero address clears previous approvals.
1158      *
1159      * Requirements:
1160      *
1161      * - The caller must own the token or be an approved operator.
1162      * - `tokenId` must exist.
1163      *
1164      * Emits an {Approval} event.
1165      */
1166     function approve(address to, uint256 tokenId) public payable virtual override {
1167         address owner = ownerOf(tokenId);
1168 
1169         if (_msgSenderERC721A() != owner)
1170             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1171                 revert ApprovalCallerNotOwnerNorApproved();
1172             }
1173 
1174         _tokenApprovals[tokenId].value = to;
1175         emit Approval(owner, to, tokenId);
1176     }
1177 
1178     /**
1179      * @dev Returns the account approved for `tokenId` token.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      */
1185     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1186         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1187 
1188         return _tokenApprovals[tokenId].value;
1189     }
1190 
1191     /**
1192      * @dev Approve or remove `operator` as an operator for the caller.
1193      * Operators can call {transferFrom} or {safeTransferFrom}
1194      * for any token owned by the caller.
1195      *
1196      * Requirements:
1197      *
1198      * - The `operator` cannot be the caller.
1199      *
1200      * Emits an {ApprovalForAll} event.
1201      */
1202     function setApprovalForAll(address operator, bool approved) public virtual override {
1203         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1204         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1205     }
1206 
1207     /**
1208      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1209      *
1210      * See {setApprovalForAll}.
1211      */
1212     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1213         return _operatorApprovals[owner][operator];
1214     }
1215 
1216     /**
1217      * @dev Returns whether `tokenId` exists.
1218      *
1219      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1220      *
1221      * Tokens start existing when they are minted. See {_mint}.
1222      */
1223     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1224         return
1225             _startTokenId() <= tokenId &&
1226             tokenId < _currentIndex && // If within bounds,
1227             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1228     }
1229 
1230     /**
1231      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1232      */
1233     function _isSenderApprovedOrOwner(
1234         address approvedAddress,
1235         address owner,
1236         address msgSender
1237     ) private pure returns (bool result) {
1238         assembly {
1239             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1240             owner := and(owner, _BITMASK_ADDRESS)
1241             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1242             msgSender := and(msgSender, _BITMASK_ADDRESS)
1243             // `msgSender == owner || msgSender == approvedAddress`.
1244             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1245         }
1246     }
1247 
1248     /**
1249      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1250      */
1251     function _getApprovedSlotAndAddress(uint256 tokenId)
1252         private
1253         view
1254         returns (uint256 approvedAddressSlot, address approvedAddress)
1255     {
1256         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1257         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1258         assembly {
1259             approvedAddressSlot := tokenApproval.slot
1260             approvedAddress := sload(approvedAddressSlot)
1261         }
1262     }
1263 
1264     // =============================================================
1265     //                      TRANSFER OPERATIONS
1266     // =============================================================
1267 
1268     /**
1269      * @dev Transfers `tokenId` from `from` to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `from` cannot be the zero address.
1274      * - `to` cannot be the zero address.
1275      * - `tokenId` token must be owned by `from`.
1276      * - If the caller is not `from`, it must be approved to move this token
1277      * by either {approve} or {setApprovalForAll}.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function transferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) public payable virtual override {
1286         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1287 
1288         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1289 
1290         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1291 
1292         // The nested ifs save around 20+ gas over a compound boolean condition.
1293         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1294             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1295 
1296         if (to == address(0)) revert TransferToZeroAddress();
1297 
1298         _beforeTokenTransfers(from, to, tokenId, 1);
1299 
1300         // Clear approvals from the previous owner.
1301         assembly {
1302             if approvedAddress {
1303                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1304                 sstore(approvedAddressSlot, 0)
1305             }
1306         }
1307 
1308         // Underflow of the sender's balance is impossible because we check for
1309         // ownership above and the recipient's balance can't realistically overflow.
1310         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1311         unchecked {
1312             // We can directly increment and decrement the balances.
1313             --_packedAddressData[from]; // Updates: `balance -= 1`.
1314             ++_packedAddressData[to]; // Updates: `balance += 1`.
1315 
1316             // Updates:
1317             // - `address` to the next owner.
1318             // - `startTimestamp` to the timestamp of transfering.
1319             // - `burned` to `false`.
1320             // - `nextInitialized` to `true`.
1321             _packedOwnerships[tokenId] = _packOwnershipData(
1322                 to,
1323                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1324             );
1325 
1326             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1327             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1328                 uint256 nextTokenId = tokenId + 1;
1329                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1330                 if (_packedOwnerships[nextTokenId] == 0) {
1331                     // If the next slot is within bounds.
1332                     if (nextTokenId != _currentIndex) {
1333                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1334                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1335                     }
1336                 }
1337             }
1338         }
1339 
1340         emit Transfer(from, to, tokenId);
1341         _afterTokenTransfers(from, to, tokenId, 1);
1342     }
1343 
1344     /**
1345      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1346      */
1347     function safeTransferFrom(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) public payable virtual override {
1352         safeTransferFrom(from, to, tokenId, '');
1353     }
1354 
1355     /**
1356      * @dev Safely transfers `tokenId` token from `from` to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - `from` cannot be the zero address.
1361      * - `to` cannot be the zero address.
1362      * - `tokenId` token must exist and be owned by `from`.
1363      * - If the caller is not `from`, it must be approved to move this token
1364      * by either {approve} or {setApprovalForAll}.
1365      * - If `to` refers to a smart contract, it must implement
1366      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function safeTransferFrom(
1371         address from,
1372         address to,
1373         uint256 tokenId,
1374         bytes memory _data
1375     ) public payable virtual override {
1376         transferFrom(from, to, tokenId);
1377         if (to.code.length != 0)
1378             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1379                 revert TransferToNonERC721ReceiverImplementer();
1380             }
1381     }
1382 
1383     /**
1384      * @dev Hook that is called before a set of serially-ordered token IDs
1385      * are about to be transferred. This includes minting.
1386      * And also called before burning one token.
1387      *
1388      * `startTokenId` - the first token ID to be transferred.
1389      * `quantity` - the amount to be transferred.
1390      *
1391      * Calling conditions:
1392      *
1393      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1394      * transferred to `to`.
1395      * - When `from` is zero, `tokenId` will be minted for `to`.
1396      * - When `to` is zero, `tokenId` will be burned by `from`.
1397      * - `from` and `to` are never both zero.
1398      */
1399     function _beforeTokenTransfers(
1400         address from,
1401         address to,
1402         uint256 startTokenId,
1403         uint256 quantity
1404     ) internal virtual {}
1405 
1406     /**
1407      * @dev Hook that is called after a set of serially-ordered token IDs
1408      * have been transferred. This includes minting.
1409      * And also called after one token has been burned.
1410      *
1411      * `startTokenId` - the first token ID to be transferred.
1412      * `quantity` - the amount to be transferred.
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` has been minted for `to`.
1419      * - When `to` is zero, `tokenId` has been burned by `from`.
1420      * - `from` and `to` are never both zero.
1421      */
1422     function _afterTokenTransfers(
1423         address from,
1424         address to,
1425         uint256 startTokenId,
1426         uint256 quantity
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1431      *
1432      * `from` - Previous owner of the given token ID.
1433      * `to` - Target address that will receive the token.
1434      * `tokenId` - Token ID to be transferred.
1435      * `_data` - Optional data to send along with the call.
1436      *
1437      * Returns whether the call correctly returned the expected magic value.
1438      */
1439     function _checkContractOnERC721Received(
1440         address from,
1441         address to,
1442         uint256 tokenId,
1443         bytes memory _data
1444     ) private returns (bool) {
1445         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1446             bytes4 retval
1447         ) {
1448             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1449         } catch (bytes memory reason) {
1450             if (reason.length == 0) {
1451                 revert TransferToNonERC721ReceiverImplementer();
1452             } else {
1453                 assembly {
1454                     revert(add(32, reason), mload(reason))
1455                 }
1456             }
1457         }
1458     }
1459 
1460     // =============================================================
1461     //                        MINT OPERATIONS
1462     // =============================================================
1463 
1464     /**
1465      * @dev Mints `quantity` tokens and transfers them to `to`.
1466      *
1467      * Requirements:
1468      *
1469      * - `to` cannot be the zero address.
1470      * - `quantity` must be greater than 0.
1471      *
1472      * Emits a {Transfer} event for each mint.
1473      */
1474     function _mint(address to, uint256 quantity) internal virtual {
1475         uint256 startTokenId = _currentIndex;
1476         if (quantity == 0) revert MintZeroQuantity();
1477 
1478         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1479 
1480         // Overflows are incredibly unrealistic.
1481         // `balance` and `numberMinted` have a maximum limit of 2**64.
1482         // `tokenId` has a maximum limit of 2**256.
1483         unchecked {
1484             // Updates:
1485             // - `balance += quantity`.
1486             // - `numberMinted += quantity`.
1487             //
1488             // We can directly add to the `balance` and `numberMinted`.
1489             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1490 
1491             // Updates:
1492             // - `address` to the owner.
1493             // - `startTimestamp` to the timestamp of minting.
1494             // - `burned` to `false`.
1495             // - `nextInitialized` to `quantity == 1`.
1496             _packedOwnerships[startTokenId] = _packOwnershipData(
1497                 to,
1498                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1499             );
1500 
1501             uint256 toMasked;
1502             uint256 end = startTokenId + quantity;
1503 
1504             // Use assembly to loop and emit the `Transfer` event for gas savings.
1505             // The duplicated `log4` removes an extra check and reduces stack juggling.
1506             // The assembly, together with the surrounding Solidity code, have been
1507             // delicately arranged to nudge the compiler into producing optimized opcodes.
1508             assembly {
1509                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1510                 toMasked := and(to, _BITMASK_ADDRESS)
1511                 // Emit the `Transfer` event.
1512                 log4(
1513                     0, // Start of data (0, since no data).
1514                     0, // End of data (0, since no data).
1515                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1516                     0, // `address(0)`.
1517                     toMasked, // `to`.
1518                     startTokenId // `tokenId`.
1519                 )
1520 
1521                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1522                 // that overflows uint256 will make the loop run out of gas.
1523                 // The compiler will optimize the `iszero` away for performance.
1524                 for {
1525                     let tokenId := add(startTokenId, 1)
1526                 } iszero(eq(tokenId, end)) {
1527                     tokenId := add(tokenId, 1)
1528                 } {
1529                     // Emit the `Transfer` event. Similar to above.
1530                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1531                 }
1532             }
1533             if (toMasked == 0) revert MintToZeroAddress();
1534 
1535             _currentIndex = end;
1536         }
1537         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1538     }
1539 
1540     /**
1541      * @dev Mints `quantity` tokens and transfers them to `to`.
1542      *
1543      * This function is intended for efficient minting only during contract creation.
1544      *
1545      * It emits only one {ConsecutiveTransfer} as defined in
1546      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1547      * instead of a sequence of {Transfer} event(s).
1548      *
1549      * Calling this function outside of contract creation WILL make your contract
1550      * non-compliant with the ERC721 standard.
1551      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1552      * {ConsecutiveTransfer} event is only permissible during contract creation.
1553      *
1554      * Requirements:
1555      *
1556      * - `to` cannot be the zero address.
1557      * - `quantity` must be greater than 0.
1558      *
1559      * Emits a {ConsecutiveTransfer} event.
1560      */
1561     function _mintERC2309(address to, uint256 quantity) internal virtual {
1562         uint256 startTokenId = _currentIndex;
1563         if (to == address(0)) revert MintToZeroAddress();
1564         if (quantity == 0) revert MintZeroQuantity();
1565         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1566 
1567         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1568 
1569         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1570         unchecked {
1571             // Updates:
1572             // - `balance += quantity`.
1573             // - `numberMinted += quantity`.
1574             //
1575             // We can directly add to the `balance` and `numberMinted`.
1576             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1577 
1578             // Updates:
1579             // - `address` to the owner.
1580             // - `startTimestamp` to the timestamp of minting.
1581             // - `burned` to `false`.
1582             // - `nextInitialized` to `quantity == 1`.
1583             _packedOwnerships[startTokenId] = _packOwnershipData(
1584                 to,
1585                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1586             );
1587 
1588             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1589 
1590             _currentIndex = startTokenId + quantity;
1591         }
1592         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1593     }
1594 
1595     /**
1596      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1597      *
1598      * Requirements:
1599      *
1600      * - If `to` refers to a smart contract, it must implement
1601      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1602      * - `quantity` must be greater than 0.
1603      *
1604      * See {_mint}.
1605      *
1606      * Emits a {Transfer} event for each mint.
1607      */
1608     function _safeMint(
1609         address to,
1610         uint256 quantity,
1611         bytes memory _data
1612     ) internal virtual {
1613         _mint(to, quantity);
1614 
1615         unchecked {
1616             if (to.code.length != 0) {
1617                 uint256 end = _currentIndex;
1618                 uint256 index = end - quantity;
1619                 do {
1620                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1621                         revert TransferToNonERC721ReceiverImplementer();
1622                     }
1623                 } while (index < end);
1624                 // Reentrancy protection.
1625                 if (_currentIndex != end) revert();
1626             }
1627         }
1628     }
1629 
1630     /**
1631      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1632      */
1633     function _safeMint(address to, uint256 quantity) internal virtual {
1634         _safeMint(to, quantity, '');
1635     }
1636 
1637     // =============================================================
1638     //                        BURN OPERATIONS
1639     // =============================================================
1640 
1641     /**
1642      * @dev Equivalent to `_burn(tokenId, false)`.
1643      */
1644     function _burn(uint256 tokenId) internal virtual {
1645         _burn(tokenId, false);
1646     }
1647 
1648     /**
1649      * @dev Destroys `tokenId`.
1650      * The approval is cleared when the token is burned.
1651      *
1652      * Requirements:
1653      *
1654      * - `tokenId` must exist.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1659         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1660 
1661         address from = address(uint160(prevOwnershipPacked));
1662 
1663         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1664 
1665         if (approvalCheck) {
1666             // The nested ifs save around 20+ gas over a compound boolean condition.
1667             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1668                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1669         }
1670 
1671         _beforeTokenTransfers(from, address(0), tokenId, 1);
1672 
1673         // Clear approvals from the previous owner.
1674         assembly {
1675             if approvedAddress {
1676                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1677                 sstore(approvedAddressSlot, 0)
1678             }
1679         }
1680 
1681         // Underflow of the sender's balance is impossible because we check for
1682         // ownership above and the recipient's balance can't realistically overflow.
1683         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1684         unchecked {
1685             // Updates:
1686             // - `balance -= 1`.
1687             // - `numberBurned += 1`.
1688             //
1689             // We can directly decrement the balance, and increment the number burned.
1690             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1691             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1692 
1693             // Updates:
1694             // - `address` to the last owner.
1695             // - `startTimestamp` to the timestamp of burning.
1696             // - `burned` to `true`.
1697             // - `nextInitialized` to `true`.
1698             _packedOwnerships[tokenId] = _packOwnershipData(
1699                 from,
1700                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1701             );
1702 
1703             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1704             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1705                 uint256 nextTokenId = tokenId + 1;
1706                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1707                 if (_packedOwnerships[nextTokenId] == 0) {
1708                     // If the next slot is within bounds.
1709                     if (nextTokenId != _currentIndex) {
1710                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1711                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1712                     }
1713                 }
1714             }
1715         }
1716 
1717         emit Transfer(from, address(0), tokenId);
1718         _afterTokenTransfers(from, address(0), tokenId, 1);
1719 
1720         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1721         unchecked {
1722             _burnCounter++;
1723         }
1724     }
1725 
1726     // =============================================================
1727     //                     EXTRA DATA OPERATIONS
1728     // =============================================================
1729 
1730     /**
1731      * @dev Directly sets the extra data for the ownership data `index`.
1732      */
1733     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1734         uint256 packed = _packedOwnerships[index];
1735         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1736         uint256 extraDataCasted;
1737         // Cast `extraData` with assembly to avoid redundant masking.
1738         assembly {
1739             extraDataCasted := extraData
1740         }
1741         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1742         _packedOwnerships[index] = packed;
1743     }
1744 
1745     /**
1746      * @dev Called during each token transfer to set the 24bit `extraData` field.
1747      * Intended to be overridden by the cosumer contract.
1748      *
1749      * `previousExtraData` - the value of `extraData` before transfer.
1750      *
1751      * Calling conditions:
1752      *
1753      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1754      * transferred to `to`.
1755      * - When `from` is zero, `tokenId` will be minted for `to`.
1756      * - When `to` is zero, `tokenId` will be burned by `from`.
1757      * - `from` and `to` are never both zero.
1758      */
1759     function _extraData(
1760         address from,
1761         address to,
1762         uint24 previousExtraData
1763     ) internal view virtual returns (uint24) {}
1764 
1765     /**
1766      * @dev Returns the next extra data for the packed ownership data.
1767      * The returned result is shifted into position.
1768      */
1769     function _nextExtraData(
1770         address from,
1771         address to,
1772         uint256 prevOwnershipPacked
1773     ) private view returns (uint256) {
1774         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1775         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1776     }
1777 
1778     // =============================================================
1779     //                       OTHER OPERATIONS
1780     // =============================================================
1781 
1782     /**
1783      * @dev Returns the message sender (defaults to `msg.sender`).
1784      *
1785      * If you are writing GSN compatible contracts, you need to override this function.
1786      */
1787     function _msgSenderERC721A() internal view virtual returns (address) {
1788         return msg.sender;
1789     }
1790 
1791     /**
1792      * @dev Converts a uint256 to its ASCII string decimal representation.
1793      */
1794     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1795         assembly {
1796             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1797             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1798             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1799             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1800             let m := add(mload(0x40), 0xa0)
1801             // Update the free memory pointer to allocate.
1802             mstore(0x40, m)
1803             // Assign the `str` to the end.
1804             str := sub(m, 0x20)
1805             // Zeroize the slot after the string.
1806             mstore(str, 0)
1807 
1808             // Cache the end of the memory to calculate the length later.
1809             let end := str
1810 
1811             // We write the string from rightmost digit to leftmost digit.
1812             // The following is essentially a do-while loop that also handles the zero case.
1813             // prettier-ignore
1814             for { let temp := value } 1 {} {
1815                 str := sub(str, 1)
1816                 // Write the character to the pointer.
1817                 // The ASCII index of the '0' character is 48.
1818                 mstore8(str, add(48, mod(temp, 10)))
1819                 // Keep dividing `temp` until zero.
1820                 temp := div(temp, 10)
1821                 // prettier-ignore
1822                 if iszero(temp) { break }
1823             }
1824 
1825             let length := sub(end, str)
1826             // Move the pointer 32 bytes leftwards to make room for the length.
1827             str := sub(str, 0x20)
1828             // Store the length.
1829             mstore(str, length)
1830         }
1831     }
1832 }
1833 
1834 // File: 1.sol
1835 
1836 
1837 pragma solidity ^0.8.9;
1838 
1839 
1840 
1841 
1842 
1843 
1844  
1845 
1846 
1847 contract TD is ERC721A, Ownable, ReentrancyGuard, ERC2981 { 
1848 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
1849 uint256 public devTotal;
1850     uint256 public _maxSupply = 5000;
1851     uint256 public _mintPrice = 0.002 ether;
1852     uint256 public _maxMintPerTx = 20;
1853  
1854     uint256 public _maxFreeMintPerAddr = 2;
1855     uint256 public _maxFreeMintSupply = 1000;
1856      uint256 public devSupply = 100;
1857  
1858     using Strings for uint256;
1859     string public baseURI;
1860 
1861     mapping(address => uint256) private _mintedFreeAmount;
1862    
1863  
1864     // Royalties
1865     address public royaltyAdd;
1866  
1867     constructor(string memory initBaseURI) ERC721A("Tw1tt3rD0g3", "TD") {
1868         baseURI = initBaseURI;
1869         setDefaultRoyalty(msg.sender, 1000); // 10%
1870     }
1871  
1872     // Set default royalty account & percentage
1873     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public {
1874         royaltyAdd = _receiver;
1875         _setDefaultRoyalty(_receiver, _feeNumerator);
1876     }
1877  
1878     // Set token specific royalty
1879     function setTokenRoyalty(
1880         uint256 tokenId,
1881         uint96 feeNumerator
1882     ) external onlyOwner {
1883         _setTokenRoyalty(tokenId, royaltyAdd, feeNumerator);
1884     }
1885  
1886     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override returns (address, uint256) {
1887         // Get royalty info from ERC2981 base implementation
1888         (, uint royaltyAmt) = super.royaltyInfo(_tokenId, _salePrice);
1889         // Royalty address is always the one specified in this contract 
1890         return (royaltyAdd, royaltyAmt);
1891     }
1892  
1893     // /**
1894     //  * @dev See {IERC165-supportsInterface}.
1895     //  */
1896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1897         return interfaceId == type(IERC2981).interfaceId || 
1898             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1899             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1900             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1901     }
1902  
1903  
1904     function mint(uint256 count) external payable {
1905         uint256 cost = _mintPrice;
1906         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
1907             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
1908             (msg.sender == owner());
1909  
1910         if (isFree) {
1911             cost = 0;
1912         }
1913  
1914         require(msg.value >= count * cost, "Please send the exact amount.");
1915         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
1916         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1917  
1918         if (isFree) {
1919             _mintedFreeAmount[msg.sender] += count;
1920         }
1921  
1922         _safeMint(msg.sender, count);
1923     }
1924  
1925      function devMint() public onlyOwner {
1926         devTotal += devSupply;
1927         emit DevMintEvent(_msgSender(), devTotal, devSupply);
1928         _safeMint(msg.sender, devSupply);
1929     }
1930  
1931     function _baseURI() internal view virtual override returns (string memory) {
1932         return baseURI;
1933     }
1934 
1935     
1936 function isApprovedForAll(address owner, address operator)
1937         override
1938         public
1939         view
1940         returns (bool)
1941     {
1942         // Block X2Y2
1943         if (operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) {
1944             return false;
1945         }
1946 
1947         return super.isApprovedForAll(owner, operator);
1948     }
1949   
1950  
1951     function tokenURI(uint256 tokenId)
1952         public
1953         view
1954         virtual
1955         override
1956         returns (string memory)
1957     {
1958         require(
1959             _exists(tokenId),
1960             "ERC721Metadata: URI query for nonexistent token"
1961         );
1962         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1963     }
1964  
1965     function setBaseURI(string memory uri) public onlyOwner {
1966         baseURI = uri;
1967     }
1968  
1969     function setFreeAmount(uint256 amount) external onlyOwner {
1970         _maxFreeMintSupply = amount;
1971     }
1972  
1973     function setPrice(uint256 _newPrice) external onlyOwner {
1974         _mintPrice = _newPrice;
1975     }
1976  
1977     function withdraw() public payable onlyOwner nonReentrant {
1978         (bool success, ) = payable(msg.sender).call{
1979             value: address(this).balance
1980         }("");
1981         require(success);
1982     }
1983 }