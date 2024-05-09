1 // File: contracts/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: contracts/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: contracts/src/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/Context.sol
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 // File: @openzeppelin/contracts/access/Ownable.sol
139 
140 
141 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
142 
143 pragma solidity ^0.8.0;
144 
145 
146 /**
147  * @dev Contract module which provides a basic access control mechanism, where
148  * there is an account (an owner) that can be granted exclusive access to
149  * specific functions.
150  *
151  * By default, the owner account will be the one that deploys the contract. This
152  * can later be changed with {transferOwnership}.
153  *
154  * This module is used through inheritance. It will make available the modifier
155  * `onlyOwner`, which can be applied to your functions to restrict their use to
156  * the owner.
157  */
158 abstract contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     /**
164      * @dev Initializes the contract setting the deployer as the initial owner.
165      */
166     constructor() {
167         _transferOwnership(_msgSender());
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         _checkOwner();
175         _;
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view virtual returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if the sender is not the owner.
187      */
188     function _checkOwner() internal view virtual {
189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: erc721a/contracts/IERC721A.sol
224 
225 
226 // ERC721A Contracts v4.2.3
227 // Creator: Chiru Labs
228 
229 pragma solidity ^0.8.4;
230 
231 /**
232  * @dev Interface of ERC721A.
233  */
234 interface IERC721A {
235     /**
236      * The caller must own the token or be an approved operator.
237      */
238     error ApprovalCallerNotOwnerNorApproved();
239 
240     /**
241      * The token does not exist.
242      */
243     error ApprovalQueryForNonexistentToken();
244 
245     /**
246      * Cannot query the balance for the zero address.
247      */
248     error BalanceQueryForZeroAddress();
249 
250     /**
251      * Cannot mint to the zero address.
252      */
253     error MintToZeroAddress();
254 
255     /**
256      * The quantity of tokens minted must be more than zero.
257      */
258     error MintZeroQuantity();
259 
260     /**
261      * The token does not exist.
262      */
263     error OwnerQueryForNonexistentToken();
264 
265     /**
266      * The caller must own the token or be an approved operator.
267      */
268     error TransferCallerNotOwnerNorApproved();
269 
270     /**
271      * The token must be owned by `from`.
272      */
273     error TransferFromIncorrectOwner();
274 
275     /**
276      * Cannot safely transfer to a contract that does not implement the
277      * ERC721Receiver interface.
278      */
279     error TransferToNonERC721ReceiverImplementer();
280 
281     /**
282      * Cannot transfer to the zero address.
283      */
284     error TransferToZeroAddress();
285 
286     /**
287      * The token does not exist.
288      */
289     error URIQueryForNonexistentToken();
290 
291     /**
292      * The `quantity` minted with ERC2309 exceeds the safety limit.
293      */
294     error MintERC2309QuantityExceedsLimit();
295 
296     /**
297      * The `extraData` cannot be set on an unintialized ownership slot.
298      */
299     error OwnershipNotInitializedForExtraData();
300 
301     // =============================================================
302     //                            STRUCTS
303     // =============================================================
304 
305     struct TokenOwnership {
306         // The address of the owner.
307         address addr;
308         // Stores the start time of ownership with minimal overhead for tokenomics.
309         uint64 startTimestamp;
310         // Whether the token has been burned.
311         bool burned;
312         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
313         uint24 extraData;
314     }
315 
316     // =============================================================
317     //                         TOKEN COUNTERS
318     // =============================================================
319 
320     /**
321      * @dev Returns the total number of tokens in existence.
322      * Burned tokens will reduce the count.
323      * To get the total number of tokens minted, please see {_totalMinted}.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     // =============================================================
328     //                            IERC165
329     // =============================================================
330 
331     /**
332      * @dev Returns true if this contract implements the interface defined by
333      * `interfaceId`. See the corresponding
334      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
335      * to learn more about how these ids are created.
336      *
337      * This function call must use less than 30000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) external view returns (bool);
340 
341     // =============================================================
342     //                            IERC721
343     // =============================================================
344 
345     /**
346      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
352      */
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when `owner` enables or disables
357      * (`approved`) `operator` to manage all of its assets.
358      */
359     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
360 
361     /**
362      * @dev Returns the number of tokens in `owner`'s account.
363      */
364     function balanceOf(address owner) external view returns (uint256 balance);
365 
366     /**
367      * @dev Returns the owner of the `tokenId` token.
368      *
369      * Requirements:
370      *
371      * - `tokenId` must exist.
372      */
373     function ownerOf(uint256 tokenId) external view returns (address owner);
374 
375     /**
376      * @dev Safely transfers `tokenId` token from `from` to `to`,
377      * checking first that contract recipients are aware of the ERC721 protocol
378      * to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move
386      * this token by either {approve} or {setApprovalForAll}.
387      * - If `to` refers to a smart contract, it must implement
388      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId,
396         bytes calldata data
397     ) external payable;
398 
399     /**
400      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
401      */
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) external payable;
407 
408     /**
409      * @dev Transfers `tokenId` from `from` to `to`.
410      *
411      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
412      * whenever possible.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token
420      * by either {approve} or {setApprovalForAll}.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external payable;
429 
430     /**
431      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
432      * The approval is cleared when the token is transferred.
433      *
434      * Only a single account can be approved at a time, so approving the
435      * zero address clears previous approvals.
436      *
437      * Requirements:
438      *
439      * - The caller must own the token or be an approved operator.
440      * - `tokenId` must exist.
441      *
442      * Emits an {Approval} event.
443      */
444     function approve(address to, uint256 tokenId) external payable;
445 
446     /**
447      * @dev Approve or remove `operator` as an operator for the caller.
448      * Operators can call {transferFrom} or {safeTransferFrom}
449      * for any token owned by the caller.
450      *
451      * Requirements:
452      *
453      * - The `operator` cannot be the caller.
454      *
455      * Emits an {ApprovalForAll} event.
456      */
457     function setApprovalForAll(address operator, bool _approved) external;
458 
459     /**
460      * @dev Returns the account approved for `tokenId` token.
461      *
462      * Requirements:
463      *
464      * - `tokenId` must exist.
465      */
466     function getApproved(uint256 tokenId) external view returns (address operator);
467 
468     /**
469      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
470      *
471      * See {setApprovalForAll}.
472      */
473     function isApprovedForAll(address owner, address operator) external view returns (bool);
474 
475     // =============================================================
476     //                        IERC721Metadata
477     // =============================================================
478 
479     /**
480      * @dev Returns the token collection name.
481      */
482     function name() external view returns (string memory);
483 
484     /**
485      * @dev Returns the token collection symbol.
486      */
487     function symbol() external view returns (string memory);
488 
489     /**
490      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
491      */
492     function tokenURI(uint256 tokenId) external view returns (string memory);
493 
494     // =============================================================
495     //                           IERC2309
496     // =============================================================
497 
498     /**
499      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
500      * (inclusive) is transferred from `from` to `to`, as defined in the
501      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
502      *
503      * See {_mintERC2309} for more details.
504      */
505     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
506 }
507 
508 // File: erc721a/contracts/ERC721A.sol
509 
510 
511 // ERC721A Contracts v4.2.3
512 // Creator: Chiru Labs
513 
514 pragma solidity ^0.8.4;
515 
516 
517 /**
518  * @dev Interface of ERC721 token receiver.
519  */
520 interface ERC721A__IERC721Receiver {
521     function onERC721Received(
522         address operator,
523         address from,
524         uint256 tokenId,
525         bytes calldata data
526     ) external returns (bytes4);
527 }
528 
529 /**
530  * @title ERC721A
531  *
532  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
533  * Non-Fungible Token Standard, including the Metadata extension.
534  * Optimized for lower gas during batch mints.
535  *
536  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
537  * starting from `_startTokenId()`.
538  *
539  * Assumptions:
540  *
541  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
542  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
543  */
544 contract ERC721A is IERC721A {
545     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
546     struct TokenApprovalRef {
547         address value;
548     }
549 
550     // =============================================================
551     //                           CONSTANTS
552     // =============================================================
553 
554     // Mask of an entry in packed address data.
555     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
556 
557     // The bit position of `numberMinted` in packed address data.
558     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
559 
560     // The bit position of `numberBurned` in packed address data.
561     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
562 
563     // The bit position of `aux` in packed address data.
564     uint256 private constant _BITPOS_AUX = 192;
565 
566     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
567     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
568 
569     // The bit position of `startTimestamp` in packed ownership.
570     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
571 
572     // The bit mask of the `burned` bit in packed ownership.
573     uint256 private constant _BITMASK_BURNED = 1 << 224;
574 
575     // The bit position of the `nextInitialized` bit in packed ownership.
576     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
577 
578     // The bit mask of the `nextInitialized` bit in packed ownership.
579     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
580 
581     // The bit position of `extraData` in packed ownership.
582     uint256 private constant _BITPOS_EXTRA_DATA = 232;
583 
584     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
585     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
586 
587     // The mask of the lower 160 bits for addresses.
588     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
589 
590     // The maximum `quantity` that can be minted with {_mintERC2309}.
591     // This limit is to prevent overflows on the address data entries.
592     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
593     // is required to cause an overflow, which is unrealistic.
594     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
595 
596     // The `Transfer` event signature is given by:
597     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
598     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
599         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
600 
601     // =============================================================
602     //                            STORAGE
603     // =============================================================
604 
605     // The next token ID to be minted.
606     uint256 private _currentIndex;
607 
608     // The number of tokens burned.
609     uint256 private _burnCounter;
610 
611     // Token name
612     string private _name;
613 
614     // Token symbol
615     string private _symbol;
616 
617     // Mapping from token ID to ownership details
618     // An empty struct value does not necessarily mean the token is unowned.
619     // See {_packedOwnershipOf} implementation for details.
620     //
621     // Bits Layout:
622     // - [0..159]   `addr`
623     // - [160..223] `startTimestamp`
624     // - [224]      `burned`
625     // - [225]      `nextInitialized`
626     // - [232..255] `extraData`
627     mapping(uint256 => uint256) private _packedOwnerships;
628 
629     // Mapping owner address to address data.
630     //
631     // Bits Layout:
632     // - [0..63]    `balance`
633     // - [64..127]  `numberMinted`
634     // - [128..191] `numberBurned`
635     // - [192..255] `aux`
636     mapping(address => uint256) private _packedAddressData;
637 
638     // Mapping from token ID to approved address.
639     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
640 
641     // Mapping from owner to operator approvals
642     mapping(address => mapping(address => bool)) private _operatorApprovals;
643 
644     // =============================================================
645     //                          CONSTRUCTOR
646     // =============================================================
647 
648     constructor(string memory name_, string memory symbol_) {
649         _name = name_;
650         _symbol = symbol_;
651         _currentIndex = _startTokenId();
652     }
653 
654     // =============================================================
655     //                   TOKEN COUNTING OPERATIONS
656     // =============================================================
657 
658     /**
659      * @dev Returns the starting token ID.
660      * To change the starting token ID, please override this function.
661      */
662     function _startTokenId() internal view virtual returns (uint256) {
663         return 0;
664     }
665 
666     /**
667      * @dev Returns the next token ID to be minted.
668      */
669     function _nextTokenId() internal view virtual returns (uint256) {
670         return _currentIndex;
671     }
672 
673     /**
674      * @dev Returns the total number of tokens in existence.
675      * Burned tokens will reduce the count.
676      * To get the total number of tokens minted, please see {_totalMinted}.
677      */
678     function totalSupply() public view virtual override returns (uint256) {
679         // Counter underflow is impossible as _burnCounter cannot be incremented
680         // more than `_currentIndex - _startTokenId()` times.
681         unchecked {
682             return _currentIndex - _burnCounter - _startTokenId();
683         }
684     }
685 
686     /**
687      * @dev Returns the total amount of tokens minted in the contract.
688      */
689     function _totalMinted() internal view virtual returns (uint256) {
690         // Counter underflow is impossible as `_currentIndex` does not decrement,
691         // and it is initialized to `_startTokenId()`.
692         unchecked {
693             return _currentIndex - _startTokenId();
694         }
695     }
696 
697     /**
698      * @dev Returns the total number of tokens burned.
699      */
700     function _totalBurned() internal view virtual returns (uint256) {
701         return _burnCounter;
702     }
703 
704     // =============================================================
705     //                    ADDRESS DATA OPERATIONS
706     // =============================================================
707 
708     /**
709      * @dev Returns the number of tokens in `owner`'s account.
710      */
711     function balanceOf(address owner) public view virtual override returns (uint256) {
712         if (owner == address(0)) revert BalanceQueryForZeroAddress();
713         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
714     }
715 
716     /**
717      * Returns the number of tokens minted by `owner`.
718      */
719     function _numberMinted(address owner) internal view returns (uint256) {
720         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
721     }
722 
723     /**
724      * Returns the number of tokens burned by or on behalf of `owner`.
725      */
726     function _numberBurned(address owner) internal view returns (uint256) {
727         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
728     }
729 
730     /**
731      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
732      */
733     function _getAux(address owner) internal view returns (uint64) {
734         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
735     }
736 
737     /**
738      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
739      * If there are multiple variables, please pack them into a uint64.
740      */
741     function _setAux(address owner, uint64 aux) internal virtual {
742         uint256 packed = _packedAddressData[owner];
743         uint256 auxCasted;
744         // Cast `aux` with assembly to avoid redundant masking.
745         assembly {
746             auxCasted := aux
747         }
748         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
749         _packedAddressData[owner] = packed;
750     }
751 
752     // =============================================================
753     //                            IERC165
754     // =============================================================
755 
756     /**
757      * @dev Returns true if this contract implements the interface defined by
758      * `interfaceId`. See the corresponding
759      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
760      * to learn more about how these ids are created.
761      *
762      * This function call must use less than 30000 gas.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765         // The interface IDs are constants representing the first 4 bytes
766         // of the XOR of all function selectors in the interface.
767         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
768         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
769         return
770             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
771             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
772             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
773     }
774 
775     // =============================================================
776     //                        IERC721Metadata
777     // =============================================================
778 
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() public view virtual override returns (string memory) {
783         return _name;
784     }
785 
786     /**
787      * @dev Returns the token collection symbol.
788      */
789     function symbol() public view virtual override returns (string memory) {
790         return _symbol;
791     }
792 
793     /**
794      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
795      */
796     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
797         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
798 
799         string memory baseURI = _baseURI();
800         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
801     }
802 
803     /**
804      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806      * by default, it can be overridden in child contracts.
807      */
808     function _baseURI() internal view virtual returns (string memory) {
809         return '';
810     }
811 
812     // =============================================================
813     //                     OWNERSHIPS OPERATIONS
814     // =============================================================
815 
816     /**
817      * @dev Returns the owner of the `tokenId` token.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
824         return address(uint160(_packedOwnershipOf(tokenId)));
825     }
826 
827     /**
828      * @dev Gas spent here starts off proportional to the maximum mint batch size.
829      * It gradually moves to O(1) as tokens get transferred around over time.
830      */
831     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
832         return _unpackedOwnership(_packedOwnershipOf(tokenId));
833     }
834 
835     /**
836      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
837      */
838     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
839         return _unpackedOwnership(_packedOwnerships[index]);
840     }
841 
842     /**
843      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
844      */
845     function _initializeOwnershipAt(uint256 index) internal virtual {
846         if (_packedOwnerships[index] == 0) {
847             _packedOwnerships[index] = _packedOwnershipOf(index);
848         }
849     }
850 
851     /**
852      * Returns the packed ownership data of `tokenId`.
853      */
854     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
855         uint256 curr = tokenId;
856 
857         unchecked {
858             if (_startTokenId() <= curr)
859                 if (curr < _currentIndex) {
860                     uint256 packed = _packedOwnerships[curr];
861                     // If not burned.
862                     if (packed & _BITMASK_BURNED == 0) {
863                         // Invariant:
864                         // There will always be an initialized ownership slot
865                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
866                         // before an unintialized ownership slot
867                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
868                         // Hence, `curr` will not underflow.
869                         //
870                         // We can directly compare the packed value.
871                         // If the address is zero, packed will be zero.
872                         while (packed == 0) {
873                             packed = _packedOwnerships[--curr];
874                         }
875                         return packed;
876                     }
877                 }
878         }
879         revert OwnerQueryForNonexistentToken();
880     }
881 
882     /**
883      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
884      */
885     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
886         ownership.addr = address(uint160(packed));
887         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
888         ownership.burned = packed & _BITMASK_BURNED != 0;
889         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
890     }
891 
892     /**
893      * @dev Packs ownership data into a single uint256.
894      */
895     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
896         assembly {
897             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
898             owner := and(owner, _BITMASK_ADDRESS)
899             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
900             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
901         }
902     }
903 
904     /**
905      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
906      */
907     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
908         // For branchless setting of the `nextInitialized` flag.
909         assembly {
910             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
911             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
912         }
913     }
914 
915     // =============================================================
916     //                      APPROVAL OPERATIONS
917     // =============================================================
918 
919     /**
920      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
921      * The approval is cleared when the token is transferred.
922      *
923      * Only a single account can be approved at a time, so approving the
924      * zero address clears previous approvals.
925      *
926      * Requirements:
927      *
928      * - The caller must own the token or be an approved operator.
929      * - `tokenId` must exist.
930      *
931      * Emits an {Approval} event.
932      */
933     function approve(address to, uint256 tokenId) public payable virtual override {
934         address owner = ownerOf(tokenId);
935 
936         if (_msgSenderERC721A() != owner)
937             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
938                 revert ApprovalCallerNotOwnerNorApproved();
939             }
940 
941         _tokenApprovals[tokenId].value = to;
942         emit Approval(owner, to, tokenId);
943     }
944 
945     /**
946      * @dev Returns the account approved for `tokenId` token.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function getApproved(uint256 tokenId) public view virtual override returns (address) {
953         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
954 
955         return _tokenApprovals[tokenId].value;
956     }
957 
958     /**
959      * @dev Approve or remove `operator` as an operator for the caller.
960      * Operators can call {transferFrom} or {safeTransferFrom}
961      * for any token owned by the caller.
962      *
963      * Requirements:
964      *
965      * - The `operator` cannot be the caller.
966      *
967      * Emits an {ApprovalForAll} event.
968      */
969     function setApprovalForAll(address operator, bool approved) public virtual override {
970         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
971         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
972     }
973 
974     /**
975      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
976      *
977      * See {setApprovalForAll}.
978      */
979     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
980         return _operatorApprovals[owner][operator];
981     }
982 
983     /**
984      * @dev Returns whether `tokenId` exists.
985      *
986      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
987      *
988      * Tokens start existing when they are minted. See {_mint}.
989      */
990     function _exists(uint256 tokenId) internal view virtual returns (bool) {
991         return
992             _startTokenId() <= tokenId &&
993             tokenId < _currentIndex && // If within bounds,
994             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
995     }
996 
997     /**
998      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
999      */
1000     function _isSenderApprovedOrOwner(
1001         address approvedAddress,
1002         address owner,
1003         address msgSender
1004     ) private pure returns (bool result) {
1005         assembly {
1006             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1007             owner := and(owner, _BITMASK_ADDRESS)
1008             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1009             msgSender := and(msgSender, _BITMASK_ADDRESS)
1010             // `msgSender == owner || msgSender == approvedAddress`.
1011             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1012         }
1013     }
1014 
1015     /**
1016      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1017      */
1018     function _getApprovedSlotAndAddress(uint256 tokenId)
1019         private
1020         view
1021         returns (uint256 approvedAddressSlot, address approvedAddress)
1022     {
1023         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1024         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1025         assembly {
1026             approvedAddressSlot := tokenApproval.slot
1027             approvedAddress := sload(approvedAddressSlot)
1028         }
1029     }
1030 
1031     // =============================================================
1032     //                      TRANSFER OPERATIONS
1033     // =============================================================
1034 
1035     /**
1036      * @dev Transfers `tokenId` from `from` to `to`.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must be owned by `from`.
1043      * - If the caller is not `from`, it must be approved to move this token
1044      * by either {approve} or {setApprovalForAll}.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function transferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public payable virtual override {
1053         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1054 
1055         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1056 
1057         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1058 
1059         // The nested ifs save around 20+ gas over a compound boolean condition.
1060         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1061             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1062 
1063         if (to == address(0)) revert TransferToZeroAddress();
1064 
1065         _beforeTokenTransfers(from, to, tokenId, 1);
1066 
1067         // Clear approvals from the previous owner.
1068         assembly {
1069             if approvedAddress {
1070                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1071                 sstore(approvedAddressSlot, 0)
1072             }
1073         }
1074 
1075         // Underflow of the sender's balance is impossible because we check for
1076         // ownership above and the recipient's balance can't realistically overflow.
1077         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1078         unchecked {
1079             // We can directly increment and decrement the balances.
1080             --_packedAddressData[from]; // Updates: `balance -= 1`.
1081             ++_packedAddressData[to]; // Updates: `balance += 1`.
1082 
1083             // Updates:
1084             // - `address` to the next owner.
1085             // - `startTimestamp` to the timestamp of transfering.
1086             // - `burned` to `false`.
1087             // - `nextInitialized` to `true`.
1088             _packedOwnerships[tokenId] = _packOwnershipData(
1089                 to,
1090                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1091             );
1092 
1093             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1094             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1095                 uint256 nextTokenId = tokenId + 1;
1096                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1097                 if (_packedOwnerships[nextTokenId] == 0) {
1098                     // If the next slot is within bounds.
1099                     if (nextTokenId != _currentIndex) {
1100                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1101                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1102                     }
1103                 }
1104             }
1105         }
1106 
1107         emit Transfer(from, to, tokenId);
1108         _afterTokenTransfers(from, to, tokenId, 1);
1109     }
1110 
1111     /**
1112      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1113      */
1114     function safeTransferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) public payable virtual override {
1119         safeTransferFrom(from, to, tokenId, '');
1120     }
1121 
1122     /**
1123      * @dev Safely transfers `tokenId` token from `from` to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `from` cannot be the zero address.
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must exist and be owned by `from`.
1130      * - If the caller is not `from`, it must be approved to move this token
1131      * by either {approve} or {setApprovalForAll}.
1132      * - If `to` refers to a smart contract, it must implement
1133      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function safeTransferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId,
1141         bytes memory _data
1142     ) public payable virtual override {
1143         transferFrom(from, to, tokenId);
1144         if (to.code.length != 0)
1145             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1146                 revert TransferToNonERC721ReceiverImplementer();
1147             }
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before a set of serially-ordered token IDs
1152      * are about to be transferred. This includes minting.
1153      * And also called before burning one token.
1154      *
1155      * `startTokenId` - the first token ID to be transferred.
1156      * `quantity` - the amount to be transferred.
1157      *
1158      * Calling conditions:
1159      *
1160      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1161      * transferred to `to`.
1162      * - When `from` is zero, `tokenId` will be minted for `to`.
1163      * - When `to` is zero, `tokenId` will be burned by `from`.
1164      * - `from` and `to` are never both zero.
1165      */
1166     function _beforeTokenTransfers(
1167         address from,
1168         address to,
1169         uint256 startTokenId,
1170         uint256 quantity
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Hook that is called after a set of serially-ordered token IDs
1175      * have been transferred. This includes minting.
1176      * And also called after one token has been burned.
1177      *
1178      * `startTokenId` - the first token ID to be transferred.
1179      * `quantity` - the amount to be transferred.
1180      *
1181      * Calling conditions:
1182      *
1183      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1184      * transferred to `to`.
1185      * - When `from` is zero, `tokenId` has been minted for `to`.
1186      * - When `to` is zero, `tokenId` has been burned by `from`.
1187      * - `from` and `to` are never both zero.
1188      */
1189     function _afterTokenTransfers(
1190         address from,
1191         address to,
1192         uint256 startTokenId,
1193         uint256 quantity
1194     ) internal virtual {}
1195 
1196     /**
1197      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1198      *
1199      * `from` - Previous owner of the given token ID.
1200      * `to` - Target address that will receive the token.
1201      * `tokenId` - Token ID to be transferred.
1202      * `_data` - Optional data to send along with the call.
1203      *
1204      * Returns whether the call correctly returned the expected magic value.
1205      */
1206     function _checkContractOnERC721Received(
1207         address from,
1208         address to,
1209         uint256 tokenId,
1210         bytes memory _data
1211     ) private returns (bool) {
1212         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1213             bytes4 retval
1214         ) {
1215             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1216         } catch (bytes memory reason) {
1217             if (reason.length == 0) {
1218                 revert TransferToNonERC721ReceiverImplementer();
1219             } else {
1220                 assembly {
1221                     revert(add(32, reason), mload(reason))
1222                 }
1223             }
1224         }
1225     }
1226 
1227     // =============================================================
1228     //                        MINT OPERATIONS
1229     // =============================================================
1230 
1231     /**
1232      * @dev Mints `quantity` tokens and transfers them to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - `to` cannot be the zero address.
1237      * - `quantity` must be greater than 0.
1238      *
1239      * Emits a {Transfer} event for each mint.
1240      */
1241     function _mint(address to, uint256 quantity) internal virtual {
1242         uint256 startTokenId = _currentIndex;
1243         if (quantity == 0) revert MintZeroQuantity();
1244 
1245         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1246 
1247         // Overflows are incredibly unrealistic.
1248         // `balance` and `numberMinted` have a maximum limit of 2**64.
1249         // `tokenId` has a maximum limit of 2**256.
1250         unchecked {
1251             // Updates:
1252             // - `balance += quantity`.
1253             // - `numberMinted += quantity`.
1254             //
1255             // We can directly add to the `balance` and `numberMinted`.
1256             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1257 
1258             // Updates:
1259             // - `address` to the owner.
1260             // - `startTimestamp` to the timestamp of minting.
1261             // - `burned` to `false`.
1262             // - `nextInitialized` to `quantity == 1`.
1263             _packedOwnerships[startTokenId] = _packOwnershipData(
1264                 to,
1265                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1266             );
1267 
1268             uint256 toMasked;
1269             uint256 end = startTokenId + quantity;
1270 
1271             // Use assembly to loop and emit the `Transfer` event for gas savings.
1272             // The duplicated `log4` removes an extra check and reduces stack juggling.
1273             // The assembly, together with the surrounding Solidity code, have been
1274             // delicately arranged to nudge the compiler into producing optimized opcodes.
1275             assembly {
1276                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1277                 toMasked := and(to, _BITMASK_ADDRESS)
1278                 // Emit the `Transfer` event.
1279                 log4(
1280                     0, // Start of data (0, since no data).
1281                     0, // End of data (0, since no data).
1282                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1283                     0, // `address(0)`.
1284                     toMasked, // `to`.
1285                     startTokenId // `tokenId`.
1286                 )
1287 
1288                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1289                 // that overflows uint256 will make the loop run out of gas.
1290                 // The compiler will optimize the `iszero` away for performance.
1291                 for {
1292                     let tokenId := add(startTokenId, 1)
1293                 } iszero(eq(tokenId, end)) {
1294                     tokenId := add(tokenId, 1)
1295                 } {
1296                     // Emit the `Transfer` event. Similar to above.
1297                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1298                 }
1299             }
1300             if (toMasked == 0) revert MintToZeroAddress();
1301 
1302             _currentIndex = end;
1303         }
1304         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1305     }
1306 
1307     /**
1308      * @dev Mints `quantity` tokens and transfers them to `to`.
1309      *
1310      * This function is intended for efficient minting only during contract creation.
1311      *
1312      * It emits only one {ConsecutiveTransfer} as defined in
1313      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1314      * instead of a sequence of {Transfer} event(s).
1315      *
1316      * Calling this function outside of contract creation WILL make your contract
1317      * non-compliant with the ERC721 standard.
1318      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1319      * {ConsecutiveTransfer} event is only permissible during contract creation.
1320      *
1321      * Requirements:
1322      *
1323      * - `to` cannot be the zero address.
1324      * - `quantity` must be greater than 0.
1325      *
1326      * Emits a {ConsecutiveTransfer} event.
1327      */
1328     function _mintERC2309(address to, uint256 quantity) internal virtual {
1329         uint256 startTokenId = _currentIndex;
1330         if (to == address(0)) revert MintToZeroAddress();
1331         if (quantity == 0) revert MintZeroQuantity();
1332         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1333 
1334         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1335 
1336         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1337         unchecked {
1338             // Updates:
1339             // - `balance += quantity`.
1340             // - `numberMinted += quantity`.
1341             //
1342             // We can directly add to the `balance` and `numberMinted`.
1343             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1344 
1345             // Updates:
1346             // - `address` to the owner.
1347             // - `startTimestamp` to the timestamp of minting.
1348             // - `burned` to `false`.
1349             // - `nextInitialized` to `quantity == 1`.
1350             _packedOwnerships[startTokenId] = _packOwnershipData(
1351                 to,
1352                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1353             );
1354 
1355             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1356 
1357             _currentIndex = startTokenId + quantity;
1358         }
1359         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1360     }
1361 
1362     /**
1363      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1364      *
1365      * Requirements:
1366      *
1367      * - If `to` refers to a smart contract, it must implement
1368      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1369      * - `quantity` must be greater than 0.
1370      *
1371      * See {_mint}.
1372      *
1373      * Emits a {Transfer} event for each mint.
1374      */
1375     function _safeMint(
1376         address to,
1377         uint256 quantity,
1378         bytes memory _data
1379     ) internal virtual {
1380         _mint(to, quantity);
1381 
1382         unchecked {
1383             if (to.code.length != 0) {
1384                 uint256 end = _currentIndex;
1385                 uint256 index = end - quantity;
1386                 do {
1387                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1388                         revert TransferToNonERC721ReceiverImplementer();
1389                     }
1390                 } while (index < end);
1391                 // Reentrancy protection.
1392                 if (_currentIndex != end) revert();
1393             }
1394         }
1395     }
1396 
1397     /**
1398      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1399      */
1400     function _safeMint(address to, uint256 quantity) internal virtual {
1401         _safeMint(to, quantity, '');
1402     }
1403 
1404     // =============================================================
1405     //                        BURN OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Equivalent to `_burn(tokenId, false)`.
1410      */
1411     function _burn(uint256 tokenId) internal virtual {
1412         _burn(tokenId, false);
1413     }
1414 
1415     /**
1416      * @dev Destroys `tokenId`.
1417      * The approval is cleared when the token is burned.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1426         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1427 
1428         address from = address(uint160(prevOwnershipPacked));
1429 
1430         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1431 
1432         if (approvalCheck) {
1433             // The nested ifs save around 20+ gas over a compound boolean condition.
1434             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1435                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1436         }
1437 
1438         _beforeTokenTransfers(from, address(0), tokenId, 1);
1439 
1440         // Clear approvals from the previous owner.
1441         assembly {
1442             if approvedAddress {
1443                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1444                 sstore(approvedAddressSlot, 0)
1445             }
1446         }
1447 
1448         // Underflow of the sender's balance is impossible because we check for
1449         // ownership above and the recipient's balance can't realistically overflow.
1450         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1451         unchecked {
1452             // Updates:
1453             // - `balance -= 1`.
1454             // - `numberBurned += 1`.
1455             //
1456             // We can directly decrement the balance, and increment the number burned.
1457             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1458             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1459 
1460             // Updates:
1461             // - `address` to the last owner.
1462             // - `startTimestamp` to the timestamp of burning.
1463             // - `burned` to `true`.
1464             // - `nextInitialized` to `true`.
1465             _packedOwnerships[tokenId] = _packOwnershipData(
1466                 from,
1467                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1468             );
1469 
1470             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1471             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1472                 uint256 nextTokenId = tokenId + 1;
1473                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1474                 if (_packedOwnerships[nextTokenId] == 0) {
1475                     // If the next slot is within bounds.
1476                     if (nextTokenId != _currentIndex) {
1477                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1478                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1479                     }
1480                 }
1481             }
1482         }
1483 
1484         emit Transfer(from, address(0), tokenId);
1485         _afterTokenTransfers(from, address(0), tokenId, 1);
1486 
1487         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1488         unchecked {
1489             _burnCounter++;
1490         }
1491     }
1492 
1493     // =============================================================
1494     //                     EXTRA DATA OPERATIONS
1495     // =============================================================
1496 
1497     /**
1498      * @dev Directly sets the extra data for the ownership data `index`.
1499      */
1500     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1501         uint256 packed = _packedOwnerships[index];
1502         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1503         uint256 extraDataCasted;
1504         // Cast `extraData` with assembly to avoid redundant masking.
1505         assembly {
1506             extraDataCasted := extraData
1507         }
1508         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1509         _packedOwnerships[index] = packed;
1510     }
1511 
1512     /**
1513      * @dev Called during each token transfer to set the 24bit `extraData` field.
1514      * Intended to be overridden by the cosumer contract.
1515      *
1516      * `previousExtraData` - the value of `extraData` before transfer.
1517      *
1518      * Calling conditions:
1519      *
1520      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1521      * transferred to `to`.
1522      * - When `from` is zero, `tokenId` will be minted for `to`.
1523      * - When `to` is zero, `tokenId` will be burned by `from`.
1524      * - `from` and `to` are never both zero.
1525      */
1526     function _extraData(
1527         address from,
1528         address to,
1529         uint24 previousExtraData
1530     ) internal view virtual returns (uint24) {}
1531 
1532     /**
1533      * @dev Returns the next extra data for the packed ownership data.
1534      * The returned result is shifted into position.
1535      */
1536     function _nextExtraData(
1537         address from,
1538         address to,
1539         uint256 prevOwnershipPacked
1540     ) private view returns (uint256) {
1541         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1542         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1543     }
1544 
1545     // =============================================================
1546     //                       OTHER OPERATIONS
1547     // =============================================================
1548 
1549     /**
1550      * @dev Returns the message sender (defaults to `msg.sender`).
1551      *
1552      * If you are writing GSN compatible contracts, you need to override this function.
1553      */
1554     function _msgSenderERC721A() internal view virtual returns (address) {
1555         return msg.sender;
1556     }
1557 
1558     /**
1559      * @dev Converts a uint256 to its ASCII string decimal representation.
1560      */
1561     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1562         assembly {
1563             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1564             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1565             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1566             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1567             let m := add(mload(0x40), 0xa0)
1568             // Update the free memory pointer to allocate.
1569             mstore(0x40, m)
1570             // Assign the `str` to the end.
1571             str := sub(m, 0x20)
1572             // Zeroize the slot after the string.
1573             mstore(str, 0)
1574 
1575             // Cache the end of the memory to calculate the length later.
1576             let end := str
1577 
1578             // We write the string from rightmost digit to leftmost digit.
1579             // The following is essentially a do-while loop that also handles the zero case.
1580             // prettier-ignore
1581             for { let temp := value } 1 {} {
1582                 str := sub(str, 1)
1583                 // Write the character to the pointer.
1584                 // The ASCII index of the '0' character is 48.
1585                 mstore8(str, add(48, mod(temp, 10)))
1586                 // Keep dividing `temp` until zero.
1587                 temp := div(temp, 10)
1588                 // prettier-ignore
1589                 if iszero(temp) { break }
1590             }
1591 
1592             let length := sub(end, str)
1593             // Move the pointer 32 bytes leftwards to make room for the length.
1594             str := sub(str, 0x20)
1595             // Store the length.
1596             mstore(str, length)
1597         }
1598     }
1599 }
1600 
1601 // File: contracts/Yempegs.sol
1602 
1603 
1604 pragma solidity ^0.8.4;
1605 
1606 
1607 
1608 
1609 contract Yempegs is ERC721A, Ownable, DefaultOperatorFilterer {
1610     uint256 public maxSupply = 3333;
1611     uint256 public teamSupply = 33;
1612     uint256 public price = 0.002 ether;
1613     uint256 public maxPerTx = 10;
1614     uint256 public maxPerWallet = 10;
1615     uint256 public maxFreeSupply = 2222;
1616     uint256 public maxFreePerWallet = 1;
1617     uint256 public freeMints = 0;
1618     bool public saleStarted = false;
1619     string public uriSuffix = ".json";
1620     string public baseURI = "ipfs://bafybeiaqqaauiqt5yiwzd7wgthgild5s4ua2nzxraywwb6sze2n72lc4ri/";
1621 
1622     constructor(string memory _name, string memory _symbol) ERC721A(_name, _symbol) {}
1623 
1624     function numberMinted(address owner) public view returns (uint256) {
1625         return _numberMinted(owner);
1626     }
1627 
1628     function updatePrice(uint256 __price) public onlyOwner {
1629         price = __price;
1630     }
1631 
1632     function mintPublic(uint256 amount) external payable {
1633         require(saleStarted, "Sale is not active.");
1634         require(amount <= maxPerTx, "Should not exceed max mint number!");
1635         require(totalSupply() + amount <= maxSupply, "Should not exceed max supply.");
1636         require(numberMinted(msg.sender) + amount <= maxPerWallet, "Should not exceed max per wallet.");
1637 
1638         uint256 freeMintCount = 0;
1639         bool isFreeMint = false;
1640         if (freeMints < maxFreeSupply) {
1641             freeMintCount = maxFreePerWallet;
1642         }
1643 
1644         uint256 count = amount;
1645         if (numberMinted(msg.sender) < freeMintCount) {
1646             if (numberMinted(msg.sender) + amount <= freeMintCount) {
1647                 count = 0;
1648             }                
1649             else {
1650                 count = numberMinted(msg.sender) + amount - freeMintCount;
1651             }
1652             isFreeMint = true;
1653         }
1654 
1655         require(msg.value >= count * price, "Ether value is not enough");
1656         
1657         if(isFreeMint) freeMints += 1;
1658 
1659         _safeMint(msg.sender, amount);
1660     }
1661 
1662     function mintForTeam(uint256 amount) external onlyOwner {
1663         require(teamSupply > 0,"Should not exceed mint limit");
1664         require(amount <= teamSupply,"Should not exceed mint limit");
1665         require(totalSupply() + amount <= maxSupply, "Should not exceed max supply.");
1666         teamSupply -= amount;
1667         _safeMint(msg.sender, amount);
1668     }
1669 
1670     function _baseURI() internal view override returns (string memory) {
1671         return baseURI;
1672     }
1673 
1674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1675         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1676         
1677         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), uriSuffix)) : '';
1678     }
1679 
1680     function toggleSale() external onlyOwner {
1681         saleStarted = !saleStarted;
1682     }
1683 
1684     function setFreeMintStart() external onlyOwner {
1685         freeMints = 0;
1686     }
1687 
1688     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1689         baseURI = newBaseURI;
1690     }
1691 
1692     function setMaxSupply(uint256 amount) external onlyOwner {
1693         maxSupply = amount;
1694     }
1695 
1696     function setTeamSupply(uint256 amount) external onlyOwner {
1697         teamSupply = amount;
1698     }
1699 
1700     function setMaxFreeSupply(uint256 amount) external onlyOwner {
1701         maxFreeSupply = amount;
1702     }
1703 
1704     function setMaxFreePerWallet(uint256 amount) external onlyOwner {
1705         maxFreePerWallet = amount;
1706     }
1707 
1708     function withdraw() external onlyOwner {
1709         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1710         require(success, "Failed to send Ether");
1711     }
1712 
1713     /////////////////////////////
1714     // OPENSEA FILTER REGISTRY 
1715     /////////////////////////////
1716 
1717     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1718         super.setApprovalForAll(operator, approved);
1719     }
1720 
1721     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1722         super.approve(operator, tokenId);
1723     }
1724 
1725     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1726         super.transferFrom(from, to, tokenId);
1727     }
1728 
1729     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1730         super.safeTransferFrom(from, to, tokenId);
1731     }
1732 
1733     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1734         public
1735         payable
1736         override
1737         onlyAllowedOperator(from)
1738     {
1739         super.safeTransferFrom(from, to, tokenId, data);
1740     }
1741 }