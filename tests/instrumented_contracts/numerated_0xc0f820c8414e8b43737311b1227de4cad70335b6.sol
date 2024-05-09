1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Contract module that helps prevent reentrant calls to a function.
80  *
81  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
82  * available, which can be applied to functions to make sure there are no nested
83  * (reentrant) calls to them.
84  *
85  * Note that because there is a single `nonReentrant` guard, functions marked as
86  * `nonReentrant` may not call one another. This can be worked around by making
87  * those functions `private`, and then adding `external` `nonReentrant` entry
88  * points to them.
89  *
90  * TIP: If you would like to learn more about reentrancy and alternative ways
91  * to protect against it, check out our blog post
92  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
93  */
94 abstract contract ReentrancyGuard {
95     // Booleans are more expensive than uint256 or any type that takes up a full
96     // word because each write operation emits an extra SLOAD to first read the
97     // slot's contents, replace the bits taken up by the boolean, and then write
98     // back. This is the compiler's defense against contract upgrades and
99     // pointer aliasing, and it cannot be disabled.
100 
101     // The values being non-zero value makes deployment a bit more expensive,
102     // but in exchange the refund on every call to nonReentrant will be lower in
103     // amount. Since refunds are capped to a percentage of the total
104     // transaction's gas, it is best to keep them low in cases like this one, to
105     // increase the likelihood of the full refund coming into effect.
106     uint256 private constant _NOT_ENTERED = 1;
107     uint256 private constant _ENTERED = 2;
108 
109     uint256 private _status;
110 
111     constructor() {
112         _status = _NOT_ENTERED;
113     }
114 
115     /**
116      * @dev Prevents a contract from calling itself, directly or indirectly.
117      * Calling a `nonReentrant` function from another `nonReentrant`
118      * function is not supported. It is possible to prevent this from happening
119      * by making the `nonReentrant` function external, and making it call a
120      * `private` function that does the actual work.
121      */
122     modifier nonReentrant() {
123         // On the first call to nonReentrant, _notEntered will be true
124         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
125 
126         // Any calls to nonReentrant after this point will fail
127         _status = _ENTERED;
128 
129         _;
130 
131         // By storing the original value once again, a refund is triggered (see
132         // https://eips.ethereum.org/EIPS/eip-2200)
133         _status = _NOT_ENTERED;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/access/Ownable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which provides a basic access control mechanism, where
174  * there is an account (an owner) that can be granted exclusive access to
175  * specific functions.
176  *
177  * By default, the owner account will be the one that deploys the contract. This
178  * can later be changed with {transferOwnership}.
179  *
180  * This module is used through inheritance. It will make available the modifier
181  * `onlyOwner`, which can be applied to your functions to restrict their use to
182  * the owner.
183  */
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor() {
193         _transferOwnership(_msgSender());
194     }
195 
196     /**
197      * @dev Returns the address of the current owner.
198      */
199     function owner() public view virtual returns (address) {
200         return _owner;
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         require(owner() == _msgSender(), "Ownable: caller is not the owner");
208         _;
209     }
210 
211     /**
212      * @dev Leaves the contract without owner. It will not be possible to call
213      * `onlyOwner` functions anymore. Can only be called by the current owner.
214      *
215      * NOTE: Renouncing ownership will leave the contract without an owner,
216      * thereby removing any functionality that is only available to the owner.
217      */
218     function renounceOwnership() public virtual onlyOwner {
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      * Can only be called by the current owner.
225      */
226     function transferOwnership(address newOwner) public virtual onlyOwner {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         _transferOwnership(newOwner);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Internal function without access restriction.
234      */
235     function _transferOwnership(address newOwner) internal virtual {
236         address oldOwner = _owner;
237         _owner = newOwner;
238         emit OwnershipTransferred(oldOwner, newOwner);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Interface of the ERC165 standard, as defined in the
251  * https://eips.ethereum.org/EIPS/eip-165[EIP].
252  *
253  * Implementers can declare support of contract interfaces, which can then be
254  * queried by others ({ERC165Checker}).
255  *
256  * For an implementation, see {ERC165}.
257  */
258 interface IERC165 {
259     /**
260      * @dev Returns true if this contract implements the interface defined by
261      * `interfaceId`. See the corresponding
262      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
263      * to learn more about how these ids are created.
264      *
265      * This function call must use less than 30 000 gas.
266      */
267     function supportsInterface(bytes4 interfaceId) external view returns (bool);
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Required interface of an ERC721 compliant contract.
280  */
281 interface IERC721 is IERC165 {
282     /**
283      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
286 
287     /**
288      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
289      */
290     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
291 
292     /**
293      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
294      */
295     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
296 
297     /**
298      * @dev Returns the number of tokens in ``owner``'s account.
299      */
300     function balanceOf(address owner) external view returns (uint256 balance);
301 
302     /**
303      * @dev Returns the owner of the `tokenId` token.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must exist.
308      */
309     function ownerOf(uint256 tokenId) external view returns (address owner);
310 
311     /**
312      * @dev Safely transfers `tokenId` token from `from` to `to`.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must exist and be owned by `from`.
319      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
321      *
322      * Emits a {Transfer} event.
323      */
324     function safeTransferFrom(
325         address from,
326         address to,
327         uint256 tokenId,
328         bytes calldata data
329     ) external;
330 
331     /**
332      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
333      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `tokenId` token must exist and be owned by `from`.
340      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
341      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
342      *
343      * Emits a {Transfer} event.
344      */
345     function safeTransferFrom(
346         address from,
347         address to,
348         uint256 tokenId
349     ) external;
350 
351     /**
352      * @dev Transfers `tokenId` token from `from` to `to`.
353      *
354      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `tokenId` token must be owned by `from`.
361      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external;
370 
371     /**
372      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
373      * The approval is cleared when the token is transferred.
374      *
375      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
376      *
377      * Requirements:
378      *
379      * - The caller must own the token or be an approved operator.
380      * - `tokenId` must exist.
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address to, uint256 tokenId) external;
385 
386     /**
387      * @dev Approve or remove `operator` as an operator for the caller.
388      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
389      *
390      * Requirements:
391      *
392      * - The `operator` cannot be the caller.
393      *
394      * Emits an {ApprovalForAll} event.
395      */
396     function setApprovalForAll(address operator, bool _approved) external;
397 
398     /**
399      * @dev Returns the account approved for `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function getApproved(uint256 tokenId) external view returns (address operator);
406 
407     /**
408      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
409      *
410      * See {setApprovalForAll}
411      */
412     function isApprovedForAll(address owner, address operator) external view returns (bool);
413 }
414 
415 // File: @openzeppelin/contracts/interfaces/IERC721.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 // File: erc721a/contracts/IERC721A.sol
424 
425 
426 // ERC721A Contracts v4.1.0
427 // Creator: Chiru Labs
428 
429 pragma solidity ^0.8.4;
430 
431 /**
432  * @dev Interface of an ERC721A compliant contract.
433  */
434 interface IERC721A {
435     /**
436      * The caller must own the token or be an approved operator.
437      */
438     error ApprovalCallerNotOwnerNorApproved();
439 
440     /**
441      * The token does not exist.
442      */
443     error ApprovalQueryForNonexistentToken();
444 
445     /**
446      * The caller cannot approve to their own address.
447      */
448     error ApproveToCaller();
449 
450     /**
451      * Cannot query the balance for the zero address.
452      */
453     error BalanceQueryForZeroAddress();
454 
455     /**
456      * Cannot mint to the zero address.
457      */
458     error MintToZeroAddress();
459 
460     /**
461      * The quantity of tokens minted must be more than zero.
462      */
463     error MintZeroQuantity();
464 
465     /**
466      * The token does not exist.
467      */
468     error OwnerQueryForNonexistentToken();
469 
470     /**
471      * The caller must own the token or be an approved operator.
472      */
473     error TransferCallerNotOwnerNorApproved();
474 
475     /**
476      * The token must be owned by `from`.
477      */
478     error TransferFromIncorrectOwner();
479 
480     /**
481      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
482      */
483     error TransferToNonERC721ReceiverImplementer();
484 
485     /**
486      * Cannot transfer to the zero address.
487      */
488     error TransferToZeroAddress();
489 
490     /**
491      * The token does not exist.
492      */
493     error URIQueryForNonexistentToken();
494 
495     /**
496      * The `quantity` minted with ERC2309 exceeds the safety limit.
497      */
498     error MintERC2309QuantityExceedsLimit();
499 
500     /**
501      * The `extraData` cannot be set on an unintialized ownership slot.
502      */
503     error OwnershipNotInitializedForExtraData();
504 
505     struct TokenOwnership {
506         // The address of the owner.
507         address addr;
508         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
509         uint64 startTimestamp;
510         // Whether the token has been burned.
511         bool burned;
512         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
513         uint24 extraData;
514     }
515 
516     /**
517      * @dev Returns the total amount of tokens stored by the contract.
518      *
519      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
520      */
521     function totalSupply() external view returns (uint256);
522 
523     // ==============================
524     //            IERC165
525     // ==============================
526 
527     /**
528      * @dev Returns true if this contract implements the interface defined by
529      * `interfaceId`. See the corresponding
530      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
531      * to learn more about how these ids are created.
532      *
533      * This function call must use less than 30 000 gas.
534      */
535     function supportsInterface(bytes4 interfaceId) external view returns (bool);
536 
537     // ==============================
538     //            IERC721
539     // ==============================
540 
541     /**
542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
543      */
544     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
545 
546     /**
547      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
548      */
549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
553      */
554     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
555 
556     /**
557      * @dev Returns the number of tokens in ``owner``'s account.
558      */
559     function balanceOf(address owner) external view returns (uint256 balance);
560 
561     /**
562      * @dev Returns the owner of the `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function ownerOf(uint256 tokenId) external view returns (address owner);
569 
570     /**
571      * @dev Safely transfers `tokenId` token from `from` to `to`.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId,
587         bytes calldata data
588     ) external;
589 
590     /**
591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must exist and be owned by `from`.
599      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
601      *
602      * Emits a {Transfer} event.
603      */
604     function safeTransferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external;
609 
610     /**
611      * @dev Transfers `tokenId` token from `from` to `to`.
612      *
613      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must be owned by `from`.
620      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
621      *
622      * Emits a {Transfer} event.
623      */
624     function transferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) external;
629 
630     /**
631      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
632      * The approval is cleared when the token is transferred.
633      *
634      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
635      *
636      * Requirements:
637      *
638      * - The caller must own the token or be an approved operator.
639      * - `tokenId` must exist.
640      *
641      * Emits an {Approval} event.
642      */
643     function approve(address to, uint256 tokenId) external;
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
648      *
649      * Requirements:
650      *
651      * - The `operator` cannot be the caller.
652      *
653      * Emits an {ApprovalForAll} event.
654      */
655     function setApprovalForAll(address operator, bool _approved) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(uint256 tokenId) external view returns (address operator);
665 
666     /**
667      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
668      *
669      * See {setApprovalForAll}
670      */
671     function isApprovedForAll(address owner, address operator) external view returns (bool);
672 
673     // ==============================
674     //        IERC721Metadata
675     // ==============================
676 
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() external view returns (string memory);
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() external view returns (string memory);
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) external view returns (string memory);
691 
692     // ==============================
693     //            IERC2309
694     // ==============================
695 
696     /**
697      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
698      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
699      */
700     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
701 }
702 
703 // File: erc721a/contracts/ERC721A.sol
704 
705 
706 // ERC721A Contracts v4.1.0
707 // Creator: Chiru Labs
708 
709 pragma solidity ^0.8.4;
710 
711 
712 /**
713  * @dev ERC721 token receiver interface.
714  */
715 interface ERC721A__IERC721Receiver {
716     function onERC721Received(
717         address operator,
718         address from,
719         uint256 tokenId,
720         bytes calldata data
721     ) external returns (bytes4);
722 }
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
726  * including the Metadata extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at `_startTokenId()`
729  * (defaults to 0, e.g. 0, 1, 2, 3..).
730  *
731  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
732  *
733  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
734  */
735 contract ERC721A is IERC721A {
736     // Mask of an entry in packed address data.
737     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
738 
739     // The bit position of `numberMinted` in packed address data.
740     uint256 private constant BITPOS_NUMBER_MINTED = 64;
741 
742     // The bit position of `numberBurned` in packed address data.
743     uint256 private constant BITPOS_NUMBER_BURNED = 128;
744 
745     // The bit position of `aux` in packed address data.
746     uint256 private constant BITPOS_AUX = 192;
747 
748     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
749     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
750 
751     // The bit position of `startTimestamp` in packed ownership.
752     uint256 private constant BITPOS_START_TIMESTAMP = 160;
753 
754     // The bit mask of the `burned` bit in packed ownership.
755     uint256 private constant BITMASK_BURNED = 1 << 224;
756 
757     // The bit position of the `nextInitialized` bit in packed ownership.
758     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
759 
760     // The bit mask of the `nextInitialized` bit in packed ownership.
761     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
762 
763     // The bit position of `extraData` in packed ownership.
764     uint256 private constant BITPOS_EXTRA_DATA = 232;
765 
766     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
767     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
768 
769     // The mask of the lower 160 bits for addresses.
770     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
771 
772     // The maximum `quantity` that can be minted with `_mintERC2309`.
773     // This limit is to prevent overflows on the address data entries.
774     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
775     // is required to cause an overflow, which is unrealistic.
776     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
777 
778     // The tokenId of the next token to be minted.
779     uint256 private _currentIndex;
780 
781     // The number of tokens burned.
782     uint256 private _burnCounter;
783 
784     // Token name
785     string private _name;
786 
787     // Token symbol
788     string private _symbol;
789 
790     // Mapping from token ID to ownership details
791     // An empty struct value does not necessarily mean the token is unowned.
792     // See `_packedOwnershipOf` implementation for details.
793     //
794     // Bits Layout:
795     // - [0..159]   `addr`
796     // - [160..223] `startTimestamp`
797     // - [224]      `burned`
798     // - [225]      `nextInitialized`
799     // - [232..255] `extraData`
800     mapping(uint256 => uint256) private _packedOwnerships;
801 
802     // Mapping owner address to address data.
803     //
804     // Bits Layout:
805     // - [0..63]    `balance`
806     // - [64..127]  `numberMinted`
807     // - [128..191] `numberBurned`
808     // - [192..255] `aux`
809     mapping(address => uint256) private _packedAddressData;
810 
811     // Mapping from token ID to approved address.
812     mapping(uint256 => address) private _tokenApprovals;
813 
814     // Mapping from owner to operator approvals
815     mapping(address => mapping(address => bool)) private _operatorApprovals;
816 
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820         _currentIndex = _startTokenId();
821     }
822 
823     /**
824      * @dev Returns the starting token ID.
825      * To change the starting token ID, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev Returns the next token ID to be minted.
833      */
834     function _nextTokenId() internal view returns (uint256) {
835         return _currentIndex;
836     }
837 
838     /**
839      * @dev Returns the total number of tokens in existence.
840      * Burned tokens will reduce the count.
841      * To get the total number of tokens minted, please see `_totalMinted`.
842      */
843     function totalSupply() public view override returns (uint256) {
844         // Counter underflow is impossible as _burnCounter cannot be incremented
845         // more than `_currentIndex - _startTokenId()` times.
846         unchecked {
847             return _currentIndex - _burnCounter - _startTokenId();
848         }
849     }
850 
851     /**
852      * @dev Returns the total amount of tokens minted in the contract.
853      */
854     function _totalMinted() internal view returns (uint256) {
855         // Counter underflow is impossible as _currentIndex does not decrement,
856         // and it is initialized to `_startTokenId()`
857         unchecked {
858             return _currentIndex - _startTokenId();
859         }
860     }
861 
862     /**
863      * @dev Returns the total number of tokens burned.
864      */
865     function _totalBurned() internal view returns (uint256) {
866         return _burnCounter;
867     }
868 
869     /**
870      * @dev See {IERC165-supportsInterface}.
871      */
872     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
873         // The interface IDs are constants representing the first 4 bytes of the XOR of
874         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
875         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
876         return
877             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
878             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
879             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view override returns (uint256) {
886         if (owner == address(0)) revert BalanceQueryForZeroAddress();
887         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
888     }
889 
890     /**
891      * Returns the number of tokens minted by `owner`.
892      */
893     function _numberMinted(address owner) internal view returns (uint256) {
894         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
895     }
896 
897     /**
898      * Returns the number of tokens burned by or on behalf of `owner`.
899      */
900     function _numberBurned(address owner) internal view returns (uint256) {
901         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
902     }
903 
904     /**
905      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
906      */
907     function _getAux(address owner) internal view returns (uint64) {
908         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
909     }
910 
911     /**
912      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
913      * If there are multiple variables, please pack them into a uint64.
914      */
915     function _setAux(address owner, uint64 aux) internal {
916         uint256 packed = _packedAddressData[owner];
917         uint256 auxCasted;
918         // Cast `aux` with assembly to avoid redundant masking.
919         assembly {
920             auxCasted := aux
921         }
922         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
923         _packedAddressData[owner] = packed;
924     }
925 
926     /**
927      * Returns the packed ownership data of `tokenId`.
928      */
929     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (_startTokenId() <= curr)
934                 if (curr < _currentIndex) {
935                     uint256 packed = _packedOwnerships[curr];
936                     // If not burned.
937                     if (packed & BITMASK_BURNED == 0) {
938                         // Invariant:
939                         // There will always be an ownership that has an address and is not burned
940                         // before an ownership that does not have an address and is not burned.
941                         // Hence, curr will not underflow.
942                         //
943                         // We can directly compare the packed value.
944                         // If the address is zero, packed is zero.
945                         while (packed == 0) {
946                             packed = _packedOwnerships[--curr];
947                         }
948                         return packed;
949                     }
950                 }
951         }
952         revert OwnerQueryForNonexistentToken();
953     }
954 
955     /**
956      * Returns the unpacked `TokenOwnership` struct from `packed`.
957      */
958     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
959         ownership.addr = address(uint160(packed));
960         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
961         ownership.burned = packed & BITMASK_BURNED != 0;
962         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
963     }
964 
965     /**
966      * Returns the unpacked `TokenOwnership` struct at `index`.
967      */
968     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
969         return _unpackedOwnership(_packedOwnerships[index]);
970     }
971 
972     /**
973      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
974      */
975     function _initializeOwnershipAt(uint256 index) internal {
976         if (_packedOwnerships[index] == 0) {
977             _packedOwnerships[index] = _packedOwnershipOf(index);
978         }
979     }
980 
981     /**
982      * Gas spent here starts off proportional to the maximum mint batch size.
983      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
984      */
985     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
986         return _unpackedOwnership(_packedOwnershipOf(tokenId));
987     }
988 
989     /**
990      * @dev Packs ownership data into a single uint256.
991      */
992     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
993         assembly {
994             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
995             owner := and(owner, BITMASK_ADDRESS)
996             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
997             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
998         }
999     }
1000 
1001     /**
1002      * @dev See {IERC721-ownerOf}.
1003      */
1004     function ownerOf(uint256 tokenId) public view override returns (address) {
1005         return address(uint160(_packedOwnershipOf(tokenId)));
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-name}.
1010      */
1011     function name() public view virtual override returns (string memory) {
1012         return _name;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-symbol}.
1017      */
1018     function symbol() public view virtual override returns (string memory) {
1019         return _symbol;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-tokenURI}.
1024      */
1025     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1026         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1027 
1028         string memory baseURI = _baseURI();
1029         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1030     }
1031 
1032     /**
1033      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1034      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1035      * by default, it can be overridden in child contracts.
1036      */
1037     function _baseURI() internal view virtual returns (string memory) {
1038         return '';
1039     }
1040 
1041     /**
1042      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1043      */
1044     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1045         // For branchless setting of the `nextInitialized` flag.
1046         assembly {
1047             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1048             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1049         }
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-approve}.
1054      */
1055     function approve(address to, uint256 tokenId) public override {
1056         address owner = ownerOf(tokenId);
1057 
1058         if (_msgSenderERC721A() != owner)
1059             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1060                 revert ApprovalCallerNotOwnerNorApproved();
1061             }
1062 
1063         _tokenApprovals[tokenId] = to;
1064         emit Approval(owner, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-getApproved}.
1069      */
1070     function getApproved(uint256 tokenId) public view override returns (address) {
1071         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1072 
1073         return _tokenApprovals[tokenId];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-setApprovalForAll}.
1078      */
1079     function setApprovalForAll(address operator, bool approved) public virtual override {
1080         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1081 
1082         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1083         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-isApprovedForAll}.
1088      */
1089     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1090         return _operatorApprovals[owner][operator];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-safeTransferFrom}.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) public virtual override {
1101         safeTransferFrom(from, to, tokenId, '');
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-safeTransferFrom}.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) public virtual override {
1113         transferFrom(from, to, tokenId);
1114         if (to.code.length != 0)
1115             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1116                 revert TransferToNonERC721ReceiverImplementer();
1117             }
1118     }
1119 
1120     /**
1121      * @dev Returns whether `tokenId` exists.
1122      *
1123      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1124      *
1125      * Tokens start existing when they are minted (`_mint`),
1126      */
1127     function _exists(uint256 tokenId) internal view returns (bool) {
1128         return
1129             _startTokenId() <= tokenId &&
1130             tokenId < _currentIndex && // If within bounds,
1131             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1132     }
1133 
1134     /**
1135      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1136      */
1137     function _safeMint(address to, uint256 quantity) internal {
1138         _safeMint(to, quantity, '');
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement
1147      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * See {_mint}.
1151      *
1152      * Emits a {Transfer} event for each mint.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal {
1159         _mint(to, quantity);
1160 
1161         unchecked {
1162             if (to.code.length != 0) {
1163                 uint256 end = _currentIndex;
1164                 uint256 index = end - quantity;
1165                 do {
1166                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1167                         revert TransferToNonERC721ReceiverImplementer();
1168                     }
1169                 } while (index < end);
1170                 // Reentrancy protection.
1171                 if (_currentIndex != end) revert();
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Mints `quantity` tokens and transfers them to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `quantity` must be greater than 0.
1183      *
1184      * Emits a {Transfer} event for each mint.
1185      */
1186     function _mint(address to, uint256 quantity) internal {
1187         uint256 startTokenId = _currentIndex;
1188         if (to == address(0)) revert MintToZeroAddress();
1189         if (quantity == 0) revert MintZeroQuantity();
1190 
1191         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1192 
1193         // Overflows are incredibly unrealistic.
1194         // `balance` and `numberMinted` have a maximum limit of 2**64.
1195         // `tokenId` has a maximum limit of 2**256.
1196         unchecked {
1197             // Updates:
1198             // - `balance += quantity`.
1199             // - `numberMinted += quantity`.
1200             //
1201             // We can directly add to the `balance` and `numberMinted`.
1202             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1203 
1204             // Updates:
1205             // - `address` to the owner.
1206             // - `startTimestamp` to the timestamp of minting.
1207             // - `burned` to `false`.
1208             // - `nextInitialized` to `quantity == 1`.
1209             _packedOwnerships[startTokenId] = _packOwnershipData(
1210                 to,
1211                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1212             );
1213 
1214             uint256 tokenId = startTokenId;
1215             uint256 end = startTokenId + quantity;
1216             do {
1217                 emit Transfer(address(0), to, tokenId++);
1218             } while (tokenId < end);
1219 
1220             _currentIndex = end;
1221         }
1222         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1223     }
1224 
1225     /**
1226      * @dev Mints `quantity` tokens and transfers them to `to`.
1227      *
1228      * This function is intended for efficient minting only during contract creation.
1229      *
1230      * It emits only one {ConsecutiveTransfer} as defined in
1231      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1232      * instead of a sequence of {Transfer} event(s).
1233      *
1234      * Calling this function outside of contract creation WILL make your contract
1235      * non-compliant with the ERC721 standard.
1236      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1237      * {ConsecutiveTransfer} event is only permissible during contract creation.
1238      *
1239      * Requirements:
1240      *
1241      * - `to` cannot be the zero address.
1242      * - `quantity` must be greater than 0.
1243      *
1244      * Emits a {ConsecutiveTransfer} event.
1245      */
1246     function _mintERC2309(address to, uint256 quantity) internal {
1247         uint256 startTokenId = _currentIndex;
1248         if (to == address(0)) revert MintToZeroAddress();
1249         if (quantity == 0) revert MintZeroQuantity();
1250         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1251 
1252         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1253 
1254         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1255         unchecked {
1256             // Updates:
1257             // - `balance += quantity`.
1258             // - `numberMinted += quantity`.
1259             //
1260             // We can directly add to the `balance` and `numberMinted`.
1261             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1262 
1263             // Updates:
1264             // - `address` to the owner.
1265             // - `startTimestamp` to the timestamp of minting.
1266             // - `burned` to `false`.
1267             // - `nextInitialized` to `quantity == 1`.
1268             _packedOwnerships[startTokenId] = _packOwnershipData(
1269                 to,
1270                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1271             );
1272 
1273             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1274 
1275             _currentIndex = startTokenId + quantity;
1276         }
1277         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1278     }
1279 
1280     /**
1281      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1282      */
1283     function _getApprovedAddress(uint256 tokenId)
1284         private
1285         view
1286         returns (uint256 approvedAddressSlot, address approvedAddress)
1287     {
1288         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1289         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1290         assembly {
1291             // Compute the slot.
1292             mstore(0x00, tokenId)
1293             mstore(0x20, tokenApprovalsPtr.slot)
1294             approvedAddressSlot := keccak256(0x00, 0x40)
1295             // Load the slot's value from storage.
1296             approvedAddress := sload(approvedAddressSlot)
1297         }
1298     }
1299 
1300     /**
1301      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1302      */
1303     function _isOwnerOrApproved(
1304         address approvedAddress,
1305         address from,
1306         address msgSender
1307     ) private pure returns (bool result) {
1308         assembly {
1309             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1310             from := and(from, BITMASK_ADDRESS)
1311             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1312             msgSender := and(msgSender, BITMASK_ADDRESS)
1313             // `msgSender == from || msgSender == approvedAddress`.
1314             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1315         }
1316     }
1317 
1318     /**
1319      * @dev Transfers `tokenId` from `from` to `to`.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `tokenId` token must be owned by `from`.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function transferFrom(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) public virtual override {
1333         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1334 
1335         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1336 
1337         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1338 
1339         // The nested ifs save around 20+ gas over a compound boolean condition.
1340         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1341             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1342 
1343         if (to == address(0)) revert TransferToZeroAddress();
1344 
1345         _beforeTokenTransfers(from, to, tokenId, 1);
1346 
1347         // Clear approvals from the previous owner.
1348         assembly {
1349             if approvedAddress {
1350                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1351                 sstore(approvedAddressSlot, 0)
1352             }
1353         }
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1358         unchecked {
1359             // We can directly increment and decrement the balances.
1360             --_packedAddressData[from]; // Updates: `balance -= 1`.
1361             ++_packedAddressData[to]; // Updates: `balance += 1`.
1362 
1363             // Updates:
1364             // - `address` to the next owner.
1365             // - `startTimestamp` to the timestamp of transfering.
1366             // - `burned` to `false`.
1367             // - `nextInitialized` to `true`.
1368             _packedOwnerships[tokenId] = _packOwnershipData(
1369                 to,
1370                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1371             );
1372 
1373             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1374             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1375                 uint256 nextTokenId = tokenId + 1;
1376                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1377                 if (_packedOwnerships[nextTokenId] == 0) {
1378                     // If the next slot is within bounds.
1379                     if (nextTokenId != _currentIndex) {
1380                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1381                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1382                     }
1383                 }
1384             }
1385         }
1386 
1387         emit Transfer(from, to, tokenId);
1388         _afterTokenTransfers(from, to, tokenId, 1);
1389     }
1390 
1391     /**
1392      * @dev Equivalent to `_burn(tokenId, false)`.
1393      */
1394     function _burn(uint256 tokenId) internal virtual {
1395         _burn(tokenId, false);
1396     }
1397 
1398     /**
1399      * @dev Destroys `tokenId`.
1400      * The approval is cleared when the token is burned.
1401      *
1402      * Requirements:
1403      *
1404      * - `tokenId` must exist.
1405      *
1406      * Emits a {Transfer} event.
1407      */
1408     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1409         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1410 
1411         address from = address(uint160(prevOwnershipPacked));
1412 
1413         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1414 
1415         if (approvalCheck) {
1416             // The nested ifs save around 20+ gas over a compound boolean condition.
1417             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1418                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1419         }
1420 
1421         _beforeTokenTransfers(from, address(0), tokenId, 1);
1422 
1423         // Clear approvals from the previous owner.
1424         assembly {
1425             if approvedAddress {
1426                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1427                 sstore(approvedAddressSlot, 0)
1428             }
1429         }
1430 
1431         // Underflow of the sender's balance is impossible because we check for
1432         // ownership above and the recipient's balance can't realistically overflow.
1433         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1434         unchecked {
1435             // Updates:
1436             // - `balance -= 1`.
1437             // - `numberBurned += 1`.
1438             //
1439             // We can directly decrement the balance, and increment the number burned.
1440             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1441             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1442 
1443             // Updates:
1444             // - `address` to the last owner.
1445             // - `startTimestamp` to the timestamp of burning.
1446             // - `burned` to `true`.
1447             // - `nextInitialized` to `true`.
1448             _packedOwnerships[tokenId] = _packOwnershipData(
1449                 from,
1450                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1451             );
1452 
1453             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1454             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1455                 uint256 nextTokenId = tokenId + 1;
1456                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1457                 if (_packedOwnerships[nextTokenId] == 0) {
1458                     // If the next slot is within bounds.
1459                     if (nextTokenId != _currentIndex) {
1460                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1461                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1462                     }
1463                 }
1464             }
1465         }
1466 
1467         emit Transfer(from, address(0), tokenId);
1468         _afterTokenTransfers(from, address(0), tokenId, 1);
1469 
1470         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1471         unchecked {
1472             _burnCounter++;
1473         }
1474     }
1475 
1476     /**
1477      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1478      *
1479      * @param from address representing the previous owner of the given token ID
1480      * @param to target address that will receive the tokens
1481      * @param tokenId uint256 ID of the token to be transferred
1482      * @param _data bytes optional data to send along with the call
1483      * @return bool whether the call correctly returned the expected magic value
1484      */
1485     function _checkContractOnERC721Received(
1486         address from,
1487         address to,
1488         uint256 tokenId,
1489         bytes memory _data
1490     ) private returns (bool) {
1491         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1492             bytes4 retval
1493         ) {
1494             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1495         } catch (bytes memory reason) {
1496             if (reason.length == 0) {
1497                 revert TransferToNonERC721ReceiverImplementer();
1498             } else {
1499                 assembly {
1500                     revert(add(32, reason), mload(reason))
1501                 }
1502             }
1503         }
1504     }
1505 
1506     /**
1507      * @dev Directly sets the extra data for the ownership data `index`.
1508      */
1509     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1510         uint256 packed = _packedOwnerships[index];
1511         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1512         uint256 extraDataCasted;
1513         // Cast `extraData` with assembly to avoid redundant masking.
1514         assembly {
1515             extraDataCasted := extraData
1516         }
1517         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1518         _packedOwnerships[index] = packed;
1519     }
1520 
1521     /**
1522      * @dev Returns the next extra data for the packed ownership data.
1523      * The returned result is shifted into position.
1524      */
1525     function _nextExtraData(
1526         address from,
1527         address to,
1528         uint256 prevOwnershipPacked
1529     ) private view returns (uint256) {
1530         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1531         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1532     }
1533 
1534     /**
1535      * @dev Called during each token transfer to set the 24bit `extraData` field.
1536      * Intended to be overridden by the cosumer contract.
1537      *
1538      * `previousExtraData` - the value of `extraData` before transfer.
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` will be minted for `to`.
1545      * - When `to` is zero, `tokenId` will be burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _extraData(
1549         address from,
1550         address to,
1551         uint24 previousExtraData
1552     ) internal view virtual returns (uint24) {}
1553 
1554     /**
1555      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1556      * This includes minting.
1557      * And also called before burning one token.
1558      *
1559      * startTokenId - the first token id to be transferred
1560      * quantity - the amount to be transferred
1561      *
1562      * Calling conditions:
1563      *
1564      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1565      * transferred to `to`.
1566      * - When `from` is zero, `tokenId` will be minted for `to`.
1567      * - When `to` is zero, `tokenId` will be burned by `from`.
1568      * - `from` and `to` are never both zero.
1569      */
1570     function _beforeTokenTransfers(
1571         address from,
1572         address to,
1573         uint256 startTokenId,
1574         uint256 quantity
1575     ) internal virtual {}
1576 
1577     /**
1578      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1579      * This includes minting.
1580      * And also called after one token has been burned.
1581      *
1582      * startTokenId - the first token id to be transferred
1583      * quantity - the amount to be transferred
1584      *
1585      * Calling conditions:
1586      *
1587      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1588      * transferred to `to`.
1589      * - When `from` is zero, `tokenId` has been minted for `to`.
1590      * - When `to` is zero, `tokenId` has been burned by `from`.
1591      * - `from` and `to` are never both zero.
1592      */
1593     function _afterTokenTransfers(
1594         address from,
1595         address to,
1596         uint256 startTokenId,
1597         uint256 quantity
1598     ) internal virtual {}
1599 
1600     /**
1601      * @dev Returns the message sender (defaults to `msg.sender`).
1602      *
1603      * If you are writing GSN compatible contracts, you need to override this function.
1604      */
1605     function _msgSenderERC721A() internal view virtual returns (address) {
1606         return msg.sender;
1607     }
1608 
1609     /**
1610      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1611      */
1612     function _toString(uint256 value) internal pure returns (string memory ptr) {
1613         assembly {
1614             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1615             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1616             // We will need 1 32-byte word to store the length,
1617             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1618             ptr := add(mload(0x40), 128)
1619             // Update the free memory pointer to allocate.
1620             mstore(0x40, ptr)
1621 
1622             // Cache the end of the memory to calculate the length later.
1623             let end := ptr
1624 
1625             // We write the string from the rightmost digit to the leftmost digit.
1626             // The following is essentially a do-while loop that also handles the zero case.
1627             // Costs a bit more than early returning for the zero case,
1628             // but cheaper in terms of deployment and overall runtime costs.
1629             for {
1630                 // Initialize and perform the first pass without check.
1631                 let temp := value
1632                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1633                 ptr := sub(ptr, 1)
1634                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1635                 mstore8(ptr, add(48, mod(temp, 10)))
1636                 temp := div(temp, 10)
1637             } temp {
1638                 // Keep dividing `temp` until zero.
1639                 temp := div(temp, 10)
1640             } {
1641                 // Body of the for loop.
1642                 ptr := sub(ptr, 1)
1643                 mstore8(ptr, add(48, mod(temp, 10)))
1644             }
1645 
1646             let length := sub(end, ptr)
1647             // Move the pointer 32 bytes leftwards to make room for the length.
1648             ptr := sub(ptr, 32)
1649             // Store the length.
1650             mstore(ptr, length)
1651         }
1652     }
1653 }
1654 
1655 // File: contracts/TubbyMilady.sol
1656 
1657 //SPDX-License-Identifier: Unlicense
1658 pragma solidity ^0.8.0;
1659 
1660 /// @author Tubby Milady
1661 
1662 
1663 
1664 
1665 
1666 
1667 contract TubbyMiladys is Ownable, ERC721A, ReentrancyGuard {
1668 
1669   uint256 public TUBBY_MILADY_SUPPLY = 4800;
1670   uint256 public TEAM_AMOUNT = 48;
1671 
1672   bool public mintLive;
1673   bool public teamMinted;
1674   bool public revealed;
1675 
1676   string public baseURI;
1677   string public unrevealedURI = "ipfs://bafybeia4w6sgbg4fiksqg7eqsokeh2yiksroy47zjpnwwks27iirkvdnya/0";
1678 
1679   address public TUBBY_CONTRACT = 0xCa7cA7BcC765F77339bE2d648BA53ce9c8a262bD;
1680   address public MILADY_CONTRACT = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
1681 
1682   constructor() ERC721A("Tubby Milady Maker", "TUBMIL") {}
1683 
1684   function mintTubbyMiladys(uint256 mintAmount) public payable {
1685     require(mintLive, "Mint not live");
1686     require(totalSupply() + mintAmount <= TUBBY_MILADY_SUPPLY, "Sold out");
1687 
1688     uint256 tubbyMiladyPrice;
1689     if (mintAmount >= 5 || holdsMiladyOrTubby(msg.sender)) {
1690       tubbyMiladyPrice = 0.0085 ether;
1691       require(msg.value >= tubbyMiladyPrice * mintAmount, "Not enough ETH (0.0085 each)");
1692     } else {
1693       tubbyMiladyPrice = 0.017 ether;
1694       require(msg.value >= tubbyMiladyPrice * mintAmount, "Not enough ETH (.017 each)");
1695     }
1696     _safeMint(msg.sender, mintAmount);
1697   }
1698 
1699   function mintTubbyMiladyTeam() external onlyOwner {
1700     require(!teamMinted, "Team already minted");
1701     teamMinted = !teamMinted;
1702     _safeMint(0x265D5CEDbCecf2a70E78D31D0AcC7BE8617de7B9, TEAM_AMOUNT);
1703   }
1704 
1705   function holdsMiladyOrTubby(address tubbyMilady) public view returns (bool) {
1706     return IERC721(MILADY_CONTRACT).balanceOf(tubbyMilady) > 0 || IERC721(TUBBY_CONTRACT).balanceOf(tubbyMilady) > 0;
1707   }
1708 
1709   function tokenURI(uint256 tokenId_) public view override returns (string memory) {
1710     if(!revealed || tokenId_ >= totalSupply()) {
1711       return unrevealedURI;
1712     }
1713     return string(abi.encodePacked(baseURI, Strings.toString(tokenId_)));
1714   }
1715 
1716   function toggleMint() external onlyOwner {
1717     mintLive = !mintLive;
1718   }
1719 
1720   function flipReveal(string calldata newURI) external onlyOwner {
1721     require(!revealed, "Already revealed");
1722     baseURI = newURI;
1723     revealed = !revealed;
1724   }
1725 
1726   function setBaseURI(string calldata newURI) external onlyOwner {
1727     baseURI = newURI;
1728   }
1729 
1730   function withdraw() external onlyOwner nonReentrant {
1731     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1732     require(success, "Transfer failed.");
1733   }
1734 }
1735 
1736 // ( ͡` ͜ʖ ͡´)