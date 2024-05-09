1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
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
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: erc721a/contracts/IERC721A.sol
115 
116 
117 // ERC721A Contracts v4.2.3
118 // Creator: Chiru Labs
119 
120 pragma solidity ^0.8.4;
121 
122 /**
123  * @dev Interface of ERC721A.
124  */
125 interface IERC721A {
126     /**
127      * The caller must own the token or be an approved operator.
128      */
129     error ApprovalCallerNotOwnerNorApproved();
130 
131     /**
132      * The token does not exist.
133      */
134     error ApprovalQueryForNonexistentToken();
135 
136     /**
137      * Cannot query the balance for the zero address.
138      */
139     error BalanceQueryForZeroAddress();
140 
141     /**
142      * Cannot mint to the zero address.
143      */
144     error MintToZeroAddress();
145 
146     /**
147      * The quantity of tokens minted must be more than zero.
148      */
149     error MintZeroQuantity();
150 
151     /**
152      * The token does not exist.
153      */
154     error OwnerQueryForNonexistentToken();
155 
156     /**
157      * The caller must own the token or be an approved operator.
158      */
159     error TransferCallerNotOwnerNorApproved();
160 
161     /**
162      * The token must be owned by `from`.
163      */
164     error TransferFromIncorrectOwner();
165 
166     /**
167      * Cannot safely transfer to a contract that does not implement the
168      * ERC721Receiver interface.
169      */
170     error TransferToNonERC721ReceiverImplementer();
171 
172     /**
173      * Cannot transfer to the zero address.
174      */
175     error TransferToZeroAddress();
176 
177     /**
178      * The token does not exist.
179      */
180     error URIQueryForNonexistentToken();
181 
182     /**
183      * The `quantity` minted with ERC2309 exceeds the safety limit.
184      */
185     error MintERC2309QuantityExceedsLimit();
186 
187     /**
188      * The `extraData` cannot be set on an unintialized ownership slot.
189      */
190     error OwnershipNotInitializedForExtraData();
191 
192     // =============================================================
193     //                            STRUCTS
194     // =============================================================
195 
196     struct TokenOwnership {
197         // The address of the owner.
198         address addr;
199         // Stores the start time of ownership with minimal overhead for tokenomics.
200         uint64 startTimestamp;
201         // Whether the token has been burned.
202         bool burned;
203         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
204         uint24 extraData;
205     }
206 
207     // =============================================================
208     //                         TOKEN COUNTERS
209     // =============================================================
210 
211     /**
212      * @dev Returns the total number of tokens in existence.
213      * Burned tokens will reduce the count.
214      * To get the total number of tokens minted, please see {_totalMinted}.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     // =============================================================
219     //                            IERC165
220     // =============================================================
221 
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 
232     // =============================================================
233     //                            IERC721
234     // =============================================================
235 
236     /**
237      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
238      */
239     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
243      */
244     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables or disables
248      * (`approved`) `operator` to manage all of its assets.
249      */
250     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
251 
252     /**
253      * @dev Returns the number of tokens in `owner`'s account.
254      */
255     function balanceOf(address owner) external view returns (uint256 balance);
256 
257     /**
258      * @dev Returns the owner of the `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function ownerOf(uint256 tokenId) external view returns (address owner);
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`,
268      * checking first that contract recipients are aware of the ERC721 protocol
269      * to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move
277      * this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement
279      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
280      *
281      * Emits a {Transfer} event.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 tokenId,
287         bytes calldata data
288     ) external payable;
289 
290     /**
291      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external payable;
298 
299     /**
300      * @dev Transfers `tokenId` from `from` to `to`.
301      *
302      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
303      * whenever possible.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must be owned by `from`.
310      * - If the caller is not `from`, it must be approved to move this token
311      * by either {approve} or {setApprovalForAll}.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external payable;
320 
321     /**
322      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
323      * The approval is cleared when the token is transferred.
324      *
325      * Only a single account can be approved at a time, so approving the
326      * zero address clears previous approvals.
327      *
328      * Requirements:
329      *
330      * - The caller must own the token or be an approved operator.
331      * - `tokenId` must exist.
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address to, uint256 tokenId) external payable;
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom}
340      * for any token owned by the caller.
341      *
342      * Requirements:
343      *
344      * - The `operator` cannot be the caller.
345      *
346      * Emits an {ApprovalForAll} event.
347      */
348     function setApprovalForAll(address operator, bool _approved) external;
349 
350     /**
351      * @dev Returns the account approved for `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function getApproved(uint256 tokenId) external view returns (address operator);
358 
359     /**
360      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
361      *
362      * See {setApprovalForAll}.
363      */
364     function isApprovedForAll(address owner, address operator) external view returns (bool);
365 
366     // =============================================================
367     //                        IERC721Metadata
368     // =============================================================
369 
370     /**
371      * @dev Returns the token collection name.
372      */
373     function name() external view returns (string memory);
374 
375     /**
376      * @dev Returns the token collection symbol.
377      */
378     function symbol() external view returns (string memory);
379 
380     /**
381      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
382      */
383     function tokenURI(uint256 tokenId) external view returns (string memory);
384 
385     // =============================================================
386     //                           IERC2309
387     // =============================================================
388 
389     /**
390      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
391      * (inclusive) is transferred from `from` to `to`, as defined in the
392      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
393      *
394      * See {_mintERC2309} for more details.
395      */
396     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
397 }
398 
399 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
400 
401 
402 // ERC721A Contracts v4.2.3
403 // Creator: Chiru Labs
404 
405 pragma solidity ^0.8.4;
406 
407 
408 /**
409  * @dev Interface of ERC721AQueryable.
410  */
411 interface IERC721AQueryable is IERC721A {
412     /**
413      * Invalid query range (`start` >= `stop`).
414      */
415     error InvalidQueryRange();
416 
417     /**
418      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
419      *
420      * If the `tokenId` is out of bounds:
421      *
422      * - `addr = address(0)`
423      * - `startTimestamp = 0`
424      * - `burned = false`
425      * - `extraData = 0`
426      *
427      * If the `tokenId` is burned:
428      *
429      * - `addr = <Address of owner before token was burned>`
430      * - `startTimestamp = <Timestamp when token was burned>`
431      * - `burned = true`
432      * - `extraData = <Extra data when token was burned>`
433      *
434      * Otherwise:
435      *
436      * - `addr = <Address of owner>`
437      * - `startTimestamp = <Timestamp of start of ownership>`
438      * - `burned = false`
439      * - `extraData = <Extra data at start of ownership>`
440      */
441     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
442 
443     /**
444      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
445      * See {ERC721AQueryable-explicitOwnershipOf}
446      */
447     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
448 
449     /**
450      * @dev Returns an array of token IDs owned by `owner`,
451      * in the range [`start`, `stop`)
452      * (i.e. `start <= tokenId < stop`).
453      *
454      * This function allows for tokens to be queried if the collection
455      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
456      *
457      * Requirements:
458      *
459      * - `start < stop`
460      */
461     function tokensOfOwnerIn(
462         address owner,
463         uint256 start,
464         uint256 stop
465     ) external view returns (uint256[] memory);
466 
467     /**
468      * @dev Returns an array of token IDs owned by `owner`.
469      *
470      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
471      * It is meant to be called off-chain.
472      *
473      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
474      * multiple smaller scans if the collection is large enough to cause
475      * an out-of-gas error (10K collections should be fine).
476      */
477     function tokensOfOwner(address owner) external view returns (uint256[] memory);
478 }
479 
480 // File: erc721a/contracts/ERC721A.sol
481 
482 
483 // ERC721A Contracts v4.2.3
484 // Creator: Chiru Labs
485 
486 pragma solidity ^0.8.4;
487 
488 
489 /**
490  * @dev Interface of ERC721 token receiver.
491  */
492 interface ERC721A__IERC721Receiver {
493     function onERC721Received(
494         address operator,
495         address from,
496         uint256 tokenId,
497         bytes calldata data
498     ) external returns (bytes4);
499 }
500 
501 /**
502  * @title ERC721A
503  *
504  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
505  * Non-Fungible Token Standard, including the Metadata extension.
506  * Optimized for lower gas during batch mints.
507  *
508  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
509  * starting from `_startTokenId()`.
510  *
511  * Assumptions:
512  *
513  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
514  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
515  */
516 contract ERC721A is IERC721A {
517     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
518     struct TokenApprovalRef {
519         address value;
520     }
521 
522     // =============================================================
523     //                           CONSTANTS
524     // =============================================================
525 
526     // Mask of an entry in packed address data.
527     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
528 
529     // The bit position of `numberMinted` in packed address data.
530     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
531 
532     // The bit position of `numberBurned` in packed address data.
533     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
534 
535     // The bit position of `aux` in packed address data.
536     uint256 private constant _BITPOS_AUX = 192;
537 
538     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
539     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
540 
541     // The bit position of `startTimestamp` in packed ownership.
542     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
543 
544     // The bit mask of the `burned` bit in packed ownership.
545     uint256 private constant _BITMASK_BURNED = 1 << 224;
546 
547     // The bit position of the `nextInitialized` bit in packed ownership.
548     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
549 
550     // The bit mask of the `nextInitialized` bit in packed ownership.
551     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
552 
553     // The bit position of `extraData` in packed ownership.
554     uint256 private constant _BITPOS_EXTRA_DATA = 232;
555 
556     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
557     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
558 
559     // The mask of the lower 160 bits for addresses.
560     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
561 
562     // The maximum `quantity` that can be minted with {_mintERC2309}.
563     // This limit is to prevent overflows on the address data entries.
564     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
565     // is required to cause an overflow, which is unrealistic.
566     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
567 
568     // The `Transfer` event signature is given by:
569     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
570     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
571         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
572 
573     // =============================================================
574     //                            STORAGE
575     // =============================================================
576 
577     // The next token ID to be minted.
578     uint256 private _currentIndex;
579 
580     // The number of tokens burned.
581     uint256 private _burnCounter;
582 
583     // Token name
584     string private _name;
585 
586     // Token symbol
587     string private _symbol;
588 
589     // Mapping from token ID to ownership details
590     // An empty struct value does not necessarily mean the token is unowned.
591     // See {_packedOwnershipOf} implementation for details.
592     //
593     // Bits Layout:
594     // - [0..159]   `addr`
595     // - [160..223] `startTimestamp`
596     // - [224]      `burned`
597     // - [225]      `nextInitialized`
598     // - [232..255] `extraData`
599     mapping(uint256 => uint256) private _packedOwnerships;
600 
601     // Mapping owner address to address data.
602     //
603     // Bits Layout:
604     // - [0..63]    `balance`
605     // - [64..127]  `numberMinted`
606     // - [128..191] `numberBurned`
607     // - [192..255] `aux`
608     mapping(address => uint256) private _packedAddressData;
609 
610     // Mapping from token ID to approved address.
611     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
612 
613     // Mapping from owner to operator approvals
614     mapping(address => mapping(address => bool)) private _operatorApprovals;
615 
616     // =============================================================
617     //                          CONSTRUCTOR
618     // =============================================================
619 
620     constructor(string memory name_, string memory symbol_) {
621         _name = name_;
622         _symbol = symbol_;
623         _currentIndex = _startTokenId();
624     }
625 
626     // =============================================================
627     //                   TOKEN COUNTING OPERATIONS
628     // =============================================================
629 
630     /**
631      * @dev Returns the starting token ID.
632      * To change the starting token ID, please override this function.
633      */
634     function _startTokenId() internal view virtual returns (uint256) {
635         return 0;
636     }
637 
638     /**
639      * @dev Returns the next token ID to be minted.
640      */
641     function _nextTokenId() internal view virtual returns (uint256) {
642         return _currentIndex;
643     }
644 
645     /**
646      * @dev Returns the total number of tokens in existence.
647      * Burned tokens will reduce the count.
648      * To get the total number of tokens minted, please see {_totalMinted}.
649      */
650     function totalSupply() public view virtual override returns (uint256) {
651         // Counter underflow is impossible as _burnCounter cannot be incremented
652         // more than `_currentIndex - _startTokenId()` times.
653         unchecked {
654             return _currentIndex - _burnCounter - _startTokenId();
655         }
656     }
657 
658     /**
659      * @dev Returns the total amount of tokens minted in the contract.
660      */
661     function _totalMinted() internal view virtual returns (uint256) {
662         // Counter underflow is impossible as `_currentIndex` does not decrement,
663         // and it is initialized to `_startTokenId()`.
664         unchecked {
665             return _currentIndex - _startTokenId();
666         }
667     }
668 
669     /**
670      * @dev Returns the total number of tokens burned.
671      */
672     function _totalBurned() internal view virtual returns (uint256) {
673         return _burnCounter;
674     }
675 
676     // =============================================================
677     //                    ADDRESS DATA OPERATIONS
678     // =============================================================
679 
680     /**
681      * @dev Returns the number of tokens in `owner`'s account.
682      */
683     function balanceOf(address owner) public view virtual override returns (uint256) {
684         if (owner == address(0)) revert BalanceQueryForZeroAddress();
685         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
686     }
687 
688     /**
689      * Returns the number of tokens minted by `owner`.
690      */
691     function _numberMinted(address owner) internal view returns (uint256) {
692         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
693     }
694 
695     /**
696      * Returns the number of tokens burned by or on behalf of `owner`.
697      */
698     function _numberBurned(address owner) internal view returns (uint256) {
699         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
700     }
701 
702     /**
703      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
704      */
705     function _getAux(address owner) internal view returns (uint64) {
706         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
707     }
708 
709     /**
710      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
711      * If there are multiple variables, please pack them into a uint64.
712      */
713     function _setAux(address owner, uint64 aux) internal virtual {
714         uint256 packed = _packedAddressData[owner];
715         uint256 auxCasted;
716         // Cast `aux` with assembly to avoid redundant masking.
717         assembly {
718             auxCasted := aux
719         }
720         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
721         _packedAddressData[owner] = packed;
722     }
723 
724     // =============================================================
725     //                            IERC165
726     // =============================================================
727 
728     /**
729      * @dev Returns true if this contract implements the interface defined by
730      * `interfaceId`. See the corresponding
731      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
732      * to learn more about how these ids are created.
733      *
734      * This function call must use less than 30000 gas.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
737         // The interface IDs are constants representing the first 4 bytes
738         // of the XOR of all function selectors in the interface.
739         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
740         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
741         return
742             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
743             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
744             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
745     }
746 
747     // =============================================================
748     //                        IERC721Metadata
749     // =============================================================
750 
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() public view virtual override returns (string memory) {
755         return _name;
756     }
757 
758     /**
759      * @dev Returns the token collection symbol.
760      */
761     function symbol() public view virtual override returns (string memory) {
762         return _symbol;
763     }
764 
765     /**
766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
767      */
768     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
769         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
770 
771         string memory baseURI = _baseURI();
772         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
773     }
774 
775     /**
776      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
777      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
778      * by default, it can be overridden in child contracts.
779      */
780     function _baseURI() internal view virtual returns (string memory) {
781         return '';
782     }
783 
784     // =============================================================
785     //                     OWNERSHIPS OPERATIONS
786     // =============================================================
787 
788     /**
789      * @dev Returns the owner of the `tokenId` token.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must exist.
794      */
795     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
796         return address(uint160(_packedOwnershipOf(tokenId)));
797     }
798 
799     /**
800      * @dev Gas spent here starts off proportional to the maximum mint batch size.
801      * It gradually moves to O(1) as tokens get transferred around over time.
802      */
803     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
804         return _unpackedOwnership(_packedOwnershipOf(tokenId));
805     }
806 
807     /**
808      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
809      */
810     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
811         return _unpackedOwnership(_packedOwnerships[index]);
812     }
813 
814     /**
815      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
816      */
817     function _initializeOwnershipAt(uint256 index) internal virtual {
818         if (_packedOwnerships[index] == 0) {
819             _packedOwnerships[index] = _packedOwnershipOf(index);
820         }
821     }
822 
823     /**
824      * Returns the packed ownership data of `tokenId`.
825      */
826     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
827         uint256 curr = tokenId;
828 
829         unchecked {
830             if (_startTokenId() <= curr)
831                 if (curr < _currentIndex) {
832                     uint256 packed = _packedOwnerships[curr];
833                     // If not burned.
834                     if (packed & _BITMASK_BURNED == 0) {
835                         // Invariant:
836                         // There will always be an initialized ownership slot
837                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
838                         // before an unintialized ownership slot
839                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
840                         // Hence, `curr` will not underflow.
841                         //
842                         // We can directly compare the packed value.
843                         // If the address is zero, packed will be zero.
844                         while (packed == 0) {
845                             packed = _packedOwnerships[--curr];
846                         }
847                         return packed;
848                     }
849                 }
850         }
851         revert OwnerQueryForNonexistentToken();
852     }
853 
854     /**
855      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
856      */
857     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
858         ownership.addr = address(uint160(packed));
859         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
860         ownership.burned = packed & _BITMASK_BURNED != 0;
861         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
862     }
863 
864     /**
865      * @dev Packs ownership data into a single uint256.
866      */
867     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
868         assembly {
869             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
870             owner := and(owner, _BITMASK_ADDRESS)
871             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
872             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
873         }
874     }
875 
876     /**
877      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
878      */
879     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
880         // For branchless setting of the `nextInitialized` flag.
881         assembly {
882             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
883             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
884         }
885     }
886 
887     // =============================================================
888     //                      APPROVAL OPERATIONS
889     // =============================================================
890 
891     /**
892      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
893      * The approval is cleared when the token is transferred.
894      *
895      * Only a single account can be approved at a time, so approving the
896      * zero address clears previous approvals.
897      *
898      * Requirements:
899      *
900      * - The caller must own the token or be an approved operator.
901      * - `tokenId` must exist.
902      *
903      * Emits an {Approval} event.
904      */
905     function approve(address to, uint256 tokenId) public payable virtual override {
906         address owner = ownerOf(tokenId);
907 
908         if (_msgSenderERC721A() != owner)
909             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
910                 revert ApprovalCallerNotOwnerNorApproved();
911             }
912 
913         _tokenApprovals[tokenId].value = to;
914         emit Approval(owner, to, tokenId);
915     }
916 
917     /**
918      * @dev Returns the account approved for `tokenId` token.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must exist.
923      */
924     function getApproved(uint256 tokenId) public view virtual override returns (address) {
925         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
926 
927         return _tokenApprovals[tokenId].value;
928     }
929 
930     /**
931      * @dev Approve or remove `operator` as an operator for the caller.
932      * Operators can call {transferFrom} or {safeTransferFrom}
933      * for any token owned by the caller.
934      *
935      * Requirements:
936      *
937      * - The `operator` cannot be the caller.
938      *
939      * Emits an {ApprovalForAll} event.
940      */
941     function setApprovalForAll(address operator, bool approved) public virtual override {
942         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
943         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
944     }
945 
946     /**
947      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
948      *
949      * See {setApprovalForAll}.
950      */
951     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
952         return _operatorApprovals[owner][operator];
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted. See {_mint}.
961      */
962     function _exists(uint256 tokenId) internal view virtual returns (bool) {
963         return
964             _startTokenId() <= tokenId &&
965             tokenId < _currentIndex && // If within bounds,
966             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
967     }
968 
969     /**
970      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
971      */
972     function _isSenderApprovedOrOwner(
973         address approvedAddress,
974         address owner,
975         address msgSender
976     ) private pure returns (bool result) {
977         assembly {
978             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
979             owner := and(owner, _BITMASK_ADDRESS)
980             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
981             msgSender := and(msgSender, _BITMASK_ADDRESS)
982             // `msgSender == owner || msgSender == approvedAddress`.
983             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
984         }
985     }
986 
987     /**
988      * @dev Returns the storage slot and value for the approved address of `tokenId`.
989      */
990     function _getApprovedSlotAndAddress(uint256 tokenId)
991         private
992         view
993         returns (uint256 approvedAddressSlot, address approvedAddress)
994     {
995         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
996         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
997         assembly {
998             approvedAddressSlot := tokenApproval.slot
999             approvedAddress := sload(approvedAddressSlot)
1000         }
1001     }
1002 
1003     // =============================================================
1004     //                      TRANSFER OPERATIONS
1005     // =============================================================
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must be owned by `from`.
1015      * - If the caller is not `from`, it must be approved to move this token
1016      * by either {approve} or {setApprovalForAll}.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function transferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public payable virtual override {
1025         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1026 
1027         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1028 
1029         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1030 
1031         // The nested ifs save around 20+ gas over a compound boolean condition.
1032         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1033             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1034 
1035         if (to == address(0)) revert TransferToZeroAddress();
1036 
1037         _beforeTokenTransfers(from, to, tokenId, 1);
1038 
1039         // Clear approvals from the previous owner.
1040         assembly {
1041             if approvedAddress {
1042                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1043                 sstore(approvedAddressSlot, 0)
1044             }
1045         }
1046 
1047         // Underflow of the sender's balance is impossible because we check for
1048         // ownership above and the recipient's balance can't realistically overflow.
1049         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1050         unchecked {
1051             // We can directly increment and decrement the balances.
1052             --_packedAddressData[from]; // Updates: `balance -= 1`.
1053             ++_packedAddressData[to]; // Updates: `balance += 1`.
1054 
1055             // Updates:
1056             // - `address` to the next owner.
1057             // - `startTimestamp` to the timestamp of transfering.
1058             // - `burned` to `false`.
1059             // - `nextInitialized` to `true`.
1060             _packedOwnerships[tokenId] = _packOwnershipData(
1061                 to,
1062                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1063             );
1064 
1065             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1066             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1067                 uint256 nextTokenId = tokenId + 1;
1068                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1069                 if (_packedOwnerships[nextTokenId] == 0) {
1070                     // If the next slot is within bounds.
1071                     if (nextTokenId != _currentIndex) {
1072                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1073                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1074                     }
1075                 }
1076             }
1077         }
1078 
1079         emit Transfer(from, to, tokenId);
1080         _afterTokenTransfers(from, to, tokenId, 1);
1081     }
1082 
1083     /**
1084      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public payable virtual override {
1091         safeTransferFrom(from, to, tokenId, '');
1092     }
1093 
1094     /**
1095      * @dev Safely transfers `tokenId` token from `from` to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `from` cannot be the zero address.
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must exist and be owned by `from`.
1102      * - If the caller is not `from`, it must be approved to move this token
1103      * by either {approve} or {setApprovalForAll}.
1104      * - If `to` refers to a smart contract, it must implement
1105      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) public payable virtual override {
1115         transferFrom(from, to, tokenId);
1116         if (to.code.length != 0)
1117             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1118                 revert TransferToNonERC721ReceiverImplementer();
1119             }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before a set of serially-ordered token IDs
1124      * are about to be transferred. This includes minting.
1125      * And also called before burning one token.
1126      *
1127      * `startTokenId` - the first token ID to be transferred.
1128      * `quantity` - the amount to be transferred.
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      * - When `to` is zero, `tokenId` will be burned by `from`.
1136      * - `from` and `to` are never both zero.
1137      */
1138     function _beforeTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after a set of serially-ordered token IDs
1147      * have been transferred. This includes minting.
1148      * And also called after one token has been burned.
1149      *
1150      * `startTokenId` - the first token ID to be transferred.
1151      * `quantity` - the amount to be transferred.
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` has been minted for `to`.
1158      * - When `to` is zero, `tokenId` has been burned by `from`.
1159      * - `from` and `to` are never both zero.
1160      */
1161     function _afterTokenTransfers(
1162         address from,
1163         address to,
1164         uint256 startTokenId,
1165         uint256 quantity
1166     ) internal virtual {}
1167 
1168     /**
1169      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1170      *
1171      * `from` - Previous owner of the given token ID.
1172      * `to` - Target address that will receive the token.
1173      * `tokenId` - Token ID to be transferred.
1174      * `_data` - Optional data to send along with the call.
1175      *
1176      * Returns whether the call correctly returned the expected magic value.
1177      */
1178     function _checkContractOnERC721Received(
1179         address from,
1180         address to,
1181         uint256 tokenId,
1182         bytes memory _data
1183     ) private returns (bool) {
1184         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1185             bytes4 retval
1186         ) {
1187             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1188         } catch (bytes memory reason) {
1189             if (reason.length == 0) {
1190                 revert TransferToNonERC721ReceiverImplementer();
1191             } else {
1192                 assembly {
1193                     revert(add(32, reason), mload(reason))
1194                 }
1195             }
1196         }
1197     }
1198 
1199     // =============================================================
1200     //                        MINT OPERATIONS
1201     // =============================================================
1202 
1203     /**
1204      * @dev Mints `quantity` tokens and transfers them to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `quantity` must be greater than 0.
1210      *
1211      * Emits a {Transfer} event for each mint.
1212      */
1213     function _mint(address to, uint256 quantity) internal virtual {
1214         uint256 startTokenId = _currentIndex;
1215         if (quantity == 0) revert MintZeroQuantity();
1216 
1217         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1218 
1219         // Overflows are incredibly unrealistic.
1220         // `balance` and `numberMinted` have a maximum limit of 2**64.
1221         // `tokenId` has a maximum limit of 2**256.
1222         unchecked {
1223             // Updates:
1224             // - `balance += quantity`.
1225             // - `numberMinted += quantity`.
1226             //
1227             // We can directly add to the `balance` and `numberMinted`.
1228             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1229 
1230             // Updates:
1231             // - `address` to the owner.
1232             // - `startTimestamp` to the timestamp of minting.
1233             // - `burned` to `false`.
1234             // - `nextInitialized` to `quantity == 1`.
1235             _packedOwnerships[startTokenId] = _packOwnershipData(
1236                 to,
1237                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1238             );
1239 
1240             uint256 toMasked;
1241             uint256 end = startTokenId + quantity;
1242 
1243             // Use assembly to loop and emit the `Transfer` event for gas savings.
1244             // The duplicated `log4` removes an extra check and reduces stack juggling.
1245             // The assembly, together with the surrounding Solidity code, have been
1246             // delicately arranged to nudge the compiler into producing optimized opcodes.
1247             assembly {
1248                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1249                 toMasked := and(to, _BITMASK_ADDRESS)
1250                 // Emit the `Transfer` event.
1251                 log4(
1252                     0, // Start of data (0, since no data).
1253                     0, // End of data (0, since no data).
1254                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1255                     0, // `address(0)`.
1256                     toMasked, // `to`.
1257                     startTokenId // `tokenId`.
1258                 )
1259 
1260                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1261                 // that overflows uint256 will make the loop run out of gas.
1262                 // The compiler will optimize the `iszero` away for performance.
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
1535             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1536             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1537             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1538             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1539             let m := add(mload(0x40), 0xa0)
1540             // Update the free memory pointer to allocate.
1541             mstore(0x40, m)
1542             // Assign the `str` to the end.
1543             str := sub(m, 0x20)
1544             // Zeroize the slot after the string.
1545             mstore(str, 0)
1546 
1547             // Cache the end of the memory to calculate the length later.
1548             let end := str
1549 
1550             // We write the string from rightmost digit to leftmost digit.
1551             // The following is essentially a do-while loop that also handles the zero case.
1552             // prettier-ignore
1553             for { let temp := value } 1 {} {
1554                 str := sub(str, 1)
1555                 // Write the character to the pointer.
1556                 // The ASCII index of the '0' character is 48.
1557                 mstore8(str, add(48, mod(temp, 10)))
1558                 // Keep dividing `temp` until zero.
1559                 temp := div(temp, 10)
1560                 // prettier-ignore
1561                 if iszero(temp) { break }
1562             }
1563 
1564             let length := sub(end, str)
1565             // Move the pointer 32 bytes leftwards to make room for the length.
1566             str := sub(str, 0x20)
1567             // Store the length.
1568             mstore(str, length)
1569         }
1570     }
1571 }
1572 
1573 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1574 
1575 
1576 // ERC721A Contracts v4.2.3
1577 // Creator: Chiru Labs
1578 
1579 pragma solidity ^0.8.4;
1580 
1581 
1582 
1583 /**
1584  * @title ERC721AQueryable.
1585  *
1586  * @dev ERC721A subclass with convenience query functions.
1587  */
1588 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1589     /**
1590      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1591      *
1592      * If the `tokenId` is out of bounds:
1593      *
1594      * - `addr = address(0)`
1595      * - `startTimestamp = 0`
1596      * - `burned = false`
1597      * - `extraData = 0`
1598      *
1599      * If the `tokenId` is burned:
1600      *
1601      * - `addr = <Address of owner before token was burned>`
1602      * - `startTimestamp = <Timestamp when token was burned>`
1603      * - `burned = true`
1604      * - `extraData = <Extra data when token was burned>`
1605      *
1606      * Otherwise:
1607      *
1608      * - `addr = <Address of owner>`
1609      * - `startTimestamp = <Timestamp of start of ownership>`
1610      * - `burned = false`
1611      * - `extraData = <Extra data at start of ownership>`
1612      */
1613     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1614         TokenOwnership memory ownership;
1615         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1616             return ownership;
1617         }
1618         ownership = _ownershipAt(tokenId);
1619         if (ownership.burned) {
1620             return ownership;
1621         }
1622         return _ownershipOf(tokenId);
1623     }
1624 
1625     /**
1626      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1627      * See {ERC721AQueryable-explicitOwnershipOf}
1628      */
1629     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1630         external
1631         view
1632         virtual
1633         override
1634         returns (TokenOwnership[] memory)
1635     {
1636         unchecked {
1637             uint256 tokenIdsLength = tokenIds.length;
1638             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1639             for (uint256 i; i != tokenIdsLength; ++i) {
1640                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1641             }
1642             return ownerships;
1643         }
1644     }
1645 
1646     /**
1647      * @dev Returns an array of token IDs owned by `owner`,
1648      * in the range [`start`, `stop`)
1649      * (i.e. `start <= tokenId < stop`).
1650      *
1651      * This function allows for tokens to be queried if the collection
1652      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1653      *
1654      * Requirements:
1655      *
1656      * - `start < stop`
1657      */
1658     function tokensOfOwnerIn(
1659         address owner,
1660         uint256 start,
1661         uint256 stop
1662     ) external view virtual override returns (uint256[] memory) {
1663         unchecked {
1664             if (start >= stop) revert InvalidQueryRange();
1665             uint256 tokenIdsIdx;
1666             uint256 stopLimit = _nextTokenId();
1667             // Set `start = max(start, _startTokenId())`.
1668             if (start < _startTokenId()) {
1669                 start = _startTokenId();
1670             }
1671             // Set `stop = min(stop, stopLimit)`.
1672             if (stop > stopLimit) {
1673                 stop = stopLimit;
1674             }
1675             uint256 tokenIdsMaxLength = balanceOf(owner);
1676             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1677             // to cater for cases where `balanceOf(owner)` is too big.
1678             if (start < stop) {
1679                 uint256 rangeLength = stop - start;
1680                 if (rangeLength < tokenIdsMaxLength) {
1681                     tokenIdsMaxLength = rangeLength;
1682                 }
1683             } else {
1684                 tokenIdsMaxLength = 0;
1685             }
1686             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1687             if (tokenIdsMaxLength == 0) {
1688                 return tokenIds;
1689             }
1690             // We need to call `explicitOwnershipOf(start)`,
1691             // because the slot at `start` may not be initialized.
1692             TokenOwnership memory ownership = explicitOwnershipOf(start);
1693             address currOwnershipAddr;
1694             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1695             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1696             if (!ownership.burned) {
1697                 currOwnershipAddr = ownership.addr;
1698             }
1699             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1700                 ownership = _ownershipAt(i);
1701                 if (ownership.burned) {
1702                     continue;
1703                 }
1704                 if (ownership.addr != address(0)) {
1705                     currOwnershipAddr = ownership.addr;
1706                 }
1707                 if (currOwnershipAddr == owner) {
1708                     tokenIds[tokenIdsIdx++] = i;
1709                 }
1710             }
1711             // Downsize the array to fit.
1712             assembly {
1713                 mstore(tokenIds, tokenIdsIdx)
1714             }
1715             return tokenIds;
1716         }
1717     }
1718 
1719     /**
1720      * @dev Returns an array of token IDs owned by `owner`.
1721      *
1722      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1723      * It is meant to be called off-chain.
1724      *
1725      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1726      * multiple smaller scans if the collection is large enough to cause
1727      * an out-of-gas error (10K collections should be fine).
1728      */
1729     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1730         unchecked {
1731             uint256 tokenIdsIdx;
1732             address currOwnershipAddr;
1733             uint256 tokenIdsLength = balanceOf(owner);
1734             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1735             TokenOwnership memory ownership;
1736             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1737                 ownership = _ownershipAt(i);
1738                 if (ownership.burned) {
1739                     continue;
1740                 }
1741                 if (ownership.addr != address(0)) {
1742                     currOwnershipAddr = ownership.addr;
1743                 }
1744                 if (currOwnershipAddr == owner) {
1745                     tokenIds[tokenIdsIdx++] = i;
1746                 }
1747             }
1748             return tokenIds;
1749         }
1750     }
1751 }
1752 
1753 // File: contracts/lib/ERC721AOwnable.sol
1754 
1755 
1756 pragma solidity ^0.8.13;
1757 
1758 
1759 
1760 
1761 contract ERC721AOwnable is Ownable, ERC721A, ERC721AQueryable {
1762     uint256 public maxSupply;
1763     uint256 public maxClaimable;
1764     string public baseURI;
1765 
1766     constructor(
1767         string memory name_,
1768         string memory symbol_,
1769         uint256 _maxSupply
1770     ) ERC721A(name_, symbol_) {
1771         maxSupply = _maxSupply;
1772         maxClaimable = 10;
1773     }
1774 
1775     function setMaxClaimable(uint256 _maxClaimable) external onlyOwner {
1776         maxClaimable = _maxClaimable;
1777     }
1778 
1779     function setBaseURI(string calldata _newBaseURI) external onlyOwner {
1780         baseURI = _newBaseURI;
1781     }
1782 
1783     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
1784         return 1;
1785     }
1786 
1787     function _baseURI()
1788         internal
1789         view
1790         override(ERC721A)
1791         returns (string memory)
1792     {
1793         return baseURI;
1794     }
1795 
1796     /**
1797      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1798      */
1799     function tokenURI(uint256 tokenId)
1800         public
1801         view
1802         virtual
1803         override(ERC721A, IERC721A)
1804         returns (string memory)
1805     {
1806         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1807 
1808         string memory baseURI_ = _baseURI();
1809         return
1810             bytes(baseURI_).length != 0
1811                 ? string(
1812                     abi.encodePacked(baseURI_, _toString(tokenId), ".json")
1813                 )
1814                 : "";
1815     }
1816 }
1817 
1818 // File: contracts/MetaDAO.sol
1819 
1820 
1821 pragma solidity ^0.8.13;
1822 
1823 
1824 contract MetaDAO is ERC721AOwnable {
1825     mapping(address => bool) public whitelist;
1826 
1827     error ZeroAddress();
1828     error NotInWhitelist();
1829     error MaxSupplyReached();
1830     error MaxClaimableReached();
1831 
1832     event WhitelistGranted(address[] users, bool granted);
1833 
1834     constructor() ERC721AOwnable("DMetaDao", "DMD", 9999) {}
1835 
1836     function claim(uint64 _quantity) external {
1837         address user = msg.sender;
1838 
1839         if (!whitelist[user]) {
1840             revert NotInWhitelist();
1841         }
1842 
1843         uint256 numberMinted = _numberMinted(user);
1844 
1845         if (numberMinted >= maxClaimable) {
1846             revert MaxClaimableReached();
1847         }
1848 
1849         uint256 claimable = maxClaimable - numberMinted;
1850         if (_quantity < claimable) {
1851             claimable = _quantity;
1852         }
1853 
1854         if (_totalMinted() + claimable > maxSupply) {
1855             revert MaxSupplyReached();
1856         }
1857 
1858         _safeMint(user, claimable, "");
1859     }
1860 
1861     function grantWhitelist(address[] calldata _users, bool _granted)
1862         external
1863         onlyOwner
1864     {
1865         for (uint64 idx = 0; idx < _users.length; idx++) {
1866             if (_users[idx] == address(0)) {
1867                 revert ZeroAddress();
1868             }
1869             whitelist[_users[idx]] = _granted;
1870         }
1871 
1872         emit WhitelistGranted(_users, _granted);
1873     }
1874 
1875     // Just in case
1876     function withdraw() external onlyOwner {
1877         (payable(owner())).transfer(address(this).balance);
1878     }
1879 }