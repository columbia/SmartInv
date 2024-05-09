1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
242 // File: erc721a/contracts/IERC721A.sol
243 
244 
245 // ERC721A Contracts v4.2.0
246 // Creator: Chiru Labs
247 
248 pragma solidity ^0.8.4;
249 
250 /**
251  * @dev Interface of ERC721A.
252  */
253 interface IERC721A {
254     /**
255      * The caller must own the token or be an approved operator.
256      */
257     error ApprovalCallerNotOwnerNorApproved();
258 
259     /**
260      * The token does not exist.
261      */
262     error ApprovalQueryForNonexistentToken();
263 
264     /**
265      * The caller cannot approve to their own address.
266      */
267     error ApproveToCaller();
268 
269     /**
270      * Cannot query the balance for the zero address.
271      */
272     error BalanceQueryForZeroAddress();
273 
274     /**
275      * Cannot mint to the zero address.
276      */
277     error MintToZeroAddress();
278 
279     /**
280      * The quantity of tokens minted must be more than zero.
281      */
282     error MintZeroQuantity();
283 
284     /**
285      * The token does not exist.
286      */
287     error OwnerQueryForNonexistentToken();
288 
289     /**
290      * The caller must own the token or be an approved operator.
291      */
292     error TransferCallerNotOwnerNorApproved();
293 
294     /**
295      * The token must be owned by `from`.
296      */
297     error TransferFromIncorrectOwner();
298 
299     /**
300      * Cannot safely transfer to a contract that does not implement the
301      * ERC721Receiver interface.
302      */
303     error TransferToNonERC721ReceiverImplementer();
304 
305     /**
306      * Cannot transfer to the zero address.
307      */
308     error TransferToZeroAddress();
309 
310     /**
311      * The token does not exist.
312      */
313     error URIQueryForNonexistentToken();
314 
315     /**
316      * The `quantity` minted with ERC2309 exceeds the safety limit.
317      */
318     error MintERC2309QuantityExceedsLimit();
319 
320     /**
321      * The `extraData` cannot be set on an unintialized ownership slot.
322      */
323     error OwnershipNotInitializedForExtraData();
324 
325     // =============================================================
326     //                            STRUCTS
327     // =============================================================
328 
329     struct TokenOwnership {
330         // The address of the owner.
331         address addr;
332         // Stores the start time of ownership with minimal overhead for tokenomics.
333         uint64 startTimestamp;
334         // Whether the token has been burned.
335         bool burned;
336         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
337         uint24 extraData;
338     }
339 
340     // =============================================================
341     //                         TOKEN COUNTERS
342     // =============================================================
343 
344     /**
345      * @dev Returns the total number of tokens in existence.
346      * Burned tokens will reduce the count.
347      * To get the total number of tokens minted, please see {_totalMinted}.
348      */
349     function totalSupply() external view returns (uint256);
350 
351     // =============================================================
352     //                            IERC165
353     // =============================================================
354 
355     /**
356      * @dev Returns true if this contract implements the interface defined by
357      * `interfaceId`. See the corresponding
358      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
359      * to learn more about how these ids are created.
360      *
361      * This function call must use less than 30000 gas.
362      */
363     function supportsInterface(bytes4 interfaceId) external view returns (bool);
364 
365     // =============================================================
366     //                            IERC721
367     // =============================================================
368 
369     /**
370      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
371      */
372     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
373 
374     /**
375      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
376      */
377     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
378 
379     /**
380      * @dev Emitted when `owner` enables or disables
381      * (`approved`) `operator` to manage all of its assets.
382      */
383     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
384 
385     /**
386      * @dev Returns the number of tokens in `owner`'s account.
387      */
388     function balanceOf(address owner) external view returns (uint256 balance);
389 
390     /**
391      * @dev Returns the owner of the `tokenId` token.
392      *
393      * Requirements:
394      *
395      * - `tokenId` must exist.
396      */
397     function ownerOf(uint256 tokenId) external view returns (address owner);
398 
399     /**
400      * @dev Safely transfers `tokenId` token from `from` to `to`,
401      * checking first that contract recipients are aware of the ERC721 protocol
402      * to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move
410      * this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement
412      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId,
420         bytes calldata data
421     ) external;
422 
423     /**
424      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
425      */
426     function safeTransferFrom(
427         address from,
428         address to,
429         uint256 tokenId
430     ) external;
431 
432     /**
433      * @dev Transfers `tokenId` from `from` to `to`.
434      *
435      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
436      * whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token
444      * by either {approve} or {setApprovalForAll}.
445      *
446      * Emits a {Transfer} event.
447      */
448     function transferFrom(
449         address from,
450         address to,
451         uint256 tokenId
452     ) external;
453 
454     /**
455      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
456      * The approval is cleared when the token is transferred.
457      *
458      * Only a single account can be approved at a time, so approving the
459      * zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Approve or remove `operator` as an operator for the caller.
472      * Operators can call {transferFrom} or {safeTransferFrom}
473      * for any token owned by the caller.
474      *
475      * Requirements:
476      *
477      * - The `operator` cannot be the caller.
478      *
479      * Emits an {ApprovalForAll} event.
480      */
481     function setApprovalForAll(address operator, bool _approved) external;
482 
483     /**
484      * @dev Returns the account approved for `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function getApproved(uint256 tokenId) external view returns (address operator);
491 
492     /**
493      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
494      *
495      * See {setApprovalForAll}.
496      */
497     function isApprovedForAll(address owner, address operator) external view returns (bool);
498 
499     // =============================================================
500     //                        IERC721Metadata
501     // =============================================================
502 
503     /**
504      * @dev Returns the token collection name.
505      */
506     function name() external view returns (string memory);
507 
508     /**
509      * @dev Returns the token collection symbol.
510      */
511     function symbol() external view returns (string memory);
512 
513     /**
514      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
515      */
516     function tokenURI(uint256 tokenId) external view returns (string memory);
517 
518     // =============================================================
519     //                           IERC2309
520     // =============================================================
521 
522     /**
523      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
524      * (inclusive) is transferred from `from` to `to`, as defined in the
525      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
526      *
527      * See {_mintERC2309} for more details.
528      */
529     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
530 }
531 
532 // File: erc721a/contracts//ERC721A.sol
533 
534 
535 // ERC721A Contracts v4.2.0
536 // Creator: Chiru Labs
537 
538 pragma solidity ^0.8.4;
539 
540 
541 /**
542  * @dev Interface of ERC721 token receiver.
543  */
544 interface ERC721A__IERC721Receiver {
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 /**
554  * @title ERC721A
555  *
556  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
557  * Non-Fungible Token Standard, including the Metadata extension.
558  * Optimized for lower gas during batch mints.
559  *
560  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
561  * starting from `_startTokenId()`.
562  *
563  * Assumptions:
564  *
565  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
566  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
567  */
568 contract ERC721A is IERC721A {
569     // Reference type for token approval.
570     struct TokenApprovalRef {
571         address value;
572     }
573 
574     // =============================================================
575     //                           CONSTANTS
576     // =============================================================
577 
578     // Mask of an entry in packed address data.
579     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
580 
581     // The bit position of `numberMinted` in packed address data.
582     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
583 
584     // The bit position of `numberBurned` in packed address data.
585     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
586 
587     // The bit position of `aux` in packed address data.
588     uint256 private constant _BITPOS_AUX = 192;
589 
590     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
591     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
592 
593     // The bit position of `startTimestamp` in packed ownership.
594     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
595 
596     // The bit mask of the `burned` bit in packed ownership.
597     uint256 private constant _BITMASK_BURNED = 1 << 224;
598 
599     // The bit position of the `nextInitialized` bit in packed ownership.
600     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
601 
602     // The bit mask of the `nextInitialized` bit in packed ownership.
603     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
604 
605     // The bit position of `extraData` in packed ownership.
606     uint256 private constant _BITPOS_EXTRA_DATA = 232;
607 
608     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
609     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
610 
611     // The mask of the lower 160 bits for addresses.
612     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
613 
614     // The maximum `quantity` that can be minted with {_mintERC2309}.
615     // This limit is to prevent overflows on the address data entries.
616     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
617     // is required to cause an overflow, which is unrealistic.
618     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
619 
620     // The `Transfer` event signature is given by:
621     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
622     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
623         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
624 
625     // =============================================================
626     //                            STORAGE
627     // =============================================================
628 
629     // The next token ID to be minted.
630     uint256 private _currentIndex;
631 
632     // The number of tokens burned.
633     uint256 private _burnCounter;
634 
635     // Token name
636     string private _name;
637 
638     // Token symbol
639     string private _symbol;
640 
641     // Mapping from token ID to ownership details
642     // An empty struct value does not necessarily mean the token is unowned.
643     // See {_packedOwnershipOf} implementation for details.
644     //
645     // Bits Layout:
646     // - [0..159]   `addr`
647     // - [160..223] `startTimestamp`
648     // - [224]      `burned`
649     // - [225]      `nextInitialized`
650     // - [232..255] `extraData`
651     mapping(uint256 => uint256) private _packedOwnerships;
652 
653     // Mapping owner address to address data.
654     //
655     // Bits Layout:
656     // - [0..63]    `balance`
657     // - [64..127]  `numberMinted`
658     // - [128..191] `numberBurned`
659     // - [192..255] `aux`
660     mapping(address => uint256) private _packedAddressData;
661 
662     // Mapping from token ID to approved address.
663     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
664 
665     // Mapping from owner to operator approvals
666     mapping(address => mapping(address => bool)) private _operatorApprovals;
667 
668     // =============================================================
669     //                          CONSTRUCTOR
670     // =============================================================
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675         _currentIndex = _startTokenId();
676     }
677 
678     // =============================================================
679     //                   TOKEN COUNTING OPERATIONS
680     // =============================================================
681 
682     /**
683      * @dev Returns the starting token ID.
684      * To change the starting token ID, please override this function.
685      */
686     function _startTokenId() internal view virtual returns (uint256) {
687         return 0;
688     }
689 
690     /**
691      * @dev Returns the next token ID to be minted.
692      */
693     function _nextTokenId() internal view virtual returns (uint256) {
694         return _currentIndex;
695     }
696 
697     /**
698      * @dev Returns the total number of tokens in existence.
699      * Burned tokens will reduce the count.
700      * To get the total number of tokens minted, please see {_totalMinted}.
701      */
702     function totalSupply() public view virtual override returns (uint256) {
703         // Counter underflow is impossible as _burnCounter cannot be incremented
704         // more than `_currentIndex - _startTokenId()` times.
705         unchecked {
706             return _currentIndex - _burnCounter - _startTokenId();
707         }
708     }
709 
710     /**
711      * @dev Returns the total amount of tokens minted in the contract.
712      */
713     function _totalMinted() internal view virtual returns (uint256) {
714         // Counter underflow is impossible as `_currentIndex` does not decrement,
715         // and it is initialized to `_startTokenId()`.
716         unchecked {
717             return _currentIndex - _startTokenId();
718         }
719     }
720 
721     /**
722      * @dev Returns the total number of tokens burned.
723      */
724     function _totalBurned() internal view virtual returns (uint256) {
725         return _burnCounter;
726     }
727 
728     // =============================================================
729     //                    ADDRESS DATA OPERATIONS
730     // =============================================================
731 
732     /**
733      * @dev Returns the number of tokens in `owner`'s account.
734      */
735     function balanceOf(address owner) public view virtual override returns (uint256) {
736         if (owner == address(0)) revert BalanceQueryForZeroAddress();
737         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
738     }
739 
740     /**
741      * Returns the number of tokens minted by `owner`.
742      */
743     function _numberMinted(address owner) internal view returns (uint256) {
744         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
745     }
746 
747     /**
748      * Returns the number of tokens burned by or on behalf of `owner`.
749      */
750     function _numberBurned(address owner) internal view returns (uint256) {
751         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
752     }
753 
754     /**
755      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
756      */
757     function _getAux(address owner) internal view returns (uint64) {
758         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
759     }
760 
761     /**
762      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
763      * If there are multiple variables, please pack them into a uint64.
764      */
765     function _setAux(address owner, uint64 aux) internal virtual {
766         uint256 packed = _packedAddressData[owner];
767         uint256 auxCasted;
768         // Cast `aux` with assembly to avoid redundant masking.
769         assembly {
770             auxCasted := aux
771         }
772         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
773         _packedAddressData[owner] = packed;
774     }
775 
776     // =============================================================
777     //                            IERC165
778     // =============================================================
779 
780     /**
781      * @dev Returns true if this contract implements the interface defined by
782      * `interfaceId`. See the corresponding
783      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
784      * to learn more about how these ids are created.
785      *
786      * This function call must use less than 30000 gas.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789         // The interface IDs are constants representing the first 4 bytes
790         // of the XOR of all function selectors in the interface.
791         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
792         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
793         return
794             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
795             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
796             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
797     }
798 
799     // =============================================================
800     //                        IERC721Metadata
801     // =============================================================
802 
803     /**
804      * @dev Returns the token collection name.
805      */
806     function name() public view virtual override returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev Returns the token collection symbol.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
819      */
820     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
821         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
822 
823         string memory baseURI = _baseURI();
824         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
825     }
826 
827     /**
828      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
829      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
830      * by default, it can be overridden in child contracts.
831      */
832     function _baseURI() internal view virtual returns (string memory) {
833         return '';
834     }
835 
836     // =============================================================
837     //                     OWNERSHIPS OPERATIONS
838     // =============================================================
839 
840     /**
841      * @dev Returns the owner of the `tokenId` token.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
848         return address(uint160(_packedOwnershipOf(tokenId)));
849     }
850 
851     /**
852      * @dev Gas spent here starts off proportional to the maximum mint batch size.
853      * It gradually moves to O(1) as tokens get transferred around over time.
854      */
855     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
856         return _unpackedOwnership(_packedOwnershipOf(tokenId));
857     }
858 
859     /**
860      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
861      */
862     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
863         return _unpackedOwnership(_packedOwnerships[index]);
864     }
865 
866     /**
867      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
868      */
869     function _initializeOwnershipAt(uint256 index) internal virtual {
870         if (_packedOwnerships[index] == 0) {
871             _packedOwnerships[index] = _packedOwnershipOf(index);
872         }
873     }
874 
875     /**
876      * Returns the packed ownership data of `tokenId`.
877      */
878     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
879         uint256 curr = tokenId;
880 
881         unchecked {
882             if (_startTokenId() <= curr)
883                 if (curr < _currentIndex) {
884                     uint256 packed = _packedOwnerships[curr];
885                     // If not burned.
886                     if (packed & _BITMASK_BURNED == 0) {
887                         // Invariant:
888                         // There will always be an initialized ownership slot
889                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
890                         // before an unintialized ownership slot
891                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
892                         // Hence, `curr` will not underflow.
893                         //
894                         // We can directly compare the packed value.
895                         // If the address is zero, packed will be zero.
896                         while (packed == 0) {
897                             packed = _packedOwnerships[--curr];
898                         }
899                         return packed;
900                     }
901                 }
902         }
903         revert OwnerQueryForNonexistentToken();
904     }
905 
906     /**
907      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
908      */
909     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
910         ownership.addr = address(uint160(packed));
911         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
912         ownership.burned = packed & _BITMASK_BURNED != 0;
913         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
914     }
915 
916     /**
917      * @dev Packs ownership data into a single uint256.
918      */
919     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
920         assembly {
921             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
922             owner := and(owner, _BITMASK_ADDRESS)
923             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
924             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
925         }
926     }
927 
928     /**
929      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
930      */
931     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
932         // For branchless setting of the `nextInitialized` flag.
933         assembly {
934             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
935             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
936         }
937     }
938 
939     // =============================================================
940     //                      APPROVAL OPERATIONS
941     // =============================================================
942 
943     /**
944      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
945      * The approval is cleared when the token is transferred.
946      *
947      * Only a single account can be approved at a time, so approving the
948      * zero address clears previous approvals.
949      *
950      * Requirements:
951      *
952      * - The caller must own the token or be an approved operator.
953      * - `tokenId` must exist.
954      *
955      * Emits an {Approval} event.
956      */
957     function approve(address to, uint256 tokenId) public virtual override {
958         address owner = ownerOf(tokenId);
959 
960         if (_msgSenderERC721A() != owner)
961             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
962                 revert ApprovalCallerNotOwnerNorApproved();
963             }
964 
965         _tokenApprovals[tokenId].value = to;
966         emit Approval(owner, to, tokenId);
967     }
968 
969     /**
970      * @dev Returns the account approved for `tokenId` token.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must exist.
975      */
976     function getApproved(uint256 tokenId) public view virtual override returns (address) {
977         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
978 
979         return _tokenApprovals[tokenId].value;
980     }
981 
982     /**
983      * @dev Approve or remove `operator` as an operator for the caller.
984      * Operators can call {transferFrom} or {safeTransferFrom}
985      * for any token owned by the caller.
986      *
987      * Requirements:
988      *
989      * - The `operator` cannot be the caller.
990      *
991      * Emits an {ApprovalForAll} event.
992      */
993     function setApprovalForAll(address operator, bool approved) public virtual override {
994         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
995 
996         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
997         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
998     }
999 
1000     /**
1001      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1002      *
1003      * See {setApprovalForAll}.
1004      */
1005     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1006         return _operatorApprovals[owner][operator];
1007     }
1008 
1009     /**
1010      * @dev Returns whether `tokenId` exists.
1011      *
1012      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1013      *
1014      * Tokens start existing when they are minted. See {_mint}.
1015      */
1016     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1017         return
1018             _startTokenId() <= tokenId &&
1019             tokenId < _currentIndex && // If within bounds,
1020             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1021     }
1022 
1023     /**
1024      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1025      */
1026     function _isSenderApprovedOrOwner(
1027         address approvedAddress,
1028         address owner,
1029         address msgSender
1030     ) private pure returns (bool result) {
1031         assembly {
1032             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1033             owner := and(owner, _BITMASK_ADDRESS)
1034             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1035             msgSender := and(msgSender, _BITMASK_ADDRESS)
1036             // `msgSender == owner || msgSender == approvedAddress`.
1037             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1043      */
1044     function _getApprovedSlotAndAddress(uint256 tokenId)
1045         private
1046         view
1047         returns (uint256 approvedAddressSlot, address approvedAddress)
1048     {
1049         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1050         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1051         assembly {
1052             approvedAddressSlot := tokenApproval.slot
1053             approvedAddress := sload(approvedAddressSlot)
1054         }
1055     }
1056 
1057     // =============================================================
1058     //                      TRANSFER OPERATIONS
1059     // =============================================================
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `from` cannot be the zero address.
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      * - If the caller is not `from`, it must be approved to move this token
1070      * by either {approve} or {setApprovalForAll}.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function transferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1080 
1081         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1082 
1083         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1084 
1085         // The nested ifs save around 20+ gas over a compound boolean condition.
1086         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1087             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1088 
1089         if (to == address(0)) revert TransferToZeroAddress();
1090 
1091         _beforeTokenTransfers(from, to, tokenId, 1);
1092 
1093         // Clear approvals from the previous owner.
1094         assembly {
1095             if approvedAddress {
1096                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1097                 sstore(approvedAddressSlot, 0)
1098             }
1099         }
1100 
1101         // Underflow of the sender's balance is impossible because we check for
1102         // ownership above and the recipient's balance can't realistically overflow.
1103         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1104         unchecked {
1105             // We can directly increment and decrement the balances.
1106             --_packedAddressData[from]; // Updates: `balance -= 1`.
1107             ++_packedAddressData[to]; // Updates: `balance += 1`.
1108 
1109             // Updates:
1110             // - `address` to the next owner.
1111             // - `startTimestamp` to the timestamp of transfering.
1112             // - `burned` to `false`.
1113             // - `nextInitialized` to `true`.
1114             _packedOwnerships[tokenId] = _packOwnershipData(
1115                 to,
1116                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1117             );
1118 
1119             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1120             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1121                 uint256 nextTokenId = tokenId + 1;
1122                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1123                 if (_packedOwnerships[nextTokenId] == 0) {
1124                     // If the next slot is within bounds.
1125                     if (nextTokenId != _currentIndex) {
1126                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1127                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1128                     }
1129                 }
1130             }
1131         }
1132 
1133         emit Transfer(from, to, tokenId);
1134         _afterTokenTransfers(from, to, tokenId, 1);
1135     }
1136 
1137     /**
1138      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1139      */
1140     function safeTransferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) public virtual override {
1145         safeTransferFrom(from, to, tokenId, '');
1146     }
1147 
1148     /**
1149      * @dev Safely transfers `tokenId` token from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must exist and be owned by `from`.
1156      * - If the caller is not `from`, it must be approved to move this token
1157      * by either {approve} or {setApprovalForAll}.
1158      * - If `to` refers to a smart contract, it must implement
1159      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function safeTransferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) public virtual override {
1169         transferFrom(from, to, tokenId);
1170         if (to.code.length != 0)
1171             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1172                 revert TransferToNonERC721ReceiverImplementer();
1173             }
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before a set of serially-ordered token IDs
1178      * are about to be transferred. This includes minting.
1179      * And also called before burning one token.
1180      *
1181      * `startTokenId` - the first token ID to be transferred.
1182      * `quantity` - the amount to be transferred.
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, `tokenId` will be burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _beforeTokenTransfers(
1193         address from,
1194         address to,
1195         uint256 startTokenId,
1196         uint256 quantity
1197     ) internal virtual {}
1198 
1199     /**
1200      * @dev Hook that is called after a set of serially-ordered token IDs
1201      * have been transferred. This includes minting.
1202      * And also called after one token has been burned.
1203      *
1204      * `startTokenId` - the first token ID to be transferred.
1205      * `quantity` - the amount to be transferred.
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` has been minted for `to`.
1212      * - When `to` is zero, `tokenId` has been burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _afterTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1224      *
1225      * `from` - Previous owner of the given token ID.
1226      * `to` - Target address that will receive the token.
1227      * `tokenId` - Token ID to be transferred.
1228      * `_data` - Optional data to send along with the call.
1229      *
1230      * Returns whether the call correctly returned the expected magic value.
1231      */
1232     function _checkContractOnERC721Received(
1233         address from,
1234         address to,
1235         uint256 tokenId,
1236         bytes memory _data
1237     ) private returns (bool) {
1238         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1239             bytes4 retval
1240         ) {
1241             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1242         } catch (bytes memory reason) {
1243             if (reason.length == 0) {
1244                 revert TransferToNonERC721ReceiverImplementer();
1245             } else {
1246                 assembly {
1247                     revert(add(32, reason), mload(reason))
1248                 }
1249             }
1250         }
1251     }
1252 
1253     // =============================================================
1254     //                        MINT OPERATIONS
1255     // =============================================================
1256 
1257     /**
1258      * @dev Mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - `to` cannot be the zero address.
1263      * - `quantity` must be greater than 0.
1264      *
1265      * Emits a {Transfer} event for each mint.
1266      */
1267     function _mint(address to, uint256 quantity) internal virtual {
1268         uint256 startTokenId = _currentIndex;
1269         if (quantity == 0) revert MintZeroQuantity();
1270 
1271         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1272 
1273         // Overflows are incredibly unrealistic.
1274         // `balance` and `numberMinted` have a maximum limit of 2**64.
1275         // `tokenId` has a maximum limit of 2**256.
1276         unchecked {
1277             // Updates:
1278             // - `balance += quantity`.
1279             // - `numberMinted += quantity`.
1280             //
1281             // We can directly add to the `balance` and `numberMinted`.
1282             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1283 
1284             // Updates:
1285             // - `address` to the owner.
1286             // - `startTimestamp` to the timestamp of minting.
1287             // - `burned` to `false`.
1288             // - `nextInitialized` to `quantity == 1`.
1289             _packedOwnerships[startTokenId] = _packOwnershipData(
1290                 to,
1291                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1292             );
1293 
1294             uint256 toMasked;
1295             uint256 end = startTokenId + quantity;
1296 
1297             // Use assembly to loop and emit the `Transfer` event for gas savings.
1298             assembly {
1299                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1300                 toMasked := and(to, _BITMASK_ADDRESS)
1301                 // Emit the `Transfer` event.
1302                 log4(
1303                     0, // Start of data (0, since no data).
1304                     0, // End of data (0, since no data).
1305                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1306                     0, // `address(0)`.
1307                     toMasked, // `to`.
1308                     startTokenId // `tokenId`.
1309                 )
1310 
1311                 for {
1312                     let tokenId := add(startTokenId, 1)
1313                 } iszero(eq(tokenId, end)) {
1314                     tokenId := add(tokenId, 1)
1315                 } {
1316                     // Emit the `Transfer` event. Similar to above.
1317                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1318                 }
1319             }
1320             if (toMasked == 0) revert MintToZeroAddress();
1321 
1322             _currentIndex = end;
1323         }
1324         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1325     }
1326 
1327     /**
1328      * @dev Mints `quantity` tokens and transfers them to `to`.
1329      *
1330      * This function is intended for efficient minting only during contract creation.
1331      *
1332      * It emits only one {ConsecutiveTransfer} as defined in
1333      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1334      * instead of a sequence of {Transfer} event(s).
1335      *
1336      * Calling this function outside of contract creation WILL make your contract
1337      * non-compliant with the ERC721 standard.
1338      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1339      * {ConsecutiveTransfer} event is only permissible during contract creation.
1340      *
1341      * Requirements:
1342      *
1343      * - `to` cannot be the zero address.
1344      * - `quantity` must be greater than 0.
1345      *
1346      * Emits a {ConsecutiveTransfer} event.
1347      */
1348     function _mintERC2309(address to, uint256 quantity) internal virtual {
1349         uint256 startTokenId = _currentIndex;
1350         if (to == address(0)) revert MintToZeroAddress();
1351         if (quantity == 0) revert MintZeroQuantity();
1352         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1353 
1354         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1355 
1356         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1357         unchecked {
1358             // Updates:
1359             // - `balance += quantity`.
1360             // - `numberMinted += quantity`.
1361             //
1362             // We can directly add to the `balance` and `numberMinted`.
1363             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1364 
1365             // Updates:
1366             // - `address` to the owner.
1367             // - `startTimestamp` to the timestamp of minting.
1368             // - `burned` to `false`.
1369             // - `nextInitialized` to `quantity == 1`.
1370             _packedOwnerships[startTokenId] = _packOwnershipData(
1371                 to,
1372                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1373             );
1374 
1375             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1376 
1377             _currentIndex = startTokenId + quantity;
1378         }
1379         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1380     }
1381 
1382     /**
1383      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1384      *
1385      * Requirements:
1386      *
1387      * - If `to` refers to a smart contract, it must implement
1388      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1389      * - `quantity` must be greater than 0.
1390      *
1391      * See {_mint}.
1392      *
1393      * Emits a {Transfer} event for each mint.
1394      */
1395     function _safeMint(
1396         address to,
1397         uint256 quantity,
1398         bytes memory _data
1399     ) internal virtual {
1400         _mint(to, quantity);
1401 
1402         unchecked {
1403             if (to.code.length != 0) {
1404                 uint256 end = _currentIndex;
1405                 uint256 index = end - quantity;
1406                 do {
1407                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1408                         revert TransferToNonERC721ReceiverImplementer();
1409                     }
1410                 } while (index < end);
1411                 // Reentrancy protection.
1412                 if (_currentIndex != end) revert();
1413             }
1414         }
1415     }
1416 
1417     /**
1418      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1419      */
1420     function _safeMint(address to, uint256 quantity) internal virtual {
1421         _safeMint(to, quantity, '');
1422     }
1423 
1424     // =============================================================
1425     //                        BURN OPERATIONS
1426     // =============================================================
1427 
1428     /**
1429      * @dev Equivalent to `_burn(tokenId, false)`.
1430      */
1431     function _burn(uint256 tokenId) internal virtual {
1432         _burn(tokenId, false);
1433     }
1434 
1435     /**
1436      * @dev Destroys `tokenId`.
1437      * The approval is cleared when the token is burned.
1438      *
1439      * Requirements:
1440      *
1441      * - `tokenId` must exist.
1442      *
1443      * Emits a {Transfer} event.
1444      */
1445     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1446         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1447 
1448         address from = address(uint160(prevOwnershipPacked));
1449 
1450         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1451 
1452         if (approvalCheck) {
1453             // The nested ifs save around 20+ gas over a compound boolean condition.
1454             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1455                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1456         }
1457 
1458         _beforeTokenTransfers(from, address(0), tokenId, 1);
1459 
1460         // Clear approvals from the previous owner.
1461         assembly {
1462             if approvedAddress {
1463                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1464                 sstore(approvedAddressSlot, 0)
1465             }
1466         }
1467 
1468         // Underflow of the sender's balance is impossible because we check for
1469         // ownership above and the recipient's balance can't realistically overflow.
1470         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1471         unchecked {
1472             // Updates:
1473             // - `balance -= 1`.
1474             // - `numberBurned += 1`.
1475             //
1476             // We can directly decrement the balance, and increment the number burned.
1477             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1478             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1479 
1480             // Updates:
1481             // - `address` to the last owner.
1482             // - `startTimestamp` to the timestamp of burning.
1483             // - `burned` to `true`.
1484             // - `nextInitialized` to `true`.
1485             _packedOwnerships[tokenId] = _packOwnershipData(
1486                 from,
1487                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1488             );
1489 
1490             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1491             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1492                 uint256 nextTokenId = tokenId + 1;
1493                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1494                 if (_packedOwnerships[nextTokenId] == 0) {
1495                     // If the next slot is within bounds.
1496                     if (nextTokenId != _currentIndex) {
1497                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1498                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1499                     }
1500                 }
1501             }
1502         }
1503 
1504         emit Transfer(from, address(0), tokenId);
1505         _afterTokenTransfers(from, address(0), tokenId, 1);
1506 
1507         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1508         unchecked {
1509             _burnCounter++;
1510         }
1511     }
1512 
1513     // =============================================================
1514     //                     EXTRA DATA OPERATIONS
1515     // =============================================================
1516 
1517     /**
1518      * @dev Directly sets the extra data for the ownership data `index`.
1519      */
1520     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1521         uint256 packed = _packedOwnerships[index];
1522         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1523         uint256 extraDataCasted;
1524         // Cast `extraData` with assembly to avoid redundant masking.
1525         assembly {
1526             extraDataCasted := extraData
1527         }
1528         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1529         _packedOwnerships[index] = packed;
1530     }
1531 
1532     /**
1533      * @dev Called during each token transfer to set the 24bit `extraData` field.
1534      * Intended to be overridden by the cosumer contract.
1535      *
1536      * `previousExtraData` - the value of `extraData` before transfer.
1537      *
1538      * Calling conditions:
1539      *
1540      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1541      * transferred to `to`.
1542      * - When `from` is zero, `tokenId` will be minted for `to`.
1543      * - When `to` is zero, `tokenId` will be burned by `from`.
1544      * - `from` and `to` are never both zero.
1545      */
1546     function _extraData(
1547         address from,
1548         address to,
1549         uint24 previousExtraData
1550     ) internal view virtual returns (uint24) {}
1551 
1552     /**
1553      * @dev Returns the next extra data for the packed ownership data.
1554      * The returned result is shifted into position.
1555      */
1556     function _nextExtraData(
1557         address from,
1558         address to,
1559         uint256 prevOwnershipPacked
1560     ) private view returns (uint256) {
1561         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1562         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1563     }
1564 
1565     // =============================================================
1566     //                       OTHER OPERATIONS
1567     // =============================================================
1568 
1569     /**
1570      * @dev Returns the message sender (defaults to `msg.sender`).
1571      *
1572      * If you are writing GSN compatible contracts, you need to override this function.
1573      */
1574     function _msgSenderERC721A() internal view virtual returns (address) {
1575         return msg.sender;
1576     }
1577 
1578     /**
1579      * @dev Converts a uint256 to its ASCII string decimal representation.
1580      */
1581     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1582         assembly {
1583             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1584             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1585             // We will need 1 32-byte word to store the length,
1586             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1587             ptr := add(mload(0x40), 128)
1588             // Update the free memory pointer to allocate.
1589             mstore(0x40, ptr)
1590 
1591             // Cache the end of the memory to calculate the length later.
1592             let end := ptr
1593 
1594             // We write the string from the rightmost digit to the leftmost digit.
1595             // The following is essentially a do-while loop that also handles the zero case.
1596             // Costs a bit more than early returning for the zero case,
1597             // but cheaper in terms of deployment and overall runtime costs.
1598             for {
1599                 // Initialize and perform the first pass without check.
1600                 let temp := value
1601                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1602                 ptr := sub(ptr, 1)
1603                 // Write the character to the pointer.
1604                 // The ASCII index of the '0' character is 48.
1605                 mstore8(ptr, add(48, mod(temp, 10)))
1606                 temp := div(temp, 10)
1607             } temp {
1608                 // Keep dividing `temp` until zero.
1609                 temp := div(temp, 10)
1610             } {
1611                 // Body of the for loop.
1612                 ptr := sub(ptr, 1)
1613                 mstore8(ptr, add(48, mod(temp, 10)))
1614             }
1615 
1616             let length := sub(end, ptr)
1617             // Move the pointer 32 bytes leftwards to make room for the length.
1618             ptr := sub(ptr, 32)
1619             // Store the length.
1620             mstore(ptr, length)
1621         }
1622     }
1623 }
1624 
1625 // File: contracts/tits.sol
1626 
1627 
1628 pragma solidity ^0.8.4;
1629 
1630 
1631 
1632 
1633 
1634 
1635 contract dontletmedoit is ERC721A, Ownable, ReentrancyGuard {
1636     using Strings for uint256;
1637     uint256 public constant Max_Supply = 1000;
1638     uint256 public price = 0.0045 ether;
1639     uint256 public step1 = 0.0040 ether;
1640     uint256 public step2 = 0.0038 ether;
1641     uint256 public step3 = 0.0035 ether;
1642     string contractmeta = "ipfs://QmeUwGcWiFsfaSDpeD98spwTHmRfQNdDEr39sT9wjzUDm8";
1643    address public NFT = 0x15d329a8f350Ac9A234387f840EB9f1CA65438f9;
1644 
1645     
1646     string private _baseTokenURI = "ipfs://QmXSfjXu8GCXrSuT4XFQLaJWPaPChYxoJxC8qa1TD74heq/";
1647    
1648     bool public isActive = true;
1649     
1650 
1651    
1652    
1653     
1654     constructor () ERC721A("dontletmedoit", "dlmd") {
1655 
1656 
1657     }
1658 
1659     event Minted(
1660         address minter,
1661         uint256 quantity
1662     );
1663 
1664     
1665 
1666  
1667 
1668 
1669  
1670  function contractURI() public view returns (string memory) {
1671         return contractmeta;
1672     }
1673 
1674     function setContractMeta(string memory _md) public onlyOwner {
1675 
1676         contractmeta = _md;
1677 
1678     }
1679 
1680     function setNFT (address _nft) public onlyOwner {
1681 
1682         NFT = _nft;
1683     }
1684     function _baseURI() internal view virtual override returns (string memory) {
1685         return _baseTokenURI;
1686     }
1687 
1688     function setBaseURI(string memory _URI) external onlyOwner {
1689         _baseTokenURI = _URI;
1690     }
1691 
1692 
1693      function setPriceStep(uint256 _price, uint256 _step1, uint256 _step2, uint256 _step3) external onlyOwner {
1694         price = _price;
1695         step1 = _step1;
1696         step2 = _step2;
1697         step3 = _step3;
1698     }
1699 
1700     function setActive(bool _state) external onlyOwner {
1701         isActive = _state;
1702     }
1703 
1704     
1705 
1706 
1707 
1708     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1709         require( _exists(_tokenId),"no token");
1710 
1711    
1712         string memory currentBaseURI = _baseURI();
1713         return bytes(currentBaseURI).length > 0
1714             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1715             : "";
1716     }
1717     
1718 
1719     function checkCloudy (address _holder) internal  virtual  returns (bool isHolder){         
1720 
1721         
1722 
1723          if (ERC721A(NFT).balanceOf(_holder) > 0){
1724              return true;
1725          }
1726         
1727     }
1728 
1729 
1730     function findprice (uint256 _quantity) public view  returns (uint256 value) {
1731         
1732       
1733 
1734          if (_quantity >= 2 && _quantity <= 5){
1735         value = _quantity * step1;
1736         }
1737         if (_quantity >= 6 && _quantity <= 8){
1738         value = _quantity * step2;
1739         }
1740 
1741         if (_quantity >= 9){
1742         value = _quantity * step3;
1743            
1744          }else{
1745         value == price;
1746         }
1747         return value;
1748 
1749     } 
1750 
1751 
1752     function mint(uint256 _quantity) external payable nonReentrant {
1753         require(isActive, "Not active");
1754         require(_quantity > 0, "No 0 mint"); 
1755        require(msg.value >= findprice(_quantity), "Not enough Eth");
1756 
1757 
1758         if (checkCloudy(msg.sender) && _quantity > 1){
1759 
1760 
1761             _quantity = _quantity +1;
1762         }
1763         
1764        
1765         require((totalSupply() + _quantity) <= Max_Supply, "Max supply");
1766        
1767         
1768         
1769         _safeMint(msg.sender, _quantity);
1770 
1771         emit Minted (
1772             msg.sender,
1773             _quantity
1774         );
1775     }
1776 
1777     function adminMint(address _recp, uint256 _quantity) external nonReentrant onlyOwner{
1778         require(isActive, "Not active");
1779         _safeMint(_recp, _quantity);
1780 
1781               emit Minted (
1782             _recp,
1783             _quantity
1784         );
1785     }
1786   
1787 
1788 
1789     function withdraw(address _address, uint256 amount) public onlyOwner nonReentrant {
1790         (bool os, ) = payable(_address).call{value: amount}("");
1791         require(os);
1792         //---
1793     }
1794 }