1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 // SPDX-License-Identifier: GPL-3.0
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
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
113 // File: erc721a/contracts/IERC721A.sol
114 
115 
116 // ERC721A Contracts v4.2.2
117 // Creator: Chiru Labs
118 
119 pragma solidity ^0.8.4;
120 
121 /**
122  * @dev Interface of ERC721A.
123  */
124 interface IERC721A {
125     /**
126      * The caller must own the token or be an approved operator.
127      */
128     error ApprovalCallerNotOwnerNorApproved();
129 
130     /**
131      * The token does not exist.
132      */
133     error ApprovalQueryForNonexistentToken();
134 
135     /**
136      * The caller cannot approve to their own address.
137      */
138     error ApproveToCaller();
139 
140     /**
141      * Cannot query the balance for the zero address.
142      */
143     error BalanceQueryForZeroAddress();
144 
145     /**
146      * Cannot mint to the zero address.
147      */
148     error MintToZeroAddress();
149 
150     /**
151      * The quantity of tokens minted must be more than zero.
152      */
153     error MintZeroQuantity();
154 
155     /**
156      * The token does not exist.
157      */
158     error OwnerQueryForNonexistentToken();
159 
160     /**
161      * The caller must own the token or be an approved operator.
162      */
163     error TransferCallerNotOwnerNorApproved();
164 
165     /**
166      * The token must be owned by `from`.
167      */
168     error TransferFromIncorrectOwner();
169 
170     /**
171      * Cannot safely transfer to a contract that does not implement the
172      * ERC721Receiver interface.
173      */
174     error TransferToNonERC721ReceiverImplementer();
175 
176     /**
177      * Cannot transfer to the zero address.
178      */
179     error TransferToZeroAddress();
180 
181     /**
182      * The token does not exist.
183      */
184     error URIQueryForNonexistentToken();
185 
186     /**
187      * The `quantity` minted with ERC2309 exceeds the safety limit.
188      */
189     error MintERC2309QuantityExceedsLimit();
190 
191     /**
192      * The `extraData` cannot be set on an unintialized ownership slot.
193      */
194     error OwnershipNotInitializedForExtraData();
195 
196     // =============================================================
197     //                            STRUCTS
198     // =============================================================
199 
200     struct TokenOwnership {
201         // The address of the owner.
202         address addr;
203         // Stores the start time of ownership with minimal overhead for tokenomics.
204         uint64 startTimestamp;
205         // Whether the token has been burned.
206         bool burned;
207         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
208         uint24 extraData;
209     }
210 
211     // =============================================================
212     //                         TOKEN COUNTERS
213     // =============================================================
214 
215     /**
216      * @dev Returns the total number of tokens in existence.
217      * Burned tokens will reduce the count.
218      * To get the total number of tokens minted, please see {_totalMinted}.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     // =============================================================
223     //                            IERC165
224     // =============================================================
225 
226     /**
227      * @dev Returns true if this contract implements the interface defined by
228      * `interfaceId`. See the corresponding
229      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
230      * to learn more about how these ids are created.
231      *
232      * This function call must use less than 30000 gas.
233      */
234     function supportsInterface(bytes4 interfaceId) external view returns (bool);
235 
236     // =============================================================
237     //                            IERC721
238     // =============================================================
239 
240     /**
241      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
247      */
248     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
249 
250     /**
251      * @dev Emitted when `owner` enables or disables
252      * (`approved`) `operator` to manage all of its assets.
253      */
254     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
255 
256     /**
257      * @dev Returns the number of tokens in `owner`'s account.
258      */
259     function balanceOf(address owner) external view returns (uint256 balance);
260 
261     /**
262      * @dev Returns the owner of the `tokenId` token.
263      *
264      * Requirements:
265      *
266      * - `tokenId` must exist.
267      */
268     function ownerOf(uint256 tokenId) external view returns (address owner);
269 
270     /**
271      * @dev Safely transfers `tokenId` token from `from` to `to`,
272      * checking first that contract recipients are aware of the ERC721 protocol
273      * to prevent tokens from being forever locked.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must exist and be owned by `from`.
280      * - If the caller is not `from`, it must be have been allowed to move
281      * this token by either {approve} or {setApprovalForAll}.
282      * - If `to` refers to a smart contract, it must implement
283      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId,
291         bytes calldata data
292     ) external;
293 
294     /**
295      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Transfers `tokenId` from `from` to `to`.
305      *
306      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
307      * whenever possible.
308      *
309      * Requirements:
310      *
311      * - `from` cannot be the zero address.
312      * - `to` cannot be the zero address.
313      * - `tokenId` token must be owned by `from`.
314      * - If the caller is not `from`, it must be approved to move this token
315      * by either {approve} or {setApprovalForAll}.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom(
320         address from,
321         address to,
322         uint256 tokenId
323     ) external;
324 
325     /**
326      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
327      * The approval is cleared when the token is transferred.
328      *
329      * Only a single account can be approved at a time, so approving the
330      * zero address clears previous approvals.
331      *
332      * Requirements:
333      *
334      * - The caller must own the token or be an approved operator.
335      * - `tokenId` must exist.
336      *
337      * Emits an {Approval} event.
338      */
339     function approve(address to, uint256 tokenId) external;
340 
341     /**
342      * @dev Approve or remove `operator` as an operator for the caller.
343      * Operators can call {transferFrom} or {safeTransferFrom}
344      * for any token owned by the caller.
345      *
346      * Requirements:
347      *
348      * - The `operator` cannot be the caller.
349      *
350      * Emits an {ApprovalForAll} event.
351      */
352     function setApprovalForAll(address operator, bool _approved) external;
353 
354     /**
355      * @dev Returns the account approved for `tokenId` token.
356      *
357      * Requirements:
358      *
359      * - `tokenId` must exist.
360      */
361     function getApproved(uint256 tokenId) external view returns (address operator);
362 
363     /**
364      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
365      *
366      * See {setApprovalForAll}.
367      */
368     function isApprovedForAll(address owner, address operator) external view returns (bool);
369 
370     // =============================================================
371     //                        IERC721Metadata
372     // =============================================================
373 
374     /**
375      * @dev Returns the token collection name.
376      */
377     function name() external view returns (string memory);
378 
379     /**
380      * @dev Returns the token collection symbol.
381      */
382     function symbol() external view returns (string memory);
383 
384     /**
385      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
386      */
387     function tokenURI(uint256 tokenId) external view returns (string memory);
388 
389     // =============================================================
390     //                           IERC2309
391     // =============================================================
392 
393     /**
394      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
395      * (inclusive) is transferred from `from` to `to`, as defined in the
396      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
397      *
398      * See {_mintERC2309} for more details.
399      */
400     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
401 }
402 
403 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
404 
405 
406 // ERC721A Contracts v4.2.2
407 // Creator: Chiru Labs
408 
409 pragma solidity ^0.8.4;
410 
411 
412 /**
413  * @dev Interface of ERC721AQueryable.
414  */
415 interface IERC721AQueryable is IERC721A {
416     /**
417      * Invalid query range (`start` >= `stop`).
418      */
419     error InvalidQueryRange();
420 
421     /**
422      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
423      *
424      * If the `tokenId` is out of bounds:
425      *
426      * - `addr = address(0)`
427      * - `startTimestamp = 0`
428      * - `burned = false`
429      * - `extraData = 0`
430      *
431      * If the `tokenId` is burned:
432      *
433      * - `addr = <Address of owner before token was burned>`
434      * - `startTimestamp = <Timestamp when token was burned>`
435      * - `burned = true`
436      * - `extraData = <Extra data when token was burned>`
437      *
438      * Otherwise:
439      *
440      * - `addr = <Address of owner>`
441      * - `startTimestamp = <Timestamp of start of ownership>`
442      * - `burned = false`
443      * - `extraData = <Extra data at start of ownership>`
444      */
445     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
446 
447     /**
448      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
449      * See {ERC721AQueryable-explicitOwnershipOf}
450      */
451     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
452 
453     /**
454      * @dev Returns an array of token IDs owned by `owner`,
455      * in the range [`start`, `stop`)
456      * (i.e. `start <= tokenId < stop`).
457      *
458      * This function allows for tokens to be queried if the collection
459      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
460      *
461      * Requirements:
462      *
463      * - `start < stop`
464      */
465     function tokensOfOwnerIn(
466         address owner,
467         uint256 start,
468         uint256 stop
469     ) external view returns (uint256[] memory);
470 
471     /**
472      * @dev Returns an array of token IDs owned by `owner`.
473      *
474      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
475      * It is meant to be called off-chain.
476      *
477      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
478      * multiple smaller scans if the collection is large enough to cause
479      * an out-of-gas error (10K collections should be fine).
480      */
481     function tokensOfOwner(address owner) external view returns (uint256[] memory);
482 }
483 
484 // File: erc721a/contracts/ERC721A.sol
485 
486 
487 // ERC721A Contracts v4.2.2
488 // Creator: Chiru Labs
489 
490 pragma solidity ^0.8.4;
491 
492 
493 /**
494  * @dev Interface of ERC721 token receiver.
495  */
496 interface ERC721A__IERC721Receiver {
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 /**
506  * @title ERC721A
507  *
508  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
509  * Non-Fungible Token Standard, including the Metadata extension.
510  * Optimized for lower gas during batch mints.
511  *
512  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
513  * starting from `_startTokenId()`.
514  *
515  * Assumptions:
516  *
517  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
518  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
519  */
520 contract ERC721A is IERC721A {
521     // Reference type for token approval.
522     struct TokenApprovalRef {
523         address value;
524     }
525 
526     // =============================================================
527     //                           CONSTANTS
528     // =============================================================
529 
530     // Mask of an entry in packed address data.
531     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
532 
533     // The bit position of `numberMinted` in packed address data.
534     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
535 
536     // The bit position of `numberBurned` in packed address data.
537     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
538 
539     // The bit position of `aux` in packed address data.
540     uint256 private constant _BITPOS_AUX = 192;
541 
542     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
543     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
544 
545     // The bit position of `startTimestamp` in packed ownership.
546     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
547 
548     // The bit mask of the `burned` bit in packed ownership.
549     uint256 private constant _BITMASK_BURNED = 1 << 224;
550 
551     // The bit position of the `nextInitialized` bit in packed ownership.
552     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
553 
554     // The bit mask of the `nextInitialized` bit in packed ownership.
555     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
556 
557     // The bit position of `extraData` in packed ownership.
558     uint256 private constant _BITPOS_EXTRA_DATA = 232;
559 
560     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
561     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
562 
563     // The mask of the lower 160 bits for addresses.
564     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
565 
566     // The maximum `quantity` that can be minted with {_mintERC2309}.
567     // This limit is to prevent overflows on the address data entries.
568     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
569     // is required to cause an overflow, which is unrealistic.
570     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
571 
572     // The `Transfer` event signature is given by:
573     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
574     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
575         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
576 
577     // =============================================================
578     //                            STORAGE
579     // =============================================================
580 
581     // The next token ID to be minted.
582     uint256 private _currentIndex;
583 
584     // The number of tokens burned.
585     uint256 private _burnCounter;
586 
587     // Token name
588     string private _name;
589 
590     // Token symbol
591     string private _symbol;
592 
593     // Mapping from token ID to ownership details
594     // An empty struct value does not necessarily mean the token is unowned.
595     // See {_packedOwnershipOf} implementation for details.
596     //
597     // Bits Layout:
598     // - [0..159]   `addr`
599     // - [160..223] `startTimestamp`
600     // - [224]      `burned`
601     // - [225]      `nextInitialized`
602     // - [232..255] `extraData`
603     mapping(uint256 => uint256) private _packedOwnerships;
604 
605     // Mapping owner address to address data.
606     //
607     // Bits Layout:
608     // - [0..63]    `balance`
609     // - [64..127]  `numberMinted`
610     // - [128..191] `numberBurned`
611     // - [192..255] `aux`
612     mapping(address => uint256) private _packedAddressData;
613 
614     // Mapping from token ID to approved address.
615     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     // =============================================================
621     //                          CONSTRUCTOR
622     // =============================================================
623 
624     constructor(string memory name_, string memory symbol_) {
625         _name = name_;
626         _symbol = symbol_;
627         _currentIndex = _startTokenId();
628     }
629 
630     // =============================================================
631     //                   TOKEN COUNTING OPERATIONS
632     // =============================================================
633 
634     /**
635      * @dev Returns the starting token ID.
636      * To change the starting token ID, please override this function.
637      */
638     function _startTokenId() internal view virtual returns (uint256) {
639         return 0;
640     }
641 
642     /**
643      * @dev Returns the next token ID to be minted.
644      */
645     function _nextTokenId() internal view virtual returns (uint256) {
646         return _currentIndex;
647     }
648 
649     /**
650      * @dev Returns the total number of tokens in existence.
651      * Burned tokens will reduce the count.
652      * To get the total number of tokens minted, please see {_totalMinted}.
653      */
654     function totalSupply() public view virtual override returns (uint256) {
655         // Counter underflow is impossible as _burnCounter cannot be incremented
656         // more than `_currentIndex - _startTokenId()` times.
657         unchecked {
658             return _currentIndex - _burnCounter - _startTokenId();
659         }
660     }
661 
662     /**
663      * @dev Returns the total amount of tokens minted in the contract.
664      */
665     function _totalMinted() internal view virtual returns (uint256) {
666         // Counter underflow is impossible as `_currentIndex` does not decrement,
667         // and it is initialized to `_startTokenId()`.
668         unchecked {
669             return _currentIndex - _startTokenId();
670         }
671     }
672 
673     /**
674      * @dev Returns the total number of tokens burned.
675      */
676     function _totalBurned() internal view virtual returns (uint256) {
677         return _burnCounter;
678     }
679 
680     // =============================================================
681     //                    ADDRESS DATA OPERATIONS
682     // =============================================================
683 
684     /**
685      * @dev Returns the number of tokens in `owner`'s account.
686      */
687     function balanceOf(address owner) public view virtual override returns (uint256) {
688         if (owner == address(0)) revert BalanceQueryForZeroAddress();
689         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
690     }
691 
692     /**
693      * Returns the number of tokens minted by `owner`.
694      */
695     function _numberMinted(address owner) internal view returns (uint256) {
696         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
697     }
698 
699     /**
700      * Returns the number of tokens burned by or on behalf of `owner`.
701      */
702     function _numberBurned(address owner) internal view returns (uint256) {
703         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
704     }
705 
706     /**
707      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
708      */
709     function _getAux(address owner) internal view returns (uint64) {
710         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
711     }
712 
713     /**
714      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
715      * If there are multiple variables, please pack them into a uint64.
716      */
717     function _setAux(address owner, uint64 aux) internal virtual {
718         uint256 packed = _packedAddressData[owner];
719         uint256 auxCasted;
720         // Cast `aux` with assembly to avoid redundant masking.
721         assembly {
722             auxCasted := aux
723         }
724         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
725         _packedAddressData[owner] = packed;
726     }
727 
728     // =============================================================
729     //                            IERC165
730     // =============================================================
731 
732     /**
733      * @dev Returns true if this contract implements the interface defined by
734      * `interfaceId`. See the corresponding
735      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
736      * to learn more about how these ids are created.
737      *
738      * This function call must use less than 30000 gas.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         // The interface IDs are constants representing the first 4 bytes
742         // of the XOR of all function selectors in the interface.
743         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
744         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
745         return
746             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
747             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
748             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
749     }
750 
751     // =============================================================
752     //                        IERC721Metadata
753     // =============================================================
754 
755     /**
756      * @dev Returns the token collection name.
757      */
758     function name() public view virtual override returns (string memory) {
759         return _name;
760     }
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() public view virtual override returns (string memory) {
766         return _symbol;
767     }
768 
769     /**
770      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
771      */
772     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
773         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
774 
775         string memory baseURI = _baseURI();
776         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
777     }
778 
779     /**
780      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
781      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
782      * by default, it can be overridden in child contracts.
783      */
784     function _baseURI() internal view virtual returns (string memory) {
785         return '';
786     }
787 
788     // =============================================================
789     //                     OWNERSHIPS OPERATIONS
790     // =============================================================
791 
792     /**
793      * @dev Returns the owner of the `tokenId` token.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
800         return address(uint160(_packedOwnershipOf(tokenId)));
801     }
802 
803     /**
804      * @dev Gas spent here starts off proportional to the maximum mint batch size.
805      * It gradually moves to O(1) as tokens get transferred around over time.
806      */
807     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
808         return _unpackedOwnership(_packedOwnershipOf(tokenId));
809     }
810 
811     /**
812      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
813      */
814     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
815         return _unpackedOwnership(_packedOwnerships[index]);
816     }
817 
818     /**
819      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
820      */
821     function _initializeOwnershipAt(uint256 index) internal virtual {
822         if (_packedOwnerships[index] == 0) {
823             _packedOwnerships[index] = _packedOwnershipOf(index);
824         }
825     }
826 
827     /**
828      * Returns the packed ownership data of `tokenId`.
829      */
830     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
831         uint256 curr = tokenId;
832 
833         unchecked {
834             if (_startTokenId() <= curr)
835                 if (curr < _currentIndex) {
836                     uint256 packed = _packedOwnerships[curr];
837                     // If not burned.
838                     if (packed & _BITMASK_BURNED == 0) {
839                         // Invariant:
840                         // There will always be an initialized ownership slot
841                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
842                         // before an unintialized ownership slot
843                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
844                         // Hence, `curr` will not underflow.
845                         //
846                         // We can directly compare the packed value.
847                         // If the address is zero, packed will be zero.
848                         while (packed == 0) {
849                             packed = _packedOwnerships[--curr];
850                         }
851                         return packed;
852                     }
853                 }
854         }
855         revert OwnerQueryForNonexistentToken();
856     }
857 
858     /**
859      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
860      */
861     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
862         ownership.addr = address(uint160(packed));
863         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
864         ownership.burned = packed & _BITMASK_BURNED != 0;
865         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
866     }
867 
868     /**
869      * @dev Packs ownership data into a single uint256.
870      */
871     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
872         assembly {
873             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
874             owner := and(owner, _BITMASK_ADDRESS)
875             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
876             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
877         }
878     }
879 
880     /**
881      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
882      */
883     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
884         // For branchless setting of the `nextInitialized` flag.
885         assembly {
886             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
887             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
888         }
889     }
890 
891     // =============================================================
892     //                      APPROVAL OPERATIONS
893     // =============================================================
894 
895     /**
896      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
897      * The approval is cleared when the token is transferred.
898      *
899      * Only a single account can be approved at a time, so approving the
900      * zero address clears previous approvals.
901      *
902      * Requirements:
903      *
904      * - The caller must own the token or be an approved operator.
905      * - `tokenId` must exist.
906      *
907      * Emits an {Approval} event.
908      */
909     function approve(address to, uint256 tokenId) public virtual override {
910         address owner = ownerOf(tokenId);
911 
912         if (_msgSenderERC721A() != owner)
913             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
914                 revert ApprovalCallerNotOwnerNorApproved();
915             }
916 
917         _tokenApprovals[tokenId].value = to;
918         emit Approval(owner, to, tokenId);
919     }
920 
921     /**
922      * @dev Returns the account approved for `tokenId` token.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      */
928     function getApproved(uint256 tokenId) public view virtual override returns (address) {
929         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
930 
931         return _tokenApprovals[tokenId].value;
932     }
933 
934     /**
935      * @dev Approve or remove `operator` as an operator for the caller.
936      * Operators can call {transferFrom} or {safeTransferFrom}
937      * for any token owned by the caller.
938      *
939      * Requirements:
940      *
941      * - The `operator` cannot be the caller.
942      *
943      * Emits an {ApprovalForAll} event.
944      */
945     function setApprovalForAll(address operator, bool approved) public virtual override {
946         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
947 
948         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
949         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
950     }
951 
952     /**
953      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
954      *
955      * See {setApprovalForAll}.
956      */
957     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
958         return _operatorApprovals[owner][operator];
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted. See {_mint}.
967      */
968     function _exists(uint256 tokenId) internal view virtual returns (bool) {
969         return
970             _startTokenId() <= tokenId &&
971             tokenId < _currentIndex && // If within bounds,
972             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
973     }
974 
975     /**
976      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
977      */
978     function _isSenderApprovedOrOwner(
979         address approvedAddress,
980         address owner,
981         address msgSender
982     ) private pure returns (bool result) {
983         assembly {
984             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
985             owner := and(owner, _BITMASK_ADDRESS)
986             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
987             msgSender := and(msgSender, _BITMASK_ADDRESS)
988             // `msgSender == owner || msgSender == approvedAddress`.
989             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
990         }
991     }
992 
993     /**
994      * @dev Returns the storage slot and value for the approved address of `tokenId`.
995      */
996     function _getApprovedSlotAndAddress(uint256 tokenId)
997         private
998         view
999         returns (uint256 approvedAddressSlot, address approvedAddress)
1000     {
1001         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1002         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1003         assembly {
1004             approvedAddressSlot := tokenApproval.slot
1005             approvedAddress := sload(approvedAddressSlot)
1006         }
1007     }
1008 
1009     // =============================================================
1010     //                      TRANSFER OPERATIONS
1011     // =============================================================
1012 
1013     /**
1014      * @dev Transfers `tokenId` from `from` to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      * - If the caller is not `from`, it must be approved to move this token
1022      * by either {approve} or {setApprovalForAll}.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1032 
1033         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1034 
1035         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1036 
1037         // The nested ifs save around 20+ gas over a compound boolean condition.
1038         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1039             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1040 
1041         if (to == address(0)) revert TransferToZeroAddress();
1042 
1043         _beforeTokenTransfers(from, to, tokenId, 1);
1044 
1045         // Clear approvals from the previous owner.
1046         assembly {
1047             if approvedAddress {
1048                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1049                 sstore(approvedAddressSlot, 0)
1050             }
1051         }
1052 
1053         // Underflow of the sender's balance is impossible because we check for
1054         // ownership above and the recipient's balance can't realistically overflow.
1055         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1056         unchecked {
1057             // We can directly increment and decrement the balances.
1058             --_packedAddressData[from]; // Updates: `balance -= 1`.
1059             ++_packedAddressData[to]; // Updates: `balance += 1`.
1060 
1061             // Updates:
1062             // - `address` to the next owner.
1063             // - `startTimestamp` to the timestamp of transfering.
1064             // - `burned` to `false`.
1065             // - `nextInitialized` to `true`.
1066             _packedOwnerships[tokenId] = _packOwnershipData(
1067                 to,
1068                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1069             );
1070 
1071             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1072             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1073                 uint256 nextTokenId = tokenId + 1;
1074                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1075                 if (_packedOwnerships[nextTokenId] == 0) {
1076                     // If the next slot is within bounds.
1077                     if (nextTokenId != _currentIndex) {
1078                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1079                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1080                     }
1081                 }
1082             }
1083         }
1084 
1085         emit Transfer(from, to, tokenId);
1086         _afterTokenTransfers(from, to, tokenId, 1);
1087     }
1088 
1089     /**
1090      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         safeTransferFrom(from, to, tokenId, '');
1098     }
1099 
1100     /**
1101      * @dev Safely transfers `tokenId` token from `from` to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - `from` cannot be the zero address.
1106      * - `to` cannot be the zero address.
1107      * - `tokenId` token must exist and be owned by `from`.
1108      * - If the caller is not `from`, it must be approved to move this token
1109      * by either {approve} or {setApprovalForAll}.
1110      * - If `to` refers to a smart contract, it must implement
1111      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) public virtual override {
1121         transferFrom(from, to, tokenId);
1122         if (to.code.length != 0)
1123             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1124                 revert TransferToNonERC721ReceiverImplementer();
1125             }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before a set of serially-ordered token IDs
1130      * are about to be transferred. This includes minting.
1131      * And also called before burning one token.
1132      *
1133      * `startTokenId` - the first token ID to be transferred.
1134      * `quantity` - the amount to be transferred.
1135      *
1136      * Calling conditions:
1137      *
1138      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1139      * transferred to `to`.
1140      * - When `from` is zero, `tokenId` will be minted for `to`.
1141      * - When `to` is zero, `tokenId` will be burned by `from`.
1142      * - `from` and `to` are never both zero.
1143      */
1144     function _beforeTokenTransfers(
1145         address from,
1146         address to,
1147         uint256 startTokenId,
1148         uint256 quantity
1149     ) internal virtual {}
1150 
1151     /**
1152      * @dev Hook that is called after a set of serially-ordered token IDs
1153      * have been transferred. This includes minting.
1154      * And also called after one token has been burned.
1155      *
1156      * `startTokenId` - the first token ID to be transferred.
1157      * `quantity` - the amount to be transferred.
1158      *
1159      * Calling conditions:
1160      *
1161      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1162      * transferred to `to`.
1163      * - When `from` is zero, `tokenId` has been minted for `to`.
1164      * - When `to` is zero, `tokenId` has been burned by `from`.
1165      * - `from` and `to` are never both zero.
1166      */
1167     function _afterTokenTransfers(
1168         address from,
1169         address to,
1170         uint256 startTokenId,
1171         uint256 quantity
1172     ) internal virtual {}
1173 
1174     /**
1175      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1176      *
1177      * `from` - Previous owner of the given token ID.
1178      * `to` - Target address that will receive the token.
1179      * `tokenId` - Token ID to be transferred.
1180      * `_data` - Optional data to send along with the call.
1181      *
1182      * Returns whether the call correctly returned the expected magic value.
1183      */
1184     function _checkContractOnERC721Received(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) private returns (bool) {
1190         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1191             bytes4 retval
1192         ) {
1193             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1194         } catch (bytes memory reason) {
1195             if (reason.length == 0) {
1196                 revert TransferToNonERC721ReceiverImplementer();
1197             } else {
1198                 assembly {
1199                     revert(add(32, reason), mload(reason))
1200                 }
1201             }
1202         }
1203     }
1204 
1205     // =============================================================
1206     //                        MINT OPERATIONS
1207     // =============================================================
1208 
1209     /**
1210      * @dev Mints `quantity` tokens and transfers them to `to`.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * Emits a {Transfer} event for each mint.
1218      */
1219     function _mint(address to, uint256 quantity) internal virtual {
1220         uint256 startTokenId = _currentIndex;
1221         if (quantity == 0) revert MintZeroQuantity();
1222 
1223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1224 
1225         // Overflows are incredibly unrealistic.
1226         // `balance` and `numberMinted` have a maximum limit of 2**64.
1227         // `tokenId` has a maximum limit of 2**256.
1228         unchecked {
1229             // Updates:
1230             // - `balance += quantity`.
1231             // - `numberMinted += quantity`.
1232             //
1233             // We can directly add to the `balance` and `numberMinted`.
1234             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1235 
1236             // Updates:
1237             // - `address` to the owner.
1238             // - `startTimestamp` to the timestamp of minting.
1239             // - `burned` to `false`.
1240             // - `nextInitialized` to `quantity == 1`.
1241             _packedOwnerships[startTokenId] = _packOwnershipData(
1242                 to,
1243                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1244             );
1245 
1246             uint256 toMasked;
1247             uint256 end = startTokenId + quantity;
1248 
1249             // Use assembly to loop and emit the `Transfer` event for gas savings.
1250             assembly {
1251                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1252                 toMasked := and(to, _BITMASK_ADDRESS)
1253                 // Emit the `Transfer` event.
1254                 log4(
1255                     0, // Start of data (0, since no data).
1256                     0, // End of data (0, since no data).
1257                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1258                     0, // `address(0)`.
1259                     toMasked, // `to`.
1260                     startTokenId // `tokenId`.
1261                 )
1262 
1263                 for {
1264                     let tokenId := add(startTokenId, 1)
1265                 } iszero(eq(tokenId, end)) {
1266                     tokenId := add(tokenId, 1)
1267                 } {
1268                     // Emit the `Transfer` event. Similar to above.
1269                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1270                 }
1271             }
1272             if (toMasked == 0) revert MintToZeroAddress();
1273 
1274             _currentIndex = end;
1275         }
1276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277     }
1278 
1279     /**
1280      * @dev Mints `quantity` tokens and transfers them to `to`.
1281      *
1282      * This function is intended for efficient minting only during contract creation.
1283      *
1284      * It emits only one {ConsecutiveTransfer} as defined in
1285      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1286      * instead of a sequence of {Transfer} event(s).
1287      *
1288      * Calling this function outside of contract creation WILL make your contract
1289      * non-compliant with the ERC721 standard.
1290      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1291      * {ConsecutiveTransfer} event is only permissible during contract creation.
1292      *
1293      * Requirements:
1294      *
1295      * - `to` cannot be the zero address.
1296      * - `quantity` must be greater than 0.
1297      *
1298      * Emits a {ConsecutiveTransfer} event.
1299      */
1300     function _mintERC2309(address to, uint256 quantity) internal virtual {
1301         uint256 startTokenId = _currentIndex;
1302         if (to == address(0)) revert MintToZeroAddress();
1303         if (quantity == 0) revert MintZeroQuantity();
1304         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1305 
1306         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1307 
1308         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1309         unchecked {
1310             // Updates:
1311             // - `balance += quantity`.
1312             // - `numberMinted += quantity`.
1313             //
1314             // We can directly add to the `balance` and `numberMinted`.
1315             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1316 
1317             // Updates:
1318             // - `address` to the owner.
1319             // - `startTimestamp` to the timestamp of minting.
1320             // - `burned` to `false`.
1321             // - `nextInitialized` to `quantity == 1`.
1322             _packedOwnerships[startTokenId] = _packOwnershipData(
1323                 to,
1324                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1325             );
1326 
1327             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1328 
1329             _currentIndex = startTokenId + quantity;
1330         }
1331         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1332     }
1333 
1334     /**
1335      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - If `to` refers to a smart contract, it must implement
1340      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1341      * - `quantity` must be greater than 0.
1342      *
1343      * See {_mint}.
1344      *
1345      * Emits a {Transfer} event for each mint.
1346      */
1347     function _safeMint(
1348         address to,
1349         uint256 quantity,
1350         bytes memory _data
1351     ) internal virtual {
1352         _mint(to, quantity);
1353 
1354         unchecked {
1355             if (to.code.length != 0) {
1356                 uint256 end = _currentIndex;
1357                 uint256 index = end - quantity;
1358                 do {
1359                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1360                         revert TransferToNonERC721ReceiverImplementer();
1361                     }
1362                 } while (index < end);
1363                 // Reentrancy protection.
1364                 if (_currentIndex != end) revert();
1365             }
1366         }
1367     }
1368 
1369     /**
1370      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1371      */
1372     function _safeMint(address to, uint256 quantity) internal virtual {
1373         _safeMint(to, quantity, '');
1374     }
1375 
1376     // =============================================================
1377     //                        BURN OPERATIONS
1378     // =============================================================
1379 
1380     /**
1381      * @dev Equivalent to `_burn(tokenId, false)`.
1382      */
1383     function _burn(uint256 tokenId) internal virtual {
1384         _burn(tokenId, false);
1385     }
1386 
1387     /**
1388      * @dev Destroys `tokenId`.
1389      * The approval is cleared when the token is burned.
1390      *
1391      * Requirements:
1392      *
1393      * - `tokenId` must exist.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1398         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1399 
1400         address from = address(uint160(prevOwnershipPacked));
1401 
1402         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1403 
1404         if (approvalCheck) {
1405             // The nested ifs save around 20+ gas over a compound boolean condition.
1406             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1407                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1408         }
1409 
1410         _beforeTokenTransfers(from, address(0), tokenId, 1);
1411 
1412         // Clear approvals from the previous owner.
1413         assembly {
1414             if approvedAddress {
1415                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1416                 sstore(approvedAddressSlot, 0)
1417             }
1418         }
1419 
1420         // Underflow of the sender's balance is impossible because we check for
1421         // ownership above and the recipient's balance can't realistically overflow.
1422         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1423         unchecked {
1424             // Updates:
1425             // - `balance -= 1`.
1426             // - `numberBurned += 1`.
1427             //
1428             // We can directly decrement the balance, and increment the number burned.
1429             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1430             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1431 
1432             // Updates:
1433             // - `address` to the last owner.
1434             // - `startTimestamp` to the timestamp of burning.
1435             // - `burned` to `true`.
1436             // - `nextInitialized` to `true`.
1437             _packedOwnerships[tokenId] = _packOwnershipData(
1438                 from,
1439                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1440             );
1441 
1442             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1443             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1444                 uint256 nextTokenId = tokenId + 1;
1445                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1446                 if (_packedOwnerships[nextTokenId] == 0) {
1447                     // If the next slot is within bounds.
1448                     if (nextTokenId != _currentIndex) {
1449                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1450                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1451                     }
1452                 }
1453             }
1454         }
1455 
1456         emit Transfer(from, address(0), tokenId);
1457         _afterTokenTransfers(from, address(0), tokenId, 1);
1458 
1459         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1460         unchecked {
1461             _burnCounter++;
1462         }
1463     }
1464 
1465     // =============================================================
1466     //                     EXTRA DATA OPERATIONS
1467     // =============================================================
1468 
1469     /**
1470      * @dev Directly sets the extra data for the ownership data `index`.
1471      */
1472     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1473         uint256 packed = _packedOwnerships[index];
1474         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1475         uint256 extraDataCasted;
1476         // Cast `extraData` with assembly to avoid redundant masking.
1477         assembly {
1478             extraDataCasted := extraData
1479         }
1480         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1481         _packedOwnerships[index] = packed;
1482     }
1483 
1484     /**
1485      * @dev Called during each token transfer to set the 24bit `extraData` field.
1486      * Intended to be overridden by the cosumer contract.
1487      *
1488      * `previousExtraData` - the value of `extraData` before transfer.
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` will be minted for `to`.
1495      * - When `to` is zero, `tokenId` will be burned by `from`.
1496      * - `from` and `to` are never both zero.
1497      */
1498     function _extraData(
1499         address from,
1500         address to,
1501         uint24 previousExtraData
1502     ) internal view virtual returns (uint24) {}
1503 
1504     /**
1505      * @dev Returns the next extra data for the packed ownership data.
1506      * The returned result is shifted into position.
1507      */
1508     function _nextExtraData(
1509         address from,
1510         address to,
1511         uint256 prevOwnershipPacked
1512     ) private view returns (uint256) {
1513         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1514         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1515     }
1516 
1517     // =============================================================
1518     //                       OTHER OPERATIONS
1519     // =============================================================
1520 
1521     /**
1522      * @dev Returns the message sender (defaults to `msg.sender`).
1523      *
1524      * If you are writing GSN compatible contracts, you need to override this function.
1525      */
1526     function _msgSenderERC721A() internal view virtual returns (address) {
1527         return msg.sender;
1528     }
1529 
1530     /**
1531      * @dev Converts a uint256 to its ASCII string decimal representation.
1532      */
1533     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1534         assembly {
1535             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1536             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1537             // We will need 1 32-byte word to store the length,
1538             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1539             str := add(mload(0x40), 0x80)
1540             // Update the free memory pointer to allocate.
1541             mstore(0x40, str)
1542 
1543             // Cache the end of the memory to calculate the length later.
1544             let end := str
1545 
1546             // We write the string from rightmost digit to leftmost digit.
1547             // The following is essentially a do-while loop that also handles the zero case.
1548             // prettier-ignore
1549             for { let temp := value } 1 {} {
1550                 str := sub(str, 1)
1551                 // Write the character to the pointer.
1552                 // The ASCII index of the '0' character is 48.
1553                 mstore8(str, add(48, mod(temp, 10)))
1554                 // Keep dividing `temp` until zero.
1555                 temp := div(temp, 10)
1556                 // prettier-ignore
1557                 if iszero(temp) { break }
1558             }
1559 
1560             let length := sub(end, str)
1561             // Move the pointer 32 bytes leftwards to make room for the length.
1562             str := sub(str, 0x20)
1563             // Store the length.
1564             mstore(str, length)
1565         }
1566     }
1567 }
1568 
1569 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1570 
1571 
1572 // ERC721A Contracts v4.2.2
1573 // Creator: Chiru Labs
1574 
1575 pragma solidity ^0.8.4;
1576 
1577 
1578 
1579 /**
1580  * @title ERC721AQueryable.
1581  *
1582  * @dev ERC721A subclass with convenience query functions.
1583  */
1584 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1585     /**
1586      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1587      *
1588      * If the `tokenId` is out of bounds:
1589      *
1590      * - `addr = address(0)`
1591      * - `startTimestamp = 0`
1592      * - `burned = false`
1593      * - `extraData = 0`
1594      *
1595      * If the `tokenId` is burned:
1596      *
1597      * - `addr = <Address of owner before token was burned>`
1598      * - `startTimestamp = <Timestamp when token was burned>`
1599      * - `burned = true`
1600      * - `extraData = <Extra data when token was burned>`
1601      *
1602      * Otherwise:
1603      *
1604      * - `addr = <Address of owner>`
1605      * - `startTimestamp = <Timestamp of start of ownership>`
1606      * - `burned = false`
1607      * - `extraData = <Extra data at start of ownership>`
1608      */
1609     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1610         TokenOwnership memory ownership;
1611         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1612             return ownership;
1613         }
1614         ownership = _ownershipAt(tokenId);
1615         if (ownership.burned) {
1616             return ownership;
1617         }
1618         return _ownershipOf(tokenId);
1619     }
1620 
1621     /**
1622      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1623      * See {ERC721AQueryable-explicitOwnershipOf}
1624      */
1625     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1626         external
1627         view
1628         virtual
1629         override
1630         returns (TokenOwnership[] memory)
1631     {
1632         unchecked {
1633             uint256 tokenIdsLength = tokenIds.length;
1634             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1635             for (uint256 i; i != tokenIdsLength; ++i) {
1636                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1637             }
1638             return ownerships;
1639         }
1640     }
1641 
1642     /**
1643      * @dev Returns an array of token IDs owned by `owner`,
1644      * in the range [`start`, `stop`)
1645      * (i.e. `start <= tokenId < stop`).
1646      *
1647      * This function allows for tokens to be queried if the collection
1648      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1649      *
1650      * Requirements:
1651      *
1652      * - `start < stop`
1653      */
1654     function tokensOfOwnerIn(
1655         address owner,
1656         uint256 start,
1657         uint256 stop
1658     ) external view virtual override returns (uint256[] memory) {
1659         unchecked {
1660             if (start >= stop) revert InvalidQueryRange();
1661             uint256 tokenIdsIdx;
1662             uint256 stopLimit = _nextTokenId();
1663             // Set `start = max(start, _startTokenId())`.
1664             if (start < _startTokenId()) {
1665                 start = _startTokenId();
1666             }
1667             // Set `stop = min(stop, stopLimit)`.
1668             if (stop > stopLimit) {
1669                 stop = stopLimit;
1670             }
1671             uint256 tokenIdsMaxLength = balanceOf(owner);
1672             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1673             // to cater for cases where `balanceOf(owner)` is too big.
1674             if (start < stop) {
1675                 uint256 rangeLength = stop - start;
1676                 if (rangeLength < tokenIdsMaxLength) {
1677                     tokenIdsMaxLength = rangeLength;
1678                 }
1679             } else {
1680                 tokenIdsMaxLength = 0;
1681             }
1682             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1683             if (tokenIdsMaxLength == 0) {
1684                 return tokenIds;
1685             }
1686             // We need to call `explicitOwnershipOf(start)`,
1687             // because the slot at `start` may not be initialized.
1688             TokenOwnership memory ownership = explicitOwnershipOf(start);
1689             address currOwnershipAddr;
1690             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1691             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1692             if (!ownership.burned) {
1693                 currOwnershipAddr = ownership.addr;
1694             }
1695             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1696                 ownership = _ownershipAt(i);
1697                 if (ownership.burned) {
1698                     continue;
1699                 }
1700                 if (ownership.addr != address(0)) {
1701                     currOwnershipAddr = ownership.addr;
1702                 }
1703                 if (currOwnershipAddr == owner) {
1704                     tokenIds[tokenIdsIdx++] = i;
1705                 }
1706             }
1707             // Downsize the array to fit.
1708             assembly {
1709                 mstore(tokenIds, tokenIdsIdx)
1710             }
1711             return tokenIds;
1712         }
1713     }
1714 
1715     /**
1716      * @dev Returns an array of token IDs owned by `owner`.
1717      *
1718      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1719      * It is meant to be called off-chain.
1720      *
1721      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1722      * multiple smaller scans if the collection is large enough to cause
1723      * an out-of-gas error (10K collections should be fine).
1724      */
1725     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1726         unchecked {
1727             uint256 tokenIdsIdx;
1728             address currOwnershipAddr;
1729             uint256 tokenIdsLength = balanceOf(owner);
1730             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1731             TokenOwnership memory ownership;
1732             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1733                 ownership = _ownershipAt(i);
1734                 if (ownership.burned) {
1735                     continue;
1736                 }
1737                 if (ownership.addr != address(0)) {
1738                     currOwnershipAddr = ownership.addr;
1739                 }
1740                 if (currOwnershipAddr == owner) {
1741                     tokenIds[tokenIdsIdx++] = i;
1742                 }
1743             }
1744             return tokenIds;
1745         }
1746     }
1747 }
1748 
1749 // File: ValiantDAO.sol
1750 
1751 
1752 pragma solidity ^0.8.0;
1753 
1754 
1755 
1756 
1757 contract ValiantDAO is ERC721A,ERC721AQueryable,Ownable {
1758 
1759     string private baseTokenURI;
1760 
1761     uint256 public maxSupply;
1762     uint256 public price;
1763     uint256 public priceIncreaseValue;
1764     uint256 public priceIncreaseCondition;
1765     uint256 public lastPriceIncreaseSupply;
1766     mapping(address => bool) public whiteList;
1767 
1768     address payable public vault;
1769 
1770     modifier priceIncreaseMod() {
1771         _;
1772         priceIncreaseFun();
1773     }
1774 
1775     constructor(uint256 maxSupply_, uint256 price_, uint256 priceIncreaseValue_, uint256 priceIncreaseCondition_, address payable vault_) ERC721A("ValiantDAO", "ValiantDAO") {
1776         maxSupply = maxSupply_;
1777         price = price_;
1778         priceIncreaseValue = priceIncreaseValue_;
1779         priceIncreaseCondition = priceIncreaseCondition_;
1780         require(vault_ != address(0), "A");
1781         vault = vault_;
1782     }
1783 
1784     /*
1785 
1786      */
1787     function mint(uint256 count_) public payable priceIncreaseMod {
1788         require(count_ > 0, "Amount to mint is 0");
1789         require(totalSupply() + count_ <= maxSupply, "Sold out!");
1790         if(!whiteList[msg.sender]){
1791             require(msg.value >= count_ * price, "Send a enough amount of eth");
1792         }
1793         _safeMint(msg.sender, count_);
1794         uint256 _balance = address(this).balance;
1795         if(_balance > 0){
1796             vault.transfer(address(this).balance);
1797         }
1798     }
1799 
1800 
1801     /*
1802      */
1803     function priceIncreaseFun() public {
1804         uint256 increaseNum = (totalSupply() - lastPriceIncreaseSupply) / priceIncreaseCondition;
1805         if(increaseNum > 0){
1806             price += priceIncreaseValue * increaseNum;
1807             lastPriceIncreaseSupply = totalSupply();
1808         }
1809     }
1810 
1811     /*
1812      */
1813     function budgetPrice(uint256 count_) public view returns (uint256) {
1814         uint256 increaseNum = (totalSupply() + count_ - lastPriceIncreaseSupply) / priceIncreaseCondition;
1815         if(increaseNum > 0){
1816             return priceIncreaseValue * increaseNum + price;
1817         }else{
1818             return price;
1819         }
1820     }
1821 
1822     /*
1823      */
1824     function updateMaxSupply(uint256 maxSupply_) external onlyOwner{
1825         require(maxSupply_ >= totalSupply(), "A");
1826         maxSupply = maxSupply_;
1827     }
1828 
1829     /*
1830      */
1831     function updatePrice(uint256 price_) external onlyOwner{
1832         price = price_;
1833     }
1834 
1835     /*
1836      */
1837     function updatePriceIncreaseValue(uint256 priceIncreaseValue_) external onlyOwner{
1838         priceIncreaseValue = priceIncreaseValue_;
1839     }
1840 
1841     /*
1842      */
1843     function updatePriceIncreaseCondition(uint256 priceIncreaseCondition_) external onlyOwner priceIncreaseMod {
1844         priceIncreaseCondition = priceIncreaseCondition_;
1845     }
1846 
1847     /*
1848      */
1849     function updateVault(address payable vault_) external onlyOwner{
1850         require(vault_ != address(0), "A");
1851         vault = vault_;
1852     }
1853 
1854     /*
1855      */
1856     function batchAddWhiteList(address[] calldata whiteList_) external onlyOwner{
1857         for(uint256 i; i<whiteList_.length; i++){
1858             whiteList[whiteList_[i]] = true;
1859         }
1860     }
1861 
1862     /*
1863      */
1864     function batchRmWhiteList(address[] calldata whiteList_) external onlyOwner{
1865         for(uint256 i; i<whiteList_.length; i++){
1866             delete whiteList[whiteList_[i]];
1867         }
1868     }
1869 
1870     /*
1871      */
1872     function setBaseURI(string calldata baseURI) external onlyOwner {
1873         baseTokenURI = baseURI;
1874     }
1875 
1876     function _baseURI() internal view virtual override returns (string memory) {
1877         return baseTokenURI;
1878     }
1879 
1880 
1881 }