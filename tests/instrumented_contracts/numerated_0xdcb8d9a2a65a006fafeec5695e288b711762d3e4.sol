1 // Sources flattened with hardhat v2.9.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
4 
5 // : MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
31 
32 // : MIT
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
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
113 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
114 
115 // : MIT
116 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Contract module which allows children to implement an emergency stop
122  * mechanism that can be triggered by an authorized account.
123  *
124  * This module is used through inheritance. It will make available the
125  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
126  * the functions of your contract. Note that they will not be pausable by
127  * simply including this module, only once the modifiers are put in place.
128  */
129 abstract contract Pausable is Context {
130     /**
131      * @dev Emitted when the pause is triggered by `account`.
132      */
133     event Paused(address account);
134 
135     /**
136      * @dev Emitted when the pause is lifted by `account`.
137      */
138     event Unpaused(address account);
139 
140     bool private _paused;
141 
142     /**
143      * @dev Initializes the contract in unpaused state.
144      */
145     constructor() {
146         _paused = false;
147     }
148 
149     /**
150      * @dev Returns true if the contract is paused, and false otherwise.
151      */
152     function paused() public view virtual returns (bool) {
153         return _paused;
154     }
155 
156     /**
157      * @dev Modifier to make a function callable only when the contract is not paused.
158      *
159      * Requirements:
160      *
161      * - The contract must not be paused.
162      */
163     modifier whenNotPaused() {
164         require(!paused(), "Pausable: paused");
165         _;
166     }
167 
168     /**
169      * @dev Modifier to make a function callable only when the contract is paused.
170      *
171      * Requirements:
172      *
173      * - The contract must be paused.
174      */
175     modifier whenPaused() {
176         require(paused(), "Pausable: not paused");
177         _;
178     }
179 
180     /**
181      * @dev Triggers stopped state.
182      *
183      * Requirements:
184      *
185      * - The contract must not be paused.
186      */
187     function _pause() internal virtual whenNotPaused {
188         _paused = true;
189         emit Paused(_msgSender());
190     }
191 
192     /**
193      * @dev Returns to normal state.
194      *
195      * Requirements:
196      *
197      * - The contract must be paused.
198      */
199     function _unpause() internal virtual whenPaused {
200         _paused = false;
201         emit Unpaused(_msgSender());
202     }
203 }
204 
205 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
206 
207 // : MIT
208 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Contract module that helps prevent reentrant calls to a function.
214  *
215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
216  * available, which can be applied to functions to make sure there are no nested
217  * (reentrant) calls to them.
218  *
219  * Note that because there is a single `nonReentrant` guard, functions marked as
220  * `nonReentrant` may not call one another. This can be worked around by making
221  * those functions `private`, and then adding `external` `nonReentrant` entry
222  * points to them.
223  *
224  * TIP: If you would like to learn more about reentrancy and alternative ways
225  * to protect against it, check out our blog post
226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
227  */
228 abstract contract ReentrancyGuard {
229     // Booleans are more expensive than uint256 or any type that takes up a full
230     // word because each write operation emits an extra SLOAD to first read the
231     // slot's contents, replace the bits taken up by the boolean, and then write
232     // back. This is the compiler's defense against contract upgrades and
233     // pointer aliasing, and it cannot be disabled.
234 
235     // The values being non-zero value makes deployment a bit more expensive,
236     // but in exchange the refund on every call to nonReentrant will be lower in
237     // amount. Since refunds are capped to a percentage of the total
238     // transaction's gas, it is best to keep them low in cases like this one, to
239     // increase the likelihood of the full refund coming into effect.
240     uint256 private constant _NOT_ENTERED = 1;
241     uint256 private constant _ENTERED = 2;
242 
243     uint256 private _status;
244 
245     constructor() {
246         _status = _NOT_ENTERED;
247     }
248 
249     /**
250      * @dev Prevents a contract from calling itself, directly or indirectly.
251      * Calling a `nonReentrant` function from another `nonReentrant`
252      * function is not supported. It is possible to prevent this from happening
253      * by making the `nonReentrant` function external, and making it call a
254      * `private` function that does the actual work.
255      */
256     modifier nonReentrant() {
257         // On the first call to nonReentrant, _notEntered will be true
258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
259 
260         // Any calls to nonReentrant after this point will fail
261         _status = _ENTERED;
262 
263         _;
264 
265         // By storing the original value once again, a refund is triggered (see
266         // https://eips.ethereum.org/EIPS/eip-2200)
267         _status = _NOT_ENTERED;
268     }
269 }
270 
271 // File erc721a/contracts/IERC721A.sol@v4.2.3
272 
273 // : MIT
274 // ERC721A Contracts v4.2.3
275 // Creator: Chiru Labs
276 
277 pragma solidity ^0.8.4;
278 
279 /**
280  * @dev Interface of ERC721A.
281  */
282 interface IERC721A {
283     /**
284      * The caller must own the token or be an approved operator.
285      */
286     error ApprovalCallerNotOwnerNorApproved();
287 
288     /**
289      * The token does not exist.
290      */
291     error ApprovalQueryForNonexistentToken();
292 
293     /**
294      * Cannot query the balance for the zero address.
295      */
296     error BalanceQueryForZeroAddress();
297 
298     /**
299      * Cannot mint to the zero address.
300      */
301     error MintToZeroAddress();
302 
303     /**
304      * The quantity of tokens minted must be more than zero.
305      */
306     error MintZeroQuantity();
307 
308     /**
309      * The token does not exist.
310      */
311     error OwnerQueryForNonexistentToken();
312 
313     /**
314      * The caller must own the token or be an approved operator.
315      */
316     error TransferCallerNotOwnerNorApproved();
317 
318     /**
319      * The token must be owned by `from`.
320      */
321     error TransferFromIncorrectOwner();
322 
323     /**
324      * Cannot safely transfer to a contract that does not implement the
325      * ERC721Receiver interface.
326      */
327     error TransferToNonERC721ReceiverImplementer();
328 
329     /**
330      * Cannot transfer to the zero address.
331      */
332     error TransferToZeroAddress();
333 
334     /**
335      * The token does not exist.
336      */
337     error URIQueryForNonexistentToken();
338 
339     /**
340      * The `quantity` minted with ERC2309 exceeds the safety limit.
341      */
342     error MintERC2309QuantityExceedsLimit();
343 
344     /**
345      * The `extraData` cannot be set on an unintialized ownership slot.
346      */
347     error OwnershipNotInitializedForExtraData();
348 
349     // =============================================================
350     //                            STRUCTS
351     // =============================================================
352 
353     struct TokenOwnership {
354         // The address of the owner.
355         address addr;
356         // Stores the start time of ownership with minimal overhead for tokenomics.
357         uint64 startTimestamp;
358         // Whether the token has been burned.
359         bool burned;
360         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
361         uint24 extraData;
362     }
363 
364     // =============================================================
365     //                         TOKEN COUNTERS
366     // =============================================================
367 
368     /**
369      * @dev Returns the total number of tokens in existence.
370      * Burned tokens will reduce the count.
371      * To get the total number of tokens minted, please see {_totalMinted}.
372      */
373     function totalSupply() external view returns (uint256);
374 
375     // =============================================================
376     //                            IERC165
377     // =============================================================
378 
379     /**
380      * @dev Returns true if this contract implements the interface defined by
381      * `interfaceId`. See the corresponding
382      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
383      * to learn more about how these ids are created.
384      *
385      * This function call must use less than 30000 gas.
386      */
387     function supportsInterface(bytes4 interfaceId) external view returns (bool);
388 
389     // =============================================================
390     //                            IERC721
391     // =============================================================
392 
393     /**
394      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
395      */
396     event Transfer(
397         address indexed from,
398         address indexed to,
399         uint256 indexed tokenId
400     );
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(
406         address indexed owner,
407         address indexed approved,
408         uint256 indexed tokenId
409     );
410 
411     /**
412      * @dev Emitted when `owner` enables or disables
413      * (`approved`) `operator` to manage all of its assets.
414      */
415     event ApprovalForAll(
416         address indexed owner,
417         address indexed operator,
418         bool approved
419     );
420 
421     /**
422      * @dev Returns the number of tokens in `owner`'s account.
423      */
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     /**
427      * @dev Returns the owner of the `tokenId` token.
428      *
429      * Requirements:
430      *
431      * - `tokenId` must exist.
432      */
433     function ownerOf(uint256 tokenId) external view returns (address owner);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`,
437      * checking first that contract recipients are aware of the ERC721 protocol
438      * to prevent tokens from being forever locked.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be have been allowed to move
446      * this token by either {approve} or {setApprovalForAll}.
447      * - If `to` refers to a smart contract, it must implement
448      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external payable;
458 
459     /**
460      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external payable;
467 
468     /**
469      * @dev Transfers `tokenId` from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
472      * whenever possible.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must be owned by `from`.
479      * - If the caller is not `from`, it must be approved to move this token
480      * by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external payable;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the
495      * zero address clears previous approvals.
496      *
497      * Requirements:
498      *
499      * - The caller must own the token or be an approved operator.
500      * - `tokenId` must exist.
501      *
502      * Emits an {Approval} event.
503      */
504     function approve(address to, uint256 tokenId) external payable;
505 
506     /**
507      * @dev Approve or remove `operator` as an operator for the caller.
508      * Operators can call {transferFrom} or {safeTransferFrom}
509      * for any token owned by the caller.
510      *
511      * Requirements:
512      *
513      * - The `operator` cannot be the caller.
514      *
515      * Emits an {ApprovalForAll} event.
516      */
517     function setApprovalForAll(address operator, bool _approved) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId)
527         external
528         view
529         returns (address operator);
530 
531     /**
532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
533      *
534      * See {setApprovalForAll}.
535      */
536     function isApprovedForAll(address owner, address operator)
537         external
538         view
539         returns (bool);
540 
541     // =============================================================
542     //                        IERC721Metadata
543     // =============================================================
544 
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 
560     // =============================================================
561     //                           IERC2309
562     // =============================================================
563 
564     /**
565      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
566      * (inclusive) is transferred from `from` to `to`, as defined in the
567      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
568      *
569      * See {_mintERC2309} for more details.
570      */
571     event ConsecutiveTransfer(
572         uint256 indexed fromTokenId,
573         uint256 toTokenId,
574         address indexed from,
575         address indexed to
576     );
577 }
578 
579 // File erc721a/contracts/ERC721A.sol@v4.2.3
580 
581 // : MIT
582 // ERC721A Contracts v4.2.3
583 // Creator: Chiru Labs
584 
585 pragma solidity ^0.8.4;
586 
587 /**
588  * @dev Interface of ERC721 token receiver.
589  */
590 interface ERC721A__IERC721Receiver {
591     function onERC721Received(
592         address operator,
593         address from,
594         uint256 tokenId,
595         bytes calldata data
596     ) external returns (bytes4);
597 }
598 
599 /**
600  * @title ERC721A
601  *
602  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
603  * Non-Fungible Token Standard, including the Metadata extension.
604  * Optimized for lower gas during batch mints.
605  *
606  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
607  * starting from `_startTokenId()`.
608  *
609  * Assumptions:
610  *
611  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
612  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
613  */
614 contract ERC721A is IERC721A {
615     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
616     struct TokenApprovalRef {
617         address value;
618     }
619 
620     // =============================================================
621     //                           CONSTANTS
622     // =============================================================
623 
624     // Mask of an entry in packed address data.
625     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
626 
627     // The bit position of `numberMinted` in packed address data.
628     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
629 
630     // The bit position of `numberBurned` in packed address data.
631     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
632 
633     // The bit position of `aux` in packed address data.
634     uint256 private constant _BITPOS_AUX = 192;
635 
636     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
637     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
638 
639     // The bit position of `startTimestamp` in packed ownership.
640     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
641 
642     // The bit mask of the `burned` bit in packed ownership.
643     uint256 private constant _BITMASK_BURNED = 1 << 224;
644 
645     // The bit position of the `nextInitialized` bit in packed ownership.
646     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
647 
648     // The bit mask of the `nextInitialized` bit in packed ownership.
649     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
650 
651     // The bit position of `extraData` in packed ownership.
652     uint256 private constant _BITPOS_EXTRA_DATA = 232;
653 
654     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
655     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
656 
657     // The mask of the lower 160 bits for addresses.
658     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
659 
660     // The maximum `quantity` that can be minted with {_mintERC2309}.
661     // This limit is to prevent overflows on the address data entries.
662     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
663     // is required to cause an overflow, which is unrealistic.
664     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
665 
666     // The `Transfer` event signature is given by:
667     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
668     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
669         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
670 
671     // =============================================================
672     //                            STORAGE
673     // =============================================================
674 
675     // The next token ID to be minted.
676     uint256 private _currentIndex;
677 
678     // The number of tokens burned.
679     uint256 private _burnCounter;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to ownership details
688     // An empty struct value does not necessarily mean the token is unowned.
689     // See {_packedOwnershipOf} implementation for details.
690     //
691     // Bits Layout:
692     // - [0..159]   `addr`
693     // - [160..223] `startTimestamp`
694     // - [224]      `burned`
695     // - [225]      `nextInitialized`
696     // - [232..255] `extraData`
697     mapping(uint256 => uint256) private _packedOwnerships;
698 
699     // Mapping owner address to address data.
700     //
701     // Bits Layout:
702     // - [0..63]    `balance`
703     // - [64..127]  `numberMinted`
704     // - [128..191] `numberBurned`
705     // - [192..255] `aux`
706     mapping(address => uint256) private _packedAddressData;
707 
708     // Mapping from token ID to approved address.
709     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     // =============================================================
715     //                          CONSTRUCTOR
716     // =============================================================
717 
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721         _currentIndex = _startTokenId();
722     }
723 
724     // =============================================================
725     //                   TOKEN COUNTING OPERATIONS
726     // =============================================================
727 
728     /**
729      * @dev Returns the starting token ID.
730      * To change the starting token ID, please override this function.
731      */
732     function _startTokenId() internal view virtual returns (uint256) {
733         return 0;
734     }
735 
736     /**
737      * @dev Returns the next token ID to be minted.
738      */
739     function _nextTokenId() internal view virtual returns (uint256) {
740         return _currentIndex;
741     }
742 
743     /**
744      * @dev Returns the total number of tokens in existence.
745      * Burned tokens will reduce the count.
746      * To get the total number of tokens minted, please see {_totalMinted}.
747      */
748     function totalSupply() public view virtual override returns (uint256) {
749         // Counter underflow is impossible as _burnCounter cannot be incremented
750         // more than `_currentIndex - _startTokenId()` times.
751         unchecked {
752             return _currentIndex - _burnCounter - _startTokenId();
753         }
754     }
755 
756     /**
757      * @dev Returns the total amount of tokens minted in the contract.
758      */
759     function _totalMinted() internal view virtual returns (uint256) {
760         // Counter underflow is impossible as `_currentIndex` does not decrement,
761         // and it is initialized to `_startTokenId()`.
762         unchecked {
763             return _currentIndex - _startTokenId();
764         }
765     }
766 
767     /**
768      * @dev Returns the total number of tokens burned.
769      */
770     function _totalBurned() internal view virtual returns (uint256) {
771         return _burnCounter;
772     }
773 
774     // =============================================================
775     //                    ADDRESS DATA OPERATIONS
776     // =============================================================
777 
778     /**
779      * @dev Returns the number of tokens in `owner`'s account.
780      */
781     function balanceOf(address owner)
782         public
783         view
784         virtual
785         override
786         returns (uint256)
787     {
788         if (owner == address(0)) revert BalanceQueryForZeroAddress();
789         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
790     }
791 
792     /**
793      * Returns the number of tokens minted by `owner`.
794      */
795     function _numberMinted(address owner) internal view returns (uint256) {
796         return
797             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
798             _BITMASK_ADDRESS_DATA_ENTRY;
799     }
800 
801     /**
802      * Returns the number of tokens burned by or on behalf of `owner`.
803      */
804     function _numberBurned(address owner) internal view returns (uint256) {
805         return
806             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
807             _BITMASK_ADDRESS_DATA_ENTRY;
808     }
809 
810     /**
811      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
812      */
813     function _getAux(address owner) internal view returns (uint64) {
814         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
815     }
816 
817     /**
818      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
819      * If there are multiple variables, please pack them into a uint64.
820      */
821     function _setAux(address owner, uint64 aux) internal virtual {
822         uint256 packed = _packedAddressData[owner];
823         uint256 auxCasted;
824         // Cast `aux` with assembly to avoid redundant masking.
825         assembly {
826             auxCasted := aux
827         }
828         packed =
829             (packed & _BITMASK_AUX_COMPLEMENT) |
830             (auxCasted << _BITPOS_AUX);
831         _packedAddressData[owner] = packed;
832     }
833 
834     // =============================================================
835     //                            IERC165
836     // =============================================================
837 
838     /**
839      * @dev Returns true if this contract implements the interface defined by
840      * `interfaceId`. See the corresponding
841      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
842      * to learn more about how these ids are created.
843      *
844      * This function call must use less than 30000 gas.
845      */
846     function supportsInterface(bytes4 interfaceId)
847         public
848         view
849         virtual
850         override
851         returns (bool)
852     {
853         // The interface IDs are constants representing the first 4 bytes
854         // of the XOR of all function selectors in the interface.
855         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
856         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
857         return
858             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
859             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
860             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
861     }
862 
863     // =============================================================
864     //                        IERC721Metadata
865     // =============================================================
866 
867     /**
868      * @dev Returns the token collection name.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev Returns the token collection symbol.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
883      */
884     function tokenURI(uint256 tokenId)
885         public
886         view
887         virtual
888         override
889         returns (string memory)
890     {
891         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
892 
893         string memory baseURI = _baseURI();
894         return
895             bytes(baseURI).length != 0
896                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
897                 : "";
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, it can be overridden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return "";
907     }
908 
909     // =============================================================
910     //                     OWNERSHIPS OPERATIONS
911     // =============================================================
912 
913     /**
914      * @dev Returns the owner of the `tokenId` token.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function ownerOf(uint256 tokenId)
921         public
922         view
923         virtual
924         override
925         returns (address)
926     {
927         return address(uint160(_packedOwnershipOf(tokenId)));
928     }
929 
930     /**
931      * @dev Gas spent here starts off proportional to the maximum mint batch size.
932      * It gradually moves to O(1) as tokens get transferred around over time.
933      */
934     function _ownershipOf(uint256 tokenId)
935         internal
936         view
937         virtual
938         returns (TokenOwnership memory)
939     {
940         return _unpackedOwnership(_packedOwnershipOf(tokenId));
941     }
942 
943     /**
944      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
945      */
946     function _ownershipAt(uint256 index)
947         internal
948         view
949         virtual
950         returns (TokenOwnership memory)
951     {
952         return _unpackedOwnership(_packedOwnerships[index]);
953     }
954 
955     /**
956      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
957      */
958     function _initializeOwnershipAt(uint256 index) internal virtual {
959         if (_packedOwnerships[index] == 0) {
960             _packedOwnerships[index] = _packedOwnershipOf(index);
961         }
962     }
963 
964     /**
965      * Returns the packed ownership data of `tokenId`.
966      */
967     function _packedOwnershipOf(uint256 tokenId)
968         private
969         view
970         returns (uint256)
971     {
972         uint256 curr = tokenId;
973 
974         unchecked {
975             if (_startTokenId() <= curr)
976                 if (curr < _currentIndex) {
977                     uint256 packed = _packedOwnerships[curr];
978                     // If not burned.
979                     if (packed & _BITMASK_BURNED == 0) {
980                         // Invariant:
981                         // There will always be an initialized ownership slot
982                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
983                         // before an unintialized ownership slot
984                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
985                         // Hence, `curr` will not underflow.
986                         //
987                         // We can directly compare the packed value.
988                         // If the address is zero, packed will be zero.
989                         while (packed == 0) {
990                             packed = _packedOwnerships[--curr];
991                         }
992                         return packed;
993                     }
994                 }
995         }
996         revert OwnerQueryForNonexistentToken();
997     }
998 
999     /**
1000      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1001      */
1002     function _unpackedOwnership(uint256 packed)
1003         private
1004         pure
1005         returns (TokenOwnership memory ownership)
1006     {
1007         ownership.addr = address(uint160(packed));
1008         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1009         ownership.burned = packed & _BITMASK_BURNED != 0;
1010         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1011     }
1012 
1013     /**
1014      * @dev Packs ownership data into a single uint256.
1015      */
1016     function _packOwnershipData(address owner, uint256 flags)
1017         private
1018         view
1019         returns (uint256 result)
1020     {
1021         assembly {
1022             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1023             owner := and(owner, _BITMASK_ADDRESS)
1024             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1025             result := or(
1026                 owner,
1027                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
1028             )
1029         }
1030     }
1031 
1032     /**
1033      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1034      */
1035     function _nextInitializedFlag(uint256 quantity)
1036         private
1037         pure
1038         returns (uint256 result)
1039     {
1040         // For branchless setting of the `nextInitialized` flag.
1041         assembly {
1042             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1043             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1044         }
1045     }
1046 
1047     // =============================================================
1048     //                      APPROVAL OPERATIONS
1049     // =============================================================
1050 
1051     /**
1052      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1053      * The approval is cleared when the token is transferred.
1054      *
1055      * Only a single account can be approved at a time, so approving the
1056      * zero address clears previous approvals.
1057      *
1058      * Requirements:
1059      *
1060      * - The caller must own the token or be an approved operator.
1061      * - `tokenId` must exist.
1062      *
1063      * Emits an {Approval} event.
1064      */
1065     function approve(address to, uint256 tokenId)
1066         public
1067         payable
1068         virtual
1069         override
1070     {
1071         address owner = ownerOf(tokenId);
1072 
1073         if (_msgSenderERC721A() != owner)
1074             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1075                 revert ApprovalCallerNotOwnerNorApproved();
1076             }
1077 
1078         _tokenApprovals[tokenId].value = to;
1079         emit Approval(owner, to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Returns the account approved for `tokenId` token.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      */
1089     function getApproved(uint256 tokenId)
1090         public
1091         view
1092         virtual
1093         override
1094         returns (address)
1095     {
1096         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1097 
1098         return _tokenApprovals[tokenId].value;
1099     }
1100 
1101     /**
1102      * @dev Approve or remove `operator` as an operator for the caller.
1103      * Operators can call {transferFrom} or {safeTransferFrom}
1104      * for any token owned by the caller.
1105      *
1106      * Requirements:
1107      *
1108      * - The `operator` cannot be the caller.
1109      *
1110      * Emits an {ApprovalForAll} event.
1111      */
1112     function setApprovalForAll(address operator, bool approved)
1113         public
1114         virtual
1115         override
1116     {
1117         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1118         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1119     }
1120 
1121     /**
1122      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1123      *
1124      * See {setApprovalForAll}.
1125      */
1126     function isApprovedForAll(address owner, address operator)
1127         public
1128         view
1129         virtual
1130         override
1131         returns (bool)
1132     {
1133         return _operatorApprovals[owner][operator];
1134     }
1135 
1136     /**
1137      * @dev Returns whether `tokenId` exists.
1138      *
1139      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1140      *
1141      * Tokens start existing when they are minted. See {_mint}.
1142      */
1143     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1144         return
1145             _startTokenId() <= tokenId &&
1146             tokenId < _currentIndex && // If within bounds,
1147             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1148     }
1149 
1150     /**
1151      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1152      */
1153     function _isSenderApprovedOrOwner(
1154         address approvedAddress,
1155         address owner,
1156         address msgSender
1157     ) private pure returns (bool result) {
1158         assembly {
1159             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1160             owner := and(owner, _BITMASK_ADDRESS)
1161             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1162             msgSender := and(msgSender, _BITMASK_ADDRESS)
1163             // `msgSender == owner || msgSender == approvedAddress`.
1164             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1165         }
1166     }
1167 
1168     /**
1169      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1170      */
1171     function _getApprovedSlotAndAddress(uint256 tokenId)
1172         private
1173         view
1174         returns (uint256 approvedAddressSlot, address approvedAddress)
1175     {
1176         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1177         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1178         assembly {
1179             approvedAddressSlot := tokenApproval.slot
1180             approvedAddress := sload(approvedAddressSlot)
1181         }
1182     }
1183 
1184     // =============================================================
1185     //                      TRANSFER OPERATIONS
1186     // =============================================================
1187 
1188     /**
1189      * @dev Transfers `tokenId` from `from` to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `from` cannot be the zero address.
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      * - If the caller is not `from`, it must be approved to move this token
1197      * by either {approve} or {setApprovalForAll}.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function transferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public payable virtual override {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         if (address(uint160(prevOwnershipPacked)) != from)
1209             revert TransferFromIncorrectOwner();
1210 
1211         (
1212             uint256 approvedAddressSlot,
1213             address approvedAddress
1214         ) = _getApprovedSlotAndAddress(tokenId);
1215 
1216         // The nested ifs save around 20+ gas over a compound boolean condition.
1217         if (
1218             !_isSenderApprovedOrOwner(
1219                 approvedAddress,
1220                 from,
1221                 _msgSenderERC721A()
1222             )
1223         )
1224             if (!isApprovedForAll(from, _msgSenderERC721A()))
1225                 revert TransferCallerNotOwnerNorApproved();
1226 
1227         if (to == address(0)) revert TransferToZeroAddress();
1228 
1229         _beforeTokenTransfers(from, to, tokenId, 1);
1230 
1231         // Clear approvals from the previous owner.
1232         assembly {
1233             if approvedAddress {
1234                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1235                 sstore(approvedAddressSlot, 0)
1236             }
1237         }
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1242         unchecked {
1243             // We can directly increment and decrement the balances.
1244             --_packedAddressData[from]; // Updates: `balance -= 1`.
1245             ++_packedAddressData[to]; // Updates: `balance += 1`.
1246 
1247             // Updates:
1248             // - `address` to the next owner.
1249             // - `startTimestamp` to the timestamp of transfering.
1250             // - `burned` to `false`.
1251             // - `nextInitialized` to `true`.
1252             _packedOwnerships[tokenId] = _packOwnershipData(
1253                 to,
1254                 _BITMASK_NEXT_INITIALIZED |
1255                     _nextExtraData(from, to, prevOwnershipPacked)
1256             );
1257 
1258             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1259             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1260                 uint256 nextTokenId = tokenId + 1;
1261                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1262                 if (_packedOwnerships[nextTokenId] == 0) {
1263                     // If the next slot is within bounds.
1264                     if (nextTokenId != _currentIndex) {
1265                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1266                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1267                     }
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, to, tokenId);
1273         _afterTokenTransfers(from, to, tokenId, 1);
1274     }
1275 
1276     /**
1277      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1278      */
1279     function safeTransferFrom(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) public payable virtual override {
1284         safeTransferFrom(from, to, tokenId, "");
1285     }
1286 
1287     /**
1288      * @dev Safely transfers `tokenId` token from `from` to `to`.
1289      *
1290      * Requirements:
1291      *
1292      * - `from` cannot be the zero address.
1293      * - `to` cannot be the zero address.
1294      * - `tokenId` token must exist and be owned by `from`.
1295      * - If the caller is not `from`, it must be approved to move this token
1296      * by either {approve} or {setApprovalForAll}.
1297      * - If `to` refers to a smart contract, it must implement
1298      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function safeTransferFrom(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) public payable virtual override {
1308         transferFrom(from, to, tokenId);
1309         if (to.code.length != 0)
1310             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1311                 revert TransferToNonERC721ReceiverImplementer();
1312             }
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before a set of serially-ordered token IDs
1317      * are about to be transferred. This includes minting.
1318      * And also called before burning one token.
1319      *
1320      * `startTokenId` - the first token ID to be transferred.
1321      * `quantity` - the amount to be transferred.
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, `tokenId` will be burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _beforeTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 
1338     /**
1339      * @dev Hook that is called after a set of serially-ordered token IDs
1340      * have been transferred. This includes minting.
1341      * And also called after one token has been burned.
1342      *
1343      * `startTokenId` - the first token ID to be transferred.
1344      * `quantity` - the amount to be transferred.
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` has been minted for `to`.
1351      * - When `to` is zero, `tokenId` has been burned by `from`.
1352      * - `from` and `to` are never both zero.
1353      */
1354     function _afterTokenTransfers(
1355         address from,
1356         address to,
1357         uint256 startTokenId,
1358         uint256 quantity
1359     ) internal virtual {}
1360 
1361     /**
1362      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1363      *
1364      * `from` - Previous owner of the given token ID.
1365      * `to` - Target address that will receive the token.
1366      * `tokenId` - Token ID to be transferred.
1367      * `_data` - Optional data to send along with the call.
1368      *
1369      * Returns whether the call correctly returned the expected magic value.
1370      */
1371     function _checkContractOnERC721Received(
1372         address from,
1373         address to,
1374         uint256 tokenId,
1375         bytes memory _data
1376     ) private returns (bool) {
1377         try
1378             ERC721A__IERC721Receiver(to).onERC721Received(
1379                 _msgSenderERC721A(),
1380                 from,
1381                 tokenId,
1382                 _data
1383             )
1384         returns (bytes4 retval) {
1385             return
1386                 retval ==
1387                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1388         } catch (bytes memory reason) {
1389             if (reason.length == 0) {
1390                 revert TransferToNonERC721ReceiverImplementer();
1391             } else {
1392                 assembly {
1393                     revert(add(32, reason), mload(reason))
1394                 }
1395             }
1396         }
1397     }
1398 
1399     // =============================================================
1400     //                        MINT OPERATIONS
1401     // =============================================================
1402 
1403     /**
1404      * @dev Mints `quantity` tokens and transfers them to `to`.
1405      *
1406      * Requirements:
1407      *
1408      * - `to` cannot be the zero address.
1409      * - `quantity` must be greater than 0.
1410      *
1411      * Emits a {Transfer} event for each mint.
1412      */
1413     function _mint(address to, uint256 quantity) internal virtual {
1414         uint256 startTokenId = _currentIndex;
1415         if (quantity == 0) revert MintZeroQuantity();
1416 
1417         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1418 
1419         // Overflows are incredibly unrealistic.
1420         // `balance` and `numberMinted` have a maximum limit of 2**64.
1421         // `tokenId` has a maximum limit of 2**256.
1422         unchecked {
1423             // Updates:
1424             // - `balance += quantity`.
1425             // - `numberMinted += quantity`.
1426             //
1427             // We can directly add to the `balance` and `numberMinted`.
1428             _packedAddressData[to] +=
1429                 quantity *
1430                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1431 
1432             // Updates:
1433             // - `address` to the owner.
1434             // - `startTimestamp` to the timestamp of minting.
1435             // - `burned` to `false`.
1436             // - `nextInitialized` to `quantity == 1`.
1437             _packedOwnerships[startTokenId] = _packOwnershipData(
1438                 to,
1439                 _nextInitializedFlag(quantity) |
1440                     _nextExtraData(address(0), to, 0)
1441             );
1442 
1443             uint256 toMasked;
1444             uint256 end = startTokenId + quantity;
1445 
1446             // Use assembly to loop and emit the `Transfer` event for gas savings.
1447             // The duplicated `log4` removes an extra check and reduces stack juggling.
1448             // The assembly, together with the surrounding Solidity code, have been
1449             // delicately arranged to nudge the compiler into producing optimized opcodes.
1450             assembly {
1451                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1452                 toMasked := and(to, _BITMASK_ADDRESS)
1453                 // Emit the `Transfer` event.
1454                 log4(
1455                     0, // Start of data (0, since no data).
1456                     0, // End of data (0, since no data).
1457                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1458                     0, // `address(0)`.
1459                     toMasked, // `to`.
1460                     startTokenId // `tokenId`.
1461                 )
1462 
1463                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1464                 // that overflows uint256 will make the loop run out of gas.
1465                 // The compiler will optimize the `iszero` away for performance.
1466                 for {
1467                     let tokenId := add(startTokenId, 1)
1468                 } iszero(eq(tokenId, end)) {
1469                     tokenId := add(tokenId, 1)
1470                 } {
1471                     // Emit the `Transfer` event. Similar to above.
1472                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1473                 }
1474             }
1475             if (toMasked == 0) revert MintToZeroAddress();
1476 
1477             _currentIndex = end;
1478         }
1479         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1480     }
1481 
1482     /**
1483      * @dev Mints `quantity` tokens and transfers them to `to`.
1484      *
1485      * This function is intended for efficient minting only during contract creation.
1486      *
1487      * It emits only one {ConsecutiveTransfer} as defined in
1488      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1489      * instead of a sequence of {Transfer} event(s).
1490      *
1491      * Calling this function outside of contract creation WILL make your contract
1492      * non-compliant with the ERC721 standard.
1493      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1494      * {ConsecutiveTransfer} event is only permissible during contract creation.
1495      *
1496      * Requirements:
1497      *
1498      * - `to` cannot be the zero address.
1499      * - `quantity` must be greater than 0.
1500      *
1501      * Emits a {ConsecutiveTransfer} event.
1502      */
1503     function _mintERC2309(address to, uint256 quantity) internal virtual {
1504         uint256 startTokenId = _currentIndex;
1505         if (to == address(0)) revert MintToZeroAddress();
1506         if (quantity == 0) revert MintZeroQuantity();
1507         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
1508             revert MintERC2309QuantityExceedsLimit();
1509 
1510         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1511 
1512         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1513         unchecked {
1514             // Updates:
1515             // - `balance += quantity`.
1516             // - `numberMinted += quantity`.
1517             //
1518             // We can directly add to the `balance` and `numberMinted`.
1519             _packedAddressData[to] +=
1520                 quantity *
1521                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1522 
1523             // Updates:
1524             // - `address` to the owner.
1525             // - `startTimestamp` to the timestamp of minting.
1526             // - `burned` to `false`.
1527             // - `nextInitialized` to `quantity == 1`.
1528             _packedOwnerships[startTokenId] = _packOwnershipData(
1529                 to,
1530                 _nextInitializedFlag(quantity) |
1531                     _nextExtraData(address(0), to, 0)
1532             );
1533 
1534             emit ConsecutiveTransfer(
1535                 startTokenId,
1536                 startTokenId + quantity - 1,
1537                 address(0),
1538                 to
1539             );
1540 
1541             _currentIndex = startTokenId + quantity;
1542         }
1543         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1544     }
1545 
1546     /**
1547      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1548      *
1549      * Requirements:
1550      *
1551      * - If `to` refers to a smart contract, it must implement
1552      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1553      * - `quantity` must be greater than 0.
1554      *
1555      * See {_mint}.
1556      *
1557      * Emits a {Transfer} event for each mint.
1558      */
1559     function _safeMint(
1560         address to,
1561         uint256 quantity,
1562         bytes memory _data
1563     ) internal virtual {
1564         _mint(to, quantity);
1565 
1566         unchecked {
1567             if (to.code.length != 0) {
1568                 uint256 end = _currentIndex;
1569                 uint256 index = end - quantity;
1570                 do {
1571                     if (
1572                         !_checkContractOnERC721Received(
1573                             address(0),
1574                             to,
1575                             index++,
1576                             _data
1577                         )
1578                     ) {
1579                         revert TransferToNonERC721ReceiverImplementer();
1580                     }
1581                 } while (index < end);
1582                 // Reentrancy protection.
1583                 if (_currentIndex != end) revert();
1584             }
1585         }
1586     }
1587 
1588     /**
1589      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1590      */
1591     function _safeMint(address to, uint256 quantity) internal virtual {
1592         _safeMint(to, quantity, "");
1593     }
1594 
1595     // =============================================================
1596     //                        BURN OPERATIONS
1597     // =============================================================
1598 
1599     /**
1600      * @dev Equivalent to `_burn(tokenId, false)`.
1601      */
1602     function _burn(uint256 tokenId) internal virtual {
1603         _burn(tokenId, false);
1604     }
1605 
1606     /**
1607      * @dev Destroys `tokenId`.
1608      * The approval is cleared when the token is burned.
1609      *
1610      * Requirements:
1611      *
1612      * - `tokenId` must exist.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1617         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1618 
1619         address from = address(uint160(prevOwnershipPacked));
1620 
1621         (
1622             uint256 approvedAddressSlot,
1623             address approvedAddress
1624         ) = _getApprovedSlotAndAddress(tokenId);
1625 
1626         if (approvalCheck) {
1627             // The nested ifs save around 20+ gas over a compound boolean condition.
1628             if (
1629                 !_isSenderApprovedOrOwner(
1630                     approvedAddress,
1631                     from,
1632                     _msgSenderERC721A()
1633                 )
1634             )
1635                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1636                     revert TransferCallerNotOwnerNorApproved();
1637         }
1638 
1639         _beforeTokenTransfers(from, address(0), tokenId, 1);
1640 
1641         // Clear approvals from the previous owner.
1642         assembly {
1643             if approvedAddress {
1644                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1645                 sstore(approvedAddressSlot, 0)
1646             }
1647         }
1648 
1649         // Underflow of the sender's balance is impossible because we check for
1650         // ownership above and the recipient's balance can't realistically overflow.
1651         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1652         unchecked {
1653             // Updates:
1654             // - `balance -= 1`.
1655             // - `numberBurned += 1`.
1656             //
1657             // We can directly decrement the balance, and increment the number burned.
1658             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1659             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1660 
1661             // Updates:
1662             // - `address` to the last owner.
1663             // - `startTimestamp` to the timestamp of burning.
1664             // - `burned` to `true`.
1665             // - `nextInitialized` to `true`.
1666             _packedOwnerships[tokenId] = _packOwnershipData(
1667                 from,
1668                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
1669                     _nextExtraData(from, address(0), prevOwnershipPacked)
1670             );
1671 
1672             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1673             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1674                 uint256 nextTokenId = tokenId + 1;
1675                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1676                 if (_packedOwnerships[nextTokenId] == 0) {
1677                     // If the next slot is within bounds.
1678                     if (nextTokenId != _currentIndex) {
1679                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1680                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1681                     }
1682                 }
1683             }
1684         }
1685 
1686         emit Transfer(from, address(0), tokenId);
1687         _afterTokenTransfers(from, address(0), tokenId, 1);
1688 
1689         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1690         unchecked {
1691             _burnCounter++;
1692         }
1693     }
1694 
1695     // =============================================================
1696     //                     EXTRA DATA OPERATIONS
1697     // =============================================================
1698 
1699     /**
1700      * @dev Directly sets the extra data for the ownership data `index`.
1701      */
1702     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1703         uint256 packed = _packedOwnerships[index];
1704         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1705         uint256 extraDataCasted;
1706         // Cast `extraData` with assembly to avoid redundant masking.
1707         assembly {
1708             extraDataCasted := extraData
1709         }
1710         packed =
1711             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
1712             (extraDataCasted << _BITPOS_EXTRA_DATA);
1713         _packedOwnerships[index] = packed;
1714     }
1715 
1716     /**
1717      * @dev Called during each token transfer to set the 24bit `extraData` field.
1718      * Intended to be overridden by the cosumer contract.
1719      *
1720      * `previousExtraData` - the value of `extraData` before transfer.
1721      *
1722      * Calling conditions:
1723      *
1724      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1725      * transferred to `to`.
1726      * - When `from` is zero, `tokenId` will be minted for `to`.
1727      * - When `to` is zero, `tokenId` will be burned by `from`.
1728      * - `from` and `to` are never both zero.
1729      */
1730     function _extraData(
1731         address from,
1732         address to,
1733         uint24 previousExtraData
1734     ) internal view virtual returns (uint24) {}
1735 
1736     /**
1737      * @dev Returns the next extra data for the packed ownership data.
1738      * The returned result is shifted into position.
1739      */
1740     function _nextExtraData(
1741         address from,
1742         address to,
1743         uint256 prevOwnershipPacked
1744     ) private view returns (uint256) {
1745         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1746         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1747     }
1748 
1749     // =============================================================
1750     //                       OTHER OPERATIONS
1751     // =============================================================
1752 
1753     /**
1754      * @dev Returns the message sender (defaults to `msg.sender`).
1755      *
1756      * If you are writing GSN compatible contracts, you need to override this function.
1757      */
1758     function _msgSenderERC721A() internal view virtual returns (address) {
1759         return msg.sender;
1760     }
1761 
1762     /**
1763      * @dev Converts a uint256 to its ASCII string decimal representation.
1764      */
1765     function _toString(uint256 value)
1766         internal
1767         pure
1768         virtual
1769         returns (string memory str)
1770     {
1771         assembly {
1772             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1773             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1774             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1775             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1776             let m := add(mload(0x40), 0xa0)
1777             // Update the free memory pointer to allocate.
1778             mstore(0x40, m)
1779             // Assign the `str` to the end.
1780             str := sub(m, 0x20)
1781             // Zeroize the slot after the string.
1782             mstore(str, 0)
1783 
1784             // Cache the end of the memory to calculate the length later.
1785             let end := str
1786 
1787             // We write the string from rightmost digit to leftmost digit.
1788             // The following is essentially a do-while loop that also handles the zero case.
1789             // prettier-ignore
1790             for { let temp := value } 1 {} {
1791                 str := sub(str, 1)
1792                 // Write the character to the pointer.
1793                 // The ASCII index of the '0' character is 48.
1794                 mstore8(str, add(48, mod(temp, 10)))
1795                 // Keep dividing `temp` until zero.
1796                 temp := div(temp, 10)
1797                 // prettier-ignore
1798                 if iszero(temp) { break }
1799             }
1800 
1801             let length := sub(end, str)
1802             // Move the pointer 32 bytes leftwards to make room for the length.
1803             str := sub(str, 0x20)
1804             // Store the length.
1805             mstore(str, length)
1806         }
1807     }
1808 }
1809 
1810 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1811 
1812 // : MIT
1813 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1814 
1815 pragma solidity ^0.8.0;
1816 
1817 /**
1818  * @dev These functions deal with verification of Merkle Trees proofs.
1819  *
1820  * The proofs can be generated using the JavaScript library
1821  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1822  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1823  *
1824  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1825  *
1826  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1827  * hashing, or use a hash function other than keccak256 for hashing leaves.
1828  * This is because the concatenation of a sorted pair of internal nodes in
1829  * the merkle tree could be reinterpreted as a leaf value.
1830  */
1831 library MerkleProof {
1832     /**
1833      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1834      * defined by `root`. For this, a `proof` must be provided, containing
1835      * sibling hashes on the branch from the leaf to the root of the tree. Each
1836      * pair of leaves and each pair of pre-images are assumed to be sorted.
1837      */
1838     function verify(
1839         bytes32[] memory proof,
1840         bytes32 root,
1841         bytes32 leaf
1842     ) internal pure returns (bool) {
1843         return processProof(proof, leaf) == root;
1844     }
1845 
1846     /**
1847      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1848      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1849      * hash matches the root of the tree. When processing the proof, the pairs
1850      * of leafs & pre-images are assumed to be sorted.
1851      *
1852      * _Available since v4.4._
1853      */
1854     function processProof(bytes32[] memory proof, bytes32 leaf)
1855         internal
1856         pure
1857         returns (bytes32)
1858     {
1859         bytes32 computedHash = leaf;
1860         for (uint256 i = 0; i < proof.length; i++) {
1861             bytes32 proofElement = proof[i];
1862             if (computedHash <= proofElement) {
1863                 // Hash(current computed hash + current element of the proof)
1864                 computedHash = _efficientHash(computedHash, proofElement);
1865             } else {
1866                 // Hash(current element of the proof + current computed hash)
1867                 computedHash = _efficientHash(proofElement, computedHash);
1868             }
1869         }
1870         return computedHash;
1871     }
1872 
1873     function _efficientHash(bytes32 a, bytes32 b)
1874         private
1875         pure
1876         returns (bytes32 value)
1877     {
1878         assembly {
1879             mstore(0x00, a)
1880             mstore(0x20, b)
1881             value := keccak256(0x00, 0x40)
1882         }
1883     }
1884 }
1885 
1886 // File contracts/HexgoCard.sol
1887 
1888 /*
1889     __  __   ______   _  __    ______   ____
1890    / / / /  / ____/  | |/ /   / ____/  / __ \
1891   / /_/ /  / __/     |   /   / / __   / / / /
1892  / __  /  / /___    /   |   / /_/ /  / /_/ /
1893 /_/ /_/  /_____/   /_/|_|   \____/   \____/
1894 
1895 */
1896 
1897 // : BSD-1-Clause
1898 pragma solidity ^0.8.4;
1899 
1900 /**
1901  * @title HEXGO
1902  */
1903 contract HEXGO is ERC721A, Ownable, Pausable, ReentrancyGuard {
1904     /** ===================== PUBLIC INFO / VARIABLES ===================== */
1905 
1906     string baseTokenURI;
1907     // string public placeholderTokenURI;
1908     bool public checkPublicSaleMint;
1909     bool public checkWhitelistMint;
1910     uint256 public maxSupply;
1911     uint256 public maxWhitelistSupply;
1912     uint256 public mintLimit;
1913     uint256 public mintPrice;
1914     mapping(address => uint256) whitelistMintCount;
1915     mapping(address => uint256) mintCount;
1916     bytes32 public whitelistMerkleRoot;
1917 
1918     function isWhitelisted(address addr, bytes32[] calldata merkleProof_)
1919         public
1920         view
1921         returns (bool)
1922     {
1923         bytes32 leaf = keccak256(abi.encodePacked(addr));
1924         return MerkleProof.verify(merkleProof_, whitelistMerkleRoot, leaf);
1925     }
1926 
1927     /// @notice Checks if the given address can currently mint
1928     /// @dev Returns true if not paused, supply not reached and public sale or whitelisted whitelist
1929     /// @param addr to check for minting permission
1930     /// @param merkleProof_ should be only provided in order to check the whitelist
1931     function canMint(address addr, bytes32[] calldata merkleProof_)
1932         external
1933         view
1934         returns (bool)
1935     {
1936         bool isWhitelist = (checkWhitelistMint &&
1937             isWhitelisted(addr, merkleProof_));
1938         bool supplyNotReached = isWhitelist
1939             ? maxWhitelistSupply == 0 || totalSupply() <= maxWhitelistSupply
1940             : maxSupply + maxWhitelistSupply == 0 ||
1941                 totalSupply() <= maxSupply + maxWhitelistSupply;
1942         return
1943             !paused() &&
1944             supplyNotReached &&
1945             (checkPublicSaleMint || isWhitelist);
1946     }
1947 
1948     /** ===================== CONTRACT INITIALIZATION ===================== */
1949 
1950     constructor(
1951         string memory name,
1952         string memory symbol,
1953         string memory baseTokenURI_,
1954         uint256 maxSupply_,
1955         uint256 maxWhitelistSupply_,
1956         uint256 mintLimit_,
1957         uint256 mintPrice_,
1958         bytes32 merkleRoot_
1959     ) ERC721A(name, symbol) {
1960         baseTokenURI = baseTokenURI_;
1961         maxSupply = maxSupply_;
1962         maxWhitelistSupply = maxWhitelistSupply_;
1963         mintLimit = mintLimit_;
1964         mintPrice = mintPrice_;
1965         whitelistMerkleRoot = merkleRoot_;
1966     }
1967 
1968     /** ===================== OPERATIONAL FUNCTIONS ===================== */
1969 
1970     /// @notice Mints new NFTs
1971     /// @param many how many NFTs to mint
1972     /// @param merkleProof_ needs to be provided during the whitelist
1973     function mint(uint256 many, bytes32[] calldata merkleProof_)
1974         public
1975         payable
1976         whenNotPaused
1977         nonReentrant
1978     {
1979         // Check if we reached max supply
1980         uint256 supply = totalSupply();
1981         address sender = _msgSender();
1982 
1983         bool isWhitelist = (checkWhitelistMint &&
1984             isWhitelisted(sender, merkleProof_));
1985 
1986         bool supplyNotReached = isWhitelist
1987             ? maxWhitelistSupply == 0 || supply + many <= maxWhitelistSupply
1988             : maxSupply + maxWhitelistSupply == 0 ||
1989                 supply + many <= maxSupply + maxWhitelistSupply;
1990 
1991         require(supplyNotReached, "Max supply reached");
1992         uint256 totalPrice = 0;
1993 
1994         /**
1995         NOTE: when public sale is activated, all minting goes through the public route
1996          */
1997 
1998         require(checkPublicSaleMint || checkWhitelistMint, "Minting closed");
1999         if (checkWhitelistMint && !checkPublicSaleMint) {
2000             // Check if address in the whitelist/whitelisted
2001             require(isWhitelist, "Invalid proof");
2002         }
2003 
2004         totalPrice = many * mintPrice;
2005         require(msg.value >= totalPrice, "Not enough funds transferred");
2006 
2007         // Check if mint per address is reached
2008         // If public sale is active, we use the public counter
2009         // Only when the whitelist sale is active and public is off, the
2010         // whitelist counter is used.
2011         uint256 count = isWhitelist && !checkPublicSaleMint
2012             ? whitelistMintCount[sender]
2013             : mintCount[sender];
2014         require(count + many <= mintLimit, "Personal limit reached");
2015 
2016         // Increment counter,
2017         // Similar gas usage here as before, the whitelist counter is the same,
2018         // it just gets "reset" when public mint starts
2019         (isWhitelist && !checkPublicSaleMint ? whitelistMintCount : mintCount)[
2020             sender
2021         ] = count + many;
2022 
2023         // Mint all
2024         _mint(sender, many);
2025 
2026         // Return funds if transferred too much
2027         uint256 rest = msg.value - totalPrice;
2028         if (rest > 0) {
2029             (bool success, ) = sender.call{value: rest}("");
2030             require(success);
2031         }
2032     }
2033 
2034     /** ===================== ADMINISTRATIVE FUNCTIONS ===================== */
2035 
2036     /// @notice Withdraws all ether from the contract
2037     /// @param to where withdraw the amount. Can be another contract address.
2038     function withdrawAll(address to) external onlyOwner {
2039         withdraw(to, address(this).balance);
2040     }
2041 
2042     /// @notice Withdraw the amount of ether from the contract
2043     /// @param to where withdraw the amount. Can be another contract address.
2044     /// @param amount to withdraw.
2045     function withdraw(address to, uint256 amount) public onlyOwner {
2046         uint256 balance = address(this).balance;
2047         require(amount <= balance);
2048         (bool success, ) = to.call{value: amount}("");
2049         require(success);
2050     }
2051 
2052     /// @notice Toggles public sale flag
2053     function toggleWhitelistState() external onlyOwner {
2054         checkWhitelistMint = !checkWhitelistMint;
2055     }
2056 
2057     /// @notice Toggles public sale flag
2058     function togglePublicSaleState() external onlyOwner {
2059         checkPublicSaleMint = !checkPublicSaleMint;
2060     }
2061 
2062     /// @notice Sets max supply
2063     /// @param maxSupply_ that can be minted.
2064     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
2065         maxSupply = maxSupply_;
2066     }
2067 
2068     /// @notice Sets max supply for whitelist
2069     /// @param maxWhitelistSupply_ that can be minted.
2070     function setWhitelistMaxSupply(uint256 maxWhitelistSupply_)
2071         external
2072         onlyOwner
2073     {
2074         maxWhitelistSupply = maxWhitelistSupply_;
2075     }
2076 
2077     /// @notice Sets public mint cost
2078     /// @param mintPrice_ for each minted item
2079     function setMintPrice(uint256 mintPrice_) external onlyOwner {
2080         mintPrice = mintPrice_;
2081     }
2082 
2083     /// @notice Sets public mint limit for each address
2084     /// @param mintLimit_ of mints for each address
2085     function setMintLimit(uint256 mintLimit_) external onlyOwner {
2086         mintLimit = mintLimit_;
2087     }
2088 
2089     /// @notice Sets the merkleRoot
2090     /// @param merkleRoot_ that should be set
2091     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
2092         whitelistMerkleRoot = merkleRoot_;
2093     }
2094 
2095     /// @notice Sets base URI
2096     /// @param uri of the new base
2097     function setBaseURI(string memory uri) external onlyOwner {
2098         baseTokenURI = uri;
2099     }
2100 
2101     /// @notice Pauses the contract
2102     function pause() external onlyOwner {
2103         _pause();
2104     }
2105 
2106     /// @notice Unpauses the contract
2107     function unpause() external onlyOwner {
2108         _unpause();
2109     }
2110 
2111     /** ===================== PRIVATE HELPER FUNCTIONS ===================== */
2112 
2113     function _baseURI() internal view override returns (string memory) {
2114         return baseTokenURI;
2115     }
2116 }