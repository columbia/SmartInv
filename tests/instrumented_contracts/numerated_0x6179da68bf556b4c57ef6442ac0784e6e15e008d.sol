1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
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
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Contract module that helps prevent reentrant calls to a function.
88  *
89  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
90  * available, which can be applied to functions to make sure there are no nested
91  * (reentrant) calls to them.
92  *
93  * Note that because there is a single `nonReentrant` guard, functions marked as
94  * `nonReentrant` may not call one another. This can be worked around by making
95  * those functions `private`, and then adding `external` `nonReentrant` entry
96  * points to them.
97  *
98  * TIP: If you would like to learn more about reentrancy and alternative ways
99  * to protect against it, check out our blog post
100  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
101  */
102 abstract contract ReentrancyGuard {
103     // Booleans are more expensive than uint256 or any type that takes up a full
104     // word because each write operation emits an extra SLOAD to first read the
105     // slot's contents, replace the bits taken up by the boolean, and then write
106     // back. This is the compiler's defense against contract upgrades and
107     // pointer aliasing, and it cannot be disabled.
108 
109     // The values being non-zero value makes deployment a bit more expensive,
110     // but in exchange the refund on every call to nonReentrant will be lower in
111     // amount. Since refunds are capped to a percentage of the total
112     // transaction's gas, it is best to keep them low in cases like this one, to
113     // increase the likelihood of the full refund coming into effect.
114     uint256 private constant _NOT_ENTERED = 1;
115     uint256 private constant _ENTERED = 2;
116 
117     uint256 private _status;
118 
119     constructor() {
120         _status = _NOT_ENTERED;
121     }
122 
123     /**
124      * @dev Prevents a contract from calling itself, directly or indirectly.
125      * Calling a `nonReentrant` function from another `nonReentrant`
126      * function is not supported. It is possible to prevent this from happening
127      * by making the `nonReentrant` function external, and making it call a
128      * `private` function that does the actual work.
129      */
130     modifier nonReentrant() {
131         // On the first call to nonReentrant, _notEntered will be true
132         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
133 
134         // Any calls to nonReentrant after this point will fail
135         _status = _ENTERED;
136 
137         _;
138 
139         // By storing the original value once again, a refund is triggered (see
140         // https://eips.ethereum.org/EIPS/eip-2200)
141         _status = _NOT_ENTERED;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Throws if called by any account other than the owner.
206      */
207     modifier onlyOwner() {
208         _checkOwner();
209         _;
210     }
211 
212     /**
213      * @dev Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      * @dev Throws if the sender is not the owner.
221      */
222     function _checkOwner() internal view virtual {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Interface of the ERC165 standard, as defined in the
266  * https://eips.ethereum.org/EIPS/eip-165[EIP].
267  *
268  * Implementers can declare support of contract interfaces, which can then be
269  * queried by others ({ERC165Checker}).
270  *
271  * For an implementation, see {ERC165}.
272  */
273 interface IERC165 {
274     /**
275      * @dev Returns true if this contract implements the interface defined by
276      * `interfaceId`. See the corresponding
277      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
278      * to learn more about how these ids are created.
279      *
280      * This function call must use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
286 
287 
288 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Interface for the NFT Royalty Standard.
295  *
296  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
297  * support for royalty payments across all NFT marketplaces and ecosystem participants.
298  *
299  * _Available since v4.5._
300  */
301 interface IERC2981 is IERC165 {
302     /**
303      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
304      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
305      */
306     function royaltyInfo(uint256 tokenId, uint256 salePrice)
307         external
308         view
309         returns (address receiver, uint256 royaltyAmount);
310 }
311 
312 // File: erc721a/contracts/IERC721A.sol
313 
314 
315 // ERC721A Contracts v4.2.2
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
370      * Cannot safely transfer to a contract that does not implement the
371      * ERC721Receiver interface.
372      */
373     error TransferToNonERC721ReceiverImplementer();
374 
375     /**
376      * Cannot transfer to the zero address.
377      */
378     error TransferToZeroAddress();
379 
380     /**
381      * The token does not exist.
382      */
383     error URIQueryForNonexistentToken();
384 
385     /**
386      * The `quantity` minted with ERC2309 exceeds the safety limit.
387      */
388     error MintERC2309QuantityExceedsLimit();
389 
390     /**
391      * The `extraData` cannot be set on an unintialized ownership slot.
392      */
393     error OwnershipNotInitializedForExtraData();
394 
395     // =============================================================
396     //                            STRUCTS
397     // =============================================================
398 
399     struct TokenOwnership {
400         // The address of the owner.
401         address addr;
402         // Stores the start time of ownership with minimal overhead for tokenomics.
403         uint64 startTimestamp;
404         // Whether the token has been burned.
405         bool burned;
406         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
407         uint24 extraData;
408     }
409 
410     // =============================================================
411     //                         TOKEN COUNTERS
412     // =============================================================
413 
414     /**
415      * @dev Returns the total number of tokens in existence.
416      * Burned tokens will reduce the count.
417      * To get the total number of tokens minted, please see {_totalMinted}.
418      */
419     function totalSupply() external view returns (uint256);
420 
421     // =============================================================
422     //                            IERC165
423     // =============================================================
424 
425     /**
426      * @dev Returns true if this contract implements the interface defined by
427      * `interfaceId`. See the corresponding
428      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
429      * to learn more about how these ids are created.
430      *
431      * This function call must use less than 30000 gas.
432      */
433     function supportsInterface(bytes4 interfaceId) external view returns (bool);
434 
435     // =============================================================
436     //                            IERC721
437     // =============================================================
438 
439     /**
440      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
443 
444     /**
445      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
446      */
447     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
448 
449     /**
450      * @dev Emitted when `owner` enables or disables
451      * (`approved`) `operator` to manage all of its assets.
452      */
453     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
454 
455     /**
456      * @dev Returns the number of tokens in `owner`'s account.
457      */
458     function balanceOf(address owner) external view returns (uint256 balance);
459 
460     /**
461      * @dev Returns the owner of the `tokenId` token.
462      *
463      * Requirements:
464      *
465      * - `tokenId` must exist.
466      */
467     function ownerOf(uint256 tokenId) external view returns (address owner);
468 
469     /**
470      * @dev Safely transfers `tokenId` token from `from` to `to`,
471      * checking first that contract recipients are aware of the ERC721 protocol
472      * to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move
480      * this token by either {approve} or {setApprovalForAll}.
481      * - If `to` refers to a smart contract, it must implement
482      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId,
490         bytes calldata data
491     ) external;
492 
493     /**
494      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Transfers `tokenId` from `from` to `to`.
504      *
505      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
506      * whenever possible.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token
514      * by either {approve} or {setApprovalForAll}.
515      *
516      * Emits a {Transfer} event.
517      */
518     function transferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) external;
523 
524     /**
525      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
526      * The approval is cleared when the token is transferred.
527      *
528      * Only a single account can be approved at a time, so approving the
529      * zero address clears previous approvals.
530      *
531      * Requirements:
532      *
533      * - The caller must own the token or be an approved operator.
534      * - `tokenId` must exist.
535      *
536      * Emits an {Approval} event.
537      */
538     function approve(address to, uint256 tokenId) external;
539 
540     /**
541      * @dev Approve or remove `operator` as an operator for the caller.
542      * Operators can call {transferFrom} or {safeTransferFrom}
543      * for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns the account approved for `tokenId` token.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function getApproved(uint256 tokenId) external view returns (address operator);
561 
562     /**
563      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
564      *
565      * See {setApprovalForAll}.
566      */
567     function isApprovedForAll(address owner, address operator) external view returns (bool);
568 
569     // =============================================================
570     //                        IERC721Metadata
571     // =============================================================
572 
573     /**
574      * @dev Returns the token collection name.
575      */
576     function name() external view returns (string memory);
577 
578     /**
579      * @dev Returns the token collection symbol.
580      */
581     function symbol() external view returns (string memory);
582 
583     /**
584      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
585      */
586     function tokenURI(uint256 tokenId) external view returns (string memory);
587 
588     // =============================================================
589     //                           IERC2309
590     // =============================================================
591 
592     /**
593      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
594      * (inclusive) is transferred from `from` to `to`, as defined in the
595      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
596      *
597      * See {_mintERC2309} for more details.
598      */
599     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
600 }
601 
602 // File: erc721a/contracts/ERC721A.sol
603 
604 
605 // ERC721A Contracts v4.2.2
606 // Creator: Chiru Labs
607 
608 pragma solidity ^0.8.4;
609 
610 
611 /**
612  * @dev Interface of ERC721 token receiver.
613  */
614 interface ERC721A__IERC721Receiver {
615     function onERC721Received(
616         address operator,
617         address from,
618         uint256 tokenId,
619         bytes calldata data
620     ) external returns (bytes4);
621 }
622 
623 /**
624  * @title ERC721A
625  *
626  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
627  * Non-Fungible Token Standard, including the Metadata extension.
628  * Optimized for lower gas during batch mints.
629  *
630  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
631  * starting from `_startTokenId()`.
632  *
633  * Assumptions:
634  *
635  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
636  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
637  */
638 contract ERC721A is IERC721A {
639     // Reference type for token approval.
640     struct TokenApprovalRef {
641         address value;
642     }
643 
644     // =============================================================
645     //                           CONSTANTS
646     // =============================================================
647 
648     // Mask of an entry in packed address data.
649     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
650 
651     // The bit position of `numberMinted` in packed address data.
652     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
653 
654     // The bit position of `numberBurned` in packed address data.
655     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
656 
657     // The bit position of `aux` in packed address data.
658     uint256 private constant _BITPOS_AUX = 192;
659 
660     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
661     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
662 
663     // The bit position of `startTimestamp` in packed ownership.
664     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
665 
666     // The bit mask of the `burned` bit in packed ownership.
667     uint256 private constant _BITMASK_BURNED = 1 << 224;
668 
669     // The bit position of the `nextInitialized` bit in packed ownership.
670     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
671 
672     // The bit mask of the `nextInitialized` bit in packed ownership.
673     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
674 
675     // The bit position of `extraData` in packed ownership.
676     uint256 private constant _BITPOS_EXTRA_DATA = 232;
677 
678     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
679     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
680 
681     // The mask of the lower 160 bits for addresses.
682     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
683 
684     // The maximum `quantity` that can be minted with {_mintERC2309}.
685     // This limit is to prevent overflows on the address data entries.
686     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
687     // is required to cause an overflow, which is unrealistic.
688     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
689 
690     // The `Transfer` event signature is given by:
691     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
692     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
693         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
694 
695     // =============================================================
696     //                            STORAGE
697     // =============================================================
698 
699     // The next token ID to be minted.
700     uint256 private _currentIndex;
701 
702     // The number of tokens burned.
703     uint256 private _burnCounter;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to ownership details
712     // An empty struct value does not necessarily mean the token is unowned.
713     // See {_packedOwnershipOf} implementation for details.
714     //
715     // Bits Layout:
716     // - [0..159]   `addr`
717     // - [160..223] `startTimestamp`
718     // - [224]      `burned`
719     // - [225]      `nextInitialized`
720     // - [232..255] `extraData`
721     mapping(uint256 => uint256) private _packedOwnerships;
722 
723     // Mapping owner address to address data.
724     //
725     // Bits Layout:
726     // - [0..63]    `balance`
727     // - [64..127]  `numberMinted`
728     // - [128..191] `numberBurned`
729     // - [192..255] `aux`
730     mapping(address => uint256) private _packedAddressData;
731 
732     // Mapping from token ID to approved address.
733     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     // =============================================================
739     //                          CONSTRUCTOR
740     // =============================================================
741 
742     constructor(string memory name_, string memory symbol_) {
743         _name = name_;
744         _symbol = symbol_;
745         _currentIndex = _startTokenId();
746     }
747 
748     // =============================================================
749     //                   TOKEN COUNTING OPERATIONS
750     // =============================================================
751 
752     /**
753      * @dev Returns the starting token ID.
754      * To change the starting token ID, please override this function.
755      */
756     function _startTokenId() internal view virtual returns (uint256) {
757         return 0;
758     }
759 
760     /**
761      * @dev Returns the next token ID to be minted.
762      */
763     function _nextTokenId() internal view virtual returns (uint256) {
764         return _currentIndex;
765     }
766 
767     /**
768      * @dev Returns the total number of tokens in existence.
769      * Burned tokens will reduce the count.
770      * To get the total number of tokens minted, please see {_totalMinted}.
771      */
772     function totalSupply() public view virtual override returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than `_currentIndex - _startTokenId()` times.
775         unchecked {
776             return _currentIndex - _burnCounter - _startTokenId();
777         }
778     }
779 
780     /**
781      * @dev Returns the total amount of tokens minted in the contract.
782      */
783     function _totalMinted() internal view virtual returns (uint256) {
784         // Counter underflow is impossible as `_currentIndex` does not decrement,
785         // and it is initialized to `_startTokenId()`.
786         unchecked {
787             return _currentIndex - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev Returns the total number of tokens burned.
793      */
794     function _totalBurned() internal view virtual returns (uint256) {
795         return _burnCounter;
796     }
797 
798     // =============================================================
799     //                    ADDRESS DATA OPERATIONS
800     // =============================================================
801 
802     /**
803      * @dev Returns the number of tokens in `owner`'s account.
804      */
805     function balanceOf(address owner) public view virtual override returns (uint256) {
806         if (owner == address(0)) revert BalanceQueryForZeroAddress();
807         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
808     }
809 
810     /**
811      * Returns the number of tokens minted by `owner`.
812      */
813     function _numberMinted(address owner) internal view returns (uint256) {
814         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
815     }
816 
817     /**
818      * Returns the number of tokens burned by or on behalf of `owner`.
819      */
820     function _numberBurned(address owner) internal view returns (uint256) {
821         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
822     }
823 
824     /**
825      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
826      */
827     function _getAux(address owner) internal view returns (uint64) {
828         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
829     }
830 
831     /**
832      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
833      * If there are multiple variables, please pack them into a uint64.
834      */
835     function _setAux(address owner, uint64 aux) internal virtual {
836         uint256 packed = _packedAddressData[owner];
837         uint256 auxCasted;
838         // Cast `aux` with assembly to avoid redundant masking.
839         assembly {
840             auxCasted := aux
841         }
842         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
843         _packedAddressData[owner] = packed;
844     }
845 
846     // =============================================================
847     //                            IERC165
848     // =============================================================
849 
850     /**
851      * @dev Returns true if this contract implements the interface defined by
852      * `interfaceId`. See the corresponding
853      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
854      * to learn more about how these ids are created.
855      *
856      * This function call must use less than 30000 gas.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
859         // The interface IDs are constants representing the first 4 bytes
860         // of the XOR of all function selectors in the interface.
861         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
862         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
863         return
864             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
865             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
866             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
867     }
868 
869     // =============================================================
870     //                        IERC721Metadata
871     // =============================================================
872 
873     /**
874      * @dev Returns the token collection name.
875      */
876     function name() public view virtual override returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev Returns the token collection symbol.
882      */
883     function symbol() public view virtual override returns (string memory) {
884         return _symbol;
885     }
886 
887     /**
888      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
889      */
890     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
891         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
892 
893         string memory baseURI = _baseURI();
894         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
895     }
896 
897     /**
898      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
899      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
900      * by default, it can be overridden in child contracts.
901      */
902     function _baseURI() internal view virtual returns (string memory) {
903         return '';
904     }
905 
906     // =============================================================
907     //                     OWNERSHIPS OPERATIONS
908     // =============================================================
909 
910     /**
911      * @dev Returns the owner of the `tokenId` token.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must exist.
916      */
917     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
918         return address(uint160(_packedOwnershipOf(tokenId)));
919     }
920 
921     /**
922      * @dev Gas spent here starts off proportional to the maximum mint batch size.
923      * It gradually moves to O(1) as tokens get transferred around over time.
924      */
925     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
926         return _unpackedOwnership(_packedOwnershipOf(tokenId));
927     }
928 
929     /**
930      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
931      */
932     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
933         return _unpackedOwnership(_packedOwnerships[index]);
934     }
935 
936     /**
937      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
938      */
939     function _initializeOwnershipAt(uint256 index) internal virtual {
940         if (_packedOwnerships[index] == 0) {
941             _packedOwnerships[index] = _packedOwnershipOf(index);
942         }
943     }
944 
945     /**
946      * Returns the packed ownership data of `tokenId`.
947      */
948     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
949         uint256 curr = tokenId;
950 
951         unchecked {
952             if (_startTokenId() <= curr)
953                 if (curr < _currentIndex) {
954                     uint256 packed = _packedOwnerships[curr];
955                     // If not burned.
956                     if (packed & _BITMASK_BURNED == 0) {
957                         // Invariant:
958                         // There will always be an initialized ownership slot
959                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
960                         // before an unintialized ownership slot
961                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
962                         // Hence, `curr` will not underflow.
963                         //
964                         // We can directly compare the packed value.
965                         // If the address is zero, packed will be zero.
966                         while (packed == 0) {
967                             packed = _packedOwnerships[--curr];
968                         }
969                         return packed;
970                     }
971                 }
972         }
973         revert OwnerQueryForNonexistentToken();
974     }
975 
976     /**
977      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
978      */
979     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
980         ownership.addr = address(uint160(packed));
981         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
982         ownership.burned = packed & _BITMASK_BURNED != 0;
983         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
984     }
985 
986     /**
987      * @dev Packs ownership data into a single uint256.
988      */
989     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
990         assembly {
991             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
992             owner := and(owner, _BITMASK_ADDRESS)
993             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
994             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
995         }
996     }
997 
998     /**
999      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1000      */
1001     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1002         // For branchless setting of the `nextInitialized` flag.
1003         assembly {
1004             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1005             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1006         }
1007     }
1008 
1009     // =============================================================
1010     //                      APPROVAL OPERATIONS
1011     // =============================================================
1012 
1013     /**
1014      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1015      * The approval is cleared when the token is transferred.
1016      *
1017      * Only a single account can be approved at a time, so approving the
1018      * zero address clears previous approvals.
1019      *
1020      * Requirements:
1021      *
1022      * - The caller must own the token or be an approved operator.
1023      * - `tokenId` must exist.
1024      *
1025      * Emits an {Approval} event.
1026      */
1027     function approve(address to, uint256 tokenId) public virtual override {
1028         address owner = ownerOf(tokenId);
1029 
1030         if (_msgSenderERC721A() != owner)
1031             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1032                 revert ApprovalCallerNotOwnerNorApproved();
1033             }
1034 
1035         _tokenApprovals[tokenId].value = to;
1036         emit Approval(owner, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Returns the account approved for `tokenId` token.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      */
1046     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1047         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1048 
1049         return _tokenApprovals[tokenId].value;
1050     }
1051 
1052     /**
1053      * @dev Approve or remove `operator` as an operator for the caller.
1054      * Operators can call {transferFrom} or {safeTransferFrom}
1055      * for any token owned by the caller.
1056      *
1057      * Requirements:
1058      *
1059      * - The `operator` cannot be the caller.
1060      *
1061      * Emits an {ApprovalForAll} event.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1065 
1066         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1067         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1068     }
1069 
1070     /**
1071      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1072      *
1073      * See {setApprovalForAll}.
1074      */
1075     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1076         return _operatorApprovals[owner][operator];
1077     }
1078 
1079     /**
1080      * @dev Returns whether `tokenId` exists.
1081      *
1082      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1083      *
1084      * Tokens start existing when they are minted. See {_mint}.
1085      */
1086     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1087         return
1088             _startTokenId() <= tokenId &&
1089             tokenId < _currentIndex && // If within bounds,
1090             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1091     }
1092 
1093     /**
1094      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1095      */
1096     function _isSenderApprovedOrOwner(
1097         address approvedAddress,
1098         address owner,
1099         address msgSender
1100     ) private pure returns (bool result) {
1101         assembly {
1102             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1103             owner := and(owner, _BITMASK_ADDRESS)
1104             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1105             msgSender := and(msgSender, _BITMASK_ADDRESS)
1106             // `msgSender == owner || msgSender == approvedAddress`.
1107             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1108         }
1109     }
1110 
1111     /**
1112      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1113      */
1114     function _getApprovedSlotAndAddress(uint256 tokenId)
1115         private
1116         view
1117         returns (uint256 approvedAddressSlot, address approvedAddress)
1118     {
1119         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1120         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1121         assembly {
1122             approvedAddressSlot := tokenApproval.slot
1123             approvedAddress := sload(approvedAddressSlot)
1124         }
1125     }
1126 
1127     // =============================================================
1128     //                      TRANSFER OPERATIONS
1129     // =============================================================
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      * - If the caller is not `from`, it must be approved to move this token
1140      * by either {approve} or {setApprovalForAll}.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function transferFrom(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) public virtual override {
1149         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1150 
1151         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1152 
1153         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1154 
1155         // The nested ifs save around 20+ gas over a compound boolean condition.
1156         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1157             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1158 
1159         if (to == address(0)) revert TransferToZeroAddress();
1160 
1161         _beforeTokenTransfers(from, to, tokenId, 1);
1162 
1163         // Clear approvals from the previous owner.
1164         assembly {
1165             if approvedAddress {
1166                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1167                 sstore(approvedAddressSlot, 0)
1168             }
1169         }
1170 
1171         // Underflow of the sender's balance is impossible because we check for
1172         // ownership above and the recipient's balance can't realistically overflow.
1173         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1174         unchecked {
1175             // We can directly increment and decrement the balances.
1176             --_packedAddressData[from]; // Updates: `balance -= 1`.
1177             ++_packedAddressData[to]; // Updates: `balance += 1`.
1178 
1179             // Updates:
1180             // - `address` to the next owner.
1181             // - `startTimestamp` to the timestamp of transfering.
1182             // - `burned` to `false`.
1183             // - `nextInitialized` to `true`.
1184             _packedOwnerships[tokenId] = _packOwnershipData(
1185                 to,
1186                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1187             );
1188 
1189             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1190             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1191                 uint256 nextTokenId = tokenId + 1;
1192                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1193                 if (_packedOwnerships[nextTokenId] == 0) {
1194                     // If the next slot is within bounds.
1195                     if (nextTokenId != _currentIndex) {
1196                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1197                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1198                     }
1199                 }
1200             }
1201         }
1202 
1203         emit Transfer(from, to, tokenId);
1204         _afterTokenTransfers(from, to, tokenId, 1);
1205     }
1206 
1207     /**
1208      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public virtual override {
1215         safeTransferFrom(from, to, tokenId, '');
1216     }
1217 
1218     /**
1219      * @dev Safely transfers `tokenId` token from `from` to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - `from` cannot be the zero address.
1224      * - `to` cannot be the zero address.
1225      * - `tokenId` token must exist and be owned by `from`.
1226      * - If the caller is not `from`, it must be approved to move this token
1227      * by either {approve} or {setApprovalForAll}.
1228      * - If `to` refers to a smart contract, it must implement
1229      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function safeTransferFrom(
1234         address from,
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) public virtual override {
1239         transferFrom(from, to, tokenId);
1240         if (to.code.length != 0)
1241             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1242                 revert TransferToNonERC721ReceiverImplementer();
1243             }
1244     }
1245 
1246     /**
1247      * @dev Hook that is called before a set of serially-ordered token IDs
1248      * are about to be transferred. This includes minting.
1249      * And also called before burning one token.
1250      *
1251      * `startTokenId` - the first token ID to be transferred.
1252      * `quantity` - the amount to be transferred.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, `tokenId` will be burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _beforeTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 
1269     /**
1270      * @dev Hook that is called after a set of serially-ordered token IDs
1271      * have been transferred. This includes minting.
1272      * And also called after one token has been burned.
1273      *
1274      * `startTokenId` - the first token ID to be transferred.
1275      * `quantity` - the amount to be transferred.
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` has been minted for `to`.
1282      * - When `to` is zero, `tokenId` has been burned by `from`.
1283      * - `from` and `to` are never both zero.
1284      */
1285     function _afterTokenTransfers(
1286         address from,
1287         address to,
1288         uint256 startTokenId,
1289         uint256 quantity
1290     ) internal virtual {}
1291 
1292     /**
1293      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1294      *
1295      * `from` - Previous owner of the given token ID.
1296      * `to` - Target address that will receive the token.
1297      * `tokenId` - Token ID to be transferred.
1298      * `_data` - Optional data to send along with the call.
1299      *
1300      * Returns whether the call correctly returned the expected magic value.
1301      */
1302     function _checkContractOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1309             bytes4 retval
1310         ) {
1311             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1312         } catch (bytes memory reason) {
1313             if (reason.length == 0) {
1314                 revert TransferToNonERC721ReceiverImplementer();
1315             } else {
1316                 assembly {
1317                     revert(add(32, reason), mload(reason))
1318                 }
1319             }
1320         }
1321     }
1322 
1323     // =============================================================
1324     //                        MINT OPERATIONS
1325     // =============================================================
1326 
1327     /**
1328      * @dev Mints `quantity` tokens and transfers them to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - `to` cannot be the zero address.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {Transfer} event for each mint.
1336      */
1337     function _mint(address to, uint256 quantity) internal virtual {
1338         uint256 startTokenId = _currentIndex;
1339         if (quantity == 0) revert MintZeroQuantity();
1340 
1341         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1342 
1343         // Overflows are incredibly unrealistic.
1344         // `balance` and `numberMinted` have a maximum limit of 2**64.
1345         // `tokenId` has a maximum limit of 2**256.
1346         unchecked {
1347             // Updates:
1348             // - `balance += quantity`.
1349             // - `numberMinted += quantity`.
1350             //
1351             // We can directly add to the `balance` and `numberMinted`.
1352             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1353 
1354             // Updates:
1355             // - `address` to the owner.
1356             // - `startTimestamp` to the timestamp of minting.
1357             // - `burned` to `false`.
1358             // - `nextInitialized` to `quantity == 1`.
1359             _packedOwnerships[startTokenId] = _packOwnershipData(
1360                 to,
1361                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1362             );
1363 
1364             uint256 toMasked;
1365             uint256 end = startTokenId + quantity;
1366 
1367             // Use assembly to loop and emit the `Transfer` event for gas savings.
1368             assembly {
1369                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1370                 toMasked := and(to, _BITMASK_ADDRESS)
1371                 // Emit the `Transfer` event.
1372                 log4(
1373                     0, // Start of data (0, since no data).
1374                     0, // End of data (0, since no data).
1375                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1376                     0, // `address(0)`.
1377                     toMasked, // `to`.
1378                     startTokenId // `tokenId`.
1379                 )
1380 
1381                 for {
1382                     let tokenId := add(startTokenId, 1)
1383                 } iszero(eq(tokenId, end)) {
1384                     tokenId := add(tokenId, 1)
1385                 } {
1386                     // Emit the `Transfer` event. Similar to above.
1387                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1388                 }
1389             }
1390             if (toMasked == 0) revert MintToZeroAddress();
1391 
1392             _currentIndex = end;
1393         }
1394         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1395     }
1396 
1397     /**
1398      * @dev Mints `quantity` tokens and transfers them to `to`.
1399      *
1400      * This function is intended for efficient minting only during contract creation.
1401      *
1402      * It emits only one {ConsecutiveTransfer} as defined in
1403      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1404      * instead of a sequence of {Transfer} event(s).
1405      *
1406      * Calling this function outside of contract creation WILL make your contract
1407      * non-compliant with the ERC721 standard.
1408      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1409      * {ConsecutiveTransfer} event is only permissible during contract creation.
1410      *
1411      * Requirements:
1412      *
1413      * - `to` cannot be the zero address.
1414      * - `quantity` must be greater than 0.
1415      *
1416      * Emits a {ConsecutiveTransfer} event.
1417      */
1418     function _mintERC2309(address to, uint256 quantity) internal virtual {
1419         uint256 startTokenId = _currentIndex;
1420         if (to == address(0)) revert MintToZeroAddress();
1421         if (quantity == 0) revert MintZeroQuantity();
1422         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1423 
1424         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1425 
1426         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1427         unchecked {
1428             // Updates:
1429             // - `balance += quantity`.
1430             // - `numberMinted += quantity`.
1431             //
1432             // We can directly add to the `balance` and `numberMinted`.
1433             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1434 
1435             // Updates:
1436             // - `address` to the owner.
1437             // - `startTimestamp` to the timestamp of minting.
1438             // - `burned` to `false`.
1439             // - `nextInitialized` to `quantity == 1`.
1440             _packedOwnerships[startTokenId] = _packOwnershipData(
1441                 to,
1442                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1443             );
1444 
1445             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1446 
1447             _currentIndex = startTokenId + quantity;
1448         }
1449         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1450     }
1451 
1452     /**
1453      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1454      *
1455      * Requirements:
1456      *
1457      * - If `to` refers to a smart contract, it must implement
1458      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1459      * - `quantity` must be greater than 0.
1460      *
1461      * See {_mint}.
1462      *
1463      * Emits a {Transfer} event for each mint.
1464      */
1465     function _safeMint(
1466         address to,
1467         uint256 quantity,
1468         bytes memory _data
1469     ) internal virtual {
1470         _mint(to, quantity);
1471 
1472         unchecked {
1473             if (to.code.length != 0) {
1474                 uint256 end = _currentIndex;
1475                 uint256 index = end - quantity;
1476                 do {
1477                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1478                         revert TransferToNonERC721ReceiverImplementer();
1479                     }
1480                 } while (index < end);
1481                 // Reentrancy protection.
1482                 if (_currentIndex != end) revert();
1483             }
1484         }
1485     }
1486 
1487     /**
1488      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1489      */
1490     function _safeMint(address to, uint256 quantity) internal virtual {
1491         _safeMint(to, quantity, '');
1492     }
1493 
1494     // =============================================================
1495     //                        BURN OPERATIONS
1496     // =============================================================
1497 
1498     /**
1499      * @dev Equivalent to `_burn(tokenId, false)`.
1500      */
1501     function _burn(uint256 tokenId) internal virtual {
1502         _burn(tokenId, false);
1503     }
1504 
1505     /**
1506      * @dev Destroys `tokenId`.
1507      * The approval is cleared when the token is burned.
1508      *
1509      * Requirements:
1510      *
1511      * - `tokenId` must exist.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1516         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1517 
1518         address from = address(uint160(prevOwnershipPacked));
1519 
1520         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1521 
1522         if (approvalCheck) {
1523             // The nested ifs save around 20+ gas over a compound boolean condition.
1524             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1525                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1526         }
1527 
1528         _beforeTokenTransfers(from, address(0), tokenId, 1);
1529 
1530         // Clear approvals from the previous owner.
1531         assembly {
1532             if approvedAddress {
1533                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1534                 sstore(approvedAddressSlot, 0)
1535             }
1536         }
1537 
1538         // Underflow of the sender's balance is impossible because we check for
1539         // ownership above and the recipient's balance can't realistically overflow.
1540         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1541         unchecked {
1542             // Updates:
1543             // - `balance -= 1`.
1544             // - `numberBurned += 1`.
1545             //
1546             // We can directly decrement the balance, and increment the number burned.
1547             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1548             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1549 
1550             // Updates:
1551             // - `address` to the last owner.
1552             // - `startTimestamp` to the timestamp of burning.
1553             // - `burned` to `true`.
1554             // - `nextInitialized` to `true`.
1555             _packedOwnerships[tokenId] = _packOwnershipData(
1556                 from,
1557                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1558             );
1559 
1560             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1561             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1562                 uint256 nextTokenId = tokenId + 1;
1563                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1564                 if (_packedOwnerships[nextTokenId] == 0) {
1565                     // If the next slot is within bounds.
1566                     if (nextTokenId != _currentIndex) {
1567                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1568                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1569                     }
1570                 }
1571             }
1572         }
1573 
1574         emit Transfer(from, address(0), tokenId);
1575         _afterTokenTransfers(from, address(0), tokenId, 1);
1576 
1577         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1578         unchecked {
1579             _burnCounter++;
1580         }
1581     }
1582 
1583     // =============================================================
1584     //                     EXTRA DATA OPERATIONS
1585     // =============================================================
1586 
1587     /**
1588      * @dev Directly sets the extra data for the ownership data `index`.
1589      */
1590     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1591         uint256 packed = _packedOwnerships[index];
1592         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1593         uint256 extraDataCasted;
1594         // Cast `extraData` with assembly to avoid redundant masking.
1595         assembly {
1596             extraDataCasted := extraData
1597         }
1598         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1599         _packedOwnerships[index] = packed;
1600     }
1601 
1602     /**
1603      * @dev Called during each token transfer to set the 24bit `extraData` field.
1604      * Intended to be overridden by the cosumer contract.
1605      *
1606      * `previousExtraData` - the value of `extraData` before transfer.
1607      *
1608      * Calling conditions:
1609      *
1610      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1611      * transferred to `to`.
1612      * - When `from` is zero, `tokenId` will be minted for `to`.
1613      * - When `to` is zero, `tokenId` will be burned by `from`.
1614      * - `from` and `to` are never both zero.
1615      */
1616     function _extraData(
1617         address from,
1618         address to,
1619         uint24 previousExtraData
1620     ) internal view virtual returns (uint24) {}
1621 
1622     /**
1623      * @dev Returns the next extra data for the packed ownership data.
1624      * The returned result is shifted into position.
1625      */
1626     function _nextExtraData(
1627         address from,
1628         address to,
1629         uint256 prevOwnershipPacked
1630     ) private view returns (uint256) {
1631         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1632         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1633     }
1634 
1635     // =============================================================
1636     //                       OTHER OPERATIONS
1637     // =============================================================
1638 
1639     /**
1640      * @dev Returns the message sender (defaults to `msg.sender`).
1641      *
1642      * If you are writing GSN compatible contracts, you need to override this function.
1643      */
1644     function _msgSenderERC721A() internal view virtual returns (address) {
1645         return msg.sender;
1646     }
1647 
1648     /**
1649      * @dev Converts a uint256 to its ASCII string decimal representation.
1650      */
1651     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1652         assembly {
1653             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1654             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1655             // We will need 1 32-byte word to store the length,
1656             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1657             str := add(mload(0x40), 0x80)
1658             // Update the free memory pointer to allocate.
1659             mstore(0x40, str)
1660 
1661             // Cache the end of the memory to calculate the length later.
1662             let end := str
1663 
1664             // We write the string from rightmost digit to leftmost digit.
1665             // The following is essentially a do-while loop that also handles the zero case.
1666             // prettier-ignore
1667             for { let temp := value } 1 {} {
1668                 str := sub(str, 1)
1669                 // Write the character to the pointer.
1670                 // The ASCII index of the '0' character is 48.
1671                 mstore8(str, add(48, mod(temp, 10)))
1672                 // Keep dividing `temp` until zero.
1673                 temp := div(temp, 10)
1674                 // prettier-ignore
1675                 if iszero(temp) { break }
1676             }
1677 
1678             let length := sub(end, str)
1679             // Move the pointer 32 bytes leftwards to make room for the length.
1680             str := sub(str, 0x20)
1681             // Store the length.
1682             mstore(str, length)
1683         }
1684     }
1685 }
1686 
1687 // File: contracts/uwag.sol
1688 
1689 
1690 pragma solidity ^0.8.9;
1691 
1692 
1693 
1694 
1695 
1696 
1697 contract UWAG_RELOADED is 
1698      ERC721A, 
1699      IERC2981,
1700      Ownable, 
1701      ReentrancyGuard 
1702 {
1703   using Strings for uint256;
1704   string public hiddenMetadataUri = "ipfs://QmaRsfbhkJnZC8epMs4SLHGRy5FPkQpcM7ypb9F9nRA1iF";
1705   uint256 public maxSupply = 333;
1706   uint256 public mintAmount = 1;
1707 
1708   address public royaltyAddress = 0xdE551e3D1A6c09Bd94d8bdF753055d394126AB86;
1709   uint256 public royalty = 100; // Must be a whole number 7.5% is 75
1710   string public uriPrefix = '';
1711   string public uriSuffix = '.json';
1712   bool public paused = true;
1713   bool public revealed = false;
1714   mapping(address => bool) public addressClaimed; // mark if claimed
1715   constructor() 
1716   ERC721A("UnderWorld Assassins GENESIS RELOADED", "UWAGR") {
1717   }
1718 
1719 /// @dev === MODIFIER ===
1720   modifier mintCompliance() {
1721     require(!paused, 'The sale is paused!');
1722     require(!addressClaimed[_msgSender()], 'Address already claimed!');
1723     require(totalSupply() + mintAmount <= maxSupply, 'Sold out!');
1724     _;
1725   }
1726 
1727 /// @dev === Minting Function - Input ====
1728   function mint() external payable mintCompliance() nonReentrant {
1729       addressClaimed[_msgSender()] = true;
1730       _safeMint(_msgSender(), mintAmount);
1731     }
1732 
1733   function mintForAddress(uint256 _amount, address _receiver) public onlyOwner {
1734     require(totalSupply() + _amount < maxSupply, 'Sold out!');
1735     _safeMint(_receiver, _amount);
1736   }
1737 
1738 /// @dev === Override ERC721A ===
1739   function _startTokenId() internal view virtual override returns (uint256) {
1740       return 1;
1741     }
1742 
1743   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1744     require(_exists(_tokenId), 'Nonexistent token!');
1745     if (revealed == false) {
1746       return hiddenMetadataUri;
1747     }
1748 
1749     string memory currentBaseURI = _baseURI();
1750     return bytes(currentBaseURI).length > 0
1751         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1752         : '';
1753   }
1754 
1755 /// @dev === Owner Control/Configuration Functions ===
1756   function pause() public onlyOwner {
1757     paused = !paused;
1758   }
1759 
1760   function setMintAmount(uint256 _amount) public onlyOwner {
1761     mintAmount = _amount;
1762   }
1763   
1764   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1765     uriPrefix = _uriPrefix;
1766   }
1767 
1768   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1769     uriSuffix = _uriSuffix;
1770   }
1771   
1772   function setRevealed() public onlyOwner {
1773     revealed = true;
1774   }
1775 
1776   function setRoyaltyAddress(address _royaltyAddress) public onlyOwner {
1777     royaltyAddress = _royaltyAddress;
1778   }
1779 
1780   function setRoyaly(uint256 _royalty) external onlyOwner {
1781         royalty = _royalty;
1782   }
1783 
1784 /// @dev === INTERNAL READ-ONLY ===
1785   function _baseURI() internal view virtual override returns (string memory) {
1786     return uriPrefix;
1787   }
1788 
1789 /// @dev === Withdraw ====
1790   function withdraw() public onlyOwner nonReentrant {
1791     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1792     require(os);
1793   }
1794 
1795 //IERC2981 Royalty Standard
1796     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1797         external view override returns (address receiver, uint256 royaltyAmount)
1798     {
1799         require(_exists(tokenId), "Nonexistent token");
1800         return (royaltyAddress, (salePrice * royalty) / 1000);
1801     }                                                
1802 
1803 /// @dev === Support Functions ==
1804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC165) returns (bool) {
1805         return
1806             interfaceId == type(IERC2981).interfaceId ||
1807             super.supportsInterface(interfaceId);
1808     }
1809 }