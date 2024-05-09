1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-06
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19     uint8 private constant _ADDRESS_LENGTH = 20;
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 
77     /**
78      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
79      */
80     function toHexString(address addr) internal pure returns (string memory) {
81         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
82     }
83 }
84 
85 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Contract module that helps prevent reentrant calls to a function.
94  *
95  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
96  * available, which can be applied to functions to make sure there are no nested
97  * (reentrant) calls to them.
98  *
99  * Note that because there is a single `nonReentrant` guard, functions marked as
100  * `nonReentrant` may not call one another. This can be worked around by making
101  * those functions `private`, and then adding `external` `nonReentrant` entry
102  * points to them.
103  *
104  * TIP: If you would like to learn more about reentrancy and alternative ways
105  * to protect against it, check out our blog post
106  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
107  */
108 abstract contract ReentrancyGuard {
109     // Booleans are more expensive than uint256 or any type that takes up a full
110     // word because each write operation emits an extra SLOAD to first read the
111     // slot's contents, replace the bits taken up by the boolean, and then write
112     // back. This is the compiler's defense against contract upgrades and
113     // pointer aliasing, and it cannot be disabled.
114 
115     // The values being non-zero value makes deployment a bit more expensive,
116     // but in exchange the refund on every call to nonReentrant will be lower in
117     // amount. Since refunds are capped to a percentage of the total
118     // transaction's gas, it is best to keep them low in cases like this one, to
119     // increase the likelihood of the full refund coming into effect.
120     uint256 private constant _NOT_ENTERED = 1;
121     uint256 private constant _ENTERED = 2;
122 
123     uint256 private _status;
124 
125     constructor() {
126         _status = _NOT_ENTERED;
127     }
128 
129     /**
130      * @dev Prevents a contract from calling itself, directly or indirectly.
131      * Calling a `nonReentrant` function from another `nonReentrant`
132      * function is not supported. It is possible to prevent this from happening
133      * by making the `nonReentrant` function external, and making it call a
134      * `private` function that does the actual work.
135      */
136     modifier nonReentrant() {
137         // On the first call to nonReentrant, _notEntered will be true
138         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
139 
140         // Any calls to nonReentrant after this point will fail
141         _status = _ENTERED;
142 
143         _;
144 
145         // By storing the original value once again, a refund is triggered (see
146         // https://eips.ethereum.org/EIPS/eip-2200)
147         _status = _NOT_ENTERED;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Context.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev Provides information about the current execution context, including the
160  * sender of the transaction and its data. While these are generally available
161  * via msg.sender and msg.data, they should not be accessed in such a direct
162  * manner, since when dealing with meta-transactions the account sending and
163  * paying for execution may not be the actual sender (as far as an application
164  * is concerned).
165  *
166  * This contract is only required for intermediate, library-like contracts.
167  */
168 abstract contract Context {
169     function _msgSender() internal view virtual returns (address) {
170         return msg.sender;
171     }
172 
173     function _msgData() internal view virtual returns (bytes calldata) {
174         return msg.data;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/access/Ownable.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @dev Contract module which provides a basic access control mechanism, where
188  * there is an account (an owner) that can be granted exclusive access to
189  * specific functions.
190  *
191  * By default, the owner account will be the one that deploys the contract. This
192  * can later be changed with {transferOwnership}.
193  *
194  * This module is used through inheritance. It will make available the modifier
195  * `onlyOwner`, which can be applied to your functions to restrict their use to
196  * the owner.
197  */
198 abstract contract Ownable is Context {
199     address private _owner;
200 
201     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203     /**
204      * @dev Initializes the contract setting the deployer as the initial owner.
205      */
206     constructor() {
207         _transferOwnership(_msgSender());
208     }
209 
210     /**
211      * @dev Throws if called by any account other than the owner.
212      */
213     modifier onlyOwner() {
214         _checkOwner();
215         _;
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view virtual returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if the sender is not the owner.
227      */
228     function _checkOwner() internal view virtual {
229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
230     }
231 
232     /**
233      * @dev Leaves the contract without owner. It will not be possible to call
234      * `onlyOwner` functions anymore. Can only be called by the current owner.
235      *
236      * NOTE: Renouncing ownership will leave the contract without an owner,
237      * thereby removing any functionality that is only available to the owner.
238      */
239     function renounceOwnership() public virtual onlyOwner {
240         _transferOwnership(address(0));
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public virtual onlyOwner {
248         require(newOwner != address(0), "Ownable: new owner is the zero address");
249         _transferOwnership(newOwner);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Internal function without access restriction.
255      */
256     function _transferOwnership(address newOwner) internal virtual {
257         address oldOwner = _owner;
258         _owner = newOwner;
259         emit OwnershipTransferred(oldOwner, newOwner);
260     }
261 }
262 
263 // File: erc721a/contracts/IERC721A.sol
264 
265 
266 // ERC721A Contracts v4.2.2
267 // Creator: Chiru Labs
268 
269 pragma solidity ^0.8.4;
270 
271 /**
272  * @dev Interface of ERC721A.
273  */
274 interface IERC721A {
275     /**
276      * The caller must own the token or be an approved operator.
277      */
278     error ApprovalCallerNotOwnerNorApproved();
279 
280     /**
281      * The token does not exist.
282      */
283     error ApprovalQueryForNonexistentToken();
284 
285     /**
286      * The caller cannot approve to their own address.
287      */
288     error ApproveToCaller();
289 
290     /**
291      * Cannot query the balance for the zero address.
292      */
293     error BalanceQueryForZeroAddress();
294 
295     /**
296      * Cannot mint to the zero address.
297      */
298     error MintToZeroAddress();
299 
300     /**
301      * The quantity of tokens minted must be more than zero.
302      */
303     error MintZeroQuantity();
304 
305     /**
306      * The token does not exist.
307      */
308     error OwnerQueryForNonexistentToken();
309 
310     /**
311      * The caller must own the token or be an approved operator.
312      */
313     error TransferCallerNotOwnerNorApproved();
314 
315     /**
316      * The token must be owned by `from`.
317      */
318     error TransferFromIncorrectOwner();
319 
320     /**
321      * Cannot safely transfer to a contract that does not implement the
322      * ERC721Receiver interface.
323      */
324     error TransferToNonERC721ReceiverImplementer();
325 
326     /**
327      * Cannot transfer to the zero address.
328      */
329     error TransferToZeroAddress();
330 
331     /**
332      * The token does not exist.
333      */
334     error URIQueryForNonexistentToken();
335 
336     /**
337      * The `quantity` minted with ERC2309 exceeds the safety limit.
338      */
339     error MintERC2309QuantityExceedsLimit();
340 
341     /**
342      * The `extraData` cannot be set on an unintialized ownership slot.
343      */
344     error OwnershipNotInitializedForExtraData();
345 
346     // =============================================================
347     //                            STRUCTS
348     // =============================================================
349 
350     struct TokenOwnership {
351         // The address of the owner.
352         address addr;
353         // Stores the start time of ownership with minimal overhead for tokenomics.
354         uint64 startTimestamp;
355         // Whether the token has been burned.
356         bool burned;
357         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
358         uint24 extraData;
359     }
360 
361     // =============================================================
362     //                         TOKEN COUNTERS
363     // =============================================================
364 
365     /**
366      * @dev Returns the total number of tokens in existence.
367      * Burned tokens will reduce the count.
368      * To get the total number of tokens minted, please see {_totalMinted}.
369      */
370     function totalSupply() external view returns (uint256);
371 
372     // =============================================================
373     //                            IERC165
374     // =============================================================
375 
376     /**
377      * @dev Returns true if this contract implements the interface defined by
378      * `interfaceId`. See the corresponding
379      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
380      * to learn more about how these ids are created.
381      *
382      * This function call must use less than 30000 gas.
383      */
384     function supportsInterface(bytes4 interfaceId) external view returns (bool);
385 
386     // =============================================================
387     //                            IERC721
388     // =============================================================
389 
390     /**
391      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
392      */
393     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
397      */
398     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
399 
400     /**
401      * @dev Emitted when `owner` enables or disables
402      * (`approved`) `operator` to manage all of its assets.
403      */
404     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
405 
406     /**
407      * @dev Returns the number of tokens in `owner`'s account.
408      */
409     function balanceOf(address owner) external view returns (uint256 balance);
410 
411     /**
412      * @dev Returns the owner of the `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function ownerOf(uint256 tokenId) external view returns (address owner);
419 
420     /**
421      * @dev Safely transfers `tokenId` token from `from` to `to`,
422      * checking first that contract recipients are aware of the ERC721 protocol
423      * to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move
431      * this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement
433      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId,
441         bytes calldata data
442     ) external;
443 
444     /**
445      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Transfers `tokenId` from `from` to `to`.
455      *
456      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
457      * whenever possible.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must be owned by `from`.
464      * - If the caller is not `from`, it must be approved to move this token
465      * by either {approve} or {setApprovalForAll}.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(
470         address from,
471         address to,
472         uint256 tokenId
473     ) external;
474 
475     /**
476      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
477      * The approval is cleared when the token is transferred.
478      *
479      * Only a single account can be approved at a time, so approving the
480      * zero address clears previous approvals.
481      *
482      * Requirements:
483      *
484      * - The caller must own the token or be an approved operator.
485      * - `tokenId` must exist.
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address to, uint256 tokenId) external;
490 
491     /**
492      * @dev Approve or remove `operator` as an operator for the caller.
493      * Operators can call {transferFrom} or {safeTransferFrom}
494      * for any token owned by the caller.
495      *
496      * Requirements:
497      *
498      * - The `operator` cannot be the caller.
499      *
500      * Emits an {ApprovalForAll} event.
501      */
502     function setApprovalForAll(address operator, bool _approved) external;
503 
504     /**
505      * @dev Returns the account approved for `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function getApproved(uint256 tokenId) external view returns (address operator);
512 
513     /**
514      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
515      *
516      * See {setApprovalForAll}.
517      */
518     function isApprovedForAll(address owner, address operator) external view returns (bool);
519 
520     // =============================================================
521     //                        IERC721Metadata
522     // =============================================================
523 
524     /**
525      * @dev Returns the token collection name.
526      */
527     function name() external view returns (string memory);
528 
529     /**
530      * @dev Returns the token collection symbol.
531      */
532     function symbol() external view returns (string memory);
533 
534     /**
535      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
536      */
537     function tokenURI(uint256 tokenId) external view returns (string memory);
538 
539     // =============================================================
540     //                           IERC2309
541     // =============================================================
542 
543     /**
544      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
545      * (inclusive) is transferred from `from` to `to`, as defined in the
546      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
547      *
548      * See {_mintERC2309} for more details.
549      */
550     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
551 }
552 
553 // File: erc721a/contracts/ERC721A.sol
554 
555 
556 // ERC721A Contracts v4.2.2
557 // Creator: Chiru Labs
558 
559 pragma solidity ^0.8.4;
560 
561 
562 /**
563  * @dev Interface of ERC721 token receiver.
564  */
565 interface ERC721A__IERC721Receiver {
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 /**
575  * @title ERC721A
576  *
577  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
578  * Non-Fungible Token Standard, including the Metadata extension.
579  * Optimized for lower gas during batch mints.
580  *
581  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
582  * starting from `_startTokenId()`.
583  *
584  * Assumptions:
585  *
586  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
587  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
588  */
589 contract ERC721A is IERC721A {
590     // Reference type for token approval.
591     struct TokenApprovalRef {
592         address value;
593     }
594 
595     // =============================================================
596     //                           CONSTANTS
597     // =============================================================
598 
599     // Mask of an entry in packed address data.
600     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
601 
602     // The bit position of `numberMinted` in packed address data.
603     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
604 
605     // The bit position of `numberBurned` in packed address data.
606     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
607 
608     // The bit position of `aux` in packed address data.
609     uint256 private constant _BITPOS_AUX = 192;
610 
611     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
612     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
613 
614     // The bit position of `startTimestamp` in packed ownership.
615     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
616 
617     // The bit mask of the `burned` bit in packed ownership.
618     uint256 private constant _BITMASK_BURNED = 1 << 224;
619 
620     // The bit position of the `nextInitialized` bit in packed ownership.
621     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
622 
623     // The bit mask of the `nextInitialized` bit in packed ownership.
624     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
625 
626     // The bit position of `extraData` in packed ownership.
627     uint256 private constant _BITPOS_EXTRA_DATA = 232;
628 
629     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
630     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
631 
632     // The mask of the lower 160 bits for addresses.
633     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
634 
635     // The maximum `quantity` that can be minted with {_mintERC2309}.
636     // This limit is to prevent overflows on the address data entries.
637     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
638     // is required to cause an overflow, which is unrealistic.
639     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
640 
641     // The `Transfer` event signature is given by:
642     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
643     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
644         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
645 
646     // =============================================================
647     //                            STORAGE
648     // =============================================================
649 
650     // The next token ID to be minted.
651     uint256 private _currentIndex;
652 
653     // The number of tokens burned.
654     uint256 private _burnCounter;
655 
656     // Token name
657     string private _name;
658 
659     // Token symbol
660     string private _symbol;
661 
662     // Mapping from token ID to ownership details
663     // An empty struct value does not necessarily mean the token is unowned.
664     // See {_packedOwnershipOf} implementation for details.
665     //
666     // Bits Layout:
667     // - [0..159]   `addr`
668     // - [160..223] `startTimestamp`
669     // - [224]      `burned`
670     // - [225]      `nextInitialized`
671     // - [232..255] `extraData`
672     mapping(uint256 => uint256) private _packedOwnerships;
673 
674     // Mapping owner address to address data.
675     //
676     // Bits Layout:
677     // - [0..63]    `balance`
678     // - [64..127]  `numberMinted`
679     // - [128..191] `numberBurned`
680     // - [192..255] `aux`
681     mapping(address => uint256) private _packedAddressData;
682 
683     // Mapping from token ID to approved address.
684     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     // =============================================================
690     //                          CONSTRUCTOR
691     // =============================================================
692 
693     constructor(string memory name_, string memory symbol_) {
694         _name = name_;
695         _symbol = symbol_;
696         _currentIndex = _startTokenId();
697     }
698 
699     // =============================================================
700     //                   TOKEN COUNTING OPERATIONS
701     // =============================================================
702 
703     /**
704      * @dev Returns the starting token ID.
705      * To change the starting token ID, please override this function.
706      */
707     function _startTokenId() internal view virtual returns (uint256) {
708         return 0;
709     }
710 
711     /**
712      * @dev Returns the next token ID to be minted.
713      */
714     function _nextTokenId() internal view virtual returns (uint256) {
715         return _currentIndex;
716     }
717 
718     /**
719      * @dev Returns the total number of tokens in existence.
720      * Burned tokens will reduce the count.
721      * To get the total number of tokens minted, please see {_totalMinted}.
722      */
723     function totalSupply() public view virtual override returns (uint256) {
724         // Counter underflow is impossible as _burnCounter cannot be incremented
725         // more than `_currentIndex - _startTokenId()` times.
726         unchecked {
727             return _currentIndex - _burnCounter - _startTokenId();
728         }
729     }
730 
731     /**
732      * @dev Returns the total amount of tokens minted in the contract.
733      */
734     function _totalMinted() internal view virtual returns (uint256) {
735         // Counter underflow is impossible as `_currentIndex` does not decrement,
736         // and it is initialized to `_startTokenId()`.
737         unchecked {
738             return _currentIndex - _startTokenId();
739         }
740     }
741 
742     /**
743      * @dev Returns the total number of tokens burned.
744      */
745     function _totalBurned() internal view virtual returns (uint256) {
746         return _burnCounter;
747     }
748 
749     // =============================================================
750     //                    ADDRESS DATA OPERATIONS
751     // =============================================================
752 
753     /**
754      * @dev Returns the number of tokens in `owner`'s account.
755      */
756     function balanceOf(address owner) public view virtual override returns (uint256) {
757         if (owner == address(0)) revert BalanceQueryForZeroAddress();
758         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
759     }
760 
761     /**
762      * Returns the number of tokens minted by `owner`.
763      */
764     function _numberMinted(address owner) internal view returns (uint256) {
765         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
766     }
767 
768     /**
769      * Returns the number of tokens burned by or on behalf of `owner`.
770      */
771     function _numberBurned(address owner) internal view returns (uint256) {
772         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
773     }
774 
775     /**
776      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
777      */
778     function _getAux(address owner) internal view returns (uint64) {
779         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
780     }
781 
782     /**
783      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
784      * If there are multiple variables, please pack them into a uint64.
785      */
786     function _setAux(address owner, uint64 aux) internal virtual {
787         uint256 packed = _packedAddressData[owner];
788         uint256 auxCasted;
789         // Cast `aux` with assembly to avoid redundant masking.
790         assembly {
791             auxCasted := aux
792         }
793         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
794         _packedAddressData[owner] = packed;
795     }
796 
797     // =============================================================
798     //                            IERC165
799     // =============================================================
800 
801     /**
802      * @dev Returns true if this contract implements the interface defined by
803      * `interfaceId`. See the corresponding
804      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
805      * to learn more about how these ids are created.
806      *
807      * This function call must use less than 30000 gas.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
810         // The interface IDs are constants representing the first 4 bytes
811         // of the XOR of all function selectors in the interface.
812         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
813         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
814         return
815             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
816             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
817             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
818     }
819 
820     // =============================================================
821     //                        IERC721Metadata
822     // =============================================================
823 
824     /**
825      * @dev Returns the token collection name.
826      */
827     function name() public view virtual override returns (string memory) {
828         return _name;
829     }
830 
831     /**
832      * @dev Returns the token collection symbol.
833      */
834     function symbol() public view virtual override returns (string memory) {
835         return _symbol;
836     }
837 
838     /**
839      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
840      */
841     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
842         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
843 
844         string memory baseURI = _baseURI();
845         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
846     }
847 
848     /**
849      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
850      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
851      * by default, it can be overridden in child contracts.
852      */
853     function _baseURI() internal view virtual returns (string memory) {
854         return '';
855     }
856 
857     // =============================================================
858     //                     OWNERSHIPS OPERATIONS
859     // =============================================================
860 
861     /**
862      * @dev Returns the owner of the `tokenId` token.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      */
868     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
869         return address(uint160(_packedOwnershipOf(tokenId)));
870     }
871 
872     /**
873      * @dev Gas spent here starts off proportional to the maximum mint batch size.
874      * It gradually moves to O(1) as tokens get transferred around over time.
875      */
876     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
877         return _unpackedOwnership(_packedOwnershipOf(tokenId));
878     }
879 
880     /**
881      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
882      */
883     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
884         return _unpackedOwnership(_packedOwnerships[index]);
885     }
886 
887     /**
888      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
889      */
890     function _initializeOwnershipAt(uint256 index) internal virtual {
891         if (_packedOwnerships[index] == 0) {
892             _packedOwnerships[index] = _packedOwnershipOf(index);
893         }
894     }
895 
896     /**
897      * Returns the packed ownership data of `tokenId`.
898      */
899     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr)
904                 if (curr < _currentIndex) {
905                     uint256 packed = _packedOwnerships[curr];
906                     // If not burned.
907                     if (packed & _BITMASK_BURNED == 0) {
908                         // Invariant:
909                         // There will always be an initialized ownership slot
910                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
911                         // before an unintialized ownership slot
912                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
913                         // Hence, `curr` will not underflow.
914                         //
915                         // We can directly compare the packed value.
916                         // If the address is zero, packed will be zero.
917                         while (packed == 0) {
918                             packed = _packedOwnerships[--curr];
919                         }
920                         return packed;
921                     }
922                 }
923         }
924         revert OwnerQueryForNonexistentToken();
925     }
926 
927     /**
928      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
929      */
930     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
931         ownership.addr = address(uint160(packed));
932         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
933         ownership.burned = packed & _BITMASK_BURNED != 0;
934         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
935     }
936 
937     /**
938      * @dev Packs ownership data into a single uint256.
939      */
940     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
941         assembly {
942             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
943             owner := and(owner, _BITMASK_ADDRESS)
944             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
945             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
946         }
947     }
948 
949     /**
950      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
951      */
952     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
953         // For branchless setting of the `nextInitialized` flag.
954         assembly {
955             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
956             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
957         }
958     }
959 
960     // =============================================================
961     //                      APPROVAL OPERATIONS
962     // =============================================================
963 
964     /**
965      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
966      * The approval is cleared when the token is transferred.
967      *
968      * Only a single account can be approved at a time, so approving the
969      * zero address clears previous approvals.
970      *
971      * Requirements:
972      *
973      * - The caller must own the token or be an approved operator.
974      * - `tokenId` must exist.
975      *
976      * Emits an {Approval} event.
977      */
978     function approve(address to, uint256 tokenId) public virtual override {
979         address owner = ownerOf(tokenId);
980 
981         if (_msgSenderERC721A() != owner)
982             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
983                 revert ApprovalCallerNotOwnerNorApproved();
984             }
985 
986         _tokenApprovals[tokenId].value = to;
987         emit Approval(owner, to, tokenId);
988     }
989 
990     /**
991      * @dev Returns the account approved for `tokenId` token.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function getApproved(uint256 tokenId) public view virtual override returns (address) {
998         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
999 
1000         return _tokenApprovals[tokenId].value;
1001     }
1002 
1003     /**
1004      * @dev Approve or remove `operator` as an operator for the caller.
1005      * Operators can call {transferFrom} or {safeTransferFrom}
1006      * for any token owned by the caller.
1007      *
1008      * Requirements:
1009      *
1010      * - The `operator` cannot be the caller.
1011      *
1012      * Emits an {ApprovalForAll} event.
1013      */
1014     function setApprovalForAll(address operator, bool approved) public virtual override {
1015         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1016 
1017         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1018         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1019     }
1020 
1021     /**
1022      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1023      *
1024      * See {setApprovalForAll}.
1025      */
1026     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1027         return _operatorApprovals[owner][operator];
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted. See {_mint}.
1036      */
1037     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1038         return
1039             _startTokenId() <= tokenId &&
1040             tokenId < _currentIndex && // If within bounds,
1041             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1042     }
1043 
1044     /**
1045      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1046      */
1047     function _isSenderApprovedOrOwner(
1048         address approvedAddress,
1049         address owner,
1050         address msgSender
1051     ) private pure returns (bool result) {
1052         assembly {
1053             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1054             owner := and(owner, _BITMASK_ADDRESS)
1055             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056             msgSender := and(msgSender, _BITMASK_ADDRESS)
1057             // `msgSender == owner || msgSender == approvedAddress`.
1058             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1064      */
1065     function _getApprovedSlotAndAddress(uint256 tokenId)
1066         private
1067         view
1068         returns (uint256 approvedAddressSlot, address approvedAddress)
1069     {
1070         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1071         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1072         assembly {
1073             approvedAddressSlot := tokenApproval.slot
1074             approvedAddress := sload(approvedAddressSlot)
1075         }
1076     }
1077 
1078     // =============================================================
1079     //                      TRANSFER OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must be owned by `from`.
1090      * - If the caller is not `from`, it must be approved to move this token
1091      * by either {approve} or {setApprovalForAll}.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function transferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1101 
1102         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1103 
1104         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1105 
1106         // The nested ifs save around 20+ gas over a compound boolean condition.
1107         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1108             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1109 
1110         if (to == address(0)) revert TransferToZeroAddress();
1111 
1112         _beforeTokenTransfers(from, to, tokenId, 1);
1113 
1114         // Clear approvals from the previous owner.
1115         assembly {
1116             if approvedAddress {
1117                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1118                 sstore(approvedAddressSlot, 0)
1119             }
1120         }
1121 
1122         // Underflow of the sender's balance is impossible because we check for
1123         // ownership above and the recipient's balance can't realistically overflow.
1124         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1125         unchecked {
1126             // We can directly increment and decrement the balances.
1127             --_packedAddressData[from]; // Updates: `balance -= 1`.
1128             ++_packedAddressData[to]; // Updates: `balance += 1`.
1129 
1130             // Updates:
1131             // - `address` to the next owner.
1132             // - `startTimestamp` to the timestamp of transfering.
1133             // - `burned` to `false`.
1134             // - `nextInitialized` to `true`.
1135             _packedOwnerships[tokenId] = _packOwnershipData(
1136                 to,
1137                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1138             );
1139 
1140             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1141             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1142                 uint256 nextTokenId = tokenId + 1;
1143                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1144                 if (_packedOwnerships[nextTokenId] == 0) {
1145                     // If the next slot is within bounds.
1146                     if (nextTokenId != _currentIndex) {
1147                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1148                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1149                     }
1150                 }
1151             }
1152         }
1153 
1154         emit Transfer(from, to, tokenId);
1155         _afterTokenTransfers(from, to, tokenId, 1);
1156     }
1157 
1158     /**
1159      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1160      */
1161     function safeTransferFrom(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) public virtual override {
1166         safeTransferFrom(from, to, tokenId, '');
1167     }
1168 
1169     /**
1170      * @dev Safely transfers `tokenId` token from `from` to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must exist and be owned by `from`.
1177      * - If the caller is not `from`, it must be approved to move this token
1178      * by either {approve} or {setApprovalForAll}.
1179      * - If `to` refers to a smart contract, it must implement
1180      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function safeTransferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) public virtual override {
1190         transferFrom(from, to, tokenId);
1191         if (to.code.length != 0)
1192             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1193                 revert TransferToNonERC721ReceiverImplementer();
1194             }
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before a set of serially-ordered token IDs
1199      * are about to be transferred. This includes minting.
1200      * And also called before burning one token.
1201      *
1202      * `startTokenId` - the first token ID to be transferred.
1203      * `quantity` - the amount to be transferred.
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` will be minted for `to`.
1210      * - When `to` is zero, `tokenId` will be burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _beforeTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 
1220     /**
1221      * @dev Hook that is called after a set of serially-ordered token IDs
1222      * have been transferred. This includes minting.
1223      * And also called after one token has been burned.
1224      *
1225      * `startTokenId` - the first token ID to be transferred.
1226      * `quantity` - the amount to be transferred.
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` has been minted for `to`.
1233      * - When `to` is zero, `tokenId` has been burned by `from`.
1234      * - `from` and `to` are never both zero.
1235      */
1236     function _afterTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * `from` - Previous owner of the given token ID.
1247      * `to` - Target address that will receive the token.
1248      * `tokenId` - Token ID to be transferred.
1249      * `_data` - Optional data to send along with the call.
1250      *
1251      * Returns whether the call correctly returned the expected magic value.
1252      */
1253     function _checkContractOnERC721Received(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) private returns (bool) {
1259         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1260             bytes4 retval
1261         ) {
1262             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1263         } catch (bytes memory reason) {
1264             if (reason.length == 0) {
1265                 revert TransferToNonERC721ReceiverImplementer();
1266             } else {
1267                 assembly {
1268                     revert(add(32, reason), mload(reason))
1269                 }
1270             }
1271         }
1272     }
1273 
1274     // =============================================================
1275     //                        MINT OPERATIONS
1276     // =============================================================
1277 
1278     /**
1279      * @dev Mints `quantity` tokens and transfers them to `to`.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `quantity` must be greater than 0.
1285      *
1286      * Emits a {Transfer} event for each mint.
1287      */
1288     function _mint(address to, uint256 quantity) internal virtual {
1289         uint256 startTokenId = _currentIndex;
1290         if (quantity == 0) revert MintZeroQuantity();
1291 
1292         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1293 
1294         // Overflows are incredibly unrealistic.
1295         // `balance` and `numberMinted` have a maximum limit of 2**64.
1296         // `tokenId` has a maximum limit of 2**256.
1297         unchecked {
1298             // Updates:
1299             // - `balance += quantity`.
1300             // - `numberMinted += quantity`.
1301             //
1302             // We can directly add to the `balance` and `numberMinted`.
1303             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1304 
1305             // Updates:
1306             // - `address` to the owner.
1307             // - `startTimestamp` to the timestamp of minting.
1308             // - `burned` to `false`.
1309             // - `nextInitialized` to `quantity == 1`.
1310             _packedOwnerships[startTokenId] = _packOwnershipData(
1311                 to,
1312                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1313             );
1314 
1315             uint256 toMasked;
1316             uint256 end = startTokenId + quantity;
1317 
1318             // Use assembly to loop and emit the `Transfer` event for gas savings.
1319             assembly {
1320                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1321                 toMasked := and(to, _BITMASK_ADDRESS)
1322                 // Emit the `Transfer` event.
1323                 log4(
1324                     0, // Start of data (0, since no data).
1325                     0, // End of data (0, since no data).
1326                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1327                     0, // `address(0)`.
1328                     toMasked, // `to`.
1329                     startTokenId // `tokenId`.
1330                 )
1331 
1332                 for {
1333                     let tokenId := add(startTokenId, 1)
1334                 } iszero(eq(tokenId, end)) {
1335                     tokenId := add(tokenId, 1)
1336                 } {
1337                     // Emit the `Transfer` event. Similar to above.
1338                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1339                 }
1340             }
1341             if (toMasked == 0) revert MintToZeroAddress();
1342 
1343             _currentIndex = end;
1344         }
1345         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1346     }
1347 
1348     /**
1349      * @dev Mints `quantity` tokens and transfers them to `to`.
1350      *
1351      * This function is intended for efficient minting only during contract creation.
1352      *
1353      * It emits only one {ConsecutiveTransfer} as defined in
1354      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1355      * instead of a sequence of {Transfer} event(s).
1356      *
1357      * Calling this function outside of contract creation WILL make your contract
1358      * non-compliant with the ERC721 standard.
1359      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1360      * {ConsecutiveTransfer} event is only permissible during contract creation.
1361      *
1362      * Requirements:
1363      *
1364      * - `to` cannot be the zero address.
1365      * - `quantity` must be greater than 0.
1366      *
1367      * Emits a {ConsecutiveTransfer} event.
1368      */
1369     function _mintERC2309(address to, uint256 quantity) internal virtual {
1370         uint256 startTokenId = _currentIndex;
1371         if (to == address(0)) revert MintToZeroAddress();
1372         if (quantity == 0) revert MintZeroQuantity();
1373         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1374 
1375         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1376 
1377         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1378         unchecked {
1379             // Updates:
1380             // - `balance += quantity`.
1381             // - `numberMinted += quantity`.
1382             //
1383             // We can directly add to the `balance` and `numberMinted`.
1384             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1385 
1386             // Updates:
1387             // - `address` to the owner.
1388             // - `startTimestamp` to the timestamp of minting.
1389             // - `burned` to `false`.
1390             // - `nextInitialized` to `quantity == 1`.
1391             _packedOwnerships[startTokenId] = _packOwnershipData(
1392                 to,
1393                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1394             );
1395 
1396             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1397 
1398             _currentIndex = startTokenId + quantity;
1399         }
1400         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1401     }
1402 
1403     /**
1404      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1405      *
1406      * Requirements:
1407      *
1408      * - If `to` refers to a smart contract, it must implement
1409      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1410      * - `quantity` must be greater than 0.
1411      *
1412      * See {_mint}.
1413      *
1414      * Emits a {Transfer} event for each mint.
1415      */
1416     function _safeMint(
1417         address to,
1418         uint256 quantity,
1419         bytes memory _data
1420     ) internal virtual {
1421         _mint(to, quantity);
1422 
1423         unchecked {
1424             if (to.code.length != 0) {
1425                 uint256 end = _currentIndex;
1426                 uint256 index = end - quantity;
1427                 do {
1428                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1429                         revert TransferToNonERC721ReceiverImplementer();
1430                     }
1431                 } while (index < end);
1432                 // Reentrancy protection.
1433                 if (_currentIndex != end) revert();
1434             }
1435         }
1436     }
1437 
1438     /**
1439      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1440      */
1441     function _safeMint(address to, uint256 quantity) internal virtual {
1442         _safeMint(to, quantity, '');
1443     }
1444 
1445     // =============================================================
1446     //                        BURN OPERATIONS
1447     // =============================================================
1448 
1449     /**
1450      * @dev Equivalent to `_burn(tokenId, false)`.
1451      */
1452     function _burn(uint256 tokenId) internal virtual {
1453         _burn(tokenId, false);
1454     }
1455 
1456     /**
1457      * @dev Destroys `tokenId`.
1458      * The approval is cleared when the token is burned.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1467         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1468 
1469         address from = address(uint160(prevOwnershipPacked));
1470 
1471         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1472 
1473         if (approvalCheck) {
1474             // The nested ifs save around 20+ gas over a compound boolean condition.
1475             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1476                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1477         }
1478 
1479         _beforeTokenTransfers(from, address(0), tokenId, 1);
1480 
1481         // Clear approvals from the previous owner.
1482         assembly {
1483             if approvedAddress {
1484                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1485                 sstore(approvedAddressSlot, 0)
1486             }
1487         }
1488 
1489         // Underflow of the sender's balance is impossible because we check for
1490         // ownership above and the recipient's balance can't realistically overflow.
1491         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1492         unchecked {
1493             // Updates:
1494             // - `balance -= 1`.
1495             // - `numberBurned += 1`.
1496             //
1497             // We can directly decrement the balance, and increment the number burned.
1498             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1499             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1500 
1501             // Updates:
1502             // - `address` to the last owner.
1503             // - `startTimestamp` to the timestamp of burning.
1504             // - `burned` to `true`.
1505             // - `nextInitialized` to `true`.
1506             _packedOwnerships[tokenId] = _packOwnershipData(
1507                 from,
1508                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1509             );
1510 
1511             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1512             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1513                 uint256 nextTokenId = tokenId + 1;
1514                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1515                 if (_packedOwnerships[nextTokenId] == 0) {
1516                     // If the next slot is within bounds.
1517                     if (nextTokenId != _currentIndex) {
1518                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1519                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1520                     }
1521                 }
1522             }
1523         }
1524 
1525         emit Transfer(from, address(0), tokenId);
1526         _afterTokenTransfers(from, address(0), tokenId, 1);
1527 
1528         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1529         unchecked {
1530             _burnCounter++;
1531         }
1532     }
1533 
1534     // =============================================================
1535     //                     EXTRA DATA OPERATIONS
1536     // =============================================================
1537 
1538     /**
1539      * @dev Directly sets the extra data for the ownership data `index`.
1540      */
1541     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1542         uint256 packed = _packedOwnerships[index];
1543         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1544         uint256 extraDataCasted;
1545         // Cast `extraData` with assembly to avoid redundant masking.
1546         assembly {
1547             extraDataCasted := extraData
1548         }
1549         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1550         _packedOwnerships[index] = packed;
1551     }
1552 
1553     /**
1554      * @dev Called during each token transfer to set the 24bit `extraData` field.
1555      * Intended to be overridden by the cosumer contract.
1556      *
1557      * `previousExtraData` - the value of `extraData` before transfer.
1558      *
1559      * Calling conditions:
1560      *
1561      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1562      * transferred to `to`.
1563      * - When `from` is zero, `tokenId` will be minted for `to`.
1564      * - When `to` is zero, `tokenId` will be burned by `from`.
1565      * - `from` and `to` are never both zero.
1566      */
1567     function _extraData(
1568         address from,
1569         address to,
1570         uint24 previousExtraData
1571     ) internal view virtual returns (uint24) {}
1572 
1573     /**
1574      * @dev Returns the next extra data for the packed ownership data.
1575      * The returned result is shifted into position.
1576      */
1577     function _nextExtraData(
1578         address from,
1579         address to,
1580         uint256 prevOwnershipPacked
1581     ) private view returns (uint256) {
1582         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1583         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1584     }
1585 
1586     // =============================================================
1587     //                       OTHER OPERATIONS
1588     // =============================================================
1589 
1590     /**
1591      * @dev Returns the message sender (defaults to `msg.sender`).
1592      *
1593      * If you are writing GSN compatible contracts, you need to override this function.
1594      */
1595     function _msgSenderERC721A() internal view virtual returns (address) {
1596         return msg.sender;
1597     }
1598 
1599     /**
1600      * @dev Converts a uint256 to its ASCII string decimal representation.
1601      */
1602     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1603         assembly {
1604             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1605             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1606             // We will need 1 32-byte word to store the length,
1607             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1608             str := add(mload(0x40), 0x80)
1609             // Update the free memory pointer to allocate.
1610             mstore(0x40, str)
1611 
1612             // Cache the end of the memory to calculate the length later.
1613             let end := str
1614 
1615             // We write the string from rightmost digit to leftmost digit.
1616             // The following is essentially a do-while loop that also handles the zero case.
1617             // prettier-ignore
1618             for { let temp := value } 1 {} {
1619                 str := sub(str, 1)
1620                 // Write the character to the pointer.
1621                 // The ASCII index of the '0' character is 48.
1622                 mstore8(str, add(48, mod(temp, 10)))
1623                 // Keep dividing `temp` until zero.
1624                 temp := div(temp, 10)
1625                 // prettier-ignore
1626                 if iszero(temp) { break }
1627             }
1628 
1629             let length := sub(end, str)
1630             // Move the pointer 32 bytes leftwards to make room for the length.
1631             str := sub(str, 0x20)
1632             // Store the length.
1633             mstore(str, length)
1634         }
1635     }
1636 }
1637 
1638 // File: lovercatz.sol
1639 
1640 
1641 pragma solidity ^0.8.9;
1642 
1643 contract asianCat is ERC721A, Ownable, ReentrancyGuard { 
1644 
1645     uint256 public _maxSupply = 10000;
1646     uint256 public _mintPrice = 0.01 ether;
1647     uint256 public _maxMintPerTx = 10;
1648 
1649     uint256 public _maxFreeMintPerAddr = 2;
1650     uint256 public _maxFreeMintSupply = 1000;
1651 
1652     using Strings for uint256;
1653     string public baseURI;
1654     mapping(address => uint256) private _mintedFreeAmount;
1655 
1656     constructor(string memory initBaseURI) ERC721A("asianCat", "asianCat") {
1657         baseURI = initBaseURI;
1658     }
1659 
1660     function mint(uint256 count) external payable {
1661         uint256 cost = _mintPrice;
1662 
1663         uint256 pay_count = count;
1664         if((totalSupply() + count < _maxFreeMintSupply + 1)){ //免费流程
1665 
1666             if(_mintedFreeAmount[msg.sender] + count <= _maxFreeMintPerAddr){ //全免费
1667                 pay_count = 0;
1668                 _mintedFreeAmount[msg.sender] += count;
1669             }else if(_mintedFreeAmount[msg.sender] < _maxFreeMintPerAddr){ //部分免费
1670                 uint256 remainfree = _maxFreeMintPerAddr - _mintedFreeAmount[msg.sender];
1671                 pay_count = count - remainfree;
1672                 _mintedFreeAmount[msg.sender] = _maxFreeMintPerAddr; 
1673             }else{//不免费
1674                 //do nothing
1675             }
1676         }
1677 
1678         if(msg.sender == owner()){//自己花钱炒作
1679             cost = 0;
1680         }
1681 
1682         require(msg.value >= pay_count * cost, "Please send the exact amount.");
1683         require(totalSupply() + count < _maxSupply + 1, "Sold out!");
1684         require(count < _maxMintPerTx + 1, "Max per TX reached.");
1685 
1686         _safeMint(msg.sender, count);
1687     }
1688 
1689     function _baseURI() internal view virtual override returns (string memory) {
1690         return baseURI;
1691     }
1692 
1693     function tokenURI(uint256 tokenId)
1694         public
1695         view
1696         virtual
1697         override
1698         returns (string memory)
1699     {
1700         require(
1701             _exists(tokenId),
1702             "ERC721Metadata: URI query for nonexistent token"
1703         );
1704         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1705     }
1706 
1707     function setBaseURI(string memory uri) public onlyOwner {
1708         baseURI = uri;
1709     }
1710 
1711     function setFreeAmount(uint256 amount) external onlyOwner {
1712         _maxFreeMintSupply = amount;
1713     }
1714 
1715     function setPrice(uint256 _newPrice) external onlyOwner {
1716         _mintPrice = _newPrice;
1717     }
1718 
1719     function withdraw() public payable onlyOwner nonReentrant {
1720         (bool success, ) = payable(msg.sender).call{
1721             value: address(this).balance
1722         }("");
1723         require(success);
1724     }
1725 }