1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
71 }
72 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Contract module that helps prevent reentrant calls to a function.
81  *
82  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
83  * available, which can be applied to functions to make sure there are no nested
84  * (reentrant) calls to them.
85  *
86  * Note that because there is a single `nonReentrant` guard, functions marked as
87  * `nonReentrant` may not call one another. This can be worked around by making
88  * those functions `private`, and then adding `external` `nonReentrant` entry
89  * points to them.
90  *
91  * TIP: If you would like to learn more about reentrancy and alternative ways
92  * to protect against it, check out our blog post
93  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
94  */
95 abstract contract ReentrancyGuard {
96     // Booleans are more expensive than uint256 or any type that takes up a full
97     // word because each write operation emits an extra SLOAD to first read the
98     // slot's contents, replace the bits taken up by the boolean, and then write
99     // back. This is the compiler's defense against contract upgrades and
100     // pointer aliasing, and it cannot be disabled.
101 
102     // The values being non-zero value makes deployment a bit more expensive,
103     // but in exchange the refund on every call to nonReentrant will be lower in
104     // amount. Since refunds are capped to a percentage of the total
105     // transaction's gas, it is best to keep them low in cases like this one, to
106     // increase the likelihood of the full refund coming into effect.
107     uint256 private constant _NOT_ENTERED = 1;
108     uint256 private constant _ENTERED = 2;
109 
110     uint256 private _status;
111 
112     constructor() {
113         _status = _NOT_ENTERED;
114     }
115 
116     /**
117      * @dev Prevents a contract from calling itself, directly or indirectly.
118      * Calling a `nonReentrant` function from another `nonReentrant`
119      * function is not supported. It is possible to prevent this from happening
120      * by making the `nonReentrant` function external, and making it call a
121      * `private` function that does the actual work.
122      */
123     modifier nonReentrant() {
124         // On the first call to nonReentrant, _notEntered will be true
125         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
126 
127         // Any calls to nonReentrant after this point will fail
128         _status = _ENTERED;
129 
130         _;
131 
132         // By storing the original value once again, a refund is triggered (see
133         // https://eips.ethereum.org/EIPS/eip-2200)
134         _status = _NOT_ENTERED;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/utils/Context.sol
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/access/Ownable.sol
166 
167 
168 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 
173 /**
174  * @dev Contract module which provides a basic access control mechanism, where
175  * there is an account (an owner) that can be granted exclusive access to
176  * specific functions.
177  *
178  * By default, the owner account will be the one that deploys the contract. This
179  * can later be changed with {transferOwnership}.
180  *
181  * This module is used through inheritance. It will make available the modifier
182  * `onlyOwner`, which can be applied to your functions to restrict their use to
183  * the owner.
184  */
185 abstract contract Ownable is Context {
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     /**
191      * @dev Initializes the contract setting the deployer as the initial owner.
192      */
193     constructor() {
194         _transferOwnership(_msgSender());
195     }
196 
197     /**
198      * @dev Throws if called by any account other than the owner.
199      */
200     modifier onlyOwner() {
201         _checkOwner();
202         _;
203     }
204 
205     /**
206      * @dev Returns the address of the current owner.
207      */
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211 
212     /**
213      * @dev Throws if the sender is not the owner.
214      */
215     function _checkOwner() internal view virtual {
216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         _transferOwnership(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Internal function without access restriction.
242      */
243     function _transferOwnership(address newOwner) internal virtual {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 
250 // File: erc721a/contracts/IERC721A.sol
251 
252 
253 // ERC721A Contracts v4.2.2
254 // Creator: Chiru Labs
255 
256 pragma solidity ^0.8.4;
257 
258 /**
259  * @dev Interface of ERC721A.
260  */
261 interface IERC721A {
262     /**
263      * The caller must own the token or be an approved operator.
264      */
265     error ApprovalCallerNotOwnerNorApproved();
266 
267     /**
268      * The token does not exist.
269      */
270     error ApprovalQueryForNonexistentToken();
271 
272     /**
273      * The caller cannot approve to their own address.
274      */
275     error ApproveToCaller();
276 
277     /**
278      * Cannot query the balance for the zero address.
279      */
280     error BalanceQueryForZeroAddress();
281 
282     /**
283      * Cannot mint to the zero address.
284      */
285     error MintToZeroAddress();
286 
287     /**
288      * The quantity of tokens minted must be more than zero.
289      */
290     error MintZeroQuantity();
291 
292     /**
293      * The token does not exist.
294      */
295     error OwnerQueryForNonexistentToken();
296 
297     /**
298      * The caller must own the token or be an approved operator.
299      */
300     error TransferCallerNotOwnerNorApproved();
301 
302     /**
303      * The token must be owned by `from`.
304      */
305     error TransferFromIncorrectOwner();
306 
307     /**
308      * Cannot safely transfer to a contract that does not implement the
309      * ERC721Receiver interface.
310      */
311     error TransferToNonERC721ReceiverImplementer();
312 
313     /**
314      * Cannot transfer to the zero address.
315      */
316     error TransferToZeroAddress();
317 
318     /**
319      * The token does not exist.
320      */
321     error URIQueryForNonexistentToken();
322 
323     /**
324      * The `quantity` minted with ERC2309 exceeds the safety limit.
325      */
326     error MintERC2309QuantityExceedsLimit();
327 
328     /**
329      * The `extraData` cannot be set on an unintialized ownership slot.
330      */
331     error OwnershipNotInitializedForExtraData();
332 
333     // =============================================================
334     //                            STRUCTS
335     // =============================================================
336 
337     struct TokenOwnership {
338         // The address of the owner.
339         address addr;
340         // Stores the start time of ownership with minimal overhead for tokenomics.
341         uint64 startTimestamp;
342         // Whether the token has been burned.
343         bool burned;
344         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
345         uint24 extraData;
346     }
347 
348     // =============================================================
349     //                         TOKEN COUNTERS
350     // =============================================================
351 
352     /**
353      * @dev Returns the total number of tokens in existence.
354      * Burned tokens will reduce the count.
355      * To get the total number of tokens minted, please see {_totalMinted}.
356      */
357     function totalSupply() external view returns (uint256);
358 
359     // =============================================================
360     //                            IERC165
361     // =============================================================
362 
363     /**
364      * @dev Returns true if this contract implements the interface defined by
365      * `interfaceId`. See the corresponding
366      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
367      * to learn more about how these ids are created.
368      *
369      * This function call must use less than 30000 gas.
370      */
371     function supportsInterface(bytes4 interfaceId) external view returns (bool);
372 
373     // =============================================================
374     //                            IERC721
375     // =============================================================
376 
377     /**
378      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
384      */
385     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
386 
387     /**
388      * @dev Emitted when `owner` enables or disables
389      * (`approved`) `operator` to manage all of its assets.
390      */
391     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
392 
393     /**
394      * @dev Returns the number of tokens in `owner`'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`,
409      * checking first that contract recipients are aware of the ERC721 protocol
410      * to prevent tokens from being forever locked.
411      *
412      * Requirements:
413      *
414      * - `from` cannot be the zero address.
415      * - `to` cannot be the zero address.
416      * - `tokenId` token must exist and be owned by `from`.
417      * - If the caller is not `from`, it must be have been allowed to move
418      * this token by either {approve} or {setApprovalForAll}.
419      * - If `to` refers to a smart contract, it must implement
420      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId,
428         bytes calldata data
429     ) external;
430 
431     /**
432      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Transfers `tokenId` from `from` to `to`.
442      *
443      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
444      * whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token
452      * by either {approve} or {setApprovalForAll}.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external;
461 
462     /**
463      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
464      * The approval is cleared when the token is transferred.
465      *
466      * Only a single account can be approved at a time, so approving the
467      * zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Approve or remove `operator` as an operator for the caller.
480      * Operators can call {transferFrom} or {safeTransferFrom}
481      * for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns the account approved for `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function getApproved(uint256 tokenId) external view returns (address operator);
499 
500     /**
501      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
502      *
503      * See {setApprovalForAll}.
504      */
505     function isApprovedForAll(address owner, address operator) external view returns (bool);
506 
507     // =============================================================
508     //                        IERC721Metadata
509     // =============================================================
510 
511     /**
512      * @dev Returns the token collection name.
513      */
514     function name() external view returns (string memory);
515 
516     /**
517      * @dev Returns the token collection symbol.
518      */
519     function symbol() external view returns (string memory);
520 
521     /**
522      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
523      */
524     function tokenURI(uint256 tokenId) external view returns (string memory);
525 
526     // =============================================================
527     //                           IERC2309
528     // =============================================================
529 
530     /**
531      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
532      * (inclusive) is transferred from `from` to `to`, as defined in the
533      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
534      *
535      * See {_mintERC2309} for more details.
536      */
537     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
538 }
539 
540 // File: erc721a/contracts/ERC721A.sol
541 
542 
543 // ERC721A Contracts v4.2.2
544 // Creator: Chiru Labs
545 
546 pragma solidity ^0.8.4;
547 
548 
549 /**
550  * @dev Interface of ERC721 token receiver.
551  */
552 interface ERC721A__IERC721Receiver {
553     function onERC721Received(
554         address operator,
555         address from,
556         uint256 tokenId,
557         bytes calldata data
558     ) external returns (bytes4);
559 }
560 
561 /**
562  * @title ERC721A
563  *
564  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
565  * Non-Fungible Token Standard, including the Metadata extension.
566  * Optimized for lower gas during batch mints.
567  *
568  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
569  * starting from `_startTokenId()`.
570  *
571  * Assumptions:
572  *
573  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
574  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
575  */
576 contract ERC721A is IERC721A {
577     // Reference type for token approval.
578     struct TokenApprovalRef {
579         address value;
580     }
581 
582     // =============================================================
583     //                           CONSTANTS
584     // =============================================================
585 
586     // Mask of an entry in packed address data.
587     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
588 
589     // The bit position of `numberMinted` in packed address data.
590     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
591 
592     // The bit position of `numberBurned` in packed address data.
593     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
594 
595     // The bit position of `aux` in packed address data.
596     uint256 private constant _BITPOS_AUX = 192;
597 
598     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
599     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
600 
601     // The bit position of `startTimestamp` in packed ownership.
602     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
603 
604     // The bit mask of the `burned` bit in packed ownership.
605     uint256 private constant _BITMASK_BURNED = 1 << 224;
606 
607     // The bit position of the `nextInitialized` bit in packed ownership.
608     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
609 
610     // The bit mask of the `nextInitialized` bit in packed ownership.
611     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
612 
613     // The bit position of `extraData` in packed ownership.
614     uint256 private constant _BITPOS_EXTRA_DATA = 232;
615 
616     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
617     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
618 
619     // The mask of the lower 160 bits for addresses.
620     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
621 
622     // The maximum `quantity` that can be minted with {_mintERC2309}.
623     // This limit is to prevent overflows on the address data entries.
624     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
625     // is required to cause an overflow, which is unrealistic.
626     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
627 
628     // The `Transfer` event signature is given by:
629     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
630     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
631         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
632 
633     // =============================================================
634     //                            STORAGE
635     // =============================================================
636 
637     // The next token ID to be minted.
638     uint256 private _currentIndex;
639 
640     // The number of tokens burned.
641     uint256 private _burnCounter;
642 
643     // Token name
644     string private _name;
645 
646     // Token symbol
647     string private _symbol;
648 
649     // Mapping from token ID to ownership details
650     // An empty struct value does not necessarily mean the token is unowned.
651     // See {_packedOwnershipOf} implementation for details.
652     //
653     // Bits Layout:
654     // - [0..159]   `addr`
655     // - [160..223] `startTimestamp`
656     // - [224]      `burned`
657     // - [225]      `nextInitialized`
658     // - [232..255] `extraData`
659     mapping(uint256 => uint256) private _packedOwnerships;
660 
661     // Mapping owner address to address data.
662     //
663     // Bits Layout:
664     // - [0..63]    `balance`
665     // - [64..127]  `numberMinted`
666     // - [128..191] `numberBurned`
667     // - [192..255] `aux`
668     mapping(address => uint256) private _packedAddressData;
669 
670     // Mapping from token ID to approved address.
671     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     // =============================================================
677     //                          CONSTRUCTOR
678     // =============================================================
679 
680     constructor(string memory name_, string memory symbol_) {
681         _name = name_;
682         _symbol = symbol_;
683         _currentIndex = _startTokenId();
684     }
685 
686     // =============================================================
687     //                   TOKEN COUNTING OPERATIONS
688     // =============================================================
689 
690     /**
691      * @dev Returns the starting token ID.
692      * To change the starting token ID, please override this function.
693      */
694     function _startTokenId() internal view virtual returns (uint256) {
695         return 0;
696     }
697 
698     /**
699      * @dev Returns the next token ID to be minted.
700      */
701     function _nextTokenId() internal view virtual returns (uint256) {
702         return _currentIndex;
703     }
704 
705     /**
706      * @dev Returns the total number of tokens in existence.
707      * Burned tokens will reduce the count.
708      * To get the total number of tokens minted, please see {_totalMinted}.
709      */
710     function totalSupply() public view virtual override returns (uint256) {
711         // Counter underflow is impossible as _burnCounter cannot be incremented
712         // more than `_currentIndex - _startTokenId()` times.
713         unchecked {
714             return _currentIndex - _burnCounter - _startTokenId();
715         }
716     }
717 
718     /**
719      * @dev Returns the total amount of tokens minted in the contract.
720      */
721     function _totalMinted() internal view virtual returns (uint256) {
722         // Counter underflow is impossible as `_currentIndex` does not decrement,
723         // and it is initialized to `_startTokenId()`.
724         unchecked {
725             return _currentIndex - _startTokenId();
726         }
727     }
728 
729     /**
730      * @dev Returns the total number of tokens burned.
731      */
732     function _totalBurned() internal view virtual returns (uint256) {
733         return _burnCounter;
734     }
735 
736     // =============================================================
737     //                    ADDRESS DATA OPERATIONS
738     // =============================================================
739 
740     /**
741      * @dev Returns the number of tokens in `owner`'s account.
742      */
743     function balanceOf(address owner) public view virtual override returns (uint256) {
744         if (owner == address(0)) revert BalanceQueryForZeroAddress();
745         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
746     }
747 
748     /**
749      * Returns the number of tokens minted by `owner`.
750      */
751     function _numberMinted(address owner) internal view returns (uint256) {
752         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
753     }
754 
755     /**
756      * Returns the number of tokens burned by or on behalf of `owner`.
757      */
758     function _numberBurned(address owner) internal view returns (uint256) {
759         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
760     }
761 
762     /**
763      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
764      */
765     function _getAux(address owner) internal view returns (uint64) {
766         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
767     }
768 
769     /**
770      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
771      * If there are multiple variables, please pack them into a uint64.
772      */
773     function _setAux(address owner, uint64 aux) internal virtual {
774         uint256 packed = _packedAddressData[owner];
775         uint256 auxCasted;
776         // Cast `aux` with assembly to avoid redundant masking.
777         assembly {
778             auxCasted := aux
779         }
780         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
781         _packedAddressData[owner] = packed;
782     }
783 
784     // =============================================================
785     //                            IERC165
786     // =============================================================
787 
788     /**
789      * @dev Returns true if this contract implements the interface defined by
790      * `interfaceId`. See the corresponding
791      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
792      * to learn more about how these ids are created.
793      *
794      * This function call must use less than 30000 gas.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
797         // The interface IDs are constants representing the first 4 bytes
798         // of the XOR of all function selectors in the interface.
799         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
800         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
801         return
802             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
803             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
804             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
805     }
806 
807     // =============================================================
808     //                        IERC721Metadata
809     // =============================================================
810 
811     /**
812      * @dev Returns the token collection name.
813      */
814     function name() public view virtual override returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev Returns the token collection symbol.
820      */
821     function symbol() public view virtual override returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
827      */
828     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
829         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
830 
831         string memory baseURI = _baseURI();
832         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, it can be overridden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return '';
842     }
843 
844     // =============================================================
845     //                     OWNERSHIPS OPERATIONS
846     // =============================================================
847 
848     /**
849      * @dev Returns the owner of the `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
856         return address(uint160(_packedOwnershipOf(tokenId)));
857     }
858 
859     /**
860      * @dev Gas spent here starts off proportional to the maximum mint batch size.
861      * It gradually moves to O(1) as tokens get transferred around over time.
862      */
863     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
864         return _unpackedOwnership(_packedOwnershipOf(tokenId));
865     }
866 
867     /**
868      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
869      */
870     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
871         return _unpackedOwnership(_packedOwnerships[index]);
872     }
873 
874     /**
875      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
876      */
877     function _initializeOwnershipAt(uint256 index) internal virtual {
878         if (_packedOwnerships[index] == 0) {
879             _packedOwnerships[index] = _packedOwnershipOf(index);
880         }
881     }
882 
883     /**
884      * Returns the packed ownership data of `tokenId`.
885      */
886     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
887         uint256 curr = tokenId;
888 
889         unchecked {
890             if (_startTokenId() <= curr)
891                 if (curr < _currentIndex) {
892                     uint256 packed = _packedOwnerships[curr];
893                     // If not burned.
894                     if (packed & _BITMASK_BURNED == 0) {
895                         // Invariant:
896                         // There will always be an initialized ownership slot
897                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
898                         // before an unintialized ownership slot
899                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
900                         // Hence, `curr` will not underflow.
901                         //
902                         // We can directly compare the packed value.
903                         // If the address is zero, packed will be zero.
904                         while (packed == 0) {
905                             packed = _packedOwnerships[--curr];
906                         }
907                         return packed;
908                     }
909                 }
910         }
911         revert OwnerQueryForNonexistentToken();
912     }
913 
914     /**
915      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
916      */
917     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
918         ownership.addr = address(uint160(packed));
919         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
920         ownership.burned = packed & _BITMASK_BURNED != 0;
921         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
922     }
923 
924     /**
925      * @dev Packs ownership data into a single uint256.
926      */
927     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
928         assembly {
929             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
930             owner := and(owner, _BITMASK_ADDRESS)
931             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
932             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
933         }
934     }
935 
936     /**
937      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
938      */
939     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
940         // For branchless setting of the `nextInitialized` flag.
941         assembly {
942             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
943             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
944         }
945     }
946 
947     // =============================================================
948     //                      APPROVAL OPERATIONS
949     // =============================================================
950 
951     /**
952      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
953      * The approval is cleared when the token is transferred.
954      *
955      * Only a single account can be approved at a time, so approving the
956      * zero address clears previous approvals.
957      *
958      * Requirements:
959      *
960      * - The caller must own the token or be an approved operator.
961      * - `tokenId` must exist.
962      *
963      * Emits an {Approval} event.
964      */
965     function approve(address to, uint256 tokenId) public virtual override {
966         address owner = ownerOf(tokenId);
967 
968         if (_msgSenderERC721A() != owner)
969             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
970                 revert ApprovalCallerNotOwnerNorApproved();
971             }
972 
973         _tokenApprovals[tokenId].value = to;
974         emit Approval(owner, to, tokenId);
975     }
976 
977     /**
978      * @dev Returns the account approved for `tokenId` token.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      */
984     function getApproved(uint256 tokenId) public view virtual override returns (address) {
985         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
986 
987         return _tokenApprovals[tokenId].value;
988     }
989 
990     /**
991      * @dev Approve or remove `operator` as an operator for the caller.
992      * Operators can call {transferFrom} or {safeTransferFrom}
993      * for any token owned by the caller.
994      *
995      * Requirements:
996      *
997      * - The `operator` cannot be the caller.
998      *
999      * Emits an {ApprovalForAll} event.
1000      */
1001     function setApprovalForAll(address operator, bool approved) public virtual override {
1002         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1003 
1004         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1005         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1006     }
1007 
1008     /**
1009      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1010      *
1011      * See {setApprovalForAll}.
1012      */
1013     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1014         return _operatorApprovals[owner][operator];
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted. See {_mint}.
1023      */
1024     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1025         return
1026             _startTokenId() <= tokenId &&
1027             tokenId < _currentIndex && // If within bounds,
1028             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1029     }
1030 
1031     /**
1032      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1033      */
1034     function _isSenderApprovedOrOwner(
1035         address approvedAddress,
1036         address owner,
1037         address msgSender
1038     ) private pure returns (bool result) {
1039         assembly {
1040             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1041             owner := and(owner, _BITMASK_ADDRESS)
1042             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1043             msgSender := and(msgSender, _BITMASK_ADDRESS)
1044             // `msgSender == owner || msgSender == approvedAddress`.
1045             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1051      */
1052     function _getApprovedSlotAndAddress(uint256 tokenId)
1053         private
1054         view
1055         returns (uint256 approvedAddressSlot, address approvedAddress)
1056     {
1057         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1058         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1059         assembly {
1060             approvedAddressSlot := tokenApproval.slot
1061             approvedAddress := sload(approvedAddressSlot)
1062         }
1063     }
1064 
1065     // =============================================================
1066     //                      TRANSFER OPERATIONS
1067     // =============================================================
1068 
1069     /**
1070      * @dev Transfers `tokenId` from `from` to `to`.
1071      *
1072      * Requirements:
1073      *
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must be owned by `from`.
1077      * - If the caller is not `from`, it must be approved to move this token
1078      * by either {approve} or {setApprovalForAll}.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public virtual override {
1087         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1088 
1089         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1090 
1091         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1092 
1093         // The nested ifs save around 20+ gas over a compound boolean condition.
1094         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1095             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1096 
1097         if (to == address(0)) revert TransferToZeroAddress();
1098 
1099         _beforeTokenTransfers(from, to, tokenId, 1);
1100 
1101         // Clear approvals from the previous owner.
1102         assembly {
1103             if approvedAddress {
1104                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1105                 sstore(approvedAddressSlot, 0)
1106             }
1107         }
1108 
1109         // Underflow of the sender's balance is impossible because we check for
1110         // ownership above and the recipient's balance can't realistically overflow.
1111         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1112         unchecked {
1113             // We can directly increment and decrement the balances.
1114             --_packedAddressData[from]; // Updates: `balance -= 1`.
1115             ++_packedAddressData[to]; // Updates: `balance += 1`.
1116 
1117             // Updates:
1118             // - `address` to the next owner.
1119             // - `startTimestamp` to the timestamp of transfering.
1120             // - `burned` to `false`.
1121             // - `nextInitialized` to `true`.
1122             _packedOwnerships[tokenId] = _packOwnershipData(
1123                 to,
1124                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1125             );
1126 
1127             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1128             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1129                 uint256 nextTokenId = tokenId + 1;
1130                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1131                 if (_packedOwnerships[nextTokenId] == 0) {
1132                     // If the next slot is within bounds.
1133                     if (nextTokenId != _currentIndex) {
1134                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1135                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1136                     }
1137                 }
1138             }
1139         }
1140 
1141         emit Transfer(from, to, tokenId);
1142         _afterTokenTransfers(from, to, tokenId, 1);
1143     }
1144 
1145     /**
1146      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1147      */
1148     function safeTransferFrom(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) public virtual override {
1153         safeTransferFrom(from, to, tokenId, '');
1154     }
1155 
1156     /**
1157      * @dev Safely transfers `tokenId` token from `from` to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `from` cannot be the zero address.
1162      * - `to` cannot be the zero address.
1163      * - `tokenId` token must exist and be owned by `from`.
1164      * - If the caller is not `from`, it must be approved to move this token
1165      * by either {approve} or {setApprovalForAll}.
1166      * - If `to` refers to a smart contract, it must implement
1167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) public virtual override {
1177         transferFrom(from, to, tokenId);
1178         if (to.code.length != 0)
1179             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before a set of serially-ordered token IDs
1186      * are about to be transferred. This includes minting.
1187      * And also called before burning one token.
1188      *
1189      * `startTokenId` - the first token ID to be transferred.
1190      * `quantity` - the amount to be transferred.
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, `tokenId` will be burned by `from`.
1198      * - `from` and `to` are never both zero.
1199      */
1200     function _beforeTokenTransfers(
1201         address from,
1202         address to,
1203         uint256 startTokenId,
1204         uint256 quantity
1205     ) internal virtual {}
1206 
1207     /**
1208      * @dev Hook that is called after a set of serially-ordered token IDs
1209      * have been transferred. This includes minting.
1210      * And also called after one token has been burned.
1211      *
1212      * `startTokenId` - the first token ID to be transferred.
1213      * `quantity` - the amount to be transferred.
1214      *
1215      * Calling conditions:
1216      *
1217      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1218      * transferred to `to`.
1219      * - When `from` is zero, `tokenId` has been minted for `to`.
1220      * - When `to` is zero, `tokenId` has been burned by `from`.
1221      * - `from` and `to` are never both zero.
1222      */
1223     function _afterTokenTransfers(
1224         address from,
1225         address to,
1226         uint256 startTokenId,
1227         uint256 quantity
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1232      *
1233      * `from` - Previous owner of the given token ID.
1234      * `to` - Target address that will receive the token.
1235      * `tokenId` - Token ID to be transferred.
1236      * `_data` - Optional data to send along with the call.
1237      *
1238      * Returns whether the call correctly returned the expected magic value.
1239      */
1240     function _checkContractOnERC721Received(
1241         address from,
1242         address to,
1243         uint256 tokenId,
1244         bytes memory _data
1245     ) private returns (bool) {
1246         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1247             bytes4 retval
1248         ) {
1249             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1250         } catch (bytes memory reason) {
1251             if (reason.length == 0) {
1252                 revert TransferToNonERC721ReceiverImplementer();
1253             } else {
1254                 assembly {
1255                     revert(add(32, reason), mload(reason))
1256                 }
1257             }
1258         }
1259     }
1260 
1261     // =============================================================
1262     //                        MINT OPERATIONS
1263     // =============================================================
1264 
1265     /**
1266      * @dev Mints `quantity` tokens and transfers them to `to`.
1267      *
1268      * Requirements:
1269      *
1270      * - `to` cannot be the zero address.
1271      * - `quantity` must be greater than 0.
1272      *
1273      * Emits a {Transfer} event for each mint.
1274      */
1275     function _mint(address to, uint256 quantity) internal virtual {
1276         uint256 startTokenId = _currentIndex;
1277         if (quantity == 0) revert MintZeroQuantity();
1278 
1279         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1280 
1281         // Overflows are incredibly unrealistic.
1282         // `balance` and `numberMinted` have a maximum limit of 2**64.
1283         // `tokenId` has a maximum limit of 2**256.
1284         unchecked {
1285             // Updates:
1286             // - `balance += quantity`.
1287             // - `numberMinted += quantity`.
1288             //
1289             // We can directly add to the `balance` and `numberMinted`.
1290             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1291 
1292             // Updates:
1293             // - `address` to the owner.
1294             // - `startTimestamp` to the timestamp of minting.
1295             // - `burned` to `false`.
1296             // - `nextInitialized` to `quantity == 1`.
1297             _packedOwnerships[startTokenId] = _packOwnershipData(
1298                 to,
1299                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1300             );
1301 
1302             uint256 toMasked;
1303             uint256 end = startTokenId + quantity;
1304 
1305             // Use assembly to loop and emit the `Transfer` event for gas savings.
1306             assembly {
1307                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1308                 toMasked := and(to, _BITMASK_ADDRESS)
1309                 // Emit the `Transfer` event.
1310                 log4(
1311                     0, // Start of data (0, since no data).
1312                     0, // End of data (0, since no data).
1313                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1314                     0, // `address(0)`.
1315                     toMasked, // `to`.
1316                     startTokenId // `tokenId`.
1317                 )
1318 
1319                 for {
1320                     let tokenId := add(startTokenId, 1)
1321                 } iszero(eq(tokenId, end)) {
1322                     tokenId := add(tokenId, 1)
1323                 } {
1324                     // Emit the `Transfer` event. Similar to above.
1325                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1326                 }
1327             }
1328             if (toMasked == 0) revert MintToZeroAddress();
1329 
1330             _currentIndex = end;
1331         }
1332         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1333     }
1334 
1335     /**
1336      * @dev Mints `quantity` tokens and transfers them to `to`.
1337      *
1338      * This function is intended for efficient minting only during contract creation.
1339      *
1340      * It emits only one {ConsecutiveTransfer} as defined in
1341      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1342      * instead of a sequence of {Transfer} event(s).
1343      *
1344      * Calling this function outside of contract creation WILL make your contract
1345      * non-compliant with the ERC721 standard.
1346      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1347      * {ConsecutiveTransfer} event is only permissible during contract creation.
1348      *
1349      * Requirements:
1350      *
1351      * - `to` cannot be the zero address.
1352      * - `quantity` must be greater than 0.
1353      *
1354      * Emits a {ConsecutiveTransfer} event.
1355      */
1356     function _mintERC2309(address to, uint256 quantity) internal virtual {
1357         uint256 startTokenId = _currentIndex;
1358         if (to == address(0)) revert MintToZeroAddress();
1359         if (quantity == 0) revert MintZeroQuantity();
1360         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1361 
1362         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1363 
1364         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1365         unchecked {
1366             // Updates:
1367             // - `balance += quantity`.
1368             // - `numberMinted += quantity`.
1369             //
1370             // We can directly add to the `balance` and `numberMinted`.
1371             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1372 
1373             // Updates:
1374             // - `address` to the owner.
1375             // - `startTimestamp` to the timestamp of minting.
1376             // - `burned` to `false`.
1377             // - `nextInitialized` to `quantity == 1`.
1378             _packedOwnerships[startTokenId] = _packOwnershipData(
1379                 to,
1380                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1381             );
1382 
1383             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1384 
1385             _currentIndex = startTokenId + quantity;
1386         }
1387         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1388     }
1389 
1390     /**
1391      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1392      *
1393      * Requirements:
1394      *
1395      * - If `to` refers to a smart contract, it must implement
1396      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1397      * - `quantity` must be greater than 0.
1398      *
1399      * See {_mint}.
1400      *
1401      * Emits a {Transfer} event for each mint.
1402      */
1403     function _safeMint(
1404         address to,
1405         uint256 quantity,
1406         bytes memory _data
1407     ) internal virtual {
1408         _mint(to, quantity);
1409 
1410         unchecked {
1411             if (to.code.length != 0) {
1412                 uint256 end = _currentIndex;
1413                 uint256 index = end - quantity;
1414                 do {
1415                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1416                         revert TransferToNonERC721ReceiverImplementer();
1417                     }
1418                 } while (index < end);
1419                 // Reentrancy protection.
1420                 if (_currentIndex != end) revert();
1421             }
1422         }
1423     }
1424 
1425     /**
1426      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1427      */
1428     function _safeMint(address to, uint256 quantity) internal virtual {
1429         _safeMint(to, quantity, '');
1430     }
1431 
1432     // =============================================================
1433     //                        BURN OPERATIONS
1434     // =============================================================
1435 
1436     /**
1437      * @dev Equivalent to `_burn(tokenId, false)`.
1438      */
1439     function _burn(uint256 tokenId) internal virtual {
1440         _burn(tokenId, false);
1441     }
1442 
1443     /**
1444      * @dev Destroys `tokenId`.
1445      * The approval is cleared when the token is burned.
1446      *
1447      * Requirements:
1448      *
1449      * - `tokenId` must exist.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1454         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1455 
1456         address from = address(uint160(prevOwnershipPacked));
1457 
1458         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1459 
1460         if (approvalCheck) {
1461             // The nested ifs save around 20+ gas over a compound boolean condition.
1462             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1463                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1464         }
1465 
1466         _beforeTokenTransfers(from, address(0), tokenId, 1);
1467 
1468         // Clear approvals from the previous owner.
1469         assembly {
1470             if approvedAddress {
1471                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1472                 sstore(approvedAddressSlot, 0)
1473             }
1474         }
1475 
1476         // Underflow of the sender's balance is impossible because we check for
1477         // ownership above and the recipient's balance can't realistically overflow.
1478         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1479         unchecked {
1480             // Updates:
1481             // - `balance -= 1`.
1482             // - `numberBurned += 1`.
1483             //
1484             // We can directly decrement the balance, and increment the number burned.
1485             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1486             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1487 
1488             // Updates:
1489             // - `address` to the last owner.
1490             // - `startTimestamp` to the timestamp of burning.
1491             // - `burned` to `true`.
1492             // - `nextInitialized` to `true`.
1493             _packedOwnerships[tokenId] = _packOwnershipData(
1494                 from,
1495                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1496             );
1497 
1498             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1499             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1500                 uint256 nextTokenId = tokenId + 1;
1501                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1502                 if (_packedOwnerships[nextTokenId] == 0) {
1503                     // If the next slot is within bounds.
1504                     if (nextTokenId != _currentIndex) {
1505                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1506                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1507                     }
1508                 }
1509             }
1510         }
1511 
1512         emit Transfer(from, address(0), tokenId);
1513         _afterTokenTransfers(from, address(0), tokenId, 1);
1514 
1515         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1516         unchecked {
1517             _burnCounter++;
1518         }
1519     }
1520 
1521     // =============================================================
1522     //                     EXTRA DATA OPERATIONS
1523     // =============================================================
1524 
1525     /**
1526      * @dev Directly sets the extra data for the ownership data `index`.
1527      */
1528     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1529         uint256 packed = _packedOwnerships[index];
1530         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1531         uint256 extraDataCasted;
1532         // Cast `extraData` with assembly to avoid redundant masking.
1533         assembly {
1534             extraDataCasted := extraData
1535         }
1536         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1537         _packedOwnerships[index] = packed;
1538     }
1539 
1540     /**
1541      * @dev Called during each token transfer to set the 24bit `extraData` field.
1542      * Intended to be overridden by the cosumer contract.
1543      *
1544      * `previousExtraData` - the value of `extraData` before transfer.
1545      *
1546      * Calling conditions:
1547      *
1548      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1549      * transferred to `to`.
1550      * - When `from` is zero, `tokenId` will be minted for `to`.
1551      * - When `to` is zero, `tokenId` will be burned by `from`.
1552      * - `from` and `to` are never both zero.
1553      */
1554     function _extraData(
1555         address from,
1556         address to,
1557         uint24 previousExtraData
1558     ) internal view virtual returns (uint24) {}
1559 
1560     /**
1561      * @dev Returns the next extra data for the packed ownership data.
1562      * The returned result is shifted into position.
1563      */
1564     function _nextExtraData(
1565         address from,
1566         address to,
1567         uint256 prevOwnershipPacked
1568     ) private view returns (uint256) {
1569         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1570         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1571     }
1572 
1573     // =============================================================
1574     //                       OTHER OPERATIONS
1575     // =============================================================
1576 
1577     /**
1578      * @dev Returns the message sender (defaults to `msg.sender`).
1579      *
1580      * If you are writing GSN compatible contracts, you need to override this function.
1581      */
1582     function _msgSenderERC721A() internal view virtual returns (address) {
1583         return msg.sender;
1584     }
1585 
1586     /**
1587      * @dev Converts a uint256 to its ASCII string decimal representation.
1588      */
1589     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1590         assembly {
1591             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1592             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1593             // We will need 1 32-byte word to store the length,
1594             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1595             str := add(mload(0x40), 0x80)
1596             // Update the free memory pointer to allocate.
1597             mstore(0x40, str)
1598 
1599             // Cache the end of the memory to calculate the length later.
1600             let end := str
1601 
1602             // We write the string from rightmost digit to leftmost digit.
1603             // The following is essentially a do-while loop that also handles the zero case.
1604             // prettier-ignore
1605             for { let temp := value } 1 {} {
1606                 str := sub(str, 1)
1607                 // Write the character to the pointer.
1608                 // The ASCII index of the '0' character is 48.
1609                 mstore8(str, add(48, mod(temp, 10)))
1610                 // Keep dividing `temp` until zero.
1611                 temp := div(temp, 10)
1612                 // prettier-ignore
1613                 if iszero(temp) { break }
1614             }
1615 
1616             let length := sub(end, str)
1617             // Move the pointer 32 bytes leftwards to make room for the length.
1618             str := sub(str, 0x20)
1619             // Store the length.
1620             mstore(str, length)
1621         }
1622     }
1623 }
1624 
1625 // File: contracts/upsidedownbatz.sol
1626 
1627 
1628 
1629 pragma solidity >=0.8.9 <0.9.0;
1630 
1631 
1632 
1633 
1634 
1635 
1636 contract UpsideDownBatz is ERC721A, Ownable, ReentrancyGuard {
1637 using Strings for uint256;
1638 
1639   string public uriPrefix = 'ipfs://QmS7qjGt1yE3tv76G7JCZU4aDYWgbCnEyKm6pgEZyqwev7/';
1640   string public uriSuffix = '.json';
1641   string public hiddenMetadataUri = 'ipfs://QmS7qjGt1yE3tv76G7JCZU4aDYWgbCnEyKm6pgEZyqwev7/';
1642   
1643   uint256 public MoneyBatzNeed = 0 ether;
1644   uint256 public BatzChillingInCave = 7777;
1645   uint256 public MaxGreedAmount = 7; 
1646 
1647   bool public paused = true;
1648   bool public revealed = true;
1649   bool public teamMinted = false;
1650 
1651   constructor(
1652     string memory _tokenName,
1653     string memory _tokenSymbol,
1654     string memory _hiddenMetadataUri
1655   ) ERC721A(_tokenName, _tokenSymbol) {
1656     setHiddenMetadataUri(_hiddenMetadataUri);
1657   }
1658 
1659   modifier mintCompliance(uint256 _mintAmount) {
1660     require(_mintAmount > 0 && _mintAmount <= MaxGreedAmount, 'Invalid mint amount!');
1661     require(totalSupply() + _mintAmount <= BatzChillingInCave, 'Max supply exceeded!');
1662     _;
1663   }
1664   modifier mintPriceCompliance(uint256 _mintAmount) {
1665     require(msg.value >= MoneyBatzNeed * _mintAmount, 'Insufficient funds!');
1666     _;
1667   }
1668 
1669   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1670     require(!paused, 'The contract is paused!');
1671 
1672     _safeMint(_msgSender(), _mintAmount);
1673   }
1674   
1675   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1676     _safeMint(_receiver, _mintAmount);
1677   }
1678 
1679   function _startTokenId() internal view virtual override returns (uint256) {
1680     return 1;
1681   }
1682 
1683   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1684     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1685 
1686     if (revealed == false) {
1687       return hiddenMetadataUri;
1688     }
1689 
1690     string memory currentBaseURI = _baseURI();
1691     return bytes(currentBaseURI).length > 0
1692         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1693         : '';
1694   }
1695 
1696   function setRevealed(bool _state) public onlyOwner {
1697     revealed = _state;
1698   }
1699 
1700   function setMoneyBatzNeed(uint256 _MoneyBatzNeed) public onlyOwner {
1701     MoneyBatzNeed = _MoneyBatzNeed;
1702   }
1703 
1704   function setMaxGreedAmount(uint256 _MaxGreedAmount) public onlyOwner {
1705     MaxGreedAmount = _MaxGreedAmount;
1706   }
1707 
1708   function setBatzChillingInCave(uint256 _BatzChillingInCave) public onlyOwner {
1709     BatzChillingInCave = _BatzChillingInCave;
1710   }
1711 
1712   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1713     hiddenMetadataUri = _hiddenMetadataUri;
1714   }
1715 
1716   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1717     uriSuffix = _uriSuffix;
1718   }
1719 
1720   function setPaused(bool _state) public onlyOwner {
1721     paused = _state;
1722   }
1723 
1724   function withdraw() public onlyOwner nonReentrant {
1725     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1726     require(os);
1727   }
1728 
1729   function _baseURI() internal view virtual override returns (string memory) {
1730     return uriPrefix;
1731   }
1732     function teamMint() external onlyOwner{
1733         require(!teamMinted, "Already Minted");
1734         teamMinted = false;
1735         _safeMint(0xf11b62645aFa36C010554253eceFEb6840E8e187, 100);
1736         }
1737    }