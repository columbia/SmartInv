1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Contract module that helps prevent reentrant calls to a function.
89  *
90  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
91  * available, which can be applied to functions to make sure there are no nested
92  * (reentrant) calls to them.
93  *
94  * Note that because there is a single `nonReentrant` guard, functions marked as
95  * `nonReentrant` may not call one another. This can be worked around by making
96  * those functions `private`, and then adding `external` `nonReentrant` entry
97  * points to them.
98  *
99  * TIP: If you would like to learn more about reentrancy and alternative ways
100  * to protect against it, check out our blog post
101  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
102  */
103 abstract contract ReentrancyGuard {
104     // Booleans are more expensive than uint256 or any type that takes up a full
105     // word because each write operation emits an extra SLOAD to first read the
106     // slot's contents, replace the bits taken up by the boolean, and then write
107     // back. This is the compiler's defense against contract upgrades and
108     // pointer aliasing, and it cannot be disabled.
109 
110     // The values being non-zero value makes deployment a bit more expensive,
111     // but in exchange the refund on every call to nonReentrant will be lower in
112     // amount. Since refunds are capped to a percentage of the total
113     // transaction's gas, it is best to keep them low in cases like this one, to
114     // increase the likelihood of the full refund coming into effect.
115     uint256 private constant _NOT_ENTERED = 1;
116     uint256 private constant _ENTERED = 2;
117 
118     uint256 private _status;
119 
120     constructor() {
121         _status = _NOT_ENTERED;
122     }
123 
124     /**
125      * @dev Prevents a contract from calling itself, directly or indirectly.
126      * Calling a `nonReentrant` function from another `nonReentrant`
127      * function is not supported. It is possible to prevent this from happening
128      * by making the `nonReentrant` function external, and making it call a
129      * `private` function that does the actual work.
130      */
131     modifier nonReentrant() {
132         // On the first call to nonReentrant, _notEntered will be true
133         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
134 
135         // Any calls to nonReentrant after this point will fail
136         _status = _ENTERED;
137 
138         _;
139 
140         // By storing the original value once again, a refund is triggered (see
141         // https://eips.ethereum.org/EIPS/eip-2200)
142         _status = _NOT_ENTERED;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         _checkOwner();
210         _;
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if the sender is not the owner.
222      */
223     function _checkOwner() internal view virtual {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225     }
226 
227     /**
228      * @dev Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         _transferOwnership(address(0));
236     }
237 
238     /**
239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
240      * Can only be called by the current owner.
241      */
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         _transferOwnership(newOwner);
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Internal function without access restriction.
250      */
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 // File: erc721a/contracts/IERC721A.sol
259 
260 
261 // ERC721A Contracts v4.2.2
262 // Creator: Chiru Labs
263 
264 pragma solidity ^0.8.4;
265 
266 /**
267  * @dev Interface of ERC721A.
268  */
269 interface IERC721A {
270     /**
271      * The caller must own the token or be an approved operator.
272      */
273     error ApprovalCallerNotOwnerNorApproved();
274 
275     /**
276      * The token does not exist.
277      */
278     error ApprovalQueryForNonexistentToken();
279 
280     /**
281      * The caller cannot approve to their own address.
282      */
283     error ApproveToCaller();
284 
285     /**
286      * Cannot query the balance for the zero address.
287      */
288     error BalanceQueryForZeroAddress();
289 
290     /**
291      * Cannot mint to the zero address.
292      */
293     error MintToZeroAddress();
294 
295     /**
296      * The quantity of tokens minted must be more than zero.
297      */
298     error MintZeroQuantity();
299 
300     /**
301      * The token does not exist.
302      */
303     error OwnerQueryForNonexistentToken();
304 
305     /**
306      * The caller must own the token or be an approved operator.
307      */
308     error TransferCallerNotOwnerNorApproved();
309 
310     /**
311      * The token must be owned by `from`.
312      */
313     error TransferFromIncorrectOwner();
314 
315     /**
316      * Cannot safely transfer to a contract that does not implement the
317      * ERC721Receiver interface.
318      */
319     error TransferToNonERC721ReceiverImplementer();
320 
321     /**
322      * Cannot transfer to the zero address.
323      */
324     error TransferToZeroAddress();
325 
326     /**
327      * The token does not exist.
328      */
329     error URIQueryForNonexistentToken();
330 
331     /**
332      * The `quantity` minted with ERC2309 exceeds the safety limit.
333      */
334     error MintERC2309QuantityExceedsLimit();
335 
336     /**
337      * The `extraData` cannot be set on an unintialized ownership slot.
338      */
339     error OwnershipNotInitializedForExtraData();
340 
341     // =============================================================
342     //                            STRUCTS
343     // =============================================================
344 
345     struct TokenOwnership {
346         // The address of the owner.
347         address addr;
348         // Stores the start time of ownership with minimal overhead for tokenomics.
349         uint64 startTimestamp;
350         // Whether the token has been burned.
351         bool burned;
352         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
353         uint24 extraData;
354     }
355 
356     // =============================================================
357     //                         TOKEN COUNTERS
358     // =============================================================
359 
360     /**
361      * @dev Returns the total number of tokens in existence.
362      * Burned tokens will reduce the count.
363      * To get the total number of tokens minted, please see {_totalMinted}.
364      */
365     function totalSupply() external view returns (uint256);
366 
367     // =============================================================
368     //                            IERC165
369     // =============================================================
370 
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 
381     // =============================================================
382     //                            IERC721
383     // =============================================================
384 
385     /**
386      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
389 
390     /**
391      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
392      */
393     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
394 
395     /**
396      * @dev Emitted when `owner` enables or disables
397      * (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in `owner`'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`,
417      * checking first that contract recipients are aware of the ERC721 protocol
418      * to prevent tokens from being forever locked.
419      *
420      * Requirements:
421      *
422      * - `from` cannot be the zero address.
423      * - `to` cannot be the zero address.
424      * - `tokenId` token must exist and be owned by `from`.
425      * - If the caller is not `from`, it must be have been allowed to move
426      * this token by either {approve} or {setApprovalForAll}.
427      * - If `to` refers to a smart contract, it must implement
428      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId,
436         bytes calldata data
437     ) external;
438 
439     /**
440      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
441      */
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) external;
447 
448     /**
449      * @dev Transfers `tokenId` from `from` to `to`.
450      *
451      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
452      * whenever possible.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must be owned by `from`.
459      * - If the caller is not `from`, it must be approved to move this token
460      * by either {approve} or {setApprovalForAll}.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
472      * The approval is cleared when the token is transferred.
473      *
474      * Only a single account can be approved at a time, so approving the
475      * zero address clears previous approvals.
476      *
477      * Requirements:
478      *
479      * - The caller must own the token or be an approved operator.
480      * - `tokenId` must exist.
481      *
482      * Emits an {Approval} event.
483      */
484     function approve(address to, uint256 tokenId) external;
485 
486     /**
487      * @dev Approve or remove `operator` as an operator for the caller.
488      * Operators can call {transferFrom} or {safeTransferFrom}
489      * for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns the account approved for `tokenId` token.
501      *
502      * Requirements:
503      *
504      * - `tokenId` must exist.
505      */
506     function getApproved(uint256 tokenId) external view returns (address operator);
507 
508     /**
509      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
510      *
511      * See {setApprovalForAll}.
512      */
513     function isApprovedForAll(address owner, address operator) external view returns (bool);
514 
515     // =============================================================
516     //                        IERC721Metadata
517     // =============================================================
518 
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 
534     // =============================================================
535     //                           IERC2309
536     // =============================================================
537 
538     /**
539      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
540      * (inclusive) is transferred from `from` to `to`, as defined in the
541      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
542      *
543      * See {_mintERC2309} for more details.
544      */
545     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
546 }
547 
548 // File: erc721a/contracts/ERC721A.sol
549 
550 
551 // ERC721A Contracts v4.2.2
552 // Creator: Chiru Labs
553 
554 pragma solidity ^0.8.4;
555 
556 
557 /**
558  * @dev Interface of ERC721 token receiver.
559  */
560 interface ERC721A__IERC721Receiver {
561     function onERC721Received(
562         address operator,
563         address from,
564         uint256 tokenId,
565         bytes calldata data
566     ) external returns (bytes4);
567 }
568 
569 /**
570  * @title ERC721A
571  *
572  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
573  * Non-Fungible Token Standard, including the Metadata extension.
574  * Optimized for lower gas during batch mints.
575  *
576  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
577  * starting from `_startTokenId()`.
578  *
579  * Assumptions:
580  *
581  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
582  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
583  */
584 contract ERC721A is IERC721A {
585     // Reference type for token approval.
586     struct TokenApprovalRef {
587         address value;
588     }
589 
590     // =============================================================
591     //                           CONSTANTS
592     // =============================================================
593 
594     // Mask of an entry in packed address data.
595     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
596 
597     // The bit position of `numberMinted` in packed address data.
598     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
599 
600     // The bit position of `numberBurned` in packed address data.
601     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
602 
603     // The bit position of `aux` in packed address data.
604     uint256 private constant _BITPOS_AUX = 192;
605 
606     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
607     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
608 
609     // The bit position of `startTimestamp` in packed ownership.
610     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
611 
612     // The bit mask of the `burned` bit in packed ownership.
613     uint256 private constant _BITMASK_BURNED = 1 << 224;
614 
615     // The bit position of the `nextInitialized` bit in packed ownership.
616     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
617 
618     // The bit mask of the `nextInitialized` bit in packed ownership.
619     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
620 
621     // The bit position of `extraData` in packed ownership.
622     uint256 private constant _BITPOS_EXTRA_DATA = 232;
623 
624     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
625     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
626 
627     // The mask of the lower 160 bits for addresses.
628     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
629 
630     // The maximum `quantity` that can be minted with {_mintERC2309}.
631     // This limit is to prevent overflows on the address data entries.
632     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
633     // is required to cause an overflow, which is unrealistic.
634     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
635 
636     // The `Transfer` event signature is given by:
637     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
638     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
639         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
640 
641     // =============================================================
642     //                            STORAGE
643     // =============================================================
644 
645     // The next token ID to be minted.
646     uint256 private _currentIndex;
647 
648     // The number of tokens burned.
649     uint256 private _burnCounter;
650 
651     // Token name
652     string private _name;
653 
654     // Token symbol
655     string private _symbol;
656 
657     // Mapping from token ID to ownership details
658     // An empty struct value does not necessarily mean the token is unowned.
659     // See {_packedOwnershipOf} implementation for details.
660     //
661     // Bits Layout:
662     // - [0..159]   `addr`
663     // - [160..223] `startTimestamp`
664     // - [224]      `burned`
665     // - [225]      `nextInitialized`
666     // - [232..255] `extraData`
667     mapping(uint256 => uint256) private _packedOwnerships;
668 
669     // Mapping owner address to address data.
670     //
671     // Bits Layout:
672     // - [0..63]    `balance`
673     // - [64..127]  `numberMinted`
674     // - [128..191] `numberBurned`
675     // - [192..255] `aux`
676     mapping(address => uint256) private _packedAddressData;
677 
678     // Mapping from token ID to approved address.
679     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     // =============================================================
685     //                          CONSTRUCTOR
686     // =============================================================
687 
688     constructor(string memory name_, string memory symbol_) {
689         _name = name_;
690         _symbol = symbol_;
691         _currentIndex = _startTokenId();
692     }
693 
694     // =============================================================
695     //                   TOKEN COUNTING OPERATIONS
696     // =============================================================
697 
698     /**
699      * @dev Returns the starting token ID.
700      * To change the starting token ID, please override this function.
701      */
702     function _startTokenId() internal view virtual returns (uint256) {
703         return 0;
704     }
705 
706     /**
707      * @dev Returns the next token ID to be minted.
708      */
709     function _nextTokenId() internal view virtual returns (uint256) {
710         return _currentIndex;
711     }
712 
713     /**
714      * @dev Returns the total number of tokens in existence.
715      * Burned tokens will reduce the count.
716      * To get the total number of tokens minted, please see {_totalMinted}.
717      */
718     function totalSupply() public view virtual override returns (uint256) {
719         // Counter underflow is impossible as _burnCounter cannot be incremented
720         // more than `_currentIndex - _startTokenId()` times.
721         unchecked {
722             return _currentIndex - _burnCounter - _startTokenId();
723         }
724     }
725 
726     /**
727      * @dev Returns the total amount of tokens minted in the contract.
728      */
729     function _totalMinted() internal view virtual returns (uint256) {
730         // Counter underflow is impossible as `_currentIndex` does not decrement,
731         // and it is initialized to `_startTokenId()`.
732         unchecked {
733             return _currentIndex - _startTokenId();
734         }
735     }
736 
737     /**
738      * @dev Returns the total number of tokens burned.
739      */
740     function _totalBurned() internal view virtual returns (uint256) {
741         return _burnCounter;
742     }
743 
744     // =============================================================
745     //                    ADDRESS DATA OPERATIONS
746     // =============================================================
747 
748     /**
749      * @dev Returns the number of tokens in `owner`'s account.
750      */
751     function balanceOf(address owner) public view virtual override returns (uint256) {
752         if (owner == address(0)) revert BalanceQueryForZeroAddress();
753         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
754     }
755 
756     /**
757      * Returns the number of tokens minted by `owner`.
758      */
759     function _numberMinted(address owner) internal view returns (uint256) {
760         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
761     }
762 
763     /**
764      * Returns the number of tokens burned by or on behalf of `owner`.
765      */
766     function _numberBurned(address owner) internal view returns (uint256) {
767         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
768     }
769 
770     /**
771      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
772      */
773     function _getAux(address owner) internal view returns (uint64) {
774         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
775     }
776 
777     /**
778      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
779      * If there are multiple variables, please pack them into a uint64.
780      */
781     function _setAux(address owner, uint64 aux) internal virtual {
782         uint256 packed = _packedAddressData[owner];
783         uint256 auxCasted;
784         // Cast `aux` with assembly to avoid redundant masking.
785         assembly {
786             auxCasted := aux
787         }
788         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
789         _packedAddressData[owner] = packed;
790     }
791 
792     // =============================================================
793     //                            IERC165
794     // =============================================================
795 
796     /**
797      * @dev Returns true if this contract implements the interface defined by
798      * `interfaceId`. See the corresponding
799      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
800      * to learn more about how these ids are created.
801      *
802      * This function call must use less than 30000 gas.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
805         // The interface IDs are constants representing the first 4 bytes
806         // of the XOR of all function selectors in the interface.
807         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
808         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
809         return
810             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
811             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
812             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
813     }
814 
815     // =============================================================
816     //                        IERC721Metadata
817     // =============================================================
818 
819     /**
820      * @dev Returns the token collection name.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev Returns the token collection symbol.
828      */
829     function symbol() public view virtual override returns (string memory) {
830         return _symbol;
831     }
832 
833     /**
834      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
835      */
836     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
837         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
838 
839         string memory baseURI = _baseURI();
840         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
841     }
842 
843     /**
844      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
845      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
846      * by default, it can be overridden in child contracts.
847      */
848     function _baseURI() internal view virtual returns (string memory) {
849         return '';
850     }
851 
852     // =============================================================
853     //                     OWNERSHIPS OPERATIONS
854     // =============================================================
855 
856     /**
857      * @dev Returns the owner of the `tokenId` token.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must exist.
862      */
863     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
864         return address(uint160(_packedOwnershipOf(tokenId)));
865     }
866 
867     /**
868      * @dev Gas spent here starts off proportional to the maximum mint batch size.
869      * It gradually moves to O(1) as tokens get transferred around over time.
870      */
871     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
872         return _unpackedOwnership(_packedOwnershipOf(tokenId));
873     }
874 
875     /**
876      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
877      */
878     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
879         return _unpackedOwnership(_packedOwnerships[index]);
880     }
881 
882     /**
883      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
884      */
885     function _initializeOwnershipAt(uint256 index) internal virtual {
886         if (_packedOwnerships[index] == 0) {
887             _packedOwnerships[index] = _packedOwnershipOf(index);
888         }
889     }
890 
891     /**
892      * Returns the packed ownership data of `tokenId`.
893      */
894     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
895         uint256 curr = tokenId;
896 
897         unchecked {
898             if (_startTokenId() <= curr)
899                 if (curr < _currentIndex) {
900                     uint256 packed = _packedOwnerships[curr];
901                     // If not burned.
902                     if (packed & _BITMASK_BURNED == 0) {
903                         // Invariant:
904                         // There will always be an initialized ownership slot
905                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
906                         // before an unintialized ownership slot
907                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
908                         // Hence, `curr` will not underflow.
909                         //
910                         // We can directly compare the packed value.
911                         // If the address is zero, packed will be zero.
912                         while (packed == 0) {
913                             packed = _packedOwnerships[--curr];
914                         }
915                         return packed;
916                     }
917                 }
918         }
919         revert OwnerQueryForNonexistentToken();
920     }
921 
922     /**
923      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
924      */
925     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
926         ownership.addr = address(uint160(packed));
927         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
928         ownership.burned = packed & _BITMASK_BURNED != 0;
929         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
930     }
931 
932     /**
933      * @dev Packs ownership data into a single uint256.
934      */
935     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
936         assembly {
937             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
938             owner := and(owner, _BITMASK_ADDRESS)
939             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
940             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
941         }
942     }
943 
944     /**
945      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
946      */
947     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
948         // For branchless setting of the `nextInitialized` flag.
949         assembly {
950             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
951             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
952         }
953     }
954 
955     // =============================================================
956     //                      APPROVAL OPERATIONS
957     // =============================================================
958 
959     /**
960      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
961      * The approval is cleared when the token is transferred.
962      *
963      * Only a single account can be approved at a time, so approving the
964      * zero address clears previous approvals.
965      *
966      * Requirements:
967      *
968      * - The caller must own the token or be an approved operator.
969      * - `tokenId` must exist.
970      *
971      * Emits an {Approval} event.
972      */
973     function approve(address to, uint256 tokenId) public virtual override {
974         address owner = ownerOf(tokenId);
975 
976         if (_msgSenderERC721A() != owner)
977             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
978                 revert ApprovalCallerNotOwnerNorApproved();
979             }
980 
981         _tokenApprovals[tokenId].value = to;
982         emit Approval(owner, to, tokenId);
983     }
984 
985     /**
986      * @dev Returns the account approved for `tokenId` token.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      */
992     function getApproved(uint256 tokenId) public view virtual override returns (address) {
993         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
994 
995         return _tokenApprovals[tokenId].value;
996     }
997 
998     /**
999      * @dev Approve or remove `operator` as an operator for the caller.
1000      * Operators can call {transferFrom} or {safeTransferFrom}
1001      * for any token owned by the caller.
1002      *
1003      * Requirements:
1004      *
1005      * - The `operator` cannot be the caller.
1006      *
1007      * Emits an {ApprovalForAll} event.
1008      */
1009     function setApprovalForAll(address operator, bool approved) public virtual override {
1010         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1011 
1012         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1013         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1014     }
1015 
1016     /**
1017      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1018      *
1019      * See {setApprovalForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev Returns whether `tokenId` exists.
1027      *
1028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1029      *
1030      * Tokens start existing when they are minted. See {_mint}.
1031      */
1032     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1033         return
1034             _startTokenId() <= tokenId &&
1035             tokenId < _currentIndex && // If within bounds,
1036             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1037     }
1038 
1039     /**
1040      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1041      */
1042     function _isSenderApprovedOrOwner(
1043         address approvedAddress,
1044         address owner,
1045         address msgSender
1046     ) private pure returns (bool result) {
1047         assembly {
1048             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1049             owner := and(owner, _BITMASK_ADDRESS)
1050             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1051             msgSender := and(msgSender, _BITMASK_ADDRESS)
1052             // `msgSender == owner || msgSender == approvedAddress`.
1053             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1054         }
1055     }
1056 
1057     /**
1058      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1059      */
1060     function _getApprovedSlotAndAddress(uint256 tokenId)
1061         private
1062         view
1063         returns (uint256 approvedAddressSlot, address approvedAddress)
1064     {
1065         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1066         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1067         assembly {
1068             approvedAddressSlot := tokenApproval.slot
1069             approvedAddress := sload(approvedAddressSlot)
1070         }
1071     }
1072 
1073     // =============================================================
1074     //                      TRANSFER OPERATIONS
1075     // =============================================================
1076 
1077     /**
1078      * @dev Transfers `tokenId` from `from` to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must be owned by `from`.
1085      * - If the caller is not `from`, it must be approved to move this token
1086      * by either {approve} or {setApprovalForAll}.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1096 
1097         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1098 
1099         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1100 
1101         // The nested ifs save around 20+ gas over a compound boolean condition.
1102         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1103             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1104 
1105         if (to == address(0)) revert TransferToZeroAddress();
1106 
1107         _beforeTokenTransfers(from, to, tokenId, 1);
1108 
1109         // Clear approvals from the previous owner.
1110         assembly {
1111             if approvedAddress {
1112                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1113                 sstore(approvedAddressSlot, 0)
1114             }
1115         }
1116 
1117         // Underflow of the sender's balance is impossible because we check for
1118         // ownership above and the recipient's balance can't realistically overflow.
1119         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1120         unchecked {
1121             // We can directly increment and decrement the balances.
1122             --_packedAddressData[from]; // Updates: `balance -= 1`.
1123             ++_packedAddressData[to]; // Updates: `balance += 1`.
1124 
1125             // Updates:
1126             // - `address` to the next owner.
1127             // - `startTimestamp` to the timestamp of transfering.
1128             // - `burned` to `false`.
1129             // - `nextInitialized` to `true`.
1130             _packedOwnerships[tokenId] = _packOwnershipData(
1131                 to,
1132                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1133             );
1134 
1135             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1136             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1137                 uint256 nextTokenId = tokenId + 1;
1138                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1139                 if (_packedOwnerships[nextTokenId] == 0) {
1140                     // If the next slot is within bounds.
1141                     if (nextTokenId != _currentIndex) {
1142                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1143                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1144                     }
1145                 }
1146             }
1147         }
1148 
1149         emit Transfer(from, to, tokenId);
1150         _afterTokenTransfers(from, to, tokenId, 1);
1151     }
1152 
1153     /**
1154      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1155      */
1156     function safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) public virtual override {
1161         safeTransferFrom(from, to, tokenId, '');
1162     }
1163 
1164     /**
1165      * @dev Safely transfers `tokenId` token from `from` to `to`.
1166      *
1167      * Requirements:
1168      *
1169      * - `from` cannot be the zero address.
1170      * - `to` cannot be the zero address.
1171      * - `tokenId` token must exist and be owned by `from`.
1172      * - If the caller is not `from`, it must be approved to move this token
1173      * by either {approve} or {setApprovalForAll}.
1174      * - If `to` refers to a smart contract, it must implement
1175      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function safeTransferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) public virtual override {
1185         transferFrom(from, to, tokenId);
1186         if (to.code.length != 0)
1187             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1188                 revert TransferToNonERC721ReceiverImplementer();
1189             }
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before a set of serially-ordered token IDs
1194      * are about to be transferred. This includes minting.
1195      * And also called before burning one token.
1196      *
1197      * `startTokenId` - the first token ID to be transferred.
1198      * `quantity` - the amount to be transferred.
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, `tokenId` will be burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _beforeTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 
1215     /**
1216      * @dev Hook that is called after a set of serially-ordered token IDs
1217      * have been transferred. This includes minting.
1218      * And also called after one token has been burned.
1219      *
1220      * `startTokenId` - the first token ID to be transferred.
1221      * `quantity` - the amount to be transferred.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` has been minted for `to`.
1228      * - When `to` is zero, `tokenId` has been burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 
1238     /**
1239      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1240      *
1241      * `from` - Previous owner of the given token ID.
1242      * `to` - Target address that will receive the token.
1243      * `tokenId` - Token ID to be transferred.
1244      * `_data` - Optional data to send along with the call.
1245      *
1246      * Returns whether the call correctly returned the expected magic value.
1247      */
1248     function _checkContractOnERC721Received(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) private returns (bool) {
1254         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1255             bytes4 retval
1256         ) {
1257             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1258         } catch (bytes memory reason) {
1259             if (reason.length == 0) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             } else {
1262                 assembly {
1263                     revert(add(32, reason), mload(reason))
1264                 }
1265             }
1266         }
1267     }
1268 
1269     // =============================================================
1270     //                        MINT OPERATIONS
1271     // =============================================================
1272 
1273     /**
1274      * @dev Mints `quantity` tokens and transfers them to `to`.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `quantity` must be greater than 0.
1280      *
1281      * Emits a {Transfer} event for each mint.
1282      */
1283     function _mint(address to, uint256 quantity) internal virtual {
1284         uint256 startTokenId = _currentIndex;
1285         if (quantity == 0) revert MintZeroQuantity();
1286 
1287         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1288 
1289         // Overflows are incredibly unrealistic.
1290         // `balance` and `numberMinted` have a maximum limit of 2**64.
1291         // `tokenId` has a maximum limit of 2**256.
1292         unchecked {
1293             // Updates:
1294             // - `balance += quantity`.
1295             // - `numberMinted += quantity`.
1296             //
1297             // We can directly add to the `balance` and `numberMinted`.
1298             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1299 
1300             // Updates:
1301             // - `address` to the owner.
1302             // - `startTimestamp` to the timestamp of minting.
1303             // - `burned` to `false`.
1304             // - `nextInitialized` to `quantity == 1`.
1305             _packedOwnerships[startTokenId] = _packOwnershipData(
1306                 to,
1307                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1308             );
1309 
1310             uint256 toMasked;
1311             uint256 end = startTokenId + quantity;
1312 
1313             // Use assembly to loop and emit the `Transfer` event for gas savings.
1314             assembly {
1315                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1316                 toMasked := and(to, _BITMASK_ADDRESS)
1317                 // Emit the `Transfer` event.
1318                 log4(
1319                     0, // Start of data (0, since no data).
1320                     0, // End of data (0, since no data).
1321                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1322                     0, // `address(0)`.
1323                     toMasked, // `to`.
1324                     startTokenId // `tokenId`.
1325                 )
1326 
1327                 for {
1328                     let tokenId := add(startTokenId, 1)
1329                 } iszero(eq(tokenId, end)) {
1330                     tokenId := add(tokenId, 1)
1331                 } {
1332                     // Emit the `Transfer` event. Similar to above.
1333                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1334                 }
1335             }
1336             if (toMasked == 0) revert MintToZeroAddress();
1337 
1338             _currentIndex = end;
1339         }
1340         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1341     }
1342 
1343     /**
1344      * @dev Mints `quantity` tokens and transfers them to `to`.
1345      *
1346      * This function is intended for efficient minting only during contract creation.
1347      *
1348      * It emits only one {ConsecutiveTransfer} as defined in
1349      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1350      * instead of a sequence of {Transfer} event(s).
1351      *
1352      * Calling this function outside of contract creation WILL make your contract
1353      * non-compliant with the ERC721 standard.
1354      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1355      * {ConsecutiveTransfer} event is only permissible during contract creation.
1356      *
1357      * Requirements:
1358      *
1359      * - `to` cannot be the zero address.
1360      * - `quantity` must be greater than 0.
1361      *
1362      * Emits a {ConsecutiveTransfer} event.
1363      */
1364     function _mintERC2309(address to, uint256 quantity) internal virtual {
1365         uint256 startTokenId = _currentIndex;
1366         if (to == address(0)) revert MintToZeroAddress();
1367         if (quantity == 0) revert MintZeroQuantity();
1368         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1369 
1370         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1371 
1372         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1373         unchecked {
1374             // Updates:
1375             // - `balance += quantity`.
1376             // - `numberMinted += quantity`.
1377             //
1378             // We can directly add to the `balance` and `numberMinted`.
1379             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1380 
1381             // Updates:
1382             // - `address` to the owner.
1383             // - `startTimestamp` to the timestamp of minting.
1384             // - `burned` to `false`.
1385             // - `nextInitialized` to `quantity == 1`.
1386             _packedOwnerships[startTokenId] = _packOwnershipData(
1387                 to,
1388                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1389             );
1390 
1391             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1392 
1393             _currentIndex = startTokenId + quantity;
1394         }
1395         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1396     }
1397 
1398     /**
1399      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1400      *
1401      * Requirements:
1402      *
1403      * - If `to` refers to a smart contract, it must implement
1404      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1405      * - `quantity` must be greater than 0.
1406      *
1407      * See {_mint}.
1408      *
1409      * Emits a {Transfer} event for each mint.
1410      */
1411     function _safeMint(
1412         address to,
1413         uint256 quantity,
1414         bytes memory _data
1415     ) internal virtual {
1416         _mint(to, quantity);
1417 
1418         unchecked {
1419             if (to.code.length != 0) {
1420                 uint256 end = _currentIndex;
1421                 uint256 index = end - quantity;
1422                 do {
1423                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1424                         revert TransferToNonERC721ReceiverImplementer();
1425                     }
1426                 } while (index < end);
1427                 // Reentrancy protection.
1428                 if (_currentIndex != end) revert();
1429             }
1430         }
1431     }
1432 
1433     /**
1434      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1435      */
1436     function _safeMint(address to, uint256 quantity) internal virtual {
1437         _safeMint(to, quantity, '');
1438     }
1439 
1440     // =============================================================
1441     //                        BURN OPERATIONS
1442     // =============================================================
1443 
1444     /**
1445      * @dev Equivalent to `_burn(tokenId, false)`.
1446      */
1447     function _burn(uint256 tokenId) internal virtual {
1448         _burn(tokenId, false);
1449     }
1450 
1451     /**
1452      * @dev Destroys `tokenId`.
1453      * The approval is cleared when the token is burned.
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must exist.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1462         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1463 
1464         address from = address(uint160(prevOwnershipPacked));
1465 
1466         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1467 
1468         if (approvalCheck) {
1469             // The nested ifs save around 20+ gas over a compound boolean condition.
1470             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1471                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1472         }
1473 
1474         _beforeTokenTransfers(from, address(0), tokenId, 1);
1475 
1476         // Clear approvals from the previous owner.
1477         assembly {
1478             if approvedAddress {
1479                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1480                 sstore(approvedAddressSlot, 0)
1481             }
1482         }
1483 
1484         // Underflow of the sender's balance is impossible because we check for
1485         // ownership above and the recipient's balance can't realistically overflow.
1486         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1487         unchecked {
1488             // Updates:
1489             // - `balance -= 1`.
1490             // - `numberBurned += 1`.
1491             //
1492             // We can directly decrement the balance, and increment the number burned.
1493             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1494             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1495 
1496             // Updates:
1497             // - `address` to the last owner.
1498             // - `startTimestamp` to the timestamp of burning.
1499             // - `burned` to `true`.
1500             // - `nextInitialized` to `true`.
1501             _packedOwnerships[tokenId] = _packOwnershipData(
1502                 from,
1503                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1504             );
1505 
1506             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1507             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1508                 uint256 nextTokenId = tokenId + 1;
1509                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1510                 if (_packedOwnerships[nextTokenId] == 0) {
1511                     // If the next slot is within bounds.
1512                     if (nextTokenId != _currentIndex) {
1513                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1514                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1515                     }
1516                 }
1517             }
1518         }
1519 
1520         emit Transfer(from, address(0), tokenId);
1521         _afterTokenTransfers(from, address(0), tokenId, 1);
1522 
1523         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1524         unchecked {
1525             _burnCounter++;
1526         }
1527     }
1528 
1529     // =============================================================
1530     //                     EXTRA DATA OPERATIONS
1531     // =============================================================
1532 
1533     /**
1534      * @dev Directly sets the extra data for the ownership data `index`.
1535      */
1536     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1537         uint256 packed = _packedOwnerships[index];
1538         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1539         uint256 extraDataCasted;
1540         // Cast `extraData` with assembly to avoid redundant masking.
1541         assembly {
1542             extraDataCasted := extraData
1543         }
1544         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1545         _packedOwnerships[index] = packed;
1546     }
1547 
1548     /**
1549      * @dev Called during each token transfer to set the 24bit `extraData` field.
1550      * Intended to be overridden by the cosumer contract.
1551      *
1552      * `previousExtraData` - the value of `extraData` before transfer.
1553      *
1554      * Calling conditions:
1555      *
1556      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1557      * transferred to `to`.
1558      * - When `from` is zero, `tokenId` will be minted for `to`.
1559      * - When `to` is zero, `tokenId` will be burned by `from`.
1560      * - `from` and `to` are never both zero.
1561      */
1562     function _extraData(
1563         address from,
1564         address to,
1565         uint24 previousExtraData
1566     ) internal view virtual returns (uint24) {}
1567 
1568     /**
1569      * @dev Returns the next extra data for the packed ownership data.
1570      * The returned result is shifted into position.
1571      */
1572     function _nextExtraData(
1573         address from,
1574         address to,
1575         uint256 prevOwnershipPacked
1576     ) private view returns (uint256) {
1577         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1578         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1579     }
1580 
1581     // =============================================================
1582     //                       OTHER OPERATIONS
1583     // =============================================================
1584 
1585     /**
1586      * @dev Returns the message sender (defaults to `msg.sender`).
1587      *
1588      * If you are writing GSN compatible contracts, you need to override this function.
1589      */
1590     function _msgSenderERC721A() internal view virtual returns (address) {
1591         return msg.sender;
1592     }
1593 
1594     /**
1595      * @dev Converts a uint256 to its ASCII string decimal representation.
1596      */
1597     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1598         assembly {
1599             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1600             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1601             // We will need 1 32-byte word to store the length,
1602             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1603             str := add(mload(0x40), 0x80)
1604             // Update the free memory pointer to allocate.
1605             mstore(0x40, str)
1606 
1607             // Cache the end of the memory to calculate the length later.
1608             let end := str
1609 
1610             // We write the string from rightmost digit to leftmost digit.
1611             // The following is essentially a do-while loop that also handles the zero case.
1612             // prettier-ignore
1613             for { let temp := value } 1 {} {
1614                 str := sub(str, 1)
1615                 // Write the character to the pointer.
1616                 // The ASCII index of the '0' character is 48.
1617                 mstore8(str, add(48, mod(temp, 10)))
1618                 // Keep dividing `temp` until zero.
1619                 temp := div(temp, 10)
1620                 // prettier-ignore
1621                 if iszero(temp) { break }
1622             }
1623 
1624             let length := sub(end, str)
1625             // Move the pointer 32 bytes leftwards to make room for the length.
1626             str := sub(str, 0x20)
1627             // Store the length.
1628             mstore(str, length)
1629         }
1630     }
1631 }
1632 
1633 // File: contracts/coolfrogz.sol
1634 
1635 
1636 
1637 pragma solidity >=0.8.9 <0.9.0;
1638 
1639 
1640 
1641 
1642 
1643 
1644 
1645 
1646 contract CoolFrogs is ERC721A, Ownable, ReentrancyGuard {
1647     string public baseURI;
1648     string public endPoint = ".json";
1649     string public hiddenMetadataUri = "";
1650     bool public revealed = true;
1651 
1652     uint256 public price = 0.0000 ether;
1653     uint256 public maxPerTx = 4;
1654     uint256 public maxPerWallet = 12;
1655     uint256 public maxSupply = 4201;
1656 
1657     constructor() ERC721A("Cool Frogs", "CoolFrogs")  {}
1658 
1659     
1660     function toggleRevealed() external onlyOwner {
1661         revealed = !revealed;
1662     }
1663     
1664     function setBaseURI(string calldata baseURI_) external onlyOwner {
1665         baseURI = baseURI_;
1666     }
1667 
1668     function mint(uint256 amount) external payable {
1669 
1670         require(msg.sender == tx.origin, "You can't mint from a contract.");
1671         require(msg.value == amount * price, "Please send the exact amount in order to mint.");
1672         require(totalSupply() + amount <= maxSupply, "Sold out.");
1673         require(numberMinted(msg.sender) + amount <= maxPerWallet, "You have exceeded the mint limit per wallet.");
1674         require(amount <= maxPerTx, "You have exceeded the mint limit per transaction.");
1675 
1676         _safeMint(msg.sender, amount);
1677     }
1678 
1679     function ownerMint(uint256 amount) external onlyOwner {
1680         require(totalSupply() + amount <= maxSupply, "Can't mint");
1681 
1682         _safeMint(msg.sender, amount);
1683     }
1684     
1685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1686         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1687         if (revealed == false) {
1688         return hiddenMetadataUri;
1689         }
1690 
1691         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), endPoint)) : '';
1692     }
1693 
1694     function _startTokenId() internal view virtual override returns (uint256) {
1695         return 1;
1696     }
1697 
1698     function numberMinted(address owner) public view returns (uint256) {
1699         return _numberMinted(owner);
1700     }
1701 
1702 
1703 
1704     function _baseURI() internal view virtual override returns (string memory) {
1705     return baseURI;
1706     }
1707 
1708     function withdraw() external onlyOwner nonReentrant {
1709         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1710         require(success, "Transfer failed.");
1711     }
1712 }