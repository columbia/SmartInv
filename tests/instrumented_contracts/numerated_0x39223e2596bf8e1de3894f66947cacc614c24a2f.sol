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
257 // File: erc721a/contracts/IERC721A.sol
258 
259 
260 // ERC721A Contracts v4.2.2
261 // Creator: Chiru Labs
262 
263 pragma solidity ^0.8.4;
264 
265 /**
266  * @dev Interface of ERC721A.
267  */
268 interface IERC721A {
269     /**
270      * The caller must own the token or be an approved operator.
271      */
272     error ApprovalCallerNotOwnerNorApproved();
273 
274     /**
275      * The token does not exist.
276      */
277     error ApprovalQueryForNonexistentToken();
278 
279     /**
280      * The caller cannot approve to their own address.
281      */
282     error ApproveToCaller();
283 
284     /**
285      * Cannot query the balance for the zero address.
286      */
287     error BalanceQueryForZeroAddress();
288 
289     /**
290      * Cannot mint to the zero address.
291      */
292     error MintToZeroAddress();
293 
294     /**
295      * The quantity of tokens minted must be more than zero.
296      */
297     error MintZeroQuantity();
298 
299     /**
300      * The token does not exist.
301      */
302     error OwnerQueryForNonexistentToken();
303 
304     /**
305      * The caller must own the token or be an approved operator.
306      */
307     error TransferCallerNotOwnerNorApproved();
308 
309     /**
310      * The token must be owned by `from`.
311      */
312     error TransferFromIncorrectOwner();
313 
314     /**
315      * Cannot safely transfer to a contract that does not implement the
316      * ERC721Receiver interface.
317      */
318     error TransferToNonERC721ReceiverImplementer();
319 
320     /**
321      * Cannot transfer to the zero address.
322      */
323     error TransferToZeroAddress();
324 
325     /**
326      * The token does not exist.
327      */
328     error URIQueryForNonexistentToken();
329 
330     /**
331      * The `quantity` minted with ERC2309 exceeds the safety limit.
332      */
333     error MintERC2309QuantityExceedsLimit();
334 
335     /**
336      * The `extraData` cannot be set on an unintialized ownership slot.
337      */
338     error OwnershipNotInitializedForExtraData();
339 
340     // =============================================================
341     //                            STRUCTS
342     // =============================================================
343 
344     struct TokenOwnership {
345         // The address of the owner.
346         address addr;
347         // Stores the start time of ownership with minimal overhead for tokenomics.
348         uint64 startTimestamp;
349         // Whether the token has been burned.
350         bool burned;
351         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
352         uint24 extraData;
353     }
354 
355     // =============================================================
356     //                         TOKEN COUNTERS
357     // =============================================================
358 
359     /**
360      * @dev Returns the total number of tokens in existence.
361      * Burned tokens will reduce the count.
362      * To get the total number of tokens minted, please see {_totalMinted}.
363      */
364     function totalSupply() external view returns (uint256);
365 
366     // =============================================================
367     //                            IERC165
368     // =============================================================
369 
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 
380     // =============================================================
381     //                            IERC721
382     // =============================================================
383 
384     /**
385      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when `owner` enables or disables
396      * (`approved`) `operator` to manage all of its assets.
397      */
398     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
399 
400     /**
401      * @dev Returns the number of tokens in `owner`'s account.
402      */
403     function balanceOf(address owner) external view returns (uint256 balance);
404 
405     /**
406      * @dev Returns the owner of the `tokenId` token.
407      *
408      * Requirements:
409      *
410      * - `tokenId` must exist.
411      */
412     function ownerOf(uint256 tokenId) external view returns (address owner);
413 
414     /**
415      * @dev Safely transfers `tokenId` token from `from` to `to`,
416      * checking first that contract recipients are aware of the ERC721 protocol
417      * to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move
425      * this token by either {approve} or {setApprovalForAll}.
426      * - If `to` refers to a smart contract, it must implement
427      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
428      *
429      * Emits a {Transfer} event.
430      */
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId,
435         bytes calldata data
436     ) external;
437 
438     /**
439      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Transfers `tokenId` from `from` to `to`.
449      *
450      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
451      * whenever possible.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `tokenId` token must be owned by `from`.
458      * - If the caller is not `from`, it must be approved to move this token
459      * by either {approve} or {setApprovalForAll}.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) external;
468 
469     /**
470      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
471      * The approval is cleared when the token is transferred.
472      *
473      * Only a single account can be approved at a time, so approving the
474      * zero address clears previous approvals.
475      *
476      * Requirements:
477      *
478      * - The caller must own the token or be an approved operator.
479      * - `tokenId` must exist.
480      *
481      * Emits an {Approval} event.
482      */
483     function approve(address to, uint256 tokenId) external;
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom}
488      * for any token owned by the caller.
489      *
490      * Requirements:
491      *
492      * - The `operator` cannot be the caller.
493      *
494      * Emits an {ApprovalForAll} event.
495      */
496     function setApprovalForAll(address operator, bool _approved) external;
497 
498     /**
499      * @dev Returns the account approved for `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function getApproved(uint256 tokenId) external view returns (address operator);
506 
507     /**
508      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
509      *
510      * See {setApprovalForAll}.
511      */
512     function isApprovedForAll(address owner, address operator) external view returns (bool);
513 
514     // =============================================================
515     //                        IERC721Metadata
516     // =============================================================
517 
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 
533     // =============================================================
534     //                           IERC2309
535     // =============================================================
536 
537     /**
538      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
539      * (inclusive) is transferred from `from` to `to`, as defined in the
540      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
541      *
542      * See {_mintERC2309} for more details.
543      */
544     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
545 }
546 
547 // File: erc721a/contracts/ERC721A.sol
548 
549 
550 // ERC721A Contracts v4.2.2
551 // Creator: Chiru Labs
552 
553 pragma solidity ^0.8.4;
554 
555 
556 /**
557  * @dev Interface of ERC721 token receiver.
558  */
559 interface ERC721A__IERC721Receiver {
560     function onERC721Received(
561         address operator,
562         address from,
563         uint256 tokenId,
564         bytes calldata data
565     ) external returns (bytes4);
566 }
567 
568 /**
569  * @title ERC721A
570  *
571  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
572  * Non-Fungible Token Standard, including the Metadata extension.
573  * Optimized for lower gas during batch mints.
574  *
575  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
576  * starting from `_startTokenId()`.
577  *
578  * Assumptions:
579  *
580  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
581  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
582  */
583 contract ERC721A is IERC721A {
584     // Reference type for token approval.
585     struct TokenApprovalRef {
586         address value;
587     }
588 
589     // =============================================================
590     //                           CONSTANTS
591     // =============================================================
592 
593     // Mask of an entry in packed address data.
594     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
595 
596     // The bit position of `numberMinted` in packed address data.
597     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
598 
599     // The bit position of `numberBurned` in packed address data.
600     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
601 
602     // The bit position of `aux` in packed address data.
603     uint256 private constant _BITPOS_AUX = 192;
604 
605     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
606     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
607 
608     // The bit position of `startTimestamp` in packed ownership.
609     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
610 
611     // The bit mask of the `burned` bit in packed ownership.
612     uint256 private constant _BITMASK_BURNED = 1 << 224;
613 
614     // The bit position of the `nextInitialized` bit in packed ownership.
615     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
616 
617     // The bit mask of the `nextInitialized` bit in packed ownership.
618     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
619 
620     // The bit position of `extraData` in packed ownership.
621     uint256 private constant _BITPOS_EXTRA_DATA = 232;
622 
623     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
624     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
625 
626     // The mask of the lower 160 bits for addresses.
627     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
628 
629     // The maximum `quantity` that can be minted with {_mintERC2309}.
630     // This limit is to prevent overflows on the address data entries.
631     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
632     // is required to cause an overflow, which is unrealistic.
633     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
634 
635     // The `Transfer` event signature is given by:
636     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
637     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
638         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
639 
640     // =============================================================
641     //                            STORAGE
642     // =============================================================
643 
644     // The next token ID to be minted.
645     uint256 private _currentIndex;
646 
647     // The number of tokens burned.
648     uint256 private _burnCounter;
649 
650     // Token name
651     string private _name;
652 
653     // Token symbol
654     string private _symbol;
655 
656     // Mapping from token ID to ownership details
657     // An empty struct value does not necessarily mean the token is unowned.
658     // See {_packedOwnershipOf} implementation for details.
659     //
660     // Bits Layout:
661     // - [0..159]   `addr`
662     // - [160..223] `startTimestamp`
663     // - [224]      `burned`
664     // - [225]      `nextInitialized`
665     // - [232..255] `extraData`
666     mapping(uint256 => uint256) private _packedOwnerships;
667 
668     // Mapping owner address to address data.
669     //
670     // Bits Layout:
671     // - [0..63]    `balance`
672     // - [64..127]  `numberMinted`
673     // - [128..191] `numberBurned`
674     // - [192..255] `aux`
675     mapping(address => uint256) private _packedAddressData;
676 
677     // Mapping from token ID to approved address.
678     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
679 
680     // Mapping from owner to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     // =============================================================
684     //                          CONSTRUCTOR
685     // =============================================================
686 
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690         _currentIndex = _startTokenId();
691     }
692 
693     // =============================================================
694     //                   TOKEN COUNTING OPERATIONS
695     // =============================================================
696 
697     /**
698      * @dev Returns the starting token ID.
699      * To change the starting token ID, please override this function.
700      */
701     function _startTokenId() internal view virtual returns (uint256) {
702         return 0;
703     }
704 
705     /**
706      * @dev Returns the next token ID to be minted.
707      */
708     function _nextTokenId() internal view virtual returns (uint256) {
709         return _currentIndex;
710     }
711 
712     /**
713      * @dev Returns the total number of tokens in existence.
714      * Burned tokens will reduce the count.
715      * To get the total number of tokens minted, please see {_totalMinted}.
716      */
717     function totalSupply() public view virtual override returns (uint256) {
718         // Counter underflow is impossible as _burnCounter cannot be incremented
719         // more than `_currentIndex - _startTokenId()` times.
720         unchecked {
721             return _currentIndex - _burnCounter - _startTokenId();
722         }
723     }
724 
725     /**
726      * @dev Returns the total amount of tokens minted in the contract.
727      */
728     function _totalMinted() internal view virtual returns (uint256) {
729         // Counter underflow is impossible as `_currentIndex` does not decrement,
730         // and it is initialized to `_startTokenId()`.
731         unchecked {
732             return _currentIndex - _startTokenId();
733         }
734     }
735 
736     /**
737      * @dev Returns the total number of tokens burned.
738      */
739     function _totalBurned() internal view virtual returns (uint256) {
740         return _burnCounter;
741     }
742 
743     // =============================================================
744     //                    ADDRESS DATA OPERATIONS
745     // =============================================================
746 
747     /**
748      * @dev Returns the number of tokens in `owner`'s account.
749      */
750     function balanceOf(address owner) public view virtual override returns (uint256) {
751         if (owner == address(0)) revert BalanceQueryForZeroAddress();
752         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
753     }
754 
755     /**
756      * Returns the number of tokens minted by `owner`.
757      */
758     function _numberMinted(address owner) internal view returns (uint256) {
759         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
760     }
761 
762     /**
763      * Returns the number of tokens burned by or on behalf of `owner`.
764      */
765     function _numberBurned(address owner) internal view returns (uint256) {
766         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
767     }
768 
769     /**
770      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
771      */
772     function _getAux(address owner) internal view returns (uint64) {
773         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
774     }
775 
776     /**
777      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
778      * If there are multiple variables, please pack them into a uint64.
779      */
780     function _setAux(address owner, uint64 aux) internal virtual {
781         uint256 packed = _packedAddressData[owner];
782         uint256 auxCasted;
783         // Cast `aux` with assembly to avoid redundant masking.
784         assembly {
785             auxCasted := aux
786         }
787         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
788         _packedAddressData[owner] = packed;
789     }
790 
791     // =============================================================
792     //                            IERC165
793     // =============================================================
794 
795     /**
796      * @dev Returns true if this contract implements the interface defined by
797      * `interfaceId`. See the corresponding
798      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
799      * to learn more about how these ids are created.
800      *
801      * This function call must use less than 30000 gas.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
804         // The interface IDs are constants representing the first 4 bytes
805         // of the XOR of all function selectors in the interface.
806         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
807         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
808         return
809             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
810             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
811             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
812     }
813 
814     // =============================================================
815     //                        IERC721Metadata
816     // =============================================================
817 
818     /**
819      * @dev Returns the token collection name.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev Returns the token collection symbol.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, it can be overridden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return '';
849     }
850 
851     // =============================================================
852     //                     OWNERSHIPS OPERATIONS
853     // =============================================================
854 
855     /**
856      * @dev Returns the owner of the `tokenId` token.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must exist.
861      */
862     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
863         return address(uint160(_packedOwnershipOf(tokenId)));
864     }
865 
866     /**
867      * @dev Gas spent here starts off proportional to the maximum mint batch size.
868      * It gradually moves to O(1) as tokens get transferred around over time.
869      */
870     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
871         return _unpackedOwnership(_packedOwnershipOf(tokenId));
872     }
873 
874     /**
875      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
876      */
877     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
878         return _unpackedOwnership(_packedOwnerships[index]);
879     }
880 
881     /**
882      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
883      */
884     function _initializeOwnershipAt(uint256 index) internal virtual {
885         if (_packedOwnerships[index] == 0) {
886             _packedOwnerships[index] = _packedOwnershipOf(index);
887         }
888     }
889 
890     /**
891      * Returns the packed ownership data of `tokenId`.
892      */
893     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
894         uint256 curr = tokenId;
895 
896         unchecked {
897             if (_startTokenId() <= curr)
898                 if (curr < _currentIndex) {
899                     uint256 packed = _packedOwnerships[curr];
900                     // If not burned.
901                     if (packed & _BITMASK_BURNED == 0) {
902                         // Invariant:
903                         // There will always be an initialized ownership slot
904                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
905                         // before an unintialized ownership slot
906                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
907                         // Hence, `curr` will not underflow.
908                         //
909                         // We can directly compare the packed value.
910                         // If the address is zero, packed will be zero.
911                         while (packed == 0) {
912                             packed = _packedOwnerships[--curr];
913                         }
914                         return packed;
915                     }
916                 }
917         }
918         revert OwnerQueryForNonexistentToken();
919     }
920 
921     /**
922      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
923      */
924     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
925         ownership.addr = address(uint160(packed));
926         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
927         ownership.burned = packed & _BITMASK_BURNED != 0;
928         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
929     }
930 
931     /**
932      * @dev Packs ownership data into a single uint256.
933      */
934     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
935         assembly {
936             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
937             owner := and(owner, _BITMASK_ADDRESS)
938             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
939             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
940         }
941     }
942 
943     /**
944      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
945      */
946     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
947         // For branchless setting of the `nextInitialized` flag.
948         assembly {
949             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
950             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
951         }
952     }
953 
954     // =============================================================
955     //                      APPROVAL OPERATIONS
956     // =============================================================
957 
958     /**
959      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
960      * The approval is cleared when the token is transferred.
961      *
962      * Only a single account can be approved at a time, so approving the
963      * zero address clears previous approvals.
964      *
965      * Requirements:
966      *
967      * - The caller must own the token or be an approved operator.
968      * - `tokenId` must exist.
969      *
970      * Emits an {Approval} event.
971      */
972     function approve(address to, uint256 tokenId) public virtual override {
973         address owner = ownerOf(tokenId);
974 
975         if (_msgSenderERC721A() != owner)
976             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
977                 revert ApprovalCallerNotOwnerNorApproved();
978             }
979 
980         _tokenApprovals[tokenId].value = to;
981         emit Approval(owner, to, tokenId);
982     }
983 
984     /**
985      * @dev Returns the account approved for `tokenId` token.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      */
991     function getApproved(uint256 tokenId) public view virtual override returns (address) {
992         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
993 
994         return _tokenApprovals[tokenId].value;
995     }
996 
997     /**
998      * @dev Approve or remove `operator` as an operator for the caller.
999      * Operators can call {transferFrom} or {safeTransferFrom}
1000      * for any token owned by the caller.
1001      *
1002      * Requirements:
1003      *
1004      * - The `operator` cannot be the caller.
1005      *
1006      * Emits an {ApprovalForAll} event.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public virtual override {
1009         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1012         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1017      *
1018      * See {setApprovalForAll}.
1019      */
1020     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1021         return _operatorApprovals[owner][operator];
1022     }
1023 
1024     /**
1025      * @dev Returns whether `tokenId` exists.
1026      *
1027      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1028      *
1029      * Tokens start existing when they are minted. See {_mint}.
1030      */
1031     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1032         return
1033             _startTokenId() <= tokenId &&
1034             tokenId < _currentIndex && // If within bounds,
1035             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1036     }
1037 
1038     /**
1039      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1040      */
1041     function _isSenderApprovedOrOwner(
1042         address approvedAddress,
1043         address owner,
1044         address msgSender
1045     ) private pure returns (bool result) {
1046         assembly {
1047             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1048             owner := and(owner, _BITMASK_ADDRESS)
1049             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1050             msgSender := and(msgSender, _BITMASK_ADDRESS)
1051             // `msgSender == owner || msgSender == approvedAddress`.
1052             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1058      */
1059     function _getApprovedSlotAndAddress(uint256 tokenId)
1060         private
1061         view
1062         returns (uint256 approvedAddressSlot, address approvedAddress)
1063     {
1064         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1065         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1066         assembly {
1067             approvedAddressSlot := tokenApproval.slot
1068             approvedAddress := sload(approvedAddressSlot)
1069         }
1070     }
1071 
1072     // =============================================================
1073     //                      TRANSFER OPERATIONS
1074     // =============================================================
1075 
1076     /**
1077      * @dev Transfers `tokenId` from `from` to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must be owned by `from`.
1084      * - If the caller is not `from`, it must be approved to move this token
1085      * by either {approve} or {setApprovalForAll}.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function transferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1095 
1096         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1097 
1098         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1099 
1100         // The nested ifs save around 20+ gas over a compound boolean condition.
1101         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1102             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1103 
1104         if (to == address(0)) revert TransferToZeroAddress();
1105 
1106         _beforeTokenTransfers(from, to, tokenId, 1);
1107 
1108         // Clear approvals from the previous owner.
1109         assembly {
1110             if approvedAddress {
1111                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1112                 sstore(approvedAddressSlot, 0)
1113             }
1114         }
1115 
1116         // Underflow of the sender's balance is impossible because we check for
1117         // ownership above and the recipient's balance can't realistically overflow.
1118         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1119         unchecked {
1120             // We can directly increment and decrement the balances.
1121             --_packedAddressData[from]; // Updates: `balance -= 1`.
1122             ++_packedAddressData[to]; // Updates: `balance += 1`.
1123 
1124             // Updates:
1125             // - `address` to the next owner.
1126             // - `startTimestamp` to the timestamp of transfering.
1127             // - `burned` to `false`.
1128             // - `nextInitialized` to `true`.
1129             _packedOwnerships[tokenId] = _packOwnershipData(
1130                 to,
1131                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1132             );
1133 
1134             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1135             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1136                 uint256 nextTokenId = tokenId + 1;
1137                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1138                 if (_packedOwnerships[nextTokenId] == 0) {
1139                     // If the next slot is within bounds.
1140                     if (nextTokenId != _currentIndex) {
1141                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1142                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1143                     }
1144                 }
1145             }
1146         }
1147 
1148         emit Transfer(from, to, tokenId);
1149         _afterTokenTransfers(from, to, tokenId, 1);
1150     }
1151 
1152     /**
1153      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1154      */
1155     function safeTransferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public virtual override {
1160         safeTransferFrom(from, to, tokenId, '');
1161     }
1162 
1163     /**
1164      * @dev Safely transfers `tokenId` token from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `from` cannot be the zero address.
1169      * - `to` cannot be the zero address.
1170      * - `tokenId` token must exist and be owned by `from`.
1171      * - If the caller is not `from`, it must be approved to move this token
1172      * by either {approve} or {setApprovalForAll}.
1173      * - If `to` refers to a smart contract, it must implement
1174      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function safeTransferFrom(
1179         address from,
1180         address to,
1181         uint256 tokenId,
1182         bytes memory _data
1183     ) public virtual override {
1184         transferFrom(from, to, tokenId);
1185         if (to.code.length != 0)
1186             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1187                 revert TransferToNonERC721ReceiverImplementer();
1188             }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before a set of serially-ordered token IDs
1193      * are about to be transferred. This includes minting.
1194      * And also called before burning one token.
1195      *
1196      * `startTokenId` - the first token ID to be transferred.
1197      * `quantity` - the amount to be transferred.
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` will be minted for `to`.
1204      * - When `to` is zero, `tokenId` will be burned by `from`.
1205      * - `from` and `to` are never both zero.
1206      */
1207     function _beforeTokenTransfers(
1208         address from,
1209         address to,
1210         uint256 startTokenId,
1211         uint256 quantity
1212     ) internal virtual {}
1213 
1214     /**
1215      * @dev Hook that is called after a set of serially-ordered token IDs
1216      * have been transferred. This includes minting.
1217      * And also called after one token has been burned.
1218      *
1219      * `startTokenId` - the first token ID to be transferred.
1220      * `quantity` - the amount to be transferred.
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` has been minted for `to`.
1227      * - When `to` is zero, `tokenId` has been burned by `from`.
1228      * - `from` and `to` are never both zero.
1229      */
1230     function _afterTokenTransfers(
1231         address from,
1232         address to,
1233         uint256 startTokenId,
1234         uint256 quantity
1235     ) internal virtual {}
1236 
1237     /**
1238      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1239      *
1240      * `from` - Previous owner of the given token ID.
1241      * `to` - Target address that will receive the token.
1242      * `tokenId` - Token ID to be transferred.
1243      * `_data` - Optional data to send along with the call.
1244      *
1245      * Returns whether the call correctly returned the expected magic value.
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
1268     // =============================================================
1269     //                        MINT OPERATIONS
1270     // =============================================================
1271 
1272     /**
1273      * @dev Mints `quantity` tokens and transfers them to `to`.
1274      *
1275      * Requirements:
1276      *
1277      * - `to` cannot be the zero address.
1278      * - `quantity` must be greater than 0.
1279      *
1280      * Emits a {Transfer} event for each mint.
1281      */
1282     function _mint(address to, uint256 quantity) internal virtual {
1283         uint256 startTokenId = _currentIndex;
1284         if (quantity == 0) revert MintZeroQuantity();
1285 
1286         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1287 
1288         // Overflows are incredibly unrealistic.
1289         // `balance` and `numberMinted` have a maximum limit of 2**64.
1290         // `tokenId` has a maximum limit of 2**256.
1291         unchecked {
1292             // Updates:
1293             // - `balance += quantity`.
1294             // - `numberMinted += quantity`.
1295             //
1296             // We can directly add to the `balance` and `numberMinted`.
1297             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1298 
1299             // Updates:
1300             // - `address` to the owner.
1301             // - `startTimestamp` to the timestamp of minting.
1302             // - `burned` to `false`.
1303             // - `nextInitialized` to `quantity == 1`.
1304             _packedOwnerships[startTokenId] = _packOwnershipData(
1305                 to,
1306                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1307             );
1308 
1309             uint256 toMasked;
1310             uint256 end = startTokenId + quantity;
1311 
1312             // Use assembly to loop and emit the `Transfer` event for gas savings.
1313             assembly {
1314                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1315                 toMasked := and(to, _BITMASK_ADDRESS)
1316                 // Emit the `Transfer` event.
1317                 log4(
1318                     0, // Start of data (0, since no data).
1319                     0, // End of data (0, since no data).
1320                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1321                     0, // `address(0)`.
1322                     toMasked, // `to`.
1323                     startTokenId // `tokenId`.
1324                 )
1325 
1326                 for {
1327                     let tokenId := add(startTokenId, 1)
1328                 } iszero(eq(tokenId, end)) {
1329                     tokenId := add(tokenId, 1)
1330                 } {
1331                     // Emit the `Transfer` event. Similar to above.
1332                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1333                 }
1334             }
1335             if (toMasked == 0) revert MintToZeroAddress();
1336 
1337             _currentIndex = end;
1338         }
1339         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1340     }
1341 
1342     /**
1343      * @dev Mints `quantity` tokens and transfers them to `to`.
1344      *
1345      * This function is intended for efficient minting only during contract creation.
1346      *
1347      * It emits only one {ConsecutiveTransfer} as defined in
1348      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1349      * instead of a sequence of {Transfer} event(s).
1350      *
1351      * Calling this function outside of contract creation WILL make your contract
1352      * non-compliant with the ERC721 standard.
1353      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1354      * {ConsecutiveTransfer} event is only permissible during contract creation.
1355      *
1356      * Requirements:
1357      *
1358      * - `to` cannot be the zero address.
1359      * - `quantity` must be greater than 0.
1360      *
1361      * Emits a {ConsecutiveTransfer} event.
1362      */
1363     function _mintERC2309(address to, uint256 quantity) internal virtual {
1364         uint256 startTokenId = _currentIndex;
1365         if (to == address(0)) revert MintToZeroAddress();
1366         if (quantity == 0) revert MintZeroQuantity();
1367         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1368 
1369         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1370 
1371         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1372         unchecked {
1373             // Updates:
1374             // - `balance += quantity`.
1375             // - `numberMinted += quantity`.
1376             //
1377             // We can directly add to the `balance` and `numberMinted`.
1378             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1379 
1380             // Updates:
1381             // - `address` to the owner.
1382             // - `startTimestamp` to the timestamp of minting.
1383             // - `burned` to `false`.
1384             // - `nextInitialized` to `quantity == 1`.
1385             _packedOwnerships[startTokenId] = _packOwnershipData(
1386                 to,
1387                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1388             );
1389 
1390             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1391 
1392             _currentIndex = startTokenId + quantity;
1393         }
1394         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1395     }
1396 
1397     /**
1398      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1399      *
1400      * Requirements:
1401      *
1402      * - If `to` refers to a smart contract, it must implement
1403      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1404      * - `quantity` must be greater than 0.
1405      *
1406      * See {_mint}.
1407      *
1408      * Emits a {Transfer} event for each mint.
1409      */
1410     function _safeMint(
1411         address to,
1412         uint256 quantity,
1413         bytes memory _data
1414     ) internal virtual {
1415         _mint(to, quantity);
1416 
1417         unchecked {
1418             if (to.code.length != 0) {
1419                 uint256 end = _currentIndex;
1420                 uint256 index = end - quantity;
1421                 do {
1422                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1423                         revert TransferToNonERC721ReceiverImplementer();
1424                     }
1425                 } while (index < end);
1426                 // Reentrancy protection.
1427                 if (_currentIndex != end) revert();
1428             }
1429         }
1430     }
1431 
1432     /**
1433      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1434      */
1435     function _safeMint(address to, uint256 quantity) internal virtual {
1436         _safeMint(to, quantity, '');
1437     }
1438 
1439     // =============================================================
1440     //                        BURN OPERATIONS
1441     // =============================================================
1442 
1443     /**
1444      * @dev Equivalent to `_burn(tokenId, false)`.
1445      */
1446     function _burn(uint256 tokenId) internal virtual {
1447         _burn(tokenId, false);
1448     }
1449 
1450     /**
1451      * @dev Destroys `tokenId`.
1452      * The approval is cleared when the token is burned.
1453      *
1454      * Requirements:
1455      *
1456      * - `tokenId` must exist.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1461         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1462 
1463         address from = address(uint160(prevOwnershipPacked));
1464 
1465         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1466 
1467         if (approvalCheck) {
1468             // The nested ifs save around 20+ gas over a compound boolean condition.
1469             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1470                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1471         }
1472 
1473         _beforeTokenTransfers(from, address(0), tokenId, 1);
1474 
1475         // Clear approvals from the previous owner.
1476         assembly {
1477             if approvedAddress {
1478                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1479                 sstore(approvedAddressSlot, 0)
1480             }
1481         }
1482 
1483         // Underflow of the sender's balance is impossible because we check for
1484         // ownership above and the recipient's balance can't realistically overflow.
1485         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1486         unchecked {
1487             // Updates:
1488             // - `balance -= 1`.
1489             // - `numberBurned += 1`.
1490             //
1491             // We can directly decrement the balance, and increment the number burned.
1492             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1493             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1494 
1495             // Updates:
1496             // - `address` to the last owner.
1497             // - `startTimestamp` to the timestamp of burning.
1498             // - `burned` to `true`.
1499             // - `nextInitialized` to `true`.
1500             _packedOwnerships[tokenId] = _packOwnershipData(
1501                 from,
1502                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1503             );
1504 
1505             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1506             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1507                 uint256 nextTokenId = tokenId + 1;
1508                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1509                 if (_packedOwnerships[nextTokenId] == 0) {
1510                     // If the next slot is within bounds.
1511                     if (nextTokenId != _currentIndex) {
1512                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1513                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1514                     }
1515                 }
1516             }
1517         }
1518 
1519         emit Transfer(from, address(0), tokenId);
1520         _afterTokenTransfers(from, address(0), tokenId, 1);
1521 
1522         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1523         unchecked {
1524             _burnCounter++;
1525         }
1526     }
1527 
1528     // =============================================================
1529     //                     EXTRA DATA OPERATIONS
1530     // =============================================================
1531 
1532     /**
1533      * @dev Directly sets the extra data for the ownership data `index`.
1534      */
1535     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1536         uint256 packed = _packedOwnerships[index];
1537         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1538         uint256 extraDataCasted;
1539         // Cast `extraData` with assembly to avoid redundant masking.
1540         assembly {
1541             extraDataCasted := extraData
1542         }
1543         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1544         _packedOwnerships[index] = packed;
1545     }
1546 
1547     /**
1548      * @dev Called during each token transfer to set the 24bit `extraData` field.
1549      * Intended to be overridden by the cosumer contract.
1550      *
1551      * `previousExtraData` - the value of `extraData` before transfer.
1552      *
1553      * Calling conditions:
1554      *
1555      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1556      * transferred to `to`.
1557      * - When `from` is zero, `tokenId` will be minted for `to`.
1558      * - When `to` is zero, `tokenId` will be burned by `from`.
1559      * - `from` and `to` are never both zero.
1560      */
1561     function _extraData(
1562         address from,
1563         address to,
1564         uint24 previousExtraData
1565     ) internal view virtual returns (uint24) {}
1566 
1567     /**
1568      * @dev Returns the next extra data for the packed ownership data.
1569      * The returned result is shifted into position.
1570      */
1571     function _nextExtraData(
1572         address from,
1573         address to,
1574         uint256 prevOwnershipPacked
1575     ) private view returns (uint256) {
1576         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1577         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1578     }
1579 
1580     // =============================================================
1581     //                       OTHER OPERATIONS
1582     // =============================================================
1583 
1584     /**
1585      * @dev Returns the message sender (defaults to `msg.sender`).
1586      *
1587      * If you are writing GSN compatible contracts, you need to override this function.
1588      */
1589     function _msgSenderERC721A() internal view virtual returns (address) {
1590         return msg.sender;
1591     }
1592 
1593     /**
1594      * @dev Converts a uint256 to its ASCII string decimal representation.
1595      */
1596     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1597         assembly {
1598             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1599             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1600             // We will need 1 32-byte word to store the length,
1601             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1602             str := add(mload(0x40), 0x80)
1603             // Update the free memory pointer to allocate.
1604             mstore(0x40, str)
1605 
1606             // Cache the end of the memory to calculate the length later.
1607             let end := str
1608 
1609             // We write the string from rightmost digit to leftmost digit.
1610             // The following is essentially a do-while loop that also handles the zero case.
1611             // prettier-ignore
1612             for { let temp := value } 1 {} {
1613                 str := sub(str, 1)
1614                 // Write the character to the pointer.
1615                 // The ASCII index of the '0' character is 48.
1616                 mstore8(str, add(48, mod(temp, 10)))
1617                 // Keep dividing `temp` until zero.
1618                 temp := div(temp, 10)
1619                 // prettier-ignore
1620                 if iszero(temp) { break }
1621             }
1622 
1623             let length := sub(end, str)
1624             // Move the pointer 32 bytes leftwards to make room for the length.
1625             str := sub(str, 0x20)
1626             // Store the length.
1627             mstore(str, length)
1628         }
1629     }
1630 }
1631 
1632 // File: Suki.sol
1633 
1634 pragma solidity >=0.8.0 <0.9.0;
1635 
1636   contract Suki is ERC721A, Ownable, ReentrancyGuard {
1637   using Strings for uint256;
1638 
1639   string public _baseTokenURI;
1640   string public hiddenMetadataUri;
1641 
1642   uint256 public cost = 0.025 ether;
1643   uint256 public maxSupply = 5555;
1644   uint256 public maxMintAmountPerTx = 25;
1645 
1646   bool public paused = true;
1647   bool public revealed;
1648 
1649   address public feeRecipient1 = 0x42D62DbD56e358D29FEEd23927E4bcb5930247c3;
1650   address public feeRecipient2 = 0x65A96d32bbcbd41e46bb2097230450Dd2C1cc224;
1651   address public feeRecipient3 = 0x9927e8FF54695F7c609e2aCef1F3130AB06C8e34;
1652   address public feeRecipient4 = 0x2B675E3BDA64fa05E90C2C2f135e6798041834b5;
1653 
1654   uint256 fee1 = 29;
1655   uint256 fee2 = 29;
1656   uint256 fee3 = 8;
1657   uint256 fee4 = 5;
1658   uint256 feeOwner = 29;
1659 
1660   constructor(
1661     string memory _hiddenMetadataUri
1662   ) ERC721A("Suki Learns to Fly", "SUKI") {
1663     _safeMint(msg.sender, 1);
1664     setHiddenMetadataUri(_hiddenMetadataUri);
1665   }
1666 
1667   function mint(uint256 _mintAmount) public payable nonReentrant {
1668     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount! Choose an amount between 1 and 25");
1669     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1670     require(!paused, "The contract is paused!");
1671     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1672 
1673     _safeMint(_msgSender(), _mintAmount);
1674   }
1675 
1676   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1677     _safeMint(_receiver, _mintAmount);
1678   }
1679 
1680   function _startTokenId() internal view virtual override returns (uint256) {
1681     return 1;
1682   }
1683 
1684   function setRevealed(bool _state) public onlyOwner {
1685     revealed = _state;
1686   }
1687 
1688   function setCost(uint256 _cost) public onlyOwner {
1689     cost = _cost;
1690   }
1691 
1692   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1693     maxMintAmountPerTx = _maxMintAmountPerTx;
1694   }
1695 
1696   function setPaused(bool _state) public onlyOwner {
1697     paused = _state;
1698   }
1699 
1700   function withdraw() public onlyOwner nonReentrant {
1701     uint256 distributedFee1 = address(this).balance * fee1 / 100;
1702     uint256 distributedFee2 = address(this).balance * fee2 / 100;
1703     uint256 distributedFee3 = address(this).balance * fee3 / 100;
1704     uint256 distributedFee4 = address(this).balance * fee4 / 100;
1705     uint256 distributedFeeOwner = address(this).balance * feeOwner / 100;
1706 
1707     withdrawToWallet(feeRecipient1, distributedFee1);
1708     withdrawToWallet(feeRecipient2, distributedFee2);
1709     withdrawToWallet(feeRecipient3, distributedFee3);
1710     withdrawToWallet(feeRecipient4, distributedFee4);
1711     withdrawToWallet(owner(), distributedFeeOwner);
1712   }
1713 
1714   function withdrawToWallet(address wallet, uint256 distributedFee) internal {
1715     (bool success, ) = wallet.call{value: distributedFee}("");
1716     require(success, "Failed to send ETH");
1717   }
1718 
1719   // METADATA HANDLING
1720 
1721   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1722     hiddenMetadataUri = _hiddenMetadataUri;
1723   }
1724 
1725   function setBaseURI(string calldata baseURI) public onlyOwner {
1726     _baseTokenURI = baseURI;
1727   }
1728 
1729   function _baseURI() internal view virtual override returns (string memory) {
1730       return _baseTokenURI;
1731   }
1732 
1733   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1734       require(_exists(_tokenId), "URI does not exist!");
1735 
1736       if (revealed) {
1737           return string(abi.encodePacked(_baseURI(), _tokenId.toString(), ".json"));
1738       } else {
1739           return hiddenMetadataUri;
1740       }
1741   }
1742 }