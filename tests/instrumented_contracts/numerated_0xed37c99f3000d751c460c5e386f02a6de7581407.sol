1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/introspection/IERC165.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Interface of the ERC165 standard, as defined in the
81  * https://eips.ethereum.org/EIPS/eip-165[EIP].
82  *
83  * Implementers can declare support of contract interfaces, which can then be
84  * queried by others ({ERC165Checker}).
85  *
86  * For an implementation, see {ERC165}.
87  */
88 interface IERC165 {
89     /**
90      * @dev Returns true if this contract implements the interface defined by
91      * `interfaceId`. See the corresponding
92      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
93      * to learn more about how these ids are created.
94      *
95      * This function call must use less than 30 000 gas.
96      */
97     function supportsInterface(bytes4 interfaceId) external view returns (bool);
98 }
99 
100 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC721/IERC721.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Required interface of an ERC721 compliant contract.
110  */
111 interface IERC721 is IERC165 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
143      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) external;
160 
161     /**
162      * @dev Transfers `tokenId` token from `from` to `to`.
163      *
164      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
183      * The approval is cleared when the token is transferred.
184      *
185      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
186      *
187      * Requirements:
188      *
189      * - The caller must own the token or be an approved operator.
190      * - `tokenId` must exist.
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address to, uint256 tokenId) external;
195 
196     /**
197      * @dev Returns the account approved for `tokenId` token.
198      *
199      * Requirements:
200      *
201      * - `tokenId` must exist.
202      */
203     function getApproved(uint256 tokenId) external view returns (address operator);
204 
205     /**
206      * @dev Approve or remove `operator` as an operator for the caller.
207      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
208      *
209      * Requirements:
210      *
211      * - The `operator` cannot be the caller.
212      *
213      * Emits an {ApprovalForAll} event.
214      */
215     function setApprovalForAll(address operator, bool _approved) external;
216 
217     /**
218      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
219      *
220      * See {setApprovalForAll}
221      */
222     function isApprovedForAll(address owner, address operator) external view returns (bool);
223 
224     /**
225      * @dev Safely transfers `tokenId` token from `from` to `to`.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId,
241         bytes calldata data
242     ) external;
243 }
244 
245 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/security/ReentrancyGuard.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Contract module that helps prevent reentrant calls to a function.
254  *
255  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
256  * available, which can be applied to functions to make sure there are no nested
257  * (reentrant) calls to them.
258  *
259  * Note that because there is a single `nonReentrant` guard, functions marked as
260  * `nonReentrant` may not call one another. This can be worked around by making
261  * those functions `private`, and then adding `external` `nonReentrant` entry
262  * points to them.
263  *
264  * TIP: If you would like to learn more about reentrancy and alternative ways
265  * to protect against it, check out our blog post
266  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
267  */
268 abstract contract ReentrancyGuard {
269     // Booleans are more expensive than uint256 or any type that takes up a full
270     // word because each write operation emits an extra SLOAD to first read the
271     // slot's contents, replace the bits taken up by the boolean, and then write
272     // back. This is the compiler's defense against contract upgrades and
273     // pointer aliasing, and it cannot be disabled.
274 
275     // The values being non-zero value makes deployment a bit more expensive,
276     // but in exchange the refund on every call to nonReentrant will be lower in
277     // amount. Since refunds are capped to a percentage of the total
278     // transaction's gas, it is best to keep them low in cases like this one, to
279     // increase the likelihood of the full refund coming into effect.
280     uint256 private constant _NOT_ENTERED = 1;
281     uint256 private constant _ENTERED = 2;
282 
283     uint256 private _status;
284 
285     constructor() {
286         _status = _NOT_ENTERED;
287     }
288 
289     /**
290      * @dev Prevents a contract from calling itself, directly or indirectly.
291      * Calling a `nonReentrant` function from another `nonReentrant`
292      * function is not supported. It is possible to prevent this from happening
293      * by making the `nonReentrant` function external, and making it call a
294      * `private` function that does the actual work.
295      */
296     modifier nonReentrant() {
297         // On the first call to nonReentrant, _notEntered will be true
298         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
299 
300         // Any calls to nonReentrant after this point will fail
301         _status = _ENTERED;
302 
303         _;
304 
305         // By storing the original value once again, a refund is triggered (see
306         // https://eips.ethereum.org/EIPS/eip-2200)
307         _status = _NOT_ENTERED;
308     }
309 }
310 
311 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/utils/Context.sol
312 
313 
314 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Provides information about the current execution context, including the
320  * sender of the transaction and its data. While these are generally available
321  * via msg.sender and msg.data, they should not be accessed in such a direct
322  * manner, since when dealing with meta-transactions the account sending and
323  * paying for execution may not be the actual sender (as far as an application
324  * is concerned).
325  *
326  * This contract is only required for intermediate, library-like contracts.
327  */
328 abstract contract Context {
329     function _msgSender() internal view virtual returns (address) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes calldata) {
334         return msg.data;
335     }
336 }
337 
338 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Contract module which provides a basic access control mechanism, where
348  * there is an account (an owner) that can be granted exclusive access to
349  * specific functions.
350  *
351  * By default, the owner account will be the one that deploys the contract. This
352  * can later be changed with {transferOwnership}.
353  *
354  * This module is used through inheritance. It will make available the modifier
355  * `onlyOwner`, which can be applied to your functions to restrict their use to
356  * the owner.
357  */
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     /**
364      * @dev Initializes the contract setting the deployer as the initial owner.
365      */
366     constructor() {
367         _transferOwnership(_msgSender());
368     }
369 
370     /**
371      * @dev Returns the address of the current owner.
372      */
373     function owner() public view virtual returns (address) {
374         return _owner;
375     }
376 
377     /**
378      * @dev Throws if called by any account other than the owner.
379      */
380     modifier onlyOwner() {
381         require(owner() == _msgSender(), "Ownable: caller is not the owner");
382         _;
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _transferOwnership(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _transferOwnership(newOwner);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Internal function without access restriction.
408      */
409     function _transferOwnership(address newOwner) internal virtual {
410         address oldOwner = _owner;
411         _owner = newOwner;
412         emit OwnershipTransferred(oldOwner, newOwner);
413     }
414 }
415 
416 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
417 
418 
419 // ERC721A Contracts v4.2.3
420 // Creator: Chiru Labs
421 
422 pragma solidity ^0.8.4;
423 
424 /**
425  * @dev Interface of ERC721A.
426  */
427 interface IERC721A {
428     /**
429      * The caller must own the token or be an approved operator.
430      */
431     error ApprovalCallerNotOwnerNorApproved();
432 
433     /**
434      * The token does not exist.
435      */
436     error ApprovalQueryForNonexistentToken();
437 
438     /**
439      * Cannot query the balance for the zero address.
440      */
441     error BalanceQueryForZeroAddress();
442 
443     /**
444      * Cannot mint to the zero address.
445      */
446     error MintToZeroAddress();
447 
448     /**
449      * The quantity of tokens minted must be more than zero.
450      */
451     error MintZeroQuantity();
452 
453     /**
454      * The token does not exist.
455      */
456     error OwnerQueryForNonexistentToken();
457 
458     /**
459      * The caller must own the token or be an approved operator.
460      */
461     error TransferCallerNotOwnerNorApproved();
462 
463     /**
464      * The token must be owned by `from`.
465      */
466     error TransferFromIncorrectOwner();
467 
468     /**
469      * Cannot safely transfer to a contract that does not implement the
470      * ERC721Receiver interface.
471      */
472     error TransferToNonERC721ReceiverImplementer();
473 
474     /**
475      * Cannot transfer to the zero address.
476      */
477     error TransferToZeroAddress();
478 
479     /**
480      * The token does not exist.
481      */
482     error URIQueryForNonexistentToken();
483 
484     /**
485      * The `quantity` minted with ERC2309 exceeds the safety limit.
486      */
487     error MintERC2309QuantityExceedsLimit();
488 
489     /**
490      * The `extraData` cannot be set on an unintialized ownership slot.
491      */
492     error OwnershipNotInitializedForExtraData();
493 
494     // =============================================================
495     //                            STRUCTS
496     // =============================================================
497 
498     struct TokenOwnership {
499         // The address of the owner.
500         address addr;
501         // Stores the start time of ownership with minimal overhead for tokenomics.
502         uint64 startTimestamp;
503         // Whether the token has been burned.
504         bool burned;
505         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
506         uint24 extraData;
507     }
508 
509     // =============================================================
510     //                         TOKEN COUNTERS
511     // =============================================================
512 
513     /**
514      * @dev Returns the total number of tokens in existence.
515      * Burned tokens will reduce the count.
516      * To get the total number of tokens minted, please see {_totalMinted}.
517      */
518     function totalSupply() external view returns (uint256);
519 
520     // =============================================================
521     //                            IERC165
522     // =============================================================
523 
524     /**
525      * @dev Returns true if this contract implements the interface defined by
526      * `interfaceId`. See the corresponding
527      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
528      * to learn more about how these ids are created.
529      *
530      * This function call must use less than 30000 gas.
531      */
532     function supportsInterface(bytes4 interfaceId) external view returns (bool);
533 
534     // =============================================================
535     //                            IERC721
536     // =============================================================
537 
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
542 
543     /**
544      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
545      */
546     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
547 
548     /**
549      * @dev Emitted when `owner` enables or disables
550      * (`approved`) `operator` to manage all of its assets.
551      */
552     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
553 
554     /**
555      * @dev Returns the number of tokens in `owner`'s account.
556      */
557     function balanceOf(address owner) external view returns (uint256 balance);
558 
559     /**
560      * @dev Returns the owner of the `tokenId` token.
561      *
562      * Requirements:
563      *
564      * - `tokenId` must exist.
565      */
566     function ownerOf(uint256 tokenId) external view returns (address owner);
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`,
570      * checking first that contract recipients are aware of the ERC721 protocol
571      * to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be have been allowed to move
579      * this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement
581      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external payable;
591 
592     /**
593      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external payable;
600 
601     /**
602      * @dev Transfers `tokenId` from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
605      * whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token
613      * by either {approve} or {setApprovalForAll}.
614      *
615      * Emits a {Transfer} event.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external payable;
622 
623     /**
624      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
625      * The approval is cleared when the token is transferred.
626      *
627      * Only a single account can be approved at a time, so approving the
628      * zero address clears previous approvals.
629      *
630      * Requirements:
631      *
632      * - The caller must own the token or be an approved operator.
633      * - `tokenId` must exist.
634      *
635      * Emits an {Approval} event.
636      */
637     function approve(address to, uint256 tokenId) external payable;
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom}
642      * for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}.
665      */
666     function isApprovedForAll(address owner, address operator) external view returns (bool);
667 
668     // =============================================================
669     //                        IERC721Metadata
670     // =============================================================
671 
672     /**
673      * @dev Returns the token collection name.
674      */
675     function name() external view returns (string memory);
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() external view returns (string memory);
681 
682     /**
683      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
684      */
685     function tokenURI(uint256 tokenId) external view returns (string memory);
686 
687     // =============================================================
688     //                           IERC2309
689     // =============================================================
690 
691     /**
692      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
693      * (inclusive) is transferred from `from` to `to`, as defined in the
694      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
695      *
696      * See {_mintERC2309} for more details.
697      */
698     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
699 }
700 
701 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
702 
703 
704 // ERC721A Contracts v4.2.3
705 // Creator: Chiru Labs
706 
707 pragma solidity ^0.8.4;
708 
709 
710 /**
711  * @dev Interface of ERC721 token receiver.
712  */
713 interface ERC721A__IERC721Receiver {
714     function onERC721Received(
715         address operator,
716         address from,
717         uint256 tokenId,
718         bytes calldata data
719     ) external returns (bytes4);
720 }
721 
722 /**
723  * @title ERC721A
724  *
725  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
726  * Non-Fungible Token Standard, including the Metadata extension.
727  * Optimized for lower gas during batch mints.
728  *
729  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
730  * starting from `_startTokenId()`.
731  *
732  * Assumptions:
733  *
734  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
735  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
736  */
737 contract ERC721A is IERC721A {
738     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
739     struct TokenApprovalRef {
740         address value;
741     }
742 
743     // =============================================================
744     //                           CONSTANTS
745     // =============================================================
746 
747     // Mask of an entry in packed address data.
748     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
749 
750     // The bit position of `numberMinted` in packed address data.
751     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
752 
753     // The bit position of `numberBurned` in packed address data.
754     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
755 
756     // The bit position of `aux` in packed address data.
757     uint256 private constant _BITPOS_AUX = 192;
758 
759     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
760     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
761 
762     // The bit position of `startTimestamp` in packed ownership.
763     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
764 
765     // The bit mask of the `burned` bit in packed ownership.
766     uint256 private constant _BITMASK_BURNED = 1 << 224;
767 
768     // The bit position of the `nextInitialized` bit in packed ownership.
769     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
770 
771     // The bit mask of the `nextInitialized` bit in packed ownership.
772     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
773 
774     // The bit position of `extraData` in packed ownership.
775     uint256 private constant _BITPOS_EXTRA_DATA = 232;
776 
777     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
778     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
779 
780     // The mask of the lower 160 bits for addresses.
781     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
782 
783     // The maximum `quantity` that can be minted with {_mintERC2309}.
784     // This limit is to prevent overflows on the address data entries.
785     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
786     // is required to cause an overflow, which is unrealistic.
787     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
788 
789     // The `Transfer` event signature is given by:
790     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
791     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
792         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
793 
794     // =============================================================
795     //                            STORAGE
796     // =============================================================
797 
798     // The next token ID to be minted.
799     uint256 private _currentIndex;
800 
801     // The number of tokens burned.
802     uint256 private _burnCounter;
803 
804     // Token name
805     string private _name;
806 
807     // Token symbol
808     string private _symbol;
809 
810     // Mapping from token ID to ownership details
811     // An empty struct value does not necessarily mean the token is unowned.
812     // See {_packedOwnershipOf} implementation for details.
813     //
814     // Bits Layout:
815     // - [0..159]   `addr`
816     // - [160..223] `startTimestamp`
817     // - [224]      `burned`
818     // - [225]      `nextInitialized`
819     // - [232..255] `extraData`
820     mapping(uint256 => uint256) private _packedOwnerships;
821 
822     // Mapping owner address to address data.
823     //
824     // Bits Layout:
825     // - [0..63]    `balance`
826     // - [64..127]  `numberMinted`
827     // - [128..191] `numberBurned`
828     // - [192..255] `aux`
829     mapping(address => uint256) private _packedAddressData;
830 
831     // Mapping from token ID to approved address.
832     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
833 
834     // Mapping from owner to operator approvals
835     mapping(address => mapping(address => bool)) private _operatorApprovals;
836 
837     // =============================================================
838     //                          CONSTRUCTOR
839     // =============================================================
840 
841     constructor(string memory name_, string memory symbol_) {
842         _name = name_;
843         _symbol = symbol_;
844         _currentIndex = _startTokenId();
845     }
846 
847     // =============================================================
848     //                   TOKEN COUNTING OPERATIONS
849     // =============================================================
850 
851     /**
852      * @dev Returns the starting token ID.
853      * To change the starting token ID, please override this function.
854      */
855     function _startTokenId() internal view virtual returns (uint256) {
856         return 0;
857     }
858 
859     /**
860      * @dev Returns the next token ID to be minted.
861      */
862     function _nextTokenId() internal view virtual returns (uint256) {
863         return _currentIndex;
864     }
865 
866     /**
867      * @dev Returns the total number of tokens in existence.
868      * Burned tokens will reduce the count.
869      * To get the total number of tokens minted, please see {_totalMinted}.
870      */
871     function totalSupply() public view virtual override returns (uint256) {
872         // Counter underflow is impossible as _burnCounter cannot be incremented
873         // more than `_currentIndex - _startTokenId()` times.
874         unchecked {
875             return _currentIndex - _burnCounter - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev Returns the total amount of tokens minted in the contract.
881      */
882     function _totalMinted() internal view virtual returns (uint256) {
883         // Counter underflow is impossible as `_currentIndex` does not decrement,
884         // and it is initialized to `_startTokenId()`.
885         unchecked {
886             return _currentIndex - _startTokenId();
887         }
888     }
889 
890     /**
891      * @dev Returns the total number of tokens burned.
892      */
893     function _totalBurned() internal view virtual returns (uint256) {
894         return _burnCounter;
895     }
896 
897     // =============================================================
898     //                    ADDRESS DATA OPERATIONS
899     // =============================================================
900 
901     /**
902      * @dev Returns the number of tokens in `owner`'s account.
903      */
904     function balanceOf(address owner) public view virtual override returns (uint256) {
905         if (owner == address(0)) revert BalanceQueryForZeroAddress();
906         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
907     }
908 
909     /**
910      * Returns the number of tokens minted by `owner`.
911      */
912     function _numberMinted(address owner) internal view returns (uint256) {
913         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
914     }
915 
916     /**
917      * Returns the number of tokens burned by or on behalf of `owner`.
918      */
919     function _numberBurned(address owner) internal view returns (uint256) {
920         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
921     }
922 
923     /**
924      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
925      */
926     function _getAux(address owner) internal view returns (uint64) {
927         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
928     }
929 
930     /**
931      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
932      * If there are multiple variables, please pack them into a uint64.
933      */
934     function _setAux(address owner, uint64 aux) internal virtual {
935         uint256 packed = _packedAddressData[owner];
936         uint256 auxCasted;
937         // Cast `aux` with assembly to avoid redundant masking.
938         assembly {
939             auxCasted := aux
940         }
941         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
942         _packedAddressData[owner] = packed;
943     }
944 
945     // =============================================================
946     //                            IERC165
947     // =============================================================
948 
949     /**
950      * @dev Returns true if this contract implements the interface defined by
951      * `interfaceId`. See the corresponding
952      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
953      * to learn more about how these ids are created.
954      *
955      * This function call must use less than 30000 gas.
956      */
957     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
958         // The interface IDs are constants representing the first 4 bytes
959         // of the XOR of all function selectors in the interface.
960         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
961         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
962         return
963             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
964             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
965             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
966     }
967 
968     // =============================================================
969     //                        IERC721Metadata
970     // =============================================================
971 
972     /**
973      * @dev Returns the token collection name.
974      */
975     function name() public view virtual override returns (string memory) {
976         return _name;
977     }
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() public view virtual override returns (string memory) {
983         return _symbol;
984     }
985 
986     /**
987      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
988      */
989     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
990         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
991 
992         string memory baseURI = _baseURI();
993         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
994     }
995 
996     /**
997      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
998      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
999      * by default, it can be overridden in child contracts.
1000      */
1001     function _baseURI() internal view virtual returns (string memory) {
1002         return '';
1003     }
1004 
1005     // =============================================================
1006     //                     OWNERSHIPS OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1017         return address(uint160(_packedOwnershipOf(tokenId)));
1018     }
1019 
1020     /**
1021      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1022      * It gradually moves to O(1) as tokens get transferred around over time.
1023      */
1024     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1025         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1026     }
1027 
1028     /**
1029      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1030      */
1031     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1032         return _unpackedOwnership(_packedOwnerships[index]);
1033     }
1034 
1035     /**
1036      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1037      */
1038     function _initializeOwnershipAt(uint256 index) internal virtual {
1039         if (_packedOwnerships[index] == 0) {
1040             _packedOwnerships[index] = _packedOwnershipOf(index);
1041         }
1042     }
1043 
1044     /**
1045      * Returns the packed ownership data of `tokenId`.
1046      */
1047     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1048         uint256 curr = tokenId;
1049 
1050         unchecked {
1051             if (_startTokenId() <= curr)
1052                 if (curr < _currentIndex) {
1053                     uint256 packed = _packedOwnerships[curr];
1054                     // If not burned.
1055                     if (packed & _BITMASK_BURNED == 0) {
1056                         // Invariant:
1057                         // There will always be an initialized ownership slot
1058                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1059                         // before an unintialized ownership slot
1060                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1061                         // Hence, `curr` will not underflow.
1062                         //
1063                         // We can directly compare the packed value.
1064                         // If the address is zero, packed will be zero.
1065                         while (packed == 0) {
1066                             packed = _packedOwnerships[--curr];
1067                         }
1068                         return packed;
1069                     }
1070                 }
1071         }
1072         revert OwnerQueryForNonexistentToken();
1073     }
1074 
1075     /**
1076      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1077      */
1078     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1079         ownership.addr = address(uint160(packed));
1080         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1081         ownership.burned = packed & _BITMASK_BURNED != 0;
1082         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1083     }
1084 
1085     /**
1086      * @dev Packs ownership data into a single uint256.
1087      */
1088     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1089         assembly {
1090             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1091             owner := and(owner, _BITMASK_ADDRESS)
1092             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1093             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1099      */
1100     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1101         // For branchless setting of the `nextInitialized` flag.
1102         assembly {
1103             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1104             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1105         }
1106     }
1107 
1108     // =============================================================
1109     //                      APPROVAL OPERATIONS
1110     // =============================================================
1111 
1112     /**
1113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1114      * The approval is cleared when the token is transferred.
1115      *
1116      * Only a single account can be approved at a time, so approving the
1117      * zero address clears previous approvals.
1118      *
1119      * Requirements:
1120      *
1121      * - The caller must own the token or be an approved operator.
1122      * - `tokenId` must exist.
1123      *
1124      * Emits an {Approval} event.
1125      */
1126     function approve(address to, uint256 tokenId) public payable virtual override {
1127         address owner = ownerOf(tokenId);
1128 
1129         if (_msgSenderERC721A() != owner)
1130             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1131                 revert ApprovalCallerNotOwnerNorApproved();
1132             }
1133 
1134         _tokenApprovals[tokenId].value = to;
1135         emit Approval(owner, to, tokenId);
1136     }
1137 
1138     /**
1139      * @dev Returns the account approved for `tokenId` token.
1140      *
1141      * Requirements:
1142      *
1143      * - `tokenId` must exist.
1144      */
1145     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1146         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1147 
1148         return _tokenApprovals[tokenId].value;
1149     }
1150 
1151     /**
1152      * @dev Approve or remove `operator` as an operator for the caller.
1153      * Operators can call {transferFrom} or {safeTransferFrom}
1154      * for any token owned by the caller.
1155      *
1156      * Requirements:
1157      *
1158      * - The `operator` cannot be the caller.
1159      *
1160      * Emits an {ApprovalForAll} event.
1161      */
1162     function setApprovalForAll(address operator, bool approved) public virtual override {
1163         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1164         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1165     }
1166 
1167     /**
1168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1169      *
1170      * See {setApprovalForAll}.
1171      */
1172     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1173         return _operatorApprovals[owner][operator];
1174     }
1175 
1176     /**
1177      * @dev Returns whether `tokenId` exists.
1178      *
1179      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1180      *
1181      * Tokens start existing when they are minted. See {_mint}.
1182      */
1183     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1184         return
1185             _startTokenId() <= tokenId &&
1186             tokenId < _currentIndex && // If within bounds,
1187             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1188     }
1189 
1190     /**
1191      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1192      */
1193     function _isSenderApprovedOrOwner(
1194         address approvedAddress,
1195         address owner,
1196         address msgSender
1197     ) private pure returns (bool result) {
1198         assembly {
1199             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1200             owner := and(owner, _BITMASK_ADDRESS)
1201             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1202             msgSender := and(msgSender, _BITMASK_ADDRESS)
1203             // `msgSender == owner || msgSender == approvedAddress`.
1204             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1205         }
1206     }
1207 
1208     /**
1209      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1210      */
1211     function _getApprovedSlotAndAddress(uint256 tokenId)
1212         private
1213         view
1214         returns (uint256 approvedAddressSlot, address approvedAddress)
1215     {
1216         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1217         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1218         assembly {
1219             approvedAddressSlot := tokenApproval.slot
1220             approvedAddress := sload(approvedAddressSlot)
1221         }
1222     }
1223 
1224     // =============================================================
1225     //                      TRANSFER OPERATIONS
1226     // =============================================================
1227 
1228     /**
1229      * @dev Transfers `tokenId` from `from` to `to`.
1230      *
1231      * Requirements:
1232      *
1233      * - `from` cannot be the zero address.
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must be owned by `from`.
1236      * - If the caller is not `from`, it must be approved to move this token
1237      * by either {approve} or {setApprovalForAll}.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function transferFrom(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) public payable virtual override {
1246         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1247 
1248         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1249 
1250         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1251 
1252         // The nested ifs save around 20+ gas over a compound boolean condition.
1253         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1254             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1255 
1256         if (to == address(0)) revert TransferToZeroAddress();
1257 
1258         _beforeTokenTransfers(from, to, tokenId, 1);
1259 
1260         // Clear approvals from the previous owner.
1261         assembly {
1262             if approvedAddress {
1263                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1264                 sstore(approvedAddressSlot, 0)
1265             }
1266         }
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1271         unchecked {
1272             // We can directly increment and decrement the balances.
1273             --_packedAddressData[from]; // Updates: `balance -= 1`.
1274             ++_packedAddressData[to]; // Updates: `balance += 1`.
1275 
1276             // Updates:
1277             // - `address` to the next owner.
1278             // - `startTimestamp` to the timestamp of transfering.
1279             // - `burned` to `false`.
1280             // - `nextInitialized` to `true`.
1281             _packedOwnerships[tokenId] = _packOwnershipData(
1282                 to,
1283                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1284             );
1285 
1286             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1287             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1288                 uint256 nextTokenId = tokenId + 1;
1289                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1290                 if (_packedOwnerships[nextTokenId] == 0) {
1291                     // If the next slot is within bounds.
1292                     if (nextTokenId != _currentIndex) {
1293                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1294                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1295                     }
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, to, tokenId);
1301         _afterTokenTransfers(from, to, tokenId, 1);
1302     }
1303 
1304     /**
1305      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1306      */
1307     function safeTransferFrom(
1308         address from,
1309         address to,
1310         uint256 tokenId
1311     ) public payable virtual override {
1312         safeTransferFrom(from, to, tokenId, '');
1313     }
1314 
1315     /**
1316      * @dev Safely transfers `tokenId` token from `from` to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `from` cannot be the zero address.
1321      * - `to` cannot be the zero address.
1322      * - `tokenId` token must exist and be owned by `from`.
1323      * - If the caller is not `from`, it must be approved to move this token
1324      * by either {approve} or {setApprovalForAll}.
1325      * - If `to` refers to a smart contract, it must implement
1326      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function safeTransferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) public payable virtual override {
1336         transferFrom(from, to, tokenId);
1337         if (to.code.length != 0)
1338             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1339                 revert TransferToNonERC721ReceiverImplementer();
1340             }
1341     }
1342 
1343     /**
1344      * @dev Hook that is called before a set of serially-ordered token IDs
1345      * are about to be transferred. This includes minting.
1346      * And also called before burning one token.
1347      *
1348      * `startTokenId` - the first token ID to be transferred.
1349      * `quantity` - the amount to be transferred.
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, `tokenId` will be burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _beforeTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 
1366     /**
1367      * @dev Hook that is called after a set of serially-ordered token IDs
1368      * have been transferred. This includes minting.
1369      * And also called after one token has been burned.
1370      *
1371      * `startTokenId` - the first token ID to be transferred.
1372      * `quantity` - the amount to be transferred.
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` has been minted for `to`.
1379      * - When `to` is zero, `tokenId` has been burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _afterTokenTransfers(
1383         address from,
1384         address to,
1385         uint256 startTokenId,
1386         uint256 quantity
1387     ) internal virtual {}
1388 
1389     /**
1390      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1391      *
1392      * `from` - Previous owner of the given token ID.
1393      * `to` - Target address that will receive the token.
1394      * `tokenId` - Token ID to be transferred.
1395      * `_data` - Optional data to send along with the call.
1396      *
1397      * Returns whether the call correctly returned the expected magic value.
1398      */
1399     function _checkContractOnERC721Received(
1400         address from,
1401         address to,
1402         uint256 tokenId,
1403         bytes memory _data
1404     ) private returns (bool) {
1405         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1406             bytes4 retval
1407         ) {
1408             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1409         } catch (bytes memory reason) {
1410             if (reason.length == 0) {
1411                 revert TransferToNonERC721ReceiverImplementer();
1412             } else {
1413                 assembly {
1414                     revert(add(32, reason), mload(reason))
1415                 }
1416             }
1417         }
1418     }
1419 
1420     // =============================================================
1421     //                        MINT OPERATIONS
1422     // =============================================================
1423 
1424     /**
1425      * @dev Mints `quantity` tokens and transfers them to `to`.
1426      *
1427      * Requirements:
1428      *
1429      * - `to` cannot be the zero address.
1430      * - `quantity` must be greater than 0.
1431      *
1432      * Emits a {Transfer} event for each mint.
1433      */
1434     function _mint(address to, uint256 quantity) internal virtual {
1435         uint256 startTokenId = _currentIndex;
1436         if (quantity == 0) revert MintZeroQuantity();
1437 
1438         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1439 
1440         // Overflows are incredibly unrealistic.
1441         // `balance` and `numberMinted` have a maximum limit of 2**64.
1442         // `tokenId` has a maximum limit of 2**256.
1443         unchecked {
1444             // Updates:
1445             // - `balance += quantity`.
1446             // - `numberMinted += quantity`.
1447             //
1448             // We can directly add to the `balance` and `numberMinted`.
1449             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1450 
1451             // Updates:
1452             // - `address` to the owner.
1453             // - `startTimestamp` to the timestamp of minting.
1454             // - `burned` to `false`.
1455             // - `nextInitialized` to `quantity == 1`.
1456             _packedOwnerships[startTokenId] = _packOwnershipData(
1457                 to,
1458                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1459             );
1460 
1461             uint256 toMasked;
1462             uint256 end = startTokenId + quantity;
1463 
1464             // Use assembly to loop and emit the `Transfer` event for gas savings.
1465             // The duplicated `log4` removes an extra check and reduces stack juggling.
1466             // The assembly, together with the surrounding Solidity code, have been
1467             // delicately arranged to nudge the compiler into producing optimized opcodes.
1468             assembly {
1469                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1470                 toMasked := and(to, _BITMASK_ADDRESS)
1471                 // Emit the `Transfer` event.
1472                 log4(
1473                     0, // Start of data (0, since no data).
1474                     0, // End of data (0, since no data).
1475                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1476                     0, // `address(0)`.
1477                     toMasked, // `to`.
1478                     startTokenId // `tokenId`.
1479                 )
1480 
1481                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1482                 // that overflows uint256 will make the loop run out of gas.
1483                 // The compiler will optimize the `iszero` away for performance.
1484                 for {
1485                     let tokenId := add(startTokenId, 1)
1486                 } iszero(eq(tokenId, end)) {
1487                     tokenId := add(tokenId, 1)
1488                 } {
1489                     // Emit the `Transfer` event. Similar to above.
1490                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1491                 }
1492             }
1493             if (toMasked == 0) revert MintToZeroAddress();
1494 
1495             _currentIndex = end;
1496         }
1497         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1498     }
1499 
1500     /**
1501      * @dev Mints `quantity` tokens and transfers them to `to`.
1502      *
1503      * This function is intended for efficient minting only during contract creation.
1504      *
1505      * It emits only one {ConsecutiveTransfer} as defined in
1506      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1507      * instead of a sequence of {Transfer} event(s).
1508      *
1509      * Calling this function outside of contract creation WILL make your contract
1510      * non-compliant with the ERC721 standard.
1511      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1512      * {ConsecutiveTransfer} event is only permissible during contract creation.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      * - `quantity` must be greater than 0.
1518      *
1519      * Emits a {ConsecutiveTransfer} event.
1520      */
1521     function _mintERC2309(address to, uint256 quantity) internal virtual {
1522         uint256 startTokenId = _currentIndex;
1523         if (to == address(0)) revert MintToZeroAddress();
1524         if (quantity == 0) revert MintZeroQuantity();
1525         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1526 
1527         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1528 
1529         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1530         unchecked {
1531             // Updates:
1532             // - `balance += quantity`.
1533             // - `numberMinted += quantity`.
1534             //
1535             // We can directly add to the `balance` and `numberMinted`.
1536             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1537 
1538             // Updates:
1539             // - `address` to the owner.
1540             // - `startTimestamp` to the timestamp of minting.
1541             // - `burned` to `false`.
1542             // - `nextInitialized` to `quantity == 1`.
1543             _packedOwnerships[startTokenId] = _packOwnershipData(
1544                 to,
1545                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1546             );
1547 
1548             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1549 
1550             _currentIndex = startTokenId + quantity;
1551         }
1552         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1553     }
1554 
1555     /**
1556      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1557      *
1558      * Requirements:
1559      *
1560      * - If `to` refers to a smart contract, it must implement
1561      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1562      * - `quantity` must be greater than 0.
1563      *
1564      * See {_mint}.
1565      *
1566      * Emits a {Transfer} event for each mint.
1567      */
1568     function _safeMint(
1569         address to,
1570         uint256 quantity,
1571         bytes memory _data
1572     ) internal virtual {
1573         _mint(to, quantity);
1574 
1575         unchecked {
1576             if (to.code.length != 0) {
1577                 uint256 end = _currentIndex;
1578                 uint256 index = end - quantity;
1579                 do {
1580                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1581                         revert TransferToNonERC721ReceiverImplementer();
1582                     }
1583                 } while (index < end);
1584                 // Reentrancy protection.
1585                 if (_currentIndex != end) revert();
1586             }
1587         }
1588     }
1589 
1590     /**
1591      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1592      */
1593     function _safeMint(address to, uint256 quantity) internal virtual {
1594         _safeMint(to, quantity, '');
1595     }
1596 
1597     // =============================================================
1598     //                        BURN OPERATIONS
1599     // =============================================================
1600 
1601     /**
1602      * @dev Equivalent to `_burn(tokenId, false)`.
1603      */
1604     function _burn(uint256 tokenId) internal virtual {
1605         _burn(tokenId, false);
1606     }
1607 
1608     /**
1609      * @dev Destroys `tokenId`.
1610      * The approval is cleared when the token is burned.
1611      *
1612      * Requirements:
1613      *
1614      * - `tokenId` must exist.
1615      *
1616      * Emits a {Transfer} event.
1617      */
1618     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1619         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1620 
1621         address from = address(uint160(prevOwnershipPacked));
1622 
1623         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1624 
1625         if (approvalCheck) {
1626             // The nested ifs save around 20+ gas over a compound boolean condition.
1627             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1628                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1629         }
1630 
1631         _beforeTokenTransfers(from, address(0), tokenId, 1);
1632 
1633         // Clear approvals from the previous owner.
1634         assembly {
1635             if approvedAddress {
1636                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1637                 sstore(approvedAddressSlot, 0)
1638             }
1639         }
1640 
1641         // Underflow of the sender's balance is impossible because we check for
1642         // ownership above and the recipient's balance can't realistically overflow.
1643         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1644         unchecked {
1645             // Updates:
1646             // - `balance -= 1`.
1647             // - `numberBurned += 1`.
1648             //
1649             // We can directly decrement the balance, and increment the number burned.
1650             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1651             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1652 
1653             // Updates:
1654             // - `address` to the last owner.
1655             // - `startTimestamp` to the timestamp of burning.
1656             // - `burned` to `true`.
1657             // - `nextInitialized` to `true`.
1658             _packedOwnerships[tokenId] = _packOwnershipData(
1659                 from,
1660                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1661             );
1662 
1663             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1664             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1665                 uint256 nextTokenId = tokenId + 1;
1666                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1667                 if (_packedOwnerships[nextTokenId] == 0) {
1668                     // If the next slot is within bounds.
1669                     if (nextTokenId != _currentIndex) {
1670                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1671                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1672                     }
1673                 }
1674             }
1675         }
1676 
1677         emit Transfer(from, address(0), tokenId);
1678         _afterTokenTransfers(from, address(0), tokenId, 1);
1679 
1680         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1681         unchecked {
1682             _burnCounter++;
1683         }
1684     }
1685 
1686     // =============================================================
1687     //                     EXTRA DATA OPERATIONS
1688     // =============================================================
1689 
1690     /**
1691      * @dev Directly sets the extra data for the ownership data `index`.
1692      */
1693     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1694         uint256 packed = _packedOwnerships[index];
1695         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1696         uint256 extraDataCasted;
1697         // Cast `extraData` with assembly to avoid redundant masking.
1698         assembly {
1699             extraDataCasted := extraData
1700         }
1701         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1702         _packedOwnerships[index] = packed;
1703     }
1704 
1705     /**
1706      * @dev Called during each token transfer to set the 24bit `extraData` field.
1707      * Intended to be overridden by the cosumer contract.
1708      *
1709      * `previousExtraData` - the value of `extraData` before transfer.
1710      *
1711      * Calling conditions:
1712      *
1713      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1714      * transferred to `to`.
1715      * - When `from` is zero, `tokenId` will be minted for `to`.
1716      * - When `to` is zero, `tokenId` will be burned by `from`.
1717      * - `from` and `to` are never both zero.
1718      */
1719     function _extraData(
1720         address from,
1721         address to,
1722         uint24 previousExtraData
1723     ) internal view virtual returns (uint24) {}
1724 
1725     /**
1726      * @dev Returns the next extra data for the packed ownership data.
1727      * The returned result is shifted into position.
1728      */
1729     function _nextExtraData(
1730         address from,
1731         address to,
1732         uint256 prevOwnershipPacked
1733     ) private view returns (uint256) {
1734         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1735         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1736     }
1737 
1738     // =============================================================
1739     //                       OTHER OPERATIONS
1740     // =============================================================
1741 
1742     /**
1743      * @dev Returns the message sender (defaults to `msg.sender`).
1744      *
1745      * If you are writing GSN compatible contracts, you need to override this function.
1746      */
1747     function _msgSenderERC721A() internal view virtual returns (address) {
1748         return msg.sender;
1749     }
1750 
1751     /**
1752      * @dev Converts a uint256 to its ASCII string decimal representation.
1753      */
1754     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1755         assembly {
1756             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1757             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1758             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1759             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1760             let m := add(mload(0x40), 0xa0)
1761             // Update the free memory pointer to allocate.
1762             mstore(0x40, m)
1763             // Assign the `str` to the end.
1764             str := sub(m, 0x20)
1765             // Zeroize the slot after the string.
1766             mstore(str, 0)
1767 
1768             // Cache the end of the memory to calculate the length later.
1769             let end := str
1770 
1771             // We write the string from rightmost digit to leftmost digit.
1772             // The following is essentially a do-while loop that also handles the zero case.
1773             // prettier-ignore
1774             for { let temp := value } 1 {} {
1775                 str := sub(str, 1)
1776                 // Write the character to the pointer.
1777                 // The ASCII index of the '0' character is 48.
1778                 mstore8(str, add(48, mod(temp, 10)))
1779                 // Keep dividing `temp` until zero.
1780                 temp := div(temp, 10)
1781                 // prettier-ignore
1782                 if iszero(temp) { break }
1783             }
1784 
1785             let length := sub(end, str)
1786             // Move the pointer 32 bytes leftwards to make room for the length.
1787             str := sub(str, 0x20)
1788             // Store the length.
1789             mstore(str, length)
1790         }
1791     }
1792 }
1793 
1794 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1795 
1796 
1797 // ERC721A Contracts v4.2.3
1798 // Creator: Chiru Labs
1799 
1800 pragma solidity ^0.8.4;
1801 
1802 
1803 /**
1804  * @dev Interface of ERC721AQueryable.
1805  */
1806 interface IERC721AQueryable is IERC721A {
1807     /**
1808      * Invalid query range (`start` >= `stop`).
1809      */
1810     error InvalidQueryRange();
1811 
1812     /**
1813      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1814      *
1815      * If the `tokenId` is out of bounds:
1816      *
1817      * - `addr = address(0)`
1818      * - `startTimestamp = 0`
1819      * - `burned = false`
1820      * - `extraData = 0`
1821      *
1822      * If the `tokenId` is burned:
1823      *
1824      * - `addr = <Address of owner before token was burned>`
1825      * - `startTimestamp = <Timestamp when token was burned>`
1826      * - `burned = true`
1827      * - `extraData = <Extra data when token was burned>`
1828      *
1829      * Otherwise:
1830      *
1831      * - `addr = <Address of owner>`
1832      * - `startTimestamp = <Timestamp of start of ownership>`
1833      * - `burned = false`
1834      * - `extraData = <Extra data at start of ownership>`
1835      */
1836     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1837 
1838     /**
1839      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1840      * See {ERC721AQueryable-explicitOwnershipOf}
1841      */
1842     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1843 
1844     /**
1845      * @dev Returns an array of token IDs owned by `owner`,
1846      * in the range [`start`, `stop`)
1847      * (i.e. `start <= tokenId < stop`).
1848      *
1849      * This function allows for tokens to be queried if the collection
1850      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1851      *
1852      * Requirements:
1853      *
1854      * - `start < stop`
1855      */
1856     function tokensOfOwnerIn(
1857         address owner,
1858         uint256 start,
1859         uint256 stop
1860     ) external view returns (uint256[] memory);
1861 
1862     /**
1863      * @dev Returns an array of token IDs owned by `owner`.
1864      *
1865      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1866      * It is meant to be called off-chain.
1867      *
1868      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1869      * multiple smaller scans if the collection is large enough to cause
1870      * an out-of-gas error (10K collections should be fine).
1871      */
1872     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1873 }
1874 
1875 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1876 
1877 
1878 // ERC721A Contracts v4.2.3
1879 // Creator: Chiru Labs
1880 
1881 pragma solidity ^0.8.4;
1882 
1883 
1884 
1885 /**
1886  * @title ERC721AQueryable.
1887  *
1888  * @dev ERC721A subclass with convenience query functions.
1889  */
1890 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1891     /**
1892      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1893      *
1894      * If the `tokenId` is out of bounds:
1895      *
1896      * - `addr = address(0)`
1897      * - `startTimestamp = 0`
1898      * - `burned = false`
1899      * - `extraData = 0`
1900      *
1901      * If the `tokenId` is burned:
1902      *
1903      * - `addr = <Address of owner before token was burned>`
1904      * - `startTimestamp = <Timestamp when token was burned>`
1905      * - `burned = true`
1906      * - `extraData = <Extra data when token was burned>`
1907      *
1908      * Otherwise:
1909      *
1910      * - `addr = <Address of owner>`
1911      * - `startTimestamp = <Timestamp of start of ownership>`
1912      * - `burned = false`
1913      * - `extraData = <Extra data at start of ownership>`
1914      */
1915     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1916         TokenOwnership memory ownership;
1917         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1918             return ownership;
1919         }
1920         ownership = _ownershipAt(tokenId);
1921         if (ownership.burned) {
1922             return ownership;
1923         }
1924         return _ownershipOf(tokenId);
1925     }
1926 
1927     /**
1928      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1929      * See {ERC721AQueryable-explicitOwnershipOf}
1930      */
1931     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1932         external
1933         view
1934         virtual
1935         override
1936         returns (TokenOwnership[] memory)
1937     {
1938         unchecked {
1939             uint256 tokenIdsLength = tokenIds.length;
1940             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1941             for (uint256 i; i != tokenIdsLength; ++i) {
1942                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1943             }
1944             return ownerships;
1945         }
1946     }
1947 
1948     /**
1949      * @dev Returns an array of token IDs owned by `owner`,
1950      * in the range [`start`, `stop`)
1951      * (i.e. `start <= tokenId < stop`).
1952      *
1953      * This function allows for tokens to be queried if the collection
1954      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1955      *
1956      * Requirements:
1957      *
1958      * - `start < stop`
1959      */
1960     function tokensOfOwnerIn(
1961         address owner,
1962         uint256 start,
1963         uint256 stop
1964     ) external view virtual override returns (uint256[] memory) {
1965         unchecked {
1966             if (start >= stop) revert InvalidQueryRange();
1967             uint256 tokenIdsIdx;
1968             uint256 stopLimit = _nextTokenId();
1969             // Set `start = max(start, _startTokenId())`.
1970             if (start < _startTokenId()) {
1971                 start = _startTokenId();
1972             }
1973             // Set `stop = min(stop, stopLimit)`.
1974             if (stop > stopLimit) {
1975                 stop = stopLimit;
1976             }
1977             uint256 tokenIdsMaxLength = balanceOf(owner);
1978             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1979             // to cater for cases where `balanceOf(owner)` is too big.
1980             if (start < stop) {
1981                 uint256 rangeLength = stop - start;
1982                 if (rangeLength < tokenIdsMaxLength) {
1983                     tokenIdsMaxLength = rangeLength;
1984                 }
1985             } else {
1986                 tokenIdsMaxLength = 0;
1987             }
1988             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1989             if (tokenIdsMaxLength == 0) {
1990                 return tokenIds;
1991             }
1992             // We need to call `explicitOwnershipOf(start)`,
1993             // because the slot at `start` may not be initialized.
1994             TokenOwnership memory ownership = explicitOwnershipOf(start);
1995             address currOwnershipAddr;
1996             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1997             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1998             if (!ownership.burned) {
1999                 currOwnershipAddr = ownership.addr;
2000             }
2001             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2002                 ownership = _ownershipAt(i);
2003                 if (ownership.burned) {
2004                     continue;
2005                 }
2006                 if (ownership.addr != address(0)) {
2007                     currOwnershipAddr = ownership.addr;
2008                 }
2009                 if (currOwnershipAddr == owner) {
2010                     tokenIds[tokenIdsIdx++] = i;
2011                 }
2012             }
2013             // Downsize the array to fit.
2014             assembly {
2015                 mstore(tokenIds, tokenIdsIdx)
2016             }
2017             return tokenIds;
2018         }
2019     }
2020 
2021     /**
2022      * @dev Returns an array of token IDs owned by `owner`.
2023      *
2024      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2025      * It is meant to be called off-chain.
2026      *
2027      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2028      * multiple smaller scans if the collection is large enough to cause
2029      * an out-of-gas error (10K collections should be fine).
2030      */
2031     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2032         unchecked {
2033             uint256 tokenIdsIdx;
2034             address currOwnershipAddr;
2035             uint256 tokenIdsLength = balanceOf(owner);
2036             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2037             TokenOwnership memory ownership;
2038             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2039                 ownership = _ownershipAt(i);
2040                 if (ownership.burned) {
2041                     continue;
2042                 }
2043                 if (ownership.addr != address(0)) {
2044                     currOwnershipAddr = ownership.addr;
2045                 }
2046                 if (currOwnershipAddr == owner) {
2047                     tokenIds[tokenIdsIdx++] = i;
2048                 }
2049             }
2050             return tokenIds;
2051         }
2052     }
2053 }
2054 
2055 // File: contracts/miladyColombia.sol
2056 
2057 
2058 pragma solidity >=0.8.9 <0.9.0;
2059 
2060 
2061 
2062 
2063 
2064 
2065 contract MiladyColombia is ERC721AQueryable, Ownable, ReentrancyGuard {
2066 
2067   using Strings for uint256;
2068 
2069 
2070   string public uriPrefix = "ipfs://bafybeiepziae5jpf24ivogvkf6blrwwyxmsq5kdfcmgslvhh6jmrd2m4ee/";
2071   string public uriSuffix = ".json";
2072   
2073   uint256 public miladyPrice;
2074   uint256 public publicPrice;
2075   uint256 public maxSupply;
2076 
2077   bool public paused = true;
2078   bool public whitelistMintEnabled = false;
2079 
2080   address constant BORED_MILADY = 0xafe12842e3703a3cC3A71d9463389b1bF2c5BC1C;
2081   address constant MILADY_RAVE = 0x880a965fAe95f72fe3a3C8e87ED2c9478C8e0a29; 
2082   address constant MILADY_MAKER = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5; 
2083   address constant PIXELADY_MAKER = 0x8Fc0D90f2C45a5e7f94904075c952e0943CFCCfd; 
2084   address constant REDACTED_REMILIO = 0x8Fc0D90f2C45a5e7f94904075c952e0943CFCCfd; 
2085 
2086 
2087   constructor(
2088     string memory _tokenName, 
2089     string memory _tokenSymbol, 
2090     uint256 _publicPrice,
2091     uint256 _miladyPrice,
2092     uint256 _maxSupply
2093   ) ERC721A(_tokenName, _tokenSymbol) {
2094     setPublicPrice(_publicPrice);
2095     setMiladyPrice(_miladyPrice);
2096     maxSupply = _maxSupply;
2097   }
2098 
2099   modifier mintCompliance(uint256 _mintAmount) {
2100     require(_mintAmount > 0, 'Invalid mint amount!');
2101     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2102     _;
2103   }
2104 
2105   modifier mintPriceCompliance(uint256 _mintAmount) {
2106      require(msg.value >= publicPrice * _mintAmount, 'Insufficient funds!');
2107     _;
2108   }
2109 
2110   modifier hasBluechip(address account){
2111     require(
2112       IERC721(BORED_MILADY).balanceOf(account) > 0 || 
2113       IERC721(MILADY_RAVE).balanceOf(account) > 0 ||
2114       IERC721(MILADY_MAKER).balanceOf(account) > 0 ||
2115       IERC721(PIXELADY_MAKER).balanceOf(account) > 0 ||
2116       IERC721(REDACTED_REMILIO).balanceOf(account) > 0, "You dont any Milady's!");
2117     _;
2118   }
2119   
2120   function mintAsHolder(uint256 _mintAmount) public payable  mintCompliance(_mintAmount) hasBluechip(msg.sender) {
2121     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2122     require(msg.value >= miladyPrice * _mintAmount, 'Insufficient funds!');
2123     _safeMint(_msgSender(), _mintAmount);
2124   }
2125 
2126   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2127     require(!paused, 'The contract is paused!');
2128     _safeMint(_msgSender(), _mintAmount);
2129   }
2130   
2131   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2132     _safeMint(_receiver, _mintAmount);
2133   }
2134 
2135   function _startTokenId() internal view virtual override returns (uint256) {
2136     return 1;
2137   }
2138 
2139   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2140     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2141 
2142     string memory currentBaseURI = _baseURI();
2143     return bytes(currentBaseURI).length > 0
2144         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2145         : '';
2146   }
2147 
2148   function setPublicPrice(uint256 _publicPrice) public onlyOwner {
2149     publicPrice = _publicPrice;
2150   }
2151 
2152   function setMiladyPrice(uint256 _miladyPrice) public onlyOwner {
2153     miladyPrice = _miladyPrice;
2154   }
2155 
2156   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2157     uriPrefix = _uriPrefix;
2158   }
2159 
2160   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2161     uriSuffix = _uriSuffix;
2162   }
2163 
2164   function setPaused(bool _state) public onlyOwner {
2165     paused = _state;
2166   }
2167 
2168   function setWhitelistMintEnabled(bool _state) public onlyOwner {
2169     whitelistMintEnabled = _state;
2170   }
2171 
2172   function getIsMiladyHolder(address _account) public view returns (bool) {
2173     if (
2174       IERC721(BORED_MILADY).balanceOf(_account) > 0 || 
2175       IERC721(MILADY_RAVE).balanceOf(_account) > 0 ||
2176       IERC721(MILADY_MAKER).balanceOf(_account) > 0 ||
2177       IERC721(PIXELADY_MAKER).balanceOf(_account) > 0 ||
2178       IERC721(REDACTED_REMILIO).balanceOf(_account) > 0
2179       ) {
2180       return true;
2181     } else {
2182       return false;
2183     }
2184   }
2185 
2186   function withdraw() public onlyOwner nonReentrant {
2187     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2188     require(os);
2189   }
2190 
2191   function _baseURI() internal view virtual override returns (string memory) {
2192     return uriPrefix;
2193   }
2194 }