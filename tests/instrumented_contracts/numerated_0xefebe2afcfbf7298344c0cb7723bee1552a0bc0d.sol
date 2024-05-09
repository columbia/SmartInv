1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81     uint8 private constant _ADDRESS_LENGTH = 20;
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 
139     /**
140      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
141      */
142     function toHexString(address addr) internal pure returns (string memory) {
143         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 /**
155  * @dev Provides information about the current execution context, including the
156  * sender of the transaction and its data. While these are generally available
157  * via msg.sender and msg.data, they should not be accessed in such a direct
158  * manner, since when dealing with meta-transactions the account sending and
159  * paying for execution may not be the actual sender (as far as an application
160  * is concerned).
161  *
162  * This contract is only required for intermediate, library-like contracts.
163  */
164 abstract contract Context {
165     function _msgSender() internal view virtual returns (address) {
166         return msg.sender;
167     }
168 
169     function _msgData() internal view virtual returns (bytes calldata) {
170         return msg.data;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/access/Ownable.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @dev Contract module which provides a basic access control mechanism, where
184  * there is an account (an owner) that can be granted exclusive access to
185  * specific functions.
186  *
187  * By default, the owner account will be the one that deploys the contract. This
188  * can later be changed with {transferOwnership}.
189  *
190  * This module is used through inheritance. It will make available the modifier
191  * `onlyOwner`, which can be applied to your functions to restrict their use to
192  * the owner.
193  */
194 abstract contract Ownable is Context {
195     address private _owner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         _transferOwnership(_msgSender());
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         _checkOwner();
211         _;
212     }
213 
214     /**
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if the sender is not the owner.
223      */
224     function _checkOwner() internal view virtual {
225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 
259 // File: erc721a/contracts/IERC721A.sol
260 
261 
262 // ERC721A Contracts v4.2.2
263 // Creator: Chiru Labs
264 
265 pragma solidity ^0.8.4;
266 
267 /**
268  * @dev Interface of ERC721A.
269  */
270 interface IERC721A {
271     /**
272      * The caller must own the token or be an approved operator.
273      */
274     error ApprovalCallerNotOwnerNorApproved();
275 
276     /**
277      * The token does not exist.
278      */
279     error ApprovalQueryForNonexistentToken();
280 
281     /**
282      * The caller cannot approve to their own address.
283      */
284     error ApproveToCaller();
285 
286     /**
287      * Cannot query the balance for the zero address.
288      */
289     error BalanceQueryForZeroAddress();
290 
291     /**
292      * Cannot mint to the zero address.
293      */
294     error MintToZeroAddress();
295 
296     /**
297      * The quantity of tokens minted must be more than zero.
298      */
299     error MintZeroQuantity();
300 
301     /**
302      * The token does not exist.
303      */
304     error OwnerQueryForNonexistentToken();
305 
306     /**
307      * The caller must own the token or be an approved operator.
308      */
309     error TransferCallerNotOwnerNorApproved();
310 
311     /**
312      * The token must be owned by `from`.
313      */
314     error TransferFromIncorrectOwner();
315 
316     /**
317      * Cannot safely transfer to a contract that does not implement the
318      * ERC721Receiver interface.
319      */
320     error TransferToNonERC721ReceiverImplementer();
321 
322     /**
323      * Cannot transfer to the zero address.
324      */
325     error TransferToZeroAddress();
326 
327     /**
328      * The token does not exist.
329      */
330     error URIQueryForNonexistentToken();
331 
332     /**
333      * The `quantity` minted with ERC2309 exceeds the safety limit.
334      */
335     error MintERC2309QuantityExceedsLimit();
336 
337     /**
338      * The `extraData` cannot be set on an unintialized ownership slot.
339      */
340     error OwnershipNotInitializedForExtraData();
341 
342     // =============================================================
343     //                            STRUCTS
344     // =============================================================
345 
346     struct TokenOwnership {
347         // The address of the owner.
348         address addr;
349         // Stores the start time of ownership with minimal overhead for tokenomics.
350         uint64 startTimestamp;
351         // Whether the token has been burned.
352         bool burned;
353         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
354         uint24 extraData;
355     }
356 
357     // =============================================================
358     //                         TOKEN COUNTERS
359     // =============================================================
360 
361     /**
362      * @dev Returns the total number of tokens in existence.
363      * Burned tokens will reduce the count.
364      * To get the total number of tokens minted, please see {_totalMinted}.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     // =============================================================
369     //                            IERC165
370     // =============================================================
371 
372     /**
373      * @dev Returns true if this contract implements the interface defined by
374      * `interfaceId`. See the corresponding
375      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
376      * to learn more about how these ids are created.
377      *
378      * This function call must use less than 30000 gas.
379      */
380     function supportsInterface(bytes4 interfaceId) external view returns (bool);
381 
382     // =============================================================
383     //                            IERC721
384     // =============================================================
385 
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables
398      * (`approved`) `operator` to manage all of its assets.
399      */
400     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
401 
402     /**
403      * @dev Returns the number of tokens in `owner`'s account.
404      */
405     function balanceOf(address owner) external view returns (uint256 balance);
406 
407     /**
408      * @dev Returns the owner of the `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function ownerOf(uint256 tokenId) external view returns (address owner);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`,
418      * checking first that contract recipients are aware of the ERC721 protocol
419      * to prevent tokens from being forever locked.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must exist and be owned by `from`.
426      * - If the caller is not `from`, it must be have been allowed to move
427      * this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement
429      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
430      *
431      * Emits a {Transfer} event.
432      */
433     function safeTransferFrom(
434         address from,
435         address to,
436         uint256 tokenId,
437         bytes calldata data
438     ) external;
439 
440     /**
441      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Transfers `tokenId` from `from` to `to`.
451      *
452      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
453      * whenever possible.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token
461      * by either {approve} or {setApprovalForAll}.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
473      * The approval is cleared when the token is transferred.
474      *
475      * Only a single account can be approved at a time, so approving the
476      * zero address clears previous approvals.
477      *
478      * Requirements:
479      *
480      * - The caller must own the token or be an approved operator.
481      * - `tokenId` must exist.
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address to, uint256 tokenId) external;
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom}
490      * for any token owned by the caller.
491      *
492      * Requirements:
493      *
494      * - The `operator` cannot be the caller.
495      *
496      * Emits an {ApprovalForAll} event.
497      */
498     function setApprovalForAll(address operator, bool _approved) external;
499 
500     /**
501      * @dev Returns the account approved for `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function getApproved(uint256 tokenId) external view returns (address operator);
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}.
513      */
514     function isApprovedForAll(address owner, address operator) external view returns (bool);
515 
516     // =============================================================
517     //                        IERC721Metadata
518     // =============================================================
519 
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 
535     // =============================================================
536     //                           IERC2309
537     // =============================================================
538 
539     /**
540      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
541      * (inclusive) is transferred from `from` to `to`, as defined in the
542      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
543      *
544      * See {_mintERC2309} for more details.
545      */
546     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
547 }
548 
549 // File: erc721a/contracts/ERC721A.sol
550 
551 
552 // ERC721A Contracts v4.2.2
553 // Creator: Chiru Labs
554 
555 pragma solidity ^0.8.4;
556 
557 
558 /**
559  * @dev Interface of ERC721 token receiver.
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
571  * @title ERC721A
572  *
573  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
574  * Non-Fungible Token Standard, including the Metadata extension.
575  * Optimized for lower gas during batch mints.
576  *
577  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
578  * starting from `_startTokenId()`.
579  *
580  * Assumptions:
581  *
582  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
583  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
584  */
585 contract ERC721A is IERC721A {
586     // Reference type for token approval.
587     struct TokenApprovalRef {
588         address value;
589     }
590 
591     // =============================================================
592     //                           CONSTANTS
593     // =============================================================
594 
595     // Mask of an entry in packed address data.
596     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
597 
598     // The bit position of `numberMinted` in packed address data.
599     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
600 
601     // The bit position of `numberBurned` in packed address data.
602     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
603 
604     // The bit position of `aux` in packed address data.
605     uint256 private constant _BITPOS_AUX = 192;
606 
607     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
608     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
609 
610     // The bit position of `startTimestamp` in packed ownership.
611     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
612 
613     // The bit mask of the `burned` bit in packed ownership.
614     uint256 private constant _BITMASK_BURNED = 1 << 224;
615 
616     // The bit position of the `nextInitialized` bit in packed ownership.
617     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
618 
619     // The bit mask of the `nextInitialized` bit in packed ownership.
620     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
621 
622     // The bit position of `extraData` in packed ownership.
623     uint256 private constant _BITPOS_EXTRA_DATA = 232;
624 
625     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
626     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
627 
628     // The mask of the lower 160 bits for addresses.
629     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
630 
631     // The maximum `quantity` that can be minted with {_mintERC2309}.
632     // This limit is to prevent overflows on the address data entries.
633     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
634     // is required to cause an overflow, which is unrealistic.
635     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
636 
637     // The `Transfer` event signature is given by:
638     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
639     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
640         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
641 
642     // =============================================================
643     //                            STORAGE
644     // =============================================================
645 
646     // The next token ID to be minted.
647     uint256 private _currentIndex;
648 
649     // The number of tokens burned.
650     uint256 private _burnCounter;
651 
652     // Token name
653     string private _name;
654 
655     // Token symbol
656     string private _symbol;
657 
658     // Mapping from token ID to ownership details
659     // An empty struct value does not necessarily mean the token is unowned.
660     // See {_packedOwnershipOf} implementation for details.
661     //
662     // Bits Layout:
663     // - [0..159]   `addr`
664     // - [160..223] `startTimestamp`
665     // - [224]      `burned`
666     // - [225]      `nextInitialized`
667     // - [232..255] `extraData`
668     mapping(uint256 => uint256) private _packedOwnerships;
669 
670     // Mapping owner address to address data.
671     //
672     // Bits Layout:
673     // - [0..63]    `balance`
674     // - [64..127]  `numberMinted`
675     // - [128..191] `numberBurned`
676     // - [192..255] `aux`
677     mapping(address => uint256) private _packedAddressData;
678 
679     // Mapping from token ID to approved address.
680     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
681 
682     // Mapping from owner to operator approvals
683     mapping(address => mapping(address => bool)) private _operatorApprovals;
684 
685     // =============================================================
686     //                          CONSTRUCTOR
687     // =============================================================
688 
689     constructor(string memory name_, string memory symbol_) {
690         _name = name_;
691         _symbol = symbol_;
692         _currentIndex = _startTokenId();
693     }
694 
695     // =============================================================
696     //                   TOKEN COUNTING OPERATIONS
697     // =============================================================
698 
699     /**
700      * @dev Returns the starting token ID.
701      * To change the starting token ID, please override this function.
702      */
703     function _startTokenId() internal view virtual returns (uint256) {
704         return 0;
705     }
706 
707     /**
708      * @dev Returns the next token ID to be minted.
709      */
710     function _nextTokenId() internal view virtual returns (uint256) {
711         return _currentIndex;
712     }
713 
714     /**
715      * @dev Returns the total number of tokens in existence.
716      * Burned tokens will reduce the count.
717      * To get the total number of tokens minted, please see {_totalMinted}.
718      */
719     function totalSupply() public view virtual override returns (uint256) {
720         // Counter underflow is impossible as _burnCounter cannot be incremented
721         // more than `_currentIndex - _startTokenId()` times.
722         unchecked {
723             return _currentIndex - _burnCounter - _startTokenId();
724         }
725     }
726 
727     /**
728      * @dev Returns the total amount of tokens minted in the contract.
729      */
730     function _totalMinted() internal view virtual returns (uint256) {
731         // Counter underflow is impossible as `_currentIndex` does not decrement,
732         // and it is initialized to `_startTokenId()`.
733         unchecked {
734             return _currentIndex - _startTokenId();
735         }
736     }
737 
738     /**
739      * @dev Returns the total number of tokens burned.
740      */
741     function _totalBurned() internal view virtual returns (uint256) {
742         return _burnCounter;
743     }
744 
745     // =============================================================
746     //                    ADDRESS DATA OPERATIONS
747     // =============================================================
748 
749     /**
750      * @dev Returns the number of tokens in `owner`'s account.
751      */
752     function balanceOf(address owner) public view virtual override returns (uint256) {
753         if (owner == address(0)) revert BalanceQueryForZeroAddress();
754         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
755     }
756 
757     /**
758      * Returns the number of tokens minted by `owner`.
759      */
760     function _numberMinted(address owner) internal view returns (uint256) {
761         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
762     }
763 
764     /**
765      * Returns the number of tokens burned by or on behalf of `owner`.
766      */
767     function _numberBurned(address owner) internal view returns (uint256) {
768         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
769     }
770 
771     /**
772      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
773      */
774     function _getAux(address owner) internal view returns (uint64) {
775         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
776     }
777 
778     /**
779      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
780      * If there are multiple variables, please pack them into a uint64.
781      */
782     function _setAux(address owner, uint64 aux) internal virtual {
783         uint256 packed = _packedAddressData[owner];
784         uint256 auxCasted;
785         // Cast `aux` with assembly to avoid redundant masking.
786         assembly {
787             auxCasted := aux
788         }
789         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
790         _packedAddressData[owner] = packed;
791     }
792 
793     // =============================================================
794     //                            IERC165
795     // =============================================================
796 
797     /**
798      * @dev Returns true if this contract implements the interface defined by
799      * `interfaceId`. See the corresponding
800      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
801      * to learn more about how these ids are created.
802      *
803      * This function call must use less than 30000 gas.
804      */
805     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
806         // The interface IDs are constants representing the first 4 bytes
807         // of the XOR of all function selectors in the interface.
808         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
809         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
810         return
811             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
812             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
813             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
814     }
815 
816     // =============================================================
817     //                        IERC721Metadata
818     // =============================================================
819 
820     /**
821      * @dev Returns the token collection name.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev Returns the token collection symbol.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
836      */
837     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
838         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
839 
840         string memory baseURI = _baseURI();
841         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
842     }
843 
844     /**
845      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
846      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
847      * by default, it can be overridden in child contracts.
848      */
849     function _baseURI() internal view virtual returns (string memory) {
850         return '';
851     }
852 
853     // =============================================================
854     //                     OWNERSHIPS OPERATIONS
855     // =============================================================
856 
857     /**
858      * @dev Returns the owner of the `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
865         return address(uint160(_packedOwnershipOf(tokenId)));
866     }
867 
868     /**
869      * @dev Gas spent here starts off proportional to the maximum mint batch size.
870      * It gradually moves to O(1) as tokens get transferred around over time.
871      */
872     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
873         return _unpackedOwnership(_packedOwnershipOf(tokenId));
874     }
875 
876     /**
877      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
878      */
879     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
880         return _unpackedOwnership(_packedOwnerships[index]);
881     }
882 
883     /**
884      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
885      */
886     function _initializeOwnershipAt(uint256 index) internal virtual {
887         if (_packedOwnerships[index] == 0) {
888             _packedOwnerships[index] = _packedOwnershipOf(index);
889         }
890     }
891 
892     /**
893      * Returns the packed ownership data of `tokenId`.
894      */
895     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
896         uint256 curr = tokenId;
897 
898         unchecked {
899             if (_startTokenId() <= curr)
900                 if (curr < _currentIndex) {
901                     uint256 packed = _packedOwnerships[curr];
902                     // If not burned.
903                     if (packed & _BITMASK_BURNED == 0) {
904                         // Invariant:
905                         // There will always be an initialized ownership slot
906                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
907                         // before an unintialized ownership slot
908                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
909                         // Hence, `curr` will not underflow.
910                         //
911                         // We can directly compare the packed value.
912                         // If the address is zero, packed will be zero.
913                         while (packed == 0) {
914                             packed = _packedOwnerships[--curr];
915                         }
916                         return packed;
917                     }
918                 }
919         }
920         revert OwnerQueryForNonexistentToken();
921     }
922 
923     /**
924      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
925      */
926     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
927         ownership.addr = address(uint160(packed));
928         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
929         ownership.burned = packed & _BITMASK_BURNED != 0;
930         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
931     }
932 
933     /**
934      * @dev Packs ownership data into a single uint256.
935      */
936     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
937         assembly {
938             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
939             owner := and(owner, _BITMASK_ADDRESS)
940             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
941             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
942         }
943     }
944 
945     /**
946      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
947      */
948     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
949         // For branchless setting of the `nextInitialized` flag.
950         assembly {
951             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
952             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
953         }
954     }
955 
956     // =============================================================
957     //                      APPROVAL OPERATIONS
958     // =============================================================
959 
960     /**
961      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
962      * The approval is cleared when the token is transferred.
963      *
964      * Only a single account can be approved at a time, so approving the
965      * zero address clears previous approvals.
966      *
967      * Requirements:
968      *
969      * - The caller must own the token or be an approved operator.
970      * - `tokenId` must exist.
971      *
972      * Emits an {Approval} event.
973      */
974     function approve(address to, uint256 tokenId) public virtual override {
975         address owner = ownerOf(tokenId);
976 
977         if (_msgSenderERC721A() != owner)
978             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
979                 revert ApprovalCallerNotOwnerNorApproved();
980             }
981 
982         _tokenApprovals[tokenId].value = to;
983         emit Approval(owner, to, tokenId);
984     }
985 
986     /**
987      * @dev Returns the account approved for `tokenId` token.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      */
993     function getApproved(uint256 tokenId) public view virtual override returns (address) {
994         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
995 
996         return _tokenApprovals[tokenId].value;
997     }
998 
999     /**
1000      * @dev Approve or remove `operator` as an operator for the caller.
1001      * Operators can call {transferFrom} or {safeTransferFrom}
1002      * for any token owned by the caller.
1003      *
1004      * Requirements:
1005      *
1006      * - The `operator` cannot be the caller.
1007      *
1008      * Emits an {ApprovalForAll} event.
1009      */
1010     function setApprovalForAll(address operator, bool approved) public virtual override {
1011         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1012 
1013         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1014         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1015     }
1016 
1017     /**
1018      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1019      *
1020      * See {setApprovalForAll}.
1021      */
1022     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1023         return _operatorApprovals[owner][operator];
1024     }
1025 
1026     /**
1027      * @dev Returns whether `tokenId` exists.
1028      *
1029      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1030      *
1031      * Tokens start existing when they are minted. See {_mint}.
1032      */
1033     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1034         return
1035             _startTokenId() <= tokenId &&
1036             tokenId < _currentIndex && // If within bounds,
1037             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1038     }
1039 
1040     /**
1041      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1042      */
1043     function _isSenderApprovedOrOwner(
1044         address approvedAddress,
1045         address owner,
1046         address msgSender
1047     ) private pure returns (bool result) {
1048         assembly {
1049             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1050             owner := and(owner, _BITMASK_ADDRESS)
1051             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1052             msgSender := and(msgSender, _BITMASK_ADDRESS)
1053             // `msgSender == owner || msgSender == approvedAddress`.
1054             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1055         }
1056     }
1057 
1058     /**
1059      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1060      */
1061     function _getApprovedSlotAndAddress(uint256 tokenId)
1062         private
1063         view
1064         returns (uint256 approvedAddressSlot, address approvedAddress)
1065     {
1066         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1067         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1068         assembly {
1069             approvedAddressSlot := tokenApproval.slot
1070             approvedAddress := sload(approvedAddressSlot)
1071         }
1072     }
1073 
1074     // =============================================================
1075     //                      TRANSFER OPERATIONS
1076     // =============================================================
1077 
1078     /**
1079      * @dev Transfers `tokenId` from `from` to `to`.
1080      *
1081      * Requirements:
1082      *
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must be owned by `from`.
1086      * - If the caller is not `from`, it must be approved to move this token
1087      * by either {approve} or {setApprovalForAll}.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1097 
1098         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1099 
1100         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1101 
1102         // The nested ifs save around 20+ gas over a compound boolean condition.
1103         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1104             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1105 
1106         if (to == address(0)) revert TransferToZeroAddress();
1107 
1108         _beforeTokenTransfers(from, to, tokenId, 1);
1109 
1110         // Clear approvals from the previous owner.
1111         assembly {
1112             if approvedAddress {
1113                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1114                 sstore(approvedAddressSlot, 0)
1115             }
1116         }
1117 
1118         // Underflow of the sender's balance is impossible because we check for
1119         // ownership above and the recipient's balance can't realistically overflow.
1120         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1121         unchecked {
1122             // We can directly increment and decrement the balances.
1123             --_packedAddressData[from]; // Updates: `balance -= 1`.
1124             ++_packedAddressData[to]; // Updates: `balance += 1`.
1125 
1126             // Updates:
1127             // - `address` to the next owner.
1128             // - `startTimestamp` to the timestamp of transfering.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `true`.
1131             _packedOwnerships[tokenId] = _packOwnershipData(
1132                 to,
1133                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1134             );
1135 
1136             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1137             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1138                 uint256 nextTokenId = tokenId + 1;
1139                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1140                 if (_packedOwnerships[nextTokenId] == 0) {
1141                     // If the next slot is within bounds.
1142                     if (nextTokenId != _currentIndex) {
1143                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1144                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1145                     }
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         safeTransferFrom(from, to, tokenId, '');
1163     }
1164 
1165     /**
1166      * @dev Safely transfers `tokenId` token from `from` to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `from` cannot be the zero address.
1171      * - `to` cannot be the zero address.
1172      * - `tokenId` token must exist and be owned by `from`.
1173      * - If the caller is not `from`, it must be approved to move this token
1174      * by either {approve} or {setApprovalForAll}.
1175      * - If `to` refers to a smart contract, it must implement
1176      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public virtual override {
1186         transferFrom(from, to, tokenId);
1187         if (to.code.length != 0)
1188             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1189                 revert TransferToNonERC721ReceiverImplementer();
1190             }
1191     }
1192 
1193     /**
1194      * @dev Hook that is called before a set of serially-ordered token IDs
1195      * are about to be transferred. This includes minting.
1196      * And also called before burning one token.
1197      *
1198      * `startTokenId` - the first token ID to be transferred.
1199      * `quantity` - the amount to be transferred.
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` will be minted for `to`.
1206      * - When `to` is zero, `tokenId` will be burned by `from`.
1207      * - `from` and `to` are never both zero.
1208      */
1209     function _beforeTokenTransfers(
1210         address from,
1211         address to,
1212         uint256 startTokenId,
1213         uint256 quantity
1214     ) internal virtual {}
1215 
1216     /**
1217      * @dev Hook that is called after a set of serially-ordered token IDs
1218      * have been transferred. This includes minting.
1219      * And also called after one token has been burned.
1220      *
1221      * `startTokenId` - the first token ID to be transferred.
1222      * `quantity` - the amount to be transferred.
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` has been minted for `to`.
1229      * - When `to` is zero, `tokenId` has been burned by `from`.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _afterTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 
1239     /**
1240      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1241      *
1242      * `from` - Previous owner of the given token ID.
1243      * `to` - Target address that will receive the token.
1244      * `tokenId` - Token ID to be transferred.
1245      * `_data` - Optional data to send along with the call.
1246      *
1247      * Returns whether the call correctly returned the expected magic value.
1248      */
1249     function _checkContractOnERC721Received(
1250         address from,
1251         address to,
1252         uint256 tokenId,
1253         bytes memory _data
1254     ) private returns (bool) {
1255         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1256             bytes4 retval
1257         ) {
1258             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1259         } catch (bytes memory reason) {
1260             if (reason.length == 0) {
1261                 revert TransferToNonERC721ReceiverImplementer();
1262             } else {
1263                 assembly {
1264                     revert(add(32, reason), mload(reason))
1265                 }
1266             }
1267         }
1268     }
1269 
1270     // =============================================================
1271     //                        MINT OPERATIONS
1272     // =============================================================
1273 
1274     /**
1275      * @dev Mints `quantity` tokens and transfers them to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - `to` cannot be the zero address.
1280      * - `quantity` must be greater than 0.
1281      *
1282      * Emits a {Transfer} event for each mint.
1283      */
1284     function _mint(address to, uint256 quantity) internal virtual {
1285         uint256 startTokenId = _currentIndex;
1286         if (quantity == 0) revert MintZeroQuantity();
1287 
1288         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1289 
1290         // Overflows are incredibly unrealistic.
1291         // `balance` and `numberMinted` have a maximum limit of 2**64.
1292         // `tokenId` has a maximum limit of 2**256.
1293         unchecked {
1294             // Updates:
1295             // - `balance += quantity`.
1296             // - `numberMinted += quantity`.
1297             //
1298             // We can directly add to the `balance` and `numberMinted`.
1299             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1300 
1301             // Updates:
1302             // - `address` to the owner.
1303             // - `startTimestamp` to the timestamp of minting.
1304             // - `burned` to `false`.
1305             // - `nextInitialized` to `quantity == 1`.
1306             _packedOwnerships[startTokenId] = _packOwnershipData(
1307                 to,
1308                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1309             );
1310 
1311             uint256 toMasked;
1312             uint256 end = startTokenId + quantity;
1313 
1314             // Use assembly to loop and emit the `Transfer` event for gas savings.
1315             assembly {
1316                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1317                 toMasked := and(to, _BITMASK_ADDRESS)
1318                 // Emit the `Transfer` event.
1319                 log4(
1320                     0, // Start of data (0, since no data).
1321                     0, // End of data (0, since no data).
1322                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1323                     0, // `address(0)`.
1324                     toMasked, // `to`.
1325                     startTokenId // `tokenId`.
1326                 )
1327 
1328                 for {
1329                     let tokenId := add(startTokenId, 1)
1330                 } iszero(eq(tokenId, end)) {
1331                     tokenId := add(tokenId, 1)
1332                 } {
1333                     // Emit the `Transfer` event. Similar to above.
1334                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1335                 }
1336             }
1337             if (toMasked == 0) revert MintToZeroAddress();
1338 
1339             _currentIndex = end;
1340         }
1341         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1342     }
1343 
1344     /**
1345      * @dev Mints `quantity` tokens and transfers them to `to`.
1346      *
1347      * This function is intended for efficient minting only during contract creation.
1348      *
1349      * It emits only one {ConsecutiveTransfer} as defined in
1350      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1351      * instead of a sequence of {Transfer} event(s).
1352      *
1353      * Calling this function outside of contract creation WILL make your contract
1354      * non-compliant with the ERC721 standard.
1355      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1356      * {ConsecutiveTransfer} event is only permissible during contract creation.
1357      *
1358      * Requirements:
1359      *
1360      * - `to` cannot be the zero address.
1361      * - `quantity` must be greater than 0.
1362      *
1363      * Emits a {ConsecutiveTransfer} event.
1364      */
1365     function _mintERC2309(address to, uint256 quantity) internal virtual {
1366         uint256 startTokenId = _currentIndex;
1367         if (to == address(0)) revert MintToZeroAddress();
1368         if (quantity == 0) revert MintZeroQuantity();
1369         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1370 
1371         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1372 
1373         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1374         unchecked {
1375             // Updates:
1376             // - `balance += quantity`.
1377             // - `numberMinted += quantity`.
1378             //
1379             // We can directly add to the `balance` and `numberMinted`.
1380             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1381 
1382             // Updates:
1383             // - `address` to the owner.
1384             // - `startTimestamp` to the timestamp of minting.
1385             // - `burned` to `false`.
1386             // - `nextInitialized` to `quantity == 1`.
1387             _packedOwnerships[startTokenId] = _packOwnershipData(
1388                 to,
1389                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1390             );
1391 
1392             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1393 
1394             _currentIndex = startTokenId + quantity;
1395         }
1396         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1397     }
1398 
1399     /**
1400      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1401      *
1402      * Requirements:
1403      *
1404      * - If `to` refers to a smart contract, it must implement
1405      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1406      * - `quantity` must be greater than 0.
1407      *
1408      * See {_mint}.
1409      *
1410      * Emits a {Transfer} event for each mint.
1411      */
1412     function _safeMint(
1413         address to,
1414         uint256 quantity,
1415         bytes memory _data
1416     ) internal virtual {
1417         _mint(to, quantity);
1418 
1419         unchecked {
1420             if (to.code.length != 0) {
1421                 uint256 end = _currentIndex;
1422                 uint256 index = end - quantity;
1423                 do {
1424                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1425                         revert TransferToNonERC721ReceiverImplementer();
1426                     }
1427                 } while (index < end);
1428                 // Reentrancy protection.
1429                 if (_currentIndex != end) revert();
1430             }
1431         }
1432     }
1433 
1434     /**
1435      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1436      */
1437     function _safeMint(address to, uint256 quantity) internal virtual {
1438         _safeMint(to, quantity, '');
1439     }
1440 
1441     // =============================================================
1442     //                        BURN OPERATIONS
1443     // =============================================================
1444 
1445     /**
1446      * @dev Equivalent to `_burn(tokenId, false)`.
1447      */
1448     function _burn(uint256 tokenId) internal virtual {
1449         _burn(tokenId, false);
1450     }
1451 
1452     /**
1453      * @dev Destroys `tokenId`.
1454      * The approval is cleared when the token is burned.
1455      *
1456      * Requirements:
1457      *
1458      * - `tokenId` must exist.
1459      *
1460      * Emits a {Transfer} event.
1461      */
1462     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1463         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1464 
1465         address from = address(uint160(prevOwnershipPacked));
1466 
1467         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1468 
1469         if (approvalCheck) {
1470             // The nested ifs save around 20+ gas over a compound boolean condition.
1471             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1472                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1473         }
1474 
1475         _beforeTokenTransfers(from, address(0), tokenId, 1);
1476 
1477         // Clear approvals from the previous owner.
1478         assembly {
1479             if approvedAddress {
1480                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1481                 sstore(approvedAddressSlot, 0)
1482             }
1483         }
1484 
1485         // Underflow of the sender's balance is impossible because we check for
1486         // ownership above and the recipient's balance can't realistically overflow.
1487         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1488         unchecked {
1489             // Updates:
1490             // - `balance -= 1`.
1491             // - `numberBurned += 1`.
1492             //
1493             // We can directly decrement the balance, and increment the number burned.
1494             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1495             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1496 
1497             // Updates:
1498             // - `address` to the last owner.
1499             // - `startTimestamp` to the timestamp of burning.
1500             // - `burned` to `true`.
1501             // - `nextInitialized` to `true`.
1502             _packedOwnerships[tokenId] = _packOwnershipData(
1503                 from,
1504                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1505             );
1506 
1507             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1508             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1509                 uint256 nextTokenId = tokenId + 1;
1510                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1511                 if (_packedOwnerships[nextTokenId] == 0) {
1512                     // If the next slot is within bounds.
1513                     if (nextTokenId != _currentIndex) {
1514                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1515                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1516                     }
1517                 }
1518             }
1519         }
1520 
1521         emit Transfer(from, address(0), tokenId);
1522         _afterTokenTransfers(from, address(0), tokenId, 1);
1523 
1524         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1525         unchecked {
1526             _burnCounter++;
1527         }
1528     }
1529 
1530     // =============================================================
1531     //                     EXTRA DATA OPERATIONS
1532     // =============================================================
1533 
1534     /**
1535      * @dev Directly sets the extra data for the ownership data `index`.
1536      */
1537     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1538         uint256 packed = _packedOwnerships[index];
1539         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1540         uint256 extraDataCasted;
1541         // Cast `extraData` with assembly to avoid redundant masking.
1542         assembly {
1543             extraDataCasted := extraData
1544         }
1545         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1546         _packedOwnerships[index] = packed;
1547     }
1548 
1549     /**
1550      * @dev Called during each token transfer to set the 24bit `extraData` field.
1551      * Intended to be overridden by the cosumer contract.
1552      *
1553      * `previousExtraData` - the value of `extraData` before transfer.
1554      *
1555      * Calling conditions:
1556      *
1557      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1558      * transferred to `to`.
1559      * - When `from` is zero, `tokenId` will be minted for `to`.
1560      * - When `to` is zero, `tokenId` will be burned by `from`.
1561      * - `from` and `to` are never both zero.
1562      */
1563     function _extraData(
1564         address from,
1565         address to,
1566         uint24 previousExtraData
1567     ) internal view virtual returns (uint24) {}
1568 
1569     /**
1570      * @dev Returns the next extra data for the packed ownership data.
1571      * The returned result is shifted into position.
1572      */
1573     function _nextExtraData(
1574         address from,
1575         address to,
1576         uint256 prevOwnershipPacked
1577     ) private view returns (uint256) {
1578         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1579         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1580     }
1581 
1582     // =============================================================
1583     //                       OTHER OPERATIONS
1584     // =============================================================
1585 
1586     /**
1587      * @dev Returns the message sender (defaults to `msg.sender`).
1588      *
1589      * If you are writing GSN compatible contracts, you need to override this function.
1590      */
1591     function _msgSenderERC721A() internal view virtual returns (address) {
1592         return msg.sender;
1593     }
1594 
1595     /**
1596      * @dev Converts a uint256 to its ASCII string decimal representation.
1597      */
1598     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1599         assembly {
1600             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1601             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1602             // We will need 1 32-byte word to store the length,
1603             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1604             str := add(mload(0x40), 0x80)
1605             // Update the free memory pointer to allocate.
1606             mstore(0x40, str)
1607 
1608             // Cache the end of the memory to calculate the length later.
1609             let end := str
1610 
1611             // We write the string from rightmost digit to leftmost digit.
1612             // The following is essentially a do-while loop that also handles the zero case.
1613             // prettier-ignore
1614             for { let temp := value } 1 {} {
1615                 str := sub(str, 1)
1616                 // Write the character to the pointer.
1617                 // The ASCII index of the '0' character is 48.
1618                 mstore8(str, add(48, mod(temp, 10)))
1619                 // Keep dividing `temp` until zero.
1620                 temp := div(temp, 10)
1621                 // prettier-ignore
1622                 if iszero(temp) { break }
1623             }
1624 
1625             let length := sub(end, str)
1626             // Move the pointer 32 bytes leftwards to make room for the length.
1627             str := sub(str, 0x20)
1628             // Store the length.
1629             mstore(str, length)
1630         }
1631     }
1632 }
1633 
1634 // File: WeAreBulls.sol
1635 
1636 
1637 
1638 pragma solidity >=0.8.9 <0.9.0;
1639 
1640 
1641 
1642 
1643 
1644 contract WeAreBulls is ERC721A, Ownable, ReentrancyGuard {
1645 
1646   using Strings for uint;
1647 
1648   string public uriPrefix = 'ipfs://bafybeibw2fvnt2hiqv5aw3cznsiuukl5ed4zb3ntbewtjgw4dwud7vo4i4/';
1649   string public uriSuffix = '.json';
1650   string public hiddenMetadataUri;
1651   
1652   uint public Cost = 0.002 ether;
1653   uint public MAXSUPPLY = 3333;
1654   uint public FREESUPPLY = 1000;
1655   uint public MAXPERWALLET = 10;
1656   uint public maxMintAmountPerTx = 2;
1657 
1658   bool public paused = true;
1659   bool public revealed = true;
1660 
1661   mapping(address => bool) public freeMintClaimed;
1662 
1663   constructor(
1664     string memory _tokenName,
1665     string memory _tokenSymbol,
1666     string memory _hiddenMetadataUri
1667   ) ERC721A(_tokenName, _tokenSymbol) {
1668     setHiddenMetadataUri(_hiddenMetadataUri);
1669   }
1670 
1671   // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1672   modifier mintCompliance(uint _mintAmount) {
1673     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1674     require(_mintAmount + balanceOf(_msgSender()) <= MAXPERWALLET, 'Only two allowed per wallet!');
1675     require(totalSupply() + _mintAmount <= MAXSUPPLY, 'Max supply exceeded!');
1676     _;
1677   }
1678 
1679   modifier mintPriceCompliance(uint _mintAmount) {
1680     if (freeMintClaimed[_msgSender()] || totalSupply() >= FREESUPPLY) {
1681       require(msg.value >= Cost * _mintAmount, 'Insufficient funds!');
1682     }
1683     _;
1684   }
1685 
1686   // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1687   function mint(uint _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1688     require(!paused, 'The contract is paused!');
1689     freeMintClaimed[_msgSender()] = true;
1690 
1691     _safeMint(_msgSender(), _mintAmount);
1692 
1693   }
1694   
1695   function mintForAddress(uint _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1696     _safeMint(_receiver, _mintAmount);
1697   }
1698 
1699   // ~~~~~~~~~~~~~~~~~~~~ Various Checks ~~~~~~~~~~~~~~~~~~~~
1700     function _baseURI() internal view virtual override returns (string memory) {
1701     return uriPrefix;
1702   }
1703 
1704   function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1705     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1706 
1707     if (revealed == false) {
1708       return hiddenMetadataUri;
1709     }
1710 
1711     string memory currentBaseURI = _baseURI();
1712     return bytes(currentBaseURI).length > 0
1713         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1714         : 'ipfs://bafybeibw2fvnt2hiqv5aw3cznsiuukl5ed4zb3ntbewtjgw4dwud7vo4i4/';
1715   }
1716 
1717   // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1718   function setRevealed(bool _state) public onlyOwner {
1719     revealed = _state;
1720   }
1721 
1722   function setCost(uint _Cost) public onlyOwner {
1723     Cost = _Cost;
1724   }
1725 
1726   function setMaxMintAmountPerTx(uint _maxMintAmountPerTx) public onlyOwner {
1727     maxMintAmountPerTx = _maxMintAmountPerTx;
1728   }
1729 
1730   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1731     hiddenMetadataUri = _hiddenMetadataUri;
1732   }
1733 
1734   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1735     uriPrefix = _uriPrefix;
1736   }
1737 
1738   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1739     uriSuffix = _uriSuffix;
1740   }
1741 
1742   function setPaused(bool _state) public onlyOwner {
1743     paused = _state;
1744   }
1745 
1746   function setFreeSupply(uint _freeQty) public onlyOwner {
1747     FREESUPPLY = _freeQty;
1748   }
1749 
1750   // ~~~~~~~~~~~~~~~~~~~~ Withdraw Functions ~~~~~~~~~~~~~~~~~~~~
1751   function withdraw() public onlyOwner nonReentrant {
1752     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1753     require(os);
1754   }
1755 /*
1756 
1757 */
1758 }