1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 // SPDX-License-Identifier: MIT
3 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Strings.sol
67 
68 
69 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78     uint8 private constant _ADDRESS_LENGTH = 20;
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 
136     /**
137      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
138      */
139     function toHexString(address addr) internal pure returns (string memory) {
140         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
141     }
142 }
143 
144 // File: @openzeppelin/contracts/utils/Context.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Provides information about the current execution context, including the
153  * sender of the transaction and its data. While these are generally available
154  * via msg.sender and msg.data, they should not be accessed in such a direct
155  * manner, since when dealing with meta-transactions the account sending and
156  * paying for execution may not be the actual sender (as far as an application
157  * is concerned).
158  *
159  * This contract is only required for intermediate, library-like contracts.
160  */
161 abstract contract Context {
162     function _msgSender() internal view virtual returns (address) {
163         return msg.sender;
164     }
165 
166     function _msgData() internal view virtual returns (bytes calldata) {
167         return msg.data;
168     }
169 }
170 
171 // File: @openzeppelin/contracts/access/Ownable.sol
172 
173 
174 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 
179 /**
180  * @dev Contract module which provides a basic access control mechanism, where
181  * there is an account (an owner) that can be granted exclusive access to
182  * specific functions.
183  *
184  * By default, the owner account will be the one that deploys the contract. This
185  * can later be changed with {transferOwnership}.
186  *
187  * This module is used through inheritance. It will make available the modifier
188  * `onlyOwner`, which can be applied to your functions to restrict their use to
189  * the owner.
190  */
191 abstract contract Ownable is Context {
192     address private _owner;
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196     /**
197      * @dev Initializes the contract setting the deployer as the initial owner.
198      */
199     constructor() {
200         _transferOwnership(_msgSender());
201     }
202 
203     /**
204      * @dev Throws if called by any account other than the owner.
205      */
206     modifier onlyOwner() {
207         _checkOwner();
208         _;
209     }
210 
211     /**
212      * @dev Returns the address of the current owner.
213      */
214     function owner() public view virtual returns (address) {
215         return _owner;
216     }
217 
218     /**
219      * @dev Throws if the sender is not the owner.
220      */
221     function _checkOwner() internal view virtual {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223     }
224 
225     /**
226      * @dev Leaves the contract without owner. It will not be possible to call
227      * `onlyOwner` functions anymore. Can only be called by the current owner.
228      *
229      * NOTE: Renouncing ownership will leave the contract without an owner,
230      * thereby removing any functionality that is only available to the owner.
231      */
232     function renounceOwnership() public virtual onlyOwner {
233         _transferOwnership(address(0));
234     }
235 
236     /**
237      * @dev Transfers ownership of the contract to a new account (`newOwner`).
238      * Can only be called by the current owner.
239      */
240     function transferOwnership(address newOwner) public virtual onlyOwner {
241         require(newOwner != address(0), "Ownable: new owner is the zero address");
242         _transferOwnership(newOwner);
243     }
244 
245     /**
246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
247      * Internal function without access restriction.
248      */
249     function _transferOwnership(address newOwner) internal virtual {
250         address oldOwner = _owner;
251         _owner = newOwner;
252         emit OwnershipTransferred(oldOwner, newOwner);
253     }
254 }
255 
256 // File: erc721a/contracts/IERC721A.sol
257 
258 
259 // ERC721A Contracts v4.2.2
260 // Creator: Chiru Labs
261 
262 pragma solidity ^0.8.4;
263 
264 /**
265  * @dev Interface of ERC721A.
266  */
267 interface IERC721A {
268     /**
269      * The caller must own the token or be an approved operator.
270      */
271     error ApprovalCallerNotOwnerNorApproved();
272 
273     /**
274      * The token does not exist.
275      */
276     error ApprovalQueryForNonexistentToken();
277 
278     /**
279      * The caller cannot approve to their own address.
280      */
281     error ApproveToCaller();
282 
283     /**
284      * Cannot query the balance for the zero address.
285      */
286     error BalanceQueryForZeroAddress();
287 
288     /**
289      * Cannot mint to the zero address.
290      */
291     error MintToZeroAddress();
292 
293     /**
294      * The quantity of tokens minted must be more than zero.
295      */
296     error MintZeroQuantity();
297 
298     /**
299      * The token does not exist.
300      */
301     error OwnerQueryForNonexistentToken();
302 
303     /**
304      * The caller must own the token or be an approved operator.
305      */
306     error TransferCallerNotOwnerNorApproved();
307 
308     /**
309      * The token must be owned by `from`.
310      */
311     error TransferFromIncorrectOwner();
312 
313     /**
314      * Cannot safely transfer to a contract that does not implement the
315      * ERC721Receiver interface.
316      */
317     error TransferToNonERC721ReceiverImplementer();
318 
319     /**
320      * Cannot transfer to the zero address.
321      */
322     error TransferToZeroAddress();
323 
324     /**
325      * The token does not exist.
326      */
327     error URIQueryForNonexistentToken();
328 
329     /**
330      * The `quantity` minted with ERC2309 exceeds the safety limit.
331      */
332     error MintERC2309QuantityExceedsLimit();
333 
334     /**
335      * The `extraData` cannot be set on an unintialized ownership slot.
336      */
337     error OwnershipNotInitializedForExtraData();
338 
339     // =============================================================
340     //                            STRUCTS
341     // =============================================================
342 
343     struct TokenOwnership {
344         // The address of the owner.
345         address addr;
346         // Stores the start time of ownership with minimal overhead for tokenomics.
347         uint64 startTimestamp;
348         // Whether the token has been burned.
349         bool burned;
350         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
351         uint24 extraData;
352     }
353 
354     // =============================================================
355     //                         TOKEN COUNTERS
356     // =============================================================
357 
358     /**
359      * @dev Returns the total number of tokens in existence.
360      * Burned tokens will reduce the count.
361      * To get the total number of tokens minted, please see {_totalMinted}.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     // =============================================================
366     //                            IERC165
367     // =============================================================
368 
369     /**
370      * @dev Returns true if this contract implements the interface defined by
371      * `interfaceId`. See the corresponding
372      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
373      * to learn more about how these ids are created.
374      *
375      * This function call must use less than 30000 gas.
376      */
377     function supportsInterface(bytes4 interfaceId) external view returns (bool);
378 
379     // =============================================================
380     //                            IERC721
381     // =============================================================
382 
383     /**
384      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
390      */
391     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables or disables
395      * (`approved`) `operator` to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in `owner`'s account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the `tokenId` token.
406      *
407      * Requirements:
408      *
409      * - `tokenId` must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`,
415      * checking first that contract recipients are aware of the ERC721 protocol
416      * to prevent tokens from being forever locked.
417      *
418      * Requirements:
419      *
420      * - `from` cannot be the zero address.
421      * - `to` cannot be the zero address.
422      * - `tokenId` token must exist and be owned by `from`.
423      * - If the caller is not `from`, it must be have been allowed to move
424      * this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement
426      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
427      *
428      * Emits a {Transfer} event.
429      */
430     function safeTransferFrom(
431         address from,
432         address to,
433         uint256 tokenId,
434         bytes calldata data
435     ) external;
436 
437     /**
438      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
450      * whenever possible.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token
458      * by either {approve} or {setApprovalForAll}.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
470      * The approval is cleared when the token is transferred.
471      *
472      * Only a single account can be approved at a time, so approving the
473      * zero address clears previous approvals.
474      *
475      * Requirements:
476      *
477      * - The caller must own the token or be an approved operator.
478      * - `tokenId` must exist.
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address to, uint256 tokenId) external;
483 
484     /**
485      * @dev Approve or remove `operator` as an operator for the caller.
486      * Operators can call {transferFrom} or {safeTransferFrom}
487      * for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns the account approved for `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function getApproved(uint256 tokenId) external view returns (address operator);
505 
506     /**
507      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
508      *
509      * See {setApprovalForAll}.
510      */
511     function isApprovedForAll(address owner, address operator) external view returns (bool);
512 
513     // =============================================================
514     //                        IERC721Metadata
515     // =============================================================
516 
517     /**
518      * @dev Returns the token collection name.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the token collection symbol.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
529      */
530     function tokenURI(uint256 tokenId) external view returns (string memory);
531 
532     // =============================================================
533     //                           IERC2309
534     // =============================================================
535 
536     /**
537      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
538      * (inclusive) is transferred from `from` to `to`, as defined in the
539      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
540      *
541      * See {_mintERC2309} for more details.
542      */
543     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
544 }
545 
546 // File: erc721a/contracts/ERC721A.sol
547 
548 
549 // ERC721A Contracts v4.2.2
550 // Creator: Chiru Labs
551 
552 pragma solidity ^0.8.4;
553 
554 
555 /**
556  * @dev Interface of ERC721 token receiver.
557  */
558 interface ERC721A__IERC721Receiver {
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 /**
568  * @title ERC721A
569  *
570  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
571  * Non-Fungible Token Standard, including the Metadata extension.
572  * Optimized for lower gas during batch mints.
573  *
574  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
575  * starting from `_startTokenId()`.
576  *
577  * Assumptions:
578  *
579  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
580  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
581  */
582 contract ERC721A is IERC721A {
583     // Reference type for token approval.
584     struct TokenApprovalRef {
585         address value;
586     }
587 
588     // =============================================================
589     //                           CONSTANTS
590     // =============================================================
591 
592     // Mask of an entry in packed address data.
593     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
594 
595     // The bit position of `numberMinted` in packed address data.
596     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
597 
598     // The bit position of `numberBurned` in packed address data.
599     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
600 
601     // The bit position of `aux` in packed address data.
602     uint256 private constant _BITPOS_AUX = 192;
603 
604     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
605     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
606 
607     // The bit position of `startTimestamp` in packed ownership.
608     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
609 
610     // The bit mask of the `burned` bit in packed ownership.
611     uint256 private constant _BITMASK_BURNED = 1 << 224;
612 
613     // The bit position of the `nextInitialized` bit in packed ownership.
614     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
615 
616     // The bit mask of the `nextInitialized` bit in packed ownership.
617     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
618 
619     // The bit position of `extraData` in packed ownership.
620     uint256 private constant _BITPOS_EXTRA_DATA = 232;
621 
622     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
623     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
624 
625     // The mask of the lower 160 bits for addresses.
626     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
627 
628     // The maximum `quantity` that can be minted with {_mintERC2309}.
629     // This limit is to prevent overflows on the address data entries.
630     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
631     // is required to cause an overflow, which is unrealistic.
632     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
633 
634     // The `Transfer` event signature is given by:
635     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
636     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
637         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
638 
639     // =============================================================
640     //                            STORAGE
641     // =============================================================
642 
643     // The next token ID to be minted.
644     uint256 private _currentIndex;
645 
646     // The number of tokens burned.
647     uint256 private _burnCounter;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to ownership details
656     // An empty struct value does not necessarily mean the token is unowned.
657     // See {_packedOwnershipOf} implementation for details.
658     //
659     // Bits Layout:
660     // - [0..159]   `addr`
661     // - [160..223] `startTimestamp`
662     // - [224]      `burned`
663     // - [225]      `nextInitialized`
664     // - [232..255] `extraData`
665     mapping(uint256 => uint256) private _packedOwnerships;
666 
667     // Mapping owner address to address data.
668     //
669     // Bits Layout:
670     // - [0..63]    `balance`
671     // - [64..127]  `numberMinted`
672     // - [128..191] `numberBurned`
673     // - [192..255] `aux`
674     mapping(address => uint256) private _packedAddressData;
675 
676     // Mapping from token ID to approved address.
677     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
678 
679     // Mapping from owner to operator approvals
680     mapping(address => mapping(address => bool)) private _operatorApprovals;
681 
682     // =============================================================
683     //                          CONSTRUCTOR
684     // =============================================================
685 
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689         _currentIndex = _startTokenId();
690     }
691 
692     // =============================================================
693     //                   TOKEN COUNTING OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Returns the starting token ID.
698      * To change the starting token ID, please override this function.
699      */
700     function _startTokenId() internal view virtual returns (uint256) {
701         return 0;
702     }
703 
704     /**
705      * @dev Returns the next token ID to be minted.
706      */
707     function _nextTokenId() internal view virtual returns (uint256) {
708         return _currentIndex;
709     }
710 
711     /**
712      * @dev Returns the total number of tokens in existence.
713      * Burned tokens will reduce the count.
714      * To get the total number of tokens minted, please see {_totalMinted}.
715      */
716     function totalSupply() public view virtual override returns (uint256) {
717         // Counter underflow is impossible as _burnCounter cannot be incremented
718         // more than `_currentIndex - _startTokenId()` times.
719         unchecked {
720             return _currentIndex - _burnCounter - _startTokenId();
721         }
722     }
723 
724     /**
725      * @dev Returns the total amount of tokens minted in the contract.
726      */
727     function _totalMinted() internal view virtual returns (uint256) {
728         // Counter underflow is impossible as `_currentIndex` does not decrement,
729         // and it is initialized to `_startTokenId()`.
730         unchecked {
731             return _currentIndex - _startTokenId();
732         }
733     }
734 
735     /**
736      * @dev Returns the total number of tokens burned.
737      */
738     function _totalBurned() internal view virtual returns (uint256) {
739         return _burnCounter;
740     }
741 
742     // =============================================================
743     //                    ADDRESS DATA OPERATIONS
744     // =============================================================
745 
746     /**
747      * @dev Returns the number of tokens in `owner`'s account.
748      */
749     function balanceOf(address owner) public view virtual override returns (uint256) {
750         if (owner == address(0)) revert BalanceQueryForZeroAddress();
751         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
752     }
753 
754     /**
755      * Returns the number of tokens minted by `owner`.
756      */
757     function _numberMinted(address owner) internal view returns (uint256) {
758         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
759     }
760 
761     /**
762      * Returns the number of tokens burned by or on behalf of `owner`.
763      */
764     function _numberBurned(address owner) internal view returns (uint256) {
765         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
766     }
767 
768     /**
769      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
770      */
771     function _getAux(address owner) internal view returns (uint64) {
772         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
773     }
774 
775     /**
776      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
777      * If there are multiple variables, please pack them into a uint64.
778      */
779     function _setAux(address owner, uint64 aux) internal virtual {
780         uint256 packed = _packedAddressData[owner];
781         uint256 auxCasted;
782         // Cast `aux` with assembly to avoid redundant masking.
783         assembly {
784             auxCasted := aux
785         }
786         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
787         _packedAddressData[owner] = packed;
788     }
789 
790     // =============================================================
791     //                            IERC165
792     // =============================================================
793 
794     /**
795      * @dev Returns true if this contract implements the interface defined by
796      * `interfaceId`. See the corresponding
797      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
798      * to learn more about how these ids are created.
799      *
800      * This function call must use less than 30000 gas.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
803         // The interface IDs are constants representing the first 4 bytes
804         // of the XOR of all function selectors in the interface.
805         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
806         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
807         return
808             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
809             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
810             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
811     }
812 
813     // =============================================================
814     //                        IERC721Metadata
815     // =============================================================
816 
817     /**
818      * @dev Returns the token collection name.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev Returns the token collection symbol.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
833      */
834     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
835         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
836 
837         string memory baseURI = _baseURI();
838         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
839     }
840 
841     /**
842      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844      * by default, it can be overridden in child contracts.
845      */
846     function _baseURI() internal view virtual returns (string memory) {
847         return '';
848     }
849 
850     // =============================================================
851     //                     OWNERSHIPS OPERATIONS
852     // =============================================================
853 
854     /**
855      * @dev Returns the owner of the `tokenId` token.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      */
861     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
862         return address(uint160(_packedOwnershipOf(tokenId)));
863     }
864 
865     /**
866      * @dev Gas spent here starts off proportional to the maximum mint batch size.
867      * It gradually moves to O(1) as tokens get transferred around over time.
868      */
869     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
870         return _unpackedOwnership(_packedOwnershipOf(tokenId));
871     }
872 
873     /**
874      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
875      */
876     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
877         return _unpackedOwnership(_packedOwnerships[index]);
878     }
879 
880     /**
881      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
882      */
883     function _initializeOwnershipAt(uint256 index) internal virtual {
884         if (_packedOwnerships[index] == 0) {
885             _packedOwnerships[index] = _packedOwnershipOf(index);
886         }
887     }
888 
889     /**
890      * Returns the packed ownership data of `tokenId`.
891      */
892     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
893         uint256 curr = tokenId;
894 
895         unchecked {
896             if (_startTokenId() <= curr)
897                 if (curr < _currentIndex) {
898                     uint256 packed = _packedOwnerships[curr];
899                     // If not burned.
900                     if (packed & _BITMASK_BURNED == 0) {
901                         // Invariant:
902                         // There will always be an initialized ownership slot
903                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
904                         // before an unintialized ownership slot
905                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
906                         // Hence, `curr` will not underflow.
907                         //
908                         // We can directly compare the packed value.
909                         // If the address is zero, packed will be zero.
910                         while (packed == 0) {
911                             packed = _packedOwnerships[--curr];
912                         }
913                         return packed;
914                     }
915                 }
916         }
917         revert OwnerQueryForNonexistentToken();
918     }
919 
920     /**
921      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
922      */
923     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
924         ownership.addr = address(uint160(packed));
925         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
926         ownership.burned = packed & _BITMASK_BURNED != 0;
927         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
928     }
929 
930     /**
931      * @dev Packs ownership data into a single uint256.
932      */
933     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
934         assembly {
935             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
936             owner := and(owner, _BITMASK_ADDRESS)
937             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
938             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
939         }
940     }
941 
942     /**
943      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
944      */
945     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
946         // For branchless setting of the `nextInitialized` flag.
947         assembly {
948             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
949             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
950         }
951     }
952 
953     // =============================================================
954     //                      APPROVAL OPERATIONS
955     // =============================================================
956 
957     /**
958      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
959      * The approval is cleared when the token is transferred.
960      *
961      * Only a single account can be approved at a time, so approving the
962      * zero address clears previous approvals.
963      *
964      * Requirements:
965      *
966      * - The caller must own the token or be an approved operator.
967      * - `tokenId` must exist.
968      *
969      * Emits an {Approval} event.
970      */
971     function approve(address to, uint256 tokenId) public virtual override {
972         address owner = ownerOf(tokenId);
973 
974         if (_msgSenderERC721A() != owner)
975             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
976                 revert ApprovalCallerNotOwnerNorApproved();
977             }
978 
979         _tokenApprovals[tokenId].value = to;
980         emit Approval(owner, to, tokenId);
981     }
982 
983     /**
984      * @dev Returns the account approved for `tokenId` token.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function getApproved(uint256 tokenId) public view virtual override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId].value;
994     }
995 
996     /**
997      * @dev Approve or remove `operator` as an operator for the caller.
998      * Operators can call {transferFrom} or {safeTransferFrom}
999      * for any token owned by the caller.
1000      *
1001      * Requirements:
1002      *
1003      * - The `operator` cannot be the caller.
1004      *
1005      * Emits an {ApprovalForAll} event.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1009 
1010         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1011         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1012     }
1013 
1014     /**
1015      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1016      *
1017      * See {setApprovalForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1020         return _operatorApprovals[owner][operator];
1021     }
1022 
1023     /**
1024      * @dev Returns whether `tokenId` exists.
1025      *
1026      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1027      *
1028      * Tokens start existing when they are minted. See {_mint}.
1029      */
1030     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1031         return
1032             _startTokenId() <= tokenId &&
1033             tokenId < _currentIndex && // If within bounds,
1034             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1035     }
1036 
1037     /**
1038      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1039      */
1040     function _isSenderApprovedOrOwner(
1041         address approvedAddress,
1042         address owner,
1043         address msgSender
1044     ) private pure returns (bool result) {
1045         assembly {
1046             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1047             owner := and(owner, _BITMASK_ADDRESS)
1048             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1049             msgSender := and(msgSender, _BITMASK_ADDRESS)
1050             // `msgSender == owner || msgSender == approvedAddress`.
1051             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1052         }
1053     }
1054 
1055     /**
1056      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1057      */
1058     function _getApprovedSlotAndAddress(uint256 tokenId)
1059         private
1060         view
1061         returns (uint256 approvedAddressSlot, address approvedAddress)
1062     {
1063         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1064         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1065         assembly {
1066             approvedAddressSlot := tokenApproval.slot
1067             approvedAddress := sload(approvedAddressSlot)
1068         }
1069     }
1070 
1071     // =============================================================
1072     //                      TRANSFER OPERATIONS
1073     // =============================================================
1074 
1075     /**
1076      * @dev Transfers `tokenId` from `from` to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must be owned by `from`.
1083      * - If the caller is not `from`, it must be approved to move this token
1084      * by either {approve} or {setApprovalForAll}.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function transferFrom(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) public virtual override {
1093         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1094 
1095         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1096 
1097         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1098 
1099         // The nested ifs save around 20+ gas over a compound boolean condition.
1100         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1101             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1102 
1103         if (to == address(0)) revert TransferToZeroAddress();
1104 
1105         _beforeTokenTransfers(from, to, tokenId, 1);
1106 
1107         // Clear approvals from the previous owner.
1108         assembly {
1109             if approvedAddress {
1110                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1111                 sstore(approvedAddressSlot, 0)
1112             }
1113         }
1114 
1115         // Underflow of the sender's balance is impossible because we check for
1116         // ownership above and the recipient's balance can't realistically overflow.
1117         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1118         unchecked {
1119             // We can directly increment and decrement the balances.
1120             --_packedAddressData[from]; // Updates: `balance -= 1`.
1121             ++_packedAddressData[to]; // Updates: `balance += 1`.
1122 
1123             // Updates:
1124             // - `address` to the next owner.
1125             // - `startTimestamp` to the timestamp of transfering.
1126             // - `burned` to `false`.
1127             // - `nextInitialized` to `true`.
1128             _packedOwnerships[tokenId] = _packOwnershipData(
1129                 to,
1130                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1131             );
1132 
1133             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1134             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1135                 uint256 nextTokenId = tokenId + 1;
1136                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1137                 if (_packedOwnerships[nextTokenId] == 0) {
1138                     // If the next slot is within bounds.
1139                     if (nextTokenId != _currentIndex) {
1140                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1141                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1142                     }
1143                 }
1144             }
1145         }
1146 
1147         emit Transfer(from, to, tokenId);
1148         _afterTokenTransfers(from, to, tokenId, 1);
1149     }
1150 
1151     /**
1152      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1153      */
1154     function safeTransferFrom(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) public virtual override {
1159         safeTransferFrom(from, to, tokenId, '');
1160     }
1161 
1162     /**
1163      * @dev Safely transfers `tokenId` token from `from` to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must exist and be owned by `from`.
1170      * - If the caller is not `from`, it must be approved to move this token
1171      * by either {approve} or {setApprovalForAll}.
1172      * - If `to` refers to a smart contract, it must implement
1173      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function safeTransferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) public virtual override {
1183         transferFrom(from, to, tokenId);
1184         if (to.code.length != 0)
1185             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1186                 revert TransferToNonERC721ReceiverImplementer();
1187             }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before a set of serially-ordered token IDs
1192      * are about to be transferred. This includes minting.
1193      * And also called before burning one token.
1194      *
1195      * `startTokenId` - the first token ID to be transferred.
1196      * `quantity` - the amount to be transferred.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, `tokenId` will be burned by `from`.
1204      * - `from` and `to` are never both zero.
1205      */
1206     function _beforeTokenTransfers(
1207         address from,
1208         address to,
1209         uint256 startTokenId,
1210         uint256 quantity
1211     ) internal virtual {}
1212 
1213     /**
1214      * @dev Hook that is called after a set of serially-ordered token IDs
1215      * have been transferred. This includes minting.
1216      * And also called after one token has been burned.
1217      *
1218      * `startTokenId` - the first token ID to be transferred.
1219      * `quantity` - the amount to be transferred.
1220      *
1221      * Calling conditions:
1222      *
1223      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1224      * transferred to `to`.
1225      * - When `from` is zero, `tokenId` has been minted for `to`.
1226      * - When `to` is zero, `tokenId` has been burned by `from`.
1227      * - `from` and `to` are never both zero.
1228      */
1229     function _afterTokenTransfers(
1230         address from,
1231         address to,
1232         uint256 startTokenId,
1233         uint256 quantity
1234     ) internal virtual {}
1235 
1236     /**
1237      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1238      *
1239      * `from` - Previous owner of the given token ID.
1240      * `to` - Target address that will receive the token.
1241      * `tokenId` - Token ID to be transferred.
1242      * `_data` - Optional data to send along with the call.
1243      *
1244      * Returns whether the call correctly returned the expected magic value.
1245      */
1246     function _checkContractOnERC721Received(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes memory _data
1251     ) private returns (bool) {
1252         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1253             bytes4 retval
1254         ) {
1255             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1256         } catch (bytes memory reason) {
1257             if (reason.length == 0) {
1258                 revert TransferToNonERC721ReceiverImplementer();
1259             } else {
1260                 assembly {
1261                     revert(add(32, reason), mload(reason))
1262                 }
1263             }
1264         }
1265     }
1266 
1267     // =============================================================
1268     //                        MINT OPERATIONS
1269     // =============================================================
1270 
1271     /**
1272      * @dev Mints `quantity` tokens and transfers them to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - `to` cannot be the zero address.
1277      * - `quantity` must be greater than 0.
1278      *
1279      * Emits a {Transfer} event for each mint.
1280      */
1281     function _mint(address to, uint256 quantity) internal virtual {
1282         uint256 startTokenId = _currentIndex;
1283         if (quantity == 0) revert MintZeroQuantity();
1284 
1285         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1286 
1287         // Overflows are incredibly unrealistic.
1288         // `balance` and `numberMinted` have a maximum limit of 2**64.
1289         // `tokenId` has a maximum limit of 2**256.
1290         unchecked {
1291             // Updates:
1292             // - `balance += quantity`.
1293             // - `numberMinted += quantity`.
1294             //
1295             // We can directly add to the `balance` and `numberMinted`.
1296             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1297 
1298             // Updates:
1299             // - `address` to the owner.
1300             // - `startTimestamp` to the timestamp of minting.
1301             // - `burned` to `false`.
1302             // - `nextInitialized` to `quantity == 1`.
1303             _packedOwnerships[startTokenId] = _packOwnershipData(
1304                 to,
1305                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1306             );
1307 
1308             uint256 toMasked;
1309             uint256 end = startTokenId + quantity;
1310 
1311             // Use assembly to loop and emit the `Transfer` event for gas savings.
1312             assembly {
1313                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1314                 toMasked := and(to, _BITMASK_ADDRESS)
1315                 // Emit the `Transfer` event.
1316                 log4(
1317                     0, // Start of data (0, since no data).
1318                     0, // End of data (0, since no data).
1319                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1320                     0, // `address(0)`.
1321                     toMasked, // `to`.
1322                     startTokenId // `tokenId`.
1323                 )
1324 
1325                 for {
1326                     let tokenId := add(startTokenId, 1)
1327                 } iszero(eq(tokenId, end)) {
1328                     tokenId := add(tokenId, 1)
1329                 } {
1330                     // Emit the `Transfer` event. Similar to above.
1331                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1332                 }
1333             }
1334             if (toMasked == 0) revert MintToZeroAddress();
1335 
1336             _currentIndex = end;
1337         }
1338         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1339     }
1340 
1341     /**
1342      * @dev Mints `quantity` tokens and transfers them to `to`.
1343      *
1344      * This function is intended for efficient minting only during contract creation.
1345      *
1346      * It emits only one {ConsecutiveTransfer} as defined in
1347      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1348      * instead of a sequence of {Transfer} event(s).
1349      *
1350      * Calling this function outside of contract creation WILL make your contract
1351      * non-compliant with the ERC721 standard.
1352      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1353      * {ConsecutiveTransfer} event is only permissible during contract creation.
1354      *
1355      * Requirements:
1356      *
1357      * - `to` cannot be the zero address.
1358      * - `quantity` must be greater than 0.
1359      *
1360      * Emits a {ConsecutiveTransfer} event.
1361      */
1362     function _mintERC2309(address to, uint256 quantity) internal virtual {
1363         uint256 startTokenId = _currentIndex;
1364         if (to == address(0)) revert MintToZeroAddress();
1365         if (quantity == 0) revert MintZeroQuantity();
1366         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1367 
1368         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1369 
1370         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1371         unchecked {
1372             // Updates:
1373             // - `balance += quantity`.
1374             // - `numberMinted += quantity`.
1375             //
1376             // We can directly add to the `balance` and `numberMinted`.
1377             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1378 
1379             // Updates:
1380             // - `address` to the owner.
1381             // - `startTimestamp` to the timestamp of minting.
1382             // - `burned` to `false`.
1383             // - `nextInitialized` to `quantity == 1`.
1384             _packedOwnerships[startTokenId] = _packOwnershipData(
1385                 to,
1386                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1387             );
1388 
1389             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1390 
1391             _currentIndex = startTokenId + quantity;
1392         }
1393         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1394     }
1395 
1396     /**
1397      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1398      *
1399      * Requirements:
1400      *
1401      * - If `to` refers to a smart contract, it must implement
1402      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1403      * - `quantity` must be greater than 0.
1404      *
1405      * See {_mint}.
1406      *
1407      * Emits a {Transfer} event for each mint.
1408      */
1409     function _safeMint(
1410         address to,
1411         uint256 quantity,
1412         bytes memory _data
1413     ) internal virtual {
1414         _mint(to, quantity);
1415 
1416         unchecked {
1417             if (to.code.length != 0) {
1418                 uint256 end = _currentIndex;
1419                 uint256 index = end - quantity;
1420                 do {
1421                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1422                         revert TransferToNonERC721ReceiverImplementer();
1423                     }
1424                 } while (index < end);
1425                 // Reentrancy protection.
1426                 if (_currentIndex != end) revert();
1427             }
1428         }
1429     }
1430 
1431     /**
1432      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1433      */
1434     function _safeMint(address to, uint256 quantity) internal virtual {
1435         _safeMint(to, quantity, '');
1436     }
1437 
1438     // =============================================================
1439     //                        BURN OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Equivalent to `_burn(tokenId, false)`.
1444      */
1445     function _burn(uint256 tokenId) internal virtual {
1446         _burn(tokenId, false);
1447     }
1448 
1449     /**
1450      * @dev Destroys `tokenId`.
1451      * The approval is cleared when the token is burned.
1452      *
1453      * Requirements:
1454      *
1455      * - `tokenId` must exist.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1460         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1461 
1462         address from = address(uint160(prevOwnershipPacked));
1463 
1464         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1465 
1466         if (approvalCheck) {
1467             // The nested ifs save around 20+ gas over a compound boolean condition.
1468             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1469                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1470         }
1471 
1472         _beforeTokenTransfers(from, address(0), tokenId, 1);
1473 
1474         // Clear approvals from the previous owner.
1475         assembly {
1476             if approvedAddress {
1477                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1478                 sstore(approvedAddressSlot, 0)
1479             }
1480         }
1481 
1482         // Underflow of the sender's balance is impossible because we check for
1483         // ownership above and the recipient's balance can't realistically overflow.
1484         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1485         unchecked {
1486             // Updates:
1487             // - `balance -= 1`.
1488             // - `numberBurned += 1`.
1489             //
1490             // We can directly decrement the balance, and increment the number burned.
1491             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1492             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1493 
1494             // Updates:
1495             // - `address` to the last owner.
1496             // - `startTimestamp` to the timestamp of burning.
1497             // - `burned` to `true`.
1498             // - `nextInitialized` to `true`.
1499             _packedOwnerships[tokenId] = _packOwnershipData(
1500                 from,
1501                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1502             );
1503 
1504             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1505             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1506                 uint256 nextTokenId = tokenId + 1;
1507                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1508                 if (_packedOwnerships[nextTokenId] == 0) {
1509                     // If the next slot is within bounds.
1510                     if (nextTokenId != _currentIndex) {
1511                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1512                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1513                     }
1514                 }
1515             }
1516         }
1517 
1518         emit Transfer(from, address(0), tokenId);
1519         _afterTokenTransfers(from, address(0), tokenId, 1);
1520 
1521         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1522         unchecked {
1523             _burnCounter++;
1524         }
1525     }
1526 
1527     // =============================================================
1528     //                     EXTRA DATA OPERATIONS
1529     // =============================================================
1530 
1531     /**
1532      * @dev Directly sets the extra data for the ownership data `index`.
1533      */
1534     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1535         uint256 packed = _packedOwnerships[index];
1536         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1537         uint256 extraDataCasted;
1538         // Cast `extraData` with assembly to avoid redundant masking.
1539         assembly {
1540             extraDataCasted := extraData
1541         }
1542         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1543         _packedOwnerships[index] = packed;
1544     }
1545 
1546     /**
1547      * @dev Called during each token transfer to set the 24bit `extraData` field.
1548      * Intended to be overridden by the cosumer contract.
1549      *
1550      * `previousExtraData` - the value of `extraData` before transfer.
1551      *
1552      * Calling conditions:
1553      *
1554      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1555      * transferred to `to`.
1556      * - When `from` is zero, `tokenId` will be minted for `to`.
1557      * - When `to` is zero, `tokenId` will be burned by `from`.
1558      * - `from` and `to` are never both zero.
1559      */
1560     function _extraData(
1561         address from,
1562         address to,
1563         uint24 previousExtraData
1564     ) internal view virtual returns (uint24) {}
1565 
1566     /**
1567      * @dev Returns the next extra data for the packed ownership data.
1568      * The returned result is shifted into position.
1569      */
1570     function _nextExtraData(
1571         address from,
1572         address to,
1573         uint256 prevOwnershipPacked
1574     ) private view returns (uint256) {
1575         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1576         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1577     }
1578 
1579     // =============================================================
1580     //                       OTHER OPERATIONS
1581     // =============================================================
1582 
1583     /**
1584      * @dev Returns the message sender (defaults to `msg.sender`).
1585      *
1586      * If you are writing GSN compatible contracts, you need to override this function.
1587      */
1588     function _msgSenderERC721A() internal view virtual returns (address) {
1589         return msg.sender;
1590     }
1591 
1592     /**
1593      * @dev Converts a uint256 to its ASCII string decimal representation.
1594      */
1595     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1596         assembly {
1597             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1598             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1599             // We will need 1 32-byte word to store the length,
1600             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1601             str := add(mload(0x40), 0x80)
1602             // Update the free memory pointer to allocate.
1603             mstore(0x40, str)
1604 
1605             // Cache the end of the memory to calculate the length later.
1606             let end := str
1607 
1608             // We write the string from rightmost digit to leftmost digit.
1609             // The following is essentially a do-while loop that also handles the zero case.
1610             // prettier-ignore
1611             for { let temp := value } 1 {} {
1612                 str := sub(str, 1)
1613                 // Write the character to the pointer.
1614                 // The ASCII index of the '0' character is 48.
1615                 mstore8(str, add(48, mod(temp, 10)))
1616                 // Keep dividing `temp` until zero.
1617                 temp := div(temp, 10)
1618                 // prettier-ignore
1619                 if iszero(temp) { break }
1620             }
1621 
1622             let length := sub(end, str)
1623             // Move the pointer 32 bytes leftwards to make room for the length.
1624             str := sub(str, 0x20)
1625             // Store the length.
1626             mstore(str, length)
1627         }
1628     }
1629 }
1630 
1631 // File: DalleWalle.sol
1632 
1633 
1634 
1635 pragma solidity >=0.8.9 <0.9.0;
1636 
1637 
1638 
1639 
1640 
1641 contract DalleWalle is ERC721A, Ownable, ReentrancyGuard {
1642 
1643   using Strings for uint;
1644 
1645   string public uriPrefix = '';
1646   string public uriSuffix = '.json';
1647   string public hiddenMetadataUri;
1648   
1649   uint public cost = 0.02 ether;
1650   uint public MAXSUPPLY = 999;
1651   uint public FREESUPPLY = 750;
1652   uint public MAXPERWALLET = 5;
1653   uint public maxMintAmountPerTx = 5;
1654 
1655   bool public paused = true;
1656   bool public revealed = true;
1657 
1658   mapping(address => bool) public freeMintClaimed;
1659 
1660   constructor(
1661     string memory _tokenName,
1662     string memory _tokenSymbol,
1663     string memory _hiddenMetadataUri
1664   ) ERC721A(_tokenName, _tokenSymbol) {
1665     setHiddenMetadataUri(_hiddenMetadataUri);
1666   }
1667 
1668   // ~~~~~~~~~~~~~~~~~~~~ Modifiers ~~~~~~~~~~~~~~~~~~~~
1669   modifier mintCompliance(uint _mintAmount) {
1670     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1671     require(_mintAmount + balanceOf(_msgSender()) <= MAXPERWALLET, 'Only two allowed per wallet!');
1672     require(totalSupply() + _mintAmount <= MAXSUPPLY, 'Max supply exceeded!');
1673     _;
1674   }
1675 
1676   modifier mintPriceCompliance(uint _mintAmount) {
1677     if (freeMintClaimed[_msgSender()] || totalSupply() >= FREESUPPLY) {
1678       require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1679     }
1680     _;
1681   }
1682 
1683   // ~~~~~~~~~~~~~~~~~~~~ Mint Functions ~~~~~~~~~~~~~~~~~~~~
1684   function mint(uint _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1685     require(!paused, 'The contract is paused!');
1686     freeMintClaimed[_msgSender()] = true;
1687 
1688     _safeMint(_msgSender(), _mintAmount);
1689 
1690   }
1691   
1692   function mintForAddress(uint _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1693     _safeMint(_receiver, _mintAmount);
1694   }
1695 
1696   // ~~~~~~~~~~~~~~~~~~~~ Various Checks ~~~~~~~~~~~~~~~~~~~~
1697     function _baseURI() internal view virtual override returns (string memory) {
1698     return uriPrefix;
1699   }
1700 
1701   function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1702     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1703 
1704     if (revealed == false) {
1705       return hiddenMetadataUri;
1706     }
1707 
1708     string memory currentBaseURI = _baseURI();
1709     return bytes(currentBaseURI).length > 0
1710         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1711         : 'QmXi7Gpqk2NHh7Y1vYxPzrDJxsinrPR4Fzh4mtghkR7Q5T';
1712   }
1713 
1714   // ~~~~~~~~~~~~~~~~~~~~ onlyOwner Functions ~~~~~~~~~~~~~~~~~~~~
1715   function setRevealed(bool _state) public onlyOwner {
1716     revealed = _state;
1717   }
1718 
1719   function setCost(uint _cost) public onlyOwner {
1720     cost = _cost;
1721   }
1722 
1723   function setMaxMintAmountPerTx(uint _maxMintAmountPerTx) public onlyOwner {
1724     maxMintAmountPerTx = _maxMintAmountPerTx;
1725   }
1726 
1727   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1728     hiddenMetadataUri = _hiddenMetadataUri;
1729   }
1730 
1731   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1732     uriPrefix = _uriPrefix;
1733   }
1734 
1735   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1736     uriSuffix = _uriSuffix;
1737   }
1738 
1739   function setPaused(bool _state) public onlyOwner {
1740     paused = _state;
1741   }
1742 
1743   function setFreeSupply(uint _freeQty) public onlyOwner {
1744     FREESUPPLY = _freeQty;
1745   }
1746 
1747   // ~~~~~~~~~~~~~~~~~~~~ Withdraw Functions ~~~~~~~~~~~~~~~~~~~~
1748   function withdraw() public onlyOwner nonReentrant {
1749     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1750     require(os);
1751   }
1752 /*
1753 
1754 */
1755 }