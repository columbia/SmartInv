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
459 // ERC721A Contracts v4.2.2
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
479      * The caller cannot approve to their own address.
480      */
481     error ApproveToCaller();
482 
483     /**
484      * Cannot query the balance for the zero address.
485      */
486     error BalanceQueryForZeroAddress();
487 
488     /**
489      * Cannot mint to the zero address.
490      */
491     error MintToZeroAddress();
492 
493     /**
494      * The quantity of tokens minted must be more than zero.
495      */
496     error MintZeroQuantity();
497 
498     /**
499      * The token does not exist.
500      */
501     error OwnerQueryForNonexistentToken();
502 
503     /**
504      * The caller must own the token or be an approved operator.
505      */
506     error TransferCallerNotOwnerNorApproved();
507 
508     /**
509      * The token must be owned by `from`.
510      */
511     error TransferFromIncorrectOwner();
512 
513     /**
514      * Cannot safely transfer to a contract that does not implement the
515      * ERC721Receiver interface.
516      */
517     error TransferToNonERC721ReceiverImplementer();
518 
519     /**
520      * Cannot transfer to the zero address.
521      */
522     error TransferToZeroAddress();
523 
524     /**
525      * The token does not exist.
526      */
527     error URIQueryForNonexistentToken();
528 
529     /**
530      * The `quantity` minted with ERC2309 exceeds the safety limit.
531      */
532     error MintERC2309QuantityExceedsLimit();
533 
534     /**
535      * The `extraData` cannot be set on an unintialized ownership slot.
536      */
537     error OwnershipNotInitializedForExtraData();
538 
539     // =============================================================
540     //                            STRUCTS
541     // =============================================================
542 
543     struct TokenOwnership {
544         // The address of the owner.
545         address addr;
546         // Stores the start time of ownership with minimal overhead for tokenomics.
547         uint64 startTimestamp;
548         // Whether the token has been burned.
549         bool burned;
550         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
551         uint24 extraData;
552     }
553 
554     // =============================================================
555     //                         TOKEN COUNTERS
556     // =============================================================
557 
558     /**
559      * @dev Returns the total number of tokens in existence.
560      * Burned tokens will reduce the count.
561      * To get the total number of tokens minted, please see {_totalMinted}.
562      */
563     function totalSupply() external view returns (uint256);
564 
565     // =============================================================
566     //                            IERC165
567     // =============================================================
568 
569     /**
570      * @dev Returns true if this contract implements the interface defined by
571      * `interfaceId`. See the corresponding
572      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
573      * to learn more about how these ids are created.
574      *
575      * This function call must use less than 30000 gas.
576      */
577     function supportsInterface(bytes4 interfaceId) external view returns (bool);
578 
579     // =============================================================
580     //                            IERC721
581     // =============================================================
582 
583     /**
584      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
585      */
586     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
587 
588     /**
589      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
590      */
591     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
592 
593     /**
594      * @dev Emitted when `owner` enables or disables
595      * (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      * @dev Returns the number of tokens in `owner`'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`,
615      * checking first that contract recipients are aware of the ERC721 protocol
616      * to prevent tokens from being forever locked.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be have been allowed to move
624      * this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement
626      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 
637     /**
638      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
639      */
640     function safeTransferFrom(
641         address from,
642         address to,
643         uint256 tokenId
644     ) external;
645 
646     /**
647      * @dev Transfers `tokenId` from `from` to `to`.
648      *
649      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
650      * whenever possible.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must be owned by `from`.
657      * - If the caller is not `from`, it must be approved to move this token
658      * by either {approve} or {setApprovalForAll}.
659      *
660      * Emits a {Transfer} event.
661      */
662     function transferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
670      * The approval is cleared when the token is transferred.
671      *
672      * Only a single account can be approved at a time, so approving the
673      * zero address clears previous approvals.
674      *
675      * Requirements:
676      *
677      * - The caller must own the token or be an approved operator.
678      * - `tokenId` must exist.
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address to, uint256 tokenId) external;
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom}
687      * for any token owned by the caller.
688      *
689      * Requirements:
690      *
691      * - The `operator` cannot be the caller.
692      *
693      * Emits an {ApprovalForAll} event.
694      */
695     function setApprovalForAll(address operator, bool _approved) external;
696 
697     /**
698      * @dev Returns the account approved for `tokenId` token.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must exist.
703      */
704     function getApproved(uint256 tokenId) external view returns (address operator);
705 
706     /**
707      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
708      *
709      * See {setApprovalForAll}.
710      */
711     function isApprovedForAll(address owner, address operator) external view returns (bool);
712 
713     // =============================================================
714     //                        IERC721Metadata
715     // =============================================================
716 
717     /**
718      * @dev Returns the token collection name.
719      */
720     function name() external view returns (string memory);
721 
722     /**
723      * @dev Returns the token collection symbol.
724      */
725     function symbol() external view returns (string memory);
726 
727     /**
728      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
729      */
730     function tokenURI(uint256 tokenId) external view returns (string memory);
731 
732     // =============================================================
733     //                           IERC2309
734     // =============================================================
735 
736     /**
737      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
738      * (inclusive) is transferred from `from` to `to`, as defined in the
739      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
740      *
741      * See {_mintERC2309} for more details.
742      */
743     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
744 }
745 
746 // File: erc721a/contracts/ERC721A.sol
747 
748 
749 // ERC721A Contracts v4.2.2
750 // Creator: Chiru Labs
751 
752 pragma solidity ^0.8.4;
753 
754 
755 /**
756  * @dev Interface of ERC721 token receiver.
757  */
758 interface ERC721A__IERC721Receiver {
759     function onERC721Received(
760         address operator,
761         address from,
762         uint256 tokenId,
763         bytes calldata data
764     ) external returns (bytes4);
765 }
766 
767 /**
768  * @title ERC721A
769  *
770  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
771  * Non-Fungible Token Standard, including the Metadata extension.
772  * Optimized for lower gas during batch mints.
773  *
774  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
775  * starting from `_startTokenId()`.
776  *
777  * Assumptions:
778  *
779  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
780  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
781  */
782 contract ERC721A is IERC721A {
783     // Reference type for token approval.
784     struct TokenApprovalRef {
785         address value;
786     }
787 
788     // =============================================================
789     //                           CONSTANTS
790     // =============================================================
791 
792     // Mask of an entry in packed address data.
793     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
794 
795     // The bit position of `numberMinted` in packed address data.
796     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
797 
798     // The bit position of `numberBurned` in packed address data.
799     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
800 
801     // The bit position of `aux` in packed address data.
802     uint256 private constant _BITPOS_AUX = 192;
803 
804     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
805     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
806 
807     // The bit position of `startTimestamp` in packed ownership.
808     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
809 
810     // The bit mask of the `burned` bit in packed ownership.
811     uint256 private constant _BITMASK_BURNED = 1 << 224;
812 
813     // The bit position of the `nextInitialized` bit in packed ownership.
814     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
815 
816     // The bit mask of the `nextInitialized` bit in packed ownership.
817     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
818 
819     // The bit position of `extraData` in packed ownership.
820     uint256 private constant _BITPOS_EXTRA_DATA = 232;
821 
822     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
823     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
824 
825     // The mask of the lower 160 bits for addresses.
826     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
827 
828     // The maximum `quantity` that can be minted with {_mintERC2309}.
829     // This limit is to prevent overflows on the address data entries.
830     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
831     // is required to cause an overflow, which is unrealistic.
832     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
833 
834     // The `Transfer` event signature is given by:
835     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
836     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
837         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
838 
839     // =============================================================
840     //                            STORAGE
841     // =============================================================
842 
843     // The next token ID to be minted.
844     uint256 private _currentIndex;
845 
846     // The number of tokens burned.
847     uint256 private _burnCounter;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to ownership details
856     // An empty struct value does not necessarily mean the token is unowned.
857     // See {_packedOwnershipOf} implementation for details.
858     //
859     // Bits Layout:
860     // - [0..159]   `addr`
861     // - [160..223] `startTimestamp`
862     // - [224]      `burned`
863     // - [225]      `nextInitialized`
864     // - [232..255] `extraData`
865     mapping(uint256 => uint256) private _packedOwnerships;
866 
867     // Mapping owner address to address data.
868     //
869     // Bits Layout:
870     // - [0..63]    `balance`
871     // - [64..127]  `numberMinted`
872     // - [128..191] `numberBurned`
873     // - [192..255] `aux`
874     mapping(address => uint256) private _packedAddressData;
875 
876     // Mapping from token ID to approved address.
877     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     // =============================================================
883     //                          CONSTRUCTOR
884     // =============================================================
885 
886     constructor(string memory name_, string memory symbol_) {
887         _name = name_;
888         _symbol = symbol_;
889         _currentIndex = _startTokenId();
890     }
891 
892     // =============================================================
893     //                   TOKEN COUNTING OPERATIONS
894     // =============================================================
895 
896     /**
897      * @dev Returns the starting token ID.
898      * To change the starting token ID, please override this function.
899      */
900     function _startTokenId() internal view virtual returns (uint256) {
901         return 0;
902     }
903 
904     /**
905      * @dev Returns the next token ID to be minted.
906      */
907     function _nextTokenId() internal view virtual returns (uint256) {
908         return _currentIndex;
909     }
910 
911     /**
912      * @dev Returns the total number of tokens in existence.
913      * Burned tokens will reduce the count.
914      * To get the total number of tokens minted, please see {_totalMinted}.
915      */
916     function totalSupply() public view virtual override returns (uint256) {
917         // Counter underflow is impossible as _burnCounter cannot be incremented
918         // more than `_currentIndex - _startTokenId()` times.
919         unchecked {
920             return _currentIndex - _burnCounter - _startTokenId();
921         }
922     }
923 
924     /**
925      * @dev Returns the total amount of tokens minted in the contract.
926      */
927     function _totalMinted() internal view virtual returns (uint256) {
928         // Counter underflow is impossible as `_currentIndex` does not decrement,
929         // and it is initialized to `_startTokenId()`.
930         unchecked {
931             return _currentIndex - _startTokenId();
932         }
933     }
934 
935     /**
936      * @dev Returns the total number of tokens burned.
937      */
938     function _totalBurned() internal view virtual returns (uint256) {
939         return _burnCounter;
940     }
941 
942     // =============================================================
943     //                    ADDRESS DATA OPERATIONS
944     // =============================================================
945 
946     /**
947      * @dev Returns the number of tokens in `owner`'s account.
948      */
949     function balanceOf(address owner) public view virtual override returns (uint256) {
950         if (owner == address(0)) revert BalanceQueryForZeroAddress();
951         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
952     }
953 
954     /**
955      * Returns the number of tokens minted by `owner`.
956      */
957     function _numberMinted(address owner) internal view returns (uint256) {
958         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
959     }
960 
961     /**
962      * Returns the number of tokens burned by or on behalf of `owner`.
963      */
964     function _numberBurned(address owner) internal view returns (uint256) {
965         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
966     }
967 
968     /**
969      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
970      */
971     function _getAux(address owner) internal view returns (uint64) {
972         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
973     }
974 
975     /**
976      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
977      * If there are multiple variables, please pack them into a uint64.
978      */
979     function _setAux(address owner, uint64 aux) internal virtual {
980         uint256 packed = _packedAddressData[owner];
981         uint256 auxCasted;
982         // Cast `aux` with assembly to avoid redundant masking.
983         assembly {
984             auxCasted := aux
985         }
986         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
987         _packedAddressData[owner] = packed;
988     }
989 
990     // =============================================================
991     //                            IERC165
992     // =============================================================
993 
994     /**
995      * @dev Returns true if this contract implements the interface defined by
996      * `interfaceId`. See the corresponding
997      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
998      * to learn more about how these ids are created.
999      *
1000      * This function call must use less than 30000 gas.
1001      */
1002     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1003         // The interface IDs are constants representing the first 4 bytes
1004         // of the XOR of all function selectors in the interface.
1005         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1006         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1007         return
1008             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1009             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1010             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1011     }
1012 
1013     // =============================================================
1014     //                        IERC721Metadata
1015     // =============================================================
1016 
1017     /**
1018      * @dev Returns the token collection name.
1019      */
1020     function name() public view virtual override returns (string memory) {
1021         return _name;
1022     }
1023 
1024     /**
1025      * @dev Returns the token collection symbol.
1026      */
1027     function symbol() public view virtual override returns (string memory) {
1028         return _symbol;
1029     }
1030 
1031     /**
1032      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1033      */
1034     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1035         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1036 
1037         string memory baseURI = _baseURI();
1038         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1039     }
1040 
1041     /**
1042      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1043      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1044      * by default, it can be overridden in child contracts.
1045      */
1046     function _baseURI() internal view virtual returns (string memory) {
1047         return '';
1048     }
1049 
1050     // =============================================================
1051     //                     OWNERSHIPS OPERATIONS
1052     // =============================================================
1053 
1054     /**
1055      * @dev Returns the owner of the `tokenId` token.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1062         return address(uint160(_packedOwnershipOf(tokenId)));
1063     }
1064 
1065     /**
1066      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1067      * It gradually moves to O(1) as tokens get transferred around over time.
1068      */
1069     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1070         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1071     }
1072 
1073     /**
1074      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1075      */
1076     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1077         return _unpackedOwnership(_packedOwnerships[index]);
1078     }
1079 
1080     /**
1081      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1082      */
1083     function _initializeOwnershipAt(uint256 index) internal virtual {
1084         if (_packedOwnerships[index] == 0) {
1085             _packedOwnerships[index] = _packedOwnershipOf(index);
1086         }
1087     }
1088 
1089     /**
1090      * Returns the packed ownership data of `tokenId`.
1091      */
1092     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1093         uint256 curr = tokenId;
1094 
1095         unchecked {
1096             if (_startTokenId() <= curr)
1097                 if (curr < _currentIndex) {
1098                     uint256 packed = _packedOwnerships[curr];
1099                     // If not burned.
1100                     if (packed & _BITMASK_BURNED == 0) {
1101                         // Invariant:
1102                         // There will always be an initialized ownership slot
1103                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1104                         // before an unintialized ownership slot
1105                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1106                         // Hence, `curr` will not underflow.
1107                         //
1108                         // We can directly compare the packed value.
1109                         // If the address is zero, packed will be zero.
1110                         while (packed == 0) {
1111                             packed = _packedOwnerships[--curr];
1112                         }
1113                         return packed;
1114                     }
1115                 }
1116         }
1117         revert OwnerQueryForNonexistentToken();
1118     }
1119 
1120     /**
1121      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1122      */
1123     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1124         ownership.addr = address(uint160(packed));
1125         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1126         ownership.burned = packed & _BITMASK_BURNED != 0;
1127         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1128     }
1129 
1130     /**
1131      * @dev Packs ownership data into a single uint256.
1132      */
1133     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1134         assembly {
1135             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1136             owner := and(owner, _BITMASK_ADDRESS)
1137             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1138             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1139         }
1140     }
1141 
1142     /**
1143      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1144      */
1145     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1146         // For branchless setting of the `nextInitialized` flag.
1147         assembly {
1148             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1149             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1150         }
1151     }
1152 
1153     // =============================================================
1154     //                      APPROVAL OPERATIONS
1155     // =============================================================
1156 
1157     /**
1158      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1159      * The approval is cleared when the token is transferred.
1160      *
1161      * Only a single account can be approved at a time, so approving the
1162      * zero address clears previous approvals.
1163      *
1164      * Requirements:
1165      *
1166      * - The caller must own the token or be an approved operator.
1167      * - `tokenId` must exist.
1168      *
1169      * Emits an {Approval} event.
1170      */
1171     function approve(address to, uint256 tokenId) public virtual override {
1172         address owner = ownerOf(tokenId);
1173 
1174         if (_msgSenderERC721A() != owner)
1175             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1176                 revert ApprovalCallerNotOwnerNorApproved();
1177             }
1178 
1179         _tokenApprovals[tokenId].value = to;
1180         emit Approval(owner, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Returns the account approved for `tokenId` token.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      */
1190     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1191         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1192 
1193         return _tokenApprovals[tokenId].value;
1194     }
1195 
1196     /**
1197      * @dev Approve or remove `operator` as an operator for the caller.
1198      * Operators can call {transferFrom} or {safeTransferFrom}
1199      * for any token owned by the caller.
1200      *
1201      * Requirements:
1202      *
1203      * - The `operator` cannot be the caller.
1204      *
1205      * Emits an {ApprovalForAll} event.
1206      */
1207     function setApprovalForAll(address operator, bool approved) public virtual override {
1208         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1209 
1210         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1211         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1212     }
1213 
1214     /**
1215      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1216      *
1217      * See {setApprovalForAll}.
1218      */
1219     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1220         return _operatorApprovals[owner][operator];
1221     }
1222 
1223     /**
1224      * @dev Returns whether `tokenId` exists.
1225      *
1226      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1227      *
1228      * Tokens start existing when they are minted. See {_mint}.
1229      */
1230     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1231         return
1232             _startTokenId() <= tokenId &&
1233             tokenId < _currentIndex && // If within bounds,
1234             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1235     }
1236 
1237     /**
1238      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1239      */
1240     function _isSenderApprovedOrOwner(
1241         address approvedAddress,
1242         address owner,
1243         address msgSender
1244     ) private pure returns (bool result) {
1245         assembly {
1246             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1247             owner := and(owner, _BITMASK_ADDRESS)
1248             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1249             msgSender := and(msgSender, _BITMASK_ADDRESS)
1250             // `msgSender == owner || msgSender == approvedAddress`.
1251             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1257      */
1258     function _getApprovedSlotAndAddress(uint256 tokenId)
1259         private
1260         view
1261         returns (uint256 approvedAddressSlot, address approvedAddress)
1262     {
1263         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1264         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1265         assembly {
1266             approvedAddressSlot := tokenApproval.slot
1267             approvedAddress := sload(approvedAddressSlot)
1268         }
1269     }
1270 
1271     // =============================================================
1272     //                      TRANSFER OPERATIONS
1273     // =============================================================
1274 
1275     /**
1276      * @dev Transfers `tokenId` from `from` to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - `from` cannot be the zero address.
1281      * - `to` cannot be the zero address.
1282      * - `tokenId` token must be owned by `from`.
1283      * - If the caller is not `from`, it must be approved to move this token
1284      * by either {approve} or {setApprovalForAll}.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function transferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) public virtual override {
1293         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1294 
1295         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1296 
1297         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1298 
1299         // The nested ifs save around 20+ gas over a compound boolean condition.
1300         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1301             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1302 
1303         if (to == address(0)) revert TransferToZeroAddress();
1304 
1305         _beforeTokenTransfers(from, to, tokenId, 1);
1306 
1307         // Clear approvals from the previous owner.
1308         assembly {
1309             if approvedAddress {
1310                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1311                 sstore(approvedAddressSlot, 0)
1312             }
1313         }
1314 
1315         // Underflow of the sender's balance is impossible because we check for
1316         // ownership above and the recipient's balance can't realistically overflow.
1317         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1318         unchecked {
1319             // We can directly increment and decrement the balances.
1320             --_packedAddressData[from]; // Updates: `balance -= 1`.
1321             ++_packedAddressData[to]; // Updates: `balance += 1`.
1322 
1323             // Updates:
1324             // - `address` to the next owner.
1325             // - `startTimestamp` to the timestamp of transfering.
1326             // - `burned` to `false`.
1327             // - `nextInitialized` to `true`.
1328             _packedOwnerships[tokenId] = _packOwnershipData(
1329                 to,
1330                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1331             );
1332 
1333             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1334             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1335                 uint256 nextTokenId = tokenId + 1;
1336                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1337                 if (_packedOwnerships[nextTokenId] == 0) {
1338                     // If the next slot is within bounds.
1339                     if (nextTokenId != _currentIndex) {
1340                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1341                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1342                     }
1343                 }
1344             }
1345         }
1346 
1347         emit Transfer(from, to, tokenId);
1348         _afterTokenTransfers(from, to, tokenId, 1);
1349     }
1350 
1351     /**
1352      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1353      */
1354     function safeTransferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) public virtual override {
1359         safeTransferFrom(from, to, tokenId, '');
1360     }
1361 
1362     /**
1363      * @dev Safely transfers `tokenId` token from `from` to `to`.
1364      *
1365      * Requirements:
1366      *
1367      * - `from` cannot be the zero address.
1368      * - `to` cannot be the zero address.
1369      * - `tokenId` token must exist and be owned by `from`.
1370      * - If the caller is not `from`, it must be approved to move this token
1371      * by either {approve} or {setApprovalForAll}.
1372      * - If `to` refers to a smart contract, it must implement
1373      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function safeTransferFrom(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory _data
1382     ) public virtual override {
1383         transferFrom(from, to, tokenId);
1384         if (to.code.length != 0)
1385             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1386                 revert TransferToNonERC721ReceiverImplementer();
1387             }
1388     }
1389 
1390     /**
1391      * @dev Hook that is called before a set of serially-ordered token IDs
1392      * are about to be transferred. This includes minting.
1393      * And also called before burning one token.
1394      *
1395      * `startTokenId` - the first token ID to be transferred.
1396      * `quantity` - the amount to be transferred.
1397      *
1398      * Calling conditions:
1399      *
1400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1401      * transferred to `to`.
1402      * - When `from` is zero, `tokenId` will be minted for `to`.
1403      * - When `to` is zero, `tokenId` will be burned by `from`.
1404      * - `from` and `to` are never both zero.
1405      */
1406     function _beforeTokenTransfers(
1407         address from,
1408         address to,
1409         uint256 startTokenId,
1410         uint256 quantity
1411     ) internal virtual {}
1412 
1413     /**
1414      * @dev Hook that is called after a set of serially-ordered token IDs
1415      * have been transferred. This includes minting.
1416      * And also called after one token has been burned.
1417      *
1418      * `startTokenId` - the first token ID to be transferred.
1419      * `quantity` - the amount to be transferred.
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` has been minted for `to`.
1426      * - When `to` is zero, `tokenId` has been burned by `from`.
1427      * - `from` and `to` are never both zero.
1428      */
1429     function _afterTokenTransfers(
1430         address from,
1431         address to,
1432         uint256 startTokenId,
1433         uint256 quantity
1434     ) internal virtual {}
1435 
1436     /**
1437      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1438      *
1439      * `from` - Previous owner of the given token ID.
1440      * `to` - Target address that will receive the token.
1441      * `tokenId` - Token ID to be transferred.
1442      * `_data` - Optional data to send along with the call.
1443      *
1444      * Returns whether the call correctly returned the expected magic value.
1445      */
1446     function _checkContractOnERC721Received(
1447         address from,
1448         address to,
1449         uint256 tokenId,
1450         bytes memory _data
1451     ) private returns (bool) {
1452         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1453             bytes4 retval
1454         ) {
1455             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1456         } catch (bytes memory reason) {
1457             if (reason.length == 0) {
1458                 revert TransferToNonERC721ReceiverImplementer();
1459             } else {
1460                 assembly {
1461                     revert(add(32, reason), mload(reason))
1462                 }
1463             }
1464         }
1465     }
1466 
1467     // =============================================================
1468     //                        MINT OPERATIONS
1469     // =============================================================
1470 
1471     /**
1472      * @dev Mints `quantity` tokens and transfers them to `to`.
1473      *
1474      * Requirements:
1475      *
1476      * - `to` cannot be the zero address.
1477      * - `quantity` must be greater than 0.
1478      *
1479      * Emits a {Transfer} event for each mint.
1480      */
1481     function _mint(address to, uint256 quantity) internal virtual {
1482         uint256 startTokenId = _currentIndex;
1483         if (quantity == 0) revert MintZeroQuantity();
1484 
1485         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1486 
1487         // Overflows are incredibly unrealistic.
1488         // `balance` and `numberMinted` have a maximum limit of 2**64.
1489         // `tokenId` has a maximum limit of 2**256.
1490         unchecked {
1491             // Updates:
1492             // - `balance += quantity`.
1493             // - `numberMinted += quantity`.
1494             //
1495             // We can directly add to the `balance` and `numberMinted`.
1496             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1497 
1498             // Updates:
1499             // - `address` to the owner.
1500             // - `startTimestamp` to the timestamp of minting.
1501             // - `burned` to `false`.
1502             // - `nextInitialized` to `quantity == 1`.
1503             _packedOwnerships[startTokenId] = _packOwnershipData(
1504                 to,
1505                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1506             );
1507 
1508             uint256 toMasked;
1509             uint256 end = startTokenId + quantity;
1510 
1511             // Use assembly to loop and emit the `Transfer` event for gas savings.
1512             assembly {
1513                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1514                 toMasked := and(to, _BITMASK_ADDRESS)
1515                 // Emit the `Transfer` event.
1516                 log4(
1517                     0, // Start of data (0, since no data).
1518                     0, // End of data (0, since no data).
1519                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1520                     0, // `address(0)`.
1521                     toMasked, // `to`.
1522                     startTokenId // `tokenId`.
1523                 )
1524 
1525                 for {
1526                     let tokenId := add(startTokenId, 1)
1527                 } iszero(eq(tokenId, end)) {
1528                     tokenId := add(tokenId, 1)
1529                 } {
1530                     // Emit the `Transfer` event. Similar to above.
1531                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1532                 }
1533             }
1534             if (toMasked == 0) revert MintToZeroAddress();
1535 
1536             _currentIndex = end;
1537         }
1538         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1539     }
1540 
1541     /**
1542      * @dev Mints `quantity` tokens and transfers them to `to`.
1543      *
1544      * This function is intended for efficient minting only during contract creation.
1545      *
1546      * It emits only one {ConsecutiveTransfer} as defined in
1547      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1548      * instead of a sequence of {Transfer} event(s).
1549      *
1550      * Calling this function outside of contract creation WILL make your contract
1551      * non-compliant with the ERC721 standard.
1552      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1553      * {ConsecutiveTransfer} event is only permissible during contract creation.
1554      *
1555      * Requirements:
1556      *
1557      * - `to` cannot be the zero address.
1558      * - `quantity` must be greater than 0.
1559      *
1560      * Emits a {ConsecutiveTransfer} event.
1561      */
1562     function _mintERC2309(address to, uint256 quantity) internal virtual {
1563         uint256 startTokenId = _currentIndex;
1564         if (to == address(0)) revert MintToZeroAddress();
1565         if (quantity == 0) revert MintZeroQuantity();
1566         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1567 
1568         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1569 
1570         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1571         unchecked {
1572             // Updates:
1573             // - `balance += quantity`.
1574             // - `numberMinted += quantity`.
1575             //
1576             // We can directly add to the `balance` and `numberMinted`.
1577             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1578 
1579             // Updates:
1580             // - `address` to the owner.
1581             // - `startTimestamp` to the timestamp of minting.
1582             // - `burned` to `false`.
1583             // - `nextInitialized` to `quantity == 1`.
1584             _packedOwnerships[startTokenId] = _packOwnershipData(
1585                 to,
1586                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1587             );
1588 
1589             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1590 
1591             _currentIndex = startTokenId + quantity;
1592         }
1593         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1594     }
1595 
1596     /**
1597      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1598      *
1599      * Requirements:
1600      *
1601      * - If `to` refers to a smart contract, it must implement
1602      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1603      * - `quantity` must be greater than 0.
1604      *
1605      * See {_mint}.
1606      *
1607      * Emits a {Transfer} event for each mint.
1608      */
1609     function _safeMint(
1610         address to,
1611         uint256 quantity,
1612         bytes memory _data
1613     ) internal virtual {
1614         _mint(to, quantity);
1615 
1616         unchecked {
1617             if (to.code.length != 0) {
1618                 uint256 end = _currentIndex;
1619                 uint256 index = end - quantity;
1620                 do {
1621                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1622                         revert TransferToNonERC721ReceiverImplementer();
1623                     }
1624                 } while (index < end);
1625                 // Reentrancy protection.
1626                 if (_currentIndex != end) revert();
1627             }
1628         }
1629     }
1630 
1631     /**
1632      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1633      */
1634     function _safeMint(address to, uint256 quantity) internal virtual {
1635         _safeMint(to, quantity, '');
1636     }
1637 
1638     // =============================================================
1639     //                        BURN OPERATIONS
1640     // =============================================================
1641 
1642     /**
1643      * @dev Equivalent to `_burn(tokenId, false)`.
1644      */
1645     function _burn(uint256 tokenId) internal virtual {
1646         _burn(tokenId, false);
1647     }
1648 
1649     /**
1650      * @dev Destroys `tokenId`.
1651      * The approval is cleared when the token is burned.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1660         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1661 
1662         address from = address(uint160(prevOwnershipPacked));
1663 
1664         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1665 
1666         if (approvalCheck) {
1667             // The nested ifs save around 20+ gas over a compound boolean condition.
1668             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1669                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1670         }
1671 
1672         _beforeTokenTransfers(from, address(0), tokenId, 1);
1673 
1674         // Clear approvals from the previous owner.
1675         assembly {
1676             if approvedAddress {
1677                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1678                 sstore(approvedAddressSlot, 0)
1679             }
1680         }
1681 
1682         // Underflow of the sender's balance is impossible because we check for
1683         // ownership above and the recipient's balance can't realistically overflow.
1684         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1685         unchecked {
1686             // Updates:
1687             // - `balance -= 1`.
1688             // - `numberBurned += 1`.
1689             //
1690             // We can directly decrement the balance, and increment the number burned.
1691             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1692             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1693 
1694             // Updates:
1695             // - `address` to the last owner.
1696             // - `startTimestamp` to the timestamp of burning.
1697             // - `burned` to `true`.
1698             // - `nextInitialized` to `true`.
1699             _packedOwnerships[tokenId] = _packOwnershipData(
1700                 from,
1701                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1702             );
1703 
1704             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1705             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1706                 uint256 nextTokenId = tokenId + 1;
1707                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1708                 if (_packedOwnerships[nextTokenId] == 0) {
1709                     // If the next slot is within bounds.
1710                     if (nextTokenId != _currentIndex) {
1711                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1712                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1713                     }
1714                 }
1715             }
1716         }
1717 
1718         emit Transfer(from, address(0), tokenId);
1719         _afterTokenTransfers(from, address(0), tokenId, 1);
1720 
1721         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1722         unchecked {
1723             _burnCounter++;
1724         }
1725     }
1726 
1727     // =============================================================
1728     //                     EXTRA DATA OPERATIONS
1729     // =============================================================
1730 
1731     /**
1732      * @dev Directly sets the extra data for the ownership data `index`.
1733      */
1734     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1735         uint256 packed = _packedOwnerships[index];
1736         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1737         uint256 extraDataCasted;
1738         // Cast `extraData` with assembly to avoid redundant masking.
1739         assembly {
1740             extraDataCasted := extraData
1741         }
1742         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1743         _packedOwnerships[index] = packed;
1744     }
1745 
1746     /**
1747      * @dev Called during each token transfer to set the 24bit `extraData` field.
1748      * Intended to be overridden by the cosumer contract.
1749      *
1750      * `previousExtraData` - the value of `extraData` before transfer.
1751      *
1752      * Calling conditions:
1753      *
1754      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1755      * transferred to `to`.
1756      * - When `from` is zero, `tokenId` will be minted for `to`.
1757      * - When `to` is zero, `tokenId` will be burned by `from`.
1758      * - `from` and `to` are never both zero.
1759      */
1760     function _extraData(
1761         address from,
1762         address to,
1763         uint24 previousExtraData
1764     ) internal view virtual returns (uint24) {}
1765 
1766     /**
1767      * @dev Returns the next extra data for the packed ownership data.
1768      * The returned result is shifted into position.
1769      */
1770     function _nextExtraData(
1771         address from,
1772         address to,
1773         uint256 prevOwnershipPacked
1774     ) private view returns (uint256) {
1775         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1776         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1777     }
1778 
1779     // =============================================================
1780     //                       OTHER OPERATIONS
1781     // =============================================================
1782 
1783     /**
1784      * @dev Returns the message sender (defaults to `msg.sender`).
1785      *
1786      * If you are writing GSN compatible contracts, you need to override this function.
1787      */
1788     function _msgSenderERC721A() internal view virtual returns (address) {
1789         return msg.sender;
1790     }
1791 
1792     /**
1793      * @dev Converts a uint256 to its ASCII string decimal representation.
1794      */
1795     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1796         assembly {
1797             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1798             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1799             // We will need 1 32-byte word to store the length,
1800             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1801             str := add(mload(0x40), 0x80)
1802             // Update the free memory pointer to allocate.
1803             mstore(0x40, str)
1804 
1805             // Cache the end of the memory to calculate the length later.
1806             let end := str
1807 
1808             // We write the string from rightmost digit to leftmost digit.
1809             // The following is essentially a do-while loop that also handles the zero case.
1810             // prettier-ignore
1811             for { let temp := value } 1 {} {
1812                 str := sub(str, 1)
1813                 // Write the character to the pointer.
1814                 // The ASCII index of the '0' character is 48.
1815                 mstore8(str, add(48, mod(temp, 10)))
1816                 // Keep dividing `temp` until zero.
1817                 temp := div(temp, 10)
1818                 // prettier-ignore
1819                 if iszero(temp) { break }
1820             }
1821 
1822             let length := sub(end, str)
1823             // Move the pointer 32 bytes leftwards to make room for the length.
1824             str := sub(str, 0x20)
1825             // Store the length.
1826             mstore(str, length)
1827         }
1828     }
1829 }
1830 
1831 // File: rare.sol
1832 
1833 
1834 pragma solidity ^0.8.9;
1835 
1836 
1837 
1838 
1839 //import "@openzeppelin/contracts/interfaces/IERC2981.sol";
1840 
1841 
1842 
1843 
1844 contract MadGibber is ERC721A, Ownable, ReentrancyGuard, ERC2981 { 
1845 event DevMintEvent(address ownerAddress, uint256 startWith, uint256 amountMinted);
1846 uint256 public devTotal;
1847     uint256 public _maxSupply = 1683;
1848     uint256 public _mintPrice = 0.002 ether;
1849     uint256 public _maxMintPerTx = 4;
1850 
1851     uint256 public _maxFreeMintPerAddr = 1;
1852     uint256 public _maxFreeMintSupply = 1123;
1853      uint256 public devSupply = 286;
1854 
1855     using Strings for uint256;
1856     string public baseURI;
1857     mapping(address => uint256) private _mintedFreeAmount;
1858 
1859     // Royalties
1860     address public royaltyAdd;
1861 
1862     constructor(string memory initBaseURI) ERC721A("MadGibber", "MG") {
1863         baseURI = initBaseURI;
1864         setDefaultRoyalty(msg.sender, 1000); // 10%
1865     }
1866 
1867     // Set default royalty account & percentage
1868     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public {
1869         royaltyAdd = _receiver;
1870         _setDefaultRoyalty(_receiver, _feeNumerator);
1871     }
1872 
1873     // Set token specific royalty
1874     function setTokenRoyalty(
1875         uint256 tokenId,
1876         address receiver,
1877         uint96 feeNumerator
1878     ) external onlyOwner {
1879         _setTokenRoyalty(tokenId, royaltyAdd, feeNumerator);
1880     }
1881 
1882     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override returns (address, uint256) {
1883         // Get royalty info from ERC2981 base implementation
1884         (, uint royaltyAmt) = super.royaltyInfo(_tokenId, _salePrice);
1885         // Royalty address is always the one specified in this contract 
1886         return (royaltyAdd, royaltyAmt);
1887     }
1888 
1889     // /**
1890     //  * @dev See {IERC165-supportsInterface}.
1891     //  */
1892     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
1893         return interfaceId == type(IERC2981).interfaceId || 
1894             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1895             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1896             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1897     }
1898 
1899     
1900     function mint(uint256 count) external payable {
1901         uint256 cost = _mintPrice;
1902         bool isFree = ((totalSupply() + count < _maxFreeMintSupply + 1) &&
1903             (_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr)) ||
1904             (msg.sender == owner());
1905 
1906         if (isFree) {
1907             cost = 0;
1908         }
1909 
1910         require(msg.value >= count * cost, "Please send the exact amount.");
1911         require(totalSupply() + count < _maxSupply - devSupply + 1, "Sold out!");
1912         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1913 
1914         if (isFree) {
1915             _mintedFreeAmount[msg.sender] += count;
1916         }
1917 
1918         _safeMint(msg.sender, count);
1919     }
1920     
1921      function devMint() public onlyOwner {
1922         devTotal += devSupply;
1923         emit DevMintEvent(_msgSender(), devTotal, devSupply);
1924         _safeMint(msg.sender, devSupply);
1925     }
1926 
1927     function _baseURI() internal view virtual override returns (string memory) {
1928         return baseURI;
1929     }
1930 
1931     function tokenURI(uint256 tokenId)
1932         public
1933         view
1934         virtual
1935         override
1936         returns (string memory)
1937     {
1938         require(
1939             _exists(tokenId),
1940             "ERC721Metadata: URI query for nonexistent token"
1941         );
1942         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1943     }
1944 
1945     function setBaseURI(string memory uri) public onlyOwner {
1946         baseURI = uri;
1947     }
1948 
1949     function setFreeAmount(uint256 amount) external onlyOwner {
1950         _maxFreeMintSupply = amount;
1951     }
1952 
1953     function setPrice(uint256 _newPrice) external onlyOwner {
1954         _mintPrice = _newPrice;
1955     }
1956 
1957     function withdraw() public payable onlyOwner nonReentrant {
1958         (bool success, ) = payable(msg.sender).call{
1959             value: address(this).balance
1960         }("");
1961         require(success);
1962     }
1963 }