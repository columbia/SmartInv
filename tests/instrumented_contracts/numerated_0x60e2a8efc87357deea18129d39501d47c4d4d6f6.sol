1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 // File: contracts/OperatorFilterer.sol
32 
33 
34 pragma solidity ^0.8.13;
35 
36 
37 abstract contract OperatorFilterer {
38     error OperatorNotAllowed(address operator);
39 
40     IOperatorFilterRegistry constant operatorFilterRegistry =
41         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
42 
43     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
44         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
45         // will not revert, but the contract will need to be registered with the registry once it is deployed in
46         // order for the modifier to filter addresses.
47         if (address(operatorFilterRegistry).code.length > 0) {
48             if (subscribe) {
49                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
50             } else {
51                 if (subscriptionOrRegistrantToCopy != address(0)) {
52                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
53                 } else {
54                     operatorFilterRegistry.register(address(this));
55                 }
56             }
57         }
58     }
59 
60     modifier onlyAllowedOperator(address from) virtual {
61         // Check registry code length to facilitate testing in environments without a deployed registry.
62         if (address(operatorFilterRegistry).code.length > 0) {
63             // Allow spending tokens from addresses with balance
64             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
65             // from an EOA.
66             if (from == msg.sender) {
67                 _;
68                 return;
69             }
70             if (
71                 !(
72                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
73                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
74                 )
75             ) {
76                 revert OperatorNotAllowed(msg.sender);
77             }
78         }
79         _;
80     }
81 }
82 // File: contracts/DefaultOperatorFilterer.sol
83 
84 
85 pragma solidity ^0.8.13;
86 
87 
88 abstract contract DefaultOperatorFilterer is OperatorFilterer {
89     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
90 
91     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
92 }
93 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
94 
95 
96 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Contract module that helps prevent reentrant calls to a function.
102  *
103  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
104  * available, which can be applied to functions to make sure there are no nested
105  * (reentrant) calls to them.
106  *
107  * Note that because there is a single `nonReentrant` guard, functions marked as
108  * `nonReentrant` may not call one another. This can be worked around by making
109  * those functions `private`, and then adding `external` `nonReentrant` entry
110  * points to them.
111  *
112  * TIP: If you would like to learn more about reentrancy and alternative ways
113  * to protect against it, check out our blog post
114  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
115  */
116 abstract contract ReentrancyGuard {
117     // Booleans are more expensive than uint256 or any type that takes up a full
118     // word because each write operation emits an extra SLOAD to first read the
119     // slot's contents, replace the bits taken up by the boolean, and then write
120     // back. This is the compiler's defense against contract upgrades and
121     // pointer aliasing, and it cannot be disabled.
122 
123     // The values being non-zero value makes deployment a bit more expensive,
124     // but in exchange the refund on every call to nonReentrant will be lower in
125     // amount. Since refunds are capped to a percentage of the total
126     // transaction's gas, it is best to keep them low in cases like this one, to
127     // increase the likelihood of the full refund coming into effect.
128     uint256 private constant _NOT_ENTERED = 1;
129     uint256 private constant _ENTERED = 2;
130 
131     uint256 private _status;
132 
133     constructor() {
134         _status = _NOT_ENTERED;
135     }
136 
137     /**
138      * @dev Prevents a contract from calling itself, directly or indirectly.
139      * Calling a `nonReentrant` function from another `nonReentrant`
140      * function is not supported. It is possible to prevent this from happening
141      * by making the `nonReentrant` function external, and making it call a
142      * `private` function that does the actual work.
143      */
144     modifier nonReentrant() {
145         _nonReentrantBefore();
146         _;
147         _nonReentrantAfter();
148     }
149 
150     function _nonReentrantBefore() private {
151         // On the first call to nonReentrant, _status will be _NOT_ENTERED
152         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
153 
154         // Any calls to nonReentrant after this point will fail
155         _status = _ENTERED;
156     }
157 
158     function _nonReentrantAfter() private {
159         // By storing the original value once again, a refund is triggered (see
160         // https://eips.ethereum.org/EIPS/eip-2200)
161         _status = _NOT_ENTERED;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/access/Ownable.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * @dev Throws if called by any account other than the owner.
226      */
227     modifier onlyOwner() {
228         _checkOwner();
229         _;
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if the sender is not the owner.
241      */
242     function _checkOwner() internal view virtual {
243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _transferOwnership(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _transferOwnership(newOwner);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Internal function without access restriction.
269      */
270     function _transferOwnership(address newOwner) internal virtual {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: erc721a/contracts/IERC721A.sol
278 
279 
280 // ERC721A Contracts v4.2.3
281 // Creator: Chiru Labs
282 
283 pragma solidity ^0.8.4;
284 
285 /**
286  * @dev Interface of ERC721A.
287  */
288 interface IERC721A {
289     /**
290      * The caller must own the token or be an approved operator.
291      */
292     error ApprovalCallerNotOwnerNorApproved();
293 
294     /**
295      * The token does not exist.
296      */
297     error ApprovalQueryForNonexistentToken();
298 
299     /**
300      * Cannot query the balance for the zero address.
301      */
302     error BalanceQueryForZeroAddress();
303 
304     /**
305      * Cannot mint to the zero address.
306      */
307     error MintToZeroAddress();
308 
309     /**
310      * The quantity of tokens minted must be more than zero.
311      */
312     error MintZeroQuantity();
313 
314     /**
315      * The token does not exist.
316      */
317     error OwnerQueryForNonexistentToken();
318 
319     /**
320      * The caller must own the token or be an approved operator.
321      */
322     error TransferCallerNotOwnerNorApproved();
323 
324     /**
325      * The token must be owned by `from`.
326      */
327     error TransferFromIncorrectOwner();
328 
329     /**
330      * Cannot safely transfer to a contract that does not implement the
331      * ERC721Receiver interface.
332      */
333     error TransferToNonERC721ReceiverImplementer();
334 
335     /**
336      * Cannot transfer to the zero address.
337      */
338     error TransferToZeroAddress();
339 
340     /**
341      * The token does not exist.
342      */
343     error URIQueryForNonexistentToken();
344 
345     /**
346      * The `quantity` minted with ERC2309 exceeds the safety limit.
347      */
348     error MintERC2309QuantityExceedsLimit();
349 
350     /**
351      * The `extraData` cannot be set on an unintialized ownership slot.
352      */
353     error OwnershipNotInitializedForExtraData();
354 
355     // =============================================================
356     //                            STRUCTS
357     // =============================================================
358 
359     struct TokenOwnership {
360         // The address of the owner.
361         address addr;
362         // Stores the start time of ownership with minimal overhead for tokenomics.
363         uint64 startTimestamp;
364         // Whether the token has been burned.
365         bool burned;
366         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
367         uint24 extraData;
368     }
369 
370     // =============================================================
371     //                         TOKEN COUNTERS
372     // =============================================================
373 
374     /**
375      * @dev Returns the total number of tokens in existence.
376      * Burned tokens will reduce the count.
377      * To get the total number of tokens minted, please see {_totalMinted}.
378      */
379     function totalSupply() external view returns (uint256);
380 
381     // =============================================================
382     //                            IERC165
383     // =============================================================
384 
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 
395     // =============================================================
396     //                            IERC721
397     // =============================================================
398 
399     /**
400      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
406      */
407     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables or disables
411      * (`approved`) `operator` to manage all of its assets.
412      */
413     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
414 
415     /**
416      * @dev Returns the number of tokens in `owner`'s account.
417      */
418     function balanceOf(address owner) external view returns (uint256 balance);
419 
420     /**
421      * @dev Returns the owner of the `tokenId` token.
422      *
423      * Requirements:
424      *
425      * - `tokenId` must exist.
426      */
427     function ownerOf(uint256 tokenId) external view returns (address owner);
428 
429     /**
430      * @dev Safely transfers `tokenId` token from `from` to `to`,
431      * checking first that contract recipients are aware of the ERC721 protocol
432      * to prevent tokens from being forever locked.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be have been allowed to move
440      * this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement
442      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443      *
444      * Emits a {Transfer} event.
445      */
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId,
450         bytes calldata data
451     ) external payable;
452 
453     /**
454      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external payable;
461 
462     /**
463      * @dev Transfers `tokenId` from `from` to `to`.
464      *
465      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
466      * whenever possible.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token
474      * by either {approve} or {setApprovalForAll}.
475      *
476      * Emits a {Transfer} event.
477      */
478     function transferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external payable;
483 
484     /**
485      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
486      * The approval is cleared when the token is transferred.
487      *
488      * Only a single account can be approved at a time, so approving the
489      * zero address clears previous approvals.
490      *
491      * Requirements:
492      *
493      * - The caller must own the token or be an approved operator.
494      * - `tokenId` must exist.
495      *
496      * Emits an {Approval} event.
497      */
498     function approve(address to, uint256 tokenId) external payable;
499 
500     /**
501      * @dev Approve or remove `operator` as an operator for the caller.
502      * Operators can call {transferFrom} or {safeTransferFrom}
503      * for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}.
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 
529     // =============================================================
530     //                        IERC721Metadata
531     // =============================================================
532 
533     /**
534      * @dev Returns the token collection name.
535      */
536     function name() external view returns (string memory);
537 
538     /**
539      * @dev Returns the token collection symbol.
540      */
541     function symbol() external view returns (string memory);
542 
543     /**
544      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
545      */
546     function tokenURI(uint256 tokenId) external view returns (string memory);
547 
548     // =============================================================
549     //                           IERC2309
550     // =============================================================
551 
552     /**
553      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
554      * (inclusive) is transferred from `from` to `to`, as defined in the
555      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
556      *
557      * See {_mintERC2309} for more details.
558      */
559     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
560 }
561 
562 // File: erc721a/contracts/ERC721A.sol
563 
564 
565 // ERC721A Contracts v4.2.3
566 // Creator: Chiru Labs
567 
568 pragma solidity ^0.8.4;
569 
570 
571 /**
572  * @dev Interface of ERC721 token receiver.
573  */
574 interface ERC721A__IERC721Receiver {
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 /**
584  * @title ERC721A
585  *
586  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
587  * Non-Fungible Token Standard, including the Metadata extension.
588  * Optimized for lower gas during batch mints.
589  *
590  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
591  * starting from `_startTokenId()`.
592  *
593  * Assumptions:
594  *
595  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
596  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
597  */
598 contract ERC721A is IERC721A {
599     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
600     struct TokenApprovalRef {
601         address value;
602     }
603 
604     // =============================================================
605     //                           CONSTANTS
606     // =============================================================
607 
608     // Mask of an entry in packed address data.
609     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
610 
611     // The bit position of `numberMinted` in packed address data.
612     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
613 
614     // The bit position of `numberBurned` in packed address data.
615     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
616 
617     // The bit position of `aux` in packed address data.
618     uint256 private constant _BITPOS_AUX = 192;
619 
620     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
621     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
622 
623     // The bit position of `startTimestamp` in packed ownership.
624     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
625 
626     // The bit mask of the `burned` bit in packed ownership.
627     uint256 private constant _BITMASK_BURNED = 1 << 224;
628 
629     // The bit position of the `nextInitialized` bit in packed ownership.
630     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
631 
632     // The bit mask of the `nextInitialized` bit in packed ownership.
633     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
634 
635     // The bit position of `extraData` in packed ownership.
636     uint256 private constant _BITPOS_EXTRA_DATA = 232;
637 
638     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
639     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
640 
641     // The mask of the lower 160 bits for addresses.
642     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
643 
644     // The maximum `quantity` that can be minted with {_mintERC2309}.
645     // This limit is to prevent overflows on the address data entries.
646     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
647     // is required to cause an overflow, which is unrealistic.
648     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
649 
650     // The `Transfer` event signature is given by:
651     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
652     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
653         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
654 
655     // =============================================================
656     //                            STORAGE
657     // =============================================================
658 
659     // The next token ID to be minted.
660     uint256 private _currentIndex;
661 
662     // The number of tokens burned.
663     uint256 private _burnCounter;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned.
673     // See {_packedOwnershipOf} implementation for details.
674     //
675     // Bits Layout:
676     // - [0..159]   `addr`
677     // - [160..223] `startTimestamp`
678     // - [224]      `burned`
679     // - [225]      `nextInitialized`
680     // - [232..255] `extraData`
681     mapping(uint256 => uint256) private _packedOwnerships;
682 
683     // Mapping owner address to address data.
684     //
685     // Bits Layout:
686     // - [0..63]    `balance`
687     // - [64..127]  `numberMinted`
688     // - [128..191] `numberBurned`
689     // - [192..255] `aux`
690     mapping(address => uint256) private _packedAddressData;
691 
692     // Mapping from token ID to approved address.
693     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     // =============================================================
699     //                          CONSTRUCTOR
700     // =============================================================
701 
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705         _currentIndex = _startTokenId();
706     }
707 
708     // =============================================================
709     //                   TOKEN COUNTING OPERATIONS
710     // =============================================================
711 
712     /**
713      * @dev Returns the starting token ID.
714      * To change the starting token ID, please override this function.
715      */
716     function _startTokenId() internal view virtual returns (uint256) {
717         return 0;
718     }
719 
720     /**
721      * @dev Returns the next token ID to be minted.
722      */
723     function _nextTokenId() internal view virtual returns (uint256) {
724         return _currentIndex;
725     }
726 
727     /**
728      * @dev Returns the total number of tokens in existence.
729      * Burned tokens will reduce the count.
730      * To get the total number of tokens minted, please see {_totalMinted}.
731      */
732     function totalSupply() public view virtual override returns (uint256) {
733         // Counter underflow is impossible as _burnCounter cannot be incremented
734         // more than `_currentIndex - _startTokenId()` times.
735         unchecked {
736             return _currentIndex - _burnCounter - _startTokenId();
737         }
738     }
739 
740     /**
741      * @dev Returns the total amount of tokens minted in the contract.
742      */
743     function _totalMinted() internal view virtual returns (uint256) {
744         // Counter underflow is impossible as `_currentIndex` does not decrement,
745         // and it is initialized to `_startTokenId()`.
746         unchecked {
747             return _currentIndex - _startTokenId();
748         }
749     }
750 
751     /**
752      * @dev Returns the total number of tokens burned.
753      */
754     function _totalBurned() internal view virtual returns (uint256) {
755         return _burnCounter;
756     }
757 
758     // =============================================================
759     //                    ADDRESS DATA OPERATIONS
760     // =============================================================
761 
762     /**
763      * @dev Returns the number of tokens in `owner`'s account.
764      */
765     function balanceOf(address owner) public view virtual override returns (uint256) {
766         if (owner == address(0)) revert BalanceQueryForZeroAddress();
767         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
768     }
769 
770     /**
771      * Returns the number of tokens minted by `owner`.
772      */
773     function _numberMinted(address owner) internal view returns (uint256) {
774         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
775     }
776 
777     /**
778      * Returns the number of tokens burned by or on behalf of `owner`.
779      */
780     function _numberBurned(address owner) internal view returns (uint256) {
781         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
782     }
783 
784     /**
785      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
786      */
787     function _getAux(address owner) internal view returns (uint64) {
788         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
789     }
790 
791     /**
792      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
793      * If there are multiple variables, please pack them into a uint64.
794      */
795     function _setAux(address owner, uint64 aux) internal virtual {
796         uint256 packed = _packedAddressData[owner];
797         uint256 auxCasted;
798         // Cast `aux` with assembly to avoid redundant masking.
799         assembly {
800             auxCasted := aux
801         }
802         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
803         _packedAddressData[owner] = packed;
804     }
805 
806     // =============================================================
807     //                            IERC165
808     // =============================================================
809 
810     /**
811      * @dev Returns true if this contract implements the interface defined by
812      * `interfaceId`. See the corresponding
813      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
814      * to learn more about how these ids are created.
815      *
816      * This function call must use less than 30000 gas.
817      */
818     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
819         // The interface IDs are constants representing the first 4 bytes
820         // of the XOR of all function selectors in the interface.
821         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
822         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
823         return
824             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
825             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
826             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
827     }
828 
829     // =============================================================
830     //                        IERC721Metadata
831     // =============================================================
832 
833     /**
834      * @dev Returns the token collection name.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev Returns the token collection symbol.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, it can be overridden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return '';
864     }
865 
866     // =============================================================
867     //                     OWNERSHIPS OPERATIONS
868     // =============================================================
869 
870     /**
871      * @dev Returns the owner of the `tokenId` token.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      */
877     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
878         return address(uint160(_packedOwnershipOf(tokenId)));
879     }
880 
881     /**
882      * @dev Gas spent here starts off proportional to the maximum mint batch size.
883      * It gradually moves to O(1) as tokens get transferred around over time.
884      */
885     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
886         return _unpackedOwnership(_packedOwnershipOf(tokenId));
887     }
888 
889     /**
890      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
891      */
892     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
893         return _unpackedOwnership(_packedOwnerships[index]);
894     }
895 
896     /**
897      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
898      */
899     function _initializeOwnershipAt(uint256 index) internal virtual {
900         if (_packedOwnerships[index] == 0) {
901             _packedOwnerships[index] = _packedOwnershipOf(index);
902         }
903     }
904 
905     /**
906      * Returns the packed ownership data of `tokenId`.
907      */
908     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
909         uint256 curr = tokenId;
910 
911         unchecked {
912             if (_startTokenId() <= curr)
913                 if (curr < _currentIndex) {
914                     uint256 packed = _packedOwnerships[curr];
915                     // If not burned.
916                     if (packed & _BITMASK_BURNED == 0) {
917                         // Invariant:
918                         // There will always be an initialized ownership slot
919                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
920                         // before an unintialized ownership slot
921                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
922                         // Hence, `curr` will not underflow.
923                         //
924                         // We can directly compare the packed value.
925                         // If the address is zero, packed will be zero.
926                         while (packed == 0) {
927                             packed = _packedOwnerships[--curr];
928                         }
929                         return packed;
930                     }
931                 }
932         }
933         revert OwnerQueryForNonexistentToken();
934     }
935 
936     /**
937      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
938      */
939     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
940         ownership.addr = address(uint160(packed));
941         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
942         ownership.burned = packed & _BITMASK_BURNED != 0;
943         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
944     }
945 
946     /**
947      * @dev Packs ownership data into a single uint256.
948      */
949     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
950         assembly {
951             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
952             owner := and(owner, _BITMASK_ADDRESS)
953             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
954             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
955         }
956     }
957 
958     /**
959      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
960      */
961     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
962         // For branchless setting of the `nextInitialized` flag.
963         assembly {
964             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
965             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
966         }
967     }
968 
969     // =============================================================
970     //                      APPROVAL OPERATIONS
971     // =============================================================
972 
973     /**
974      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
975      * The approval is cleared when the token is transferred.
976      *
977      * Only a single account can be approved at a time, so approving the
978      * zero address clears previous approvals.
979      *
980      * Requirements:
981      *
982      * - The caller must own the token or be an approved operator.
983      * - `tokenId` must exist.
984      *
985      * Emits an {Approval} event.
986      */
987     function approve(address to, uint256 tokenId) public payable virtual override {
988         address owner = ownerOf(tokenId);
989 
990         if (_msgSenderERC721A() != owner)
991             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
992                 revert ApprovalCallerNotOwnerNorApproved();
993             }
994 
995         _tokenApprovals[tokenId].value = to;
996         emit Approval(owner, to, tokenId);
997     }
998 
999     /**
1000      * @dev Returns the account approved for `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId].value;
1010     }
1011 
1012     /**
1013      * @dev Approve or remove `operator` as an operator for the caller.
1014      * Operators can call {transferFrom} or {safeTransferFrom}
1015      * for any token owned by the caller.
1016      *
1017      * Requirements:
1018      *
1019      * - The `operator` cannot be the caller.
1020      *
1021      * Emits an {ApprovalForAll} event.
1022      */
1023     function setApprovalForAll(address operator, bool approved) public virtual override {
1024         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1025         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1026     }
1027 
1028     /**
1029      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1030      *
1031      * See {setApprovalForAll}.
1032      */
1033     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1034         return _operatorApprovals[owner][operator];
1035     }
1036 
1037     /**
1038      * @dev Returns whether `tokenId` exists.
1039      *
1040      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1041      *
1042      * Tokens start existing when they are minted. See {_mint}.
1043      */
1044     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1045         return
1046             _startTokenId() <= tokenId &&
1047             tokenId < _currentIndex && // If within bounds,
1048             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1049     }
1050 
1051     /**
1052      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1053      */
1054     function _isSenderApprovedOrOwner(
1055         address approvedAddress,
1056         address owner,
1057         address msgSender
1058     ) private pure returns (bool result) {
1059         assembly {
1060             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1061             owner := and(owner, _BITMASK_ADDRESS)
1062             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1063             msgSender := and(msgSender, _BITMASK_ADDRESS)
1064             // `msgSender == owner || msgSender == approvedAddress`.
1065             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1071      */
1072     function _getApprovedSlotAndAddress(uint256 tokenId)
1073         private
1074         view
1075         returns (uint256 approvedAddressSlot, address approvedAddress)
1076     {
1077         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1078         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1079         assembly {
1080             approvedAddressSlot := tokenApproval.slot
1081             approvedAddress := sload(approvedAddressSlot)
1082         }
1083     }
1084 
1085     // =============================================================
1086     //                      TRANSFER OPERATIONS
1087     // =============================================================
1088 
1089     /**
1090      * @dev Transfers `tokenId` from `from` to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must be owned by `from`.
1097      * - If the caller is not `from`, it must be approved to move this token
1098      * by either {approve} or {setApprovalForAll}.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public payable virtual override {
1107         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1108 
1109         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1110 
1111         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1112 
1113         // The nested ifs save around 20+ gas over a compound boolean condition.
1114         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1115             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1116 
1117         if (to == address(0)) revert TransferToZeroAddress();
1118 
1119         _beforeTokenTransfers(from, to, tokenId, 1);
1120 
1121         // Clear approvals from the previous owner.
1122         assembly {
1123             if approvedAddress {
1124                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1125                 sstore(approvedAddressSlot, 0)
1126             }
1127         }
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1132         unchecked {
1133             // We can directly increment and decrement the balances.
1134             --_packedAddressData[from]; // Updates: `balance -= 1`.
1135             ++_packedAddressData[to]; // Updates: `balance += 1`.
1136 
1137             // Updates:
1138             // - `address` to the next owner.
1139             // - `startTimestamp` to the timestamp of transfering.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `true`.
1142             _packedOwnerships[tokenId] = _packOwnershipData(
1143                 to,
1144                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1145             );
1146 
1147             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1148             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1149                 uint256 nextTokenId = tokenId + 1;
1150                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1151                 if (_packedOwnerships[nextTokenId] == 0) {
1152                     // If the next slot is within bounds.
1153                     if (nextTokenId != _currentIndex) {
1154                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1155                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1156                     }
1157                 }
1158             }
1159         }
1160 
1161         emit Transfer(from, to, tokenId);
1162         _afterTokenTransfers(from, to, tokenId, 1);
1163     }
1164 
1165     /**
1166      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) public payable virtual override {
1173         safeTransferFrom(from, to, tokenId, '');
1174     }
1175 
1176     /**
1177      * @dev Safely transfers `tokenId` token from `from` to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must exist and be owned by `from`.
1184      * - If the caller is not `from`, it must be approved to move this token
1185      * by either {approve} or {setApprovalForAll}.
1186      * - If `to` refers to a smart contract, it must implement
1187      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function safeTransferFrom(
1192         address from,
1193         address to,
1194         uint256 tokenId,
1195         bytes memory _data
1196     ) public payable virtual override {
1197         transferFrom(from, to, tokenId);
1198         if (to.code.length != 0)
1199             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1200                 revert TransferToNonERC721ReceiverImplementer();
1201             }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before a set of serially-ordered token IDs
1206      * are about to be transferred. This includes minting.
1207      * And also called before burning one token.
1208      *
1209      * `startTokenId` - the first token ID to be transferred.
1210      * `quantity` - the amount to be transferred.
1211      *
1212      * Calling conditions:
1213      *
1214      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1215      * transferred to `to`.
1216      * - When `from` is zero, `tokenId` will be minted for `to`.
1217      * - When `to` is zero, `tokenId` will be burned by `from`.
1218      * - `from` and `to` are never both zero.
1219      */
1220     function _beforeTokenTransfers(
1221         address from,
1222         address to,
1223         uint256 startTokenId,
1224         uint256 quantity
1225     ) internal virtual {}
1226 
1227     /**
1228      * @dev Hook that is called after a set of serially-ordered token IDs
1229      * have been transferred. This includes minting.
1230      * And also called after one token has been burned.
1231      *
1232      * `startTokenId` - the first token ID to be transferred.
1233      * `quantity` - the amount to be transferred.
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` has been minted for `to`.
1240      * - When `to` is zero, `tokenId` has been burned by `from`.
1241      * - `from` and `to` are never both zero.
1242      */
1243     function _afterTokenTransfers(
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 
1250     /**
1251      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1252      *
1253      * `from` - Previous owner of the given token ID.
1254      * `to` - Target address that will receive the token.
1255      * `tokenId` - Token ID to be transferred.
1256      * `_data` - Optional data to send along with the call.
1257      *
1258      * Returns whether the call correctly returned the expected magic value.
1259      */
1260     function _checkContractOnERC721Received(
1261         address from,
1262         address to,
1263         uint256 tokenId,
1264         bytes memory _data
1265     ) private returns (bool) {
1266         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1267             bytes4 retval
1268         ) {
1269             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1270         } catch (bytes memory reason) {
1271             if (reason.length == 0) {
1272                 revert TransferToNonERC721ReceiverImplementer();
1273             } else {
1274                 assembly {
1275                     revert(add(32, reason), mload(reason))
1276                 }
1277             }
1278         }
1279     }
1280 
1281     // =============================================================
1282     //                        MINT OPERATIONS
1283     // =============================================================
1284 
1285     /**
1286      * @dev Mints `quantity` tokens and transfers them to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `to` cannot be the zero address.
1291      * - `quantity` must be greater than 0.
1292      *
1293      * Emits a {Transfer} event for each mint.
1294      */
1295     function _mint(address to, uint256 quantity) internal virtual {
1296         uint256 startTokenId = _currentIndex;
1297         if (quantity == 0) revert MintZeroQuantity();
1298 
1299         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1300 
1301         // Overflows are incredibly unrealistic.
1302         // `balance` and `numberMinted` have a maximum limit of 2**64.
1303         // `tokenId` has a maximum limit of 2**256.
1304         unchecked {
1305             // Updates:
1306             // - `balance += quantity`.
1307             // - `numberMinted += quantity`.
1308             //
1309             // We can directly add to the `balance` and `numberMinted`.
1310             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1311 
1312             // Updates:
1313             // - `address` to the owner.
1314             // - `startTimestamp` to the timestamp of minting.
1315             // - `burned` to `false`.
1316             // - `nextInitialized` to `quantity == 1`.
1317             _packedOwnerships[startTokenId] = _packOwnershipData(
1318                 to,
1319                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1320             );
1321 
1322             uint256 toMasked;
1323             uint256 end = startTokenId + quantity;
1324 
1325             // Use assembly to loop and emit the `Transfer` event for gas savings.
1326             // The duplicated `log4` removes an extra check and reduces stack juggling.
1327             // The assembly, together with the surrounding Solidity code, have been
1328             // delicately arranged to nudge the compiler into producing optimized opcodes.
1329             assembly {
1330                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1331                 toMasked := and(to, _BITMASK_ADDRESS)
1332                 // Emit the `Transfer` event.
1333                 log4(
1334                     0, // Start of data (0, since no data).
1335                     0, // End of data (0, since no data).
1336                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1337                     0, // `address(0)`.
1338                     toMasked, // `to`.
1339                     startTokenId // `tokenId`.
1340                 )
1341 
1342                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1343                 // that overflows uint256 will make the loop run out of gas.
1344                 // The compiler will optimize the `iszero` away for performance.
1345                 for {
1346                     let tokenId := add(startTokenId, 1)
1347                 } iszero(eq(tokenId, end)) {
1348                     tokenId := add(tokenId, 1)
1349                 } {
1350                     // Emit the `Transfer` event. Similar to above.
1351                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1352                 }
1353             }
1354             if (toMasked == 0) revert MintToZeroAddress();
1355 
1356             _currentIndex = end;
1357         }
1358         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1359     }
1360 
1361     /**
1362      * @dev Mints `quantity` tokens and transfers them to `to`.
1363      *
1364      * This function is intended for efficient minting only during contract creation.
1365      *
1366      * It emits only one {ConsecutiveTransfer} as defined in
1367      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1368      * instead of a sequence of {Transfer} event(s).
1369      *
1370      * Calling this function outside of contract creation WILL make your contract
1371      * non-compliant with the ERC721 standard.
1372      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1373      * {ConsecutiveTransfer} event is only permissible during contract creation.
1374      *
1375      * Requirements:
1376      *
1377      * - `to` cannot be the zero address.
1378      * - `quantity` must be greater than 0.
1379      *
1380      * Emits a {ConsecutiveTransfer} event.
1381      */
1382     function _mintERC2309(address to, uint256 quantity) internal virtual {
1383         uint256 startTokenId = _currentIndex;
1384         if (to == address(0)) revert MintToZeroAddress();
1385         if (quantity == 0) revert MintZeroQuantity();
1386         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1387 
1388         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1389 
1390         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1391         unchecked {
1392             // Updates:
1393             // - `balance += quantity`.
1394             // - `numberMinted += quantity`.
1395             //
1396             // We can directly add to the `balance` and `numberMinted`.
1397             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1398 
1399             // Updates:
1400             // - `address` to the owner.
1401             // - `startTimestamp` to the timestamp of minting.
1402             // - `burned` to `false`.
1403             // - `nextInitialized` to `quantity == 1`.
1404             _packedOwnerships[startTokenId] = _packOwnershipData(
1405                 to,
1406                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1407             );
1408 
1409             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1410 
1411             _currentIndex = startTokenId + quantity;
1412         }
1413         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1414     }
1415 
1416     /**
1417      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1418      *
1419      * Requirements:
1420      *
1421      * - If `to` refers to a smart contract, it must implement
1422      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1423      * - `quantity` must be greater than 0.
1424      *
1425      * See {_mint}.
1426      *
1427      * Emits a {Transfer} event for each mint.
1428      */
1429     function _safeMint(
1430         address to,
1431         uint256 quantity,
1432         bytes memory _data
1433     ) internal virtual {
1434         _mint(to, quantity);
1435 
1436         unchecked {
1437             if (to.code.length != 0) {
1438                 uint256 end = _currentIndex;
1439                 uint256 index = end - quantity;
1440                 do {
1441                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1442                         revert TransferToNonERC721ReceiverImplementer();
1443                     }
1444                 } while (index < end);
1445                 // Reentrancy protection.
1446                 if (_currentIndex != end) revert();
1447             }
1448         }
1449     }
1450 
1451     /**
1452      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1453      */
1454     function _safeMint(address to, uint256 quantity) internal virtual {
1455         _safeMint(to, quantity, '');
1456     }
1457 
1458     // =============================================================
1459     //                        BURN OPERATIONS
1460     // =============================================================
1461 
1462     /**
1463      * @dev Equivalent to `_burn(tokenId, false)`.
1464      */
1465     function _burn(uint256 tokenId) internal virtual {
1466         _burn(tokenId, false);
1467     }
1468 
1469     /**
1470      * @dev Destroys `tokenId`.
1471      * The approval is cleared when the token is burned.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1480         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1481 
1482         address from = address(uint160(prevOwnershipPacked));
1483 
1484         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1485 
1486         if (approvalCheck) {
1487             // The nested ifs save around 20+ gas over a compound boolean condition.
1488             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1489                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1490         }
1491 
1492         _beforeTokenTransfers(from, address(0), tokenId, 1);
1493 
1494         // Clear approvals from the previous owner.
1495         assembly {
1496             if approvedAddress {
1497                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1498                 sstore(approvedAddressSlot, 0)
1499             }
1500         }
1501 
1502         // Underflow of the sender's balance is impossible because we check for
1503         // ownership above and the recipient's balance can't realistically overflow.
1504         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1505         unchecked {
1506             // Updates:
1507             // - `balance -= 1`.
1508             // - `numberBurned += 1`.
1509             //
1510             // We can directly decrement the balance, and increment the number burned.
1511             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1512             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1513 
1514             // Updates:
1515             // - `address` to the last owner.
1516             // - `startTimestamp` to the timestamp of burning.
1517             // - `burned` to `true`.
1518             // - `nextInitialized` to `true`.
1519             _packedOwnerships[tokenId] = _packOwnershipData(
1520                 from,
1521                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1522             );
1523 
1524             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1525             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1526                 uint256 nextTokenId = tokenId + 1;
1527                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1528                 if (_packedOwnerships[nextTokenId] == 0) {
1529                     // If the next slot is within bounds.
1530                     if (nextTokenId != _currentIndex) {
1531                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1532                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1533                     }
1534                 }
1535             }
1536         }
1537 
1538         emit Transfer(from, address(0), tokenId);
1539         _afterTokenTransfers(from, address(0), tokenId, 1);
1540 
1541         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1542         unchecked {
1543             _burnCounter++;
1544         }
1545     }
1546 
1547     // =============================================================
1548     //                     EXTRA DATA OPERATIONS
1549     // =============================================================
1550 
1551     /**
1552      * @dev Directly sets the extra data for the ownership data `index`.
1553      */
1554     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1555         uint256 packed = _packedOwnerships[index];
1556         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1557         uint256 extraDataCasted;
1558         // Cast `extraData` with assembly to avoid redundant masking.
1559         assembly {
1560             extraDataCasted := extraData
1561         }
1562         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1563         _packedOwnerships[index] = packed;
1564     }
1565 
1566     /**
1567      * @dev Called during each token transfer to set the 24bit `extraData` field.
1568      * Intended to be overridden by the cosumer contract.
1569      *
1570      * `previousExtraData` - the value of `extraData` before transfer.
1571      *
1572      * Calling conditions:
1573      *
1574      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1575      * transferred to `to`.
1576      * - When `from` is zero, `tokenId` will be minted for `to`.
1577      * - When `to` is zero, `tokenId` will be burned by `from`.
1578      * - `from` and `to` are never both zero.
1579      */
1580     function _extraData(
1581         address from,
1582         address to,
1583         uint24 previousExtraData
1584     ) internal view virtual returns (uint24) {}
1585 
1586     /**
1587      * @dev Returns the next extra data for the packed ownership data.
1588      * The returned result is shifted into position.
1589      */
1590     function _nextExtraData(
1591         address from,
1592         address to,
1593         uint256 prevOwnershipPacked
1594     ) private view returns (uint256) {
1595         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1596         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1597     }
1598 
1599     // =============================================================
1600     //                       OTHER OPERATIONS
1601     // =============================================================
1602 
1603     /**
1604      * @dev Returns the message sender (defaults to `msg.sender`).
1605      *
1606      * If you are writing GSN compatible contracts, you need to override this function.
1607      */
1608     function _msgSenderERC721A() internal view virtual returns (address) {
1609         return msg.sender;
1610     }
1611 
1612     /**
1613      * @dev Converts a uint256 to its ASCII string decimal representation.
1614      */
1615     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1616         assembly {
1617             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1618             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1619             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1620             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1621             let m := add(mload(0x40), 0xa0)
1622             // Update the free memory pointer to allocate.
1623             mstore(0x40, m)
1624             // Assign the `str` to the end.
1625             str := sub(m, 0x20)
1626             // Zeroize the slot after the string.
1627             mstore(str, 0)
1628 
1629             // Cache the end of the memory to calculate the length later.
1630             let end := str
1631 
1632             // We write the string from rightmost digit to leftmost digit.
1633             // The following is essentially a do-while loop that also handles the zero case.
1634             // prettier-ignore
1635             for { let temp := value } 1 {} {
1636                 str := sub(str, 1)
1637                 // Write the character to the pointer.
1638                 // The ASCII index of the '0' character is 48.
1639                 mstore8(str, add(48, mod(temp, 10)))
1640                 // Keep dividing `temp` until zero.
1641                 temp := div(temp, 10)
1642                 // prettier-ignore
1643                 if iszero(temp) { break }
1644             }
1645 
1646             let length := sub(end, str)
1647             // Move the pointer 32 bytes leftwards to make room for the length.
1648             str := sub(str, 0x20)
1649             // Store the length.
1650             mstore(str, length)
1651         }
1652     }
1653 }
1654 
1655 // File: contracts/StrangeCats.sol
1656 
1657 
1658 
1659 pragma solidity 0.8.13;
1660 
1661 
1662 contract StrangeCats is DefaultOperatorFilterer, ERC721A, Ownable, ReentrancyGuard {
1663   string public uriPrefix = '';
1664   string public hiddenUri = 'https://aquamarine-naval-barracuda-611.mypinata.cloud/ipfs/QmPpTjdfKoR7yKnjWs2yW13hsbpWhYAm3aMCvhe8QMAjNr/hidden';
1665 
1666   uint256 public cost = 0.003 ether;
1667   uint256 public maxSupply = 4444;
1668   uint256 public maxMintAmountPerTx = 5;
1669   uint256 public maxMintAmountPerWallet = 5;
1670   mapping(address => uint256) public alreadyMinted;
1671 
1672   bool public paused = true;
1673 
1674   constructor(
1675     string memory _tokenName,
1676     string memory _tokenSymbol
1677   ) ERC721A(_tokenName, _tokenSymbol) {}
1678 
1679   function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1680     super.transferFrom(from, to, tokenId);
1681   }
1682 
1683   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1684     super.safeTransferFrom(from, to, tokenId);
1685   }
1686 
1687   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1688     super.safeTransferFrom(from, to, tokenId, data);
1689   }
1690 
1691   modifier mintCompliance(uint256 _mintAmount) {
1692     require(msg.sender == tx.origin, 'The minter is another contract');
1693     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1694     require(alreadyMinted[msg.sender] + _mintAmount <= maxMintAmountPerWallet, 'Max supply exceeded!');
1695     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1696     require(msg.value >= cost * (_mintAmount - 1), 'Insufficient funds!');
1697     _;
1698   }
1699 
1700   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1701     require(!paused, 'The contract is paused!');
1702     alreadyMinted[msg.sender] += _mintAmount;
1703     _safeMint(msg.sender, _mintAmount);
1704   }
1705 
1706   function teamMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1707     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1708     _safeMint(_receiver, _mintAmount);
1709   }
1710 
1711   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1712     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1713 
1714     string memory currentBaseURI = _baseURI();
1715     return bytes(currentBaseURI).length > 0
1716         ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId)))
1717         : hiddenUri;
1718   }
1719 
1720   function setCost(uint256 _cost) public onlyOwner {
1721     cost = _cost;
1722   }
1723 
1724   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1725     uriPrefix = _uriPrefix;
1726   }
1727 
1728   function setPaused(bool _state) public onlyOwner {
1729     paused = _state;
1730   }
1731 
1732   function withdraw() public onlyOwner nonReentrant {
1733     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1734     require(os);
1735   }
1736 
1737   function _baseURI() internal view virtual override returns (string memory) {
1738     return uriPrefix;
1739   }
1740 }