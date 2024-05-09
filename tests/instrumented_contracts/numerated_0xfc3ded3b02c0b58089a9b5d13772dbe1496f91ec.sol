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
15 interface IERC165Upgradeable {
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
27 // File @openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol@v4.8.0
28 
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC1155 compliant contract, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
37  *
38  * _Available since v3.1._
39  */
40 interface IERC1155Upgradeable is IERC165Upgradeable {
41     /**
42      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
43      */
44     event TransferSingle(
45         address indexed operator,
46         address indexed from,
47         address indexed to,
48         uint256 id,
49         uint256 value
50     );
51 
52     /**
53      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
54      * transfers.
55      */
56     event TransferBatch(
57         address indexed operator,
58         address indexed from,
59         address indexed to,
60         uint256[] ids,
61         uint256[] values
62     );
63 
64     /**
65      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
66      * `approved`.
67      */
68     event ApprovalForAll(
69         address indexed account,
70         address indexed operator,
71         bool approved
72     );
73 
74     /**
75      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
76      *
77      * If an {URI} event was emitted for `id`, the standard
78      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
79      * returned by {IERC1155MetadataURI-uri}.
80      */
81     event URI(string value, uint256 indexed id);
82 
83     /**
84      * @dev Returns the amount of tokens of token type `id` owned by `account`.
85      *
86      * Requirements:
87      *
88      * - `account` cannot be the zero address.
89      */
90     function balanceOf(
91         address account,
92         uint256 id
93     ) external view returns (uint256);
94 
95     /**
96      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
97      *
98      * Requirements:
99      *
100      * - `accounts` and `ids` must have the same length.
101      */
102     function balanceOfBatch(
103         address[] calldata accounts,
104         uint256[] calldata ids
105     ) external view returns (uint256[] memory);
106 
107     /**
108      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
109      *
110      * Emits an {ApprovalForAll} event.
111      *
112      * Requirements:
113      *
114      * - `operator` cannot be the caller.
115      */
116     function setApprovalForAll(address operator, bool approved) external;
117 
118     /**
119      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
120      *
121      * See {setApprovalForAll}.
122      */
123     function isApprovedForAll(
124         address account,
125         address operator
126     ) external view returns (bool);
127 
128     /**
129      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
130      *
131      * Emits a {TransferSingle} event.
132      *
133      * Requirements:
134      *
135      * - `to` cannot be the zero address.
136      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
137      * - `from` must have a balance of tokens of type `id` of at least `amount`.
138      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
139      * acceptance magic value.
140      */
141     function safeTransferFrom(
142         address from,
143         address to,
144         uint256 id,
145         uint256 amount,
146         bytes calldata data
147     ) external;
148 
149     /**
150      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
151      *
152      * Emits a {TransferBatch} event.
153      *
154      * Requirements:
155      *
156      * - `ids` and `amounts` must have the same length.
157      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
158      * acceptance magic value.
159      */
160     function safeBatchTransferFrom(
161         address from,
162         address to,
163         uint256[] calldata ids,
164         uint256[] calldata amounts,
165         bytes calldata data
166     ) external;
167 }
168 
169 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Provides information about the current execution context, including the
178  * sender of the transaction and its data. While these are generally available
179  * via msg.sender and msg.data, they should not be accessed in such a direct
180  * manner, since when dealing with meta-transactions the account sending and
181  * paying for execution may not be the actual sender (as far as an application
182  * is concerned).
183  *
184  * This contract is only required for intermediate, library-like contracts.
185  */
186 abstract contract Context {
187     function _msgSender() internal view virtual returns (address) {
188         return msg.sender;
189     }
190 
191     function _msgData() internal view virtual returns (bytes calldata) {
192         return msg.data;
193     }
194 }
195 
196 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
197 
198 
199 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev Contract module which provides a basic access control mechanism, where
205  * there is an account (an owner) that can be granted exclusive access to
206  * specific functions.
207  *
208  * By default, the owner account will be the one that deploys the contract. This
209  * can later be changed with {transferOwnership}.
210  *
211  * This module is used through inheritance. It will make available the modifier
212  * `onlyOwner`, which can be applied to your functions to restrict their use to
213  * the owner.
214  */
215 abstract contract Ownable is Context {
216     address private _owner;
217 
218     event OwnershipTransferred(
219         address indexed previousOwner,
220         address indexed newOwner
221     );
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor() {
227         _transferOwnership(_msgSender());
228     }
229 
230     /**
231      * @dev Throws if called by any account other than the owner.
232      */
233     modifier onlyOwner() {
234         _checkOwner();
235         _;
236     }
237 
238     /**
239      * @dev Returns the address of the current owner.
240      */
241     function owner() public view virtual returns (address) {
242         return _owner;
243     }
244 
245     /**
246      * @dev Throws if the sender is not the owner.
247      */
248     function _checkOwner() internal view virtual {
249         require(owner() == _msgSender(), "Ownable: caller is not the owner");
250     }
251 
252     /**
253      * @dev Leaves the contract without owner. It will not be possible to call
254      * `onlyOwner` functions anymore. Can only be called by the current owner.
255      *
256      * NOTE: Renouncing ownership will leave the contract without an owner,
257      * thereby removing any functionality that is only available to the owner.
258      */
259     function renounceOwnership() public virtual onlyOwner {
260         _transferOwnership(address(0));
261     }
262 
263     /**
264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
265      * Can only be called by the current owner.
266      */
267     function transferOwnership(address newOwner) public virtual onlyOwner {
268         require(
269             newOwner != address(0),
270             "Ownable: new owner is the zero address"
271         );
272         _transferOwnership(newOwner);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Internal function without access restriction.
278      */
279     function _transferOwnership(address newOwner) internal virtual {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Interface of the ERC165 standard, as defined in the
295  * https://eips.ethereum.org/EIPS/eip-165[EIP].
296  *
297  * Implementers can declare support of contract interfaces, which can then be
298  * queried by others ({ERC165Checker}).
299  *
300  * For an implementation, see {ERC165}.
301  */
302 interface IERC165 {
303     /**
304      * @dev Returns true if this contract implements the interface defined by
305      * `interfaceId`. See the corresponding
306      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
307      * to learn more about how these ids are created.
308      *
309      * This function call must use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) external view returns (bool);
312 }
313 
314 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.8.0
315 
316 
317 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Interface for the NFT Royalty Standard.
323  *
324  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
325  * support for royalty payments across all NFT marketplaces and ecosystem participants.
326  *
327  * _Available since v4.5._
328  */
329 interface IERC2981 is IERC165 {
330     /**
331      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
332      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
333      */
334     function royaltyInfo(
335         uint256 tokenId,
336         uint256 salePrice
337     ) external view returns (address receiver, uint256 royaltyAmount);
338 }
339 
340 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Implementation of the {IERC165} interface.
349  *
350  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
351  * for the additional interface id that will be supported. For example:
352  *
353  * ```solidity
354  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
355  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
356  * }
357  * ```
358  *
359  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
360  */
361 abstract contract ERC165 is IERC165 {
362     /**
363      * @dev See {IERC165-supportsInterface}.
364      */
365     function supportsInterface(
366         bytes4 interfaceId
367     ) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.8.0
373 
374 
375 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 /**
380  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
381  *
382  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
383  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
384  *
385  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
386  * fee is specified in basis points by default.
387  *
388  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
389  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
390  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
391  *
392  * _Available since v4.5._
393  */
394 abstract contract ERC2981 is IERC2981, ERC165 {
395     struct RoyaltyInfo {
396         address receiver;
397         uint96 royaltyFraction;
398     }
399 
400     RoyaltyInfo private _defaultRoyaltyInfo;
401     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
402 
403     /**
404      * @dev See {IERC165-supportsInterface}.
405      */
406     function supportsInterface(
407         bytes4 interfaceId
408     ) public view virtual override(IERC165, ERC165) returns (bool) {
409         return
410             interfaceId == type(IERC2981).interfaceId ||
411             super.supportsInterface(interfaceId);
412     }
413 
414     /**
415      * @inheritdoc IERC2981
416      */
417     function royaltyInfo(
418         uint256 _tokenId,
419         uint256 _salePrice
420     ) public view virtual override returns (address, uint256) {
421         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
422 
423         if (royalty.receiver == address(0)) {
424             royalty = _defaultRoyaltyInfo;
425         }
426 
427         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
428             _feeDenominator();
429 
430         return (royalty.receiver, royaltyAmount);
431     }
432 
433     /**
434      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
435      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
436      * override.
437      */
438     function _feeDenominator() internal pure virtual returns (uint96) {
439         return 10000;
440     }
441 
442     /**
443      * @dev Sets the royalty information that all ids in this contract will default to.
444      *
445      * Requirements:
446      *
447      * - `receiver` cannot be the zero address.
448      * - `feeNumerator` cannot be greater than the fee denominator.
449      */
450     function _setDefaultRoyalty(
451         address receiver,
452         uint96 feeNumerator
453     ) internal virtual {
454         require(
455             feeNumerator <= _feeDenominator(),
456             "ERC2981: royalty fee will exceed salePrice"
457         );
458         require(receiver != address(0), "ERC2981: invalid receiver");
459 
460         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
461     }
462 
463     /**
464      * @dev Removes default royalty information.
465      */
466     function _deleteDefaultRoyalty() internal virtual {
467         delete _defaultRoyaltyInfo;
468     }
469 
470     /**
471      * @dev Sets the royalty information for a specific token id, overriding the global default.
472      *
473      * Requirements:
474      *
475      * - `receiver` cannot be the zero address.
476      * - `feeNumerator` cannot be greater than the fee denominator.
477      */
478     function _setTokenRoyalty(
479         uint256 tokenId,
480         address receiver,
481         uint96 feeNumerator
482     ) internal virtual {
483         require(
484             feeNumerator <= _feeDenominator(),
485             "ERC2981: royalty fee will exceed salePrice"
486         );
487         require(receiver != address(0), "ERC2981: Invalid parameters");
488 
489         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
490     }
491 
492     /**
493      * @dev Resets royalty information for the token id back to the global default.
494      */
495     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
496         delete _tokenRoyaltyInfo[tokenId];
497     }
498 }
499 
500 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.8.0
501 
502 
503 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Required interface of an ERC1155 compliant contract, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
510  *
511  * _Available since v3.1._
512  */
513 interface IERC1155 is IERC165 {
514     /**
515      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
516      */
517     event TransferSingle(
518         address indexed operator,
519         address indexed from,
520         address indexed to,
521         uint256 id,
522         uint256 value
523     );
524 
525     /**
526      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
527      * transfers.
528      */
529     event TransferBatch(
530         address indexed operator,
531         address indexed from,
532         address indexed to,
533         uint256[] ids,
534         uint256[] values
535     );
536 
537     /**
538      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
539      * `approved`.
540      */
541     event ApprovalForAll(
542         address indexed account,
543         address indexed operator,
544         bool approved
545     );
546 
547     /**
548      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
549      *
550      * If an {URI} event was emitted for `id`, the standard
551      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
552      * returned by {IERC1155MetadataURI-uri}.
553      */
554     event URI(string value, uint256 indexed id);
555 
556     /**
557      * @dev Returns the amount of tokens of token type `id` owned by `account`.
558      *
559      * Requirements:
560      *
561      * - `account` cannot be the zero address.
562      */
563     function balanceOf(
564         address account,
565         uint256 id
566     ) external view returns (uint256);
567 
568     /**
569      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
570      *
571      * Requirements:
572      *
573      * - `accounts` and `ids` must have the same length.
574      */
575     function balanceOfBatch(
576         address[] calldata accounts,
577         uint256[] calldata ids
578     ) external view returns (uint256[] memory);
579 
580     /**
581      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
582      *
583      * Emits an {ApprovalForAll} event.
584      *
585      * Requirements:
586      *
587      * - `operator` cannot be the caller.
588      */
589     function setApprovalForAll(address operator, bool approved) external;
590 
591     /**
592      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
593      *
594      * See {setApprovalForAll}.
595      */
596     function isApprovedForAll(
597         address account,
598         address operator
599     ) external view returns (bool);
600 
601     /**
602      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
603      *
604      * Emits a {TransferSingle} event.
605      *
606      * Requirements:
607      *
608      * - `to` cannot be the zero address.
609      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
610      * - `from` must have a balance of tokens of type `id` of at least `amount`.
611      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
612      * acceptance magic value.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 id,
618         uint256 amount,
619         bytes calldata data
620     ) external;
621 
622     /**
623      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
624      *
625      * Emits a {TransferBatch} event.
626      *
627      * Requirements:
628      *
629      * - `ids` and `amounts` must have the same length.
630      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
631      * acceptance magic value.
632      */
633     function safeBatchTransferFrom(
634         address from,
635         address to,
636         uint256[] calldata ids,
637         uint256[] calldata amounts,
638         bytes calldata data
639     ) external;
640 }
641 
642 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
643 
644 
645 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Standard math utilities missing in the Solidity language.
651  */
652 library Math {
653     enum Rounding {
654         Down, // Toward negative infinity
655         Up, // Toward infinity
656         Zero // Toward zero
657     }
658 
659     /**
660      * @dev Returns the largest of two numbers.
661      */
662     function max(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a > b ? a : b;
664     }
665 
666     /**
667      * @dev Returns the smallest of two numbers.
668      */
669     function min(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a < b ? a : b;
671     }
672 
673     /**
674      * @dev Returns the average of two numbers. The result is rounded towards
675      * zero.
676      */
677     function average(uint256 a, uint256 b) internal pure returns (uint256) {
678         // (a + b) / 2 can overflow.
679         return (a & b) + (a ^ b) / 2;
680     }
681 
682     /**
683      * @dev Returns the ceiling of the division of two numbers.
684      *
685      * This differs from standard division with `/` in that it rounds up instead
686      * of rounding down.
687      */
688     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
689         // (a + b - 1) / b can overflow on addition, so we distribute.
690         return a == 0 ? 0 : (a - 1) / b + 1;
691     }
692 
693     /**
694      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
695      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
696      * with further edits by Uniswap Labs also under MIT license.
697      */
698     function mulDiv(
699         uint256 x,
700         uint256 y,
701         uint256 denominator
702     ) internal pure returns (uint256 result) {
703         unchecked {
704             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
705             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
706             // variables such that product = prod1 * 2^256 + prod0.
707             uint256 prod0; // Least significant 256 bits of the product
708             uint256 prod1; // Most significant 256 bits of the product
709             assembly {
710                 let mm := mulmod(x, y, not(0))
711                 prod0 := mul(x, y)
712                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
713             }
714 
715             // Handle non-overflow cases, 256 by 256 division.
716             if (prod1 == 0) {
717                 return prod0 / denominator;
718             }
719 
720             // Make sure the result is less than 2^256. Also prevents denominator == 0.
721             require(denominator > prod1);
722 
723             ///////////////////////////////////////////////
724             // 512 by 256 division.
725             ///////////////////////////////////////////////
726 
727             // Make division exact by subtracting the remainder from [prod1 prod0].
728             uint256 remainder;
729             assembly {
730                 // Compute remainder using mulmod.
731                 remainder := mulmod(x, y, denominator)
732 
733                 // Subtract 256 bit number from 512 bit number.
734                 prod1 := sub(prod1, gt(remainder, prod0))
735                 prod0 := sub(prod0, remainder)
736             }
737 
738             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
739             // See https://cs.stackexchange.com/q/138556/92363.
740 
741             // Does not overflow because the denominator cannot be zero at this stage in the function.
742             uint256 twos = denominator & (~denominator + 1);
743             assembly {
744                 // Divide denominator by twos.
745                 denominator := div(denominator, twos)
746 
747                 // Divide [prod1 prod0] by twos.
748                 prod0 := div(prod0, twos)
749 
750                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
751                 twos := add(div(sub(0, twos), twos), 1)
752             }
753 
754             // Shift in bits from prod1 into prod0.
755             prod0 |= prod1 * twos;
756 
757             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
758             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
759             // four bits. That is, denominator * inv = 1 mod 2^4.
760             uint256 inverse = (3 * denominator) ^ 2;
761 
762             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
763             // in modular arithmetic, doubling the correct bits in each step.
764             inverse *= 2 - denominator * inverse; // inverse mod 2^8
765             inverse *= 2 - denominator * inverse; // inverse mod 2^16
766             inverse *= 2 - denominator * inverse; // inverse mod 2^32
767             inverse *= 2 - denominator * inverse; // inverse mod 2^64
768             inverse *= 2 - denominator * inverse; // inverse mod 2^128
769             inverse *= 2 - denominator * inverse; // inverse mod 2^256
770 
771             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
772             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
773             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
774             // is no longer required.
775             result = prod0 * inverse;
776             return result;
777         }
778     }
779 
780     /**
781      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
782      */
783     function mulDiv(
784         uint256 x,
785         uint256 y,
786         uint256 denominator,
787         Rounding rounding
788     ) internal pure returns (uint256) {
789         uint256 result = mulDiv(x, y, denominator);
790         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
791             result += 1;
792         }
793         return result;
794     }
795 
796     /**
797      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
798      *
799      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
800      */
801     function sqrt(uint256 a) internal pure returns (uint256) {
802         if (a == 0) {
803             return 0;
804         }
805 
806         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
807         //
808         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
809         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
810         //
811         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
812         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
813         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
814         //
815         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
816         uint256 result = 1 << (log2(a) >> 1);
817 
818         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
819         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
820         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
821         // into the expected uint128 result.
822         unchecked {
823             result = (result + a / result) >> 1;
824             result = (result + a / result) >> 1;
825             result = (result + a / result) >> 1;
826             result = (result + a / result) >> 1;
827             result = (result + a / result) >> 1;
828             result = (result + a / result) >> 1;
829             result = (result + a / result) >> 1;
830             return min(result, a / result);
831         }
832     }
833 
834     /**
835      * @notice Calculates sqrt(a), following the selected rounding direction.
836      */
837     function sqrt(
838         uint256 a,
839         Rounding rounding
840     ) internal pure returns (uint256) {
841         unchecked {
842             uint256 result = sqrt(a);
843             return
844                 result +
845                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
846         }
847     }
848 
849     /**
850      * @dev Return the log in base 2, rounded down, of a positive value.
851      * Returns 0 if given 0.
852      */
853     function log2(uint256 value) internal pure returns (uint256) {
854         uint256 result = 0;
855         unchecked {
856             if (value >> 128 > 0) {
857                 value >>= 128;
858                 result += 128;
859             }
860             if (value >> 64 > 0) {
861                 value >>= 64;
862                 result += 64;
863             }
864             if (value >> 32 > 0) {
865                 value >>= 32;
866                 result += 32;
867             }
868             if (value >> 16 > 0) {
869                 value >>= 16;
870                 result += 16;
871             }
872             if (value >> 8 > 0) {
873                 value >>= 8;
874                 result += 8;
875             }
876             if (value >> 4 > 0) {
877                 value >>= 4;
878                 result += 4;
879             }
880             if (value >> 2 > 0) {
881                 value >>= 2;
882                 result += 2;
883             }
884             if (value >> 1 > 0) {
885                 result += 1;
886             }
887         }
888         return result;
889     }
890 
891     /**
892      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
893      * Returns 0 if given 0.
894      */
895     function log2(
896         uint256 value,
897         Rounding rounding
898     ) internal pure returns (uint256) {
899         unchecked {
900             uint256 result = log2(value);
901             return
902                 result +
903                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
904         }
905     }
906 
907     /**
908      * @dev Return the log in base 10, rounded down, of a positive value.
909      * Returns 0 if given 0.
910      */
911     function log10(uint256 value) internal pure returns (uint256) {
912         uint256 result = 0;
913         unchecked {
914             if (value >= 10 ** 64) {
915                 value /= 10 ** 64;
916                 result += 64;
917             }
918             if (value >= 10 ** 32) {
919                 value /= 10 ** 32;
920                 result += 32;
921             }
922             if (value >= 10 ** 16) {
923                 value /= 10 ** 16;
924                 result += 16;
925             }
926             if (value >= 10 ** 8) {
927                 value /= 10 ** 8;
928                 result += 8;
929             }
930             if (value >= 10 ** 4) {
931                 value /= 10 ** 4;
932                 result += 4;
933             }
934             if (value >= 10 ** 2) {
935                 value /= 10 ** 2;
936                 result += 2;
937             }
938             if (value >= 10 ** 1) {
939                 result += 1;
940             }
941         }
942         return result;
943     }
944 
945     /**
946      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
947      * Returns 0 if given 0.
948      */
949     function log10(
950         uint256 value,
951         Rounding rounding
952     ) internal pure returns (uint256) {
953         unchecked {
954             uint256 result = log10(value);
955             return
956                 result +
957                 (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
958         }
959     }
960 
961     /**
962      * @dev Return the log in base 256, rounded down, of a positive value.
963      * Returns 0 if given 0.
964      *
965      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
966      */
967     function log256(uint256 value) internal pure returns (uint256) {
968         uint256 result = 0;
969         unchecked {
970             if (value >> 128 > 0) {
971                 value >>= 128;
972                 result += 16;
973             }
974             if (value >> 64 > 0) {
975                 value >>= 64;
976                 result += 8;
977             }
978             if (value >> 32 > 0) {
979                 value >>= 32;
980                 result += 4;
981             }
982             if (value >> 16 > 0) {
983                 value >>= 16;
984                 result += 2;
985             }
986             if (value >> 8 > 0) {
987                 result += 1;
988             }
989         }
990         return result;
991     }
992 
993     /**
994      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
995      * Returns 0 if given 0.
996      */
997     function log256(
998         uint256 value,
999         Rounding rounding
1000     ) internal pure returns (uint256) {
1001         unchecked {
1002             uint256 result = log256(value);
1003             return
1004                 result +
1005                 (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1006         }
1007     }
1008 }
1009 
1010 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1011 
1012 
1013 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @dev String operations.
1019  */
1020 library Strings {
1021     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1022     uint8 private constant _ADDRESS_LENGTH = 20;
1023 
1024     /**
1025      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1026      */
1027     function toString(uint256 value) internal pure returns (string memory) {
1028         unchecked {
1029             uint256 length = Math.log10(value) + 1;
1030             string memory buffer = new string(length);
1031             uint256 ptr;
1032             /// @solidity memory-safe-assembly
1033             assembly {
1034                 ptr := add(buffer, add(32, length))
1035             }
1036             while (true) {
1037                 ptr--;
1038                 /// @solidity memory-safe-assembly
1039                 assembly {
1040                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1041                 }
1042                 value /= 10;
1043                 if (value == 0) break;
1044             }
1045             return buffer;
1046         }
1047     }
1048 
1049     /**
1050      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1051      */
1052     function toHexString(uint256 value) internal pure returns (string memory) {
1053         unchecked {
1054             return toHexString(value, Math.log256(value) + 1);
1055         }
1056     }
1057 
1058     /**
1059      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1060      */
1061     function toHexString(
1062         uint256 value,
1063         uint256 length
1064     ) internal pure returns (string memory) {
1065         bytes memory buffer = new bytes(2 * length + 2);
1066         buffer[0] = "0";
1067         buffer[1] = "x";
1068         for (uint256 i = 2 * length + 1; i > 1; --i) {
1069             buffer[i] = _SYMBOLS[value & 0xf];
1070             value >>= 4;
1071         }
1072         require(value == 0, "Strings: hex length insufficient");
1073         return string(buffer);
1074     }
1075 
1076     /**
1077      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1078      */
1079     function toHexString(address addr) internal pure returns (string memory) {
1080         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1081     }
1082 }
1083 
1084 // File contracts/interfaces/ILDPCLionade.sol
1085 
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 interface ILDPCLionade is IERC1155Upgradeable {
1090     function airdrop(address _toAddress, uint256[] calldata itemIds) external;
1091 
1092     function burnItemForOwnerAddress(
1093         address _materialOwnerAddress,
1094         uint256 _typeId,
1095         uint256 _quantity
1096     ) external;
1097 
1098     function mintItemToAddress(
1099         address _toAddress,
1100         uint256 _typeId,
1101         uint256 _quantity
1102     ) external;
1103 
1104     function mintBatchItemsToAddress(
1105         address _toAddress,
1106         uint256[] memory _typeIds,
1107         uint256[] memory _quantities
1108     ) external;
1109 
1110     function bulkSafeTransfer(
1111         address[] calldata recipients,
1112         uint256 _typeId,
1113         uint256 _quantityPerRecipient
1114     ) external;
1115 }
1116 
1117 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
1118 
1119 
1120 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1121 
1122 pragma solidity ^0.8.0;
1123 
1124 /**
1125  * @dev Contract module that helps prevent reentrant calls to a function.
1126  *
1127  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1128  * available, which can be applied to functions to make sure there are no nested
1129  * (reentrant) calls to them.
1130  *
1131  * Note that because there is a single `nonReentrant` guard, functions marked as
1132  * `nonReentrant` may not call one another. This can be worked around by making
1133  * those functions `private`, and then adding `external` `nonReentrant` entry
1134  * points to them.
1135  *
1136  * TIP: If you would like to learn more about reentrancy and alternative ways
1137  * to protect against it, check out our blog post
1138  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1139  */
1140 abstract contract ReentrancyGuard {
1141     // Booleans are more expensive than uint256 or any type that takes up a full
1142     // word because each write operation emits an extra SLOAD to first read the
1143     // slot's contents, replace the bits taken up by the boolean, and then write
1144     // back. This is the compiler's defense against contract upgrades and
1145     // pointer aliasing, and it cannot be disabled.
1146 
1147     // The values being non-zero value makes deployment a bit more expensive,
1148     // but in exchange the refund on every call to nonReentrant will be lower in
1149     // amount. Since refunds are capped to a percentage of the total
1150     // transaction's gas, it is best to keep them low in cases like this one, to
1151     // increase the likelihood of the full refund coming into effect.
1152     uint256 private constant _NOT_ENTERED = 1;
1153     uint256 private constant _ENTERED = 2;
1154 
1155     uint256 private _status;
1156 
1157     constructor() {
1158         _status = _NOT_ENTERED;
1159     }
1160 
1161     /**
1162      * @dev Prevents a contract from calling itself, directly or indirectly.
1163      * Calling a `nonReentrant` function from another `nonReentrant`
1164      * function is not supported. It is possible to prevent this from happening
1165      * by making the `nonReentrant` function external, and making it call a
1166      * `private` function that does the actual work.
1167      */
1168     modifier nonReentrant() {
1169         _nonReentrantBefore();
1170         _;
1171         _nonReentrantAfter();
1172     }
1173 
1174     function _nonReentrantBefore() private {
1175         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1176         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1177 
1178         // Any calls to nonReentrant after this point will fail
1179         _status = _ENTERED;
1180     }
1181 
1182     function _nonReentrantAfter() private {
1183         // By storing the original value once again, a refund is triggered (see
1184         // https://eips.ethereum.org/EIPS/eip-2200)
1185         _status = _NOT_ENTERED;
1186     }
1187 }
1188 
1189 // File erc721a/contracts/IERC721A.sol@v4.2.3
1190 
1191 
1192 // ERC721A Contracts v4.2.3
1193 // Creator: Chiru Labs
1194 
1195 pragma solidity ^0.8.4;
1196 
1197 /**
1198  * @dev Interface of ERC721A.
1199  */
1200 interface IERC721A {
1201     /**
1202      * The caller must own the token or be an approved operator.
1203      */
1204     error ApprovalCallerNotOwnerNorApproved();
1205 
1206     /**
1207      * The token does not exist.
1208      */
1209     error ApprovalQueryForNonexistentToken();
1210 
1211     /**
1212      * Cannot query the balance for the zero address.
1213      */
1214     error BalanceQueryForZeroAddress();
1215 
1216     /**
1217      * Cannot mint to the zero address.
1218      */
1219     error MintToZeroAddress();
1220 
1221     /**
1222      * The quantity of tokens minted must be more than zero.
1223      */
1224     error MintZeroQuantity();
1225 
1226     /**
1227      * The token does not exist.
1228      */
1229     error OwnerQueryForNonexistentToken();
1230 
1231     /**
1232      * The caller must own the token or be an approved operator.
1233      */
1234     error TransferCallerNotOwnerNorApproved();
1235 
1236     /**
1237      * The token must be owned by `from`.
1238      */
1239     error TransferFromIncorrectOwner();
1240 
1241     /**
1242      * Cannot safely transfer to a contract that does not implement the
1243      * ERC721Receiver interface.
1244      */
1245     error TransferToNonERC721ReceiverImplementer();
1246 
1247     /**
1248      * Cannot transfer to the zero address.
1249      */
1250     error TransferToZeroAddress();
1251 
1252     /**
1253      * The token does not exist.
1254      */
1255     error URIQueryForNonexistentToken();
1256 
1257     /**
1258      * The `quantity` minted with ERC2309 exceeds the safety limit.
1259      */
1260     error MintERC2309QuantityExceedsLimit();
1261 
1262     /**
1263      * The `extraData` cannot be set on an unintialized ownership slot.
1264      */
1265     error OwnershipNotInitializedForExtraData();
1266 
1267     // =============================================================
1268     //                            STRUCTS
1269     // =============================================================
1270 
1271     struct TokenOwnership {
1272         // The address of the owner.
1273         address addr;
1274         // Stores the start time of ownership with minimal overhead for tokenomics.
1275         uint64 startTimestamp;
1276         // Whether the token has been burned.
1277         bool burned;
1278         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1279         uint24 extraData;
1280     }
1281 
1282     // =============================================================
1283     //                         TOKEN COUNTERS
1284     // =============================================================
1285 
1286     /**
1287      * @dev Returns the total number of tokens in existence.
1288      * Burned tokens will reduce the count.
1289      * To get the total number of tokens minted, please see {_totalMinted}.
1290      */
1291     function totalSupply() external view returns (uint256);
1292 
1293     // =============================================================
1294     //                            IERC165
1295     // =============================================================
1296 
1297     /**
1298      * @dev Returns true if this contract implements the interface defined by
1299      * `interfaceId`. See the corresponding
1300      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1301      * to learn more about how these ids are created.
1302      *
1303      * This function call must use less than 30000 gas.
1304      */
1305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1306 
1307     // =============================================================
1308     //                            IERC721
1309     // =============================================================
1310 
1311     /**
1312      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1313      */
1314     event Transfer(
1315         address indexed from,
1316         address indexed to,
1317         uint256 indexed tokenId
1318     );
1319 
1320     /**
1321      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1322      */
1323     event Approval(
1324         address indexed owner,
1325         address indexed approved,
1326         uint256 indexed tokenId
1327     );
1328 
1329     /**
1330      * @dev Emitted when `owner` enables or disables
1331      * (`approved`) `operator` to manage all of its assets.
1332      */
1333     event ApprovalForAll(
1334         address indexed owner,
1335         address indexed operator,
1336         bool approved
1337     );
1338 
1339     /**
1340      * @dev Returns the number of tokens in `owner`'s account.
1341      */
1342     function balanceOf(address owner) external view returns (uint256 balance);
1343 
1344     /**
1345      * @dev Returns the owner of the `tokenId` token.
1346      *
1347      * Requirements:
1348      *
1349      * - `tokenId` must exist.
1350      */
1351     function ownerOf(uint256 tokenId) external view returns (address owner);
1352 
1353     /**
1354      * @dev Safely transfers `tokenId` token from `from` to `to`,
1355      * checking first that contract recipients are aware of the ERC721 protocol
1356      * to prevent tokens from being forever locked.
1357      *
1358      * Requirements:
1359      *
1360      * - `from` cannot be the zero address.
1361      * - `to` cannot be the zero address.
1362      * - `tokenId` token must exist and be owned by `from`.
1363      * - If the caller is not `from`, it must be have been allowed to move
1364      * this token by either {approve} or {setApprovalForAll}.
1365      * - If `to` refers to a smart contract, it must implement
1366      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function safeTransferFrom(
1371         address from,
1372         address to,
1373         uint256 tokenId,
1374         bytes calldata data
1375     ) external payable;
1376 
1377     /**
1378      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1379      */
1380     function safeTransferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) external payable;
1385 
1386     /**
1387      * @dev Transfers `tokenId` from `from` to `to`.
1388      *
1389      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1390      * whenever possible.
1391      *
1392      * Requirements:
1393      *
1394      * - `from` cannot be the zero address.
1395      * - `to` cannot be the zero address.
1396      * - `tokenId` token must be owned by `from`.
1397      * - If the caller is not `from`, it must be approved to move this token
1398      * by either {approve} or {setApprovalForAll}.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function transferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) external payable;
1407 
1408     /**
1409      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1410      * The approval is cleared when the token is transferred.
1411      *
1412      * Only a single account can be approved at a time, so approving the
1413      * zero address clears previous approvals.
1414      *
1415      * Requirements:
1416      *
1417      * - The caller must own the token or be an approved operator.
1418      * - `tokenId` must exist.
1419      *
1420      * Emits an {Approval} event.
1421      */
1422     function approve(address to, uint256 tokenId) external payable;
1423 
1424     /**
1425      * @dev Approve or remove `operator` as an operator for the caller.
1426      * Operators can call {transferFrom} or {safeTransferFrom}
1427      * for any token owned by the caller.
1428      *
1429      * Requirements:
1430      *
1431      * - The `operator` cannot be the caller.
1432      *
1433      * Emits an {ApprovalForAll} event.
1434      */
1435     function setApprovalForAll(address operator, bool _approved) external;
1436 
1437     /**
1438      * @dev Returns the account approved for `tokenId` token.
1439      *
1440      * Requirements:
1441      *
1442      * - `tokenId` must exist.
1443      */
1444     function getApproved(
1445         uint256 tokenId
1446     ) external view returns (address operator);
1447 
1448     /**
1449      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1450      *
1451      * See {setApprovalForAll}.
1452      */
1453     function isApprovedForAll(
1454         address owner,
1455         address operator
1456     ) external view returns (bool);
1457 
1458     // =============================================================
1459     //                        IERC721Metadata
1460     // =============================================================
1461 
1462     /**
1463      * @dev Returns the token collection name.
1464      */
1465     function name() external view returns (string memory);
1466 
1467     /**
1468      * @dev Returns the token collection symbol.
1469      */
1470     function symbol() external view returns (string memory);
1471 
1472     /**
1473      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1474      */
1475     function tokenURI(uint256 tokenId) external view returns (string memory);
1476 
1477     // =============================================================
1478     //                           IERC2309
1479     // =============================================================
1480 
1481     /**
1482      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1483      * (inclusive) is transferred from `from` to `to`, as defined in the
1484      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1485      *
1486      * See {_mintERC2309} for more details.
1487      */
1488     event ConsecutiveTransfer(
1489         uint256 indexed fromTokenId,
1490         uint256 toTokenId,
1491         address indexed from,
1492         address indexed to
1493     );
1494 }
1495 
1496 // File erc721a/contracts/ERC721A.sol@v4.2.3
1497 
1498 
1499 // ERC721A Contracts v4.2.3
1500 // Creator: Chiru Labs
1501 
1502 pragma solidity ^0.8.4;
1503 
1504 /**
1505  * @dev Interface of ERC721 token receiver.
1506  */
1507 interface ERC721A__IERC721Receiver {
1508     function onERC721Received(
1509         address operator,
1510         address from,
1511         uint256 tokenId,
1512         bytes calldata data
1513     ) external returns (bytes4);
1514 }
1515 
1516 /**
1517  * @title ERC721A
1518  *
1519  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1520  * Non-Fungible Token Standard, including the Metadata extension.
1521  * Optimized for lower gas during batch mints.
1522  *
1523  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1524  * starting from `_startTokenId()`.
1525  *
1526  * Assumptions:
1527  *
1528  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1529  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1530  */
1531 contract ERC721A is IERC721A {
1532     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1533     struct TokenApprovalRef {
1534         address value;
1535     }
1536 
1537     // =============================================================
1538     //                           CONSTANTS
1539     // =============================================================
1540 
1541     // Mask of an entry in packed address data.
1542     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1543 
1544     // The bit position of `numberMinted` in packed address data.
1545     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1546 
1547     // The bit position of `numberBurned` in packed address data.
1548     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1549 
1550     // The bit position of `aux` in packed address data.
1551     uint256 private constant _BITPOS_AUX = 192;
1552 
1553     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1554     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1555 
1556     // The bit position of `startTimestamp` in packed ownership.
1557     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1558 
1559     // The bit mask of the `burned` bit in packed ownership.
1560     uint256 private constant _BITMASK_BURNED = 1 << 224;
1561 
1562     // The bit position of the `nextInitialized` bit in packed ownership.
1563     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1564 
1565     // The bit mask of the `nextInitialized` bit in packed ownership.
1566     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1567 
1568     // The bit position of `extraData` in packed ownership.
1569     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1570 
1571     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1572     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1573 
1574     // The mask of the lower 160 bits for addresses.
1575     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1576 
1577     // The maximum `quantity` that can be minted with {_mintERC2309}.
1578     // This limit is to prevent overflows on the address data entries.
1579     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1580     // is required to cause an overflow, which is unrealistic.
1581     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1582 
1583     // The `Transfer` event signature is given by:
1584     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1585     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1586         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1587 
1588     // =============================================================
1589     //                            STORAGE
1590     // =============================================================
1591 
1592     // The next token ID to be minted.
1593     uint256 private _currentIndex;
1594 
1595     // The number of tokens burned.
1596     uint256 private _burnCounter;
1597 
1598     // Token name
1599     string private _name;
1600 
1601     // Token symbol
1602     string private _symbol;
1603 
1604     // Mapping from token ID to ownership details
1605     // An empty struct value does not necessarily mean the token is unowned.
1606     // See {_packedOwnershipOf} implementation for details.
1607     //
1608     // Bits Layout:
1609     // - [0..159]   `addr`
1610     // - [160..223] `startTimestamp`
1611     // - [224]      `burned`
1612     // - [225]      `nextInitialized`
1613     // - [232..255] `extraData`
1614     mapping(uint256 => uint256) private _packedOwnerships;
1615 
1616     // Mapping owner address to address data.
1617     //
1618     // Bits Layout:
1619     // - [0..63]    `balance`
1620     // - [64..127]  `numberMinted`
1621     // - [128..191] `numberBurned`
1622     // - [192..255] `aux`
1623     mapping(address => uint256) private _packedAddressData;
1624 
1625     // Mapping from token ID to approved address.
1626     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1627 
1628     // Mapping from owner to operator approvals
1629     mapping(address => mapping(address => bool)) private _operatorApprovals;
1630 
1631     // =============================================================
1632     //                          CONSTRUCTOR
1633     // =============================================================
1634 
1635     constructor(string memory name_, string memory symbol_) {
1636         _name = name_;
1637         _symbol = symbol_;
1638         _currentIndex = _startTokenId();
1639     }
1640 
1641     // =============================================================
1642     //                   TOKEN COUNTING OPERATIONS
1643     // =============================================================
1644 
1645     /**
1646      * @dev Returns the starting token ID.
1647      * To change the starting token ID, please override this function.
1648      */
1649     function _startTokenId() internal view virtual returns (uint256) {
1650         return 0;
1651     }
1652 
1653     /**
1654      * @dev Returns the next token ID to be minted.
1655      */
1656     function _nextTokenId() internal view virtual returns (uint256) {
1657         return _currentIndex;
1658     }
1659 
1660     /**
1661      * @dev Returns the total number of tokens in existence.
1662      * Burned tokens will reduce the count.
1663      * To get the total number of tokens minted, please see {_totalMinted}.
1664      */
1665     function totalSupply() public view virtual override returns (uint256) {
1666         // Counter underflow is impossible as _burnCounter cannot be incremented
1667         // more than `_currentIndex - _startTokenId()` times.
1668         unchecked {
1669             return _currentIndex - _burnCounter - _startTokenId();
1670         }
1671     }
1672 
1673     /**
1674      * @dev Returns the total amount of tokens minted in the contract.
1675      */
1676     function _totalMinted() internal view virtual returns (uint256) {
1677         // Counter underflow is impossible as `_currentIndex` does not decrement,
1678         // and it is initialized to `_startTokenId()`.
1679         unchecked {
1680             return _currentIndex - _startTokenId();
1681         }
1682     }
1683 
1684     /**
1685      * @dev Returns the total number of tokens burned.
1686      */
1687     function _totalBurned() internal view virtual returns (uint256) {
1688         return _burnCounter;
1689     }
1690 
1691     // =============================================================
1692     //                    ADDRESS DATA OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Returns the number of tokens in `owner`'s account.
1697      */
1698     function balanceOf(
1699         address owner
1700     ) public view virtual override returns (uint256) {
1701         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1702         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1703     }
1704 
1705     /**
1706      * Returns the number of tokens minted by `owner`.
1707      */
1708     function _numberMinted(address owner) internal view returns (uint256) {
1709         return
1710             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
1711             _BITMASK_ADDRESS_DATA_ENTRY;
1712     }
1713 
1714     /**
1715      * Returns the number of tokens burned by or on behalf of `owner`.
1716      */
1717     function _numberBurned(address owner) internal view returns (uint256) {
1718         return
1719             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
1720             _BITMASK_ADDRESS_DATA_ENTRY;
1721     }
1722 
1723     /**
1724      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1725      */
1726     function _getAux(address owner) internal view returns (uint64) {
1727         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1728     }
1729 
1730     /**
1731      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1732      * If there are multiple variables, please pack them into a uint64.
1733      */
1734     function _setAux(address owner, uint64 aux) internal virtual {
1735         uint256 packed = _packedAddressData[owner];
1736         uint256 auxCasted;
1737         // Cast `aux` with assembly to avoid redundant masking.
1738         assembly {
1739             auxCasted := aux
1740         }
1741         packed =
1742             (packed & _BITMASK_AUX_COMPLEMENT) |
1743             (auxCasted << _BITPOS_AUX);
1744         _packedAddressData[owner] = packed;
1745     }
1746 
1747     // =============================================================
1748     //                            IERC165
1749     // =============================================================
1750 
1751     /**
1752      * @dev Returns true if this contract implements the interface defined by
1753      * `interfaceId`. See the corresponding
1754      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1755      * to learn more about how these ids are created.
1756      *
1757      * This function call must use less than 30000 gas.
1758      */
1759     function supportsInterface(
1760         bytes4 interfaceId
1761     ) public view virtual override returns (bool) {
1762         // The interface IDs are constants representing the first 4 bytes
1763         // of the XOR of all function selectors in the interface.
1764         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1765         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1766         return
1767             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1768             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1769             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1770     }
1771 
1772     // =============================================================
1773     //                        IERC721Metadata
1774     // =============================================================
1775 
1776     /**
1777      * @dev Returns the token collection name.
1778      */
1779     function name() public view virtual override returns (string memory) {
1780         return _name;
1781     }
1782 
1783     /**
1784      * @dev Returns the token collection symbol.
1785      */
1786     function symbol() public view virtual override returns (string memory) {
1787         return _symbol;
1788     }
1789 
1790     /**
1791      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1792      */
1793     function tokenURI(
1794         uint256 tokenId
1795     ) public view virtual override returns (string memory) {
1796         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1797 
1798         string memory baseURI = _baseURI();
1799         return
1800             bytes(baseURI).length != 0
1801                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1802                 : "";
1803     }
1804 
1805     /**
1806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1808      * by default, it can be overridden in child contracts.
1809      */
1810     function _baseURI() internal view virtual returns (string memory) {
1811         return "";
1812     }
1813 
1814     // =============================================================
1815     //                     OWNERSHIPS OPERATIONS
1816     // =============================================================
1817 
1818     /**
1819      * @dev Returns the owner of the `tokenId` token.
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must exist.
1824      */
1825     function ownerOf(
1826         uint256 tokenId
1827     ) public view virtual override returns (address) {
1828         return address(uint160(_packedOwnershipOf(tokenId)));
1829     }
1830 
1831     /**
1832      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1833      * It gradually moves to O(1) as tokens get transferred around over time.
1834      */
1835     function _ownershipOf(
1836         uint256 tokenId
1837     ) internal view virtual returns (TokenOwnership memory) {
1838         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1839     }
1840 
1841     /**
1842      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1843      */
1844     function _ownershipAt(
1845         uint256 index
1846     ) internal view virtual returns (TokenOwnership memory) {
1847         return _unpackedOwnership(_packedOwnerships[index]);
1848     }
1849 
1850     /**
1851      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1852      */
1853     function _initializeOwnershipAt(uint256 index) internal virtual {
1854         if (_packedOwnerships[index] == 0) {
1855             _packedOwnerships[index] = _packedOwnershipOf(index);
1856         }
1857     }
1858 
1859     /**
1860      * Returns the packed ownership data of `tokenId`.
1861      */
1862     function _packedOwnershipOf(
1863         uint256 tokenId
1864     ) private view returns (uint256) {
1865         uint256 curr = tokenId;
1866 
1867         unchecked {
1868             if (_startTokenId() <= curr)
1869                 if (curr < _currentIndex) {
1870                     uint256 packed = _packedOwnerships[curr];
1871                     // If not burned.
1872                     if (packed & _BITMASK_BURNED == 0) {
1873                         // Invariant:
1874                         // There will always be an initialized ownership slot
1875                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1876                         // before an unintialized ownership slot
1877                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1878                         // Hence, `curr` will not underflow.
1879                         //
1880                         // We can directly compare the packed value.
1881                         // If the address is zero, packed will be zero.
1882                         while (packed == 0) {
1883                             packed = _packedOwnerships[--curr];
1884                         }
1885                         return packed;
1886                     }
1887                 }
1888         }
1889         revert OwnerQueryForNonexistentToken();
1890     }
1891 
1892     /**
1893      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1894      */
1895     function _unpackedOwnership(
1896         uint256 packed
1897     ) private pure returns (TokenOwnership memory ownership) {
1898         ownership.addr = address(uint160(packed));
1899         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1900         ownership.burned = packed & _BITMASK_BURNED != 0;
1901         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1902     }
1903 
1904     /**
1905      * @dev Packs ownership data into a single uint256.
1906      */
1907     function _packOwnershipData(
1908         address owner,
1909         uint256 flags
1910     ) private view returns (uint256 result) {
1911         assembly {
1912             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1913             owner := and(owner, _BITMASK_ADDRESS)
1914             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1915             result := or(
1916                 owner,
1917                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
1918             )
1919         }
1920     }
1921 
1922     /**
1923      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1924      */
1925     function _nextInitializedFlag(
1926         uint256 quantity
1927     ) private pure returns (uint256 result) {
1928         // For branchless setting of the `nextInitialized` flag.
1929         assembly {
1930             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1931             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1932         }
1933     }
1934 
1935     // =============================================================
1936     //                      APPROVAL OPERATIONS
1937     // =============================================================
1938 
1939     /**
1940      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1941      * The approval is cleared when the token is transferred.
1942      *
1943      * Only a single account can be approved at a time, so approving the
1944      * zero address clears previous approvals.
1945      *
1946      * Requirements:
1947      *
1948      * - The caller must own the token or be an approved operator.
1949      * - `tokenId` must exist.
1950      *
1951      * Emits an {Approval} event.
1952      */
1953     function approve(
1954         address to,
1955         uint256 tokenId
1956     ) public payable virtual override {
1957         address owner = ownerOf(tokenId);
1958 
1959         if (_msgSenderERC721A() != owner)
1960             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1961                 revert ApprovalCallerNotOwnerNorApproved();
1962             }
1963 
1964         _tokenApprovals[tokenId].value = to;
1965         emit Approval(owner, to, tokenId);
1966     }
1967 
1968     /**
1969      * @dev Returns the account approved for `tokenId` token.
1970      *
1971      * Requirements:
1972      *
1973      * - `tokenId` must exist.
1974      */
1975     function getApproved(
1976         uint256 tokenId
1977     ) public view virtual override returns (address) {
1978         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1979 
1980         return _tokenApprovals[tokenId].value;
1981     }
1982 
1983     /**
1984      * @dev Approve or remove `operator` as an operator for the caller.
1985      * Operators can call {transferFrom} or {safeTransferFrom}
1986      * for any token owned by the caller.
1987      *
1988      * Requirements:
1989      *
1990      * - The `operator` cannot be the caller.
1991      *
1992      * Emits an {ApprovalForAll} event.
1993      */
1994     function setApprovalForAll(
1995         address operator,
1996         bool approved
1997     ) public virtual override {
1998         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1999         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2000     }
2001 
2002     /**
2003      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2004      *
2005      * See {setApprovalForAll}.
2006      */
2007     function isApprovedForAll(
2008         address owner,
2009         address operator
2010     ) public view virtual override returns (bool) {
2011         return _operatorApprovals[owner][operator];
2012     }
2013 
2014     /**
2015      * @dev Returns whether `tokenId` exists.
2016      *
2017      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2018      *
2019      * Tokens start existing when they are minted. See {_mint}.
2020      */
2021     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2022         return
2023             _startTokenId() <= tokenId &&
2024             tokenId < _currentIndex && // If within bounds,
2025             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2026     }
2027 
2028     /**
2029      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2030      */
2031     function _isSenderApprovedOrOwner(
2032         address approvedAddress,
2033         address owner,
2034         address msgSender
2035     ) private pure returns (bool result) {
2036         assembly {
2037             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2038             owner := and(owner, _BITMASK_ADDRESS)
2039             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2040             msgSender := and(msgSender, _BITMASK_ADDRESS)
2041             // `msgSender == owner || msgSender == approvedAddress`.
2042             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2043         }
2044     }
2045 
2046     /**
2047      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2048      */
2049     function _getApprovedSlotAndAddress(
2050         uint256 tokenId
2051     )
2052         private
2053         view
2054         returns (uint256 approvedAddressSlot, address approvedAddress)
2055     {
2056         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2057         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2058         assembly {
2059             approvedAddressSlot := tokenApproval.slot
2060             approvedAddress := sload(approvedAddressSlot)
2061         }
2062     }
2063 
2064     // =============================================================
2065     //                      TRANSFER OPERATIONS
2066     // =============================================================
2067 
2068     /**
2069      * @dev Transfers `tokenId` from `from` to `to`.
2070      *
2071      * Requirements:
2072      *
2073      * - `from` cannot be the zero address.
2074      * - `to` cannot be the zero address.
2075      * - `tokenId` token must be owned by `from`.
2076      * - If the caller is not `from`, it must be approved to move this token
2077      * by either {approve} or {setApprovalForAll}.
2078      *
2079      * Emits a {Transfer} event.
2080      */
2081     function transferFrom(
2082         address from,
2083         address to,
2084         uint256 tokenId
2085     ) public payable virtual override {
2086         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2087 
2088         if (address(uint160(prevOwnershipPacked)) != from)
2089             revert TransferFromIncorrectOwner();
2090 
2091         (
2092             uint256 approvedAddressSlot,
2093             address approvedAddress
2094         ) = _getApprovedSlotAndAddress(tokenId);
2095 
2096         // The nested ifs save around 20+ gas over a compound boolean condition.
2097         if (
2098             !_isSenderApprovedOrOwner(
2099                 approvedAddress,
2100                 from,
2101                 _msgSenderERC721A()
2102             )
2103         )
2104             if (!isApprovedForAll(from, _msgSenderERC721A()))
2105                 revert TransferCallerNotOwnerNorApproved();
2106 
2107         if (to == address(0)) revert TransferToZeroAddress();
2108 
2109         _beforeTokenTransfers(from, to, tokenId, 1);
2110 
2111         // Clear approvals from the previous owner.
2112         assembly {
2113             if approvedAddress {
2114                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2115                 sstore(approvedAddressSlot, 0)
2116             }
2117         }
2118 
2119         // Underflow of the sender's balance is impossible because we check for
2120         // ownership above and the recipient's balance can't realistically overflow.
2121         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2122         unchecked {
2123             // We can directly increment and decrement the balances.
2124             --_packedAddressData[from]; // Updates: `balance -= 1`.
2125             ++_packedAddressData[to]; // Updates: `balance += 1`.
2126 
2127             // Updates:
2128             // - `address` to the next owner.
2129             // - `startTimestamp` to the timestamp of transfering.
2130             // - `burned` to `false`.
2131             // - `nextInitialized` to `true`.
2132             _packedOwnerships[tokenId] = _packOwnershipData(
2133                 to,
2134                 _BITMASK_NEXT_INITIALIZED |
2135                     _nextExtraData(from, to, prevOwnershipPacked)
2136             );
2137 
2138             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2139             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2140                 uint256 nextTokenId = tokenId + 1;
2141                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2142                 if (_packedOwnerships[nextTokenId] == 0) {
2143                     // If the next slot is within bounds.
2144                     if (nextTokenId != _currentIndex) {
2145                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2146                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2147                     }
2148                 }
2149             }
2150         }
2151 
2152         emit Transfer(from, to, tokenId);
2153         _afterTokenTransfers(from, to, tokenId, 1);
2154     }
2155 
2156     /**
2157      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2158      */
2159     function safeTransferFrom(
2160         address from,
2161         address to,
2162         uint256 tokenId
2163     ) public payable virtual override {
2164         safeTransferFrom(from, to, tokenId, "");
2165     }
2166 
2167     /**
2168      * @dev Safely transfers `tokenId` token from `from` to `to`.
2169      *
2170      * Requirements:
2171      *
2172      * - `from` cannot be the zero address.
2173      * - `to` cannot be the zero address.
2174      * - `tokenId` token must exist and be owned by `from`.
2175      * - If the caller is not `from`, it must be approved to move this token
2176      * by either {approve} or {setApprovalForAll}.
2177      * - If `to` refers to a smart contract, it must implement
2178      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2179      *
2180      * Emits a {Transfer} event.
2181      */
2182     function safeTransferFrom(
2183         address from,
2184         address to,
2185         uint256 tokenId,
2186         bytes memory _data
2187     ) public payable virtual override {
2188         transferFrom(from, to, tokenId);
2189         if (to.code.length != 0)
2190             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2191                 revert TransferToNonERC721ReceiverImplementer();
2192             }
2193     }
2194 
2195     /**
2196      * @dev Hook that is called before a set of serially-ordered token IDs
2197      * are about to be transferred. This includes minting.
2198      * And also called before burning one token.
2199      *
2200      * `startTokenId` - the first token ID to be transferred.
2201      * `quantity` - the amount to be transferred.
2202      *
2203      * Calling conditions:
2204      *
2205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2206      * transferred to `to`.
2207      * - When `from` is zero, `tokenId` will be minted for `to`.
2208      * - When `to` is zero, `tokenId` will be burned by `from`.
2209      * - `from` and `to` are never both zero.
2210      */
2211     function _beforeTokenTransfers(
2212         address from,
2213         address to,
2214         uint256 startTokenId,
2215         uint256 quantity
2216     ) internal virtual {}
2217 
2218     /**
2219      * @dev Hook that is called after a set of serially-ordered token IDs
2220      * have been transferred. This includes minting.
2221      * And also called after one token has been burned.
2222      *
2223      * `startTokenId` - the first token ID to be transferred.
2224      * `quantity` - the amount to be transferred.
2225      *
2226      * Calling conditions:
2227      *
2228      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2229      * transferred to `to`.
2230      * - When `from` is zero, `tokenId` has been minted for `to`.
2231      * - When `to` is zero, `tokenId` has been burned by `from`.
2232      * - `from` and `to` are never both zero.
2233      */
2234     function _afterTokenTransfers(
2235         address from,
2236         address to,
2237         uint256 startTokenId,
2238         uint256 quantity
2239     ) internal virtual {}
2240 
2241     /**
2242      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2243      *
2244      * `from` - Previous owner of the given token ID.
2245      * `to` - Target address that will receive the token.
2246      * `tokenId` - Token ID to be transferred.
2247      * `_data` - Optional data to send along with the call.
2248      *
2249      * Returns whether the call correctly returned the expected magic value.
2250      */
2251     function _checkContractOnERC721Received(
2252         address from,
2253         address to,
2254         uint256 tokenId,
2255         bytes memory _data
2256     ) private returns (bool) {
2257         try
2258             ERC721A__IERC721Receiver(to).onERC721Received(
2259                 _msgSenderERC721A(),
2260                 from,
2261                 tokenId,
2262                 _data
2263             )
2264         returns (bytes4 retval) {
2265             return
2266                 retval ==
2267                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
2268         } catch (bytes memory reason) {
2269             if (reason.length == 0) {
2270                 revert TransferToNonERC721ReceiverImplementer();
2271             } else {
2272                 assembly {
2273                     revert(add(32, reason), mload(reason))
2274                 }
2275             }
2276         }
2277     }
2278 
2279     // =============================================================
2280     //                        MINT OPERATIONS
2281     // =============================================================
2282 
2283     /**
2284      * @dev Mints `quantity` tokens and transfers them to `to`.
2285      *
2286      * Requirements:
2287      *
2288      * - `to` cannot be the zero address.
2289      * - `quantity` must be greater than 0.
2290      *
2291      * Emits a {Transfer} event for each mint.
2292      */
2293     function _mint(address to, uint256 quantity) internal virtual {
2294         uint256 startTokenId = _currentIndex;
2295         if (quantity == 0) revert MintZeroQuantity();
2296 
2297         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2298 
2299         // Overflows are incredibly unrealistic.
2300         // `balance` and `numberMinted` have a maximum limit of 2**64.
2301         // `tokenId` has a maximum limit of 2**256.
2302         unchecked {
2303             // Updates:
2304             // - `balance += quantity`.
2305             // - `numberMinted += quantity`.
2306             //
2307             // We can directly add to the `balance` and `numberMinted`.
2308             _packedAddressData[to] +=
2309                 quantity *
2310                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
2311 
2312             // Updates:
2313             // - `address` to the owner.
2314             // - `startTimestamp` to the timestamp of minting.
2315             // - `burned` to `false`.
2316             // - `nextInitialized` to `quantity == 1`.
2317             _packedOwnerships[startTokenId] = _packOwnershipData(
2318                 to,
2319                 _nextInitializedFlag(quantity) |
2320                     _nextExtraData(address(0), to, 0)
2321             );
2322 
2323             uint256 toMasked;
2324             uint256 end = startTokenId + quantity;
2325 
2326             // Use assembly to loop and emit the `Transfer` event for gas savings.
2327             // The duplicated `log4` removes an extra check and reduces stack juggling.
2328             // The assembly, together with the surrounding Solidity code, have been
2329             // delicately arranged to nudge the compiler into producing optimized opcodes.
2330             assembly {
2331                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2332                 toMasked := and(to, _BITMASK_ADDRESS)
2333                 // Emit the `Transfer` event.
2334                 log4(
2335                     0, // Start of data (0, since no data).
2336                     0, // End of data (0, since no data).
2337                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2338                     0, // `address(0)`.
2339                     toMasked, // `to`.
2340                     startTokenId // `tokenId`.
2341                 )
2342 
2343                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2344                 // that overflows uint256 will make the loop run out of gas.
2345                 // The compiler will optimize the `iszero` away for performance.
2346                 for {
2347                     let tokenId := add(startTokenId, 1)
2348                 } iszero(eq(tokenId, end)) {
2349                     tokenId := add(tokenId, 1)
2350                 } {
2351                     // Emit the `Transfer` event. Similar to above.
2352                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2353                 }
2354             }
2355             if (toMasked == 0) revert MintToZeroAddress();
2356 
2357             _currentIndex = end;
2358         }
2359         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2360     }
2361 
2362     /**
2363      * @dev Mints `quantity` tokens and transfers them to `to`.
2364      *
2365      * This function is intended for efficient minting only during contract creation.
2366      *
2367      * It emits only one {ConsecutiveTransfer} as defined in
2368      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2369      * instead of a sequence of {Transfer} event(s).
2370      *
2371      * Calling this function outside of contract creation WILL make your contract
2372      * non-compliant with the ERC721 standard.
2373      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2374      * {ConsecutiveTransfer} event is only permissible during contract creation.
2375      *
2376      * Requirements:
2377      *
2378      * - `to` cannot be the zero address.
2379      * - `quantity` must be greater than 0.
2380      *
2381      * Emits a {ConsecutiveTransfer} event.
2382      */
2383     function _mintERC2309(address to, uint256 quantity) internal virtual {
2384         uint256 startTokenId = _currentIndex;
2385         if (to == address(0)) revert MintToZeroAddress();
2386         if (quantity == 0) revert MintZeroQuantity();
2387         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
2388             revert MintERC2309QuantityExceedsLimit();
2389 
2390         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2391 
2392         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2393         unchecked {
2394             // Updates:
2395             // - `balance += quantity`.
2396             // - `numberMinted += quantity`.
2397             //
2398             // We can directly add to the `balance` and `numberMinted`.
2399             _packedAddressData[to] +=
2400                 quantity *
2401                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
2402 
2403             // Updates:
2404             // - `address` to the owner.
2405             // - `startTimestamp` to the timestamp of minting.
2406             // - `burned` to `false`.
2407             // - `nextInitialized` to `quantity == 1`.
2408             _packedOwnerships[startTokenId] = _packOwnershipData(
2409                 to,
2410                 _nextInitializedFlag(quantity) |
2411                     _nextExtraData(address(0), to, 0)
2412             );
2413 
2414             emit ConsecutiveTransfer(
2415                 startTokenId,
2416                 startTokenId + quantity - 1,
2417                 address(0),
2418                 to
2419             );
2420 
2421             _currentIndex = startTokenId + quantity;
2422         }
2423         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2424     }
2425 
2426     /**
2427      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2428      *
2429      * Requirements:
2430      *
2431      * - If `to` refers to a smart contract, it must implement
2432      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2433      * - `quantity` must be greater than 0.
2434      *
2435      * See {_mint}.
2436      *
2437      * Emits a {Transfer} event for each mint.
2438      */
2439     function _safeMint(
2440         address to,
2441         uint256 quantity,
2442         bytes memory _data
2443     ) internal virtual {
2444         _mint(to, quantity);
2445 
2446         unchecked {
2447             if (to.code.length != 0) {
2448                 uint256 end = _currentIndex;
2449                 uint256 index = end - quantity;
2450                 do {
2451                     if (
2452                         !_checkContractOnERC721Received(
2453                             address(0),
2454                             to,
2455                             index++,
2456                             _data
2457                         )
2458                     ) {
2459                         revert TransferToNonERC721ReceiverImplementer();
2460                     }
2461                 } while (index < end);
2462                 // Reentrancy protection.
2463                 if (_currentIndex != end) revert();
2464             }
2465         }
2466     }
2467 
2468     /**
2469      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2470      */
2471     function _safeMint(address to, uint256 quantity) internal virtual {
2472         _safeMint(to, quantity, "");
2473     }
2474 
2475     // =============================================================
2476     //                        BURN OPERATIONS
2477     // =============================================================
2478 
2479     /**
2480      * @dev Equivalent to `_burn(tokenId, false)`.
2481      */
2482     function _burn(uint256 tokenId) internal virtual {
2483         _burn(tokenId, false);
2484     }
2485 
2486     /**
2487      * @dev Destroys `tokenId`.
2488      * The approval is cleared when the token is burned.
2489      *
2490      * Requirements:
2491      *
2492      * - `tokenId` must exist.
2493      *
2494      * Emits a {Transfer} event.
2495      */
2496     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2497         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2498 
2499         address from = address(uint160(prevOwnershipPacked));
2500 
2501         (
2502             uint256 approvedAddressSlot,
2503             address approvedAddress
2504         ) = _getApprovedSlotAndAddress(tokenId);
2505 
2506         if (approvalCheck) {
2507             // The nested ifs save around 20+ gas over a compound boolean condition.
2508             if (
2509                 !_isSenderApprovedOrOwner(
2510                     approvedAddress,
2511                     from,
2512                     _msgSenderERC721A()
2513                 )
2514             )
2515                 if (!isApprovedForAll(from, _msgSenderERC721A()))
2516                     revert TransferCallerNotOwnerNorApproved();
2517         }
2518 
2519         _beforeTokenTransfers(from, address(0), tokenId, 1);
2520 
2521         // Clear approvals from the previous owner.
2522         assembly {
2523             if approvedAddress {
2524                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2525                 sstore(approvedAddressSlot, 0)
2526             }
2527         }
2528 
2529         // Underflow of the sender's balance is impossible because we check for
2530         // ownership above and the recipient's balance can't realistically overflow.
2531         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2532         unchecked {
2533             // Updates:
2534             // - `balance -= 1`.
2535             // - `numberBurned += 1`.
2536             //
2537             // We can directly decrement the balance, and increment the number burned.
2538             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2539             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2540 
2541             // Updates:
2542             // - `address` to the last owner.
2543             // - `startTimestamp` to the timestamp of burning.
2544             // - `burned` to `true`.
2545             // - `nextInitialized` to `true`.
2546             _packedOwnerships[tokenId] = _packOwnershipData(
2547                 from,
2548                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
2549                     _nextExtraData(from, address(0), prevOwnershipPacked)
2550             );
2551 
2552             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2553             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2554                 uint256 nextTokenId = tokenId + 1;
2555                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2556                 if (_packedOwnerships[nextTokenId] == 0) {
2557                     // If the next slot is within bounds.
2558                     if (nextTokenId != _currentIndex) {
2559                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2560                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2561                     }
2562                 }
2563             }
2564         }
2565 
2566         emit Transfer(from, address(0), tokenId);
2567         _afterTokenTransfers(from, address(0), tokenId, 1);
2568 
2569         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2570         unchecked {
2571             _burnCounter++;
2572         }
2573     }
2574 
2575     // =============================================================
2576     //                     EXTRA DATA OPERATIONS
2577     // =============================================================
2578 
2579     /**
2580      * @dev Directly sets the extra data for the ownership data `index`.
2581      */
2582     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2583         uint256 packed = _packedOwnerships[index];
2584         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2585         uint256 extraDataCasted;
2586         // Cast `extraData` with assembly to avoid redundant masking.
2587         assembly {
2588             extraDataCasted := extraData
2589         }
2590         packed =
2591             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
2592             (extraDataCasted << _BITPOS_EXTRA_DATA);
2593         _packedOwnerships[index] = packed;
2594     }
2595 
2596     /**
2597      * @dev Called during each token transfer to set the 24bit `extraData` field.
2598      * Intended to be overridden by the cosumer contract.
2599      *
2600      * `previousExtraData` - the value of `extraData` before transfer.
2601      *
2602      * Calling conditions:
2603      *
2604      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2605      * transferred to `to`.
2606      * - When `from` is zero, `tokenId` will be minted for `to`.
2607      * - When `to` is zero, `tokenId` will be burned by `from`.
2608      * - `from` and `to` are never both zero.
2609      */
2610     function _extraData(
2611         address from,
2612         address to,
2613         uint24 previousExtraData
2614     ) internal view virtual returns (uint24) {}
2615 
2616     /**
2617      * @dev Returns the next extra data for the packed ownership data.
2618      * The returned result is shifted into position.
2619      */
2620     function _nextExtraData(
2621         address from,
2622         address to,
2623         uint256 prevOwnershipPacked
2624     ) private view returns (uint256) {
2625         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2626         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2627     }
2628 
2629     // =============================================================
2630     //                       OTHER OPERATIONS
2631     // =============================================================
2632 
2633     /**
2634      * @dev Returns the message sender (defaults to `msg.sender`).
2635      *
2636      * If you are writing GSN compatible contracts, you need to override this function.
2637      */
2638     function _msgSenderERC721A() internal view virtual returns (address) {
2639         return msg.sender;
2640     }
2641 
2642     /**
2643      * @dev Converts a uint256 to its ASCII string decimal representation.
2644      */
2645     function _toString(
2646         uint256 value
2647     ) internal pure virtual returns (string memory str) {
2648         assembly {
2649             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2650             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2651             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2652             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2653             let m := add(mload(0x40), 0xa0)
2654             // Update the free memory pointer to allocate.
2655             mstore(0x40, m)
2656             // Assign the `str` to the end.
2657             str := sub(m, 0x20)
2658             // Zeroize the slot after the string.
2659             mstore(str, 0)
2660 
2661             // Cache the end of the memory to calculate the length later.
2662             let end := str
2663 
2664             // We write the string from rightmost digit to leftmost digit.
2665             // The following is essentially a do-while loop that also handles the zero case.
2666             // prettier-ignore
2667             for { let temp := value } 1 {} {
2668                 str := sub(str, 1)
2669             // Write the character to the pointer.
2670             // The ASCII index of the '0' character is 48.
2671                 mstore8(str, add(48, mod(temp, 10)))
2672             // Keep dividing `temp` until zero.
2673                 temp := div(temp, 10)
2674             // prettier-ignore
2675                 if iszero(temp) { break }
2676             }
2677 
2678             let length := sub(end, str)
2679             // Move the pointer 32 bytes leftwards to make room for the length.
2680             str := sub(str, 0x20)
2681             // Store the length.
2682             mstore(str, length)
2683         }
2684     }
2685 }
2686 
2687 // File erc721a/contracts/extensions/IERC721ABurnable.sol@v4.2.3
2688 
2689 
2690 // ERC721A Contracts v4.2.3
2691 // Creator: Chiru Labs
2692 
2693 pragma solidity ^0.8.4;
2694 
2695 /**
2696  * @dev Interface of ERC721ABurnable.
2697  */
2698 interface IERC721ABurnable is IERC721A {
2699     /**
2700      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2701      *
2702      * Requirements:
2703      *
2704      * - The caller must own `tokenId` or be an approved operator.
2705      */
2706     function burn(uint256 tokenId) external;
2707 }
2708 
2709 // File erc721a/contracts/extensions/ERC721ABurnable.sol@v4.2.3
2710 
2711 
2712 // ERC721A Contracts v4.2.3
2713 // Creator: Chiru Labs
2714 
2715 pragma solidity ^0.8.4;
2716 
2717 /**
2718  * @title ERC721ABurnable.
2719  *
2720  * @dev ERC721A token that can be irreversibly burned (destroyed).
2721  */
2722 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2723     /**
2724      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2725      *
2726      * Requirements:
2727      *
2728      * - The caller must own `tokenId` or be an approved operator.
2729      */
2730     function burn(uint256 tokenId) public virtual override {
2731         _burn(tokenId, true);
2732     }
2733 }
2734 
2735 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.2.3
2736 
2737 
2738 // ERC721A Contracts v4.2.3
2739 // Creator: Chiru Labs
2740 
2741 pragma solidity ^0.8.4;
2742 
2743 /**
2744  * @dev Interface of ERC721AQueryable.
2745  */
2746 interface IERC721AQueryable is IERC721A {
2747     /**
2748      * Invalid query range (`start` >= `stop`).
2749      */
2750     error InvalidQueryRange();
2751 
2752     /**
2753      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2754      *
2755      * If the `tokenId` is out of bounds:
2756      *
2757      * - `addr = address(0)`
2758      * - `startTimestamp = 0`
2759      * - `burned = false`
2760      * - `extraData = 0`
2761      *
2762      * If the `tokenId` is burned:
2763      *
2764      * - `addr = <Address of owner before token was burned>`
2765      * - `startTimestamp = <Timestamp when token was burned>`
2766      * - `burned = true`
2767      * - `extraData = <Extra data when token was burned>`
2768      *
2769      * Otherwise:
2770      *
2771      * - `addr = <Address of owner>`
2772      * - `startTimestamp = <Timestamp of start of ownership>`
2773      * - `burned = false`
2774      * - `extraData = <Extra data at start of ownership>`
2775      */
2776     function explicitOwnershipOf(
2777         uint256 tokenId
2778     ) external view returns (TokenOwnership memory);
2779 
2780     /**
2781      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2782      * See {ERC721AQueryable-explicitOwnershipOf}
2783      */
2784     function explicitOwnershipsOf(
2785         uint256[] memory tokenIds
2786     ) external view returns (TokenOwnership[] memory);
2787 
2788     /**
2789      * @dev Returns an array of token IDs owned by `owner`,
2790      * in the range [`start`, `stop`)
2791      * (i.e. `start <= tokenId < stop`).
2792      *
2793      * This function allows for tokens to be queried if the collection
2794      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2795      *
2796      * Requirements:
2797      *
2798      * - `start < stop`
2799      */
2800     function tokensOfOwnerIn(
2801         address owner,
2802         uint256 start,
2803         uint256 stop
2804     ) external view returns (uint256[] memory);
2805 
2806     /**
2807      * @dev Returns an array of token IDs owned by `owner`.
2808      *
2809      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2810      * It is meant to be called off-chain.
2811      *
2812      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2813      * multiple smaller scans if the collection is large enough to cause
2814      * an out-of-gas error (10K collections should be fine).
2815      */
2816     function tokensOfOwner(
2817         address owner
2818     ) external view returns (uint256[] memory);
2819 }
2820 
2821 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.2.3
2822 
2823 
2824 // ERC721A Contracts v4.2.3
2825 // Creator: Chiru Labs
2826 
2827 pragma solidity ^0.8.4;
2828 
2829 /**
2830  * @title ERC721AQueryable.
2831  *
2832  * @dev ERC721A subclass with convenience query functions.
2833  */
2834 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2835     /**
2836      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2837      *
2838      * If the `tokenId` is out of bounds:
2839      *
2840      * - `addr = address(0)`
2841      * - `startTimestamp = 0`
2842      * - `burned = false`
2843      * - `extraData = 0`
2844      *
2845      * If the `tokenId` is burned:
2846      *
2847      * - `addr = <Address of owner before token was burned>`
2848      * - `startTimestamp = <Timestamp when token was burned>`
2849      * - `burned = true`
2850      * - `extraData = <Extra data when token was burned>`
2851      *
2852      * Otherwise:
2853      *
2854      * - `addr = <Address of owner>`
2855      * - `startTimestamp = <Timestamp of start of ownership>`
2856      * - `burned = false`
2857      * - `extraData = <Extra data at start of ownership>`
2858      */
2859     function explicitOwnershipOf(
2860         uint256 tokenId
2861     ) public view virtual override returns (TokenOwnership memory) {
2862         TokenOwnership memory ownership;
2863         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2864             return ownership;
2865         }
2866         ownership = _ownershipAt(tokenId);
2867         if (ownership.burned) {
2868             return ownership;
2869         }
2870         return _ownershipOf(tokenId);
2871     }
2872 
2873     /**
2874      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2875      * See {ERC721AQueryable-explicitOwnershipOf}
2876      */
2877     function explicitOwnershipsOf(
2878         uint256[] calldata tokenIds
2879     ) external view virtual override returns (TokenOwnership[] memory) {
2880         unchecked {
2881             uint256 tokenIdsLength = tokenIds.length;
2882             TokenOwnership[] memory ownerships = new TokenOwnership[](
2883                 tokenIdsLength
2884             );
2885             for (uint256 i; i != tokenIdsLength; ++i) {
2886                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2887             }
2888             return ownerships;
2889         }
2890     }
2891 
2892     /**
2893      * @dev Returns an array of token IDs owned by `owner`,
2894      * in the range [`start`, `stop`)
2895      * (i.e. `start <= tokenId < stop`).
2896      *
2897      * This function allows for tokens to be queried if the collection
2898      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2899      *
2900      * Requirements:
2901      *
2902      * - `start < stop`
2903      */
2904     function tokensOfOwnerIn(
2905         address owner,
2906         uint256 start,
2907         uint256 stop
2908     ) external view virtual override returns (uint256[] memory) {
2909         unchecked {
2910             if (start >= stop) revert InvalidQueryRange();
2911             uint256 tokenIdsIdx;
2912             uint256 stopLimit = _nextTokenId();
2913             // Set `start = max(start, _startTokenId())`.
2914             if (start < _startTokenId()) {
2915                 start = _startTokenId();
2916             }
2917             // Set `stop = min(stop, stopLimit)`.
2918             if (stop > stopLimit) {
2919                 stop = stopLimit;
2920             }
2921             uint256 tokenIdsMaxLength = balanceOf(owner);
2922             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2923             // to cater for cases where `balanceOf(owner)` is too big.
2924             if (start < stop) {
2925                 uint256 rangeLength = stop - start;
2926                 if (rangeLength < tokenIdsMaxLength) {
2927                     tokenIdsMaxLength = rangeLength;
2928                 }
2929             } else {
2930                 tokenIdsMaxLength = 0;
2931             }
2932             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2933             if (tokenIdsMaxLength == 0) {
2934                 return tokenIds;
2935             }
2936             // We need to call `explicitOwnershipOf(start)`,
2937             // because the slot at `start` may not be initialized.
2938             TokenOwnership memory ownership = explicitOwnershipOf(start);
2939             address currOwnershipAddr;
2940             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2941             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2942             if (!ownership.burned) {
2943                 currOwnershipAddr = ownership.addr;
2944             }
2945             for (
2946                 uint256 i = start;
2947                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
2948                 ++i
2949             ) {
2950                 ownership = _ownershipAt(i);
2951                 if (ownership.burned) {
2952                     continue;
2953                 }
2954                 if (ownership.addr != address(0)) {
2955                     currOwnershipAddr = ownership.addr;
2956                 }
2957                 if (currOwnershipAddr == owner) {
2958                     tokenIds[tokenIdsIdx++] = i;
2959                 }
2960             }
2961             // Downsize the array to fit.
2962             assembly {
2963                 mstore(tokenIds, tokenIdsIdx)
2964             }
2965             return tokenIds;
2966         }
2967     }
2968 
2969     /**
2970      * @dev Returns an array of token IDs owned by `owner`.
2971      *
2972      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2973      * It is meant to be called off-chain.
2974      *
2975      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2976      * multiple smaller scans if the collection is large enough to cause
2977      * an out-of-gas error (10K collections should be fine).
2978      */
2979     function tokensOfOwner(
2980         address owner
2981     ) external view virtual override returns (uint256[] memory) {
2982         unchecked {
2983             uint256 tokenIdsIdx;
2984             address currOwnershipAddr;
2985             uint256 tokenIdsLength = balanceOf(owner);
2986             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2987             TokenOwnership memory ownership;
2988             for (
2989                 uint256 i = _startTokenId();
2990                 tokenIdsIdx != tokenIdsLength;
2991                 ++i
2992             ) {
2993                 ownership = _ownershipAt(i);
2994                 if (ownership.burned) {
2995                     continue;
2996                 }
2997                 if (ownership.addr != address(0)) {
2998                     currOwnershipAddr = ownership.addr;
2999                 }
3000                 if (currOwnershipAddr == owner) {
3001                     tokenIds[tokenIdsIdx++] = i;
3002                 }
3003             }
3004             return tokenIds;
3005         }
3006     }
3007 }
3008 
3009 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.3.1
3010 
3011 
3012 pragma solidity ^0.8.13;
3013 
3014 interface IOperatorFilterRegistry {
3015     function isOperatorAllowed(
3016         address registrant,
3017         address operator
3018     ) external view returns (bool);
3019 
3020     function register(address registrant) external;
3021 
3022     function registerAndSubscribe(
3023         address registrant,
3024         address subscription
3025     ) external;
3026 
3027     function registerAndCopyEntries(
3028         address registrant,
3029         address registrantToCopy
3030     ) external;
3031 
3032     function unregister(address addr) external;
3033 
3034     function updateOperator(
3035         address registrant,
3036         address operator,
3037         bool filtered
3038     ) external;
3039 
3040     function updateOperators(
3041         address registrant,
3042         address[] calldata operators,
3043         bool filtered
3044     ) external;
3045 
3046     function updateCodeHash(
3047         address registrant,
3048         bytes32 codehash,
3049         bool filtered
3050     ) external;
3051 
3052     function updateCodeHashes(
3053         address registrant,
3054         bytes32[] calldata codeHashes,
3055         bool filtered
3056     ) external;
3057 
3058     function subscribe(
3059         address registrant,
3060         address registrantToSubscribe
3061     ) external;
3062 
3063     function unsubscribe(address registrant, bool copyExistingEntries) external;
3064 
3065     function subscriptionOf(address addr) external returns (address registrant);
3066 
3067     function subscribers(
3068         address registrant
3069     ) external returns (address[] memory);
3070 
3071     function subscriberAt(
3072         address registrant,
3073         uint256 index
3074     ) external returns (address);
3075 
3076     function copyEntriesOf(
3077         address registrant,
3078         address registrantToCopy
3079     ) external;
3080 
3081     function isOperatorFiltered(
3082         address registrant,
3083         address operator
3084     ) external returns (bool);
3085 
3086     function isCodeHashOfFiltered(
3087         address registrant,
3088         address operatorWithCode
3089     ) external returns (bool);
3090 
3091     function isCodeHashFiltered(
3092         address registrant,
3093         bytes32 codeHash
3094     ) external returns (bool);
3095 
3096     function filteredOperators(
3097         address addr
3098     ) external returns (address[] memory);
3099 
3100     function filteredCodeHashes(
3101         address addr
3102     ) external returns (bytes32[] memory);
3103 
3104     function filteredOperatorAt(
3105         address registrant,
3106         uint256 index
3107     ) external returns (address);
3108 
3109     function filteredCodeHashAt(
3110         address registrant,
3111         uint256 index
3112     ) external returns (bytes32);
3113 
3114     function isRegistered(address addr) external returns (bool);
3115 
3116     function codeHashOf(address addr) external returns (bytes32);
3117 }
3118 
3119 // File operator-filter-registry/src/OperatorFilterer.sol@v1.3.1
3120 
3121 
3122 pragma solidity ^0.8.13;
3123 
3124 /**
3125  * @title  OperatorFilterer
3126  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3127  *         registrant's entries in the OperatorFilterRegistry.
3128  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3129  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3130  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3131  */
3132 abstract contract OperatorFilterer {
3133     error OperatorNotAllowed(address operator);
3134 
3135     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3136         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3137 
3138     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3139         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3140         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3141         // order for the modifier to filter addresses.
3142         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3143             if (subscribe) {
3144                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
3145                     address(this),
3146                     subscriptionOrRegistrantToCopy
3147                 );
3148             } else {
3149                 if (subscriptionOrRegistrantToCopy != address(0)) {
3150                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
3151                         address(this),
3152                         subscriptionOrRegistrantToCopy
3153                     );
3154                 } else {
3155                     OPERATOR_FILTER_REGISTRY.register(address(this));
3156                 }
3157             }
3158         }
3159     }
3160 
3161     modifier onlyAllowedOperator(address from) virtual {
3162         // Allow spending tokens from addresses with balance
3163         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3164         // from an EOA.
3165         if (from != msg.sender) {
3166             _checkFilterOperator(msg.sender);
3167         }
3168         _;
3169     }
3170 
3171     modifier onlyAllowedOperatorApproval(address operator) virtual {
3172         _checkFilterOperator(operator);
3173         _;
3174     }
3175 
3176     function _checkFilterOperator(address operator) internal view virtual {
3177         // Check registry code length to facilitate testing in environments without a deployed registry.
3178         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3179             if (
3180                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3181                     address(this),
3182                     operator
3183                 )
3184             ) {
3185                 revert OperatorNotAllowed(operator);
3186             }
3187         }
3188     }
3189 }
3190 
3191 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.3.1
3192 
3193 
3194 pragma solidity ^0.8.13;
3195 
3196 /**
3197  * @title  DefaultOperatorFilterer
3198  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3199  */
3200 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3201     address constant DEFAULT_SUBSCRIPTION =
3202         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3203 
3204     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3205 }
3206 
3207 // File contracts/LDPCWildside.sol
3208 
3209 
3210 pragma solidity ^0.8.17;
3211 
3212 /**
3213  * @title LDPC Wildside
3214  * @custom:website https://lionsdenpoker.io/
3215  * @author https://twitter.com/lionsdenpoker
3216  * @notice The Lions Den Poker Club is more than just an NFT project – it’s a community of like-minded individuals who share a passion for poker and the opportunities that the blockchain provides.
3217  */
3218 contract LDPCWildside is
3219     DefaultOperatorFilterer,
3220     ERC2981,
3221     ERC721AQueryable,
3222     ERC721ABurnable,
3223     Ownable,
3224     ReentrancyGuard
3225 {
3226     using Strings for uint256;
3227 
3228     struct MintState {
3229         bool isPublicOpen;
3230         uint256 liveAt;
3231         uint256 expiresAt;
3232         uint256 maxSupply;
3233         uint256 totalSupply;
3234         uint256 price;
3235         uint256 minted;
3236     }
3237 
3238     /// @dev Treasury
3239     address public treasury =
3240         payable(0x021b8329B4A2a659a1Ff78aB8A8Ed5e975320fdC);
3241 
3242     // @dev Base uri for the nft
3243     string private baseURI = "ipfs://cid/";
3244 
3245     // @dev Hidden uri for the nft
3246     string private hiddenURI =
3247         "ipfs://bafybeicmao57ukowuazilgwnri6tpom5ai3jzxic6fpvcpboilmk65z66y/";
3248 
3249     /// @dev The total supply of the collection (n-1)
3250     uint256 public maxSupply = 2501;
3251 
3252     /// @dev The max per wallet (n-1)
3253     uint256 public maxPerWallet = 20;
3254 
3255     /// @dev The max per tx (n-1)
3256     uint256 public maxPerTransaction = 6;
3257 
3258     /// @notice ETH mint price
3259     uint256 public price = 0.075 ether;
3260 
3261     /// @notice Live timestamp
3262     uint256 public liveAt = 1678035600;
3263 
3264     /// @notice Expires timestamp
3265     uint256 public expiresAt = 1680710400;
3266 
3267     /// @notice Mint Pass contract
3268     ILDPCLionade public lionadeContract;
3269 
3270     uint256 private LIONADE_ID = 1;
3271 
3272     /// @notice Public mint
3273     bool public isPublicOpen = true;
3274 
3275     /// @notice Is Revealed
3276     bool public isRevealed = false;
3277 
3278     /// @notice An address mapping mints
3279     mapping(address => uint256) public addressToMinted;
3280 
3281     constructor(
3282         address _lionadeContract,
3283         address[] memory _addresses,
3284         uint256[] memory _amounts
3285     ) ERC721A("LDPCWildside", "LDPCWS") {
3286         _setDefaultRoyalty(treasury, 1000);
3287         lionadeContract = ILDPCLionade(_lionadeContract);
3288         // Airdrop OGs
3289         for (uint256 i = 0; i < _addresses.length; i++) {
3290             _mintERC2309(_addresses[i], _amounts[i]);
3291         }
3292     }
3293 
3294     function _startTokenId() internal view virtual override returns (uint256) {
3295         return 1;
3296     }
3297 
3298     /**
3299      * @notice Sets the hidden URI of the NFT
3300      * @param _hiddenURI A base uri
3301      */
3302     function setHiddenURI(string calldata _hiddenURI) external onlyOwner {
3303         hiddenURI = _hiddenURI;
3304     }
3305 
3306     /**
3307      * @notice Sets the base URI of the NFT
3308      * @param _baseURI A base uri
3309      */
3310     function setBaseURI(string calldata _baseURI) external onlyOwner {
3311         baseURI = _baseURI;
3312     }
3313 
3314     modifier withinThreshold(uint256 _amount) {
3315         require(_amount < maxPerTransaction, "Max per transaction reached.");
3316         require(totalSupply() + _amount < maxSupply, "Max mint reached.");
3317         require(
3318             addressToMinted[_msgSenderERC721A()] + _amount < maxPerWallet,
3319             "Already minted max."
3320         );
3321         _;
3322     }
3323 
3324     modifier canMintPublic() {
3325         require(isLive() && isPublicOpen, "Public mint is not active.");
3326         _;
3327     }
3328 
3329     modifier isCorrectPrice(uint256 _amount, uint256 _price) {
3330         require(msg.value >= _amount * _price, "Not enough funds.");
3331         _;
3332     }
3333 
3334     /**************************************************************************
3335      * Minting
3336      *************************************************************************/
3337 
3338     /**
3339      * @dev Airdrop lionades
3340      * @param _addresses The addresses to mint
3341      * @param _amounts The amounts to mint
3342      */
3343     function airdropOG(
3344         address[] memory _addresses,
3345         uint256[] memory _amounts
3346     ) external onlyOwner {
3347         for (uint256 i = 0; i < _addresses.length; i++) {
3348             lionadeContract.mintItemToAddress(
3349                 _addresses[i],
3350                 LIONADE_ID,
3351                 _amounts[i]
3352             );
3353         }
3354     }
3355 
3356     /**
3357      * @dev Public mint function
3358      * @param _amount The amount to mint
3359      */
3360     function mint(
3361         uint256 _amount
3362     )
3363         external
3364         payable
3365         canMintPublic
3366         isCorrectPrice(_amount, price)
3367         withinThreshold(_amount)
3368     {
3369         address sender = _msgSenderERC721A();
3370         addressToMinted[sender] += _amount;
3371         _mint(sender, _amount);
3372         lionadeContract.mintItemToAddress(sender, LIONADE_ID, _amount);
3373     }
3374 
3375     /// @dev Check if mint is live
3376     function isLive() public view returns (bool) {
3377         return block.timestamp >= liveAt && block.timestamp <= expiresAt;
3378     }
3379 
3380     /**
3381      * @notice Returns current mint state for a particular address
3382      * @param _address The address
3383      */
3384     function getMintState(
3385         address _address
3386     ) external view returns (MintState memory) {
3387         return
3388             MintState({
3389                 isPublicOpen: isPublicOpen,
3390                 liveAt: liveAt,
3391                 expiresAt: expiresAt,
3392                 maxSupply: maxSupply,
3393                 totalSupply: totalSupply(),
3394                 price: price,
3395                 minted: addressToMinted[_address]
3396             });
3397     }
3398 
3399     /**
3400      * @notice Returns the URI for a given token id
3401      * @param _tokenId A tokenId
3402      */
3403     function tokenURI(
3404         uint256 _tokenId
3405     ) public view override(IERC721A, ERC721A) returns (string memory) {
3406         if (!_exists(_tokenId)) revert OwnerQueryForNonexistentToken();
3407         if (!isRevealed)
3408             return string(abi.encodePacked(hiddenURI, "prereveal.json"));
3409         return
3410             string(
3411                 abi.encodePacked(baseURI, Strings.toString(_tokenId), ".json")
3412             );
3413     }
3414 
3415     /**************************************************************************
3416      * Admin
3417      *************************************************************************/
3418 
3419     /**
3420      * @notice Sets the reveal state
3421      * @param _isRevealed The reveal state
3422      */
3423     function setIsRevealed(bool _isRevealed) external onlyOwner {
3424         isRevealed = _isRevealed;
3425     }
3426 
3427     /**
3428      * @notice Sets the collection max supply
3429      * @param _maxSupply The max supply of the collection
3430      */
3431     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
3432         maxSupply = _maxSupply;
3433     }
3434 
3435     /**
3436      * @notice Sets the collection max per transaction
3437      * @param _maxPerTransaction The max per transaction
3438      */
3439     function setMaxPerTransaction(
3440         uint256 _maxPerTransaction
3441     ) external onlyOwner {
3442         maxPerTransaction = _maxPerTransaction;
3443     }
3444 
3445     /**
3446      * @notice Sets the collection max per wallet
3447      * @param _maxPerWallet The max per wallet
3448      */
3449     function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
3450         maxPerWallet = _maxPerWallet;
3451     }
3452 
3453     /**
3454      * @notice Sets eth price
3455      * @param _price The price in wei
3456      */
3457     function setPrice(uint256 _price) external onlyOwner {
3458         price = _price;
3459     }
3460 
3461     /**
3462      * @notice Sets the treasury recipient
3463      * @param _treasury The treasury address
3464      */
3465     function setTreasury(address _treasury) public onlyOwner {
3466         treasury = payable(_treasury);
3467     }
3468 
3469     /**
3470      * @notice Sets the lionade contract
3471      * @param _lionadeContract The contract address
3472      */
3473     function setLionadeContracts(address _lionadeContract) public onlyOwner {
3474         lionadeContract = ILDPCLionade(_lionadeContract);
3475     }
3476 
3477     /**
3478      * @notice Sets the mint states
3479      * @param _isPublicMintOpen The public mint is open
3480      */
3481     function setMintStates(bool _isPublicMintOpen) external onlyOwner {
3482         isPublicOpen = _isPublicMintOpen;
3483     }
3484 
3485     /**
3486      * @notice Sets timestamps for live and expires timeframe
3487      * @param _liveAt A unix timestamp for live date
3488      * @param _expiresAt A unix timestamp for expiration date
3489      */
3490     function setMintWindow(
3491         uint256 _liveAt,
3492         uint256 _expiresAt
3493     ) external onlyOwner {
3494         liveAt = _liveAt;
3495         expiresAt = _expiresAt;
3496     }
3497 
3498     /**
3499      * @notice Changes the contract defined royalty
3500      * @param _receiver - The receiver of royalties
3501      * @param _feeNumerator - The numerator that represents a percent out of 10,000
3502      */
3503     function setDefaultRoyalty(
3504         address _receiver,
3505         uint96 _feeNumerator
3506     ) public onlyOwner {
3507         _setDefaultRoyalty(_receiver, _feeNumerator);
3508     }
3509 
3510     /// @notice Withdraws funds from contract
3511     function withdraw() public onlyOwner {
3512         uint256 balance = address(this).balance;
3513         (bool success, ) = treasury.call{value: balance}("");
3514         require(success, "Unable to withdraw ETH");
3515     }
3516 
3517     /**
3518      * @dev Airdrop function
3519      * @param _to The address to mint to
3520      * @param _amount The amount to mint
3521      */
3522     function airdrop(address _to, uint256 _amount) external onlyOwner {
3523         require(totalSupply() + _amount < maxSupply, "Max mint reached.");
3524         _mint(_to, _amount);
3525     }
3526 
3527     /**************************************************************************
3528      * Royalties
3529      *************************************************************************/
3530 
3531     function supportsInterface(
3532         bytes4 interfaceId
3533     ) public view virtual override(IERC721A, ERC721A, ERC2981) returns (bool) {
3534         return
3535             ERC721A.supportsInterface(interfaceId) ||
3536             ERC2981.supportsInterface(interfaceId);
3537     }
3538 
3539     function setApprovalForAll(
3540         address operator,
3541         bool approved
3542     ) public override(IERC721A, ERC721A) onlyAllowedOperatorApproval(operator) {
3543         super.setApprovalForAll(operator, approved);
3544     }
3545 
3546     function approve(
3547         address operator,
3548         uint256 tokenId
3549     )
3550         public
3551         payable
3552         override(IERC721A, ERC721A)
3553         onlyAllowedOperatorApproval(operator)
3554     {
3555         super.approve(operator, tokenId);
3556     }
3557 
3558     function transferFrom(
3559         address from,
3560         address to,
3561         uint256 tokenId
3562     ) public payable override(IERC721A, ERC721A) onlyAllowedOperator(from) {
3563         super.transferFrom(from, to, tokenId);
3564     }
3565 
3566     function safeTransferFrom(
3567         address from,
3568         address to,
3569         uint256 tokenId
3570     ) public payable override(IERC721A, ERC721A) onlyAllowedOperator(from) {
3571         super.safeTransferFrom(from, to, tokenId);
3572     }
3573 
3574     function safeTransferFrom(
3575         address from,
3576         address to,
3577         uint256 tokenId,
3578         bytes memory data
3579     ) public payable override(IERC721A, ERC721A) onlyAllowedOperator(from) {
3580         super.safeTransferFrom(from, to, tokenId, data);
3581     }
3582 }