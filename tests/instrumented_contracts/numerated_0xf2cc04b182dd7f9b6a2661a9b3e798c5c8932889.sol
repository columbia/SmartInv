1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
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
31 
32 // File: operator-filter-registry/src/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 abstract contract OperatorFilterer {
39     error OperatorNotAllowed(address operator);
40 
41     IOperatorFilterRegistry constant operatorFilterRegistry =
42         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
43 
44     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
45         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
46         // will not revert, but the contract will need to be registered with the registry once it is deployed in
47         // order for the modifier to filter addresses.
48         if (address(operatorFilterRegistry).code.length > 0) {
49             if (subscribe) {
50                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
51             } else {
52                 if (subscriptionOrRegistrantToCopy != address(0)) {
53                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
54                 } else {
55                     operatorFilterRegistry.register(address(this));
56                 }
57             }
58         }
59     }
60 
61     modifier onlyAllowedOperator(address from) virtual {
62         // Check registry code length to facilitate testing in environments without a deployed registry.
63         if (address(operatorFilterRegistry).code.length > 0) {
64             // Allow spending tokens from addresses with balance
65             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
66             // from an EOA.
67             if (from == msg.sender) {
68                 _;
69                 return;
70             }
71             if (
72                 !(
73                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
74                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
75                 )
76             ) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 }
83 
84 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
85 
86 
87 pragma solidity ^0.8.13;
88 
89 
90 abstract contract DefaultOperatorFilterer is OperatorFilterer {
91     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
92 
93     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
94 }
95 
96 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module that helps prevent reentrant calls to a function.
105  *
106  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
107  * available, which can be applied to functions to make sure there are no nested
108  * (reentrant) calls to them.
109  *
110  * Note that because there is a single `nonReentrant` guard, functions marked as
111  * `nonReentrant` may not call one another. This can be worked around by making
112  * those functions `private`, and then adding `external` `nonReentrant` entry
113  * points to them.
114  *
115  * TIP: If you would like to learn more about reentrancy and alternative ways
116  * to protect against it, check out our blog post
117  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
118  */
119 abstract contract ReentrancyGuard {
120     // Booleans are more expensive than uint256 or any type that takes up a full
121     // word because each write operation emits an extra SLOAD to first read the
122     // slot's contents, replace the bits taken up by the boolean, and then write
123     // back. This is the compiler's defense against contract upgrades and
124     // pointer aliasing, and it cannot be disabled.
125 
126     // The values being non-zero value makes deployment a bit more expensive,
127     // but in exchange the refund on every call to nonReentrant will be lower in
128     // amount. Since refunds are capped to a percentage of the total
129     // transaction's gas, it is best to keep them low in cases like this one, to
130     // increase the likelihood of the full refund coming into effect.
131     uint256 private constant _NOT_ENTERED = 1;
132     uint256 private constant _ENTERED = 2;
133 
134     uint256 private _status;
135 
136     constructor() {
137         _status = _NOT_ENTERED;
138     }
139 
140     /**
141      * @dev Prevents a contract from calling itself, directly or indirectly.
142      * Calling a `nonReentrant` function from another `nonReentrant`
143      * function is not supported. It is possible to prevent this from happening
144      * by making the `nonReentrant` function external, and making it call a
145      * `private` function that does the actual work.
146      */
147     modifier nonReentrant() {
148         _nonReentrantBefore();
149         _;
150         _nonReentrantAfter();
151     }
152 
153     function _nonReentrantBefore() private {
154         // On the first call to nonReentrant, _status will be _NOT_ENTERED
155         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
156 
157         // Any calls to nonReentrant after this point will fail
158         _status = _ENTERED;
159     }
160 
161     function _nonReentrantAfter() private {
162         // By storing the original value once again, a refund is triggered (see
163         // https://eips.ethereum.org/EIPS/eip-2200)
164         _status = _NOT_ENTERED;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Context.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Provides information about the current execution context, including the
177  * sender of the transaction and its data. While these are generally available
178  * via msg.sender and msg.data, they should not be accessed in such a direct
179  * manner, since when dealing with meta-transactions the account sending and
180  * paying for execution may not be the actual sender (as far as an application
181  * is concerned).
182  *
183  * This contract is only required for intermediate, library-like contracts.
184  */
185 abstract contract Context {
186     function _msgSender() internal view virtual returns (address) {
187         return msg.sender;
188     }
189 
190     function _msgData() internal view virtual returns (bytes calldata) {
191         return msg.data;
192     }
193 }
194 
195 // File: @openzeppelin/contracts/access/Ownable.sol
196 
197 
198 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @dev Contract module which provides a basic access control mechanism, where
205  * there is an account (an owner) that can be granted exclusive access to
206  * specific functions.
207  *
208  * By default, the owner account will be the one that deploys the contract. This
209  * can later be changed with {transferOwnership}.
210  *
211  * This module is used through inheritance. It will make available the modifier
212  * `onlyOwner`, which can be applied to your functions to restrict their use to
213  * the owner.
214  */
215 abstract contract Ownable is Context {
216     address private _owner;
217 
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /**
221      * @dev Initializes the contract setting the deployer as the initial owner.
222      */
223     constructor() {
224         _transferOwnership(_msgSender());
225     }
226 
227     /**
228      * @dev Throws if called by any account other than the owner.
229      */
230     modifier onlyOwner() {
231         _checkOwner();
232         _;
233     }
234 
235     /**
236      * @dev Returns the address of the current owner.
237      */
238     function owner() public view virtual returns (address) {
239         return _owner;
240     }
241 
242     /**
243      * @dev Throws if the sender is not the owner.
244      */
245     function _checkOwner() internal view virtual {
246         require(owner() == _msgSender(), "Ownable: caller is not the owner");
247     }
248 
249     /**
250      * @dev Leaves the contract without owner. It will not be possible to call
251      * `onlyOwner` functions anymore. Can only be called by the current owner.
252      *
253      * NOTE: Renouncing ownership will leave the contract without an owner,
254      * thereby removing any functionality that is only available to the owner.
255      */
256     function renounceOwnership() public virtual onlyOwner {
257         _transferOwnership(address(0));
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      * Can only be called by the current owner.
263      */
264     function transferOwnership(address newOwner) public virtual onlyOwner {
265         require(newOwner != address(0), "Ownable: new owner is the zero address");
266         _transferOwnership(newOwner);
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Internal function without access restriction.
272      */
273     function _transferOwnership(address newOwner) internal virtual {
274         address oldOwner = _owner;
275         _owner = newOwner;
276         emit OwnershipTransferred(oldOwner, newOwner);
277     }
278 }
279 
280 // File: erc721a/contracts/IERC721A.sol
281 
282 
283 // ERC721A Contracts v4.2.3
284 // Creator: Chiru Labs
285 
286 pragma solidity ^0.8.4;
287 
288 /**
289  * @dev Interface of ERC721A.
290  */
291 interface IERC721A {
292     /**
293      * The caller must own the token or be an approved operator.
294      */
295     error ApprovalCallerNotOwnerNorApproved();
296 
297     /**
298      * The token does not exist.
299      */
300     error ApprovalQueryForNonexistentToken();
301 
302     /**
303      * Cannot query the balance for the zero address.
304      */
305     error BalanceQueryForZeroAddress();
306 
307     /**
308      * Cannot mint to the zero address.
309      */
310     error MintToZeroAddress();
311 
312     /**
313      * The quantity of tokens minted must be more than zero.
314      */
315     error MintZeroQuantity();
316 
317     /**
318      * The token does not exist.
319      */
320     error OwnerQueryForNonexistentToken();
321 
322     /**
323      * The caller must own the token or be an approved operator.
324      */
325     error TransferCallerNotOwnerNorApproved();
326 
327     /**
328      * The token must be owned by `from`.
329      */
330     error TransferFromIncorrectOwner();
331 
332     /**
333      * Cannot safely transfer to a contract that does not implement the
334      * ERC721Receiver interface.
335      */
336     error TransferToNonERC721ReceiverImplementer();
337 
338     /**
339      * Cannot transfer to the zero address.
340      */
341     error TransferToZeroAddress();
342 
343     /**
344      * The token does not exist.
345      */
346     error URIQueryForNonexistentToken();
347 
348     /**
349      * The `quantity` minted with ERC2309 exceeds the safety limit.
350      */
351     error MintERC2309QuantityExceedsLimit();
352 
353     /**
354      * The `extraData` cannot be set on an unintialized ownership slot.
355      */
356     error OwnershipNotInitializedForExtraData();
357 
358     // =============================================================
359     //                            STRUCTS
360     // =============================================================
361 
362     struct TokenOwnership {
363         // The address of the owner.
364         address addr;
365         // Stores the start time of ownership with minimal overhead for tokenomics.
366         uint64 startTimestamp;
367         // Whether the token has been burned.
368         bool burned;
369         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
370         uint24 extraData;
371     }
372 
373     // =============================================================
374     //                         TOKEN COUNTERS
375     // =============================================================
376 
377     /**
378      * @dev Returns the total number of tokens in existence.
379      * Burned tokens will reduce the count.
380      * To get the total number of tokens minted, please see {_totalMinted}.
381      */
382     function totalSupply() external view returns (uint256);
383 
384     // =============================================================
385     //                            IERC165
386     // =============================================================
387 
388     /**
389      * @dev Returns true if this contract implements the interface defined by
390      * `interfaceId`. See the corresponding
391      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
392      * to learn more about how these ids are created.
393      *
394      * This function call must use less than 30000 gas.
395      */
396     function supportsInterface(bytes4 interfaceId) external view returns (bool);
397 
398     // =============================================================
399     //                            IERC721
400     // =============================================================
401 
402     /**
403      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
409      */
410     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables or disables
414      * (`approved`) `operator` to manage all of its assets.
415      */
416     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
417 
418     /**
419      * @dev Returns the number of tokens in `owner`'s account.
420      */
421     function balanceOf(address owner) external view returns (uint256 balance);
422 
423     /**
424      * @dev Returns the owner of the `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`,
434      * checking first that contract recipients are aware of the ERC721 protocol
435      * to prevent tokens from being forever locked.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be have been allowed to move
443      * this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement
445      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external payable;
455 
456     /**
457      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
458      */
459     function safeTransferFrom(
460         address from,
461         address to,
462         uint256 tokenId
463     ) external payable;
464 
465     /**
466      * @dev Transfers `tokenId` from `from` to `to`.
467      *
468      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
469      * whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token
477      * by either {approve} or {setApprovalForAll}.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(
482         address from,
483         address to,
484         uint256 tokenId
485     ) external payable;
486 
487     /**
488      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
489      * The approval is cleared when the token is transferred.
490      *
491      * Only a single account can be approved at a time, so approving the
492      * zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external payable;
502 
503     /**
504      * @dev Approve or remove `operator` as an operator for the caller.
505      * Operators can call {transferFrom} or {safeTransferFrom}
506      * for any token owned by the caller.
507      *
508      * Requirements:
509      *
510      * - The `operator` cannot be the caller.
511      *
512      * Emits an {ApprovalForAll} event.
513      */
514     function setApprovalForAll(address operator, bool _approved) external;
515 
516     /**
517      * @dev Returns the account approved for `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function getApproved(uint256 tokenId) external view returns (address operator);
524 
525     /**
526      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
527      *
528      * See {setApprovalForAll}.
529      */
530     function isApprovedForAll(address owner, address operator) external view returns (bool);
531 
532     // =============================================================
533     //                        IERC721Metadata
534     // =============================================================
535 
536     /**
537      * @dev Returns the token collection name.
538      */
539     function name() external view returns (string memory);
540 
541     /**
542      * @dev Returns the token collection symbol.
543      */
544     function symbol() external view returns (string memory);
545 
546     /**
547      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
548      */
549     function tokenURI(uint256 tokenId) external view returns (string memory);
550 
551     // =============================================================
552     //                           IERC2309
553     // =============================================================
554 
555     /**
556      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
557      * (inclusive) is transferred from `from` to `to`, as defined in the
558      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
559      *
560      * See {_mintERC2309} for more details.
561      */
562     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
563 }
564 
565 // File: erc721a/contracts/ERC721A.sol
566 
567 
568 // ERC721A Contracts v4.2.3
569 // Creator: Chiru Labs
570 
571 pragma solidity ^0.8.4;
572 
573 
574 /**
575  * @dev Interface of ERC721 token receiver.
576  */
577 interface ERC721A__IERC721Receiver {
578     function onERC721Received(
579         address operator,
580         address from,
581         uint256 tokenId,
582         bytes calldata data
583     ) external returns (bytes4);
584 }
585 
586 /**
587  * @title ERC721A
588  *
589  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
590  * Non-Fungible Token Standard, including the Metadata extension.
591  * Optimized for lower gas during batch mints.
592  *
593  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
594  * starting from `_startTokenId()`.
595  *
596  * Assumptions:
597  *
598  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
599  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
600  */
601 contract ERC721A is IERC721A {
602     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
603     struct TokenApprovalRef {
604         address value;
605     }
606 
607     // =============================================================
608     //                           CONSTANTS
609     // =============================================================
610 
611     // Mask of an entry in packed address data.
612     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
613 
614     // The bit position of `numberMinted` in packed address data.
615     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
616 
617     // The bit position of `numberBurned` in packed address data.
618     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
619 
620     // The bit position of `aux` in packed address data.
621     uint256 private constant _BITPOS_AUX = 192;
622 
623     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
624     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
625 
626     // The bit position of `startTimestamp` in packed ownership.
627     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
628 
629     // The bit mask of the `burned` bit in packed ownership.
630     uint256 private constant _BITMASK_BURNED = 1 << 224;
631 
632     // The bit position of the `nextInitialized` bit in packed ownership.
633     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
634 
635     // The bit mask of the `nextInitialized` bit in packed ownership.
636     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
637 
638     // The bit position of `extraData` in packed ownership.
639     uint256 private constant _BITPOS_EXTRA_DATA = 232;
640 
641     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
642     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
643 
644     // The mask of the lower 160 bits for addresses.
645     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
646 
647     // The maximum `quantity` that can be minted with {_mintERC2309}.
648     // This limit is to prevent overflows on the address data entries.
649     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
650     // is required to cause an overflow, which is unrealistic.
651     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
652 
653     // The `Transfer` event signature is given by:
654     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
655     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
656         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
657 
658     // =============================================================
659     //                            STORAGE
660     // =============================================================
661 
662     // The next token ID to be minted.
663     uint256 private _currentIndex;
664 
665     // The number of tokens burned.
666     uint256 private _burnCounter;
667 
668     // Token name
669     string private _name;
670 
671     // Token symbol
672     string private _symbol;
673 
674     // Mapping from token ID to ownership details
675     // An empty struct value does not necessarily mean the token is unowned.
676     // See {_packedOwnershipOf} implementation for details.
677     //
678     // Bits Layout:
679     // - [0..159]   `addr`
680     // - [160..223] `startTimestamp`
681     // - [224]      `burned`
682     // - [225]      `nextInitialized`
683     // - [232..255] `extraData`
684     mapping(uint256 => uint256) private _packedOwnerships;
685 
686     // Mapping owner address to address data.
687     //
688     // Bits Layout:
689     // - [0..63]    `balance`
690     // - [64..127]  `numberMinted`
691     // - [128..191] `numberBurned`
692     // - [192..255] `aux`
693     mapping(address => uint256) private _packedAddressData;
694 
695     // Mapping from token ID to approved address.
696     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
697 
698     // Mapping from owner to operator approvals
699     mapping(address => mapping(address => bool)) private _operatorApprovals;
700 
701     // =============================================================
702     //                          CONSTRUCTOR
703     // =============================================================
704 
705     constructor(string memory name_, string memory symbol_) {
706         _name = name_;
707         _symbol = symbol_;
708         _currentIndex = _startTokenId();
709     }
710 
711     // =============================================================
712     //                   TOKEN COUNTING OPERATIONS
713     // =============================================================
714 
715     /**
716      * @dev Returns the starting token ID.
717      * To change the starting token ID, please override this function.
718      */
719     function _startTokenId() internal view virtual returns (uint256) {
720         return 0;
721     }
722 
723     /**
724      * @dev Returns the next token ID to be minted.
725      */
726     function _nextTokenId() internal view virtual returns (uint256) {
727         return _currentIndex;
728     }
729 
730     /**
731      * @dev Returns the total number of tokens in existence.
732      * Burned tokens will reduce the count.
733      * To get the total number of tokens minted, please see {_totalMinted}.
734      */
735     function totalSupply() public view virtual override returns (uint256) {
736         // Counter underflow is impossible as _burnCounter cannot be incremented
737         // more than `_currentIndex - _startTokenId()` times.
738         unchecked {
739             return _currentIndex - _burnCounter - _startTokenId();
740         }
741     }
742 
743     /**
744      * @dev Returns the total amount of tokens minted in the contract.
745      */
746     function _totalMinted() internal view virtual returns (uint256) {
747         // Counter underflow is impossible as `_currentIndex` does not decrement,
748         // and it is initialized to `_startTokenId()`.
749         unchecked {
750             return _currentIndex - _startTokenId();
751         }
752     }
753 
754     /**
755      * @dev Returns the total number of tokens burned.
756      */
757     function _totalBurned() internal view virtual returns (uint256) {
758         return _burnCounter;
759     }
760 
761     // =============================================================
762     //                    ADDRESS DATA OPERATIONS
763     // =============================================================
764 
765     /**
766      * @dev Returns the number of tokens in `owner`'s account.
767      */
768     function balanceOf(address owner) public view virtual override returns (uint256) {
769         if (owner == address(0)) revert BalanceQueryForZeroAddress();
770         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
771     }
772 
773     /**
774      * Returns the number of tokens minted by `owner`.
775      */
776     function _numberMinted(address owner) internal view returns (uint256) {
777         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
778     }
779 
780     /**
781      * Returns the number of tokens burned by or on behalf of `owner`.
782      */
783     function _numberBurned(address owner) internal view returns (uint256) {
784         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
785     }
786 
787     /**
788      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
789      */
790     function _getAux(address owner) internal view returns (uint64) {
791         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
792     }
793 
794     /**
795      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
796      * If there are multiple variables, please pack them into a uint64.
797      */
798     function _setAux(address owner, uint64 aux) internal virtual {
799         uint256 packed = _packedAddressData[owner];
800         uint256 auxCasted;
801         // Cast `aux` with assembly to avoid redundant masking.
802         assembly {
803             auxCasted := aux
804         }
805         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
806         _packedAddressData[owner] = packed;
807     }
808 
809     // =============================================================
810     //                            IERC165
811     // =============================================================
812 
813     /**
814      * @dev Returns true if this contract implements the interface defined by
815      * `interfaceId`. See the corresponding
816      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
817      * to learn more about how these ids are created.
818      *
819      * This function call must use less than 30000 gas.
820      */
821     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
822         // The interface IDs are constants representing the first 4 bytes
823         // of the XOR of all function selectors in the interface.
824         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
825         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
826         return
827             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
828             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
829             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
830     }
831 
832     // =============================================================
833     //                        IERC721Metadata
834     // =============================================================
835 
836     /**
837      * @dev Returns the token collection name.
838      */
839     function name() public view virtual override returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev Returns the token collection symbol.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
852      */
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
858     }
859 
860     /**
861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
863      * by default, it can be overridden in child contracts.
864      */
865     function _baseURI() internal view virtual returns (string memory) {
866         return '';
867     }
868 
869     // =============================================================
870     //                     OWNERSHIPS OPERATIONS
871     // =============================================================
872 
873     /**
874      * @dev Returns the owner of the `tokenId` token.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      */
880     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
881         return address(uint160(_packedOwnershipOf(tokenId)));
882     }
883 
884     /**
885      * @dev Gas spent here starts off proportional to the maximum mint batch size.
886      * It gradually moves to O(1) as tokens get transferred around over time.
887      */
888     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
889         return _unpackedOwnership(_packedOwnershipOf(tokenId));
890     }
891 
892     /**
893      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
894      */
895     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
896         return _unpackedOwnership(_packedOwnerships[index]);
897     }
898 
899     /**
900      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
901      */
902     function _initializeOwnershipAt(uint256 index) internal virtual {
903         if (_packedOwnerships[index] == 0) {
904             _packedOwnerships[index] = _packedOwnershipOf(index);
905         }
906     }
907 
908     /**
909      * Returns the packed ownership data of `tokenId`.
910      */
911     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
912         uint256 curr = tokenId;
913 
914         unchecked {
915             if (_startTokenId() <= curr)
916                 if (curr < _currentIndex) {
917                     uint256 packed = _packedOwnerships[curr];
918                     // If not burned.
919                     if (packed & _BITMASK_BURNED == 0) {
920                         // Invariant:
921                         // There will always be an initialized ownership slot
922                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
923                         // before an unintialized ownership slot
924                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
925                         // Hence, `curr` will not underflow.
926                         //
927                         // We can directly compare the packed value.
928                         // If the address is zero, packed will be zero.
929                         while (packed == 0) {
930                             packed = _packedOwnerships[--curr];
931                         }
932                         return packed;
933                     }
934                 }
935         }
936         revert OwnerQueryForNonexistentToken();
937     }
938 
939     /**
940      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
941      */
942     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
943         ownership.addr = address(uint160(packed));
944         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
945         ownership.burned = packed & _BITMASK_BURNED != 0;
946         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
947     }
948 
949     /**
950      * @dev Packs ownership data into a single uint256.
951      */
952     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
953         assembly {
954             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
955             owner := and(owner, _BITMASK_ADDRESS)
956             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
957             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
958         }
959     }
960 
961     /**
962      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
963      */
964     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
965         // For branchless setting of the `nextInitialized` flag.
966         assembly {
967             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
968             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
969         }
970     }
971 
972     // =============================================================
973     //                      APPROVAL OPERATIONS
974     // =============================================================
975 
976     /**
977      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
978      * The approval is cleared when the token is transferred.
979      *
980      * Only a single account can be approved at a time, so approving the
981      * zero address clears previous approvals.
982      *
983      * Requirements:
984      *
985      * - The caller must own the token or be an approved operator.
986      * - `tokenId` must exist.
987      *
988      * Emits an {Approval} event.
989      */
990     function approve(address to, uint256 tokenId) public payable virtual override {
991         address owner = ownerOf(tokenId);
992 
993         if (_msgSenderERC721A() != owner)
994             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
995                 revert ApprovalCallerNotOwnerNorApproved();
996             }
997 
998         _tokenApprovals[tokenId].value = to;
999         emit Approval(owner, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Returns the account approved for `tokenId` token.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      */
1009     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1010         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1011 
1012         return _tokenApprovals[tokenId].value;
1013     }
1014 
1015     /**
1016      * @dev Approve or remove `operator` as an operator for the caller.
1017      * Operators can call {transferFrom} or {safeTransferFrom}
1018      * for any token owned by the caller.
1019      *
1020      * Requirements:
1021      *
1022      * - The `operator` cannot be the caller.
1023      *
1024      * Emits an {ApprovalForAll} event.
1025      */
1026     function setApprovalForAll(address operator, bool approved) public virtual override {
1027         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1028         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1029     }
1030 
1031     /**
1032      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1033      *
1034      * See {setApprovalForAll}.
1035      */
1036     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1037         return _operatorApprovals[owner][operator];
1038     }
1039 
1040     /**
1041      * @dev Returns whether `tokenId` exists.
1042      *
1043      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1044      *
1045      * Tokens start existing when they are minted. See {_mint}.
1046      */
1047     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1048         return
1049             _startTokenId() <= tokenId &&
1050             tokenId < _currentIndex && // If within bounds,
1051             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1052     }
1053 
1054     /**
1055      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1056      */
1057     function _isSenderApprovedOrOwner(
1058         address approvedAddress,
1059         address owner,
1060         address msgSender
1061     ) private pure returns (bool result) {
1062         assembly {
1063             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1064             owner := and(owner, _BITMASK_ADDRESS)
1065             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1066             msgSender := and(msgSender, _BITMASK_ADDRESS)
1067             // `msgSender == owner || msgSender == approvedAddress`.
1068             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1069         }
1070     }
1071 
1072     /**
1073      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1074      */
1075     function _getApprovedSlotAndAddress(uint256 tokenId)
1076         private
1077         view
1078         returns (uint256 approvedAddressSlot, address approvedAddress)
1079     {
1080         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1081         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1082         assembly {
1083             approvedAddressSlot := tokenApproval.slot
1084             approvedAddress := sload(approvedAddressSlot)
1085         }
1086     }
1087 
1088     // =============================================================
1089     //                      TRANSFER OPERATIONS
1090     // =============================================================
1091 
1092     /**
1093      * @dev Transfers `tokenId` from `from` to `to`.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      * - If the caller is not `from`, it must be approved to move this token
1101      * by either {approve} or {setApprovalForAll}.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function transferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) public payable virtual override {
1110         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1111 
1112         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1113 
1114         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1115 
1116         // The nested ifs save around 20+ gas over a compound boolean condition.
1117         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1118             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1119 
1120         if (to == address(0)) revert TransferToZeroAddress();
1121 
1122         _beforeTokenTransfers(from, to, tokenId, 1);
1123 
1124         // Clear approvals from the previous owner.
1125         assembly {
1126             if approvedAddress {
1127                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1128                 sstore(approvedAddressSlot, 0)
1129             }
1130         }
1131 
1132         // Underflow of the sender's balance is impossible because we check for
1133         // ownership above and the recipient's balance can't realistically overflow.
1134         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1135         unchecked {
1136             // We can directly increment and decrement the balances.
1137             --_packedAddressData[from]; // Updates: `balance -= 1`.
1138             ++_packedAddressData[to]; // Updates: `balance += 1`.
1139 
1140             // Updates:
1141             // - `address` to the next owner.
1142             // - `startTimestamp` to the timestamp of transfering.
1143             // - `burned` to `false`.
1144             // - `nextInitialized` to `true`.
1145             _packedOwnerships[tokenId] = _packOwnershipData(
1146                 to,
1147                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1148             );
1149 
1150             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1151             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1152                 uint256 nextTokenId = tokenId + 1;
1153                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1154                 if (_packedOwnerships[nextTokenId] == 0) {
1155                     // If the next slot is within bounds.
1156                     if (nextTokenId != _currentIndex) {
1157                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1158                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1159                     }
1160                 }
1161             }
1162         }
1163 
1164         emit Transfer(from, to, tokenId);
1165         _afterTokenTransfers(from, to, tokenId, 1);
1166     }
1167 
1168     /**
1169      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) public payable virtual override {
1176         safeTransferFrom(from, to, tokenId, '');
1177     }
1178 
1179     /**
1180      * @dev Safely transfers `tokenId` token from `from` to `to`.
1181      *
1182      * Requirements:
1183      *
1184      * - `from` cannot be the zero address.
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must exist and be owned by `from`.
1187      * - If the caller is not `from`, it must be approved to move this token
1188      * by either {approve} or {setApprovalForAll}.
1189      * - If `to` refers to a smart contract, it must implement
1190      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) public payable virtual override {
1200         transferFrom(from, to, tokenId);
1201         if (to.code.length != 0)
1202             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1203                 revert TransferToNonERC721ReceiverImplementer();
1204             }
1205     }
1206 
1207     /**
1208      * @dev Hook that is called before a set of serially-ordered token IDs
1209      * are about to be transferred. This includes minting.
1210      * And also called before burning one token.
1211      *
1212      * `startTokenId` - the first token ID to be transferred.
1213      * `quantity` - the amount to be transferred.
1214      *
1215      * Calling conditions:
1216      *
1217      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1218      * transferred to `to`.
1219      * - When `from` is zero, `tokenId` will be minted for `to`.
1220      * - When `to` is zero, `tokenId` will be burned by `from`.
1221      * - `from` and `to` are never both zero.
1222      */
1223     function _beforeTokenTransfers(
1224         address from,
1225         address to,
1226         uint256 startTokenId,
1227         uint256 quantity
1228     ) internal virtual {}
1229 
1230     /**
1231      * @dev Hook that is called after a set of serially-ordered token IDs
1232      * have been transferred. This includes minting.
1233      * And also called after one token has been burned.
1234      *
1235      * `startTokenId` - the first token ID to be transferred.
1236      * `quantity` - the amount to be transferred.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` has been minted for `to`.
1243      * - When `to` is zero, `tokenId` has been burned by `from`.
1244      * - `from` and `to` are never both zero.
1245      */
1246     function _afterTokenTransfers(
1247         address from,
1248         address to,
1249         uint256 startTokenId,
1250         uint256 quantity
1251     ) internal virtual {}
1252 
1253     /**
1254      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1255      *
1256      * `from` - Previous owner of the given token ID.
1257      * `to` - Target address that will receive the token.
1258      * `tokenId` - Token ID to be transferred.
1259      * `_data` - Optional data to send along with the call.
1260      *
1261      * Returns whether the call correctly returned the expected magic value.
1262      */
1263     function _checkContractOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1270             bytes4 retval
1271         ) {
1272             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1273         } catch (bytes memory reason) {
1274             if (reason.length == 0) {
1275                 revert TransferToNonERC721ReceiverImplementer();
1276             } else {
1277                 assembly {
1278                     revert(add(32, reason), mload(reason))
1279                 }
1280             }
1281         }
1282     }
1283 
1284     // =============================================================
1285     //                        MINT OPERATIONS
1286     // =============================================================
1287 
1288     /**
1289      * @dev Mints `quantity` tokens and transfers them to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - `to` cannot be the zero address.
1294      * - `quantity` must be greater than 0.
1295      *
1296      * Emits a {Transfer} event for each mint.
1297      */
1298     function _mint(address to, uint256 quantity) internal virtual {
1299         uint256 startTokenId = _currentIndex;
1300         if (quantity == 0) revert MintZeroQuantity();
1301 
1302         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1303 
1304         // Overflows are incredibly unrealistic.
1305         // `balance` and `numberMinted` have a maximum limit of 2**64.
1306         // `tokenId` has a maximum limit of 2**256.
1307         unchecked {
1308             // Updates:
1309             // - `balance += quantity`.
1310             // - `numberMinted += quantity`.
1311             //
1312             // We can directly add to the `balance` and `numberMinted`.
1313             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1314 
1315             // Updates:
1316             // - `address` to the owner.
1317             // - `startTimestamp` to the timestamp of minting.
1318             // - `burned` to `false`.
1319             // - `nextInitialized` to `quantity == 1`.
1320             _packedOwnerships[startTokenId] = _packOwnershipData(
1321                 to,
1322                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1323             );
1324 
1325             uint256 toMasked;
1326             uint256 end = startTokenId + quantity;
1327 
1328             // Use assembly to loop and emit the `Transfer` event for gas savings.
1329             // The duplicated `log4` removes an extra check and reduces stack juggling.
1330             // The assembly, together with the surrounding Solidity code, have been
1331             // delicately arranged to nudge the compiler into producing optimized opcodes.
1332             assembly {
1333                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1334                 toMasked := and(to, _BITMASK_ADDRESS)
1335                 // Emit the `Transfer` event.
1336                 log4(
1337                     0, // Start of data (0, since no data).
1338                     0, // End of data (0, since no data).
1339                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1340                     0, // `address(0)`.
1341                     toMasked, // `to`.
1342                     startTokenId // `tokenId`.
1343                 )
1344 
1345                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1346                 // that overflows uint256 will make the loop run out of gas.
1347                 // The compiler will optimize the `iszero` away for performance.
1348                 for {
1349                     let tokenId := add(startTokenId, 1)
1350                 } iszero(eq(tokenId, end)) {
1351                     tokenId := add(tokenId, 1)
1352                 } {
1353                     // Emit the `Transfer` event. Similar to above.
1354                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1355                 }
1356             }
1357             if (toMasked == 0) revert MintToZeroAddress();
1358 
1359             _currentIndex = end;
1360         }
1361         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1362     }
1363 
1364     /**
1365      * @dev Mints `quantity` tokens and transfers them to `to`.
1366      *
1367      * This function is intended for efficient minting only during contract creation.
1368      *
1369      * It emits only one {ConsecutiveTransfer} as defined in
1370      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1371      * instead of a sequence of {Transfer} event(s).
1372      *
1373      * Calling this function outside of contract creation WILL make your contract
1374      * non-compliant with the ERC721 standard.
1375      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1376      * {ConsecutiveTransfer} event is only permissible during contract creation.
1377      *
1378      * Requirements:
1379      *
1380      * - `to` cannot be the zero address.
1381      * - `quantity` must be greater than 0.
1382      *
1383      * Emits a {ConsecutiveTransfer} event.
1384      */
1385     function _mintERC2309(address to, uint256 quantity) internal virtual {
1386         uint256 startTokenId = _currentIndex;
1387         if (to == address(0)) revert MintToZeroAddress();
1388         if (quantity == 0) revert MintZeroQuantity();
1389         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1390 
1391         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1392 
1393         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1394         unchecked {
1395             // Updates:
1396             // - `balance += quantity`.
1397             // - `numberMinted += quantity`.
1398             //
1399             // We can directly add to the `balance` and `numberMinted`.
1400             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1401 
1402             // Updates:
1403             // - `address` to the owner.
1404             // - `startTimestamp` to the timestamp of minting.
1405             // - `burned` to `false`.
1406             // - `nextInitialized` to `quantity == 1`.
1407             _packedOwnerships[startTokenId] = _packOwnershipData(
1408                 to,
1409                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1410             );
1411 
1412             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1413 
1414             _currentIndex = startTokenId + quantity;
1415         }
1416         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1417     }
1418 
1419     /**
1420      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1421      *
1422      * Requirements:
1423      *
1424      * - If `to` refers to a smart contract, it must implement
1425      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1426      * - `quantity` must be greater than 0.
1427      *
1428      * See {_mint}.
1429      *
1430      * Emits a {Transfer} event for each mint.
1431      */
1432     function _safeMint(
1433         address to,
1434         uint256 quantity,
1435         bytes memory _data
1436     ) internal virtual {
1437         _mint(to, quantity);
1438 
1439         unchecked {
1440             if (to.code.length != 0) {
1441                 uint256 end = _currentIndex;
1442                 uint256 index = end - quantity;
1443                 do {
1444                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1445                         revert TransferToNonERC721ReceiverImplementer();
1446                     }
1447                 } while (index < end);
1448                 // Reentrancy protection.
1449                 if (_currentIndex != end) revert();
1450             }
1451         }
1452     }
1453 
1454     /**
1455      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1456      */
1457     function _safeMint(address to, uint256 quantity) internal virtual {
1458         _safeMint(to, quantity, '');
1459     }
1460 
1461     // =============================================================
1462     //                        BURN OPERATIONS
1463     // =============================================================
1464 
1465     /**
1466      * @dev Equivalent to `_burn(tokenId, false)`.
1467      */
1468     function _burn(uint256 tokenId) internal virtual {
1469         _burn(tokenId, false);
1470     }
1471 
1472     /**
1473      * @dev Destroys `tokenId`.
1474      * The approval is cleared when the token is burned.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1483         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1484 
1485         address from = address(uint160(prevOwnershipPacked));
1486 
1487         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1488 
1489         if (approvalCheck) {
1490             // The nested ifs save around 20+ gas over a compound boolean condition.
1491             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1492                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1493         }
1494 
1495         _beforeTokenTransfers(from, address(0), tokenId, 1);
1496 
1497         // Clear approvals from the previous owner.
1498         assembly {
1499             if approvedAddress {
1500                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1501                 sstore(approvedAddressSlot, 0)
1502             }
1503         }
1504 
1505         // Underflow of the sender's balance is impossible because we check for
1506         // ownership above and the recipient's balance can't realistically overflow.
1507         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1508         unchecked {
1509             // Updates:
1510             // - `balance -= 1`.
1511             // - `numberBurned += 1`.
1512             //
1513             // We can directly decrement the balance, and increment the number burned.
1514             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1515             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1516 
1517             // Updates:
1518             // - `address` to the last owner.
1519             // - `startTimestamp` to the timestamp of burning.
1520             // - `burned` to `true`.
1521             // - `nextInitialized` to `true`.
1522             _packedOwnerships[tokenId] = _packOwnershipData(
1523                 from,
1524                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1525             );
1526 
1527             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1528             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1529                 uint256 nextTokenId = tokenId + 1;
1530                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1531                 if (_packedOwnerships[nextTokenId] == 0) {
1532                     // If the next slot is within bounds.
1533                     if (nextTokenId != _currentIndex) {
1534                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1535                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1536                     }
1537                 }
1538             }
1539         }
1540 
1541         emit Transfer(from, address(0), tokenId);
1542         _afterTokenTransfers(from, address(0), tokenId, 1);
1543 
1544         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1545         unchecked {
1546             _burnCounter++;
1547         }
1548     }
1549 
1550     // =============================================================
1551     //                     EXTRA DATA OPERATIONS
1552     // =============================================================
1553 
1554     /**
1555      * @dev Directly sets the extra data for the ownership data `index`.
1556      */
1557     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1558         uint256 packed = _packedOwnerships[index];
1559         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1560         uint256 extraDataCasted;
1561         // Cast `extraData` with assembly to avoid redundant masking.
1562         assembly {
1563             extraDataCasted := extraData
1564         }
1565         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1566         _packedOwnerships[index] = packed;
1567     }
1568 
1569     /**
1570      * @dev Called during each token transfer to set the 24bit `extraData` field.
1571      * Intended to be overridden by the cosumer contract.
1572      *
1573      * `previousExtraData` - the value of `extraData` before transfer.
1574      *
1575      * Calling conditions:
1576      *
1577      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1578      * transferred to `to`.
1579      * - When `from` is zero, `tokenId` will be minted for `to`.
1580      * - When `to` is zero, `tokenId` will be burned by `from`.
1581      * - `from` and `to` are never both zero.
1582      */
1583     function _extraData(
1584         address from,
1585         address to,
1586         uint24 previousExtraData
1587     ) internal view virtual returns (uint24) {}
1588 
1589     /**
1590      * @dev Returns the next extra data for the packed ownership data.
1591      * The returned result is shifted into position.
1592      */
1593     function _nextExtraData(
1594         address from,
1595         address to,
1596         uint256 prevOwnershipPacked
1597     ) private view returns (uint256) {
1598         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1599         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1600     }
1601 
1602     // =============================================================
1603     //                       OTHER OPERATIONS
1604     // =============================================================
1605 
1606     /**
1607      * @dev Returns the message sender (defaults to `msg.sender`).
1608      *
1609      * If you are writing GSN compatible contracts, you need to override this function.
1610      */
1611     function _msgSenderERC721A() internal view virtual returns (address) {
1612         return msg.sender;
1613     }
1614 
1615     /**
1616      * @dev Converts a uint256 to its ASCII string decimal representation.
1617      */
1618     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1619         assembly {
1620             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1621             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1622             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1623             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1624             let m := add(mload(0x40), 0xa0)
1625             // Update the free memory pointer to allocate.
1626             mstore(0x40, m)
1627             // Assign the `str` to the end.
1628             str := sub(m, 0x20)
1629             // Zeroize the slot after the string.
1630             mstore(str, 0)
1631 
1632             // Cache the end of the memory to calculate the length later.
1633             let end := str
1634 
1635             // We write the string from rightmost digit to leftmost digit.
1636             // The following is essentially a do-while loop that also handles the zero case.
1637             // prettier-ignore
1638             for { let temp := value } 1 {} {
1639                 str := sub(str, 1)
1640                 // Write the character to the pointer.
1641                 // The ASCII index of the '0' character is 48.
1642                 mstore8(str, add(48, mod(temp, 10)))
1643                 // Keep dividing `temp` until zero.
1644                 temp := div(temp, 10)
1645                 // prettier-ignore
1646                 if iszero(temp) { break }
1647             }
1648 
1649             let length := sub(end, str)
1650             // Move the pointer 32 bytes leftwards to make room for the length.
1651             str := sub(str, 0x20)
1652             // Store the length.
1653             mstore(str, length)
1654         }
1655     }
1656 }
1657 
1658 // File: contracts/XorePioneerEnforced.sol
1659 
1660 
1661 
1662 // ██╗  ██╗ ██████╗ ██████╗ ███████╗    ██████╗ ██╗ ██████╗ ███╗   ██╗███████╗███████╗██████╗ 
1663 // ╚██╗██╔╝██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗██║██╔═══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗
1664 //  ╚███╔╝ ██║   ██║██████╔╝█████╗      ██████╔╝██║██║   ██║██╔██╗ ██║█████╗  █████╗  ██████╔╝
1665 //  ██╔██╗ ██║   ██║██╔══██╗██╔══╝      ██╔═══╝ ██║██║   ██║██║╚██╗██║██╔══╝  ██╔══╝  ██╔══██╗
1666 // ██╔╝ ██╗╚██████╔╝██║  ██║███████╗    ██║     ██║╚██████╔╝██║ ╚████║███████╗███████╗██║  ██║
1667 // ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝                                                                                          
1668 
1669 
1670 
1671 pragma solidity ^0.8.13;
1672 
1673 
1674 
1675 
1676 
1677 contract XorePioneer is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1678 
1679 
1680   string public baseURI;
1681   string public notRevealedUri;
1682   uint256 public cost = 0 ether;
1683   uint256 public wlcost = 0 ether;
1684   uint256 public maxSupply = 333;
1685   uint256 public WlSupply = 250;
1686   uint256 public MaxperWallet = 1; // max per wallet for public
1687   uint256 public MaxperWalletWl = 1; // max per wallet for whitelist
1688   uint256 public MaxperTx = 1;  // max per transaction for public
1689   uint256 public MaxperTxWl = 1; // max per transaction for whitelist
1690   bool public paused = false;
1691   bool public revealed = false;
1692   bool public preSale = true;
1693   bool public publicSale = false;
1694   mapping (address => uint256) public PublicMinted;
1695   mapping (address => uint256) public WhitelistMinted;
1696   mapping(address => bool) whitelistedAddresses;
1697   address public p1 = 0xdef889a07c5608f2EEaAbb13BB6dA45cF21EF2a5;
1698 
1699   constructor(
1700     string memory _initBaseURI,
1701     string memory _notRevealedUri
1702   ) ERC721A("XORE-Pioneer", "XP") {
1703     setBaseURI(_initBaseURI);
1704     setNotRevealedURI(_notRevealedUri);
1705   }
1706 
1707   // internal
1708   function _baseURI() internal view virtual override returns (string memory) {
1709     return baseURI;
1710   }
1711       function _startTokenId() internal view virtual override returns (uint256) {
1712         return 1;
1713     }
1714 
1715 
1716 
1717   /// @dev Public mint 
1718   function mint(uint256 tokens) public payable nonReentrant {
1719     require(!paused, "oops contract is paused");
1720     require(publicSale, "Sale hasn't started yet");
1721     require(tokens <= MaxperTx, "max mint amount per tx exceeded");
1722     require(totalSupply() + tokens <= maxSupply, "We Soldout");
1723     require(PublicMinted[_msgSenderERC721A()] + tokens <= MaxperWallet, "Max NFT Per Wallet exceeded");
1724     require(msg.value >= cost * tokens, "insufficient funds");
1725 
1726       PublicMinted[_msgSenderERC721A()] += tokens;
1727       _safeMint(_msgSenderERC721A(), tokens);
1728     
1729   }
1730 /// @dev presale mint for whitelisted
1731     function presalemint(uint256 tokens) public payable nonReentrant {
1732     require(!paused, "oops contract is paused");
1733     require(preSale, "Presale hasn't started yet");
1734     require(whitelistedAddresses[_msgSenderERC721A()], "You are Not Whitelisted");
1735     require(WhitelistMinted[_msgSenderERC721A()] + tokens <= MaxperWalletWl, "Max NFT Per Wallet exceeded");
1736     require(tokens <= MaxperTxWl, "max mint per Tx exceeded");
1737     require(totalSupply() + tokens <= WlSupply, "Whitelist MaxSupply exceeded");
1738     require(msg.value >= wlcost * tokens, "insufficient funds");
1739 
1740         WhitelistMinted[_msgSenderERC721A()] += tokens;
1741       _safeMint(_msgSenderERC721A(), tokens);
1742   }
1743 
1744   /// @dev use it for giveaway and team mint
1745      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1746     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1747 
1748       _safeMint(destination, _mintAmount);
1749   }
1750 
1751 /// @notice returns metadata link of tokenid
1752   function tokenURI(uint256 tokenId)
1753     public
1754     view
1755     virtual
1756     override
1757     returns (string memory)
1758   {
1759     require(
1760       _exists(tokenId),
1761       "ERC721AMetadata: URI query for nonexistent token"
1762     );
1763     
1764     if(revealed == false) {
1765         return notRevealedUri;
1766     }
1767 
1768     string memory currentBaseURI = _baseURI();
1769     return bytes(currentBaseURI).length > 0
1770         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
1771         : "";
1772   }
1773 
1774      /// @notice return the number minted by an address
1775     function numberMinted(address owner) public view returns (uint256) {
1776     return _numberMinted(owner);
1777   }
1778 
1779     /// @notice return the tokens owned by an address
1780       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1781         unchecked {
1782             uint256 tokenIdsIdx;
1783             address currOwnershipAddr;
1784             uint256 tokenIdsLength = balanceOf(owner);
1785             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1786             TokenOwnership memory ownership;
1787             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1788                 ownership = _ownershipAt(i);
1789                 if (ownership.burned) {
1790                     continue;
1791                 }
1792                 if (ownership.addr != address(0)) {
1793                     currOwnershipAddr = ownership.addr;
1794                 }
1795                 if (currOwnershipAddr == owner) {
1796                     tokenIds[tokenIdsIdx++] = i;
1797                 }
1798             }
1799             return tokenIds;
1800         }
1801     }
1802 
1803   //only owner
1804   function reveal(bool _state) public onlyOwner {
1805       revealed = _state;
1806   }
1807 
1808   /// @dev change the public max per wallet
1809   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1810     MaxperWallet = _limit;
1811   }
1812 
1813   /// @dev change the whitelist max per wallet
1814     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1815     MaxperWalletWl = _limit;
1816   }
1817 
1818     /// @dev change the public max per transaction
1819   function setMaxPerTx(uint256 _limit) public onlyOwner {
1820     MaxperTx = _limit;
1821   }
1822 
1823   /// @dev change the whitelist max per transaction
1824     function setWlMaxPerTx(uint256 _limit) public onlyOwner {
1825     MaxperTxWl = _limit;
1826   }
1827 
1828    /// @dev change the public price(amount need to be in wei)
1829   function setCost(uint256 _newCost) public onlyOwner {
1830     cost = _newCost;
1831   }
1832 
1833    /// @dev change the whitelist price(amount need to be in wei)
1834     function setWlCost(uint256 _newWlCost) public onlyOwner {
1835     wlcost = _newWlCost;
1836   }
1837 
1838   /// @dev cut the supply if we dont sold out
1839     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1840     maxSupply = _newsupply;
1841   }
1842 
1843  /// @dev cut the whitelist supply if we dont sold out
1844     function setwlsupply(uint256 _newsupply) public onlyOwner {
1845     WlSupply = _newsupply;
1846   }
1847 
1848  /// @dev set your baseuri
1849   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1850     baseURI = _newBaseURI;
1851   }
1852 
1853    /// @dev set hidden uri
1854   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1855     notRevealedUri = _notRevealedURI;
1856   }
1857 
1858  /// @dev to pause and unpause your contract(use booleans true or false)
1859   function pause(bool _state) public onlyOwner {
1860     paused = _state;
1861   }
1862 
1863      /// @dev activate whitelist sale(use booleans true or false)
1864     function togglepreSale(bool _state) external onlyOwner {
1865         preSale = _state;
1866     }
1867 
1868     /// @dev activate public sale(use booleans true or false)
1869     function togglepublicSale(bool _state) external onlyOwner {
1870         publicSale = _state;
1871     }
1872 
1873       function isWhitelisted(address _user) public view returns (bool) {
1874     return whitelistedAddresses[_user];
1875   }
1876 
1877     function whitelistUsers(address[] memory addresses) public onlyOwner {
1878     for (uint256 i = 0; i < addresses.length; i++) {
1879       whitelistedAddresses[addresses[i]] = true;
1880     }
1881   }
1882   
1883   /// @dev withdraw funds from contract
1884   function withdraw() public payable onlyOwner nonReentrant {
1885       uint256 share1 = address(this).balance * 100 / 100;
1886 
1887       payable(p1).transfer(share1);
1888   }
1889 
1890     /// Opensea Royalties
1891 
1892     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1893     super.transferFrom(from, to, tokenId);
1894   }
1895 
1896     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1897     super.safeTransferFrom(from, to, tokenId);
1898   }
1899 
1900     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
1901     super.safeTransferFrom(from, to, tokenId, data);
1902   }
1903 }