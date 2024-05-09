1 // File: @openzeppelin/contracts@4.7.3/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts@4.7.3/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts@4.7.3/security/ReentrancyGuard.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Contract module that helps prevent reentrant calls to a function.
122  *
123  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
124  * available, which can be applied to functions to make sure there are no nested
125  * (reentrant) calls to them.
126  *
127  * Note that because there is a single `nonReentrant` guard, functions marked as
128  * `nonReentrant` may not call one another. This can be worked around by making
129  * those functions `private`, and then adding `external` `nonReentrant` entry
130  * points to them.
131  *
132  * TIP: If you would like to learn more about reentrancy and alternative ways
133  * to protect against it, check out our blog post
134  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
135  */
136 abstract contract ReentrancyGuard {
137     // Booleans are more expensive than uint256 or any type that takes up a full
138     // word because each write operation emits an extra SLOAD to first read the
139     // slot's contents, replace the bits taken up by the boolean, and then write
140     // back. This is the compiler's defense against contract upgrades and
141     // pointer aliasing, and it cannot be disabled.
142 
143     // The values being non-zero value makes deployment a bit more expensive,
144     // but in exchange the refund on every call to nonReentrant will be lower in
145     // amount. Since refunds are capped to a percentage of the total
146     // transaction's gas, it is best to keep them low in cases like this one, to
147     // increase the likelihood of the full refund coming into effect.
148     uint256 private constant _NOT_ENTERED = 1;
149     uint256 private constant _ENTERED = 2;
150 
151     uint256 private _status;
152 
153     constructor() {
154         _status = _NOT_ENTERED;
155     }
156 
157     /**
158      * @dev Prevents a contract from calling itself, directly or indirectly.
159      * Calling a `nonReentrant` function from another `nonReentrant`
160      * function is not supported. It is possible to prevent this from happening
161      * by making the `nonReentrant` function external, and making it call a
162      * `private` function that does the actual work.
163      */
164     modifier nonReentrant() {
165         // On the first call to nonReentrant, _notEntered will be true
166         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
167 
168         // Any calls to nonReentrant after this point will fail
169         _status = _ENTERED;
170 
171         _;
172 
173         // By storing the original value once again, a refund is triggered (see
174         // https://eips.ethereum.org/EIPS/eip-2200)
175         _status = _NOT_ENTERED;
176     }
177 }
178 
179 // File: @openzeppelin/contracts@4.7.3/utils/Strings.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev String operations.
188  */
189 library Strings {
190     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
191     uint8 private constant _ADDRESS_LENGTH = 20;
192 
193     /**
194      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
195      */
196     function toString(uint256 value) internal pure returns (string memory) {
197         // Inspired by OraclizeAPI's implementation - MIT licence
198         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
199 
200         if (value == 0) {
201             return "0";
202         }
203         uint256 temp = value;
204         uint256 digits;
205         while (temp != 0) {
206             digits++;
207             temp /= 10;
208         }
209         bytes memory buffer = new bytes(digits);
210         while (value != 0) {
211             digits -= 1;
212             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
213             value /= 10;
214         }
215         return string(buffer);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
220      */
221     function toHexString(uint256 value) internal pure returns (string memory) {
222         if (value == 0) {
223             return "0x00";
224         }
225         uint256 temp = value;
226         uint256 length = 0;
227         while (temp != 0) {
228             length++;
229             temp >>= 8;
230         }
231         return toHexString(value, length);
232     }
233 
234     /**
235      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
236      */
237     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
238         bytes memory buffer = new bytes(2 * length + 2);
239         buffer[0] = "0";
240         buffer[1] = "x";
241         for (uint256 i = 2 * length + 1; i > 1; --i) {
242             buffer[i] = _HEX_SYMBOLS[value & 0xf];
243             value >>= 4;
244         }
245         require(value == 0, "Strings: hex length insufficient");
246         return string(buffer);
247     }
248 
249     /**
250      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
251      */
252     function toHexString(address addr) internal pure returns (string memory) {
253         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
254     }
255 }
256 
257 // File: erc721a@4.2.3/contracts/IERC721A.sol
258 
259 
260 // ERC721A Contracts v4.2.3
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
280      * Cannot query the balance for the zero address.
281      */
282     error BalanceQueryForZeroAddress();
283 
284     /**
285      * Cannot mint to the zero address.
286      */
287     error MintToZeroAddress();
288 
289     /**
290      * The quantity of tokens minted must be more than zero.
291      */
292     error MintZeroQuantity();
293 
294     /**
295      * The token does not exist.
296      */
297     error OwnerQueryForNonexistentToken();
298 
299     /**
300      * The caller must own the token or be an approved operator.
301      */
302     error TransferCallerNotOwnerNorApproved();
303 
304     /**
305      * The token must be owned by `from`.
306      */
307     error TransferFromIncorrectOwner();
308 
309     /**
310      * Cannot safely transfer to a contract that does not implement the
311      * ERC721Receiver interface.
312      */
313     error TransferToNonERC721ReceiverImplementer();
314 
315     /**
316      * Cannot transfer to the zero address.
317      */
318     error TransferToZeroAddress();
319 
320     /**
321      * The token does not exist.
322      */
323     error URIQueryForNonexistentToken();
324 
325     /**
326      * The `quantity` minted with ERC2309 exceeds the safety limit.
327      */
328     error MintERC2309QuantityExceedsLimit();
329 
330     /**
331      * The `extraData` cannot be set on an unintialized ownership slot.
332      */
333     error OwnershipNotInitializedForExtraData();
334 
335     // =============================================================
336     //                            STRUCTS
337     // =============================================================
338 
339     struct TokenOwnership {
340         // The address of the owner.
341         address addr;
342         // Stores the start time of ownership with minimal overhead for tokenomics.
343         uint64 startTimestamp;
344         // Whether the token has been burned.
345         bool burned;
346         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
347         uint24 extraData;
348     }
349 
350     // =============================================================
351     //                         TOKEN COUNTERS
352     // =============================================================
353 
354     /**
355      * @dev Returns the total number of tokens in existence.
356      * Burned tokens will reduce the count.
357      * To get the total number of tokens minted, please see {_totalMinted}.
358      */
359     function totalSupply() external view returns (uint256);
360 
361     // =============================================================
362     //                            IERC165
363     // =============================================================
364 
365     /**
366      * @dev Returns true if this contract implements the interface defined by
367      * `interfaceId`. See the corresponding
368      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
369      * to learn more about how these ids are created.
370      *
371      * This function call must use less than 30000 gas.
372      */
373     function supportsInterface(bytes4 interfaceId) external view returns (bool);
374 
375     // =============================================================
376     //                            IERC721
377     // =============================================================
378 
379     /**
380      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
381      */
382     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
383 
384     /**
385      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
386      */
387     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when `owner` enables or disables
391      * (`approved`) `operator` to manage all of its assets.
392      */
393     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
394 
395     /**
396      * @dev Returns the number of tokens in `owner`'s account.
397      */
398     function balanceOf(address owner) external view returns (uint256 balance);
399 
400     /**
401      * @dev Returns the owner of the `tokenId` token.
402      *
403      * Requirements:
404      *
405      * - `tokenId` must exist.
406      */
407     function ownerOf(uint256 tokenId) external view returns (address owner);
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`,
411      * checking first that contract recipients are aware of the ERC721 protocol
412      * to prevent tokens from being forever locked.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be have been allowed to move
420      * this token by either {approve} or {setApprovalForAll}.
421      * - If `to` refers to a smart contract, it must implement
422      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
423      *
424      * Emits a {Transfer} event.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId,
430         bytes calldata data
431     ) external payable;
432 
433     /**
434      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external payable;
441 
442     /**
443      * @dev Transfers `tokenId` from `from` to `to`.
444      *
445      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
446      * whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token
454      * by either {approve} or {setApprovalForAll}.
455      *
456      * Emits a {Transfer} event.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external payable;
463 
464     /**
465      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
466      * The approval is cleared when the token is transferred.
467      *
468      * Only a single account can be approved at a time, so approving the
469      * zero address clears previous approvals.
470      *
471      * Requirements:
472      *
473      * - The caller must own the token or be an approved operator.
474      * - `tokenId` must exist.
475      *
476      * Emits an {Approval} event.
477      */
478     function approve(address to, uint256 tokenId) external payable;
479 
480     /**
481      * @dev Approve or remove `operator` as an operator for the caller.
482      * Operators can call {transferFrom} or {safeTransferFrom}
483      * for any token owned by the caller.
484      *
485      * Requirements:
486      *
487      * - The `operator` cannot be the caller.
488      *
489      * Emits an {ApprovalForAll} event.
490      */
491     function setApprovalForAll(address operator, bool _approved) external;
492 
493     /**
494      * @dev Returns the account approved for `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function getApproved(uint256 tokenId) external view returns (address operator);
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}.
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     // =============================================================
510     //                        IERC721Metadata
511     // =============================================================
512 
513     /**
514      * @dev Returns the token collection name.
515      */
516     function name() external view returns (string memory);
517 
518     /**
519      * @dev Returns the token collection symbol.
520      */
521     function symbol() external view returns (string memory);
522 
523     /**
524      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
525      */
526     function tokenURI(uint256 tokenId) external view returns (string memory);
527 
528     // =============================================================
529     //                           IERC2309
530     // =============================================================
531 
532     /**
533      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
534      * (inclusive) is transferred from `from` to `to`, as defined in the
535      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
536      *
537      * See {_mintERC2309} for more details.
538      */
539     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
540 }
541 
542 // File: erc721a@4.2.3/contracts/ERC721A.sol
543 
544 
545 // ERC721A Contracts v4.2.3
546 // Creator: Chiru Labs
547 
548 pragma solidity ^0.8.4;
549 
550 
551 /**
552  * @dev Interface of ERC721 token receiver.
553  */
554 interface ERC721A__IERC721Receiver {
555     function onERC721Received(
556         address operator,
557         address from,
558         uint256 tokenId,
559         bytes calldata data
560     ) external returns (bytes4);
561 }
562 
563 /**
564  * @title ERC721A
565  *
566  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
567  * Non-Fungible Token Standard, including the Metadata extension.
568  * Optimized for lower gas during batch mints.
569  *
570  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
571  * starting from `_startTokenId()`.
572  *
573  * Assumptions:
574  *
575  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
576  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
577  */
578 contract ERC721A is IERC721A {
579     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
580     struct TokenApprovalRef {
581         address value;
582     }
583 
584     // =============================================================
585     //                           CONSTANTS
586     // =============================================================
587 
588     // Mask of an entry in packed address data.
589     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
590 
591     // The bit position of `numberMinted` in packed address data.
592     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
593 
594     // The bit position of `numberBurned` in packed address data.
595     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
596 
597     // The bit position of `aux` in packed address data.
598     uint256 private constant _BITPOS_AUX = 192;
599 
600     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
601     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
602 
603     // The bit position of `startTimestamp` in packed ownership.
604     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
605 
606     // The bit mask of the `burned` bit in packed ownership.
607     uint256 private constant _BITMASK_BURNED = 1 << 224;
608 
609     // The bit position of the `nextInitialized` bit in packed ownership.
610     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
611 
612     // The bit mask of the `nextInitialized` bit in packed ownership.
613     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
614 
615     // The bit position of `extraData` in packed ownership.
616     uint256 private constant _BITPOS_EXTRA_DATA = 232;
617 
618     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
619     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
620 
621     // The mask of the lower 160 bits for addresses.
622     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
623 
624     // The maximum `quantity` that can be minted with {_mintERC2309}.
625     // This limit is to prevent overflows on the address data entries.
626     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
627     // is required to cause an overflow, which is unrealistic.
628     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
629 
630     // The `Transfer` event signature is given by:
631     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
632     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
633         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
634 
635     // =============================================================
636     //                            STORAGE
637     // =============================================================
638 
639     // The next token ID to be minted.
640     uint256 private _currentIndex;
641 
642     // The number of tokens burned.
643     uint256 private _burnCounter;
644 
645     // Token name
646     string private _name;
647 
648     // Token symbol
649     string private _symbol;
650 
651     // Mapping from token ID to ownership details
652     // An empty struct value does not necessarily mean the token is unowned.
653     // See {_packedOwnershipOf} implementation for details.
654     //
655     // Bits Layout:
656     // - [0..159]   `addr`
657     // - [160..223] `startTimestamp`
658     // - [224]      `burned`
659     // - [225]      `nextInitialized`
660     // - [232..255] `extraData`
661     mapping(uint256 => uint256) private _packedOwnerships;
662 
663     // Mapping owner address to address data.
664     //
665     // Bits Layout:
666     // - [0..63]    `balance`
667     // - [64..127]  `numberMinted`
668     // - [128..191] `numberBurned`
669     // - [192..255] `aux`
670     mapping(address => uint256) private _packedAddressData;
671 
672     // Mapping from token ID to approved address.
673     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     // =============================================================
679     //                          CONSTRUCTOR
680     // =============================================================
681 
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685         _currentIndex = _startTokenId();
686     }
687 
688     // =============================================================
689     //                   TOKEN COUNTING OPERATIONS
690     // =============================================================
691 
692     /**
693      * @dev Returns the starting token ID.
694      * To change the starting token ID, please override this function.
695      */
696     function _startTokenId() internal view virtual returns (uint256) {
697         return 0;
698     }
699 
700     /**
701      * @dev Returns the next token ID to be minted.
702      */
703     function _nextTokenId() internal view virtual returns (uint256) {
704         return _currentIndex;
705     }
706 
707     /**
708      * @dev Returns the total number of tokens in existence.
709      * Burned tokens will reduce the count.
710      * To get the total number of tokens minted, please see {_totalMinted}.
711      */
712     function totalSupply() public view virtual override returns (uint256) {
713         // Counter underflow is impossible as _burnCounter cannot be incremented
714         // more than `_currentIndex - _startTokenId()` times.
715         unchecked {
716             return _currentIndex - _burnCounter - _startTokenId();
717         }
718     }
719 
720     /**
721      * @dev Returns the total amount of tokens minted in the contract.
722      */
723     function _totalMinted() internal view virtual returns (uint256) {
724         // Counter underflow is impossible as `_currentIndex` does not decrement,
725         // and it is initialized to `_startTokenId()`.
726         unchecked {
727             return _currentIndex - _startTokenId();
728         }
729     }
730 
731     /**
732      * @dev Returns the total number of tokens burned.
733      */
734     function _totalBurned() internal view virtual returns (uint256) {
735         return _burnCounter;
736     }
737 
738     // =============================================================
739     //                    ADDRESS DATA OPERATIONS
740     // =============================================================
741 
742     /**
743      * @dev Returns the number of tokens in `owner`'s account.
744      */
745     function balanceOf(address owner) public view virtual override returns (uint256) {
746         if (owner == address(0)) revert BalanceQueryForZeroAddress();
747         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
748     }
749 
750     /**
751      * Returns the number of tokens minted by `owner`.
752      */
753     function _numberMinted(address owner) internal view returns (uint256) {
754         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
755     }
756 
757     /**
758      * Returns the number of tokens burned by or on behalf of `owner`.
759      */
760     function _numberBurned(address owner) internal view returns (uint256) {
761         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
762     }
763 
764     /**
765      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
766      */
767     function _getAux(address owner) internal view returns (uint64) {
768         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
769     }
770 
771     /**
772      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
773      * If there are multiple variables, please pack them into a uint64.
774      */
775     function _setAux(address owner, uint64 aux) internal virtual {
776         uint256 packed = _packedAddressData[owner];
777         uint256 auxCasted;
778         // Cast `aux` with assembly to avoid redundant masking.
779         assembly {
780             auxCasted := aux
781         }
782         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
783         _packedAddressData[owner] = packed;
784     }
785 
786     // =============================================================
787     //                            IERC165
788     // =============================================================
789 
790     /**
791      * @dev Returns true if this contract implements the interface defined by
792      * `interfaceId`. See the corresponding
793      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
794      * to learn more about how these ids are created.
795      *
796      * This function call must use less than 30000 gas.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
799         // The interface IDs are constants representing the first 4 bytes
800         // of the XOR of all function selectors in the interface.
801         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
802         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
803         return
804             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
805             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
806             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
807     }
808 
809     // =============================================================
810     //                        IERC721Metadata
811     // =============================================================
812 
813     /**
814      * @dev Returns the token collection name.
815      */
816     function name() public view virtual override returns (string memory) {
817         return _name;
818     }
819 
820     /**
821      * @dev Returns the token collection symbol.
822      */
823     function symbol() public view virtual override returns (string memory) {
824         return _symbol;
825     }
826 
827     /**
828      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
829      */
830     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
831         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
832 
833         string memory baseURI = _baseURI();
834         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
835     }
836 
837     /**
838      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
839      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
840      * by default, it can be overridden in child contracts.
841      */
842     function _baseURI() internal view virtual returns (string memory) {
843         return '';
844     }
845 
846     // =============================================================
847     //                     OWNERSHIPS OPERATIONS
848     // =============================================================
849 
850     /**
851      * @dev Returns the owner of the `tokenId` token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
858         return address(uint160(_packedOwnershipOf(tokenId)));
859     }
860 
861     /**
862      * @dev Gas spent here starts off proportional to the maximum mint batch size.
863      * It gradually moves to O(1) as tokens get transferred around over time.
864      */
865     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
866         return _unpackedOwnership(_packedOwnershipOf(tokenId));
867     }
868 
869     /**
870      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
871      */
872     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
873         return _unpackedOwnership(_packedOwnerships[index]);
874     }
875 
876     /**
877      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
878      */
879     function _initializeOwnershipAt(uint256 index) internal virtual {
880         if (_packedOwnerships[index] == 0) {
881             _packedOwnerships[index] = _packedOwnershipOf(index);
882         }
883     }
884 
885     /**
886      * Returns the packed ownership data of `tokenId`.
887      */
888     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
889         uint256 curr = tokenId;
890 
891         unchecked {
892             if (_startTokenId() <= curr)
893                 if (curr < _currentIndex) {
894                     uint256 packed = _packedOwnerships[curr];
895                     // If not burned.
896                     if (packed & _BITMASK_BURNED == 0) {
897                         // Invariant:
898                         // There will always be an initialized ownership slot
899                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
900                         // before an unintialized ownership slot
901                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
902                         // Hence, `curr` will not underflow.
903                         //
904                         // We can directly compare the packed value.
905                         // If the address is zero, packed will be zero.
906                         while (packed == 0) {
907                             packed = _packedOwnerships[--curr];
908                         }
909                         return packed;
910                     }
911                 }
912         }
913         revert OwnerQueryForNonexistentToken();
914     }
915 
916     /**
917      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
918      */
919     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
920         ownership.addr = address(uint160(packed));
921         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
922         ownership.burned = packed & _BITMASK_BURNED != 0;
923         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
924     }
925 
926     /**
927      * @dev Packs ownership data into a single uint256.
928      */
929     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
930         assembly {
931             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
932             owner := and(owner, _BITMASK_ADDRESS)
933             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
934             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
935         }
936     }
937 
938     /**
939      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
940      */
941     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
942         // For branchless setting of the `nextInitialized` flag.
943         assembly {
944             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
945             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
946         }
947     }
948 
949     // =============================================================
950     //                      APPROVAL OPERATIONS
951     // =============================================================
952 
953     /**
954      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
955      * The approval is cleared when the token is transferred.
956      *
957      * Only a single account can be approved at a time, so approving the
958      * zero address clears previous approvals.
959      *
960      * Requirements:
961      *
962      * - The caller must own the token or be an approved operator.
963      * - `tokenId` must exist.
964      *
965      * Emits an {Approval} event.
966      */
967     function approve(address to, uint256 tokenId) public payable virtual override {
968         address owner = ownerOf(tokenId);
969 
970         if (_msgSenderERC721A() != owner)
971             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
972                 revert ApprovalCallerNotOwnerNorApproved();
973             }
974 
975         _tokenApprovals[tokenId].value = to;
976         emit Approval(owner, to, tokenId);
977     }
978 
979     /**
980      * @dev Returns the account approved for `tokenId` token.
981      *
982      * Requirements:
983      *
984      * - `tokenId` must exist.
985      */
986     function getApproved(uint256 tokenId) public view virtual override returns (address) {
987         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
988 
989         return _tokenApprovals[tokenId].value;
990     }
991 
992     /**
993      * @dev Approve or remove `operator` as an operator for the caller.
994      * Operators can call {transferFrom} or {safeTransferFrom}
995      * for any token owned by the caller.
996      *
997      * Requirements:
998      *
999      * - The `operator` cannot be the caller.
1000      *
1001      * Emits an {ApprovalForAll} event.
1002      */
1003     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1058         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
1086     ) public payable virtual override {
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
1152     ) public payable virtual override {
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
1176     ) public payable virtual override {
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
1306             // The duplicated `log4` removes an extra check and reduces stack juggling.
1307             // The assembly, together with the surrounding Solidity code, have been
1308             // delicately arranged to nudge the compiler into producing optimized opcodes.
1309             assembly {
1310                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1311                 toMasked := and(to, _BITMASK_ADDRESS)
1312                 // Emit the `Transfer` event.
1313                 log4(
1314                     0, // Start of data (0, since no data).
1315                     0, // End of data (0, since no data).
1316                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1317                     0, // `address(0)`.
1318                     toMasked, // `to`.
1319                     startTokenId // `tokenId`.
1320                 )
1321 
1322                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1323                 // that overflows uint256 will make the loop run out of gas.
1324                 // The compiler will optimize the `iszero` away for performance.
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
1597             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1598             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1599             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1600             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1601             let m := add(mload(0x40), 0xa0)
1602             // Update the free memory pointer to allocate.
1603             mstore(0x40, m)
1604             // Assign the `str` to the end.
1605             str := sub(m, 0x20)
1606             // Zeroize the slot after the string.
1607             mstore(str, 0)
1608 
1609             // Cache the end of the memory to calculate the length later.
1610             let end := str
1611 
1612             // We write the string from rightmost digit to leftmost digit.
1613             // The following is essentially a do-while loop that also handles the zero case.
1614             // prettier-ignore
1615             for { let temp := value } 1 {} {
1616                 str := sub(str, 1)
1617                 // Write the character to the pointer.
1618                 // The ASCII index of the '0' character is 48.
1619                 mstore8(str, add(48, mod(temp, 10)))
1620                 // Keep dividing `temp` until zero.
1621                 temp := div(temp, 10)
1622                 // prettier-ignore
1623                 if iszero(temp) { break }
1624             }
1625 
1626             let length := sub(end, str)
1627             // Move the pointer 32 bytes leftwards to make room for the length.
1628             str := sub(str, 0x20)
1629             // Store the length.
1630             mstore(str, length)
1631         }
1632     }
1633 }
1634 
1635 // File: contracts/PeppaFlip.sol
1636 
1637 
1638 /*
1639 ____/\\\\\\\\\______/\\\_______/\\\____________/\\\\\\\\\\\\\\\__/\\\______________/\\\\\\\\\\\__/\\\\\\\\\\\\\___        
1640  __/\\\///////\\\___\///\\\___/\\\/____________\/\\\///////////__\/\\\_____________\/////\\\///__\/\\\/////////\\\_       
1641   _\///______\//\\\____\///\\\\\\/______________\/\\\_____________\/\\\_________________\/\\\_____\/\\\_______\/\\\_      
1642    ___________/\\\/_______\//\\\\________________\/\\\\\\\\\\\_____\/\\\_________________\/\\\_____\/\\\\\\\\\\\\\/__     
1643     ________/\\\//__________\/\\\\________________\/\\\///////______\/\\\_________________\/\\\_____\/\\\/////////____    
1644      _____/\\\//_____________/\\\\\\_______________\/\\\_____________\/\\\_________________\/\\\_____\/\\\_____________   
1645       ___/\\\/______________/\\\////\\\_____________\/\\\_____________\/\\\_________________\/\\\_____\/\\\_____________  
1646        __/\\\\\\\\\\\\\\\__/\\\/___\///\\\___________\/\\\_____________\/\\\\\\\\\\\\\\\__/\\\\\\\\\\\_\/\\\_____________ 
1647         _\///////////////__\///_______\///____________\///______________\///////////////__\///////////__\///______________
1648 */
1649 pragma solidity >=0.8.7 <0.9.0;
1650 
1651 
1652 
1653 
1654 
1655 contract PeppaFlip is ERC721A, Ownable, ReentrancyGuard {
1656   using Strings for uint256;
1657   uint256 public maxMintAmountPerTx = 4;
1658   uint256 public maxFreeMint = 2;
1659   uint256 public maxSupply = 1000;
1660   string public _baseTokenURI;
1661   string public _headTokenURI = ".json";
1662   string public hiddenMetadataUri;
1663 
1664   uint256 public cost = 0.0025 ether;
1665 
1666   bool public isFreeMintActive = true;
1667   bool public paused;
1668   bool public revealed;
1669 
1670   mapping(address => uint256) private _freeMints;
1671 
1672   constructor(
1673     string memory _hiddenMetadataUri
1674   ) ERC721A("Peppa Flip", "PF") {
1675     setHiddenMetadataUri(_hiddenMetadataUri);
1676   }
1677 
1678   function setIsFreeMintActive(bool _isFreeMintActive) external onlyOwner {
1679     isFreeMintActive = _isFreeMintActive;
1680   }
1681 
1682   function amountFreeMinted(address addr) external view returns (uint256) {
1683     return _freeMints[addr];
1684   }
1685 
1686   function freeMint(uint256 _mintAmount) external nonReentrant {
1687     address ms = _msgSender();
1688     require(isFreeMintActive, "Free minting is not active");
1689     require(_mintAmount > 0 && _freeMints[ms] + _mintAmount <= maxFreeMint, "Free mint already claimed");
1690     require(totalSupply() + _mintAmount <= maxSupply, "Purchase would exceed max tokens");
1691     require(!paused, "The contract is paused!");
1692 
1693     _freeMints[ms] += _mintAmount;
1694     _safeMint(ms, _mintAmount);
1695   }
1696 
1697   function mint(uint256 _mintAmount) public payable nonReentrant {
1698     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1699     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1700     require(!paused, "The contract is paused!");
1701     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1702 
1703     _safeMint(_msgSender(), _mintAmount);
1704   }
1705 
1706   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1707     _safeMint(_receiver, _mintAmount);
1708   }
1709 
1710   function _startTokenId() internal view virtual override returns (uint256) {
1711     return 1;
1712   }
1713 
1714   function setRevealed(bool _state) public onlyOwner {
1715     revealed = _state;
1716   }
1717 
1718   function setCost(uint256 _cost) public onlyOwner {
1719     cost = _cost;
1720   }
1721 
1722   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1723     maxMintAmountPerTx = _maxMintAmountPerTx;
1724   }
1725 
1726   function setPaused(bool _state) public onlyOwner {
1727     paused = _state;
1728   }
1729 
1730   function withdraw() public onlyOwner nonReentrant {
1731     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1732     require(os);
1733   }
1734 
1735   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1736     hiddenMetadataUri = _hiddenMetadataUri;
1737   }
1738 
1739   function setBaseURI(string calldata baseURI) public onlyOwner {
1740     _baseTokenURI = baseURI;
1741   }
1742 
1743   function _baseURI() internal view virtual override returns (string memory) {
1744       return _baseTokenURI;
1745   }
1746 
1747   function setHeadURI(string calldata headURI) public onlyOwner {
1748     _headTokenURI = headURI;
1749   }
1750 
1751   function _headURI() internal view virtual returns (string memory) {
1752       return _headTokenURI;
1753   }
1754 
1755   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1756       require(_exists(_tokenId), "URI does not exist!");
1757 
1758       if (revealed) {
1759           return string(abi.encodePacked(_baseURI(), _tokenId.toString(), _headURI()));
1760       } else {
1761           return hiddenMetadataUri;
1762       }
1763   }
1764 }