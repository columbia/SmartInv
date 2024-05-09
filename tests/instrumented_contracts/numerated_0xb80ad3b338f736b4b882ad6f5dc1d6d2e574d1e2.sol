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
67 // File: @openzeppelin/contracts/utils/Context.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 // File: @openzeppelin/contracts/access/Ownable.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _transferOwnership(_msgSender());
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         _checkOwner();
131         _;
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if the sender is not the owner.
143      */
144     function _checkOwner() internal view virtual {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: erc721a/contracts/IERC721A.sol
180 
181 
182 // ERC721A Contracts v4.2.3
183 // Creator: Chiru Labs
184 
185 pragma solidity ^0.8.4;
186 
187 /**
188  * @dev Interface of ERC721A.
189  */
190 interface IERC721A {
191     /**
192      * The caller must own the token or be an approved operator.
193      */
194     error ApprovalCallerNotOwnerNorApproved();
195 
196     /**
197      * The token does not exist.
198      */
199     error ApprovalQueryForNonexistentToken();
200 
201     /**
202      * Cannot query the balance for the zero address.
203      */
204     error BalanceQueryForZeroAddress();
205 
206     /**
207      * Cannot mint to the zero address.
208      */
209     error MintToZeroAddress();
210 
211     /**
212      * The quantity of tokens minted must be more than zero.
213      */
214     error MintZeroQuantity();
215 
216     /**
217      * The token does not exist.
218      */
219     error OwnerQueryForNonexistentToken();
220 
221     /**
222      * The caller must own the token or be an approved operator.
223      */
224     error TransferCallerNotOwnerNorApproved();
225 
226     /**
227      * The token must be owned by `from`.
228      */
229     error TransferFromIncorrectOwner();
230 
231     /**
232      * Cannot safely transfer to a contract that does not implement the
233      * ERC721Receiver interface.
234      */
235     error TransferToNonERC721ReceiverImplementer();
236 
237     /**
238      * Cannot transfer to the zero address.
239      */
240     error TransferToZeroAddress();
241 
242     /**
243      * The token does not exist.
244      */
245     error URIQueryForNonexistentToken();
246 
247     /**
248      * The `quantity` minted with ERC2309 exceeds the safety limit.
249      */
250     error MintERC2309QuantityExceedsLimit();
251 
252     /**
253      * The `extraData` cannot be set on an unintialized ownership slot.
254      */
255     error OwnershipNotInitializedForExtraData();
256 
257     // =============================================================
258     //                            STRUCTS
259     // =============================================================
260 
261     struct TokenOwnership {
262         // The address of the owner.
263         address addr;
264         // Stores the start time of ownership with minimal overhead for tokenomics.
265         uint64 startTimestamp;
266         // Whether the token has been burned.
267         bool burned;
268         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
269         uint24 extraData;
270     }
271 
272     // =============================================================
273     //                         TOKEN COUNTERS
274     // =============================================================
275 
276     /**
277      * @dev Returns the total number of tokens in existence.
278      * Burned tokens will reduce the count.
279      * To get the total number of tokens minted, please see {_totalMinted}.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     // =============================================================
284     //                            IERC165
285     // =============================================================
286 
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * `interfaceId`. See the corresponding
290      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 
297     // =============================================================
298     //                            IERC721
299     // =============================================================
300 
301     /**
302      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
303      */
304     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
305 
306     /**
307      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
308      */
309     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
310 
311     /**
312      * @dev Emitted when `owner` enables or disables
313      * (`approved`) `operator` to manage all of its assets.
314      */
315     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
316 
317     /**
318      * @dev Returns the number of tokens in `owner`'s account.
319      */
320     function balanceOf(address owner) external view returns (uint256 balance);
321 
322     /**
323      * @dev Returns the owner of the `tokenId` token.
324      *
325      * Requirements:
326      *
327      * - `tokenId` must exist.
328      */
329     function ownerOf(uint256 tokenId) external view returns (address owner);
330 
331     /**
332      * @dev Safely transfers `tokenId` token from `from` to `to`,
333      * checking first that contract recipients are aware of the ERC721 protocol
334      * to prevent tokens from being forever locked.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `tokenId` token must exist and be owned by `from`.
341      * - If the caller is not `from`, it must be have been allowed to move
342      * this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement
344      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId,
352         bytes calldata data
353     ) external payable;
354 
355     /**
356      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
357      */
358     function safeTransferFrom(
359         address from,
360         address to,
361         uint256 tokenId
362     ) external payable;
363 
364     /**
365      * @dev Transfers `tokenId` from `from` to `to`.
366      *
367      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
368      * whenever possible.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must be owned by `from`.
375      * - If the caller is not `from`, it must be approved to move this token
376      * by either {approve} or {setApprovalForAll}.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external payable;
385 
386     /**
387      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
388      * The approval is cleared when the token is transferred.
389      *
390      * Only a single account can be approved at a time, so approving the
391      * zero address clears previous approvals.
392      *
393      * Requirements:
394      *
395      * - The caller must own the token or be an approved operator.
396      * - `tokenId` must exist.
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address to, uint256 tokenId) external payable;
401 
402     /**
403      * @dev Approve or remove `operator` as an operator for the caller.
404      * Operators can call {transferFrom} or {safeTransferFrom}
405      * for any token owned by the caller.
406      *
407      * Requirements:
408      *
409      * - The `operator` cannot be the caller.
410      *
411      * Emits an {ApprovalForAll} event.
412      */
413     function setApprovalForAll(address operator, bool _approved) external;
414 
415     /**
416      * @dev Returns the account approved for `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function getApproved(uint256 tokenId) external view returns (address operator);
423 
424     /**
425      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
426      *
427      * See {setApprovalForAll}.
428      */
429     function isApprovedForAll(address owner, address operator) external view returns (bool);
430 
431     // =============================================================
432     //                        IERC721Metadata
433     // =============================================================
434 
435     /**
436      * @dev Returns the token collection name.
437      */
438     function name() external view returns (string memory);
439 
440     /**
441      * @dev Returns the token collection symbol.
442      */
443     function symbol() external view returns (string memory);
444 
445     /**
446      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
447      */
448     function tokenURI(uint256 tokenId) external view returns (string memory);
449 
450     // =============================================================
451     //                           IERC2309
452     // =============================================================
453 
454     /**
455      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
456      * (inclusive) is transferred from `from` to `to`, as defined in the
457      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
458      *
459      * See {_mintERC2309} for more details.
460      */
461     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
462 }
463 
464 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
465 
466 
467 // ERC721A Contracts v4.2.3
468 // Creator: Chiru Labs
469 
470 pragma solidity ^0.8.4;
471 
472 
473 /**
474  * @dev Interface of ERC721AQueryable.
475  */
476 interface IERC721AQueryable is IERC721A {
477     /**
478      * Invalid query range (`start` >= `stop`).
479      */
480     error InvalidQueryRange();
481 
482     /**
483      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
484      *
485      * If the `tokenId` is out of bounds:
486      *
487      * - `addr = address(0)`
488      * - `startTimestamp = 0`
489      * - `burned = false`
490      * - `extraData = 0`
491      *
492      * If the `tokenId` is burned:
493      *
494      * - `addr = <Address of owner before token was burned>`
495      * - `startTimestamp = <Timestamp when token was burned>`
496      * - `burned = true`
497      * - `extraData = <Extra data when token was burned>`
498      *
499      * Otherwise:
500      *
501      * - `addr = <Address of owner>`
502      * - `startTimestamp = <Timestamp of start of ownership>`
503      * - `burned = false`
504      * - `extraData = <Extra data at start of ownership>`
505      */
506     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
507 
508     /**
509      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
510      * See {ERC721AQueryable-explicitOwnershipOf}
511      */
512     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
513 
514     /**
515      * @dev Returns an array of token IDs owned by `owner`,
516      * in the range [`start`, `stop`)
517      * (i.e. `start <= tokenId < stop`).
518      *
519      * This function allows for tokens to be queried if the collection
520      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
521      *
522      * Requirements:
523      *
524      * - `start < stop`
525      */
526     function tokensOfOwnerIn(
527         address owner,
528         uint256 start,
529         uint256 stop
530     ) external view returns (uint256[] memory);
531 
532     /**
533      * @dev Returns an array of token IDs owned by `owner`.
534      *
535      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
536      * It is meant to be called off-chain.
537      *
538      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
539      * multiple smaller scans if the collection is large enough to cause
540      * an out-of-gas error (10K collections should be fine).
541      */
542     function tokensOfOwner(address owner) external view returns (uint256[] memory);
543 }
544 
545 // File: erc721a/contracts/ERC721A.sol
546 
547 
548 // ERC721A Contracts v4.2.3
549 // Creator: Chiru Labs
550 
551 pragma solidity ^0.8.4;
552 
553 
554 /**
555  * @dev Interface of ERC721 token receiver.
556  */
557 interface ERC721A__IERC721Receiver {
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 /**
567  * @title ERC721A
568  *
569  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
570  * Non-Fungible Token Standard, including the Metadata extension.
571  * Optimized for lower gas during batch mints.
572  *
573  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
574  * starting from `_startTokenId()`.
575  *
576  * Assumptions:
577  *
578  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
579  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
580  */
581 contract ERC721A is IERC721A {
582     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
583     struct TokenApprovalRef {
584         address value;
585     }
586 
587     // =============================================================
588     //                           CONSTANTS
589     // =============================================================
590 
591     // Mask of an entry in packed address data.
592     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
593 
594     // The bit position of `numberMinted` in packed address data.
595     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
596 
597     // The bit position of `numberBurned` in packed address data.
598     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
599 
600     // The bit position of `aux` in packed address data.
601     uint256 private constant _BITPOS_AUX = 192;
602 
603     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
604     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
605 
606     // The bit position of `startTimestamp` in packed ownership.
607     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
608 
609     // The bit mask of the `burned` bit in packed ownership.
610     uint256 private constant _BITMASK_BURNED = 1 << 224;
611 
612     // The bit position of the `nextInitialized` bit in packed ownership.
613     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
614 
615     // The bit mask of the `nextInitialized` bit in packed ownership.
616     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
617 
618     // The bit position of `extraData` in packed ownership.
619     uint256 private constant _BITPOS_EXTRA_DATA = 232;
620 
621     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
622     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
623 
624     // The mask of the lower 160 bits for addresses.
625     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
626 
627     // The maximum `quantity` that can be minted with {_mintERC2309}.
628     // This limit is to prevent overflows on the address data entries.
629     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
630     // is required to cause an overflow, which is unrealistic.
631     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
632 
633     // The `Transfer` event signature is given by:
634     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
635     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
636         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
637 
638     // =============================================================
639     //                            STORAGE
640     // =============================================================
641 
642     // The next token ID to be minted.
643     uint256 private _currentIndex;
644 
645     // The number of tokens burned.
646     uint256 private _burnCounter;
647 
648     // Token name
649     string private _name;
650 
651     // Token symbol
652     string private _symbol;
653 
654     // Mapping from token ID to ownership details
655     // An empty struct value does not necessarily mean the token is unowned.
656     // See {_packedOwnershipOf} implementation for details.
657     //
658     // Bits Layout:
659     // - [0..159]   `addr`
660     // - [160..223] `startTimestamp`
661     // - [224]      `burned`
662     // - [225]      `nextInitialized`
663     // - [232..255] `extraData`
664     mapping(uint256 => uint256) private _packedOwnerships;
665 
666     // Mapping owner address to address data.
667     //
668     // Bits Layout:
669     // - [0..63]    `balance`
670     // - [64..127]  `numberMinted`
671     // - [128..191] `numberBurned`
672     // - [192..255] `aux`
673     mapping(address => uint256) private _packedAddressData;
674 
675     // Mapping from token ID to approved address.
676     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     // =============================================================
682     //                          CONSTRUCTOR
683     // =============================================================
684 
685     constructor(string memory name_, string memory symbol_) {
686         _name = name_;
687         _symbol = symbol_;
688         _currentIndex = _startTokenId();
689     }
690 
691     // =============================================================
692     //                   TOKEN COUNTING OPERATIONS
693     // =============================================================
694 
695     /**
696      * @dev Returns the starting token ID.
697      * To change the starting token ID, please override this function.
698      */
699     function _startTokenId() internal view virtual returns (uint256) {
700         return 0;
701     }
702 
703     /**
704      * @dev Returns the next token ID to be minted.
705      */
706     function _nextTokenId() internal view virtual returns (uint256) {
707         return _currentIndex;
708     }
709 
710     /**
711      * @dev Returns the total number of tokens in existence.
712      * Burned tokens will reduce the count.
713      * To get the total number of tokens minted, please see {_totalMinted}.
714      */
715     function totalSupply() public view virtual override returns (uint256) {
716         // Counter underflow is impossible as _burnCounter cannot be incremented
717         // more than `_currentIndex - _startTokenId()` times.
718         unchecked {
719             return _currentIndex - _burnCounter - _startTokenId();
720         }
721     }
722 
723     /**
724      * @dev Returns the total amount of tokens minted in the contract.
725      */
726     function _totalMinted() internal view virtual returns (uint256) {
727         // Counter underflow is impossible as `_currentIndex` does not decrement,
728         // and it is initialized to `_startTokenId()`.
729         unchecked {
730             return _currentIndex - _startTokenId();
731         }
732     }
733 
734     /**
735      * @dev Returns the total number of tokens burned.
736      */
737     function _totalBurned() internal view virtual returns (uint256) {
738         return _burnCounter;
739     }
740 
741     // =============================================================
742     //                    ADDRESS DATA OPERATIONS
743     // =============================================================
744 
745     /**
746      * @dev Returns the number of tokens in `owner`'s account.
747      */
748     function balanceOf(address owner) public view virtual override returns (uint256) {
749         if (owner == address(0)) revert BalanceQueryForZeroAddress();
750         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
751     }
752 
753     /**
754      * Returns the number of tokens minted by `owner`.
755      */
756     function _numberMinted(address owner) internal view returns (uint256) {
757         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
758     }
759 
760     /**
761      * Returns the number of tokens burned by or on behalf of `owner`.
762      */
763     function _numberBurned(address owner) internal view returns (uint256) {
764         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
765     }
766 
767     /**
768      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
769      */
770     function _getAux(address owner) internal view returns (uint64) {
771         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
772     }
773 
774     /**
775      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
776      * If there are multiple variables, please pack them into a uint64.
777      */
778     function _setAux(address owner, uint64 aux) internal virtual {
779         uint256 packed = _packedAddressData[owner];
780         uint256 auxCasted;
781         // Cast `aux` with assembly to avoid redundant masking.
782         assembly {
783             auxCasted := aux
784         }
785         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
786         _packedAddressData[owner] = packed;
787     }
788 
789     // =============================================================
790     //                            IERC165
791     // =============================================================
792 
793     /**
794      * @dev Returns true if this contract implements the interface defined by
795      * `interfaceId`. See the corresponding
796      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
797      * to learn more about how these ids are created.
798      *
799      * This function call must use less than 30000 gas.
800      */
801     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
802         // The interface IDs are constants representing the first 4 bytes
803         // of the XOR of all function selectors in the interface.
804         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
805         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
806         return
807             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
808             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
809             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
810     }
811 
812     // =============================================================
813     //                        IERC721Metadata
814     // =============================================================
815 
816     /**
817      * @dev Returns the token collection name.
818      */
819     function name() public view virtual override returns (string memory) {
820         return _name;
821     }
822 
823     /**
824      * @dev Returns the token collection symbol.
825      */
826     function symbol() public view virtual override returns (string memory) {
827         return _symbol;
828     }
829 
830     /**
831      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
832      */
833     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
834         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
835 
836         string memory baseURI = _baseURI();
837         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
838     }
839 
840     /**
841      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
842      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
843      * by default, it can be overridden in child contracts.
844      */
845     function _baseURI() internal view virtual returns (string memory) {
846         return '';
847     }
848 
849     // =============================================================
850     //                     OWNERSHIPS OPERATIONS
851     // =============================================================
852 
853     /**
854      * @dev Returns the owner of the `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
861         return address(uint160(_packedOwnershipOf(tokenId)));
862     }
863 
864     /**
865      * @dev Gas spent here starts off proportional to the maximum mint batch size.
866      * It gradually moves to O(1) as tokens get transferred around over time.
867      */
868     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
869         return _unpackedOwnership(_packedOwnershipOf(tokenId));
870     }
871 
872     /**
873      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
874      */
875     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
876         return _unpackedOwnership(_packedOwnerships[index]);
877     }
878 
879     /**
880      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
881      */
882     function _initializeOwnershipAt(uint256 index) internal virtual {
883         if (_packedOwnerships[index] == 0) {
884             _packedOwnerships[index] = _packedOwnershipOf(index);
885         }
886     }
887 
888     /**
889      * Returns the packed ownership data of `tokenId`.
890      */
891     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
892         uint256 curr = tokenId;
893 
894         unchecked {
895             if (_startTokenId() <= curr)
896                 if (curr < _currentIndex) {
897                     uint256 packed = _packedOwnerships[curr];
898                     // If not burned.
899                     if (packed & _BITMASK_BURNED == 0) {
900                         // Invariant:
901                         // There will always be an initialized ownership slot
902                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
903                         // before an unintialized ownership slot
904                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
905                         // Hence, `curr` will not underflow.
906                         //
907                         // We can directly compare the packed value.
908                         // If the address is zero, packed will be zero.
909                         while (packed == 0) {
910                             packed = _packedOwnerships[--curr];
911                         }
912                         return packed;
913                     }
914                 }
915         }
916         revert OwnerQueryForNonexistentToken();
917     }
918 
919     /**
920      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
921      */
922     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
923         ownership.addr = address(uint160(packed));
924         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
925         ownership.burned = packed & _BITMASK_BURNED != 0;
926         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
927     }
928 
929     /**
930      * @dev Packs ownership data into a single uint256.
931      */
932     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
933         assembly {
934             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
935             owner := and(owner, _BITMASK_ADDRESS)
936             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
937             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
938         }
939     }
940 
941     /**
942      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
943      */
944     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
945         // For branchless setting of the `nextInitialized` flag.
946         assembly {
947             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
948             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
949         }
950     }
951 
952     // =============================================================
953     //                      APPROVAL OPERATIONS
954     // =============================================================
955 
956     /**
957      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
958      * The approval is cleared when the token is transferred.
959      *
960      * Only a single account can be approved at a time, so approving the
961      * zero address clears previous approvals.
962      *
963      * Requirements:
964      *
965      * - The caller must own the token or be an approved operator.
966      * - `tokenId` must exist.
967      *
968      * Emits an {Approval} event.
969      */
970     function approve(address to, uint256 tokenId) public payable virtual override {
971         address owner = ownerOf(tokenId);
972 
973         if (_msgSenderERC721A() != owner)
974             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
975                 revert ApprovalCallerNotOwnerNorApproved();
976             }
977 
978         _tokenApprovals[tokenId].value = to;
979         emit Approval(owner, to, tokenId);
980     }
981 
982     /**
983      * @dev Returns the account approved for `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function getApproved(uint256 tokenId) public view virtual override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId].value;
993     }
994 
995     /**
996      * @dev Approve or remove `operator` as an operator for the caller.
997      * Operators can call {transferFrom} or {safeTransferFrom}
998      * for any token owned by the caller.
999      *
1000      * Requirements:
1001      *
1002      * - The `operator` cannot be the caller.
1003      *
1004      * Emits an {ApprovalForAll} event.
1005      */
1006     function setApprovalForAll(address operator, bool approved) public virtual override {
1007         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1008         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1013      *
1014      * See {setApprovalForAll}.
1015      */
1016     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1017         return _operatorApprovals[owner][operator];
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted. See {_mint}.
1026      */
1027     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1028         return
1029             _startTokenId() <= tokenId &&
1030             tokenId < _currentIndex && // If within bounds,
1031             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1032     }
1033 
1034     /**
1035      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1036      */
1037     function _isSenderApprovedOrOwner(
1038         address approvedAddress,
1039         address owner,
1040         address msgSender
1041     ) private pure returns (bool result) {
1042         assembly {
1043             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1044             owner := and(owner, _BITMASK_ADDRESS)
1045             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1046             msgSender := and(msgSender, _BITMASK_ADDRESS)
1047             // `msgSender == owner || msgSender == approvedAddress`.
1048             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1049         }
1050     }
1051 
1052     /**
1053      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1054      */
1055     function _getApprovedSlotAndAddress(uint256 tokenId)
1056         private
1057         view
1058         returns (uint256 approvedAddressSlot, address approvedAddress)
1059     {
1060         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1061         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1062         assembly {
1063             approvedAddressSlot := tokenApproval.slot
1064             approvedAddress := sload(approvedAddressSlot)
1065         }
1066     }
1067 
1068     // =============================================================
1069     //                      TRANSFER OPERATIONS
1070     // =============================================================
1071 
1072     /**
1073      * @dev Transfers `tokenId` from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must be owned by `from`.
1080      * - If the caller is not `from`, it must be approved to move this token
1081      * by either {approve} or {setApprovalForAll}.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function transferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) public payable virtual override {
1090         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1091 
1092         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1093 
1094         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1095 
1096         // The nested ifs save around 20+ gas over a compound boolean condition.
1097         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1098             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1099 
1100         if (to == address(0)) revert TransferToZeroAddress();
1101 
1102         _beforeTokenTransfers(from, to, tokenId, 1);
1103 
1104         // Clear approvals from the previous owner.
1105         assembly {
1106             if approvedAddress {
1107                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1108                 sstore(approvedAddressSlot, 0)
1109             }
1110         }
1111 
1112         // Underflow of the sender's balance is impossible because we check for
1113         // ownership above and the recipient's balance can't realistically overflow.
1114         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1115         unchecked {
1116             // We can directly increment and decrement the balances.
1117             --_packedAddressData[from]; // Updates: `balance -= 1`.
1118             ++_packedAddressData[to]; // Updates: `balance += 1`.
1119 
1120             // Updates:
1121             // - `address` to the next owner.
1122             // - `startTimestamp` to the timestamp of transfering.
1123             // - `burned` to `false`.
1124             // - `nextInitialized` to `true`.
1125             _packedOwnerships[tokenId] = _packOwnershipData(
1126                 to,
1127                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1128             );
1129 
1130             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1131             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1132                 uint256 nextTokenId = tokenId + 1;
1133                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1134                 if (_packedOwnerships[nextTokenId] == 0) {
1135                     // If the next slot is within bounds.
1136                     if (nextTokenId != _currentIndex) {
1137                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1138                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1139                     }
1140                 }
1141             }
1142         }
1143 
1144         emit Transfer(from, to, tokenId);
1145         _afterTokenTransfers(from, to, tokenId, 1);
1146     }
1147 
1148     /**
1149      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public payable virtual override {
1156         safeTransferFrom(from, to, tokenId, '');
1157     }
1158 
1159     /**
1160      * @dev Safely transfers `tokenId` token from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `from` cannot be the zero address.
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must exist and be owned by `from`.
1167      * - If the caller is not `from`, it must be approved to move this token
1168      * by either {approve} or {setApprovalForAll}.
1169      * - If `to` refers to a smart contract, it must implement
1170      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function safeTransferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) public payable virtual override {
1180         transferFrom(from, to, tokenId);
1181         if (to.code.length != 0)
1182             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1183                 revert TransferToNonERC721ReceiverImplementer();
1184             }
1185     }
1186 
1187     /**
1188      * @dev Hook that is called before a set of serially-ordered token IDs
1189      * are about to be transferred. This includes minting.
1190      * And also called before burning one token.
1191      *
1192      * `startTokenId` - the first token ID to be transferred.
1193      * `quantity` - the amount to be transferred.
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, `tokenId` will be burned by `from`.
1201      * - `from` and `to` are never both zero.
1202      */
1203     function _beforeTokenTransfers(
1204         address from,
1205         address to,
1206         uint256 startTokenId,
1207         uint256 quantity
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Hook that is called after a set of serially-ordered token IDs
1212      * have been transferred. This includes minting.
1213      * And also called after one token has been burned.
1214      *
1215      * `startTokenId` - the first token ID to be transferred.
1216      * `quantity` - the amount to be transferred.
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` has been minted for `to`.
1223      * - When `to` is zero, `tokenId` has been burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _afterTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 
1233     /**
1234      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1235      *
1236      * `from` - Previous owner of the given token ID.
1237      * `to` - Target address that will receive the token.
1238      * `tokenId` - Token ID to be transferred.
1239      * `_data` - Optional data to send along with the call.
1240      *
1241      * Returns whether the call correctly returned the expected magic value.
1242      */
1243     function _checkContractOnERC721Received(
1244         address from,
1245         address to,
1246         uint256 tokenId,
1247         bytes memory _data
1248     ) private returns (bool) {
1249         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1250             bytes4 retval
1251         ) {
1252             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1253         } catch (bytes memory reason) {
1254             if (reason.length == 0) {
1255                 revert TransferToNonERC721ReceiverImplementer();
1256             } else {
1257                 assembly {
1258                     revert(add(32, reason), mload(reason))
1259                 }
1260             }
1261         }
1262     }
1263 
1264     // =============================================================
1265     //                        MINT OPERATIONS
1266     // =============================================================
1267 
1268     /**
1269      * @dev Mints `quantity` tokens and transfers them to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `to` cannot be the zero address.
1274      * - `quantity` must be greater than 0.
1275      *
1276      * Emits a {Transfer} event for each mint.
1277      */
1278     function _mint(address to, uint256 quantity) internal virtual {
1279         uint256 startTokenId = _currentIndex;
1280         if (quantity == 0) revert MintZeroQuantity();
1281 
1282         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1283 
1284         // Overflows are incredibly unrealistic.
1285         // `balance` and `numberMinted` have a maximum limit of 2**64.
1286         // `tokenId` has a maximum limit of 2**256.
1287         unchecked {
1288             // Updates:
1289             // - `balance += quantity`.
1290             // - `numberMinted += quantity`.
1291             //
1292             // We can directly add to the `balance` and `numberMinted`.
1293             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1294 
1295             // Updates:
1296             // - `address` to the owner.
1297             // - `startTimestamp` to the timestamp of minting.
1298             // - `burned` to `false`.
1299             // - `nextInitialized` to `quantity == 1`.
1300             _packedOwnerships[startTokenId] = _packOwnershipData(
1301                 to,
1302                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1303             );
1304 
1305             uint256 toMasked;
1306             uint256 end = startTokenId + quantity;
1307 
1308             // Use assembly to loop and emit the `Transfer` event for gas savings.
1309             // The duplicated `log4` removes an extra check and reduces stack juggling.
1310             // The assembly, together with the surrounding Solidity code, have been
1311             // delicately arranged to nudge the compiler into producing optimized opcodes.
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
1325                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1326                 // that overflows uint256 will make the loop run out of gas.
1327                 // The compiler will optimize the `iszero` away for performance.
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
1600             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1601             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1602             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1603             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1604             let m := add(mload(0x40), 0xa0)
1605             // Update the free memory pointer to allocate.
1606             mstore(0x40, m)
1607             // Assign the `str` to the end.
1608             str := sub(m, 0x20)
1609             // Zeroize the slot after the string.
1610             mstore(str, 0)
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
1638 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1639 
1640 
1641 // ERC721A Contracts v4.2.3
1642 // Creator: Chiru Labs
1643 
1644 pragma solidity ^0.8.4;
1645 
1646 
1647 
1648 /**
1649  * @title ERC721AQueryable.
1650  *
1651  * @dev ERC721A subclass with convenience query functions.
1652  */
1653 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1654     /**
1655      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1656      *
1657      * If the `tokenId` is out of bounds:
1658      *
1659      * - `addr = address(0)`
1660      * - `startTimestamp = 0`
1661      * - `burned = false`
1662      * - `extraData = 0`
1663      *
1664      * If the `tokenId` is burned:
1665      *
1666      * - `addr = <Address of owner before token was burned>`
1667      * - `startTimestamp = <Timestamp when token was burned>`
1668      * - `burned = true`
1669      * - `extraData = <Extra data when token was burned>`
1670      *
1671      * Otherwise:
1672      *
1673      * - `addr = <Address of owner>`
1674      * - `startTimestamp = <Timestamp of start of ownership>`
1675      * - `burned = false`
1676      * - `extraData = <Extra data at start of ownership>`
1677      */
1678     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1679         TokenOwnership memory ownership;
1680         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1681             return ownership;
1682         }
1683         ownership = _ownershipAt(tokenId);
1684         if (ownership.burned) {
1685             return ownership;
1686         }
1687         return _ownershipOf(tokenId);
1688     }
1689 
1690     /**
1691      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1692      * See {ERC721AQueryable-explicitOwnershipOf}
1693      */
1694     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1695         external
1696         view
1697         virtual
1698         override
1699         returns (TokenOwnership[] memory)
1700     {
1701         unchecked {
1702             uint256 tokenIdsLength = tokenIds.length;
1703             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1704             for (uint256 i; i != tokenIdsLength; ++i) {
1705                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1706             }
1707             return ownerships;
1708         }
1709     }
1710 
1711     /**
1712      * @dev Returns an array of token IDs owned by `owner`,
1713      * in the range [`start`, `stop`)
1714      * (i.e. `start <= tokenId < stop`).
1715      *
1716      * This function allows for tokens to be queried if the collection
1717      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1718      *
1719      * Requirements:
1720      *
1721      * - `start < stop`
1722      */
1723     function tokensOfOwnerIn(
1724         address owner,
1725         uint256 start,
1726         uint256 stop
1727     ) external view virtual override returns (uint256[] memory) {
1728         unchecked {
1729             if (start >= stop) revert InvalidQueryRange();
1730             uint256 tokenIdsIdx;
1731             uint256 stopLimit = _nextTokenId();
1732             // Set `start = max(start, _startTokenId())`.
1733             if (start < _startTokenId()) {
1734                 start = _startTokenId();
1735             }
1736             // Set `stop = min(stop, stopLimit)`.
1737             if (stop > stopLimit) {
1738                 stop = stopLimit;
1739             }
1740             uint256 tokenIdsMaxLength = balanceOf(owner);
1741             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1742             // to cater for cases where `balanceOf(owner)` is too big.
1743             if (start < stop) {
1744                 uint256 rangeLength = stop - start;
1745                 if (rangeLength < tokenIdsMaxLength) {
1746                     tokenIdsMaxLength = rangeLength;
1747                 }
1748             } else {
1749                 tokenIdsMaxLength = 0;
1750             }
1751             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1752             if (tokenIdsMaxLength == 0) {
1753                 return tokenIds;
1754             }
1755             // We need to call `explicitOwnershipOf(start)`,
1756             // because the slot at `start` may not be initialized.
1757             TokenOwnership memory ownership = explicitOwnershipOf(start);
1758             address currOwnershipAddr;
1759             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1760             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1761             if (!ownership.burned) {
1762                 currOwnershipAddr = ownership.addr;
1763             }
1764             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1765                 ownership = _ownershipAt(i);
1766                 if (ownership.burned) {
1767                     continue;
1768                 }
1769                 if (ownership.addr != address(0)) {
1770                     currOwnershipAddr = ownership.addr;
1771                 }
1772                 if (currOwnershipAddr == owner) {
1773                     tokenIds[tokenIdsIdx++] = i;
1774                 }
1775             }
1776             // Downsize the array to fit.
1777             assembly {
1778                 mstore(tokenIds, tokenIdsIdx)
1779             }
1780             return tokenIds;
1781         }
1782     }
1783 
1784     /**
1785      * @dev Returns an array of token IDs owned by `owner`.
1786      *
1787      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1788      * It is meant to be called off-chain.
1789      *
1790      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1791      * multiple smaller scans if the collection is large enough to cause
1792      * an out-of-gas error (10K collections should be fine).
1793      */
1794     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1795         unchecked {
1796             uint256 tokenIdsIdx;
1797             address currOwnershipAddr;
1798             uint256 tokenIdsLength = balanceOf(owner);
1799             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1800             TokenOwnership memory ownership;
1801             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1802                 ownership = _ownershipAt(i);
1803                 if (ownership.burned) {
1804                     continue;
1805                 }
1806                 if (ownership.addr != address(0)) {
1807                     currOwnershipAddr = ownership.addr;
1808                 }
1809                 if (currOwnershipAddr == owner) {
1810                     tokenIds[tokenIdsIdx++] = i;
1811                 }
1812             }
1813             return tokenIds;
1814         }
1815     }
1816 }
1817 
1818 // File: contracts/Gm_Cookies/GmCookieNft.sol
1819 
1820 // contracts/GmCookiesNFT.sol
1821 
1822 
1823                                                                     
1824 pragma solidity ^0.8.0;
1825 
1826 
1827 
1828 
1829 
1830 /*
1831  ____                ____                    __                           
1832 /\  _`\             /\  _`\                 /\ \      __                  
1833 \ \ \L\_\    ___ ___\ \ \/\_\    ___     ___\ \ \/'\ /\_\     __    ____  
1834  \ \ \L_L  /' __` __`\ \ \/_/_  / __`\  / __`\ \ , < \/\ \  /'__`\ /',__\ 
1835   \ \ \/, \/\ \/\ \/\ \ \ \L\ \/\ \L\ \/\ \L\ \ \ \\`\\ \ \/\  __//\__, `\
1836    \ \____/\ \_\ \_\ \_\ \____/\ \____/\ \____/\ \_\ \_\ \_\ \____\/\____/
1837     \/___/  \/_/\/_/\/_/\/___/  \/___/  \/___/  \/_/\/_/\/_/\/____/\/___/ 
1838 */    
1839 contract GmCookieNFT is Ownable, ERC721AQueryable, ReentrancyGuard {
1840     constructor() ERC721A("GM!Cookies!", "GM!Cookies!") {
1841         PRICE = 3000000000000000;
1842     }
1843 
1844     string public BASE_URI = "/";
1845 
1846     function initialize() public onlyOwner nonReentrant {
1847         _safeMint(owner(), 1);
1848     }
1849 
1850     uint256 public constant MAX_SUPPLY = 1999; // MAX_SUPPLY
1851     uint256 public constant MAX_MINT = 5; // max per mint call
1852     uint256 public constant MAX_MINT_PER_ADDRESS = 10; // the max num single address can <MINT>
1853     uint256 public PRICE = 3000000000000000; // price
1854 
1855     bool public paused = true; // if the saling is running
1856     uint256 public minted = 0;
1857 
1858     mapping(address => uint256) public userMinted; // to limit single user mint max
1859     mapping(address => bool) public burnPassMap;
1860 
1861     function setBaseUri(string memory uri) public onlyOwner {
1862         BASE_URI = uri;
1863     }
1864 
1865     function _baseURI() internal view virtual override returns (string memory) {
1866         return BASE_URI;
1867     }
1868 
1869     function setPause(bool _paused) public onlyOwner {
1870         paused = _paused;
1871     }
1872 
1873     function setPrice(uint256 newPrice) public onlyOwner {
1874         PRICE = newPrice;
1875     }
1876 
1877     modifier notPaused() {
1878         require(!paused, "gm! cookies error: sale paused!");
1879         _;
1880     }
1881 
1882     function mint(uint256 amount) public payable notPaused nonReentrant {
1883         address wallet = _msgSender();
1884         // EOA check
1885         require(msg.sender == tx.origin, "gm! cookies error: eoa only");
1886         // CHECK PAYMENT
1887         require(PRICE * amount <= msg.value, "gm! cookies error: price not enough");
1888         // CHECK MINT AMOUNT
1889         require(MAX_MINT >= amount, "gm! cookies error: u cannot mint once more than MAX_MINT (5) !");
1890         // CHECK REACH CAP
1891         require(MAX_SUPPLY >= minted + amount, "gm! cookies error: MAX_SUPPLY reached!");
1892         // CHECK REACH USER MINT CAP
1893         require(MAX_MINT_PER_ADDRESS >= userMinted[wallet] + amount,"gm! cookies error: u cannot mint more than MAX_MINT_PER_ADDRESS (10) !");
1894         _safeMint(wallet,amount);
1895     }
1896 
1897     function _safeMint(address wallet,uint256 amount) override internal {
1898         // mint
1899         super._safeMint(wallet, amount);
1900         userMinted[wallet] += amount;
1901         minted += amount;
1902     }
1903 
1904     function setburnPassMap(address _addr, bool pass) public onlyOwner {
1905         burnPassMap[_addr] = pass;
1906     }
1907 
1908     function burn(uint256 tokenId, address _user) external {
1909         require(_msgSender() == owner() || burnPassMap[_msgSender()], "gm! cookies error:user or contract shall not pass");
1910         require(ownerOf(tokenId) == _user, "gm! cookies error:only owner can burn this token!");
1911         _burn(tokenId);
1912     }
1913 
1914     function withdraw(uint256 amount) public onlyOwner nonReentrant {
1915         uint256 _amt = amount;
1916         if (amount == 0) {
1917             _amt = address(this).balance;
1918         }
1919         require(_amt > 0, "gm! cookies error:amount cannot be zero");
1920         _widthdraw(owner(), _amt);
1921     }
1922 
1923     function _widthdraw(address _address, uint256 _amount) private {
1924         (bool success, ) = _address.call{value: _amount}("");
1925         require(success, "gm! cookies error:Transfer failed.");
1926     }
1927 
1928     function setApprovalForAll(address operator, bool approved) public override(IERC721A, ERC721A) {
1929         super.setApprovalForAll(operator, approved);
1930     }
1931 
1932     function approve(address operator, uint256 tokenId) public payable override(IERC721A, ERC721A) {
1933         super.approve(operator, tokenId);
1934     }
1935 
1936     struct ContractDashboard {
1937         bool paused;
1938         uint256 totalMinted;
1939         uint256 totalSupply;
1940         uint256 userMinted;
1941     }
1942 
1943     function status(address _addr) public view returns (ContractDashboard memory dashboard) {
1944         dashboard.paused = paused;
1945         dashboard.totalMinted = minted;
1946         dashboard.totalSupply = totalSupply();
1947         dashboard.userMinted = userMinted[_addr];
1948         return dashboard;
1949     }
1950 
1951     function transferFrom(
1952         address from,
1953         address to,
1954         uint256 tokenId
1955     ) public payable override(IERC721A, ERC721A) {
1956         super.transferFrom(from, to, tokenId);
1957     }
1958 
1959     function safeTransferFrom(
1960         address from,
1961         address to,
1962         uint256 tokenId
1963     ) public payable override(IERC721A, ERC721A) {
1964         super.safeTransferFrom(from, to, tokenId);
1965     }
1966 
1967     function safeTransferFrom(
1968         address from,
1969         address to,
1970         uint256 tokenId,
1971         bytes memory data
1972     ) public payable override(IERC721A, ERC721A) {
1973         super.safeTransferFrom(from, to, tokenId, data);
1974     }
1975 
1976     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC721A, ERC721A) returns (bool) {
1977         // Supports the following `interfaceId`s:
1978         // - IERC165: 0x01ffc9a7
1979         // - IERC721: 0x80ac58cd
1980         // - IERC721Metadata: 0x5b5e139f
1981         return ERC721A.supportsInterface(interfaceId);
1982     }
1983 }